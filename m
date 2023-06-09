Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7A9729A05
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 14:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbjFIMak (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 08:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238967AbjFIMaj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 08:30:39 -0400
Received: from out-28.mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9EE210D
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 05:29:58 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686313242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UcRk5qlFQvWJ33hcG3kedIDgrONZn1C9jUn4w2g+xQE=;
        b=pMVV6ttk9cC1bb9hMbPJ2nhJL4+5iM2MZUL2t5mCo0dMDHDYZF2wWs9FwxyxnaF9fsnbYs
        cAsk4dLBG8y7YTO3GAthr7JjIK7+l1xk+Ah06/k2MtSibvYeefOjjtJrQTa9UkygKoQvL/
        PLhjaK4YODsCHyKkGbzrr4aW1I5Ndw8=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 01/11] io-wq: fix worker counting after worker received exit signal
Date:   Fri,  9 Jun 2023 20:20:21 +0800
Message-Id: <20230609122031.183730-2-hao.xu@linux.dev>
In-Reply-To: <20230609122031.183730-1-hao.xu@linux.dev>
References: <20230609122031.183730-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

acct->nr_workers should be decremented when we break the loop in
io_wq_worker().

Fixes: 78f8876c2d9f ("io-wq: exclusively gate signal based exit on get_signal() return")
Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index b2715988791e..b70eebec2845 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -634,6 +634,10 @@ static int io_wq_worker(void *data)
 
 			if (!get_signal(&ksig))
 				continue;
+
+			raw_spin_lock(&wq->lock);
+			acct->nr_workers--;
+			raw_spin_unlock(&wq->lock);
 			break;
 		}
 		if (!ret) {
-- 
2.25.1

