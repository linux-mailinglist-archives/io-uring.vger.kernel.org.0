Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06393F3650
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 00:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhHTWUj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 18:20:39 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:59817 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231334AbhHTWUj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 18:20:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UkT1rW2_1629497994;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UkT1rW2_1629497994)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 21 Aug 2021 06:19:59 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH for-5.15 v2] io_uring: fix lacking of protection for compl_nr
Date:   Sat, 21 Aug 2021 06:19:54 +0800
Message-Id: <20210820221954.61815-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

coml_nr in ctx_flush_and_put() is not protected by uring_lock, this
may cause problems when accessing it parallelly:

say coml_nr > 0

  ctx_flush_and put                  other context
   if (compl_nr)                      get mutex
                                      coml_nr > 0
                                      do flush
                                          coml_nr = 0
                                      release mutex
        get mutex
           do flush (*)
        release mutex

in (*) place, we call io_cqring_ev_posted() and users likely get
none events there.

Fixes: 2c32395d8111 ("io_uring: fix __tctx_task_work() ctx race")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c755efdac71f..c3bd2b3fc46b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2005,7 +2005,8 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx)
 		return;
 	if (ctx->submit_state.compl_nr) {
 		mutex_lock(&ctx->uring_lock);
-		io_submit_flush_completions(ctx);
+		if (ctx->submit_state.compl_nr)
+			io_submit_flush_completions(ctx);
 		mutex_unlock(&ctx->uring_lock);
 	}
 	percpu_ref_put(&ctx->refs);
-- 
2.24.4

