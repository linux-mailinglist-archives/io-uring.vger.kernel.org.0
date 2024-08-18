Return-Path: <io-uring+bounces-2821-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB480955A82
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 03:08:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A30DA281308
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 01:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D3E1C2E;
	Sun, 18 Aug 2024 01:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="L0AB6ub7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11D538B
	for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 01:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723943330; cv=none; b=PShVqergli4EAQ2X5qakueM9O8vkQ0RtgF1FKXpYb/8tmm2o/h3ir0qLxTip9ZFIKaEeS03rESWp5KT8GirH6OqNhQ/UlCBTy3g685o6np1Jh89WmrZP6v+ZTPb6F5tYMoq8aGp2Z1ECcd6TutaiTmKcW8gm1Mqcm2R/YVuL/bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723943330; c=relaxed/simple;
	bh=1UI6HVTgaJ+oRbcISjxlxABH9/5IJn/m/w+r/1S/Kmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=njrkKIpUn/3SsTtM39ICw3X1cVPPArTr9Ut7bIOkCU5I1vzIqa1HMnd8cL6McVaN7Ym6/EZUhGBJGT/Kwk+lrTPmWArTt3WkP/xwnL39tPjLgwyvXsPJP6xba50WVlt1IWcFVQNksMgsqsrwNg6CLL7fevveADQ5n9rUxWdzRUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=L0AB6ub7; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2cdba9c71ebso495807a91.2
        for <io-uring@vger.kernel.org>; Sat, 17 Aug 2024 18:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723943326; x=1724548126; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Pqil7nWGzKgSVvnaTpJ8auzhfT/fhro9bspcuvI4a7w=;
        b=L0AB6ub7U50tTx2ueNhKjaEQAjsgoxajBRFJDMecY6gKLX2a0hXOBmap7a5gevQLRS
         b9FKH8Vj+5WwTwLka7hxBTBm4zwiA1jDVR3DpYUAX5azgbuLmQL73EHj+/v092FfThsk
         49K1CYHFVklOKXBL7lYJtIvvbzDBRu2CJuVGUHS6NEQ3G9GrnXBmmbJ10mINEivgQP+D
         fivdvavwS6HXW7A4EOqW9jKFESkbK09rHetrYJL9C2psOEDAcyy6ZP5J7HgiyTNlUOVh
         CgiFEVqUXs1WYQWyr+UtICBgXjfYEOfhpEruVlm6h1QexccskkdsWQJiEv9+eGq1F80f
         x1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723943326; x=1724548126;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pqil7nWGzKgSVvnaTpJ8auzhfT/fhro9bspcuvI4a7w=;
        b=CqZp7tVOMkv3fgH8wZ6hb4qVbjE/0l7CcXmEOB2GhtQLfiyrXp/S/kEpuHdQPMv3JQ
         id7T3v6jJIhglUyy/1eaqooFnCQhq+jpIKg33MalUm5OHJCRVmjS3QQMtDqXABvttvjT
         +96GdpdJZzuHP4GeOBt9LMTze545xkG/Cvh6+2Se4k/c5BUvEFssug+3eJlgxrjQ5Af/
         vGUUh6NC00SS5HjVWlKTaaWrTfk0D9kvJVrPxL0/Cwefdv7DZ1hvl5hheg4nG3oL3T7x
         E+W4d6PrmG9CMXVmF2rvVq1xeIfryyK/G8VtXwIOkHnU1wo2MBcbORcv6/FW0/zWmMcv
         a5QQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmovlK79+aVj/he/o/KeXra7ajimlEy0R/UYytWzd6GTT+f4ym8O1bvZTSSuQv+mrAeW6f8bFsvehixLdzEA0gRyOuzwJvEtE=
X-Gm-Message-State: AOJu0YzqJ2XX6H1cisVOSGyUCJRCZu8FN8oT8fYYzfL3NHI481apjk2V
	lelbM2vUfIZHayGMV6In9wb0AEqQ5rkEACMLm//Hd1ojQYSW5fAcsloK4yvKkxD1irhtZhzBfAW
	0
X-Google-Smtp-Source: AGHT+IH+82gOqy3Fnv4uBzh+TeqrwTnANANxO4f6whU/IEYhJd7riCjZH71ocaGggpdv4jP6OxYL2A==
X-Received: by 2002:a17:90b:1bc2:b0:2c9:36d3:8934 with SMTP id 98e67ed59e1d1-2d3dfc6f340mr4946683a91.1.1723943325928;
        Sat, 17 Aug 2024 18:08:45 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3e3c80f1bsm4536469a91.43.2024.08.17.18.08.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Aug 2024 18:08:45 -0700 (PDT)
