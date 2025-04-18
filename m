Return-Path: <io-uring+bounces-7552-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33D0CA93DFD
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 20:52:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BBD67AF7B8
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 18:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E92A41DF968;
	Fri, 18 Apr 2025 18:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="dMA+GTKB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DE445009
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 18:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745002369; cv=none; b=u0SrSa00Qz+tmx7Nd8rNwKooBJxC6Ogddx7yX0pZ+DP5RCm1oCJSiRBPZg3nWummYoyqcZsI/mQdwrHuZRBQgig5/V1LVapgD1f2gEnrdKJdFnLka7oMCp3dj1+lD7ysakesCxXHKeRrGCjRJ3WIvkxEkthl49bNXcwKct8TMLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745002369; c=relaxed/simple;
	bh=qBFreUF/QMPq+cIgGCbVMPCs7GsIEhR6LBNhsZ++SYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aw4Pw7lNZVO01yNyKYuDkL/cokrn5oyZ3VMYrhxalR0vx+kEJfYPBPbf19F9QV5n86vK8SnjACybS4cZBFOtE40ANRPQp8cwoWZ+3CNR0jnmncDzl3iOUGIc4ePijQpmGfrevjP4aZ7CRqUNSo0UUW8rAgDDVVQWAHdtRsDUOl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=dMA+GTKB; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-227c7e57da2so20264285ad.0
        for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 11:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1745002367; x=1745607167; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DD9snh9uX0mYya4+NVkJsmHpSJlibOg9vnF244LtnQ4=;
        b=dMA+GTKBNdm3nLXMqyv955tIWCudjAvTD326XDuTjdRIokOpmuFG6sCh2/q5NHIvPm
         QBERhLp6XSKxxjfJQtUDb7TnYGWu90JoCkYu/umDjZuR3iIXUd96JrEyMERHnc9Kycus
         qWN3P4RF1iTj3+UGROhY4bodQb1qlhiCRx3IdE0oSlc4cD73JbTxHf0rBOKRgNGba3HD
         OTGvsEeTZEG1InisymEqqTu0PveTHkl1I2ern2p3TcuW+4q93E2mexPqdW7H0E2RgkIr
         PYZMHNGkgPT0fe7n9nhM7Nj9V4LDfcD5dLvnAaPnb78d+RVXpSXNUnnEgGgF4DAEMDQe
         Z6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745002367; x=1745607167;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DD9snh9uX0mYya4+NVkJsmHpSJlibOg9vnF244LtnQ4=;
        b=EMHUBHRDgN1z1/qTrZ7FWk8MndLmk7xK9bKpvQs9MQTuaLtojL6byJXBd0jCjicjkO
         T7jruI4YQHgjEAabxLU/jbgyOdrijQfCCU/NX7NnLg6SVCFjWVNXUdaOEW9A8rMf7zXM
         Y4bpO8BFu+s5Y91Xx1WGq/4ov1B4eKcsLaDSLkmSrehu74hntbWjzk3DViQRTXg3jPkS
         9C85gI3QkMEMTn7bWGv4yhfXAKItj4aHO3aMooNwl7dijgcR3AxWYXUMvy0GunoK+75l
         zuWFC6OAmSzohJOYiRQW97zE0OVZT++SEpPp+9BN0+2S4qetBiLCku3hLCHT99/sFtsr
         CFNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfu8u1o/MfEo4c9ngJJf+Byf5tj03nTyLPxnk7p7oIwGKRKaOsX7qAt5xneKSjHdf4I+Un09LlWg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJidH1Iv0Iy9155ACj0kXdcZMVKfO1jPAqNAAGLjY82A27+CLx
	VLHq7QVwaUkrv1wOypH42nhe6tB4camyuEybWsQQne/B+0c4fumpiShVNUM556Q=
X-Gm-Gg: ASbGnctVtEDcQFdzDmJw+chmxbYAkA1wagrj5jAS9HYH7AsxjVQG/hvkTZaUKUeNQGY
	2uv1OPIBIdPTXoKg4wTUWiKoBaMEBG5LHmN0V9BWe/5uMbfGjzd/2pyixnHGT9tPI8Fu8Lu8IN9
	TiMTcLVQcvLXBup8qBrZUGQ+V9le8iNVwk0i9EkYCkOlyJQ7yNiTnyqheexoQAj8N6/cYdPg3Z6
	XRqeV/wYbBfOnOUxVlAPmJMlxRVjkUJEUYvFW+Iios57LRTmQ1eud0HyhhScLRE+d1fUO7xSsG5
	hwAYeBVrqIVKKhY/UGSyDTwpo20YBQJLY9Dr+h5pqIiY7kWIjS68JasDG4KiVgQFUztU8Hr4cPd
	b8U4=
