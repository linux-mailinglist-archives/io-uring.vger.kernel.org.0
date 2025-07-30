Return-Path: <io-uring+bounces-8864-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A48E9B16271
	for <lists+io-uring@lfdr.de>; Wed, 30 Jul 2025 16:15:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD1B75434E1
	for <lists+io-uring@lfdr.de>; Wed, 30 Jul 2025 14:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA3115853B;
	Wed, 30 Jul 2025 14:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YNdGN6DD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419A02C3264;
	Wed, 30 Jul 2025 14:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753884916; cv=none; b=aCviZFddU1vJCDGLZdU0S/dxHY52E7jEUV/GxUgVhD88S5gjk92M06XFIIv2l6osaQmT8xDlSlzsi3bBaxWaEUO7Hmvsi+/BQdyz4cslcNYHsjsTdhYCpXh3toPAE3iv4U09285xvY5wa8tKxhZToh4GG2o/1Frrl4lBLPObfzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753884916; c=relaxed/simple;
	bh=Z8WKZF1qAcB2oc/3RY6CB39RFCZu1U0ELTHjaUz8veg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hJhIB/8Mf7mSfF/qxxz1o6axubeVrYxpY90oRp58fiQsd7Rcqb3ZaTueTWG9soCPz9Plcu4Vj4Usg4ZWXixIO7d0/x4KrCWfUBiexsb+BjGEO+YvlQFgCIdVKNd/ikVofj38YNuzpLaAXD+nvq87go/7HAVT7ZRkCriMU8L+V8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YNdGN6DD; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4561607166aso6846285e9.2;
        Wed, 30 Jul 2025 07:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753884912; x=1754489712; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cj7xuCDwSSUyk/P3n0X0MKFMXCloTe+RUvJmTVUwO7w=;
        b=YNdGN6DDPu7y+agngfA7hbjbvGxhlXghjczBTAbeI5oG2bAhdgc3p2kOU0fLE1WNfT
         Pq9WlBe2v8BPCKSSKpykHG5VXFOmPztK+dm7Wvbm4aGXo5N2+lQ4bY5v8ic6j2cwZdpg
         uD7mQGRNX16jD52sG58myjLBdMU/PWlnkbiUHHBXsHTPp62SDW9UFwqIBL8W5GLyl+Gf
         8qb6JiuH2tTEX6mt1weyKMsLpcau3Dox6zyC6Yl/xXZKWh0URaoQMO1tXlZU9s0q9qH4
         UZGLpyr4bb6iXqsfe/v1OAWVflqkOtVD6XpPt/TO2mKDHMC8ya28VF+2zmH4jMroDeg/
         wXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753884912; x=1754489712;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cj7xuCDwSSUyk/P3n0X0MKFMXCloTe+RUvJmTVUwO7w=;
        b=pnxG+STro2Ymtvj4TYkKoJkJdazvO0VPyPYwqhbSErz4pSbApWLzFOFEovbhtOQoz3
         4RuWiJwUfinu86i7C03Zgm+5K6BBcSw3aGohN73hvV95APp/xlXJaJ7UQybizspG8mj+
         gEomZepvkyDaFj/WvWHxSm9glBgbcrfgBOis/tk8kEQAMpqSqt6AXu/Bo4NbmlIHWshF
         tuXquQbkTvY+LuNN042VLDmcIHIU8Q+9NlQtxYiAko1ZoUJ25JKxKcWLllMXjz7H6rHJ
         zu7nwUsN0ukCwdSwkwVFlBTHksJQ7OfWZJia5E9rb0Tp6zPBJeE0GkQfSAyThV5O0avX
         2xcA==
X-Forwarded-Encrypted: i=1; AJvYcCWKgNrFu7ia8Hz21YOFTJWdRwbtoDZ1bZgNA1QBIPFTCqaB8+Afj9ED1fAQpDge5KWlGuHGWRHijg==@vger.kernel.org, AJvYcCWoMEqyY78ioTu1ImlUgw5Tge0qeRMmFXwIlP/N8DhV+28x+WAsEzR27HVWiTUQwQ+JOX8YYj6M@vger.kernel.org
X-Gm-Message-State: AOJu0YwE5d/YAOG0M2y5Z6rwKMrztetyKpp7OB92O3Z5VNuS10pgxMR1
	gTgGWBIlQteXDdPvKs5mqmF6gcWAO05u+blB4EvLBPraNuka7ezfZ+Hi
X-Gm-Gg: ASbGncsjHSKV08/TsmLO4zn0W3TxTcVcZf3yiKo3ypTiOypoc3BQm26JlR3FK4wq1cE
	vAABcMEwz2iqBOO138N3t7Hxvm9LGvpSij9i8M/Fmg3mX3FC2V4w0OcxKpnR6Wlf4iOg3SWZ58h
	3qgxhavdKd4T3kH0OnoKiOn3atQzuGrx8chmwneKbrcvBfRTcKpkuNRFA8bJ0QzwRHO49+9lUIR
	+2/PC99ZcFyKYpNGj2t0iFCsrxWKNuWbJTSRqOA+QdPHLdoDemf5GU3dU6gvtIV33I231dvvbwe
	h2YNAFhQeFdCH9eNIa9SQusBJwSkQbZhPi5sq3YWPTf91J13f/yo4Wt6UVNdOpfzJhEHzJ243sW
	VuUyed38BjjNRUEHzPkAGQYuRHGb36uE=
X-Google-Smtp-Source: AGHT+IFx7mPxi3CjVwR8c+QyP8py8CNpyrqCbScdwGU3T/I1wbdAvN7Yc1/oaXIxtCZEEJKP6CE9yA==
X-Received: by 2002:a05:600c:1da2:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-45892b9dfc9mr45740355e9.10.1753884912086;
        Wed, 30 Jul 2025 07:15:12 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.165])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589536bc42sm28991685e9.7.2025.07.30.07.15.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 07:15:11 -0700 (PDT)
