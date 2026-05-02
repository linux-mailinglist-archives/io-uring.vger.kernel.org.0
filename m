Return-Path: <io-uring+bounces-13203-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Y70DgNi9WkeKwIAu9opvQ
	(envelope-from <io-uring+bounces-13203-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 04:31:31 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 17EBB4B0B02
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 04:31:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5EBA43008CAB
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2026 02:31:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EE0440DFC5;
	Sat,  2 May 2026 02:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="AodqPRfy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9702B40DFBE
	for <io-uring@vger.kernel.org>; Sat,  2 May 2026 02:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777689085; cv=none; b=rMaLf0PmXZPPVUwnSjdoNnxL/sl5/qVIquKU5j14Hi/ob1E8yelHnbdevB1ybLbgWGtuZOoVHX0UkP3kpdBfIkW3JQ2VN8uCKMyHOSwWBETeXkcHzX6U6TRDQ2wCsIkXfl4dT+mNi/tONEJ21t/9F1D3cThUb4VNTtwB9D6+LKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777689085; c=relaxed/simple;
	bh=ttrGHbUsGm1z7kiw0g/3Aj+Yv3QG6AtSVS7bV1TyzXo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=NesM8mSRvQoeudSIxOy5Kc7+4UkqRUwVPg4ySvAWaJmGgatn+vsSAkjQDn0qum/BsdocThsPtBlVhgQ1RtV3sys8fntCg1tYTtimrwfeahoVk34uhYDZQzpTuA3lndhJkwmbe6ARnZciQbtamBg3oIUVVL5/FgtQHcDYnYuaJ7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=AodqPRfy; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-463f00cda04so1260724b6e.2
        for <io-uring@vger.kernel.org>; Fri, 01 May 2026 19:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777689081; x=1778293881; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=erUJKVwCjqkVbWP9mBREswJmsr8l3gmW+6BsSEipSY0=;
        b=AodqPRfyNLAWn/m7ZnEqcXMq/oND+T5I3U/o750kkXsjAG2z2RiGB5E34/HkxPmHkt
         hnkYUUOp82h0vUKbK1QWoZPrRsM5RRL3RLRsR3f/3lUdmP5veE91SXgunHUeeZ8h99Fx
         NmwhADB+6IBRzlldyHqWW5ulV9p/Y2hy2RWkR54j/tPTxGjiBjktDR1BxhwAb0T6kgre
         FsPbNeIXrilduDYJUWLewtP3/54ZgJ0Fbl2BmHgaB4JGHTrndF7xtn15cxqHrFHEnLo0
         ZVQua25jh3CG6AgPr/+QKNeA7HniYNMy/MNPS+WqZXa5WJv9cFw4vsvrmYdY8I0jtKFv
         inbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777689081; x=1778293881;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=erUJKVwCjqkVbWP9mBREswJmsr8l3gmW+6BsSEipSY0=;
        b=NGvg9zaiI5vDzHiSwRyDc95+m6u3TPNch4XzUdCa7dbDPWW7izmZXLQisn0kaiVByy
         MKWF/ntYEALsElM5co9qtkKQNODTjkvBL9+m/hZQMe4b4lcuXnY2faEaplc8dnjWu7uc
         5BeaQUJWq8KQnAKiwLQMn8h9fukfFkdaygFZeIqRL4s6miM62PgG36Pd5k3Cpj+bIUz/
         Gy34Twj3kkFZ9fEFTbHI6yTHxk1p7x/aCV6AjEuTcesSawN7Zp1bKFlzNIvnyC0/4CdH
         kHLu87+3NqLC/S8dbFMPHtwQ87PnMExmGjPlsFQuh1ROHxmtYFtR0QZOnTWgnykOE+wa
         TEvA==
X-Gm-Message-State: AOJu0YxS0AGhXnI9z5Jz1AiM0Dw7uBwV9gu2QUJXVfX93vBiL98/L9aM
	0+uBACj+6aKqfAuNNIJ+7nlNsDp8Ybj6yUDeuII+okaPrRTwcA0iz0SxwAZ32u2KFjkOUpJzD4f
	GnYty
X-Gm-Gg: AeBDieuL65S/mDFpekp4aDd9mvw/Bk4ku/rjmXhL1/eoCzyhPP7SIMf1UMqxH1gqOYu
	kPEQkjeoYbjV8E7vVc587yldiWS77VG9+Iz7HgMrTfWIGK15XTa9jy8RvqgOtmejXrdxEMvJ7wS
	k9yPC1NgdY3w/PzhJppXqiXyMGtuhNJsSyOQMDdjB6uQzG+HcGonhQwD+93l2/YXPsmdcdxP7Om
	Tn6zqsnX5Xwk6sRx36l4Br4lnFnOgSpenk7Wh3gSLTwKrEc024QnmW6dU5rancoG7XN/ZRIbg+D
	jLt3IGlmSS7QR7+o2XlkiSuDyK/Vnaay9EH8fB8ssIViUtN3CtmcWnjfYeh74IR2gyq4fWlKux+
	0jURf+zU7FyGgQuw8IvlRZGKWH+flRxYYWxude+f4BKCaJKwlDGZ1dfJha3YKEraZVoqRy3cRq1
	oEiQCsR7tWS0/FPPEPEtynIBobfTDZ+3Prx4fqrc7PSyt4N6XWR+5/Or3j2+JMA70+4TfsDyV2X
	L6mVaTilddiFl935dnr
X-Received: by 2002:a05:6808:11c6:b0:47c:3640:c5c1 with SMTP id 5614622812f47-47c88fdb3d3mr943775b6e.14.1777689080858;
        Fri, 01 May 2026 19:31:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c76986404sm2345755b6e.15.2026.05.01.19.31.19
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2026 19:31:19 -0700 (PDT)
Message-ID: <d377141e-064e-48a2-9a76-8477a90e8655@kernel.dk>
Date: Fri, 1 May 2026 20:31:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3] io_uring/rsrc: add huge page accounting for registered
 buffers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 17EBB4B0B02
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13203-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email]

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

