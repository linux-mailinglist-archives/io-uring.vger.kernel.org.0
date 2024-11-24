Return-Path: <io-uring+bounces-5022-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8D1D9D7842
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 474DC162BCC
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D6D913FD72;
	Sun, 24 Nov 2024 21:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lRaHQGKc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582CE156960
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482743; cv=none; b=gxjjE0u7NywVvLeBWVGtsOtFXnLEbUI4+TWRMIFMF2BrkyHs+PCNcTZdpI/bnvYXpww1hJj7/cyeeB69fHIstRhEc+zn1NYXVcJJTtyysUhv5+uDXSyhi0U7Bzk8iqW+6j+YiQ882wy7Nf5aFZXIpkR/XlWBPDpn4YeHBNAJadw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482743; c=relaxed/simple;
	bh=6E56ks1kypMJjgmiNbwiHW0OEsH6fT3SvMKVVQrd8Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d51I7S3g5d7ySL4VahISdzwGO1dr/5TsVEOvHOIPI/A1yeVnYMA7Hv9ibGz2iH1soEZ/LNo5nfF/fS19B9kEzUMk7tGLxGRKebZyBuF6WHPhClOcKvtZ/H4SqcwB2vHQ7hFYHJd5LHCXy3ZguqzqaPvjt5XLrs89cAcswmVymMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lRaHQGKc; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43158625112so34980275e9.3
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482739; x=1733087539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UMqCVFH4bCWU9Q/bAjVPrMRtHJHe9onTMmao6gGbEpU=;
        b=lRaHQGKcFdiLXaW9rCXzM5IztELkN7zMxstGWiAnh8cb/8THEHyxT4c4DM6fvzmYMq
         Xsjym4gKzktXQJskFwyWoJ8YZULhVNXihqmGxmXb89WjBpQ8DX+YcwWC63aogRfNzEmX
         ETxWGp4MXhnrSZQTSvkhMF0/fEZdSK8G/I/eVr/vnMbql3jGCE23vfG0G5f5+DtrxGX7
         xncTUzWwae4Gs1PptNrwW6QYKO7981l9wnNxe9lkQvFyf8PzSVgb4WLma38S0Reb31mJ
         HfNimDaJojp7ljsNeBhcIZeJMf0KVe6FBZeJssOG4f3mgfUT3MKuAiVGmzrU4Sb3iNw/
         Jb8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482739; x=1733087539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UMqCVFH4bCWU9Q/bAjVPrMRtHJHe9onTMmao6gGbEpU=;
        b=niHXEvbirueRaKU1FmyDow+AVsx21J/jyc4+VS6yARW7LgxrCMNnWgLHJ2hh2fwH3y
         gCbc7w6HZJBLXYkeGBd/MUl0OB1tUfy2LAo80K+2rzU+y4p4C+vswZfyGBv7qY0BCvlS
         A9w2xrTpk2n+T8KfpoiwCccY/sBVs0/+IBdSXxhp4wkKyebeBOdpxJ4l/BSTYm9yq/8O
         TTkv5S5KRleQ1wQd37Meqj86GQ8crO84lvAcGjUzJqwz3wQPyx1BJ1j8zF0UV3/tnx6J
         q29hMSclDwo0AJe9lC9PJ+92MJ22yrXBjHoMplA3EYbtLg7czt4v+hV6gdjUgsDshvU3
         ZHbw==
X-Gm-Message-State: AOJu0YxvbpTbx9w3aDbvF8F0+c10BYEyUwqUS2dl+C5S04VriK15BPV3
	MaugyWNE9J/y3Sn/a0B2HZkUozzTlux8ALATdIUW1Px4hTDf/B89bzxbiA==
X-Gm-Gg: ASbGncvmxv+h0DJpA1F3/nsjZh9wPNIRuCPlzArjwi0HkQQwdJSZm4Mue1d9Mk/quXX
	sV29+rX2gyBxLAif4H1kN8AfeTR0xXtZgm2SdTxJ5rg9LF1arBdW27MefUzNUuIqrmcTmkD1Qjo
	pBgyGKxEHXoU8zn5ZjJhJXnjPgetihRkzP1Uj6oPIPOpy6BJlEb/Pr/z4tXzzyC/WrAEugrOWd6
	FmPIFPJbMwTR3A1E5kEKz52ylpqrUkzlATO4NH0TuiVJseCZLcDabYgEUGj7mQ=
X-Google-Smtp-Source: AGHT+IHEmzT58X5BKSfsoIJvpsCMD50MrbnUO0cXtfm0i1tSOMplwjyCTHvg1pBFtjuqga5w2vE28w==
X-Received: by 2002:a05:600c:1d08:b0:431:5465:807b with SMTP id 5b1f17b1804b1-433ce4e2582mr84337325e9.32.1732482739539;
        Sun, 24 Nov 2024 13:12:19 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:19 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 15/18] io_uring/kbuf: use mmap_lock to sync with mmap
Date: Sun, 24 Nov 2024 21:12:32 +0000
Message-ID: <62eec2e533534f4f023929fc3c3695947d45e131.1732481694.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1732481694.git.asml.silence@gmail.com>
References: <cover.1732481694.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A preparation / cleanup patch simplifying the buf ring - mmap
synchronisation. Instead of relying on RCU, which is trickier, do it by
grabbing the mmap_lock when when anyone tries to publish or remove a
registered buffer to / from ->io_bl_xa.

