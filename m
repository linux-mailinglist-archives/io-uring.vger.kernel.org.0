Return-Path: <io-uring+bounces-4127-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0E559B4F68
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 17:35:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEFCB284443
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 461C519A2A3;
	Tue, 29 Oct 2024 16:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dVO0ccWV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED95E1953BD;
	Tue, 29 Oct 2024 16:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730219702; cv=none; b=Z3C/0KUdbBljWqu1pSC9YLYeyef4VfxNxYoGA/9ySCymwoR57Kev5x9Qdv+fg7jTXOJyA7XrkO/zYMlKjg9G+1jYcdm/tUTHrJgipB1Ud/Bk2T//pulzE/k/zdYvLep82pR1f3VoZCHVa2kgSFpms6/vAH3AVeywAdxh8PpHWzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730219702; c=relaxed/simple;
	bh=9UFLjkptR6QNpx3fZ3XKEoB+h3bv0CqqhrhXETuwvTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RdMCtTEsJytmYYKr3eRAhyTQzJztKD96t7WAHAkNgA7RM1PKhNul8PGBhHWH9hMJ08xNSW3Mvyz9vPhQT1DCdvvMxweZdP6HDSGs6ZrtjRdjKo5+3Gca7H4hf2z2L7a8hUWnvTs4BFT5gHwGBLVrgQ2ow19bp/moIEMfivxY80g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dVO0ccWV; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-37d4b0943c7so3781937f8f.1;
        Tue, 29 Oct 2024 09:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730219698; x=1730824498; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+u5Ty9K6ARrub3VQWTBAHNUC9+t1wfrSDcH0T/9nwt8=;
        b=dVO0ccWVEAGXEHSrJvqnraQksNIzM83IH+g+NWIMd0BRpEmaxpDNfee3CVIZfwQ8sk
         O5xCTy99DjZ6kChIawvSGkAIIKiWgjTM52rpkDi8uaoVjrFQ0fN9/vUFJ0kvU+53ld4a
         RKDiH7R52y4teURUiB04Jt2mtz+Z2Oc90HBULxQRe8E8uwCG9kkzrWHUf9HyGC93kw9V
         hzcdStrhMhrXUbZkDnYaLw2L9mA9cyNzlRZGu75rDuxIaxTATPeAWa3qTxVfU569AqA+
         +gjCop/yGdJw5F1bWzS201FbUz0ZEZGB6bL8MiPODnaHjzT1/hW0eKHlklIGUvqSxu2Y
         dHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730219698; x=1730824498;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+u5Ty9K6ARrub3VQWTBAHNUC9+t1wfrSDcH0T/9nwt8=;
        b=qxm3kY6MzuLU/BMUCxFHi3+u/FcWjEyRKO5MOoAQJAkXulfWimanqxRgWQ0fdmacaa
         pAJ2t7xUUQMLNmXbf2OT8OLa0uDRdAbX9cANgb737zkRNX5iwO1OTngAkei14+dG6yyr
         TkO4iVCVYbG7X9JeRqM/vgIeu3nBdnWCPz9L+lzgxyC2xnwCXRWU13aDGySVz/EMVudk
         bS22MRxKPKvUuhwkyIXGwfYQ99dZ27V8Rf2gHs+0Vja3jvHxKE2dF9OQTS+dLM2iPlXF
         Vsi9co0+PhBqxyDLrBjCk3tQlK8Ylk2ZEm3jJwCAJSfxV2LGjO7y1Yx/EpEP1law2zsI
         AvIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBnGe11rFEIm9L/U8ab70so3kzLqpwTsbxWOXmsnbPV7R8tnrmjH1aKzZapT2ZK9bIRF1qGHtwjQ==@vger.kernel.org, AJvYcCUVni0PYtD9YfHkIHKryy9WdrjUPgh/eYDjn4VjHjY1YBWwGfPh7T+iKv4CSzQyNsgpvElUiBPvwe/6wWk=@vger.kernel.org, AJvYcCVsRJ0NHegNHot37QH+4P5bZrPsAPKCD7NVfikpP3MAAC0uVLecmhgjnLTKhUS1kosVk10q7LHp@vger.kernel.org
X-Gm-Message-State: AOJu0YyfuAXMwKeUhwUBGgVJMNICIPuBhAPAsQq6hiCMAqJQJ/SGLXdi
	8eI7vD47Hh00f16Q/XrtYO0B8gmtMFzFyyrx8UcCTLTW9tSzccS2
X-Google-Smtp-Source: AGHT+IFGeVvWfs2GbjjZ9Xw4mTo06zaHYge/2mupAU5QXpyOurso+KUqnM1MIi7YA6r0q9wC6cUBrQ==
X-Received: by 2002:a5d:5146:0:b0:37d:5496:290c with SMTP id ffacd0b85a97d-380610f255fmr9152980f8f.7.1730219698083;
        Tue, 29 Oct 2024 09:34:58 -0700 (PDT)
