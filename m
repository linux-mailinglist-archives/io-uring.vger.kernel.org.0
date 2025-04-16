Return-Path: <io-uring+bounces-7489-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAB88A9078E
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 17:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4A1F44647C
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 15:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4AAF208987;
	Wed, 16 Apr 2025 15:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjcD/PCg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DAB207E05
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 15:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744816813; cv=none; b=k8kjkvSVNJHWZ1iMiZQxdMxplW2aiNqx08k1EiS1uI06XQNizkRx6bSlzeLqnBeII8KJT3OYMvS1zBuqOGKkneeoZPl1RgBp+nrPMJtkv+lkFpmK3e6NMxSw+TSIuFIKvvpKvJLRMdfInGIYktldgQ6ns7ocSjon/F34dZ6VRmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744816813; c=relaxed/simple;
	bh=gIFeUvEvYzw2ltpqNJrIlbRPD2QUq+c75sdqwRYUO8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FM/+XcveXrv/ufwaBJhKCAGRbETauBBUOpHVT6TZi8NwxQW4/N4BLMIalvcR0BoeXc+1g/Gh5Nj5tbkpaUBTuzPTju7L5yAb+bbDisAFxGLsxt+QbA4ff0gSUZVUvbKyyzPmroV67nRnafAf5ju+ahHlK1z6UnhMvtn0Vvplc34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SjcD/PCg; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ac41514a734so1132568466b.2
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 08:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744816810; x=1745421610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9mq4thrKoL9APYU9ABo+nGi5WPxRzND5P8mwRGpuncc=;
        b=SjcD/PCgdfiVwTfEWlMJl06LmYvCiMcM9pYaETaKJhXIaYBYNHmMriAvvztyZLqM0P
         UExVi6OEEsx68tpLFwmswynqVrnRXhqukqY+u0a/svibXF3IKJiyWr7+W2HS7wFuJM0M
         Qtc9eFf1mN7dCCDatZjV295RIPFps8Ejx2UD76dmu1BJzf52ML5LIp9RUuEcMpem4B+u
         tu7f6oAm6y/Hj72NZeBDeKf+dJDL8J8GRfVupxU9axLqjwuSQ6zu0NfJST/OBQ8GjLEv
         dTw+Mt7ybHexCrEEtxW+Z0JPRHU+KR2ABXTFu8AraSZ3akDXGkMoSCzH89kz0MLkDbDL
         hR6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744816810; x=1745421610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9mq4thrKoL9APYU9ABo+nGi5WPxRzND5P8mwRGpuncc=;
        b=dGCHK7PhiGVehQaMoQ3vl0imfgtTHW4oeq8rStypAxwuHlim//T0T2Q//PabCYjkEJ
         Y5dPpcrRn7vjrAIckYV0R5MSw+orzay/l9CLRZWQXL5iEIW0RKFCeHm5E+uDNDncmNIN
         DA+XKOaZjU6cF61nttMcDLnPPis6eu0M/pyqCtEjGop9Th+VK3uRooNVk34e4fj8xXPJ
         InItIMfQrRB9CXoN5Qocd2oSKmuDmboZE3nLn4/MRZleQzmRzBg4qVkB6BVVs6eJRpIp
         jo1j9fIjGpoPHHDFuti9rdRE1JQgJOijeEGhIr+Xc0YPF+w7mW/6nAECP8aQU5kEC2+F
         6jEA==
X-Gm-Message-State: AOJu0Yxf1gkTQ35IHZyJkJ3lRTbuj9JHhkOgwF9ovGkIGZG/Gp7CSiJv
	0aS8FpmrYJiSMtz9//ySYmJV5SCd76K7s2IjSISfgcCuxJ2wWc9Cd5zYHqWM
