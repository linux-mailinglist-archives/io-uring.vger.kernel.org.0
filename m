Return-Path: <io-uring+bounces-1047-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAA8887DC09
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 00:58:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 034911C20A1F
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 23:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 247E736AE3;
	Sat, 16 Mar 2024 23:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2iY2PrlN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9854B1BC40
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 23:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710633512; cv=none; b=JWUR67dLMMw8pRawfzM1r///4nvgY36BU+9kVEdF0xvuHt3cS4WgaOyMJLNGhMN5JlCzTv4FpjUFpg2hZjTWVryQYPH4h8H8SA672ot+M9r/guZMXuIhiKJ6UCaY+rBGhf3C0gulYPJNoct1KhuKRaNDsBNU7DBg/0tjI5jxCi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710633512; c=relaxed/simple;
	bh=axOeEoN9a9RrMwTLieQRxZCHh6AefNI5rouhWjDSfvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NyrBoDz+KXkiU7zXZgAz3dyyNBpWaGIDGTe9LpOUg9VYuAmjk3lUYYUnyOBTn1K0T5ntumiyGRzOyuzSf+Myz2YVaf7IWAPH8SFcsNuFLI3onzhbKxqRIhwwshEhW+r5E2AjlqUYsV4aAj2VOueAWHykQ/ukocuwt/1E35w0pJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2iY2PrlN; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e6c9f6e654so742089b3a.0
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710633507; x=1711238307; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DcFFRCUfpKN9VA918ZqCS8KrYqMl6D7pHdHpPv1EArU=;
        b=2iY2PrlNgdP4+EDT3TqzOKr2QuEAJdXrm4cMR7kq9xksSeTSl3RnJX3IPWrkWv8WQx
         XeZ6MW81up1G/ZLPgJERhMIKpEu40u8cB6TZ5sK2dA9Uc6cd4W8DNBDtBxBmjNEGcU/B
         dhZG8cjSgvqFqV1Zp7G1rSu0Wo4b3iMlj+CNyeHDpAbKY7UfO/eC0EcctGLBPaeXd0Jy
         QVsj0e1J7XyRFhqOJayL/raApyrD2TPvkhjBiqdFhpjhSnnBDsMDLzugmz407pgEtEzE
         zVJ8JrviEXVsPIdmz7AydTQD8pspj+6xMnax68RNaedIWrcam+dBHesPCFO9veh+WmKf
         0D3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710633507; x=1711238307;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DcFFRCUfpKN9VA918ZqCS8KrYqMl6D7pHdHpPv1EArU=;
        b=pStMR15qNSRiq0654cF+TCLhLkuJp9EiHoYgCgt6lJ4Jh0vpM6ge9AIAyHqfbODFeo
         QT1z/7Z9jDk0a1cEzZCw3JkbWCUIxJ9Ij7d3zZv9JnhnEsMhnhCJqBw+Yu1gnqhjP347
         x3Shr1WJEewS2cUjeTV7htw616oLqWhn/3mTIw+OahMdm7dlKY2H0fyGEys6UROeB7DN
         CGEcYidoxfDz5UtllLt+e93VDy9P6ZkzeazmmiDZxNKhgxQDUTGgKXDzplUEqvnXWeDX
         t3CINBbp3TtUsZ69K3F3F6mpcw3sgQa1zOFBXZ41z2/b594fg0WP4FpXnuADidynCMN7
         kbBg==
X-Forwarded-Encrypted: i=1; AJvYcCVfQ0ddi8TBrVouiCEdwh0eBddW1T6fDFb/ZkXrgpzXKFQHfoxA8HcbPMcxJ20ELp62YIfMc6jzg5uop2yrZP6IVxYgEC5YRb8=
X-Gm-Message-State: AOJu0YxKN1AV3gVcbOI2ddFGwK2P1L1QYYLekC7Xel0NdXMTzPr00+4q
	UcyqP21i1DzG2pnH/BAsyIwZjTq8VVbFFIYx4qPDVuWKHw2Un8aaZjtXr77Jl/sM21F9WlE65/i
	D
