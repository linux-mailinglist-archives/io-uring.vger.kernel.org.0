Return-Path: <io-uring+bounces-10035-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D4045BE3AB1
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 15:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5D9D835948B
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 13:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483FE202F7B;
	Thu, 16 Oct 2025 13:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JgdW3yG/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637B826D4E8
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 13:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760620933; cv=none; b=bGjOhLvOY1/PjP5ieG75CAmAs+kctY2U5/i1AQz3NBFgCxCjMUg/D68shiTBlpyqPxiiB4VTHoeNG4vVPykW/MX5rZS8NI5ulGw3TGkqNrjkXJV26yTWebKnN7lKTbLYILQtWdAnqFGfeLX6d0XG5MxCaRY3KzMyVQXbkTfzqbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760620933; c=relaxed/simple;
	bh=t5rASJfqVSk/kUqnR7KZ65IadHTa7fXgAzxL5dNiWlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tB2p9Zkl0f9+F8P6My/08qkKajWsH145OaOCzqmt38hoTtMv44JuDRoZA4QcJRpTc2aZWZY3meCB3jMY3bY5Q1wTSpR5DgZeG/EQthJKZjLJLvbIY6ldtLgdSH9efR/tXjL5Ug6tXhJOBSOQtw0vIi8+ZXQZdFB/uWYbzcF9zNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JgdW3yG/; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e6a6a5e42so3769155e9.0
        for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 06:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760620928; x=1761225728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7AFJ7MVQEOk5j7h5Ole8O51c7lBV+/c6GRjTKRsvu/k=;
        b=JgdW3yG/LTHB68SmZD3C80u3w2PBNAHk+53+ZuexSjGj71V4dScStOv+Xe7yypG1Fc
         M4b9BbNVfDfckYVypSGJSSNOqP74U3AincEkP/+SBZBNBzVvki0PmEdVkf+DS21Whovq
         wwohwOGKGGYYDTlcMNGtYOQG6ZAmLTUsd332R/IrcgVa6YJuuE8E0Aufr8pbwwMzxWxZ
         YnDdEXNOcDa5wI490o1er5zh8txcwp6MINPvqbZDrfFIQSJP5Y0+fqbINFJza1lPNC4g
         5JtCCfgvaAQAZZAXOCe7xXo/X4FVLIRBKDYWR63ARmQad/vfuFGySx173ZuE/as62YBq
         76Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760620928; x=1761225728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7AFJ7MVQEOk5j7h5Ole8O51c7lBV+/c6GRjTKRsvu/k=;
        b=l50nL5SvO7LWw61qJZUB8UvVleOMcMMigS9zNuvzCqMqG4T3J+gYp3dtxopbvxAbXd
         E5o6jcgD7oALpuQJhfzmSdXSeKZKAlwztLZnRuA2GZll2U8DU253sJaqdqi7Q8GegGtB
         lcF72srn0kiiak+1EVGOSjwTNM6N9r8PV8sZG7tLs7uiWDrwjgMhcza/WO/KiO0y1Rmp
         LCBA67WKnR+boTFAMoN6gscNbJRcQuVhVuDrOWGUOsT168/PJBY6le2Z6oyzCKT+iF0K
         trDuOScvWF6jB+h5qe3jcLKxPQNmme9DX0mSPo59TM74m5q3prcigQ1ZYs3865Z5K7Bq
         sREA==
X-Gm-Message-State: AOJu0Yyn4UhwwO+XEK6Wr+mcZmrvda5drmt1HaLTB8REax4pNFfrflVl
	GMybRmnQwNBmAgR7E4F+wvS5TY80XNjtlgXRqgvI9vkzrfLTDDWjl3T0afJp2A==