X-Google-Smtp-Source: AGHT+IEPpfUsg3hR33mREz1E57qR3qdkfZmWuaP53v8Asz6d2xyTxwdfxBW2vGwS4GL0e+ZnRTEgVA==
X-Received: by 2002:a17:902:f652:b0:223:628c:199 with SMTP id d9443c01a7336-22c53620c8bmr48818915ad.52.1745002367446;
        Fri, 18 Apr 2025 11:52:47 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:1cf1:8569:9916:d71f? ([2620:10d:c090:500::6:5122])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50eb4287sm20080455ad.130.2025.04.18.11.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 11:52:47 -0700 (PDT)
Message-ID: <1401e428-a96a-4c77-899f-3a32be0733f0@davidwei.uk>
Date: Fri, 18 Apr 2025 11:52:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring/zcrx: move zcrx region to struct io_zcrx_ifq
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1744815316.git.asml.silence@gmail.com>
 <6d2bb3ce1d1fb0653a5330a67f6b9b60d069b284.1744815316.git.asml.silence@gmail.com>
 <b787d94c-8398-43d5-9721-5c4fb76890ca@davidwei.uk>
 <a3a444fd-b219-4b70-9936-8ad347842d57@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <a3a444fd-b219-4b70-9936-8ad347842d57@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2025-04-18 09:22, Pavel Begunkov wrote:
> On 4/18/25 17:05, David Wei wrote:
>> On 2025-04-16 08:21, Pavel Begunkov wrote:
>>> Refill queue region is a part of zcrx and should stay in struct
>>> io_zcrx_ifq. We can't have multiple queues without it.
>>>
>>> Note: ctx->ifq assignments are now protected by mmap_lock as it's in
>>> the mmap region look up path.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   include/linux/io_uring_types.h |  2 --
>>>   io_uring/zcrx.c                | 20 ++++++++++++--------
>>>   io_uring/zcrx.h                |  1 +
>>>   3 files changed, 13 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>> index 3b467879bca8..06d722289fc5 100644
>>> --- a/include/linux/io_uring_types.h
>>> +++ b/include/linux/io_uring_types.h
>>> @@ -448,8 +448,6 @@ struct io_ring_ctx {
>>>       struct io_mapped_region        ring_region;
>>>       /* used for optimised request parameter and wait argument passing  */
>>>       struct io_mapped_region        param_region;
>>> -    /* just one zcrx per ring for now, will move to io_zcrx_ifq eventually */
>>> -    struct io_mapped_region        zcrx_region;
>>>   };
>>>     /*
>>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>>> index 652daff0eb8d..d56665fd103d 100644
>>> --- a/io_uring/zcrx.c
>>> +++ b/io_uring/zcrx.c
>>> @@ -160,12 +160,11 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
>>>       if (size > rd->size)
>>>           return -EINVAL;
>>>   -    ret = io_create_region_mmap_safe(ifq->ctx, &ifq->ctx->zcrx_region, rd,
>>> -                     IORING_MAP_OFF_ZCRX_REGION);
>>> +    ret = io_create_region(ifq->ctx, &ifq->region, rd, IORING_MAP_OFF_ZCRX_REGION);
>>
>> Why is this changed to io_create_region()? I don't see the caller of
>> io_allocate_rbuf_ring() changing or taking mmap_lock.
> 
> We only care about mmap seeing a consistent region. The mmap holds
> the ctx->mmap_lock, and *mmap_safe was making sure the region is
> updated atomically from its perspective.
> 
> Now, instead of protecting the region itself, this patch is protecting
> how ifq and subsequently the region is published:
> 
> -    ctx->ifq = ifq;
> +    scoped_guard(mutex, &ctx->mmap_lock)
> +        ctx->ifq = ifq;
> 
> And io_zcrx_get_region() is either sees NULL or ifq with a
> correct region.
> 

Ah I see, thanks, make sense.

Reviewed-by: David Wei <dw@davidwei.uk>

