Return-Path: <io-uring+bounces-13236-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ONyfGSye+Wl9+QIAu9opvQ
	(envelope-from <io-uring+bounces-13236-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 05 May 2026 09:37:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0086E4C80E9
	for <lists+io-uring@lfdr.de>; Tue, 05 May 2026 09:37:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 35004300C01D
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2026 07:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAD983AC0CB;
	Tue,  5 May 2026 07:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="ewTlCDN6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3131ACEDF
	for <io-uring@vger.kernel.org>; Tue,  5 May 2026 07:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777966544; cv=none; b=HE41H59JSRSuYCU+wOAgeOV0+VDJY6rF5925XPvL8IwiFWFI0TbbvhSXgPg3C4lbpVOvI7prITK8jLyxdHvPt0twfPX55fcM7w5D03AODLH7dYGsygTwTxQdKEKlJjJ+WcHyW8ypRg5ovc4q/kxk4VkOfkO2DTZf1OP1rpjzyHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777966544; c=relaxed/simple;
	bh=qc021fYwSKUyL4AqpjXhLeqUdicDJZ/H/HjBua9XJ9Y=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=t8yJ3n5Z71p9QrSxLQUCseRJPByYOCVed7lreavAxoVVxGCofmysv5MrMtIXaDsiAXhYGgt9ZKEO8WnAVIBqjpJTqoy0FoI9GB8Fp4Jvs0m+o0mKAjZX4olh+QXU9qRIBThV11Z23NhYOQqziNoTR+Mm/jWaHkNay+HYcd54Ubw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=ewTlCDN6; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4896c22fcbaso36642745e9.0
        for <io-uring@vger.kernel.org>; Tue, 05 May 2026 00:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777966539; x=1778571339; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uE1FKieJNsNOlU6IvNt40/98H4AOkJFQWYanjQSC+9k=;
        b=ewTlCDN6Cw6wWEXdqJ6gqY2Exfpex9NisUONkyg5wLI3nBcxLihThgYGw7oWOi/Lku
         kqBXX5W0tEb822rTD0WG5wJgR7c1ZjA41Mfn6U6mpS6aYfrd3YdIl49+8bzgMQzr9sS+
         CPVIt9nS1c/OmuzcaHShDFTbdy280ON9MlGlKcOivAxhdULVCi3Hukb07Pr8eZEGswVS
         7k6z4UJXjwlbI3zsvbSEV2fHCFzqIe7wcnvyzItUUpv+1A/o/VfwmQQFGSUEkx4+NTdL
         yKyTrcKSFkbwdBbfK8UTSTPUaUMgnJ5C1mfXMwkI2d6pleciix5j3fhVg5Vf+qqrwAzM
         AtCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777966539; x=1778571339;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uE1FKieJNsNOlU6IvNt40/98H4AOkJFQWYanjQSC+9k=;
        b=EDR1fXwbC3MF2hhcTQxQLRconeFywD/oaO15wiqsFBX7Enr2QiaJXqTSvNg5p3ZZVn
         CRhdIpYPonZW81RDRgU5p51INnMIvSJch0he36Ot11TLWi3T6B2RxRp7/ZltGs7WBzjr
         tuNvgdLjAMMfyopyO/rRPPFfH8q9e5HzuIjAhEuvRsLbJfxkC/ACdA900Dn+yZ7oNKU/
         Y13Xeb+co5ja9UOapF+0PTDifZjb3HOo73D6dnCyjLKXdnXaG+gRSoUd8e4HlNvnfOUu
         QMoNiK7uHrZ+9eaYTlS7BoUJeJshz86v/OIY8h97GUB/6LUwtbSgoyJPksX2MVm7MT8i
         HruQ==
X-Gm-Message-State: AOJu0YwbqImc0o6fzjN0tyr3i0PvXhCEIGnPDVcRTfJ8BPaWUU4c8x8T
	mOJNgrpVpW/8MibSu48yLGssC2Y9z4M8nWRF/vgk3syycUOZvkkCI9ssFF9s3g3ymXwG4KZ2rw3
	IVd8bTcE=
X-Gm-Gg: AeBDieu9k6Aqg3hiL8yafVesjchv3npaudStLVBB4p5WVumcLwXZbtbwlfAO6sKKOhl
	WdRshjsEBdhbbyT/byu1ulMU061uXqm/foKapnV/6ZrxEWQDQMa99Oqrq7wf6gTT3s3UzPhr/lB
	korujHYD8XGsT2kdch/zxPZxlrJAF9Dfr6Nm82+uLL9QMPhVHr0auaUyCC51suFWZa+TVfOxneI
	0JhlnberLBCazatdRE7f88G9e8xq+8UmOP9zdUQiFzNP8YyHM9SOozvomLjE4k4kAPV+NvM4sie
	YIKJBL6xT7eQ1a4Sh3bbeku7Z8tegtsEJE4heXVHyE+xOq0PIKpzvekj0MfRTsOXVyrJZgQriWD
	GKN43bAgyEYCoC3svfdHFXjCWR9gDzq1BtltZQAs+qkZoCz8yPIn8yB8iyqC+vqPUqUb3YbjRIY
	lsv2bVmO0a6PG0EzuUlWdMYqBeaEk/UdPTW//jHulb3izOTq8hkWi8YUJ1LY0q02Xr/wOkaSZuw
	ozqkBiFqK2TWc5nE46NIQ7U9U5gvJw=
X-Received: by 2002:a05:600d:8453:b0:48a:5339:ef0e with SMTP id 5b1f17b1804b1-48a9852f5e7mr169156745e9.3.1777966539124;
        Tue, 05 May 2026 00:35:39 -0700 (PDT)
Received: from [10.211.9.173] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8eb3427fsm542802805e9.0.2026.05.05.00.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 00:35:38 -0700 (PDT)
Message-ID: <9c0097c2-d1de-493a-b193-7afc2200b5a6@kernel.dk>
Date: Tue, 5 May 2026 01:35:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@meta.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v4] io_uring/rsrc: add huge page accounting for registered
 buffers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0086E4C80E9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13236-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]

