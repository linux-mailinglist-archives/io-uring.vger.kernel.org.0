Return-Path: <io-uring+bounces-3572-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 847129993A6
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 22:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04A6CB23134
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 20:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D2231DFD93;
	Thu, 10 Oct 2024 20:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R4s8RhYb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E231D31B2;
	Thu, 10 Oct 2024 20:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728591984; cv=none; b=ut+17hF5JBesHb1KJjqN/EGX69cQ+CFH8n0RUVupIBlZxLVXYOgkZEjvI1DxKAfoW5ydKgmqFEaLXoZ/qykDeG5UwLBoWISQp/y7VcgD1vmTwtsoBoUdJ1uCM8l84rYJo60koh35KgYsr1HMEcs75rYM+xj3ffDESA/3z/IYnas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728591984; c=relaxed/simple;
	bh=aDbyIfvPH6sU5Ww3LaB38b0SMXtQjk4IAYtgHCQ7xnI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UgQ38Nz2rytBCPYCnnV8wmVx1N7jnxOYJI6IdFGxW6g7rykymTWMc8Y94x2Kb4MPQIKItBgWZb3+G5RTCVz9XkRtrCzuk+Wn442rF4a3Oqob1MWuH3FD6JwUTofBs4b6pmOP/orjtO6Tlun3fDHfMWCGsp/VuD5nMpjixbLZDMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R4s8RhYb; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-37d5038c653so510930f8f.2;
        Thu, 10 Oct 2024 13:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728591980; x=1729196780; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3Mk6kNX02i5cUlWVJL1ATuLiRq5acxf7DAq6ut8h2XQ=;
        b=R4s8RhYb54hRGHB2DfYBp3QfPJi+4DGhDN6XnlPY7lka1shWucJZo9IvjzWXGD/pVs
         TrcfkTAuyBwIBkpLgDTM5jNpp+EVQAN06EU/a2ML7MFb8XF6j12Tw6VF5TnslREdypcI
         TCRGLcfmzDXTZ0zyW8ureEJVWz74xoPsoy1d1crKJREQkFmqR2TJ0dWourYin1Q02pII
         PAUvslISnUIM6RxPLyXXLJ552tKBX1Q+mvbYvr6IEbwiFUma1/TY5H2oJmlh9doyUe4b
         KKgRH6b2IpDzPzWC7/aFSxUUGtsNrNxkSo6VAYO5vO4jZQ2u8zbf1LnnNZXoolt3Zb4n
         BpGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728591980; x=1729196780;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Mk6kNX02i5cUlWVJL1ATuLiRq5acxf7DAq6ut8h2XQ=;
        b=oygEgtNpLUabzkhZgswQpAMJS6+I+atowsXq1HICo9WKL5fM0R3J7goe7a0YIRrBFR
         RgZmAsduXvZNutqSQE1sKe6lieDEpM7YEOPVSxHdnYTBYwv4U0jUZpgGOJx92RVL3kHX
         9eTzVwBmRTBPNynLCfMRmwdLUpoKNQelKwMwpD7dzqzbWzevQaTWXyuC4YJ8fL09HdTm
         sNHbasYFr1faCD/dF4DIS3ZlpKQD0Zs+pA2SxyfRSZBXmkkd/zN2UFnY33/FKVy+j4pe
         LV5QJBqmwhVCKYwlE7p9JQ/1rSWsE+cCpjyHIPI5StbP16YRp5bSc4OMK2xQYe1oXRaj
         WOOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTVLCAlLgPNKE4/QLkps8QutozCf47Zgz+WlMexIMQSqTZY1OJlq7vz1TAmfpt4G7fvZew8ypX@vger.kernel.org, AJvYcCXk093DnkEFLeHU+U/CRt3PDfb9e+D8be/AcrMTqO++kYNDL9Pf+jxzeVgrJOLI8dGq23Nw/PaYcw==@vger.kernel.org
X-Gm-Message-State: AOJu0YydSTD0oNacE5AL0En5FTcqyPEzz3dqWChOSHu6bF5NVePnyTem
	7uRYPMSAtONgjB18tcMeLdtDfZTwgjC5tfskQSwv1V5S9oLsxg1h
