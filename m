Return-Path: <io-uring+bounces-5496-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 404999F1FE4
	for <lists+io-uring@lfdr.de>; Sat, 14 Dec 2024 17:26:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B95A41885B01
	for <lists+io-uring@lfdr.de>; Sat, 14 Dec 2024 16:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2964B190052;
	Sat, 14 Dec 2024 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e1dbdhd1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437A738DE0
	for <io-uring@vger.kernel.org>; Sat, 14 Dec 2024 16:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734193582; cv=none; b=se+PuAxzv1lsKHg4Q6fTw01pP/I7kA5ZED7crVD5Y7Wjav9XTrdQsKuKqT8XP2Am+irFTJ668UP0Tjs9NeSLRuTCqaqXgsPLaygI58TYeHX9Zjl70lp1w8dZD545Byaa8luVfFE/dpCv9Fo5BnmOvVODkfBKOgC2D+XyFg/Nt2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734193582; c=relaxed/simple;
	bh=6FjECuRFhWorqXKblYMlS44v5wafVSefSx+IX7Wxmi4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SRA1anYg1gRGZ9x1PFgs1R+iIlt7A8gPk+PeHS3Wf8rwQrjOQ/OINdCWFHjpXz7fVULfVp0LhJR1hDZgxq/mC79vE8tU202Cf4buIiQyC5WEOMTh6kRYcgI32XOSng+GJpxtpW25fiXLFJJRP9hzj3Bx5IWmrN2pneq87LDpjRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=e1dbdhd1; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21619108a6bso20640365ad.3
        for <io-uring@vger.kernel.org>; Sat, 14 Dec 2024 08:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734193576; x=1734798376; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EfATDUX50/LtZMexNkcu3bn8NI4BaAxvdGDGaYnOphA=;
        b=e1dbdhd18nqHzMT7uBhtTSzNs9gpjEPY7WOVnkQlXXJ62La/m1YSWFhYp7/JXkSu5h
         4KxTbZ7cLuxZAhoc2ZnLW67+frlyrauzkPLNTNnkCVNv/QT8TjtB1RhMYkuYe7OrtyJX
         E5iJcz/XtVZlqx1PVnXJxBrX/ueAyvrvMSobMv/UCEVIrEigq1kXbByuyYfCPHPoH2RQ
         CulprvCukDC2PHDMaKV37hpn/ZMBddlhzLrrw8LenOc/wpo5OhifpPn7qdsQHI8nZh6v
         VhdserSRkpBpTQE0rNZpPqKnpjbm8yrtsmLmaI6IWE1qn8NS+HlnuXaSqJSnZxhmXX38
         r3bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734193576; x=1734798376;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EfATDUX50/LtZMexNkcu3bn8NI4BaAxvdGDGaYnOphA=;
        b=GkLZppRfsvFCG3eH76BLEtcXcdAKLe5UVtTNsbmSuImOEePsxmcUZt5uqe6njiN9Nz
         6wwcWWangIQLKGR/PG09aW4KzRSWBqd+gY5eZQTwLUiHfyUHupnjquPNxOXagoVMjfXi
         kG0tGRvoiKfbrY8ZO/I0haZycHQLz9FK+ygfO/kkXAG+pywvlZ+AwkSlHV14hkJGMrLu
         gi8E124zKigTdxH1q6Zo428nXbwyHNGx2WGh2mDvuTj2aQIoVhgvuSany1QUpuWj1SSb
         S2lZuTcdyQdWh77u+vMfB06Ktx+5HzBZ+YOrXlill39E/DFsmO5B49TzEgcUDfU+d2WM
         JT2A==
X-Gm-Message-State: AOJu0YxO5CbGj0c3rwmgMVLFa8NKFlGsbjUQKVkl6SrRxClz47qXHM8e
	vBZJx2WiODybKci0B90AAWaWH4tpZ39rxLvm40aK4ispJldPEae0dVqhqrB/LJPgQq6E3aeFITs
	R
