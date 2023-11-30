Return-Path: <io-uring+bounces-175-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BF927FFBBC
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 20:46:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C14B2282801
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 19:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1640C53E0D;
	Thu, 30 Nov 2023 19:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YpP0Tl5p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B99DD5C
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:46 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-35c683417f1so1093855ab.0
        for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701373605; x=1701978405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hxeP5jSRRX1HG4Q7VF5uTV5vDunsnLEvK5wo5+KXwMg=;
        b=YpP0Tl5pAtrtu6Ltuw5syOoZYFCOax/w/1It8VueVa15f3z5QsuRpnhXCvQP3vNGTa
         ZShsVmDUJe+C984NeZ20hSCiK1o4gc/3s2XgkyIINZbgbTeCpgksgEXBMek1y++vi5Pn
         akH2z5Lj9SJtVZM0F8U0n6HznlKT2Bo/eFW7OZsA0/8JhkQCJzYLo41nwluijOnw1Fso
         sHIttV9kEnBz0FPjB238RZ98/+qzsoYjyZTxjnpETY0u9t/p0Q+IMgrtL12SRSx0nvJY
         T0qilMKcQ1LGvvDyIhzcDJOyuRFrk/YaEnkdOZc4t04kRek4boEFY+gLlqMtUi4GFO/I
         p/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701373605; x=1701978405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hxeP5jSRRX1HG4Q7VF5uTV5vDunsnLEvK5wo5+KXwMg=;
        b=iglfQqLFornJi1qc/da/wSMLClFGO9KqRNvbD3MNcssq/pJA2XMR+8fOiFRcyaEYFl
         Vh7UkOcS3+DDGXIl+aXcyKfeG/kY+wQeOfTfl6/zNRLIbQHjGvWMqy+RYw5VU2N/iLQY
         /sF3TvN0dkYy0fHxBY9KsVWoGLymCO1NTjKJwCKuWPG02nTTwcAt8lZOh43mXUUNSofY
         GqttNKUL5NMP6QtHF59yN+LFQ2Oe58l3xExOzfQgcX6vX9311pbwoS08HK4+v33V2vm+
         i3m+/9URRStOUl3uCLKkM+RMIwAnn3ULm40PrApFl1jvztjLykD4qtRYVqiprI6aUl8W
         oDEw==
X-Gm-Message-State: AOJu0YxhzCehQj4UUOqeIFJL9l14nWcWCyILP6o6WC70sNSftFJ82X5T
	ZP6dDKqX1KJz19Uq0Z6W1auyLWaz0SeMVfGsMkHuJw==
X-Google-Smtp-Source: AGHT+IGsIkCPSEw70Evsd2pxr6HUEd73RHYUxadc7Yk55VL/36orPOUQVAZ/dKVmJRfgw7e4/50weg==
X-Received: by 2002:a6b:660f:0:b0:7b3:58c4:b894 with SMTP id a15-20020a6b660f000000b007b358c4b894mr20263864ioc.1.1701373604903;
        Thu, 30 Nov 2023 11:46:44 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a18-20020a029f92000000b004667167d8cdsm461179jam.116.2023.11.30.11.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:46:43 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org,
	Jann Horn <jannh@google.com>
Subject: [PATCH 4/8] io_uring/kbuf: defer release of mapped buffer rings
Date: Thu, 30 Nov 2023 12:45:50 -0700
Message-ID: <20231130194633.649319-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231130194633.649319-1-axboe@kernel.dk>
References: <20231130194633.649319-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a provided buffer ring is setup with IOU_PBUF_RING_MMAP, then the
kernel allocates the memory for it and the application is expected to
mmap(2) this memory. However, io_uring uses remap_pfn_range() for this
operation, so we cannot rely on normal munmap/release on freeing them
for us.

Stash an io_buf_free entry away for each of these, if any, and provide
a helper to free them post ->release().