X-Google-Smtp-Source: AGHT+IFKfgSaOYFgvRqmRB0ZjGK6qXtOtOMjD31BVi4i73RPxNJJwKQzMsrtKmkVILc/RAaNqzaNUQ==
X-Received: by 2002:adf:e908:0:b0:37c:cd0d:3437 with SMTP id ffacd0b85a97d-37d5530438bmr241394f8f.58.1728591979843;
        Thu, 10 Oct 2024 13:26:19 -0700 (PDT)
Received: from [192.168.42.41] ([148.252.140.94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b9180f8sm2286695f8f.115.2024.10.10.13.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 13:26:19 -0700 (PDT)
Message-ID: <f89c65da-197a-42d9-b78a-507951484759@gmail.com>
Date: Thu, 10 Oct 2024 21:26:54 +0100
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izPjHv_J8=Hz6xZmfa857st+zyA7MLSe+gCJTdZewPOmEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/10/24 19:19, Mina Almasry wrote:
> On Wed, Oct 9, 2024 at 3:57 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 10/9/24 23:01, Mina Almasry wrote:
>>> On Mon, Oct 7, 2024 at 3:16 PM David Wei <dw@davidwei.uk> wrote:
>>>>
>>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>>
>>>> Implement a page pool memory provider for io_uring to receieve in a
>>>> zero copy fashion. For that, the provider allocates user pages wrapped
>>>> around into struct net_iovs, that are stored in a previously registered
>>>> struct net_iov_area.
>>>>
>>>> Unlike with traditional receives, for which pages from a page pool can
>>>> be deallocated right after the user receives data, e.g. via recv(2),
>>>> we extend the lifetime by recycling buffers only after the user space
>>>> acknowledges that it's done processing the data via the refill queue.
>>>> Before handing buffers to the user, we mark them by bumping the refcount
>>>> by a bias value IO_ZC_RX_UREF, which will be checked when the buffer is
>>>> returned back. When the corresponding io_uring instance and/or page pool
>>>> are destroyed, we'll force back all buffers that are currently in the
>>>> user space in ->io_pp_zc_scrub by clearing the bias.
>>>>
>>>
>>> This is an interesting design choice. In my experience the page_pool
>>> works the opposite way, i.e. all the netmems in it are kept alive
>>> until the user is done with them. Deviating from that requires custom
>>> behavior (->scrub), which may be fine, but why do this? Isn't it
>>> better for uapi perspective to keep the memory alive until the user is
>>> done with it?
>>
>> It's hardly interesting, it's _exactly_ the same thing devmem TCP
>> does by attaching the lifetime of buffers to a socket's xarray,
>> which requires custom behaviour. Maybe I wasn't clear on one thing
>> though, it's accounting from the page pool's perspective. Those are
>> user pages, likely still mapped into the user space, in which case
>> they're not going to be destroyed.
>>
> 
> I think we miscommunicated. Both devmem TCP and io_uring seem to bump
> the refcount of memory while the user is using it, yes. But devmem TCP
> doesn't scrub the memory when the page_pool dies. io_uring seems to
> want to scrub the memory when the page_pool dies. I'm wondering about
> this difference. Seems it's better from a uapi prespective to keep the
> memory alive until the user returns it or crash. Otherwise you could

The (user) memory is not going to be pulled under the user,
it's user pages in the user's mm and pinned by it. The difference
is that the page pool will be able to die.

> have 1 thread reading user memory and 1 thread destroying the
> page_pool and the memory will be pulled from under the read, right?

If an io_uring is shared b/w users and one of them is destroying
the instance while it's still running, it's a severe userspace bug,
even then the memory will still be alive as per above.

>>>> Refcounting and lifetime:
>>>>
>>>> Initially, all buffers are considered unallocated and stored in
>>>> ->freelist, at which point they are not yet directly exposed to the core
>>>> page pool code and not accounted to page pool's pages_state_hold_cnt.
>>>> The ->alloc_netmems callback will allocate them by placing into the
>>>> page pool's cache, setting the refcount to 1 as usual and adjusting
>>>> pages_state_hold_cnt.
>>>>
>>>> Then, either the buffer is dropped and returns back to the page pool
>>>> into the ->freelist via io_pp_zc_release_netmem, in which case the page
>>>> pool will match hold_cnt for us with ->pages_state_release_cnt. Or more
>>>> likely the buffer will go through the network/protocol stacks and end up
>>>> in the corresponding socket's receive queue. From there the user can get
>>>> it via an new io_uring request implemented in following patches. As
>>>> mentioned above, before giving a buffer to the user we bump the refcount
>>>> by IO_ZC_RX_UREF.
>>>>
>>>> Once the user is done with the buffer processing, it must return it back
>>>> via the refill queue, from where our ->alloc_netmems implementation can
>>>> grab it, check references, put IO_ZC_RX_UREF, and recycle the buffer if
>>>> there are no more users left. As we place such buffers right back into
>>>> the page pools fast cache and they didn't go through the normal pp
>>>> release path, they are still considered "allocated" and no pp hold_cnt
>>>> is required.
>>>
>>> Why is this needed? In general the provider is to allocate free memory
>>
>> I don't get it, what "this"? If it's refill queue, that's because
>> I don't like actively returning buffers back via syscall / setsockopt
>> and trying to transfer them into the napi context (i.e.
>> napi_pp_put_page) hoping it works / cached well.
>>
>> If "this" is IO_ZC_RX_UREF, it's because we need to track when a
>> buffer is given to the userspace, and I don't think some kind of
>> map / xarray in the hot path is the best for performance solution.
>>
> 
> Sorry I wasn't clear. By 'this' I'm referring to:
> 
> "from where our ->alloc_netmems implementation can grab it, check
> references, put IO_ZC_RX_UREF, and recycle the buffer if there are no
> more users left"
> 
> This is the part that I'm not able to stomach at the moment. Maybe if
> I look deeper it would make more sense, but my first feelings is that
> it's really not acceptable.
> 
> alloc_netmems (and more generically page_pool_alloc_netmem), just
> allocates a netmem and gives it to the page_pool code to decide

That how it works because that's how devmem needs it and you
tailored it, not the other way around. It could've pretty well
been a callback that fills the cache as an intermediate, from
where page pool can grab netmems and return back to the user,
and it would've been a pretty clean interface as well.

> whether to put it in the cache, in the ptr ring, or directly to the
> user, etc.

And that's the semantics you've just imbued into it.

> The provider should not be overstepping or overriding the page_pool
> logic to recycle pages or deliver them to the user. alloc_netmem

I'm baffled, where does it overrides page pool's logic? It provides the
memory to the page pool, nothing more, nothing less, it doesn't decide if
it's handed to the user or go to ptr ring, the page pool is free to do
whatever is needed. Yes, it's handed by means of returning in the cache
because of performance considerations. The provider API can look
differently, e.g. passing a temp array like in the oversimplified snippet
below, but even then I don't think that's good enough.

page_pool_alloc_netmem() {
	netmem_t arr[64];
	nr = pool->mp_ops->alloc_netmems(arr, 64);

	// page pool does the page pool stuff.
	for (i = 0; i < nr; i++)
		pp->cache[idx] = arr[i];
	return pp->cache;
}

> should just just alloc the netmem and hand it to the page_pool to
> decide what to do with it.
> 
>>> and logic as to where the memory should go (to fast cache, to normal
>>> pp release path, etc) should remain in provider agnostic code paths in
>>> the page_pool. Not maintainable IMO in the long run to have individual
>>
>> Please do elaborate what exactly is not maintainable here
>>
> 
> In the future we will have N memory providers. It's not maintainable
> IMO for each of them to touch pp->alloc.cache and other internals in M
> special ways and for us to have to handle N * M edge cases in the
> page_pool code because each provider is overstepping on our internals.

It sounds like anything that strays from the devmem TCP way is wrong,
please let me know if so, because if that's the case there can only be
devmem TCP, maybe just renamed for niceness. The patch set uses the
abstractions, in a performant way, without adding overhead to everyone
else, and to the best of my taste in a clean way.

> The provider should just provide memory. The page_pool should decide
> to fill its alloc.cache & ptr ring & give memory to the pp caller as
> it sees fit.
> 
>>> pp providers customizing non-provider specific code or touching pp
>>> private structs.
>>
>> ...
>>>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>>>> index 8382129402ac..6cd3dee8b90a 100644
>>>> --- a/io_uring/zcrx.c
>>>> +++ b/io_uring/zcrx.c
>>>> @@ -2,7 +2,11 @@
>> ...
>>>> +static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
>>>> +{
>>>> +       struct net_iov_area *owner = net_iov_owner(niov);
>>>> +
>>>> +       return container_of(owner, struct io_zcrx_area, nia);
>>>
>>> Similar to other comment in the other patch, why are we sure this
>>> doesn't return garbage (i.e. it's accidentally called on a dmabuf
>>> net_iov?)
>>
>> There couldn't be any net_iov at this point not belonging to
>> the current io_uring instance / etc. Same with devmem TCP,
>> devmem callbacks can't be called for some random net_iov, the
>> only place you need to explicitly check is where it comes
>> from generic path to a devmem aware path like that patched
>> chunk in tcp.c
>>
>>>> +static inline void io_zc_add_pp_cache(struct page_pool *pp,
>>>> +                                     struct net_iov *niov)
>>>> +{
>>>> +       netmem_ref netmem = net_iov_to_netmem(niov);
>>>> +
>>>> +#if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
>>>> +       if (pp->dma_sync && dma_dev_need_sync(pp->p.dev)) {
>>>
>>> IIRC we force that dma_sync == true for memory providers, unless you
>>> changed that and I missed it.
>>
>> I'll take a look, might remove it.
>>
>>>> +               dma_addr_t dma_addr = page_pool_get_dma_addr_netmem(netmem);
>>>> +
>>>> +               dma_sync_single_range_for_device(pp->p.dev, dma_addr,
>>>> +                                                pp->p.offset, pp->p.max_len,
>>>> +                                                pp->p.dma_dir);
>>>> +       }
>>>> +#endif
>>>> +
>>>> +       page_pool_fragment_netmem(netmem, 1);
>>>> +       pp->alloc.cache[pp->alloc.count++] = netmem;
>>>
>>> IMO touching pp internals in a provider should not be acceptable.
>>
>> Ok, I can add a page pool helper for that.
>>
> 
> To be clear, adding a helper will not resolve the issue I'm seeing.
> IMO nothing in the alloc_netmem or any helpers its calling should
> touch pp->alloc.cache. alloc_netmem should just allocate the memory
> and let the non-provider pp code decide what to do with the memory.

Then we have opposite opinions, and I can't agree with what
you're proposing. If I'm adding an interface, I'm trying to make
it lasting and not be thrown away in a year. One indirect call
per page in the hot hot path is just insanity. Just remember what
you've been told about one single "if" in the hot path.

>>> pp->alloc.cache is a data structure private to the page_pool and
>>> should not be touched at all by any specific memory provider. Not
>>> maintainable in the long run tbh for individual pp providers to mess
>>> with pp private structs and we hunt for bugs that are reproducible
>>> with 1 pp provider or another, or have to deal with the mental strain
>>> of provider specific handling in what is supposed to be generic
>>> page_pool paths.
>>
>> I get what you're trying to say about not touching internals,
>> I agree with that, but I can't share the sentiment about debugging.
>> It's a pretty specific api, users running io_uring almost always
>> write directly to io_uring and we solve it. If happens it's not
>> the case, please do redirect the issue.
>>
>>> IMO the provider must implement the 4 'ops' (alloc, free, init,
>>
>> Doing 1 buffer per callback wouldn't be scalable at speeds
>> we're looking at.
>>
> 
> I doubt this is true or at least there needs to be more info here. The

If you don't believe me, then, please, go ahead and do your testing,
or look through patches addressing it across the stack like [1],
but you'll be able to find many more. I don't have any recent numbers
on indirect calls, but I did a fair share of testing before for
different kinds of overhead, it has always been expensive, can easily
be 1-2% per fast block request, which could be much worse if it's per
page.

[1] https://lore.kernel.org/netdev/cover.1543836966.git.pabeni@redhat.com/


> page_pool_alloc_netmem() pretty much allocates 1 buffer per callback
> for all its current users (regular memory & dmabuf), and that's good
> enough to drive 200gbps NICs. What is special about io_uring use case
> that this is not good enough?
> 
> The reason it is good enough in my experience is that
> page_pool_alloc_netmem() is a slow path. netmems are allocated from
> that function and heavily recycled by the page_pool afterwards.

That's because how you return buffers back to the page pool, with
io_uring it is a hot path, even though ammortised exactly because
it doesn't just return one buffer at a time.

-- 
Pavel Begunkov

