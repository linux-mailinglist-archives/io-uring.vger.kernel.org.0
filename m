Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8D96E8533
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 00:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjDSWsY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 18:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjDSWsO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 18:48:14 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3646B1991
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 15:48:12 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-24733b262fdso53148a91.1
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 15:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681944491; x=1684536491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJouhk3GtHhx4j7Gx0k/VX97WoDn1hZiBkStWsBGUsk=;
        b=CILzMRnKPxG2P5ORSEwNtPdCR+n06cpYg4hEUCFLJG0jSCLcTGYy8KbA5PFgxvqUZP
         qqWAbAidxpuDXE0ll6ubRai9XxgP/mhnmNWs/jeHayYBnKzqLDCWLK/mOA1AIGr4Xpg3
         ZUObfsOm1jyvodDePOi0gn+g1fyW8lC+QLRpKehoNl16+MfADInOqtBlTK50Y5KcurpE
         f1A+mL9raVvDrOTShoajzr7uoBZtM/cTJuNuyzNfOrJRjFasmlJ14Dq8jwKr8Mz/kqo2
         SKdkbHdpaaNAQuLAAxgzes6gDqD6DoaA27chDGpI+b7FwmDm+dCdcrLXpX4eUNp/gf4+
         dvlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681944491; x=1684536491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJouhk3GtHhx4j7Gx0k/VX97WoDn1hZiBkStWsBGUsk=;
        b=HSRpjXAQ8tztOK7JM5FUbOGLyjsnRoz/09IBmtdWmX3JAf+qgZVBwySEwFVckkS1A/
         aw/VGeC/6hrnwsq2iueo64WQrgLdQTLme3EBobFzHD2rg6si1K/F4vq8Pk1EOqdr/RCm
         w51KKDOE/FKtqU1QaoDFqgdZUHSWZC3RLTD7Fp3w18qhAA5gXJp0hJRMGBtocZkz2q7p
         6rlCZeGAFcqcJ/nR90qfe0xZQSm/aBCSb4oJLrHB4NZjj2rJYdqqjJ9yrGWPUN6ZqNJD
         n0t2zc2WgTAWwJ/C+jSj+qo+oC5bjRFx2GaSAsppiOy2UGdafVW1pTpE3+x+ccfHLvBq
         ZOng==
X-Gm-Message-State: AAQBX9dGnmOL1tLDhnnAqd9mYz4t5yIO4l/B2yM/1rQt+leJk3SyAqOf
        PuRniiOk44pSJ4rgzdN022TKXo7IXZm6BQLdKsY=
X-Google-Smtp-Source: AKy350bLAtVy5I9uQtEzMHfuz57P6ZJ3vgScNy04PlF2de6oEj9S1yPUdamjT7mub9QObvm5dj8fRw==
X-Received: by 2002:a17:90a:352:b0:247:b1f7:9f67 with SMTP id 18-20020a17090a035200b00247b1f79f67mr7832495pjf.4.1681944491370;
        Wed, 19 Apr 2023 15:48:11 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l9-20020a17090a49c900b002353082958csm1853364pjm.10.2023.04.19.15.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:48:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: support for user allocated memory for rings/sqes
Date:   Wed, 19 Apr 2023 16:48:05 -0600
Message-Id: <20230419224805.693734-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230419224805.693734-1-axboe@kernel.dk>
References: <20230419224805.693734-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently io_uring applications must call mmap(2) twice to map the rings
themselves, and the sqes array. This works fine, but it does not support
using huge pages to back the rings/sqes.

Provide a way for the application to pass in pre-allocated memory for
the rings/sqes, which can then suitably be allocated from shmfs or
via mmap to get huge page support.

Particularly for larger rings, this reduces the TLBs needed.

If an application wishes to take advantage of that, it must pre-allocate
the memory needed for the sq/cq ring, and the sqes. The former must
be passed in via the io_uring_params->cq_off.user_data field, while the
latter is passed in via the io_uring_params->sq_off.user_data field. Then
it must set IORING_SETUP_NO_MMAP in the io_uring_params->flags field,
and io_uring will then map the existing memory into the kernel for shared
use. The application must not call mmap(2) to map rings as it otherwise
would have, that will now fail with -EINVAL if this setup flag was used.

The pages used for the rings and sqes must be contigious. The intent here
is clearly that huge pages should be used, otherwise the normal setup
procedure works fine as-is. The application may use one huge page for
both the rings and sqes.

