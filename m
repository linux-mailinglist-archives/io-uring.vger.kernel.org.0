Return-Path: <io-uring+bounces-7576-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC9FFA94757
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 11:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 777013B6AEC
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 09:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062AA2A1C9;
	Sun, 20 Apr 2025 09:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BYwGTgBb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241621DEFFC
	for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 09:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745141424; cv=none; b=NxHbY8jf9VmpO+MzFKPqPDJWaudsxlXOnV9Jap7zkjDX//UY7sTvyYIuugoNS9tTj9KBxRbSMXh139t3zntpPSD2RF/YKv5Xqw+GjntSr3E4X79LXQCD1H6xRKZbBejkWCN1lA4iHGEzXF/PSzqsHL/YMC+eGT+lEEvAGMdfMBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745141424; c=relaxed/simple;
	bh=vR6JKd13hBVDZxNsHu+2d4QgRlMo/ozyhYklfkY+QZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ujt9TBj6TRom8St77w1SvhTxcbbLUsXtyaSS0A29y/Suu0nclJ+7lbxVZPKTHuO9dGfp6DsKMIInIGvWlcKWPjw9EUn2BJstGyuCF9byr+PGxMqpZEeYjGsgGKbyA9BpHN+s0Rqd6rMfchQ6kdJI+c3zoVCN+YZQm0VDyuHwb44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BYwGTgBb; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-39c31e4c3e5so2146207f8f.0
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 02:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745141421; x=1745746221; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u+3m+UMbYNf2r/11cc0B7NOrD6daXSaztZLpeLmd1w8=;
        b=BYwGTgBbY9x8vaJhjO+1U6o+AxkRHXEVf+5ZvQSCddobETvTx0hygNxkRi1Ufo0NHa
         k29WgXKOxsnIpNllJ5nniWy9o1YmpAsQH6Dq5TovLwn2lHFCw8U5jDgZAPgdLCcpkjel
         MW4LeReRKc01VR0Xx74UJ/R4HfCVgxf+gKopPhjlhnogHzRRSjhgIHz7HUZuDI+BydFH
         0Uj9ENWU+ZJA3rQHZdcycUMMPAh0l3kXutsnvqcJCCw06RpzbKVRtZshV7E57BDZolpr
         VKAUPRFKCDGplL/GDJdVG1Gb7mR01uIYJ6I/Jo+1lxPpAKvwSVQjsiK9BSFPV0H1PjTq
         tz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745141421; x=1745746221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u+3m+UMbYNf2r/11cc0B7NOrD6daXSaztZLpeLmd1w8=;
        b=EjWD/uLarRir73/I/zpHegGFVujoDsbQpGgeY9mWlmcOiVj3S56fjonGuwMc5Gh14/
         RPidt7USPIi/dg99BIrdYNw1iylaHOK4cRLTFRA/BJChtqvdNIVtxcaTBLhtgfN25M+8
         qjkxrImznHF/IFLG4wvth+BVO7BtmiQc9pwaxrPgVc5KFWE2BuvTEYGbxNSKHP6Cwcs8
         zl19QT1KBowo9C/Snv+WcQvax9/gv8bqYnPSosUZtQ56oEPZn651XAt13L0W8U538v5s
         gQTlIDcL07gEqZvdi5it03VtPc9nHxhYg7DrZTk556HJEBC+8gyip11pITQr4wZZEdSD
         pJhw==
X-Gm-Message-State: AOJu0Yzb3q2wQK3BdVUFh7w/Eid4XnJv61cazF1xYYRqfeO8hhTNBj1/
	zcXUh/T5V+fuWhxxYv2i8+MjGSd9IGMIeVaR3J7t8rWoXD1ll0vkeTvNJQ==
X-Gm-Gg: ASbGncvRIbZtSPIvmmEoBQc3ALvFnkvKs2zSxZg7UewjVAmPQEc003eBBuNchE3TyWA
	bxZq4705bP5B9JIYA8YDgKxIu/tG3IYcTTb1Jq8iC/9xAuWNBQd5/7RAX2DlxhRblt6RATQMazX
	ljwxgbtbPRXY155wl8pj64uzGhVbk+ViuQtvlXaNWobMAYrg17sESXI9gSrioMdRlNGnrr5PGbv
	IjWriVcQgR8ADWgdBCdw1pto/kyYhb5u74uL5a2BcqmLMzbOVCVZ503iGPYS8Gw50sx6BPr2+w/
	IO7g5r8JRAYSsIHJYQGqSXmpxru+JHLwj4HxTKE1kSsvHMh7FtDvpA==
X-Google-Smtp-Source: AGHT+IG74RSlz9gq3eQEx3BGFJJNzFx7nlBj9OLjx8MV3UiWhb509Ob8cAjOYHJFnPyVD5M5ouzWLg==
X-Received: by 2002:a05:6000:2584:b0:39a:ca05:5232 with SMTP id ffacd0b85a97d-39efba399c5mr6642662f8f.5.1745141420644;
        Sun, 20 Apr 2025 02:30:20 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5ccd43sm91188675e9.26.2025.04.20.02.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Apr 2025 02:30:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH v2 4/6] io_uring/zcrx: let zcrx choose region for mmaping
Date: Sun, 20 Apr 2025 10:31:18 +0100
Message-ID: <d9006e2ef8cd5e5b337c2ba2228ede8409eb60f2.1745141261.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745141261.git.asml.silence@gmail.com>
References: <cover.1745141261.git.asml.silence@gmail.com>
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
 io_uring/memmap.c | 11 +++++++----
 io_uring/memmap.h |  2 ++
 io_uring/zcrx.c   | 10 ++++++++++
 io_uring/zcrx.h   |  7 +++++++
 4 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 76fcc79656b0..5cf3f23e751b 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -13,6 +13,7 @@
 #include "memmap.h"
 #include "kbuf.h"
 #include "rsrc.h"
+#include "zcrx.h"
 
 static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
 				   size_t size, gfp_t gfp)
@@ -258,7 +259,8 @@ static struct io_mapped_region *io_mmap_get_region(struct io_ring_ctx *ctx,
 						   loff_t pgoff)
 {
 	loff_t offset = pgoff << PAGE_SHIFT;
-	unsigned int bgid;
+	unsigned int id;
+
 
 	switch (offset & IORING_OFF_MMAP_MASK) {
 	case IORING_OFF_SQ_RING:
@@ -267,12 +269,13 @@ static struct io_mapped_region *io_mmap_get_region(struct io_ring_ctx *ctx,
 	case IORING_OFF_SQES:
 		return &ctx->sq_region;
 	case IORING_OFF_PBUF_RING:
-		bgid = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
-		return io_pbuf_get_region(ctx, bgid);
+		id = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
+		return io_pbuf_get_region(ctx, id);
 	case IORING_MAP_OFF_PARAM_REGION:
 		return &ctx->param_region;
 	case IORING_MAP_OFF_ZCRX_REGION:
-		return &ctx->zcrx_region;
+		id = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_ZCRX_SHIFT;
+		return io_zcrx_get_region(ctx, id);
 	}
 	return NULL;
 }
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index dad0aa5b1b45..24afb298e974 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -4,6 +4,8 @@
 #define IORING_MAP_OFF_PARAM_REGION		0x20000000ULL
 #define IORING_MAP_OFF_ZCRX_REGION		0x30000000ULL
 
+#define IORING_OFF_ZCRX_SHIFT		16
+
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
 
 #ifndef CONFIG_MMU
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