Received: from [192.168.42.53] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b7124csm13055685f8f.81.2024.10.29.09.34.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 09:34:57 -0700 (PDT)
Message-ID: <9a14e132-6a13-4077-973d-b1eca417e563@gmail.com>
Date: Tue, 29 Oct 2024 16:35:16 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/15] net: generalise net_iov chunk owners
To: Christoph Hellwig <hch@infradead.org>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-3-dw@davidwei.uk> <ZxijxiqNGONin3IY@infradead.org>
 <264c8f95-2a69-4d49-8af6-d035fa890ef1@gmail.com>
 <ZxoSBhC6sMEbXQi8@infradead.org>
 <a6864bf1-dd88-4ae0-bc67-b88bb4c17b44@gmail.com>
 <ZxpwgLRNsrTBmJEr@infradead.org>
 <de9ae678-258d-4f68-86e1-59d5eb4b70a4@gmail.com>
 <Zx9_iYLVnkyE05Hh@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zx9_iYLVnkyE05Hh@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/24 12:11, Christoph Hellwig wrote:
> On Thu, Oct 24, 2024 at 05:40:02PM +0100, Pavel Begunkov wrote:
>> On 10/24/24 17:06, Christoph Hellwig wrote:
>>> On Thu, Oct 24, 2024 at 03:23:06PM +0100, Pavel Begunkov wrote:
>>>>> That's not what this series does.  It adds the new memory_provider_ops
>>>>> set of hooks, with once implementation for dmabufs, and one for
>>>>> io_uring zero copy.
>>>>
>>>> First, it's not a _new_ abstraction over a buffer as you called it
>>>> before, the abstraction (net_iov) is already merged.
>>>
>>> Umm, it is a new ops vector.
>>
>> I don't understand what you mean. Callback?
> 
> struct memory_provider_ops.  It's a method table or ops vetor, no
> callbacks involved.

I see, the reply is about your phrase about additional memory
abstractions:

"... don't really need to build memory buffer abstraction over
memory buffer abstraction."

>> Then please go ahead and take a look at the patchset in question
>> and see how much of dmabuf handling is there comparing to pure
>> networking changes. The point that it's a new set of API and lots
>> of changes not related directly to dmabufs stand. dmabufs is useful
>> there as an abstraction there, but it's a very long stretch saying
>> that the series is all about it.
> 
> I did take a look, that's why I replied.
> 
>>>> on an existing network specific abstraction, which are not restricted to
>>>> pages or anything specific in the long run, but the flow of which from
>>>> net stack to user and back is controlled by io_uring. If you worry about
>>>> abuse, io_uring can't even sanely initialise those buffers itself and
>>>> therefore asking the page pool code to do that.
>>>
>>> No, I worry about trying to io_uring for not good reason. This
>>
>> It sounds that the argument is that you just don't want any
>> io_uring APIs, I don't think you'd be able to help you with
>> that.
> 
> No, that's complete misinterpreting what I'm saying.  Of course an
> io_uring API is fine.  But tying low-level implementation details to
> to is not.

It works with low level concepts, i.e. private NIC queues, but it does
that through well established abstractions (page pool) already extended
for such cases. There is no directly going into a driver / hardware and
hard coding queue allocation, some memory injection or anything similar.
The user api has to embrace the hardware limitations, right, there is no
way around it without completely changing the approach and performance
and/or applicability. And queues as first class citizens is not a new
concept in general.

>>> pre-cludes in-kernel uses which would be extremly useful for
>>
>> Uses of what? devmem TCP is merged, I'm not removing it,
>> and the net_iov abstraction is in there, which can be potentially
>> be reused by other in-kernel users if that'd even make sense.
> 
> How when you are hardcoding io uring memory registrations instead
> of making them a generic dmabuf?  Which btw would also really help

If you mean internals, making up a dmabuf that has never existed in the
picture in the first place is not cleaner or easier in any way. If that
changes, e.g. there is more code to reuse in the future, we can unify it
then.

If that's about user api, you've just mentioned before that it can be
pages / user pointers. As to why it goes through io_uring, I explained
it before, but in short, it gives a better api for io_uring users, we
can avoid creating a yet another file (netlink socket) and keeping it
around, that way we don't need to synchronise with the nl socket and/or
trying to steal memory from it, and the devmem api is also too
monolithic for such purposes, so even that would need to change, i.e.
splitting queue and memory registration.

> with pre-registering the memry with the iommu to get good performance
> in IOMMU-enabled setups.

The page pool already does that just like it handles the normal
path without providers.

-- 
Pavel Begunkov

