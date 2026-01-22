Return-Path: <io-uring+bounces-11888-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wH85O+FicmnfjQAAu9opvQ
	(envelope-from <io-uring+bounces-11888-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 18:48:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 546EB6BA49
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 18:48:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D3BD53002B79
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 17:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E36734404F;
	Thu, 22 Jan 2026 17:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ekzaEtyL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com [209.85.167.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E13233ADB4
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 17:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769104090; cv=none; b=UcUANNtYseV/BSQLId6juDbp7FaTTKTIVe4Pbqk13lXgypBV9ZNE5/xnSJHkmuZ2UfBoLT62DeqbE5OXLInB+6mHYgHPOuaR8rtY6fp5GOYmwnnytfOIPXKSLQr00SXaUMMmg05why5nPqxAefRzuhVp7pqTpk9KGRcjQPC5Gcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769104090; c=relaxed/simple;
	bh=49srhGImsId0QkHe5QH0OscT6JWTVDJqrGDDcteRD6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lbAVRKqBkrqNveZMZKc/IdWSa5kLGn7IdfxvWX6PnXemU5giq5qDbSJbw+FTXXDGGkbs4cqNXkGCCzOscdmk/9MAMT0Bs/0N+k+w9OhBWQWrp6sPYDekitA1S2wzQ2sedeSmrkbuQF5Uwjd0DKvZ51DvPhJvQvtBl0NoLyBTU2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ekzaEtyL; arc=none smtp.client-ip=209.85.167.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f193.google.com with SMTP id 5614622812f47-45ca0d06eddso440498b6e.2
        for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 09:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769104078; x=1769708878; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tAqYu3xB4La4CDsCFBPKH7jgCHbWvIT5wooh5c1w7TA=;
        b=ekzaEtyLptFcVPJZAjKX7EgwWmXjs3Z6bghpmwtqTaQFBQNjEP4pClwtVM7ivKOQf9
         cshxFBn8t1VRJU3K59EO0uHoa3h4NZDdLHrWVgpYhzDHG9TSZCzIwZYh2je3QyODV1Yx
         eQH9a+vRSxV7veydJuyfrmPac32UGUjWN06xLXl3Rb7XpLwXtU6HysIQNNzr+1g14tnu
         kWRAMP5TuaQzY17XJWNygas/hISnT3NPSjt4a7y+gDvfoDnrxupAYCYdFHtm0+UHG+m9
         80XZ2OdvhDt+jovYQHow9X9Ir5JB997scPDKmzGqCI4gviTBPTWqkmSvoqn6cmHhTAqd
         S0Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769104078; x=1769708878;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tAqYu3xB4La4CDsCFBPKH7jgCHbWvIT5wooh5c1w7TA=;
        b=v4GxecLz/JvCWYul8h81KIm3mpQUDTr3fywjCXv9xVXz43yQxxbtRjySVbx0/QEWCw
         rOSyjt3DMd37BJ9a+V+NbWhgg2+k6hurTZfkTWOI5fCRmObRiLTd9H+tuwtkKjX/EHUZ
         XMlxrFNFX2VGNc+0lDoD2z3xct0BVjSJaaAUvORDOAn/HkUJjFyGCZVHb7HEw/7LR2MC
         83evspIjvpP8NOkwpLMwnRk7P045K9DPI+LbzA6OBstY0Y6LFoYXV8ttn2mGfuqgYKfT
         7xoP5JGpYE5brBPZzy0pxU3E84dvCNVJpc7wh5K8MNHVb31c2e/IB91YsrV2T8XJ15VT
         6Iig==
X-Gm-Message-State: AOJu0Yy3tpBH+R9Ze+oYqtwKCp/ASpsoCO2AFnXlHexSldE+JepuJhSB
	w0I0/u/WIUcU8mCwbn3a8MH96oMKRoCy3SAVeAf2Z7EOT4wIWv77WdVrWa13lZjPJd8=
X-Gm-Gg: AZuq6aKTFCAu6RGkMpeFt3WHmwhqBUi+bRWxve6YVyw0YMxXd441u1QjDbGzidsarn6
	n/xGwQX1ECJprKES+OXLUqSTe7pU8r4qHEKbiJdmAJLLFe5Gj1A0IHbEtoR4XFGNrSCHrH6SKGP
	v+e5jZLbq10pKGVmbq8Y2sGxP22oubSyIzPvbfH8KzDfi8ryxLp/82ZXjT8vwxWZwInjIjrATvT
	riPkablJMSeIckpusB8Vv2/06uBMKFvwDtfS4Oo9KOx6oZLd+jUu/EEYWcRsLF61FF0l0WJl0SZ
	BLM6UwSKVNJbiSHrQgARA8adL1Ifq9NdyHAEtMkAp7K01VwaM7EnXdSKNEWt1EN5AUkcV8wNxmx
	ilgEU33QkHmERg3ULgG+3BTn3nelcKg1NiphvknxuomRPhaXt73OsNyV4iWwC385LhQy6aN6gdW
	yRt0TxrwYrTGEsjaMVv/yUePdUDRDPWvJhag+4xqZ8wyDa9/F2Wl9YqSOPvDt2fa9x2/kr
X-Received: by 2002:a05:6808:4482:b0:450:474b:2736 with SMTP id 5614622812f47-45eb1cf6dc0mr193617b6e.45.1769104078250;
        Thu, 22 Jan 2026 09:47:58 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9e08943csm10644269b6e.20.2026.01.22.09.47.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 09:47:57 -0800 (PST)
Message-ID: <3b7e6088-7d92-4d5c-96c7-f8c0e2cc7745@kernel.dk>
Date: Thu, 22 Jan 2026 10:47:56 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
To: Pavel Begunkov <asml.silence@gmail.com>,
 Yuhao Jiang <danisjiang@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260119071039.2113739-1-danisjiang@gmail.com>
 <bc2e8ec1-8809-4603-9519-788cfff2ae12@kernel.dk>
 <CAHYQsXTHfRKBuTDYWus9r5jDLO2WLBeopt4_bGH_vVm=0z7mWw@mail.gmail.com>
 <2919f3c5-2510-4e97-ab7f-c9eef1c76a69@kernel.dk>
 <CAHYQsXQK4nKu+fcni71__=V241RN=QxUHrvNQMQtPMzeL_z=BA@mail.gmail.com>
 <d8d28435-2a89-4b25-925e-14fdb346839b@gmail.com>
 <8c6a9114-82e9-416e-804b-ffaa7a679ab7@kernel.dk>
 <2be71481-ac35-4ff2-b6a9-a7568f81f728@gmail.com>
 <2fcf583a-f521-4e8d-9a89-0985681ca85b@kernel.dk>
 <d2fc2ff2-98d9-49f8-af95-968100174d55@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <d2fc2ff2-98d9-49f8-af95-968100174d55@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11888-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 546EB6BA49
X-Rspamd-Action: no action

On 1/22/26 4:43 AM, Pavel Begunkov wrote:
> On 1/21/26 14:58, Jens Axboe wrote:
>> On 1/20/26 2:45 PM, Pavel Begunkov wrote:
>>> On 1/20/26 17:03, Jens Axboe wrote:
>>>> On 1/20/26 5:05 AM, Pavel Begunkov wrote:
>>>>> On 1/20/26 07:05, Yuhao Jiang wrote:
>>> ...
>>>>>>
>>>>>> I've been implementing the xarray-based ref tracking approach for v3.
>>>>>> While working on it, I discovered an issue with buffer cloning.
>>>>>>
>>>>>> If ctx1 has two buffers sharing a huge page, ctx1->hpage_acct[page] = 2.
>>>>>> Clone to ctx2, now both have a refcount of 2. On cleanup both hit zero
>>>>>> and unaccount, so we double-unaccount and user->locked_vm goes negative.
>>>>>>
>>>>>> The per-context xarray can't coordinate across clones - each context
>>>>>> tracks its own refcount independently. I think we either need a global
>>>>>> xarray (shared across all contexts), or just go back to v2. What do
>>>>>> you think?
>>>>>
>>>>> The Jens' diff is functionally equivalent to your v1 and has
>>>>> exactly same problems. Global tracking won't work well.
>>>>
>>>> Why not? My thinking was that we just use xa_lock() for this, with
>>>> a global xarray. It's not like register+unregister is a high frequency
>>>> thing. And if they are, then we've got much bigger problems than the
>>>> single lock as the runtime complexity isn't ideal.
>>>
>>> 1. There could be quite a lot of entries even for a single ring
>>> with realistic amount of memory. If lots of threads start up
>>> at the same time taking it in a loop, it might become a chocking
>>> point for large systems. Should be even more spectacular for
>>> some numa setups.
>>
>> I already briefly touched on that earlier, for sure not going to be of
>> any practical concern.
> 
> Modest 16 GB can give 1M entries. Assuming 50ns-100ns per entry for the
> xarray business, that's 50-100ms. It's all serialised, so multiply by
> the number of CPUs/threads, e.g. 10-100, that's 0.5-10s. Account sky
> high spinlock contention, and it jumps again, and there can be more
> memory / CPUs / numa nodes. Not saying that it's worse than the
> current O(n^2), I have a test program that borderline hangs the
> system.

It's definitely not worse than the existing system, which is why I don't
think it's a big deal. Nobody has ever complained about time to register
buffers. It's inherently a slow path, and quite slow at that depending
on the use case. Out of curiosity, I ran some stilly testing on
registering 16GB of memory, with 1..32 threads. Each will do 16GB, so
512GB registered in total for the 32 case. Before is the current kernel,
after is with per-user xarray accounting:

before

nthreads 1:      646 msec
nthreads 2:      888 msec
nthreads 4:      864 msec
nthreads 8:     1450 msec
nthreads 16:    2890 msec
nthreads 32:    4410 msec

after

nthreads 1:      650 msec
nthreads 2:      888 msec
nthreads 4:      892 msec
nthreads 8:     1270 msec
nthreads 16:    2430 msec
nthreads 32:    4160 msec

This includes both registering buffers, cloning all of them to another
ring, and unregistering times, and nowhere is locking scalability an
issue for the xarray manipulation. The box has 32 nodes and 512 CPUs. So
no, I strongly believe this isn't an issue.

IOW, accurate accounting is cheaper than the stuff we have now. None of
them are super cheap. Does it matter? I really don't think so, or people
would've complained already. The only complaint I got on these kinds of
things was for cloning, which did get fixed up some releases ago.

> Look, I don't care what it'd be, whether it stutters or blows up the
> kernel, I only took a quick look since you pinged me and was asking
> "why not". If you don't want to consider my reasoning, as the
> maintainer you can merge whatever you like, and it'll be easier for
> me as I won't be wasting more time.

I do consider your reasoning, but you also need to consider mine rather
than assuming there's only one answer here, or that yours is invariably
the correct one and being stubborn about it. The above test obviously
isn't the end-all be-all of testing, but it would show if we had issues
with scaling to the extent that you assume.

Also worth considering that for these kinds of parallel setups running,
the (by far) common use case is threads. And hence you're going to be
banging on the shared mm anyway for a lot of these memory related setup
operations.

-- 
Jens Axboe

