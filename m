Return-Path: <io-uring+bounces-4337-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFDC99B99DC
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 22:09:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE38E282FE9
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 21:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA0F1E2606;
	Fri,  1 Nov 2024 21:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VRTAFUih"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B471D0E15;
	Fri,  1 Nov 2024 21:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730495347; cv=none; b=sBwmQB8sW9z6xGsSAF/IMuXMo5VyQVfN+30pYWfpNQDBRtXc0/MthlRthk9WhAz11vS4dF3SXPEVbm38SLhRCGfrmni7ea5W9j/hdU3hhmyNJwinLBFG5+byNYnC+H2q8O9K5+WfvqnCOEeZQyCUYJIIpoCjWAaxW3pSzySg8eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730495347; c=relaxed/simple;
	bh=gYqBqpZUsKsGxUTeaAzPRaTiBApNmP7gi4o+2m2jqSs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IjQ33wngbLcuFK8iX1V2shkR7h4jiRoWl+XLhjuv1nBFPrW0soc3pGgh8w71Yq+1TMBVgMF3z1o+2znG+iTfrcZG0575/9ymMlQVczQ/09wAz/z6UB8OPGiCxly26HFr+T2/SAo04SCxX77HLmubna5nLiAYoJ2wepbmRwHFkrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VRTAFUih; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4315baa51d8so20801755e9.0;
        Fri, 01 Nov 2024 14:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730495343; x=1731100143; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PHD7tV1GY5hfwpnKdhaQtJuojhfOJVmzZyf74ZOv7fE=;
        b=VRTAFUihGiZ3noynpmjr09LF0/RPrx+pWxuFzd14S4YVknxi4AG+/6mrTYyl3qzgnA
         K/Tm0i1EWrkx6XPN3HPDlXfHZivoOp9ePiedlem7V0ww7pxeEi7vtvKFlVmIyJl76egZ
         KWJtpUAJFHsuRHH96UFsSvbjpFSUsWDp8ThST3tAuBSXgvJs5o40TWpJiXjerL69WuFt
         KCcmGq77BfR3+GBwMBIblSnbvKfPD8m9GOp9NCj4FNDk+CD2nvWFflXgDyo1Y1UuvMQR
         DM8Wq/J3rh0L3xiEVVqfeKuQs1KiHQOfzLIukkIM7XpfW2nJoHfvJgeodzhNOnKIv/Mq
         gu3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730495343; x=1731100143;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PHD7tV1GY5hfwpnKdhaQtJuojhfOJVmzZyf74ZOv7fE=;
        b=YucBJo30bFSQOCoWkDiqaTH/26gQvrBCK5oAQWKDzTrNUJWfKCavSSRP+sXI2oxmgX
         QL0f89JSpeb2vB6Eh41i+gEdlzQtO6DDiRDF/IcqiHBCs3F3L587FpyQWnEQJGWHCM3i
         /7ckvSgh3tvApxUaeUSaqFtrr5CKlX07KUnGfR/uR/J4h+GsOvYdaBP/Uj+pk4QB5Wz7
         2Er+kJh28aOC9RSta0Z5rBnTBdmi6K5K4aSh+Omf8o8WwzFPTk7imuQIrilUPsehBpwe
         78skSs5jKVisJ2N0jjSFDgfr5yeR8nSmkcQSHg3SH06RRGZfOTOBwcJdvWOesTL8ZZov
         TPWg==
X-Forwarded-Encrypted: i=1; AJvYcCUlMvIcC4S2e7pNU4qZgxT8VF3PWxTmGcBoujTj7HuNRHaOWPgd3cXM7uiBU9fZIbdKn1Mbf9A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFYAkiSWRZeqTvHz1P1nDeYGTDhHOFD14UxLdbcUffYwtqKU4O
	1o8SHmL8bCYDcFJaLKJHZpl0dVEaDYicRYLA9jAo3FhGchlhz3f3
X-Google-Smtp-Source: AGHT+IFBhskr4oQ0Tj/fclaUHmjGwKFLsJzbCS45+6JXXy7CdV9N5SxA2WieF6JLmBtsQibvvqEu4g==
X-Received: by 2002:a5d:6c61:0:b0:35f:d70:6193 with SMTP id ffacd0b85a97d-381bea1c0c9mr7259547f8f.41.1730495343143;
        Fri, 01 Nov 2024 14:09:03 -0700 (PDT)
Received: from [192.168.42.19] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10d4991sm6224526f8f.29.2024.11.01.14.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 14:09:02 -0700 (PDT)
Message-ID: <af9a249a-1577-40fd-b1ba-be3737e86b18@gmail.com>
Date: Fri, 1 Nov 2024 21:09:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-12-dw@davidwei.uk>
 <CAHS8izNbNCAmecRDCL_rRjMU0Spnqo_BY5pyG1EhF2rZFx+y0A@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izNbNCAmecRDCL_rRjMU0Spnqo_BY5pyG1EhF2rZFx+y0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/24 20:06, Mina Almasry wrote:
...
>> +__maybe_unused
>> +static const struct memory_provider_ops io_uring_pp_zc_ops;
>> +
>> +static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
>> +{
>> +       struct net_iov_area *owner = net_iov_owner(niov);
>> +
>> +       return container_of(owner, struct io_zcrx_area, nia);
>> +}
>> +
> 
> We discussed this before I disappeared on vacation but I'm not too
> convinced to be honest, sorry.
> 
> It's invalid to call io_zcrx_iov_to_area on a devmem niov and vice
> versa, right? So current and future code has to be very careful to

Yes

