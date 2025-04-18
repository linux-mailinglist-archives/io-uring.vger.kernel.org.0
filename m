Return-Path: <io-uring+bounces-7553-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D4AA93E00
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 20:54:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F3D646281A
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 18:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A7445009;
	Fri, 18 Apr 2025 18:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="DWw6tHbl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B4B1DF968
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 18:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745002480; cv=none; b=b904Q+fMm4TY7/eouPZTLYyTXiZQ8SWxN3KD8UQszIBat3jKnqEavtSgcIkMEzZRoF49vHvfPyQQw2vOT1+MtdsLZBVbPBnV/zANBGUy5TXodlgO1BTTTTLaNzTQSJsHfCjstNakMDCmThwu27LXYC58Gzyh6h8PZvr9WYAyYCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745002480; c=relaxed/simple;
	bh=y0pIE6RCuRrUD/+1yOxQ3/n3Nw/g3z/A9MQBRUjToTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OkctHAmFYr8ZHEsvZ1rHIYB9L6OP5nkbDVghBHEblSW8pR2cvBmQ2V5vti8Lb1oDvVV3KOsIHpFhJCKJNDx66YRVunkGpGZIfYwL+Mp5wDraE6NA3NOqTCwD/S2dlNPvxUyvp0bK4h5tozJ2cx97ZmSAvut8QtUD/isQRy7fb0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=DWw6tHbl; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-226185948ffso24918325ad.0
        for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 11:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1745002478; x=1745607278; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s8nCTjFwY/nQKN3+Pt7v9b6CExgaas4lnVDEX6vqwFg=;
        b=DWw6tHblJs9QGmst6P9D2R+GRKKMWmunhkN/hkA2cMgqmnEMWNWwQ30ICMhzJnULGB
         hxLn38vrL5Vw/ieg8ldZoGvEsDQpSsvhM8f/YZ2FX6mF2/5HlRbz1Hyo6wNeIcpEkL3S
         zwEs9ecbodLuHYsRQteMnh0DyP4jIDs3y0XeekT8FMnIBvAlfSL6rgOKfit7CTVy1gH/
         RBFbitElDBc4J0rr1XOSVU2l+vQK0E35pCvanzjFotjH8ebVDfA5Tetc5Wr9TnWvOeFj
         YyfY3J3xHfRHojgziJuCjlSHR2pvgMCynYNsyjRWh6xpwF0wGkbjPfgjj/mkGjwe3MWz
         HwOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745002478; x=1745607278;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s8nCTjFwY/nQKN3+Pt7v9b6CExgaas4lnVDEX6vqwFg=;
        b=lal2ZjCvWP2HIfVOyvBKFfZfLyfWdSLnbKA5aNdx1FCDtYsjbKW5cS/0chx8N5Aixp
         cbYrfU9TEcFNbAPYQ92nTMPXp4M/mZYums+FTmvcuRMrmU5ymiOLqF7H/C0eORLxC8Md
         s8ou1ssiAreOHi8Yzuag9tY+GMMqkJnU+JQCKdQXEwr4Iijo3zR5U0ak4fGnxln5a5SQ
         u3q+HsfqTUCDp1HHMslIHZykc13gEXaq2ced1xIBtlbEH+K4B+0vj1XmuWp8v6c+YXWG
         cFoOKbB44YOZCaMMMbbawUxzzHyUSUo4USS4wtzjTwP6R4Xd3T1edZ2zBBK+/HCCdmHS
         ZR6g==
X-Forwarded-Encrypted: i=1; AJvYcCVFxI02+O7T4g0FVWh1j2moN5Iw8i8d1IYnVztc823KwDIJ1ckDkO94FS8BMl4RaUJq10sroiYLVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKUaIMaxMtMcp8j//7Vx1XzJuJ5jgEvACTtZgm1iVjRX7+b/PF
	nMKSUZzXgc0XjeA6z+knUb25oAhSAMvhDBr1tpJg/ZQp8/SlAHI7ZzTGcfAO7to=
X-Gm-Gg: ASbGncsotAzxHHx/jtt5pw/DEUl2W4fk1izq+Ra62NFwMw9s4RWgjmzqI1jFyjJ9bI/
	QwmLAhkgcdhDmrvuiQAaPzlptJNWMR/yZSx3rKNIG7E+ax/+nx0wQzOrS1cL732xf097Si5IIf8
	G9nr47rkEYCIZV+zoiHMG3DkfYBIRIEphHutaFe0kQPLq3x3IDl6OxIks4qsCUAsL1eHnsitkuO
	dsdF8N0BCfJR2szJKZtV1X1iW/QgGaQ7YESRbteHAYiSfyU7dV2chkSWtnflG5CBj0K8UEkJW2W
	6DblSkEk12f8MEYcdUsIE+tU9ne7qlJ77WY3npC1sayd8p43sAV7NElY97gdWXJ3hikLp2qXEit
	tO7cjpgH5+3TDsA==
X-Google-Smtp-Source: AGHT+IFsIyxl9eERkJC/IKW7wp/Ml53DJ6uwdnp8bQ1Hiv0SgWCCG3p3Kj+3x5F1KjqysFuq49+U2A==
X-Received: by 2002:a17:902:e88f:b0:223:58ff:c722 with SMTP id d9443c01a7336-22c535acbf9mr55252015ad.28.1745002477696;
        Fri, 18 Apr 2025 11:54:37 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:1cf1:8569:9916:d71f? ([2620:10d:c090:500::6:5122])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50bf3391sm20297645ad.60.2025.04.18.11.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 11:54:37 -0700 (PDT)
