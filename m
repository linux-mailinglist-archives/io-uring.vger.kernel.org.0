Return-Path: <io-uring+bounces-1258-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BFB488EF14
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 20:19:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6C9DB23A5D
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 19:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B15615217F;
	Wed, 27 Mar 2024 19:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wygDKyR+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAC812E1F6
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 19:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567186; cv=none; b=ZEWCCXqljJ/kZZ+XR8WvGL2EG3o4bK3rbcEBWQnuVG0ZVOZCzGxseFKoJBmYEhrthpqxtq6jGC+xgt8gtmd6uzOCQzBAa/4pGAX2UHbzZu+I2EDz2kOxnmf4Ou4U3V2jh5ASsFvexdVv/5YRYFt8y712pShQt0Z0xLEulxLOkLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567186; c=relaxed/simple;
	bh=10rApHkF9zSklfaPE7lnFCjhYUOdaSjtacrcM0x8rVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHwixjHnUL4OeWyPDeur+efW+XrNYs2caNdQITLoOQ2M7AYGY2vrfT34zCk1NqEyJM8cjyGdQSJaDVtUeRDhfKtmI5oqfKPhq3O0tIwdKHX1glzsUAgCu0G3CUKPfYRsKMRFk758Z1drA8T1Gq6/9p9739+I3WNj/iigDpEg+2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wygDKyR+; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e694337fffso59607b3a.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 12:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711567183; x=1712171983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8RMlGq1Gwhpk4UAA96yMefndlkDhs2bhrF9FMUSrKbo=;
        b=wygDKyR+tK+ko+d83xBsuh+9Hru46zpzbyEC5H1Tf7IQ2q9++DtnR2NicLdW5lNI/j
         XqFfKCfit+Nc8yaD1t/3NfIYH6EX/ymWbg2/f7EgZ5Cj1egNk/o+DUYAwNrCn/icWpTr
         g3Y+IkExrxPj6ePAQ9UzNe/5R5rU/MdLvB8rVuqPiBuOsslSMWxjaeWgQoEqMCTRu0DB
         RNDNUWcPEaR+1oYz2oB7FyAKKpuJvyceE6ByH3ZuHL3mMHdlvnOeaHgzhxEq4ldtG61V
         crXo2AAUbCEK4C9xmGeeCPfWCMH5i/SZVKpnAZBOpHgvNNSFyuPDx3e6kWVSZLCUqMuW
         igtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711567183; x=1712171983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8RMlGq1Gwhpk4UAA96yMefndlkDhs2bhrF9FMUSrKbo=;
        b=CLWaZS9/GcXO7FKhmRxjWXsFETYdnECD2HJJDOtcFDj4KiotuHIYolhptLS+3NQ5DA
         nG1qXpn5nRKBiuR6XtekcwgRUZ9iZW3YVuaCJHZXBNXYdGEL100rlA7igRyDaoaLLhCQ
         GJQsTmFVp7YJyhmsOPucPQ0HMGPYQMXIXFq8J2+cmGDJgKor7lRMH/5fCriHR/ZIJCYa
         lQlYn8ykFDkowmIaopmQY+9xcel+i2KGorTbj5Vm9xncchieP5fIKbUVNr5MXNAKQ1hh
         DAipA2tBf8WMLAw4MFYwx0Y6KLTF/ZtK026N2TJNEOXhkEuK/yHPWjlopBpQ0qRFBQLB
         J4Sw==
X-Gm-Message-State: AOJu0YyztDRoMJ4KsKlU7f7FwneTYMGUxZoFHexhLdRoW/+rSD6Gzatr
	TNMYSWPgq2LVqv6yDDypGUug+Ed2sRT+GdFCFgska9eoWLD0YbP9xHVO4b7X7VRgbAobbDCI/jq
	y
X-Google-Smtp-Source: AGHT+IGK0oyuCfqYYMTrX2DTfSnfVufYGirs8t+UBSVUwwuaBpnmJqYeo/TDMgcYs59fK4JC5W49Ng==
X-Received: by 2002:a05:6a20:da8d:b0:1a3:4721:df94 with SMTP id iy13-20020a056a20da8d00b001a34721df94mr1099753pzb.0.1711567183174;
        Wed, 27 Mar 2024 12:19:43 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79842000000b006e6c3753786sm8278882pfq.41.2024.03.27.12.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 12:19:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/10] io_uring: unify io_pin_pages()
