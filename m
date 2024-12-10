Return-Path: <io-uring+bounces-5390-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2359EA71F
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 05:14:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7130A16391F
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 724F72248B0;
	Tue, 10 Dec 2024 04:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W6KT24F7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F931B6CF1;
	Tue, 10 Dec 2024 04:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733804065; cv=none; b=r3VtUgpAYTWjhZ7JxWhoUbDSr9LhLd9t+xwkXt4joB4aW1AJTmHvfbpAzq1jUJ/Qaqrt6e0wfVdzi/dbHzScyZZXYNNF2cRi3iq2q+m03PijwknZY+s2opZX/djDsPFMk++GrQBqfbSz7glK2+AnALjea0Cp6W/Phohi2CzBzNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733804065; c=relaxed/simple;
	bh=GXLedB2QpeIbY+JVxpbaRyMxB2K04Wa01+aVAsoinCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b8BHTkE23LWu8Ejore8VNuTTmaPVXtRvlXEP+X6uKV3s//ieJ0RWvkeLdElEOL59Fa6PsRpOnh69PMgbd+tM4K/C+GcaqQDepwwABL0e80t3zvP+Cb31bARoT9Jd79172h1zKkRKcGU0FknKvtgdVomiId/57NP6Pny1JtkaIN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W6KT24F7; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43540bdb448so1261545e9.2;
        Mon, 09 Dec 2024 20:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733804062; x=1734408862; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VldIR0dFLLhJMKpNadkLSWi0aTQvehNzea+L4eiqEQI=;
        b=W6KT24F7Mnv1DqK69+vGLziXK171L4596SSiC5ND98NMlCkBqkLMVw1DKC4fjzrdJg
         aDJ9L/ikX8bG3Eme2ZQfJnh/1TcIc5OyDpp2znpb4CL/MsM9MxaD25BCA4FFzgkHkeHq
         gXwN/ld9mEE5580ZxBbshqGL5XRDEfCaoaYgJi/6hTuIJiD+a3ZXcSHvdsABIfTi/XIv
         ors+xxOyJEvNdkXd4bVyJmCZ2aTJyhtWaugA1c5/S1ToeVTGgenSm2rSqSwYc5sRpTwo
         eM53QViWnhE5O24LGIgqYL0BraD4P+qCCPCxOx7Yn2sJq5HzSlMfkjT7uyxSjFz/tK3s
         HD3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733804062; x=1734408862;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VldIR0dFLLhJMKpNadkLSWi0aTQvehNzea+L4eiqEQI=;
        b=p7r1TWt1nm7z4dp1Bp6y581RLrNLoIpY+Cl/zjODiYeSYZDVrBPzNxesZC5IHRNa+a
         M9Jl9/GOo49jxI6C9Y3Ua483B02E/haH3+2HpwUGYgqYGbZkzkfi40MxWnJL7JQUNvba
         /49NCAo9MFdnqYhTVyRG7ur7v7DftvvkvcIsCTWcnwhJZoxLBBomsrx7xtMpbqfk1JU/
         nlVvw/ezoWqpFX2CRPe66B4hM8L38/fvmuJQ0/ESVU1o2VmcCB5hXm7N22Aq3mGsc8va
         p3v0nw7tV4WtSh7z7aE2+zmXFsfg+qSY7kG1rDTKPEeaTvHKBQy+JmPW2rcqmfhFCfia
         2ohQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4caDCFsTEoCGJcKBPY1CyKkdWqfwu9ONpkzZEpRSkAfA4AWKbnPnzKJ3Q19yrt461NE4ODnRR@vger.kernel.org, AJvYcCUmK2JYm1ZWT1grQAfeSO4iIgXTt7MQpCZHLdeiZMeYE0+ulS3/doiwBKjWthCjkkeYbVkFCSxyog==@vger.kernel.org
X-Gm-Message-State: AOJu0YzovUtttR3UcDlAxk5UeFGb3qLP35GQYyvO+qfisXxnvQYBm0pU
	NQYR0uVooVE1X+csbDg3XgXVY2AWPxEphoFTbTqHXocqapb23NpO
