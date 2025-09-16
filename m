Return-Path: <io-uring+bounces-9818-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C4EB59A4A
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:34:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CB7A1C065D0
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C588534A326;
	Tue, 16 Sep 2025 14:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LuW94JQ7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ED5346A10
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032834; cv=none; b=Juvd+HTlWZ49lrWIZcJwVMP5uwEB86hW42cJVldsDGwptnChWejkvbMxlKRSs+3PMVm3wlWmK5uZAdo9ABqJyUM4s+k4b31kKOpX31J7RUtmE0erWIm/af5SWlAMKoU31sTcLB2F1W9E5+1cA6yTD4siUJbXpwIprPpvyZr4dWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032834; c=relaxed/simple;
	bh=OQFjokGn3WaqjsssPWzJqKKp55as+qTWDAvWlatEDD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfJe3Fxky/R4zWlJ++Ekky8FK9QR8DI1kZ0crdoYW0M3Z0P3St7nfTz1T6VDjqb2p2O6WjYDflzgPN55+u25ykiLfStU9Nlci39EZumTlNYPpJFOaF2ULSm6HxMJEfdGX3zGFayuaBmB100NcO6wW3fljyZp96jDBbmWmLCtE2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LuW94JQ7; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45dcff2f313so34786885e9.0
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032831; x=1758637631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sRfVer2fUIipwB8cmncBOeklcNg3ZFTmdULVyysrYj4=;
        b=LuW94JQ7Z/1OSzHGgLNFQ5iqRxLSBXOhlvCHzP7NdsmMs0h79obBOJd3gmxbWaUB0W
         Y357wqKtne+MYVlIrk/4H7fDiCL9RZlvrVI0puPjla9AHEnALMcCvexzWyw+HGnUGD/G
         7eFthl9On/k3RRRqT0M3bGUBxh+5pcodN3S2svYXANc0l0ciYiSIo7BmMbn/XfZhLYpZ
         elahkmiF6wHlqndTEpcKKWPHw6j6AExf5kfrYHnUnR+7eEI4dPYR2gs9py6J/AneCXuR
         S9XM6R8ddC+n224VgIw11DMQQLAfF366wHwiyFJLRzmP5fyLhYj5IRP+teZVR4lyzC9e
         1juQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032831; x=1758637631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sRfVer2fUIipwB8cmncBOeklcNg3ZFTmdULVyysrYj4=;
        b=CO2aS2Mw3iHzdP+tMSx8iQd9yt8VvMuOUyKdhWGsejO6Cp/jl1GbY+DzewfbYmcstY
         Z4501RyGgAb2DmMBpILT5pIMJvnmlUxCU9BCjmOUhUo04T9c2VlcVm07JTfyoRT/Swl1
         FE98xBTmUHYgwQkPtkmuVdVOm7B9BaMXA1oaMjztEsxDFfXhrStSkjzlDho2KswoiG1n
         S9dToO4wFesehJEVHIFPMqORRbc994yR3PhGd74nQRMB/WMuYSXQbfsNXPBxM5mOS5jX
         nYK0MHPSMrGHA3EvLIC5mu9av5FNV2VRPVC8ZhwAS0A4sRkojzao1UAaXlhkHclbgEpH
         Hjmg==
X-Gm-Message-State: AOJu0YzO7SN3RRZWZknZlzsSNNyR+zk8SntiuqPj9pc/hec0cYG9Waej
	1vGtrR4SzAPKOrP+XVscPM7aySMmb/tr+7uqbavZfaC6eKSRzpKt4t5VY7/05w==
X-Gm-Gg: ASbGncv7JGb1WtqCf4u02BnrW+oFjvb7MZZxWEadtK28WLCzfXjNeM7a86H6uFT0zxP
	uBVyGc5BuPiBXer7oi71bXyuV00gCv0Z4zv75FCC3UFI4RYEPqd+WMVYIYBB8LGHJNMaPUEJXIA
	JfqTkDXmwebGeGrWZnhUVIlrBxJdIIuICCP13YXL/1VVQW6x7v60c4ORvQbXZNcPU5AJ/i/llWk
	svcXT+4Z14LRGt9+lZVJU3x+F66S7ZrSZmG5ZUiZo0k+clnvn6Qz7UX0Uq8h7oZ7hi64Mz0g/sJ
	oLLmO/CruE8z6MwQPfvmxy8qZr4rABWBGh9zGQ/Mw01/tUWWMzqP3jdkeuitW95d9YTZzPGMoUj
	UQMcKyw==
X-Google-Smtp-Source: AGHT+IFpQpBBI/RRzhcEhne0rIeMs7c/SdD4OgqtFmdHjtuN5szPMtq2zOIAyu5qHXyF6id2lG/33w==
X-Received: by 2002:a05:6000:18a6:b0:3e7:486b:45cb with SMTP id ffacd0b85a97d-3e765594133mr13697709f8f.3.1758032830890;
        Tue, 16 Sep 2025 07:27:10 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:27:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 18/20] io_uring/zcrx: introduce io_parse_rqe()
Date: Tue, 16 Sep 2025 15:28:01 +0100
Message-ID: <6f8483923c688e19cfbccc9ee795b2d1b0086d51.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper for verifying a rqe and extracting a niov out of it. It'll
be reused in following patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a805f744c774..81d4aa75a69f 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -750,6 +750,28 @@ static struct io_uring_zcrx_rqe *io_zcrx_get_rqe(struct io_zcrx_ifq *ifq,
 	return &ifq->rqes[idx];
 }
 
+static inline bool io_parse_rqe(struct io_uring_zcrx_rqe *rqe,
+				struct io_zcrx_ifq *ifq,
+				struct net_iov **ret_niov)
+{
+	unsigned niov_idx, area_idx;
+	struct io_zcrx_area *area;
+
+	area_idx = rqe->off >> IORING_ZCRX_AREA_SHIFT;
+	niov_idx = (rqe->off & ~IORING_ZCRX_AREA_MASK) >> ifq->niov_shift;
+
+	if (unlikely(rqe->__pad || area_idx))
+		return false;
+	area = ifq->area;
+
+	if (unlikely(niov_idx >= area->nia.num_niovs))
+		return false;
+	niov_idx = array_index_nospec(niov_idx, area->nia.num_niovs);
+
+	*ret_niov = &area->nia.niovs[niov_idx];
+	return true;
+}
+
 static void io_zcrx_ring_refill(struct page_pool *pp,
 				struct io_zcrx_ifq *ifq)
 {
@@ -765,23 +787,11 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 
 	do {
 		struct io_uring_zcrx_rqe *rqe = io_zcrx_get_rqe(ifq, mask);
-		struct io_zcrx_area *area;
 		struct net_iov *niov;
-		unsigned niov_idx, area_idx;
 		netmem_ref netmem;
 
-		area_idx = rqe->off >> IORING_ZCRX_AREA_SHIFT;
-		niov_idx = (rqe->off & ~IORING_ZCRX_AREA_MASK) >> ifq->niov_shift;
-
-		if (unlikely(rqe->__pad || area_idx))
+		if (!io_parse_rqe(rqe, ifq, &niov))
 			continue;
-		area = ifq->area;
-
-		if (unlikely(niov_idx >= area->nia.num_niovs))
-			continue;
-		niov_idx = array_index_nospec(niov_idx, area->nia.num_niovs);
-
-		niov = &area->nia.niovs[niov_idx];
 		if (!io_zcrx_put_niov_uref(niov))
 			continue;
 
-- 
2.49.0


