Return-Path: <io-uring+bounces-1035-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C001F87DAE0
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:42:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74DE7281E96
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 527551B952;
	Sat, 16 Mar 2024 16:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="k21U10q3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22618199B4
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710607371; cv=none; b=rvOLdpTUZS6Cu9vuWOZ4FupLBu6PD8XPp27hJidcplr1ZLy/H946oaVwtDPRH9DGSkJjOu1V98uGhA6Yiq5gz3gL7REIQxO+b+m+MQMI00gvUqr3F18amBNtd1J/4QfBt9zC9O418W9ocPPTTfna/Z9wTlEDP1RgiS9VE4B9ags=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710607371; c=relaxed/simple;
	bh=vcWbxtX7ui2C9QEnUw1/cxiKxCJ8j2CdE8KkGn5X+l0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cRQ79HHcZD9dcDiLbw1oGuzWA44YgWrzzsZoWhqvFhdPctgKnEjL+YsaJKEU8oVsxEVRoYU3o5hHz8r9K32PVe+UFs1p+K/QyCkZ9hBmWZYPFweh8Hhqsag6P4x/LMusgu6nwifrb0GXlOp5GKC+7OsSaoZmczNiPoMYUNgbeSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=k21U10q3; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so879903b3a.0
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710607368; x=1711212168; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UGO5SyLY7hLJWc+mxaKiGt1WQXjxH1NVSomM7vXW0E4=;
        b=k21U10q3dLkZmyQCSK7uN0SBu8BhhO7bw80EQAybFpic6vZJsCzL+h8gBYeOwQmILg
         /VuqRrV/pPwIk994LMgW68h+vHskuENolsLldzcM2ayhrWmR+2u62sAsNz1UBofkD5mY
         EEvVLu+l7DoVQP1whTtl9ZOYDMkoRsU74s+lTTx6TmPi+8iwz0a5Jiyp7JKwiXfcwdRe
         E2um/IaT4+uucVKoHSXe9OGEnKPzX37/wYnuIybByOgtDB4oQz4PxaPtPuDOj9/OSZRk
         cGqWjDWC+cJDAM7DeNgHhzzbleM42Zx1PYt3UsXjXYMPYrC/cVaj3eJAHt8HKC58ZK4e
         2G6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710607368; x=1711212168;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UGO5SyLY7hLJWc+mxaKiGt1WQXjxH1NVSomM7vXW0E4=;
        b=MffSZF96oKGpmU57jZ3G0T4t1PH/ywTdTzox5IkemlTeRE3s9TfKtaeHljAk8Y5ML6
         kPYpisf+UXKMqDSsXltj4nr8KvSMm4VgVOXRpZEmgYg7C7yr+yGncXV5deA6sXUswASz
         PoxC1tt9vWMWeVcPtXSUBpNNzEaiB7TV+KSNh3xUtEG1WeJBD5+QnVMwFCKNx5SXrCyJ
         L/n5zlsuyYyAVHb112UiLqqwRi43AsDHL3EYaoW4Ebstf6FGmbxvLNuSSzjgRJ6Z0tCy
         Dqnii4nYVH45XpwErRW9YHuRxHyJ8epki4eO8/nhcjUrQKKSMg2dS74taor5wIM0h00D
         9v7g==
X-Forwarded-Encrypted: i=1; AJvYcCVozzJNR+2LKn+q4cTSvRlfMRVhZyzn6nDPdtrCdSQxffVmhzbxsseQJHGOi7YNVUuJ0dEImqNxbKTZIhf4dpu06K+naCPi7FU=
X-Gm-Message-State: AOJu0YyRRX/HAiU9kkw9gA8O38vJhjzmgsI/CZUJYScBOCdpJ1yXpeWt
	IHekUax6GbraKcANq+Kay7Bq+kUb2045xlYQ/9roGFqCG1pf8AIUJ7MBtIUUE591Ac9CimXU+Wu
	P
X-Google-Smtp-Source: AGHT+IFcpmuKjmYwyl/gmfe/yYVDukCwIzCGl0Dw7j3E8WD1JsjZBJXPCDL0HDFLUZ76bvGXnLffCg==
X-Received: by 2002:a05:6a21:3381:b0:1a3:5c74:62ae with SMTP id yy1-20020a056a21338100b001a35c7462aemr1185966pzb.1.1710607368332;
        Sat, 16 Mar 2024 09:42:48 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id lb15-20020a056a004f0f00b006e6b9dd81bdsm5333768pfb.99.2024.03.16.09.42.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:42:47 -0700 (PDT)