Track huge page references in a per-ring xarray to prevent double
accounting when the same huge page is used by multiple registered
buffers, either within the same ring or across cloned rings.

When registering buffers backed by huge pages, we need to account for
RLIMIT_MEMLOCK. But if multiple buffers share the same huge page (common
with cloned buffers), we must not account for the same page multiple
times. Similarly, we must only unaccount when the last reference to a
huge page is released.

Maintain a per-ring xarray (hpage_acct) that tracks reference counts for
each huge page. When registering a buffer, for each unique huge page,
increment its accounting reference count, and only account pages that
are newly added.

When unregistering a buffer, for each unique huge page, decrement its
refcount. Once the refcount hits zero, the page is unaccounted.

Note: any account is done against the ctx->user that was assigned when
the ring was setup. As before, if root is running the operation, no
accounting is done.

With these changes, any use of imu->acct_pages is also dead, hence kill
it from struct io_mapped_ubuf. This shrinks it from 56b to 48b on a
64-bit arch. Additionally, hpage_already_acct() is gone, which was an
O(M*M) scan over current + previous registrations.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Changes since v3:
- Code cleanups based on feedback from Clément

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 244392026c6d..23b8891d5704 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -446,6 +446,9 @@ struct io_ring_ctx {
 	/* Stores zcrx object pointers of type struct io_zcrx_ifq */
 	struct xarray			zcrx_ctxs;
 
+	/* Used for accounting references on pages in registered buffers */
+	struct xarray		hpage_acct;
+
 	u32			pers_next;
 	struct xarray		personalities;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ed998d60c09..fb6ed52bae61 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -233,6 +233,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		return NULL;
 
 	xa_init(&ctx->io_bl_xa);
+	xa_init(&ctx->hpage_acct);
 
 	/*
 	 * Use 5 bits less than the max cq entries, that should give us around
@@ -302,6 +303,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_free_alloc_caches(ctx);
 	kvfree(ctx->cancel_table.hbs);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_destroy(&ctx->hpage_acct);
 	kfree(ctx);
 	return NULL;
 }
@@ -2198,6 +2200,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_napi_free(ctx);
 	kvfree(ctx->cancel_table.hbs);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_destroy(&ctx->hpage_acct);
 	kfree(ctx);
 }
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 650303626be6..be7c5bf4e161 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -28,7 +28,52 @@ struct io_rsrc_update {
 };
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-			struct iovec *iov, struct page **last_hpage);
+						   struct iovec *iov);
+
+static int hpage_acct_ref(struct io_ring_ctx *ctx, struct page *hpage,
+			  bool *acct_new)
+{
+	unsigned long key = (unsigned long) hpage;
+	unsigned long count;
+	void *entry;
+	int ret;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	entry = xa_load(&ctx->hpage_acct, key);
+	if (entry) {
+		*acct_new = false;
+		count = xa_to_value(entry) + 1;
+	} else {
+		ret = xa_reserve(&ctx->hpage_acct, key, GFP_KERNEL_ACCOUNT);
+		if (ret)
+			return ret;
+		*acct_new = true;
+		count = 1;
+	}
+	xa_store(&ctx->hpage_acct, key, xa_mk_value(count), GFP_KERNEL_ACCOUNT);
+	return 0;
+}
+
+static bool hpage_acct_unref(struct io_ring_ctx *ctx, struct page *hpage)
+{
+	unsigned long key = (unsigned long) hpage;
+	unsigned long count;
+	void *entry;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	entry = xa_load(&ctx->hpage_acct, key);
+	if (WARN_ON_ONCE(!entry))
+		return false;
+	count = xa_to_value(entry);
+	if (count == 1) {
+		xa_erase(&ctx->hpage_acct, key);
+		return true;
+	}
+	xa_store(&ctx->hpage_acct, key, xa_mk_value(count - 1), GFP_KERNEL_ACCOUNT);
+	return false;
+}
 
 /* only define max */
 #define IORING_MAX_FIXED_FILES	(1U << 20)
@@ -124,15 +169,53 @@ static void io_free_imu(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 		kvfree(imu);
 }
 
+static unsigned long io_buffer_unaccount_pages(struct io_ring_ctx *ctx,
+					       struct io_mapped_ubuf *imu)
+{
+	struct page *seen = NULL;
+	unsigned long acct = 0;
+	int i;
+
+	if (imu->flags & IO_REGBUF_F_KBUF || !ctx->user)
+		return 0;
+
+	for (i = 0; i < imu->nr_bvecs; i++) {
+		struct page *page = imu->bvec[i].bv_page;
+		struct page *hpage;
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
+		/* Unaccount on last reference */
+		if (hpage_acct_unref(ctx, hpage))
+			acct += page_size(hpage) >> PAGE_SHIFT;
+		cond_resched();
+	}
+
+	return acct;
+}
+
 static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 {
+	unsigned long acct_pages = 0;
+
+	/* Always decrement, so it works for cloned buffers too */
+	acct_pages = io_buffer_unaccount_pages(ctx, imu);
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
@@ -282,7 +365,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 {
 	u64 __user *tags = u64_to_user_ptr(up->tags);
 	struct iovec fast_iov, *iov;
-	struct page *last_hpage = NULL;
 	struct iovec __user *uvec;
 	u64 user_data = up->data;
 	__u32 done;
@@ -307,7 +389,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			err = -EFAULT;
 			break;
 		}
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		node = io_sqe_buffer_register(ctx, iov);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
 			break;
@@ -605,76 +687,79 @@ int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 }
 
 /*
- * Not super efficient, but this is just a registration time. And we do cache
- * the last compound head, so generally we'll only do a full search if we don't
- * match that one.
- *
- * We check if the given compound head page has already been accounted, to
- * avoid double accounting it. This allows us to account the full size of the
- * page, not just the constituent pages of a huge page.
+ * Undo hpage_acct_ref() calls made during io_buffer_account_pin() on failure.
+ * This operates on the pages array since imu->bvec isn't populated yet.
  */
-static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
-				  int nr_pages, struct page *hpage)
+static void io_buffer_unaccount_hpages(struct io_ring_ctx *ctx,
+				       struct page **pages, int nr_pages)
 {
-	int i, j;
+	struct page *seen = NULL;
+	int i;
+
+	if (!ctx->user)
+		return;
 
-	/* check current page array */
 	for (i = 0; i < nr_pages; i++) {
+		struct page *hpage;
+
 		if (!PageCompound(pages[i]))
 			continue;
-		if (compound_head(pages[i]) == hpage)
-			return true;
-	}
-
-	/* check previously registered pages */
-	for (i = 0; i < ctx->buf_table.nr; i++) {
-		struct io_rsrc_node *node = ctx->buf_table.nodes[i];
-		struct io_mapped_ubuf *imu;
 
-		if (!node)
+		hpage = compound_head(pages[i]);
+		if (hpage == seen)
 			continue;
-		imu = node->buf;
-		for (j = 0; j < imu->nr_bvecs; j++) {
-			if (!PageCompound(imu->bvec[j].bv_page))
-				continue;
-			if (compound_head(imu->bvec[j].bv_page) == hpage)
-				return true;
-		}
-	}
+		seen = hpage;
 
-	return false;
+		hpage_acct_unref(ctx, hpage);
+		cond_resched();
+	}
 }
 
 static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
