Return-Path: <io-uring+bounces-2818-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C6F9559CA
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 23:04:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 082C5282223
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 21:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A50EA54774;
	Sat, 17 Aug 2024 21:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jm8gryL/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE8D13B783
	for <io-uring@vger.kernel.org>; Sat, 17 Aug 2024 21:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723928687; cv=none; b=FfPQDs21KlM5ygNQieQxR8qfvbioGVQ5Ltdz5wRDn4B109uadJ01Xg8cKONWdVwgq9iXtlj+w3P8VjkVLM0G0GjelgVscYu40UEl7AsFbdsLlQz5fDwQpfyZPwEK7avxPRwyCV+DaKIYoaB+7Rppvnyl8p/aLPEjg/2mIQM82fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723928687; c=relaxed/simple;
	bh=i0K8TttfI/AcRaS9uTjQmwXFxPFe3LmJWAzgI7DWFGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dyOWFbK9qlEszuu0h1rVxkqBjLih7KNefMsFtmw02tVccz11SU3zy+QEMbc8ZWcewK43EBGBSH62f0DaL0/CoIkt7zIKr59SuVlEVExNh0PyN1nB4TShKXBkQKaa7lrqfuDH2ZuGTW97Hi9SE8IUxQ+JG4hFqHNZW0aF2lpfGEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jm8gryL/; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a7aada2358fso639754466b.0
        for <io-uring@vger.kernel.org>; Sat, 17 Aug 2024 14:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723928684; x=1724533484; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OX8Dz6bXavQ/Qjq7PPZO03weTUYvLfjkhwq9q7wA8rY=;
        b=jm8gryL/rjXIs2lIW2dF+zLEsawPlerjLx4k3YCZxGnDIHQioYvpG7V1deIa/ACDrO
         yJrAwHmWLcJQ3pjmaXpFx1/GQ2AI9jGEBb/Okz3VHJ8VeaIda/vOWkBAfVWDOPAHU8Za
         kCd0NR/ZHp2JcAmaMdligygsa8iftmT2FtMlTDGhrKDTXNIgRZpAjc9elKKq0IrQKxjp
         NpgsDAEOwbKZxRWMdTwGiUMQ+XcNVkMvXtOQ6qIelgB3b+9LWnp7+xp9e1Mrk3ExIZ1g
         gw5J+t0nzE1/TVmxTI09BkEIPGMwwt2rAM4z50xbeUYKV5rY0Wv7C1DM69KQWkI37Sp0
         RRrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723928684; x=1724533484;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OX8Dz6bXavQ/Qjq7PPZO03weTUYvLfjkhwq9q7wA8rY=;
        b=W+HXusFelm7zFIOBXMHUWByoH04fuuYnVJuTinZnjH5ManWYYHGdfmgl3B9ytGEdIE
         UsHupuNt++TnR6vL8Kyft6R+QMHhh9LPx5krgzVuj8tDLq+nd5YtoDCr0IBvuES2k/pg
         qoCkzH8YyOvq5xP5XcTQEq/E6+zwejjy7h/BoQ2gJpv8z1j9ut4lQnG+4SE0zLJoKDAP
         m+7ebpEglUjh4HEX2QHEG13zJ8Vi+VPOPlofsCt8CqTsoXFzPOy8qtl8O6+hWRu2feYV
         MoCYcPlAT1yG3JMN1RceMn/DUm58DUpuP0Atn9Jfg3ybq6KCTkWPe/PuWeCv2gZHhsnK
         tgHg==
X-Forwarded-Encrypted: i=1; AJvYcCWUNQFUtljtZfrrx7LI7f9FOj+esY0fy9+yO3/wAxpq2VfVdDaHoON/DbXxV1mHR4yyYDS2IT7p9LGttgaMqvPq0SQkRQrgU2w=
X-Gm-Message-State: AOJu0YzlP8XOxR26VLnFegovbrxKgfJHOP2nsQwAVqBxQZk/GQkNxYVV
	KbRb1FHWlikTszPMYJ52dk1e4ZQ3SQn7kM8j3nZfHG//VBEE7O4O
X-Google-Smtp-Source: AGHT+IEgR2a/LJ/HQPvJvz1isgAcvLdbwlCfoFgP7QPf0Wfr/Qe5gaxE53amWYVxc4cd+HgrciNOzg==
X-Received: by 2002:a17:907:3e9e:b0:a7d:2772:6d5f with SMTP id a640c23a62f3a-a8394f7e9f9mr468671566b.23.1723928683455;
        Sat, 17 Aug 2024 14:04:43 -0700 (PDT)