Message-ID: <f7b2c2e2-7362-4ef4-92b6-be186ccd35d4@kernel.dk>
Date: Sat, 17 Aug 2024 19:08:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: add IORING_ENTER_NO_IOWAIT to not set
 in_iowait
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20240816223640.1140763-1-dw@davidwei.uk>
 <ab4252f1-90e3-4abf-b4fb-0b318edc05bd@gmail.com>
 <03d825b1-187b-432c-bff4-f28d96e3164e@kernel.dk>
 <d9d11df4-2a1b-4648-a0f1-d2fb9e76c868@gmail.com>
 <e623a08d-2740-4e09-900b-dda5f1c38daf@kernel.dk>
 <4a5bb60a-2b53-4f76-b912-08841aceae1e@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4a5bb60a-2b53-4f76-b912-08841aceae1e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/17/24 4:04 PM, Pavel Begunkov wrote:
> On 8/17/24 22:09, Jens Axboe wrote:
>> On 8/17/24 3:05 PM, Pavel Begunkov wrote:
>>> On 8/17/24 21:20, Jens Axboe wrote:
>>>> On 8/17/24 1:44 PM, Pavel Begunkov wrote:
>>>>>> This patchset adds a IOURING_ENTER_NO_IOWAIT flag that can be set on
>>>>>> enter. If set, then current->in_iowait is not set. By default this flag
>>>>>
>>>>> A worthwhile change but for _completely_ different reasons. So, first,
>>>>> it's v3, not v2, considering the patchset from a couple month ago. And
>>>>> since in essence nothing has changed, I can only repeat same points I
>>>>> made back then.
>>>>>
>>>>> The description reads like the flag's purpose is to change accounting,
>>>>> and I'm vividly oppose any user exposed (per ring) toggle doing that.
>>>>> We don't want the overhead, it's a very confusing feature, and not even
>>>>
>>>> Come on, there's no overhead associated with this, in practice.
>>>
>>> Minor, right, ~ 1 "if" or ccmov, but that's for a feature that nobody
>>> really cares about and arguably even harmful. That's assuming there
>>> will be another flag for performance tuning in the future, at least
>>> the description reads like that.
>>
>> You literally brought up the case where people care yourself in the
>> reply, the one from Jamal. And the one I said is probably not the common
> 
> Not really. Yes, by chance high iowait helped to narrow it to the
> in_iowait io_uring patch, but that's rather a weird side effect,
> not what iowait was "created for", i.e. system is idling because
> storage waiting takes too long.

It's definitely a smoking gun, if you're already looking for that. But
the main question remains - was this an actual power issue or not?
Because the answer to that is pretty key imho.

> And that "use case" for iowait directly linked to cpufreq, so
> if it still counts, then we shouldn't be separating stats from
> cpufreq at all.

This is what the cpufreq people want to do anyway, so it'll probably
happen whether we like it or not.

>> case, yet I think we should cater to it as it very well could be legit,
>> just in the tiny minority of cases.
> 
> I explained why it's a confusing feature. We can make up some niche
> case (with enough of imagination we can justify basically anything),
> but I explained why IMHO accounting flag (let's forget about
> cpufreq) would have net negative effect. A sysctl knob would be
> much more reasonable, but I don't think it's needed at all.

The main thing for me is policy vs flexibility. The fact that boost and
iowait accounting is currently tied together is pretty ugly and will
hopefully go away with my patches.

>>>> It's really simple for this stuff - the freq boost is useful (and
>>>> needed) for some workloads, and the iowait accounting is never useful
>>>> for anything but (currently) comes as an unfortunate side effect of the
>>>> former. But even with those two separated, there are still going to be
>>>> cases where you want to control when it happens.
>>>
>>> You can imagine such cases, but in reality I doubt it. If we
>>> disable the stat part, nobody would notice as nobody cared for
>>> last 3-4 years before in_iowait was added.
>>
>> That would be ideal. You're saying Jamal's complaint was purely iowait
>> based? Because it looked like power concerns to me... If it's just
>> iowait, then they just need to stop looking at that, that's pretty
>> simple.
> 
> Power consumption, and then, in search of what's wrong, it was
> correlated to high iowait as well as difference in C state stats.

But this means that it was indeed power consumption, and iowait was just
the canary in the coal mine that lead them down the right path.

And this in turn means that even with the split, we want to
differentiate between short/busty sleeps and longer ones.

