Return-Path: <io-uring+bounces-12475-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2H3iA4wYomnFzAQAu9opvQ
	(envelope-from <io-uring+bounces-12475-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:19:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F27E1BE9FA
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:19:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BFFD6302BBD4
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 22:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4E4C2BD033;
	Fri, 27 Feb 2026 22:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dAWaqybK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C2425B1D2
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 22:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772230793; cv=none; b=HUO2AImRirIOUm7tTYMsIE1U5BWjlx+ycWlEnZp+V3Ewrg2N9AUNLASaWhJZqJUMRt0nBtL5r6B/aJVPvn8lbAo91DPehNgvbSZfj+V9JFTEMcdFjrKvjk4q70gzuy0qmdcpb6bfWgg78V+6jmgmfLVEdMq5tlaa/3QhBu0Wq5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772230793; c=relaxed/simple;
	bh=1RH/a0DIRBIeCU/QEcemQhtCL97EhKi7WvoWjYL/IfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nzr46k6zw0DboXpsg4L/7Z6rvfa0n/3aPnUNS7bqiFnpGZrkb2n3Vj9ZWJr9xijzJJSkxiS2BJZnUY9brv/I2Ifjf6EsGz3wpb7tiMwG3jnvhiJCG3ND3bGDgsZ9QmaAZ16rAGmcFXIFIYuqwoqdvjCNVFUzkiFvlp6wFqClByM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dAWaqybK; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7d4c68f0e47so1587930a34.1
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 14:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772230789; x=1772835589; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5gJtMDFjAgvxZGs57XjY7x6lRNuo04z6xXJD76j2pKw=;
        b=dAWaqybKsNDXs/tG9lc4osJRrfixtaHbByqTOh0OyNmzsZgo9wXo750sjPNZTVmNfa
         QUFjfgS/aMf5G+nNhN7e5E0C6kNk9QszENpBrl5GpUrUDiVAaRf1YxQsqCSjWEhbAI4i
         8vYPKTZP7iVjuWxdfp6RpdvTQYRUZyq9c4I1fNjc9kfg/FufFrm3502T9TFfFYvp2Y3j
         ACigGwgDre5TKAfLxWHDqDwMWzwW79AyXp7SUfmjh72wIkyxctMLzFwj72qA/cXJ6Olk
         J0zYni1Jx4vDN7EPFTGLn8X6I4pnsN11iL9rhl5STYv7WY4a/DfCLEpxpKOOKQGTnxjD
         gfyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772230789; x=1772835589;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5gJtMDFjAgvxZGs57XjY7x6lRNuo04z6xXJD76j2pKw=;
        b=RtOIswWV62w5CJvctqSgu6ooi1/N9Z7YeVarOs5tpDJyD2u256DBRuM7JOmR00jd4B
         vZOiyjTM5rwB5z+WKnE1odOrk/zXo5+MbAFYm9+AmT4H7EhLODCX0Ua7d9i7jZc8KXzn
         HY+e7gtrDlwmAApl3garODxl8gkDkptfHKULXwxGfP7uhq+9WuZHfwQ1yoJBMAzgERUJ
         H7vTYX2SvmMzpNxW+1jm8IGH+kJMVkwVQMZQfHEB8iJyP2Uy6xq9WzLidGEXX9jGtheG
         5HcqzasZOE8ZhkdRz/iVr90vDFUWslkmbPkdmVMpWYgg3ycTYuGYIldwwLvXFdNt6LnZ
         iIrA==
X-Forwarded-Encrypted: i=1; AJvYcCWXrUkuzpRRGEZeu63QmUgZ7z8SiEcb5IxlREQqptq+JKkx8HYz9ZV+/zWIm+N8AEPnvb7MYbjo8A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2bA+K4trByJiWFwKW/0IcU/Mjfdb45GC9SPHuT5kdVdLABNlU
	y6e1MBgqxf0ZAvdZuSREGnPjQVr1ZT+YKBcWoh/KiZYlhBWXCwjr8j4NHKzysolZem/cBvrDLzM
	17QP2ev8=
X-Gm-Gg: ATEYQzxr6XU0cpY4o3apZRy1hrii0MlsDGquvQK1q1whOInsf6UIrevO4h2B4mRKOhS
	uiOGE+rt0lqya+oSGPCT+2jmnM+0PT8yVv8TenA+mjzNCq5KzRHn9PGZQACmlO4wilQ7tCNFXen
	5zz6dn0+4ReXxYjApziPZjOT8NtJ7WiNKGBJO/JO8v7YpmvBTVYDZwi1V6yyJtyW4lVwoykIjfm
	PHn8qOUWVEvWHt68IX9GDOdPaanax3NTNy41P75CNsWAmLxYobY8HYVkqFSbvDJ4ifnYnVApXGX
	3svEgLZdeYZqnXocS9YrcgFjuMGB5Tr37sbrtXgxcX8J1gz4t0ehrXJQ0iuRttEwaf0oqo26R+j
	UyYG8n5g9E07kiHUr5vRvHoP3fs2V4X99mxmJByVNNsmLasMKl/ypXui7oKzzLoosRDnt1Oehb7
	/P2G31FM9qHeLuSTTVswJoiemBbDZBfbw2bD3kHRJrNWbd9WvzWYonnv31tpIkIaocGAhpajp2Q
	ZtAJdCOxA==
X-Received: by 2002:a05:6830:67ef:b0:7cf:e41d:f0b0 with SMTP id 46e09a7af769-7d591bd0edamr3076884a34.18.1772230789421;
        Fri, 27 Feb 2026 14:19:49 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d5866541fcsm5147834a34.21.2026.02.27.14.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 14:19:48 -0800 (PST)
Message-ID: <3a8e5738-b417-440a-9851-b8ecc2a82b82@kernel.dk>
Date: Fri, 27 Feb 2026 15:19:48 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
To: Pavel Begunkov <asml.silence@gmail.com>,
 Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <cover.1772015321.git.asml.silence@gmail.com>
 <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
 <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
 <a6cbceb5-2065-42ff-bcca-bdb1c2443b96@gmail.com>
 <1cd9a071-dc93-48d1-81c9-24b65e65e8bf@kernel.dk>
 <dcb21382-36a6-4d5b-8e79-66290e522f2c@gmail.com>
 <2daa9b01-d989-4922-b892-e7f3f06297ac@kernel.dk>
 <cc9ba4b8-88f1-48c9-8aae-fe30a6b5c282@gmail.com>
 <e834eb01-6cde-4249-a797-ed1fd9f8c713@kernel.dk>
 <2ab205f2-fd87-4fcc-9c0a-0bdebbadeb58@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2ab205f2-fd87-4fcc-9c0a-0bdebbadeb58@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12475-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,samba.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 8F27E1BE9FA
X-Rspamd-Action: no action

On 2/27/26 3:10 PM, Pavel Begunkov wrote:
> On 2/27/26 21:17, Jens Axboe wrote:
>> On 2/27/26 2:09 PM, Pavel Begunkov wrote:
>>> On 2/27/26 20:19, Jens Axboe wrote:
>>>> On 2/27/26 1:03 PM, Pavel Begunkov wrote:
>>>>> On 2/27/26 19:39, Jens Axboe wrote:
>>> ...
>>>>>> I don't think it's about length of it - if you can avoid the div by
>>>>>> doing ns_to_timespec64(), that might be very useful? Would make
>>>>>
>>>>> hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), mode);
>>>>>                                      ^^^
>>>>>
>>>>> io_uring just needs to flip it and use ktime, but I left it for later.
>>>>
>>>> I think we should go all the way with this if we're doing the immediate
>>>> mode. And I do think that is a good idea. Doing a half-way thing doesn't
>>>> make much sense to me.
>>>
>>> One time people will tell you don't do premature optimisations,
>>> merge the main thing first, another time it's the other way around,
>>> you can never guess.
>>
>> IMHO this isn't premature optimization, it's more about just doing it
>> right in the first place.
>>
>>> In either case, it's useful by itself. Div is not that expensive
>>> to be a break dealer, and div by constant will usually get
>>> replaced with a mul by modern compilers.
>>
>> Agree, and that's likely what it does here. It's just why not avoid it
>> in the first place if possible. That's not premature optimization.
> 
> I think uapi should come first before we waste time on making
> internals one way or another.

