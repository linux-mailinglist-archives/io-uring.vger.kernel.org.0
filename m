Return-Path: <io-uring+bounces-711-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE618628C0
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 02:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0ED5281DC7
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 01:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D52601361;
	Sun, 25 Feb 2024 01:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WfP56T1r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106E11109
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 01:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708826210; cv=none; b=p8XqILd2zdIjevQb3nZgY3jlxTlWZVhyFhL14mMYXG4Ho+ttODz/oBC3WTYKEyQIH9T9pVwIgxpED6KB0mF+pLwm8qtvRPvd8Mdd4shXNwS83BT1AprrGa61eFtrwP5BHNb6c1pww/wW9GUSDC3x/tYRg+aTUJwF+JvRXQRHGKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708826210; c=relaxed/simple;
	bh=NLG8xKBh3VaZxeinSguEaOWk1a76sXl7d2aNlLW/1P8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hCvxP8wrkW1KvGlhnAbB5pesW/pWmoaC/ao/mpaimRV+fY6sFjcXKQbe65muxbsExC+rxguPlQGYq2s+ArD2IsrcK7fkADUfCuyDxm/h9BRg60TlmHx4NlGdz+5T1N5cReGw+51/bTU+tOhkZC0cAeL3bafoXHasRUCJN1sztgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WfP56T1r; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a3e5d82ad86so283095766b.2
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 17:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708826207; x=1709431007; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/RX1CxQabEAeBVFeISqA5nC33PixG5iSlfVfvHZ5PLw=;
        b=WfP56T1rWV/FFX4J0pR3Yzm8Y65rErJUc/I5+KGKpQV/jo75v2F//r9VzGkgnKQYpX
         eX6jD377JJotgISm1BIzydUGCMJU9DGGTXwuZJBtGxI3TV3XjR1vtGhYcgn6dJtRskun
         YsS57d3osrpXb+g8FualNhxdDWR6iPTEyk3FtlA1+2+Z8f4Jrn+Irl1Mh+jDVrQSZZ8w
         dmhDwMJjK0cSnA9+HFTN3CDILDauFz2TypibKVeqIuptMKUmORMUb+sJC14i8x+Fux7H
         ZqlXHhiKylSqjRbGGCRq3dOPQ5860RwdWm5S3coAZFBj+42QwMeaYFblDBG5QH4TuD8p
         tmpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708826207; x=1709431007;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/RX1CxQabEAeBVFeISqA5nC33PixG5iSlfVfvHZ5PLw=;
        b=OoFPszhKwyI5vanQo4fmDL+zQFSMv9OqF+6bUEOqzw8crWZR6lgBJbFg7o6A/8TdMV
         2jTXuVPev7lnbkHSZrdxuH+Adf9KsuZY43chmjgiuurI19TKg3TS/OeI5SFmnbFAboKW
         PC2b+2MoNYcTuQEpMFOGN1VCZ40FC8+5KUTWO3BratcJCxra72albPM5g/JgHO3MwDkX
         WkZEHyGq9Qze2SF/niZu2ysHFgpMppWV2AcXaMlomJirLGANXsHKKaFYo9trnyyFqVUB
         GO7wGmjHRziEdfuvtNsztZW+F7pJwYf/kIqjoud5HIQNmSqq/FY+YRNCRedYJsNrjMoP
         WldA==
X-Forwarded-Encrypted: i=1; AJvYcCWAxVuus0KXkVFayDdL+yP21MEqyMr7Hahip/0CQkBG1TsAZNmfYP2tswzJE1ifFRI3BqzWSwnoruQL0gw1uUzkY/LqYY81Tjc=
X-Gm-Message-State: AOJu0YwHbbDL7Kii90/hieGUtInOBtuChiiUfFZC1dPXfCplweB+KzTo
	seSz7g9nqNt0HNNULvvGeHWWYmJM9rR9AO8k80Q0v5/FnrKZej+rCdahGptI
X-Google-Smtp-Source: AGHT+IF5akzIrmRhcCYNkM3dC1FA/Fqjs6Snx0dCEXA28R8x6ZzcWdIiPHUPpNyFlJoe9L69OBI2Ag==
X-Received: by 2002:a17:906:d9c3:b0:a3f:64ce:3a98 with SMTP id qk3-20020a170906d9c300b00a3f64ce3a98mr1944382ejb.10.1708826207306;
        Sat, 24 Feb 2024 17:56:47 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.140])
        by smtp.gmail.com with ESMTPSA id v14-20020a170906180e00b00a3efce660b7sm1054133eje.190.2024.02.24.17.56.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Feb 2024 17:56:46 -0800 (PST)
