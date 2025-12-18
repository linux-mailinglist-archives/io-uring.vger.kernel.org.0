Return-Path: <io-uring+bounces-11196-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D925BCCB004
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:48:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F199C30AB7C3
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE81E334682;
	Thu, 18 Dec 2025 08:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bvOVLKjU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C91333725
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046901; cv=none; b=B1FBbUEJ2ctEOWIhoTd39tcyGTwe6p61Pv6cDHsUePiVGHfnSbvEViE3JpjefoMr+I2SdwYH+PFz3SiQfieTASflPXQcNZuJrSvkgTORYdtkTdI1JsaqBFGxGFxwVj3fSmxxo4pa3jSJ4Q+xh3ExieEZBOSuGVtVfE0oP17GEvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046901; c=relaxed/simple;
	bh=9zbdRQa5U1WLeoH5boQGAcxtyf4ds0If1PxNAfsMtqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7q0ogauGKwEZvHdh6lZfZfQ+Gn+8rsl0FhxeeskDUsknTAs1HPyaklDG3aLmU9QcqBtVVceAY24NT6DpdD3euDWqnqFSRd6JlxbFHiJXW8BO9X4NeqDATLQwvR7g2QWTcbB3QIgX7z3NuNYL4LgFSuqvqQZEn7F9P6Tuol9iY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bvOVLKjU; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a09d981507so2732995ad.1
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046900; x=1766651700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZfmCPWKHjdJmwvEJc9zhie0v6QHYRdYOxmgZuC/D3tU=;
        b=bvOVLKjU2oeH+MAh9qgntgoMONgZx1BC62kKR/x8HFGKUFWzsW0u1whS93xRPAS26c
         8CKQacPUVlkdtgVxhFWZ2D9hF8MJZqW/FHoXjdS2VuTmHF4eD9j/Gy8zEjy1azI4aisa
         xLY0EB8pRsM3bq4t8Ha5updPFPyrtS4kTeJkjng5/RuQRdx0R7a7GdPfOz60kiKLEYWy
         wx6MBcTnBmiMdTOizIBzV0L7JIVDiu0wcJpyUKH8iNOJpGPt0z+cQMLL7ndiC89rA9UO
         K945z6DYzMhOQPEQAf06Xg2ILJHQ2sRxhiksilzk5L6imw4GkvABv0fSxjCGZrcwO42K
         XMzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046900; x=1766651700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZfmCPWKHjdJmwvEJc9zhie0v6QHYRdYOxmgZuC/D3tU=;
        b=V0rmBVBFb8AZrCIpCrCeXhJBaTIWj/sSqBmvwSi5KZTEAnNTWWVX4RuSZmodH0jqya
         8TVDs8y0RL4vwwubTcJclFC+gvptCgoTMpQwy5j9F1d0eF82BTC6BegrR+OKrCFLluGG
         Q3rw7yXgr6aRVH4HmFARXb1wK0NquEJiCbeGEEMqAtMD4lxygAT1gnF4/GkR/jbylHaj
         DIL06c9cFps4fjk8SXDAGgOU0eeyr9IJNvIjfrL5KHrLjkz+Fpv3P6WYotgKETj8P3pY
         upLFjsjdgdV0iQxqsjchPDjE1521AIA+B/Iy8Js+pzR7CFsifeeBOs4c8RQi3htZdHzf
         rw8A==
X-Forwarded-Encrypted: i=1; AJvYcCUQlK+IykIsjFOswTDjTpUPYwbJp6f1eNgI//4Gtr1G1llV3S+N4QVQlWZsCP7M+8+jNLOCmnEaNw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMzw7AsbkmGtLR17qqA4syyTpcX/vOaRWb652gHPJP/kokkdCl
	RTzjqqnWtbWnTaHGhLuzHh11CTf93a68GSH9ILGpeq97my0inMLwQ9VI
X-Gm-Gg: AY/fxX7aRLfnnlryXhWgsgrUM+C5t3fbU4H7LtB8COChwwC0aSP3Vj/UfbicHULFzbT
	6Go68UAXbk28iwa2E42MrCVGq0Ve/ZilSN0vcFgW1AIlrJDgxzK5//eqZ5RjtT5gwI3oFtsOTu3
	6mU37K/Cr/IU2YtUPZDm/XBc2WqxityqFkdEhGyI8lMjysub5wGJVRbix3A89F3lTlMOrJFMKd5
	C3Rt+YwS7BKrN6pqluqcgaOCeXFAgSEfr1hsxfu3VrOEhBgBA3y4WxI/7r0Zv9Ml9t6uf7m2HLp
	151hiLqEvD5uGlUbJLbXjghc4j0iZkDFkwlIh+q5JMjcPEBEkrxx811xrrvo6S6HcNPypqJyKeV
	JppYYRVjZ1ql3fSERVMK6K+cKcG87e+g89BuyUFbWWEoGqX1ng8R9NgftlKshL6/+DEIoiq+8ly
	Hdb429gRT1T+JBndP0uA==
X-Google-Smtp-Source: AGHT+IFrG8RKwLokVum7lZ5IpJbwRaIkFZsyAqD+Xy++PIPfx+W+LsrS4xVKl4DpP1rJ0VzUnHXUMQ==
X-Received: by 2002:a17:903:2b10:b0:2a0:d454:5372 with SMTP id d9443c01a7336-2a2cab0a1c1mr19322505ad.22.1766046899683;
        Thu, 18 Dec 2025 00:34:59 -0800 (PST)
