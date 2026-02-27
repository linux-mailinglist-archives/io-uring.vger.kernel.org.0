Return-Path: <io-uring+bounces-12474-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mPdAOWUWomnFzAQAu9opvQ
	(envelope-from <io-uring+bounces-12474-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:10:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 665B31BE8BE
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:10:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5472530062F5
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 22:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B2D478845;
	Fri, 27 Feb 2026 22:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CK5wYAwo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F54C4611E1
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 22:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772230207; cv=none; b=DKRnX8+Lws7VuZXGLiuDYkFr5RON9HEjJBLBOJGLBTtvDfuB/4cHeQg9qhoJ5jGo7n1qVosN4+HaZ3oBiR9hDDnF6vZy0kw8nJqD1K4K2PRJETvhP6h1JaYKujD+CFoGJkgZgQ+JK1fGXchGNkDHL2BQdTcFOSiAU8a1N4FDy20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772230207; c=relaxed/simple;
	bh=lawNdtPWyONXbUpPDKexsc11ZxmGazjrqVyUo4ojLRg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MRS33V45P3R6Pkn9Bq2JSNE6X/7QzrU+WU0cC1gZPF0V9BLzboJsZeyCq17LLzlvk3fMBi7FPUbAJB+nkb0UK327FSvGsYFQm3mAk6l2BGAGp7NCx1QKa/chek0LvB1vow9EKTvHcIw0tRcyheHzf6FDBvQqqxGYQ18w/Vb2Ub4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CK5wYAwo; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48379a42f76so19272045e9.0
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 14:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772230204; x=1772835004; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E6TcU0HkjTPm+E1uBFfOcWK9/KmVXaXcOB62n4ts/Wk=;
        b=CK5wYAwogFF4Qvyt+x4aZAF5Bz6mjq6ngU/a2ydkfJAPece5cPgMaJx/Rn/d/7kHP/
         uWGxhK4bOeESeeV2WGAjvJpL4jiPjiW2XzFvgQgVLpHcXBqKTv2gAv68Hy0tvukJXQjY
         UhzeUeCHShCTTPsnL9oJaQ6nVv4L69gIEHbo9TtFnhcbmnNuLCuWpckBHZ77tQKDGZqG
         k9o0Bpb6egeH7a8qOpAhIvbuoFFI85HZeM2SplV/C6vHtjOqpDQyTzlynnXDndOjWR2c
         ZO8qMZ4WY7qxf1Kqpr9rg03XXlIMQhP6CfT0k+pDPQrcMm7/hKUPZ5BX0nCYdSJxrCr2
         0FRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772230204; x=1772835004;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E6TcU0HkjTPm+E1uBFfOcWK9/KmVXaXcOB62n4ts/Wk=;
        b=E4hG8I8E4e5Fzz8Llq7CyudOcHoQdrW8kALI/vtcr3lWZCCDuODGbtGWfzf/NeFcuw
         NOe42lwj3xfGJeQEiga8bXZQar9Feq9bdFaE7NbBPTQocdx1vkeQOGftH8Gw9UFn0xxQ
         xGLnAgCTO6WJ0sJeeB4QPTKQXbb0VwFsTPgIgZoYD1a/3rxMD656nTn3e3sea/IdvyI+
         kTskAnJA9CMRF8kVCq+dEsT64XZYXuW4wxoq4K9g+GiI6Egu5w4lebd7H76fYmQTfNom
         U5FRzDwGLYrODcczMn6A8H4uZAHhl+m9X6i9IQevKTT7ADtjC+EnoUQChcaeau/1cl8Y
         Qndg==
X-Forwarded-Encrypted: i=1; AJvYcCVtQkcti01fWgl+HewrbwSpD00RjEfMDOyYsWaTL3HCIieYSY7ILXltCrBgEWSLaoIX3cIEN/WXBw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd1K3lqRM6qoorgll59ahCEfJ+tA18B7+/hJ6ol1Kr2b0mtdDl
	N8nYod08F7DfopmnPl7wozsbMTmPZHWVTUsdNPTtxDMcsrJeplkXXQOu
X-Gm-Gg: ATEYQzyUeXjScrJCqehjdMrVqPQY7YMdgrh594LGgMWDnzsENGQA6VTke7uK0yYSCTy
	paWwUV+7/zsx/gSHWJgcyxzlQJ5vb+05jXwWJ7p7b4idmqWSh2fgG/up4rPiiBzpMw/rAsfKMTU
	jwVi4xl/mx5TH4t3sXieZPfrWE94UJ50u3T3I9f0KEczH0Vy0adqL1bUu6A8GShPh0E//Tt69u2
	WLUOYiHlfoGwjiUSfhh+x8Om/T6tljxQtF+MHMIvLPfq6ukrGyb9h6KhFw5kI3p83m8/WzgEkBd
	dt5JChS7QHUMmWhzkZx9f15Deb5QJb5Dn/EFOjd5GNOC3JV2/zCF5j8QILYNAtvPDPwtJIXZZAd
	vk8s1vBLT1Rb7Nya1k7rK0XvyYeyEWeFT7NCX/29maYEVkA1Up2pBFAb4/idJzqc13R3VRY/KCo
	O7moWLETrWNxXHy5rkG6vm96x8UVcpCQbL5+EW4Ga+fY50wFjvfG4Hd9+a5qHVgGEQ5djttkmvA
	2F4Oe0lqdSOe2ZO8jqVSKIvUtniFQJr7y9s03+0q5MI9qG7TTU+5XjV37lmaPF2H6PoWboqV/to
	qm9P2f/+94/R
X-Received: by 2002:a05:600c:3e0c:b0:480:4d38:7abc with SMTP id 5b1f17b1804b1-483c9bbcdf3mr64427115e9.11.1772230204316;
        Fri, 27 Feb 2026 14:10:04 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd6f26d7sm258780715e9.3.2026.02.27.14.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 14:10:03 -0800 (PST)
Message-ID: <2ab205f2-fd87-4fcc-9c0a-0bdebbadeb58@gmail.com>
Date: Fri, 27 Feb 2026 22:10:00 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
To: Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
 io-uring@vger.kernel.org
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e834eb01-6cde-4249-a797-ed1fd9f8c713@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12474-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 665B31BE8BE
X-Rspamd-Action: no action

On 2/27/26 21:17, Jens Axboe wrote:
> On 2/27/26 2:09 PM, Pavel Begunkov wrote:
>> On 2/27/26 20:19, Jens Axboe wrote:
>>> On 2/27/26 1:03 PM, Pavel Begunkov wrote:
>>>> On 2/27/26 19:39, Jens Axboe wrote:
>> ...
>>>>> I don't think it's about length of it - if you can avoid the div by
>>>>> doing ns_to_timespec64(), that might be very useful? Would make
>>>>
>>>> hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), mode);
>>>>                                      ^^^
>>>>
>>>> io_uring just needs to flip it and use ktime, but I left it for later.
>>>
>>> I think we should go all the way with this if we're doing the immediate
>>> mode. And I do think that is a good idea. Doing a half-way thing doesn't
>>> make much sense to me.
>>
>> One time people will tell you don't do premature optimisations,
>> merge the main thing first, another time it's the other way around,
>> you can never guess.
> 
> IMHO this isn't premature optimization, it's more about just doing it
> right in the first place.
> 
>> In either case, it's useful by itself. Div is not that expensive
>> to be a break dealer, and div by constant will usually get
>> replaced with a mul by modern compilers.
> 
> Agree, and that's likely what it does here. It's just why not avoid it
> in the first place if possible. That's not premature optimization.

