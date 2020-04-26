Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5D51B8DB0
	for <lists+io-uring@lfdr.de>; Sun, 26 Apr 2020 09:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgDZHzI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Apr 2020 03:55:08 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:50328 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726135AbgDZHzI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 26 Apr 2020 03:55:08 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01355;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Twfm1Io_1587887687;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Twfm1Io_1587887687)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 26 Apr 2020 15:54:55 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: fix mismatched finish_wait() calls in io_uring_cancel_files()
Date:   Sun, 26 Apr 2020 15:54:43 +0800
Message-Id: <20200426075443.30215-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The prepare_to_wait() and finish_wait() calls in io_uring_cancel_files()
are mismatched. Currently I don't see any issues related this bug, just
find it by learning codes.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c687f57fb651..2d7a8d05ab10 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7356,11 +7356,9 @@ static int io_uring_release(struct inode *inode, struct file *file)
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
-	struct io_kiocb *req;
-	DEFINE_WAIT(wait);
-
 	while (!list_empty_careful(&ctx->inflight_list)) {
-		struct io_kiocb *cancel_req = NULL;
+		struct io_kiocb *cancel_req = NULL, *req;
+		DEFINE_WAIT(wait);
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
@@ -7400,6 +7398,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			 */
 			if (refcount_sub_and_test(2, &cancel_req->refs)) {
 				io_put_req(cancel_req);
+				finish_wait(&ctx->inflight_wait, &wait);
 				continue;
 			}
 		}
@@ -7407,8 +7406,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
 		io_put_req(cancel_req);
 		schedule();
+		finish_wait(&ctx->inflight_wait, &wait);
 	}
-	finish_wait(&ctx->inflight_wait, &wait);
 }
 
 static int io_uring_flush(struct file *file, void *data)
-- 
2.17.2

