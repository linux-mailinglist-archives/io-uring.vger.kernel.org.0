Return-Path: <io-uring+bounces-11784-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B50CD38A28
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:32:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 962CC3027BC3
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFDA8235063;
	Fri, 16 Jan 2026 23:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K9LotxQ1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D78327210
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606294; cv=none; b=MiDa7n5Yk2Ib+9eA/BaJiZIphy8lq1cXaSPL1szORpSGa4hMlJ3tJGhytGfqf2trJe0XfhzjwTPeiVbfBbJB00pMDQH4RlUh3uxpLmZFTFDVYwvGE2hVcgVg/YRa7SIXN7k4xP7wnWMgDzwFOooA0kMxqVOP0TigUIloLzhKrbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606294; c=relaxed/simple;
	bh=9zbdRQa5U1WLeoH5boQGAcxtyf4ds0If1PxNAfsMtqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFloMT4/p41al4/MR40cZn0PAKnIXq+b2hlG79895jJG6N0TaQuxPyxlvSCCmX7m3qOPIiWaKQ9FTYJ7KPL8tloOep6zUr/ZoXvpe2r6xaL+krETG5bKcLTPTHW5FXFNz0Gw+L4BzNYZdoy+rJP3+etkJjh1XzRG8jZgQvj4lzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K9LotxQ1; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-81f4c0e2b42so1402867b3a.1
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606292; x=1769211092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZfmCPWKHjdJmwvEJc9zhie0v6QHYRdYOxmgZuC/D3tU=;
        b=K9LotxQ1uFsPIcLjm0Nv0KzT2PUcAKUdAXUl3H+T0LlhREXhnmdYwXgX3QX/blUTcX
         4xfFG0aBpuDPcOz/wbEnmjuRfeViL7zWsh3Sj124sDZIs/EhkGpcDGW00pSh6LtA9bOi
         94Z0o2t9vPuTCIL00mGeEVabR/jRiRlV3cv5rNJYFiFQF2DXVYpmiccHikdKArqfwTmt
         96tRvGClT1gYUhPqAWFUP8sfhShm/D82GK0b9+5xMfByTrASnqLcSfRqmVZU3KK2WAYA
         iMsw+uMJKld824hnAXvBbc4tgJ61sURLcJKQNp/vkT+DE3gWtlqn6Ab0yU0t+Y4+6P/d
         mP2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606292; x=1769211092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZfmCPWKHjdJmwvEJc9zhie0v6QHYRdYOxmgZuC/D3tU=;
        b=fLpivsyCnXP+Bbp5yDYgvQpbt/HALBX6Cw1FHbHHG2vbNAtOUXplr6J+5/du8gb5BS
         KT7k6Kq91L+VBHH1F56xbo5Q/3VP/CQnyrz7fAQk77s2Df1Fh0HdNrp5DouXZY9IALMa
         Cb4v9aqnrVNldNRfD5ykFLPu6aYthmB+Q4A97MeO1xr6GDk20cVDGn/xcw6ynT6NR6Ib
         3QXRxDX63adrXyp+cYB/b6iVYIkKhPXrKW6mUFl1KAGz7gdKyQ/pSQzhgjZTA9mV6JKY
         1QCtIxJEnwTxyo1WnxNPU+GZoHHc7XgPi62zPoFIoo/jmgZEmv6HpZ0/aOvqLnXcvNcW
         9nPg==
X-Forwarded-Encrypted: i=1; AJvYcCVkQ9SxuY71xALmy2INVg1p2ue6eHAAaLkJb/xEvc4Ivya8Mpyj0fcRRvv3yDkavMBvud/bsADA2Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyI7J9lIWPLYHoIVK2kL4NcypjP4iVQhuK8dBzoNHx4ljsicbWo
	/qXbzGnLCryjL4Ptm+7RxlNcgGw7jO1QwGxXdkQwMcFUn/TpEmuZoHOv
X-Gm-Gg: AY/fxX40VFGvA6gijvuuMzQsm5bhdhzYkBiL4dAzGDK6DyxIsRHAc0dfK5Fy+8eCDSG
	W2VFaokTfyuFZ6weUGx7D/xmptirXS+RBqXCTWdFJEq9L/4CIOovHmpZM7GoUsOkof2b//06JIp
	vqxAzaXXDZk6GbTuaQfOQz/73Cbk9muDQm5WVGFnAhpxxIcDiWRRq7ZyO/1vrxkZ6awSpxEDn5z
	Hq3bMl+RnbuDST5uhxTUvizPJHb3MKnJJBiGcpZOlt1w9Ig6RP9R9MLcmzCaDtleWy497z7I7lg
	vJFEvq3FnMrxSj9gJeJE3swR5HtThyaykm1jclCrBJmYsrGZwoWu+FiuPDHjv/9GEmHfs08i7BG
	I9c1Hjk4Ek5ibkkjVhYeGwd9jb6Ekem55+SMqXmX413JyGvoHvDAzoIItokaqUxUsR/XRQL1Pbr
	j0eCjVY8nVnVzXFQEL
X-Received: by 2002:a05:6a00:80c:b0:81e:8e66:38d8 with SMTP id d2e1a72fcca58-81f9f68f832mr4045469b3a.10.1768606292600;
        Fri, 16 Jan 2026 15:31:32 -0800 (PST)
Received: from localhost ([2a03:2880:ff:21::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa10e8059sm2944956b3a.30.2026.01.16.15.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:32 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	miklos@szeredi.hu
Cc: bschubert@ddn.com,
	csander@purestorage.com,
	krisman@suse.de,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	xiaobing.li@samsung.com,
	safinaskar@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 16/25] fuse: use enum types for header copying
Date: Fri, 16 Jan 2026 15:30:35 -0800
Message-ID: <20260116233044.1532965-17-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
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


