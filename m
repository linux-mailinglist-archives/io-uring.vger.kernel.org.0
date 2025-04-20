Return-Path: <io-uring+bounces-7574-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 142BEA94755
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 11:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BA263B6B61
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 09:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2F111D89FD;
	Sun, 20 Apr 2025 09:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ncxGo06L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BB013C3F2
	for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 09:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745141421; cv=none; b=U2yP3y94+Hi6EzyNiNvhJPJWIA2N/CWIxXfUJI8BhR0h5VfYp35h+WYdS+/B5hEarfdFPdcVf1PMlgEGyJB+3fB3XlzzFATskVEHSS67uKTg7BMwCHd6WBOBCkbHqk+Cw0prM0jHFisBnyGOTNqp2uldhfmowdkK239e7sMPIeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745141421; c=relaxed/simple;
	bh=NE8SGDlfOVd4lzNs1O7Hk63fNUID4ruFvAnosAG1oZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k26g9gEktGizYuU0xvljRQGCHDlI4K23bl5HA6IRG39xxyGCM7+CfLhLQ5/224oQg2g4T651ftfHXZfRdCiwXFXVOq3UVjLI77/F+PHnD+RdxAhtaR2tnjoteAw7YAULl+7X/NU5LUx9YrlIEyIhl/7aiSsWOtrbDHIwFVedi98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ncxGo06L; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cfe63c592so37179035e9.2
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 02:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745141418; x=1745746218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oYbG5tw4moqnlGwFJYEbY+SVSjvMLwNUzV0iQZzMSxY=;
        b=ncxGo06LuK3UKdBJQpV3BO67WKOT5La2WBvjPeQbTZA24eGM7jz0/+8Cnz9CQct6TW
         pAQ6yiUphejnsX/DhBL4nGKSn2m81z6oPvh6jMalwUgZgXL6J9h6dVF3ygRVcmGcAEcc
         ggGrFil+K8In8bndo3cjYsArRdXoT75flUIpgF1NtoZAl5NEka4BEdhPCBqX9YLZRcnX
         5FB31KKztnSzaLL7PI2rrzOaByh+uc/hSDY2pMhOX8VNk+FVEVHc4UexLXrSWIPS8o0N
         yAiR6f1srBME7nirvtae9wBlIQlb67aDMvPFRlA4KayNZhQSPOGgn2Vx0oU4X8+ENQTi
         hLgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745141418; x=1745746218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oYbG5tw4moqnlGwFJYEbY+SVSjvMLwNUzV0iQZzMSxY=;
        b=YMh3FZpeQ912EhTr6xv1VVa0GR3VFz53grAQPW+Jgl1/OwAB2R1DRMATrPWUM9BMIy
         EIwCNUaOWd2cpBZ7eA4Yv5x2dcYy0+6HUa110FSyn7wVBXHnXAp9QWm0KdjtIM4lAMNG
         SGb4qU885aMRgrv1xbpjqw6JRZ3sDcEa6MCgpdNZCw7o+9AYTY9KSVhzZFgiK230Y9v5
         F/eUDqL/u51TsSg0OVpPMlMbEbybJvx2sKNfEQwPl205E/SNvywtUHeB6tn8/SzO7i66
         NrdpgoDkJBtzZBQU9x3/BzCp28VH3NYZOO0/YDO/LtpCs7D/TWuuAx4Vq0fkUxKShoRe
         PWnA==
X-Gm-Message-State: AOJu0Yw/wz4VaoTRjuF/mSfBY/cMrXi46dIA6F8zdXT2vARr0IyC3lV9
	3t7nmszVu6PPM7vm0kIHO53gqHex9oqqyE6d0tGozj4GRL0LdSK06Tixww==
X-Gm-Gg: ASbGncswCPh5Qg6lFNY7829eVizDX+/LmJGMJDEAzt0Af0x/j65js5gsveddrekt9xw
	9FMfZf4BjejrlEE7Y1oGDynuA3I3Lh7+U10xfWwP0bkIxX2HzvXro52zIfQBe/gYF9oI5ixMBP1
	Rd7v0jfaqWRlTJLH2x/I57p0HjT4VNRrJf99rmDfs+QUvy/IeJILQat7ZyImeXkBMrD+Nr8HcVL
	CPfAw5OYssMsaUJWO3JLW48o/4V5jNf5pWU+GXzXkUvU88om/gCLVOdhrjbhCOxOlQ4oXV+jdus
	Qvk8e022jqvKF5k3nnDKk/kGyO4A9MQydEakfnzfjj+GeV89QIJ3UQ==
X-Google-Smtp-Source: AGHT+IEFfXdRTzGQbvPnqN83MFAsYp2FR/uGrD8zLdNnKruqnIELd0Inuqq3QJaiMNGrNioIdYSASw==
X-Received: by 2002:a05:600c:5007:b0:43c:fad6:fa5a with SMTP id 5b1f17b1804b1-4407fddd950mr9940775e9.24.1745141417988;
        Sun, 20 Apr 2025 02:30:17 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5ccd43sm91188675e9.26.2025.04.20.02.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Apr 2025 02:30:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH v2 2/6] io_uring/zcrx: move io_zcrx_iov_page
Date: Sun, 20 Apr 2025 10:31:16 +0100
Message-ID: <575617033a8b84a5985c7eb760b7121efdbe7e56.1745141261.git.asml.silence@gmail.com>
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

We'll need io_zcrx_iov_page at the top to keep offset calculations
closer together, move it there.

Reviewed-by: David Wei <dw@davidwei.uk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 659438f4cfcf..0b56d5f84959 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -31,6 +31,20 @@ static inline struct io_zcrx_ifq *io_pp_to_ifq(struct page_pool *pp)
 	return pp->mp_priv;
 }
 
+static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
+{
+	struct net_iov_area *owner = net_iov_owner(niov);
+
+	return container_of(owner, struct io_zcrx_area, nia);
+}
+
+static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
+{
+	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+
+	return area->pages[net_iov_idx(niov)];
+}
+
 #define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
 
 static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
@@ -111,13 +125,6 @@ struct io_zcrx_args {
 
 static const struct memory_provider_ops io_uring_pp_zc_ops;
 
-static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
-{
-	struct net_iov_area *owner = net_iov_owner(niov);
-
-	return container_of(owner, struct io_zcrx_area, nia);
-}
-
 static inline atomic_t *io_get_user_counter(struct net_iov *niov)
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
@@ -140,13 +147,6 @@ static void io_zcrx_get_niov_uref(struct net_iov *niov)
 	atomic_inc(io_get_user_counter(niov));
 }
 
-static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
-{
-	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
-
-	return area->pages[net_iov_idx(niov)];
-}
-
 static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg,
 				 struct io_uring_region_desc *rd)
-- 
2.48.1


