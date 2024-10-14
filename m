Return-Path: <io-uring+bounces-3660-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4682699CB9F
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 15:37:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F2BA1C21BDF
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 13:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927281A726B;
	Mon, 14 Oct 2024 13:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dDc8rSiU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01821514CB;
	Mon, 14 Oct 2024 13:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728913021; cv=none; b=e2YiZlSDdOQjtflwQrQw34OPkIenUahUJiEmZ/G9ZHF7HrWukdn+Wldc10PFTh4fp6vbQZJtc1o0TpvytkS7Z1tn0OeItzPeMeNAXbUF5A/QJEx3hV+QSaQzXFvWiSS4ltYcbulH8UQHqg+lbVPBBnkqM9QafolzOBUB3fnFMr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728913021; c=relaxed/simple;
	bh=mkohjIqe3KFYc1Se1+fU0hxIZEEb2ISgnoT28BVIcEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cDrejbnUCpyquS1tiBLhxMohgOipXLNTBvuymEr1phX85kIbCqnj53+/wOBON/l4YLwk/S0adQRBxTYu6xtZs2Uh+dI6PE8YV1IUc9W9CZGuZ0eqrakNBTlq0ditKQmRPRP+sVxXbVcz/Fjik5jmby3P8ktHLuZnaw28oq+fAr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dDc8rSiU; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a9a0ec0a94fso142885466b.1;
        Mon, 14 Oct 2024 06:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728913018; x=1729517818; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I2sz3o8o0U5nrnHU9yj9mk1ERgr57OEcLyvibpejIH4=;
        b=dDc8rSiUwMQtPGA0vFrVZnugxrfwuTPuTfkP1GlrAK+6cw2AJYO1uQuqsJgyyM8NRm
         +XODB0a5Uhs6LQc65naf4vwnwGrOXRxQbfvUqLwP12/MVWSZRfVe6HFAWhraTYLWAprT
         6dbmw0xHDVGvRfXTHd2UJVQdBztDD02AWA/yuc2Y/QZgfg9n6wLwJm68Gz87FoYzb996
         pKUbvmvMwYH4gxKFoDpjZ5tziT57StzjOKMn9vyXW78VMN5k92mV7JOJteOYLEo5/uCY
         7uBLIqM9my9aBGW8cJ/uFqev8loao5oOwGshPlnHf65I1685CXPKZ8pY9CDVspjATPbr
         /rUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728913018; x=1729517818;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I2sz3o8o0U5nrnHU9yj9mk1ERgr57OEcLyvibpejIH4=;
        b=UjFLchCwtsgTASUr3A1/Dp32Jkw6h0RO9RW5p1X18VZ0O3CXdIkyvBHM6bxM6nAfDz
         g/HQ78mkmYkiFaMB93Kjlzzdh93Ml5bF111BaFNXbYMFr5bakIzD8i5tNEPhIJ/0MJkO
         weEPST6b1+FR0PBNwvQI9R9lChkzEycTVLiurRTFtm28Jxfzw1cKn4ZLQQduSgqUvKXc
         pLla2IoIbSzJ+dOb14HVsgnnflGD/EUnKwBP1Cw6zKnexwQBqKrhkH6F0qjyR6vCh53A
         2cotaD0YxfSZqCX0qLxLd+zVR57hPgO2AG2qeVBR5QKr/RHgG1pAk+mHHTA9JZY/OOWr
         UFgg==
X-Forwarded-Encrypted: i=1; AJvYcCX3eil0ksWn/ELgT93L7n+q6ezQQwjgCJZglA4yMUmZl60T1rJC1Kv+bBPgrNlWG+OhxBOfqQo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywuf6v8YlwGFw1LPWfQPNP/bJBSvkc2hNODSlkF66G7obgBR97G
	j01+UT9AS2fC37q1Plx4jIXTTvSGvNhKElqSWD8CPBScJaEg4Ruc
X-Google-Smtp-Source: AGHT+IHKMBVuhFfBWqxbKMr0ScumOZyZB+uRWOn+yhmu82KfEMG7ro8nWnv1yvB+rADs1Bu0zQAQ/g==
X-Received: by 2002:a17:907:eab:b0:a9a:1c42:88a4 with SMTP id a640c23a62f3a-a9a1c42b5a8mr106328266b.59.1728913017828;
        Mon, 14 Oct 2024 06:36:57 -0700 (PDT)
