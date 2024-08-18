Return-Path: <io-uring+bounces-2822-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F22955A95
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 04:27:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DF771F216D2
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 02:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 187F74414;
	Sun, 18 Aug 2024 02:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gEQ/MSAr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9C51FB4
	for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 02:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723948030; cv=none; b=g8OkFlv2Ayal8vyJYShgCoOXY35plFeuWxJFi/f7qFdjwCweHIMu/Yv7yMXP0yGYgK1ffJm/zgQAqexB9rfjfGIdbUq09N4A/VOiCSlaKNXdPAcJJIkLoyktZjQSjbh82+eLACNdV+F5qtuwJ2CAzo8GNz/1N6NfjWlVYWUXvnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723948030; c=relaxed/simple;
	bh=i1rGG+yik6sBkWeptWTURCluR3FmCSRAySrA0AA3JIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ix4fas97S825COECBOxdRDuZmmiZ5/rznx5r1CYrlD9CTFBQKrgEKP3GLCPTUfSS3JX1ijsPrOZntS0LuUBLQFmlEDhaBcKQWGDTf0/JYQIIz6bA3ldmFFp8YIwravw5vrGkXMtKLwiloo0KPXKvhSV58vBRXkmsnfi/xbbXra0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gEQ/MSAr; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a77ec5d3b0dso360985166b.0
        for <io-uring@vger.kernel.org>; Sat, 17 Aug 2024 19:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723948026; x=1724552826; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xXhj+pDQvf9/CDiSwe/xz3wDIOPgBq+6TquvF1qG/VM=;
        b=gEQ/MSArsgu05HIa+pTFwUfLv2tZazFSLE8wQ683dqhN3CwKa52UrQrC6PAR6qSFYc
         uUqnX316ZY33fhv173jzUD+g7REIimPq8LyB8t6MlWApGg5DzM76DGWpIzkk15FQpmX+
         gtFgA+LgBfx9iVlKZXWVVMiEeH08JLWmdKEvHnNVQN0ywBmKxzs2BYRf6bV9oaz2FvpG
         2p2mhl0VTRt2Zyb1bH3RlY2GeS3I6MKrvQA9dm+PovgL+ycf5Aj9uMEWUzQCzHi5jSqt
         o0qO6ZvE/3rH5RL1u+U6OtqnIUe/VvgaAMeQ4UZaMNyYz6gDLh2bvD74W4o6eh8prBal
         8Ogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723948026; x=1724552826;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xXhj+pDQvf9/CDiSwe/xz3wDIOPgBq+6TquvF1qG/VM=;
        b=sOOhQBDRflLkWkOg2gl57dkKlsCjZQhypwbGFRv8xSxaeyC19Ld/JDqZWImf8/5KBg
         V+N/5v5qkMu6/5HM6GgH17636aKMn34SM0CqFeVsyKAFlfzAUumYRAEaNrfLpvP9SBll
         K2dIbWS9c7/Oil/oVvPOjDDIiKWivzyEnip/WAlHpS1+pNcrCOBkVvtD7TWIyAX3lYqo
         E0CCiMp4v4aed9bqY9ldWbSqhg8kmk7U7bUUwn7W7l+j27IqCoJnEDVm2U5AEJ/jLXbr
         xQTWT6gH/jy8J8s+YQeyV7mZUFEAn4eK5lDWniwlF/Z8Ui3oW+nfUENoMsMoAUv3N+Es
         g1DQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnV7s0TzGvDhb7ew1shCZzcI7YDrRYLX2wsvi3Kt0agVNWTmCTaQXGUujubAdqN0OFlYf3/i0okxiRUK0KACUYl4OmgjttIRA=
X-Gm-Message-State: AOJu0YyBGCDBsZGnSfunB4wooS5IbQL3HIlJCCXUMayRT6NlubmxgIRq
	G0hxlOYVD1QG9s/iszctwftDUvKZxP6uitbZRTyptYvkTP37ervM
X-Google-Smtp-Source: AGHT+IGIV7XihBS/1PUmr3IW8I0CwBBwbAtGbpPgfJM3k5BkQhyzS53NWUA6FoHWD+ll4sroEz0EjA==
X-Received: by 2002:a17:907:f16a:b0:a7a:bd5a:1ec0 with SMTP id a640c23a62f3a-a8392953529mr460879766b.29.1723948026050;
        Sat, 17 Aug 2024 19:27:06 -0700 (PDT)
