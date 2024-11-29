Return-Path: <io-uring+bounces-5146-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4794A9DE7B2
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A24DB23AF5
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B46199E89;
	Fri, 29 Nov 2024 13:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eJy4hLyf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9907D19E980
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887252; cv=none; b=U6BVvatg5E+XjvmrttZowHK8mCtZMMPtkwrI5j4KFFS3bCPgFTAVMwEZttrmVYowROa4kpeGkwi4wuPCSlkwf/bkPg76hBLAFv1jRDaMylrVj/HXqfnvBa109ODW3X62Oi/PU8U/W8Z/YGJbpAYhdADwwEJDa/GILYCf5+AG2Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887252; c=relaxed/simple;
	bh=i4q5zoh+RVcVUtG+p4DEvHPHxUCZOGcdxw6RV/ymmA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLGqn1DILU2yuo9+bE7yXuQOoF/RV6tma8xpfGt4fc9DajcSMR2qS85EpPrZSjSgWZ9UxXyo+d35xKm+KJ6RuVMSpyTrEoSWLzTt5FMBhgFssqio72YbLV+qeTUiH/pQS92bhWIkywHXFISHwrayqqOJu6om9ap7MSN6VM5pcSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eJy4hLyf; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2ffc3f2b3a9so28133921fa.1
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887248; x=1733492048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3MlVDCt73aMY59x9K9s6HGMef2pKI7M9nX1Jols9I8s=;
        b=eJy4hLyfWQbzalDW/SkuVVvnZo5O9wBHHnDO5dOtE1QQ/Qz5fW1PKh0q8nMSXbNAMl
         4muNRfqTsgXOXlxN5CUvfdZ/9rXrX3+Laqdh3GaS7HWs5U3BQt2pPMsBv4AaOxg5+ta3
         4+QyeCzlKHHAdFw8m7ERePgEsltgL8KnVQFoe5RyLLrQsLwjpsCZ/JAQYhSkfp3/36ih
         sSZsH4JLcnugJ8QSK/mUYTa8iBiSLNLoHbSUiWIO8/LNGUs3R9Au0/ES2JAVh8K1hOrP
         5J2d23miFWWdFJuBypiXWNcYtAxLHKmDqkYFkrOEnvhcjA/GqfyAEL0/KP2TEkvtZ4tC
         7b8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887248; x=1733492048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3MlVDCt73aMY59x9K9s6HGMef2pKI7M9nX1Jols9I8s=;
        b=vc7kmfgnxXID0/tVMcSRR5JPBq71mDPkK/TAslmWUydvtP/MQn3qmaBCfnWLLj6aOV
         QC28v4dEIc8KX/yQ6f1Bd85A/5gfi/R0EJFdEAhXKtZ/34nqs2eSnOkPcnR46h/Xy06q
         I1/C9BHG+fTaZTX943dSWgBxuEfSJNGlNQWccr3sWgI1W1NGrzIA5N08yr6hhHemZ+el
         V/JBkZYflr8Y4+YddzxmsM3F/jOPJTasMxyLniAImPPbbBoiP8oZ7a2ZeOo+TtXZOrvb
         9ZWxdww2tb6Cqg8lOOVWWr3+yPy8CekGtIq73q6e/0S3Bp3IDbI6uvB1Fol1kpCYqQ8v
         enDw==
X-Gm-Message-State: AOJu0Ywe4Cfi/bfwGSL4CBEXts94e90LD8NDpUvZ/ZRTWJDi4W/885I5
	KK2rFPmNmjiXKqiSFqi4t1lX1DPNWVvq1IvDOiPO0/KCGkpZtrP6/dhq7w==
X-Gm-Gg: ASbGncsgEREcQXHwdj2FbUaqfiZgIjkimfcdVzawKzq8bGe882dKOQzgc1u+fdr7cd8
	H5A2iW1lxBlGPXV4DBbF6KsKTFcpGyLM5gFUcMFaPz6QsiChhCUrzR5nldfPCGkSGMI0GK916o8
	e6/QiqnaGKfMGKupBT57mFyuHZNbPvn6nntwXUzKS2QVHRp/RtoYYh/RJDukk03GtT1BnI9qVHu
	sUknAoyOrx3InUybP+i6jGWiEBCyCV+6XmsrrhfNfZ+4pe4UE4QsvXOjOBogrjj
X-Google-Smtp-Source: AGHT+IEC9Nr3jv9IOdfVLOqyjYo65D+PQvIY/jfS1Zo0sYD4VuowdY+npIwh8kBcJWpiomfb3Ks+xQ==
X-Received: by 2002:a05:651c:508:b0:2ff:cb81:c016 with SMTP id 38308e7fff4ca-2ffd6028d77mr108125271fa.19.1732887248090;
        Fri, 29 Nov 2024 05:34:08 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:34:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 15/18] io_uring/kbuf: use mmap_lock to sync with mmap
Date: Fri, 29 Nov 2024 13:34:36 +0000
Message-ID: <af13bde56ee1a26bcaefaa9aad37a9ea318a590e.1732886067.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1732886067.git.asml.silence@gmail.com>
References: <cover.1732886067.git.asml.silence@gmail.com>
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
2.47.1


