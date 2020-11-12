Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59742AFFEB
	for <lists+io-uring@lfdr.de>; Thu, 12 Nov 2020 07:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgKLG4F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 01:56:05 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:50171 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbgKLG4E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 01:56:04 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UF2nc-q_1605164161;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UF2nc-q_1605164161)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 Nov 2020 14:56:01 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH 5.11 2/2] io_uring: don't acquire uring_lock twice
Date:   Thu, 12 Nov 2020 14:56:00 +0800
Message-Id: <20201112065600.8710-3-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201112065600.8710-1-xiaoguang.wang@linux.alibaba.com>
References: <20201112065600.8710-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Both IOPOLL and sqes handling need to acquire uring_lock, combine
them together, then we just need to acquire uring_lock once.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c9b743be5328..f594c72de777 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6859,23 +6859,19 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 	unsigned int to_submit;
 	int ret = 0;
 
-	if (!list_empty(&ctx->iopoll_list)) {
-		unsigned nr_events = 0;
-
-		mutex_lock(&ctx->uring_lock);
-		if (!list_empty(&ctx->iopoll_list))
-			io_do_iopoll(ctx, &nr_events, 0);
-		mutex_unlock(&ctx->uring_lock);
-	}
-
 	to_submit = io_sqring_entries(ctx);
 	/* if we're handling multiple rings, cap submit size for fairness */
 	if (cap_entries && to_submit > 8)
 		to_submit = 8;
 
-	if (to_submit) {
+	if (!list_empty(&ctx->iopoll_list) || to_submit) {
+		unsigned nr_events = 0;
+
 		mutex_lock(&ctx->uring_lock);
-		if (likely(!percpu_ref_is_dying(&ctx->refs)))
+		if (!list_empty(&ctx->iopoll_list))
+			io_do_iopoll(ctx, &nr_events, 0);
+
+		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)))
 			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 	}
-- 
2.17.2