Yep agree, which is really what this reply thread is mostly about - the
user API.

>>>>>> userspace simpler too potentially, and basically make the immediate mode
>>>>>> _exactly_ the same as the non-immediate mode, it just delivers the
>>>>>> __kernel_timespec in a different way.
>>>>>
>>>>> I very much want to believe that everything about kernel_timespec has
>>>>> some deep meaning, but I fail to see why they split it as sec/ns and
>>>>> left invalid ranges for ns, why ns is signed, and why even after a
>>>>> large revamp one of the fields doesn't use a fixed width type.
>>>>> I'm not sure exactly like it is actually a good idea.
>>>>
>>>> But that's the API for anything timing related, whether it be timeval,
>>>> timespec, or __kernel_timespec the latter obviously only existing
>>>> because everybody else could not be bothered to do a proper 32 vs 64-bit
>>>> agnostic type before. Hence that's the API that people know and use,
>>>> there's no deeper meaning other than that. And I agree, it's kind of
>>>> crap in how you can have an invalid range and it gets masked.
>>>>
>>>> It's like like I'm a huge __kernel_timespec fan, but for consistency's
>>>> sake, I do like it. With a clock source, then it does start to make
>>>> sense.
>>>
>>> What's about clock source? I'm curious
>>
>> Just that timespec/timeval/whatever usually go with a clocksource, vs
>> some isolated nsec value.
> 
> They're orthogonal though, timeout requests also support clock
> sources.

