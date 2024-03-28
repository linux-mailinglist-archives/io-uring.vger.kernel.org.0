Return-Path: <io-uring+bounces-1310-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9459890E89
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 00:34:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 731652959FF
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 23:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 653F8225A8;
	Thu, 28 Mar 2024 23:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2IO5mD5N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBB5136E35
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 23:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711668895; cv=none; b=WmscSU9bLQFwvu7iyfYLhjd4wgX7FYZAmE69g+AeshcjoJCSG4uQoG7H4geZ563AAng4PyOHB38nxpdcR7/C68z7qYBNPgEi9hqo26NLsNbXeBRSObRho1AetpP79Oc3e0vLENmzw6PnGbKsbI3XQYoEqBjW+dJje7PBlXHrcGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711668895; c=relaxed/simple;
	bh=qca79bPx4QE4FdCO1F9KhQ8sdnFh5uCJmdpa2OpXU6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8tTn+apn7BOF1OxYYhUwdqBflS/UyI3rELsSLWuXVMXUgn/l/JPdEvMfCcHC1eU56yTt0RKLSHFuvWksRq2Iivse+S027AWLAn7esIzl4ZQWc+oindFkZxSzhFDjSd+k0w47LLJHAVu5v9djMd5xsF1td9FqWgPEZGuEj+3Z8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2IO5mD5N; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2a1f8308532so294985a91.1
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 16:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711668893; x=1712273693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=inc4OH6qBFXNe31XZ2xEFuCJLRY5h4FhZzKZtMt5Q/c=;
        b=2IO5mD5N6XHAjLPYy2jmAYae4r6UMaA3hXzWx9VX09RIunsplNGD6YG/pqmn/5BYVW
         oBBRuHZcq2VGVivj39xnB6gb+p4HjWehBG4FwuVvOJLVrULffWsFpyCl51gu3NJm2+WQ
         Z++5iZ5D0F55akPJYB9uONGOlHQnvZXBj4qmIrr8sLkUBqFf2WTSULiA7U2rTkzdGRhH
         aZtI3al06lQQFwMD2OoA9hrDYjNMWYaC6/t5XVdJHI4ERKHKwD1/t9Ikg4DWsPPmXU1A
         RrG1hXlyfDBfSwS0jhbtmQME8stkDO1kx7PKmQxzFboRX+es7Fn0pp+vWfMkNIEjoHmU
         7QVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711668893; x=1712273693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=inc4OH6qBFXNe31XZ2xEFuCJLRY5h4FhZzKZtMt5Q/c=;
        b=qJBnBvjJb1srcbUnJ0NzkRj57yZWARtZ8NYe8rsSHuqcUC4Bv3FSKw0p6AccEaHmbm
         MudviIxEZd/UN5LaledtArHd5gOYcut7/5njGKkPCVlxpIAcxBrZOQJgUGsluyPvhvUf
         SZrAudbj/pfQ+E5tRehSYGdhkGbUx2D7qLY8MvSXv3yCUo5F/gEv7lcjL5/NOsx3045B
         yuqvH8H1AQ0vRaxnLa1GI25jQyGmJy5/L3v2azRXdGAsDYsfnyboyblU8ZBpFKqbGtMJ
         833il5O6QAcVXa1TVYUKNkn451kjqwqKEz8vTAiKTse30Hi/Jj+HKi3BvchIiZtqoxOH
         dO9g==
X-Gm-Message-State: AOJu0YydeEdqhVMXUP3FJl+XJxTOo9ywdTBIV/ci2RcXjwnbyRyd6FR3
	ZERFVRZJI0xs/QeiP00Khg/QMzjobKTouewLUgKcfmSUVJT3z+pR5jfyek0q9LpWSbUhti2Mvdu
	v
X-Google-Smtp-Source: AGHT+IGiLQxSVGxFpYJC+RLf0bN1JVOnHJL9CW7fVknzPb/7O7SaX0LNKJRR3dTayg6dPz0AnsrXZg==
X-Received: by 2002:a17:902:b092:b0:1e0:c887:f938 with SMTP id p18-20020a170902b09200b001e0c887f938mr962457plr.3.1711668892743;
        Thu, 28 Mar 2024 16:34:52 -0700 (PDT)
Received: from localhost.localdomain ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b001e0b3c9fe60sm2216981pla.46.2024.03.28.16.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:34:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: hannes@cmpxchg.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/11] io_uring: use vmap() for ring mapping
Date: Thu, 28 Mar 2024 17:31:30 -0600
Message-ID: <20240328233443.797828-4-axboe@kernel.dk>
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

This is the last holdout which does odd page checking, convert it to
vmap just like what is done for the non-mmap path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 982545ca23f9..4c6eeb299e5d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -63,7 +63,6 @@
 #include <linux/sched/mm.h>
 #include <linux/uaccess.h>
 #include <linux/nospec.h>
-#include <linux/highmem.h>
 #include <linux/fsnotify.h>
 #include <linux/fadvise.h>
 #include <linux/task_work.h>
@@ -2649,7 +2648,7 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 	struct page **page_array;
 	unsigned int nr_pages;
 	void *page_addr;
-	int ret, i, pinned;
+	int ret, pinned;
 
 	*npages = 0;
 
@@ -2671,34 +2670,13 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 		goto free_pages;
 	}
 
-	page_addr = page_address(page_array[0]);
-	for (i = 0; i < nr_pages; i++) {
-		ret = -EINVAL;
-
-		/*
-		 * Can't support mapping user allocated ring memory on 32-bit
-		 * archs where it could potentially reside in highmem. Just
-		 * fail those with -EINVAL, just like we did on kernels that
-		 * didn't support this feature.
-		 */
-		if (PageHighMem(page_array[i]))
-			goto free_pages;
-
-		/*
-		 * No support for discontig pages for now, should either be a
-		 * single normal page, or a huge page. Later on we can add
-		 * support for remapping discontig pages, for now we will
-		 * just fail them with EINVAL.
-		 */
-		if (page_address(page_array[i]) != page_addr)
-			goto free_pages;
-		page_addr += PAGE_SIZE;
+	page_addr = vmap(page_array, nr_pages, VM_MAP, PAGE_KERNEL);
+	if (page_addr) {
+		*pages = page_array;
+		*npages = nr_pages;
+		return page_addr;
 	}
-
-	*pages = page_array;
-	*npages = nr_pages;
-	return page_to_virt(page_array[0]);
-
+	ret = -ENOMEM;
 free_pages:
 	io_pages_free(&page_array, pinned > 0 ? pinned : 0);
 	return ERR_PTR(ret);
@@ -2728,6 +2706,8 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 		ctx->n_ring_pages = 0;
 		io_pages_free(&ctx->sqe_pages, ctx->n_sqe_pages);
 		ctx->n_sqe_pages = 0;
+		vunmap(ctx->rings);
+		vunmap(ctx->sq_sqes);
 	}
 
 	ctx->rings = NULL;
-- 
2.43.0


