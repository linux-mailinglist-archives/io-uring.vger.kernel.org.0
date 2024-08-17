Return-Path: <io-uring+bounces-2820-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C18E955A02
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 00:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC5361C209D2
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 22:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 890E41487FF;
	Sat, 17 Aug 2024 22:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="khdr2AGm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7565F79CC
	for <io-uring@vger.kernel.org>; Sat, 17 Aug 2024 22:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723932223; cv=none; b=Sj3WbO6k/vtJZHuc/xGqXBsrmxb2Opsx91TJ20XOO/HTl3qz94MBPcH/iySp55fvKdPyVf8bY+dwBeUCDQQDGPEHU4EKHUboQEelLjimUPb5VtsWYEArwKyFdv0xqTnKmrfHUmbvmOArsE+JAcipIR7mEJl9LQnAFQlUQTmFyJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723932223; c=relaxed/simple;
	bh=f7cdBF60dTmC59YLHEbw6Q/o9vkONoYcBYfaiPxHfzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sbDic7l34iA7G/PHBoS1jjZqXphthhjBNov0JAIA/50qbICWtdips5BruacsGxJ102Mv+MnzJNCyZFrxe/A1e1GwmX3kgz6DalTMPZCG9PS1NElkO6+rwEm9aaFn8PCe5tOvD70oqDpJ5j4Jw2mtM5FM9e9rwI63s5+aZ6KcM/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=khdr2AGm; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-52f024f468bso3971070e87.1
        for <io-uring@vger.kernel.org>; Sat, 17 Aug 2024 15:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723932219; x=1724537019; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MkYIWVNFv4o37iTBcbD0h7iSo/tH6lz+WLt/NI9qBZY=;
        b=khdr2AGmbbiUUfu8HNBqSmy1bhT1ftG0UGlnndQo53IhSx/zTf7/jSQ9BqQoVZ68/i
         3849S7lkNX9M1OiPKhJ0OPN4gLRDESEh+m5/TVr9yT+7AxKN2Qm8+eT0zd8t1FWfrWfl
         MKw0f+D3+TXRTwDa8s/UuMMoGJBaLA1SGuf8ov0qqBYXQxKORUA9AnRb2zEpClomDWFR
         fp5BOwdiz36A8jDvpKnR4ncGhDZBdZ3D/QJC8mWb4MmFEKvsS06c/g7lthcEmMcYBN4z
         mUT4QcTi6iIMO5fdSOlMkzk42nmLfNLm6/BmM66Snso94JF/t127orbq3zZ3QKb8xOvL
         LaTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723932219; x=1724537019;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MkYIWVNFv4o37iTBcbD0h7iSo/tH6lz+WLt/NI9qBZY=;
        b=ptD5t7EN0LhMpSVgavwKU+JfEQJgeVH3ASzf1yvEsYXl41HspYkIs7bmeQDQxolTzt
         xtwM73mhXCWeydpEj20vfQKXJxcYG5HdsItz/5I1q5yopHSrCfAEZCKQEeGZVzBya/3N
         0JPGMjJIQUM7aqD5nfnKeGpjuuQ/MkeuMO0eG4v/5Al3ibMh8fmOWd1MVVj92X42jrKs
         aocqFMw9LQfwDKPCjB07x+XfCZQ4ty6w8ffMRio23v0hKH6NJZKHI9bGhFraGIcjQMiQ
         prktphOnYnqNnIPz9l1Ebsk3SKepLmCgw51yGSmo4oOSqAGvSKs9YDpUWPwBq0bbjCjv
         CaYA==
X-Forwarded-Encrypted: i=1; AJvYcCXUzSWbo2yUhQJx18KJyBkzU7aJFYQOaamQT4dvX0Tejq8euRBnq4YKUxpfec4vgFnONMsnX89P32Sn2WXUkzDf5Zy3bp+EmoQ=
X-Gm-Message-State: AOJu0Yx1/IcsD96bTomUWxv174Bs+y4NnzWlYwo5Jyg0G43fPvT8PV26
	0O9xJu5ojO26yg8PCq1dz24XLWOrXWr5xxDOdz5mdAsjXqoCfbzd
