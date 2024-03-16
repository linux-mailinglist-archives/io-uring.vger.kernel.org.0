Return-Path: <io-uring+bounces-1030-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63B8287DAD8
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:36:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 868261C20B59
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0421172C;
	Sat, 16 Mar 2024 16:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BE0J5Pps"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734091774E
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710606965; cv=none; b=mKI+5Lr9mvtkmTNSHQNTvfvm3Zy7rJJQ/swxlmzYSA1WcCoFQbAEsBKEf966D3XLZKJM+fYuNkWo+bPZiXI5zKZhrINd/nvVfo65Ec7RiPXOTQRzS7S6zLPW8uSPTOyqM9LjSZm9FLV+LGIRxGDyGMvPm8kJZyMy+Gvqe2hs+bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710606965; c=relaxed/simple;
	bh=JCLH6OnY89aczF/h64ahEQLf//GIOP4ivcNehJ52apE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CSr903dZ3fKpGyzFl9lKbj/ko4SmGLwbR786xLhXe70QtEGdM/ooKGX2Zif359AKYATyDgclIu/AIL5v1VgQxYgGPke3XeAJomFMKynHFagKqv30+25lOmasps1prpqRo09L41gPkqakmvc4pPXJEY0f1s4TgIQuzZOSTD17KIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BE0J5Pps; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1dee6672526so2838785ad.1
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710606962; x=1711211762; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6ekj5lMXAa/iBT7TSVZBbLmLJFsJfK/gRlw/ahp+t7M=;
        b=BE0J5PpsixtxDlxL/CGbhzzIsrYO2FCT4dFdg95zh7p9+rKZvW7bClxPenvVzdErNb
         rWOGJuMn+gTsT5QD+M4JZ//4L9CV6xqsMcz6fJizAs0OBWEWPRW11iarlwZM7q2BqqHa
         mIb74mFdwMtqGedPsorz7ZOn9Oqjyc3nHLEOyStUAVlCT1KNoyjuSPC82O0VjROeVRtQ
         PwUpAiPs/Dc6n3E1OKSP9Zv3F2XrtLBuppDQxt8nG1zJNwLmrbbcP0bod3n2o/Ulv3QM
         KyJCNhCElCwqO7fEN0wkgjRbzaK2wb8JTxiJH+24BuY8ehFgmEIAsH2ztymLfzzrbQ+e
         qkcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710606962; x=1711211762;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ekj5lMXAa/iBT7TSVZBbLmLJFsJfK/gRlw/ahp+t7M=;
        b=UyWNuTOtzIivi0Gx7smFSfHdhXvSt7tXsEZEx6ErGbgWqQAiJvdLiqmXcBDzSaWzWT
         gnA1/Eckck16d8JzotWVoDKcdIg4+pXxjg9pFQg4g4dE2b7x11H1eVdDdKUMcW44RxkS
         ilDth1tCYGRSddVqmMImVgfwvMfAX8mJNPvmxsm0T4o2iMeTBVnK/wGS/gC4PGYGArRs
         QTR1VRaPgNM+JDHFunPE3SURcOAnCEa5EKwdq26GeVHsO/JdRuE4jI4FltMkvyUkjEH5
         YYiWecdxTiRJweqsVV7Xta9T/hQcXaPZkblcSuzQqiBiGwuedzx3wdcJMzK4CH1zsh4p
         VOMA==
X-Forwarded-Encrypted: i=1; AJvYcCUnslAs0ATJ2iZGqM27aOMS75wi/1A1h5RqKmGDvmxxDQbXBJ/nBl0bsRvYjFN4PVI08wztYpx+DJd2L6lwbDmXzuiZsQ5tfGI=
X-Gm-Message-State: AOJu0YzsU8M+RirMNwYlCWVkWFDawMpC8Y2fUbGM/0uNoQsKla/9hHDv
	o41uDrhrLbv6N39Xv9iKvKKoKLbpagJCMmczOADEfWfk5gIUhIaX6sV64+mPYQU=
X-Google-Smtp-Source: AGHT+IFE/spI5os+6nNVL/g9BFOTuMYB2m7rFxPcaixIw7fjhz5wfSReu1lTdBJvg7+vGQEpUklWbQ==
X-Received: by 2002:a17:902:e84e:b0:1dc:82bc:c072 with SMTP id t14-20020a170902e84e00b001dc82bcc072mr7614373plg.1.1710606961758;
        Sat, 16 Mar 2024 09:36:01 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id mp16-20020a170902fd1000b001dbb6fef41fsm5991127plb.257.2024.03.16.09.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:36:01 -0700 (PDT)
Message-ID: <0224b8e1-9692-4682-8b15-16a1d422c8b2@kernel.dk>
Date: Sat, 16 Mar 2024 10:36:00 -0600
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
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6affbea3-c723-4080-b55d-49a4fbedce70@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/16/24 10:32 AM, Pavel Begunkov wrote:
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
>>>>>>>>>              def->fail(req);
>>>>>>>>>          io_req_complete_defer(req);
>>>>>>>>>      }
>>>>>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>              }
>>>>>>>>>              req->flags |= REQ_F_CREDS;
>>>>>>>>>          }
>>>>>>>>> -
>>>>>>>>> -    return def->prep(req, sqe);
>>>>>>>>> +    return 0;
>>>>>>>>>      }
>>>>>>>>>
>>>>>>>>>      static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>          int ret;
>>>>>>>>>
>>>>>>>>>          ret = io_init_req(ctx, req, sqe);
>>>>>>>>> -    if (unlikely(ret))
>>>>>>>>> +    if (unlikely(ret)) {
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
>>>
>>> Which one and/or which part of it?
>>
>> send zc
> 
> I don't think so. If prep wasn't called there wouldn't be
> a notif allocated, and so no F_MORE required. If you take
> at the code path it's under REQ_F_NEED_CLEANUP, which is only
> set by opcode handlers

I'm not making this up, your test case will literally fail as it doesn't
get to flag MORE for that case. FWIW, this was done with EARLY_FAIL
being flagged, and failing if we fail during or before prep.

-- 
Jens Axboe


