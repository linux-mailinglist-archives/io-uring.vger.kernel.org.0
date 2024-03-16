Return-Path: <io-uring+bounces-1038-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70A5387DAEB
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:59:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B85972822EC
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81D41B960;
	Sat, 16 Mar 2024 16:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nMUxt6b/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDC98C07
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710608376; cv=none; b=FXfNizehBBVtk9wBeZM11HxfcxsFjzGWU+CE/KCfFD1bQC68zULJ0DImVap6OKv0YjsJLftrGrMsZHZ+X+ZQWoEeQvNsKg2WDZliDMHB2OBumy16ZUeh89BhLBR771GoZ5ZbzvscWMdFwdwwQ91KnQOL/aax2cbvP/LIUatXPns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710608376; c=relaxed/simple;
	bh=hrcaTQvNJLilQSSnYHqNZpmwRhho0koJ98xkAykpyUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ly8cWEtRkvGc9UZx+Fh/Oe0+WDoLAWJx5QHa78VSsWULrMadp23u+qAkmvtEoagIFvgo0dAFvvVfPIaeWBK8TyuOYCMhGDyOlZZxrN/+SrZgE8Wq7fTbLXLnXehhwRYmjd3g85jDVhsc2GOb+6MTmL3eEBOme/XkTDrIpMG5rbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nMUxt6b/; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-33fd8a2a3e6so172347f8f.0
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710608373; x=1711213173; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X4aaN7MgYGAWvynJxxVtdx35lcRQ04JQJWkikmLfhTo=;
        b=nMUxt6b//8vj62KVHTHGnlqTgjICfqtPici6ddwCEXQy09kHG3rvvnlLvTDVrYEH7z
         L+C7wXZHDlh1ix3lGDkW3zRnRAiAjlivUSB+IZO0FDu2V5Al4sKPUdyNNVfhlM6+Xr39
         SjXwCZHDXo/ztuD6pdW90gq0DLatJTpecW7K+JLLJvUwONG+OUz05dJv4cCqatlGFteT
         kmcavFceNr1pbWfFC2aaYSppqMElJ68e+cgYuuOblJqHeFgApQsxeGQ1GK+YpfpvE872
         5d5yLi8Ku/nhf84CsCIsH6g6XzhulRFpKv0fNu/76WuIZJFqtKw56ejXdXs8MR726GLU
         DcNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710608373; x=1711213173;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X4aaN7MgYGAWvynJxxVtdx35lcRQ04JQJWkikmLfhTo=;
        b=EelsaVsH2e4+GoRwLE3Ne/SdBNtE+voROQd3P+U9EV2iB98zmt1mhMQu1p6YtfEFXO
         +SBUhk7G25DtyYvepKKRdA0r1rRKbLRztO3KvMYWyggeiqDLAw2lo1vQ9f4Ly4fDxLQK
         TKves9xcSFlPjNlYgTYx8kXOKIHAY261+X6fKJ5sXQNKZEnOMAE3uz12K8DmtGixFFHy
         eJQ4q9T8eSALXRFQPfu/OL4pP3/HqD2WQ6FjkEeeNsy1xX5oWZlA2awQRIFDO8G/6zic
         xyhrwa+qdY+xhQri71NH4T4Nh0h7+OQQfyBpPga0yB98cDZQBk2iFbC9xjbnR9o0YBf7
         iQHw==
X-Forwarded-Encrypted: i=1; AJvYcCXWvrYAe8psd62yrkt8E6tbq1xOggP7BgIUJq9AiyC228cmcCRRquRPIBxRUNPW0CzHjpF49PCiEzTRmifWXUQlh+z7hjfiq/s=
X-Gm-Message-State: AOJu0YxtJqDpPxf2hm7eaLEhad3CIP55TjnRHAXlqQAaRpp6F8B8rR5z
	Ornj5tUU0M07tCTt8hnf03ARXv8qBCsU1mAx4/cc9ti8sdRdLmEft+teNqj2
X-Google-Smtp-Source: AGHT+IEH35zEc7s3+uDQotPJbHETyEZt7b1DomkOL/Ox78/Sj/LMP+YRzn6nbvnR+D/y9t5thjrXSg==
X-Received: by 2002:a5d:5005:0:b0:33e:7831:8f69 with SMTP id e5-20020a5d5005000000b0033e78318f69mr7299358wrt.32.1710608372913;
        Sat, 16 Mar 2024 09:59:32 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id s15-20020adfeccf000000b0033e9e26a2d0sm5753066wro.37.2024.03.16.09.59.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:59:32 -0700 (PDT)
Message-ID: <fe6e491c-f661-45db-90aa-f58cf9032cb4@gmail.com>
Date: Sat, 16 Mar 2024 16:57:32 +0000
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
 <34586d43-2553-402e-b53b-a34b51c8f550@gmail.com>
 <a7d4d0d6-1b0f-4618-8c87-b831e653993c@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a7d4d0d6-1b0f-4618-8c87-b831e653993c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/24 16:51, Jens Axboe wrote:
