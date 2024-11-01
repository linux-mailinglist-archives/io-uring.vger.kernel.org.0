Return-Path: <io-uring+bounces-4323-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0575D9B973A
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 19:17:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28CB71C20E5A
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 18:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7076C196D80;
	Fri,  1 Nov 2024 18:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RAeH6rW5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910401CEAA4;
	Fri,  1 Nov 2024 18:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730484982; cv=none; b=M8XZFLgy8hcCqech6c8HDOlLQqbRn5vEfSzjTKP5v+k3ndrtk+oUwmohrtiYkNlqrF/VfR6iv3BUIupY0nKKEcXctumqtw/LMHRpyLFURYhowGdkZTQ+3LnQ9nw7thyMTIqXQKEFXQv0EsGWSpEPna0gT/FXTmdod+DrTVa9bIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730484982; c=relaxed/simple;
	bh=0FR/njw452jCVSO4SsQ9lRF6aQwJcXYFDa74fwjd7xU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kli2LW5KkP77VL/F3jORLKfvCdqth3t2hfFntm/0IpnX/cHTS6pmBUzq71P7PA9WXT5podsWVk4maTujia9QrLlC1sJGC6GAV35GP1amdWCIyA/74KdG2yNV9xy3pzdwo6eW1Tte2bWEHYKd52ZudairwFZu75j6xGIDpsIfyPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RAeH6rW5; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43163667f0eso18815705e9.0;
        Fri, 01 Nov 2024 11:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730484979; x=1731089779; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cc4lXFKgcyUIAuEC6kZ9N4WBDUARabN2Mw/9c+S8Xsw=;
        b=RAeH6rW5kWb5ME5WurdlJIRXNC8K59CZlvmVjf6YofVxOFRe8Bw1oDGcgMcS2r3Wav
         NslruWQfEOeKWEFuQIyOtMgHjoDkAS9M8D1FTC90t7b2VQm2BofmnshwhdPhH23sWvtZ
         adWg/VstzzpMw4qW3Nc4P4aRFyWiCz4/Uj6/lM50EMNWXTR7JcPsfhMALYzgn/Ldee0F
         /iiSPoaSyaAUgPLQiGpmYhAZ9Pgi2zQRpHYu6CciU69nWAAAdMmgTvzQ4VLFRRxYiB7I
         TxS7A5RX7Uwa76TCvrfYG6hDf694rVADc/rbdEwEdnJNj/lRRQh0uXoAVd0oOPBY/R3P
         xl2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730484979; x=1731089779;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cc4lXFKgcyUIAuEC6kZ9N4WBDUARabN2Mw/9c+S8Xsw=;
        b=jkogd5jZs6FGi1ZPmHdiXYYQo2gAPTRnqUVbC6aEHCCGj+FsmGmQ2wLmM1z5ebAJZi
         wXN+zvFcyDl/Q1SXhTARDJZkZUpv/ffo4/fgk0UxET+FzWZZ+LUdmOfN0TeHOMMhmK/e
         Fyha6f8E4avp3weWhjY7BBSxGuHHu2iYFzQ7I7Q/p28mIez7UR988CXQ0kai9zx7OeH+
         m1sYyQxj4RdPnVWyoXLK2IuxD6C5+8/8VqLZbN3zBvsAdVVNMc7Y2E5v9W0yQ+fXlHlL
         rFOSVnsKcIKldonc8EzYZi+98OZrOT0nL2UXAAmUWMZIift69d/cChwduJHKwsXHTCzU
         CATQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhbjxZLWnFiGVsFhyn8isExjSio12if+SWZS2XFX0F8c8GSNc2U76S/2HWnTMJYuyzYVR/mhI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxacGxPh3VIrxPDB8mTnF1K6bp0nNHbQdBTDzRkIgDM62eBwJF
	5RU2k4dzUwR0IDBXyg/tsDZhxbJLmKHDk9Bieq2R8BLn9PBcW2YN
X-Google-Smtp-Source: AGHT+IElKTn819yNPTSho21gH78+hoFX4HkE49vG5ci5mpB3stuKhjkJP3WgO8moYPZrDmK6WDB6gA==
X-Received: by 2002:a05:600c:3150:b0:431:5ce5:4864 with SMTP id 5b1f17b1804b1-432832aa0b1mr34058125e9.35.1730484978490;
        Fri, 01 Nov 2024 11:16:18 -0700 (PDT)