Received: from localhost ([2a03:2880:ff:70::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d0889384sm17657175ad.34.2025.12.18.00.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:34:59 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 16/25] fuse: use enum types for header copying
Date: Thu, 18 Dec 2025 00:33:10 -0800
Message-ID: <20251218083319.3485503-17-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use enum types to identify which part of the header needs to be copied.
This improves the interface and will simplify both kernel-space and
user-space header addresses when kernel-managed buffer rings are added.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c | 57 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index e8ee51bfa5fc..d16f6b3489c1 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -31,6 +31,15 @@ struct fuse_uring_pdu {
 
 static const struct fuse_iqueue_ops fuse_io_uring_ops;
 
+enum fuse_uring_header_type {
+	/* struct fuse_in_header / struct fuse_out_header */
+	FUSE_URING_HEADER_IN_OUT,
+	/* per op code header */
+	FUSE_URING_HEADER_OP,
+	/* struct fuse_uring_ent_in_out header */
+	FUSE_URING_HEADER_RING_ENT,
+};
+
 static void uring_cmd_set_ring_ent(struct io_uring_cmd *cmd,
 				   struct fuse_ring_ent *ring_ent)
 {
@@ -575,10 +584,32 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
 	return err;
 }
 
-static __always_inline int copy_header_to_ring(void __user *ring,
+static void __user *get_user_ring_header(struct fuse_ring_ent *ent,
+					 enum fuse_uring_header_type type)
+{
+	switch (type) {
+	case FUSE_URING_HEADER_IN_OUT:
+		return &ent->headers->in_out;
+	case FUSE_URING_HEADER_OP:
+		return &ent->headers->op_in;
+	case FUSE_URING_HEADER_RING_ENT:
+		return &ent->headers->ring_ent_in_out;
+	}
+
+	WARN_ON_ONCE(1);
+	return NULL;
+}
+
+static __always_inline int copy_header_to_ring(struct fuse_ring_ent *ent,
+					       enum fuse_uring_header_type type,
 					       const void *header,
 					       size_t header_size)
 {
+	void __user *ring = get_user_ring_header(ent, type);
+
+	if (!ring)
+		return -EINVAL;
+
 	if (copy_to_user(ring, header, header_size)) {
 		pr_info_ratelimited("Copying header to ring failed.\n");
 		return -EFAULT;
@@ -587,10 +618,16 @@ static __always_inline int copy_header_to_ring(void __user *ring,
 	return 0;
 }
 
-static __always_inline int copy_header_from_ring(void *header,
-						 const void __user *ring,
+static __always_inline int copy_header_from_ring(struct fuse_ring_ent *ent,
+						 enum fuse_uring_header_type type,
+						 void *header,
 						 size_t header_size)
 {
+	const void __user *ring = get_user_ring_header(ent, type);
+
+	if (!ring)
+		return -EINVAL;
+
 	if (copy_from_user(header, ring, header_size)) {
 		pr_info_ratelimited("Copying header from ring failed.\n");
 		return -EFAULT;
@@ -609,8 +646,8 @@ static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 	int err;
 	struct fuse_uring_ent_in_out ring_in_out;
 
-	err = copy_header_from_ring(&ring_in_out, &ent->headers->ring_ent_in_out,
-				    sizeof(ring_in_out));
+	err = copy_header_from_ring(ent, FUSE_URING_HEADER_RING_ENT,
+				    &ring_in_out, sizeof(ring_in_out));
 	if (err)
 		return err;
 
@@ -661,7 +698,7 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 		 * Some op code have that as zero size.
 		 */
 		if (args->in_args[0].size > 0) {
-			err = copy_header_to_ring(&ent->headers->op_in,
+			err = copy_header_to_ring(ent, FUSE_URING_HEADER_OP,
 						  in_args->value,
 						  in_args->size);
 			if (err)
@@ -681,8 +718,8 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 	}
 
 	ent_in_out.payload_sz = cs.ring.copied_sz;
-	return copy_header_to_ring(&ent->headers->ring_ent_in_out, &ent_in_out,
-				   sizeof(ent_in_out));
+	return copy_header_to_ring(ent, FUSE_URING_HEADER_RING_ENT,
+				   &ent_in_out, sizeof(ent_in_out));
 }
 
 static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
@@ -711,7 +748,7 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
 	}
 
 	/* copy fuse_in_header */
-	return copy_header_to_ring(&ent->headers->in_out, &req->in.h,
+	return copy_header_to_ring(ent, FUSE_URING_HEADER_IN_OUT, &req->in.h,
 				   sizeof(req->in.h));
 }
 
@@ -806,7 +843,7 @@ static void fuse_uring_commit(struct fuse_ring_ent *ent, struct fuse_req *req,
 	struct fuse_conn *fc = ring->fc;
 	ssize_t err = 0;
 
-	err = copy_header_from_ring(&req->out.h, &ent->headers->in_out,
+	err = copy_header_from_ring(ent, FUSE_URING_HEADER_IN_OUT, &req->out.h,
 				    sizeof(req->out.h));
 	if (err) {
 		req->out.h.error = err;
-- 
2.47.3


