Return-Path: <io-uring+bounces-10540-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B5BC52534
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 13:51:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8ACC94EABF9
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 12:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD0E733555E;
	Wed, 12 Nov 2025 12:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hiv3aPpL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D757A31326C
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 12:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762951581; cv=none; b=nFb/8E8pqnBsgoBFg9MVvQebTi3s9YPncrGbEIYjjC5BuqFkuYADtXcOBCktlnz95SW9De0iqLDBENAA105JAp9/YG7UQeYwc9yzHPVn/Myt5wu+0d95T8v2OvXrkGeBbGQ5zYZn0aU5redPCQ+vwb26xnGSWw8jmQ8lIzfstKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762951581; c=relaxed/simple;
	bh=K7oeR7e7DkzlHjq5Pnbs5c62vzZE1vXGEs+4Xwc2+ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBNrR8+68PD35wmvil3z3WDkh7dpLTFHGB+ysKy4QcXaJFiXE66jSMFTbudBeeRio2lqv2nEyLRvzNCZykpVT0BeLqxNqZ/ORU/x1jeR5XYB9n4PcqZMbn/KtaZqreCirvnke4PQKkv9E4J3ZwqS/ThYCQ3VngfSxp6jH1V+MtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hiv3aPpL; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4777771ed1aso5645115e9.2
        for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 04:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762951577; x=1763556377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GbwKHinxOykmkOdqlBvR4EMhrWztjxoItvy817OvXCs=;
        b=Hiv3aPpLGhTbfwEZKCPYD2985wgDZch0hHSBXTL09i1B1Zz56e9ica2GHPDLtZMMBK
         eJSdsoxyfJoEjF+74fiZJJ5MLVTXHJjtLwpO9zihPAwLMJ8ZCGwaAxw6XaHQy/y0CQfx
         hMQLhRWnloAp3SrBT8NPSU+pc5on+H47ok/jEPDIier/s4HkfiNgrZoGBRJCj9p5/T6N
         ZxjxvLhn4pbIrHIQ89MZncfRWAAam8lMF+TqFn5ullYuUvbCMH8E3UbAtELoIuJ70/gL
         fxncoskEAdUEVYHqYYYyPcWkHEDdGaZb1YBzsi46nCE9TYxmPgkO4teXHTT4pJW/4aU0
         Puwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762951577; x=1763556377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GbwKHinxOykmkOdqlBvR4EMhrWztjxoItvy817OvXCs=;
        b=c85acFrZBmZapJdXbucw8bFFTMF5KdMgYaPnSy+A+XmOe0mbSm3A32SbpSb2OlYrb4
         UP3gLs1wC5imIXLKfbnyknHQso541TmoU30eEkWFZ2lD+PheWxK6k3vFM8ZlTASqoB7/
         5kin0DQwRfD1qgzqPTkjMe8pvNcP6wUYVdwspALt2Jjy5ZIsF5cOhfb2MkexJgjbHiDV
         kbzGYD0Ia/VB80BOf2H4GyPHIhnvPUM05HpRPZd+dhoaO34kIhYjIVeaFKZpTRfLKqeB
         wlBIubYX/3uKDOQj4lDlYhhWg7AeWZs+qEhZjq+wqSb/Gp0ZDK2UP7nEOc5xXkjZalgU
         zLog==
X-Gm-Message-State: AOJu0Yz+HwfRDaoFqFJCuQChN9y5AZ69Uwiz8IDNkAFgBcyRZIXo3TGz
	V8hzc4z+QgP2NHMoKm5pqzNEyZmBXSn4P46F9QZdvr+kJIquWBAXnOYsg4zqxg==
X-Gm-Gg: ASbGncs4CnIWs/e9NFPDZDnNT+xMbQ2w3QNbos7Co4AXdjLZNVKCL0bnBY44bw5e8jd
	IT9otWrnfsnLMqgNhGjYySgg50J//7zKC7QJigz385vgBCuMzSPizdnmlgYJj20SXu+G/tEWi4y
	h5ZGQ1FBb2zew8Bu0hlqbnzRvfh+nHKjTL/8EGseiiF6bDLKqX7K/+PXdc59VoeP0PM67sdK8xM
	RsbpLLy2UK+yg06N9So07OkcHtFTQbUHHqwdqXIwGOALEU6T1e8V5JJUwLsvKLA2aEt7kKMvcZe
	K1YF1+fgHAFAsqw765Vy70YaNrfwHMkAL/u/tjjiyai59OwQYKNB5xnGyhNRFTNBa3wCU/PVVZH
	w4i0nQk6D0lKwK+09R2UOYLy5FeS7+hPLOr8r2TGtCCJaHmAJV2Dqc6UmKak=
X-Google-Smtp-Source: AGHT+IGt32yJIIf5OVJKmNA6bLkd5/MnyRLnHjVn18myvV/xlpV9Z6T45xesZQH+ct+SzGcOe+0qDQ==
X-Received: by 2002:a05:600c:450e:b0:471:786:94d3 with SMTP id 5b1f17b1804b1-4778708666emr27101595e9.22.1762951577437;
        Wed, 12 Nov 2025 04:46:17 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:2601])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e58501sm33846795e9.10.2025.11.12.04.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 04:46:16 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/7] io_uring: introduce struct io_ctx_config
