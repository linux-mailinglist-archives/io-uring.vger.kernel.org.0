Return-Path: <io-uring+bounces-4015-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB40F9AF550
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 00:22:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BAC81F23EE7
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 22:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE64215025;
	Thu, 24 Oct 2024 22:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ct4ybd7a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBEE22B66F
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 22:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729808545; cv=none; b=agXvy4MSK0gcr+acXENB2cY6FH30SS1KoSvn3U1JiixWRueSUHG9+OPTYQTZSzTr0PYZwgabHuTd2QZx39h/9ggr0gDH8p+byP+2Zk+CbTl28flOQjZI9tfJ5HHUvM/Y+oNVA2g/SrLfmTmsBynY3qzjxWhw9DW4ZsRjVg9KK5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729808545; c=relaxed/simple;
	bh=zfzw175bTt0Vu4it6W6pjD64S6NtXzbRQa/VOuJ0Zfs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=miNMNC4xnHMyqwRegQ+vfv/jNeQ/jV83mTXKENFMoBS0zrCsbx8wU9U/pgXKze8EUB3ca7SeL+Cz8ANt8u6nw7rbNAiwNlEpK5Rl4gmguubsi1ok1DY5guA8Xf8axvWpwFISy+QcWr01t33tU+n/Mrd0BmYSQetg0srbhUOoazk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ct4ybd7a; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20c803787abso11039245ad.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729808540; x=1730413340; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hq1QW15UA8PcEDvahX2AzvsAU54e2YuL1FlxVrwrSXQ=;
        b=ct4ybd7aQmvPATP928EYJkRLXoJjMR4lkvIgbUA/2IU/pRU07xmnsOWr+XczUM+6yu
         ZwhdzZtSYsKoCe4ueX1SgknxfrSDHf1G0PubbT0MZeXjifHV8UtLEup99GAtm0RSapmj
         PQMsuo0hZPn5QxHroVVktcqC4vDoX8jsowRp7EzTqa/b8+H/0nbypBhoeaYNfxx1bu0l
         jdwxnNZnO8n39vUuSaP9Rh1dDbkkkIOFWcpJl68l8S90meszRDQrX+7UKk+Qdy6nFy6V
         t9yBDowugLZZT1ZewqzZBef8NL1C+LIoBRIn5hv4e8XRiJgX6g53dri7C1KeLWJNwElm
         9zbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729808540; x=1730413340;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hq1QW15UA8PcEDvahX2AzvsAU54e2YuL1FlxVrwrSXQ=;
        b=Jkxqo7DtehvwD0q4a3PtnfvpTzKd2GGXXGndlDUHMeH1GQGwR67O/xaDlJiKCXbjNb
         Wdg0f4V6UzA4LQdNU193ibb9ju4FslbVmR7Pou0gsnuPozbPrzVoih2z2qMPXeQsbQL4
         ZV4Whi4O4hdF7sR+jyw2dDNFN0/qTgSDsmyxxnCvaV+Hk3tNNwh2qL3MDeOAYgWtCzJV
         /JjgNIxZdc2z0kPKfhvdIk2zgUM20JgYftOJ+rBYu4oCqWWVQPiZfid2w5bnD9nAe32Q
         pc+uN5mNkHHKmz+HxTLb4y884MCH/ZrSGTtdE/yB7lWfrPBEAlw+HdJjpWN8R+XQwvll
         UHmg==
X-Forwarded-Encrypted: i=1; AJvYcCUFIZMK7nrgDq7KCdrGoqJVMlF1uioG/jT/ox1K+lEFLbgtqwO5SIP7gKjXHqide/tPcWqdDkyBmg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxBE0kqF2MUq0NPPqVyf2tCInscFXHJVCZ/mxaY6sSWwoxzNtx
	hL0RPAcANKP/MRh5eWtIFYhoYWZBMgnG4huA2gPXDDbitJoF9XFneSHePJw6Gh85JUZGXlczDnl
	k
X-Google-Smtp-Source: AGHT+IF6cV2kihvKqGbArPP0OCDmqDvezYSIV79ThAd3Mwq1lgzQAKNkN+wYNQe2hl4ZGgSU4estLA==
X-Received: by 2002:a17:902:dacf:b0:20c:8f98:5dbb with SMTP id d9443c01a7336-20fb896511cmr49868555ad.16.1729808539992;
        Thu, 24 Oct 2024 15:22:19 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7eee6538sm76849985ad.47.2024.10.24.15.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 15:22:19 -0700 (PDT)
