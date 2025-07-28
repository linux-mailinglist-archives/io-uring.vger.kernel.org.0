Return-Path: <io-uring+bounces-8844-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D3B78B143D3
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 23:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE2DC189394D
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 21:27:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1931A23B1;
	Mon, 28 Jul 2025 21:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D6AbPwn8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8652264BF;
	Mon, 28 Jul 2025 21:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753738034; cv=none; b=CQrU5yCs6zUsumQUCKUSqefhE8odPFhCMGZaDfYDkVsdmQRlwzJJjsyd++/F58byRTQI4p8T2vQ9jxeGPF28tFZELteohQEehsGC4PSKIeXNQN8BMg9VyHAy/5yvQ95shY5Ge3CZnlPF5xkmxju8GJ6r9FzMvvQesQje1L1NyDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753738034; c=relaxed/simple;
	bh=IzpvrGp8i14VUfruuB3/KLhb8wxZIHRxsrWtief3KGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s0rvGAKmaFaBLGaS9uVU1y/d6uhHAAVHYbYPW/pqJJQKCgJi+UyT7DvLlmct0zujcpC3WK0F0TJ/iXqkJAtOR7V2tcSJRWxaMvAWD0AdSk6nKUbCqGDOnC/WDIPinry7043MXtL9NnZb/ECLwRsc1uOA4w1ySfK7+x/i6tsjWZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D6AbPwn8; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-60c5b8ee2d9so10225666a12.2;
        Mon, 28 Jul 2025 14:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753738031; x=1754342831; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tIQmwnYTc/cYP7oc2ka+tfN0f6pfnJP/yRiTLhorpT0=;
        b=D6AbPwn8HfjxaQW6K1IRqanr6lk5LsHvPweCHVZFgJlGVe46PbjaLIVHcJ/DOgCRLb
         or7eyFDXh2KngPzMdgnP/YiwnCbR4vvBL0tMLnLnf4zvyOPK2PTv6nIhxj+GjlQVahtz
         VyLb4eepxvx+tG2udNe0X+lCvG7N3btx/76I2vaCpGnia7BR19csz+7VqxeKjSj6v1TW
         K878tCdPehjba5LPn7wZ+WbN5sK+alXj5cW87Osk3vjn6B5RjofbzMscqgh7Db/5rJjU
         49qUL7Z4Q7pTwmKEjOc8yZjHjPMOg45bbLQlKIyxlLawA/Xt1LCl9v8rig8z4ZKnfZZR
         kurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753738031; x=1754342831;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tIQmwnYTc/cYP7oc2ka+tfN0f6pfnJP/yRiTLhorpT0=;
        b=Ddr1Cj62GTrQrDL0+6DaS+yQCicLcowN9HAIaTc7kS/Auy+GA18Zu6+zgHgh/d4iGS
         kCPSF/IHPJX0JwprlTLPwaoSgWA4Biwh7mhEwInINao/nLTOEARN6mMl53NMvy+WBGsl
         daSD7kFWnV/7/M0apV/ZpkzT5Dz9zUsM4PKteH/FykC3kjlqvjBOofixNjFPR49aeS+O
         6Fh/KypbK6Qfdl9gvmEfzgbonrb3h1xMvtosFDPs21+W8bTh1bO076O7YCQsLB4dgNJy
         zFAbhq31sRReeR83v9pbcZC85K3TIMhoNG3tTzOyZ0Ndkse52MItFt9VBGb7/yuhNdKU
         p5uQ==
X-Forwarded-Encrypted: i=1; AJvYcCU341g/niNFRpf4Nvy5jFZNRjRf6Jzi0bYbc+TxWFQBt4hrjBqkj5DscyVsoPA9f9MYLkFFCmHL8A==@vger.kernel.org, AJvYcCWRkj3Ri5KspqdSreM5iWzYtAFRd+2ZwP2ydQUCARL0LY1boPjFu6PlGh37t6uWGwhI5B+VMozz@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7EeExo1V6uwoc7mcZtPw+awTm1+El5kUR/8jhqRL5xho8+xId
	wHMG58svwnAOjtV5efi2qpd0BBB4vMn/Dd6iDXVMtoTA+rLcAEsosu3q
X-Gm-Gg: ASbGncs0yTCbilLkzsyRYw8uplcIid73SoxvR+LHMxSMftnHOASEjoGJeIC/Ufvf+YF
	KU/fkGN2lRxeP/7DOeAMOnfzeAwYhcOAUbtJNZk8/ZJzXkx/OHXaUcIaENgE6AzTE0/hmsVqYGk
	psCra5xBatJlkq8YZQnG3ypWwfO2UWNXYfMFxXyLyTBiWvJkXaHCcEM0pFHUHDNhwS2amgiq4o5
	dYcutbYam2LFvHOgDwRujTh33jWDgQb0zBs3OAlDaSdXgSYxnNiLxFyv7sctpU+WJdnEjIN+Bd5
	oE8FIsOnYiUXelAKiS3vn6IT5QonVgiGkwRqNTefy29TcqQ6QgvtM97cVE4k6dVMNypNQnO0ect
	SyEV5uHHnKFY1/YfWBh56wioRgOQhtDU=
