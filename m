Return-Path: <io-uring+bounces-10119-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46991BFD6CE
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:00:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B609818923B8
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CCD1F63D9;
	Wed, 22 Oct 2025 17:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hGf/b6wu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E34A269B1C
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761152423; cv=none; b=JznqeGGgeHvHR4eRxyfGbFEEdHFue4EdlIhJYVGj7CKWLFTJdfqkLKHMomcThvM9cWDImVRAv9BqyPni4Af1dI2Iv3opusuSoK8SFMBXBPq9b7p6i0uHPp+kW3QFHvqBzW6mHFKwc2QWurOAY2zR/y7otvvR1I1Z8qvjMC+FTXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761152423; c=relaxed/simple;
	bh=jEIK/MnFGgvkU2jSoBVRXZVtORuZhZu66mF1C8+cc1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nNBuAOkx1GHBXMO43ncJi5X2t4ELFmCvcmQRe7URFN1ULH6VgXDNmYnL8aOOt2AEG5TAs4D5DdVQp2CxhHg2eQXlVSbrsE7+AKz6yG8cLd/0Z5qUN+8qQSkxikN80zVF40dbMHa9cJxwudL7rZtJERm2+JmeXz1UFnkDTqU7hm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hGf/b6wu; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3ecde0be34eso787137f8f.1
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761152419; x=1761757219; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DmMvg3UcZfyV6BSGB2AmIHcJ7yJomZZTxM0vi/9tarU=;
        b=hGf/b6wuq1w0zN87xVcaPsBNJ8D7KrdU3L3ilTOFgFuBEVDt8jGhDSQNFu5d+CIBzP
         8rLDuvcQp6FU2XjWpR3Jb9j48ClbfbSmwULdf/IrSEaUHO8ymLDC2MrBmmlP0NFrS5TO
         sXGLNG/8LNJLxgXCN8ltU8MiU9NBDEfuCkUUj4hmkCfDHfdtO1ilvupOV5rnr5zEOwUI
         Glcomfrc/7TvVr5uK9ictSS2UkEpsJ0Z4C3yUVgzKjLHlWMr7Bv81dgnzri72lrjKWTy
         7uKVg3ujsfpiH+fuG5po5PN5jzWVYFnLncS7dtqZOAXJ7fM3tCXbDedgtmEwm2y1rO32
         0sqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761152419; x=1761757219;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DmMvg3UcZfyV6BSGB2AmIHcJ7yJomZZTxM0vi/9tarU=;
        b=VfrLjjVgbvgoOKexmR3UkMjhJHi3HLqdfA2uny7yrs7H9RtNq9OeBZxSsYQPD5PNGP
         +yPmn6Fbhy+HIJFmSfwoEFjQucn1U4Uj/JkT8Em804TC7eSB0i2H/v04QR6ppOnNjPm8
         Gu+rYGWdaYZGJ4VIVVO9uOkTwHBf0ETypKKVA2hwysklCO1uBHE9bOrxap7B7oXu9s/4
         nNqjH2yh78bvt7+JaMKk6d0d6WL59GUbOV7usbYFp0OwvCO90EwRD/71VQOCHOdMxwil
         ISLm2NHu1/LS0gh4auGZfQ+Kw9znHMviq7dJTdXd1Q1DMvZowcQVmS1pQNkbCpE9zRk3
         P6iw==
X-Forwarded-Encrypted: i=1; AJvYcCX71PKeDlEQTvJBGFTtdfg9pRN7UfJmuASrMsICBgZmZvWIzxprrH0Yo5AuZDL1D4QGX9j7KBvq7g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWygSSo/BYS1mUNdxLWQSB6VdGsB+332Mw+zzP+TOoH2f8KlT7
	2sVFM3yuIhHmcvTa3ELtH3yx5Tf2pFdJ1LVH037oQOpKby4PCYczTBfp
X-Gm-Gg: ASbGncv3hTZ1eweYeaKo4nyiLhSjmoBJV9wzgdYt/pTrhFKMPYRS3LPIWt75xjW1nr2
	dnERS8MfQakArZKIACxZG+l6/X5wvOvbWi9S4qrVKHa8bGFH5WD9Wv4B3AhXzv8wmfPRv5BiJa1
	PVDXCC3F/YS2nsS3Wk2O21BgE13evGLfxAStVEBF2xyR84WUVYFGNNY29NhFYuQj5diJnsy84qc
	7WqwT0bKqJ1Y9zNwmrZ0z0bRq6kEyv3gP1NXUq0hKOXMyqKckEaDOEAM+rBc+JQcc0zNDAtDTU7
	8Xx6QTn15wPwfI7waPzWDINLfmfrmqTD7cQMddTiJ4CXuSdH/V6O3ZxzL84Q0fMuyFY1dvV8d/N
	HviHWLJMm5PVmToK+pKj67qfP34ZnW3s/r3a03NmyVf0ichJIrf+lOY9zeFBQpCmKOSaHP/zL08
	U7k8iEhz6MJuUE2AROJ+DGFUS6zqEJT+tKQ08ysAFSwxE=
