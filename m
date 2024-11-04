Return-Path: <io-uring+bounces-4441-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD6A9BBFD9
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 22:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8BDB0B20AD2
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 21:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815601FA26A;
	Mon,  4 Nov 2024 21:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QFPq4067"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826EB1C876D;
	Mon,  4 Nov 2024 21:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730754845; cv=none; b=AJgjNgjf0YZD//qlQ06yfAd8QWOPNXF3sQmBf/SU4y6/r55lXlg2CJMPo12qFe/28N6k2uF4PnHqdwE7f/nMCOfmMUrhwwESCX8Mvrd3wGuSmGOIsvlgUR+AeY43Cqx8FRC1xr2rEyN+mXJYcJxicM7jAnQ8dawgbAc2E1n52H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730754845; c=relaxed/simple;
	bh=axIWzfxJvIGR269ac/ln8wUhstyhyXgrHWnIlIj4jCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=praTKsUKTgLPC/EFcEvNp2HDlUq+rDt93xsSN1XINpFgnMxKBw1OOhscF2CrSzxWNZhM+bemN7p86zHAkG32GX9DpI4ya9CVIdREwLvaj3zNHfRVJnZG5Uo4j4BCseogsJZGWRG6xx4TMDDokkMcNO5/CS1b79VwUXc2ihSJok0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QFPq4067; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-37d63a79bb6so3132810f8f.0;
        Mon, 04 Nov 2024 13:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730754842; x=1731359642; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0UK+gLR5efKANS6Cd+H8JFHboC4jyEtlOK1EQRQtHDo=;
        b=QFPq4067BNqDh1qybaWI4GUBab0qbWiI34USsJkAOE/faQr2nQUA1qjM76y2/PRy4e
         URfbHHFOCKNU68qGxaLap8/p71kuXHAIJqL5ns+HFxXYYdHRbIQSvGHflIxbVBTvngvv
         9EVPuKAV7AA21hj0A04tDUz/hpwmLQzEipVXI5xgRUTG+tos8e816ZABJ5tHG64ElBTJ
         W4lreh2xdFaku542cYJgaPpNv8xg42FKgtJIv5osGznLRTufzQXojjr+Y9/6+7t9yWKd
         sXhhdg+hnhSjSCQX/2iuIQqkjb2Ygw2QPiaLiT93D/rvGG6mHScvgmsmsFIlZTM/1zSA
         ifIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730754842; x=1731359642;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0UK+gLR5efKANS6Cd+H8JFHboC4jyEtlOK1EQRQtHDo=;
        b=GD4fS+oRlAYUWBb5qwkAi1HaiEzcNEhX2CgbtfqO6rNUJ7j3785WriXj/xlsBujC9i
         rKTmiHrMfHaWXkLZt6Op/DoqKFR1i7Kk6oBTe6x/jv6hbH39CTamNG5QknJSb4evzc0Q
         PP7S9xlFsHoc5X9TjrqVrkapwG5jzyDsXD9i8+QBYjg70sS8V+uz6U80xQjpjeB7/bEU
         Vmsi7yAv4PXxjz6PwKjXZygnLKGqGPUy1ORJrz3bfWB2508xqffebpxno8FkuQH/zinA
         gCQt+BMnxDHvLsS/KZCm3dHbt2D+gSEFO4pOR9CXEUOMiDeevl9DQpvz/xf4je5myApB
         N/xQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEHvCzXm5oxfbfq4QAZMyG3L1TfH0GFKuXlr9oert21Iokz65DFWcurwwLM3Qd7zDPIDQyOIZn@vger.kernel.org, AJvYcCWWNSi+95JXucps1GBl2zZVoDRGbCHshGez8ljQgnhJnvy11CEVRpYhYXgr4E7Eq6J/taopdp8rzw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3/J2thtnb+bLWx6nbcMJDjDY5luc2oInvwiUOFRQWNTYPkw99
	TfHgfYGGYZ8GpHxtR6yb0ibEceTmz71NIAHtsEY+0CZj2icDdNE7
