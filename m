Return-Path: <io-uring+bounces-3576-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA862999456
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 23:22:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24AA8283440
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 21:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E311CF2A3;
	Thu, 10 Oct 2024 21:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I0tTtZBw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA6819CD1B;
	Thu, 10 Oct 2024 21:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728595337; cv=none; b=hG0+pwdSKBkZwy0uwtC+WoF3eagfDot8dAz8rdm08XY5lG4eYqI4TgPia1JxxmNGU5M+1Qw5qh0XEQkj1AV5V9sFEGBGCqKuXfF3Bqj4ZiJV6L3sFsPDZgGdEZmwbgsfXfOwhqEuEcBXyPJp8e/4tNNjWp13pnymqLrYLUjBj/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728595337; c=relaxed/simple;
	bh=VmrQkJxFV/UqdyAIDY5SIDP07fndQpvIcz4Z7fpRKZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oOjAQx6AmCnO+MnCHM1JY2PgyRKVwtU8wd0RjUq4Zpkt9sJLurCc6kSGEr5SSGlt5blA5BkMbsXhWbhf72G1gnof142kfuuaHX27DB3xjAirjYMtKGS7CrWGIndTjxeUVYOMoyhOfvjpLRJI8gnHy8GLbp5xLhsCNR3c4bKx1Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I0tTtZBw; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5c42e7adbddso1696182a12.2;
        Thu, 10 Oct 2024 14:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728595334; x=1729200134; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xSvAET0RtvVtYiv3KxcsZgImHwHZbzkRtTq+trQbCXw=;
        b=I0tTtZBwBaqb9ZGHu1gzzWjVyGgupjdtiGHgb1XqlerThGm2+xlgdXB9td0LicFEOw
         mBN/z8k5kjutBGZ07tZjkzb+LozNJv+/yYqSrSLosPWcnxIq9ajSpyEOSXurb0TgEy7W
         3xrHdxIX2N4v71SGgdpliUTbT9nX5MBKqjOTOrQzaQU9yf6GKwxBMxUecxIRFPrAmBII
         x1X2Wzmc2a6NQDi8CeJGcas14DEBbPHBPY3HLkS8bAMNoI6bH2aOShx7Ozsn1BdddWnn
         nDukGmpRRXAormbgbsVz4NCulXraUQKGhleuRhUXufEpN8UlnLKTnQvMq2dwlGAJjIGQ
         o2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728595334; x=1729200134;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xSvAET0RtvVtYiv3KxcsZgImHwHZbzkRtTq+trQbCXw=;
        b=dBOPDkwfbISfSfwLwUSA2RQZtYIzaTtzaXx0B6SQyF9jpw3BsDTz5yqTbLJvaeOb/n
         DhgHQUpwkNR8NOvwSmfgZ427iMkp9L3HBoNr96RX0fGa6x2gV7YG0KIk+1Putd2J1TMh
         9WdZIFwllPNDszMmMwPiySXSLOVfH6+raSkoBarptMVnQblnXadbZjaZdlgOvyNAvORX
         jlYXbKPTFgmcfA6WMC2krWaAckakls/NNSUNoN5FbeVpNMxZ8CrMfYJEGcWybUledT3s
         tw+o+M+mNhXvILEr35ptr9OS2aG+jDG+GG5TCPAHVe7GemcmhfPCoVXMjTIeeiqddC+o
         cQxw==
X-Forwarded-Encrypted: i=1; AJvYcCUW7jsTP1osL3SXf0OdEB8dENI+fUMmINeuTy11+pkSEuIq5hQqy5JrhL+He36w0yXoNUgqTZu+@vger.kernel.org, AJvYcCXv8mY2EktjYlvwO5or8L3oAVfjuuJ2TeoJ/lZPrSCBTHsCxFTZhLDiabW6qBFftxwVWes/tJu6JA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjGvOVF/BlKzPXtcmw+bK/ILW6LfP08hfccyPpWkYkGUW3r16G
	RTl438C3kcv/pqCS6LKlKHOCelloXnqC05qAObo39QLqzL6XVXYO
X-Google-Smtp-Source: AGHT+IFFRvNZISyxsGhdFx6m+xzlfADh+kknyc0Wq182er6i/QkbltIDXFT39STgRnaWVqlSicyDOQ==
X-Received: by 2002:a05:6402:42cf:b0:5c8:8db1:1d55 with SMTP id 4fb4d7f45d1cf-5c948ca0884mr139067a12.10.1728595333508;
        Thu, 10 Oct 2024 14:22:13 -0700 (PDT)
Received: from [192.168.42.41] ([148.252.140.94])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c937156973sm1288473a12.58.2024.10.10.14.22.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 14:22:12 -0700 (PDT)
Message-ID: <096387ce-64f0-402f-a5d2-6b51653f9539@gmail.com>
Date: Thu, 10 Oct 2024 22:22:47 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
To: Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-12-dw@davidwei.uk>
 <CAHS8izO-=ugX7S11dTr5cXp11V+L-gquvwBLQko8hW4AP9vg6g@mail.gmail.com>
 <94a22079-0858-473c-b07f-89343d9ba845@gmail.com>
 <CAHS8izPjHv_J8=Hz6xZmfa857st+zyA7MLSe+gCJTdZewPOmEw@mail.gmail.com>
 <f89c65da-197a-42d9-b78a-507951484759@gmail.com>
 <CAHS8izMrPuQNvwGwAUjh7GAY-CoC81rc5BD1ZMmy-nNds3xDgA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMrPuQNvwGwAUjh7GAY-CoC81rc5BD1ZMmy-nNds3xDgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/10/24 21:53, Mina Almasry wrote:
