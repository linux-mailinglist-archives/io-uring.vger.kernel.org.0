Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EDD4FE379
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 16:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiDLONL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 10:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355996AbiDLONB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 10:13:01 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1F61CFD5
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:43 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id c7so27995453wrd.0
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OMv7TB98xCrL0O+0UD0g1DltjDoVm1IsGGdBYdoGTa8=;
        b=EIwfJcibdwA/fU3d8VVPjXx70iNzMwSKxpLiMQskIacpgCtJA34vvgYNSEGaIbMBFe
         fXT0dgKQ9rNnXkNmpfeDCeiquideA/e7TuOs4Wxghm8AckYCW22NPluYRZL/FDlW/Juh
         i72IQttQyOs5l9jDW2heiRGKiZrlL0DL3FvyOA9rJ6mawvZ2jNTl5vX2WgCLfu9H1qev
         q/uH4o5yHyDE47eCLpjFdA3i+whT1M5xk1OIP7OEo8hX7cIUYrCkPudyHv7acxN/95D8
         dyQT2Izlt3uev9E6IjW+z9xpHvUP9PaVwMkVsH5ThR1uWU3U3JSiZrpRMcKSq5U2gnGW
         uOkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OMv7TB98xCrL0O+0UD0g1DltjDoVm1IsGGdBYdoGTa8=;
        b=m0gNE/GeWOOxu5YWORvwf2MQZxxLq9btqQ5PdZRRpuZyOklVtAhwRfKKIcrOklbNIe
         DcNhV5AD/+SD4LR5aUPKb7xWwHubiPsgFyTKTLwM9YZ8jfKc9N5zi/elhB91VbmOZ//9
         S+PO78ZbIxAkN8c+M7CqEfD9MAHc/CRbIywvVi2Gb7HejLf18DHa8OL8SCW5h0DBBVJ3
         7wVzNz6jDL9YQOYN7Eu5t2cNEHtNWCUBQP4dBCR+6QoEyfDBy3BHNAQEuCmgOEKvDrmd
         NGHQTZtQN4tlWNaNpXkq3UVEr0pFgX/ZhBTR/tJ3ydILMnw3PhwwatdCZNAm2Y5S51l3
         b9SA==
X-Gm-Message-State: AOAM531y6qXqfzl2mtaM0jQsZ7lvTMuttsj30ionYNWnW4Uu4dqHD7c7
        6/1QJOdpnfQdVaaXia0gPrhca553jhk=
X-Google-Smtp-Source: ABdhPJxYXyThDBfUVb+sbkIq4GJ+5zxW8sTmvFBX1n749d/Ztvw/KgxIOVNnqDW+03d1Kw5j0/QtYw==
X-Received: by 2002:a05:6000:1c0f:b0:207:9b38:2d4c with SMTP id ba15-20020a0560001c0f00b002079b382d4cmr15314004wrb.326.1649772642089;
        Tue, 12 Apr 2022 07:10:42 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.222])
        by smtp.gmail.com with ESMTPSA id ay41-20020a05600c1e2900b0038e75fda4edsm2363703wmb.47.2022.04.12.07.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 07:10:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 9/9] io_uring: optimise io_get_cqe()
Date:   Tue, 12 Apr 2022 15:09:51 +0100
Message-Id: <487eeef00f3146537b3d9c1a9cef2fc0b9a86f81.1649771823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649771823.git.asml.silence@gmail.com>
References: <cover.1649771823.git.asml.silence@gmail.com>
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

io_get_cqe() is expensive because of a bunch of loads, masking, etc.
However, most of the time we should have enough of entries in the CQ,
so we can cache two pointers representing a range of contiguous CQE
memory we can use. When the range is exhausted we'll go through a slower
path to set up a new range. When there are no CQEs avaliable, pointers
will naturally point to the same address.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b349a3c52354..f2269ffe09eb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -416,6 +416,13 @@ struct io_ring_ctx {
 	unsigned long		check_cq_overflow;
 
 	struct {
+		/*
+		 * We cache a range of free CQEs we can use, once exhausted it
+		 * should go through a slower range setup, see __io_get_cqe()
+		 */
+		struct io_uring_cqe	*cqe_cached;
+		struct io_uring_cqe	*cqe_santinel;
+
 		unsigned		cached_cq_tail;
 		unsigned		cq_entries;
 		struct io_ev_fd	__rcu	*io_ev_fd;
@@ -1831,21 +1838,38 @@ static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
 	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
 }
 
-static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
+/*
+ * writes to the cq entry need to come after reading head; the
+ * control dependency is enough as we're using WRITE_ONCE to
+ * fill the cq entry
+ */
+static noinline struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
-	unsigned tail, mask = ctx->cq_entries - 1;
-
-	/*
-	 * writes to the cq entry need to come after reading head; the
-	 * control dependency is enough as we're using WRITE_ONCE to
-	 * fill the cq entry
-	 */
-	if (__io_cqring_events(ctx) == ctx->cq_entries)
+	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
+	unsigned int free, queued, len;
+
+	/* userspace may cheat modifying the tail, be safe and do min */
+	queued = min(__io_cqring_events(ctx), ctx->cq_entries);
+	free = ctx->cq_entries - queued;
+	/* we need a contiguous range, limit based on the current array offset */
+	len = min(free, ctx->cq_entries - off);
+	if (!len)
 		return NULL;
 
-	tail = ctx->cached_cq_tail++;
-	return &rings->cqes[tail & mask];
+	ctx->cached_cq_tail++;
+	ctx->cqe_cached = &rings->cqes[off];
+	ctx->cqe_santinel = ctx->cqe_cached + len;
+	return ctx->cqe_cached++;
+}
+
+static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
+{
+	if (likely(ctx->cqe_cached < ctx->cqe_santinel)) {
+		ctx->cached_cq_tail++;
+		return ctx->cqe_cached++;
+	}
+	return __io_get_cqe(ctx);
 }
 
 static void io_eventfd_signal(struct io_ring_ctx *ctx)
-- 
2.35.1

