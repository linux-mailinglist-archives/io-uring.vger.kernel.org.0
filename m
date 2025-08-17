Return-Path: <io-uring+bounces-9011-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4CE6B29596
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:43:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE9D7202664
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17BE52253E0;
	Sun, 17 Aug 2025 22:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aZrxS6uZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D90721767C
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470633; cv=none; b=Wzb/T3G5HXKuBj+3LnU4+HLnzcsSd2MFbOspUg4wxDSXHSCSi+CIESMydRmPG3YODwoBq/LrQez3H6BA0K6rIofCb70m0eMn8gd4eUQ1H3CF8be9uMhmlFd9HFPPPWZP3gV0n1sIShRjQEA7Muuf1rPDA247ctgz3AqK+m6SkJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470633; c=relaxed/simple;
	bh=st6Z5nZG+EKJpN7JVhgVpxXEOAnVS+aD63GqOcdNotU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWgKfNV6nLqy42RXkRucAVXQlHUxLQ5Dxo5Pny10wDIMuLZMCfTyveY0kGfUlH3osOuwrqtDwbAcIrIgT6rx77ERW29jOjsayGM1Kq6jXfrrgzrWcyqZTtcgSRqi8uesv9WigHLmaCNqYCI3zNzSna7PC1LwwW7pcXjrXxDRHG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aZrxS6uZ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45a1b00a65fso16986775e9.0
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470629; x=1756075429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTMC4/v8xCW2CW7VfvjtmH06GTa/PZZUp+swUAs+yHY=;
        b=aZrxS6uZxgX8rDiANmbupJ3QefLnN0D+U2DEU+JWeHMB49cnPpJpK0W2mFc8a7ZwCT
         dTJhcB4WSbKtZ7PYja7haTvQiX1qp8oTquybBcFzPzZtw+xie6E0NZ/x6Cl/XJz21xVu
         c/nEvsScx6bEj3dAwHKO2Hh19JfuUqi9ecOOR8+iRVHR9gtcuO1N0B87VeGCSGwWcAyZ
         LQGmNdIuto/4Q5+57Hd4XCOJQwh4Mx3nUu+9A2B9dbynqOGuslB8+5Z7FKTn8x/S+h6P
         SoTqhnHDQ2czo9//YV8v38Mk0oineoCZ65Enr4zjAFkNEM9YdjS6x09NJeD1xFwTawFf
         A8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470629; x=1756075429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LTMC4/v8xCW2CW7VfvjtmH06GTa/PZZUp+swUAs+yHY=;
        b=jL5zGHtl2Rw7MLZ5Ete7HOzRN8W+awuV+XvVMg1zeLpkskrykEbjlErJ/jiimb7RJ6
         UI83JrOjsMdWYsuyE41DT27x9XQY5Z036oFdpdYE1RwI5/GZ6KFiJFE13rcUZekXKUFm
         r2bjW4Y94jBb3wNrRkHNeByqT17M+X9zvu/GUlshtiqgkXO6Cb7ZlRl1Uw8LT1nybjIP
         IDJIEJLonb7Ml/kNUIA04ipu/F6v4rzSBm5fpLBXvtA+0t+GHbhuWNpdmGsdbyZnf1Dd
         0GRpK8X1eU003z3eNiyjWiCCaKuuYzb0c+4ZS1laII454iBu8uesonMufGSqJwzDA1qM
         hLfw==
X-Gm-Message-State: AOJu0YxY5OKTzXPVjduYkVUPrtxoxjeefis8dKA/NolpJQNijp3LIeF9
	Hgq46GdUP58Vvg9Z3k8M97wDWL/fUPn5Om4Hdqh/sx63zxKpgKroQxWafuAZxg==
X-Gm-Gg: ASbGnctlVzgzxNxPzdY0jX2vrcDIU+Shs2sDT45GcOvUMw9N+ssj7qd143z//PmjylO
	NPiXfZ74IC3EWHlXsvA16USnyD8qVU2S88mErqy/qTI6m/kgqsngoWwc5uJIrq+8DzORRSlayiv
	k2Jn1KMdmBKW9iQgPpK+lWQgdL6y8co81pMjmKVvH+h3/MQrJEdQWq+eFOTQGVVEPppw2NmW883
	5y54oiVA0hOYB5J44bf7+7R89BbZQCLCkXxbPU1jw8HN/ZDvpe/j95lKQmdM6y/lRqQizLBasP4
	gKJHKYElA6QGDTeNlWEYwMO8FAqSCiMfdIF8BaPLN1oskKpvSCghl7KCB9awiw4vtHbfH4L+fDv
	X5KSTr0oDBCGop5tXW6xGlgTgUFg06sookA==
X-Google-Smtp-Source: AGHT+IFSAglTU7HPpSgIk2kiVGNGx3d19oVry1WnvOn7AN3Bl6Ehe/7ogkA96j/VWSZgjwhTcHe7Ug==
X-Received: by 2002:a05:600c:524e:b0:459:e398:ed80 with SMTP id 5b1f17b1804b1-45a21877bcemr69190775e9.32.1755470629391;
        Sun, 17 Aug 2025 15:43:49 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231a67asm104759135e9.11.2025.08.17.15.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:43:48 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 1/2] io_uring/zcrx: introduce io_parse_rqe()
Date: Sun, 17 Aug 2025 23:44:57 +0100
Message-ID: <87cf02a7bea71af39f576ae516f68626e626955b.1755468077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755468077.git.asml.silence@gmail.com>
References: <cover.1755468077.git.asml.silence@gmail.com>
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
index b3cfe0c04920..d510ebc3d382 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -727,6 +727,28 @@ static struct io_uring_zcrx_rqe *io_zcrx_get_rqe(struct io_zcrx_ifq *ifq,
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
@@ -741,23 +763,11 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 
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