X-Gm-Gg: ASbGncuwhZzhF9EtahUZzJf7S2rcUsjB3mIWskPQtyhGss8txvVhOjI5FnEMGz6+k/q
	M5sFYL91RCG3533LVTbp3S/Ni5YIB5ZTcwfb8cNd4HMVmrfZs1OHFjM+FfLZsrQnZGOiF5a0GLu
	MMgQxkXL8qqzHedyOu3VYWa9OwI9aVC0XDKtOAyREs6O9MXUbBya3PdcZwK2gt+AvaqazxnDwcs
	p7i1hZ8adTBV0Et9M1vffEZgBIJmVhfF1rEqwCHyFCTsTt1p+VtWi5iL37Msls=
X-Google-Smtp-Source: AGHT+IFemr9ZU2feIl2M2VUuN8vIMaDnEUNYiJh4F7uMrSX9mf70nFzi94Ttp/hBMXEt/zacuNwpLQ==
X-Received: by 2002:a05:600c:458c:b0:434:edcf:7464 with SMTP id 5b1f17b1804b1-434fffc0b2bmr26030345e9.30.1733804061734;
        Mon, 09 Dec 2024 20:14:21 -0800 (PST)
Received: from [192.168.42.90] ([85.255.235.153])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434d52c0be4sm214816165e9.28.2024.12.09.20.14.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 20:14:21 -0800 (PST)
Message-ID: <1e1d368c-5a52-421c-9022-57166a8a3340@gmail.com>
Date: Tue, 10 Dec 2024 04:15:13 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 04/17] net: prepare for non devmem TCP memory
 providers
To: Jakub Kicinski <kuba@kernel.org>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-5-dw@davidwei.uk>
 <20241209191526.063d6797@kernel.org>
 <12cb04de-dfbe-4247-b1d6-8e6feae640d8@gmail.com>
 <20241209200636.56a3dbae@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241209200636.56a3dbae@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/10/24 04:06, Jakub Kicinski wrote:
> On Tue, 10 Dec 2024 03:53:36 +0000 Pavel Begunkov wrote:
>>>> @@ -353,16 +356,16 @@ void page_pool_unlist(struct page_pool *pool)
>>>>    int page_pool_check_memory_provider(struct net_device *dev,
>>>>    				    struct netdev_rx_queue *rxq)
>>>>    {
>>>> -	struct net_devmem_dmabuf_binding *binding = rxq->mp_params.mp_priv;
>>>> +	void *mp_priv = rxq->mp_params.mp_priv;
>>>>    	struct page_pool *pool;
>>>>    	struct hlist_node *n;
>>>>    
>>>> -	if (!binding)
>>>> +	if (!mp_priv)
>>>>    		return 0;
>>>>    
>>>>    	mutex_lock(&page_pools_lock);
>>>>    	hlist_for_each_entry_safe(pool, n, &dev->page_pools, user.list) {
>>>> -		if (pool->mp_priv != binding)
>>>> +		if (pool->mp_priv != mp_priv)
>>>>    			continue;
>>>>    
>>>>    		if (pool->slow.queue_idx == get_netdev_rx_queue_index(rxq)) {
>>>
>>> appears to be unrelated
>>
>> The entire chunk? It removes the type, nobody should be blindly casting
>> it to devmem specific binding even if it's not referenced, otherwise it
>> gets pretty ugly pretty fast. E.g. people might assume that it's always
>> the right type to cast to.
> 
> Change is good. It didn't feel very related to the other changes
> which specifically address devmem code. While this one only removes
> the type because the code itself isn't devmem specific. Right?

Right, and nobody cared because there wasn't anyone but devmem
prior to the series.

> if you make this chunk a separate patch #1 in the series I can apply it
> right away. pp->mp_priv is void *, this is a good cleanup regardless.

I can throw it into a separate patch, though let's just keep
it in the series as it'd complicate merging otherwise. Let's
say if it doesn't land this release, I'll send it separately
with 1/17 as clean ups.

-- 
Pavel Begunkov


