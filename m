Return-Path: <io-uring+bounces-1041-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F27BA87DAF7
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 18:12:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77CEA282316
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC16B1BC4F;
	Sat, 16 Mar 2024 17:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B2wY+VNG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB8C1BC20
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 17:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710609144; cv=none; b=h5wQgwQcV4W0jseTHM3MfNoR9Jkt+tke1A50fagXWYwPB847hDAvZ6pQ5ecBv+I7k2ywIAo3PlWg3Gy1cs/ZBkmYxTqBUEP7iBkC8zxjbpAlcCMEcE2zD4MZDilczItt1I3475l4z6XQsOkUra0X4es4eCNpXOwdkWkngFxMXik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710609144; c=relaxed/simple;
	bh=LLWMqz81glootpZXZKWeKw/5LQ2W6L5YPKB82i53wt8=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=bA7ZTk3lITNdviMEA3vecX1HCijNvTejXGCY/9+lou/W4anLksV+KLNXl6sPn9cQN4VE2blWber+U1IubuGWJZQO0C1L/elW05xQcxfKB0iOxs9UfYhwgKr7IdYT7wt3MqRChUlIYLTQI89NtBgtBH6MC3GjgFNWhssE8PNHSMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B2wY+VNG; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1def81ee762so2897735ad.0
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 10:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710609141; x=1711213941; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WRbexiv25ULgYSFYMs9m7hXNCOsJlMTYYcvn3ZobuDs=;
        b=B2wY+VNGl0INw2bR+RzbkaSYnajOiG4mQD7hd1XjqJ/d3eREX803InCoAxTuexEtq+
         h7DjoVN2fugkIdfAQT01F3ZUhaSHiinL2GvSfChjPBThNRCmOjX84F4wVuEAVA47cSpV
         ueA99CacFWxb/UxsaOjQMWZBcAgrJeDkPr0xT4pHGgXzJUHNVLBlua8v80wfXqTnx1Sa
         CIMBMhfqbk1vx6PKF5u2dYg+HGOkhNiTDQ2L5xvHsdK7kOai3zWNi89fU1kWa33rPkr5
         Uz9q1h/MOQrEYaumOb8jwz/s3cDlBIsanfatxTiAcKpsrCGn5iUbnh3ok4nSXuy+d5Vc
         tyrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710609141; x=1711213941;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WRbexiv25ULgYSFYMs9m7hXNCOsJlMTYYcvn3ZobuDs=;
        b=octpd++qTLZ2xh7fCBt5UYwcYFzlIhtQZHkyZxnAlaTrbxB0S+f2O8o3Ubsjd/yipB
         B4zPs5oKSKxnXtCNGDQdptW7ZwelcyokZe+AKAJSlFeJOoesW+VJ12KAAP3vjPL/SaMB
         60KK/L/Hs5DwfbNPMaUZuezu0NKU29fwKY4ywuLyR35u6QIFdaYDmAnqROMdE5M3zgnI
         RCX4h1Bxio24vCR0/p5549C2Sv6Rm/HbFA06FEWgRVudHZ1eWpbElG0PME8qc47bsFWw
         PW8dNfC/ArHUcC7G/lJRV9AejINRqiaI1jmvZ2U8nf2RFtEbFi6akoVAWeqRbHZHa4We
         frIA==
X-Gm-Message-State: AOJu0YwpYfLW989dPHD8EHzDQJeuqI6kfYVs185RqukGhQzP+LOR86+d
	THna9EDK1QaJ+e9uJl+2hwZfhEFO9zCtLaYxKceTesV0mi5ot1eLAU3w+abUYJFczZOiRI686WG
	4
X-Google-Smtp-Source: AGHT+IEsScGe2wrrM6POha42gDR+KRSbhKLuzWMEd/6UvhTV9rbaOuNwpG+yJ2477eJa8UhbyIG1sA==
X-Received: by 2002:a05:6a21:3a4a:b0:1a1:67a6:511e with SMTP id zu10-20020a056a213a4a00b001a167a6511emr9453367pzb.2.1710609140872;
        Sat, 16 Mar 2024 10:12:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id gx20-20020a056a001e1400b006e6bcbccda9sm5188154pfb.59.2024.03.16.10.12.19
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 10:12:20 -0700 (PDT)
Message-ID: <5eb0fff0-5357-4407-81bf-8d7698c86e8b@kernel.dk>
Date: Sat, 16 Mar 2024 11:12:19 -0600
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
Subject: [PATCH] io_uring: remove timeout/poll specific cancelations
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For historical reasons these were special cased, as they were the only
ones that needed cancelation. But now we handle cancelations generally,
and hence there's no need to check for these in
io_ring_ctx_wait_and_kill() when io_uring_try_cancel_requests() handles
both these and the rest as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8174abb8313e..76dcb21e9318 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3069,17 +3069,8 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	percpu_ref_kill(&ctx->refs);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
-	if (ctx->rings)
-		io_poll_remove_all(ctx, NULL, true);
 	mutex_unlock(&ctx->uring_lock);
 
-	/*
-	 * If we failed setting up the ctx, we might not have any rings
-	 * and therefore did not submit any requests
-	 */
-	if (ctx->rings)
-		io_kill_timeouts(ctx, NULL, true);
-
 	flush_delayed_work(&ctx->fallback_work);
 
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);

-- 
Jens Axboe


