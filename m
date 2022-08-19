Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90EA599E39
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349552AbiHSP35 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349346AbiHSP34 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:29:56 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4487101C4
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:29:55 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660922994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eKSA674mYIi3+xSnO7yHzmLX7iobcHsHIt3i/73o/ag=;
        b=eaJpmRfhG3B1evVrE9Z/WdR9RlSEp/9JZ+kubzqH/4a9ChujrpqZEHoq/bqSop5rhO+0hE
        PV4AtAJckUuqiqQe7c9DGm8Xr02ItEyW7HVjVxgxnBI7kzxWSE1fJbIyP7wFvFfveq9CjR
        sAMq08e5Y9lExrJMxpK9vtUU6mYT13I=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 11/19] io_uring: don't allocate io-wq for a worker in uringlet mode
Date:   Fri, 19 Aug 2022 23:27:30 +0800
Message-Id: <20220819152738.1111255-12-hao.xu@linux.dev>
In-Reply-To: <20220819152738.1111255-1-hao.xu@linux.dev>
References: <20220819152738.1111255-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

A uringlet worker doesn't need any io-wq pool.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/tctx.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 0c15fb8b9a2e..b04d361bcf34 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -81,12 +81,17 @@ __cold int io_uring_alloc_task_context(struct task_struct *task,
 		return ret;
 	}
 
-	tctx->io_wq = io_init_wq_offload(ctx, task);
-	if (IS_ERR(tctx->io_wq)) {
-		ret = PTR_ERR(tctx->io_wq);
-		percpu_counter_destroy(&tctx->inflight);
-		kfree(tctx);
-		return ret;
+	/*
+	 * don't allocate io-wq in uringlet mode
+	 */
+	if (!(ctx->flags & IORING_SETUP_URINGLET)) {
+		tctx->io_wq = io_init_wq_offload(ctx, task);
+		if (IS_ERR(tctx->io_wq)) {
+			ret = PTR_ERR(tctx->io_wq);
+			percpu_counter_destroy(&tctx->inflight);
+			kfree(tctx);
+			return ret;
+		}
 	}
 
 	xa_init(&tctx->xa);
-- 
2.25.1