Received: from [192.168.42.88] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99f3ffe64csm309881966b.184.2024.10.14.06.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 06:36:57 -0700 (PDT)
Message-ID: <4a33bf2c-49ef-4cfd-97af-8341cdb977d3@gmail.com>
Date: Mon, 14 Oct 2024 14:37:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/15] net: page_pool: add ->scrub mem provider
 callback
To: David Wei <dw@davidwei.uk>, Mina Almasry <almasrymina@google.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-7-dw@davidwei.uk>
 <CAHS8izPFp_Q1OngcwZDQeo=YD+nnA9vyVqhuaT--+uREEkfujQ@mail.gmail.com>
 <9f1897b3-0cea-4822-8e33-a4cab278b2ac@gmail.com>
 <CAHS8izOxsLc82jX=b3cwEctASerQabKR=Kqqio2Rs7hVkDHL4A@mail.gmail.com>
 <5d7925ed-91bf-4c78-8b70-598ae9ab3885@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5d7925ed-91bf-4c78-8b70-598ae9ab3885@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/13/24 18:25, David Wei wrote:
> On 2024-10-10 10:54, Mina Almasry wrote:
>> On Wed, Oct 9, 2024 at 2:58 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> On 10/9/24 22:00, Mina Almasry wrote:
>>>> On Mon, Oct 7, 2024 at 3:16 PM David Wei <dw@davidwei.uk> wrote:
>>>>>
>>>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>>>
>>>>> page pool is now waiting for all ppiovs to return before destroying
>>>>> itself, and for that to happen the memory provider might need to push
>>>>> some buffers, flush caches and so on.
>>>>>
>>>>> todo: we'll try to get by without it before the final release
>>>>>
>>>>
>>>> Is the intention to drop this todo and stick with this patch, or to
>>>> move ahead with this patch?
>>>
>>> Heh, I overlooked this todo. The plan is to actually leave it
>>> as is, it's by far the simplest way and doesn't really gets
>>> into anyone's way as it's a slow path.
>>>
>>>> To be honest, I think I read in a follow up patch that you want to
>>>> unref all the memory on page_pool_destory, which is not how the
>>>> page_pool is used today. Tdoay page_pool_destroy does not reclaim
>>>> memory. Changing that may be OK.
>>>
>>> It doesn't because it can't (not breaking anything), which is a
>>> problem as the page pool might never get destroyed. io_uring
>>> doesn't change that, a buffer can't be reclaimed while anything
>>> in the kernel stack holds it. It's only when it's given to the
>>> user we can force it back out of there.
> 
> The page pool will definitely be destroyed, the call to
> netdev_rx_queue_restart() with mp_ops/mp_priv set to null and netdev
> core will ensure that.
> 
>>>
>>> And it has to happen one way or another, we can't trust the
>>> user to put buffers back, it's just devmem does that by temporarily
>>> attaching the lifetime of such buffers to a socket.
>>>
>>
>> (noob question) does io_uring not have a socket equivalent that you
>> can tie the lifetime of the buffers to? I'm thinking there must be
>> one, because in your patches IIRC you have the fill queues and the
>> memory you bind from the userspace, there should be something that
>> tells you that the userspace has exited/crashed and it's time to now
>> destroy the fill queue and unbind the memory, right?
>>
>> I'm thinking you may want to bind the lifetime of the buffers to that,
>> instead of the lifetime of the pool. The pool will not be destroyed
>> until the next driver/reset reconfiguration happens, right? That could
>> be long long after the userspace has stopped using the memory.
>>
> 
> Yes, there are io_uring objects e.g. interface queue that hold
> everything together. IIRC page pool destroy doesn't unref but it waits
> for all pages that are handed out to skbs to be returned. So for us,
> below might work:
> 
> 1. Call netdev_rx_queue_restart() which allocates a new pp for the rx
>     queue and tries to free the old pp
> 2. At this point we're guaranteed that any packets hitting this rx queue
>     will not go to user pages from our memory provider
> 3. Assume userspace is gone (either crash or gracefully terminating),
>     unref the uref for all pages, same as what scrub() is doing today
> 4. Any pages that are still in skb frags will get freed when the sockets
>     etc are closed
> 5. Rely on the pp delay release to eventually terminate and clean up
> 
> Let me know what you think Pavel.

I'll get to this comment a bit later when I get some time to
remember what races we have to deal with without the callback.

-- 
Pavel Begunkov

