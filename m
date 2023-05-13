Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55DE7017B9
	for <lists+io-uring@lfdr.de>; Sat, 13 May 2023 16:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237196AbjEMOSB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 May 2023 10:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239116AbjEMOQ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 May 2023 10:16:56 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725121FE6
        for <io-uring@vger.kernel.org>; Sat, 13 May 2023 07:16:54 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-6439bf89cb7so2100195b3a.0
        for <io-uring@vger.kernel.org>; Sat, 13 May 2023 07:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683987413; x=1686579413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4nm4Xm3ajEi82BV1Xr3IeCHO1J9BtqnQCIxSBMCatIw=;
        b=YOye63Mcgyp4i2xozBQa9vt9GWSRnFqNkI42mcixjsC615kW2iB36hll3GiDqQ9KQC
         2grYbnC/zObTbrJQwdXrM2RpLzdcwfOBe5SZxPLrizRO6XXyWEpLPS7muR46k9kCm/pq
         HIkCmzh3j8ejyFj8qsFSiRZlozdYi3oMgQvGDliy1+8s6v0ZdIwyMCSlxYLl8LroMFUG
         BTDS6umWWPXX1lckakhsvTfX0iLlk91SI8L9q39ggs1qQzefFbHlZK2P4ddNOxwGneO0
         JRHySH5immoLiZWUJa3TT0jqpCgwyJtu3pQLkfFF81iHn57MfiZ6f2iWVumvsTnfVzR0
         BR5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683987413; x=1686579413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4nm4Xm3ajEi82BV1Xr3IeCHO1J9BtqnQCIxSBMCatIw=;
        b=GVfLPmUGi5YZ3mBFMh0j035ny6Ysl+lp/r/YbJuVnIHo9twu1N/EEOvDYGnnU+9NFQ
         bNd4rXUxE4UFhgZhNDuin3WzL/Bj4wcH8sX9OQR8GZLAY/bRdIgmchAer+ogKtZ9bP3d
         jsJaSk9W1uPjPMtnYVn/ek4pFX/Qw964eaTpwH/2Fga15PQF30Dd2Pden5pnNTTcqT7c
         wSq2w3LN6grvceZj8uq3d8jzLhZpPbbny5Hjm5tc+eD76qhHOEQn8GhkgiJ+N/BTkb+s
         XkCkQs52qWlAIt2uVQCHFlj1954q65MzrokndMReHr+quwSYUBbBphChox/mSjh1+i+v
         PtBg==
X-Gm-Message-State: AC+VfDwr0XKoaf+TpXC6sauLdrdJkPKhXcNUTJApNS5G+Ue6CWqPhcZs
        qBUfI8sWHcCqIi16aZg4QQeQT0rTN3ja61ZjukM=
X-Google-Smtp-Source: ACHHUZ4yEbAmR7WgAwXzaancQ64M2zYY/fuobm+jq09roja8xJmLBVuhKvqY77dOd+9ZPXsZXJaD2A==
X-Received: by 2002:a05:6a20:a108:b0:100:b92b:e8be with SMTP id q8-20020a056a20a10800b00100b92be8bemr23693801pzk.2.1683987413473;
        Sat, 13 May 2023 07:16:53 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o4-20020a63f144000000b00513973a7014sm8360027pgk.12.2023.05.13.07.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 May 2023 07:16:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: support for user allocated memory for rings/sqes
Date:   Sat, 13 May 2023 08:16:43 -0600
Message-Id: <20230513141643.1037620-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230513141643.1037620-1-axboe@kernel.dk>
References: <20230513141643.1037620-1-axboe@kernel.dk>
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
 include/linux/io_uring_types.h |  10 +++
 include/uapi/linux/io_uring.h  |   9 ++-
 io_uring/io_uring.c            | 108 ++++++++++++++++++++++++++++++---
 3 files changed, 115 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 1b2a20a42413..f04ce513fadb 100644
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
index 0716cb17e436..2edba9a274de 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -173,6 +173,11 @@ enum {
  */
 #define IORING_SETUP_DEFER_TASKRUN	(1U << 13)
 
+/*
+ * Application provides the memory for the rings
+ */
+#define IORING_SETUP_NO_MMAP		(1U << 14)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
@@ -406,7 +411,7 @@ struct io_sqring_offsets {
 	__u32 dropped;
 	__u32 array;
 	__u32 resv1;
-	__u64 resv2;
+	__u64 user_addr;
 };
 
 /*
@@ -425,7 +430,7 @@ struct io_cqring_offsets {
 	__u32 cqes;
 	__u32 flags;
 	__u32 resv1;
-	__u64 resv2;
+	__u64 user_addr;
 };
 
 /*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5433e8d6c481..fccc80c201fb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2709,12 +2709,85 @@ static void io_mem_free(void *ptr)
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
+	/*
+	 * Should be a single page. If the ring is small enough that we can
+	 * use a normal page, that is fine. If we need multiple pages, then
+	 * userspace should use a huge page. That's the only way to guarantee
+	 * that we get contigious memory, outside of just being lucky or
+	 * (currently) having low memory fragmentation.
+	 */
+	if (page_array[0] != page_array[ret - 1])
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
@@ -3359,6 +3432,10 @@ static void *io_uring_validate_mmap_request(struct file *file,
 	struct page *page;
 	void *ptr;
 
+	/* Don't allow mmap if the ring was setup without it */
+	if (ctx->flags & IORING_SETUP_NO_MMAP)
+		return ERR_PTR(-EINVAL);
+
 	switch (offset & IORING_OFF_MMAP_MASK) {
 	case IORING_OFF_SQ_RING:
 	case IORING_OFF_CQ_RING:
@@ -3694,7 +3771,11 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
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
 
@@ -3714,13 +3795,17 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
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
 
@@ -3906,7 +3991,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
 	p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
 	p->sq_off.resv1 = 0;
-	p->sq_off.resv2 = 0;
+	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
+		p->sq_off.user_addr = 0;
 
 	p->cq_off.head = offsetof(struct io_rings, cq.head);
 	p->cq_off.tail = offsetof(struct io_rings, cq.tail);
@@ -3916,7 +4002,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->cq_off.cqes = offsetof(struct io_rings, cqes);
 	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
 	p->cq_off.resv1 = 0;
-	p->cq_off.resv2 = 0;
+	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
+		p->cq_off.user_addr = 0;
 
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
@@ -3982,7 +4069,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
 			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
-			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN))
+			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
+			IORING_SETUP_NO_MMAP))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
-- 
2.39.2

