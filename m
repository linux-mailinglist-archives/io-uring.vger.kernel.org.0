Return-Path: <io-uring+bounces-3867-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1991B9A6FE3
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 18:40:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D88F1F24BC2
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 16:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0711DEFC2;
	Mon, 21 Oct 2024 16:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XrIXzYia"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB4B1C3F01;
	Mon, 21 Oct 2024 16:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729528744; cv=none; b=F75bYL083NVbzuHvsXI3E3JsMvfRYFeDx5cjB7M9qFSnthmWPll9HcZ+G+vtASNGMCBLdL4iq3pJroUEmuL7bfiuNW1aCh10GhOZnvGDLq+v15JpAH4sesGsfBRpekO9NDtrv+5NoLDliWNiSe5Jt1KyGovIj+zKqkuXYyDx264=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729528744; c=relaxed/simple;
	bh=nvSFXGB+98NDtw+8SBYXIwUfr4i5GYhj1TDfXwIvzqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jc66FAiwQ11WD5QYlEDrxp9RK4DNIemc58XdXHorAcaSX5CEg6irNkOBqnInvNBAlxVnqYxntZUKhkiJq2DxDDAwoIbVVB1GhOj8KhT8MB3bmUkYFn13uhZvHVhPXZyfgPYACPhtdD9P8o378eyRkel/ggDeLF28H7MRvQmRIbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XrIXzYia; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-37d70df0b1aso3751711f8f.3;
        Mon, 21 Oct 2024 09:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729528741; x=1730133541; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uceUaBIcyMgGQtjqWzvB0RNBxAKK8bmcottgDtLYClw=;
        b=XrIXzYia0fWEF89kVpi5tkRSS6j8Nowc6TvHYDpwDc7s/bQUqVGM+kED8FerHgu0yA
         PjhoYrwTzEFIwTNoBD6fhK/DtPiAfDbqPoeRbMMtztht2IqDfFRM6boYfNse4GHVMl5j
         MmNqpi8EHY01VThlw0Dy5+5Kvih5Po9ybafYJpNAp5jNlb77MSS9Vm8AOz+Rtnfh3hCx
         OZo+kq/GS3oEDPoXVPRxOX7OErT5a3MEh8iqJCQPLSqqLZCgshMCiTFJbgLKFTaYQ+p7
         8tm0CT70XE+tIp3U5aaVq/04XTQHpGXI+U9RYMjTQ8Q0WaUnnOFqWun4GOpdnr7r4mYL
         RfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729528741; x=1730133541;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uceUaBIcyMgGQtjqWzvB0RNBxAKK8bmcottgDtLYClw=;
        b=FjBrIVqIY0TBynqiMIBRE+tOxgeltBgGt5p3nEYX5dMS/vZcS5HTsOj1n3pOS/NDoY
         7yEZkB+Y2+YW3jUS1cU961GC2NL4GQz8zRJQ1ghL1DfwUWm7ilY7x7bIDp8ubKBquQ6o
         llCsTnJGf8iCmAVz0KqPf+yjW08XXeirMimQZdyxqnd5dM5nk8GQXzdtIxEi+MwSVWL4
         4nW5nDb8s5jNRS/th+DoeqFO2rkrFcVZObwSipGD9/KykqOAtsPU9Y7mUA7Xs83k3v8d
         9z3nRO5rdehKYrZY2J0P0GyjssF6QsdUYNzycyJfkk9aBiHZRmOSJdwUw+U+9SRoT9o+
         7J8g==
X-Forwarded-Encrypted: i=1; AJvYcCU7pDS2zSJ8Jtpytm1ytKMCJc8PCfsAjcwH3056x7QFpsMMHFB6hGJ10Udwy/jjKHQ4KIiOn6ifWA==@vger.kernel.org, AJvYcCXXT1UcG61noCpO4OE43P6XJFiozCWMPLMlhW3GFkw227CnC5zCYf5EPc6QM6DElgVEV+430+DQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzCJ1CUxRNIjW2VOEnfZ8pNeJRA//Yx0UQJ+rjEPkasLClIgvPK
	6CFKHrTPxKttkJo/tawQW0TVFXlZPivL4OCXEuME0A7t8x6e+RgE
X-Google-Smtp-Source: AGHT+IGNO7VRh28ZocUijIvCtJXFAKDFREcS5s0s9K7YaVAuDydYBwSNblSTucgQ6nTZ6NojfKGDpA==
X-Received: by 2002:a5d:5741:0:b0:37d:45f0:dd0a with SMTP id ffacd0b85a97d-37eab72787bmr6940620f8f.1.1729528741064;
        Mon, 21 Oct 2024 09:39:01 -0700 (PDT)
