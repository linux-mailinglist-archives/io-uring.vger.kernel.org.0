Return-Path: <io-uring+bounces-2819-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A70A9559CB
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 23:09:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3E36B21116
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 21:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E1BC13B783;
	Sat, 17 Aug 2024 21:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="E5UXzaIg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65DF8BE5
	for <io-uring@vger.kernel.org>; Sat, 17 Aug 2024 21:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723928966; cv=none; b=a3Nsjw2a4/t5iiFMBo1p5TNfUY4HzHG6YOJQ3m3FPXplPMap5ze55bPKu5iPxQPkGv1wzJyvZekGgMNaK1rq9rVflGaXzKjhozjB+VXeDrO93wWMB4fw4jGCc94pDEJTKLMfukWixj+Fu11jmvAOSjq6WSUPxlC4u4WkB4d7KiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723928966; c=relaxed/simple;
	bh=dmqfjC+SbKhTaXPhLc/gjbIsOmw6gPhNZQKP8EmIUkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NqDGKSZMeKd63SzttTgyoThAp2w7r9ZDTZ4ZDKVlcjrYv57P63agOJ3xVjDQh1zEVtSbnj9Beh7OWOdCKskFmFgkdeg45Hok9FmsnATtyu7AC64FmQJek4YMHdRNaVAcyRDBa1BtNa4swAZ6lic8UdwS6mb8XTbkfLtOemcbWAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=E5UXzaIg; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2cdba9c71ebso470983a91.2
        for <io-uring@vger.kernel.org>; Sat, 17 Aug 2024 14:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723928961; x=1724533761; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kPHYZKt2+a0EknoDKNJoxWaQlaxxV6MTLfKpxUkZrnY=;
        b=E5UXzaIgXj87afn1M2XV91r2CQtnKngtQrpJ46plX7WejNWlOdpCrWojCM7II4JX31
         DKqEoOSMqKzoyDAcu1exfX675vO9FIF+yvl6704t6WPjOOXl7tHLHp6lOko4p/oY2nw9
         zLIYy7f8XegT3haTtX/Loiz/xsvQPW87r9r5490ZtJ/DISF9PffaE1kQphg8vleP0uec
         5NaRfQlpx/cN84PxV6K+HCKfx5kCVdOB7cAWULUK/4d0hBticlKubDQtgZswI5rMhKUc
         LOKwBcsfMwwUf9iCb2eL8uDc8v9OHlJHxlz9xiqZmfVDmNyMjrD+d05S9QxMJEJ7Vx0M
         rZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723928961; x=1724533761;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kPHYZKt2+a0EknoDKNJoxWaQlaxxV6MTLfKpxUkZrnY=;
        b=bZm2rPVq1K2rhYNspxuWxV9BD1sL4TAHMfAQtZKEn/VVH19YKynNTwR6vz70tX73/l
         YjSF4sZnIzOmtn/n3yojFvZB+yfgqt5yPP4sXHWuSNfvcTeurK+w7AsJGbMh6WLiAeYe
         XVYVQAzJcMIApcUBT//uP9HbxD+JIois4brHIKBRcluSKTcZmLG7DACobaH8XdedFaqf
         25IAuAK/bNcqHfGgjTXIBrezwYopUiX/+EeZP1ZS6xlr9DCTOyX1dM3koVk46W2UJHzX
         j4uTEvrJSu3xi+Hp42a1lFsPs5IDb6ZD5kvgW8BTYpdfZovf6jqxB10MiEaig8KkzZ5s
         RvJA==
X-Forwarded-Encrypted: i=1; AJvYcCX6Ua0sZR2zeovjaaUmNQ87HP1BQMxE/0VeZQLvCiaSPMKUOU5yTQ3y9NPHPZkbRZcZ5c/2et4YLRTBlsN4ZOlCD4LwSErL3pg=
X-Gm-Message-State: AOJu0Yxu8Vb+mWJ2UIaJewqD7Y2W7YfKMVjmsMlG/p/UasmzRga80cO3
	DW6qHz5V64fYflGMvEVHcrb4jAyEkCOgeT8W0/UeaqvaaA812PNhICJwqxWAVKxBqEttkPFsCVA
	9
X-Google-Smtp-Source: AGHT+IEvDvsE1FENzvIwyZWWM2TyEQJsGHYR89/7iVGZ92yZCCDe6GqEoGrc7v/Fi2MB5YY+YDJbKQ==
X-Received: by 2002:a17:902:d2cc:b0:202:18d7:7ffb with SMTP id d9443c01a7336-20218d782f8mr28685655ad.11.1723928960809;
        Sat, 17 Aug 2024 14:09:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03a35fcsm42932005ad.256.2024.08.17.14.09.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Aug 2024 14:09:20 -0700 (PDT)
Message-ID: <e623a08d-2740-4e09-900b-dda5f1c38daf@kernel.dk>
Date: Sat, 17 Aug 2024 15:09:18 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d9d11df4-2a1b-4648-a0f1-d2fb9e76c868@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/17/24 3:05 PM, Pavel Begunkov wrote:
> On 8/17/24 21:20, Jens Axboe wrote:
>> On 8/17/24 1:44 PM, Pavel Begunkov wrote:
>>>> This patchset adds a IOURING_ENTER_NO_IOWAIT flag that can be set on
>>>> enter. If set, then current->in_iowait is not set. By default this flag
>>>
>>> A worthwhile change but for _completely_ different reasons. So, first,
>>> it's v3, not v2, considering the patchset from a couple month ago. And
>>> since in essence nothing has changed, I can only repeat same points I
>>> made back then.
>>>
>>> The description reads like the flag's purpose is to change accounting,
>>> and I'm vividly oppose any user exposed (per ring) toggle doing that.
>>> We don't want the overhead, it's a very confusing feature, and not even
>>
>> Come on, there's no overhead associated with this, in practice.
> 
> Minor, right, ~ 1 "if" or ccmov, but that's for a feature that nobody
> really cares about and arguably even harmful. That's assuming there
> will be another flag for performance tuning in the future, at least
> the description reads like that.