X-Google-Smtp-Source: AGHT+IGmUdhLNpcCs4zKdx65xrWBzG9FNrP1BduTmKcPD515p1F0jQo1rFeACWljCbaAw/4GcNyCoA==
X-Received: by 2002:a17:902:ce91:b0:1dc:df03:ad86 with SMTP id f17-20020a170902ce9100b001dcdf03ad86mr8714745plg.2.1710633506544;
        Sat, 16 Mar 2024 16:58:26 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902e34300b001dca3a65200sm6371708plc.228.2024.03.16.16.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 16:58:25 -0700 (PDT)
Message-ID: <8487b07e-6510-409e-8939-0908cc1930d7@kernel.dk>
Date: Sat, 16 Mar 2024 17:58:24 -0600
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
 <c2e551c2-446e-4f83-89b2-ccdfa6438ce0@kernel.dk>
 <d344ee99-365d-40da-ba29-ecb953364e2b@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d344ee99-365d-40da-ba29-ecb953364e2b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/16/24 11:42 AM, Pavel Begunkov wrote:
> On 3/16/24 17:01, Jens Axboe wrote:
>> On 3/16/24 10:57 AM, Pavel Begunkov wrote:
>>> On 3/16/24 16:51, Jens Axboe wrote:
>>>> On 3/16/24 10:46 AM, Pavel Begunkov wrote:
>>>>> On 3/16/24 16:42, Jens Axboe wrote:
>>>>>> On 3/16/24 10:36 AM, Pavel Begunkov wrote:
>>>>>>> On 3/16/24 16:36, Jens Axboe wrote:
>>>>>>>> On 3/16/24 10:32 AM, Pavel Begunkov wrote:
>>>>>>>>> On 3/16/24 16:31, Jens Axboe wrote:
>>>>>>>>>> On 3/16/24 10:28 AM, Pavel Begunkov wrote:
>>>>>>>>>>> On 3/16/24 16:14, Jens Axboe wrote:
>>>>>>>>>>>> On 3/15/24 5:28 PM, Pavel Begunkov wrote:
>>>>>>>>>>>>> On 3/15/24 23:25, Jens Axboe wrote:
>>>>>>>>>>>>>> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>>>>>>>>>>>>>>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>>>>>>>>>>>>>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>>>>>>>>>>>>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>>>>>>>>>>>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>>>>>>>>>>>>>>> async handlers. But if we then fail setting it up and want to post
>>>>>>>>>>>>>>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>>>>>>>>>>>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>>>>>>>>>>>>>>> potential errors, but we need to cover the async setup too.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>>>>>>>>>>>>>>> off of an early submission failure path where def->prep has
>>>>>>>>>>>>>>>>> not yet been called, I don't think the patch will fix the
>>>>>>>>>>>>>>>>> problem.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> ->fail() handlers are fragile, maybe we should skip them
>>>>>>>>>>>>>>>>> if def->prep() wasn't called. Not even compile tested:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>>>>>>>>>> index 846d67a9c72e..56eed1490571 100644
>>>>>>>>>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>>>>>>>>> [...]
>>>>>>>>>>>>>>>>>                  def->fail(req);
>>>>>>>>>>>>>>>>>              io_req_complete_defer(req);
>>>>>>>>>>>>>>>>>          }
>>>>>>>>>>>>>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>>>>>>>                  }
>>>>>>>>>>>>>>>>>                  req->flags |= REQ_F_CREDS;
>>>>>>>>>>>>>>>>>              }
>>>>>>>>>>>>>>>>> -
>>>>>>>>>>>>>>>>> -    return def->prep(req, sqe);
>>>>>>>>>>>>>>>>> +    return 0;
>>>>>>>>>>>>>>>>>          }
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>          static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>>>>>>>>>>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>>>>>>>              int ret;
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>              ret = io_init_req(ctx, req, sqe);
>>>>>>>>>>>>>>>>> -    if (unlikely(ret))
>>>>>>>>>>>>>>>>> +    if (unlikely(ret)) {
>>>>>>>>>>>>>>>>> +fail:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Obvious the diff is crap, but still bugging me enough to write
>>>>>>>>>>>>>>> that the label should've been one line below, otherwise we'd
>>>>>>>>>>>>>>> flag after ->prep as well.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> It certainly needs testing :-)
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
>>>>>>>>>>>>>> and hopefully not have to worry about it again. Do you want to clean it
>>>>>>>>>>>>>> up, test it, and send it out?
>>>>>>>>>>>>>
>>>>>>>>>>>>> I'd rather leave it to you, I suspect it wouldn't fix the syzbot
>>>>>>>>>>>>> report w/o fiddling with done_io as in your patch.
>>>>>>>>>>>>
>>>>>>>>>>>> I gave this a shot, but some fail handlers do want to get called. But
>>>>>>>>>>>
>>>>>>>>>>> Which one and/or which part of it?
>>>>>>>>>>
>>>>>>>>>> send zc
>>>>>>>>>
>>>>>>>>> I don't think so. If prep wasn't called there wouldn't be
>>>>>>>>> a notif allocated, and so no F_MORE required. If you take
>>>>>>>>> at the code path it's under REQ_F_NEED_CLEANUP, which is only
>>>>>>>>> set by opcode handlers
>>>>>>>>
>>>>>>>> I'm not making this up, your test case will literally fail as it doesn't
>>>>>>>> get to flag MORE for that case. FWIW, this was done with EARLY_FAIL
>>>>>>>> being flagged, and failing if we fail during or before prep.
>>>>>>>
>>>>>>> Maybe the test is too strict, but your approach is different
>>>>>>> from what I mentioned yesterday
>>>>>>>
>>>>>>> -    return def->prep(req, sqe);
>>>>>>> +    ret = def->prep(req, sqe);
>>>>>>> +    if (unlikely(ret)) {
>>>>>>> +        req->flags |= REQ_F_EARLY_FAIL;
>>>>>>> +        return ret;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    return 0;
>>>>>>>
>>>>>>> It should only set REQ_F_EARLY_FAIL if we fail
>>>>>>> _before_ prep is called
>>>>>>
>>>>>> I did try both ways, fails if we just have:
>>>>>
>>>>> Ok, but the point is that the sendzc's ->fail doesn't
>>>>> need to be called unless you've done ->prep first.
>>>>
>>>> But it fails, not sure how else to say it.
>>>
>>> liburing tests? Which test case? If so, it should be another
>>
>> Like I mentioned earlier, it's send zc and it's failing the test case
>> for that. test/send-zerocopy.t.
>>
>>> bug. REQ_F_NEED_CLEANUP is only set by opcodes, if a request is
>>> terminated before ->prep is called, it means it never entered
>>> any of the opdef callbacks and have never seen any of net.c
>>> code, so there should be no REQ_F_NEED_CLEANUP, and so
>>> io_sendrecv_fail() wouldn't try to set F_MORE. I don't know
>>> what's wrong.
>>
>> Feel free to take a look! I do like the simplicity of the early error
>> flag.
> 
> ./send-zerocopy.t works fine

Huh, I wonder what I messed up. But:

> @@ -2250,7 +2249,13 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>      int ret;
>  
>      ret = io_init_req(ctx, req, sqe);
> -    if (unlikely(ret))
> +    if (unlikely(ret)) {
> +        req->flags |= REQ_F_UNPREPPED_FAIL;
> +        return io_submit_fail_init(sqe, req, ret);
> +    }
> +
> +    ret = def->prep(req, sqe);
> +    if (ret)
>          return io_submit_fail_init(sqe, req, ret);

this obviously won't compile, assuming this is not the one you ran.

In any case, I do like the one I sent out for review. It moves all the
slow path out of line and shrinks things nicely too. And clearing the
cmd.data area seems like a good idea for that case.

-- 
Jens Axboe


