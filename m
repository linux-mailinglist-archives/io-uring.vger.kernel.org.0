Return-Path: <io-uring+bounces-3038-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C125696C7C1
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 21:42:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D6782875C9
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 19:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7D084A27;
	Wed,  4 Sep 2024 19:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="w08QlZm2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28481E1A34
	for <io-uring@vger.kernel.org>; Wed,  4 Sep 2024 19:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725478915; cv=none; b=eXnqzTUGLbcwULZncIbNT8bWD2Jad7PjsiLOztdtVDmw9+t1z0dFRJ5c8TXkHq918uSzlpu7aju078l9R6EmkBEGGwVKGH8AHFGChJfhN9ueseRTbc3rAFEMRIBdo7BA9T9i6Pe82EP+Kc+3UA3uuPY61QMFqfDzUq0xKSbmPs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725478915; c=relaxed/simple;
	bh=wbc+d2YpNTtCFGaD6dfisy7NLXUN9LVrut/O3nL494k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fidlEDx/SIXzQDGcyYMwMtIFw/DG4X3d5LwNyvZ6Z31MbBUj7CBQHQriKnVLOFKtQf9okIJF03zEzq3Zy0sdfnJrfkWd6mA2On5tKEJH4hobdGl1L8/z8NyboPymTUm50IPI6Sh/mUbMxu/zvziyq47Ty8CKpFjdYKqFHb/fTtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=w08QlZm2; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-39d47a9ffb9so25529605ab.1
        for <io-uring@vger.kernel.org>; Wed, 04 Sep 2024 12:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725478913; x=1726083713; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RdwDAwj1M1g5czG2XW5eNSEASwKM8Vfwg83dxIvpeAI=;
        b=w08QlZm20dmSaeI4iVJuMF/vukREsJMyYCAZhdJoI+zZX0soN0Z3Q7OUJOE1UQbafB
         qQX1S1cPqwNvT37yGCZOymYQgOUyCqnoDtGBX6ZI2vZ0rHfyp7rYxqmxc4u81rRMLQum
         3onLKk70J9vBME7dRCb6sML17qMWXECGkMPaRe30pfxMmAnubH6ZMw6BFoH0asRrTHS4
         +B6jKlDuHEqUpUksvUI6iswv5YdmwUjIZTks6H+17Af9s4vKVm7Mcbz3sbSZycq6mQDm
         YG6VYJtgi12T6SLH5jFXzPvTcooxp93vo+CwliZMAywf1ioYkR3xQS1gktnmKLxX6nSF
         LRuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725478913; x=1726083713;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RdwDAwj1M1g5czG2XW5eNSEASwKM8Vfwg83dxIvpeAI=;
        b=s1n6ZlzYuVw7yv19UPfF1frOt4esqNYMxaLDN5tFDcaQpRSlu/z7P7zrNYS4/JUZtc
         vMNxQiQmpvd17onWQkfepkbBvk7KUh2kwI6nuQ0bzFPtC8EDULy6u9MQmjykd+kZ0H7q
         amFeBXHX9Anbb2lJD4z4+D8Leky4tVuGwbD2B27Xmtqv6C058POp5domrdkDmSJ691TL
         fvjBvLzce+x7SE2D3E0od34g0ECoaxmOYBs0/wOaopo1quaFdX7EDIXQArvTBdTt5VaY
         yHZJp8xLQnyFj1E4oK1Pcmyfh9a1MDbLoqbWTkfSkAdoJGLkQzhUbhGmT+X4TwSjhgWx
         LTHg==
X-Forwarded-Encrypted: i=1; AJvYcCUh9hFRTxfTbEpO/NAGhAW09wg/aghWf7uhRW6G7FGSLo9JtS8TigVorZNuhmW99zVgamKeqCCgdA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxboMhOaq3697s16fIaFVtNQ7h/aNVktUp7K7hSg0OoqBqcNItr
	0twfD8YsMiIVioxZHUaHiujhIE8QRi+YIG3tlG96HStvLKayfJIkl+bZ7ERnptE=
X-Google-Smtp-Source: AGHT+IHeZk1frFnh+IgNt7FlgN2aGXKB+oocbA6gS5JVRPoPWPYbe0NvMfg+O8wOba9QrMFCFRvn2Q==
X-Received: by 2002:a05:6e02:1a29:b0:39f:61e4:1ad8 with SMTP id e9e14a558f8ab-39f61e48be4mr123352395ab.26.1725478912732;
        Wed, 04 Sep 2024 12:41:52 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39f5078fb2dsm26948335ab.87.2024.09.04.12.41.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2024 12:41:52 -0700 (PDT)
Message-ID: <5a71607d-ba1a-49f1-8ea6-7e619b85b547@kernel.dk>
Date: Wed, 4 Sep 2024 13:41:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 00/17] fuse: fuse-over-io-uring
To: Bernd Schubert <bernd.schubert@fastmail.fm>,
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
 <e51abb75-b3f9-4e91-91dc-81931ceacad6@kernel.dk>
 <93127b12-77ae-4e25-bb48-8c8596c7702f@fastmail.fm>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <93127b12-77ae-4e25-bb48-8c8596c7702f@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/24 1:37 PM, Bernd Schubert wrote:
> 
> 
> On 9/4/24 18:42, Jens Axboe wrote:
>> Overall I think this looks pretty reasonable from an io_uring point of
>> view. Some minor comments in the replies that would need to get
>> resolved, and we'll need to get Ming's buffer work done to reap the dio
>> benefits.
>>
>> I ran a quick benchmark here, doing 4k buffered random reads from a big
>> file. I see about 25% improvement for that case, and notably at half the
>> CPU usage.
> 
> That is a bit low for my needs, but you will definitely need to wake up on 
> the same core - not applied in this patch version. I also need to re-test
>  with current kernel versions, but I think even that is not perfect. 
> 
> We had a rather long discussion here
> https://lore.kernel.org/lkml/d9151806-c63a-c1da-12ad-c9c1c7039785@amd.com/T/#r58884ee2c68f9ac5fdb89c4e3a968007ff08468e
> and there is a seesaw hack, which makes it work perfectly. 
> Then got persistently distracted with other work - so far I didn't track down yet why 
> __wake_up_on_current_cpu didn't work. Back that time it was also only still
> patch and not in linux yet. I need to retest and possible figure out where
> the task switch happens.

I'll give it a look, wasn't too worried about it as we're also still
missing the zero copy bits. More concerned with just getting the core of
it sane, which I think we're pretty close to. Then we can work on making
it even faster post that.

> Also, if you are testing with with buffered writes, 
> v2 series had more optimization, like a core+1 hack for async IO.
> I think in order to get it landed and to agree on the approach with
> Miklos it is better to first remove all these optimizations and then
> fix it later... Though for performance testing it is not optimal.

Exactly, that's why I objected to some of the v2 io_uring hackery that
just wasn't palatable.

-- 
Jens Axboe


