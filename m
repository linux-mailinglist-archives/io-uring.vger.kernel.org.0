Return-Path: <io-uring+bounces-1037-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 095D587DAE5
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:51:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D4BA1C20A95
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A426414A9D;
	Sat, 16 Mar 2024 16:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BCv4CN7o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DED1BDCD
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710607875; cv=none; b=l+oPNLwKWUz9R3/2idVbahYLd/rs/xCDYC3crV3uE/tlYg7yvp18YR9w4i8JJPBQC/IMOMLxiuUR/4j4Ya9XNcMPX9oG6AEnqptVc0SE+wLyFvNUsjmGXOgKWv/AcK5AwxHPJzCGzhtMkIPRJNA2Z7g9dDoTpXRRIpkyGBzDm5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710607875; c=relaxed/simple;
	bh=ZdX0Qyq88LQZfQjwXSYabeE34KlUb50A2MDzkvxgwco=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ECmXbfzdgPqKA4g5TKB034qrCCGpTjndAdWcRpUuAvwwOTELLWa6z/NK7hdW8/Wqubh09CZIX7VXyNLQOUpM2xmjyMSrHKu2rCtXqlpQrN8DoYXXiIym2gMpnVKr5R+yGe0iB5jVjS/QVnGo1R1Hbe0Gn5lu+Gi68AIlPqLx8yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BCv4CN7o; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5d862e8b163so423015a12.1
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710607872; x=1711212672; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7atmtyA/FHREEqmH2qN6UN7tM91Jl9ZK5fIeRqN5Pq4=;
        b=BCv4CN7oGl3iO6u17PmvoqfODH7ynjN/+6YdEAncS33G24tARIW0nwIs4BIg0dpwS/
         PXk5Lw7NZ2zkfYCrjPiBxvf5GW37qkvqYFRHNbgda2GTceETYLQAdIvRt2iQxFlQ9TWP
         Jm8Dhq4Ul1tyok9hRjf5KwSWezXEHoVgKpnW5N4kMXrSKYEnpUeHSG+AdmZUKJ8Dk5kW
         jWooXv/pRIsqSlaXONheMWhwbeMGmBc1R88G1XH9dQeQYyTgk9gov+Cgc1wLf9uf98Uk
         W2Um48f2wv9EpTvXZLsjklfLeAVZvdy8mXHr0ZREm69SMNfJ3ZOXUbiaP/hGobzetGl2
         NXOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710607872; x=1711212672;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7atmtyA/FHREEqmH2qN6UN7tM91Jl9ZK5fIeRqN5Pq4=;
        b=d50VGoqnNWv4wn9gWPxxY57rJpSLikGjeyWLgwrOsHibZnn5Scn+B8+iM3fjz8owGA
         gaHE+NaonupARzfTbq14ZWTG4gid3YBzp9Dzpb5pttxKj29dj1DicUCqIbxfD2TtMiAs
         7tVPxGhxSZ3zV9JGhQZZeEx2Y1ApUsK4QB/BhrKrFZvnrG3qkRxW5Qj7eveKB2xbT5DL
         owzSnwxYJ4nN5zN5NYWCIwZjYZKJAkKVQKXvP3eh2fnBp0bBOjsxkQGCMKZ33yZ18r5/
         fIWvdNvnH5ezlzrM53BVCZ14betxJSwdr+ZPM2dZBiFAJ7FktJyTtzj3fhzoeHTTS7Jh
         MA9w==
X-Forwarded-Encrypted: i=1; AJvYcCU/e/xiUXasLyZoXn+zkWEe7dXBv4HomrAdYEwf8N5NNAEnS7rGaStIkQ7YEc7+utMJ/USti5CAtxYwx5QctIPnmqLbcbj7cuc=
X-Gm-Message-State: AOJu0Yzc30uyYcFSTpJP7Bza+1yOsWx7W/XxeT/0rI4PdGvrW+OMMh81
	dy7B/KQGLgIa/YaDt2LTb1bXeIBa9Plz5W2pZ4tVxcQ2iLqoAA6B8xvw90Bmxgs=
X-Google-Smtp-Source: AGHT+IH742GePJxLlWVHq0hbHTWt6CM4OMy49+krKep+SYhDTDBmlgH6Cqg/A+DbpnzJNPoSbtGCJQ==
X-Received: by 2002:a05:6a21:670f:b0:1a1:3d79:82 with SMTP id wh15-20020a056a21670f00b001a13d790082mr8252854pzb.0.1710607872416;
        Sat, 16 Mar 2024 09:51:12 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id m9-20020a17090a34c900b0029bc1c931d9sm5210865pjf.51.2024.03.16.09.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:51:11 -0700 (PDT)
