Return-Path: <io-uring+bounces-8373-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DBEBADB713
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 18:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21EF618840A4
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 16:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7892868AA;
	Mon, 16 Jun 2025 16:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KTcKSmqV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32D81F9F7A
	for <io-uring@vger.kernel.org>; Mon, 16 Jun 2025 16:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750091760; cv=none; b=hR/5KjeMqE6x4wJxu4KpnlJmBRJVvCMnHU1lbOB1qiUcGtzNf3IC0xp9VKmnITb9NT6hO+UpiEob0/DdtWs7n7pvZT051UfJ6dwzPzlV7wnBpa1M39D9k6Kzf8UI0s/iQ0rqeg3sV/JXY4SqbU7IWiaqZtl6G+lSKBePJpI9RHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750091760; c=relaxed/simple;
	bh=PlJutQVv0CC/CeFsaLjKbuHaBPAaX9JwqDzPiUHqoNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JimwYZ6sTG+r9Mg7iui5W729uMnlyQjsc850XV4UnE63y4fXZ0ACKJXemjJXHnhNi+Qt5TFDAKo2CqGh07+JhbjFq1CHn8Ibd9gVOrzWmFgd3VzTpq7SZr1JlYzILAEe4vyCPDgNTagU3tR1vkX14cjN2GrgNEkfPvJIAPy2mCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KTcKSmqV; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d8020ba858so53761555ab.0
        for <io-uring@vger.kernel.org>; Mon, 16 Jun 2025 09:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750091757; x=1750696557; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3dedbl7KF0M309NmbvhdrBdhuZGznIkcgu4Wmdr0qwU=;
        b=KTcKSmqVdb9j6Y7pTJDmGmCA8qVZvwkvixg85t9Kt8QF7emBm2BvNtY/yL1XPSRs8h
         2jEWI0hOfoQoMoqyu9GCtdud8FXDJbwiodXHfqkGJLI8Uj/rN/1FXUGPOFdZ5Rn6qbcv
         8Zd58OcSd37bs/Vlmcn4VwTJMM9mLgbawLlv2QfL1m8OYGH41gikyXuADqLgYAyoJQNU
         ekgiYoiQjh7y6Fx4WmKoIy6nydnVm/WLAKb1dGIM1xuZu2xcAa14Nmnulfe7p8Bk//pl
         cgdvGO69Bptiaefp4l9PdSW9MaLBCCpkFINERvqGuYmj6xQS8I7l0EDnzK6qBCwRZO5q
         n60Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750091757; x=1750696557;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3dedbl7KF0M309NmbvhdrBdhuZGznIkcgu4Wmdr0qwU=;
        b=enLf0LvtaWxYIKj+iV9DhzZKs1xLH5Aosns7I27hP4d1sLvcYdYyRsrcM+EeQXwebb
         +1oAAag9Vu5p1nm4hoHE65ePxWCayOgctuGDiGeWUTJf59y2hV6QaADlWDMZ38O2i8we
         hXqEtnL/2EJpI4eF+9g3np1ay7K1H/s0EU3EHiVoq/CsoCddiVg+UUh43wtkRP8zbB3p
         9y6Xr0S1mgpOzFakWvlEHTwO8a29Wkf6Lvbj0cdx33mCeT0HYP26YJN+dISpojSUk+gk
         cnrtMCimjpKQON2RJN7So1IByRmnZEko8bpzHy6AqZ0JiFe4a2UxG6YivuKo2yj270XS
         oRuA==
X-Gm-Message-State: AOJu0Yz+OtuR1wlHSyYK10sSgbOltFti/HgNWG7newB5rEHqwo8/vmYh
	ay2cwgrZWNS7miSOinv3+pFKzFA/pTJE1gXJvU9k+xToLAWrNsomLD88gIWSfCaJ6aF8MeWXPJr
	ZuQfi
X-Gm-Gg: ASbGnctF9O5+c9gibxLIe3WY+d/MFRf5uFABVcJhYXpWlmBVKjCh6usi9fM1Sgebsxy
	OwdZbxejr8bJsys8CjvsdHLW4cEHii8GoAsoETQjpxYO1zN9MaO3uwbRL0gymcR152Gr/4bWzC4
	oB9pfr/eu/iEnqrkLHUvfrK9qW01JatYhPXqDWB3XEZfOXR5WI1+B0JOWrWBh7/fZinsZ9yH3Wy
	EpxqXzEtQS5vENUGrQNxjYHcEfpPO2v7O0nf2RrUerw7teUJsxn+RZkJCjIXaXQARvh09vut6Ss
	xA43EM4zWAvfMr7SferGdPsmmzK9pWfrujmb695YWPkTgg2eAHrE8OvoExA=
X-Google-Smtp-Source: AGHT+IF/Uk+eQA1bTEeB0Uq7dwQBGeWi1CQE3et9Bbbsir81pkhSeM40zBr87sadSs00JoMXy/g7YQ==
X-Received: by 2002:a05:6e02:310c:b0:3dd:b5fd:aafd with SMTP id e9e14a558f8ab-3de07c53c80mr121510365ab.2.1750091756578;
        Mon, 16 Jun 2025 09:35:56 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50149c85bf7sm1759951173.107.2025.06.16.09.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 09:35:56 -0700 (PDT)
