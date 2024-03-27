Return-Path: <io-uring+bounces-1261-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49D6888EF15
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 20:19:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D5E11C28A53
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 19:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F93A12E1F6;
	Wed, 27 Mar 2024 19:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ldhv9mFl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A192D1514EC
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 19:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567191; cv=none; b=QNwiJGfiVbYLyPAIO3kEraz3RVTa91fkonyWmf/oEh5xtKe20FeRtFW6uzUOlZw2r+AH1cxP8COAMQl+ue7X0k5LFwQG2VEgZxLH5ivFiFoZ8lXCDqXIgScUcFmNj0ARLdoGOc6EDEtuCN1twj4se0WRRpMq2uuOhfeh3Bb4X2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567191; c=relaxed/simple;
	bh=0W2obeekuSQdzZWXiQybp+acO7ke81Dc2YvaIvoTuQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvTBcwyk3ATY60rewBI9g4gkcO4ElRWgmCl+/3/jZ6BozNaoRrJ688C1KhZyYtR1+54u/0iOje/Pmxh7AJQaA89gRtYuE7E0GyTvcC8dXILbAGSz4cVXoEZsQnDgwFiFUdWLJ7pTHvXLWOt8wL1pwxWHnsQh41I0I6vqCmLSXbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ldhv9mFl; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e694337fffso59622b3a.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 12:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711567188; x=1712171988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IrcjwXvOlSphD9f4BvWGSMDrK92UD29qUBOBEFOPsVY=;
        b=Ldhv9mFlbBRqz46nKlHY9aM6BTJjKe6MgfWfR6raSuckqYyO9UhLCj2xLuBX9FDVXo
         4K9hiEWtCOiUmdMRaWykC5WY53dvzu3CfWqnBruCQq5K7UfjGx/SEKQNX3N/YCAndjsl
         ibX4lHcVIOccm/FvoWFpgV7a+N5w5bC1K0uVsRz8SMpY+RJCDJbwpoQp6xG2wfWWCUfB
         c1LtijGKRb5/LcisWr2dsl6A3KoasXjXkCCEwqW4F9nLK+/6dm6wgtEkkiHQkDDg3V3J
         MOGtpmivKJG4+9t+91Xhk1srmAfx74qq34A+Os9qpRf4ppXFwB2fprm8bkgRmsp3xeWK
         BydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711567188; x=1712171988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IrcjwXvOlSphD9f4BvWGSMDrK92UD29qUBOBEFOPsVY=;
        b=DzRfISsSNv7pgc2bVXW2ZCvqdL8yoVvpVfds9B+USdTvtT+1pkruP8bnPBwlYu+ZwW
         +A9hBMuKr5zHNfY648BGkVhSuNfRF7mVfY1MTfs2BCGkK4GvMPP9g3n6gnqTju0sDNuI
         79w8gQdAaAbvnMrAsFoy2HAskmesr/petT1IDeCs25ccU1GiN0neoLaR4PsEiK2gJwf0
         3Or+kyS7dJn6V9nEA3fx2ngmfWvFDo7ihn6OJd6Vo2N8WEiNcn1mdgHSczQQ3Tn39u4f
         chAxC8GkJJ8zTiOTsxjsguXrsGp53tc+bB/8DzYPxUJNBVmvAjnoHMfY1dgIMydyhute
         Z+wA==
X-Gm-Message-State: AOJu0Yx0111lBW9erUszuHwsmDuIdNQi35in+T4KSykOGCwqgN3Ra7dJ
	lCEG+VW5x/voGtdpqRUCBk/4S4Uog1VrqQ6gWmp7++I5oepHFtgtOJlZBfjBxqjpaW++9E3R0zy
	1