Message-ID: <a7d4d0d6-1b0f-4618-8c87-b831e653993c@kernel.dk>
Date: Sat, 16 Mar 2024 10:51:10 -0600
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
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <34586d43-2553-402e-b53b-a34b51c8f550@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/16/24 10:46 AM, Pavel Begunkov wrote:
> On 3/16/24 16:42, Jens Axboe wrote:
>> On 3/16/24 10:36 AM, Pavel Begunkov wrote:
>>> On 3/16/24 16:36, Jens Axboe wrote:
>>>> On 3/16/24 10:32 AM, Pavel Begunkov wrote:
>>>>> On 3/16/24 16:31, Jens Axboe wrote:
>>>>>> On 3/16/24 10:28 AM, Pavel Begunkov wrote:
>>>>>>> On 3/16/24 16:14, Jens Axboe wrote:
>>>>>>>> On 3/15/24 5:28 PM, Pavel Begunkov wrote:
>>>>>>>>> On 3/15/24 23:25, Jens Axboe wrote:
>>>>>>>>>> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>>>>>>>>>>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>>>>>>>>>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>>>>>>>>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>>>>>>>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>>>>>>>>>>> async handlers. But if we then fail setting it up and want to post
>>>>>>>>>>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>>>>>>>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>>>>>>>>>>> potential errors, but we need to cover the async setup too.
>>>>>>>>>>>>>
>>>>>>>>>>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>>>>>>>>>>> off of an early submission failure path where def->prep has
>>>>>>>>>>>>> not yet been called, I don't think the patch will fix the
>>>>>>>>>>>>> problem.
>>>>>>>>>>>>>
>>>>>>>>>>>>> ->fail() handlers are fragile, maybe we should skip them
>>>>>>>>>>>>> if def->prep() wasn't called. Not even compile tested:
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>>>>>> index 846d67a9c72e..56eed1490571 100644
>>>>>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>>>>> [...]
>>>>>>>>>>>>>                def->fail(req);
>>>>>>>>>>>>>            io_req_complete_defer(req);
>>>>>>>>>>>>>        }
>>>>>>>>>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>>>                }
>>>>>>>>>>>>>                req->flags |= REQ_F_CREDS;
>>>>>>>>>>>>>            }
>>>>>>>>>>>>> -
>>>>>>>>>>>>> -    return def->prep(req, sqe);
>>>>>>>>>>>>> +    return 0;
>>>>>>>>>>>>>        }
>>>>>>>>>>>>>
>>>>>>>>>>>>>        static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>>>>>>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>>>            int ret;
>>>>>>>>>>>>>
>>>>>>>>>>>>>            ret = io_init_req(ctx, req, sqe);
>>>>>>>>>>>>> -    if (unlikely(ret))
>>>>>>>>>>>>> +    if (unlikely(ret)) {
>>>>>>>>>>>>> +fail:
>>>>>>>>>>>
>>>>>>>>>>> Obvious the diff is crap, but still bugging me enough to write
>>>>>>>>>>> that the label should've been one line below, otherwise we'd
>>>>>>>>>>> flag after ->prep as well.
>>>>>>>>>>
>>>>>>>>>> It certainly needs testing :-)
>>>>>>>>>>
>>>>>>>>>> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
>>>>>>>>>> and hopefully not have to worry about it again. Do you want to clean it
>>>>>>>>>> up, test it, and send it out?
>>>>>>>>>
>>>>>>>>> I'd rather leave it to you, I suspect it wouldn't fix the syzbot
>>>>>>>>> report w/o fiddling with done_io as in your patch.
>>>>>>>>
>>>>>>>> I gave this a shot, but some fail handlers do want to get called. But
>>>>>>>
>>>>>>> Which one and/or which part of it?
>>>>>>
>>>>>> send zc
>>>>>
>>>>> I don't think so. If prep wasn't called there wouldn't be
>>>>> a notif allocated, and so no F_MORE required. If you take
>>>>> at the code path it's under REQ_F_NEED_CLEANUP, which is only
>>>>> set by opcode handlers
>>>>
>>>> I'm not making this up, your test case will literally fail as it doesn't
>>>> get to flag MORE for that case. FWIW, this was done with EARLY_FAIL
>>>> being flagged, and failing if we fail during or before prep.
>>>
>>> Maybe the test is too strict, but your approach is different
>>> from what I mentioned yesterday
>>>
>>> -    return def->prep(req, sqe);
>>> +    ret = def->prep(req, sqe);
>>> +    if (unlikely(ret)) {
>>> +        req->flags |= REQ_F_EARLY_FAIL;
>>> +        return ret;
>>> +    }
>>> +
>>> +    return 0;
>>>
>>> It should only set REQ_F_EARLY_FAIL if we fail
>>> _before_ prep is called
>>
>> I did try both ways, fails if we just have:
> 
> Ok, but the point is that the sendzc's ->fail doesn't
> need to be called unless you've done ->prep first.

But it fails, not sure how else to say it.

FWIW, the current io_uring-6.9 branch has two patches on top, looks fine
for me so far. We'll see if syzbot agrees. I'll send them out later
today, unless I change my mind and try a different approach.

-- 
Jens Axboe


