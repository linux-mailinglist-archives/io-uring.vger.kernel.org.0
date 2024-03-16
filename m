Return-Path: <io-uring+bounces-1036-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E83687DAE1
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:48:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0F9F1F214E2
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0831B960;
	Sat, 16 Mar 2024 16:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uovp51qG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280A118C36
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710607690; cv=none; b=LrwbpneIA2gZ4+zsk3voRUlx2R1NQtBotSPN5QqYL7PXXWbA+gN678bEcwH5rmFMClNiWUaOw6DlSwsQQtm4Fw71j6mSmEl7GnUuej7oMl3xZYSvXQwf6TwmrdUFKsmZ8leBKI48ctoEMqlUGFsfxMhwDsEofUM2Eek0F3DTkLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710607690; c=relaxed/simple;
	bh=hi9fyfHLTi0v19H46Y6+tpRy5LjOWbka+hpkocpjD9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fGFE/ghl6HOe7Pui91gB64Z6Dcg/CzRi0SMCLCCd0ABu9DUyv9UKw8457D3dM2+0gsHFzcP+jtAsMPWzrooXYp7GDSZoI6DXs8H67qOaQBvFL5b19PX25KSG3GQ1yaDoqmNDXGAXhVhj8OVp4gBtJiwaS+ro1XhGiDIR6myq8cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uovp51qG; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4140844fc85so3928115e9.2
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710607687; x=1711212487; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hbmMAFfSHhPU+YvKC7J0M3p0cNXFG9ntLVJtTdPZTt4=;
        b=Uovp51qG2EO2THZPM+zJKeXahAY/oIv1AzWujFmWE3cXzkYF1RdEyeCdFGUAJ7jrUH
         f7CS1wgbrMfbzRwl6CjIWxXi7mHtHApgLCFrlyHcQfsHx8dy+ME4l6eWc1NmulBkUJNV
         tKL9EU834EYyDOEOq337Itm+wlbROU1jMABuVSFrumv18NaH57pBRMSuZ1XUCN9O73rp
         KM7sfPp91+oTpOCsBcjXkRynVRZ7TqCtJf9BcCU8RMNLOR+Zahax6GOmjmBRL7hzbIjC
         oYwKmM2rwGSxJAmmFB8UujBiKzLf/v4fobra6j5D5upvpAZ9RhWlIsLDF4oZZ/cT43Qh
         zJJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710607687; x=1711212487;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hbmMAFfSHhPU+YvKC7J0M3p0cNXFG9ntLVJtTdPZTt4=;
        b=kMj0zH8Ih+ThtnQymBi4EMg/3DIDnviICf0qMvaGYTUszmSX4ggsHsWt7EZXUGqJYV
         Hexi9GN8MnUDz2CBmmI87bmZi/8ClSCDT+6q41YWg7XvJI76m8rUL2mAZBoUmv+JnXJB
         x3iobR+O0nicm2sfy8j+17J8Ulk6JrRlf9N2azXiECIvk5UaFvNOAhrASKN758NK5xfV
         N0Adna6CTXvqGXy8Mh9vo+mEI+KdghRBq+/FsvwT0t8XagyOX0ZTo/R4GDYkT48sntvr
         1oFON8/SfLufBvwnI6ntBGZh0t0a7o6VOT39crsXAU2jbo5wK1a0z7QuH3dO58WLwcdF
         ECVw==
X-Forwarded-Encrypted: i=1; AJvYcCX0vnqzO7LOpGi4NjU18JC51lyF2ww/cMq3in+NM5PIfDtDyb5mlXfmI7VHg1zsJqwqWKcDjSQdAY7G1oRNu+VPryj2CiYnPYg=
X-Gm-Message-State: AOJu0YyY50VA8UedtGqKALyz5xNIBwz6EkopO36aXOuBlLMDWe18wYXn
	dd/usK3L3LCuIs5zRAgP3IENkYp4UoUHAUxi5/hRezYrxstTVChOPsiwNhZH
X-Google-Smtp-Source: AGHT+IGv7/0eF0DM9YnQlmqJV+76oJ/pA4JKHZ0qUMUVljNlLFT1YxOIa8C8jhqgqjbIpWH57IBtGw==
X-Received: by 2002:a05:600c:474e:b0:413:30dc:698a with SMTP id w14-20020a05600c474e00b0041330dc698amr6718172wmo.25.1710607687306;
        Sat, 16 Mar 2024 09:48:07 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id m8-20020a05600c4f4800b00413ea26f942sm12035703wmq.14.2024.03.16.09.48.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:48:06 -0700 (PDT)
