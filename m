Return-Path: <io-uring+bounces-710-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05C9F8628B6
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 02:15:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D0A7B21429
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 01:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F037F9;
	Sun, 25 Feb 2024 01:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BC/YeXs5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE9F10E4
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 01:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708823744; cv=none; b=Y+T76Sy1U/fcyVeUX62RskXY2X3chs7q+K4BU4dJoxxuUfFa6IGkyiiarAUkcB+LjNeO9hM2eb1cCKPLOJJhmuprJpLwRPGOzBrF+BPMTRefgGKsP4bgFr+B6rI/aIgaQIMdF7z//1kisxrXTNmmGnGDh/z/3EEgHKZK8YQ1Aiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708823744; c=relaxed/simple;
	bh=e//fex00lYzOFW64Xyy7V/t1ixivnfkicU3ItrVSX2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nQk41M4XRKjfQWcCMQYLOp8dDyF3qPJePnJ1n9srG3EfYrDZ05P2ppdA5Y7HtxMMHcAjuweSZfDT+eDNAiTthBBAm9r0OH3PV+nllFFv0fHulBglojXEp6vlQRa1JmXx4x4U7zO/hDfXnOzdoP5dxbKA04HRu7cHzLNlJ1OmVDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BC/YeXs5; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a3e72ec566aso257760666b.2
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 17:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708823740; x=1709428540; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xlmspl6L1Gt/9gouRNjyAKb1plzf5SatZMqbSZXlz/c=;
        b=BC/YeXs5CPPZ8iswDj6/LThNQMy3yVa9LVsDBjPKavKbNT5u2kVxTdmrkpWVvUZmjl
         PNStDO5pmV/8Jd9WvXdXI9ZdngDLv3ZCp+dyEdDtlLnkdjckGsnzD6tRclaDYrUpUixE
         gQ8fFiHLq7SYSqjUy8BG+SoOpf/oKGOanuiaD55PJQFSPO67V4/oIY0OupsfQ0lyWRwr
         QrhlkdAqgypt7PYBHT5A8labLphO7rdb2d97x7t196FPv5WhR82DJ2oVPswkjZLNzl78
         CK9gaNM82xHCysVsJ2HoPST0/lQMmmHrqUsQeGpTSbRucpqhSyT1tTYXaqfCXEPQgdLW
         /YBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708823740; x=1709428540;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xlmspl6L1Gt/9gouRNjyAKb1plzf5SatZMqbSZXlz/c=;
        b=qPpLhCbcHEZru+dWzgecRKCUSWnVO3qo6MPVyBmnhggtwTdvAaKIXp6EEAQcNOwZL3
         pN6y8BMl49sqLapAHF5BBdzvRYWplt9s3JGCy8qXW83VUf7fxublDgzM5vzaHiaJHjer
         yefBx4D7UkV3hoU1sigk0PTMjEwl4XvYhMS2wKPr+L36d+WVKc3ce25hTO207nyG3F+A
         OesXi6ZJLu/bPcAd9CCgqlV3RUk+ogTckm8mWprzm/F1OswEpLv2bWYOGNSMZ62rYQzA
         W3BIAsKpwAtUmO+FSQWR5S2nvFYLnDiomUGfSH3z8a+6tWdsp0nuaUF6UC54WPO/fQ4G
         6OYw==
X-Forwarded-Encrypted: i=1; AJvYcCXjFcEMAJrfXefoQFdYRlUPfeV0hPVbi5dkHWQhc8yZm4Mv9n6XEPhRs+F0dSA+yS+LWTH+awX/q5cRMMhJEUVF26gNdsnEnBs=
X-Gm-Message-State: AOJu0YxTll7Q9B9m5hVHbhPwFv0XzjM1vHSOCTW6VxgU1eQG/cFfBv1i
	+NQZvsUIa6aq06pG30oxKHyn96owoHLDJcGMOgycC2qhkCDc/7Z3udZsk48v
X-Google-Smtp-Source: AGHT+IHbUDTnSLWNjMREk8z65VzBtqd6YsrNVEqHRY/NqEqmP/QW6pIPl+8IdTgEHrXGV5TrptPOPw==
X-Received: by 2002:a17:906:bc97:b0:a3e:f1c8:f5c2 with SMTP id lv23-20020a170906bc9700b00a3ef1c8f5c2mr2236474ejb.23.1708823740279;
        Sat, 24 Feb 2024 17:15:40 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.140])
        by smtp.gmail.com with ESMTPSA id s18-20020a17090699d200b00a42eb167492sm1001880ejn.116.2024.02.24.17.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Feb 2024 17:15:39 -0800 (PST)