X-Google-Smtp-Source: AGHT+IGam4ANjd1Vl1pbiQeQUrUv5bRUQpJFrhxGJD7I1Bl4dEoOuYd9llkMfRPdZ5ZEkvIAnUgW8A==
X-Received: by 2002:a17:906:f597:b0:ae3:d021:9b05 with SMTP id a640c23a62f3a-af617502b19mr1629178566b.15.1753738030686;
        Mon, 28 Jul 2025 14:27:10 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.164])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af635b4a7fbsm480929266b.148.2025.07.28.14.27.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 14:27:09 -0700 (PDT)
Message-ID: <0dbb74c0-fcd6-498f-8e1e-3a222985d443@gmail.com>
Date: Mon, 28 Jul 2025 22:28:30 +0100
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
 <aIfb1Zd3CSAM14nX@mini-arch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aIfb1Zd3CSAM14nX@mini-arch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/28/25 21:21, Stanislav Fomichev wrote:
> On 07/28, Pavel Begunkov wrote:
>> On 7/28/25 18:13, Stanislav Fomichev wrote:
...>>> Supporting big buffers is the right direction, but I have the same
>>> feedback:
>>
>> Let me actually check the feedback for the queue config RFC...
>>
>> it would be nice to fit a cohesive story for the devmem as well.
>>
>> Only the last patch is zcrx specific, the rest is agnostic,
>> devmem can absolutely reuse that. I don't think there are any
>> issues wiring up devmem?
> 
> Right, but the patch number 2 exposes per-queue rx-buf-len which
> I'm not sure is the right fit for devmem, see below. If all you

I guess you're talking about uapi setting it, because as an
internal per queue parameter IMHO it does make sense for devmem.

> care is exposing it via io_uring, maybe don't expose it from netlink for

Sure, I can remove the set operation.

> now? Although I'm not sure I understand why you're also passing
> this per-queue value via io_uring. Can you not inherit it from the
> queue config?

It's not a great option. It complicates user space with netlink.
And there are convenience configuration features in the future
that requires io_uring to parse memory first. E.g. instead of
user specifying a particular size, it can say "choose the largest
length under 32K that the backing memory allows".

>>> We should also aim for another use-case where we allocate page pool
>>> chunks from the huge page(s),
>>
>> Separate huge page pool is a bit beyond the scope of this series.
>>
>> this should push the perf even more.
>>
>> And not sure about "even more" is from, you can already
>> register a huge page with zcrx, and this will allow to chunk
>> them to 32K or so for hardware. Is it in terms of applicability
>> or you have some perf optimisation ideas?
> 
> What I'm looking for is a generic system-wide solution where we can
> set up the host to use huge pages to back all (even non-zc) networking queues.
> Not necessary needed, but might be an option to try.

Probably like what Jakub was once suggesting with the initial memory
provider patch, got it.

>>> We need some way to express these things from the UAPI point of view.
>>
>> Can you elaborate?
>>
>>> Flipping the rx-buf-len value seems too fragile - there needs to be
>>> something to request 32K chunks only for devmem case, not for the (default)
>>> CPU memory. And the queues should go back to default 4K pages when the dmabuf
>>> is detached from the queue.
>>
>> That's what the per-queue config is solving. It's not default, zcrx
>> configures it only for the specific queue it allocated, and the value
>> is cleared on restart in netdev_rx_queue_restart(), if not even too
>> aggressively. Maybe I should just stash it into mp_params to make
>> sure it's not cleared if a provider is still attached on a spurious
>> restart.
> 
> If we assume that at some point niov can be backed up by chunks larger
> than PAGE_SIZE, the assumed workflow for devemem is:
> 1. change rx-buf-len to 32K
>    - this is needed only for devmem, but not for CPU RAM, but we'll have
>      to refill the queues from the main memory anyway

Urgh, that's another reason why I prefer to just pass it through
zcrx and not netlink. So maybe you can just pass the len to devmem
on creation, and internally it sets up its queues with it.

>    - there is also a question on whether we need to do anything about
>      MAX_PAGE_ORDER/PAGE_ALLOC_COSTLY_ORDER - do we just let the driver
>      allocations fail?
> 2. attach dmabuf to the queue to refill from dmabuf sgt, essentially wasting
>     all the effort on (1)
> 3. on detach, something needs to also not forget to reset the rx-buf-len
>    back to PAGE_SIZE

Sure

> I was hoping that maybe we can bind rx-buf-len to dmabuf for devmem,
> that should avoid all that useless refill from the main memory with
> large chunks. But I'm not sure it's the right way to go either.
-- 
Pavel Begunkov


