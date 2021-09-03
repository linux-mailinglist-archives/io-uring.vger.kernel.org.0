Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513DE3FFE8E
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 13:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348376AbhICLCB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 07:02:01 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:55948 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348390AbhICLB7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 07:01:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Un61DbM_1630666849;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Un61DbM_1630666849)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Sep 2021 19:00:58 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/6] io_uring: enhance flush completion logic
Date:   Fri,  3 Sep 2021 19:00:44 +0800
Message-Id: <20210903110049.132958-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210903110049.132958-1-haoxu@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Though currently refcount of a req is always one when we flush inline
completions, but still a chance there will be exception in the future.
Enhance the flush logic to make sure we maintain compl_nr correctly.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

we need to either removing the if check to claim clearly that the req's
refcount is 1 or adding this patch's logic.

 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2bde732a1183..c48d43207f57 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2291,7 +2291,7 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state = &ctx->submit_state;
-	int i, nr = state->compl_nr;
+	int i, nr = state->compl_nr, remain = 0;
 	struct req_batch rb;
 
 	spin_lock(&ctx->completion_lock);
@@ -2311,10 +2311,12 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 
 		if (req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
+		else
+			state->compl_reqs[remain++] = state->compl_reqs[i];
 	}
 
 	io_req_free_batch_finish(ctx, &rb);
-	state->compl_nr = 0;
+	state->compl_nr = remain;
 }
 
 /*
-- 
2.24.4