Received: from [192.168.42.178] ([185.69.144.74])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838cf052sm467219066b.46.2024.08.17.19.27.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Aug 2024 19:27:05 -0700 (PDT)
Message-ID: <d132af13-0460-4280-b762-72fb19ccccfa@gmail.com>
Date: Sun, 18 Aug 2024 03:27:38 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: add IORING_ENTER_NO_IOWAIT to not set
 in_iowait
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20240816223640.1140763-1-dw@davidwei.uk>
 <ab4252f1-90e3-4abf-b4fb-0b318edc05bd@gmail.com>
 <03d825b1-187b-432c-bff4-f28d96e3164e@kernel.dk>
 <d9d11df4-2a1b-4648-a0f1-d2fb9e76c868@gmail.com>
 <e623a08d-2740-4e09-900b-dda5f1c38daf@kernel.dk>
 <4a5bb60a-2b53-4f76-b912-08841aceae1e@gmail.com>
 <f7b2c2e2-7362-4ef4-92b6-be186ccd35d4@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f7b2c2e2-7362-4ef4-92b6-be186ccd35d4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/24 02:08, Jens Axboe wrote:
> On 8/17/24 4:04 PM, Pavel Begunkov wrote:
>> On 8/17/24 22:09, Jens Axboe wrote:
>>> On 8/17/24 3:05 PM, Pavel Begunkov wrote:
>>>> On 8/17/24 21:20, Jens Axboe wrote:
>>>>> On 8/17/24 1:44 PM, Pavel Begunkov wrote:
>>>>>>> This patchset adds a IOURING_ENTER_NO_IOWAIT flag that can be set on
>>>>>>> enter. If set, then current->in_iowait is not set. By default this flag
...
>> And that "use case" for iowait directly linked to cpufreq, so
>> if it still counts, then we shouldn't be separating stats from
>> cpufreq at all.
> 
> This is what the cpufreq people want to do anyway, so it'll probably
> happen whether we like it or not.

Not against it, quite the opposite


>>> case, yet I think we should cater to it as it very well could be legit,
>>> just in the tiny minority of cases.
>>
>> I explained why it's a confusing feature. We can make up some niche
>> case (with enough of imagination we can justify basically anything),
>> but I explained why IMHO accounting flag (let's forget about
>> cpufreq) would have net negative effect. A sysctl knob would be
>> much more reasonable, but I don't think it's needed at all.
> 
> The main thing for me is policy vs flexibility. The fact that boost and
> iowait accounting is currently tied together is pretty ugly and will
> hopefully go away with my patches.
> 
>>>>> It's really simple for this stuff - the freq boost is useful (and
>>>>> needed) for some workloads, and the iowait accounting is never useful
>>>>> for anything but (currently) comes as an unfortunate side effect of the
>>>>> former. But even with those two separated, there are still going to be
>>>>> cases where you want to control when it happens.
>>>>
>>>> You can imagine such cases, but in reality I doubt it. If we
>>>> disable the stat part, nobody would notice as nobody cared for
>>>> last 3-4 years before in_iowait was added.
>>>
>>> That would be ideal. You're saying Jamal's complaint was purely iowait
>>> based? Because it looked like power concerns to me... If it's just
>>> iowait, then they just need to stop looking at that, that's pretty
>>> simple.
>>
>> Power consumption, and then, in search of what's wrong, it was
>> correlated to high iowait as well as difference in C state stats.
> 
> But this means that it was indeed power consumption, and iowait was just
> the canary in the coal mine that lead them down the right path.
> 
> And this in turn means that even with the split, we want to
> differentiate between short/busty sleeps and longer ones.

That's what I've been talking about since a couple of months ago,
for networking we have a well measured energy consumption
regression because of iowait, not like we can just leave it as
it is now. And For the lack of a good way to auto tune in the
kernel, an enter flag (described as a performance feature) looks
good, I agree.

...
>>>
>>>> The name might also be confusing. We need an explanation when
>>>> it could be useful, and name it accordingly. DEEP/SHALLOW_WAIT?
>>>> Do you remember how cpufreq accounts for it?
>>>
>>> I don't remember how it accounts for it, and was just pondering that
>>> with the above reply. Because if it just decays the sleep state, then
>>> you could just use it generically. If it stays high regardless of how
>>> long you wait, then it could be a power issue. Not on servers really
>>> (well a bit, depending on boosting), but more so on desktop apps.
>>> Laptops tend to be pretty power conservative!
>>
>> {SHORT,BRIEF}/LONG_WAIT maybe?
> 
> I think that's a lot more descriptive. Ideally we'd want to tie this to
> wakeup latencies, eg we'd need to know about wakeup latencies. For
> example, if the user asks for a 100 usec wait, we'd want to influence
> what sleep state is picked in propagating that information. Things like
> the min-wait I posted would directly work for that, as it tells the
> story in two chapters on what waits we're expecting here. Currently
> there's no way to do that (hence iowait -> cpufreq boosting), but there
> clearly should be. Or even without min-wait, the timeout is clearly
> known here, combined with the expected/desired number of events the
> application is looking for.

Yeah, interesting, we can auto apply it depending on the delta
time, etc. Might worth to ask the cpufreq guys about thresholds.

-- 
Pavel Begunkov