X-Gm-Gg: ASbGncvnkXcwSZ7R/zUvxLt+nwygUDMvDOjPiM8tgA/NTgahcqDrTjYqhjPIu3/0LYN
	8tBHYN9uY5fCwJ/5fIZS2cOXUbxTzsKtLGmGSC0VC5bIhmMZZ1G94e8YawSD2iWUkMHVmcVanMO
	5fmo+g9MgWQBLJq2ah6h1G46plKbYGPkGMjBfqBlIR1Kfe4nbCJMOPmftpw6Hk5HMNtSuwH7Sjw
	iYWVGL7tUMY8i7Q0AexPQyRJ5yO/FldhRA2VwkXbEOIC4wUdPoJLqICKXnDBuWLXcbF8fOGSDGu
	LtTiSMEpuHVJBCPZVWcrHIQnmTqLvZQ3Q8+8jeR76avkKC1xYvb+MxKGdZL6Qnhd50MvLd4xB6Z
	tdflVQb/2cHyS5Fqna5AFvNHMFZ9JmAPdJy1SNzZK4JC4pUwtOK/fMNm6MR+Q2wtrtPsj8WbX5M
	xfL/F4
X-Google-Smtp-Source: AGHT+IExYYHtBhVAAahSLd0GrpzpZNOGcmBtlXl3Ou2vBobm9Gt2kMiPHFTtjSS4eJ+0gy/sv8IluQ==
X-Received: by 2002:a05:600c:45c6:b0:46d:ba6d:65bb with SMTP id 5b1f17b1804b1-46fa9b01de9mr245118485e9.31.1760620928015;
        Thu, 16 Oct 2025 06:22:08 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2b54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144239bdsm41834385e9.3.2025.10.16.06.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 06:22:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/7] io_uring: sanity check sizes before attempting allocation
Date: Thu, 16 Oct 2025 14:23:18 +0100
Message-ID: <902410e76d5bd6e6be991de1dfbcb9e2fbb2bdb2.1760620698.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1760620698.git.asml.silence@gmail.com>
References: <cover.1760620698.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's a good practice to validate parameters before doing any heavy stuff
like queue allocations. Do that for io_allocate_scq_urings().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f9fc297e2fce..1e8566b39b52 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3606,21 +3606,27 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 {
 	struct io_uring_region_desc rd;
 	struct io_rings *rings;
-	size_t size, sq_array_offset;
-	size_t sqe_size;
+	size_t sq_array_offset;
+	size_t sq_size, cq_size, sqe_size;
 	int ret;
 
 	/* make sure these are sane, as we already accounted them */
 	ctx->sq_entries = p->sq_entries;
 	ctx->cq_entries = p->cq_entries;
 
-	size = rings_size(ctx->flags, p->sq_entries, p->cq_entries,
+	sqe_size = sizeof(struct io_uring_sqe);
+	if (p->flags & IORING_SETUP_SQE128)
+		sqe_size *= 2;
+	sq_size = array_size(sqe_size, p->sq_entries);
+	if (sq_size == SIZE_MAX)
+		return -EOVERFLOW;
+	cq_size = rings_size(ctx->flags, p->sq_entries, p->cq_entries,
 			  &sq_array_offset);
-	if (size == SIZE_MAX)
+	if (cq_size == SIZE_MAX)
 		return -EOVERFLOW;
 
 	memset(&rd, 0, sizeof(rd));
-	rd.size = PAGE_ALIGN(size);
+	rd.size = PAGE_ALIGN(cq_size);
 	if (ctx->flags & IORING_SETUP_NO_MMAP) {
 		rd.user_addr = p->cq_off.user_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
@@ -3637,18 +3643,8 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	rings->sq_ring_entries = p->sq_entries;
 	rings->cq_ring_entries = p->cq_entries;
 
-	sqe_size = sizeof(struct io_uring_sqe);
-	if (p->flags & IORING_SETUP_SQE128)
-		sqe_size *= 2;
-
-	size = array_size(sqe_size, p->sq_entries);
-	if (size == SIZE_MAX) {
-		io_rings_free(ctx);
-		return -EOVERFLOW;
-	}
-
 	memset(&rd, 0, sizeof(rd));
-	rd.size = PAGE_ALIGN(size);
+	rd.size = PAGE_ALIGN(sq_size);
 	if (ctx->flags & IORING_SETUP_NO_MMAP) {
 		rd.user_addr = p->sq_off.user_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
-- 
2.49.0