Message-ID: <f5b6a7f1-ecb2-4247-b339-b7a3f51f5216@kernel.dk>
Date: Mon, 16 Jun 2025 10:35:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Building liburing on musl libc gives error that errno.h not found
To: =?UTF-8?Q?Milan_P=2E_Stani=C4=87?= <mps@arvanta.net>
Cc: io-uring@vger.kernel.org
References: <20250615171638.GA11009@m1pro.arvanta.net>
 <b94bfb39-0083-446a-bc76-79b99ea84a4e@kernel.dk>
 <20250615195617.GA15397@m1pro.arvanta.net>
 <1198c63d-4fe8-4dda-ae9f-23a9f5dafd5c@kernel.dk>
 <20250616130612.GA21485@m1pro.arvanta.net>
 <39ae421b-a633-4b47-bf2b-6a55d818aa7c@kernel.dk>
 <20250616141823.GA27374@m1pro.arvanta.net>
 <290bfa14-b595-4fea-b1fe-a3f0881f4220@kernel.dk>
 <a3aaaba3-17d6-4d23-8723-2a25526a4587@kernel.dk>
 <20250616163244.GA16126@m1pro.arvanta.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250616163244.GA16126@m1pro.arvanta.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/16/25 10:32 AM, Milan P. Stani? wrote:
> On Mon, 2025-06-16 at 09:35, Jens Axboe wrote:
>> On 6/16/25 9:13 AM, Jens Axboe wrote:
>>> On 6/16/25 8:18 AM, Milan P. Stani? wrote:
>>>> On Mon, 2025-06-16 at 07:59, Jens Axboe wrote:
>>>>> On 6/16/25 7:06 AM, Milan P. Stani? wrote:
>>>>>> On Mon, 2025-06-16 at 06:34, Jens Axboe wrote:
>>>>>>> On 6/15/25 1:56 PM, Milan P. Stani? wrote:
>>>>>>>> On Sun, 2025-06-15 at 12:57, Jens Axboe wrote:
>>>>>>>>> On 6/15/25 11:16 AM, Milan P. Stani? wrote:
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> Trying to build liburing 2.10 on Alpine Linux with musl libc got error
>>>>>>>>>> that errno.h is not found when building examples/zcrx.c
>>>>>>>>>>
>>>>>>>>>> Temporary I disabled build zcrx.c, merge request with patch for Alpine
>>>>>>>>>> is here:
>>>>>>>>>> https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/84981
>>>>>>>>>> I commented in merge request that error.h is glibc specific.
>>>>>>>>>
>>>>>>>>> I killed it, it's not needed and should've been caught during review.
>>>>>>>>> We should probably have alpine/musl as part of the CI...
>>>>>>>>
>>>>>>>> Fine.
>>>>>>>>
>>>>>>>>>> Side note: running `make runtests` gives 'Tests failed (32)'. Not sure
>>>>>>>>>> should I post full log here.
>>>>>>>>>
>>>>>>>>> Either that or file an issue on GH. Sounds like something is very wrong
>>>>>>>>> on the setup if you get failing tests, test suite should generally
>>>>>>>>> pass on the current kernel, or any -stable kernel.
>>>>>>>>>
>>>>>>>> I'm attaching log here to this mail. Actually it is one bug but repeated
>>>>>>>> in different tests, segfaults
>>>>>>>
>>>>>>> Your kernel is ancient, and that will surely account from some of the
>>>>>>> failures you see. A 6.6 stable series from January 2024 is not current
>>>>>>> by any stretch, should definitely upgrade that. But I don't think this
>>>>>>> accounts for all the failures seen, it's more likely there's some musl
>>>>>>> related issue as well which is affecting some of the tests.
>>>>>>
>>>>>> This happens also on 6.14.8-1 asahi kernel on apple m1pro machine.
>>>>>> I forgot to mention this in previous mail, sorry.
>>>>>
>>>>> Also on musl, correct?
>>>>
>>>> Yes, correct.
>>>>
>>>>> Guessing it must be some musl oddity. I'll try and setup a vm with
>>>>> alpine and see how that goes.
>>>>
>>>> It could be. I can ask on #musl IRC channel on libera.chat
>>>
>>> Probably easier if I just take a look at it, as long as I can get
>>> an alpine vm image going.
>>
>> Pure guesswork, but you are most likely running into default ulimit
>> limits being tiny. Probably something ala:
>>
>> rc_ulimit="-n 524288 -l 262144"
>>
>> in /etc/rc.conf would help.
> 
> Tried, but didn't help.
> 
> I will left it for now and return to test it when new liburing is
> released. It must pass our builders and CI, so I disabled test earlier.
> 
> Thank you for help.

That's fine, I don't recommend distros attempt to verify it by using
the test suite anyway, that's not really its intended purpose. Though it
can be useful in terms of verifying all relevant fixes are backported,
particular if the distro is one of those oddballs that don't base on or
pull in -stable.

I'll be releasing 2.11 shortly, but it likely won't change anything on
your end, outside of having the examples/zcrx compilation fixed.

FWIW, I'm on Alpine Linux 3.22 and it passes here.

-- 
Jens Axboe

