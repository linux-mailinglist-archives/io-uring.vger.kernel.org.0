Return-Path: <io-uring+bounces-1028-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C09B687DAD4
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A1C51F2189C
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A64CF510;
	Sat, 16 Mar 2024 16:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pohH1HBj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3705C1774E
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710606707; cv=none; b=sDUx2Crh8N55w4MTI5jgnzOhe9bHCBJ1d5VbgCi+G5eFGTbT4mryFJQ/muC+a1W0URGtvWy3Y00TBordsVfNp37g6KVDIkkgIoPYdN9+Njz5ePuHarQ+2knnnnivb0QSvYBaDM18rp7qgSTAeAnQ2udA7UcDAV9phmLd06mEEEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710606707; c=relaxed/simple;
	bh=0TP0m8ctegP2fC7fVYkdENQxFSczZKITfHrtRe0uKS4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FiQ5C4zLBPCNXTJ2XveIK395Ejt56Tkk5k/fyQeKI4oIO1pMVfb/9PIVo3QUkVnKw2bq2fvyO/87YwMKq5veIu0GKtkS2iNi2BVOXyIbGXRkLC/YtcdiKbz8xZnwQWRqeEpGcQGT1K7GYJVUxAxMoIGXqXipDIJx2cBFjxbKLNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pohH1HBj; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-29df844539bso468628a91.1
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710606703; x=1711211503; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Go6GczkK0ovIGwAIICxWoYo9iRY8Q6jjvit5TUkJFhE=;
        b=pohH1HBjCrNfbXHD4YHy7IlrnAS9kCFj6mVCt5WmSEI/9NQZcq6DKaHq812XxJe9jn
         PopicVFeTlK0Xke3yf5GnO53rl2nYflEmVwyPV9UjSRwj5Vi94Ub1UgkCo45MZHrrnFl
         Tw9rn4mlVbNQ1IlZIxhmOnP1769I+mtmUWKJ5sgfaEpe6JsX3b2sgj+7CAPotjHqrqqI
         xb7gx4DzIfLeKlKPaZiU+StxjVGqPtqCD9DKodp+DphZe9d4Wzmj6dfge97vCCcdHwmS
         OP5+VWmAmkbrvRBPg7v84Zc0UUou/Uy+O/rWupJcn9HdY+udd54/YsEK5bvMMnWt1Itf
         IRng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710606703; x=1711211503;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Go6GczkK0ovIGwAIICxWoYo9iRY8Q6jjvit5TUkJFhE=;
        b=aTWk9jOHn9hVrDylq80+MPjYvhiAZaMOakz63Jezxw/1EaxCjU8JjxRwvLQfvVNXzq
         Y2ye5gDgfxlRq8US3vjFOTNOYx2ZDyoug4i1365DUuFOjdUnZ1/4A5uswXc7ALW1LZqX
         WMltz5rdBVv6G8GJzD0fgTvJ20jb+5lTzN6EV3issf9X4na2M4lcUy7uRFFnV4D+kA47
         AX90YtndHmcE0E4BDPuC4o8uua4hkDTb8GhwFg9Q1S7hTvM9emmHa4mDt6wFQL1hIu6j
         t9O0aGFsYkj5LrBAYk/dyi7pfzR7UkqpBGtLklhX+keSJ2/3M8NSs/xgAKDVN0YaCxi0
         Apjw==
X-Forwarded-Encrypted: i=1; AJvYcCXwhVPca0Vbie7VKyli1zg/GArh66pNDSKZ/1B694AJtTzsvN0mP08P9LC98ed6nAoXhCbRFMU2M7n8UfVB2j9iUCiIlr2jBhI=
X-Gm-Message-State: AOJu0YwhEU/n2y3vC9+00+Mg8iiMAGzianBqOG+GV9Z+LtPm3Eyxal7L
	7IUniNkEX+DRXtNSX9kXwOAWEl39aM7ySJCU4zVdVS3fEY3Dgh697rKjXitD/x35t6+KYyk2zCF
	L
X-Google-Smtp-Source: AGHT+IGOvovagac6lqRqkLe8+fLakRXpZUnkj67MCLn1ncwN/hFcj78rvRS/WX9bEVLWe42ZSYvOFg==
X-Received: by 2002:a05:6a20:4292:b0:1a1:4de6:dd5b with SMTP id o18-20020a056a20429200b001a14de6dd5bmr6339460pzj.2.1710606703431;
        Sat, 16 Mar 2024 09:31:43 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id y5-20020a62f245000000b006e5dc1b4861sm5089848pfl.64.2024.03.16.09.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:31:42 -0700 (PDT)
Message-ID: <1e595d4b-6688-4193-9bf7-448590a77cdc@kernel.dk>
Date: Sat, 16 Mar 2024 10:31:41 -0600
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
 <083d800c-34b0-4947-b6d1-b477f147e129@kernel.dk>
 <aae54a98-3302-477f-be3f-39841c1b20d4@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aae54a98-3302-477f-be3f-39841c1b20d4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/16/24 10:28 AM, Pavel Begunkov wrote:
> On 3/16/24 16:14, Jens Axboe wrote:
>> On 3/15/24 5:28 PM, Pavel Begunkov wrote:
>>> On 3/15/24 23:25, Jens Axboe wrote:
>>>> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>>>>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>>>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>>>>> async handlers. But if we then fail setting it up and want to post
>>>>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>>>>> potential errors, but we need to cover the async setup too.
>>>>>>>
>>>>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>>>>> off of an early submission failure path where def->prep has
>>>>>>> not yet been called, I don't think the patch will fix the
>>>>>>> problem.
>>>>>>>
>>>>>>> ->fail() handlers are fragile, maybe we should skip them
>>>>>>> if def->prep() wasn't called. Not even compile tested:
>>>>>>>
>>>>>>>
>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>> index 846d67a9c72e..56eed1490571 100644
>>>>>>> --- a/io_uring/io_uring.c
>>>>>>> +++ b/io_uring/io_uring.c
>>>>> [...]
>>>>>>>             def->fail(req);
>>>>>>>         io_req_complete_defer(req);
>>>>>>>     }
>>>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>             }
>>>>>>>             req->flags |= REQ_F_CREDS;
>>>>>>>         }
>>>>>>> -
>>>>>>> -    return def->prep(req, sqe);
>>>>>>> +    return 0;
>>>>>>>     }
>>>>>>>
>>>>>>>     static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>         int ret;
>>>>>>>
>>>>>>>         ret = io_init_req(ctx, req, sqe);
>>>>>>> -    if (unlikely(ret))
>>>>>>> +    if (unlikely(ret)) {
>>>>>>> +fail:
>>>>>
>>>>> Obvious the diff is crap, but still bugging me enough to write
>>>>> that the label should've been one line below, otherwise we'd
>>>>> flag after ->prep as well.
>>>>
>>>> It certainly needs testing :-)
>>>>
>>>> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
>>>> and hopefully not have to worry about it again. Do you want to clean it
>>>> up, test it, and send it out?
>>>
>>> I'd rather leave it to you, I suspect it wouldn't fix the syzbot
>>> report w/o fiddling with done_io as in your patch.
>>
>> I gave this a shot, but some fail handlers do want to get called. But
> 
> Which one and/or which part of it?

send zc

I think the sanest is:

1) Opcode handlers should always initialize whatever they need before
   failure
2) If we fail before ->prep, don't call ->fail

Yes that doesn't cover the case where opcode handlers do stupid things
like use opcode members in fail if they fail the prep, but that should
be the smallest part.

-- 
Jens Axboe