Outside of those initialization changes, everything works like it did
before.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  10 ++++
 include/uapi/linux/io_uring.h  |   9 ++-
 io_uring/io_uring.c            | 102 +++++++++++++++++++++++++++++----
 3 files changed, 109 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c54f3fb7ab1a..3489fa223586 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -211,6 +211,16 @@ struct io_ring_ctx {
 		unsigned int		compat: 1;
 
 		enum task_work_notify_mode	notify_method;
+
+		/*
+		 * If IORING_SETUP_NO_MMAP is used, then the below holds
+		 * the gup'ed pages for the two rings, and the sqes.
+		 */
+		unsigned short		n_ring_pages;
+		unsigned short		n_sqe_pages;
+		struct page		**ring_pages;
+		struct page		**sqe_pages;
+
 		struct io_rings			*rings;
 		struct task_struct		*submitter_task;
 		struct percpu_ref		refs;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ea903a677ce9..5499f9728f9d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -179,6 +179,11 @@ enum {
  */
 #define IORING_SETUP_NO_OFFLOAD		(1U << 14)
 
+/*
+ * Application provides the memory for the rings
+ */
+#define IORING_SETUP_NO_MMAP		(1U << 15)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
@@ -412,7 +417,7 @@ struct io_sqring_offsets {
 	__u32 dropped;
 	__u32 array;
 	__u32 resv1;
-	__u64 resv2;
+	__u64 user_addr;
 };
 
 /*
@@ -431,7 +436,7 @@ struct io_cqring_offsets {
 	__u32 cqes;
 	__u32 flags;
 	__u32 resv1;
-	__u64 resv2;
+	__u64 user_addr;
 };
 
 /*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf570b0f82ec..d6694bd92453 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2716,12 +2716,80 @@ static void io_mem_free(void *ptr)
 		free_compound_page(page);
 }
 
+static void io_pages_free(struct page ***pages, int npages)
+{
+	struct page **page_array;
+	int i;
+
+	if (!pages)
+		return;
+	page_array = *pages;
+	for (i = 0; i < npages; i++)
+		unpin_user_page(page_array[i]);
+	kvfree(page_array);
+	*pages = NULL;
+}
+
+static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
+			    unsigned long uaddr, size_t size)
+{
+	struct page **page_array;
+	unsigned int nr_pages;
+	int ret;
+
+	*npages = 0;
+
+	if (uaddr & (PAGE_SIZE - 1) || !size)
+		return ERR_PTR(-EINVAL);
+
+	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (nr_pages > USHRT_MAX)
+		return ERR_PTR(-EINVAL);
+	page_array = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
+	if (!page_array)
+		return ERR_PTR(-ENOMEM);
+
+	ret = pin_user_pages_fast(uaddr, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
+					page_array);
+	if (ret != nr_pages) {
+err:
+		io_pages_free(&page_array, ret > 0 ? ret : 0);
+		return ret < 0 ? ERR_PTR(ret) : ERR_PTR(-EFAULT);
+	}
+	/* pages must be contig */
+	ret--;
+	if (page_array[0] + ret != page_array[ret])
+		goto err;
+	*pages = page_array;
+	*npages = nr_pages;
+	return page_to_virt(page_array[0]);
+}
+
+static void *io_rings_map(struct io_ring_ctx *ctx, unsigned long uaddr,
+			  size_t size)
+{
+	return __io_uaddr_map(&ctx->ring_pages, &ctx->n_ring_pages, uaddr,
+				size);
+}
+
+static void *io_sqes_map(struct io_ring_ctx *ctx, unsigned long uaddr,
+			 size_t size)
+{
+	return __io_uaddr_map(&ctx->sqe_pages, &ctx->n_sqe_pages, uaddr,
+				size);
+}
+
 static void io_rings_free(struct io_ring_ctx *ctx)
 {
-	io_mem_free(ctx->rings);
-	io_mem_free(ctx->sq_sqes);
-	ctx->rings = NULL;
-	ctx->sq_sqes = NULL;
+	if (!(ctx->flags & IORING_SETUP_NO_MMAP)) {
+		io_mem_free(ctx->rings);
+		io_mem_free(ctx->sq_sqes);
+		ctx->rings = NULL;
+		ctx->sq_sqes = NULL;
+	} else {
+		io_pages_free(&ctx->ring_pages, ctx->n_ring_pages);
+		io_pages_free(&ctx->sqe_pages, ctx->n_sqe_pages);
+	}
 }
 
 static void *io_mem_alloc(size_t size)
@@ -3366,6 +3434,10 @@ static void *io_uring_validate_mmap_request(struct file *file,
 	struct page *page;
 	void *ptr;
 
+	/* Don't allow mmap if the ring was setup without it */
+	if (ctx->flags & IORING_SETUP_NO_MMAP)
+		return ERR_PTR(-EINVAL);
+
 	switch (offset & IORING_OFF_MMAP_MASK) {
 	case IORING_OFF_SQ_RING:
 	case IORING_OFF_CQ_RING:
@@ -3707,7 +3779,11 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	if (size == SIZE_MAX)
 		return -EOVERFLOW;
 
-	rings = io_mem_alloc(size);
+	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
+		rings = io_mem_alloc(size);
+	else
+		rings = io_rings_map(ctx, p->cq_off.user_addr, size);
+
 	if (IS_ERR(rings))
 		return PTR_ERR(rings);
 
@@ -3727,13 +3803,17 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 		return -EOVERFLOW;
 	}
 
-	ptr = io_mem_alloc(size);
+	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
+		ptr = io_mem_alloc(size);
+	else
+		ptr = io_sqes_map(ctx, p->sq_off.user_addr, size);
+
 	if (IS_ERR(ptr)) {
 		io_rings_free(ctx);
 		return PTR_ERR(ptr);
 	}
 
-	ctx->sq_sqes = io_mem_alloc(size);
+	ctx->sq_sqes = ptr;
 	return 0;
 }
 
@@ -3919,7 +3999,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
 	p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
 	p->sq_off.resv1 = 0;
-	p->sq_off.resv2 = 0;
+	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
+		p->sq_off.user_addr = 0;
 
 	p->cq_off.head = offsetof(struct io_rings, cq.head);
 	p->cq_off.tail = offsetof(struct io_rings, cq.tail);
@@ -3929,7 +4010,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->cq_off.cqes = offsetof(struct io_rings, cqes);
 	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
 	p->cq_off.resv1 = 0;
-	p->cq_off.resv2 = 0;
+	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
+		p->cq_off.user_addr = 0;
 
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
@@ -3996,7 +4078,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
-			IORING_SETUP_NO_OFFLOAD))
+			IORING_SETUP_NO_OFFLOAD | IORING_SETUP_NO_MMAP))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
-- 
2.39.2

