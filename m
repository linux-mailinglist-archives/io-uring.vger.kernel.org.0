Return-Path: <io-uring+bounces-4903-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4929C9D449C
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0699A283153
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B431C304F;
	Wed, 20 Nov 2024 23:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QPxf0yYJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68B71C3F0E
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145960; cv=none; b=EQ6H9bO5UKi6nZzRgUNTIRYlR3+tJSlJYfq7HTv/WbK7UE75/jGuM+Q6umKJsHtHY5W5FiyNNpFXPaznuaRAkaAlHulnKl5Tt7NDniyLvpnVkPLIO8G/0POaYzUv5Hm4IuLKhui0e8oL2usgkpdMF5wHswfnSa01TarOpjQMG4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145960; c=relaxed/simple;
	bh=CSRCw925h0xPkBhV0+xncLyeFiq36jeusAlSTLuKXVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prFs4frBaJ0SJft306cR9zDo6C9zLuU0ur4RgxG5JFvnWkvZDinozkSqXAmZXBVkkLBjnHBQDhwYoBbXpxEpRHRF3H1lZB5Mdt6dXKhCy3y6UCcbXlV4+aoOnO27QOiPyW2UvDu1fbMlkDCnwUGe2hBpEY8+Fcc5y9FJ5XVkGg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QPxf0yYJ; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9e8522c10bso45717866b.1
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145957; x=1732750757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FD7qJ37j4F2SjsPExi3zhKBut3tTRkbQuozGRoZgzps=;
        b=QPxf0yYJg2LL6peaNhlkWRqVTRdUaEYj5F2I6GwTrer9BYR9/2/MQY5dcMAHaNEEtg
         zNNBkVNjzVf9spoAzOQ0u9JlH8GNt8EVwZnkCIrrXPCYHPg9chl3fGwjqV7R6SlZWFtW
         mXKbKafA47pcqBblaQ7RhTjUHgwdr2XriUHGlTMXVV/Np8iOYuhSjNjtZs8VZsMgoP4x
         RGQAj7uk2yXGqqpAscaDyAJMr29w/+lt7HcbqnY2UvDOapaU4+eNfryITRIxKKLcitzk
         sKqP9BphumSpyXqrV4yyVBvKnmUdOnDovENY3YAUiPhFQ+S/sljHD3L7YEtCVqDB3TwM
         PetA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145957; x=1732750757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FD7qJ37j4F2SjsPExi3zhKBut3tTRkbQuozGRoZgzps=;
        b=rEjAJfpMiretiKsefiVKOTWPfCjOP3STTZ37J/QqYVFhBCa8MbV/jASzIqqv9iXBYy
         81jfVShqV9BwZraw0mOT+Mm2tSAgGNRF+9pPZY4W+prX8nHDRMgpUIU6wm4zZyRI8+hv
         OxEzlnW65te2vOVn7GKu42eJGpxTAxkHF8rEK6SYyeXKjZ6EhjDxs686WPO+08D6PlFY
         XomncGDhxeV4WeavaieMhRSGNuheDlixTlFp7BSi2G/KBhhk1j9GvsadtSUIWRGyk2u0
         K4N3JQPcgWuwg/RttHWLBYnXpptwEesm1c3bpeBwbXLzW+27VGCSOte6pmNg+iCrUG13
         Lhbg==
X-Gm-Message-State: AOJu0YzGIEvFp2kWQXLmP2p0t3IiDtNwaKUEzEV20RVNYdMjjF5Eka22
	sgNwObL6tQeFxuvi8IWaZSwTLyDorU/svYwca8MJL+EtMeONt2c3sFeRyw==
X-Google-Smtp-Source: AGHT+IGHyQoObkjZgreYtxVX6YdcezFTA7YqQk8N5lOaFIyTceuSSqYxhq1o/snpvmLT24WujReLCw==
X-Received: by 2002:a17:907:7b86:b0:a99:f5d8:726 with SMTP id a640c23a62f3a-aa4efdd0c3bmr87271366b.23.1732145956974;
        Wed, 20 Nov 2024 15:39:16 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f418120fsm12544566b.78.2024.11.20.15.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:39:15 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 4/4] test/reg-wait: test kernel allocated regions
