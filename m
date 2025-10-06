Return-Path: <io-uring+bounces-9896-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B140BBBCEBA
	for <lists+io-uring@lfdr.de>; Mon, 06 Oct 2025 03:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DE51F3479DB
	for <lists+io-uring@lfdr.de>; Mon,  6 Oct 2025 01:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B3A199E94;
	Mon,  6 Oct 2025 01:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ALe5mBfT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D392D34BA37
	for <io-uring@vger.kernel.org>; Mon,  6 Oct 2025 01:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759712998; cv=none; b=Pahrowf6UUt1OtI9uQtwQ1eDUt2EI0JNHz5DHqPFM1Rkfuia1rDUl7Cz51zQSxwciGncm2th7dii3wCJknfwvycFQqOSvxj0ZNwgTt7L7/CDIEPncsx3/mjD4KrZGYAte0qj01BFs/WSycwl3Jshn7ZD6qnn8NnzLct6DZcVs+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759712998; c=relaxed/simple;
	bh=9lke7M/wTxgZuODbJRki9rULohJLXiAWe2VZjICDF3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IK3Gj+IvmvZ3FjrG8ANXAKlJ3b5oVFiPPUMxvEQv2pq7Lljjs+O5No8v4kDCQl3AkWvHaUi9XUKi9zlRd8BxRT8CPlDo7x6tRu22oEXU4HyW5/N9fBD40pQQm8oFDZiJibsJsZPJzQ6pRYg4LUGcsYBPOMEx/EN8xW7qt4Jd4+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ALe5mBfT; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-90926724bceso372056739f.1
        for <io-uring@vger.kernel.org>; Sun, 05 Oct 2025 18:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759712994; x=1760317794; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CnuS9YAfYvaZynqWM0iMADrPOeXE4IvhGiq2JTd/WAs=;
        b=ALe5mBfT7K3xjewBaN/CJa059NtV2fDUBVX4W5EA1MOUH3bp/TOzV1HNx72mZMZiGo
         XGjwunMrQC6tDVJ7L5rseIFUEata9RV0cm2N77H5IxfehGooHDthxJA77OqFc24aw5RS
         xorMliP4vyGjHkRCVAkcsDBsx/Ubs07SYdGEx1bQrCSIB1fLzjJgj8aysmYApx3f8Fs1
         VkYytX8IV4VS9jcxxS6xEVJW1yDrouKL1MOSDWxgLuabqIVWReQbzDeSy9C1lIrJ2/ZD
         Q6eWJfn0xo+q+4BLc/T+YbmwWGtBVaBVsbdlWCoQdfca4XGEMeO6DGknbLWVNbP7ou25
         S5sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759712994; x=1760317794;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CnuS9YAfYvaZynqWM0iMADrPOeXE4IvhGiq2JTd/WAs=;
        b=cOO+MWu/yU5axUyCDPNg3S6c0gUPYg7HyVkvPOkUATSNw60/AYVZZWRJ+U7xMx0WNl
         2NOzxx6Vci2ze+9ieBymWUX0kj8/ig6rLi+ZzgJXQ5o19XS5RmD9qwJlQzZa7wNSx/AE
         tIfbFva9AoaxuQIrpY9JWVm4/dRv3uAGW/X8Jg/8sqpD1PjrjCIn+fnHwBjfR6DXFk+A
         l5E3K96aW3hxk90a0UH5+FUGzXQa9A1ZJ3pDtcTZKoxc8yhT50AkO7WY15KuS3dD6Yq3
         32h4Vm6te8hXv2MCzA3ac7lnvhwcJqT4izsL0f3ZkDfgZQCPdIk78w7eh55Zox7O0oKQ
         C+kg==
X-Forwarded-Encrypted: i=1; AJvYcCV0VzZxrA9gzdnYbJDJwJTSYUcpp9GVKHUkedBG4MkD8Va52DjZJcZcv53ACgRz7/M6AKfEvE+tTw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ2scd6fhKWw2SYcWJcrJnckSAdLXCRtMdr++HZWbLMwM6O4e/
	R9NqIrV6UauSqrz3oRkibFi5f1xoMrMs63iMWN6L1bFoU76HVHm3/NKP5hUPPPBdals=
X-Gm-Gg: ASbGncsKxss3VDa6IGd7WRSpj108VI8aqzwFd+WD09HsE4Ml6Rzojeeyu5gwSJRSNqg
	vya44LtkDRK19VZtvEl89Uu5cDSST4se6otaMUijq6nA4lDfuXUvnVscKpHNjorjiqXu7wjMzGg
	cupPjVra4tCuBgWV9SnF5k/RipS5UwlDWjpG7Q4rPsNkOke8fVRSjCJaf1MRseEQq3MFtQZM6l5
	NF1tnIrMhRX1iCtnFxbopqTcOB4u2Rw7Px49aLcWNgMTe20IPK7Jx9EkCnrD4aD1hZr2pCz18vA
	FZr0y+qc8pzyt/ncchQpTpq/GCxkWONqV9lBbPtL4jhpRnKBTtcsdd+F5nmNBeZ6JWIuE6Vcj/q
	7heNj7aM58iPlh6XeOoMGs2ZsSlVPYdlEow7WUNUAR5GYkaQPARHngaA=
