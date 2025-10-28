Return-Path: <io-uring+bounces-10268-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D218C16472
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 18:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D9F4C356576
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 17:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E564634D4CE;
	Tue, 28 Oct 2025 17:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="YJMo1jpF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432473451AE
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 17:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673605; cv=none; b=DqGeMPa5kKzCLF5AbGgiCtGshmCSUVUjwMmeWSeVvIhBGKu9tPGX21w6/zJs9kAbJ8dh98D76hc+bmtW4hJhO4HhzeSCy8p1HSrMGU5nfxmpvphxnMFpYXJ/T2bOya8OjeEUvlR7aEa4tNFpGwe2Bw/lTe2VDwYxjzd1drRkoSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673605; c=relaxed/simple;
	bh=/6TeMQIZFGOGBftkQFVAyJCfXQVP0Dd9lxnoQSG7qIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArlfaeOCDVte6SCvv8m3py6ZT2sRuCcLdsTuRXHOLSa/53Z1SeYtUaLxx4g+hyAcCF1h/5Va6nCIsDft//igLDF8eGMcVCnsGfDkBL1sRHTF6LqeD5T80SHbMkBYdilqRLYAunGl67u5oNZpE+xx50kIIUXDV5pwEHgED60wIHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=YJMo1jpF; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7c2948b774cso3498556a34.0
        for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 10:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761673603; x=1762278403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hz8W4FYKKdml45Vr6A3xpwDAjARBCNSHsrnQa69SYYY=;
        b=YJMo1jpFP5wcQwtX7wOYhJUYsBjofCR0pvzm0qsnajXeHqPpy8qd1OwGZ6ledxy5HQ
         VViCMsrTDwqAmE+7CfJyrj/gtjdRLYQJLb8Gj6qPSwxcqDdPySpPIq5+779LH5woLKM+
         kEYfGCJu19zM3DjEoVcgMGbbzx9CN7pONAcjJpmKG2PK0Rc7RJbRhqKuIwV1Ftn4Ss6K
         jSAJST4VFGTgn+7ZcZzttZrAD86zBgVqzjbO/Reu6yMmx2+kVDpkfPIKBIHstYtd3lTg
         ZC1dXJZFO04Fqkk4nZfGZuYolRMsucEklTFtJikxJgOiqXIo05ON/nV3SliX394gf/PN
         dovA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673603; x=1762278403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hz8W4FYKKdml45Vr6A3xpwDAjARBCNSHsrnQa69SYYY=;
        b=SJJdVRb1BcKtkqJW+dPV5qqMJhip2bX66cOXSS/pF5ldYD4qUb+8wSZMhTBcP1RvjU
         XlMv+Q7s0Qgi+kIaUJ9g2QHTTW45vudITp8AopRtZAwnTzXxq+U1Ez8OTPf32xYThA1t
         MJEXM5i2l6OME1Qk7hahpudWd6oC6UD5ufxs4eSln2jtcIcev48dO19HvUVilIG3u8em
         vovZPIbShlV7nLIzhsEECNwhmJzQ5wn9sXdErQ7qii5R5N2Pp0Y5RFbtEGBgwBIsJ5xQ
         V19hUf36nyLkEKAvTjkYqVDPPB/36ysNntLxmqLzfe0CtrWZQYbCbGLoQlgaLPwhlu6A
         4xXQ==
X-Gm-Message-State: AOJu0YzbKXlmOUX8gvyN3cxPms7rJ/y9SSJ3vRZBbtydUNvrgV0kglmx
	kdb+bgqFicM0JwlAUtCnBNtlBnuceZBjR5jmj6WZgRSCwDgrsUVYfTZWotz+3rKsHqhWahdcHbD
	ewx4b
X-Gm-Gg: ASbGncvhYeab194PO2VgYcbcQXVmc7lXCU5XxDWgAsGwjMbEMRrpbMUFuNmeLD2XkQP
	VE7tFEE62TmPqqh7PkUseRHl2yPHMQgk80pLx/Qj8x4gS4JDTPGRZPB2JfbJS8gYjH7tfBmJQ//
	aiJLbAVhVs5rJO28FdVCJjjwo99lr4iRLoqJRHTOkrBy5p+ZSpNWoSU8Vn6SDTOFwDGbXY4bElm
	CKIvMFhKhtg/nuJ03ZUtYHeHs1mqeLhelbTn4Ja+mSPmMX0zd8ofLLDnaPXwjFkMWc1jbRWApjX
	7YLO/17p2HzWKaslBBJy11W4j1ucJO7no+E37RvWGwa27r7iPZNzbMZs3cUB1Y0fbWRGDJy2L9+
	ZR5P2c4kAGck93ex19vaRzuAGRAngx6Go/F+1LblXCPhm/GoW2Phd+N62iAvOShlEfm4qc4vLiu
	OxycKnlYc3Le2gF7QNsg==