Date: Wed, 20 Nov 2024 23:39:51 +0000
Message-ID: <f6bcae3813e2792e0f1b5d65e00de7f33d21574a.1731987026.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731987026.git.asml.silence@gmail.com>
References: <cover.1731987026.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/reg-wait.c | 68 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 57 insertions(+), 11 deletions(-)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index d59e51b..299fbf1 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -413,6 +413,31 @@ static void t_region_free(struct t_region *r)
 		munmap(r->ptr, r->size);
 }
 
+static int t_region_create_kernel(struct t_region *r,
+				  struct io_uring *ring)
+{
+	struct io_uring_region_desc rd = { .size = r->size, };
+	struct io_uring_mem_region_reg mr = {
+		.region_uptr = (__u64)(unsigned long)&rd,
+		.flags = IORING_MEM_REGION_REG_WAIT_ARG,
+	};
+	void *p;
+	int ret;
+
+	ret = io_uring_register_region(ring, &mr);
+	if (ret)
+		return ret;
+
+	p = mmap(NULL, r->size, PROT_READ | PROT_WRITE,
+		 MAP_SHARED | MAP_POPULATE, ring->ring_fd, rd.mmap_offset);
+	if (p == MAP_FAILED)
+		return -EFAULT;
+
+	r->ptr = p;
+	r->user_mem = false;
+	return 0;
+}
+
 static int t_region_create_user(struct t_region *r,
 				struct io_uring *ring,
 				bool huge)
@@ -446,17 +471,36 @@ static int t_region_create_user(struct t_region *r,
 	return 0;
 }
 
+struct test_param {
+	size_t size;
+	bool huge_page;
+	bool kern_buf;
+};
+
 static int test_region_buffer_types(void)
 {
 	const size_t huge_size = 1024 * 1024 * 2;
-	const size_t map_sizes[] = { page_size, page_size * 2, page_size * 16,
-				     huge_size, 2 * huge_size};
+	struct test_param params[] = {
+		{ .size = page_size },
+		/* forcing vmap */
+		{ .size = page_size * 2 },
+		{ .size = page_size * 16 },
+		/* huge page w/o vmap */
+		{ .size = huge_size, .huge_page = true },
+		/* huge page w/ vmap */
+		{ .size = huge_size * 2, .huge_page = true },
+		{ .size = page_size, .kern_buf = true },
+		/* likely to be a compound page */
+		{ .size = page_size * 2, .kern_buf = true },
+		{ .size = page_size * 8, .kern_buf = true },
+		/* kernel allocation + vmap */
+		{ .size = page_size * 512, .kern_buf = true },
+	};
 	struct io_uring ring;
-	int sz_idx, ret;
+	int i, ret;
 
-	for (sz_idx = 0; sz_idx < ARRAY_SIZE(map_sizes); sz_idx++) {
-		size_t size = map_sizes[sz_idx];
-		struct t_region r = { .size = size, };
+	for (i = 0; i < ARRAY_SIZE(params); i++) {
+		struct t_region r = { .size = params[i].size, };
 
 		ret = io_uring_queue_init(8, &ring, IORING_SETUP_R_DISABLED);
 		if (ret) {
@@ -464,12 +508,15 @@ static int test_region_buffer_types(void)
 			return ret;
 		}
 
-		ret = t_region_create_user(&r, &ring, size >= huge_size);
+		if (params[i].kern_buf)
+			ret = t_region_create_kernel(&r, &ring);
+		else
+			ret = t_region_create_user(&r, &ring, params[i].huge_page);
 		if (ret) {
 			io_uring_queue_exit(&ring);
 			if (ret == -ENOMEM || ret == -EINVAL)
 				continue;
-			fprintf(stderr, "t_region_create_user failed\n");
+			fprintf(stderr, "t_region_create_user failed, idx %i\n", i);
 			return 1;
 		}
 
@@ -479,10 +526,9 @@ static int test_region_buffer_types(void)
 			return ret;
 		}
 
-		ret = test_offsets(&ring, r.ptr, size, false);
+		ret = test_offsets(&ring, r.ptr, r.size, false);
 		if (ret) {
-			fprintf(stderr, "test_offsets failed, size %lu\n",
-				(unsigned long)size);
+			fprintf(stderr, "test_offsets failed, idx %i\n", i);
 			return 1;
 		}
 
-- 
2.46.0


