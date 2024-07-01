Return-Path: <io-uring+bounces-2403-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9406791E2C3
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 16:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C55791C22881
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 14:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3F616B750;
	Mon,  1 Jul 2024 14:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GKqbruL1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B3116C863
	for <io-uring@vger.kernel.org>; Mon,  1 Jul 2024 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719845358; cv=none; b=O8VnauPDvQBD7fuhx3qW6zVs3yQSlxFT3dDgY+KxrdMw2w75UpCchZFVbE0mj7heHw9gdhT7U1PHuIHCuagv5wPGz4NGg53+J2cYlywPe2bHp6Z6cNYZ8PH3sjbXV5Aft5fsAsWwcJn/8/U086eJAjrf/rDydYZLOoISow8Zaj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719845358; c=relaxed/simple;
	bh=admKDe4e60Dcc4mIlxOoQS98/OyQyQp++RVS7dO1mqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0hCGfcCD7o8b0JwfAqk0bCbDLMURiUr7/+tBPNHIj5FTSLlJ8fj2KZk+aMV4qXHWITef1ck45iHTJk7fKMuZA1ZUEMaGRj2DJOgB6sfvxN3NjVlrGnU+VsfdfReiwTXWo8vB2BfY0vKHnV0JR/PGsRTOUxUT/Ao1rcq0dK+Oag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GKqbruL1; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5c43dd8d348so38858eaf.1
        for <io-uring@vger.kernel.org>; Mon, 01 Jul 2024 07:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719845355; x=1720450155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AyErbdBirqGQIr9VWb7ujarTlfm1GbvY/AEKEAfqIM8=;
        b=GKqbruL1C18AAFb+HUpV8XuA/SevebNLKzkvW9Anztx7TrI2Qe4sVitLzgR1zjdI0R
         ukoUzjCEroUXyhmaeuv/OzmMPIwUmiNw2YN5k3wIh770MJ3FGRCqpPxjBW7sMJAC53PW
         0imdSwoJDeqUN20meJXPEciy5EHuQ1cZDJGCRI0X+xLjrrY5A+NMuhSmfIou1K94Ky3s
         +ya9FOLsWJU40gkHjj3lhnjXdtPxEnBFbPRLbWn69FUgbcOTA/Y/lJ4D1AQ77Jo5W3Wp
         0mGnXwHC5j3m6f+fOIEJ5hZkUP7gX4XyvQtSQGKb8cHvbspPlv3Z4UOSnm89tFv+quP0
         NTlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719845355; x=1720450155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AyErbdBirqGQIr9VWb7ujarTlfm1GbvY/AEKEAfqIM8=;
        b=hJcnV3TtoynabUZRDS/Z3awklYF4hYPWf60ijHk9pKI4A8J0uwr1zs9+Ny5z0bVH72
         M2FIqB1OG8IPgrialwJ9MYZyj/Ge6jqyGYXhVVPLe8TpRA42rRvbh0foYyIi7Uwuj+nX
         OpcjZaMSsz4babhmnVlEF//lceYnZDBkpkkHP8R1gVB5D1pzCooiPg8gEW7C7FYwoNDU
         kPJETCZ0H/dpP5eKFMf1e2n9nJoLluSPFVQsFdmKZMN8JfLkoULed3EUBvatFsp9Cva+
         e9DzRjmxfAZPdqGlFgZICtgLiaXTd+MRf6A/Di44vV5s7iwksD/iLL2CeRhYpa/hJNb9
         ENNQ==
X-Gm-Message-State: AOJu0Yw0GT8vkvXjlk1SyPCouMh1sZXlBU3ohUONH9u1of9wG//hRYrW
	2931muP0sURvKwPoaHgASqZjKYHwk6F7sT6uzoSkWlBH5ZrYPTu5X494lQZ6wy0nctxsG0xG09s
	PSww=
X-Google-Smtp-Source: AGHT+IF60zaIOFyOVsLd3+ocx0AOzsBiehs7OBJlvacEurq9c0thZsAYi/17ppsFnJxMZxlUh+0iGg==
X-Received: by 2002:a4a:ba84:0:b0:5c4:24e0:26cd with SMTP id 006d021491bc7-5c43902eff0mr5522694eaf.1.1719845354755;
        Mon, 01 Jul 2024 07:49:14 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5c4149396basm1025133eaf.21.2024.07.01.07.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 07:49:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/msg_ring: use kmem_cache_free() to free request
Date: Mon,  1 Jul 2024 08:48:00 -0600
Message-ID: <20240701144908.19602-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240701144908.19602-1-axboe@kernel.dk>
References: <20240701144908.19602-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The change adding caching around the request allocated and freed for
data messages changed a kmem_cache_free() to a kfree(), which isn't
correct as the request came from slab in the first place. Fix that up
and use the right freeing function if the cache is already at its limit.

Fixes: 50cf5f3842af ("io_uring/msg_ring: add an alloc cache for io_kiocb entries")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index c2171495098b..29fa9285a33d 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -82,7 +82,7 @@ static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 		spin_unlock(&ctx->msg_lock);
 	}
 	if (req)
-		kfree(req);
+		kmem_cache_free(req_cachep, req);
 	percpu_ref_put(&ctx->refs);
 }
 
-- 
2.43.0


