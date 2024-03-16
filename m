Return-Path: <io-uring+bounces-1032-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 912E987DADB
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:36:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3CE81C20A51
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D230D1774E;
	Sat, 16 Mar 2024 16:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LUKIfBHL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB9B1B952
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710607012; cv=none; b=LC/mYOvV+eFlbMwdfTHw+uJBr6PY4budH9gjklFZTM60vJYNp/lpc4mhg3DMbKwVUW/LIM8CwI8g0MRg1su2+0NjlPIWagVUa8eQewuFPuCs/LKimgHBVviVpr2/f0BMHRZ4gV3Rrgfe/jCu4mR7ngBpCDgPa37qnNGFGUBmfXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710607012; c=relaxed/simple;
	bh=Tmi2Rv2q4/srE4HPNOmPms6LxdN22HK3rDQn2AQQgl0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=kCgSkUxtZ3WH99++PRiWQIUM93eMiEotuo9mKRiwQjkSO8porLPkiw26fWxcBbVr8wAnmHma5nJzGA21FvaL5hFOXscwduvKNIQx0Dnh2uyQHTQ6AIfayNQiJzWxGl8+wmSlpPNRZVT/4nwPzc+h2Na351q/hLOOngCNeVZVInU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LUKIfBHL; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-414006a0115so16829475e9.3
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710607009; x=1711211809; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I6VnbAjMFm64dtshJVLjq4J4TuUpYW81LiNJAV16rs0=;
        b=LUKIfBHLyonQa6WKTfwMCYYa+cSpEO/z0w9Cyt1HUXsnZQVsRaVT7Cjwy+vTBRCaf9
         8/ptqkPCXEAvgJMB+8Ywoj2r2uYmu+vbhOFYXKLgUMf5CXPYX+QCDt0i/8MPvXR16W9T
         4Lw/CB33ocN1fgI3iCbjvuoDLsVXr0cJeuxQxzIw6l/eRrio8gX3x7iPzcqux5UuF+6B
         xJs8E2TVJhH/QRiJrqY9oR+92CUxANqsFH7qPh9VpPLXzmck50xRaTrXvVlTWCoubHre
         yZl8VRQLdrL4z8nIKcA+ORTH5GYHlXepwkIZX3fqU3lVJJCk5Lg2qoVLH2kGxIYOiGDO
         m3ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710607009; x=1711211809;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I6VnbAjMFm64dtshJVLjq4J4TuUpYW81LiNJAV16rs0=;
        b=fq4liq1Yk0mSqtdIMPHDM508yFUvs8rijzqBSc5Zb7MaF5L9yqD4airw63+SAjW7OF
         Ysv+TOD31piYJCzHdpYjDYq8NGMQMKlRrOHgZNBsdWt4U4Jd69o3JF4OPVCykw0Vtm7s
         M6TA65P33+LjYKgCKKygI9dkQJgDXwUa3XipmaHOnNbBLsqVbr29DdVZiTVcGsfNLMj7
         giMhZuki61jXuPzW2c0mCLu7Yeq1MNrH5dq31CKNG9x52UNaj/VCfVYCzXoQ6EGRlaLS
         B2tTFPGOPdFdv1S76NXqpPUZPZ/VrSvjoxx+vHaB+HDwU9aoY4n8Tb6KWs9cjzChQVgP
         rkVw==
X-Forwarded-Encrypted: i=1; AJvYcCXbRCMo7Jf0L6BxbI1SgtNgEhizbaEKmgWte1vnwcQshkQg5DSLEJdIs70PJzEbM8GVPetvA9IXw7XqFYr9E+kql6rdljFbj4U=
X-Gm-Message-State: AOJu0YyRzQA8rt19l5Mb3rgoGBHahjehPRBXJUdBrs1hzi4Kl4MMF+5f
	kpiY2rS0HzNFCRTs/DLL0saUVbthQ/HCmx1g9N7vziPaiRzCmxk3ZvjCf96Y
