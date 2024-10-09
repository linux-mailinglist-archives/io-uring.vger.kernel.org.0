Return-Path: <io-uring+bounces-3517-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71BB9997572
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A491C1C226E5
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 19:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 646461DF734;
	Wed,  9 Oct 2024 19:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ca4lfUGM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A472CEDE;
	Wed,  9 Oct 2024 19:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500902; cv=none; b=vDvnrkhZ+KsBwzI5V7mEjGErh4ISNtpP0Q4+37yOo0e18pCyEvi65Jl9I4GoYHWbWIIpThH/xwh/etkvAdH/SvtQKnxC3YgSJRi4jHlzw5JI0tQQfrGbDMzHgrG7sllC6d5cUqnpDjhAcEf7R+eHpyUhG8FKDYAIuL4ic3SGHqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500902; c=relaxed/simple;
	bh=G5s6E6f3HH7Z0pR1OU0hV/3kW2hFKzyqyr8PKYwFUdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UByMBkcmm5nTLkraCLiXeQSLQ2I2ucjSdHuLG8wA4shgLZZ4G83ABCy7RcrNng5Nilunjs4wr3O9NCelq1/gVZaUpJGvxHBAj9NArXulqsgTch4fzuB2HKh0lq7I0DZHtlObdGwIgl+Xbi5Wr7g5JpsSZ7lWODEEowyKjPyLLj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ca4lfUGM; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a7aa086b077so24271266b.0;
        Wed, 09 Oct 2024 12:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728500897; x=1729105697; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iNbwS/9TFy5SDCfi2gzQ4eMSSBkW/CakGPDvG7OaM5I=;
        b=ca4lfUGMADvmeAnNdABHxIyPFdaqJ6mNhWmFA8k5VbjrxbD9DM9IiOoPspBrBqgWv4
         W31lAVjJArHig+I3YY6MoGfRmCHdoAstBE9qV7WivfsofOpOU13uhRCRD+t0yGOOwzbG
         W+4IVR7gseBX6t4wxNq27O4QZO3fcyW295Rmh17jp1ljr+Q77NWVp08AOu1nlYzttGRY
         0bKz0Limzaj+0psKN+E46RjwPqRDi/+0NwzVJMZY0KY0wjuyWGFl/rEOHRvJ8/HqgelP
         uYnI9XZQZF2+tausPXUQmxmslTsNCJ+Xo+Eng4ziKvqD3nll9jCKhIcLEdwu1KZ4xbN4
         y67Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728500897; x=1729105697;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iNbwS/9TFy5SDCfi2gzQ4eMSSBkW/CakGPDvG7OaM5I=;
        b=CuNAYrKcl3VV2mHL0+eE7ZL2qylg1a8lOV/0804XxR0gpeDfasvdHxvksC2kQ/zW2f
         JKOjfabCxCv/d5FGA4S+8fNjurZSa5Q46oVVEdCBRGwWDPChxHCTyEExlOo3j5jvn4nj
         E6Yw03da+tpyzvUATW5EfGAi4msyyosRMF1sf3JgJoQ2wnhJTDMC5KCF2mQbBi0n+GIp
         esS8ne2h5yQjDdBd+k7GKtYvyPrd2heQHnJGl6/u+h5FluU9grByvqH04ytBMOthTBg/
         eWBfuTUOulqNH3nhrbXk3tJMKu+ZQhWCe5QG1DCIsbqn29iGkK8m8VnZCwjA3EOkHamp
         GWug==
X-Forwarded-Encrypted: i=1; AJvYcCUEXHi3Rr262FKqyVNNBcrMicvFoGgxFM2a2gC8GBtV5pUdU7be2mxXN39HUVDNSN6cMKC6O0kXKg==@vger.kernel.org, AJvYcCUpcME0xIwcY+iA6O6pyMcB1KsFqlqydGmfoOpArdHOmRA6QZjcYHAuJeBu45nTClZUodNpCGCI@vger.kernel.org
X-Gm-Message-State: AOJu0YyGYmiLx1++2FmNlF6bEm31mWu+VP5ePz9/ooQTugKjOi0NUnKA
	44hFq91sfziUslnLUhIIltzMvFBn3dFAAGRRmKbQPAiVs7yOgH24
X-Google-Smtp-Source: AGHT+IFwHpJ0YRgupGxZL5VNYKMbysPScAH+WyZ6mG3JMls0+JD31bVetIVMkCnpgf0resTUvD4TQw==
X-Received: by 2002:a17:907:c19:b0:a99:37af:9cf9 with SMTP id a640c23a62f3a-a999e8cb92emr123481666b.49.1728500896628;
        Wed, 09 Oct 2024 12:08:16 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.145.180])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99527e8e15sm473000766b.181.2024.10.09.12.08.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 12:08:16 -0700 (PDT)
Message-ID: <8d624a0a-3b00-4117-800d-a25314a8a25b@gmail.com>
Date: Wed, 9 Oct 2024 20:08:52 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 09/15] io_uring/zcrx: add interface queue and refill
 queue
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-10-dw@davidwei.uk>
 <8075828d-74c8-4a0c-8505-45259181f6bb@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8075828d-74c8-4a0c-8505-45259181f6bb@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 18:50, Jens Axboe wrote:
> On 10/7/24 4:15 PM, David Wei wrote:
>> From: David Wei <davidhwei@meta.com>
>>
...
>> diff --git a/io_uring/Makefile b/io_uring/Makefile
>> index 61923e11c767..1a1184f3946a 100644
>> --- a/io_uring/Makefile
>> +++ b/io_uring/Makefile
>> @@ -10,6 +10,7 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
>>   					epoll.o statx.o timeout.o fdinfo.o \
>>   					cancel.o waitid.o register.o \
>>   					truncate.o memmap.o
>> +obj-$(CONFIG_PAGE_POOL)	+= zcrx.o
>>   obj-$(CONFIG_IO_WQ)		+= io-wq.o
>>   obj-$(CONFIG_FUTEX)		+= futex.o
>>   obj-$(CONFIG_NET_RX_BUSY_POLL) += napi.o
> 
> I wonder if this should be expressed a bit differently. Probably have a
> CONFIG_IO_URING_ZCRX which depends on CONFIG_INET and CONFIG_PAGE_POOL.
> And then you can also use that rather than doing:
> 
> #if defined(CONFIG_PAGE_POOL) && defined(CONFIG_INET)
> 
> in some spots. Not a big deal, it'll work as-is. And honestly should
> probably cleanup the existing IO_WQ symbol while at it, so perhaps
> better left for after the fact.

I should probably just add not selectable by user
CONFIG_IO_URING_ZCRX and make it depend on INET/etc.


>> +static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
>> +				 struct io_uring_zcrx_ifq_reg *reg)
>> +{
>> +	size_t off, size;
>> +	void *ptr;
>> +
>> +	off = sizeof(struct io_uring);
>> +	size = off + sizeof(struct io_uring_zcrx_rqe) * reg->rq_entries;
>> +
>> +	ptr = io_pages_map(&ifq->rqe_pages, &ifq->n_rqe_pages, size);
>> +	if (IS_ERR(ptr))
>> +		return PTR_ERR(ptr);
>> +
>> +	ifq->rq_ring = (struct io_uring *)ptr;
>> +	ifq->rqes = (struct io_uring_zcrx_rqe *)((char *)ptr + off);
>> +	return 0;
>> +}
> 
> No need to cast that ptr to char *.

I'll apply it and other small nits, thanks for the review

-- 
Pavel Begunkov

