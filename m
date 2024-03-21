Return-Path: <io-uring+bounces-1184-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA20885B27
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 15:48:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70D4F284EA5
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 14:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1DD85277;
	Thu, 21 Mar 2024 14:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iT4nHDET"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587E51E534
	for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 14:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711032522; cv=none; b=MRbGxt9LF7m0ec9rCtg2ebBAUYQDWWsDFqJVCIrD4eLeLUGYvnxHU6WqLT3GKp51wkLprxn8stWidJY8PHfsAUjyuOkapGyy7haDmD6oj6b5ITyLyP215Erab4d20xCG1FTv0nb+Z5AEy38eDPP66V5/X+UozWBHzpiPvQMQhdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711032522; c=relaxed/simple;
	bh=0W2obeekuSQdzZWXiQybp+acO7ke81Dc2YvaIvoTuQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f60vROyzG/GNPQPusgTaVBkuvp27nFv5MTc8zM20Ie5uTCR1W6fW0Ema1bMAWeU2XG6Tbry+99H9TVbXm566NOBum+Dq/mVGVg8QNInSqVyTSJxmPVNHnaowlAN1X0xyK0lmA31CHAFtXGHZ15ktF+UECyWxcbc04EJ8UzIkLMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iT4nHDET; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so13372239f.1
        for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 07:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711032519; x=1711637319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IrcjwXvOlSphD9f4BvWGSMDrK92UD29qUBOBEFOPsVY=;
        b=iT4nHDETzfU9kFp8i+ayB9L08fvSkx1p7J1xPcMi5prXRrqwN7PP12Rr5aOJAX/74I
         AFWEK3oOd2PhqjXI/QUGDDcQkUBOoYkHaxsz0EI3pliRxEm7rzgon21TJFXmIG12kukz
         O1V4zqGR+KOgVVOqubsSqonh27io8wqordJXCkmc03djB/Tw/meM2mc/gS6CwND1dJ6d
         bUyf9p6jBvlADKPSx+QojFmgyMq6hx+dJEMEmfb/wg5lAe+ngcVxbfHD8YsAOCqh436l
         BdHouxeN6mfQutunRViM9ZqnYEfiWcmnp/1xrfZDBxViQjEsbSezAtOvR4E3aAn8pWjE
         YCog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711032519; x=1711637319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IrcjwXvOlSphD9f4BvWGSMDrK92UD29qUBOBEFOPsVY=;
        b=oIAFyVjQinJ3mokz/bRTvJb6hVc3htI7ngvaoeNINddhZ/Ud9w2eA6dmSzKbkYNprU
         yFe1YoY+/MNs8TA2U1RR30UzZvFNO7/kYTLyOiQaQ0kGA1JRdfdV6KemQnj24mghZFbs
         X/4CZcr/DJK0wX84um+z/PzaAbLqQ1UNBuCYxhITSJ9Nbjditf3xBQrov8mkTHJT5OM7
         XOai7a5Av4qKo7T86/0xC4fVDlNIWjgeSZjYXJu2V9pNLvWIjqtr0JW2xpKw7yjZZD3Q
         a2iW7hFj7rPlVB/kYOwWdWt4uYJOVrOC5of/RqjNu2ggk3QGz3A1NxSxvJliijQendfC
         sSQQ==
X-Gm-Message-State: AOJu0YxRiNpy8bknkh55Z4ITrA5kX1ljKaMq+JwC1Deg45HcsNkPP13T
	Nq8v82PXb4TgzBkPQ39w7DUM4/rMEKotk48weZx8dBWdN0pzuXcNmVbY33d+cfJoEVDuyEPK1fP
	5
X-Google-Smtp-Source: AGHT+IEQdz+v6hyYI3bYsEYR/c3QIUBRO3AtGDfLjAiy3nRCKL0BKcQkP2MfmR5OUkZY16fSyaUsgQ==
X-Received: by 2002:a5e:c10d:0:b0:7cf:28df:79e2 with SMTP id v13-20020a5ec10d000000b007cf28df79e2mr2731967iol.1.1711032519186;
        Thu, 21 Mar 2024 07:48:39 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q20-20020a02c8d4000000b0047bed9ff286sm250835jao.31.2024.03.21.07.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 07:48:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring/kbuf: vmap pinned buffer ring
Date: Thu, 21 Mar 2024 08:44:58 -0600
Message-ID: <20240321144831.58602-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240321144831.58602-1-axboe@kernel.dk>
References: <20240321144831.58602-1-axboe@kernel.dk>
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


