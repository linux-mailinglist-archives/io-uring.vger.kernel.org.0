Return-Path: <io-uring+bounces-1040-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5280887DAF0
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 18:01:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D31391F217AA
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3A91B960;
	Sat, 16 Mar 2024 17:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Dptru7Fe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B851BC20
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 17:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710608477; cv=none; b=AZlpFs45gMZuYYPOhcdw/ZXrW4jhB2YEm+SMsUB5xqeaWq+TsVBDIrWpBzd1K2wJxCqbjrIPDVc6hknibJx3yQfrZmQ6hN+/x4rVQnc0AMcMBzHGJiLU6Ts/K8yVfEl/Xqp6Ft7xZXauU5oN15PgGTqvM/ma9IdRnDDDYFSpFXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710608477; c=relaxed/simple;
	bh=zReGmsVH7zqCsXnSGOAWS+xz+vNVf8azzUI8llXEHg8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lRQMLieuBD5DM4JCIMcN6+TUJJ+obW18pYFZQEeP3RWLXplmXw1Ex3ik196RI4B+JmLFcpUDzJtgxWJZQMcv53ZLAZ5MEjGx+0Et1n42rDSHDySuSIK34a9yRfZZesgBT8UpAlElpxvjbsy9/bJr8zNpoO/XU91mYY020Ypp9o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Dptru7Fe; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e6c9f6e654so661472b3a.0
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 10:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710608475; x=1711213275; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WyU0zNBdN91YJ5400iWnkxykAZUvzcCzLO9peffmKLk=;
        b=Dptru7Fe/r/dzHi+QaP64ZaVYLNK1xg0Mms4Ihv/9Y7Uwe4H5TG9aksv7Gp952WL6N
         H5vPWlVU5rOKgNsVB+egGyQxEccq0hskAnZeJWzKxMoYUZSwfl0g/tRY7rcWg+K2Fn6x
         /+2Hb2vmtowMhbhbqiRr5yzNxiEtwiNXoI1STV6tPbqPrD6hJukGo/pFUvIke6aGJPRk
         QT7288c8fLegzJoGz25VUywaeUILXbQgw99VqoDR9u5ZSkM6GcS24++EouE14LlhEnva
         A9ESywNvLRR+0w1AzS/CpDFRKjmYEOreFpmFS/yiRcejvh0vuKVTCmtbXTuf3ofsFEoe
         0kLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710608475; x=1711213275;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WyU0zNBdN91YJ5400iWnkxykAZUvzcCzLO9peffmKLk=;
        b=lq+IL3Pf9+HaVFS+px4/Q+LB7r5sC6P0qjBgxU15UiC5ZdyI2aC0IPJcxcfR2cwbno
         sQs32q6g4f+Y3qXzcBi81p2qpkr859fB2grmNemtDuwbtr2Fe9foekfkx+XIyesx3Vf9
         1yKSnkuVJW5nB0+afrOXpsKCk236W6tutaajHaRm9xCqiKGIVuKXnDmowW+VgXlRfKSn
         4canTWzH3qU/qZDgfnqWJZhPZ8he6AyhlOe2QDntqCrgEwd8V9garYMBR0/o8Llcz0kk
         nBkto2X7LNohb/Bi9wF7FATqxbt0jMe1Kf05K2PyFSRu0EhWYtpg7iOVLoFVZbU/9pFP
         dtTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjnOyex8YImLmWzW1yVIsjeeOFDCafgmOst5Yy8OQBxmmsOX4wnd1blmH6v7ySb50Bb2zYN9Km1JLPnFiIPqnJ5JOyxh74ilE=
X-Gm-Message-State: AOJu0YxCJfwPYWKCgZMSxGby6ahpnQPqFRuCF9TZNxOCZwpOIo74yevF
	We+/7uKyQ0beuVf83nTpiM50G/GEiA8ltnhK/oWRqo8G0cMSv5J/DbciPJmKyBO6d6xeA6NvvdZ
	4
X-Google-Smtp-Source: AGHT+IGj0LrieDdgt8pqGgOSgcPftEoy18tYtI9LtbDKa9p2go28JS1zst1ip5xYHOmmHACYvAqT9Q==
X-Received: by 2002:a05:6a20:1451:b0:1a1:85d6:e2a4 with SMTP id a17-20020a056a20145100b001a185d6e2a4mr6734407pzi.1.1710608474556;
        Sat, 16 Mar 2024 10:01:14 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id n29-20020a634d5d000000b005d6a0b2efb3sm4303093pgl.21.2024.03.16.10.01.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 10:01:13 -0700 (PDT)
Message-ID: <c2e551c2-446e-4f83-89b2-ccdfa6438ce0@kernel.dk>
Date: Sat, 16 Mar 2024 11:01:13 -0600
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
 <1e595d4b-6688-4193-9bf7-448590a77cdc@kernel.dk>
 <6affbea3-c723-4080-b55d-49a4fbedce70@gmail.com>
 <0224b8e1-9692-4682-8b15-16a1d422c8b2@kernel.dk>
 <30535d27-7979-4aa9-b8f7-e35eb51dedb0@gmail.com>
 <0f3bc43a-7533-40b2-b9c8-615abf4f81c1@kernel.dk>
 <34586d43-2553-402e-b53b-a34b51c8f550@gmail.com>
 <a7d4d0d6-1b0f-4618-8c87-b831e653993c@kernel.dk>
 <fe6e491c-f661-45db-90aa-f58cf9032cb4@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <fe6e491c-f661-45db-90aa-f58cf9032cb4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/16/24 10:57 AM, Pavel Begunkov wrote:
> On 3/16/24 16:51, Jens Axboe wrote:
>> On 3/16/24 10:46 AM, Pavel Begunkov wrote:
>>> On 3/16/24 16:42, Jens Axboe wrote:
>>>> On 3/16/24 10:36 AM, Pavel Begunkov wrote:
>>>>> On 3/16/24 16:36, Jens Axboe wrote:
>>>>>> On 3/16/24 10:32 AM, Pavel Begunkov wrote:
>>>>>>> On 3/16/24 16:31, Jens Axboe wrote:
>>>>>>>> On 3/16/24 10:28 AM, Pavel Begunkov wrote:
>>>>>>>>> On 3/16/24 16:14, Jens Axboe wrote:
>>>>>>>>>> On 3/15/24 5:28 PM, Pavel Begunkov wrote:
>>>>>>>>>>> On 3/15/24 23:25, Jens Axboe wrote:
>>>>>>>>>>>> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>>>>>>>>>>>>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>>>>>>>>>>>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>>>>>>>>>>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>>>>>>>>>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>>>>>>>>>>>>> async handlers. But if we then fail setting it up and want to post
>>>>>>>>>>>>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>>>>>>>>>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>>>>>>>>>>>>> potential errors, but we need to cover the async setup too.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>>>>>>>>>>>>> off of an early submission failure path where def->prep has
>>>>>>>>>>>>>>> not yet been called, I don't think the patch will fix the
>>>>>>>>>>>>>>> problem.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> ->fail() handlers are fragile, maybe we should skip them
>>>>>>>>>>>>>>> if def->prep() wasn't called. Not even compile tested:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>>>>>>>> index 846d67a9c72e..56eed1490571 100644
>>>>>>>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>>>>>>> [...]
>>>>>>>>>>>>>>>                 def->fail(req);
>>>>>>>>>>>>>>>             io_req_complete_defer(req);
>>>>>>>>>>>>>>>         }
>>>>>>>>>>>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>>>>>                 }
>>>>>>>>>>>>>>>                 req->flags |= REQ_F_CREDS;
>>>>>>>>>>>>>>>             }
>>>>>>>>>>>>>>> -
>>>>>>>>>>>>>>> -    return def->prep(req, sqe);
>>>>>>>>>>>>>>> +    return 0;
>>>>>>>>>>>>>>>         }
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>         static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>>>>>>>>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>>>>>             int ret;
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>             ret = io_init_req(ctx, req, sqe);
>>>>>>>>>>>>>>> -    if (unlikely(ret))
>>>>>>>>>>>>>>> +    if (unlikely(ret)) {
>>>>>>>>>>>>>>> +fail:
>>>>>>>>>>>>>
>>>>>>>>>>>>> Obvious the diff is crap, but still bugging me enough to write
>>>>>>>>>>>>> that the label should've been one line below, otherwise we'd
>>>>>>>>>>>>> flag after ->prep as well.
>>>>>>>>>>>>
>>>>>>>>>>>> It certainly needs testing :-)
>>>>>>>>>>>>
>>>>>>>>>>>> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
>>>>>>>>>>>> and hopefully not have to worry about it again. Do you want to clean it
>>>>>>>>>>>> up, test it, and send it out?
>>>>>>>>>>>
>>>>>>>>>>> I'd rather leave it to you, I suspect it wouldn't fix the syzbot
>>>>>>>>>>> report w/o fiddling with done_io as in your patch.
>>>>>>>>>>
>>>>>>>>>> I gave this a shot, but some fail handlers do want to get called. But
>>>>>>>>>
>>>>>>>>> Which one and/or which part of it?
>>>>>>>>
>>>>>>>> send zc
>>>>>>>
>>>>>>> I don't think so. If prep wasn't called there wouldn't be
>>>>>>> a notif allocated, and so no F_MORE required. If you take
>>>>>>> at the code path it's under REQ_F_NEED_CLEANUP, which is only
>>>>>>> set by opcode handlers
>>>>>>
>>>>>> I'm not making this up, your test case will literally fail as it doesn't
>>>>>> get to flag MORE for that case. FWIW, this was done with EARLY_FAIL
>>>>>> being flagged, and failing if we fail during or before prep.
>>>>>
>>>>> Maybe the test is too strict, but your approach is different
>>>>> from what I mentioned yesterday
>>>>>
>>>>> -    return def->prep(req, sqe);
>>>>> +    ret = def->prep(req, sqe);
>>>>> +    if (unlikely(ret)) {
>>>>> +        req->flags |= REQ_F_EARLY_FAIL;
>>>>> +        return ret;
>>>>> +    }
>>>>> +
>>>>> +    return 0;
>>>>>
>>>>> It should only set REQ_F_EARLY_FAIL if we fail
>>>>> _before_ prep is called
>>>>
>>>> I did try both ways, fails if we just have:
>>>
>>> Ok, but the point is that the sendzc's ->fail doesn't
>>> need to be called unless you've done ->prep first.
>>
>> But it fails, not sure how else to say it.
> 
> liburing tests? Which test case? If so, it should be another

Like I mentioned earlier, it's send zc and it's failing the test case
for that. test/send-zerocopy.t.

> bug. REQ_F_NEED_CLEANUP is only set by opcodes, if a request is
> terminated before ->prep is called, it means it never entered
> any of the opdef callbacks and have never seen any of net.c
> code, so there should be no REQ_F_NEED_CLEANUP, and so
> io_sendrecv_fail() wouldn't try to set F_MORE. I don't know
> what's wrong.

Feel free to take a look! I do like the simplicity of the early error
flag.

-- 
Jens Axboe