Message-ID: <46fabfb5-ee39-43a2-986e-30df2e4d13ab@gmail.com>
Date: Wed, 30 Jul 2025 15:16:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 00/22] Large rx buffer support for zcrx
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, almasrymina@google.com, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com
References: <cover.1753694913.git.asml.silence@gmail.com>
 <aIevvoYj7BcURD3F@mini-arch> <df74d6e8-41cc-4840-8aca-ad7e57d387ce@gmail.com>
 <aIfb1Zd3CSAM14nX@mini-arch> <0dbb74c0-fcd6-498f-8e1e-3a222985d443@gmail.com>
 <aIf0bXkt4bvA-0lC@mini-arch> <52597d29-6de4-4292-b3f0-743266a8dcff@gmail.com>
 <aIj3wEHU251DXu18@mini-arch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aIj3wEHU251DXu18@mini-arch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/25 17:33, Stanislav Fomichev wrote:
> On 07/28, Pavel Begunkov wrote:
>> On 7/28/25 23:06, Stanislav Fomichev wrote:
>>> On 07/28, Pavel Begunkov wrote:
>>>> On 7/28/25 21:21, Stanislav Fomichev wrote:
>>>>> On 07/28, Pavel Begunkov wrote:
>>>>>> On 7/28/25 18:13, Stanislav Fomichev wrote:
>>>> ...>>> Supporting big buffers is the right direction, but I have the same
>>>>>>> feedback:
>>>>>>
>>>>>> Let me actually check the feedback for the queue config RFC...
>>>>>>
>>>>>> it would be nice to fit a cohesive story for the devmem as well.
>>>>>>
>>>>>> Only the last patch is zcrx specific, the rest is agnostic,
>>>>>> devmem can absolutely reuse that. I don't think there are any
>>>>>> issues wiring up devmem?
>>>>>
>>>>> Right, but the patch number 2 exposes per-queue rx-buf-len which
>>>>> I'm not sure is the right fit for devmem, see below. If all you
>>>>
>>>> I guess you're talking about uapi setting it, because as an
>>>> internal per queue parameter IMHO it does make sense for devmem.
>>>>
>>>>> care is exposing it via io_uring, maybe don't expose it from netlink for
>>>>
>>>> Sure, I can remove the set operation.
>>>>
>>>>> now? Although I'm not sure I understand why you're also passing
>>>>> this per-queue value via io_uring. Can you not inherit it from the
>>>>> queue config?
>>>>
>>>> It's not a great option. It complicates user space with netlink.
>>>> And there are convenience configuration features in the future
>>>> that requires io_uring to parse memory first. E.g. instead of
>>>> user specifying a particular size, it can say "choose the largest
>>>> length under 32K that the backing memory allows".
>>>
>>> Don't you already need a bunch of netlink to setup rss and flow
>>
>> Could be needed, but there are cases where configuration and
>> virtual queue selection is done outside the program. I'll need
>> to ask which option we currently use.
> 
> If the setup is done outside, you can also setup rx-buf-len outside, no?

You can't do it without assuming the memory layout, and that's
the application's role to allocate buffers. Not to mention that
often the app won't know about all specifics either and it'd be
resolved on zcrx registration.

>>> steering? And if we end up adding queue api, you'll have to call that
>>> one over netlink also.
>>
>> There is already a queue api, even though it's cropped IIUC.
>> What kind of extra setup you have in mind?
> 
> I'm talking about allocating the queues. Currently the zc/devmem setup is
> a bit complicated, we need to partition the queues and rss+flow
> steer into a subset of zerocopy ones. In the future we might add some apis
> to request a new dedicated queue for the specific flow(s). That should
> hopefully simplify the design (and make the cleanup of the queues more
> robust if the application dies).

I see, would be useful indeed, but let's not over complicate things
until we have to, especially since there are reasons not to. For
the configuration, I was arguing for a while that it'd be great to
have an allocated queue wrapped into an fd, so that all
containerisation / queue passing / security / etc. questions just
solved in a generic and ubiquitous way.

>>>>> If we assume that at some point niov can be backed up by chunks larger
>>>>> than PAGE_SIZE, the assumed workflow for devemem is:
>>>>> 1. change rx-buf-len to 32K
>>>>>      - this is needed only for devmem, but not for CPU RAM, but we'll have
>>>>>        to refill the queues from the main memory anyway
>>>>
>>>> Urgh, that's another reason why I prefer to just pass it through
>>>> zcrx and not netlink. So maybe you can just pass the len to devmem
>>>> on creation, and internally it sets up its queues with it.
>>>
>>> But you still need to solve MAX_PAGE_ORDER/PAGE_ALLOC_COSTLY_ORDER I
>>> think? We don't want the drivers to do PAGE_ALLOC_COSTLY_ORDER costly
>>> allocation presumably?
>>
>> #define PAGE_ALLOC_COSTLY_ORDER 3
>>
>> It's "costly" for the page allocator and not a custom specially
>> cooked memory providers. Nobody should care as long as the length
>> applies to the given provider only. MAX_PAGE_ORDER also seems to
>> be a page allocator thing.
> 
> By custom memory providers you mean page pool? Thinking about it more,

zcrx / devmem. I'm just saying that in situations where zcrx sets
the size for its queues and that only affects zcrx allocations and
not normal page pools, PAGE_ALLOC_COSTLY_ORDER is irrelevant.

I agreed on dropping the netlink queue size set, which leaves the
global size set, but that's a separate topic.

> maybe it's fine as is as long as we have ndo_queue_cfg_validate that
> enforces sensible ranges..

-- 
Pavel Begunkov


