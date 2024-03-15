Return-Path: <io-uring+bounces-982-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C40487D423
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 19:53:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F2C1B25305
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 18:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56BAD43AC5;
	Fri, 15 Mar 2024 18:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EXAqqb2J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661AF524CE;
	Fri, 15 Mar 2024 18:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710528753; cv=none; b=E08fInpGP5q/PgKIURzDbYcvtT9NnRi4oviA79Mg1EirUNbRaMQ6DEKJatsXSzOjAYWFsztA4xbHMo8yYK2UKTKubZGPyowx3B+QgsTVrJtquwC53GAVc01Uemdd/uIde52aF+uheYRJZWqoM9pjVYWOCVI/Ri49aiU7MbKa/SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710528753; c=relaxed/simple;
	bh=wlgT7OHFo5SMViIN2+LKA8R6ViWJyIVi9DvS7s/wYzE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GX44yz2g7oUIhDYWpDHBTQ8qPOZPhmufyogH1zVYCJE2ouI90PrFxEScq9yKXrvHzm7h4TmpxoYPeDpI5osmEf2Em5ab/ZkPw1zOPC4191RD/hpfZc8Vhr9MoR/0/D83Q0hqQ1QjK9r+uHioZ7jtw6BQtYNvN0kzvIUg4GjWEBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EXAqqb2J; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-568a9c331a3so1719528a12.0;
        Fri, 15 Mar 2024 11:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710528750; x=1711133550; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H7U4AVDV5A/9CNFi9pg0paklwB/t3MJh/RUYn1bsR7c=;
        b=EXAqqb2JG4Y8woy2EdSJsP8GpFTF+7t8pZT/k88ZyxQdEvw1KrJ3yqD1tAwrsS50LW
         Lvn+x5KAUDpUw4Sh22pxPm14/4OQHsY7nDBOlAOrKdJrvzCWgryQRxELNWVzMC4mYoiZ
         qbYQzu2wZ42wqiasf/pMM66BYCQDRWtXiO4IA8x4KdCcErmbMfzMrg4hNmP0sAa6wUtE
         jnGRjZqIFnDuz89rqKPZ9kogeqM/8p8r2zx7w1UFMa6HlIZLA57+QzbOvhVrTakOYnwF
         Nfk24zA523tA3BZJUAIiPRdi1J7GKJPhCL9Jx6osjP+TZbLKBEP+68I2GW3gnGBEqtHK
         CfHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710528750; x=1711133550;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H7U4AVDV5A/9CNFi9pg0paklwB/t3MJh/RUYn1bsR7c=;
        b=S/izmzylOZZGe9lGecBM3+ciCILLyfORHqY7lG3AprIfx+8MIxKUI3n6GQkOpnOrEi
         6MrFLPTNLXGZwF+muELeOZ0GVRwZrBYMlmqMsMrXyeTMLvZltOPS8kPlwaHiRlgdFXy3
         C4pOpbhbo36m8ayDyPxssgTq9W7hEJSkJ/zIT3a0OXoV1KOhgoSvp8kCGJLBDTJCbGFP
         R/wkt00RZM7k0pkWNI83VGYZDlqvg2ebm5y/tinXyDzkw3k4SFUwKRYq+2LGceYbq2y/
         85ulsadB6E9Gx2/srEDQ96p1DOxZIHj1jbkkcMDmIEKly1g1MnS8fDplRmZkundbvI7G
         Ms+A==
X-Forwarded-Encrypted: i=1; AJvYcCUQoSoO2mo4C+cdybAGEJB1BjiUYm9/d67D6hFk2H5plLIb9c6ltnH7ZlSdmM7elUsN/PYCl50av+5atxsb/dgNCRKvcCYmkLw=
X-Gm-Message-State: AOJu0YwIlvyvRpEXMak+QlWMISMfAqn/rXeTG6TxtIh80++3Z16Pyfj4
	l5qYP1tRGtgSGKEiIhZ5Ymamxpz4Sb/vBDKSqMEeBj+rsVu9as6f
X-Google-Smtp-Source: AGHT+IEMlnLq/5qQ4NjyZpFxHt2ZGc2GQxfTzcvVK9pQeyYymJpRd5FVxGW0K1yarNwywD+B67U4pA==
X-Received: by 2002:a17:907:20e4:b0:a44:7ad0:8069 with SMTP id rh4-20020a17090720e400b00a447ad08069mr3351823ejb.72.1710528749584;
        Fri, 15 Mar 2024 11:52:29 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id ho16-20020a1709070e9000b00a4672fb2a03sm1812667ejc.10.2024.03.15.11.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 11:52:29 -0700 (PDT)
Message-ID: <e3e3496b-244c-4fb9-ab37-a032b178b485@gmail.com>
Date: Fri, 15 Mar 2024 18:51:24 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] io_uring: get rid of intermediate aux cqe caches
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
 Ming Lei <ming.lei@redhat.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <0eb3f55722540a11b036d3c90771220eb082d65e.1710514702.git.asml.silence@gmail.com>
 <6e5d55a8-1860-468f-97f4-0bd355be369a@kernel.dk>
 <7a6b4d7f-8bbd-4259-b1f1-e026b5183350@gmail.com>
 <70e18e4c-6722-475d-818b-dc739d67f7e7@kernel.dk>
 <dfdfcafe-199f-4652-9e79-7fb0e7b2ab4f@kernel.dk>
 <e40448f1-11b4-41a8-81ab-11b4ffc1b717@gmail.com>
 <0f164d26-e4da-4e96-b413-ec66cf16e3d7@kernel.dk>
 <d82a07b8-a65d-4551-8516-5e50e0fab2fe@gmail.com>
 <47ab135e-af1c-4492-8807-d0bc434da253@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <47ab135e-af1c-4492-8807-d0bc434da253@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/24 18:26, Jens Axboe wrote:
> On 3/15/24 11:26 AM, Pavel Begunkov wrote:
>> On 3/15/24 16:49, Jens Axboe wrote:
>>> On 3/15/24 10:44 AM, Pavel Begunkov wrote:
>>>> On 3/15/24 16:27, Jens Axboe wrote:
>>>>> On 3/15/24 10:25 AM, Jens Axboe wrote:
>>>>>> On 3/15/24 10:23 AM, Pavel Begunkov wrote:
>>>>>>> On 3/15/24 16:20, Jens Axboe wrote:
>>>>>>>> On 3/15/24 9:30 AM, Pavel Begunkov wrote:
>>>>>>>>> io_post_aux_cqe(), which is used for multishot requests, delays
>>>>>>>>> completions by putting CQEs into a temporary array for the purpose
>>>>>>>>> completion lock/flush batching.
>>>>>>>>>
>>>>>>>>> DEFER_TASKRUN doesn't need any locking, so for it we can put completions
>>>>>>>>> directly into the CQ and defer post completion handling with a flag.
>>>>>>>>> That leaves !DEFER_TASKRUN, which is not that interesting / hot for
>>>>>>>>> multishot requests, so have conditional locking with deferred flush
>>>>>>>>> for them.
>>>>>>>>
>>>>>>>> This breaks the read-mshot test case, looking into what is going on
>>>>>>>> there.
>>>>>>>
>>>>>>> I forgot to mention, yes it does, the test makes odd assumptions about
>>>>>>> overflows, IIRC it expects that the kernel allows one and only one aux
>>>>>>> CQE to be overflown. Let me double check
>>>>>>
>>>>>> Yeah this is very possible, the overflow checking could be broken in
>>>>>> there. I'll poke at it and report back.
>>>>>
>>>>> It does, this should fix it:
>>>>>
>>>>>
>>>>> diff --git a/test/read-mshot.c b/test/read-mshot.c
>>>>> index 8fcb79857bf0..501ca69a98dc 100644
>>>>> --- a/test/read-mshot.c
>>>>> +++ b/test/read-mshot.c
>>>>> @@ -236,7 +236,7 @@ static int test(int first_good, int async, int overflow)
>>>>>             }
>>>>>             if (!(cqe->flags & IORING_CQE_F_MORE)) {
>>>>>                 /* we expect this on overflow */
>>>>> -            if (overflow && (i - 1 == NR_OVERFLOW))
>>>>> +            if (overflow && i >= NR_OVERFLOW)
>>>>
>>>> Which is not ideal either, e.g. I wouldn't mind if the kernel stops
>>>> one entry before CQ is full, so that the request can complete w/o
>>>> overflowing. Not supposing the change because it's a marginal
>>>> case, but we shouldn't limit ourselves.
>>>
>>> But if the event keeps triggering we have to keep posting CQEs,
>>> otherwise we could get stuck.
>>
>> Or we can complete the request, then the user consumes CQEs
>> and restarts as usual
> 
> So you'd want to track if we'd overflow, wait for overflow to clear, and
> then restart that request?

No, the 2 line change in io_post_cqe() from the last email's
snippet is the only thing you'd need.

I probably don't understand why and what tracking you mean, but
fwiw we currently do track and account for overflows.


/* For defered completions this is not as strict as it is otherwise,
  * however it's main job is to prevent unbounded posted completions,
  * and in that it works just as well.
  */
if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq))
	return false;


which is being killed in the series.

> I think that sounds a bit involved, no?
> Particularly for a case like overflow, which generally should not occur.
> If it does, just terminate it, and have the user re-issue it. That seems
> like the simpler and better solution to me.
> 
>>> As far as I'm concerned, the behavior with
>>> the patch looks correct. The last CQE is overflown, and that terminates
>>> it, and it doesn't have MORE set. The one before that has MORE set, but
>>> it has to, unless you aborted it early. But that seems impossible,
>>> because what if that was indeed the last current CQE, and we reap CQEs
>>> before the next one is posted.
>>>
>>> So unless I'm missing something, I don't think we can be doing any
>>> better.
>>
>> You can opportunistically try to avoid overflows, unreliably
>>
>> bool io_post_cqe() {
>>      // Not enough space in the CQ left, so if there is a next
>>      // completion pending we'd have to overflow. Avoid that by
>>      // terminating it now.
>>      //
>>      // If there are no more CQEs after this one, we might
>>      // terminate a bit earlier, but that better because
>>      // overflows are so expensive and unhandy and so on.
>>      if (cq_space_left() <= 1)
>>          return false;
>>      fill_cqe();
>>      return true;
>> }
>>
>> some_multishot_function(req) {
>>      if (!io_post_cqe(res))
>>          complete_req(req, res);
>> }
>>
>> Again, not suggesting the change for all the obvious reasons, but
>> I think semantically we should be able to do it.
> 
> Yeah not convinced this is worth looking at. If it was the case that the
> hot path would often see overflows and it'd help to avoid it, then
> probably it'd make sense. But I don't think that's the case.

We're talking about different things. Seems you're discussing a
particular implementation, its constraints and performance. I care
purely about the semantics, the implicit uapi. And I define it as
"multishot requests may decide to terminate at any point, the user
should expect it and reissue when appropriate", not restricting it
to "can only (normally) terminate when CQ is full".

We're changing tests from time to time, but the there is that
"behaviour defines semantics", especially when it wasn't clear
in advance and breaks someone's app, and people might be using
assumptions in tests as the universal truth.

-- 
Pavel Begunkov