> call the right helpers on the right niovs.
> 
> At the very least there needs to be a comment above all these
> container_of helpers:
> 
> /* caller must have verified that this niov is devmem/io_zcrx */.
> 
> However I feel like even a comment is extremely error prone. These
> container_of's are inside of the call stack of some helpers. I would
> say we need a check. If we're concerned about performance, the check
> can be behind DEBUG_NET_WARN_ON(), although even that is a bit iffy,
> but could be fine. Doing this without a check seems too risky to me.

No, it doesn't need a check nor it needs a comment. The very
essence of virtual function tables is that they're coupled
together with objects for which those function make sense and
called only for those objects. The only way to get here with
invalid net_iovs is to take one page pool and feed it with
net_iovs from other another page pool that won't be sane in
the first place.

That would be an equivalent of:

struct file *f1 = ...;
struct file *f2 = ...;

f1->f_op->read(f2, ...);

Maybe it looks strange for you in C, but it's same as putting
comments that a virtual function that it should be called only
for objects of that class:

struct A {
	virtual void foo() = 0;
};
struct B: public A {
	void foo() override {
		// we should only be called with objects of type
		// struct B (or anything inheriting it), check that
		if (!reinterpret_cast<struct B*>(this))
			throw;
		...
	}
}


>>   static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
>>                                   struct io_uring_zcrx_ifq_reg *reg)
>>   {
>> @@ -99,6 +114,9 @@ static int io_zcrx_create_area(struct io_ring_ctx *ctx,
>>                  goto err;
>>
>>          for (i = 0; i < nr_pages; i++) {
>> +               struct net_iov *niov = &area->nia.niovs[i];
>> +
>> +               niov->owner = &area->nia;
>>                  area->freelist[i] = i;
>>          }
>>
>> @@ -230,3 +248,200 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
>>   {
>>          lockdep_assert_held(&ctx->uring_lock);
>>   }
>> +
>> +static bool io_zcrx_niov_put(struct net_iov *niov, int nr)
>> +{
>> +       return atomic_long_sub_and_test(nr, &niov->pp_ref_count);
>> +}
>> +
>> +static bool io_zcrx_put_niov_uref(struct net_iov *niov)
>> +{
>> +       if (atomic_long_read(&niov->pp_ref_count) < IO_ZC_RX_UREF)
>> +               return false;
>> +
>> +       return io_zcrx_niov_put(niov, IO_ZC_RX_UREF);
>> +}
>> +
> 
> Sorry, I have to push back a bit against this. The refcounting of
> netmem is already complicated. the paged netmem has 2 refcounts and
> care needs to be taken when acquiring and dropping refcounts. net_iov
> inherited the pp_ref_count but not the paged refcount, and again need
> some special handling. skb_frag_unref takes very special care checking

Which is why it's using net_iovs.

> pp->recycle, is_pp_netmem, and others to figure out the correct

pp->recycle has nothing to do with the series. We don't add
it in any special way, and if it's broken it's broken even
for non-proivder buffers.

> refcount to put based on the type of the netmem and skb flag.

Just same as with the ->[un]readable flag, which is not
functionally needed, and if it's screwed many things can
go very wrong.

> This code ignores all these generic code
> skb_frag_unref/napi_pp_put_page/etc paths and uses raw access to

I don't see the point, they are not used because they're not
needed. Instead of checking whether it came from a page pool
and whether it's net_iov or not, in the path io_uring returns
it we already apriori know that they're from a specific page
pool, net_iov and from the current provider.

Same for optimisations provided by those helpers, they are
useful when you're transferring buffers from one context to
another, e.g. task recieve path -> napi / page_pool. In this
case they're already fetched in the right context without any
need to additionally jumping through the hoops. If anything,
it'd be odd to jump out of a window to climb a rope on the
other side of the building when you could've just walked 5
meters to the other room.

> niv->pp_ref_count. If this is merged as-is, for posterity any changes

Ok, let's add a helper then

> in netmem refcounting need to also account for this use case opting
> out of these generic code paths that handle all other skb reffing
> including devmem.
> 
> Additionally since you're opting out of the generic unreffing paths
> you're also (as mentioned before) bypassing the pp recycling. AFAICT
> that may be hurting your performance. IIUC you refill
> PP_ALLOC_CACHE_REFILL (64) entries everytime _alloc_netmems is
> entered, and you don't recycle netmem any other way, so your slow path
> is entered 1/64 of the page_pool_alloc calls? That should be much

One virtual call per 64 buffers gets enough of ammortisation. The
cache size can be extended if necessary.

> worse than what the normal pp recycling does, which returns all freed
> netmem into its alloc.cache or the ptr_ring and hits *_alloc_netmems

You return it from a syscall (a special sockopt), I'm pretty sure
overhead of just that syscall without any handling would be more
expensive than one virtual function call. Then you need to hit the
fast cache, and it's not unconditional, it has to be lucky enough
so that napi is not run or scheduled, and even then it has to
be very careful to avoid races. That's the best case for <64 entries
recycling, otherwise it's ptr_ring and spinlocks.

Note, the normal (non-zc) recycling happens in the receive
syscall, but it's not the normal path, and just like devmem we
have to give the buffer to the user and wait until it's returned
back.
  
> much more rarely. There are also regular perf improvements and testing
> to the generic pool recycling paths you're also opting out of.

For performance, see above. As for testing, tests come after code
functionality, not the other way around. Why we're even adding any
zero copy and interface when it could be old good and well tested
non-zerocopy recv(2)

> I see a lot of downsides to opting out of the generic use cases. Is
> there any reason the normal freeing paths are not applicable to your
> use case?
> 
>> +static inline void io_zc_add_pp_cache(struct page_pool *pp,
>> +                                     struct net_iov *niov)
>> +{
>> +}
>> +
> 
> Looks unused/empty.

Indeed, slipped through.
...

-- 
Pavel Begunkov

