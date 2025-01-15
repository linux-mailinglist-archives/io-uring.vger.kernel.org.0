Return-Path: <io-uring+bounces-5888-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 165B6A12962
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 18:07:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65B447A05FD
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 17:07:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D371990C5;
	Wed, 15 Jan 2025 17:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uaQo1i3C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277EE192D69
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 17:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736960859; cv=none; b=eMuBsqAXRDqYNwUIN4+dGDTo4pMoknrREntLR4IesD/LUOfeBELyPWrnh5MuBv/RbqKLFC1XxpNayzfI0JRbNXSfdu85V7A8Nr78TP9nL8Cmg8wpk3Me90LfeNLbjsqV4lQzq3chYWZTW2f3mQsPfofmdbNBUurPswd8FDL/FXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736960859; c=relaxed/simple;
	bh=Wx0VeeTMi08KlXgxqrOmWyyBuL+pZqYNt2OsH7Q3YVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bT/sVJlf1MdU6sWcffEk3g4qFBfXiGwxldtvDXFunpoIJYGEkvJeyolnoeDhbferSN+xzQe+nruHr35bMn+Qrxjt7joBUqQmGdVE4XiB9z1tMmDmR3kWDNXdPF+YKihxJGmeoJmIqPaeZXwtNV5P0ePmmixB1R12ifND0GPvUvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uaQo1i3C; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-844ee166150so221798239f.2
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 09:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736960856; x=1737565656; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z2A5SCpB8WeqB9juiIe0GlyGttgDVJOWI4w1w4gv7r8=;
        b=uaQo1i3C/MFIB8cgFVYqjkFjRM0XKuBDTVQLmIMxeDyI4srIRlYYv1RANx6RTLRXjd
         CLVMGQWXJFr+tx6CMKgHfb4vy0AXshoOtjo29+SttPCqXFNSYuizbSvKWeL0u1XpBOcc
         Y5jMrypSRPmHKXjORTayNdhoCE3A2SMV58P51GejXRgkjpXhw5UmNNP1YDRDQ9fF39xg
         tRYtzMPue72bWFgsfxhKi4IZRxP14DHoJ8CuPefn7t7Mc3H3H9XP2JAhNlsPE5ylXuDH
         d/fHnoIV0fT+la9zddkpsl5rKWk1xSOKgX4Mcj6EMT4FRurqjk8B0J6JzPWTAyr1PDzd
         xCzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736960856; x=1737565656;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2A5SCpB8WeqB9juiIe0GlyGttgDVJOWI4w1w4gv7r8=;
        b=AqtoHrTMkh90r/68MQURQHLbGN3JCAsFik6t/rUvTzf7waqx3uAFojZvkjlA7flcX/
         ifcb1llkUl7nq7fC3m54UXEVwJ77HDs97nmENGLtvV7VGdoKdRvaN/1A0Qy9q7nDLhLY
         TyPu/nk+qnm1Zg/a1bv/GrpBDi6ml5p+mSR6RC3Dz5iz2Mw519h+rufaf2t6qaVJzYaK
         uT46pWk3AAtiLeN24B+6uS4DwW7Zm2ctZ8xCWHi1su19FNSSGbYRuI23ZzMZdddJXVho
         I26zMST5UU9HtwsOijOEIXFq+nRU7NRcBm/yQaXjAP4MjBt4xKjdjnVIpz77l8YptVRk
         VVEA==
X-Forwarded-Encrypted: i=1; AJvYcCV8vEkN30S277H5pp4cMK4GmuOAvV5xcar83+ADSXOY1uXI9RHTwupip3EfwrUE63P675UXxMLDig==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJFgoYhpiCcZlRIuHzW96/dHSnO5q+XAhY7rzwf+oC3GUAWnJx
	kgza49DnMIidc31jvPIp4Z5RnQWq3pCHlJjaK//Hxloz4AeNYUQIYlBsoQ9D30I=
X-Gm-Gg: ASbGncs9Dzlgyksqh/SgrtLYHGGPkeyV+TzLBluLQingYdbjESQNk0vQoy+g68rPkh3
	P5NafWNNK5sv03vyuM+Hzd0ZIhlmpA/ZbLEzC51LqfBKaIMnoaz0NBQjF+wN9FzDc0aFGsyLn8v
	fBgVNZwVM1whuQc0RIU9DUa6NvxpWCDkwr4AFQeq/h3afiGJ7JKJVCQ/UpIg3eY1LokLa/MBQL2
	m+c6znMGR85YkOaWbAj5imnreu683Ar1B9Z4+7+nHae4xyUWZWn
X-Google-Smtp-Source: AGHT+IE/Xq/L3NZJczlwQ4pSaUcLJdPCpkw+bO4k0tQkMeu6oZebS/7lMFWakB32yx9P79/WHZSehA==
X-Received: by 2002:a05:6602:4891:b0:847:4fc0:c6c3 with SMTP id ca18e2360f4ac-84ce0125306mr2808888739f.7.1736960856265;
        Wed, 15 Jan 2025 09:07:36 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-84d61fc811esm408728039f.42.2025.01.15.09.07.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 09:07:35 -0800 (PST)
Message-ID: <f86765f7-80ee-4247-ae65-70638366dbb7@kernel.dk>
Date: Wed, 15 Jan 2025 10:07:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: futex+io_uring: futex_q::task can maybe be dangling (but is not
 actually accessed, so it's fine)
To: Thomas Gleixner <tglx@linutronix.de>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>,
 Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
 =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>,
 kernel list <linux-kernel@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
References: <CAG48ez2HHU+vSCcurs5TsFXiEfUhLSXbEzcugBSTBZgBWkzpuA@mail.gmail.com>
 <3b78348b-a804-4072-b088-9519353edb10@kernel.dk>
 <20250113143832.GH5388@noisy.programming.kicks-ass.net> <877c6wcra6.ffs@tglx>
 <30a6d768-b1b8-4adf-8ff0-9f54edde9605@kernel.dk>
 <5603e468-9891-46a3-9ef7-13830cc975e5@kernel.dk> <87msfsatyb.ffs@tglx>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87msfsatyb.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/25 10:05 AM, Thomas Gleixner wrote:
> On Wed, Jan 15 2025 at 08:32, Jens Axboe wrote:
>> Here's the raw patch. Should've done this initially rather than just
>> tackle __futex_queue(), for some reason I thought/assumed that
>> futex_queue() was more widely used.
> 
> 'git grep' is pretty useful to validate such assumptions :)

It would not be a good assumption if it was backed by fact checking ;-)

>> What do you think?
> 
> Looks about right.

OK thanks, fwiw I did send it out as a proper patch as well.

-- 
Jens Axboe