Message-ID: <970686b3-041b-4dee-b875-4a50d87eda42@davidwei.uk>
Date: Fri, 18 Apr 2025 11:54:36 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] io_uring/zcrx: add support for multiple ifqs
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1744815316.git.asml.silence@gmail.com>
 <8d8ddd5862a4793cdb1b4486601e285d427df22e.1744815316.git.asml.silence@gmail.com>
 <1b14f24b-f84a-4863-a0cb-33d0ebcd9171@davidwei.uk>
 <68cd2f57-91cc-4727-ab07-f46fe1f8994c@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <68cd2f57-91cc-4727-ab07-f46fe1f8994c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2025-04-18 10:22, Pavel Begunkov wrote:
> On 4/18/25 18:01, David Wei wrote:
>> On 2025-04-16 08:21, Pavel Begunkov wrote:
>>> Allow the user to register multiple ifqs / zcrx contexts. With that we
>>> can use multiple interfaces / interface queues in a single io_uring
>>> instance.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   include/linux/io_uring_types.h |  5 ++--
>>>   io_uring/io_uring.c            |  3 +-
>>>   io_uring/net.c                 |  8 ++---
>>>   io_uring/zcrx.c                | 53 +++++++++++++++++++++-------------
>>>   4 files changed, 40 insertions(+), 29 deletions(-)
>>>
>> [...]
>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>> index 5f1a519d1fc6..b3a643675ce8 100644
>>> --- a/io_uring/net.c
>>> +++ b/io_uring/net.c
>>> @@ -1185,16 +1185,14 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>       struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>>       unsigned ifq_idx;
>>>   -    if (unlikely(sqe->file_index || sqe->addr2 || sqe->addr ||
>>> -             sqe->addr3))
>>> +    if (unlikely(sqe->addr2 || sqe->addr || sqe->addr3))
>>>           return -EINVAL;
>>
>> Why remove sqe->file_index?
> 
> it's aliased with ->zcrx_ifq_idx. The ifq_idx check below
> essentially does nothing. And fwiw, userspace was getting
> correct errors, so it's not a fix.
> 

Got it.

>>>       ifq_idx = READ_ONCE(sqe->zcrx_ifq_idx);
>>> -    if (ifq_idx != 0)
>>> -        return -EINVAL;
>>> -    zc->ifq = req->ctx->ifq;
>>> +    zc->ifq = xa_load(&req->ctx->zcrx_ctxs, ifq_idx);
>>>       if (!zc->ifq)
>>>           return -EINVAL;
>>> +
>>>       zc->len = READ_ONCE(sqe->len);
>>>       zc->flags = READ_ONCE(sqe->ioprio);
>>>       zc->msg_flags = READ_ONCE(sqe->msg_flags);
>>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>>> index d56665fd103d..e4ce971b1257 100644
>>> --- a/io_uring/zcrx.c
>>> +++ b/io_uring/zcrx.c
>>> @@ -172,9 +172,6 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
>>>     static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
>>>   {
>>> -    if (WARN_ON_ONCE(ifq->ctx->ifq))
>>> -        return;
>>> -
>>
>> I think this should stay.
> 
> There is not ctx->ifq anymore. You may look up in the xarray,
> but for that you need to know the index, and it's easier to
> just remove it.

Yeah, and it's rather defensive to check.

> 
>  
>>>       io_free_region(ifq->ctx, &ifq->region);
>>>       ifq->rq_ring = NULL;
>>>       ifq->rqes = NULL;
>> [...]
>>> @@ -440,16 +443,23 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>>>     void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
>>>   {
>>> -    struct io_zcrx_ifq *ifq = ctx->ifq;
>>> +    struct io_zcrx_ifq *ifq;
>>> +    unsigned long id;
>>>         lockdep_assert_held(&ctx->uring_lock);
>>>   -    if (!ifq)
>>> -        return;
>>> +    while (1) {
>>> +        scoped_guard(mutex, &ctx->mmap_lock) {
>>> +            ifq = xa_find(&ctx->zcrx_ctxs, &id, ULONG_MAX, XA_PRESENT);
>>> +            if (ifq)
>>> +                xa_erase(&ctx->zcrx_ctxs, id);
>>> +        }
>>> +        if (!ifq)
>>> +            break;
>>> +        io_zcrx_ifq_free(ifq);
>>> +    }
>>
>> Why not xa_for_each()? Is it weirdness with scoped_guard macro?
> 
> I don't want io_zcrx_ifq_free() to be under mmap_lock, that might
> complicate sync with mmap. It's good enough for now, but I'd like
> to have sth like this in the future:
> 
> struct xarray tmp_onstack_xarray;
> 
> scoped_guard(mutex, &ctx->mmap_lock)
>     xarray_swap(&tmp_onstack_xarray, &ctx->zcrx);
> for_each_xarray(tmp_onstack_xarray)
>     io_zcrx_ifq_free();
> 
> but there is no xarray_swap AFAIK.
> 

Reviewed-by: David Wei <dw@davidwei.uk>

