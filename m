Return-Path: <io-uring+bounces-2757-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FDBB950FCD
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 00:35:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 826A9B21B0D
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 22:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A7D313635D;
	Tue, 13 Aug 2024 22:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SrAcvfO4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A38370
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 22:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723588535; cv=none; b=FqzHXOq9dbW3xDPuW3gFAU3M2Ok5+RWnZzuwm0M2f4mOK2GGNWoU6+l2jXEIWj6Q+Eg3ctIkZHhzfTHk2sOdpggnpzr0ZEKtPAARdaW1AeHqXD1C+OCaRs630fwEyWCroG+XNSaAY83+tZR8jl08kebQUpXYtlhiCFhqJqbzJxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723588535; c=relaxed/simple;
	bh=77496m2abrxEQVmRZIZWUjDUrlNjeSLEdYlATnxGszU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YIi5Oo1LlQruxBaokN+NbGxlJ+tOiSOosgeyN2hAMpPhraYt+nDNN1Jl8Ba1Rn1kG/+R1og4MRw59gLjR+xeXT149nDiFF6Pl5JmQBjjHu6Ylg2j5U86YgUZOg9geGXfnYQmWTZHDCMNG9fszN7xRanUMEUJig0KLzGkCwYovLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SrAcvfO4; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-530c2e5f4feso6140052e87.0
        for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 15:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723588531; x=1724193331; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=47x11KgbZEARAnGZBQ+LaTRjIinzqaQ7vbKlWxtgyJA=;
        b=SrAcvfO4q9hnRazZrsLLqY40s8Ps8FPe5XEt8LGAo3FwT61FF7elRP2Z8X78ylL6sy
         E2Jsrgskj3mM0z7jNQNdYs8KeJyCau5kiy6R/j5p43K7U5IYVjBe1qJex9GjWQab0+RS
         FhbblctzgiCE4q4p+4fCaONdZZMId9CE3LrKsekLg8OprKZECphjxUYyudbnumi4cf/k
         A6BVQD4PizWVcZnc8dW8LkQb8mFO82qqa8ud4gUZCtNzC1qqDurG/cEzK9p6yNTA83Av
         ydjYfVGF5m+TiMWcn0ERxOc4Y5ywgyGQ+y+uH1rGKo9rx8pXOMy9VRjnC3s6uuIVVMXy
         VswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723588531; x=1724193331;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47x11KgbZEARAnGZBQ+LaTRjIinzqaQ7vbKlWxtgyJA=;
        b=WNMF+62p2e9VV1GBrZRIVTCTF3UWDcHh88YziXg3F/eXYQLwKcCOIuFjivz4gdRJ5+
         M99Kg+CVUKzVGeJg9Xue58662tTG3i7LQXI/7fabYxgyNUd8cVmmraseK551Afuee5oM
         y4xJ57hXbol7LIT4F1dkKjvEp1wqYg/fe8OqE1MRdIoTQ5eI6W86McZOhm4nXFfFJPom
         8/ZXHtmSPtAispyNvsKA+JnCA4tJhVSnD6pMf2tej7gVl+d1RvUNlhe9C2BhzIBvDdcD
         J2L0QCcPAngaC5SrwjSKtMmOmWC0T6fvSkQ/5n0EiR/laUU+EznFnicdmmMvrgQKRF20
         ZUvg==
X-Forwarded-Encrypted: i=1; AJvYcCXwHTpOzDfnUjezUL4iLKCYesIFyoV2D+eNzH4YIUFkWMBlI5lilRr1EQTHif5Xy3Ax4mzTkTpCkKPtCPGdDJ2vG3Q+CppDa6s=
X-Gm-Message-State: AOJu0Yz6jzcwIqsaL+WTCeQS6CsDxdKjHmuJVdCi4moXuAxB+a42WN/2
	drbocqHopT6wm/rBKKwQu7XebRICywyVx3n13JaZw9cKBCa7f4Yu
X-Google-Smtp-Source: AGHT+IGvour3g7/jrTeZ0ARGxFsVe5xenIei7LauVP//uha54SwYQSBBu2/vgHiFoN8stEBEnO5rPA==
X-Received: by 2002:a05:6512:398a:b0:52e:9ecd:3465 with SMTP id 2adb3069b0e04-532edbcf258mr402215e87.57.1723588530845;
        Tue, 13 Aug 2024 15:35:30 -0700 (PDT)
Received: from [192.168.42.69] ([148.252.132.251])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f411b578sm105054766b.142.2024.08.13.15.35.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 15:35:30 -0700 (PDT)
Message-ID: <70c5f2ff-d134-4e90-8e3d-e9f06ba8f407@gmail.com>
Date: Tue, 13 Aug 2024 23:36:06 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] abstract napi tracking strategy
To: Olivier Langlois <olivier@trillion01.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <cover.1723567469.git.olivier@trillion01.com>
 <c614ee28-eeb2-43bd-ae06-cdde9fd6fee2@kernel.dk>
 <a818bc04dfdcdbacf7cc6bf90c03b8a81d051328.camel@trillion01.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a818bc04dfdcdbacf7cc6bf90c03b8a81d051328.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/24 22:25, Olivier Langlois wrote:
> On Tue, 2024-08-13 at 12:33 -0600, Jens Axboe wrote:
>> On 8/13/24 10:44 AM, Olivier Langlois wrote:
>>> the actual napi tracking strategy is inducing a non-negligeable
>>> overhead.
>>> Everytime a multishot poll is triggered or any poll armed, if the
>>> napi is
>>> enabled on the ring a lookup is performed to either add a new napi
>>> id into
>>> the napi_list or its timeout value is updated.
>>>
>>> For many scenarios, this is overkill as the napi id list will be
>>> pretty
>>> much static most of the time. To address this common scenario, a
>>> new
>>> abstraction has been created following the common Linux kernel
>>> idiom of
>>> creating an abstract interface with a struct filled with function
>>> pointers.
>>>
>>> Creating an alternate napi tracking strategy is therefore made in 2
>>> phases.
>>>
>>> 1. Introduce the io_napi_tracking_ops interface
>>> 2. Implement a static napi tracking by defining a new
>>> io_napi_tracking_ops
>>
>> I don't think we should create ops for this, unless there's a strict
>> need to do so. Indirect function calls aren't cheap, and the CPU side
>> mitigations for security issues made them worse.
>>
>> You're not wrong that ops is not an uncommon idiom in the kernel, but
>> it's a lot less prevalent as a solution than it used to. Exactly
>> because
>> of the above reasons.
>>
> ok. Do you have a reference explaining this?
> and what type of construct would you use instead?
> 
> AFAIK, a big performance killer is the branch mispredictions coming
> from big switch/case or if/else if/else blocks and it was precisely the
> reason why you removed the big switch/case io_uring was having with
> function pointers in io_issue_def...

Compilers can optimise switch-case very well, look up what jump
tables is, often works even better than indirect functions even
without mitigations. And it wasn't converted because of performance,
it was a nice efficient jump table before.

And not like compilers can devirtualise indirect calls either, I'd
say it hits the pipeline even harder. Maybe not as hard as a long
if-else-if in the final binary, but jump tables help and we're
talking about a single "if".

I totally agree, it's way over engineered.

> I consumme an enormous amount of programming learning material daily
> and this is the first time that I am hearing this.
> 
> If there was a performance concern about this type of construct and
> considering that my main programming language is C++, I am bit
> surprised that I have not seen anything about some problems with C++
> vtbls...

Even without mitigation business, we can look up a lot about
devirtualisation, which is also why "final" keyword exists in c++.

-- 
Pavel Begunkov

