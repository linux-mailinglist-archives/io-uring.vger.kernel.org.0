Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3422D53662B
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 18:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbiE0Qxn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 12:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233988AbiE0Qxl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 12:53:41 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAF8ED70C
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 09:53:37 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VEY.2mw_1653670414;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VEY.2mw_1653670414)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 28 May 2022 00:53:34 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring: fix file leaks around io_fixed_fd_install()
Date:   Sat, 28 May 2022 00:53:32 +0800
Message-Id: <20220527165333.55212-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.14.4.44.g2045bb6
In-Reply-To: <20220527165333.55212-1-xiaoguang.wang@linux.alibaba.com>
References: <20220527165333.55212-1-xiaoguang.wang@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_fixed_fd_install() may fail for many reasons, such as short of
free fixed file bitmap, memory allocation failures, etc. When these
errors happen, current code forgets to fput(file) correspondingly.

This patch will fix resource leaks around io_fixed_fd_install(),
meanwhile io_fixed_fd_install() and io_install_fixed_file() are
basically similar, fold them into one function.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 77 ++++++++++++++++++++++++++---------------------------------
 1 file changed, 34 insertions(+), 43 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d50bbf8de4fb..ff50e5f1753d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1364,8 +1364,8 @@ static void io_req_task_queue(struct io_kiocb *req);
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 static int io_req_prep_async(struct io_kiocb *req);
 
-static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
-				 unsigned int issue_flags, u32 slot_index);
+static int io_install_fixed_file(struct io_kiocb *req, unsigned int issue_flags,
+				 struct file *file, u32 slot);
 static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
 
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
@@ -5438,36 +5438,6 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
 	return -ENFILE;
 }
 
-static int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
-			       struct file *file, unsigned int file_slot)
-{
-	bool alloc_slot = file_slot == IORING_FILE_INDEX_ALLOC;
-	struct io_ring_ctx *ctx = req->ctx;
-	int ret;
-
-	if (alloc_slot) {
-		io_ring_submit_lock(ctx, issue_flags);
-		ret = io_file_bitmap_get(ctx);
-		if (unlikely(ret < 0)) {
-			io_ring_submit_unlock(ctx, issue_flags);
-			return ret;
-		}
-
-		file_slot = ret;
-	} else {
-		file_slot--;
-	}
-
-	ret = io_install_fixed_file(req, file, issue_flags, file_slot);
-	if (alloc_slot) {
-		io_ring_submit_unlock(ctx, issue_flags);
-		if (!ret)
-			return file_slot;
-	}
-
-	return ret;
-}
-
 static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct open_flags op;
@@ -5520,11 +5490,14 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 		file->f_flags &= ~O_NONBLOCK;
 	fsnotify_open(file);
 
-	if (!fixed)
+	if (!fixed) {
 		fd_install(ret, file);
-	else
-		ret = io_fixed_fd_install(req, issue_flags, file,
-						req->open.file_slot);
+	} else {
+		ret = io_install_fixed_file(req, issue_flags, file,
+					    req->open.file_slot);
+		if (ret < 0)
+			fput(file);
+	}
 err:
 	putname(req->open.filename);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
@@ -6603,8 +6576,10 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		fd_install(fd, file);
 		ret = fd;
 	} else {
-		ret = io_fixed_fd_install(req, issue_flags, file,
-						accept->file_slot);
+		ret = io_install_fixed_file(req, issue_flags, file,
+					    accept->file_slot);
+		if (ret < 0)
+			fput(file);
 	}
 
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
@@ -6676,8 +6651,10 @@ static int io_socket(struct io_kiocb *req, unsigned int issue_flags)
 		fd_install(fd, file);
 		ret = fd;
 	} else {
-		ret = io_fixed_fd_install(req, issue_flags, file,
+		ret = io_install_fixed_file(req, issue_flags, file,
 					    sock->file_slot);
+		if (ret < 0)
+			fput(file);
 	}
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
@@ -10130,15 +10107,27 @@ static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 	return 0;
 }
 
-static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
-				 unsigned int issue_flags, u32 slot_index)
+static int io_install_fixed_file(struct io_kiocb *req, unsigned int issue_flags,
+				 struct file *file, u32 slot)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	bool needs_switch = false;
 	struct io_fixed_file *file_slot;
 	int ret = -EBADF;
+	bool alloc_slot = slot == IORING_FILE_INDEX_ALLOC;
+	int slot_index;
 
 	io_ring_submit_lock(ctx, issue_flags);
+	if (alloc_slot) {
+		slot_index = io_file_bitmap_get(ctx);
+		if (unlikely(slot_index < 0)) {
+			io_ring_submit_unlock(ctx, issue_flags);
+			return slot_index;
+		}
+	} else {
+		slot_index = slot - 1;
+	}
+
 	if (file->f_op == &io_uring_fops)
 		goto err;
 	ret = -ENXIO;
@@ -10178,8 +10167,10 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 	if (needs_switch)
 		io_rsrc_node_switch(ctx, ctx->file_data);
 	io_ring_submit_unlock(ctx, issue_flags);
-	if (ret)
-		fput(file);
+	if (alloc_slot) {
+		if (!ret)
+			return slot_index;
+	}
 	return ret;
 }
 
-- 
2.14.4.44.g2045bb6

