Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD7B43CB72
	for <lists+io-uring@lfdr.de>; Wed, 27 Oct 2021 16:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242354AbhJ0OEw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Oct 2021 10:04:52 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:52524 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242374AbhJ0OEv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Oct 2021 10:04:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UtuRLZW_1635343336;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UtuRLZW_1635343336)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 22:02:24 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 4/8] io_uring: split io_req_complete_post() and add a helper
Date:   Wed, 27 Oct 2021 22:02:12 +0800
Message-Id: <20211027140216.20008-5-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211027140216.20008-1-haoxu@linux.alibaba.com>
References: <20211027140216.20008-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Split io_req_complete_post(), this is a prep for the next patch.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 98abf94b2015..3c621798dd2f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1818,12 +1818,11 @@ static noinline bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data
 	return __io_cqring_fill_event(ctx, user_data, res, cflags);
 }
 
-static void io_req_complete_post(struct io_kiocb *req, s32 res,
+static void __io_req_complete_post(struct io_kiocb *req, s32 res,
 				 u32 cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	spin_lock(&ctx->completion_lock);
 	__io_cqring_fill_event(ctx, req->user_data, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
@@ -1844,6 +1843,15 @@ static void io_req_complete_post(struct io_kiocb *req, s32 res,
 		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
 	}
+}
+
+static void io_req_complete_post(struct io_kiocb *req, long res,
+				 unsigned int cflags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	spin_lock(&ctx->completion_lock);
+	__io_req_complete_post(req, res, cflags);
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
-- 
2.24.4