Date: Wed, 12 Nov 2025 12:45:56 +0000
Message-ID: <1e67e5b3f27a6d7ee95710b5dbc38b56183bf764.1762947814.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762947814.git.asml.silence@gmail.com>
References: <cover.1762947814.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There will be more information needed during ctx setup, and instead of
passing a handful of pointers around, wrap them all into a new
structure. Add a helper for encapsulating all configuration checks and
preparation, that's also reused for ring resizing.

Note, it indirectly adds a io_uring_sanitise_params() check to ring
resizing, which is a good thing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 41 ++++++++++++++++++++++++++++-------------
 io_uring/io_uring.h |  8 +++++++-
 io_uring/register.c |  7 +++++--
 3 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 57ebba8ba46c..f039e293582a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3480,7 +3480,7 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 	return 0;
 }
 
-int io_uring_fill_params(struct io_uring_params *p)
+static int io_uring_fill_params(struct io_uring_params *p)
 {
 	unsigned entries = p->sq_entries;
 
@@ -3545,12 +3545,9 @@ int io_uring_fill_params(struct io_uring_params *p)
 	return 0;
 }
 
-static __cold int io_uring_create(struct io_uring_params *p,
-				  struct io_uring_params __user *params)
+int io_prepare_config(struct io_ctx_config *config)
 {
-	struct io_ring_ctx *ctx;
-	struct io_uring_task *tctx;
-	struct file *file;
+	struct io_uring_params *p = &config->p;
 	int ret;
 
 	ret = io_uring_sanitise_params(p);
@@ -3558,7 +3555,22 @@ static __cold int io_uring_create(struct io_uring_params *p,
 		return ret;
 
 	ret = io_uring_fill_params(p);
-	if (unlikely(ret))
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static __cold int io_uring_create(struct io_ctx_config *config)
+{
+	struct io_uring_params *p = &config->p;
+	struct io_ring_ctx *ctx;
+	struct io_uring_task *tctx;
+	struct file *file;
+	int ret;
+
+	ret = io_prepare_config(config);
+	if (ret)
 		return ret;
 
 	ctx = io_ring_ctx_alloc(p);
@@ -3631,7 +3643,7 @@ static __cold int io_uring_create(struct io_uring_params *p,
 
 	p->features = IORING_FEAT_FLAGS;
 
-	if (copy_to_user(params, p, sizeof(*p))) {
+	if (copy_to_user(config->uptr, p, sizeof(*p))) {
 		ret = -EFAULT;
 		goto err;
 	}
@@ -3684,16 +3696,19 @@ static __cold int io_uring_create(struct io_uring_params *p,
  */
 static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 {
-	struct io_uring_params p;
+	struct io_ctx_config config;
+
+	memset(&config, 0, sizeof(config));
 
-	if (copy_from_user(&p, params, sizeof(p)))
+	if (copy_from_user(&config.p, params, sizeof(config.p)))
 		return -EFAULT;
 
-	if (!mem_is_zero(&p.resv, sizeof(p.resv)))
+	if (!mem_is_zero(&config.p.resv, sizeof(config.p.resv)))
 		return -EINVAL;
 
-	p.sq_entries = entries;
-	return io_uring_create(&p, params);
+	config.p.sq_entries = entries;
+	config.uptr = params;
+	return io_uring_create(&config);
 }
 
 static inline int io_uring_allowed(void)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index b2251446497a..d8bc44acb9fa 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -17,6 +17,11 @@
 #include <trace/events/io_uring.h>
 #endif
 
+struct io_ctx_config {
+	struct io_uring_params p;
+	struct io_uring_params __user *uptr;
+};
+
 #define IORING_FEAT_FLAGS (IORING_FEAT_SINGLE_MMAP |\
 			IORING_FEAT_NODROP |\
 			IORING_FEAT_SUBMIT_STABLE |\
@@ -136,7 +141,8 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 
 unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 			 unsigned int cq_entries, size_t *sq_offset);
-int io_uring_fill_params(struct io_uring_params *p);
+int io_prepare_config(struct io_ctx_config *config);
+
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 int io_run_local_work(struct io_ring_ctx *ctx, int min_events, int max_events);
diff --git a/io_uring/register.c b/io_uring/register.c
index f6b7b1c1be48..13385ac0f85a 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -398,13 +398,16 @@ static void io_register_free_rings(struct io_ring_ctx *ctx,
 
 static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 {
+	struct io_ctx_config config;
 	struct io_uring_region_desc rd;
 	struct io_ring_ctx_rings o = { }, n = { }, *to_free = NULL;
 	size_t size, sq_array_offset;
 	unsigned i, tail, old_head;
-	struct io_uring_params __p, *p = &__p;
+	struct io_uring_params *p = &config.p;
 	int ret;
 
+	memset(&config, 0, sizeof(config));
+
 	/* limited to DEFER_TASKRUN for now */
 	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
 		return -EINVAL;
@@ -416,7 +419,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	/* properties that are always inherited */
 	p->flags |= (ctx->flags & COPY_FLAGS);
 
-	ret = io_uring_fill_params(p);
+	ret = io_prepare_config(&config);
 	if (unlikely(ret))
 		return ret;
 
-- 
2.49.0


