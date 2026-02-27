Return-Path: <io-uring+bounces-12473-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uA3PFQcKomngyQQAu9opvQ
	(envelope-from <io-uring+bounces-12473-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 22:17:59 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B9A731BE20F
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 22:17:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 94CBB30120CA
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 21:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F039A361DC8;
	Fri, 27 Feb 2026 21:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sjeufmSv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFF53451CC
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 21:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772227076; cv=none; b=Rj9ziMVpbH11w91e29+3cqTB8H5rK2+YPO9qxO13aceRFXAj8ThDlpUHPcTD9HPLkBnpTcqgQ+UNYW/KFQ9GTjxPu9n51wkB0iLSbMtNtfyq6jSvp1ezxtFNWdcV5EE5NEVM0BK7MCbDG+QvMQnvHlI0QMnEQ3w+CA/548Al6H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772227076; c=relaxed/simple;
	bh=gzoX54N+IqFF5kH/Ge3+AjgwX1msPUpuREub1J575DI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L2rg3SfH/qnJTRBkbcmWJFd3KEMbMoVNn+WtV1z5UJyROZXziuKbXpb0ALqSdDZlNcf7igFQpDNCbES1oSQfvY/xtnujqlZQxX8j1jC5trGlS4HqJDYackFkS+vjtgbEZzwr6lHYFWsrYORmoYUjTCAjZJLH+kYoXPshYBaE1+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sjeufmSv; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d18f80b5c2so760460a34.3
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 13:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772227073; x=1772831873; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TsNvrCoDCr6JEHvvMUk0h7WH+oaecqG/QPmYtOVAsLc=;
        b=sjeufmSvR7MVkIdIBm5n4NwEZ+v0w+hG9BnYq3McnB9dJpdOYhIGRXpOBRS6KQ8+Hb
         GQXDMI8F+KpDuk8ppDWjuup1XE+fZKiuzwQTcQhHQNMIJ0Fw+xHhDS9fKdpE97796660
         fznlG3Mqrty2Mw/rtqOcAT4ex/7tZl205fJvEgoRZSZhOgRNFDTaXHI1U7PDeNNjhvhP
         95Ath2C34hl3BSHMB2udU6b4Lbpm6glKVHFUrenLBPMjU7V2VZenj5JLLH7KDG1xgzei
         gpNZrrXqqSzK6x9Vv1Of8tG6IzsMQ782mXSZas1qROYxr9CZefdRw+HbrUmxkf4V4mKW
         c4bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772227073; x=1772831873;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TsNvrCoDCr6JEHvvMUk0h7WH+oaecqG/QPmYtOVAsLc=;
        b=cgtIoZP7OPwhf3VusdYDZqoXr/0EtaUXam+HmnVGb/frXUn2PUJHjNYEiYwUyh/eRa
         q4A35zuBxcUgOrbPHdHeECgjF0rzs9GKi7nwcDQILL4L4Qlj4+tpK94UZlBTr3RO4qj1
         2regr0033Ixz61cGXTVFw/9GWfnJpKJQeFJIVmzV/j+zucbHLyfC5VHP16SEFy23A0w7
         3EWhMdKjw+ckxTMh6pwfI6LkdR5GjHCq+8nLqAFqsMeFh+QItJC5+QpOnbUzivV+NhH3
         3ustVC9UCcZn/DOgb2Vf3tDOPfFMK00rSgxcUDRRUdfb8ETOTPEUWRtIFtvIJtlHycgq
         LrsA==
X-Forwarded-Encrypted: i=1; AJvYcCX3lnNRCb5thLJ4CyzKD6BzhuJUSpAllQE/fdWJXH84OFX1zDoo/WNBTUzhR+Ga0GpS4CnHeZZ/uw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxuu3ep4bN9X3HBAPv6aRIt/VZ0pu+2rG8tBdY26OghRkmaaewb
	sedU2sgBIJoAcnxdGOD6/NjeS34K0tmP3Ga8m85dIpoDk+FAptsntE6Pu59xt3fig3VRP5yeeDd
	hCg+h+lI=
X-Gm-Gg: ATEYQzwjp0O/KyipRtSzuAmLmc4ZEe6lR2bDPZEMGOLH/eAjC8MTjxM+z0OETK9vrsp
	nyU4uCYvmQqPfGW1p6yKuGG+4RZkVoGAKg+svYA5Iv0+s3n0HOVqTTmd8E4CJ7Zba5O/Gbvywoy
	Ro+LU11IkNoAK+9vpnia0rbFCOfpZI+nxKDsK4iBoFW3YMh+98LLzWdJ1OaGLBuW5LNuXFGf+8N
	fwBlOfl2Cgikz88NtOjZVQGAHYzvI7/7nlnyPcPguGYO/vcjJzchRGbGzzbM2R1tDIkLweqyqjs
	41ojjdmjzxEbwcscAAxta1JHlFNM8QY7poIlgSyymVYGhS8/aVvom0IHJp7ZtPTHZqNpPqxCyuM
	8VsaDbvTR/jBFsehx972VCWBRdebH+9UILoFldyc9RyXAreFwwgbWlDL3mphKNgwtdBo1WlK8CJ
	1FpbBRBT84rwcdO7AvnmDbBV8Gtr7EBNfkGnEoLo2mm0nh+WSkD9vPjQHmNwhooNWBhMfs+10sf
	BrULi5kQA==
X-Received: by 2002:a05:6830:8297:b0:7d1:90d6:3ee with SMTP id 46e09a7af769-7d591b269e1mr3391433a34.8.1772227073147;
        Fri, 27 Feb 2026 13:17:53 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d586653f6asm5282136a34.19.2026.02.27.13.17.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 13:17:52 -0800 (PST)
Message-ID: <e834eb01-6cde-4249-a797-ed1fd9f8c713@kernel.dk>
Date: Fri, 27 Feb 2026 14:17:51 -0700
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cc9ba4b8-88f1-48c9-8aae-fe30a6b5c282@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12473-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,samba.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B9A731BE20F
X-Rspamd-Action: no action

On 2/27/26 2:09 PM, Pavel Begunkov wrote:
> On 2/27/26 20:19, Jens Axboe wrote:
>> On 2/27/26 1:03 PM, Pavel Begunkov wrote:
>>> On 2/27/26 19:39, Jens Axboe wrote:
> ...
>>>> I don't think it's about length of it - if you can avoid the div by
>>>> doing ns_to_timespec64(), that might be very useful? Would make
>>>
>>> hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), mode);
>>>                                     ^^^
>>>
>>> io_uring just needs to flip it and use ktime, but I left it for later.
>>
>> I think we should go all the way with this if we're doing the immediate
>> mode. And I do think that is a good idea. Doing a half-way thing doesn't
>> make much sense to me.
> 
> One time people will tell you don't do premature optimisations,
> merge the main thing first, another time it's the other way around,
> you can never guess.