> On Thu, Oct 10, 2024 at 1:26 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>>>
>>> Sorry I wasn't clear. By 'this' I'm referring to:
>>>
>>> "from where our ->alloc_netmems implementation can grab it, check
>>> references, put IO_ZC_RX_UREF, and recycle the buffer if there are no
>>> more users left"
>>>
>>> This is the part that I'm not able to stomach at the moment. Maybe if
>>> I look deeper it would make more sense, but my first feelings is that
>>> it's really not acceptable.
>>>
>>> alloc_netmems (and more generically page_pool_alloc_netmem), just
>>> allocates a netmem and gives it to the page_pool code to decide
>>
>> That how it works because that's how devmem needs it and you
>> tailored it, not the other way around. It could've pretty well
>> been a callback that fills the cache as an intermediate, from
>> where page pool can grab netmems and return back to the user,
>> and it would've been a pretty clean interface as well.
>>
> 
> It could have been, but that would be a much worse design IMO. The
> whole point of memory proivders is that they provide memory to the
> page_pool and the page_pool does its things (among which is recycling)
> with that memory. In this patch you seem to have implemented a
> provider which, if the page is returned by io_uring, then it's not
> returned to the page_pool, it's returned directly to the provider. In
> other code paths the memory will be returned to the page_pool.
> 
> I.e allocation is always:
> provider -> pp -> driver
> 
> freeing from io_uring is:
> io_uring -> provider -> pp
> 
> freeing from tcp stack or driver I'm guessing will be:
> tcp stack/driver -> pp -> provider
> 
> I'm recommending that the model for memory providers must be in line
> with what we do for pages, devmem TCP, and Jakub's out of tree huge
> page provider (i.e. everything else using the page_pool). The model is
> the streamlined:

Let's not go into the normal pages, because 1) it can't work
any other way in general case, it has to cross the context from
whenever page is to the napi / page pool, and 2) because devmem
TCP and io_uring already deviate from the standard page pool,
by extending lifetime of buffers to user space and more.

And then that's exactly what I'm saying, you recommend it to be
aligned with devmem TCP. And let's not forget that you had to add
batching to that exact syscall return path because of
performance...

...
>>> I doubt this is true or at least there needs to be more info here. The
>>
>> If you don't believe me, then, please, go ahead and do your testing,
>> or look through patches addressing it across the stack like [1],
>> but you'll be able to find many more. I don't have any recent numbers
>> on indirect calls, but I did a fair share of testing before for
>> different kinds of overhead, it has always been expensive, can easily
>> be 1-2% per fast block request, which could be much worse if it's per
>> page.
>>
>> [1] https://lore.kernel.org/netdev/cover.1543836966.git.pabeni@redhat.com/
>>
>>
>>> page_pool_alloc_netmem() pretty much allocates 1 buffer per callback
>>> for all its current users (regular memory & dmabuf), and that's good
>>> enough to drive 200gbps NICs. What is special about io_uring use case
>>> that this is not good enough?
>>>
>>> The reason it is good enough in my experience is that
>>> page_pool_alloc_netmem() is a slow path. netmems are allocated from
>>> that function and heavily recycled by the page_pool afterwards.
>>
>> That's because how you return buffers back to the page pool, with
>> io_uring it is a hot path, even though ammortised exactly because
>> it doesn't just return one buffer at a time.
>>
> 
> Right, I guess I understand now. You need to implement your own
> recycling in the provider because your model has bypassed the
> page_pool recycling - which to me is 90% of the utility of the

So the utility of the page pool is a fast return path for the
standard page mode, i.e. napi_pp_put_page, which it is and is
important, I agree. But then even though we have a better IMO
approach for this "extended to userspace buffer life cycle"
scenario, it has to use that very same return path because...?

> page_pool. To make matters worse, the bypass is only there if the
> netmems are returned from io_uring, and not bypassed when the netmems
> are returned from driver/tcp stack. I'm guessing if you reused the
> page_pool recycling in the io_uring return path then it would remove
> the need for your provider to implement its own recycling for the
> io_uring return case.
> 
> Is letting providers bypass and override the page_pool's recycling in
> some code paths OK? IMO, no. A maintainer will make the judgement call

Mina, frankly, that's nonsense. If we extend the same logic,
devmem overrides page allocation rules with callbacks, devmem
overrides and violates page pool buffer lifetimes by extending
it to user space, devmem violates and overrides the page pool
object lifetime by binding buffers to sockets. And all of it
I'd rather name extends and enhances to fit in the devmem use
case.

> and speak authoritatively here and I will follow, but I do think it's
> a (much) worse design.

Sure, I have a completely opposite opinion, that's a much
better approach than returning through a syscall, but I will
agree with you that ultimately the maintainers will say if
that's acceptable for the networking or not.

-- 
Pavel Begunkov

