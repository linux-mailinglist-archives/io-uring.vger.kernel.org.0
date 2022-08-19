Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65986599E31
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349507AbiHSPaR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349577AbiHSPaQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:30:16 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77321FF8EF
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:30:15 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660923014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k6K5sCnfZDewEDUqgPTjWysfUpc7lfJuLBqyMQeq0xI=;
        b=mTEhrkVYNfzHafM2P6xMwZYXzSMq+dosZb8AoZptt7L684ovYLVQxwpNFDr8DgXa/xnWlw
        j6kEi7WuM9MwFgjX9HOlm8FWsAEE/llFm5RVnpiwFLD0l+KCZnSk8+jImxnGBxFjfVJk2L
        kRb7z7z3qXvFiDLDmnSgNViD9nYygT4=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 16/19] io_uring: release ctx->let when a ring exits
Date:   Fri, 19 Aug 2022 23:27:35 +0800
Message-Id: <20220819152738.1111255-17-hao.xu@linux.dev>
In-Reply-To: <20220819152738.1111255-1-hao.xu@linux.dev>
References: <20220819152738.1111255-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Release the uringlet worker pool when a ring exits, and reclaim the
resource.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a109dcb48702..bbe8948f4771 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2699,6 +2699,11 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	unsigned long index;
 	struct creds *creds;
 
+	if (ctx->flags & IORING_SETUP_URINGLET) {
+		io_wq_exit_start(ctx->let);
+		io_wq_put_and_exit(ctx->let);
+	}
+
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
 	if (ctx->rings)
-- 
2.25.1