X-Google-Smtp-Source: AGHT+IEUZyrZemMohwkMg3rjPSk8jy4Sl6mdsUsXHGWIuZPH/1YFF4sqHyk7lR8WjknU42CCeCtQzQ==
X-Received: by 2002:a05:6512:10cb:b0:52e:9dee:a6f5 with SMTP id 2adb3069b0e04-5331c6dcca9mr3860643e87.46.1723932219125;
        Sat, 17 Aug 2024 15:03:39 -0700 (PDT)
Received: from [192.168.8.113] ([185.69.144.74])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838d015asm450733366b.90.2024.08.17.15.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Aug 2024 15:03:38 -0700 (PDT)
Message-ID: <4a5bb60a-2b53-4f76-b912-08841aceae1e@gmail.com>
Date: Sat, 17 Aug 2024 23:04:13 +0100
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e623a08d-2740-4e09-900b-dda5f1c38daf@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/24 22:09, Jens Axboe wrote:
> On 8/17/24 3:05 PM, Pavel Begunkov wrote:
>> On 8/17/24 21:20, Jens Axboe wrote:
>>> On 8/17/24 1:44 PM, Pavel Begunkov wrote:
>>>>> This patchset adds a IOURING_ENTER_NO_IOWAIT flag that can be set on
>>>>> enter. If set, then current->in_iowait is not set. By default this flag
>>>>
>>>> A worthwhile change but for _completely_ different reasons. So, first,
>>>> it's v3, not v2, considering the patchset from a couple month ago. And
>>>> since in essence nothing has changed, I can only repeat same points I
>>>> made back then.
>>>>
>>>> The description reads like the flag's purpose is to change accounting,
>>>> and I'm vividly oppose any user exposed (per ring) toggle doing that.
>>>> We don't want the overhead, it's a very confusing feature, and not even
>>>
>>> Come on, there's no overhead associated with this, in practice.
>>
>> Minor, right, ~ 1 "if" or ccmov, but that's for a feature that nobody
>> really cares about and arguably even harmful. That's assuming there
>> will be another flag for performance tuning in the future, at least
>> the description reads like that.
> 
> You literally brought up the case where people care yourself in the
> reply, the one from Jamal. And the one I said is probably not the common

Not really. Yes, by chance high iowait helped to narrow it to the
in_iowait io_uring patch, but that's rather a weird side effect,
not what iowait was "created for", i.e. system is idling because
storage waiting takes too long.

And that "use case" for iowait directly linked to cpufreq, so
if it still counts, then we shouldn't be separating stats from
cpufreq at all.

> case, yet I think we should cater to it as it very well could be legit,
> just in the tiny minority of cases.

I explained why it's a confusing feature. We can make up some niche
case (with enough of imagination we can justify basically anything),
but I explained why IMHO accounting flag (let's forget about
cpufreq) would have net negative effect. A sysctl knob would be
much more reasonable, but I don't think it's needed at all.


>>> It's really simple for this stuff - the freq boost is useful (and
>>> needed) for some workloads, and the iowait accounting is never useful
>>> for anything but (currently) comes as an unfortunate side effect of the
>>> former. But even with those two separated, there are still going to be
>>> cases where you want to control when it happens.
>>
>> You can imagine such cases, but in reality I doubt it. If we
>> disable the stat part, nobody would notice as nobody cared for
>> last 3-4 years before in_iowait was added.
> 
> That would be ideal. You're saying Jamal's complaint was purely iowait
> based? Because it looked like power concerns to me... If it's just
> iowait, then they just need to stop looking at that, that's pretty
> simple.

Power consumption, and then, in search of what's wrong, it was
correlated to high iowait as well as difference in C state stats.


