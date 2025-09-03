Return-Path: <io-uring+bounces-9545-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C194B411E2
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 03:22:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90486561D5B
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 01:22:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2421DDC08;
	Wed,  3 Sep 2025 01:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OrRc3EKj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07E51DDC37
	for <io-uring@vger.kernel.org>; Wed,  3 Sep 2025 01:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756862460; cv=none; b=HPAQv+sLFxPiSGhD9Vv+TcwoHHxajLauhnipqCJgUKAFP32GVM38QCrYsifCS5Y1v85GMQt42nUsj+7EredEHEkbP2EtaOEGck2NXqpkkMolfBGPCbMZvKwduNcQqieBEZdNjiG8rlXqKkEiG/zVBVWOPSNvXJ02xR2UNDkgI2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756862460; c=relaxed/simple;
	bh=fmNcwoVhmtA3sUlBlhDFCfMAovsp+XeyfaidR5mbMq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l5qcvRFx4tEz7NsyMj7oXs6HxAUfYeJ3VA66ZbD/eigkV+NdRS417sk2HSvDlVbmqqcHDUHUAfk76fbXozyKFeeZPfR/0Dw7/GdSvxFKNMdQJQzg5P0HOp4ddmI/y4IzuYKKoMkOtGgmOcAe5Mj4Qp7uRzvR4kEOl9vUWrLrbZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OrRc3EKj; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-88428b19ea9so23302339f.0
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 18:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756862457; x=1757467257; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lH27iUhjx48DOCWLoiAo/kj62nUk3VhPaNmQ4WFivsw=;
        b=OrRc3EKj9QrU/2fhNmyT7fvWbbp7cS6kEAzkoaOy3T4sE4etQGiddQonCn0fL6xUnD
         XALYLT4+bfQfaMzT852em83xC4ZvPQqVMxSs8fWoQi8wqQjZcppV+Cu/NElsNVqeStt9
         9YWTpUAIzHrqnpOPgGPBz5Yr5wBphQgreH1qaP74ybB57SJnOcI53j37XwKQGMamcW/8
         g8oLOjUGYbpLAHrKi/soqEqnDniqqHFkuK/6gbBjrnR/Fx/J+HtasFovQf95KXm0yRBN
         kd9ZXt1WBbZnxDzo8T13PDquvS4D9CEMEdQ7KzQ0HKUzswbry/oGTK24SAV3qY9RW1in
         2/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756862457; x=1757467257;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lH27iUhjx48DOCWLoiAo/kj62nUk3VhPaNmQ4WFivsw=;
        b=e0j/eKW3fsh+IMT5j/90yUa/HfoVYrdgPsGcwphda5MceFbIkGy053uliCgHaIYr2Q
         z7frY2qNo70el+zVg8+LDzMMLM8rR3xBWEtbKPjD4f8ZZTw8GONw0C7m10u0Z/4giMIN
         PIL/O+8zxoaEgwN1nRZxg1Pq3ZbvLHY4MFKXbGo5RvSd4+A0Njixyd9qhdWCUO73ITmc
         +/vCWIuwBH/62t0BjimHDPAJ7MzUzGn+wctwU2z24iQGpcrEPHH1da0rT9jcw4wgNXzz
         5pzqSd8MxdEsUZf5taD+Y4PLmQq46WVxAB54XtO4K5y7C0CdhtnHWKK/3NspdSMRj5Si
         KV4g==
X-Gm-Message-State: AOJu0YyxzQJxdCMGetSJ4wThnJdtvkcPF/kmd9Hk/LAP/c+Wg8mXzuSn
	E4b6YzE9zTT4jC8GqALouN3I5JB7HR4IROiPSMkduhz0hDeb+OFnN9wsvCfkuVW2n7o=
X-Gm-Gg: ASbGncsx+/T0kWiCK6fq25biFzqrQo+l7M3+JSC+t4Xw3GM6Z8RRhhmKP0KbDTEBk3o
	81/NYQPosQ3rdWr7eiLGll2WPq9y+utW23Xdsr1vKW3K8zzKwa75/HNE173wnosIDyK/Mb+yWVg
	b5Dc8fJEs0pM1HL98lmzXfsjvR24lA6Zr8W5T3cksxPV5xBlxdb82K5gO+f3RpJMyH/GvsSbLgp
	HyqTX1h+OKB9QRDAG51FqPZeRPynKuFKNJ+sqR70w03YPlM4WgCg7lens4DjUZQkC8SPtZID6Lu
	dg7zOn3EiccORM6VxZ/Q0d5izRQK3mgG9bU9EzU5UfUFrhITYfOkpzthhwmRcLI6/CquOmIzyLY
	Vymd6725+1ZMLfIbPZc78ptivzhhH6eXWGA7h/b9ZpADn2JxUCNRQdXJC
X-Google-Smtp-Source: AGHT+IHitIUUJVqzMKK8HpEQxgzwcYn/ZPrwZ6tD/9BkJMLk1eySpeUhvSyzB6hNahMhajjG+WgHng==
X-Received: by 2002:a05:6602:4006:b0:881:980d:ce93 with SMTP id ca18e2360f4ac-8871df0bfcamr2982560139f.2.1756862456737;
        Tue, 02 Sep 2025 18:20:56 -0700 (PDT)
Received: from [10.11.35.62] (syn-047-044-098-030.biz.spectrum.com. [47.44.98.30])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50ecafdfcecsm3078890173.33.2025.09.02.18.20.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 18:20:56 -0700 (PDT)
Message-ID: <28b5e071-70f2-4f46-86af-11879be0f2a4@kernel.dk>
Date: Tue, 2 Sep 2025 19:20:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: remove WRITE_ONCE() in io_uring_create()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250902215144.1925256-1-csander@purestorage.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250902215144.1925256-1-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/2/25 3:51 PM, Caleb Sander Mateos wrote:
> There's no need to use WRITE_ONCE() to set ctx->submitter_task in
> io_uring_create() since no other thread can access the io_ring_ctx until
> a file descriptor is associated with it. So use a normal assignment
> instead of WRITE_ONCE().

Would probably warrant a code comment to that effect, as just reading
the code would be slightly confusing after this.

-- 
Jens Axboe