X-Google-Smtp-Source: AGHT+IFnLIFUvEofEsAisI+6aomnCw1PdUfVGK6l6Zyn1OxOcHdvOYojb3oN+SDtEQhGhm4+0RYFcw==
X-Received: by 2002:a05:6000:2cf:b0:37d:47f9:be8a with SMTP id ffacd0b85a97d-381be577f72mr14738177f8f.0.1730754841288;
        Mon, 04 Nov 2024 13:14:01 -0800 (PST)
Received: from [192.168.42.103] ([148.252.145.116])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb17cf862sm31408866b.107.2024.11.04.13.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 13:14:00 -0800 (PST)
Message-ID: <8837c96b-f764-4ba7-ae9b-40299f8c266c@gmail.com>
Date: Mon, 4 Nov 2024 21:14:05 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
To: Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-12-dw@davidwei.uk>
 <CAHS8izNbNCAmecRDCL_rRjMU0Spnqo_BY5pyG1EhF2rZFx+y0A@mail.gmail.com>
 <af9a249a-1577-40fd-b1ba-be3737e86b18@gmail.com>
 <CAHS8izPEmbepTYsjjsxX_Dt-0Lz1HviuCyPM857-0q4GPdn4Rg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izPEmbepTYsjjsxX_Dt-0Lz1HviuCyPM857-0q4GPdn4Rg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/4/24 19:54, Mina Almasry wrote:
> On Fri, Nov 1, 2024 at 2:09 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>>> However I feel like even a comment is extremely error prone. These
>>> container_of's are inside of the call stack of some helpers. I would
>>> say we need a check. If we're concerned about performance, the check
>>> can be behind DEBUG_NET_WARN_ON(), although even that is a bit iffy,
>>> but could be fine. Doing this without a check seems too risky to me.
>>
>> No, it doesn't need a check nor it needs a comment. The very
>> essence of virtual function tables is that they're coupled
>> together with objects for which those function make sense and
>> called only for those objects. The only way to get here with
>> invalid net_iovs is to take one page pool and feed it with
>> net_iovs from other another page pool that won't be sane in
>> the first place.
>>
> 
> That could happen. In fact the whole devmem tcp paths are very
> carefully written to handle that

What could happen? Calling ops of one page pool with net iovs
of another? Right, you can force yourself to write it this way,
but it's not sane code.

> net_iovs are allocated from the page_pool, put in skbs, and then sit
> in the sk receive queue. In pathological cases (user is
> re/misconfiguring flow steering) we can have 1 sk receive queue that
> has a mix of page skbs, devmem skbs, and io_uring skbs, and other
> skbs.
> 
> Code that is processing the skbs in the receive queue has no idea
> whether what kind of skb it is. That's why that code needs to check
> whether the skb has readable frags, and that's why in this very series
> you needed to add a check in tcp_recvmsg_dmabuf to make sure that its
> a dmabuf skb, and you need to add a check to io_zcrx_recv_frag that
> the frag inside it is io_uring niov. The code would be wrong without
> it.

Right, it's expanded to support multiple possible types instead of
"it's a devmem TCP thing and nothing else can ever use it". And it's
not new, devmem forks off the generic path, it just does it based on
skb->readable, which is no more than an optimisation and could've
been on the type of the buffer, e.g. is_net_iov(netmem).

> All I'm trying to say is that it's very error prone to rely on folks

It's really not, especially comparing to lots of other bits that
are much easier to screw up, skb->readable would be a stark
example, which we did catch failing many times.

