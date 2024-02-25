Return-Path: <io-uring+bounces-717-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B31D862BCE
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 17:43:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 939B01F21256
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 16:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B7AD13AEE;
	Sun, 25 Feb 2024 16:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="p6e9dRyg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40B112E71
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 16:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708879429; cv=none; b=o4i4SnlHjF9ZdLR5bkgviTGSq2fy4Nxzr+1UOrYxQRRXC+OmdRijhBtgYqC90Y21eeCR060qd6NroaAr1zpdYG9d/+v2+EfpgeRoGbttyVLhWaH8Gw7zDn7LHQ6egZqBuQene3cLTP8FQzlwBw9T+ivk2Op/TF1zMQWMqem7ybs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708879429; c=relaxed/simple;
	bh=sVlJ2KFOPAqdJors258SrkclYffrvu/c4DlqGxtZBrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=apbuviNoshjvE+l0Iwdhc0x5xJ7oWFD2HAMOP31fQ/ioq9Edivu74solll46iqBP4VCHx2BD+//vjsNjC6Om04z4ri0ZiynEoCKlT2R9LhUI9EtH5p0bc0KPDzgIg+KcxM0U1WzXY5u5zmCdrCPHgGnf2PVO0pBAx0cB2w67Ldg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=p6e9dRyg; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so1047005a12.0
        for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 08:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708879426; x=1709484226; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7eWccaP1/dn7dYx1f8shNIzbGeQR8KofumnXlosKSlM=;
        b=p6e9dRyghzVc7nC8yTS/bQ/o2M8e426eNZL11hpj1xfxiC1T8f+sV+c93v+pEc9n4F
         RLFkHUl9St3MeoWCwNPiL5i+Ka5yJyR0QUXbYJQSlUVfNg/BPUMVRdOIWF1sBKKxgsVq
         TjAgIE0yWLEq6X/5tAate3Cd4nKbszxvViYu4WhXjOHyWYS24UTGpKqb5mChMypIanQi
         rUZPGOfgSv3XSw5bZRP2vUjTgA2zdd8wlobFm+dyeHrRpFu2I4temg4xYMP3fTNRKUH2
         6iDso7ygIamUyoFftbF60Eh1H89jRJZsWwH2IKfOnSIzVPjLcoh3DNBSP8QYaAGAQ6Kp
         j8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708879426; x=1709484226;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7eWccaP1/dn7dYx1f8shNIzbGeQR8KofumnXlosKSlM=;
        b=O+sQSLFuWwyMyc6+pL3PiEEfdcmyDEBq9OgQGZE5Y23hwidSLFbiDRk7ExIfIfpqWH
         568IAHG5QNLaTOsC3++3VTUAPIS4t2W5r+QdwLW9syNEFEgOAvLJTfxpExJ39FfGuuKN
         qkEELyphp/pQhQFDcRkIdxFYt/XRRwps/TYRz5NKTcd7prSf5qIr/bjHCaL4C0uLcQ5O
         La24wSlrYCCREzeVO4VpoDPsZ5dQkC/qBv8jC7qNQ8u23Sh7a9aJu+oZ1k7H1Z51kfyh
         H4LNkHUK6z1hpfnjzcRJAROWZlCsSY8GHJhE55s6M4AhdVw7pn/2JRFOPGoYI1E7qFTf
         FHoA==
X-Forwarded-Encrypted: i=1; AJvYcCX2oMaaZtKnX177zqFAZA6j14fqBO2psLp6r9V+8JQQgFdijs1fR9s01RjyDHK5sOvjQfnjNELUDO2XvRG4XeITcm3TD6ZoMaU=
X-Gm-Message-State: AOJu0YwLGl8moQtfPKNl+8Tc7r8G4IhoGDRFFbGchyJZ2rmE4JtR8Q8y
	WvL+tZoJN+jjJ5HrP2k2i/KQ5fm+03bqgWuzjQF8vPLftIofRlYIWovW3HKjQy4=
X-Google-Smtp-Source: AGHT+IEv35baFdNk3dmZwR9SHASBPEpnbm/FnPzyq8BB4pPJgRf7WZryIQje7RDW/g2d5757ZN+H/Q==
X-Received: by 2002:a17:902:c184:b0:1dc:2be8:f61a with SMTP id d4-20020a170902c18400b001dc2be8f61amr5712708pld.2.1708879426049;
        Sun, 25 Feb 2024 08:43:46 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902ef0400b001db8145a1a2sm2441210plx.274.2024.02.25.08.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Feb 2024 08:43:45 -0800 (PST)
