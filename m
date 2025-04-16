Return-Path: <io-uring+bounces-7488-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF59FA9078D
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 17:20:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06E221906CD5
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 15:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFB8F2080FF;
	Wed, 16 Apr 2025 15:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l7kKqtF5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537D7189BB5
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 15:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744816813; cv=none; b=bdlHxEJpbFjKVSkfebeJSVfgpcZv/gDhyfwS5XFns0zligeAcrhQJDYX9M/8ZfctmH3lx7O2GYsDaA7hftfnkVPJHrKSIkFmloPhMErpRiy7FVBYOSjDQDO9ruNB7x2w8lWsFDrjTs06vwSYUXO5Et9BRvtG/cxz39O9LWOu+Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744816813; c=relaxed/simple;
	bh=8fkcI50eAyTULfvKZvmPG8H0WUTdfJOI6k6iux/uGWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DP6OAFpUCNhI0rZH8ka0HkQJH05/K6zRKr0QMVNdCK2N+jMghWchYFmFopJnd3knhs/P+NOnUUJ7jZTrvlMRHzt5h9lvKJks2YeZiJFl9kUarFlVqOOj3vEZ/NpeHqKcaT2DgOfnxZLDPgiJsBv/dUmcoOEn2vT/Ddlx6PYh4Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l7kKqtF5; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e5cded3e2eso10992651a12.0
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 08:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744816809; x=1745421609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c2ws1dCYoyoIoQrDX91S9WuSTCHQgdZ2FNnqfXUJWBM=;
        b=l7kKqtF5AlBjKK+f5i4CSN6qcjDKwgNExk81rZaqS+CgoiHXBoQuv2ntrKatG/7GYk
         Cs0AEPSNPhRrjlIs1oLTGd8lEzJN31TvqpK/OffqYhZee85IqqYjxX6K7c62TOx+EAcx
         axch3YgC7/HWqF9vMEW4smbyxFGCaOOvGqnOtA8T+nrM+b2hKsEnIgoNv9DJNaaIondY
         ETYXPslIWxi5TQ7uleC46FZoSvF7U2oEYeBizu3IEkhgnwsvv1ZLhyBk9OjjmtnDKCPs
         uLMSGkG1imTHJFgNUbvFRRsVUfBqKIX8nkPD/kblT7htqJkwa/ptgpuKf3Fe1CD6JI4z
         sgtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744816809; x=1745421609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c2ws1dCYoyoIoQrDX91S9WuSTCHQgdZ2FNnqfXUJWBM=;
        b=CNnl/4OYlJ3hUq0ERbZrRlWBDxs6RDQBysKqhU3+Q2OM+HR/ErVHWZWG5gmIYzAO3Z
         XNwtM07/vHn1LrX+cEc6o7D84piu+jiMzwlT8spNj4yGQNYT7asDk8vDbZfT60HfA+VN
         4cFdQc+avn6VQxDWS/WpUcU3VQAd78AwqHfIp7DggjmvwQCp5dTvCBMvBX8fxyfRQBEy
         8lRosM02hGhdlkP4tdgrkwBfvwpZW6H2b+lMnNEDm+bpx1hHkJ/KnXjy991oRyihk2Y7
         KxbFgYQWCr4SSBOhbupyjkrFm94Mgw/ksLqjO80zAqRvBilHPaKbbe88gEl8ze+OTYAb
         maTg==
X-Gm-Message-State: AOJu0YyBvvtBlYJwLghBByzJKIH3HxMILXg++1q6aOwqq1Jcdy0LMiz8
	Wzt1ygLQ/961aV5g1wVtEh2y4aJlni62uj/HC+kYeaRIzAnZRJOmqeWlPkp1
X-Gm-Gg: ASbGnctNn4xjdf7JDpvrZUp7hi2uYH2Qc/TIAv+HoQSBjO+cnf6AWH8Kkhj2MzH/HvQ
	73urooUuc07GkZAA5tjf0K9t3Fhbcld/v9QwxXin+cIoMmkassL/sKLcTbCFv8Eef+PIxhKpj0C
	ZtUyoAvUqSU6yaW4a6AY4/R1IUiiEXPSAm35XWkNa2OKY12gd9S9gikylJcEoKzMBI8Zn0fyEB6
	ozMRBNn3g1bECTzM2phbHhYDxx25TbNMPj4SceQUtrW/17pkI1xVYEAbEY/ZQ1iVLo8v+Z+1DWS
	7XRtZzMgfp3vX1XbHH/ypM93
X-Google-Smtp-Source: AGHT+IGELEWFtpCLYPB+ahkuIyt7xgiSJKay3tzt7GIl06UzsCDy7ntKAoluX/34Cdy6Is2LbFJIgQ==
X-Received: by 2002:a17:907:7285:b0:aca:c57f:3a1b with SMTP id a640c23a62f3a-acb42c2fc80mr217414866b.54.1744816808680;
        Wed, 16 Apr 2025 08:20:08 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:1ccb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3cd61f75sm144579566b.35.2025.04.16.08.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 08:20:08 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 2/5] io_uring/zcrx: move io_zcrx_iov_page
Date: Wed, 16 Apr 2025 16:21:17 +0100
Message-ID: <af1f2e0947fcbee59c4f9e3707133d503d5589f0.1744815316.git.asml.silence@gmail.com>
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

We'll need io_zcrx_iov_page at the top to keep offset calculations
closer together, move it there.

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