-				 int nr_pages, struct io_mapped_ubuf *imu,
-				 struct page **last_hpage)
+				 int nr_pages)
 {
+	unsigned long acct_pages = 0;
+	struct page *seen = NULL;
 	int i, ret;
 
-	imu->acct_pages = 0;
+	if (!ctx->user)
+		return 0;
+
 	for (i = 0; i < nr_pages; i++) {
+		struct page *hpage;
+		bool acct_new;
+
 		if (!PageCompound(pages[i])) {
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
+			acct_pages++;
+			continue;
+		}
+
+		hpage = compound_head(pages[i]);
+		if (hpage == seen)
+			continue;
+		seen = hpage;
+
+		ret = hpage_acct_ref(ctx, hpage, &acct_new);
+		if (ret) {
+			io_buffer_unaccount_hpages(ctx, pages, i);
+			return ret;
 		}
+		if (acct_new)
+			acct_pages += page_size(hpage) >> PAGE_SHIFT;
+		cond_resched();
 	}
 
-	if (!imu->acct_pages)
-		return 0;
+	/* Try to account the memory */
+	if (acct_pages) {
+		ret = io_account_mem(ctx->user, ctx->mm_account, acct_pages);
+		if (ret) {
+			/* Undo the refs we just added */
+			io_buffer_unaccount_hpages(ctx, pages, nr_pages);
+			return ret;
+		}
+	}
 
-	ret = io_account_mem(ctx->user, ctx->mm_account, imu->acct_pages);
-	if (ret)
-		imu->acct_pages = 0;
-	return ret;
+	return 0;
 }
 
 static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
