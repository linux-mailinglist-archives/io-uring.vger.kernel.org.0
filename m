Return-Path: <io-uring+bounces-980-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DD6487D388
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 19:27:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7D221F2302E
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 18:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94AF44EB5F;
	Fri, 15 Mar 2024 18:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1CMVgeew"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590BB4C637
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 18:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710527223; cv=none; b=uoTwCMNbkNk9m5X8uKwI9Ob5Khwq+LFI4rn92sAJt0EBUR9kb9WTKZhN4Pe2K06jEXjpSttiSwLUKJZEyW+Ub9lnmG4+PmwTyuh0WjvgAgBsgXz8CR3vRPv5Mqnm6dAv8HxF9127Tli28LfRt7KzDGRlQRvnqjIsqUPiM3Eseaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710527223; c=relaxed/simple;
	bh=FcY+VRirWnU1Ol2e0GYoMsDgxmwDeVmjIWYEaGeRtOU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qu+OBgx7ex5+DoqJ1nfjm+r3mGsd/aXmByF4bEtX0U7Qd2VJNTWHPfhO+nVh0WhfsIWyKqHPrJDWlWM3EjVzYTty/DmkZxipPX14FokJSadbdV1K6hOZBjSPASelozTascWR70/d2lp02pbJktgnQuL7uTDHmXgRqNpfdHELdfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1CMVgeew; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5a46b30857bso330851eaf.1
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 11:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710527219; x=1711132019; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=23OrLcxLDxWvP8ctyHWVIeXpKDHsE6jft/6XM7K55hY=;
        b=1CMVgeewB5BKuIJx1GeSMLIgoaXaSXOyG10jTBVaCDfA02UWWWXWm0b0hunYJS6d2d
         akpTk2f+rDLT4Yb6q5VZa3ZBS5koy0Q3akK7u/Cg+mj9d6WCYNdULwwEPs7RsH/Zc2YI
         dDcCyfbeGlyFRaP3YMqc9DVvXriuMdCChT8MKwmLGRjl7YXcur2ZTnTq+RjrdPK2Xs5I
         6nPD4a8zDgipDhYSMipvcCG3u3qeUZeXazl/2w5//+ZG1mw9xrgLeQ82nhsmomKEM636
         8WOcaTDcbbzI32x6uowBWma2Ur0DQTty9tiANyv+P4APZYbqI6fT9FExkm4543DpSN8F
         xNBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710527219; x=1711132019;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=23OrLcxLDxWvP8ctyHWVIeXpKDHsE6jft/6XM7K55hY=;
        b=aew/DpDA3JWLpHK1WthbDR/XYEbJoOgLjKmQN//uuzS8qKebUnOMHnN+HCePg05re/
         VVM7HdryQQrwf40Gt04fbE2iCsl9uA/CxCU3yIuVw7btCbtMsWn5POdyct71awotV4IU
         SsinmAiKbsNFQWRXOhicO58mTAWckIeS4MHSgGYB7J1s88Krw87TRWzeHCOm50sFJdVK
         AGlQ1/RbuLuzBB9QQL6JVJY9o8DOvVXZBzLf1c29jfv8Ihk2sZTMvTRdxM0xW7Gz8ry7
         Ndrg20+d2ZgeLGYqvunCNdhgv40plEd+614PLwqFz9WLOIc7ONDndTP/ME9kvp46+d9w
         CtAw==
X-Forwarded-Encrypted: i=1; AJvYcCWAqVzRNvjTpisb6mbDHLjw73y28dJwPHSZ1MrVH6O2Y1SSWK91rsoC7e94AuSJ2oy9TjguC1FOou8ypd01m9I9bXizwhIFf7s=
X-Gm-Message-State: AOJu0Yy99PJ0ZCmRaxutvF9kc3ca0kbHr54092sIcpTmzzSMeaKMezpx
	qtyGnsL/Vr+FFblNjULT+lA1dRwbTgaISIPEYfT6AeQFSsjTGq8jXNtOq3naH1o=
X-Google-Smtp-Source: AGHT+IE2wt3Ca0cSemGgx6ZlZKrjy2DSpcqRW3JFt5NDyyCIlmPEGKVDj3sdfJK+ECrvJuhT8PB+JQ==
X-Received: by 2002:a05:6359:458c:b0:17e:bbaf:4060 with SMTP id no12-20020a056359458c00b0017ebbaf4060mr3433889rwb.2.1710527219231;
        Fri, 15 Mar 2024 11:26:59 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id f35-20020a635563000000b005dc884e9f5bsm2768927pgm.38.2024.03.15.11.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 11:26:58 -0700 (PDT)
