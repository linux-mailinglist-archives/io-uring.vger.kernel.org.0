Return-Path: <io-uring+bounces-1314-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56202890E8D
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 00:35:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CCDF295EC3
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 23:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ECBD130AC8;
	Thu, 28 Mar 2024 23:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vYQ4xaYM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869C9225A8
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 23:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711668903; cv=none; b=GWM7uR9nGcVWA0bJdsewSeTkfAK++XjQSIfr0xUm20m1qMEKIrc2KlIW9F9pwnC58Xp2CNTSo59ydx4qO1Vod5TtoxYYDEqybyZ380T+Rxu3d0eslKDIwH4r1Q1htz653PFIHn2KiqjCLI/V28NX+ANuIfREww4U+/5qftXqyds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711668903; c=relaxed/simple;
	bh=0W2obeekuSQdzZWXiQybp+acO7ke81Dc2YvaIvoTuQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxvBH1xxpll8ckysW0h6J+2aiU9A/VzYNNhmDvsbxZ50CJHIGu97ljWGSxRehRqIm5rkoKPE67JZGypVaMo1qeOkCW56zQRIjytNMpTtYqOrqbYoyt1sp8Tjdzn6i86wtT3bVnkCtnfc4vVmBwaULd5armpKsQIjxkcfohvaQr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vYQ4xaYM; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dd3c6c8dbbso2242955ad.1
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 16:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711668900; x=1712273700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IrcjwXvOlSphD9f4BvWGSMDrK92UD29qUBOBEFOPsVY=;
        b=vYQ4xaYMxRSy80Yl/vVwtjxEQpfeeyoRBywo/ES6OA8k0TZZ/PI3iuoZvxkquaxMYV
         g/a5Xjs1z487K6wod8vo4+Pq6Du81cJdmjfwkVtn+QhDtTBd/s+zuwS9cetnH39ojIzZ
         UctEmPntyOxwMw3sEgkU3AdrkEBe6Pjvj7uwIbNbUERmMm2L2G9yTl67gWe65JEmH7V8
         cXKnj+VBrnTb30QactATZ52b8aGyaZEAJ6KQ0QEGvjCNWvnos5GTTZ4m8T8ZpcLncMWk
         /eEXmC3LpHzOqfD7Ue7yaYBIUQKv/5zIy3A3h5SnhZG9alKIg/dX2WfvpBo6j9nc9W1a
         Riew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711668900; x=1712273700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IrcjwXvOlSphD9f4BvWGSMDrK92UD29qUBOBEFOPsVY=;
        b=dvwGJcRMSIZrrwRXhW7XqYIylmCf5AGnBDUyxw8CW/FOe6WaRoVU1EBAwuYe8dC88V
         y3fFcIawoJW8Uom0yFyiYCbkp0C2DC1PRjHnTyEfWZ6cckqsW1XmVMqdtHdsG9TheBo9
         Kd3w+RT+Fj1S0slFiI8azNXGyNDans+yYJ8C2cA/eyRTrlysn5aUc+iKIkXLKq0pE+mN
         EJP15TE6bJKmlFITYXid0jZcLHLRhQsTnWvJpTmE8YNY0iHTCgb3wXQHvuDyyun2Xqt3
         fzcRW6538rM6ATPinueJhvJ49+U20nihAuXdA238AenZCYjmZj5zOkNl7p7mJqcdtgyY
         NvjQ==
X-Gm-Message-State: AOJu0YzrTyTKcMScBXfp432Yg0kvJu07bI02n3JM40SKTFwTEiI6loBw
	O/0Zv1lOGc8aaMlrdhjmjnaq8Qoez89iZub6wigX5qnhPWXgfbBtqKj48Dlg0oDPraynIdkARE6
	z
X-Google-Smtp-Source: AGHT+IFQiLQ3jjSDdv+HXbLZpdwfpE8vT5LRB2kjU9KB95frRjRodEyl1J28JW62h7rchFf8XGGT9Q==
X-Received: by 2002:a17:903:503:b0:1dd:b883:3398 with SMTP id jn3-20020a170903050300b001ddb8833398mr946742plb.4.1711668900443;
        Thu, 28 Mar 2024 16:35:00 -0700 (PDT)
Received: from localhost.localdomain ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b001e0b3c9fe60sm2216981pla.46.2024.03.28.16.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:34:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: hannes@cmpxchg.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/11] io_uring/kbuf: vmap pinned buffer ring
Date: Thu, 28 Mar 2024 17:31:34 -0600
Message-ID: <20240328233443.797828-8-axboe@kernel.dk>
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


