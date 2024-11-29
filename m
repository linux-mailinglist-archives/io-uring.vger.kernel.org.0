Return-Path: <io-uring+bounces-5140-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 315B99DE7B0
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6B621644B9
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C14119E806;
	Fri, 29 Nov 2024 13:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VwgNRa11"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83CE199E89
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887247; cv=none; b=cpzapsnw5ycnnZ1tMyOeDvMVPI0ToRqfiazp6bLLrMkWBbyBswy92oCcGtoHVFc7qQcgYo4orx21RfstV2Pb/2AGmryyok+i31INYyvAYE/D3moeI6tiDibZ0ah3ZJpbV4m3wrrlxnZu3bQr/ut+Ihz/yJbQ9muF3v8ZIqtJVlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887247; c=relaxed/simple;
	bh=xG5BJVMYMK/ic6yBusHqEDPDk8SnMuUQSGJz4Wz7DsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0yO+5co3nUnX+l4lmGDRO/dPsKeIGQEMme5FnmthUTB3hs4Eh/6LAJvGEeFYRf1xIpaTL83a/yvA4YWz9YIQ5WKAINWDio9d0oabW+ZAYF8dPpocqrh2VH7so+tR770WD648DQVkUKzGi3/5ZNZHat6114gKfKH95zq1ht/WTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VwgNRa11; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d0be79e7e7so358355a12.0
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887244; x=1733492044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iw9KjbDCnQd55jzzAKjgJBEKh2EnMTZarOWnv7TTLMc=;
        b=VwgNRa11fhlySS+d6AfClKv9gWStu8MqPRbxiWIfavRc1srA2PWWu2ldeKXdd2vlvM
         bUDFTpr/t3KrYEduDyxJd0VeggSzbfJuXFRvV5c4XrTJBIYDmnrj170zjsMWizF14XMx
         rc57FXOGXZN/n5gmAjt8U53yWBhJlLH4zoLgAlxoigTYgzIj0wfMBXizaT/KSdm3cuil
         zAgA/Gzh/WAaG/odUycHWZc9bKi/te51n0Rl+9VVuXDAtTDH0/olD+P5t0iHc0wJxWi+
         fRuiZ9glhwM07o/GaeId8sCXZZm6A6F7U/U9F+FLhLaZbXW+Js/Q0pln7zk8OFb1gU1D
         w1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887244; x=1733492044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iw9KjbDCnQd55jzzAKjgJBEKh2EnMTZarOWnv7TTLMc=;
        b=vBWPg01ibQOo09AEGvC0NegSs4QKcWHzbqsYI+H6gT4ruPP5kQdYczauQHZkHNa1MW
         x6QYIgVtWKxfJRQS+g2pxrwRBTyi8Bxlde16odau7Y/k97Muqs29BV3buRPcVjukBmcT
         AJiW3QR5ZXRyc4+qnRiblsiSm/rf1UHEuePUFX1mu4B0TkHvLLSNxAnXoT3hw+g4CV0g
         8eWaHnyWz+K/IOD2v5IQXuzpRzL1o3gXxBOT8L31cMNjU8/Q24vTHCSgx0IyL9RwBKed
         8z6jzdwGY3/S8Pg0XUPc/Et6CCKH992zXh0AeA6vDGdNnUHO2uaWiliWlnmyEma8tOAh
         uEyg==
X-Gm-Message-State: AOJu0Yx1uB9kry2UlD/zWC8GC+zikgjc/5lpnY6FYdVOkjq8i9sOblqu
	7drTQ0edbPyfpwU3yz9vWfdpvxwOQYXvfjODqgAnoMokgur2z+bT0BuLUQ==
X-Gm-Gg: ASbGncsRgTI5y1D3GyH99lXV2byatou2HxCAwK2B8TONM6EZr+eHRB9NyUnfeldwdF/
	U/i9zshBVN/lzIqclDA+rbbQPU8y6MccJZb9bAVAq9I5vaxzhcYzttSItn9He/57wdN/eWX8iqV
	UkNDByI0AFDfUHPJ/FG752oPoksqmdWdSWyqgtrUxbXNQxlA2M6wGvhg3vM0Cp0BFr2opKZSRSy
	pMO3KycVRvm1ODXhpQJxqy7o188mdK+rH/wQeJs1nIyuYyNKVq5Dd76ZxUriby4
X-Google-Smtp-Source: AGHT+IHsNRqZe14BbrAzNFA6CcOOUCUjd3bjNThTeH2sfPKu1tChv9c03Sz46qBtK80/CZI+d1DTOQ==
X-Received: by 2002:a17:906:3d29:b0:aa5:1699:e25a with SMTP id a640c23a62f3a-aa580ee98eamr809780966b.10.1732887243828;
        Fri, 29 Nov 2024 05:34:03 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:34:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 09/18] io_uring/memmap: add IO_REGION_F_SINGLE_REF
Date: Fri, 29 Nov 2024 13:34:30 +0000
Message-ID: <a7abfa7535e9728d5fcade29a1ea1605ec2c04ce.1732886067.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1732886067.git.asml.silence@gmail.com>
References: <cover.1732886067.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernel allocated compound pages will have just one reference for the
entire page array, add a flag telling io_free_region about that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 5d261e07c2e3..a37ccb167258 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -207,15 +207,23 @@ enum {
 	IO_REGION_F_VMAP			= 1,
 	/* memory is provided by user and pinned by the kernel */
 	IO_REGION_F_USER_PROVIDED		= 2,
+	/* only the first page in the array is ref'ed */
+	IO_REGION_F_SINGLE_REF			= 4,
 };
 
 void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
 {
 	if (mr->pages) {
+		long nr_refs = mr->nr_pages;
+
+		if (mr->flags & IO_REGION_F_SINGLE_REF)
+			nr_refs = 1;
+
 		if (mr->flags & IO_REGION_F_USER_PROVIDED)
-			unpin_user_pages(mr->pages, mr->nr_pages);
+			unpin_user_pages(mr->pages, nr_refs);
 		else
-			release_pages(mr->pages, mr->nr_pages);
+			release_pages(mr->pages, nr_refs);
+
 		kvfree(mr->pages);
 	}
 	if ((mr->flags & IO_REGION_F_VMAP) && mr->ptr)
-- 
2.47.1


