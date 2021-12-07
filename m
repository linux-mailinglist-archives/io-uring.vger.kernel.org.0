Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFF346B7A0
	for <lists+io-uring@lfdr.de>; Tue,  7 Dec 2021 10:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbhLGJnd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Dec 2021 04:43:33 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:55413 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234017AbhLGJnc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Dec 2021 04:43:32 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UzkVFio_1638869991;
Received: from hao-A29R.hz.ali.com(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UzkVFio_1638869991)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Dec 2021 17:40:01 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 4/5] io_uring: split io_req_complete_post() and add a helper
Date:   Tue,  7 Dec 2021 17:39:50 +0800
Message-Id: <20211207093951.247840-5-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207093951.247840-1-haoxu@linux.alibaba.com>
References: <20211207093951.247840-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Split io_req_complete_post(), this is a prep for the next patch.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 85f9459e9072..21738ed7521e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1891,12 +1891,11 @@ static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
 	return __io_fill_cqe(ctx, user_data, res, cflags);
 }
 
-static void io_req_complete_post(struct io_kiocb *req, s32 res,
-				 u32 cflags)
+static void __io_req_complete_post(struct io_kiocb *req, s32 res,
+				   u32 cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	spin_lock(&ctx->completion_lock);
 	if (!(req->flags & REQ_F_CQE_SKIP))
 		__io_fill_cqe(ctx, req->user_data, res, cflags);
 	/*
@@ -1918,6 +1917,15 @@ static void io_req_complete_post(struct io_kiocb *req, s32 res,
 		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
 	}
+}
+
+static void io_req_complete_post(struct io_kiocb *req, s32 res,
+				 u32 cflags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	spin_lock(&ctx->completion_lock);
+	__io_req_complete_post(req, res, cflags);
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
-- 
2.25.1

