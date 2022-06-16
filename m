Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FD754DE1B
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 11:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376481AbiFPJW5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 05:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376618AbiFPJWz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 05:22:55 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6D817049
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:54 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id o8so1053920wro.3
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fI7Bbf1p3N5077YqPdGx1gf2DBASuHPaoVFSYzfe9G4=;
        b=gGOzo5KQQ2bO3MPeuhUtkTDiLYqLzRWPzGiZitZ9rCtvqAPR1uoLxDWjasbKPg1WkN
         qvIFm5NJWiGp5/kdLpGaPq+sF2DP/YDT6FV0+f0GSNWilKx9kNbJT/HPj8awFlyJFCwt
         jh6aDqACk1WSMguSZ9V+33FTkhwym620pkfTjj80o/9GyUvyOsCPYO6zYGVDnZ9ENJBG
         0Xkzi13GqMV15eemw0bNknqHHCq0HuhD233OTHEG72Z85mBo2HSOvrqSIiOHQua8TujA
         dDhjX2UQ9uOhgD0YhPd3JOH/Rg6k0xu3sAu1gwAWDuXOb1PmeqR0wJzf2/2jn/pjLCZb
         dwvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fI7Bbf1p3N5077YqPdGx1gf2DBASuHPaoVFSYzfe9G4=;
        b=ukw7zO6vbrIXn5Ge88KdPBtOgo4VeMnzZMzcdKDDX+DAb2YxWLUF7hv1EFeWrDXVc8
         ucIay+Et0Rka5mcT/k+lGxy9dnpghFVi41RwoxeLLi4Vsulrx05g6mBQRU3qyFRmwUgJ
         OBCdG8ncd1iuueTi1rKo5T8CIHZiXH1eNaH/ms+ZHWnVWHTEGDv3RIV6/PtOoNtFr1Ha
         az3zOVjHhNG/sN2Duzyzx2ZWDibWKJ8T4N7wpcIbSq6fftMhJ0vljw45pVB68gGpeyMO
         seYiharb7oYEKWoZk9FqrHnEN4bBVFy7uAYgRpsFzRuoWH+V1GcVhKe9OOuuSCQLn81w
         x1Ag==
X-Gm-Message-State: AJIora8jPAMvhBPairRbddikqyvwa4dWkJT+mXQydYdrVmra8HKszF4D
        BlzbOPNXYR4uzvJ1kqu4moc2ySYlBfbEiA==
X-Google-Smtp-Source: AGRyM1tCH6WKkwfbkWJWWCjNyUQTPbG6iiX8qesDp16qFpDzru8B2wT0stBWUeqhrI3b8jL1fppZlg==
X-Received: by 2002:a5d:6484:0:b0:219:eb95:3502 with SMTP id o4-20020a5d6484000000b00219eb953502mr3708525wri.692.1655371373764;
        Thu, 16 Jun 2022 02:22:53 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm1695221wmc.25.2022.06.16.02.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 02:22:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v3 10/16] io_uring: clean up io_ring_ctx_alloc
Date:   Thu, 16 Jun 2022 10:22:06 +0100
Message-Id: <993926ed0d614ba9a76b2a85bebae2babcb13983.1655371007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655371007.git.asml.silence@gmail.com>
References: <cover.1655371007.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a variable for the number of hash buckets in io_ring_ctx_alloc(),
makes it more readable.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 97113c71e881..b2bd71cb2be6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -244,6 +244,8 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
+	unsigned hash_buckets;
+	size_t hash_size;
 	int hash_bits;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
@@ -259,15 +261,15 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	 */
 	hash_bits = ilog2(p->cq_entries) - 5;
 	hash_bits = clamp(hash_bits, 1, 8);
+	hash_buckets = 1U << hash_bits;
+	hash_size = hash_buckets * sizeof(struct io_hash_bucket);
 
 	ctx->cancel_hash_bits = hash_bits;
-	ctx->cancel_hash =
-		kmalloc((1U << hash_bits) * sizeof(struct io_hash_bucket),
-			GFP_KERNEL);
+	ctx->cancel_hash = kmalloc(hash_size, GFP_KERNEL);
 	if (!ctx->cancel_hash)
 		goto err;
 
-	init_hash_table(ctx->cancel_hash, 1U << hash_bits);
+	init_hash_table(ctx->cancel_hash, hash_buckets);
 
 	ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
 	if (!ctx->dummy_ubuf)
-- 
2.36.1