Received: from [192.168.42.158] ([185.69.144.55])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0a47b74sm4701108f8f.27.2024.10.21.09.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 09:39:00 -0700 (PDT)
Message-ID: <c2ae899b-f7b0-4357-a5e0-c8029404c85b@gmail.com>
Date: Mon, 21 Oct 2024 17:39:45 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/15] io_uring/zcrx: add io_zcrx_area
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-11-dw@davidwei.uk>
 <3aebbd91-6f2f-4c8c-82db-4d09e39e7946@kernel.dk>
 <433d21ff-6d7f-4123-8b11-c5d3c9a9deb1@gmail.com>
 <b2810a26-7f03-45c5-9354-c8ab21ae411e@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b2810a26-7f03-45c5-9354-c8ab21ae411e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 17:29, Jens Axboe wrote:
> On 10/21/24 10:28 AM, Pavel Begunkov wrote:
>> On 10/21/24 16:35, Jens Axboe wrote:
>>> On 10/16/24 12:52 PM, David Wei wrote:
>>>> +static int io_zcrx_create_area(struct io_ring_ctx *ctx,
>>>> +                   struct io_zcrx_ifq *ifq,
>>>> +                   struct io_zcrx_area **res,
>>>> +                   struct io_uring_zcrx_area_reg *area_reg)
>>>> +{
>>>> +    struct io_zcrx_area *area;
>>>> +    int i, ret, nr_pages;
>>>> +    struct iovec iov;
>>>> +
>>>> +    if (area_reg->flags || area_reg->rq_area_token)
>>>> +        return -EINVAL;
>>>> +    if (area_reg->__resv1 || area_reg->__resv2[0] || area_reg->__resv2[1])
>>>> +        return -EINVAL;
>>>> +    if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
>>>> +        return -EINVAL;
>>>> +
>>>> +    iov.iov_base = u64_to_user_ptr(area_reg->addr);
>>>> +    iov.iov_len = area_reg->len;
>>>> +    ret = io_buffer_validate(&iov);
>>>> +    if (ret)
>>>> +        return ret;
>>>> +
>>>> +    ret = -ENOMEM;
>>>> +    area = kzalloc(sizeof(*area), GFP_KERNEL);
>>>> +    if (!area)
>>>> +        goto err;
>>>> +
>>>> +    area->pages = io_pin_pages((unsigned long)area_reg->addr, area_reg->len,
>>>> +                   &nr_pages);
>>>> +    if (IS_ERR(area->pages)) {
>>>> +        ret = PTR_ERR(area->pages);
>>>> +        area->pages = NULL;
>>>> +        goto err;
>>>> +    }
>>>> +    area->nia.num_niovs = nr_pages;
>>>> +
>>>> +    area->nia.niovs = kvmalloc_array(nr_pages, sizeof(area->nia.niovs[0]),
>>>> +                     GFP_KERNEL | __GFP_ZERO);
>>>> +    if (!area->nia.niovs)
>>>> +        goto err;
>>>> +
>>>> +    area->freelist = kvmalloc_array(nr_pages, sizeof(area->freelist[0]),
>>>> +                    GFP_KERNEL | __GFP_ZERO);
>>>> +    if (!area->freelist)
>>>> +        goto err;
>>>> +
>>>> +    for (i = 0; i < nr_pages; i++) {
>>>> +        area->freelist[i] = i;
>>>> +    }
>>>> +
>>>> +    area->free_count = nr_pages;
>>>> +    area->ifq = ifq;
>>>> +    /* we're only supporting one area per ifq for now */
>>>> +    area->area_id = 0;
>>>> +    area_reg->rq_area_token = (u64)area->area_id << IORING_ZCRX_AREA_SHIFT;
>>>> +    spin_lock_init(&area->freelist_lock);
>>>> +    *res = area;
>>>> +    return 0;
>>>> +err:
>>>> +    if (area)
>>>> +        io_zcrx_free_area(area);
>>>> +    return ret;
>>>> +}
>>>
>>> Minor nit, but I think this would be nicer returning area and just using
>>> ERR_PTR() for the errors.
>>
>> I'd rather avoid it. Too often null vs IS_ERR checking gets
>> messed up down the road and the compiler doesn't help with it
>> at all.
> 
> The main issue imho is when people mix NULL and ERR_PTR, the pure "valid
> pointer or non-null error pointer" seem to be OK in terms of

Right, I meant it in general, mixing normal pointer types with
the implicit type that can have an error.

> maintainability. But like I said, not a huge deal, and it's not hot path
> material so doesn't matter in terms of that.

I agree it's maintainable, but this way I don't even need to think
about it.

>> Not related to the patch, but would be nice to have a type safer
>> way for that, e.g. returning some new type not directly
>> cast'able to the pointer.
> 
> Definitely, room for improvement in the infrastructure for this.
> 

-- 
Pavel Begunkov

