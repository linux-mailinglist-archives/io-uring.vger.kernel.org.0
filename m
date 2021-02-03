Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD86330DD6D
	for <lists+io-uring@lfdr.de>; Wed,  3 Feb 2021 16:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhBCPBf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Feb 2021 10:01:35 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:41652 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233487AbhBCPBd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Feb 2021 10:01:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UNmPdAz_1612364276;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UNmPdAz_1612364276)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Feb 2021 22:58:04 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/2] io_uring: add uring_lock as an argument to io_sqe_files_unregister()
Date:   Wed,  3 Feb 2021 22:57:55 +0800
Message-Id: <1612364276-26847-2-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1612364276-26847-1-git-send-email-haoxu@linux.alibaba.com>
References: <1612364276-26847-1-git-send-email-haoxu@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_sqe_files_unregister is currently called from several places:
    - syscall io_uring_register (with uring_lock)
    - io_ring_ctx_wait_and_kill() (without uring_lock)

There is a AA type deadlock in io_sqe_files_unregister(), thus we need
to know if we hold uring_lock in io_sqe_files_unregister() to fix the
issue.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 38c6cbe1ab38..efb6d02fea6f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7339,7 +7339,7 @@ static void io_sqe_files_set_node(struct fixed_file_data *file_data,
 	percpu_ref_get(&file_data->refs);
 }
 
-static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
+static int io_sqe_files_unregister(struct io_ring_ctx *ctx, bool locked)
 {
 	struct fixed_file_data *data = ctx->file_data;
 	struct fixed_file_ref_node *backup_node, *ref_node = NULL;
@@ -7872,13 +7872,13 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	ret = io_sqe_files_scm(ctx);
 	if (ret) {
-		io_sqe_files_unregister(ctx);
+		io_sqe_files_unregister(ctx, true);
 		return ret;
 	}
 
 	ref_node = alloc_fixed_file_ref_node(ctx);
 	if (!ref_node) {
-		io_sqe_files_unregister(ctx);
+		io_sqe_files_unregister(ctx, true);
 		return -ENOMEM;
 	}
 
@@ -8682,7 +8682,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		css_put(ctx->sqo_blkcg_css);
 #endif
 
-	io_sqe_files_unregister(ctx);
+	io_sqe_files_unregister(ctx, false);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
 	idr_destroy(&ctx->personality_idr);
@@ -10065,7 +10065,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = -EINVAL;
 		if (arg || nr_args)
 			break;
-		ret = io_sqe_files_unregister(ctx);
+		ret = io_sqe_files_unregister(ctx, true);
 		break;
 	case IORING_REGISTER_FILES_UPDATE:
 		ret = io_sqe_files_update(ctx, arg, nr_args);
-- 
1.8.3.1

