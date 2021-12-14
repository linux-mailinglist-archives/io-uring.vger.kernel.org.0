Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60540473CD4
	for <lists+io-uring@lfdr.de>; Tue, 14 Dec 2021 06:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhLNF7N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Dec 2021 00:59:13 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:42720 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhLNF7M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Dec 2021 00:59:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V-b090n_1639461544;
Received: from localhost.localdomain(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V-b090n_1639461544)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 14 Dec 2021 13:59:11 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: code clean for some ctx usage
Date:   Tue, 14 Dec 2021 13:59:04 +0800
Message-Id: <20211214055904.61772-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are some functions doing ctx = req->ctx while still using
req->ctx, update those places.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1265dc1942eb..d86372664f9f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1548,7 +1548,7 @@ static void io_prep_async_link(struct io_kiocb *req)
 static inline void io_req_add_compl_list(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_submit_state *state = &req->ctx->submit_state;
+	struct io_submit_state *state = &ctx->submit_state;
 
 	if (!(req->flags & REQ_F_CQE_SKIP))
 		ctx->submit_state.flush_cqes = true;
@@ -2179,7 +2179,7 @@ static void __io_req_find_next_prep(struct io_kiocb *req)
 	spin_lock(&ctx->completion_lock);
 	posted = io_disarm_next(req);
 	if (posted)
-		io_commit_cqring(req->ctx);
+		io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
 	if (posted)
 		io_cqring_ev_posted(ctx);
-- 
2.25.1

