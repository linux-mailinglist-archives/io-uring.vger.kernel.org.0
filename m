Return-Path: <io-uring+bounces-3641-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D710999BC94
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 00:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E27A1C209F3
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 22:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8E48335D3;
	Sun, 13 Oct 2024 22:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QJPI9/z1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106671BC20;
	Sun, 13 Oct 2024 22:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728858781; cv=none; b=jc4eB8XEyQbCAHTqQT8985v8wG6i4T9rddv5mmAVupDa4GbDbX0hwhegz/1OYwpnUlRxL2uq5SMcOaLW9Jjz8yZamMEOvF9ExejhLJqHx/08JN8QLMgPoejRXgXi+HihbnIpToTvYa2M4DeFN624seT6Ucoa5rEsUeHjnUiLdhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728858781; c=relaxed/simple;
	bh=tKWiA7M5xxTeQjlMq2HHHxUIXeqjf36pNoMnHjW8SFM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Sho3Lg5Qgk+s7N7MlgoP42gSQ3TK+xamZEPsGlr2atECc4FA0m5LCyEMoJnr0NEwZnsun1Nr7cZiGd7mW+6yex+JowoepX6vW0BXA2K8IWWxmDqrYubfppBTc9lSkEQgcPxPRBC6vRCP9kMhhAQpGGhNqJABJ+Azuwi75oaBnJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QJPI9/z1; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c949d60d84so2913436a12.1;
        Sun, 13 Oct 2024 15:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728858778; x=1729463578; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lk2mrDGJXqsEn6DSAy7SDtXamQlcgvhrM5bB3UNVS20=;
        b=QJPI9/z1BlN8BbK7UmRVKt0yNybEgjzu+bsQ/kDTS5muNjNDY54wdnUnYRcZf2La6b
         crLBkf2L8+Ac7SqtO++ZULc0wt0hJ/9VMflZITrYQ68fCPNTca6ZPx9SImow/D4IOaey
         p29/lvdIQjF/rdkHuNe01yx+/AaVS+aU00+y9EECOWLDaKBEN+EgaQkCTqyZbLQVxAji
         w2SOYnqKKoA9hbgq9/9VtFIX4pMH/yr86Yt2ch7Q175b1vMDsxlad0Qj0Qg23ySxSbsw
         0LWrGDNOwSqt0lm3pp0TzJMULybAfpull8teFeiY+MWeeHVRXE/VA0R2SOxZF+oUStf3
         EjRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728858778; x=1729463578;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lk2mrDGJXqsEn6DSAy7SDtXamQlcgvhrM5bB3UNVS20=;
        b=oO5xGYq40exT7RRfHN7rZJacAu7GecrjPntxHbB+mcw9IDjkzZg1I1T5EaZuKo/AGs
         C9JUAlHUHD8j7KFYuXhxKQWdWjYAFA+/driTJQCuH8d7y63PO4Kf2/zkZuuURff/04PX
         vUk8jFpu1UnJ1lfYPw2Er+aOehPu6W42Wy5koPBiC8X0MiAF5zC6GRqmIEP5vqIqp+S3
         Q2w4MrOugENYQLz7R7plCJVMQECZoTbn5G8SQtkixGBcfpDYDaXt3e19lBfcRBayuofd
         L4+w8D+L86MOU99t15i1NUUDwOSNXul3dMHXbcjeVPKwz4KvzCq/K3I9ZWZsFac2XnxT
         4rnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzF72CMAZTeL6OtvgnVYhBfDzof0njvve0Dq0Ewym439Y8uLwugtyJOxIYzukELCvFeEkwH7o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7SEF0GAC3ejhGJBrOljZrSDrqIwCwLnSlZpuOZLhgGy6u0Jo2
	57aMCCW8y6T4pZCcopAZoQ18i47Hk4BM87ZC4dF3jXuoo5tUvH5I
X-Google-Smtp-Source: AGHT+IEeora+mJJnXiYHOPlk4dCZMOCciA/w9ixOtcJBKY259m2Em1oqKzzNIKOGawwBiTnUiZTDcg==
X-Received: by 2002:a05:6402:520b:b0:5c9:7f41:eb19 with SMTP id 4fb4d7f45d1cf-5c97f41f747mr400081a12.4.1728858777950;
        Sun, 13 Oct 2024 15:32:57 -0700 (PDT)
Received: from [192.168.42.245] ([85.255.233.136])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c9370d3795sm4174127a12.9.2024.10.13.15.32.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2024 15:32:56 -0700 (PDT)
Message-ID: <947d1299-90e6-440d-a7a1-ca54458ccad3@gmail.com>
Date: Sun, 13 Oct 2024 23:33:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 05/15] net: prepare for non devmem TCP memory providers
From: Pavel Begunkov <asml.silence@gmail.com>
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-6-dw@davidwei.uk>
 <CAHS8izOqNBpoOTXPU9bJJAs9L2QRmEg_tva3sM2HgiyWd=ME0g@mail.gmail.com>
 <c16651d1-5ab3-4233-841b-7a9681f80b0c@gmail.com>
Content-Language: en-US
In-Reply-To: <c16651d1-5ab3-4233-841b-7a9681f80b0c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/9/24 22:45, Pavel Begunkov wrote:
> On 10/9/24 21:56, Mina Almasry wrote:
>> On Mon, Oct 7, 2024 at 3:16 PM David Wei <dw@davidwei.uk> wrote:
>>>
>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>
>>> There is a good bunch of places in generic paths assuming that the only
>>> page pool memory provider is devmem TCP. As we want to reuse the net_iov
>>> and provider infrastructure, we need to patch it up and explicitly check
>>> the provider type when we branch into devmem TCP code.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> Signed-off-by: David Wei <dw@davidwei.uk>
>>> ---
>>>   net/core/devmem.c         |  4 ++--
>>>   net/core/page_pool_user.c | 15 +++++++++------
>>>   net/ipv4/tcp.c            |  6 ++++++
>>>   3 files changed, 17 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/net/core/devmem.c b/net/core/devmem.c
>>> index 83d13eb441b6..b0733cf42505 100644
>>> --- a/net/core/devmem.c
>>> +++ b/net/core/devmem.c
>>> @@ -314,10 +314,10 @@ void dev_dmabuf_uninstall(struct net_device *dev)
>>>          unsigned int i;
>>>
>>>          for (i = 0; i < dev->real_num_rx_queues; i++) {
>>> -               binding = dev->_rx[i].mp_params.mp_priv;
>>> -               if (!binding)
>>> +               if (dev->_rx[i].mp_params.mp_ops != &dmabuf_devmem_ops)
>>>                          continue;
>>>
>>
>> Sorry if I missed it (and please ignore me if I did), but
>> dmabuf_devmem_ops are maybe not defined yet?
> 
> You exported it in devmem.h

A correction, this patchset exposed it before. This place is
fine, but I'll wrap it around into a function since it causes
compilation problems in other places for some configurations.


>> I'm also wondering how to find all the annyoing places where we need
>> to check this. Looks like maybe a grep for net_devmem_dmabuf_binding
>> is the way to go? I need to check whether these are all the places we
>> need the check but so far looks fine.
> 
> I whac-a-mole'd them the best I can following recent devmem TCP
> changes. Would be great if you take a look and might remember
> some more places to check. And thanks for the review!
> 

-- 
Pavel Begunkov

