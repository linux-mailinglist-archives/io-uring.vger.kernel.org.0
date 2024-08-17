Return-Path: <io-uring+bounces-2817-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B24BB955984
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 22:20:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 153612824A2
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 20:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54847433B0;
	Sat, 17 Aug 2024 20:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="srfZsTYx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF7512DD88
	for <io-uring@vger.kernel.org>; Sat, 17 Aug 2024 20:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723926037; cv=none; b=Apvkaor873Bq1AAQr9lE8nqZoXpXMWT+vq+5XTSAQgxD96qk5yJaSPXDU5MYDieB+S6Z0ZxKdht+YNBTx3SP1oM8KixYY8wcLdSbmDAEnXJ1oq2oPz5tSQmLMJ0EISi+7GENM54yOMVVWs8Xr4/N158SWGFu95gOwr0hb64EO0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723926037; c=relaxed/simple;
	bh=rTS+9HhLagRfJBXwKRxCaMwrPhGEHZkNCS0emLox0SY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ONXQ/x1ASC9atRYxZj18/l6R44m/niEOEV+D3uffTzeqs9LikwdSF9QlH+krZkSECcRNqYKDgkzO4T/rG1xBciY+UYHs90qgiQednjpr5zgUr7uXu/vHsOMatFqiH2wsBRLdwGEcQsHOOEy2o7CC80KDyLJQpN21qXavkNmYsPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=srfZsTYx; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2d3b654d4d7so468378a91.0
        for <io-uring@vger.kernel.org>; Sat, 17 Aug 2024 13:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723926032; x=1724530832; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fY6id0drsbcVIQH+9HHfHDSMWUMIssEoqFcyTWfWpz0=;
        b=srfZsTYxZtm6610S3pTJhVPpiBL1DO9BtH9cUWuhQgRewoBoRDxkNIiZ/6bPv/6adA
         RtV7+nHA7WNtQrsJ7qzW6LmY7Ux/zaK+jPDlbrd6GhAsZqMJOIOfeieUvf3UlTKqA5Lh
         NL6prG3yXwvYEZxf/TVOTG0QRdOdbA/lgTjuUEi9d+CAdnQFE1NONq9F24BbyH7PVDna
         VJK8kmVr/LPz5y7jPfZdv9PIim/2seqjUbUaTU6YgSeoTUzQb+FYReg/za91J8pAbrG8
         Yb4BZ86jq8qH+g+lmda+/0tO98ZSKhgVCioOUaMJZwWelw6HpxbZ752a8BrRqYBXvxGV
         wYLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723926032; x=1724530832;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fY6id0drsbcVIQH+9HHfHDSMWUMIssEoqFcyTWfWpz0=;
        b=VO9TwRo3BTJ5MoZABPS6M11w98w+3UUdLaz1hfadyjyceVAo25cuDkuJFTgp5VdF7Q
         FeeJKdfDNkszYnQUlNBdSl2uKMokBWcou6v0I+Cz12F1e6JpyGrQtiOaDjc8eXkTe7Vq
         O/YbCu1FAZOvP/aFWmHryKdBXE0GShgUw9cTXmnh4/Rqqpv+4BCBSsdRGDHhr/RqpISM
         EW0x9nkPDEbhuF49WA0hBW6BJn6Qz1SjtRBRaSzVPU4LtrOJ0yieg+kzMotEyd7XhFaY
         Fc8ha4vM7wYXVBhwXO9o4c3MiT3yfxhNrsLafq3zpeBDuTtsCL6LFAh2G2b/Vr1IJFx/
         1Apg==
X-Forwarded-Encrypted: i=1; AJvYcCWNqWUa1CpYNqSc9vyoc+ih+b+lATdeDENWJtvUwLptiAH8LFO51sxMFDPDHQiBpnRFkU9g0S46DPwcU0dMuQWWgO3+UUFnIYM=
X-Gm-Message-State: AOJu0YwzVQDqVo/1QuydXkj6KM2qMfi54GHfIaMD6poJpU1lPYjkEkkG
	7Fev78GaLvi8GT+mjg3o6YEJLXp+Geilo8ksHsZDLUhrU6kje2zbEUmNRRuMuw8=
