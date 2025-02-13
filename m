Return-Path: <io-uring+bounces-6425-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F6AA35159
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 23:36:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 862BB1890E86
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 22:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F5923A9BB;
	Thu, 13 Feb 2025 22:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WaEr6+/0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F9428A2BF;
	Thu, 13 Feb 2025 22:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739486170; cv=none; b=EN1gdCu4Gb+Cj8DO/h5N+Yi26gGRtyTSw/6EVQ1EzJA4YiOAN5xeOgXzbwu5ufR6KarhzIEiuJVRKt7LK04n+NhWQp7BxTO5I68K5hKd9Yms3YHDovu49QXl569V3TbrkSL6LtzJYzDrzZb1OUUszSm1MTBlaW0La4/d7VyAgoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739486170; c=relaxed/simple;
	bh=b8YXK+PAQe7iLpKqfH4Zqyd1LiYtiuaDceGuhl4FWow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e2LJ6AsSiDRcP3tUn5I0gpOXrmhlhIFJP0++PleCzzn1PRk0zntiuUMX6RN+DgXXOAtvjO9noDXflLYGCF3DJYSwsBJj1c1EwmE5oytb6TMXz5C9PhAzTM3p6zI9c4ycEl+y+oBaMeACE/HjyKm+CEOI+GLJlQvugyp6GtORT60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WaEr6+/0; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-38f29a1a93bso661932f8f.1;
        Thu, 13 Feb 2025 14:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739486166; x=1740090966; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8QgkM4CKIrOB7zZnNdSusnVoGaIEEu2025XfAbdmEc8=;
        b=WaEr6+/0GilMOzM5COv+DopFsI+bOR2ZAN7ha11trDxSY9AU9NomCwCFvyRYLPwGk9
         AnLakyPxcvb9hVNNwS878Oaj5JAzPCM0mdxZPAvJjii9ksGReVrJjV+d8V5G+o9aPH7n
         JiVLep56eF3l7ItrRAEbx2IaTpoxH70aVGY+jQG0bXDKCjocqRcqmRvf7iewabjiU5DK
         +HVuSPoQsaqO+86aQSMBL52EDV+wNDgHmlzWfH2xUoyN9ASQCUTleat07YtZEoXqsApo
         54PgYm6HGxMWG3J2NE8HdWMkA75hLHmSvr1tnlIH5v05CieowDlL2J5eyz6Z7DF9OBjU
         Smog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739486166; x=1740090966;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8QgkM4CKIrOB7zZnNdSusnVoGaIEEu2025XfAbdmEc8=;
        b=ubHxiWZKOIApp337+c04sSCmKhVgSq+RaJYA5WFOv3USrkrvT4h2MnOORVKtHMHjAJ
         Eu8XWvyU5xH33b9IFuVrSLGp0sC0lejCqasJHEO6qNTXUtLeTmrz43aY1IotKvWHpf3O
         wj4uJb18u6iGDogWfL578cvH5/RcNu7dh2e+4Ju8BeLPY77riVVvcHfz4dyGjB1t32pG
         C4OWN7vwA+s1CUOaVObw2U2dpCSEw1MsgdrEbLxXPV1d4NjWUzKFgdw774PnyoA9y3kE
         7AKtni4eysk+qVv1fPBcp6d2OGWWZ0oCinOYxF8CYNdptzG2b4Jq9lrgs4iizlk6KwX/
         aR1g==
X-Forwarded-Encrypted: i=1; AJvYcCU1DhcdqRk78JtrANdJManrJr9+jXc0gOEfWg6T5FKIK2GvpqrYPVSEawLYyaN5tYSGHqpgDOI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtSksYNXfGO6kZ29oyEqa+2RYnSTWvSHkTYRedLqbQQ8gj4oGb
	Rq/A5xYS1RkhSb3vjtnaXpcXqoOiJjQfVU9M+5G6F20tSkLl11r0
X-Gm-Gg: ASbGnctjnInGn8/Ln8PH1ZSNernd8JMaKVmbymIcacd/UmLD2Rz2YfadkEqRH2nbYBu
	bIclNr8ydAhtDmfhJzGR32c33INpDEUbM2YlGy/19iqmXKgi/x5ZRUeYZyTGtcmb6TQthvn50hz
	TLKdAs/ZlEWqCnGDLXFqWD+Gf7KosKTs+RHxXEGJLmhnIce912XUxbNsU7nLi0hMEeq0nmK37wU
	6VAFm4UjUBjDg6MqYT0CiT/0fsFOsxxr3v/9tUfpT9lyF53jTSk1mqD/VECFTAhq3jauntSMI1M
	ERlASr1l0YQMrMuv8XmIS77hyw==
X-Google-Smtp-Source: AGHT+IHK4mKvpdv5/hBcIIA/dl942KqPFgWt6hy/D76b3kdYk+8L7a0BtsljIet6ofJenfgHf7RgCg==
X-Received: by 2002:a5d:6dae:0:b0:38d:dc57:855d with SMTP id ffacd0b85a97d-38dea2eadd8mr11646275f8f.35.1739486166259;
        Thu, 13 Feb 2025 14:36:06 -0800 (PST)
Received: from [192.168.8.100] ([148.252.146.210])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259f7df2sm2971447f8f.84.2025.02.13.14.36.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 14:36:04 -0800 (PST)
Message-ID: <7565219f-cdbc-4ea4-9122-fe81b5363375@gmail.com>
Date: Thu, 13 Feb 2025 22:37:07 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v13 04/11] io_uring/zcrx: implement zerocopy
 receive pp memory provider
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250212185859.3509616-1-dw@davidwei.uk>
 <20250212185859.3509616-5-dw@davidwei.uk>
 <CAHS8izMOrPWx5X_i+xxjJ8XJyP0Kn-WEcgvK096-WEw1afQ75w@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMOrPWx5X_i+xxjJ8XJyP0Kn-WEcgvK096-WEw1afQ75w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/25 20:57, Mina Almasry wrote:
