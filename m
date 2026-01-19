Return-Path: <io-uring+bounces-11815-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 973C0D3B3FF
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 18:22:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 214DA30C8CF9
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 17:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC17930E0FD;
	Mon, 19 Jan 2026 17:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2G9JhZ7e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f68.google.com (mail-oa1-f68.google.com [209.85.160.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA362EB85E
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 17:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768842227; cv=none; b=gty+eWSqdQMc24GyrQ86HNotoaufWo2leeK6LAgBX15xaTigLjnfbwWaHlLuAPxM11nm/HQuTwcURscwsED+UgPSzD4FANjqcJKYC6433QBI+VKkD5JfxavjDzFn6CMbSPBQcINOBfh4TTR3HUWn8VJYOwLQl0hs6y7tbOuie08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768842227; c=relaxed/simple;
	bh=dDzM+ng+eQ+NaQ/ZAcv0JwSDfcFLDtCFd4pVO2Vq7rc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C4G1RpWoCI7pPTR1OAKHUu9smOiH6UH+/eykTx4FTvNxYnNtUbj8kNMB0k0ryleIRktjm7gWkWx3gY1GruDVfOqcwUY+WvNriDF12uIJTvNfyCH/Tr3ii6WJOwuYXBiVETsis8PVz3BLqyCygaE2c1meJ85arOVEG0wItK1VQq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2G9JhZ7e; arc=none smtp.client-ip=209.85.160.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f68.google.com with SMTP id 586e51a60fabf-404308dd5d6so1892048fac.1
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 09:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768842224; x=1769447024; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0gRZKzH2yaGYcvrmWWUn6MNoiwik1prNysONcHiprrI=;
        b=2G9JhZ7eIPYEOqokagvbzqyXLCYq07S+yvMX2XMNSLRV9GnfCpelAi6ZB361Isjpt9
         DHZBQQgAnbnaQZcH3we07aXI66ku+kkshoYU0ZpRaZLiLsBw3xxhss3Iv9TGGEEoxsoH
         cUO7a7oSbUuV8ht75JWc7VDCZUyu0+Vr42SIt8fTORPmouEh3ys09tFHwfI/sYnRC7fR
         M1LUnGdmgsc43T4144Rdvrclkle7VkrnOOvTxLbGgekrh7dP+j22Mctu8R56IoXNitpu
         aWhrX/zQ4vbMBZrvjDd5Vcv//LGVXkNL7efd1+0LMf05kHhJIH2wBziM5HRBffQQ/UWX
         a4LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768842224; x=1769447024;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0gRZKzH2yaGYcvrmWWUn6MNoiwik1prNysONcHiprrI=;
        b=p9/CefCByN9mN4/+rfefVr93nCckY8flqz0383U/EverX+JZ8Xl2V0BSNva1pmjuGr
         Y/PyqlC4cHA8/1bI0uGQq/RIRn8npaiYW/GcStDqsKvKKNj8ReT7MXtaJMOmroUXm6Xd
         LXVHu75G5P36KfIZhQBgyOMEMeBaE5VZ/6nucyUCgLKce8RDswyBmBVoao3w4b2RsDTY
         koB+8EjE0rMjRyfXp2gd6FIzSwT8ANzu1pqWbckT7dzG0M1fBioutUTAYsltTE0Nqtpu
         Ul0zU97bUAlrqrjf1hkVCaiwhCI0LLUuN+fiBpz5nL5IcyxAfMnBM8Sylpz5DQ97vLFF
         Muqg==
X-Gm-Message-State: AOJu0YzGvt4bfzl62OYyS/08jbItC0Ns1kRmZ26oJYRHhCMqReRuSNod
	ShojzcW3/GlQowK0Uhcocw3Sep5Dt1qAZApXxIXWrnxYyKfKXD6YW1G5jbjaG4kzpjM=
X-Gm-Gg: AZuq6aKMeNGzpTz9ApVjisrTko/cv/5sAoxQjxatFD+X4wD4WdDRVpVxhSJaSSfTk0y
	oqRlgo31MepUTlP9sMOXNmfzyM3tzW+0sbRIqNcfGA28pmB8QfQbH0hbjXIT7pDIATFoI9vvf73
	q5ti5fGGvkU63hzIrVEWx5cSuVqVz4lSqPjEGj2em6GJJysQQr9UR6wp6f9Aod5ftiKtZfaYIl8
	YunUTExnrYBhBsk3BFTEYdqGc56srcQSjZ2z+WgmBGMEFlwWeCfZrvkT37t4S51kf31TO3TwpP3
	eFLKTp123tgz0VUR0FF7hRxNlRKA3486PwkOWODU7s/1cShm6PhBGZkeast7du02OXXEcx+hEy5
	pYymsegAj22jwN/t1EPDK5isWalH4sAEL9UBaX4TKj3cGzJ1sp525VDHdy2BVQFJN4awsShYVKM
	89gw8vfOUKgEfQ7kgn2HZlxl6RTFOxPl27JxUNs/ENHvyqolXFQJgqI/SsmVsYtkpu5aShZcDmA
	p1D7EQi
X-Received: by 2002:a05:6871:60f:b0:3d3:4338:bbab with SMTP id 586e51a60fabf-4044ce3b320mr5254952fac.18.1768842223873;
        Mon, 19 Jan 2026 09:03:43 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044baf38f4sm6985223fac.1.2026.01.19.09.03.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 09:03:43 -0800 (PST)
Message-ID: <bc2e8ec1-8809-4603-9519-788cfff2ae12@kernel.dk>
Date: Mon, 19 Jan 2026 10:03:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
To: Yuhao Jiang <danisjiang@gmail.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260119071039.2113739-1-danisjiang@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260119071039.2113739-1-danisjiang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/19/26 12:10 AM, Yuhao Jiang wrote:
> The trade-off is that memory accounting may be overestimated when
> multiple buffers share compound pages, but this is safe and prevents
> the security issue.

I'd be worried that this would break existing setups. We obviously need
to get the unmap accounting correct, but in terms of practicality, any
user of registered buffers will have had to bump distro limits manually
anyway, and in that case it's usually just set very high. Otherwise
there's very little you can do with it.

How about something else entirely - just track the accounted pages on
the side. If we ref those, then we can ensure that if a huge page is
accounted, it's only unaccounted when all existing "users" of it have
gone away. That means if you drop parts of it, it'll remain accounted.

Something totally untested like the below... Yes it's not a trivial
amount of code, but it is actually fairly trivial code.

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index a3e8ddc9b380..bd92c01f4401 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -423,6 +423,7 @@ struct io_ring_ctx {
 	/* Only used for accounting purposes */
 	struct user_struct		*user;
 	struct mm_struct		*mm_account;
+	struct xarray			hpage_acct;
 
 	/*
 	 * List of tctx nodes for this ctx, protected by tctx_lock. For
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b7a077c11c21..9e810d4f872c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -292,6 +292,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		return NULL;
 
 	xa_init(&ctx->io_bl_xa);
+	xa_init(&ctx->hpage_acct);
 
 	/*
 	 * Use 5 bits less than the max cq entries, that should give us around
@@ -361,6 +362,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_free_alloc_caches(ctx);
 	kvfree(ctx->cancel_table.hbs);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_destroy(&ctx->hpage_acct);
 	kfree(ctx);
 	return NULL;
 }
@@ -2880,6 +2882,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_napi_free(ctx);
 	kvfree(ctx->cancel_table.hbs);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_destroy(&ctx->hpage_acct);
 	kfree(ctx);
 }
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 41c89f5c616d..a2ee8840b479 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -28,7 +28,7 @@ struct io_rsrc_update {
 };
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-			struct iovec *iov, struct page **last_hpage);
+						   struct iovec *iov);
 
 /* only define max */
 #define IORING_MAX_FIXED_FILES	(1U << 20)
@@ -139,15 +139,75 @@ static void io_free_imu(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 		kvfree(imu);
 }
 
+/*
+ * Loop pages in this imu, and drop a reference to the accounted page
+ * in the ->hpage_acct xarray. If ours is the last reference, kill
+ * the entry and return pages to unaccount.
+ */
+static unsigned long io_buffer_unmap_pages(struct io_ring_ctx *ctx,
+					   struct io_mapped_ubuf *imu)
+{
+	struct page *seen = NULL;
+	unsigned long acct = 0;
+	int i;
+
+	/* Kernel buffers don't participate in RLIMIT_MEMLOCK accounting */
+	if (imu->is_kbuf)
+		return 0;
+
+	for (i = 0; i < imu->nr_bvecs; i++) {
+		struct page *page = imu->bvec[i].bv_page;
+		struct page *hpage;
+		unsigned long key;
+		void *entry;
+		unsigned long count;
+
+		if (!PageCompound(page)) {
+			acct++;
+			continue;
+		}
+
+		hpage = compound_head(page);
+		if (hpage == seen)
+			continue;
+		seen = hpage;
+
+		key = (unsigned long) hpage;
+		entry = xa_load(&ctx->hpage_acct, key);
+		if (!entry) {
+			/* can't happen... */
+			WARN_ON_ONCE(1);
+			continue;
+		}
+
+		count = xa_to_value(entry);
+		if (count == 1) {
+			/* Last reference in this ctx, remove from xarray */
+			xa_erase(&ctx->hpage_acct, key);
+			acct += page_size(hpage) >> PAGE_SHIFT;
+		} else {
+			xa_store(&ctx->hpage_acct, key,
+				 xa_mk_value(count - 1), GFP_KERNEL);
+		}
+	}
+
+	return acct;
+}
+
 static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 {
+	unsigned long acct_pages;
+
+	/* Always decrement, so it works for cloned buffers too */
+	acct_pages = io_buffer_unmap_pages(ctx, imu);
+
 	if (unlikely(refcount_read(&imu->refs) > 1)) {
 		if (!refcount_dec_and_test(&imu->refs))
 			return;
 	}
 
-	if (imu->acct_pages)
-		io_unaccount_mem(ctx->user, ctx->mm_account, imu->acct_pages);
+	if (acct_pages)
+		io_unaccount_mem(ctx->user, ctx->mm_account, acct_pages);
 	imu->release(imu->priv);
 	io_free_imu(ctx, imu);
 }
@@ -294,7 +354,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 {
 	u64 __user *tags = u64_to_user_ptr(up->tags);
 	struct iovec fast_iov, *iov;
-	struct page *last_hpage = NULL;
 	struct iovec __user *uvec;
 	u64 user_data = up->data;
 	__u32 done;
@@ -322,7 +381,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		err = io_buffer_validate(iov);
 		if (err)
 			break;
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		node = io_sqe_buffer_register(ctx, iov);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
 			break;
@@ -619,77 +678,69 @@ int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 	return 0;
 }
 
-/*
- * Not super efficient, but this is just a registration time. And we do cache
- * the last compound head, so generally we'll only do a full search if we don't
- * match that one.
- *
- * We check if the given compound head page has already been accounted, to
- * avoid double accounting it. This allows us to account the full size of the
- * page, not just the constituent pages of a huge page.
- */
-static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
-				  int nr_pages, struct page *hpage)
+static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
+				 int nr_pages, struct io_mapped_ubuf *imu)
 {
-	int i, j;
+	struct page *seen = NULL;
+	int i, ret;
 
-	/* check current page array */
+	imu->acct_pages = 0;
+
+	/* First pass: calculate pages to account */
 	for (i = 0; i < nr_pages; i++) {
-		if (!PageCompound(pages[i]))
+		struct page *hpage;
+		unsigned long key;
+
+		if (!PageCompound(pages[i])) {
+			imu->acct_pages++;
 			continue;
-		if (compound_head(pages[i]) == hpage)
-			return true;
-	}
+		}
 
-	/* check previously registered pages */
-	for (i = 0; i < ctx->buf_table.nr; i++) {
-		struct io_rsrc_node *node = ctx->buf_table.nodes[i];
-		struct io_mapped_ubuf *imu;
+		hpage = compound_head(pages[i]);
+		if (hpage == seen)
+			continue;
+		seen = hpage;
 
-		if (!node)
+		/* Check if already tracked globally */
+		key = (unsigned long) hpage;
+		if (xa_load(&ctx->hpage_acct, key))
 			continue;
-		imu = node->buf;
-		for (j = 0; j < imu->nr_bvecs; j++) {
-			if (!PageCompound(imu->bvec[j].bv_page))
-				continue;
-			if (compound_head(imu->bvec[j].bv_page) == hpage)
-				return true;
+
+		imu->acct_pages += page_size(hpage) >> PAGE_SHIFT;
+	}
+
+	/* Try to account the memory */
+	if (imu->acct_pages) {
+		ret = io_account_mem(ctx->user, ctx->mm_account, imu->acct_pages);
+		if (ret) {
+			imu->acct_pages = 0;
+			return ret;
 		}
 	}
 
-	return false;
-}
+	/* Second pass: update xarray refcounts */
+	seen = NULL;
+	for (i = 0; i < nr_pages; i++) {
+		struct page *hpage;
+		unsigned long key;
+		void *entry;
+		unsigned long count;
 
-static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
-				 int nr_pages, struct io_mapped_ubuf *imu,
-				 struct page **last_hpage)
-{
-	int i, ret;
+		if (!PageCompound(pages[i]))
+			continue;
 
-	imu->acct_pages = 0;
-	for (i = 0; i < nr_pages; i++) {
-		if (!PageCompound(pages[i])) {
-			imu->acct_pages++;
-		} else {
-			struct page *hpage;
-
-			hpage = compound_head(pages[i]);
-			if (hpage == *last_hpage)
-				continue;
-			*last_hpage = hpage;
-			if (headpage_already_acct(ctx, pages, i, hpage))
-				continue;
-			imu->acct_pages += page_size(hpage) >> PAGE_SHIFT;
-		}
-	}
+		hpage = compound_head(pages[i]);
+		if (hpage == seen)
+			continue;
+		seen = hpage;
 
-	if (!imu->acct_pages)
-		return 0;
+		key = (unsigned long) hpage;
+		entry = xa_load(&ctx->hpage_acct, key);
+		count = entry ? xa_to_value(entry) + 1 : 1;
+		xa_store(&ctx->hpage_acct, key, xa_mk_value(count), GFP_KERNEL);
+	}
 
-	ret = io_account_mem(ctx->user, ctx->mm_account, imu->acct_pages);
-	if (ret)
-		imu->acct_pages = 0;
-	return ret;
+	return 0;
 }
 
 static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
@@ -778,8 +829,7 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 }
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-						   struct iovec *iov,
-						   struct page **last_hpage)
+						   struct iovec *iov)
 {
 	struct io_mapped_ubuf *imu = NULL;
 	struct page **pages = NULL;
@@ -817,7 +867,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		goto done;
 
 	imu->nr_bvecs = nr_pages;
-	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
+	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu);
 	if (ret)
 		goto done;
 