>>>>> that helpful. iowait is monitored not by the app itself but by someone
>>>>> else outside, likely by a different person, and even before trying to
>>>>> make sense of numbers the monitor would need to learn first whether
>>>>> _any_ program uses io_uring and what flags the application writer
>>>>> decided to pass, even more fun when io_uring is used via a 3rd party
>>>>> library.
>>>>>
>>>>> Exactly same patches could make sense if you flip the description
>>>>> and say "in_iowait is good for perfomance in some cases but
>>>>> degrades power consumption for others, so here is a way to tune
>>>>> performance", (just take Jamal's numbers). And that would need to
>>>>> clearly state (including man) that the iowait statistic is a side
>>>>> effect of it, we don't give it a thought, and the time accounting
>>>>> aspect may and hopefully will change in the future.
>>>>
>>>> Don't disagree with that, the boosting is the primary function here,
>>>> iowait accounting is just an odd relic and side effect.
>>>>
>>>>> Jens, can you remind what happened with separating iowait stats
>>>>> vs the optimisation? I believed you sent some patches
>>>>
>>>> Yep I still have them, and I'll dust them off and resend them. But it
>>>> doesn't really change the need for this at all, other than perhaps
>>>> wanting to rename the actual flag as it would not be about iowait at
>>>> all, it'd just be about power consumption.
>>>>
>>>> Last cut was here:
>>>>
>>>> https://git.kernel.dk/cgit/linux/log/?h=iowait.2
>>>>
>>>> just need simple rebasing.
>>>
>>> IMHO we should try to merge it first. And if there would be
>>> some friction, we can get back and take this patch, with
>>> additional note describing about iowait stat side effects.
>>
>> I did just rebase on top of sched/core and sent out a new version. I
>> still think it makes sense regardless of this patch or not, only
>> difference would be what you call the flag.
> 
> There shouldn't be any difference in how it's called or how
> it's recommended to be used, but maybe I don't understand
> what you mean. As I see it, the difference in a blob of
> text in the man mentioning the iowait stat side effect.

See above.

>> It's here:
>>
>> https://lore.kernel.org/lkml/20240817204639.132794-1-axboe@kernel.dk/T/#mab3638659a54193927351ebdc5e345278637bc41
> 
> Perfect
> 
> 
>>>>>> is not set to maintain existing behaviour i.e. in_iowait is always set.
>>>>>> This is to prevent waiting for completions being accounted as CPU
>>>>>> utilisation.
>>>>>
>>>>> For accounting, it's more reasonable to keep it disabled by
>>>>> default, so we stop getting millions complaints per day about
>>>>> high iowait.
>>>>
>>>> Agree, it should just go away.
>>>>
>>>>>> Not setting in_iowait does mean that we also lose cpufreq optimisations
>>>>>> above because in_iowait semantics couples 1 and 2 together. Eventually
>>>>>> we will untangle the two so the optimisations can be enabled
>>>>>> independently of the accounting.
>>>>>>
>>>>>> IORING_FEAT_IOWAIT_TOGGLE is returned in io_uring_create() to indicate
>>>>>> support. This will be used by liburing to check for this feature.
>>>>>> Signed-off-by: David Wei <dw@davidwei.uk>
>>>>>> ---
>>>>>> v2:
>>>>>>     - squash patches into one
>>>>>>     - move no_iowait in struct io_wait_queue to the end
>>>>>>     - always set iowq.no_iowait
>>>>>>
>>>>>> ---
>>>>>>     include/uapi/linux/io_uring.h | 2 ++
>>>>>>     io_uring/io_uring.c           | 7 ++++---
>>>>>>     io_uring/io_uring.h           | 1 +
>>>>>>     3 files changed, 7 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>>> index 48c440edf674..3a94afa8665e 100644
>>>>>> --- a/include/uapi/linux/io_uring.h
>>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>>> @@ -508,6 +508,7 @@ struct io_cqring_offsets {
>>>>>>     #define IORING_ENTER_EXT_ARG        (1U << 3)
>>>>>>     #define IORING_ENTER_REGISTERED_RING    (1U << 4)
>>>>>>     #define IORING_ENTER_ABS_TIMER        (1U << 5)
>>>>>> +#define IORING_ENTER_NO_IOWAIT        (1U << 6)
>>>>>
>>>>> Just curious, why did we switch from a register opcode to an
>>>>> ENTER flag?
>>>>
>>>> That was my suggestion, I think it's more flexible in that you can
>>>> disable the boost if you know you're doing longer waits or slower IO,
>>>> and enable it when frequencies go up. I don't particularly like the
>>>> static register approach for this.
>>>
>>> Makes sense, it's easier for the app to count how many
>>> request of what type is inflight.
>>
>> Exactly
>>
>>> The name might also be confusing. We need an explanation when
>>> it could be useful, and name it accordingly. DEEP/SHALLOW_WAIT?
>>> Do you remember how cpufreq accounts for it?
>>
>> I don't remember how it accounts for it, and was just pondering that
>> with the above reply. Because if it just decays the sleep state, then
>> you could just use it generically. If it stays high regardless of how
>> long you wait, then it could be a power issue. Not on servers really
>> (well a bit, depending on boosting), but more so on desktop apps.
>> Laptops tend to be pretty power conservative!
> 
> {SHORT,BRIEF}/LONG_WAIT maybe?

I think that's a lot more descriptive. Ideally we'd want to tie this to
wakeup latencies, eg we'd need to know about wakeup latencies. For
example, if the user asks for a 100 usec wait, we'd want to influence
what sleep state is picked in propagating that information. Things like
the min-wait I posted would directly work for that, as it tells the
story in two chapters on what waits we're expecting here. Currently
there's no way to do that (hence iowait -> cpufreq boosting), but there
clearly should be. Or even without min-wait, the timeout is clearly
known here, combined with the expected/desired number of events the
application is looking for.

-- 
Jens Axboe