X-Google-Smtp-Source: AGHT+IEkitXBhX7cJjhHDx3sMlWCKoCENN9fSQ1fUnTNhyi1E839jKAcxNTQny4kXNc7sSkF19aTiw==
X-Received: by 2002:a05:6830:411e:b0:7c5:2d86:cdf8 with SMTP id 46e09a7af769-7c68312b6a3mr91549a34.29.1761673603371;
        Tue, 28 Oct 2025 10:46:43 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:8::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c530206ddfsm3383717a34.29.2025.10.28.10.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 10:46:43 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 2/8] io_uring/memmap: refactor io_free_region() to take user_struct param
Date: Tue, 28 Oct 2025 10:46:33 -0700
Message-ID: <20251028174639.1244592-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251028174639.1244592-1-dw@davidwei.uk>
References: <20251028174639.1244592-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor io_free_region() to take user_struct directly, instead of
accessing it from the ring ctx.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/io_uring.c | 6 +++---
 io_uring/kbuf.c     | 4 ++--
 io_uring/memmap.c   | 8 ++++----
 io_uring/memmap.h   | 2 +-
 io_uring/register.c | 6 +++---
 io_uring/zcrx.c     | 2 +-
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 200b6c4bb2cc..7d42748774f8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2798,8 +2798,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 static void io_rings_free(struct io_ring_ctx *ctx)
 {
-	io_free_region(ctx, &ctx->sq_region);
-	io_free_region(ctx, &ctx->ring_region);
+	io_free_region(ctx->user, &ctx->sq_region);
+	io_free_region(ctx->user, &ctx->ring_region);
 	ctx->rings = NULL;
 	ctx->sq_sqes = NULL;
 }
@@ -2884,7 +2884,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_eventfd_unregister(ctx);
 	io_free_alloc_caches(ctx);
 	io_destroy_buffers(ctx);
-	io_free_region(ctx, &ctx->param_region);
+	io_free_region(ctx->user, &ctx->param_region);
 	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index c034c90396bc..8a329556f8df 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -428,7 +428,7 @@ static int io_remove_buffers_legacy(struct io_ring_ctx *ctx,
 static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 {
 	if (bl->flags & IOBL_BUF_RING)
-		io_free_region(ctx, &bl->region);
+		io_free_region(ctx->user, &bl->region);
 	else
 		io_remove_buffers_legacy(ctx, bl, -1U);
 
@@ -672,7 +672,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	io_buffer_add_list(ctx, bl, reg.bgid);
 	return 0;
 fail:
-	io_free_region(ctx, &bl->region);
+	io_free_region(ctx->user, &bl->region);
 	kfree(bl);
 	return ret;
 }
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index d1318079c337..b1054fe94568 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -88,7 +88,7 @@ enum {
 	IO_REGION_F_SINGLE_REF			= 4,
 };
 
-void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
+void io_free_region(struct user_struct *user, struct io_mapped_region *mr)
 {
 	if (mr->pages) {
 		long nr_refs = mr->nr_pages;
@@ -105,8 +105,8 @@ void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
 	}
 	if ((mr->flags & IO_REGION_F_VMAP) && mr->ptr)
 		vunmap(mr->ptr);
-	if (mr->nr_pages && ctx->user)
-		__io_unaccount_mem(ctx->user, mr->nr_pages);
+	if (mr->nr_pages && user)
+		__io_unaccount_mem(user, mr->nr_pages);
 
 	memset(mr, 0, sizeof(*mr));
 }
@@ -228,7 +228,7 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		goto out_free;
 	return 0;
 out_free:
-	io_free_region(ctx, mr);
+	io_free_region(ctx->user, mr);
 	return ret;
 }
 
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index 58002976e0c3..a7c476f499d5 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -16,7 +16,7 @@ unsigned long io_uring_get_unmapped_area(struct file *file, unsigned long addr,
 					 unsigned long flags);
 int io_uring_mmap(struct file *file, struct vm_area_struct *vma);
 
-void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr);
+void io_free_region(struct user_struct *user, struct io_mapped_region *mr);
 int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg,
 		     unsigned long mmap_offset);
diff --git a/io_uring/register.c b/io_uring/register.c
index 1a3e05be6e7b..023f5e7a18da 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -381,8 +381,8 @@ struct io_ring_ctx_rings {
 static void io_register_free_rings(struct io_ring_ctx *ctx,
 				   struct io_ring_ctx_rings *r)
 {
-	io_free_region(ctx, &r->sq_region);
-	io_free_region(ctx, &r->ring_region);
+	io_free_region(ctx->user, &r->sq_region);
+	io_free_region(ctx->user, &r->ring_region);
 }
 
 #define swap_old(ctx, o, n, field)		\
@@ -604,7 +604,7 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 	if (ret)
 		return ret;
 	if (copy_to_user(rd_uptr, &rd, sizeof(rd))) {
-		io_free_region(ctx, &region);
+		io_free_region(ctx->user, &region);
 		return -EFAULT;
 	}
 
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a816f5902091..d15453884004 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -378,7 +378,7 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 
 static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 {
-	io_free_region(ifq->ctx, &ifq->region);
+	io_free_region(ifq->ctx->user, &ifq->region);
 	ifq->rq_ring = NULL;
 	ifq->rqes = NULL;
 }
-- 
2.47.3


