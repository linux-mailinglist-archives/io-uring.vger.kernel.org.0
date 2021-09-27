Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9EF419290
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 12:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhI0Kxx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 06:53:53 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:51827 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233878AbhI0Kxw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 06:53:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Upn7J34_1632739883;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Upn7J34_1632739883)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 18:51:31 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 5/8] io_uring: split io_req_complete_post() and add a helper
Date:   Mon, 27 Sep 2021 18:51:20 +0800
Message-Id: <20210927105123.169301-6-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210927105123.169301-1-haoxu@linux.alibaba.com>
References: <20210927105123.169301-1-haoxu@linux.alibaba.com>
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
index af3811f1ef2e..91bb4a7bb84a 100644
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

