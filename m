Return-Path: <io-uring+bounces-11267-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 84446CD785D
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:38:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 57E253051331
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8951FCF41;
	Tue, 23 Dec 2025 00:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FCrrTsG/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FFC213E89
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450214; cv=none; b=C3+1vPnaF61ROsXlyBRSTSg1c/zhW7aOJbmFpN6FXFA1B+0gPFWzFm/qR4FeOEC87M+EQKL+rV4IE4XTivwSjvZHb+gfxpSeJJIxxFtED7ZangXE6EIth83gBI0UQJsNdM1p9OMmtYgWk7PqyrEoloyA3jZ9hxr9nAmWCbszRMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450214; c=relaxed/simple;
	bh=9zbdRQa5U1WLeoH5boQGAcxtyf4ds0If1PxNAfsMtqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1FgNlFHRXvizZTPi5KDd8oy8ZKUmlRJurBBlOFL1W4n6yNwGw5jBbvyUvo96nZYh9m1TNFyYeeZ/rJeE48R65XkyXUh/VcHQe/YE+Bhnzuypu05Vj3+e+mxW/g5dMfaNDrSiOJQjBbL2VZg4URQ/y9y7EQZCgMs7OmNYZayyKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FCrrTsG/; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29f0f875bc5so64857105ad.3
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450211; x=1767055011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZfmCPWKHjdJmwvEJc9zhie0v6QHYRdYOxmgZuC/D3tU=;
        b=FCrrTsG/H2/wb4v+EFC3wnlPJ10/tD9IvcKWkibPX0kXhFyl2u4qCzKUBNO69x80BA
         3BXXhMbCKdkKgsJa5CrYxgLMwX4z9Y8/n12xOOVh+pyaJ+n6OO2LW+OLMefjc4DyvMfe
         uPrKFC81p9pS+tPWPrXtetlzZCHEHrlf4GEfW494cw4HAWuLRWVNql43GlCW61o1tNXn
         T624RnlfQJflbHbizR0jJ8hHoqWlwOHVT9GLI8R5g8UJtbNadWnY+5jmB0dw1NqaqCMZ
         GKOQ+j2MJT1H0qnT1hDI8/usEgykaNg/YJypiB8gJkrWYIEDRbXJMRWW647riI97gZwP
         jxKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450211; x=1767055011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZfmCPWKHjdJmwvEJc9zhie0v6QHYRdYOxmgZuC/D3tU=;
        b=fDZ5Xy6kA9DYL/220TB6oqaiM3/hBucVSbgNZZC7F9uhfiCzHuRG9GgdSo61U0YFf8
         Zge1PKFIHqdxuuL9CFHrwzCgnkj+ePFMTxJCUWiDQ3JYQQZV1e79D1L29nXEyxOEezv8
         ayKWzkIfNNDTzQJ9tcw2i8sG68PMz23SVunaRDyEsc5rj3TF1Yuwt63zG4EVIjZCaU24
         43IqZ9z1V1yR8k2YtNy3Q9Gq1fGJWNUEn/lg0TIFV68IK3t2fn0RtldKeAXgM+qsmOjB
         DPxoZt6iwJ1PmmnXohIjxufwac1OBiF2wglMC0xJ933WiFAQymEHyOeqckjfGFO9+uJe
         He+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXGXfH2WofJ7qem5F2HxGxGorIVQywxLmBblGkEyDdROxf7WG21WCPZaVPDsb83hFbNFRiKa0ieUA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwaNPSspklYuaXhm8p48ZS0RBSefePvwddJwkEVuUX8KHMHliNt
	iUB9dd8KITbxgtu1+lMphhYOTzOqCTxfNRS+21zSos/b14Mlo3NfajgA
X-Gm-Gg: AY/fxX7zNh2mhJSG/tOjE5zx8EuO+lBJ78F+o6EFhi7FY1CJDsHDADaBge9ZgVtTtgY
	1ZmrlEEyzlSoHrnl58jlJJM4hz7OF3tp1YWnBF5+gbB3gHQGjVZWjhKpbA1LBObjPR0z8xS8D9/
	qC8XFk4+Jm/ZEIRn2giSh+fjhzGMc6mltE5mCjMPD/t7ubnflS/BOsD4jik650zNt+D8ocuro+l
	c8jbY59XgFj5BFZvbQv9LgHheW61LTP1eOYOtYnW8Bp6HjCX8CD0kVs56eeab8oPATHvwKvBXVC
	2lydkok08hefaiodm5pfkNN2suAdJY8J1Nec4kH5Xe8nbZ/iqv4gRFy5zej/BfEiwbgYksmtDSW
	0NH+1ubIQdYucJoMMSxPWRgsKNlrvn5hJhb84Tln8wO/xRvI0tinzjIR56vNNcRsdsNvA8eRIdp
	GZXBkYvPy7XpfxjUBHesSdE/YHxTrn
X-Google-Smtp-Source: AGHT+IE+lQSn4pbluCyiCY9c4fM2ImY0JcC4xUdOVITmgDUnMQzogMPoYRJtwJKEiWI2YjUTbYyeyg==
X-Received: by 2002:a17:903:1a85:b0:2a0:acca:f3f2 with SMTP id d9443c01a7336-2a2f29370d3mr115125235ad.48.1766450210941;
        Mon, 22 Dec 2025 16:36:50 -0800 (PST)
Received: from localhost ([2a03:2880:ff:53::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d5d658sm107018465ad.78.2025.12.22.16.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:50 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 16/25] fuse: use enum types for header copying
Date: Mon, 22 Dec 2025 16:35:13 -0800
Message-ID: <20251223003522.3055912-17-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003522.3055912-1-joannelkoong@gmail.com>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
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


