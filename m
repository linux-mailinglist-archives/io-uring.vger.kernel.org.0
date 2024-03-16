Return-Path: <io-uring+bounces-1034-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8020C87DADF
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:42:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E978281D5E
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD43D17543;
	Sat, 16 Mar 2024 16:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKQ8ySJl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21C61BC23
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710607339; cv=none; b=QLnXQ6isH5cgQ+XpR9bkdzVNhEstZljOGw/vJvBLh+8Gz1mk0hmAfnvDC4WG4yiUuA4fHl3eoKxxqhoMMaUeRgYgB3Gi69eT99lak382lP39RgvStm0VcZ3UQ4QcvosRTBz37ZjmXqJ4JExrAUrA80j4ksVs7Hg6+wzD28H1PVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710607339; c=relaxed/simple;
	bh=/jq/jzBj28/RKm63QAwG8atr1j7KuxUmtg7lr6FEDkQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=XttjVaSkMnO+wNGQ12Nj/myS3Z5YXiv/nXVK85x7fPWHUvUn7SeFRQDtGfWaFaW1H7LwgYn3IZ7uhVuAWhbRLCM0jvK6KO/YjJyswl/RCNnrw4auU6AqWsOcB9V/LEUrD0cY142lAYMLbDmX6vlzpehnroCrWpfZjY7QZW6bOfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EKQ8ySJl; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4140844fc85so3904315e9.2
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710607336; x=1711212136; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2NhJGGUlAe4L+VhIS0kXSNo8uH5yqWL1rgmJMfXNeK0=;
        b=EKQ8ySJldRL9gvFhBMllCdBFILfYUU/wymqWbqwtvRIplgVGWWbwZwXYQaB0O8GFSv
         Ud7Nm+ugnFX1T34+dCiYmtGbFVDpCfznzaUARtLI1At5jGgYI9B3YNo/zyfykUXtO/i9
         eEZt5uJ/b3jYf+rHb2Cp9gGDXNSx1gQxGiFI+4JHgPSseyU5ptTTL19mul5etEBLEo+G
         wloNZLlKzLU3+/ALJo1TPK4z4xRwuvkrRWuzbpR+7M7985HSGO8RZtTutx6/3k5cp5o+
         J28WQoMmLx37BLoEuW5hKy3mtd/lmBiciiG76VqHKbkvtwXc4RP00583180wFk9Ex2dk
         yVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710607336; x=1711212136;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2NhJGGUlAe4L+VhIS0kXSNo8uH5yqWL1rgmJMfXNeK0=;
        b=c9oHsZk3xBroevYKu0PHp5RlwoaBtM2KVNVueiwSnJqpef1fRvIihAHwkIcS+eTFo7
         4vXBPGtx31iDe3wYKJWkRIUfrrB5FNp+c8sSRthFCsHQq9u9nhufIuzLl6W0AkHxWcOv
         umw259WsVjeM5pWNdlEXvwC/wWw+57gGYgIbNKc4a2akieiw/cAt1AMr+9i8ofYowZzE
         rmDgEKvuOAA0fj5LQ0CFvxLOnrlZSBnhD0HOqgU0Vq8pOg7WmTuBrjd3fPbGHrBoesNN
         0lPSHHDv6tqX0cglgCwtx18Frb+/Eb2e/RSmr0YUju+EFQUsvYeL3PVEF8z2r8d0kCnb
         gJSw==
X-Forwarded-Encrypted: i=1; AJvYcCUjBV2dlLgQ9PqSkxada2SY43BH+tQNmM/Ovi9qzXSS2l1MbGAPVJzInh+jtdpYQBIDp3nCCg+En+r9ok+P9wHlP8m26PsKhPk=
X-Gm-Message-State: AOJu0YyNClA0yPBfFC5H4Na6ob/Py8gJyaJQvpdDD2CW5D/JZixwvjn4
	Q0aVELFTXaxtCrNzaHXaUsDIGgORDcs2zfgkEVV1yrKme0cwAvv2
X-Google-Smtp-Source: AGHT+IFbmrlzdY+qka/sXTe51va82T0CkFDYewnr7iYISW8Xel3xWz5Rpp3q5SDF4CI2OXaDTM231g==
X-Received: by 2002:a05:600c:b86:b0:414:a6e:219e with SMTP id fl6-20020a05600c0b8600b004140a6e219emr248969wmb.8.1710607335894;
        Sat, 16 Mar 2024 09:42:15 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id t14-20020a05600c450e00b0041409db0349sm1055777wmo.48.2024.03.16.09.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:42:15 -0700 (PDT)
Message-ID: <f5be514e-4298-470a-a0af-200fef5caaad@gmail.com>
Date: Sat, 16 Mar 2024 16:40:17 +0000
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
 <0224b8e1-9692-4682-8b15-16a1d422c8b2@kernel.dk>
 <30535d27-7979-4aa9-b8f7-e35eb51dedb0@gmail.com>
In-Reply-To: <30535d27-7979-4aa9-b8f7-e35eb51dedb0@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/16/24 16:36, Pavel Begunkov wrote:
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
>>>>>>>>>>>               def->fail(req);
>>>>>>>>>>>           io_req_complete_defer(req);
>>>>>>>>>>>       }
>>>>>>>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>               }
>>>>>>>>>>>               req->flags |= REQ_F_CREDS;
>>>>>>>>>>>           }
>>>>>>>>>>> -
>>>>>>>>>>> -    return def->prep(req, sqe);
>>>>>>>>>>> +    return 0;
>>>>>>>>>>>       }
>>>>>>>>>>>
>>>>>>>>>>>       static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>>>>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>           int ret;
>>>>>>>>>>>
>>>>>>>>>>>           ret = io_init_req(ctx, req, sqe);
>>>>>>>>>>> -    if (unlikely(ret))
>>>>>>>>>>> +    if (unlikely(ret)) {
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
> -    return def->prep(req, sqe);
> +    ret = def->prep(req, sqe);
> +    if (unlikely(ret)) {
> +        req->flags |= REQ_F_EARLY_FAIL;
> +        return ret;
> +    }
> +
> +    return 0;
> 
> It should only set REQ_F_EARLY_FAIL if we fail
> _before_ prep is called

We can't post a notif unless we allocated it, which couldn't
possibly happen without ->prep being called fist.

Let's better call it UNPREPPED_FAIL or somehow more meaningfully,
I expect a lot of confusion around "EARLY_FAIL"

-- 
Pavel Begunkov