X-Google-Smtp-Source: AGHT+IEMXPTtbN3fcgfvF2OXh/lo9HWBSKGGaPfgEOyBk8teyMLT7+VrOSifMFf/Ae1v5WbO89iFqw==
X-Received: by 2002:a05:6000:22c5:b0:427:401:197e with SMTP id ffacd0b85a97d-42856a82823mr1703265f8f.25.1761152419203;
        Wed, 22 Oct 2025 10:00:19 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:b576])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c438caeesm50619835e9.18.2025.10.22.10.00.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 10:00:17 -0700 (PDT)
Message-ID: <20f8d441-914d-48b9-85d4-c1891f44d20f@gmail.com>
Date: Wed, 22 Oct 2025 18:01:42 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring zcrx: add MAINTAINERS entry
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Mina Almasry <almasrymina@google.com>
References: <20251021202944.3877502-1-dw@davidwei.uk>
 <60d18b98-6a25-4db7-a4c6-0c86d6c4f787@gmail.com>
 <832b03de-6b59-4a07-b7ea-51492c4cca7e@kernel.dk>
 <3990f8ee-4194-4b06-820e-c0ecbcb08af1@gmail.com>
 <8486dc74-44a3-4972-9713-2e24cefced22@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8486dc74-44a3-4972-9713-2e24cefced22@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/25 15:34, Jens Axboe wrote:
> On 10/22/25 8:25 AM, Pavel Begunkov wrote:
>> On 10/22/25 14:17, Jens Axboe wrote:
>>> On 10/22/25 5:38 AM, Pavel Begunkov wrote:
>>>> On 10/21/25 21:29, David Wei wrote:
>>>>> Same as [1] but also with netdev@ as an additional mailing list.
>>>>> io_uring zero copy receive is of particular interest to netdev
>>>>> participants too, given its tight integration to netdev core.
>>>>
>>>> David, I can guess why you sent it, but it doesn't address the bigger
>>>> problem on the networking side. Specifically, why patches were blocked
>>>> due to a rule that had not been voiced before and remained blocked even
>>>> after pointing this out? And why accusations against me with the same
>>>> circumstances, which I equate to defamation, were left as is without
>>>> any retraction? To avoid miscommunication, those are questions to Jakub
>>>> and specifically about the v3 of the large buffer patchset without
>>>> starting a discussion here on later revisions.
>>>>
>>>> Without that cleared, considering that compliance with the new rule
>>>> was tried and lead to no results, this behaviour can only be accounted
>>>> to malice, and it's hard to see what cooperation is there to be had as
>>>> there is no indication Jakub is going to stop maliciously blocking
>>>> my work.
>>>
>>> The netdev side has been pretty explicit on wanting a MAINTAINERS entry
>>
>> Can you point out where that was requested dated before the series in
>> question? Because as far as I know, only CC'ing was mentioned and
>> only as a question, for which I proposed a fairly standard way of
>> dealing with it by introducing API and agreeing on any changes to that,
>> and got no reply. Even then, I was CC'ing netdev for changes that might
>> be interesting to netdev, that includes the blocked series.
> 
> Not interested in digging out those other discussions, but Mina had a
> patch back in August, and there was the previous discussion on the big

If August, I'm pretty sure you're referring to one of the
replies / follow ups after the mentioned series.

> patchset. At least I very much understood it as netdev wanting to be
> CC'ed, and the straight forward way to always have that is to make it
> explicit in MAINTAINERS.
> 
>>> so that they see changes. I don't think it's unreasonable to have that,
>>> and it doesn't mean that they need to ack things that are specific to
>>> zcrx. Nobody looks at all the various random lists, giving them easier
>>> insight is a good thing imho. I think we all agree on that.
>>>
>>> Absent that change, it's also not unreasonable for that side to drag
>>> their feet a bit on further changes. Could the communication have been
>>> better on that side? Certainly yes. But it's hard to blame them too much
>>> on that front, as any response would have predictably yielded an
>>> accusatory reply back.
>>
>> Not really, solely depends on the reply.
> 
> Well, statistically based on recent and earlier replies in those
> threads, if I was on that side, I'd say that would be a fair assumption.
> 
>>> And honestly, nobody wants to deal with that, if
>>
>> Understandable, but you're making it sound like I started by
>> throwing accusations and not the other way around. But it's
>> true that I never wanted to deal with it.
> 
> Honestly I don't even know where this all started, but it hasn't been
> going swimmingly the last few months would be my assessment.
> 
> My proposal is to put all of this behind us and move forward in a
> productive manner. There's absolutely nothing to be gained from
> continuing down the existing path of arguing about who did what and why,
> and frankly I have zero inclination to participate in that. It should be
> in everybody's best interest to move forward, productively. And if that
> starts with a simple MAINTAINERS entry, that seems like a good place to
> start. So _please_, can we do that?

I'm convinced it's not going to help with the work being
blocked or the aforementioned issues, but ok, let's have it
your way.

-- 
Pavel Begunkov