X-Google-Smtp-Source: AGHT+IF7DxvTKL9S6yjL8eCo6E/D9LcyusLsDZ9gEVD7Wmkfl0VjVvoZy6V/9/Hh9s9oypVcwFkVaw==
X-Received: by 2002:a05:600c:4e8e:b0:414:286:fd21 with SMTP id f14-20020a05600c4e8e00b004140286fd21mr1842033wmq.28.1710607009131;
        Sat, 16 Mar 2024 09:36:49 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id n22-20020a05600c3b9600b0041408451874sm2029089wms.17.2024.03.16.09.36.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:36:48 -0700 (PDT)
Message-ID: <a71e54e5-8959-47be-b477-16d862254447@gmail.com>
Date: Sat, 16 Mar 2024 16:34:51 +0000
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
From: Pavel Begunkov <asml.silence@gmail.com>
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
In-Reply-To: <6affbea3-c723-4080-b55d-49a4fbedce70@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/16/24 16:32, Pavel Begunkov wrote:
> On 3/16/24 16:31, Jens Axboe wrote:
>> On 3/16/24 10:28 AM, Pavel Begunkov wrote:
>>> On 3/16/24 16:14, Jens Axboe wrote:
>>>> On 3/15/24 5:28 PM, Pavel Begunkov wrote:
>>>>> On 3/15/24 23:25, Jens Axboe wrote:
>>>>>> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>>>>>>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>>>>>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>>>>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>>>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>>>>>>> async handlers. But if we then fail setting it up and want to post
>>>>>>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>>>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>>>>>>> potential errors, but we need to cover the async setup too.
>>>>>>>>>
>>>>>>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>>>>>>> off of an early submission failure path where def->prep has
>>>>>>>>> not yet been called, I don't think the patch will fix the
>>>>>>>>> problem.
>>>>>>>>>
>>>>>>>>> ->fail() handlers are fragile, maybe we should skip them
>>>>>>>>> if def->prep() wasn't called. Not even compile tested:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>> index 846d67a9c72e..56eed1490571 100644
>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>> [...]
>>>>>>>>>              def->fail(req);
>>>>>>>>>          io_req_complete_defer(req);
>>>>>>>>>      }
>>>>>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>              }
>>>>>>>>>              req->flags |= REQ_F_CREDS;
>>>>>>>>>          }
>>>>>>>>> -
>>>>>>>>> -    return def->prep(req, sqe);
>>>>>>>>> +    return 0;
>>>>>>>>>      }
>>>>>>>>>
>>>>>>>>>      static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>          int ret;
>>>>>>>>>
>>>>>>>>>          ret = io_init_req(ctx, req, sqe);
>>>>>>>>> -    if (unlikely(ret))
>>>>>>>>> +    if (unlikely(ret)) {
>>>>>>>>> +fail:
>>>>>>>
>>>>>>> Obvious the diff is crap, but still bugging me enough to write
>>>>>>> that the label should've been one line below, otherwise we'd
>>>>>>> flag after ->prep as well.
>>>>>>
>>>>>> It certainly needs testing :-)
>>>>>>
>>>>>> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
>>>>>> and hopefully not have to worry about it again. Do you want to clean it
>>>>>> up, test it, and send it out?
>>>>>
>>>>> I'd rather leave it to you, I suspect it wouldn't fix the syzbot
>>>>> report w/o fiddling with done_io as in your patch.
>>>>
>>>> I gave this a shot, but some fail handlers do want to get called. But

Maybe I didn't get you right. I assumed you're saying "the zc's ->fail
wants to get called even if prep didn't happen. ?


>>> Which one and/or which part of it?
>>
>> send zc
> 
> I don't think so. If prep wasn't called there wouldn't be
> a notif allocated, and so no F_MORE required. If you take
> at the code path it's under REQ_F_NEED_CLEANUP, which is only
> set by opcode handlers
> 
> 
>>
>> I think the sanest is:
>>
>> 1) Opcode handlers should always initialize whatever they need before
>>     failure

Yes

>> 2) If we fail before ->prep, don't call ->fail

That's what I suggested

>> Yes that doesn't cover the case where opcode handlers do stupid things
>> like use opcode members in fail if they fail the prep, but that should
>> be the smallest part.
>>
> 

-- 
Pavel Begunkov