I think uapi should come first before we waste time on making
internals one way or another.

>>>>> userspace simpler too potentially, and basically make the immediate mode
>>>>> _exactly_ the same as the non-immediate mode, it just delivers the
>>>>> __kernel_timespec in a different way.
>>>>
>>>> I very much want to believe that everything about kernel_timespec has
>>>> some deep meaning, but I fail to see why they split it as sec/ns and
>>>> left invalid ranges for ns, why ns is signed, and why even after a
>>>> large revamp one of the fields doesn't use a fixed width type.
>>>> I'm not sure exactly like it is actually a good idea.
>>>
>>> But that's the API for anything timing related, whether it be timeval,
>>> timespec, or __kernel_timespec the latter obviously only existing
>>> because everybody else could not be bothered to do a proper 32 vs 64-bit
>>> agnostic type before. Hence that's the API that people know and use,
>>> there's no deeper meaning other than that. And I agree, it's kind of
>>> crap in how you can have an invalid range and it gets masked.
>>>
>>> It's like like I'm a huge __kernel_timespec fan, but for consistency's
>>> sake, I do like it. With a clock source, then it does start to make
>>> sense.
>>
>> What's about clock source? I'm curious
> 
> Just that timespec/timeval/whatever usually go with a clocksource, vs
> some isolated nsec value.

They're orthogonal though, timeout requests also support clock
sources.

>>> Not that I think there's a lot of ABS use cases, I'd expect
>>> relative to be what people generally use here. But at least then the
>>
>> It's probably common enough. Not the "wake me on Monday at 5am" kind,
>> but rather get the current time and then recalculating intervals
>> from it. Would be nice to return the wake up time as well in a CQE,
>> if only it was free.
> 
> Yeah could be, it's always hard to know. Which is why it's nice to error
> on the side of "let's just support both upfront" if it's feasible.
> 
>>> IMMED API addition will just work regardless of what you do in the app.
>>> That's better than someone a few revisions later than saying "hey that's
>>> cool, can we do ABS too which I use because of X and Y" and then having
>>> to hack that on top.
>>
>> Hack it up in the user program? I didn't get it.
> 
> No, I mean needing to retrofit ABS support on the kernel side for IMMED
> up front.

They should be enabled in the same release, but we've been rather
discussing the way to do that. I was saying that u64 is enough to
pass the abs timeout value, and we can extend it to another u64 if
needed in several centuries from now. And it's not a bad option
because plain u64 ns makes much much more sense for the relative
mode. And even for the abs scenario above, I'd prefer that rather
than doing second adjustments every single time.

-- 
Pavel Begunkov