Message-ID: <34586d43-2553-402e-b53b-a34b51c8f550@gmail.com>
Date: Sat, 16 Mar 2024 16:46:08 +0000
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
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
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
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0f3bc43a-7533-40b2-b9c8-615abf4f81c1@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/24 16:42, Jens Axboe wrote:
> On 3/16/24 10:36 AM, Pavel Begunkov wrote:
>> On 3/16/24 16:36, Jens Axboe wrote:
>>> On 3/16/24 10:32 AM, Pavel Begunkov wrote:
>>>> On 3/16/24 16:31, Jens Axboe wrote:
>>>>> On 3/16/24 10:28 AM, Pavel Begunkov wrote:
>>>>>> On 3/16/24 16:14, Jens Axboe wrote:
>>>>>>> On 3/15/24 5:28 PM, Pavel Begunkov wrote:
>>>>>>>> On 3/15/24 23:25, Jens Axboe wrote:
>>>>>>>>> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>>>>>>>>>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>>>>>>>>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>>>>>>>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>>>>>>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>>>>>>>>>> async handlers. But if we then fail setting it up and want to post
>>>>>>>>>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>>>>>>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>>>>>>>>>> potential errors, but we need to cover the async setup too.
>>>>>>>>>>>>
>>>>>>>>>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>>>>>>>>>> off of an early submission failure path where def->prep has
>>>>>>>>>>>> not yet been called, I don't think the patch will fix the
>>>>>>>>>>>> problem.
>>>>>>>>>>>>
>>>>>>>>>>>> ->fail() handlers are fragile, maybe we should skip them
>>>>>>>>>>>> if def->prep() wasn't called. Not even compile tested:
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>>>>> index 846d67a9c72e..56eed1490571 100644
>>>>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>>>> [...]
>>>>>>>>>>>>                def->fail(req);
>>>>>>>>>>>>            io_req_complete_defer(req);
>>>>>>>>>>>>        }
>>>>>>>>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>>                }
>>>>>>>>>>>>                req->flags |= REQ_F_CREDS;
>>>>>>>>>>>>            }
>>>>>>>>>>>> -
>>>>>>>>>>>> -    return def->prep(req, sqe);
>>>>>>>>>>>> +    return 0;
>>>>>>>>>>>>        }
>>>>>>>>>>>>
>>>>>>>>>>>>        static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>>>>>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>>            int ret;
>>>>>>>>>>>>
>>>>>>>>>>>>            ret = io_init_req(ctx, req, sqe);
>>>>>>>>>>>> -    if (unlikely(ret))
>>>>>>>>>>>> +    if (unlikely(ret)) {
>>>>>>>>>>>> +fail:
>>>>>>>>>>
>>>>>>>>>> Obvious the diff is crap, but still bugging me enough to write
>>>>>>>>>> that the label should've been one line below, otherwise we'd
>>>>>>>>>> flag after ->prep as well.
>>>>>>>>>
>>>>>>>>> It certainly needs testing :-)
>>>>>>>>>
>>>>>>>>> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
>>>>>>>>> and hopefully not have to worry about it again. Do you want to clean it
>>>>>>>>> up, test it, and send it out?
>>>>>>>>
>>>>>>>> I'd rather leave it to you, I suspect it wouldn't fix the syzbot
>>>>>>>> report w/o fiddling with done_io as in your patch.
>>>>>>>
>>>>>>> I gave this a shot, but some fail handlers do want to get called. But
>>>>>>
>>>>>> Which one and/or which part of it?
>>>>>
>>>>> send zc
>>>>
>>>> I don't think so. If prep wasn't called there wouldn't be
>>>> a notif allocated, and so no F_MORE required. If you take
>>>> at the code path it's under REQ_F_NEED_CLEANUP, which is only
>>>> set by opcode handlers
>>>
>>> I'm not making this up, your test case will literally fail as it doesn't
>>> get to flag MORE for that case. FWIW, this was done with EARLY_FAIL
>>> being flagged, and failing if we fail during or before prep.
>>
>> Maybe the test is too strict, but your approach is different
>> from what I mentioned yesterday
>>
>> -    return def->prep(req, sqe);
>> +    ret = def->prep(req, sqe);
>> +    if (unlikely(ret)) {
>> +        req->flags |= REQ_F_EARLY_FAIL;
>> +        return ret;
>> +    }
>> +
>> +    return 0;
>>
>> It should only set REQ_F_EARLY_FAIL if we fail
>> _before_ prep is called
> 
> I did try both ways, fails if we just have:

Ok, but the point is that the sendzc's ->fail doesn't
need to be called unless you've done ->prep first.


> 	return def->prep(req, sqe);
> fail:
> 	req->flags |= REQ_F_EARLY_FAIL;
> 	...
> 
> as well.
> 

-- 
Pavel Begunkov