X-Google-Smtp-Source: AGHT+IE3PERzd/nfFQlwPYyGtmnXFESfpmk0lyii1SPkAo4DLSnpdbwRUYXczCwCXJyLOT1auraYFg==
X-Received: by 2002:a05:6a00:929e:b0:6ea:b1f5:8aa with SMTP id jw30-20020a056a00929e00b006eab1f508aamr858051pfb.3.1711567188530;
        Wed, 27 Mar 2024 12:19:48 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79842000000b006e6c3753786sm8278882pfq.41.2024.03.27.12.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 12:19:47 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/10] io_uring/kbuf: vmap pinned buffer ring
Date: Wed, 27 Mar 2024 13:13:42 -0600
Message-ID: <20240327191933.607220-8-axboe@kernel.dk>
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

This avoids needing to care about HIGHMEM, and it makes the buffer
indexing easier as both ring provided buffer methods are now virtually
mapped in a contigious fashion.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 011280d873e7..72c15dde34d3 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
+#include <linux/vmalloc.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
@@ -145,15 +146,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		req->flags |= REQ_F_BL_EMPTY;
 
 	head &= bl->mask;
-	/* mmaped buffers are always contig */
-	if (bl->is_mmap || head < IO_BUFFER_LIST_BUF_PER_PAGE) {
-		buf = &br->bufs[head];
-	} else {
-		int off = head & (IO_BUFFER_LIST_BUF_PER_PAGE - 1);
-		int index = head / IO_BUFFER_LIST_BUF_PER_PAGE;
-		buf = page_address(bl->buf_pages[index]);
-		buf += off;
-	}
+	buf = &br->bufs[head];
 	if (*len == 0 || *len > buf->len)
 		*len = buf->len;
 	req->flags |= REQ_F_BUFFER_RING;
@@ -240,6 +233,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 			for (j = 0; j < bl->buf_nr_pages; j++)
 				unpin_user_page(bl->buf_pages[j]);
 			kvfree(bl->buf_pages);
+			vunmap(bl->buf_ring);
 			bl->buf_pages = NULL;
 			bl->buf_nr_pages = 0;
 		}
@@ -490,9 +484,9 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 			    struct io_buffer_list *bl)
 {
-	struct io_uring_buf_ring *br;
+	struct io_uring_buf_ring *br = NULL;
+	int nr_pages, ret, i;
 	struct page **pages;
-	int i, nr_pages;
 
 	pages = io_pin_pages(reg->ring_addr,
 			     flex_array_size(br, bufs, reg->ring_entries),
@@ -500,18 +494,12 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
-	/*
-	 * Apparently some 32-bit boxes (ARM) will return highmem pages,
-	 * which then need to be mapped. We could support that, but it'd
-	 * complicate the code and slowdown the common cases quite a bit.
-	 * So just error out, returning -EINVAL just like we did on kernels
-	 * that didn't support mapped buffer rings.
-	 */
-	for (i = 0; i < nr_pages; i++)
-		if (PageHighMem(pages[i]))
-			goto error_unpin;
+	br = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	if (!br) {
+		ret = -ENOMEM;
+		goto error_unpin;
+	}
 
-	br = page_address(pages[0]);
 #ifdef SHM_COLOUR
 	/*
 	 * On platforms that have specific aliasing requirements, SHM_COLOUR
@@ -522,8 +510,10 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	 * should use IOU_PBUF_RING_MMAP instead, and liburing will handle
 	 * this transparently.
 	 */
-	if ((reg->ring_addr | (unsigned long) br) & (SHM_COLOUR - 1))
+	if ((reg->ring_addr | (unsigned long) br) & (SHM_COLOUR - 1)) {
+		ret = -EINVAL;
 		goto error_unpin;
+	}
 #endif
 	bl->buf_pages = pages;
 	bl->buf_nr_pages = nr_pages;
@@ -535,7 +525,8 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	for (i = 0; i < nr_pages; i++)
 		unpin_user_page(pages[i]);
 	kvfree(pages);
-	return -EINVAL;
+	vunmap(br);
+	return ret;
 }
 
 /*
-- 
2.43.0