>>>> that helpful. iowait is monitored not by the app itself but by someone
>>>> else outside, likely by a different person, and even before trying to
>>>> make sense of numbers the monitor would need to learn first whether
>>>> _any_ program uses io_uring and what flags the application writer
>>>> decided to pass, even more fun when io_uring is used via a 3rd party
>>>> library.
>>>>
>>>> Exactly same patches could make sense if you flip the description
>>>> and say "in_iowait is good for perfomance in some cases but
>>>> degrades power consumption for others, so here is a way to tune
>>>> performance", (just take Jamal's numbers). And that would need to
>>>> clearly state (including man) that the iowait statistic is a side
>>>> effect of it, we don't give it a thought, and the time accounting
>>>> aspect may and hopefully will change in the future.
>>>
>>> Don't disagree with that, the boosting is the primary function here,
>>> iowait accounting is just an odd relic and side effect.
>>>
>>>> Jens, can you remind what happened with separating iowait stats
>>>> vs the optimisation? I believed you sent some patches
>>>
>>> Yep I still have them, and I'll dust them off and resend them. But it
>>> doesn't really change the need for this at all, other than perhaps
>>> wanting to rename the actual flag as it would not be about iowait at
>>> all, it'd just be about power consumption.
>>>
>>> Last cut was here:
>>>
>>> https://git.kernel.dk/cgit/linux/log/?h=iowait.2
>>>
>>> just need simple rebasing.
>>
>> IMHO we should try to merge it first. And if there would be
>> some friction, we can get back and take this patch, with
>> additional note describing about iowait stat side effects.
> 
> I did just rebase on top of sched/core and sent out a new version. I
> still think it makes sense regardless of this patch or not, only
> difference would be what you call the flag.

There shouldn't be any difference in how it's called or how
it's recommended to be used, but maybe I don't understand
what you mean. As I see it, the difference in a blob of
text in the man mentioning the iowait stat side effect.

> It's here:
> 
> https://lore.kernel.org/lkml/20240817204639.132794-1-axboe@kernel.dk/T/#mab3638659a54193927351ebdc5e345278637bc41

Perfect


>>>>> is not set to maintain existing behaviour i.e. in_iowait is always set.
>>>>> This is to prevent waiting for completions being accounted as CPU
>>>>> utilisation.
>>>>
>>>> For accounting, it's more reasonable to keep it disabled by
>>>> default, so we stop getting millions complaints per day about
>>>> high iowait.
>>>
>>> Agree, it should just go away.
>>>
>>>>> Not setting in_iowait does mean that we also lose cpufreq optimisations
>>>>> above because in_iowait semantics couples 1 and 2 together. Eventually
>>>>> we will untangle the two so the optimisations can be enabled
>>>>> independently of the accounting.
>>>>>
>>>>> IORING_FEAT_IOWAIT_TOGGLE is returned in io_uring_create() to indicate
>>>>> support. This will be used by liburing to check for this feature.
>>>>> Signed-off-by: David Wei <dw@davidwei.uk>
>>>>> ---
>>>>> v2:
>>>>>     - squash patches into one
>>>>>     - move no_iowait in struct io_wait_queue to the end
>>>>>     - always set iowq.no_iowait
>>>>>
>>>>> ---
>>>>>     include/uapi/linux/io_uring.h | 2 ++
>>>>>     io_uring/io_uring.c           | 7 ++++---
>>>>>     io_uring/io_uring.h           | 1 +
>>>>>     3 files changed, 7 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>> index 48c440edf674..3a94afa8665e 100644
>>>>> --- a/include/uapi/linux/io_uring.h
>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>> @@ -508,6 +508,7 @@ struct io_cqring_offsets {
>>>>>     #define IORING_ENTER_EXT_ARG        (1U << 3)
>>>>>     #define IORING_ENTER_REGISTERED_RING    (1U << 4)
>>>>>     #define IORING_ENTER_ABS_TIMER        (1U << 5)
>>>>> +#define IORING_ENTER_NO_IOWAIT        (1U << 6)
>>>>
>>>> Just curious, why did we switch from a register opcode to an
>>>> ENTER flag?
>>>
>>> That was my suggestion, I think it's more flexible in that you can
>>> disable the boost if you know you're doing longer waits or slower IO,
>>> and enable it when frequencies go up. I don't particularly like the
>>> static register approach for this.
>>
>> Makes sense, it's easier for the app to count how many
>> request of what type is inflight.
> 
> Exactly
> 
>> The name might also be confusing. We need an explanation when
>> it could be useful, and name it accordingly. DEEP/SHALLOW_WAIT?
>> Do you remember how cpufreq accounts for it?
> 
> I don't remember how it accounts for it, and was just pondering that
> with the above reply. Because if it just decays the sleep state, then
> you could just use it generically. If it stays high regardless of how
> long you wait, then it could be a power issue. Not on servers really
> (well a bit, depending on boosting), but more so on desktop apps.
> Laptops tend to be pretty power conservative!

{SHORT,BRIEF}/LONG_WAIT maybe?

-- 
Pavel Begunkov

