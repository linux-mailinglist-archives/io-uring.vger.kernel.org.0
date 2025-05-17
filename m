Return-Path: <io-uring+bounces-8032-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32748ABAA08
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 14:26:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA5224A6C1F
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 12:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CD1E1FECB4;
	Sat, 17 May 2025 12:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N8iXfp+8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E924B1E7F
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 12:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747484800; cv=none; b=M/5PRU2+ISANj3/QcxUc1fJffxHtAGBquIYEt7ufaP5AJwfkUBhlV4OfzphuEq7sr8w6qieW/FQXlpNXfjpb4V6l/r2HUgIfUxt8LoSwqOOeq64sHxa6ilQZdaW9EbVVA7bEOssorvFa9WSxTvQ/V/P4ZMZ44k4sOcT+NhDJijA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747484800; c=relaxed/simple;
	bh=IXoEZ59Tw0E8nSN9pHgj9roH0/j8rU2tgE4xVrBV7wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHJaygJdjOdsmvn5D/73R3r4z6Qb0JyHvcgQABHTHfZ6Ah5exakRRXN6Ris6/cO7mqphuzB92hrxfOffVOw5gQVjpRrnZDwB9uXp6KPbAZM0Abf9xjkREYsfcNQICns5ozGffh23kqsKMOODotSLq/4c9PCcJfdg+fBaWzK7mz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N8iXfp+8; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5f3f04b5dbcso4121031a12.1
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 05:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747484796; x=1748089596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w4sRH95F88gQe49fz6GXCbta3BjfWxZwZhZVCqiA6OY=;
        b=N8iXfp+8J9BpL6q9Mibo6HQIj47YgXnwbWM9x+yfWswbojt/mX7Brt70xJxEt08lf9
         6eMkiVjmL3wNAm4xqc4ZbtY5TTuPLMsWdRlBj8Oqq5pQjg9OqSU68G+dOkEszDlJer1M
         eiMBgCqF27NvAJcwWdrp7uVdf8YazeZn6dkSLlazQ+J2iFNe65OrvWL+EZsQmP6/gcL9
         xg3No5nkCGbZIAJjFEWdvkcHva1D8yIJ+IcchKvr49ZOZ5kDbMGjZZjKIM02ItuZ4cYp
         V/7PAMAdthETPz0lIrQh3LUZouACtiCCbui0A0B9iPodiUeskWMh8xEObQow+t6Au9Lk
         Zhew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747484796; x=1748089596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w4sRH95F88gQe49fz6GXCbta3BjfWxZwZhZVCqiA6OY=;
        b=NBclyhQcvK8/eh3UCulJjIvbvgd8epK7U3ZQD50rYjesu/QdrZ2x3CcBrBLfuaIfr0
         2LF+DpGZdab/Bnv/B0RFvbYA3K3gp1XU43iYMCObatMO4rI9GKDKdmev+P5ltABJ/Wws
         L7JgMFtDoHL+R4wzbD3P4LwkdU46Wr6eXeMzYpvZqx71RB6JQk/DlzOQwiDegr2tRGUv
         9Kk7mTmupBI4ZJd8WAyRaeD2o3iK7FpNDcs6IZmIjtRQVqwVCwUiZTS1P2Pm7EzLeXxG
         6DY/2tSDVbfv8osqt//cYXkH7ceab5B2Oxvg8N0Fi+pbtehb/rx7ueTn3YT4gJhYLW1l
         06EA==
X-Gm-Message-State: AOJu0YwuoOEjWtVc2JoG+smB6K7HUuEFbNAGxigo3vZXIFIU/d0AaoM1
	Ip6GRGlO95RBGvFcLT0ScOTLNZr5eQBaMfrVUoS53qtLrU7/JJRNARp+SoD4CA==
X-Gm-Gg: ASbGncvgIjnXCS94nBenLgv9Bukx5z2BI563gBKzzo3RQUCSTsii1LPIJIOMl28dRoG
	M3ZMw2dZzxNpKInn5krzut5HN3ZIu+qGtWGmbJiiHqKJBQ/XrnFob3+NiX25iO4n56N5x4GcPkj
	E6QM2klkq3tOA0Mt1HSdedJfESdWk8GFCGRkwCjExp704TTZqS0gHGWk33C+PmuBn1Ona+/LjfF
	17AqHOxBX7bILD/SoO02vxl85UcCGD81aesTcrZ364nzLkbuv6fVq2Ipun+OhFWWRVRr4+uG/PB
	U9Ztu8RtvYvDHosEU+7rMzdTg1PhJYTsjjNuDHUyU6weViH/+rpD62Y0y1qvEPs=
X-Google-Smtp-Source: AGHT+IFjnJlO4VB29sLibNl7T9oSmb3qVNIhiOcTWbsfpDMpAg3+z7Nh+sW96Ag1F0sH+NP0JVLdsg==
X-Received: by 2002:a05:6402:280c:b0:5fb:f31a:df83 with SMTP id 4fb4d7f45d1cf-6008a390f27mr6600594a12.3.1747484796214;
        Sat, 17 May 2025 05:26:36 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005a6e6884sm2876604a12.46.2025.05.17.05.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 05:26:35 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 2/7] io_uring: init overflow entry before passing to tracing
Date: Sat, 17 May 2025 13:27:38 +0100
Message-ID: <cdf9400891dd484825a2883b3f273b9fda2a9fca.1747483784.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747483784.git.asml.silence@gmail.com>
References: <cover.1747483784.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

trace_io_uring_cqe_overflow() doesn't dereference the overflow pointer,
but it's still a good idea to initialise it beforehand if some bpf will
try to poke into it. That will also help to simplifying the tracing
helper in the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2fa84912b053..d112f103135b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -732,6 +732,16 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 		ocq_size += sizeof(struct io_uring_cqe);
 
 	ocqe = kmalloc(ocq_size, GFP_ATOMIC | __GFP_ACCOUNT);
+	if (ocqe) {
+		ocqe->cqe.user_data = user_data;
+		ocqe->cqe.res = res;
+		ocqe->cqe.flags = cflags;
+		if (is_cqe32) {
+			ocqe->cqe.big_cqe[0] = extra1;
+			ocqe->cqe.big_cqe[1] = extra2;
+		}
+	}
+
 	trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
 	if (!ocqe) {
 		struct io_rings *r = ctx->rings;
@@ -748,14 +758,6 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	if (list_empty(&ctx->cq_overflow_list)) {
 		set_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
 		atomic_or(IORING_SQ_CQ_OVERFLOW, &ctx->rings->sq_flags);
-
-	}
-	ocqe->cqe.user_data = user_data;
-	ocqe->cqe.res = res;
-	ocqe->cqe.flags = cflags;
-	if (is_cqe32) {
-		ocqe->cqe.big_cqe[0] = extra1;
-		ocqe->cqe.big_cqe[1] = extra2;
 	}
 	list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
 	return true;
-- 
2.49.0


