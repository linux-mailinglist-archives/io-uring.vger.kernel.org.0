Return-Path: <io-uring+bounces-5060-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 421F09DA08E
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 03:10:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CCEAB22DF4
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 02:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169AA17BA2;
	Wed, 27 Nov 2024 02:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ytrIqmmr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEFA38FAD
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 02:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732673446; cv=none; b=OGZYV1HLbXcJKJv+ukLj6pDQEcWb64mIhk9WC2gvjTi+hEVn88HtRgudS/FuRTzgWue1+oxDsCCSTD0Mcv0PanrsRo8Ll1WrCOp7AQr8exNnknUA9A0gqSUGWRHiEfbqzZ4ahcDODk6WADZ36M5ekesJoVNDSyVDC9LLylWzS6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732673446; c=relaxed/simple;
	bh=tmCSlbCU3KjQLwp+92HsJhs+KG3V5m+P6ft1AAG5Buo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lcLDr9UYrVgK1bkyBaRBjiEIJlB7QH4zN91xwYcuYxIjlK2yeJi3T6ZUpeZB31Pt8JmmAbmTXFNkh8+Y9NCivjsh16yZrWhimNteOZNlqPBoJjtHS8fNK7TJpToUPo3cFwaddjg7VwXdxx/R6+SXfIErkuH2int0bZjrmGSZEXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ytrIqmmr; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7fc2b84bc60so2164773a12.1
        for <io-uring@vger.kernel.org>; Tue, 26 Nov 2024 18:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732673443; x=1733278243; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bN0OJ4Bm1lJFlb51vvB5T5hdENjLiQmr8uWBqBhmsFI=;
        b=ytrIqmmrJotcq4EjWmZAaK4uWGJkY+5HlS/woLV09fbTOxjGw8PQ8537Yn5HRCtkVR
         6CfsblHHFEwOX3uxuJS5amGUIhxKRRmUbhstNq7G4mHvu3yGHYk3PalNsmsEC8Ovtv3P
         F3P19Qww+aRYjxoDAb3OlrsOM8ze9hv/10MjXJcepsddrT2jK2IlZZI6oXupis+eDsg3
         /2tNLm9bpp0Xr85CZ2nhTTbE8NwNr1ByZl71VViySuY829CHuZelcBXkmbSccOsJJVDf
         HeEXIGVx/+5T+5tIWkUFESODErANe0RYfkAHQC2N/iU5woM2y8OnL5iJSPGR6+28KG8j
         IUoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732673443; x=1733278243;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bN0OJ4Bm1lJFlb51vvB5T5hdENjLiQmr8uWBqBhmsFI=;
        b=kZjx4TDNn6neJEsveXzsWTYoIVX6snVFJHusJgDftqIfZu3msvRLgBRLNhHMRsSFJ0
         kLQH7QK8cTc/J/oQ2K5lTlp/8BS18NqDmN4hyAFNeq+MQLcGiUTN7cWFxdZVnPDTa7Dc
         6ZRSSXmDlA/XluPv0pjcb7pO3RHQ9618VWz2tKlX9v7ZqJQFwM0Sfi5EuVZ2LZGr/jjZ
         mS11t0q5zhH3Tu52QzjfqnhG0H3KU//eGHc2yMZzTwqYdVxBHW+apFu5qv9hWC/MGtiP
         XjdToixGmJOxdzYD4jDKxJCyEObF8lR83hcvQ9kAcTTP6AToURzdShrsBBtOaltuKqE+
         jqCw==
X-Gm-Message-State: AOJu0Yy3rC5HyvRhtOVOFvH4wO0hBMkFQaB7GrFZ4tj5flxYcktXy3q+
	nKfqZZ6fFxhTqQnh70i/EHWRPo649B90ioc9DDzkb0VEAPDDOPGb5TdICa63m+M=
X-Gm-Gg: ASbGncuaSLnubWkZ4uREe9KcqdMamsCD1TlRIlJNUdTNoo7bQh7t17fTVJExJo7Q3Gi
	8ERX87hiPUsCtGWrA/Pr2lfIwWSWwzeUVjevqhJdUhXfHxefEfwfkLRkfsLaoGbq4jJMdTgd0iG
	hwIhzvp8WdGXMHksFoyeOpxxh6JFvF2MXM5GcZ3Zv8j+YJIPkgv9YeWMsVMA21Rj4LJ2kFWqtuF
	kS2py/YiEAUMq4qSRgvugcvB3DGEyZDyw9tkZzbSXbCdmQ=