> On 3/16/24 10:46 AM, Pavel Begunkov wrote:
>> On 3/16/24 16:42, Jens Axboe wrote:
>>> On 3/16/24 10:36 AM, Pavel Begunkov wrote:
>>>> On 3/16/24 16:36, Jens Axboe wrote:
>>>>> On 3/16/24 10:32 AM, Pavel Begunkov wrote:
>>>>>> On 3/16/24 16:31, Jens Axboe wrote:
>>>>>>> On 3/16/24 10:28 AM, Pavel Begunkov wrote:
>>>>>>>> On 3/16/24 16:14, Jens Axboe wrote:
>>>>>>>>> On 3/15/24 5:28 PM, Pavel Begunkov wrote:
>>>>>>>>>> On 3/15/24 23:25, Jens Axboe wrote:
>>>>>>>>>>> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>>>>>>>>>>>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>>>>>>>>>>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>>>>>>>>>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>>>>>>>>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>>>>>>>>>>>> async handlers. But if we then fail setting it up and want to post
>>>>>>>>>>>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>>>>>>>>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>>>>>>>>>>>> potential errors, but we need to cover the async setup too.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>>>>>>>>>>>> off of an early submission failure path where def->prep has
>>>>>>>>>>>>>> not yet been called, I don't think the patch will fix the
>>>>>>>>>>>>>> problem.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> ->fail() handlers are fragile, maybe we should skip them
>>>>>>>>>>>>>> if def->prep() wasn't called. Not even compile tested:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>>>>>>> index 846d67a9c72e..56eed1490571 100644
>>>>>>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>>>>>> [...]
>>>>>>>>>>>>>>                 def->fail(req);
>>>>>>>>>>>>>>             io_req_complete_defer(req);
>>>>>>>>>>>>>>         }
>>>>>>>>>>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>>>>                 }
>>>>>>>>>>>>>>                 req->flags |= REQ_F_CREDS;
>>>>>>>>>>>>>>             }
>>>>>>>>>>>>>> -
>>>>>>>>>>>>>> -    return def->prep(req, sqe);
>>>>>>>>>>>>>> +    return 0;
>>>>>>>>>>>>>>         }
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>         static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>>>>>>>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>>>>             int ret;
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>             ret = io_init_req(ctx, req, sqe);
>>>>>>>>>>>>>> -    if (unlikely(ret))
>>>>>>>>>>>>>> +    if (unlikely(ret)) {
>>>>>>>>>>>>>> +fail:
>>>>>>>>>>>>
>>>>>>>>>>>> Obvious the diff is crap, but still bugging me enough to write
>>>>>>>>>>>> that the label should've been one line below, otherwise we'd
>>>>>>>>>>>> flag after ->prep as well.
>>>>>>>>>>>
>>>>>>>>>>> It certainly needs testing :-)
>>>>>>>>>>>
>>>>>>>>>>> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
>>>>>>>>>>> and hopefully not have to worry about it again. Do you want to clean it
>>>>>>>>>>> up, test it, and send it out?
>>>>>>>>>>
>>>>>>>>>> I'd rather leave it to you, I suspect it wouldn't fix the syzbot
>>>>>>>>>> report w/o fiddling with done_io as in your patch.
>>>>>>>>>
>>>>>>>>> I gave this a shot, but some fail handlers do want to get called. But
>>>>>>>>
>>>>>>>> Which one and/or which part of it?
>>>>>>>
>>>>>>> send zc
>>>>>>
>>>>>> I don't think so. If prep wasn't called there wouldn't be
>>>>>> a notif allocated, and so no F_MORE required. If you take
>>>>>> at the code path it's under REQ_F_NEED_CLEANUP, which is only
>>>>>> set by opcode handlers
>>>>>
>>>>> I'm not making this up, your test case will literally fail as it doesn't
>>>>> get to flag MORE for that case. FWIW, this was done with EARLY_FAIL
>>>>> being flagged, and failing if we fail during or before prep.
>>>>
>>>> Maybe the test is too strict, but your approach is different
>>>> from what I mentioned yesterday
>>>>
>>>> -    return def->prep(req, sqe);
>>>> +    ret = def->prep(req, sqe);
>>>> +    if (unlikely(ret)) {
>>>> +        req->flags |= REQ_F_EARLY_FAIL;
>>>> +        return ret;
>>>> +    }
>>>> +
>>>> +    return 0;
>>>>
>>>> It should only set REQ_F_EARLY_FAIL if we fail
>>>> _before_ prep is called
>>>
>>> I did try both ways, fails if we just have:
>>
>> Ok, but the point is that the sendzc's ->fail doesn't
>> need to be called unless you've done ->prep first.
> 
> But it fails, not sure how else to say it.

liburing tests? Which test case? If so, it should be another
bug. REQ_F_NEED_CLEANUP is only set by opcodes, if a request is
terminated before ->prep is called, it means it never entered
any of the opdef callbacks and have never seen any of net.c
code, so there should be no REQ_F_NEED_CLEANUP, and so
io_sendrecv_fail() wouldn't try to set F_MORE. I don't know
what's wrong.


> FWIW, the current io_uring-6.9 branch has two patches on top, looks fine
> for me so far. We'll see if syzbot agrees. I'll send them out later
> today, unless I change my mind and try a different approach.
> 

-- 
Pavel Begunkov

