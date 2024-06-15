Return-Path: <io-uring+bounces-2225-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0ED7909518
	for <lists+io-uring@lfdr.de>; Sat, 15 Jun 2024 02:39:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E3532848BA
	for <lists+io-uring@lfdr.de>; Sat, 15 Jun 2024 00:39:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30AA4804;
	Sat, 15 Jun 2024 00:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SNaNuloP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE5F1373
	for <io-uring@vger.kernel.org>; Sat, 15 Jun 2024 00:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718411954; cv=none; b=qJ8SlXoc8ZhYUTfsQk295uYHhc6Yok+VyURpDqJ2B+3lgNF63ZC0pEz3+BzQtXZ0gpHWIMaFdFbaJIJ/q/cSsrZVytZEjmJyaUR71jlGxmAGjstJ76YNgQEgLG/nsB1tno3BaHA0sM0ud51TBbRs1IcV3Hm/E9eiGWRb5KgXLnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718411954; c=relaxed/simple;
	bh=JpwShLvLpdCvUq0tZQRnGNwybhHbyYput21LaJq/rhE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=QkbJvXm4KQwUN4KkkK7NuUedMNoUg49yqOiZCcBDVIPocBO+sNGm4O+px8U2ivQeFDlVxylIY9Gyj/W3VzEHSzyphv+i8nRRG6yLNaSpgekDFb8FwTlHwU2XUr4ZM7l9hZa77kWIE0/eWliENV/9+IEFKhrAZ93FxD93SdjoZ7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SNaNuloP; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7ebb58f4f4bso5375339f.3
        for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 17:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718411951; x=1719016751; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PSm+L39pGAnp7ODjaYuf3nHJ1dNUQOdDadw7rl/gQO8=;
        b=SNaNuloPsYpd2LVikHBDLOPs44oi348jlx5YP2UFClHEL6LSsYMCzVSjXqa/rHCzzW
         Esz4cQpBlsXWrfrFmuTzRowJTu1Som3g+f53ZA/2WoMBSP/KLO80pfKUtcQd6ILBIg+W
         e66+JWQOFWygH7N2aS4kj2n/4VNsD0owS0ys/fX769xZ6t7/4fmgixYpifAS+695fv5L
         PTdVhxFWZ4QkKlO0qCfo0+8/qF7/Qu6m4N7VK4JS+S1uo22T/QlBFFWHoK89Il7eMtLy
         ld4Bd1ldo1f0J2G5MRSYAynmEL8/LHE42k0rZSUPFZMvnPSIHwYwjSTDSK+7H3FZVbdi
         A3tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718411951; x=1719016751;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PSm+L39pGAnp7ODjaYuf3nHJ1dNUQOdDadw7rl/gQO8=;
        b=BaMCt4bUuRFEddKnjKSdW8mj3fvIplwXgw22wo+zvuqaD7YuK4u+DQwBD0hGbDI8mV
         uYnIHjQUg7/Leda4ltrjunxVRNE4SZBDdDAuaXugQDB76AOMF6LfKwRlaYkp4p6eYc6T
         f1/BN6KDi8fiE6NsBn/midN1NAtJPaiYnXbcBLqM2qZ2d/Mc0iOedh14sUG2KBDlyoHA
         Jj4E7gCb81ST3cWO+RkvKFDpcbv7CozkTM8DPhHUnCYWClSrKp/KlFXZIVjtZ/rq6vN5
         P9X5yVPUrFOEDcNWWKjZTeF5CPVKPGZsyjT5a00fENCGNcy78haIiHHaPFMmn0KnbWsE
         MIGw==
X-Gm-Message-State: AOJu0YxXA+cSLs97Xxfbp4DOY++MQWSScb+pXPyGBf0JdZLZYyxY1jNd
	U98U9W52nKzS03zD+5jBMyDXz+e3m4R108Ualwjb+rRUjH7q4gdQK+L162gKnCI=
X-Google-Smtp-Source: AGHT+IHsnel9baJmDu3yjeArw2zknPVgKZ1YQY0j17UgHixA0+lhKVfBSWEPnfc3cbDEzCngS6HjMw==
X-Received: by 2002:a05:6602:154:b0:7eb:73f1:1357 with SMTP id ca18e2360f4ac-7ebeaeef51bmr416202939f.0.1718411951017;
        Fri, 14 Jun 2024 17:39:11 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc9257e0sm3658386b3a.29.2024.06.14.17.39.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 17:39:10 -0700 (PDT)
Message-ID: <97b10c69-7884-42a2-a1a4-f4eee3b5b099@kernel.dk>
Date: Fri, 14 Jun 2024 18:39:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] io_uring fixes for 6.10-rc4
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
References: <ae3d160d-6886-47a3-9179-de6becf0af38@kernel.dk>
 <CAHk-=wiMPR5nuVp416xpwFFBb_wcdg-eRDsGQpkDv91bQkMoTQ@mail.gmail.com>
 <8058db6a-4255-4843-8b7f-8c30aa277b26@kernel.dk>
Content-Language: en-US
In-Reply-To: <8058db6a-4255-4843-8b7f-8c30aa277b26@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/14/24 6:22 PM, Jens Axboe wrote:
>> The reason you need that
>>
>>                         __set_current_state(TASK_RUNNING);
>>
>> in the *other* place is the very fact that you didn't call schedule at
>> all after doing a
>>
>>                 prepare_to_wait(&ctx->rsrc_quiesce_wq, &we, TASK_INTERRUPTIBLE);
>>
>> So the bug was that the code had the __set_current_state() in exactly
>> the wrong place.
>>
>> But the fix didn't remove the bogus one, so it all looks entirely like
>> voodoo.
> 
> I'll kill that other redundant one.

Honestly I think it's cleaner to kill both of them, and just call
finish_wait() when we now we're going to break anyway. Yes that'll be an
extra check after the break, but that doesn't matter. That's more
readable than random __set_current_state() calls.

Will do a separate patch once I reshuffle for -rc4 anyway.

-- 
Jens Axboe