X-Gm-Gg: ASbGnctnfoipl2+WE6rsI8bJaLHSYf23a4/FlBW6gCURmmEu/Zx1vRhSL2Jw0u89GPU
	L36DY8BiyuCjnUI7cHIv2OlQFe0hHf2mSiTzkrnzKqvcjFHXS596vqDq1TJ4Un56FEM9YZty9cM
	ewX4irx8gfELEj1jKMNmy63Jop3zN+cFS+PQdnuJKYay6M0FC1EgikHRk/HAduAODx7ldfTaK/e
	1FP4GdIt4kx7M7vznaKZNLrZ98PA/O+U2MPI0uKYqPz2bOykCnQnA==
X-Google-Smtp-Source: AGHT+IGn6QX0TtGbYY/u1oR+oZjv7gM53U0lrC3y8Sk5zOOwWGd2T8iog+3Nf+8ZU03xlcj3wijZHw==
X-Received: by 2002:a17:903:2304:b0:216:2dc5:2330 with SMTP id d9443c01a7336-21892a210b8mr98345055ad.36.1734193576330;
        Sat, 14 Dec 2024 08:26:16 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-218a1e6416csm14394585ad.230.2024.12.14.08.26.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2024 08:26:15 -0800 (PST)
Message-ID: <d6e9cf93-670c-4700-899a-984e951a421c@kernel.dk>
Date: Sat, 14 Dec 2024 09:26:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] io_uring: add support for fchmod
To: lizetao <lizetao1@huawei.com>, Pavel Begunkov <asml.silence@gmail.com>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <ad222c8b35e54627b0244d5ee4d54f0c@huawei.com>
 <283d7be4-27d2-4123-96be-34c9c77c1371@gmail.com>
 <8f309e91581b4c5ca664d4685f1045a3@huawei.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8f309e91581b4c5ca664d4685f1045a3@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/3/24 6:54 PM, lizetao wrote:
> Hi,
> 
>> -----Original Message-----
>> From: Pavel Begunkov <asml.silence@gmail.com>
>> Sent: Tuesday, December 3, 2024 10:44 PM
>> To: lizetao <lizetao1@huawei.com>; Jens Axboe <axboe@kernel.dk>
>> Cc: io-uring@vger.kernel.org
>> Subject: Re: [PATCH -next] io_uring: add support for fchmod
>>
>> On 11/26/24 15:07, lizetao wrote:
>>>>>>> On 11/19/24 1:12 AM, lizetao wrote:
>>>>>>> Adds support for doing chmod through io_uring.
>> IORING_OP_FCHMOD
>>>>>>> behaves like fchmod(2) and takes the same arguments.
>>>>>
>>>>>> Looks pretty straight forward. The only downside is the forced use of
>> REQ_F_FORCE_ASYNC - did you look into how feasible it would be to allow
>> non-blocking issue of this? Would imagine the majority of fchmod calls end
>> up not blocking in the first place.
>>>>>
>>>>> Yes, I considered fchmod to allow asynchronous execution and wrote a
>> test case to test it, the results are as follows:
>>>>>
>>
>> FYI, this email got into spam.
> Sorry to bother everyone, but I would like to know if there are any
> plans to implement asynchronous system calls through io_uring, and
> which system calls are in the planning.

No specific plans, existing syscalls are mostly sync by nature of the
API for them. Supporting syscalls through io_uring in an efficient
manner generally necessitates changing something ala:

syscall_foo(..)
{
	return do_foo_syscall(...);
}

into

syscall_foo(...)
{
	start_foo_syscall(...);
	return wait_on_foo_syscall(...);
}

where the act of issuing and waiting for the completion of it are two
separate entities, generally where the waiting is a waitqueue and the
wait_on_foo_syscall() simply waits on it to be completed, and io_uring
can use this waitqueue to get a callback when it has finished.

That allows efficient processing of syscalls through io_uring. If you
don't do that, then you're stuck with do_foo_syscall(), and then
io_uring can only support it by punting to the io-wq worker threads
which will do the sync do_foo_sycall() part.

-- 
Jens Axboe