Date: Wed, 27 Mar 2024 13:13:39 -0600
Message-ID: <20240327191933.607220-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240327191933.607220-1-axboe@kernel.dk>
References: <20240327191933.607220-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move it into io_uring.c where it belongs, and use it in there as well
rather than have two implementations of this.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 58 ++++++++++++++++++++++++++++++++-------------
 io_uring/rsrc.c     | 36 ----------------------------
 2 files changed, 41 insertions(+), 53 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 67c93b290ed9..e3d2e2655e95 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2643,31 +2643,56 @@ static void io_pages_free(struct page ***pages, int npages)
 	*pages = NULL;
 }
 
+struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
+{
+	unsigned long start, end, nr_pages;
+	struct page **pages;
+	int ret;
+
+	end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	start = uaddr >> PAGE_SHIFT;
+	nr_pages = end - start;
+	WARN_ON(!nr_pages);
+
+	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
+	if (!pages)
+		return ERR_PTR(-ENOMEM);
+
+	ret = pin_user_pages_fast(uaddr, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
+					pages);
+	/* success, mapped all pages */
+	if (ret == nr_pages) {
+		*npages = nr_pages;
+		return pages;
+	}
+
+	/* partial map, or didn't map anything */
+	if (ret >= 0) {
+		/* if we did partial map, release any pages we did get */
+		if (ret)
+			unpin_user_pages(pages, ret);
+		ret = -EFAULT;
+	}
+	kvfree(pages);
+	return ERR_PTR(ret);
+}
+
 static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 			    unsigned long uaddr, size_t size)
 {
 	struct page **page_array;
 	unsigned int nr_pages;
 	void *page_addr;
-	int ret, pinned;
 
 	*npages = 0;
 
 	if (uaddr & (PAGE_SIZE - 1) || !size)
 		return ERR_PTR(-EINVAL);
 
-	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (nr_pages > USHRT_MAX)
-	if (!page_array)
-		return ERR_PTR(-ENOMEM);
-
-
-	pinned = pin_user_pages_fast(uaddr, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
-				     page_array);
-	if (pinned != nr_pages) {
-		ret = (pinned < 0) ? pinned : -EFAULT;
-		goto free_pages;
-	}
+	nr_pages = 0;
+	page_array = io_pin_pages(uaddr, size, &nr_pages);
+	if (IS_ERR(page_array))
+		return page_array;
 
 	page_addr = vmap(page_array, nr_pages, VM_MAP, PAGE_KERNEL);
 	if (page_addr) {
@@ -2675,10 +2700,9 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 		*npages = nr_pages;
 		return page_addr;
 	}
-	ret = -ENOMEM;
-free_pages:
-	io_pages_free(&page_array, pinned > 0 ? pinned : 0);
-	return ERR_PTR(ret);
+
+	io_pages_free(&page_array, nr_pages);
+	return ERR_PTR(-ENOMEM);
 }
 
 static void *io_rings_map(struct io_ring_ctx *ctx, unsigned long uaddr,
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 7b8a056f98ed..8a34181c97ab 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -870,42 +870,6 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }
 
-struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
-{
-	unsigned long start, end, nr_pages;
-	struct page **pages = NULL;
-	int ret;
-
-	end = (ubuf + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	start = ubuf >> PAGE_SHIFT;
-	nr_pages = end - start;
-	WARN_ON(!nr_pages);
-
-	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
-	if (!pages)
-		return ERR_PTR(-ENOMEM);
-
-	mmap_read_lock(current->mm);
-	ret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM, pages);
-	mmap_read_unlock(current->mm);
-
-	/* success, mapped all pages */
-	if (ret == nr_pages) {
-		*npages = nr_pages;
-		return pages;
-	}
-
-	/* partial map, or didn't map anything */
-	if (ret >= 0) {
-		/* if we did partial map, release any pages we did get */
-		if (ret)
-			unpin_user_pages(pages, ret);
-		ret = -EFAULT;
-	}
-	kvfree(pages);
-	return ERR_PTR(ret);
-}
-
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage)
-- 
2.43.0