X-Gm-Gg: ASbGncuM/h6wvv4HZtWjNx6ippy5IIhYEuZ6cd0qmDmucpeSE6n2MR75+6A4nzu4d+j
	XNqSi8EE/2K5fIrK4+Yj+3NN/xAp9JtlUEA0A/Oim2Aibj0KVZbCR4tsCeccG/+5eak9nBr3wW6
	ZATifxWO+YfiHH2wQ1yuHs/w22Mq+vDCC5ttTqgWYjvQC6qQizjTBhQ2ihFNroLOqpTU/qTW45L
	GtVGG79HFo+piJPqnHNL+gtJaYqQd4EKdNyYA4mEOM7XBXrBXDjEYtGx2hlzOASxYXo+0DZ0/PG
	4Er6Ph2GWwBMlg/KblAEkuD6
X-Google-Smtp-Source: AGHT+IFkjPuHfz6yEJpEhdoXQ3UPCA0oVOmbJhEUkepF9PmbtJOeEcbXwlKZRp5VAONVlyoVIdvEUw==
X-Received: by 2002:a17:907:6e87:b0:aca:db46:8170 with SMTP id a640c23a62f3a-acb42c762eemr154561166b.60.1744816809567;
        Wed, 16 Apr 2025 08:20:09 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:1ccb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3cd61f75sm144579566b.35.2025.04.16.08.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 08:20:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 3/5] io_uring/zcrx: let zcrx choose region for mmaping
Date: Wed, 16 Apr 2025 16:21:18 +0100
Message-ID: <83105d96566ff5615aacd3d7646811081614d9a0.1744815316.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1744815316.git.asml.silence@gmail.com>
References: <cover.1744815316.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for adding multiple ifqs, add a helper returning a region
for mmaping zcrx refill queue. For now it's trivial and returns the same
ctx global ->zcrx_region.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 10 ++++++----
 io_uring/zcrx.c   | 10 ++++++++++
 io_uring/zcrx.h   |  7 +++++++
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 76fcc79656b0..e53289b8d69d 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -13,6 +13,7 @@
 #include "memmap.h"
 #include "kbuf.h"
 #include "rsrc.h"
+#include "zcrx.h"
 
 static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
 				   size_t size, gfp_t gfp)
@@ -258,7 +259,9 @@ static struct io_mapped_region *io_mmap_get_region(struct io_ring_ctx *ctx,
 						   loff_t pgoff)
 {
 	loff_t offset = pgoff << PAGE_SHIFT;
-	unsigned int bgid;
+	unsigned int id;
+
+	id = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
 
 	switch (offset & IORING_OFF_MMAP_MASK) {
 	case IORING_OFF_SQ_RING:
@@ -267,12 +270,11 @@ static struct io_mapped_region *io_mmap_get_region(struct io_ring_ctx *ctx,
 	case IORING_OFF_SQES:
 		return &ctx->sq_region;
 	case IORING_OFF_PBUF_RING:
-		bgid = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
-		return io_pbuf_get_region(ctx, bgid);
+		return io_pbuf_get_region(ctx, id);
 	case IORING_MAP_OFF_PARAM_REGION:
 		return &ctx->param_region;
 	case IORING_MAP_OFF_ZCRX_REGION:
-		return &ctx->zcrx_region;
+		return io_zcrx_get_region(ctx, id);
 	}
 	return NULL;
 }
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 0b56d5f84959..652daff0eb8d 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -329,6 +329,16 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 	kfree(ifq);
 }
 
+struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
+					    unsigned int id)
+{
+	lockdep_assert_held(&ctx->mmap_lock);
+
+	if (id != 0)
+		return NULL;
+	return &ctx->zcrx_region;
+}
+
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 47f1c0e8c197..a183125e69f0 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -48,6 +48,8 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx);
 int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		 struct socket *sock, unsigned int flags,
 		 unsigned issue_flags, unsigned int *len);
+struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
+					    unsigned int id);
 #else
 static inline int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 					struct io_uring_zcrx_ifq_reg __user *arg)
@@ -66,6 +68,11 @@ static inline int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 {
 	return -EOPNOTSUPP;
 }
+static inline struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
+							  unsigned int id)
+{
+	return NULL;
+}
 #endif
 
 int io_recvzc(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.48.1