> writing and reviewing code to check that whenever dmabuf/io_rcrx/etc
> handling is done, somewhere in the call stack a type verification
> check has been made, and a DEBUG_NET_WARN could help avoid some subtle
> memory corruption bugs.
> 
>> That would be an equivalent of:
>>
>> struct file *f1 = ...;
>> struct file *f2 = ...;
>>
>> f1->f_op->read(f2, ...);
>>
>> Maybe it looks strange for you in C, but it's same as putting
>> comments that a virtual function that it should be called only
>> for objects of that class:
>>
>> struct A {
>>          virtual void foo() = 0;
>> };
>> struct B: public A {
>>          void foo() override {
>>                  // we should only be called with objects of type
>>                  // struct B (or anything inheriting it), check that
>>                  if (!reinterpret_cast<struct B*>(this))
>>                          throw;
>>                  ...
>>          }
>> }
>>
>>
> 
> I'm not really sure I followed here. We do not get any type of
> compiler or type safety from this code because the dma-buf niovs and
> io_uring niovs are the same net_iov type.

Right, because it's C, but the basic idea of virtual dispatch
is in there.

> We can get type safety by defining new types for dmabuf_net_iov and
> io_uring_net_iov, then provide helpers:
> 
> dmabuf_net_iov *net_iov_to_dmabuf();
> io_uring_net_iov *net_iov_to_io_uring();

Directly aliasing it to parts of struct page doesn't leave
much space to extending types. The only option is for all
those types to have exactly same layout, but then there is
no much point in doing so.

> The helpers can check the niov is of the right type once and do a
> cast,  then the object with the specific type can be passed to all
> future heplers without additional checks. This is one way to do it I
> guess.
> 
...
>> Same for optimisations provided by those helpers, they are
>> useful when you're transferring buffers from one context to
>> another, e.g. task recieve path -> napi / page_pool. In this
>> case they're already fetched in the right context without any
>> need to additionally jumping through the hoops. If anything,
>> it'd be odd to jump out of a window to climb a rope on the
>> other side of the building when you could've just walked 5
>> meters to the other room.
>>
> 
> For me, "they are not used because they're not needed." is not enough
> justification to ignore the generic code paths that support generic
> use cases and add your own freeing path and recycling that needs to
> work adjacent to generic paths for posterity. You need to provide
> concrete reasons why the current code paths don't work for you and
> can't be made to work for you.

No, it more than justifies it, it's neither needed nor makes sense for
the chosen API, and the API is chosen so that it avoids those extra
steps of crossing contexts an extra time.

What you're saying is that It should work in a less efficient way and
(perhaps arguably) be less convenient to the user as it now needs to
care about batching, because that's how devmem TCP does it. It's not
really a good argument.

Let me give you a devmem TCP example of what you're saying. Why can't
you use the generic (copy) TCP path for devmem TCP? It's well
tested. The reason that it's about zero copy and copying adds... hmm...
a "copy" doesn't justify avoiding the generic path.

> Is it very complicated to napi_pp_put_page() niovs as the user puts
> them in the refill queue without adding a new syscall? If so, is it
> possible to do a niov equivalent of page_pool_put_page_bulk() of the
> refill queue while/as you process the RX path?

That adds an extra jump from one context to another for no apparent
reason just as mentioned above.

> If you've tested the generic code paths to be performance deficient
> and your recycling is indeed better, you could improve the page_pool
> to pull netmems when it needs to like you're doing here, but in a
> generic way that applies to the page allocator and other providers.
> Not a one-off implementation that only applies to your provider.

If I read it right, you're saying you need to improve devmem TCP
instead of doing an io_uring API, just like you indirectly declared
in the very beginning a couple of weeks ago. Again, if you're
against having an io_uring user API in general or against some
particular aspects of the API, then please state it clearly. If not,
I can leave the idea to you to entertain once it's merged.

> If you're absolutely set on ignoring the currently supported reffing
> and implementing your own reffing and recycling for your use case,
> sure, that could work, but please don't overload the
> niov->pp_ref_count reserved for the generic use cases for this. Add
> io_zcrx_area->io_uring_ref or something and do whatever you want with
> it. Since it's not sharing the pp_ref_count with the generic code
> paths I don't see them conflicting in the future.

That would be a performance problem, I don't believe they can't
live together.

-- 
Pavel Begunkov