X-Google-Smtp-Source: AGHT+IE9uISrOEl4KTWeobmdXazG8YucvPWmEclLwb/Xx2ikEFfX1WqHl7qI20lUvNHalUpshxI9+Q==
X-Received: by 2002:a05:6a21:998d:b0:1c6:a62a:9773 with SMTP id adf61e73a8af0-1c905025deamr5322747637.5.1723926031713;
        Sat, 17 Aug 2024 13:20:31 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127aef8996sm4373373b3a.122.2024.08.17.13.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Aug 2024 13:20:30 -0700 (PDT)
Message-ID: <03d825b1-187b-432c-bff4-f28d96e3164e@kernel.dk>
Date: Sat, 17 Aug 2024 14:20:29 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ab4252f1-90e3-4abf-b4fb-0b318edc05bd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/17/24 1:44 PM, Pavel Begunkov wrote:
>> This patchset adds a IOURING_ENTER_NO_IOWAIT flag that can be set on
>> enter. If set, then current->in_iowait is not set. By default this flag
> 
> A worthwhile change but for _completely_ different reasons. So, first,
> it's v3, not v2, considering the patchset from a couple month ago. And
> since in essence nothing has changed, I can only repeat same points I
> made back then.
> 
> The description reads like the flag's purpose is to change accounting,
> and I'm vividly oppose any user exposed (per ring) toggle doing that.
> We don't want the overhead, it's a very confusing feature, and not even

Come on, there's no overhead associated with this, in practice.

It's really simple for this stuff - the freq boost is useful (and
needed) for some workloads, and the iowait accounting is never useful
for anything but (currently) comes as an unfortunate side effect of the
former. But even with those two separated, there are still going to be
cases where you want to control when it happens.

> that helpful. iowait is monitored not by the app itself but by someone
> else outside, likely by a different person, and even before trying to
> make sense of numbers the monitor would need to learn first whether
> _any_ program uses io_uring and what flags the application writer
> decided to pass, even more fun when io_uring is used via a 3rd party
> library.
> 
> Exactly same patches could make sense if you flip the description
> and say "in_iowait is good for perfomance in some cases but
> degrades power consumption for others, so here is a way to tune
> performance", (just take Jamal's numbers). And that would need to
> clearly state (including man) that the iowait statistic is a side
> effect of it, we don't give it a thought, and the time accounting
> aspect may and hopefully will change in the future.

Don't disagree with that, the boosting is the primary function here,
iowait accounting is just an odd relic and side effect.

> Jens, can you remind what happened with separating iowait stats
> vs the optimisation? I believed you sent some patches

Yep I still have them, and I'll dust them off and resend them. But it
doesn't really change the need for this at all, other than perhaps
wanting to rename the actual flag as it would not be about iowait at
all, it'd just be about power consumption.

Last cut was here:

https://git.kernel.dk/cgit/linux/log/?h=iowait.2

just need simple rebasing.

>> is not set to maintain existing behaviour i.e. in_iowait is always set.
>> This is to prevent waiting for completions being accounted as CPU
>> utilisation.
> 
> For accounting, it's more reasonable to keep it disabled by
> default, so we stop getting millions complaints per day about
> high iowait.

Agree, it should just go away.

>> Not setting in_iowait does mean that we also lose cpufreq optimisations
>> above because in_iowait semantics couples 1 and 2 together. Eventually
>> we will untangle the two so the optimisations can be enabled
>> independently of the accounting.
>>
>> IORING_FEAT_IOWAIT_TOGGLE is returned in io_uring_create() to indicate
>> support. This will be used by liburing to check for this feature.
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>> v2:
>>   - squash patches into one
>>   - move no_iowait in struct io_wait_queue to the end
>>   - always set iowq.no_iowait
>>
>> ---
>>   include/uapi/linux/io_uring.h | 2 ++
>>   io_uring/io_uring.c           | 7 ++++---
>>   io_uring/io_uring.h           | 1 +
>>   3 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 48c440edf674..3a94afa8665e 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -508,6 +508,7 @@ struct io_cqring_offsets {
>>   #define IORING_ENTER_EXT_ARG        (1U << 3)
>>   #define IORING_ENTER_REGISTERED_RING    (1U << 4)
>>   #define IORING_ENTER_ABS_TIMER        (1U << 5)
>> +#define IORING_ENTER_NO_IOWAIT        (1U << 6)
> 
> Just curious, why did we switch from a register opcode to an
> ENTER flag?

That was my suggestion, I think it's more flexible in that you can
disable the boost if you know you're doing longer waits or slower IO,
and enable it when frequencies go up. I don't particularly like the
static register approach for this.

-- 
Jens Axboe


