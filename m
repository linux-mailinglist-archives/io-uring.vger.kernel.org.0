Return-Path: <io-uring+bounces-7208-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C79F3A6CBC4
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 19:14:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2813C3AF85A
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 18:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B07224243;
	Sat, 22 Mar 2025 18:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BmWswYn3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639A61E990D
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 18:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742667270; cv=none; b=TRXbKAoj9dkfG/AEPYcY8dBvViuK+mNgQCaOFWn3FpbLD1wRrnOM97AxB0uQPGKq+vHXOrpzvzqgTPKYUW86LpnVkuR0ftvJTFn/uEC15ahWnvoflZlvxDPCWkbCtxyjv8JV6hab+9040gsweEq1HvwcOXsphoWzhbmEVblbRQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742667270; c=relaxed/simple;
	bh=PECWAJDGORgfnwMKA3uUd1Hv3ew1yWR0Wl8yVoGsRT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WI9mjdpFWqrymlADw2ISDD8Czq8I8J9Or4c6Un1ZkTwN3I1yzD7YEXdZ+N4s55CMI3tINE4ntHUW4mQM/F4yNBlbSzxKYs30ksKgBVqk/V4LXc0xIonELFWA88oBO+HEwCNO7NUPzMl3AakDhs47KO4bSBw6um9+4pqYMfg4VgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BmWswYn3; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5e6194e9d2cso5477090a12.2
        for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 11:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742667266; x=1743272066; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Roz3aDji5KufPBsU9ugngGCRJq5wtoiaLYNSOAHRfDI=;
        b=BmWswYn3/0mE6E5ceFlPQ7w4cqQD1904IT8WkE44HDd7gxl6o1jJnUOeD5WB18wDGX
         NFNNArC5H70LlFrlyCQ9fVLUZy6wLbY2a4PHoQeQbdIq/Mzx8D9apw/Zzk3koNBL6Xqv
         3Is4jrINAsfzVwOb2brygkC5mtpEnAuahQdZFw885Oqpkpp8HHpvqpzxqreF9CVYHxWa
         s38gGZqw6vZVhHCmqxUssK8rYH9tprs/cmgLJUmfh4/H13kwQ4t+yfZ8aSnw5mS0u4iF
         1JLriC0CZtyXGKtyDQ9H/dzYUj659jr1mDh/Tvu8Vb3PDzP561ZDNAefEPqJdrfFkpAm
         TsAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742667266; x=1743272066;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Roz3aDji5KufPBsU9ugngGCRJq5wtoiaLYNSOAHRfDI=;
        b=ocGbopU0lLoC7mFry9VRvtJsda3ZStzRqQEcYfYXyHM+zRpM5bgUFvKOyBG4I22R6O
         2LxivLwkjidl04i6quCoChikAIaLZIxrUaicl3otlZX/6AvL1rWWcLfWPEP0dw6ZKEE+
         tv2tMn3RVaNcWa3NEhcYPI/GexEivpqza3maKWJZO187uKS/EFoUKJS+288QAd/jJFNf
         dBfCpBxaMaS3+rcI+D1JSFsuX99o9pMaVN6uOz35AIFLRxt2tBA0Tpww1B1O7xXGV+Uf
         cevBYbZ+T7IEmrLvgm8D2jcQj3oZSzID6RD4OIe2pvXFW9YwhsXCW9p4j7r1BvCRhVth
         5WdA==
X-Forwarded-Encrypted: i=1; AJvYcCUXbCbmRdThHQffr82mJad32d8BBaoSgMSyNLPEtupDGVQr/ZQAnJ/mkmhDScs/1L+LYCAoO94k6g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwB3hDMZk6PR3vywxwSxRmhMscsIZCmkPt4nuVdiyDdM3S8EOMR
	tcMoh50MjMMCH2bi60D7eKGmKcrghhweqI/KgnGwX8kBxwH6qoW2
X-Gm-Gg: ASbGncve/S4Hz19wfYwSgt7Db6valdAlDgmNZzBRodTNNlTDLJfIdI8NmanEo8wYCo9
	NHuE5Oi7ZeFvDuOfn2xzWPcoog0kzY2H45+6s94SjHebV76AyXn8MOGfxWpZx9UHYVXpTqnJKgo
	FyJMHbuuk+ci067C4GeSvk65s1EMLCY17VCBV/eia/lzz4UmUeMk2c3qKF3HucXp5FmYlrPX3mI
	RmZ61ZGmO7sbXuo6exG2Olyv3CrpoyQJcey9Ptci0O290QVhTuqevmYp7SyAGxdJeBwFB6xO8Nn
	nEHuXFU7Wn0b+iG9U6KkH0TMOs4kkEk5L/LXXR36BPUdIyNGXJDqs8kDLEh0LXs=