Message-ID: <a5fc01ba-d023-4f02-acb1-fa1d3cfbff2d@kernel.dk>
Date: Sun, 25 Feb 2024 09:43:44 -0700
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
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20240224050735.1759733-1-dw@davidwei.uk>
 <678382b5-0448-4f4d-b7b7-8df7592d77a4@gmail.com>
 <2106a112-35ca-4e02-a501-546f8d734103@davidwei.uk>
 <cf1f03ce-352b-4a61-a595-d595413bc831@kernel.dk>
 <8dc18842-bb1b-4565-ab98-427cbd07542b@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8dc18842-bb1b-4565-ab98-427cbd07542b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/24/24 6:39 PM, Pavel Begunkov wrote:
> On 2/24/24 18:55, Jens Axboe wrote:
>> On 2/24/24 10:20 AM, David Wei wrote:
>>>> I don't believe it's a sane approach. I think we agree that per
>>>> cpu iowait is a silly and misleading metric. I have hard time to
>>>> define what it is, and I'm sure most probably people complaining
>>>> wouldn't be able to tell as well. Now we're taking that metric
>>>> and expose even more knobs to userspace.
>>>>
>>>> Another argument against is that per ctx is not the right place
>>>> to have it. It's a system metric, and you can imagine some system
>>>> admin looking for it. Even in cases when had some meaning w/o
>>>> io_uring now without looking at what flags io_uring has it's
>>>> completely meaningless, and it's too much to ask.>
>>>> I don't understand why people freak out at seeing hi iowait,
>>>> IMHO it perfectly fits the definition of io_uring waiting for
>>>> IO / completions, but at this point it might be better to just
>>>> revert it to the old behaviour of not reporting iowait at all.
>>>
>>> Irrespective of how misleading iowait is, many tools include it in its
>>> CPU util/load calculations and users then use those metrics for e.g.
>>> load balancing. In situations with storage workloads, iowait can be
>>> useful even if its usefulness is limited. The problem that this patch is
>>> trying to resolve is in mixed storage/network workloads on the same
>>> system, where iowait has some usefulness (due to storage workloads)
>>> _but_ I don't want network workloads contributing to the metric.
>>>
>>> This does put the onus on userspace to do the right thing - decide
>>> whether iowait makes sense for a workload or not. I don't have enough
>>> kernel experience to know whether this expectation is realistic or not.
>>> But, it is turned off by default so if userspace does not set it (which
>>> seems like the most likely thing) then iowait accounting is off just
>>> like the old behaviour. Perhaps we need to make it clearer to storage
>>> use-cases to turn it on in order to get the optimisation?
>>
>> Personally I don't care too much about per-ctx iowait, I don't think
>> it's an issue at all. Fact is, most workloads that do storage and
>> networking would likely use a ring for each. And if they do mix, then
>> just pick if you care about iowait or not. Long term, would the toggle
> 
> Let's say you want the optimisation, but don't want to screw up system
> iowait stats because as we've seen there will be people complaining.
> What do you do? 99% of frameworks and libraries would never enable it,
> which is a shame. If it's some container hosting, the vendors might
> start complaining, especially since it's inconsistent and depends on
> the user, then we might need to blacklist it globally. Then the cases
> when you control the entire stack, you need to tell people from other
> teams and PEs that it's how it is.

I suspect the best way would be to leave it as-is, eg iowait is on by
default. That way if people start noticing they will look around, find
the knob, an tweak it. For a pure storage kind of workload, people are
used to iowait and they will probably think nothing of it. For a pure
networking workload, people might find it odd and that'll trigger the
incentive to start searching for it and then they will pretty quickly
figure out how to turn it off.

>> iowait thing most likely just go away? Yep it would. But it's not like
> 
> I predict that with enough time if you'd try to root it out
> there will be someone complaining that iowait is unexpectedly
> 0, it's a regression please return the flag back. I doubt it
> would just go away, but probably depends on the timeline.

Right, so just keep it as-is by default.

>> it's any kind of maintenance burden. tldr - if we can do cpufreq
> 
> ala death from thousand useless apis nobody cares about
> nor truly understands.

Let's be real, some toggle function isn't really going to cause any
maintenance burden going forward. It's not like it's a complicated API.
If it rots in a corner years from now, which I hope it will, it won't
really add any burden on maintainers. It'll most likely never get
touched again once it has landed.

>> boosting easily on waits without adding iowait to the mix, then that'd
>> be great and we can just do that. If not, let's add the iowait toggle
>> and just be done with it.
>>
>>>> And if we want to save the cpu freq iowait optimisation, we
>>>> should just split notion of iowait reporting and iowait cpufreq
>>>> tuning.
>>>
>>> Yeah, that could be an option. I'll take a look at it.
>>
>> It'd be trivial to do, only issue I see is that it'd require another set
>> of per-runqueue atomics to count for short waits on top of the
>> nr_iowaits we already do. I doubt the scheduling side will be receptive
>> to that.
> 
> Looked it up, sounds unfortunate, but also seems like the
> status quo can be optimised with an additional cpu local
> var.

If you are motivated, please dig into it. If not, I guess I will take a
look this week. 

-- 
Jens Axboe


