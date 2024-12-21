Return-Path: <io-uring+bounces-5589-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B73B9F9D70
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2024 01:50:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7ED1D16AE29
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2024 00:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 008201C32;
	Sat, 21 Dec 2024 00:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ABGWrgfH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7C1163;
	Sat, 21 Dec 2024 00:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734742194; cv=none; b=CWVXgPKHQPdeMOVlUKtqhQ5B0ke8w7fEo66v4FNDuktgotC7vOw5km9MAE9tli4G1LM7hXXrpUjkwBysFWcEzPPAQpthxL/8/oC0ntMbGQGSzGPe8F+6nU0J/4p7OdkfzQtj1BGsIxqm+jZrIW61AQvVcee0hVCIt16ilsZk+RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734742194; c=relaxed/simple;
	bh=SVUEiPqRIvm4db1/9DqcwGe7iYoIvQHWawpvUKd8GeQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zx2fcbGgWXDa8wCuuu8ECf1vvsMpSeb44fSlgfE6+2JUZr5lZF6LRv0bL4WrEmFLJh9/ygu0SWb4SdRgZojAlh+cqT6t986bfZ+sr+DpEhTHbjYOgHjq5Y8dnN6GWtmtZO/5mTrd35CDVkFE4T0DrXWm+EBBjkGKmzE/tlID2rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ABGWrgfH; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-436341f575fso26518805e9.1;
        Fri, 20 Dec 2024 16:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734742191; x=1735346991; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dSzPtgNSx0y5b3UPhZtL4mj4qL312OPvg1+udWx+/5o=;
        b=ABGWrgfHcEFWx3mLUBbJmf5esPZ3vjqKrt9EcVRG/Jx0p8P+nAg2Byw+hNHnej3giW
         NPcVV/LkW1JV0uP+2Ir6nADaA7Znuz9eKCNUYUABpExm+6OVMD+qRxz2CHbdTjpJfyz4
         zToKB6X/6JTM8rcuWGzS/jAPxPBFx+PopocaNggDtVjZ6zEjK0CKaf03LW+dQYL6gXs+
         cB4ivB2o+ATYH7Lje4rVfqXjGzUMTsxpNq0mofVcx/cxDJnZDeSrcofrNHt5ycKxFpxS
         ACJrbftl+rLMglomdBDU0t1cg6e4/dXlZitvnxvdSGZG84DmJGtXKdqD9yXXPekWEa3J
         VWkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734742191; x=1735346991;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dSzPtgNSx0y5b3UPhZtL4mj4qL312OPvg1+udWx+/5o=;
        b=KZdkBhP7Ro50xk5/gjey8f5w+J5EiADH8xLeh2kr/gvZoPXnQjNAdg2IG9lnL56FuU
         W3jNUH0XMVxSGBhQpHB37FyRsziomuGiXs8x70NFwePJhbIr/8bk/veZRQkBG5b7xWlD
         h83yNh0AxJKGYV7LbJIPnbaMy9roe9hpdJeeZ1rspAVs/cv7dCX6HolkMhes6cAUBglM
         UlaOOFagZNYOI/9MsBgyBDhq3Np2nkV8OYIElRw9tIgAS+wNW2g3Rzi+WQI96Ur4wT15
         QDpxoWIvrHrPNQ3+xhPJhW/CxE1B8NulZhEjhRJg5yT/IpywrYmPJrq/jqGycC9e53je
         Kv2A==
X-Forwarded-Encrypted: i=1; AJvYcCUQHPoQx0efgpCS4TOJ+stRitrldLLycBNxf61mHuOmxZw4pGeGvyKeS/37l4zlKeY4qxUsJ0k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVoJTIbAGVj5VWBqkYhvgllHoCGbgaR+w37/WgLVlV1nu17hlD
	sc9ylkz4oWlRPOxjO/KlDmH8Y/i4tIur2/vJ5ZGBY6Jh9xxblnkpF2TimQ==
X-Gm-Gg: ASbGncsplsmaPJ83d+xaa/5z84A2KPwG99Bf1hpuOCZ/TrDPWfDLkGRikAFsDWK7gve
	liE8k3hZDzO9IdbQjOlfgH/91/p8Y00eCtYkbNl6tKrcvPLGJqfjLyhyiIjhrOAnTbvx9L35BRz
	Y9BpwuNmi7tdPs59Gf9stT90RpycUwqvQnRPM1q9x1sdCZYe4EnJzZZwIxXfVqQ2dOtBqu0FCBe
	srUWP4Tifo9EFZb5yUGt+gEtk9GgOnuHyHui/h7m8E2BWBHksJy6b1zAxPZiGFF6Rk=
X-Google-Smtp-Source: AGHT+IG7IKcCMm+m23l843c+BPbqEHBOl3c6DtL6EgisGXdvTe/M2m4vQitSaDwgUPp5YjAFcOzjcg==
X-Received: by 2002:a05:600c:35c9:b0:434:f753:6012 with SMTP id 5b1f17b1804b1-436686440bemr47198355e9.17.1734742191256;
        Fri, 20 Dec 2024 16:49:51 -0800 (PST)
Received: from [192.168.42.184] ([185.69.144.186])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b442dasm93329235e9.42.2024.12.20.16.49.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2024 16:49:50 -0800 (PST)
Message-ID: <5d308d1b-4c9d-430e-b116-e669bd778b30@gmail.com>
Date: Sat, 21 Dec 2024 00:50:37 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 03/20] net: generalise net_iov chunk owners
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241218003748.796939-1-dw@davidwei.uk>
 <20241218003748.796939-4-dw@davidwei.uk> <20241220141436.65513ff7@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241220141436.65513ff7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/20/24 22:14, Jakub Kicinski wrote:
> On Tue, 17 Dec 2024 16:37:29 -0800 David Wei wrote:
>>   struct dmabuf_genpool_chunk_owner {
>> -	/* Offset into the dma-buf where this chunk starts.  */
>> -	unsigned long base_virtual;
>> +	struct net_iov_area area;
>> +	struct net_devmem_dmabuf_binding *binding;
>>   
>>   	/* dma_addr of the start of the chunk.  */
>>   	dma_addr_t base_dma_addr;
> 
> Is there a good reason why dma addr is not part of net_iov_area?
> net_iov_area is one chunk of continuous address space.
> Instead of looping over pages in io_zcrx_map_area we could map
> the whole thing in one go.

It's not physically contiguous. The registration API takes
contig user addresses, but that's not a hard requirement
either.

-- 
Pavel Begunkov


