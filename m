Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1A9418EFC
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 08:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhI0GTs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 02:19:48 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:58258 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232963AbhI0GTs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 02:19:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpiKFOp_1632723441;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpiKFOp_1632723441)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 14:17:28 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 5/8] io_uring: split io_req_complete_post() and add a helper
Date:   Mon, 27 Sep 2021 14:17:18 +0800
Message-Id: <20210927061721.180806-6-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210927061721.180806-1-haoxu@linux.alibaba.com>
References: <20210927061721.180806-1-haoxu@linux.alibaba.com>
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
index 58ce58e7c65d..4ee5bbe36e3b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1793,12 +1793,11 @@ static noinline bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data
 	return __io_cqring_fill_event(ctx, user_data, res, cflags);
 }
 
-static void io_req_complete_post(struct io_kiocb *req, long res,
+static void __io_req_complete_post(struct io_kiocb *req, long res,
 				 unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	spin_lock(&ctx->completion_lock);
 	__io_cqring_fill_event(ctx, req->user_data, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
@@ -1819,6 +1818,15 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 		ctx->locked_free_nr++;
 		percpu_ref_put(&ctx->refs);
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