X-Google-Smtp-Source: AGHT+IHlrfrkruBixAOVw+N3Zu1YoktJwaNFHUxpXIwUbdzLKeEoekUnVB2Y1hJjCwXLDq6U1XqpPA==
X-Received: by 2002:a17:907:3da9:b0:ac2:29c7:8622 with SMTP id a640c23a62f3a-ac3f252f862mr754463766b.54.1742667266160;
        Sat, 22 Mar 2025 11:14:26 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.37])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef8d3f0csm381925766b.71.2025.03.22.11.14.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Mar 2025 11:14:25 -0700 (PDT)
Message-ID: <87b1eeb2-238b-413d-b7f3-6dc4fa63c6ca@gmail.com>
Date: Sat, 22 Mar 2025 18:15:18 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: zero remained bytes when reading to fixed
 kernel buffer
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Caleb Sander Mateos <csander@purestorage.com>,
 Keith Busch <kbusch@kernel.org>
References: <20250322075625.414708-1-ming.lei@redhat.com>
 <ae74ba78-d102-42de-95a6-1834f5f85dc6@gmail.com> <Z97ALTDd-s0-uT7O@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z97ALTDd-s0-uT7O@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/22/25 13:50, Ming Lei wrote:
> On Sat, Mar 22, 2025 at 12:02:02PM +0000, Pavel Begunkov wrote:
>> On 3/22/25 07:56, Ming Lei wrote:
>>> So far fixed kernel buffer is only used for FS read/write, in which
>>> the remained bytes need to be zeroed in case of short read, otherwise
>>> kernel data may be leaked to userspace.
>>
>> Can you remind me, how that can happen? Normally, IIUC, you register
>> a request filled with user pages, so no kernel data there. Is it some
>> bounce buffers?
> 
> For direct io, it is filled with user pages, but it can be buffered IO,
> and the page can be mapped to userspace.

I see. I don't mind the patch personally, but I think it's a security
concern, it's still a user space app even though privileged. Is there
a precedent maybe for fuse that we trust the user driver enough to
expose kernel memory?

One option is to try to distinguish when it contains user pages,
and conditionally zero it in ublk beforehand.

But if we consider that it's fine, can ublk zero during the struct
request completion? ublk should already know from the userspace driver
if it failed or whether it's a short IO.


>>> Add two helpers for fixing this issue, meantime replace one check
>>> with io_use_fixed_kbuf().
>>>
>>> Cc: Caleb Sander Mateos <csander@purestorage.com>
>>> Cc: Keith Busch <kbusch@kernel.org>
>>> Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")
>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>> ---
>> ...
>>> +/* zero remained bytes of kernel buffer for avoiding to leak data */
>>> +static inline void io_req_zero_remained(struct io_kiocb *req,
>>> +					struct iov_iter *iter)
>>> +{
>>> +	size_t left = iov_iter_count(iter);
>>> +
>>> +	if (left > 0 && iov_iter_rw(iter) == READ)
>>> +		iov_iter_zero(left, iter);
>>> +}
>>> +
>>>    #endif
>>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>>> index 039e063f7091..67dc1a6710c9 100644
>>> --- a/io_uring/rw.c
>>> +++ b/io_uring/rw.c
>>> @@ -541,6 +541,12 @@ static void __io_complete_rw_common(struct io_kiocb *req, long res)
>>>    	} else {
>>>    		req_set_fail(req);
>>>    		req->cqe.res = res;
>>> +
>>> +		if (io_use_fixed_kbuf(req)) {
>>> +			struct io_async_rw *io = req->async_data;
>>> +
>>> +			io_req_zero_remained(req, &io->iter);
>>> +		}
>>
>> I think it can be exploited. It's called from ->ki_complete, i.e.
>> io_complete_rw, so make the request size enough, if you're stuck
>> copying in [soft]irq for too long.
> 
> Short read seldom happens, so how it can be exploited? And the request size
> can't be too big in this(ublk) use case.

Denial of service by blocking irq. I'm pretty sure we can construct
a quite large bio / request in general case, e.g. with huge pages.
Maybe ublk forces splitting, but I wouldn't rely on the ublk
behaviour as it's a generic feature even though currently with
one user. We should move it to the task context, where io_uring
requests end up anyway. I'm pretty it can be cleaned up to not
have any overhead later.

-- 
Pavel Begunkov


