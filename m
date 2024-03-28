Return-Path: <io-uring+bounces-1311-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92DE8890E8B
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 00:35:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E572BB23311
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 23:34:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CCCD1311AC;
	Thu, 28 Mar 2024 23:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iixutGTQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A19130AC8
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 23:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711668897; cv=none; b=US813cDNF7X7kXdUg+B7xNZep2s42ZwOKcSlj+qC4UXnIEEXZeBjO+H9gQXCM/GGvSydfo2ORdiY4yrbmQrv4k0QjyPw5reuyQoF2RgpJPPpu15nTm4rAIPNS9GbjY6BqBJiHJn+aQI7jNsDXmuh7ht1WL0eYsUW+qO2o6+yRIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711668897; c=relaxed/simple;
	bh=DVP9nSBiNSFr9i9Z7TY5KdEBVCeY9WdQ2M/7Lpd3tck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNmuoLg+1GD+o8CCDgPjHI9d21a+f9WHXhttazUbFhO3pbcTAXzhJ/L8zrjImG5GV4RmJPEyvB8kjJymeq+Y0+oLZMpJBr1h1cweqJAotP7jr0cSQnASgJLYwL7eBdORErtNHa+BdZvUwU8y9D5pnZe9ubHmi0Y+wz7aqErmgnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iixutGTQ; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-29df844539bso409589a91.1
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 16:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711668895; x=1712273695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0BmIeXpb4QrnCLFpsrPOywqx8dk2Tjma8P5taVJ4LeY=;
        b=iixutGTQ9/4qfzZi8/awCnyLdpGZVfZppmqUuCz/W0ad7NmQjeR3OR406qeBJTP+R0
         pvw5bjtc2WJf2ryTrTcM9PgD4MKtPOpqI1OIpt45ZE3vCUPF9e5FzVFycaCyalkZx0lL
         homvCIZBQXUQZlQPRNLXvm3z+R4U5EyjvZ8J8vNmSBDvXcrIDGvdeuXpwt0QnNIS3BXA
         2NkqHvbVlcC56UBT9RMAYAGc3zi3TBrfMYSzUsJbX5kyylX1udqdMn95HTuVLN94EkDY
         8CbSQQrOI0KclNCLinUrSPT3maX1pcfIeDeYILft1hyUfKKia/XK1uiQGcMPOmqANbWG
         fAgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711668895; x=1712273695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0BmIeXpb4QrnCLFpsrPOywqx8dk2Tjma8P5taVJ4LeY=;
        b=fcr73i4DZXLAhYODASdNE+MsnA4acc8sURoqPxnQFeoCCHv7FICX04RqvtJT/FpCae
         BQp7kRvSgwad3451+BpCVf6G8agpqsFgj5Zj5iNlbrfqFc1wgHRL2dNdvENO5ea/jtTY
         PAFGcYKmC/VukRC1FT30lhHeJwRt3RN+tBrSFEC397M0HxDLXK/ak1sAeyyvrHylRYFE
         Lk3W/ZJ6p3Ty8EP2MkCzvPybpqpAUDO2y8fop2IzJqvNAPCe9PgR/Dq9MMdYHtB4lUUZ
         CcOKp1lMnzTEIHFQHjk22oPcSn/MTA5Fn5SnqBs1dd3Z11PhmeB/IEE/jdxZ7Geyv2y2
         u3TA==
X-Gm-Message-State: AOJu0Yz5AbUqhwsep7CYkLghjuKS7Fdh41CgI3QRQBA2Rp6A+KqZaTjg
	qMOg07mVBbx+0Nc1iuxF+D/HZ9V4h3V3XRXYP1Tb3Y8fqTtsyV58HssbOq3A+UfRXCSmBJ2yK46
	c
X-Google-Smtp-Source: AGHT+IHqUnWV6SgFxj7UpJhbC51ZIKBiKVRxcdAs0Xc4KIynL/fmai/Ap33JVmI2Hje0Dds8cx6wgQ==
X-Received: by 2002:a17:902:ed46:b0:1dd:7c4c:c6b6 with SMTP id y6-20020a170902ed4600b001dd7c4cc6b6mr904319plb.5.1711668894720;
        Thu, 28 Mar 2024 16:34:54 -0700 (PDT)
Received: from localhost.localdomain ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b001e0b3c9fe60sm2216981pla.46.2024.03.28.16.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:34:53 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: hannes@cmpxchg.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/11] io_uring: unify io_pin_pages()
Date: Thu, 28 Mar 2024 17:31:31 -0600
Message-ID: <20240328233443.797828-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240328233443.797828-1-axboe@kernel.dk>
References: <20240328233443.797828-1-axboe@kernel.dk>
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
 io_uring/io_uring.c | 61 +++++++++++++++++++++++++++++++--------------
 io_uring/rsrc.c     | 36 --------------------------
 2 files changed, 42 insertions(+), 55 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4c6eeb299e5d..3aac7fbee499 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2642,33 +2642,57 @@ static void io_pages_free(struct page ***pages, int npages)
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
+	if (WARN_ON_ONCE(!nr_pages))
+		return ERR_PTR(-EINVAL);
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
-		return ERR_PTR(-EINVAL);
-	page_array = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
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
@@ -2676,10 +2700,9 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
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


