Return-Path: <io-uring+bounces-10409-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E466C3CB7E
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:08:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B607C6259C6
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1C4D34D4C0;
	Thu,  6 Nov 2025 17:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CwAplHC/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240C922B8C5
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448524; cv=none; b=Ecmq1RsIvGeQIjYnUuu/mNPnsB9x5/97yTj1ASYVB3rf2Ph8Za3VhzSwbSQi3QCvFwlClS7j/3WGJGIW4ajTSyd/X4TpmTvD/v8N8lU9+dCN4KOXw/qxmcAU4So+usJHPZadCnEj9oo5ZvKakErGNfWz983RArjocotWswrIrm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448524; c=relaxed/simple;
	bh=JiqE2sg20zu47I5t8yW4jw3eRYQBDV8DHwkQ0ibeRlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJmRBkuvWyi6jJzEAB0zhuNKRS9upufil43+y7GT6IcspBm9ZS+xxR9MyaIsnpmYs3mBG5jWhA+nrFEzn2KpDFBQCEkipxKJ7ioi9u5kdBcZ8TC3jtpkKBz7ECVdrHJCxAOXGhe7p9wArR0R6uU9goWrKbpVznFrFIZrYVUkfhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CwAplHC/; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-429bcddad32so932255f8f.3
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448521; x=1763053321; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zLvxF124ujSDkZeadXHipHRr3w2itu5AbwhA62vWkIk=;
        b=CwAplHC/YSKSdHDBlShdFWnBjX29cZSWaoNx6GZRan9blfGIvR/YgbgevC2MQJtFXX
         j96oRzBlwGCnoSxZjK8PcdJ4Xi0FHkZCuoOjbAQbyjZZ2OtAPUnfHbk674h/wHw0xSLA
         vcjyXZVawWz0SsO3uSIltk1NVbZMzAny1w/mqjKF1GxXDz0t3zrFTJrhHj4DxNOUDviR
         m03G9DsypUqUaPL/CreabzYNuM8Gw0eg9xC6xpXRmo+dB6Xx6G003MPoBOR787ZevhOk
         XW1pb9rt/Q2vkKAm2qX3LG3Rb0GMmoBH8we/Z0TGQCB8G3z/F98CPonBeIq9+bxvRqqG
         t6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448521; x=1763053321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zLvxF124ujSDkZeadXHipHRr3w2itu5AbwhA62vWkIk=;
        b=kAJCx3uueBU0BzCVvNhT33sdMbcaIBoktD+P1mAKHbLgGtVX6QDr78wZInpJEm+Xln
         UOi8RKcQXNBRGXA948C+oVOpPhUNis7WQ3Fz8WoWJdW2nNJGKEHUb4xlar5ktT6qm+KG
         8usTIMEg2Y5wf0OkXWtE18smY1id8htEDLu41WsAaaG8TAdtUKC3pyB5TlziLJYVeBAQ
         PV0oURkUordULgY1jv+PhMQzV17EfR56+UiXo+pbff5vGWm7wssJ1ccoYk+8GJAWUHOH
         z7ALqIKAe/LISc5yPPZahpEBjOIWvVcesYwI093xxnQReLYVfO8kd3kTQkBz4fET0DnQ
         o3dg==
X-Gm-Message-State: AOJu0YxNgX5hBouQ23KkdxHP6OOB/ItlErFddbcvtlafUzgYUlMYdwUA
	jnOX7a3VtsxJ9eGDnTyLnrGeU2iwgoB3xsTcSmhEk+1Sd5v8q10+H2CAgwdIZA==
X-Gm-Gg: ASbGncvidlL+E4vqN4HV8gE2hrT37jok4DUKaKXpgUuuX4obl3sEjmZ1V7uOT6qj6Pk
	gybjeK8zoIM0jdl3a056ucKC90jCPnNrdLZ11KJdLgkufWM0RLhfkxNfkHLRK2dD6SKBy2L8Ci8
	J5RxGGdYMZ0K5dxBpvNHwkecMOX6iHCvOwUvpuPqlu5o9HnLGoYl3V4iPZ5B25GjIdCxz6P00ww
	MEW7d1WwdsEYxRrCFzpBx+g27FLNJntjHgvtaxuj58abeRWCACbpfZPPjzQ/rxMUrCtu+hj0ap/
	b9gjdmfcN4lYXgTAOASJe9/ol+0j65o8RLZq2UXmRusLV+e+cc9Ue9fGYXq+zHTvp2rytQsnGtQ
	nWj9GdV6VTMYzrVVU0Le2VcHLeL0jcMyB4JtSQzFCxnc5pWATNxJeijoojkp+RgoDiTYNnpOdQA
	ex7Fw=
X-Google-Smtp-Source: AGHT+IF/QVAqH1BwVxVOojOvHt/FPYvF4P/A+0i0b3a6SyuUltLLlqrx17uynHJE4MzQ2hRKExzmYA==
X-Received: by 2002:a05:6000:22c6:b0:429:b9bc:e826 with SMTP id ffacd0b85a97d-429e3334c76mr6980998f8f.53.1762448520603;
        Thu, 06 Nov 2025 09:02:00 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:00 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 01/16] io_uring: add helper calculating region byte size
Date: Thu,  6 Nov 2025 17:01:40 +0000
Message-ID: <dc903e7b1e532632c145c181f577557d67532d49.1762447538.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762447538.git.asml.silence@gmail.com>
References: <cover.1762447538.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There has been type related issues with region size calculation, add an
utility helper function that returns the size and handles type
conversions right.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 4 ++--
 io_uring/memmap.h | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index ce8118434c5a..b329cee8d6e8 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -135,7 +135,7 @@ static int io_region_pin_pages(struct io_ring_ctx *ctx,
 				struct io_mapped_region *mr,
 				struct io_uring_region_desc *reg)
 {
-	unsigned long size = (size_t)mr->nr_pages << PAGE_SHIFT;
+	size_t size = io_region_size(mr);
 	struct page **pages;
 	int nr_pages;
 
@@ -156,7 +156,7 @@ static int io_region_allocate_pages(struct io_ring_ctx *ctx,
 				    unsigned long mmap_offset)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
-	size_t size = (size_t) mr->nr_pages << PAGE_SHIFT;
+	size_t size = io_region_size(mr);
 	unsigned long nr_allocated;
 	struct page **pages;
 
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index f9e94458c01f..d4b8b6363a7d 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -43,4 +43,9 @@ static inline void io_region_publish(struct io_ring_ctx *ctx,
 	*dst_region = *src_region;
 }
 
+static inline size_t io_region_size(struct io_mapped_region *mr)
+{
+	return (size_t)mr->nr_pages << PAGE_SHIFT;
+}
+
 #endif
-- 
2.49.0


