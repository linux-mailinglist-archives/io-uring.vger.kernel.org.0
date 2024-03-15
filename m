Return-Path: <io-uring+bounces-1003-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB02187D775
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 00:54:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87B77282F84
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 23:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318C81EB48;
	Fri, 15 Mar 2024 23:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Pg4mH/go"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450F35B213
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 23:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710546835; cv=none; b=mTgovE06uFC5Qa11srM9iXA82Wkl0AxWGdPaaKxOA66cbogel2cs3OVrcQXwf3I6rLj6A7oia1qowrhYlLxZH7JYMJy8jgAA5T7hQ6/iOKPzT6+ZOkaA8/u8PTDM76ojlBbqri3cuZ1Jc3eIIl9QkW8jJQTayCbNR6X+h3D5fzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710546835; c=relaxed/simple;
	bh=MjChKK4CmzljLX3BKeCGAEGp3yDXChHiMQnAtcoMzhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Bo8B9oKycanVkBOAi5IRsPvflz25d2JWozn8gJYG8BtTdB8fOh3jDig+z0lisDwEgoHLya5SbquJSp9mFDEEVT64l4RSo8sxc0CnL6dVWFfDsWLsZepsT8eYwuh8B3xjq1CJsINXA40geVt/Y/d+W9u5STZpmo1I5divTFP5SJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Pg4mH/go; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e6c38be762so561453b3a.1
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 16:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710546831; x=1711151631; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6bthKZB7MUVtEi7DpZqth/NPlMAy90ceRufzRGC2IdA=;
        b=Pg4mH/goBwaSQdv18fvPF+hlHBdImMt0d/JGEf2RWDwXZvNBYZnGw0JZKV+N35vnoH
         i83fUkcL1dnh4UDUm2r3Og+08STA3OIxJFb0I3mxaEZFfUt9O8nGJ7cEaRWNpzC/d7H2
         tWTclf4X+uOEeF3e6XDaSFhCXxAzWebLh3XzDr05bdzCbBeo68sB2UbaYhL44uHJXcQG
         n+OIKmbcqLr3PA9hAdfvIELu+GQaw79bVa3J+ByfVRdElfekT2krikh4J+r/xtN6qZeO
         u32jfiuH6n/gM/znXQtc3AEnP6zwHZm0Ni+GTqjsFvs4pU6hwxrmgP1FgOYT1WkZESZJ
         br4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710546831; x=1711151631;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6bthKZB7MUVtEi7DpZqth/NPlMAy90ceRufzRGC2IdA=;
        b=bfTw7Psu8z0xG3jz+QAbiZEZn+ZQ4/hJ99KzanHVB06pgVr+J71UANy992KJFPAuBf
         6SmWQE8I//B5vJtuzB22bl0VCx+PLn6gq+kL5qIT7t5xHhwG7419K6QMLxdYuhNZV9ds
         4GAmBO79JyKYnfsixm+0jd2okxOp9eyX8SAgPWrXRZL8pTPrKI5Cizz/abTzokvdSOAI
         5QGMbTPmTF42pC7Zm/U8yx7T6VBOwHQeOm2L6GSEGF7Q+VaL+vIiMXhVk7y2JoS+vvr5
         Nuru3FUVa5H1yByfgqPJRbflCCV9yVFqDo/ue7Bzts+18IONR+16Hx2QA46Nf9vyA6yd
         zCtQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4OF/aiDIldrUsgGs0QiqjYlTubFBskJp2xbmjBfC1nS6hfwSibApXljEhpcI8CzL4qYDeoY+/e9OQSF7hchNwvY0pK+6O4Ew=
X-Gm-Message-State: AOJu0Yx6Qs0Ed73pCLHyW8CJEVAcAPydIZRAxlGQqgtKyessQZsklHWW
	Rh653Ww/yucMNU594AZqBtPgqF0IAnY18zY5NYC6iPWjcE1fKN2C81ZfnkgLebc=
X-Google-Smtp-Source: AGHT+IFGoBCrWzSWsihF9dlRISqPZ5dYsdOqfGwivF+dQ6lA9oe7t/5qxUPF1vNzjWTGqf5yfMTK8w==
X-Received: by 2002:a05:6a20:9c8e:b0:1a1:42db:9c5a with SMTP id mj14-20020a056a209c8e00b001a142db9c5amr7780270pzb.6.1710546831559;
        Fri, 15 Mar 2024 16:53:51 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id jj4-20020a170903048400b001dc96cb0358sm4477034plb.206.2024.03.15.16.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 16:53:50 -0700 (PDT)
Message-ID: <6abb4e98-b7b1-40b5-8854-918f372c549b@kernel.dk>
Date: Fri, 15 Mar 2024 17:53:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: ensure async prep handlers always
 initialize ->done_io
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <472ec1d4-f928-4a52-8a93-7ccc1af4f362@kernel.dk>
 <0ec91000-43f8-477e-9b61-f0a2f531e7d5@gmail.com>
 <cef96955-f7bc-4a0f-b3aa-befb338ca84d@gmail.com>
 <2af3dfa2-a91c-4cae-8c4c-9599459202e2@gmail.com>
 <cafdf8d7-2798-4d91-a6e5-3f9486303c6a@kernel.dk>
 <f44e113c-a70f-4293-aea9-bd7b2f9e1b32@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f44e113c-a70f-4293-aea9-bd7b2f9e1b32@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/24 5:28 PM, Pavel Begunkov wrote:
> On 3/15/24 23:25, Jens Axboe wrote:
>> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>>> async handlers. But if we then fail setting it up and want to post
>>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>>> potential errors, but we need to cover the async setup too.
>>>>>
>>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>>> off of an early submission failure path where def->prep has
>>>>> not yet been called, I don't think the patch will fix the
>>>>> problem.
>>>>>
>>>>> ->fail() handlers are fragile, maybe we should skip them
>>>>> if def->prep() wasn't called. Not even compile tested:
>>>>>
>>>>>
>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>> index 846d67a9c72e..56eed1490571 100644
>>>>> --- a/io_uring/io_uring.c
>>>>> +++ b/io_uring/io_uring.c
>>> [...]
>>>>>            def->fail(req);
>>>>>        io_req_complete_defer(req);
>>>>>    }
>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>            }
>>>>>            req->flags |= REQ_F_CREDS;
>>>>>        }
>>>>> -
>>>>> -    return def->prep(req, sqe);
>>>>> +    return 0;
>>>>>    }
>>>>>
>>>>>    static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>        int ret;
>>>>>
>>>>>        ret = io_init_req(ctx, req, sqe);
>>>>> -    if (unlikely(ret))
>>>>> +    if (unlikely(ret)) {
>>>>> +fail:
>>>
>>> Obvious the diff is crap, but still bugging me enough to write
>>> that the label should've been one line below, otherwise we'd
>>> flag after ->prep as well.
>>
>> It certainly needs testing :-)
>>
>> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
>> and hopefully not have to worry about it again. Do you want to clean it
>> up, test it, and send it out?
> 
> I'd rather leave it to you, I suspect it wouldn't fix the syzbot
> report w/o fiddling with done_io as in your patch.

I'd probably be in favor of just doing the net one for now, ensuring
it's OK. Then we can do a generic version for 6.10.

-- 
Jens Axboe


