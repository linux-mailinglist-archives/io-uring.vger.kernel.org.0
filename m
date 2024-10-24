Return-Path: <io-uring+bounces-4014-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 036FF9AF526
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 00:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B3641F22ACB
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 22:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E4C217320;
	Thu, 24 Oct 2024 22:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R+WXq7D7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D372178F2
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 22:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729808039; cv=none; b=GD4tZeKHG7Ma6UguPnU/NsUX5K2xdQ4hrKK6R7d9Gj/vi0Iv1fDhQ2q3L6IkGcMNMAqxV0BobERB+ghvkCVcY1mPCC+cBJIJerPKO+NRLI8ULd9HPIje4LR9klGBRca0wIYHcphWaHxYBBa8peaeNpx9ju7fcsEVRM5Uq0AK5Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729808039; c=relaxed/simple;
	bh=po5ehJnb+7rP+GK7VYUm+dex1qNN9qSIiZ8NawvUPIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GofkX5BRFgQTHmG5yRf0uRsrAh6hD9SLYmYR3Iaqhf/13hLxif0oOiFn0BxgSKydLOJkZLhwBWe2vhP+Ly9BEUDkejrMKEgKf/5wz9hAyWQhgKnAFpSxv7GEZNXd9XUNXpGGOmNbqAJc0rSMUp+aUZuptkEQ2cfn88gh/SpABPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R+WXq7D7; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539e5c15fd3so1421367e87.3
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729808035; x=1730412835; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sFw2J2mL4WOYJo9lC4QSyavZpjOp0c0IrgvtMNHB3r4=;
        b=R+WXq7D7yXwX5ngc2UYxPSZYttH2TIU0077iRMsVAxlm8zmrpt3vXc8j6OdRlLnrnM
         ElPPxWlcP4dxHOkmH+Xbxy47qXRoacTcba6hx3ZJLvhfgCocm0W3fA3SxQuMoOhfiHzP
         JhpQR6X2/kqGubzYewLoU5PW76j/mRqvSunO8zgoQNI/qIbiR2kQrg4agBPy7378orCl
         AAtD4kNsUaJTHMtu+cFxG4XjZ4VI3NnmGrrSKAe+uAchSbtx8crparfHvVRo2GZa4M/1
         Pi+EJcokLIpp9S1XDwyCn3nsOugwR9KgjG+odG314wDz0eLLD7EwWWuQyVEPLhraStd0
         g+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729808035; x=1730412835;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sFw2J2mL4WOYJo9lC4QSyavZpjOp0c0IrgvtMNHB3r4=;
        b=Z0hUzpMoxvKPSiLf9TVm76hMwM72B6GqA6xFfnbNmlPpM3rSIjN651nYFFYtQvsX/E
         NtOaJdQX3vBJPqmTMReIEHpz69f5sGDiNh7PmSyvLRS9EQvL1LkpHYog3DFOZiY1guQ+
         1r6wUEiRlD55KwQERUYBiRlF29FqOJjWX3+bhZOOAu44pyXg9OxFUUXroz2xtGrqVTN1
         a7QU+n37WwG6lZKo9luMbde78IcbkzMyo54z/4P96BthzsfAaSx4t/RLgcm5vla5In2n
         y+GjDmsCiT3opdLHSt7BjLSD+tbkLQPc8hMPcN03Fdlszv9iLRJ3b5xlpz/0ew+7p55q
         +few==
X-Forwarded-Encrypted: i=1; AJvYcCVKn94Xcy7lZ5oDmA612Aphy3Lym9kCZzY1NWrshfa+9zUhRMAdYjsZemdqTXLpm2Piak1S/O7qKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWz76ajbDQ8IXMqsrEvQnnV2o2hZ+xlgFlM2WAJPPkPpT6Qtlq
	00ewZQjnDvNShXOdO20NrSHsKimp1xeCBZ2Q4mtuRB/gE3bjKxxbfx+LKA==
X-Google-Smtp-Source: AGHT+IHZM50lyVZN7uVv4FJPwT6NPdmlHaDIxHdysd4FAeox191HxoEklu/pHPVgNIxq0s40mKVqGw==
X-Received: by 2002:a05:6512:3b86:b0:539:f468:a51c with SMTP id 2adb3069b0e04-53b23e9f955mr2302784e87.52.1729808035248;
        Thu, 24 Oct 2024 15:13:55 -0700 (PDT)