IMHO this isn't premature optimization, it's more about just doing it
right in the first place.

> In either case, it's useful by itself. Div is not that expensive
> to be a break dealer, and div by constant will usually get
> replaced with a mul by modern compilers.

Agree, and that's likely what it does here. It's just why not avoid it
in the first place if possible. That's not premature optimization.

>>>> userspace simpler too potentially, and basically make the immediate mode
>>>> _exactly_ the same as the non-immediate mode, it just delivers the
>>>> __kernel_timespec in a different way.
>>>
>>> I very much want to believe that everything about kernel_timespec has
>>> some deep meaning, but I fail to see why they split it as sec/ns and
>>> left invalid ranges for ns, why ns is signed, and why even after a
>>> large revamp one of the fields doesn't use a fixed width type.
>>> I'm not sure exactly like it is actually a good idea.
>>
>> But that's the API for anything timing related, whether it be timeval,
>> timespec, or __kernel_timespec the latter obviously only existing
>> because everybody else could not be bothered to do a proper 32 vs 64-bit
>> agnostic type before. Hence that's the API that people know and use,
>> there's no deeper meaning other than that. And I agree, it's kind of
>> crap in how you can have an invalid range and it gets masked.
>>
>> It's like like I'm a huge __kernel_timespec fan, but for consistency's
>> sake, I do like it. With a clock source, then it does start to make
>> sense. 
> 
> What's about clock source? I'm curious

Just that timespec/timeval/whatever usually go with a clocksource, vs
some isolated nsec value.

>> Not that I think there's a lot of ABS use cases, I'd expect
>> relative to be what people generally use here. But at least then the
> 
> It's probably common enough. Not the "wake me on Monday at 5am" kind,
> but rather get the current time and then recalculating intervals
> from it. Would be nice to return the wake up time as well in a CQE,
> if only it was free.

Yeah could be, it's always hard to know. Which is why it's nice to error
on the side of "let's just support both upfront" if it's feasible.

>> IMMED API addition will just work regardless of what you do in the app.
>> That's better than someone a few revisions later than saying "hey that's
>> cool, can we do ABS too which I use because of X and Y" and then having
>> to hack that on top.
> 
> Hack it up in the user program? I didn't get it.

No, I mean needing to retrofit ABS support on the kernel side for IMMED
up front.

-- 
Jens Axboe