Received: from [192.168.42.19] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4327d5c65c7sm69352105e9.19.2024.11.01.11.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 11:16:18 -0700 (PDT)
Message-ID: <2928976c-d3ea-4595-803f-b975847e4402@gmail.com>
Date: Fri, 1 Nov 2024 18:16:30 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/15] net: page pool: add helper creating area from
 pages
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-7-dw@davidwei.uk>
 <CAHS8izMkpisFO1Mx0z_qh0eeAkhsowbyCqKqvcV=JkzHV0Y2gQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMkpisFO1Mx0z_qh0eeAkhsowbyCqKqvcV=JkzHV0Y2gQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/1/24 17:33, Mina Almasry wrote:
> On Tue, Oct 29, 2024 at 4:06 PM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Add a helper that takes an array of pages and initialises passed in
>> memory provider's area with them, where each net_iov takes one page.
>> It's also responsible for setting up dma mappings.
>>
>> We keep it in page_pool.c not to leak netmem details to outside
>> providers like io_uring, which don't have access to netmem_priv.h
>> and other private helpers.
>>
> 
> I honestly prefer leaking netmem_priv.h details into the io_uring
> rather than having io_uring provider specific code in page_pool.c.

Even though Jakub didn't comment on this patch, but he definitely
wasn't fond of giving all those headers to non net/ users. I guess
I can't please everyone. One middle option is to make the page
pool helper more granular, i.e. taking care of one netmem at
a time, and moving the loop to io_uring, but I don't think it
changes anything.

...
>>   #include <linux/dma-direction.h>
>> @@ -459,7 +460,8 @@ page_pool_dma_sync_for_device(const struct page_pool *pool,
>>                  __page_pool_dma_sync_for_device(pool, netmem, dma_sync_size);
>>   }
>>
>> -static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem)
>> +static bool page_pool_dma_map_page(struct page_pool *pool, netmem_ref netmem,
>> +                                  struct page *page)
> 
> I have to say this is confusing for me. Passing in both the netmem and
> the page is weird. The page is the one being mapped and the
> netmem->dma_addr is the one being filled with the mapping.

the page argument provides a mapping, the netmem gives the object
where the mapping is set. netmem could be the same as the page
argument, but I don't think it's inherently wrong, and it's an
internal helper anyway. I can entirely copy paste the function, I
don't think it's anyhow an improvement.

> Netmem is meant to be an abstraction over page. Passing both makes
> little sense to me. The reason you're doing this is because the
> io_uring memory provider is in a bit of a weird design IMO where the
> memory comes in pages but it doesn't want to use paged-backed-netmem.

Mina, as explained it before, I view it rather as an abstraction
that helps with finer grained control over memory and extending
it this way, I don't think it's such a stretch, and it doesn't
change much for the networking stack overall. Not fitting into
devmem TCP category doesn't make it weird.

> Instead it uses net_iov-backed-netmem and there is an out of band page
> to be managed.
> 
> I think it would make sense to use paged-backed-netmem for your use
> case, or at least I don't see why it wouldn't work. Memory providers

It's a user page, we can't make assumptions about it, we can't
reuse space in struct page like for pp refcounting (unlike when
it's allocated by the kernel), we can't use the normal page
refcounting.

If that's the direction people prefer, we can roll back to v1 from
a couple years ago, fill skbs fill user pages, attach ubuf_info to
every skb, and whack-a-mole'ing all places where the page could be
put down or such, pretty similarly what net_iov does. Honestly, I
thought that reusing common infra so that the net stack doesn't
need a different path per interface was a good idea.

> were designed to handle the hugepage usecase where the memory
> allocated by the provider is pages. Is there a reason that doesn't
> work for you as well?
> 
> If you really need to use net_iov-backed-netmem, can we put this
> weirdness in the provider? I don't know that we want a generic-looking
> dma_map function which is a bit confusing to take a netmem and a page.> 
...
>> +
>> +static void page_pool_release_page_dma(struct page_pool *pool,
>> +                                      netmem_ref netmem)
>> +{
>> +       __page_pool_release_page_dma(pool, netmem);
>> +}
>> +
> 
> Is this wrapper necessary? Do you wanna rename the original function
> to remove the __ instead of a adding a wrapper?

I only added it here to cast away __always_inline since it's used in
a slow / setup path. It shouldn't change the binary, but I'm not a huge
fan of leaving the hint for the code where it's not needed.

-- 
Pavel Begunkov

