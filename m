Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F16775EE1
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 14:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjHIM1i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 08:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbjHIM1i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 08:27:38 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225D91FC2
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 05:27:37 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-31763b2c5a4so5679442f8f.3
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 05:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691584055; x=1692188855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=986jdSEKXW6uovI+R4WEC4WRfhjuWUUFhWAqHitrUFg=;
        b=qRcekq2IFvqrsxGW5ECSbKGcJWrGK/sLCxY+zagNTKfyvtjsKLOOx8beVgFZyjBNq8
         sJq00rvpPkMGW0Ci9kubjKX67WF8uClcds6JXWCqcwT8BVWBXK3fT7HbdDy60Al/zAdb
         jMqLk0mXG3rGEYisIm0nP6eNcNBx4em296ozo8qC6lZViFafXQtJluQV1QmKz/OP1rvK
         VXcGKbV9pFGRr7/Y6NlfSnLuv98bZc8YccCCY8oEPILan+0CiXa8XVtbk5WsJf9N8pZF
         zMBhg99YriJiu+7GXDSD80CRDWqRodUck088yijwkMBoA3FgpJnAErTtkeY+FdZLYkma
         3BDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691584055; x=1692188855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=986jdSEKXW6uovI+R4WEC4WRfhjuWUUFhWAqHitrUFg=;
        b=DtOdEnli8sAVWXt6o/NdpMiAY87waNfs08XEps4xRHvDzAjIggBH1KTMJ5tzCAJIzm
         BVMzFgfx9foklUsGzPWr3deGzGCMpkwHHcUtaCJyGr/eMTTct7CpmPqiWmfRVaFN8EVo
         m9EXuxzsk5X52Dajg8kGhCt+hEvIRaLaS3jWlAXEpIZrQJxlgoeAEIao3EXfGcxc0Xgj
         oAoYPCsPaNefnatGJdfViWr9gEVYO78f2njOSQzowmNXPDOD1N3yaaNnmYNnNdWP0BJi
         vz9KftmR4c2R4gKtXhO9nMWk2YDji9tPr+dpgRyJntYIOgjz/wo9L7g/1MsIN0ELVDJO
         ms4Q==
X-Gm-Message-State: AOJu0Yx5/+uGPubO5DqVkj5J1UCdw4rQoCq/ZN+TgnuzjxWNfsQoDu4Q
        6La0KcGPazDPS91VccdftrmvTrK1gD4=
X-Google-Smtp-Source: AGHT+IGx67pt+FFyhsK0DE5ef0ONydcCTonFtMzzl/hQ7FaJfieVSFOlvQAR1lJRynqHY1gdEIjO/g==
X-Received: by 2002:adf:f744:0:b0:318:69:ab03 with SMTP id z4-20020adff744000000b003180069ab03mr1707688wrp.17.1691584055292;
        Wed, 09 Aug 2023 05:27:35 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-78.dab.02.net. [82.132.230.78])
        by smtp.gmail.com with ESMTPSA id n4-20020a5d4204000000b0030ae499da59sm16558111wrq.111.2023.08.09.05.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 05:27:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring/rsrc: keep one global dummy_ubuf
Date:   Wed,  9 Aug 2023 13:25:26 +0100
Message-ID: <95c9dea5180d066dc35a94d39f4ce5a3ecdfbf77.1691546329.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1691546329.git.asml.silence@gmail.com>
References: <cover.1691546329.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  9 ---------
 io_uring/rsrc.c     | 14 ++++++++++----
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fb70ae436db6..3c97401240c2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -307,13 +307,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
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
@@ -352,7 +345,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	return ctx;
 err:
-	kfree(ctx->dummy_ubuf);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
 	kfree(ctx->io_bl);
@@ -2905,7 +2897,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		io_wq_put_hash(ctx->hash_map);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
-	kfree(ctx->dummy_ubuf);
 	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5e8fdd9b8ca6..92e2471283ba 100644
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
+			ctx->user_bufs[i] = &dummy_ubuf;
 		}
 
 		ctx->user_bufs[i] = imu;
@@ -1077,7 +1083,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	int ret, nr_pages, i;
 	struct folio *folio = NULL;
 
-	*pimu = ctx->dummy_ubuf;
+	*pimu = &dummy_ubuf;
 	if (!iov->iov_base)
 		return 0;
 
-- 
2.41.0