@@ -763,8 +848,7 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 }
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-						   struct iovec *iov,
-						   struct page **last_hpage)
+						   struct iovec *iov)
 {
 	struct io_mapped_ubuf *imu = NULL;
 	struct page **pages = NULL;
@@ -811,7 +895,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		goto done;
 
 	imu->nr_bvecs = nr_pages;
-	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
+	ret = io_buffer_account_pin(ctx, pages, nr_pages);
 	if (ret)
 		goto done;
 
@@ -861,7 +945,6 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned int nr_args, u64 __user *tags)
 {
-	struct page *last_hpage = NULL;
 	struct io_rsrc_data data;
 	struct iovec fast_iov, *iov = &fast_iov;
 	const struct iovec __user *uvec;
@@ -904,7 +987,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			}
 		}
 
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		node = io_sqe_buffer_register(ctx, iov);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
 			break;
@@ -971,7 +1054,6 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 
 	imu->ubuf = 0;
 	imu->len = blk_rq_bytes(rq);
-	imu->acct_pages = 0;
 	imu->folio_shift = PAGE_SHIFT;
 	refcount_set(&imu->refs, 1);
 	imu->release = release;
@@ -1136,6 +1218,56 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
 }
 
+static int io_buffer_acct_cloned_hpages(struct io_ring_ctx *ctx,
+					struct io_mapped_ubuf *imu)
+{
+	struct page *seen = NULL;
+	int i, ret = 0;
+
+	if (imu->flags & IO_REGBUF_F_KBUF || !ctx->user)
+		return 0;
+
+	for (i = 0; i < imu->nr_bvecs; i++) {
+		struct page *page = imu->bvec[i].bv_page;
+		struct page *hpage;
+		bool acct_new;
+
+		if (!PageCompound(page))
+			continue;
+
+		hpage = compound_head(page);
+		if (hpage == seen)
+			continue;
+		seen = hpage;
+
+		/* Atomically add reference for cloned buffer */
+		ret = hpage_acct_ref(ctx, hpage, &acct_new);
+		if (ret)
+			break;
+
+		cond_resched();
+	}
+
+	if (!ret)
+		return 0;
+
+	/* Undo refs we added for bvecs [0..i) */
+	seen = NULL;
+	for (int j = 0; j < i; j++) {
+		struct page *p = imu->bvec[j].bv_page;
+		struct page *hp;
+
+		if (!PageCompound(p))
+			continue;
+		hp = compound_head(p);
+		if (hp == seen)
+			continue;
+		seen = hp;
+		hpage_acct_unref(ctx, hp);
+	}
+	return ret;
+}
+
 /* Lock two rings at once. The rings must be different! */
 static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
 {
@@ -1218,6 +1350,14 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 
 			refcount_inc(&src_node->buf->refs);
 			dst_node->buf = src_node->buf;
+			/* track compound references to clones */
+			ret = io_buffer_acct_cloned_hpages(ctx, src_node->buf);
+			if (ret) {
+				refcount_dec(&src_node->buf->refs);
+				io_cache_free(&ctx->node_cache, dst_node);
+				io_rsrc_data_free(ctx, &data);
+				return ret;
+			}
 		}
 		data.nodes[off++] = dst_node;
 		i++;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 44e3386f7c1c..c0f8a18ec767 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -38,7 +38,6 @@ struct io_mapped_ubuf {
 	unsigned int	nr_bvecs;
 	unsigned int    folio_shift;
 	refcount_t	refs;
-	unsigned long	acct_pages;
 	void		(*release)(void *);
 	void		*priv;
 	u8		flags;

-- 
Jens Axboe