Modifications of the xarray should always be protected by both
->uring_lock and ->mmap_lock, while lookups should hold either of them.
While a struct io_buffer_list is in the xarray, the mmap related fields
like ->flags and ->buf_pages should stay stable.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  5 +++
 io_uring/kbuf.c                | 56 +++++++++++++++-------------------
 io_uring/kbuf.h                |  1 -
 3 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 2db252841509..091d1eaf5ba0 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -293,6 +293,11 @@ struct io_ring_ctx {
 
 		struct io_submit_state	submit_state;
 
+		/*
+		 * Modifications are protected by ->uring_lock and ->mmap_lock.
+		 * The flags, buf_pages and buf_nr_pages fields should be stable
+		 * once published.
+		 */
 		struct xarray		io_bl_xa;
 
 		struct io_hash_table	cancel_table;
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index d407576ddfb7..662e928cc3b0 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -45,10 +45,11 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	/*
 	 * Store buffer group ID and finally mark the list as visible.
 	 * The normal lookup doesn't care about the visibility as we're
-	 * always under the ->uring_lock, but the RCU lookup from mmap does.
+	 * always under the ->uring_lock, but lookups from mmap do.
 	 */
 	bl->bgid = bgid;
 	atomic_set(&bl->refs, 1);
+	guard(mutex)(&ctx->mmap_lock);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
@@ -388,7 +389,7 @@ void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 {
 	if (atomic_dec_and_test(&bl->refs)) {
 		__io_remove_buffers(ctx, bl, -1U);
-		kfree_rcu(bl, rcu);
+		kfree(bl);
 	}
 }
 
@@ -397,10 +398,17 @@ void io_destroy_buffers(struct io_ring_ctx *ctx)
 	struct io_buffer_list *bl;
 	struct list_head *item, *tmp;
 	struct io_buffer *buf;
-	unsigned long index;
 
-	xa_for_each(&ctx->io_bl_xa, index, bl) {
-		xa_erase(&ctx->io_bl_xa, bl->bgid);
+	while (1) {
+		unsigned long index = 0;
+
+		scoped_guard(mutex, &ctx->mmap_lock) {
+			bl = xa_find(&ctx->io_bl_xa, &index, ULONG_MAX, XA_PRESENT);
+			if (bl)
+				xa_erase(&ctx->io_bl_xa, bl->bgid);
+		}
+		if (!bl)
+			break;
 		io_put_bl(ctx, bl);
 	}
 
@@ -589,11 +597,7 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 		INIT_LIST_HEAD(&bl->buf_list);
 		ret = io_buffer_add_list(ctx, bl, p->bgid);
 		if (ret) {
-			/*
-			 * Doesn't need rcu free as it was never visible, but
-			 * let's keep it consistent throughout.
-			 */
-			kfree_rcu(bl, rcu);
+			kfree(bl);
 			goto err;
 		}
 	}
@@ -736,7 +740,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		return 0;
 	}
 
-	kfree_rcu(free_bl, rcu);
+	kfree(free_bl);
 	return ret;
 }
 
@@ -760,7 +764,9 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (!(bl->flags & IOBL_BUF_RING))
 		return -EINVAL;
 
-	xa_erase(&ctx->io_bl_xa, bl->bgid);
+	scoped_guard(mutex, &ctx->mmap_lock)
+		xa_erase(&ctx->io_bl_xa, bl->bgid);
+
 	io_put_bl(ctx, bl);
 	return 0;
 }
@@ -795,29 +801,13 @@ struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
 				      unsigned long bgid)
 {
 	struct io_buffer_list *bl;
-	bool ret;
 
-	/*
-	 * We have to be a bit careful here - we're inside mmap and cannot grab
-	 * the uring_lock. This means the buffer_list could be simultaneously
-	 * going away, if someone is trying to be sneaky. Look it up under rcu
-	 * so we know it's not going away, and attempt to grab a reference to
-	 * it. If the ref is already zero, then fail the mapping. If successful,
-	 * the caller will call io_put_bl() to drop the the reference at at the
-	 * end. This may then safely free the buffer_list (and drop the pages)
-	 * at that point, vm_insert_pages() would've already grabbed the
-	 * necessary vma references.
-	 */
-	rcu_read_lock();
 	bl = xa_load(&ctx->io_bl_xa, bgid);
 	/* must be a mmap'able buffer ring and have pages */
-	ret = false;
-	if (bl && bl->flags & IOBL_MMAP)
-		ret = atomic_inc_not_zero(&bl->refs);
-	rcu_read_unlock();
-
-	if (ret)
-		return bl;
+	if (bl && bl->flags & IOBL_MMAP) {
+		if (atomic_inc_not_zero(&bl->refs))
+			return bl;
+	}
 
 	return ERR_PTR(-EINVAL);
 }
@@ -829,6 +819,8 @@ int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma)
 	struct io_buffer_list *bl;
 	int bgid, ret;
 
+	lockdep_assert_held(&ctx->mmap_lock);
+
 	bgid = (pgoff & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
 	bl = io_pbuf_get_bl(ctx, bgid);
 	if (IS_ERR(bl))
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 36aadfe5ac00..d5e4afcbfbb3 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -25,7 +25,6 @@ struct io_buffer_list {
 			struct page **buf_pages;
 			struct io_uring_buf_ring *buf_ring;
 		};
-		struct rcu_head rcu;
 	};
 	__u16 bgid;
 
-- 
2.46.0