Message-ID: <2bdf6fa7-35d8-438b-be20-e1da78ca0151@gmail.com>
Date: Sun, 25 Feb 2024 00:58:02 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] io_uring: only account cqring wait time as iowait
 if enabled for a ring
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20240224050735.1759733-1-dw@davidwei.uk>
 <678382b5-0448-4f4d-b7b7-8df7592d77a4@gmail.com>
 <ce348f24-8e11-49e9-aebb-7c87f45138d0@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ce348f24-8e11-49e9-aebb-7c87f45138d0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/24 18:51, Jens Axboe wrote:
> On 2/24/24 8:31 AM, Pavel Begunkov wrote:
>> On 2/24/24 05:07, David Wei wrote:
>>> Currently we unconditionally account time spent waiting for events in CQ
>>> ring as iowait time.
>>>
>>> Some userspace tools consider iowait time to be CPU util/load which can
>>> be misleading as the process is sleeping. High iowait time might be
>>> indicative of issues for storage IO, but for network IO e.g. socket
>>> recv() we do not control when the completions happen so its value
>>> misleads userspace tooling.
>>>
>>> This patch gates the previously unconditional iowait accounting behind a
>>> new IORING_REGISTER opcode. By default time is not accounted as iowait,
>>> unless this is explicitly enabled for a ring. Thus userspace can decide,
>>> depending on the type of work it expects to do, whether it wants to
>>> consider cqring wait time as iowait or not.
>>
>> I don't believe it's a sane approach. I think we agree that per
>> cpu iowait is a silly and misleading metric. I have hard time to
>> define what it is, and I'm sure most probably people complaining
>> wouldn't be able to tell as well. Now we're taking that metric
>> and expose even more knobs to userspace.
> 
> For sure, it's a stupid metric. But at the same time, educating people
> on this can be like talking to a brick wall, and it'll be years of doing
> that before we're making a dent in it. Hence I do think that just
> exposing the knob and letting the storage side use it, if they want, is
> the path of least resistance. I'm personally not going to do a crusade
> on iowait to eliminate it, I don't have the time for that. I'll educate

Exactly my point but with a different conclusion. The path of least
resistance is to have io_uring not accounted to iowait. That's how
it was so nobody should complain about it, you don't have to care about
it at all, you don't have to educate people on iowait when it comes up
with in the context of that knob, and you don't have to educate folks
on what this knob is and wtf it's there, and we're not pretending that
it works when it's not.

> people when it comes up, like I have been doing, but pulling this to
> conclusion would be 10+ years easily.
> 
>> Another argument against is that per ctx is not the right place
>> to have it. It's a system metric, and you can imagine some system
>> admin looking for it. Even in cases when had some meaning w/o
>> io_uring now without looking at what flags io_uring has it's
>> completely meaningless, and it's too much to ask.
>>
>> I don't understand why people freak out at seeing hi iowait,
>> IMHO it perfectly fits the definition of io_uring waiting for
>> IO / completions, but at this point it might be better to just
>> revert it to the old behaviour of not reporting iowait at all.
>> And if we want to save the cpu freq iowait optimisation, we
>> should just split notion of iowait reporting and iowait cpufreq
>> tuning.
> 
> For io_uring, splitting the cpufreq from iowait is certainly the right
> approach. And then just getting rid of iowait completely on the io_uring
> side. This can be done without preaching about iowait to everyone that
> has bad metrics for their healt monitoring, which is why I like that a
> lot. I did ponder that the other day as well.
> 
> You still kind of run into a problem with that in terms of when short vs
> long waits are expected. On the io_uring side, we use the "do I have
> any requests pending" for that, which is obviously not fine grained
> enough. We could apply it on just "do I have any requests against
> regular files" instead, which would then translate to needing further
> tracking on our side. Probably fine to just apply it for the existing
> logic, imho.

Let's say there are two problems, one is the accounting mess, which
is IMHO clear. The second is the optimisation, which is not mentioned
in the patch and kind of an orthogonal issue. If we want a knob to
disable/enable the cpufreq thing, it should be separate from iowait
accounting, because it sounds like a really unfortunate side effect
when you enable the optimisation and the iowait goes pounding the roof.
Then people never touch it, especially in a framework, because an
system admin will be pretty surprised by the metric.

Not like I'm a fan of the idea of having a userspace knob for the
optimisation, it'd be pretty complicated to use, and hopefully there
is a more intelligent approach.


-- 
Pavel Begunkov