Cc: stable@vger.kernel.org
Fixes: c56e022c0a27 ("io_uring: add support for user mapped provided buffer ring")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/io_uring.c            |  2 ++
 io_uring/kbuf.c                | 44 ++++++++++++++++++++++++++++++----
 io_uring/kbuf.h                |  2 ++
 4 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index d3009d56af0b..805bb635cdf5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -340,6 +340,9 @@ struct io_ring_ctx {
 
 	struct list_head	io_buffers_cache;
 
+	/* deferred free list, protected by ->uring_lock */
+	struct hlist_head	io_buf_list;
+
 	/* Keep this last, we don't need it for the fast path */
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e40b11438210..3a216f0744dd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -325,6 +325,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
+	INIT_HLIST_HEAD(&ctx->io_buf_list);
 	io_alloc_cache_init(&ctx->rsrc_node_cache, IO_NODE_ALLOC_CACHE_MAX,
 			    sizeof(struct io_rsrc_node));
 	io_alloc_cache_init(&ctx->apoll_cache, IO_ALLOC_CACHE_MAX,
@@ -2950,6 +2951,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		ctx->mm_account = NULL;
 	}
 	io_rings_free(ctx);
+	io_kbuf_mmap_list_free(ctx);
 
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index a1e4239c7d75..85e680fc74ce 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -33,6 +33,11 @@ struct io_provide_buf {
 	__u16				bid;
 };
 
+struct io_buf_free {
+	struct hlist_node		list;
+	void				*mem;
+};
+
 static inline struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
 							unsigned int bgid)
 {
@@ -223,7 +228,10 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	if (bl->is_mapped) {
 		i = bl->buf_ring->tail - bl->head;
 		if (bl->is_mmap) {
-			folio_put(virt_to_folio(bl->buf_ring));
+			/*
+			 * io_kbuf_list_free() will free the page(s) at
+			 * ->release() time.
+			 */
 			bl->buf_ring = NULL;
 			bl->is_mmap = 0;
 		} else if (bl->buf_nr_pages) {
@@ -531,18 +539,28 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	return -EINVAL;
 }
 
-static int io_alloc_pbuf_ring(struct io_uring_buf_reg *reg,
+static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
+			      struct io_uring_buf_reg *reg,
 			      struct io_buffer_list *bl)
 {
-	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
+	struct io_buf_free *ibf;
 	size_t ring_size;
 	void *ptr;
 
 	ring_size = reg->ring_entries * sizeof(struct io_uring_buf_ring);
-	ptr = (void *) __get_free_pages(gfp, get_order(ring_size));
+	ptr = io_mem_alloc(ring_size);
 	if (!ptr)
 		return -ENOMEM;
 
+	/* Allocate and store deferred free entry */
+	ibf = kmalloc(sizeof(*ibf), GFP_KERNEL_ACCOUNT);
+	if (!ibf) {
+		io_mem_free(ptr);
+		return -ENOMEM;
+	}
+	ibf->mem = ptr;
+	hlist_add_head(&ibf->list, &ctx->io_buf_list);
+
 	bl->buf_ring = ptr;
 	bl->is_mapped = 1;
 	bl->is_mmap = 1;
@@ -599,7 +617,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (!(reg.flags & IOU_PBUF_RING_MMAP))
 		ret = io_pin_pbuf_ring(&reg, bl);
 	else
-		ret = io_alloc_pbuf_ring(&reg, bl);
+		ret = io_alloc_pbuf_ring(ctx, &reg, bl);
 
 	if (!ret) {
 		bl->nr_entries = reg.ring_entries;
@@ -649,3 +667,19 @@ void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
 
 	return bl->buf_ring;
 }
+
+/*
+ * Called at or after ->release(), free the mmap'ed buffers that we used
+ * for memory mapped provided buffer rings.
+ */
+void io_kbuf_mmap_list_free(struct io_ring_ctx *ctx)
+{
+	struct io_buf_free *ibf;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry_safe(ibf, tmp, &ctx->io_buf_list, list) {
+		hlist_del(&ibf->list);
+		io_mem_free(ibf->mem);
+		kfree(ibf);
+	}
+}
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index f2d615236b2c..6c7646e6057c 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -51,6 +51,8 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags);
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 
+void io_kbuf_mmap_list_free(struct io_ring_ctx *ctx);
+
 unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
-- 
2.42.0