Received: from [192.168.42.26] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66a6d798sm6344024a12.50.2024.10.24.15.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 15:13:54 -0700 (PDT)
Message-ID: <4f38ca15-a341-4d93-80eb-18f79fdd6664@gmail.com>
Date: Thu, 24 Oct 2024 23:14:28 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] implement vectored registered buffers for sendzc
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1729650350.git.asml.silence@gmail.com>
 <b15e136f-3dbd-4d4e-92c5-103ecffe3965@kernel.dk>
 <bfbe577b-1092-47a2-ab6c-d358f55003dc@gmail.com>
 <28964ec6-34a7-49b8-88f5-7aaf0e1e4e3f@kernel.dk>
 <3e28f0bb-4739-40de-93c7-9b207d90d7c5@gmail.com>
 <3e6c3ff5-9116-4d50-9fa8-aae85ad24abc@kernel.dk>
 <3376be3e-e5c4-4fbb-95bb-b3bcd0e9bd8b@gmail.com>
 <67f9a2b9-f2bd-4abd-a4a5-c1c5e8beda61@kernel.dk>
 <d8da2a22-948b-4837-a69a-e9e91e37feec@gmail.com>
 <daeacc90-e5b4-471d-a79e-74ae10eb4aba@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <daeacc90-e5b4-471d-a79e-74ae10eb4aba@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 20:56, Jens Axboe wrote:
> On 10/24/24 12:13 PM, Pavel Begunkov wrote:
>> On 10/24/24 19:00, Jens Axboe wrote:
>>> On 10/24/24 11:56 AM, Pavel Begunkov wrote:
>>>> On 10/24/24 18:19, Jens Axboe wrote:
>>>>> On 10/24/24 10:06 AM, Pavel Begunkov wrote:
>>>>>> On 10/24/24 16:45, Jens Axboe wrote:
>> ...>>>> Seems like you're agreeing but then stating the opposite, there
>>>>>> is some confusion. I'm saying that IMHO the right API wise way
>>>>>> is resolving an imu at issue time, just like it's done for fixed
>>>>>> files, and what your recent series did for send zc.
>>>>>
>>>>> Yeah early morning confusion I guess. And I do agree in principle,
>>>>> though for registered buffers, those have to be registered upfront
>>>>> anyway, so no confusion possible with prep vs issue there. For provided
>>>>> buffers, it only matters for the legacy ones, which generally should not
>>>>> be used. Doesn't change the fact that you're technically correct, the
>>>>> right time to resolve them would be at issue time.
>>>>
>>>> I'm talking about sendmsg with iovec. Registered buffers should
>>>> be registered upfront, that's right, but iovec should be copied
>>>> at prep, and finally resolved into bvecs incl the imu/buffer lookup
>>>> at the issue time. And those are two different points in time,
>>>> maybe because of links, draining or anything else. And if they
>>>> should be at different moments, there is no way to do it while
>>>> copying iovec.
>>>
>>> Oh I totally follow, the incremental approach would only work if it can
>>> be done at prep time. If at issue time, then it has to turn an existing
>>> iovec array into the appropriate bvec array. And that's where you'd have
>>> to do some clever bits to avoid holding both a full bvec and iovec array
>>> in memory, which would be pretty wasteful/inefficient. If done at issue
>>
>> Why would it be wasteful and inefficient? No more than jumping
>> though that incremental infra for each chunk, doubling the size
>> of the array / reallocating / memcpy'ing it, instead of a tight
>> loop doing the entire conversion.
> 
> Because it would prevent doing an iovec at-the-time import, then turning
> it into the desired bvec. That's one loop instead of two. You would have
> the space upfront, there should be no need to realloc+memcpy. And then
> there's the space concern, where the initial import is an iovec, and
> then you need a bvec. For 64-bit that's fine as they take up the same
> amount of space,

That's not true, each iov can produce multiple bvec entries so
iovs might get overwritten if you do it the simplest way.

> but for 32-bit it'd make incremental importing from a
> stable iovec to a bvec array a bit more tricky (and would need realloc,
> unless you over-alloc'ed for the iovec array upfront).

And that's not true, you can still well do it in place if
iovec is placed right in the memory, which I explicitly
noted there are simple enough ways to do it in place
without extra reallocs.

-- 
Pavel Begunkov

