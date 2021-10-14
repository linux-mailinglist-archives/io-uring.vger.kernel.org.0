Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA2A42DB0A
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 16:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhJNOGN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 10:06:13 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:36135 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230177AbhJNOGN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 10:06:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Urrp8XH_1634220240;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Urrp8XH_1634220240)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 Oct 2021 22:04:06 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: fix wrong condition to grab uring lock
Date:   Thu, 14 Oct 2021 22:04:00 +0800
Message-Id: <20211014140400.50235-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Grab uring lock when we are in io-worker rather than in the original
or system-wq context since we already hold it in these two situation.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 73135c5c6168..e2ed21c65f71 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2890,7 +2890,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 			struct io_ring_ctx *ctx = req->ctx;
 
 			req_set_fail(req);
-			if (issue_flags & IO_URING_F_NONBLOCK) {
+			if (!(issue_flags & IO_URING_F_NONBLOCK)) {
 				mutex_lock(&ctx->uring_lock);
 				__io_req_complete(req, issue_flags, ret, cflags);
 				mutex_unlock(&ctx->uring_lock);
-- 
2.24.4

