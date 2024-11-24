Return-Path: <io-uring+bounces-5023-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D84099D7844
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66A6C162BAD
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E61163;
	Sun, 24 Nov 2024 21:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lLAdqA8n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3487E15B97D
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482743; cv=none; b=jUVgSk8MXuL94nEvmd9l8aVy+coSKrygujP65VfP29weDCdk8t+GR9zAFjyFvX/0Mpgpp9+zA1y8gErQJialTCSFhYWuDoYC0PtjbCzxAp/6d7pTlqQcHJdKAZlRDlCZWArkOve5DqLvuzJ2dXoklY/ongsWoGsvfhlfjOjVEjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482743; c=relaxed/simple;
	bh=HBHMOwbntdYlLb19w1mghXVhp16gZ994kKx4hDX4zC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5B2s5R9sqdmeFj9wKakuN2DvzGzmV4+aEDBgF51GA7C5aQ5mHcYqBB2I/q4Q15rbaHuLJHCDvCndR/4Zux3dav+ZBvn5EJi62BeI+pkOeLvwHUXuw4beUIKLK6yoAz7+ovbfIXNdMJPC67oS4+p4bdwDOhCMpwuYjWNyw1Ogf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lLAdqA8n; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4315baa51d8so34456135e9.0
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482740; x=1733087540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jtAiMRa8mZj+7A/VMGZktqkrs4UQMtnl0rhZfY6g9rA=;
        b=lLAdqA8n/T71tJs68TEhGccPE9Jp/J7i8chibelbeH+WmFPBX2gM17n5/Y3QzbMdyN
         Usr9JnU5zFf7M7OeEDC+d6MKDAJftXDnRwdcSCl3CihBeUsHGFBfxOTESH9HUdsJzRZc
         ZH1bEbdtIG98wJGeao+FYRsErXlePD2Uc3oQj6UzM0wSJTgiT4Ip7iEdIbcb3+ZzugeZ
         focwRQPajVnXx5HRBPYhqsXXzrFTWJZCQ3g/569NgPClrE5tNs2SfZHAFZZ/mdwwtF54
         QK7NtvFxZ6NtAP9VSmLafRcYrlcxXlx+fsR5VoFANSugXgBdXvGTO6bSi+Lg37P2/sPT
         ZJqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482740; x=1733087540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jtAiMRa8mZj+7A/VMGZktqkrs4UQMtnl0rhZfY6g9rA=;
        b=Sjm0g4NsVUbjY8AkbHnifVbhmrZVMoPgbtef8IB2EPYSIfF1lSIuEEwWD9UiEjUhS6
         RwIu4s+WrfBf8NH7eL9od7KFwLksxPZ/8zv3lP3mFfaz5JcG+SiDToJP7hAoO0oQ8HjG
         S2qs+4URMWtxfs28YzxctU1g8Qd2ck5DLldSVSmw3GwzAG2DcFBwat+8H8PasU28xkSY
         avXMQdy9QUjx165iO0WcutCqTxPKJr+7GMUS9Z/lQC5wL8XqrpAn+oaJXeHob/BwNHIM
         UDrVnc41s6y7twNp//NM20Ev0cJar6rbZ00fBFE6m0n+2euiE+e/m+Si5pvBkGRzrRoR
         Zh2Q==
X-Gm-Message-State: AOJu0YxqjAQepOSA1pw+tWEzL3OZuYRVfiXav2DYeXjPdfpFjhy/jZ/u
	JFy/xbKeyVsYIi0AyQcWSlCEnKbksQh9cUkVXJhHbHOkXsiRBR2hmWUofA==
X-Gm-Gg: ASbGnctf3ilh34HrpVACYxVp0+ceDmuDEfETqdK5Ej0sE29Udg6zs6ICwShVujjvWgZ
	T3Px52G6GxJU/7duSlkuTOaP2JM6lk8BLI6X8aXpI6KaF4fzUO1uUh3ogZ6msDAsFNCXJcZEYHX
	SuTUGPLn4LMCo1tuit5AgObIa8zedSMmbYWiK3v1TUTN26Hs/sHZ89ZsnigpuyN+fM0JrlcwwNR
	rMST9rquS6GL4+7uwh7WqHk6xog7BO1Jr0W9oP6GMWQLLq1YH5DjZJ8JSfHZfg=