Message-ID: <47ab135e-af1c-4492-8807-d0bc434da253@kernel.dk>
Date: Fri, 15 Mar 2024 12:26:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] io_uring: get rid of intermediate aux cqe caches
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
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
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d82a07b8-a65d-4551-8516-5e50e0fab2fe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/24 11:26 AM, Pavel Begunkov wrote:
> On 3/15/24 16:49, Jens Axboe wrote:
>> On 3/15/24 10:44 AM, Pavel Begunkov wrote:
>>> On 3/15/24 16:27, Jens Axboe wrote:
>>>> On 3/15/24 10:25 AM, Jens Axboe wrote:
>>>>> On 3/15/24 10:23 AM, Pavel Begunkov wrote:
>>>>>> On 3/15/24 16:20, Jens Axboe wrote:
>>>>>>> On 3/15/24 9:30 AM, Pavel Begunkov wrote:
>>>>>>>> io_post_aux_cqe(), which is used for multishot requests, delays
>>>>>>>> completions by putting CQEs into a temporary array for the purpose
>>>>>>>> completion lock/flush batching.
>>>>>>>>
>>>>>>>> DEFER_TASKRUN doesn't need any locking, so for it we can put completions
>>>>>>>> directly into the CQ and defer post completion handling with a flag.
>>>>>>>> That leaves !DEFER_TASKRUN, which is not that interesting / hot for
>>>>>>>> multishot requests, so have conditional locking with deferred flush
>>>>>>>> for them.
>>>>>>>
>>>>>>> This breaks the read-mshot test case, looking into what is going on
>>>>>>> there.
>>>>>>
>>>>>> I forgot to mention, yes it does, the test makes odd assumptions about
>>>>>> overflows, IIRC it expects that the kernel allows one and only one aux
>>>>>> CQE to be overflown. Let me double check
>>>>>
>>>>> Yeah this is very possible, the overflow checking could be broken in
>>>>> there. I'll poke at it and report back.
>>>>
>>>> It does, this should fix it:
>>>>
>>>>
>>>> diff --git a/test/read-mshot.c b/test/read-mshot.c
>>>> index 8fcb79857bf0..501ca69a98dc 100644
>>>> --- a/test/read-mshot.c
>>>> +++ b/test/read-mshot.c
>>>> @@ -236,7 +236,7 @@ static int test(int first_good, int async, int overflow)
>>>>            }
>>>>            if (!(cqe->flags & IORING_CQE_F_MORE)) {
>>>>                /* we expect this on overflow */
>>>> -            if (overflow && (i - 1 == NR_OVERFLOW))
>>>> +            if (overflow && i >= NR_OVERFLOW)
>>>
>>> Which is not ideal either, e.g. I wouldn't mind if the kernel stops
>>> one entry before CQ is full, so that the request can complete w/o
>>> overflowing. Not supposing the change because it's a marginal
>>> case, but we shouldn't limit ourselves.
>>
>> But if the event keeps triggering we have to keep posting CQEs,
>> otherwise we could get stuck. 
> 
> Or we can complete the request, then the user consumes CQEs
> and restarts as usual

So you'd want to track if we'd overflow, wait for overflow to clear, and
then restart that request? I think that sounds a bit involved, no?
Particularly for a case like overflow, which generally should not occur.
If it does, just terminate it, and have the user re-issue it. That seems
like the simpler and better solution to me.

>> As far as I'm concerned, the behavior with
>> the patch looks correct. The last CQE is overflown, and that terminates
>> it, and it doesn't have MORE set. The one before that has MORE set, but
>> it has to, unless you aborted it early. But that seems impossible,
>> because what if that was indeed the last current CQE, and we reap CQEs
>> before the next one is posted.
>>
>> So unless I'm missing something, I don't think we can be doing any
>> better.
> 
> You can opportunistically try to avoid overflows, unreliably
> 
> bool io_post_cqe() {
>     // Not enough space in the CQ left, so if there is a next
>     // completion pending we'd have to overflow. Avoid that by
>     // terminating it now.
>     //
>     // If there are no more CQEs after this one, we might
>     // terminate a bit earlier, but that better because
>     // overflows are so expensive and unhandy and so on.
>     if (cq_space_left() <= 1)
>         return false;
>     fill_cqe();
>     return true;
> }
> 
> some_multishot_function(req) {
>     if (!io_post_cqe(res))
>         complete_req(req, res);
> }
> 
> Again, not suggesting the change for all the obvious reasons, but
> I think semantically we should be able to do it.

Yeah not convinced this is worth looking at. If it was the case that the
hot path would often see overflows and it'd help to avoid it, then
probably it'd make sense. But I don't think that's the case.

-- 
Jens Axboe