Message-ID: <0f3bc43a-7533-40b2-b9c8-615abf4f81c1@kernel.dk>
Date: Sat, 16 Mar 2024 10:42:46 -0600
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
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <30535d27-7979-4aa9-b8f7-e35eb51dedb0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/16/24 10:36 AM, Pavel Begunkov wrote:
> On 3/16/24 16:36, Jens Axboe wrote:
>> On 3/16/24 10:32 AM, Pavel Begunkov wrote:
>>> On 3/16/24 16:31, Jens Axboe wrote:
>>>> On 3/16/24 10:28 AM, Pavel Begunkov wrote:
>>>>> On 3/16/24 16:14, Jens Axboe wrote:
>>>>>> On 3/15/24 5:28 PM, Pavel Begunkov wrote:
>>>>>>> On 3/15/24 23:25, Jens Axboe wrote:
>>>>>>>> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>>>>>>>>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>>>>>>>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>>>>>>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>>>>>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>>>>>>>>> async handlers. But if we then fail setting it up and want to post
>>>>>>>>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>>>>>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>>>>>>>>> potential errors, but we need to cover the async setup too.
>>>>>>>>>>>
>>>>>>>>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>>>>>>>>> off of an early submission failure path where def->prep has
>>>>>>>>>>> not yet been called, I don't think the patch will fix the
>>>>>>>>>>> problem.
>>>>>>>>>>>
>>>>>>>>>>> ->fail() handlers are fragile, maybe we should skip them
>>>>>>>>>>> if def->prep() wasn't called. Not even compile tested:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>>>> index 846d67a9c72e..56eed1490571 100644
>>>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>>> [...]
>>>>>>>>>>>               def->fail(req);
>>>>>>>>>>>           io_req_complete_defer(req);
>>>>>>>>>>>       }
>>>>>>>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>               }
>>>>>>>>>>>               req->flags |= REQ_F_CREDS;
>>>>>>>>>>>           }
>>>>>>>>>>> -
>>>>>>>>>>> -    return def->prep(req, sqe);
>>>>>>>>>>> +    return 0;
>>>>>>>>>>>       }
>>>>>>>>>>>
>>>>>>>>>>>       static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>>>>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>           int ret;
>>>>>>>>>>>
>>>>>>>>>>>           ret = io_init_req(ctx, req, sqe);
>>>>>>>>>>> -    if (unlikely(ret))
>>>>>>>>>>> +    if (unlikely(ret)) {
>>>>>>>>>>> +fail:
>>>>>>>>>
>>>>>>>>> Obvious the diff is crap, but still bugging me enough to write
>>>>>>>>> that the label should've been one line below, otherwise we'd
>>>>>>>>> flag after ->prep as well.
>>>>>>>>
>>>>>>>> It certainly needs testing :-)
>>>>>>>>
>>>>>>>> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
>>>>>>>> and hopefully not have to worry about it again. Do you want to clean it
>>>>>>>> up, test it, and send it out?
>>>>>>>
>>>>>>> I'd rather leave it to you, I suspect it wouldn't fix the syzbot
>>>>>>> report w/o fiddling with done_io as in your patch.
>>>>>>
>>>>>> I gave this a shot, but some fail handlers do want to get called. But
>>>>>
>>>>> Which one and/or which part of it?
>>>>
>>>> send zc
>>>
>>> I don't think so. If prep wasn't called there wouldn't be
>>> a notif allocated, and so no F_MORE required. If you take
>>> at the code path it's under REQ_F_NEED_CLEANUP, which is only
>>> set by opcode handlers
>>
>> I'm not making this up, your test case will literally fail as it doesn't
>> get to flag MORE for that case. FWIW, this was done with EARLY_FAIL
>> being flagged, and failing if we fail during or before prep.
> 
> Maybe the test is too strict, but your approach is different
> from what I mentioned yesterday
> 
> -    return def->prep(req, sqe);
> +    ret = def->prep(req, sqe);
> +    if (unlikely(ret)) {
> +        req->flags |= REQ_F_EARLY_FAIL;
> +        return ret;
> +    }
> +
> +    return 0;
> 
> It should only set REQ_F_EARLY_FAIL if we fail
> _before_ prep is called

I did try both ways, fails if we just have:

	return def->prep(req, sqe);
fail:
	req->flags |= REQ_F_EARLY_FAIL;
	...

as well.

-- 
Jens Axboe