Message-ID: <ce033359-a17a-4303-bd57-0ad66b5138fc@kernel.dk>
Date: Thu, 24 Oct 2024 16:22:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] implement vectored registered buffers for sendzc
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1729650350.git.asml.silence@gmail.com>
 <b15e136f-3dbd-4d4e-92c5-103ecffe3965@kernel.dk>
 <bfbe577b-1092-47a2-ab6c-d358f55003dc@gmail.com>
 <28964ec6-34a7-49b8-88f5-7aaf0e1e4e3f@kernel.dk>
 <3e28f0bb-4739-40de-93c7-9b207d90d7c5@gmail.com>
 <3e6c3ff5-9116-4d50-9fa8-aae85ad24abc@kernel.dk>
 <3376be3e-e5c4-4fbb-95bb-b3bcd0e9bd8b@gmail.com>
 <67f9a2b9-f2bd-4abd-a4a5-c1c5e8beda61@kernel.dk>
 <d8da2a22-948b-4837-a69a-e9e91e37feec@gmail.com>
 <daeacc90-e5b4-471d-a79e-74ae10eb4aba@kernel.dk>
 <4f38ca15-a341-4d93-80eb-18f79fdd6664@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4f38ca15-a341-4d93-80eb-18f79fdd6664@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 4:14 PM, Pavel Begunkov wrote:
> On 10/24/24 20:56, Jens Axboe wrote:
>> On 10/24/24 12:13 PM, Pavel Begunkov wrote:
>>> On 10/24/24 19:00, Jens Axboe wrote:
>>>> On 10/24/24 11:56 AM, Pavel Begunkov wrote:
>>>>> On 10/24/24 18:19, Jens Axboe wrote:
>>>>>> On 10/24/24 10:06 AM, Pavel Begunkov wrote:
>>>>>>> On 10/24/24 16:45, Jens Axboe wrote:
>>> ...>>>> Seems like you're agreeing but then stating the opposite, there
>>>>>>> is some confusion. I'm saying that IMHO the right API wise way
>>>>>>> is resolving an imu at issue time, just like it's done for fixed
>>>>>>> files, and what your recent series did for send zc.
>>>>>>
>>>>>> Yeah early morning confusion I guess. And I do agree in principle,
>>>>>> though for registered buffers, those have to be registered upfront
>>>>>> anyway, so no confusion possible with prep vs issue there. For provided
>>>>>> buffers, it only matters for the legacy ones, which generally should not
>>>>>> be used. Doesn't change the fact that you're technically correct, the
>>>>>> right time to resolve them would be at issue time.
>>>>>
>>>>> I'm talking about sendmsg with iovec. Registered buffers should
>>>>> be registered upfront, that's right, but iovec should be copied
>>>>> at prep, and finally resolved into bvecs incl the imu/buffer lookup
>>>>> at the issue time. And those are two different points in time,
>>>>> maybe because of links, draining or anything else. And if they
>>>>> should be at different moments, there is no way to do it while
>>>>> copying iovec.
>>>>
>>>> Oh I totally follow, the incremental approach would only work if it can
>>>> be done at prep time. If at issue time, then it has to turn an existing
>>>> iovec array into the appropriate bvec array. And that's where you'd have
>>>> to do some clever bits to avoid holding both a full bvec and iovec array
>>>> in memory, which would be pretty wasteful/inefficient. If done at issue
>>>
>>> Why would it be wasteful and inefficient? No more than jumping
>>> though that incremental infra for each chunk, doubling the size
>>> of the array / reallocating / memcpy'ing it, instead of a tight
>>> loop doing the entire conversion.
>>
>> Because it would prevent doing an iovec at-the-time import, then turning
>> it into the desired bvec. That's one loop instead of two. You would have
>> the space upfront, there should be no need to realloc+memcpy. And then
>> there's the space concern, where the initial import is an iovec, and
>> then you need a bvec. For 64-bit that's fine as they take up the same
>> amount of space,
> 
> That's not true, each iov can produce multiple bvec entries so
> iovs might get overwritten if you do it the simplest way.

What part isn't true? Yeah one iovec can turn into multiple bvec
segments, the provided send zc stuff I sent does deal with that. So yeah
it's not necessarily a 1:1 mapping, and even if they have the same size,
you may need more elements on the bvec size.

Doesn't change the fact that you can loop once and do it. If you need to
expand the bvec size, that would be a realloc+copy. But that part is
true even if you first import all iovecs, and then iterate them to map
the bvecs. Unless you do some upfront tracking to know how many elements
you need, but that would seem overly convoluted. With caching, the
expansion should be a rare occurence outside of the initial import into
a new region.

>> but for 32-bit it'd make incremental importing from a
>> stable iovec to a bvec array a bit more tricky (and would need realloc,
>> unless you over-alloc'ed for the iovec array upfront).
> 
> And that's not true, you can still well do it in place if
> iovec is placed right in the memory, which I explicitly
> noted there are simple enough ways to do it in place
> without extra reallocs.

I don't think anything stated there is untrue, just saying it's a bit
more tricky. Which is certainly true, if it's the same memory region and
there's overlaps. But let's just see the code for it, much easier to
discuss over those parts rather than pontificate hypotheticals :-)

-- 
Jens Axboe

