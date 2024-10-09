Return-Path: <io-uring+bounces-3541-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A7BD9978C3
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 00:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BAF741F2337D
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 22:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D1318E345;
	Wed,  9 Oct 2024 22:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e5a5bPZn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46186189520;
	Wed,  9 Oct 2024 22:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728514664; cv=none; b=EEc6jWS3fTdWdH7rWby654X+a3j6mbLaucmoWMjPclehzwxUBnpOtygB0dOCaY46zdyXnJLfToFxq5g0kZfDRXngdZXEPpylR9jxGpBBS0OzfuCqktPfPIma24hN2JIGpVno0aC/zLDfzKXI14lEyCYfelReDnS3uVDoStGuSBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728514664; c=relaxed/simple;
	bh=dLxna75wADPeBKJftxvDnMotIKDetPx5lhWUosde00w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=box+mWg5NyOdUA/sTfoktFkoyfZxRvcBLRapkkp5YLhoZZ9rF9tYV6Nra5BQTUc0DSYKINdR6GjQi5N+2+5o0GWp5o4Gv2Pb28u1v8q4T4UUxEg48n2yyJew2G2TOcN9JNo99vWUWcxWPI8IwA25CyFsnRmko12aGxyphLmepH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e5a5bPZn; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-42e748f78d6so2085045e9.0;
        Wed, 09 Oct 2024 15:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728514660; x=1729119460; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7bZ8bWpf9+vmB/42H0j1bEZ6D+w0izbJdCTZHcO4xTY=;
        b=e5a5bPZn7jiBg3xLJnJ1V5c4izJ7Z2JAIOCA/YWkOMk90XTpLGtGsBHrRMRwVuGiI8
         egRIsXAUi677Lhir2bterMx5glsw6U59F3Z63/YAlC9LGSM+b27pRhIsCIrz7nHL1sVa
         WADtjsMaaGlgxnV8S2OsI9DXBKZH8z0WS6Ot69AqnjYvilJOdXnhUni5JwaDZT9oIvvB
         5QSvP8OaBBhR4qQMVvlAMjKO74ueOo1d/xRdqY/v3UXZ3NIqSM5/afK9IAbgMQTHo4Bw
         +C9ce/U0m7TpQPM6Pl7dWYlLeC5ArCvIcLOyTnav8o+Fkv3GruMxcCW+wybYLcO1gtCE
         4j7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728514661; x=1729119461;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7bZ8bWpf9+vmB/42H0j1bEZ6D+w0izbJdCTZHcO4xTY=;
        b=cSlVGKjSDbfIqmAEDzyC6ZoQOmrsw6sASDIPM6rGEywM193UXLorfvr8qZTjH05flv
         9DSwXU64YBqQQdqoSL33s465X0+pzjKC10onvL668Ey59y0U+tX87URhkTp+IJGvcraX
         yl9hjp3d1NwoLPV3lNzIuTITYZXjonafjrjc1OHQFYn1qh67Kp9VIFP+706UP68Ys9lg
         8Ps9rXfjz4Na6nXrXxynfPFlisb1dlXubx46z3RmpI1IGG6J23NU/e8Yh3NaI6hG2il1
         Jw51VBp7ulKU1g3yE0Zm0FoFrlQvtXflaimsj9kJUbCqWj/Bld6Yh9eNr0BRskmBEulp
         VHiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUF9tR+e7vEz7phxhlbilNAAd3Iu3+S68/AzsDG318EReTbQoj1Jiocm+B6dvGKdHA5gQROFKU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNP7+cFntpFJbK+FgYZ5XcLu+S0u5Mhd0H05wIc/vtSokxREgu
	CbUOyCr/ZJ0MMRqD4AIwuAoBFC7NS5SnZ+HgPDGdB8+WCVw5Og1M
X-Google-Smtp-Source: AGHT+IFLNXC4XadEKJNCIk5HeTKWyVreyJ5s+LNRMiM/sKta9jQRUwMHfwC7NMPO8DJHFizdnXGrDA==
X-Received: by 2002:a05:600c:3b9b:b0:42a:a6aa:4135 with SMTP id 5b1f17b1804b1-430ccf46b87mr26785285e9.20.1728514660323;
        Wed, 09 Oct 2024 15:57:40 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.140.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-430d70b4420sm32197065e9.34.2024.10.09.15.57.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 15:57:39 -0700 (PDT)
Message-ID: <94a22079-0858-473c-b07f-89343d9ba845@gmail.com>
Date: Wed, 9 Oct 2024 23:58:14 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-12-dw@davidwei.uk>
 <CAHS8izO-=ugX7S11dTr5cXp11V+L-gquvwBLQko8hW4AP9vg6g@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izO-=ugX7S11dTr5cXp11V+L-gquvwBLQko8hW4AP9vg6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/9/24 23:01, Mina Almasry wrote:
> On Mon, Oct 7, 2024 at 3:16 PM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Implement a page pool memory provider for io_uring to receieve in a
>> zero copy fashion. For that, the provider allocates user pages wrapped
>> around into struct net_iovs, that are stored in a previously registered
>> struct net_iov_area.
>>
>> Unlike with traditional receives, for which pages from a page pool can
>> be deallocated right after the user receives data, e.g. via recv(2),
>> we extend the lifetime by recycling buffers only after the user space
>> acknowledges that it's done processing the data via the refill queue.
>> Before handing buffers to the user, we mark them by bumping the refcount
>> by a bias value IO_ZC_RX_UREF, which will be checked when the buffer is
>> returned back. When the corresponding io_uring instance and/or page pool
>> are destroyed, we'll force back all buffers that are currently in the
>> user space in ->io_pp_zc_scrub by clearing the bias.
>>
> 
> This is an interesting design choice. In my experience the page_pool
> works the opposite way, i.e. all the netmems in it are kept alive
> until the user is done with them. Deviating from that requires custom
> behavior (->scrub), which may be fine, but why do this? Isn't it
> better for uapi perspective to keep the memory alive until the user is
> done with it?

