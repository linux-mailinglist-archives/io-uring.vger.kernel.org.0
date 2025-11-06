Return-Path: <io-uring+bounces-10417-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A850EC3CBA5
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:09:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF84D625DDF
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D26734D907;
	Thu,  6 Nov 2025 17:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q0m+IroC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A692BEFFD
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448533; cv=none; b=R6L5ERhaIRB+eI1ZrglCRM73dEUTOTxVDPczC3+NR23IPKGmHFEOpRIq/PiGIjRRsevoQHglIq+7FGBO1vZ93EvacMUf69F+fBwT1s+q7rCEdUEhg5aZ59+KffLIPTKsr3RWZZQxhdWVatIzDfr5P7pgJa8UI2xV5K4/ORMktX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448533; c=relaxed/simple;
	bh=kwDqzAjalBI07PwYQ120sBuE0flrWriYpW9nunDDVfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1GdN/a6p69Zs5G9Cn68tV1KJTJkCLGMDJ+2gjUXUQUDVJ1JPvvFgzPxSPLGabvGYi5sk36MDLYbSGiNrH9Ek/IuUjPA3u7bgDl+TGQYcOJ7hspMb4yoq8Dq7c7KDAfBn7a7NhKW3ottlSg5AMyjKPlm2p4f4VIO3meGeaggTXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q0m+IroC; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-429b7ba208eso752531f8f.1
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448529; x=1763053329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nh7Ql+r+42HVCAWObafvgkpSLlKq5tXNTj0FPLjxOdk=;
        b=Q0m+IroCQJ5f8oyVWWP4r5M/mEmkQv+wZQYF5Olsk6JNK3cJB4+v739U94nkbQr9aJ
         oS77YEVp63DGTL4l23ptDCtpYFciVgoV69qYqNPrk8YXXS8IWZXOyewbA0gzVcHnncAl
         wSg6QfLQDvWZYw351BWu7VbvAuSn50Zn6jGRF83GJQJJ7nwogPhY3IVBQNk/IUVeBj3G
         5UpolkA2f8GR36sBYWHoiKRJSe4Rrx9vKuNrcFrXvO563mHTApPw4oGrxaYsYY29tRIV
         uuTnzlXpsy/VJYzOD8epbsN+57YO5dC8m3V3Z/99EoNCPwDa+4VqYN4Jg37f97obrj41
         4L0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448529; x=1763053329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nh7Ql+r+42HVCAWObafvgkpSLlKq5tXNTj0FPLjxOdk=;
        b=I+F0ydu+0CLsFlzNR5ZfpecCMBTJw+t9PYr0vKsxtokgCxR/y0I0V7aRXBGlpdeeM1
         mGMLcxHGoInsPuKiV4USquf3s0P5gcs44xxlvfZ28s0YN43ybZBgZchRwEYdx0QgN/BQ
         pPH1TnXXegTjvEOwnDT0s2nl536EpnBLRUvU9RTz6wHXEyrlJk5bIVeB8Yay9dEczEDc
         qHwAdJ2K42kJf8rKsrRMfDTZyoy5o1RHrUzdoJeC0vbU8uCUobanUqZAJR3DlrBDdKjT
         q2/xia1qaL2eK+KXnRWICdT7r7WUQIlBVma8WX6pFz3yEZC8SR/U6iWDsClVX1KSqXNH
         1wow==
X-Gm-Message-State: AOJu0YwoOMaj17wsP6TiHVWLKYz/kJviGfgUd90FSKmGULUAYbkylYkm
	9qmrY90ULKgfRC1lhOLY9pnL1GgQNNVzz7w2xWfd/x//IimMoTzpcuPnY9vfDw==
X-Gm-Gg: ASbGncsVfcNr2a+kFyUDg6HxM6a/2J+29NT3+pB4g8cXfdOKPWHlyUROIoxBLldVFrJ
	bSFGMmlr98qFblssmBaiXXQ0ndR4tyIBVr4csrh1TZWPa3xKZJyOf1u54cMt4bhgIdjNe0Wq6Ce
	guZAoDVKs2YMRwvYx7f7opEuffCLRqRhdOFNS5XwIZqszMLGODziK+as5q8262JyO9S1Xyhz6NL
	jIBSyiiczANKGu66RSl+NmMVCbZfOQJ38x++WS7L+b6S/NbYXq6Ovz91bWxiSN82ZAh2JMnpsDG
	Yj2yTLkaNBCoI/wbWM41ape7ft+uS28iib2m9YhfL5KraGl8II19pu7OMHUwlMTBKl+Rwi/vYoE
	1G36E1ZUDVZ3AzTTXeQlPyUcJ7lYcKU3BD8FEj4lbCQSy9IagSZm0zFWIidcW86+cIayDF9LjTA
	UxuVbRhfCeRnte5w==