Received: from [192.168.8.113] ([185.69.144.74])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838cfa18sm446454766b.73.2024.08.17.14.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Aug 2024 14:04:42 -0700 (PDT)
Message-ID: <d9d11df4-2a1b-4648-a0f1-d2fb9e76c868@gmail.com>
Date: Sat, 17 Aug 2024 22:05:15 +0100
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <03d825b1-187b-432c-bff4-f28d96e3164e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/24 21:20, Jens Axboe wrote:
> On 8/17/24 1:44 PM, Pavel Begunkov wrote:
>>> This patchset adds a IOURING_ENTER_NO_IOWAIT flag that can be set on
>>> enter. If set, then current->in_iowait is not set. By default this flag
>>
>> A worthwhile change but for _completely_ different reasons. So, first,
>> it's v3, not v2, considering the patchset from a couple month ago. And
>> since in essence nothing has changed, I can only repeat same points I
>> made back then.
>>
>> The description reads like the flag's purpose is to change accounting,
>> and I'm vividly oppose any user exposed (per ring) toggle doing that.
>> We don't want the overhead, it's a very confusing feature, and not even
> 
> Come on, there's no overhead associated with this, in practice.

Minor, right, ~ 1 "if" or ccmov, but that's for a feature that nobody
really cares about and arguably even harmful. That's assuming there
will be another flag for performance tuning in the future, at least
the description reads like that.

> It's really simple for this stuff - the freq boost is useful (and
> needed) for some workloads, and the iowait accounting is never useful
> for anything but (currently) comes as an unfortunate side effect of the
> former. But even with those two separated, there are still going to be
> cases where you want to control when it happens.

You can imagine such cases, but in reality I doubt it. If we
disable the stat part, nobody would notice as nobody cared for
last 3-4 years before in_iowait was added.

>> that helpful. iowait is monitored not by the app itself but by someone
>> else outside, likely by a different person, and even before trying to
>> make sense of numbers the monitor would need to learn first whether
>> _any_ program uses io_uring and what flags the application writer
>> decided to pass, even more fun when io_uring is used via a 3rd party
>> library.
>>
>> Exactly same patches could make sense if you flip the description
>> and say "in_iowait is good for perfomance in some cases but
>> degrades power consumption for others, so here is a way to tune
>> performance", (just take Jamal's numbers). And that would need to
>> clearly state (including man) that the iowait statistic is a side
>> effect of it, we don't give it a thought, and the time accounting
>> aspect may and hopefully will change in the future.
> 
> Don't disagree with that, the boosting is the primary function here,
> iowait accounting is just an odd relic and side effect.
> 
>> Jens, can you remind what happened with separating iowait stats
>> vs the optimisation? I believed you sent some patches
> 
> Yep I still have them, and I'll dust them off and resend them. But it
> doesn't really change the need for this at all, other than perhaps
> wanting to rename the actual flag as it would not be about iowait at
> all, it'd just be about power consumption.
> 
> Last cut was here:
> 
> https://git.kernel.dk/cgit/linux/log/?h=iowait.2
> 
> just need simple rebasing.

IMHO we should try to merge it first. And if there would be
some friction, we can get back and take this patch, with
additional note describing about iowait stat side effects.

>>> is not set to maintain existing behaviour i.e. in_iowait is always set.
>>> This is to prevent waiting for completions being accounted as CPU
>>> utilisation.
>>
>> For accounting, it's more reasonable to keep it disabled by
>> default, so we stop getting millions complaints per day about
>> high iowait.
> 
> Agree, it should just go away.
> 
>>> Not setting in_iowait does mean that we also lose cpufreq optimisations
>>> above because in_iowait semantics couples 1 and 2 together. Eventually
>>> we will untangle the two so the optimisations can be enabled
>>> independently of the accounting.
>>>
>>> IORING_FEAT_IOWAIT_TOGGLE is returned in io_uring_create() to indicate
>>> support. This will be used by liburing to check for this feature.
>>> Signed-off-by: David Wei <dw@davidwei.uk>
>>> ---
>>> v2:
>>>    - squash patches into one
>>>    - move no_iowait in struct io_wait_queue to the end
>>>    - always set iowq.no_iowait
>>>
>>> ---
>>>    include/uapi/linux/io_uring.h | 2 ++
>>>    io_uring/io_uring.c           | 7 ++++---
>>>    io_uring/io_uring.h           | 1 +
>>>    3 files changed, 7 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index 48c440edf674..3a94afa8665e 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -508,6 +508,7 @@ struct io_cqring_offsets {
>>>    #define IORING_ENTER_EXT_ARG        (1U << 3)
>>>    #define IORING_ENTER_REGISTERED_RING    (1U << 4)
>>>    #define IORING_ENTER_ABS_TIMER        (1U << 5)
>>> +#define IORING_ENTER_NO_IOWAIT        (1U << 6)
>>
>> Just curious, why did we switch from a register opcode to an
>> ENTER flag?
> 
> That was my suggestion, I think it's more flexible in that you can
> disable the boost if you know you're doing longer waits or slower IO,
> and enable it when frequencies go up. I don't particularly like the
> static register approach for this.

Makes sense, it's easier for the app to count how many
request of what type is inflight.

The name might also be confusing. We need an explanation when
it could be useful, and name it accordingly. DEEP/SHALLOW_WAIT?
Do you remember how cpufreq accounts for it?

-- 
Pavel Begunkov