X-Google-Smtp-Source: AGHT+IHyCjyArazp4Kv+QAet0OwgoauPRpA8UZJ0doQRguV0LK0oU8Aqd3kwqL8U6VmfnA4taK2Z3Q==
X-Received: by 2002:a05:6a20:2449:b0:1db:eb56:be7c with SMTP id adf61e73a8af0-1e0e0b5377cmr2466242637.35.1732673443643;
        Tue, 26 Nov 2024 18:10:43 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724de47d186sm9165002b3a.76.2024.11.26.18.10.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2024 18:10:43 -0800 (PST)
Message-ID: <4face69c-50f7-4dc7-827a-b3b91a4f7a3a@kernel.dk>
Date: Tue, 26 Nov 2024 19:10:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] io_uring: add support for fchmod
To: lizetao <lizetao1@huawei.com>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "asml.silence@gmail.com" <asml.silence@gmail.com>
References: <ad222c8b35e54627b0244d5ee4d54f0c@huawei.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ad222c8b35e54627b0244d5ee4d54f0c@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/24 8:07 AM, lizetao wrote:
> Hi,
> 
>> On 11/23/24 5:23 AM, lizetao wrote:
>>> Hi
>>>
>>>>> On 11/19/24 1:12 AM, lizetao wrote:
>>>>> Adds support for doing chmod through io_uring. IORING_OP_FCHMOD 
>>>>> behaves like fchmod(2) and takes the same arguments.
>>>
>>>> Looks pretty straight forward. The only downside is the forced use
>>>> of REQ_F_FORCE_ASYNC - did you look into how feasible it would be
>>>> to allow non-blocking issue of this? Would imagine the majority of
>>>> fchmod calls end up not blocking in the first place.
>>>
>>> Yes, I considered fchmod to allow asynchronous execution and wrote a
>>> test case to test it, the results are as follows:

>>>
>>> fchmod:
>>> real	0m1.413s
>>> user	0m0.253s
>>> sys	0m1.079s
>>>
>>> io_uring + fchmod:
>>> real	0m1.268s
>>> user	0m0.015s
>>> sys	0m5.739s
>>>
>>> There is about a 10% improvement.
> 
>> And that makes sense if you're keeping some fchmod inflight, as you'd
>> generally just have one io-wq processing them and running things in
>> parallel with submission. But what you you keep an indepth count of
>> 1, eg do sync fchmod? Then it'd be considerably slower than the
>> syscall.
>
> Indeed, When performing REQ_F_FORCE_ASYNC operations at depth 1,
> performance is degraded. The results are as follows:
>
> fchmod:
> real	0m2.285s
> user	0m0.050s
> sys	0m1.996s
> 
> io_uring + fchmod:
> real	0m2.541s
> user	0m0.013s
> sys	0m2.379s

That's what I expected. But actually looks like io-wq does a good job in
this case, that's pretty close.

>> This isn't necessarily something to worry about, but fact is that if
>> you can do a nonblock issue and have it succeed most of the time,
>> that'll be more efficient (and faster for low/sync fchmod) than
>> something that just offloads to io-wq. You can see that from your
>> results too, comparing the sys number netween the two.
>
> However, when I remove REQ_F_FORCE_ASYNC and use IO_URING_F_NONBLOCK,
> the performance is not improved. The measured results are as follows:
> fchmod:
> real	0m2.132s
> user	0m0.048s
> sys	0m1.845s
> 
> io_uring + fchmod:
> real	0m2.196s
> user	0m0.005s
> sys	0m2.097s

You would not expect it to be faster, as it's really just doing the same
work through a different mechanism. I'd expect that to roughly be within
normal variance, and if you're not doing a submit_and_wait mechanism (eg
you're doing submit and wait separately, hence doing 2 syscalls for each
fchmod), then that likely explains the discrepancy, if there is any.

And you'd also need to actually be able to remove REQ_F_FORCE_ASYNC to
have this as something that could be included. Otherwise if vfs_fchmod()
blocks, then you're now stalling the whole pipeline. Removing it just as
a test is fine, as you did.

>> Hence why I'm asking if you looked into doing a nonblocking issue at
>> all. This won't necessarily gate the inclusion of the patch, and it
>> is something that can be changed down the line, I'm mostly just
>> curious.
>
> Does this result meet expectations? Or maybe I missed something,
> please let me know

Yep that looks like I expected. io-wq offload will be fine if you're
doing a bunch of fchmod, in fact it'll probably end up being faster as
you reported. But if you're doing single (or few) fchmod at the time,
then io-wq offload will be a bit slower.

-- 
Jens Axboe