See previous discussions here:

https://lore.kernel.org/io-uring/20260119071039.2113739-1-danisjiang@gmail.com/

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
index 650303626be6..ca22e07245c4 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -28,7 +28,51 @@ struct io_rsrc_update {
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
+	if (!entry) {
+		ret = xa_reserve(&ctx->hpage_acct, key, GFP_KERNEL_ACCOUNT);
+		if (ret)
+			return ret;
+	}
+
+	count = 1;
+	if (entry)
+		count = xa_to_value(entry) + 1;
+	xa_store(&ctx->hpage_acct, key, xa_mk_value(count), GFP_KERNEL_ACCOUNT);
+	*acct_new = (count == 1);
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
+	if (count == 1)
+		xa_erase(&ctx->hpage_acct, key);
+	else
+		xa_store(&ctx->hpage_acct, key, xa_mk_value(count - 1), GFP_KERNEL_ACCOUNT);
+	return count == 1;
+}
 
 /* only define max */
 #define IORING_MAX_FIXED_FILES	(1U << 20)
@@ -124,15 +168,53 @@ static void io_free_imu(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
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
@@ -282,7 +364,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 {
 	u64 __user *tags = u64_to_user_ptr(up->tags);
 	struct iovec fast_iov, *iov;
-	struct page *last_hpage = NULL;
 	struct iovec __user *uvec;
 	u64 user_data = up->data;
 	__u32 done;
@@ -307,7 +388,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			err = -EFAULT;
 			break;
 		}
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		node = io_sqe_buffer_register(ctx, iov);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
 			break;
@@ -605,76 +686,79 @@ int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
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
 		}
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
+		}
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
@@ -763,8 +847,7 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 }
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-						   struct iovec *iov,
-						   struct page **last_hpage)
+						   struct iovec *iov)
 {
 	struct io_mapped_ubuf *imu = NULL;
 	struct page **pages = NULL;
@@ -811,7 +894,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		goto done;
 
 	imu->nr_bvecs = nr_pages;
-	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
+	ret = io_buffer_account_pin(ctx, pages, nr_pages);
 	if (ret)
 		goto done;
 
@@ -861,7 +944,6 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned int nr_args, u64 __user *tags)
 {
-	struct page *last_hpage = NULL;
 	struct io_rsrc_data data;
 	struct iovec fast_iov, *iov = &fast_iov;
 	const struct iovec __user *uvec;
@@ -904,7 +986,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			}
 		}
 
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		node = io_sqe_buffer_register(ctx, iov);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
 			break;
@@ -971,7 +1053,6 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 
 	imu->ubuf = 0;
 	imu->len = blk_rq_bytes(rq);
-	imu->acct_pages = 0;
 	imu->folio_shift = PAGE_SHIFT;
 	refcount_set(&imu->refs, 1);
 	imu->release = release;
@@ -1137,6 +1218,56 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 }
 
 /* Lock two rings at once. The rings must be different! */
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
 static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
 {
 	if (ctx1 > ctx2)
@@ -1218,6 +1349,14 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 
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