You literally brought up the case where people care yourself in the
reply, the one from Jamal. And the one I said is probably not the common
case, yet I think we should cater to it as it very well could be legit,
just in the tiny minority of cases.

>> It's really simple for this stuff - the freq boost is useful (and
>> needed) for some workloads, and the iowait accounting is never useful
>> for anything but (currently) comes as an unfortunate side effect of the
>> former. But even with those two separated, there are still going to be
>> cases where you want to control when it happens.
> 
> You can imagine such cases, but in reality I doubt it. If we
> disable the stat part, nobody would notice as nobody cared for
> last 3-4 years before in_iowait was added.

That would be ideal. You're saying Jamal's complaint was purely iowait
based? Because it looked like power concerns to me... If it's just
iowait, then they just need to stop looking at that, that's pretty
simple.

>>> that helpful. iowait is monitored not by the app itself but by someone
>>> else outside, likely by a different person, and even before trying to
>>> make sense of numbers the monitor would need to learn first whether
>>> _any_ program uses io_uring and what flags the application writer
>>> decided to pass, even more fun when io_uring is used via a 3rd party
>>> library.
>>>
>>> Exactly same patches could make sense if you flip the description
>>> and say "in_iowait is good for perfomance in some cases but
>>> degrades power consumption for others, so here is a way to tune
>>> performance", (just take Jamal's numbers). And that would need to
>>> clearly state (including man) that the iowait statistic is a side
>>> effect of it, we don't give it a thought, and the time accounting
>>> aspect may and hopefully will change in the future.
>>
>> Don't disagree with that, the boosting is the primary function here,
>> iowait accounting is just an odd relic and side effect.
>>
>>> Jens, can you remind what happened with separating iowait stats
>>> vs the optimisation? I believed you sent some patches
>>
>> Yep I still have them, and I'll dust them off and resend them. But it
>> doesn't really change the need for this at all, other than perhaps
>> wanting to rename the actual flag as it would not be about iowait at
>> all, it'd just be about power consumption.
>>
>> Last cut was here:
>>
>> https://git.kernel.dk/cgit/linux/log/?h=iowait.2
>>
>> just need simple rebasing.
> 
> IMHO we should try to merge it first. And if there would be
> some friction, we can get back and take this patch, with
> additional note describing about iowait stat side effects.

I did just rebase on top of sched/core and sent out a new version. I
still think it makes sense regardless of this patch or not, only
difference would be what you call the flag.

It's here:

https://lore.kernel.org/lkml/20240817204639.132794-1-axboe@kernel.dk/T/#mab3638659a54193927351ebdc5e345278637bc41

>>>> is not set to maintain existing behaviour i.e. in_iowait is always set.
>>>> This is to prevent waiting for completions being accounted as CPU
>>>> utilisation.
>>>
>>> For accounting, it's more reasonable to keep it disabled by
>>> default, so we stop getting millions complaints per day about
>>> high iowait.
>>
>> Agree, it should just go away.
>>
>>>> Not setting in_iowait does mean that we also lose cpufreq optimisations
>>>> above because in_iowait semantics couples 1 and 2 together. Eventually
>>>> we will untangle the two so the optimisations can be enabled
>>>> independently of the accounting.
>>>>
>>>> IORING_FEAT_IOWAIT_TOGGLE is returned in io_uring_create() to indicate
>>>> support. This will be used by liburing to check for this feature.
>>>> Signed-off-by: David Wei <dw@davidwei.uk>
>>>> ---
>>>> v2:
>>>>    - squash patches into one
>>>>    - move no_iowait in struct io_wait_queue to the end
>>>>    - always set iowq.no_iowait
>>>>
>>>> ---
>>>>    include/uapi/linux/io_uring.h | 2 ++
>>>>    io_uring/io_uring.c           | 7 ++++---
>>>>    io_uring/io_uring.h           | 1 +
>>>>    3 files changed, 7 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>> index 48c440edf674..3a94afa8665e 100644
>>>> --- a/include/uapi/linux/io_uring.h
>>>> +++ b/include/uapi/linux/io_uring.h
>>>> @@ -508,6 +508,7 @@ struct io_cqring_offsets {
>>>>    #define IORING_ENTER_EXT_ARG        (1U << 3)
>>>>    #define IORING_ENTER_REGISTERED_RING    (1U << 4)
>>>>    #define IORING_ENTER_ABS_TIMER        (1U << 5)
>>>> +#define IORING_ENTER_NO_IOWAIT        (1U << 6)
>>>
>>> Just curious, why did we switch from a register opcode to an
>>> ENTER flag?
>>
>> That was my suggestion, I think it's more flexible in that you can
>> disable the boost if you know you're doing longer waits or slower IO,
>> and enable it when frequencies go up. I don't particularly like the
>> static register approach for this.
> 
> Makes sense, it's easier for the app to count how many
> request of what type is inflight.

Exactly

> The name might also be confusing. We need an explanation when
> it could be useful, and name it accordingly. DEEP/SHALLOW_WAIT?
> Do you remember how cpufreq accounts for it?

I don't remember how it accounts for it, and was just pondering that
with the above reply. Because if it just decays the sleep state, then
you could just use it generically. If it stays high regardless of how
long you wait, then it could be a power issue. Not on servers really
(well a bit, depending on boosting), but more so on desktop apps.
Laptops tend to be pretty power conservative!

-- 
Jens Axboe