Sure, it's just less natural that way. At least imho.

>>>> Not that I think there's a lot of ABS use cases, I'd expect
>>>> relative to be what people generally use here. But at least then the
>>>
>>> It's probably common enough. Not the "wake me on Monday at 5am" kind,
>>> but rather get the current time and then recalculating intervals
>>> from it. Would be nice to return the wake up time as well in a CQE,
>>> if only it was free.
>>
>> Yeah could be, it's always hard to know. Which is why it's nice to error
>> on the side of "let's just support both upfront" if it's feasible.
>>
>>>> IMMED API addition will just work regardless of what you do in the app.
>>>> That's better than someone a few revisions later than saying "hey that's
>>>> cool, can we do ABS too which I use because of X and Y" and then having
>>>> to hack that on top.
>>>
>>> Hack it up in the user program? I didn't get it.
>>
>> No, I mean needing to retrofit ABS support on the kernel side for IMMED
>> up front.
> 
> They should be enabled in the same release, but we've been rather
> discussing the way to do that. I was saying that u64 is enough to
> pass the abs timeout value, and we can extend it to another u64 if
> needed in several centuries from now. And it's not a bad option
> because plain u64 ns makes much much more sense for the relative
> mode. And even for the abs scenario above, I'd prefer that rather
> than doing second adjustments every single time.

ABS makes very little sense as nanoseconds, that's pretty confusing on
the userspace side. That's the main issue.

I'm not sure why it's such a big deal to just encode the sec/nsec so
that userspace can use it directly from a timespec or timeval which is
most likely what they are querying time from anyway? If you do absolute,
surely you'd do

get_time(&t);
t.tv_sec += 1;

now issue timeout for that. That's a hell of a lot more natural to use
than converting to and from nsecs.

For relative it's obviously not a huge deal, but it'd be nice to keep
them consistent.

-- 
Jens Axboe