Message-ID: <8dc18842-bb1b-4565-ab98-427cbd07542b@gmail.com>
Date: Sun, 25 Feb 2024 01:39:06 +0000
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
 <2106a112-35ca-4e02-a501-546f8d734103@davidwei.uk>
 <cf1f03ce-352b-4a61-a595-d595413bc831@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cf1f03ce-352b-4a61-a595-d595413bc831@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/24 18:55, Jens Axboe wrote:
> On 2/24/24 10:20 AM, David Wei wrote:
>>> I don't believe it's a sane approach. I think we agree that per
>>> cpu iowait is a silly and misleading metric. I have hard time to
>>> define what it is, and I'm sure most probably people complaining
>>> wouldn't be able to tell as well. Now we're taking that metric
>>> and expose even more knobs to userspace.
>>>
>>> Another argument against is that per ctx is not the right place
>>> to have it. It's a system metric, and you can imagine some system
>>> admin looking for it. Even in cases when had some meaning w/o
>>> io_uring now without looking at what flags io_uring has it's
>>> completely meaningless, and it's too much to ask.>
>>> I don't understand why people freak out at seeing hi iowait,
>>> IMHO it perfectly fits the definition of io_uring waiting for
>>> IO / completions, but at this point it might be better to just
>>> revert it to the old behaviour of not reporting iowait at all.
>>
>> Irrespective of how misleading iowait is, many tools include it in its
>> CPU util/load calculations and users then use those metrics for e.g.
>> load balancing. In situations with storage workloads, iowait can be
>> useful even if its usefulness is limited. The problem that this patch is
>> trying to resolve is in mixed storage/network workloads on the same
>> system, where iowait has some usefulness (due to storage workloads)
>> _but_ I don't want network workloads contributing to the metric.
>>
>> This does put the onus on userspace to do the right thing - decide
>> whether iowait makes sense for a workload or not. I don't have enough
>> kernel experience to know whether this expectation is realistic or not.
>> But, it is turned off by default so if userspace does not set it (which
>> seems like the most likely thing) then iowait accounting is off just
>> like the old behaviour. Perhaps we need to make it clearer to storage
>> use-cases to turn it on in order to get the optimisation?
> 
> Personally I don't care too much about per-ctx iowait, I don't think
> it's an issue at all. Fact is, most workloads that do storage and
> networking would likely use a ring for each. And if they do mix, then
> just pick if you care about iowait or not. Long term, would the toggle

Let's say you want the optimisation, but don't want to screw up system
iowait stats because as we've seen there will be people complaining.
What do you do? 99% of frameworks and libraries would never enable it,
which is a shame. If it's some container hosting, the vendors might
start complaining, especially since it's inconsistent and depends on
the user, then we might need to blacklist it globally. Then the cases
when you control the entire stack, you need to tell people from other
teams and PEs that it's how it is.

> iowait thing most likely just go away? Yep it would. But it's not like

I predict that with enough time if you'd try to root it out
there will be someone complaining that iowait is unexpectedly
0, it's a regression please return the flag back. I doubt it
would just go away, but probably depends on the timeline.

> it's any kind of maintenance burden. tldr - if we can do cpufreq

ala death from thousand useless apis nobody cares about
nor truly understands.

> boosting easily on waits without adding iowait to the mix, then that'd
> be great and we can just do that. If not, let's add the iowait toggle
> and just be done with it.
> 
>>> And if we want to save the cpu freq iowait optimisation, we
>>> should just split notion of iowait reporting and iowait cpufreq
>>> tuning.
>>
>> Yeah, that could be an option. I'll take a look at it.
> 
> It'd be trivial to do, only issue I see is that it'd require another set
> of per-runqueue atomics to count for short waits on top of the
> nr_iowaits we already do. I doubt the scheduling side will be receptive
> to that.

Looked it up, sounds unfortunate, but also seems like the
status quo can be optimised with an additional cpu local
var.

-- 
Pavel Begunkov