X-Google-Smtp-Source: AGHT+IGs2+wJa4E+BCMWu7M4iOGvF0bPQa1i8zpkqXsimgkNZxOD9yRm+DsVdFBoF1HrOxrGHOrswg==
X-Received: by 2002:a05:600c:1c0b:b0:431:52b7:a499 with SMTP id 5b1f17b1804b1-433ce48ea08mr81224875e9.20.1732482740408;
        Sun, 24 Nov 2024 13:12:20 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:19 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 16/18] io_uring/kbuf: remove pbuf ring refcounting
Date: Sun, 24 Nov 2024 21:12:33 +0000
Message-ID: <88da9858b1d5cd09013125a96f42c74f9e10aa1b.1732481694.git.asml.silence@gmail.com>
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

struct io_buffer_list refcounting was needed for RCU based sync with
mmap, now  we can kill it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c   | 21 +++++++--------------
 io_uring/kbuf.h   |  3 ---
 io_uring/memmap.c |  1 -
 3 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 662e928cc3b0..644f61445ec9 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -48,7 +48,6 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	 * always under the ->uring_lock, but lookups from mmap do.
 	 */
 	bl->bgid = bgid;
-	atomic_set(&bl->refs, 1);
 	guard(mutex)(&ctx->mmap_lock);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
@@ -385,12 +384,10 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	return i;
 }
 
-void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 {
-	if (atomic_dec_and_test(&bl->refs)) {
-		__io_remove_buffers(ctx, bl, -1U);
-		kfree(bl);
-	}
+	__io_remove_buffers(ctx, bl, -1U);
+	kfree(bl);
 }
 
 void io_destroy_buffers(struct io_ring_ctx *ctx)
@@ -804,10 +801,8 @@ struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
 
 	bl = xa_load(&ctx->io_bl_xa, bgid);
 	/* must be a mmap'able buffer ring and have pages */
-	if (bl && bl->flags & IOBL_MMAP) {
-		if (atomic_inc_not_zero(&bl->refs))
-			return bl;
-	}
+	if (bl && bl->flags & IOBL_MMAP)
+		return bl;
 
 	return ERR_PTR(-EINVAL);
 }
@@ -817,7 +812,7 @@ int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma)
 	struct io_ring_ctx *ctx = file->private_data;
 	loff_t pgoff = vma->vm_pgoff << PAGE_SHIFT;
 	struct io_buffer_list *bl;
-	int bgid, ret;
+	int bgid;
 
 	lockdep_assert_held(&ctx->mmap_lock);
 
@@ -826,7 +821,5 @@ int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (IS_ERR(bl))
 		return PTR_ERR(bl);
 
-	ret = io_uring_mmap_pages(ctx, vma, bl->buf_pages, bl->buf_nr_pages);
-	io_put_bl(ctx, bl);
-	return ret;
+	return io_uring_mmap_pages(ctx, vma, bl->buf_pages, bl->buf_nr_pages);
 }
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index d5e4afcbfbb3..dff7444026a6 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -35,8 +35,6 @@ struct io_buffer_list {
 	__u16 mask;
 
 	__u16 flags;
-
-	atomic_t refs;
 };
 
 struct io_buffer {
@@ -83,7 +81,6 @@ void __io_put_kbuf(struct io_kiocb *req, int len, unsigned issue_flags);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
-void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl);
 struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
 				      unsigned long bgid);
 int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma);
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 52afe0576be6..88428a8dc3bc 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -384,7 +384,6 @@ static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
 		if (IS_ERR(bl))
 			return bl;
 		ptr = bl->buf_ring;
-		io_put_bl(ctx, bl);
 		return ptr;
 		}
 	case IORING_MAP_OFF_PARAM_REGION:
-- 
2.46.0


