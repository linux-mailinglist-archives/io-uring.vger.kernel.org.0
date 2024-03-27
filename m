Return-Path: <io-uring+bounces-1257-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B288688EF11
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 20:19:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 670C529C1C4
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 19:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6949615216D;
	Wed, 27 Mar 2024 19:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QN+zwuZL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCB014D280
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 19:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567184; cv=none; b=EPy2wjc+a/7yXwSiqH+yMpK8mwu98Euy8BFtEvKbYzCbcX4H6jWITbbjUUH1iAKAnikTI2O8f2D1mcIe1Rr1qRSQp2LtdWuKCHKyQlR26fhGlpFQNxHH5iMPKizNyWHWL1BPs06xzqXCnGPIREhQD7ZUeiazsvUuBd48eh7tSIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567184; c=relaxed/simple;
	bh=kvVE6febIb04jrE/F9NLWAAO/39newEvIn7hbro7q98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+1yJC6pi0XVwJ3HSvuBmKg9k94xP1VAwG799zvHCZIE9n0q0yZLguxD+QlryLYzLXtV+497qO8hrgWaerYmPWyB2Bj/iTnwDX+R6rsjtnY02GEdsXIEtgQvoio0Gg9PnLjrXuvGozT7Yr6NFA1GLDVC9bsTRzihVlPDnerXBUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QN+zwuZL; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-58962bf3f89so25573a12.0
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 12:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711567181; x=1712171981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SBdcP6DeDOrKct7/HMwyFlsXehHONUqtIcZ6bDvoZsc=;
        b=QN+zwuZLeqtOwzj4xT7/awceCemJ9PKD6G7yXn6Ms8hSsK+l6IWq7Vx+cEiSnAlXfr
         4/dGht5RDDg/D4nm0HQsgiHg3LDSTBN9jciN1nOPj3KUKiaC9ddkKDUkDNNnQF/NgnlN
         T3jTARWUKMidwbZz8aE2C9BPrOGWSw6m0GN6pf7Wis4s0rIcqKl0+U+eq/l9vSCfduzA
         QnItdH3NLR2gAqOwGx4qorRMmRT4HMf/tb0E444c2USzgJg67vl9krEqPad1Ls6e2bU2
         CpmBVQs68z2sPatIZFN4EXlLpcvY6Cyrw2ZAG8hEQmXOfal4UbVues0W0AP/Wi65SfCX
         5hHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711567181; x=1712171981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SBdcP6DeDOrKct7/HMwyFlsXehHONUqtIcZ6bDvoZsc=;
        b=cPr3fsDbUzFGexRKtc0t8No5GrmENvW9CvI81o4wGuMWboWF8hV9h8eLeyb0r1cBlC
         kkJp0pbh7S8AUxIyw4GBmfSAOKMXHUofJSUvyyhocIVbVPMTQ3tHZCi+5dcQiCPrYTqL
         R72eKhB3FXE87zorNIBC1JmgIIeclHFMYDKJRCMHCslTvVKicmlAKajGbCveB/+oMkjL
         9TsIQWCFJ1zM+QcUB4KwlYuElZ8B0teZUs2Y/A7BVUC/z0aUfAsXrUL4hBVaoJt16i09
         dWF1e/nupg++jk1NUmcSS/FCioPcVhK7i0WTVMA8mrQgp0EYqXTOusLNe4elB2tYYEOw
         P5ug==
X-Gm-Message-State: AOJu0Yw1Qy3FvKG0sQZNESviEvqSjyU1jLHj+EXiPFz6lyuKdJeUSw1F
	JGQcbxxgPZozVa3e6ehzGK7sYN/zSpKpGKVb6Dx8GlAfJ+zQqBH+9bix5g4Q/YSpE1d73OBSU+o
	9
X-Google-Smtp-Source: AGHT+IEZHEyuY1mT+EZP0LQ0Rpw3LkvHb5879hfoiiKPyLDGqpEmFO6DFVwS1lNt4MXL9O66XGyLyQ==
X-Received: by 2002:a05:6a21:7881:b0:1a3:66d8:d978 with SMTP id bf1-20020a056a21788100b001a366d8d978mr1089487pzc.3.1711567181083;
        Wed, 27 Mar 2024 12:19:41 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79842000000b006e6c3753786sm8278882pfq.41.2024.03.27.12.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 12:19:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/10] io_uring: use vmap() for ring mapping
Date: Wed, 27 Mar 2024 13:13:38 -0600
Message-ID: <20240327191933.607220-4-axboe@kernel.dk>
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

This is the last holdout which does odd page checking, convert it to
vmap just like what is done for the non-mmap path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 40 +++++++++-------------------------------
 1 file changed, 9 insertions(+), 31 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 29d0c1764aab..67c93b290ed9 100644
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
@@ -2650,7 +2649,7 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 	struct page **page_array;
 	unsigned int nr_pages;
 	void *page_addr;
-	int ret, i, pinned;
+	int ret, pinned;
 
 	*npages = 0;
 
@@ -2659,8 +2658,6 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 
 	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (nr_pages > USHRT_MAX)
-		return ERR_PTR(-EINVAL);
-	page_array = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
 	if (!page_array)
 		return ERR_PTR(-ENOMEM);
 
@@ -2672,34 +2669,13 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
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
@@ -2729,6 +2705,8 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 		ctx->n_ring_pages = 0;
 		io_pages_free(&ctx->sqe_pages, ctx->n_sqe_pages);
 		ctx->n_sqe_pages = 0;
+		vunmap(ctx->rings);
+		vunmap(ctx->sq_sqes);
 	}
 
 	ctx->rings = NULL;
-- 
2.43.0


