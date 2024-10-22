Return-Path: <io-uring+bounces-3886-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B5B39A960A
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 04:12:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7431283687
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 02:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1A9D126C14;
	Tue, 22 Oct 2024 02:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OuSKkTCc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A54A12D75C
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 02:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729563130; cv=none; b=EcPMUXZ2s9vOkEYjXZsP+QaxQ0BD824RpSkCUY5fjoXTVb9L4Kbn/ZKiSU5vkiPuRZ6sFrtJtWVcAX2wnaKAVciLPfA7wH4CYYcyoY6ks+WrhqaTWEHwIKB1HzxnMc3GghMdAfe8zpz4rZxja/hDyoCnRrg98cF9dPbbOGmkEtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729563130; c=relaxed/simple;
	bh=j3VmYIUYlyBTGlqvUIMc0JUgVTjmWoaF5EMC9Dn7Zk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJymP1USk/XGPavXPFeG1XtzzodIIC0MdR0JHOlMhfQ+W3jkWGAglKd0TXClIKKOnfr7vdry6ArkPpajMKIK0K24TE0XwjpJtpQEdNJM7Fr4AcYfZB/YcvVEZLGNFnc6a+vEbe1UT7g2PMtb4lfffFnoNajNoKLwiGuRrUU44cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OuSKkTCc; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7ea7ad1e01fso3419860a12.0
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 19:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729563128; x=1730167928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5+0vcL80oErDAtwoUFPo8e5XBLS2uO6xNRw7O3/obNg=;
        b=OuSKkTCciu+0vb/caJw1SNSyLp6UCsbU4j3srXpwqFN06a+5SD9fmmgevzyrKa9Ntu
         RtQX/M1Kos8IqpHU+f2uHCn+GICvksJ5lJXIZw3NQtWXjWTqUAvv2LmbA/ufUCnKBA8w
         gldkdkeiw/dRp1AYUIeGK7bRF4eG8SaLIldvWYFlS8VE9b/hvDMQhUUJb0HgbL6gSp3m
         KwjbgwZbasPcG3d3BUybQUGvDcx19KFb982e0LhCQlm1vLd582WwuQVR6PNfRPpjVun/
         uyS8T1f8PYxRY+eVn8k31UITMTrzsy7j5OkV11vndOmWn5J7LauTsBGJwYWKIcEspsNp
         68MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729563128; x=1730167928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5+0vcL80oErDAtwoUFPo8e5XBLS2uO6xNRw7O3/obNg=;
        b=e8giZ8dK+MSrYqZVUt7UDspg2QaWySj9fm50Vf2uuA2HqhXodoawc548sxfUwBRUXl
         8yiFEjnv6wduJh7cSdMVZQe3YP3DJSv5rTciqIbWn0gYE5tStRyEe6SVIS0vvNeEhNK9
         PczYRIRx4IMfeNQdcHE+aKkludWYsIgXWtOBUqoiS15dGBw4lLs3MwjF/VHi3ijAK08S
         D5JjhpXWbNzay8lpojnTU5sZCc0fputdkAzpgs+7trHrFtRunpvsYJjVZVz/D7m24G8g
         SmC6QZt4tZVMgfCw7bPg20mYFBX1ZIGnopeOXWHm2LstJOynuVDfRLGtlYwNefKIYXwe
         kq5A==
X-Gm-Message-State: AOJu0YwcoGb0MYo3NS/oIjNleBOYnAbyCnKXcFxYRJEitdR6mMPDawBN
	kUixvV11OOhgpGpWml1d2oDbj63PVwKMqLJjWawVWdBhiuVIe/kC1CSP/VXeB+yjnrvee+NcNlG
	I
X-Google-Smtp-Source: AGHT+IGn9tC7VKQNM0RblVrGLjgt81xbCA7xPZe5fLbsg2c/lSqa4dKcyeTvAFaUFwjKvQ//bfCW+g==
X-Received: by 2002:a05:6a20:d045:b0:1d9:a94:feec with SMTP id adf61e73a8af0-1d96c261e4fmr2820300637.2.1729563128107;
        Mon, 21 Oct 2024 19:12:08 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec131477asm3747060b3a.10.2024.10.21.19.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 19:12:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: abstract out a bit of the ring filling logic
Date: Mon, 21 Oct 2024 20:08:29 -0600
Message-ID: <20241022021159.820925-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022021159.820925-1-axboe@kernel.dk>
References: <20241022021159.820925-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Abstract out a io_uring_fill_params() helper, which fills out the
necessary bits of struct io_uring_params. Add it to io_uring.h as well,
in preparation for having another internal user of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 70 ++++++++++++++++++++++++++-------------------
 io_uring/io_uring.h |  1 +
 2 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6dea5242d666..b5974bdad48b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3498,14 +3498,8 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 					 O_RDWR | O_CLOEXEC, NULL);
 }
 
-static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
-				  struct io_uring_params __user *params)
+int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
 {
-	struct io_ring_ctx *ctx;
-	struct io_uring_task *tctx;
-	struct file *file;
-	int ret;
-
 	if (!entries)
 		return -EINVAL;
 	if (entries > IORING_MAX_ENTRIES) {
@@ -3547,6 +3541,42 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		p->cq_entries = 2 * p->sq_entries;
 	}
 
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
+	return 0;
+}
+
+static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
+				  struct io_uring_params __user *params)
+{
+	struct io_ring_ctx *ctx;
+	struct io_uring_task *tctx;
+	struct file *file;
+	int ret;
+
+	ret = io_uring_fill_params(entries, p);
+	if (unlikely(ret))
+		return ret;
+
 	ctx = io_ring_ctx_alloc(p);
 	if (!ctx)
 		return -ENOMEM;
@@ -3630,6 +3660,9 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
+	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
+		p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
+
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
@@ -3638,29 +3671,6 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
-	p->sq_off.head = offsetof(struct io_rings, sq.head);
-	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
-	p->sq_off.ring_mask = offsetof(struct io_rings, sq_ring_mask);
-	p->sq_off.ring_entries = offsetof(struct io_rings, sq_ring_entries);
-	p->sq_off.flags = offsetof(struct io_rings, sq_flags);
-	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
-	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
-	p->sq_off.resv1 = 0;
-	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
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
-	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
-		p->cq_off.user_addr = 0;
-
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4a471a810f02..e3e6cb14de5d 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -70,6 +70,7 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 
 unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 			 unsigned int cq_entries, size_t *sq_offset);
+int io_uring_fill_params(unsigned entries, struct io_uring_params *p);
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
-- 
2.45.2