...
>> +static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
>> +{
>> +       struct io_zcrx_area *area = ifq->area;
>> +       int i;
>> +
>> +       if (!area)
>> +               return;
>> +
>> +       /* Reclaim back all buffers given to the user space. */
>> +       for (i = 0; i < area->nia.num_niovs; i++) {
>> +               struct net_iov *niov = &area->nia.niovs[i];
>> +               int nr;
>> +
>> +               if (!atomic_read(io_get_user_counter(niov)))
>> +                       continue;
>> +               nr = atomic_xchg(io_get_user_counter(niov), 0);
>> +               if (nr && !page_pool_unref_netmem(net_iov_to_netmem(niov), nr))
>> +                       io_zcrx_return_niov(niov);
> 
> I assume nr can be > 1? 

Right

If it's always 1, then page_pool_put_netmem()
> does the page_pool_unref_netmem() + page_pool_put_unrefed_netmem() a
> bit more succinctly.
...
>> +       entries = io_zcrx_rqring_entries(ifq);
>> +       entries = min_t(unsigned, entries, PP_ALLOC_CACHE_REFILL - pp->alloc.count);
>> +       if (unlikely(!entries)) {
>> +               spin_unlock_bh(&ifq->rq_lock);
>> +               return;
>> +       }
>> +
>> +       do {
>> +               struct io_uring_zcrx_rqe *rqe = io_zcrx_get_rqe(ifq, mask);
>> +               struct io_zcrx_area *area;
>> +               struct net_iov *niov;
>> +               unsigned niov_idx, area_idx;
>> +
>> +               area_idx = rqe->off >> IORING_ZCRX_AREA_SHIFT;
>> +               niov_idx = (rqe->off & ~IORING_ZCRX_AREA_MASK) >> PAGE_SHIFT;
>> +
>> +               if (unlikely(rqe->__pad || area_idx))
>> +                       continue;
> 
> nit: I believe a lot of the unlikely in the file are redundant. AFAIU
> the compiler always treats the condition inside the if as unlikely by
> default if there is no else statement.

That'd be too presumptious of the compiler. Sections can be reshuffled,
but even without that, the code generation often looks different. The
annotation is in the right place.

...
>> +static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
>> +{
>> +       struct io_zcrx_ifq *ifq = pp->mp_priv;
>> +
>> +       /* pp should already be ensuring that */
>> +       if (unlikely(pp->alloc.count))
>> +               goto out_return;
>> +
> 
> As the comment notes, this is a very defensive check that can be
> removed. We pp should never invoke alloc_netmems if it has items in
> the cache.

Maybe I'll kill it in the future, but it might be a good idea to
leave it be as even page_pool.c itself doesn't trust it too much,
see __page_pool_alloc_pages_slow().

>> +       io_zcrx_ring_refill(pp, ifq);
>> +       if (likely(pp->alloc.count))
>> +               goto out_return;
>> +
>> +       io_zcrx_refill_slow(pp, ifq);
>> +       if (!pp->alloc.count)
>> +               return 0;
>> +out_return:
>> +       return pp->alloc.cache[--pp->alloc.count];
>> +}
>> +
>> +static bool io_pp_zc_release_netmem(struct page_pool *pp, netmem_ref netmem)
>> +{
>> +       struct net_iov *niov;
>> +
>> +       if (WARN_ON_ONCE(!netmem_is_net_iov(netmem)))
>> +               return false;
>> +
> 
> Also a very defensive check that can be removed. There should be no
> way for the pp to release a netmem to the provider that didn't come

Agree, but it's a warning and I don't care about performance
of this chunk to that extent. Maybe we'll remove it later.

> from this provider. netmem should be guaranteed to be a net_iov, and

Not like it matters for now, but I wouldn't say it should be
net_iov, those callback were initially proposed for huge pages.

> also an io_uring net_iov (not dma-buf one), and specifically be a
> net_iov from this particular memory provider.
> 
>> +       niov = netmem_to_net_iov(netmem);
>> +       net_mp_niov_clear_page_pool(niov);
>> +       io_zcrx_return_niov_freelist(niov);
>> +       return false;
>> +}
>> +
>> +static int io_pp_zc_init(struct page_pool *pp)
>> +{
>> +       struct io_zcrx_ifq *ifq = pp->mp_priv;
>> +
>> +       if (WARN_ON_ONCE(!ifq))
>> +               return -EINVAL;
>> +       if (pp->dma_map)
>> +               return -EOPNOTSUPP;
> 
> This condition should be flipped actually. pp->dma_map should be true,
> otherwise the provider isn't supported.

It's not implemented in this patch, which is why rejected.
You can think of it as an unconditional failure, even though
io_pp_zc_init is not reachable just yet.

>  From the netmem.rst docs we require that netmem page_pools are
> configured with PP_FLAG_DMA_MAP.
> 
> And we actually check that pp->dma_map == true before invoking
> mp_ops->init(). This code shouldn't be working unless I missed
> something.
> 
> Also arguably this check is defensive. The pp should confirm that

Sure, and I have nothing against defensive checks in cold paths

> pp->dma_map is true before invoking any memory provider, you should
> assume it is true here (and the devmem provider doesn't check it
> IIRU).

-- 
Pavel Begunkov