@@ -867,7 +917,6 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned int nr_args, u64 __user *tags)
 {
-	struct page *last_hpage = NULL;
 	struct io_rsrc_data data;
 	struct iovec fast_iov, *iov = &fast_iov;
 	const struct iovec __user *uvec;
@@ -913,7 +962,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			}
 		}
 
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		node = io_sqe_buffer_register(ctx, iov);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
 			break;
@@ -1152,6 +1201,38 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
 }
 
+static void io_buffer_add_cloned_hpages(struct io_ring_ctx *ctx,
+					struct io_mapped_ubuf *imu)
+{
+	struct page *seen = NULL;
+	int i;
+
+	if (imu->is_kbuf)
+		return;
+
+	for (i = 0; i < imu->nr_bvecs; i++) {
+		struct page *page = imu->bvec[i].bv_page;
+		struct page *hpage;
+		unsigned long key;
+		void *entry;
+		unsigned long count;
+
+		if (!PageCompound(page))
+			continue;
+
+		hpage = compound_head(page);
+		if (hpage == seen)
+			continue;
+		seen = hpage;
+
+		/* Add or increment entry in destination context's hpage_acct */
+		key = (unsigned long) hpage;
+		entry = xa_load(&ctx->hpage_acct, key);
+		count = entry ? xa_to_value(entry) + 1 : 1;
+		xa_store(&ctx->hpage_acct, key, xa_mk_value(count), GFP_KERNEL);
+	}
+}
+
 /* Lock two rings at once. The rings must be different! */
 static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
 {
@@ -1234,6 +1315,8 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 
 			refcount_inc(&src_node->buf->refs);
 			dst_node->buf = src_node->buf;
+			/* track compound references to clones */
+			io_buffer_add_cloned_hpages(ctx, src_node->buf);
 		}
 		data.nodes[off++] = dst_node;
 		i++;

-- 
Jens Axboe

