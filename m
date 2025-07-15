Return-Path: <io-uring+bounces-8683-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B61B0614F
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 16:36:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0553566E23
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 14:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6AC1299924;
	Tue, 15 Jul 2025 14:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uhj6iLb8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23511271449
	for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 14:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752588623; cv=none; b=Mg5y7Kdo/EX53ImzdcUiu8VmnKG3JKKexISB8tJlitYWlHiKiwCm32sAN7Ku1mbpXI/zys3RAajkLtD8xZd/8uuEnLB/XJWWPfRbofms3zEbomrdKAbLXIsveXpeXObqHL9f7j7Arhh9rX/psCxjAiF9IO50UW7sThZvdytfuc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752588623; c=relaxed/simple;
	bh=+bManZoJ7DUc7PE7xd7pJIQtqW11gJZQd7GwUTQc7J0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hCjFm1glYuZvdnnuqN10NPO0NSd8W6esVKNHEtDSS1Yu/5C1mdXIo7dwiMmdckGeOp3QvIwchjOZPeVK01LywWwLnEXzvybq59eWUcXmtHwUjnaGN2OIyfwkFb+T84EsNxKnL+ldWLVKWLEebh94Uju8O+vUm7Vh9AopTcfY6UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uhj6iLb8; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3da73df6c4eso44165965ab.0
        for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 07:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752588619; x=1753193419; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gz6M9A3kNVymngWUbjHxUUeWvWwN2Oe7xxlyyy1otJk=;
        b=uhj6iLb8jUGuO8NvGeCz6/X7zB+qHasRR5W6nO74xGZWuefIEdHWhFlM+zdo378KnG
         QemLJ9FwwbS3B178uWI0VUZfJP0Wf9qMe75XoltTbvBTz/YHaTSIBPPHnDEruTjYAeS+
         7A0HewDXbnlHIqURfXp5J8DdfK0gXZUoWu4xV5dRkV6uSYWTFJjvAybZTdKWb+ue+t41
         t3ljdq45hfdD5T2QkKHeCE80Gzc7IcVfj0Pu7d6rIoKV5v/ViHBN9ebxwElPwM0DoKoR
         cmsOAfKOmDmVrU99kJI/P664Lj7DI+TpZ+LhfQ8BgIQTywdOWjyXQKC4w8DQNA95Gz2C
         y+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752588619; x=1753193419;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gz6M9A3kNVymngWUbjHxUUeWvWwN2Oe7xxlyyy1otJk=;
        b=cjxcAi5vKtU8aExTk6Nejos9Cjs9w0YJKThp4rkRTTmg3l29wVHVQ+Sq1cGkP/KSAc
         IfbQVBVLAnMNsMUrDlSmLSKn5sCCDZcuSAmsgjIugHg8yklecRYUBPFTzT0fFfH5M6rB
         bJutzjBqPc+2U1Vr/eMPgmQTQfTbU/T5/7V5ne5bq3rIwVMJkVifwvJC2zqfMdhBZJxE
         0J6cLBAYGiCivTjyrQQ/2NqSQ3ilQR+tn6pHV7vjVhH/LaQ/s9mGF9zboYgtnA/vD/in
         pRscpBikLARVMXcN0OykbY8PHlQnjYJ9rBM90PJtb2Gbw4EKbVR1LH18qDaACrZti4hY
         W6aQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDSm9MgMoJPDTxpBaTUTrGDtg9PISRRiciuG2Eq9uqdaJlzk/5rPobJt8nuzMagQH7FrTJEtDsJw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwhqCSnR3Qq4rDLnkY9vAS1Cpe81lrm5F8gfmgTG/54fFTa6j2F
	GKofAgVLrL67d/wPnBSEqjg3iL2fGQMv6ZFVAZVPD+30EaaCoRfv70X/Ry9XYLZ3ONxxJBEzqXg
	LvQHM
X-Gm-Gg: ASbGncs/D0IoAsv0b0sBo8NOMDRuioAXYiSvRaQIPXz+zCH7VJxfiPYUelFUM3oY/I4
	6MJRdH0R0rAER20h1CmGHSp2XNejcx5aKtC8n/gwtAZjuA30UF3ibJ6QqcFb41jqydQqT/EZ4dV
	bY01AEUeX8mCRgDr4QzUsuFjKhZ6PPjBA+WdFC3ezym6pUntdobPDLL4fhgRAP/fp3aNZpBazpt
	OMK0LwxxyvldKZ4aDkzDiKhEB+BPtdO8y0DWEo4se62PwlETP7keiMwpjUrYgSM+8S3KbUZ2E0h
	+NVxXiI9MjyArTOM9cbrXoaf6acogAuDF5pX7+nXmCyMLTY6tqCcr+659CuZv9esOpgdOPYdxOV
	Dqyt1j8FBdwPU9C71EZw=
X-Google-Smtp-Source: AGHT+IE1jSl0+Ol461G6fZrpoKwEDGHayubqoEeTwWls/gtKYdvp4zX/qFJoj8BP/4ShuOwARvbT3w==
X-Received: by 2002:a05:6e02:188b:b0:3dd:d189:6511 with SMTP id e9e14a558f8ab-3e2556d42ddmr182511335ab.21.1752588618466;
        Tue, 15 Jul 2025 07:10:18 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e276c97460sm7269955ab.70.2025.07.15.07.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 07:10:17 -0700 (PDT)
Message-ID: <4bc75566-9cb5-42ec-a6b7-16e04062e0c6@kernel.dk>
Date: Tue, 15 Jul 2025 08:10:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/3] Revert "test/io_uring_register: kill old
 memfd test"
To: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 io-uring Mailing List <io-uring@vger.kernel.org>,
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
 Ammar Faizi <ammarfaizi2@gnuweeb.org>
References: <20250715050629.1513826-1-alviro.iskandar@gnuweeb.org>
 <20250715050629.1513826-2-alviro.iskandar@gnuweeb.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250715050629.1513826-2-alviro.iskandar@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/14/25 11:06 PM, Alviro Iskandar Setiawan wrote:
> This reverts commit 732bf609b670631731765a585a68d14ed3fdc9b7.
> 
> Bring back `CONFIG_HAVE_MEMFD_CREATE` and the associated memfd test
> to resolve Android build failures caused by:
> 
>   93d3a7a70b4a ("examples/zcrx: udmabuf backed areas")
> 
> It added a call to `memfd_create()`, which is unavailable on some
> Android toolchains, leading to the following build error:
> 
> ```
>   zcrx.c:111:10: error: call to undeclared function 'memfd_create'; ISO C99 and \
>   later do not support implicit function declarations \
>   [-Wimplicit-function-declaration]
>     111 |         memfd = memfd_create("udmabuf-test", MFD_ALLOW_SEALING);
>         |                 ^
> ```
> 
> This reversion is a preparation step for a proper fix by ensuring
> `memfd_create()` usage is guarded and portable. Issue #620 was
> initially unclear, but we now suspect it stemmed from improper
> compiler/linker flag combinations.

Maybe just bring back the configure parts? The test, as mentioned in
that commit, is pretty useless.

-- 
Jens Axboe