X-Google-Smtp-Source: AGHT+IE4e427Yx/SrtM/tPnniklRxdb2jMAlFXcqw9uuiY9g0EScKf0j8qHuK3a4VT3OqBkFfiJnfQ==
X-Received: by 2002:a05:6e02:3e8b:b0:42d:8afd:4444 with SMTP id e9e14a558f8ab-42e7adaaa0emr150395645ab.26.1759712994533;
        Sun, 05 Oct 2025 18:09:54 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ebc8181sm4566937173.47.2025.10.05.18.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Oct 2025 18:09:54 -0700 (PDT)
Message-ID: <57de87e9-eac2-4f91-a2b4-bd76e4de7ece@kernel.dk>
Date: Sun, 5 Oct 2025 19:09:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CQE repeats the first item?
To: Jacob Thompson <jacobT@beta.pyu.ca>, io-uring@vger.kernel.org
Cc: "hange-folder>?" <toggle-mailboxes@vultr155.smtp.subspace.kernel.org>
References: <20251005202115.78998140681@vultr155>
 <ef3a1c2c-f356-4b17-b0bd-2c81acde1462@kernel.dk>
 <20251005215437.GA973@vultr155>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251005215437.GA973@vultr155>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/5/25 3:54 PM, Jacob Thompson wrote:
> On Sun, Oct 05, 2025 at 02:56:05PM -0600, Jens Axboe wrote:
>> On 10/5/25 2:21 PM, Jacob Thompson wrote:
>>> I'm doing something wrong and I wanted to know if anyone knows what I
>>> did wrong from the description I'm using syscalls to call
>>> io_uring_setup and io_uring_enter. I managed to submit 1 item without
>>> an issue but any more gets me the first item over and over again. In
>>> my test I did a memset -1 on cqes and sqes, I memset 0 the first ten
>>> sqes with different user_data (0x1234 + i), and I used the opcode
>>> IORING_OP_NOP. I called "io_uring_enter(fd, 10, 0,
>>> IORING_ENTER_SQ_WAKEUP, 0)" and looked at the cq. Item 11 has the
>>> user_data as '18446744073709551615' which is correct, but the first 10
>>> all has user_data be 0x1234 which is weird AF since only one item has
>>> that user_data and I submited 10 I considered maybe the debugger was
>>> giving me incorrect values so I tried printing the user data in a
>>> loop, I have no idea why the first one repeats 10 times. I only called
>>> enter once
>>>
>>> Id is 4660
>>> Id is 4660
>>> Id is 4660
>>> Id is 4660
>>> Id is 4660
>>> Id is 4660
>>> Id is 4660
>>> Id is 4660
>>> Id is 4660
>>> Id is 4660
>>> Id is 18446744073709551615
>>
>> You're presumably not updating your side of the CQ ring correctly, see
>> what liburing does when you call io_uring_cqe_seen(). If that's not it,
>> then you're probably mishandling something else and an example would be
>> useful as otherwise I'd just be guessing. There's really not much to go
>> from in this report.
>>
>> -- 
>> Jens Axboe
> 
> I tried reproducing it in a smaller file. Assume I did everything wrong but somehow I seem to get results and they're not correct.
> 
> The codebase I'd like to use this in has very little activity (could go seconds without a single syscall), then execute a few hundreds-thousand (which I like to be async).
> SQPOLL sounds like the one best for my usecase. You can see I updated the sq tail before enter and I used IORING_ENTER_SQ_WAKEUP + slept for a second.
> The sq tail isn't zero which means I have results? and you can see its 10 of the same user_data
> 
> cq head is 0 enter result was 10
> 1234 0
> 1234 0
> 1234 0
> 1234 0
> 1234 0
> 1234 0
> 1234 0
> 1234 0
> 1234 0
> 1234 0
> FFFFFFFF -1

I looked at your test code, and you're setting up 10 NOP requests with
userdata == 0x1234, and hence you get 10 completions with that userdata.
For some reason you iterate 11 CQEs, which means your last one is the one
that you already filled with -1.

In other words, it very much looks like it's working as it should. Any
reason why you're using the raw interface rather than liburing? All of
this seems to be not understanding how the ring works, and liburing
helps isolate you from that. The SQ ring doesn't tell you anything about
whether you have results (CQEs?), the difference between the SQ head and
tail just tell you if there's something to submit. The CQ ring head and
tail would tell you if there are CQEs to reap or not.

-- 
Jens Axboe

