Return-Path: <io-uring+bounces-6738-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F79DA4401A
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 14:07:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB6B44417E9
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 13:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24471268C40;
	Tue, 25 Feb 2025 13:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="na6YMRHF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E64185B73;
	Tue, 25 Feb 2025 13:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740488708; cv=none; b=a/Jd2NyAx677V93v1hAsO0oA0bH+ShQqmJvMXn5CF9QWCZv+KXCKpVylepiRDxkdzRp4JB8T2RMoqLJuN/6O5xqnaD/ns+j5AuUOb8eHnR17P0BEj2ZkXKGBtdxVJgZ/ro11GFWkp4Fo8YQ2SAEJSocrBb+ZzkkWHrQlCUdBwqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740488708; c=relaxed/simple;
	bh=AdZwqpqPC5vH6hmjyBgEuQvR8+35PB8OyLTns41JMKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kXzcqFvrw6hH2MqEapql+ofp5QZ3uLtuk1798zJV900ttzZ6W0J2QJxOntRZ9AHzG28NtmORVSUnkG/Ex+mnIoIhmN34Jdj+OjSPowhkY8+zSeHR4EOTvoBFTLvrC9J+r9JUgvH/0QoVycx/O/IJNvG1BFYlEFS3HfZ13q4vr3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=na6YMRHF; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-abb75200275so884770566b.3;
        Tue, 25 Feb 2025 05:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740488705; x=1741093505; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OxrLbfbfoAQxm9Jib0ykAP2wsZvBazEkzjSnu1OQ64Q=;
        b=na6YMRHFbZgKEeFpxSiuCjDPGd5suSChfXrzCS8Uu6LUlrow0mePbGSfr4XZ96W8se
         0SgIJMYs+5rrkmNFTTqCIIb0u9gQ89G+DHOYrBDYfSRIwsUNPxMrRBtmQU40lRyNXmxR
         ybyxgqmVheeOnJ0oXu1Baii0jIZRUR+LtYfnSWczRzpWmbGAnv+WOMqMnR/mTfWubeKc
         9ZTjQKPsRQVS1VE8PzofnycDdmPohSISC2cJPo4VVq1SANi+8jukUOzoT6MqoVxcapGe
         Yptvgw/IqmJ384/+FXRWZSVON1R7HeilGNILPiixDzEasajsAk1d+eyyIDDQC7FSBCG+
         elXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740488705; x=1741093505;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OxrLbfbfoAQxm9Jib0ykAP2wsZvBazEkzjSnu1OQ64Q=;
        b=FGJISPjjNjv1rskmu2mjU5kSVTLGRdfaKxQh5goDJLZYnlqD6pzEWIrTbYxAm9WgF8
         ivBVSVydglTrLqyMTkWNYgeUFI8GFw9sPa8PROVk/4/4NImtiM3N4iRI4X6WYXLzx27z
         pjwh/+iRcMtuSJGjo6I3twyJp8iAB3wac0Ag+x6vaH8NltK8yTZ/rgqlnNqEomGRqTjs
         tfEDEEg/ntFuLJwFx4S8NzfajG+Kgon1zZYSiZ/moo0k2jPpRHTld3/2zmhNZG7Xe0EP
         tcvoARJQx41R4zeGxZNv2dZTbH3aIgi33DJtXu+As/fcKB8QElEVy6EzVhkvcpujQhCD
         HnpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHvM+vdwiO1IY+Cmb/EdRDlAmu0xJ9DnS7vemtMRWDeYXiGAsTgP2AFl3moqlXdbPy+XDa0Tmsjg==@vger.kernel.org, AJvYcCVIkPXp6joTj8PHgabvjE8kPs9Eav9pBMjPWHNLWCUswd4v5YlgDVfaJ8+pYRqaA63EQlbNSsOYq+fjvmY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/HRdcU7SZJZMt1twby80AiGBZfOVAUcijjwUyOjH6sOYzV4SP
	KxzFmMxXdxWwrI9+SbYJxB0FsxRxWKjGikKEW+tv+AfSDV7x4mBs
X-Gm-Gg: ASbGncuZoo9yuojqX/gjuX5wU4UxBEAQiLxJ83P/wNJLwnpKjzQUPMr2+gNoi34GS5f
	8ffCgOq8sU1ozR5lotmdWakBZU6nyl80TGuGrt+WGm71dHP9EtfEp57odC/zz2n6OVVrQ80zga0
	128lymFoefTvEm8EXafij/M4KRljbArUHiHuk4VgYQCl+Jf1AWgMwDq1gZif8sg1feDHzKRpuJy
	AKAsfEFUKWmK0JxVvHLdqCIDIHSYjduf95ec+503hrXG+fWC3rAYVkFLWJOBshWzN4a6MIuF1wN
	16JmVagm4IzOviRFnhKi6lT3oZFV2PdKSdVyUItkGJqQ9LdCIuxnNK1xIC0=
X-Google-Smtp-Source: AGHT+IGTqG7HfTAP2eYJcsr7XX1L3wlxJOuEu7+IAvLLjDqA6/VVsycXL53oTUttGijB+Xw0W2r+AA==
X-Received: by 2002:a17:907:2dab:b0:ab6:b9c0:1ea2 with SMTP id a640c23a62f3a-abc09a62edbmr1953413166b.25.1740488703975;
        Tue, 25 Feb 2025 05:05:03 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9e08])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed20b4fdfsm138494166b.170.2025.02.25.05.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 05:05:03 -0800 (PST)
Message-ID: <89efbcee-09fa-43e0-ad9e-de143add05f8@gmail.com>
Date: Tue, 25 Feb 2025 13:06:03 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 5/5] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com,
 csander@purestorage.com
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-6-kbusch@meta.com>
 <d2889d14-27d2-4a64-b8d1-ff0e4af6d552@gmail.com>
 <Z7dJNx5yIneheFsd@kbusch-mbp>
 <00375984-956d-4a25-aae2-e2d72a91c62a@gmail.com>
 <Z7ze-kzDuoP_XPBx@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z7ze-kzDuoP_XPBx@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 21:04, Keith Busch wrote:
> On Thu, Feb 20, 2025 at 04:06:21PM +0000, Pavel Begunkov wrote:
>> On 2/20/25 15:24, Keith Busch wrote:
>>>>> +		node = io_cache_alloc(&ctx->buf_table.node_cache, GFP_KERNEL);
>>>>
>>>> That's why node allocators shouldn't be a part of the buffer table.
>>>
>>> Are you saying you want file nodes to also subscribe to the cache? The
>>
>> Yes, but it might be easier for you to focus on finalising the essential
>> parts, and then we can improve later.
>>
>>> two tables can be resized independently of each other, we don't know how
>>> many elements the cache needs to hold.
>>
>> I wouldn't try to correlate table sizes with desired cache sizes,
>> users can have quite different patterns like allocating a barely used
>> huge table. And you care about the speed of node change, which at
>> extremes is rather limited by CPU and performance and not spatiality
>> of the table. And you can also reallocate it as well.
> 
> Having the cache size and lifetime match a table that it's providing

You don't need to align it with the table size, I actually
overlooked it, will comment on v5.

> seems as simple as I can make this. This is still an optimization at the
> end of the day, so it's not strictly necessary to take the last two
> patches from this series to make zero copy work if you don't want to
> include it from the beginning.

Ok. As I mentioned above, I do think it's wrong for nodes, but
we can merge the patch and rework on top.

-- 
Pavel Begunkov


