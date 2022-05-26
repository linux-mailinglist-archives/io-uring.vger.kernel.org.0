Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3C0534F5C
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 14:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbiEZMiy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 08:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbiEZMix (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 08:38:53 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D342AC7B
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 05:38:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VESR4l-_1653568728;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VESR4l-_1653568728)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 26 May 2022 20:38:48 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [RFC] io_uring: let IORING_OP_FILES_UPDATE support to choose fixed file slot
Date:   Thu, 26 May 2022 20:38:48 +0800
Message-Id: <20220526123848.18998-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.14.4.44.g2045bb6
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

One big issue with file registration feature is that it needs user
space apps to maintain free slot info about io_uring's fixed file
table, which really is a burden for development. Now since io_uring
starts to choose free file slot for user space apps by using
IORING_FILE_INDEX_ALLOC flag in accept or open operations, but they
need app to uses direct accept or direct open, which as far as I know,
some apps are not prepared to use direct accept or open yet.

To support apps, who still need real fds, use registration feature
easier, let IORING_OP_FILES_UPDATE support to choose fixed file slot,
which will return free file slot in cqe->res.

TODO list:
    Need to prepare liburing corresponding helpers.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c                 | 50 ++++++++++++++++++++++++++++++++++---------
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9f1c682d7caf..d77e6bbec81c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -680,6 +680,7 @@ struct io_rsrc_update {
 	u64				arg;
 	u32				nr_args;
 	u32				offset;
+	u32				flags;
 };
 
 struct io_fadvise {
@@ -7970,14 +7971,23 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+#define IORING_FILES_UPDATE_INDEX_ALLOC 1
+
 static int io_rsrc_update_prep(struct io_kiocb *req,
 				const struct io_uring_sqe *sqe)
 {
+	u32 flags = READ_ONCE(sqe->files_update_flags);
+
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->rw_flags || sqe->splice_fd_in)
+	if (sqe->splice_fd_in)
+		return -EINVAL;
+	if (flags & ~IORING_FILES_UPDATE_INDEX_ALLOC)
+		return -EINVAL;
+	if ((flags & IORING_FILES_UPDATE_INDEX_ALLOC) && READ_ONCE(sqe->len) != 1)
 		return -EINVAL;
 
+	req->rsrc_update.flags = flags;
 	req->rsrc_update.offset = READ_ONCE(sqe->off);
 	req->rsrc_update.nr_args = READ_ONCE(sqe->len);
 	if (!req->rsrc_update.nr_args)
@@ -7990,18 +8000,38 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_rsrc_update2 up;
+	struct file *file;
 	int ret;
 
-	up.offset = req->rsrc_update.offset;
-	up.data = req->rsrc_update.arg;
-	up.nr = 0;
-	up.tags = 0;
-	up.resv = 0;
-	up.resv2 = 0;
+	if (req->rsrc_update.flags & IORING_FILES_UPDATE_INDEX_ALLOC) {
+		int fd;
 
-	io_ring_submit_lock(ctx, issue_flags);
-	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
-					&up, req->rsrc_update.nr_args);
+		if (copy_from_user(&fd, (int *)req->rsrc_update.arg, sizeof(fd))) {
+			ret = -EFAULT;
+			goto out;
+		}
+		file = fget(fd);
+		if (!file) {
+			ret = -EBADF;
+			goto out;
+		}
+		ret = io_fixed_fd_install(req, issue_flags, file,
+					  IORING_FILE_INDEX_ALLOC);
+	} else {
+		up.offset = req->rsrc_update.offset;
+		up.data = req->rsrc_update.arg;
+		up.nr = 0;
+		up.tags = 0;
+		up.resv = 0;
+		up.resv2 = 0;
+
+		io_ring_submit_lock(ctx, issue_flags);
+		ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
+				&up, req->rsrc_update.nr_args);
+		io_ring_submit_unlock(ctx, issue_flags);
+	}
+
+out:
 	io_ring_submit_unlock(ctx, issue_flags);
 
 	if (ret < 0)
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 53e7dae92e42..b4af01d56d7c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -47,6 +47,7 @@ struct io_uring_sqe {
 		__u32		unlink_flags;
 		__u32		hardlink_flags;
 		__u32		xattr_flags;
+		__u32		files_update_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
-- 
2.14.4.44.g2045bb6