It's hardly interesting, it's _exactly_ the same thing devmem TCP
does by attaching the lifetime of buffers to a socket's xarray,
which requires custom behaviour. Maybe I wasn't clear on one thing
though, it's accounting from the page pool's perspective. Those are
user pages, likely still mapped into the user space, in which case
they're not going to be destroyed.

>> Refcounting and lifetime:
>>
>> Initially, all buffers are considered unallocated and stored in
>> ->freelist, at which point they are not yet directly exposed to the core
>> page pool code and not accounted to page pool's pages_state_hold_cnt.
>> The ->alloc_netmems callback will allocate them by placing into the
>> page pool's cache, setting the refcount to 1 as usual and adjusting
>> pages_state_hold_cnt.
>>
>> Then, either the buffer is dropped and returns back to the page pool
>> into the ->freelist via io_pp_zc_release_netmem, in which case the page
>> pool will match hold_cnt for us with ->pages_state_release_cnt. Or more
>> likely the buffer will go through the network/protocol stacks and end up
>> in the corresponding socket's receive queue. From there the user can get
>> it via an new io_uring request implemented in following patches. As
>> mentioned above, before giving a buffer to the user we bump the refcount
>> by IO_ZC_RX_UREF.
>>
>> Once the user is done with the buffer processing, it must return it back
>> via the refill queue, from where our ->alloc_netmems implementation can
>> grab it, check references, put IO_ZC_RX_UREF, and recycle the buffer if
>> there are no more users left. As we place such buffers right back into
>> the page pools fast cache and they didn't go through the normal pp
>> release path, they are still considered "allocated" and no pp hold_cnt
>> is required.
> 
> Why is this needed? In general the provider is to allocate free memory

I don't get it, what "this"? If it's refill queue, that's because
I don't like actively returning buffers back via syscall / setsockopt
and trying to transfer them into the napi context (i.e.
napi_pp_put_page) hoping it works / cached well.

If "this" is IO_ZC_RX_UREF, it's because we need to track when a
buffer is given to the userspace, and I don't think some kind of
map / xarray in the hot path is the best for performance solution.

> and logic as to where the memory should go (to fast cache, to normal
> pp release path, etc) should remain in provider agnostic code paths in
> the page_pool. Not maintainable IMO in the long run to have individual

Please do elaborate what exactly is not maintainable here

> pp providers customizing non-provider specific code or touching pp
> private structs.

...
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index 8382129402ac..6cd3dee8b90a 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -2,7 +2,11 @@
...
>> +static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
>> +{
>> +       struct net_iov_area *owner = net_iov_owner(niov);
>> +
>> +       return container_of(owner, struct io_zcrx_area, nia);
> 
> Similar to other comment in the other patch, why are we sure this
> doesn't return garbage (i.e. it's accidentally called on a dmabuf
> net_iov?)

There couldn't be any net_iov at this point not belonging to
the current io_uring instance / etc. Same with devmem TCP,
devmem callbacks can't be called for some random net_iov, the
only place you need to explicitly check is where it comes
from generic path to a devmem aware path like that patched
chunk in tcp.c

>> +static inline void io_zc_add_pp_cache(struct page_pool *pp,
>> +                                     struct net_iov *niov)
>> +{
>> +       netmem_ref netmem = net_iov_to_netmem(niov);
>> +
>> +#if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
>> +       if (pp->dma_sync && dma_dev_need_sync(pp->p.dev)) {
> 
> IIRC we force that dma_sync == true for memory providers, unless you
> changed that and I missed it.

I'll take a look, might remove it.

>> +               dma_addr_t dma_addr = page_pool_get_dma_addr_netmem(netmem);
>> +
>> +               dma_sync_single_range_for_device(pp->p.dev, dma_addr,
>> +                                                pp->p.offset, pp->p.max_len,
>> +                                                pp->p.dma_dir);
>> +       }
>> +#endif
>> +
>> +       page_pool_fragment_netmem(netmem, 1);
>> +       pp->alloc.cache[pp->alloc.count++] = netmem;
> 
> IMO touching pp internals in a provider should not be acceptable.

Ok, I can add a page pool helper for that.

> pp->alloc.cache is a data structure private to the page_pool and
> should not be touched at all by any specific memory provider. Not
> maintainable in the long run tbh for individual pp providers to mess
> with pp private structs and we hunt for bugs that are reproducible
> with 1 pp provider or another, or have to deal with the mental strain
> of provider specific handling in what is supposed to be generic
> page_pool paths.

I get what you're trying to say about not touching internals,
I agree with that, but I can't share the sentiment about debugging.
It's a pretty specific api, users running io_uring almost always
write directly to io_uring and we solve it. If happens it's not
the case, please do redirect the issue.
  
> IMO the provider must implement the 4 'ops' (alloc, free, init,

Doing 1 buffer per callback wouldn't be scalable at speeds
we're looking at.

-- 
Pavel Begunkov

