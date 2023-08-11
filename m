Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9048B778FF7
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 14:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbjHKMzS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 08:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjHKMzR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 08:55:17 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6985B115
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:16 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-99c47ef365cso281981266b.0
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691758514; x=1692363314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WyPJ8ImW+Enn/JA4TnwWypJPSlU1aIeQGsKxhR8THfU=;
        b=BkJJvuraa5dwDPTR1vx6NaFNRAzNH6hFEKrQIP9cd8o0QPH+UCqY/TXnyYe0ULdmW4
         JJlCPM7eFLZtVVIxEPC2wMWsv07PA9HnM2xCtCv+urBW70ewPWxgmT/YLeJDyOLkg2fj
         LMEUpmVS8Wxi7Nm92kd4dR2SV0Khb17RMirDxXCNyLNFSAxrSmCVn4dGUUyhsHKsoqHQ
         xOKfvQp1uVy4HcBzkWF06ZwRjHkExSzfOYyjECY3InjhPsA/jAZMsIKyYe7tX6ic9vzi
         otM4DJtQIUALBlkXz8M/jIxD0RU5nl/rZrPq3safipwLYYWVGZSHwWs+/zMVHkaQC6Xw
         KBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691758514; x=1692363314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WyPJ8ImW+Enn/JA4TnwWypJPSlU1aIeQGsKxhR8THfU=;
        b=Khb3RjfEokliYFdMWEFj3sNMG5WqzmtlPfOiT4GUd/dLBsOAtwUzUvCbhXe4r+i1yy
         jHJ0fGDo1xkfRL1ykG6CRvXcDq+SI3SBmS6+pssuO4h4GAubCxDKiAF/1GfTDM5gB5zU
         3GdG/NzDZPPF+ZzN6579qgIwikOaOm+4KPMM330tYHyUkXmbKabNlctQ/F6EN93EqQFc
         z7Aw/vBeMw2386kMbUGcZAINlEDrin4kjrTLnyqkkB+Kh+zaISoz8IS7xkXRfRj1bw9h
         +heFmimfJE8Aeu2FF0sya56nqc7WxNKVPL/9ixxL5PZXNEHRDpPa/JzN1NviY1O7sEVj
         9GfQ==
X-Gm-Message-State: AOJu0Yw14/N8MYaAjmLEcSxlqpAOxwA+gHtQQVs2BdTVvMFIPOMsSa0S
        oFQrbUqc2jPaQKmmmQcuTQlmciGZnzE=
X-Google-Smtp-Source: AGHT+IEn37CeDZpDg8BiQl0RikAPK4Yz6FJeure6kLQ6+0+wnhSmZQV3MRQRLEx6z0smTp6//BkDoA==
X-Received: by 2002:a17:906:9bc1:b0:99c:ad52:b0a with SMTP id de1-20020a1709069bc100b0099cad520b0amr1773354ejc.38.1691758514563;
        Fri, 11 Aug 2023 05:55:14 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a57e])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm2206943ejc.157.2023.08.11.05.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 05:55:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 6/7] io_uring/rsrc: keep one global dummy_ubuf
Date:   Fri, 11 Aug 2023 13:53:46 +0100
Message-ID: <e4a96dda35ab755914bc43f6781bba0df97ac489.1691757663.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1691757663.git.asml.silence@gmail.com>
References: <cover.1691757663.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We set empty registered buffers to dummy_ubuf as an optimisation.
Currently, we allocate the dummy entry for each ring, whenever we can
simply have one global instance.

We're casting out const on assignment, it's fine as we're not going to
change the content of the dummy, the constness gives us an extra layer
of protection if sth ever goes wrong.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  9 ---------
 io_uring/rsrc.c     | 14 ++++++++++----
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e57d00939ab9..a7a4d637aee0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -290,13 +290,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 	if (io_alloc_hash_table(&ctx->cancel_table_locked, hash_bits))
 		goto err;
-
-	ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
-	if (!ctx->dummy_ubuf)
-		goto err;
-	/* set invalid range, so io_import_fixed() fails meeting it */
-	ctx->dummy_ubuf->ubuf = -1UL;
-
 	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
 			    0, GFP_KERNEL))
 		goto err;
@@ -335,7 +328,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	return ctx;
 err:
-	kfree(ctx->dummy_ubuf);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
 	kfree(ctx->io_bl);
@@ -2897,7 +2889,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		io_wq_put_hash(ctx->hash_map);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
-	kfree(ctx->dummy_ubuf);
 	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5e8fdd9b8ca6..d9c853d10587 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -33,6 +33,12 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 #define IORING_MAX_FIXED_FILES	(1U << 20)
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
 
+static const struct io_mapped_ubuf dummy_ubuf = {
+	/* set invalid range, so io_import_fixed() fails meeting it */
+	.ubuf = -1UL,
+	.ubuf_end = 0,
+};
+
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
@@ -132,7 +138,7 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 	struct io_mapped_ubuf *imu = *slot;
 	unsigned int i;
 
-	if (imu != ctx->dummy_ubuf) {
+	if (imu != &dummy_ubuf) {
 		for (i = 0; i < imu->nr_bvecs; i++)
 			unpin_user_page(imu->bvec[i].bv_page);
 		if (imu->acct_pages)
@@ -459,14 +465,14 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			break;
 
 		i = array_index_nospec(up->offset + done, ctx->nr_user_bufs);
-		if (ctx->user_bufs[i] != ctx->dummy_ubuf) {
+		if (ctx->user_bufs[i] != &dummy_ubuf) {
 			err = io_queue_rsrc_removal(ctx->buf_data, i,
 						    ctx->user_bufs[i]);
 			if (unlikely(err)) {
 				io_buffer_unmap(ctx, &imu);
 				break;
 			}
-			ctx->user_bufs[i] = ctx->dummy_ubuf;
+			ctx->user_bufs[i] = (struct io_mapped_ubuf *)&dummy_ubuf;
 		}
 
 		ctx->user_bufs[i] = imu;
@@ -1077,7 +1083,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	int ret, nr_pages, i;
 	struct folio *folio = NULL;
 
-	*pimu = ctx->dummy_ubuf;
+	*pimu = (struct io_mapped_ubuf *)&dummy_ubuf;
 	if (!iov->iov_base)
 		return 0;
 
-- 
2.41.0