X-Google-Smtp-Source: AGHT+IHn0j3Cy/Ny1+Fdijq+15aibZwsBh+Myb7ISr5xRYiZWdOvgghJjdIrm6ZwECR+ETnznRyIxQ==
X-Received: by 2002:a05:6000:2503:b0:429:d48c:edf with SMTP id ffacd0b85a97d-429e32e45a9mr6655227f8f.24.1762448528868;
        Thu, 06 Nov 2025 09:02:08 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:08 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 09/16] io_uring: inroduce helper for setting user offset
Date: Thu,  6 Nov 2025 17:01:48 +0000
Message-ID: <d6dff0fbc616ba36441181a66447fcefb3982d1c.1762447538.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762447538.git.asml.silence@gmail.com>
References: <cover.1762447538.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct io_[c,s]qring_offsets may require computation from other steps
like in case of sq_off.array. Move the initialisation out of
io_uring_fill_params() into a separate function that can be called
later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 52 ++++++++++++++++++++++++---------------------
 io_uring/io_uring.h |  1 +
 io_uring/register.c |  1 +
 3 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index aeb9555bd258..be866a8e94bf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3487,6 +3487,33 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 	return 0;
 }
 
+void io_fill_scq_offsets(struct io_uring_params *p, struct io_scq_dim *dims)
+{
+	p->sq_off.head = offsetof(struct io_rings, sq.head);
+	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
+	p->sq_off.ring_mask = offsetof(struct io_rings, sq_ring_mask);
+	p->sq_off.ring_entries = offsetof(struct io_rings, sq_ring_entries);
+	p->sq_off.flags = offsetof(struct io_rings, sq_flags);
+	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
+	p->sq_off.resv1 = 0;
+	if (!(p->flags & IORING_SETUP_NO_MMAP))
+		p->sq_off.user_addr = 0;
+
+	p->cq_off.head = offsetof(struct io_rings, cq.head);
+	p->cq_off.tail = offsetof(struct io_rings, cq.tail);
+	p->cq_off.ring_mask = offsetof(struct io_rings, cq_ring_mask);
+	p->cq_off.ring_entries = offsetof(struct io_rings, cq_ring_entries);
+	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
+	p->cq_off.cqes = offsetof(struct io_rings, cqes);
+	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
+	p->cq_off.resv1 = 0;
+	if (!(p->flags & IORING_SETUP_NO_MMAP))
+		p->cq_off.user_addr = 0;
+
+	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
+		p->sq_off.array = dims->sq_array_offset;
+}
+
 int io_uring_fill_params(struct io_uring_params *p)
 {
 	unsigned entries = p->sq_entries;
@@ -3528,27 +3555,6 @@ int io_uring_fill_params(struct io_uring_params *p)
 		p->cq_entries = 2 * p->sq_entries;
 	}
 
-	p->sq_off.head = offsetof(struct io_rings, sq.head);
-	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
-	p->sq_off.ring_mask = offsetof(struct io_rings, sq_ring_mask);
-	p->sq_off.ring_entries = offsetof(struct io_rings, sq_ring_entries);
-	p->sq_off.flags = offsetof(struct io_rings, sq_flags);
-	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
-	p->sq_off.resv1 = 0;
-	if (!(p->flags & IORING_SETUP_NO_MMAP))
-		p->sq_off.user_addr = 0;
-
-	p->cq_off.head = offsetof(struct io_rings, cq.head);
-	p->cq_off.tail = offsetof(struct io_rings, cq.tail);
-	p->cq_off.ring_mask = offsetof(struct io_rings, cq_ring_mask);
-	p->cq_off.ring_entries = offsetof(struct io_rings, cq_ring_entries);
-	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
-	p->cq_off.cqes = offsetof(struct io_rings, cqes);
-	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
-	p->cq_off.resv1 = 0;
-	if (!(p->flags & IORING_SETUP_NO_MMAP))
-		p->cq_off.user_addr = 0;
-
 	return 0;
 }
 
@@ -3569,9 +3575,7 @@ static int io_prepare_config(struct io_ctx_config *config)
 	if (ret)
 		return ret;
 
-	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
-		p->sq_off.array = config->dims.sq_array_offset;
-
+	io_fill_scq_offsets(p, &config->dims);
 	return 0;
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d1c2c70720f1..f6c4b141a33d 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -151,6 +151,7 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 int rings_size(unsigned int flags, unsigned int sq_entries,
 	       unsigned int cq_entries, struct io_scq_dim *dims);
 int io_uring_fill_params(struct io_uring_params *p);
+void io_fill_scq_offsets(struct io_uring_params *p, struct io_scq_dim *dims);
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 int io_run_local_work(struct io_ring_ctx *ctx, int min_events, int max_events);
diff --git a/io_uring/register.c b/io_uring/register.c
index 85814f983dde..da804f925622 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -423,6 +423,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	ret = rings_size(p.flags, p.sq_entries, p.cq_entries, &dims);
 	if (ret)
 		return ret;
+	io_fill_scq_offsets(&p, &dims);
 
 	size = dims.cq_comp_size;
 	sq_array_offset = dims.sq_array_offset;
-- 
2.49.0


