Return-Path: <io-uring+bounces-1237-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB44588CC55
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 19:49:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2878B1C66062
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 18:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CDF13CC60;
	Tue, 26 Mar 2024 18:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mcAt0Pbq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00BA13C3CD
	for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 18:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711478866; cv=none; b=BDfKz9RIfK8SjrZTltQ6CGMv6e/1UTCsYwn8+5avk4ynn4nZ0i1zYwRvI7bzfRPjofIU3VDp4cKnebCzwCN4rmFE1t5sqtNzyba8AOtds0kABaDOODdiOTMv8kK/1KCMZ1agEB6Y3GRGYMPrePb+jB4YIEbFhSNh8T7ZlPplA8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711478866; c=relaxed/simple;
	bh=rviGZVO0SnsOaNrFpmkgb9IJ0z8NV8Fb64eGqeeunw4=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=f2J3N1Xkw+aNFgBdJ1wyNI3eK/W8D04DXg9RCAO92Uvds881gM0z7lwH0gvZW5yF9TRR49CnJJGNhy7K5MbBbURVd31FFpSgoI60f4xhJT3mqWWX0lfYNRsPGGLlPmxwDagnHYbZbZDJbqkP5EjMg4RLj4kUY4PSIiOn56EDWHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mcAt0Pbq; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1e0e89faf47so3625925ad.1
        for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 11:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711478864; x=1712083664; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOTNEz2+cuTQqfMG8+tddhDw9QqYgfZGl4wO9HoCExg=;
        b=mcAt0Pbq2+TCmkNlRNOqWBjoNoyAmeCYwVnwLMKpueTlJ/NODM7ZihP9jm3i8d0/mE
         9mUSgJD2o0Q2NDcO8/lTYrT9z2R1KrIKd/HYFUaqJe8OKo5BZIQ0GB5uuCVC5HhvfLCC
         mzikoO9+gQE9YbflKV6WRf6LbE4HDgUS/SSWKb0r11ntTFG02O6chAhdRuUvIkdPgKMz
         PxsirzLm9aNpb/6R9JLCIf7dtVMemXc8oBHrGrW3xCuDap/q1QKOGYEG+oj6kLnbRu9e
         STs2JPCoV+86onR3EmNHOCLrjUmKm7ZLONR+n0TBNVZsG8aXBhpde3h7bsMVedhBEpT7
         XmPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711478864; x=1712083664;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nOTNEz2+cuTQqfMG8+tddhDw9QqYgfZGl4wO9HoCExg=;
        b=ozSbLpycWhU0ZCK6jLyTEmSQecBrZi3MvC8E+l1QWHR0G8dHd6UffTACvdqIKFNw2P
         eMaMnrpEzs/ZIvDDZLVqL1cs1gHDiLK8h4IbQnTGoCoTe7yv0/ax+7RagRmbOIddphcB
         h09PevhEg4QPE2yQIK2kvAW/aPb8zF1Objv4TZuYAb8o4+O474sNYgAADe80goPSrcsv
         hju0q/pKXzp1cAu1BtAqPxQpImW0XG9M7ZRi4DzvLvJqk4vkqQ40RexMbMK2zOefHXxj
         k8FAqL6s3iL18Fa7CSnXCpT/VsVt6qMbD9IeOuYN1zCdP1bqOMnHLGK68rPgQKEDFnl3
         UsGg==
X-Gm-Message-State: AOJu0YwBgZQu0GaskezwUpQqiZccE6a/Iif1KZqeHC2lcoBBPnZibA+7
	BW1k7iT7IcaPvUss4H8vvYEoAOoGdxo+ebKDW1b8OesJSrmFdnld+lnjnB6j5CFyvFenvKmmTly
	K
X-Google-Smtp-Source: AGHT+IEIlPkJeHG9VgnWZteCX9+rJ7rRJu7PhaC2dnOIlJUYRFYzKFPn6JlCQsrojK8EI/TTS+n0XA==
X-Received: by 2002:a17:902:f551:b0:1e0:c887:f93f with SMTP id h17-20020a170902f55100b001e0c887f93fmr5721783plf.1.1711478863698;
        Tue, 26 Mar 2024 11:47:43 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:163c])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c20d00b001dd82855d47sm7151084pll.265.2024.03.26.11.47.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Mar 2024 11:47:43 -0700 (PDT)
Message-ID: <eb71eb39-abaf-4ba5-8a71-a112bd5de377@kernel.dk>
Date: Tue, 26 Mar 2024 12:47:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: refill request cache in memory order
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The allocator will generally return memory in order, but
__io_alloc_req_refill() then adds them to a stack and we'll extract them
in the opposite order. This obviously isn't a huge deal, but:

1) it makes debugging easier when they are in order
2) keeping them in-order is the right thing to do
3) reduces the code for adding them to the stack

Just add them in reverse to the stack.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 40a98f6424ab..585fbc363eaf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1039,7 +1039,7 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	void *reqs[IO_REQ_ALLOC_BATCH];
-	int ret, i;
+	int ret;
 
 	/*
 	 * If we have more than a batch's worth of requests in our IRQ side
@@ -1066,8 +1066,8 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	}
 
 	percpu_ref_get_many(&ctx->refs, ret);
-	for (i = 0; i < ret; i++) {
-		struct io_kiocb *req = reqs[i];
+	while (ret--) {
+		struct io_kiocb *req = reqs[ret];
 
 		io_preinit_req(req, ctx);
 		io_req_add_to_cache(req, ctx);
-- 
Jens Axboe


