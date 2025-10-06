Return-Path: <io-uring+bounces-9899-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 80088BBCEDE
	for <lists+io-uring@lfdr.de>; Mon, 06 Oct 2025 03:31:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 42B4C4E1981
	for <lists+io-uring@lfdr.de>; Mon,  6 Oct 2025 01:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A9EE1E487;
	Mon,  6 Oct 2025 01:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YRwuKBWL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E6F15C0
	for <io-uring@vger.kernel.org>; Mon,  6 Oct 2025 01:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759714286; cv=none; b=j91Cq3lB+P78V9GDlGSDgkZ5nJp3XRrTRUdyRuDSjRHiDRDO7M4stgd+OwOTLgt+hu7V/HfAay9MfeeeQI5NVvrazRexJWVJg0jylY/zmHr9FdHh4FJ3UcbaSbp5XyndqYkFEKEJZ6P7SEocwNEkNGqiaJiozF4R7FnmL3nzcy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759714286; c=relaxed/simple;
	bh=/5ACAnuH7pVKoKEUn6iW28LA/LLkfMpDQqSZXxmBAwE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ap8APEzOhT8oA8oas21x1ANQf/y3vxmJ2E2RpXvdEI0v4XeAnw/9YrzBM5t1m8u2yJz9j16NREp9y3EMzsYPVEmnFJdiLNzSkNjFY3n4GXSOHaGf4kJ52/81JTPGefUs3aAi410MdkrkTE1zDCIgZXHsER3p4rPR/XtPJa6h3R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YRwuKBWL; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-4242bb22132so44473275ab.3
        for <io-uring@vger.kernel.org>; Sun, 05 Oct 2025 18:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759714282; x=1760319082; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iZGdi0qwL3715rpFw9Ka8HJomWK4uZdq99DWMvzfY6Q=;
        b=YRwuKBWLwYI7LcQCb6KjGWkejRpllaZIjSSJk0qOc+cdJ+jmxh6IwPN4tS/cYRGk57
         uaa5I2rtE4PE7gYAsqSAk8MHYlh213OxrbL/gWlB+Z7bIEaBxwhvEQoFDfwjA1ygqAIn
         2V/gk3GcrBdlknav5MFS+bxd33ijItuqM696ianHu859Uo2pbdpKdQ8srtO3wEY/st6Q
         77MAW6xjqHC+fFn7xSPxS8BgHZjOD/s8cyDhkXUqM11cLFyLzjvtaq7nyvzc4l/2bgSo
         ThY9Ckh5XGrdXu+Ik3WZHICbr8PSWq2/a2IDfGkr2OTnzWfije7WwGlIsX7ezyE6eA3k
         tnJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759714282; x=1760319082;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iZGdi0qwL3715rpFw9Ka8HJomWK4uZdq99DWMvzfY6Q=;
        b=hGnsv5tUSIaCcXOL3D6/CQEA5FjMA92UY9ad85Nr8nzoyYQz0RwQbUIRs/Y5uY+XVU
         YaQoa73ei2QKTPTwLTl3mIrYqFN0cPFzL76Vkxy8m1eQjldKccD/82ZsOXthDpmvvRFS
         1+VBmkQRrC8Wa8PchzBTCw7BZkhD5Z5d8gH6/hrdnbSWQ5+ippvb/+21W7YIo3SdsGK2
         2bq+t5GAtzVsU7l6w3EQw+tFOivkPxv1Hs4TVE6ORT2vxT1lJyiOEkgCWCf9jIfUhbqh
         Ke9Re6IJozysflpWhx8KWJIEcL8dJ68LcIvYbysxfgmzaAbukGnlbcCAE1iC8QDhaQeO
         DToA==
X-Forwarded-Encrypted: i=1; AJvYcCVyGbv+GqCB385pns1PGET1mMqGY1YStf6gouBwMbpjnh7zgG6wSAGTJL8QPPPuzdpMM+Uqg3jHgw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWa7ZvYpIFMup/FxANiFn5lRnNBvt/FXIHhf1RU3uoFrBRy9Z1
	s2l0s0VwDvJuFDw6XRIPl1N4jDQ9lD9dxKTAvakMQR//SdTAJWh1P76B1OrDcIksMjumuG+KxF1
	d3hRcLrQ=
X-Gm-Gg: ASbGncudEDWW4keGe0FGtgGMBdk5d0Y4mXJN3wLA/Bo4TCfLtrPIs5xEZbUWnY2pHPl
	lw9+PaqEjlFqHDWIyKqw4flV1SqpnoQaVDoJYh+DCZejOh037ZupPOCQ0CQlGVF/fABYAsXEwZ+
	c0mLG6spAbKOLm32gu3iYOSD5No4lFdL3j1JPcralQSLPhf37LK8YYjPg+iKLaNrVUAhc6FFbEU
	x57QBmGxRfH4mvfYX2M8/6aiwfqyyfMBa3v3vOUOV0WjYFvbvpr0luVnpfdcNNV+IT9tF8/k6yy
	cLH3N/a8VDoufj527aTJB3kc6wDBTKOqAV3FibRAS6IrevFp85k8BWUHSwPz387/5FLiQh24tid
	bggGNW+4RVNMLD5aioGNMBa3Ct2FwqOFZMwFbXJQxbWJ8
X-Google-Smtp-Source: AGHT+IF7L+ycbd5tw8T8DgbWRaXXuNUmUimprChCxjGWKWmPdz7yuBmUFytstDhNYzwKaLoMn3nJFw==
X-Received: by 2002:a05:6e02:1aa1:b0:42d:d4f6:1128 with SMTP id e9e14a558f8ab-42e7ada8ce9mr147171275ab.26.1759714282165;
        Sun, 05 Oct 2025 18:31:22 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42e7b10610bsm37148005ab.23.2025.10.05.18.31.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Oct 2025 18:31:21 -0700 (PDT)
Message-ID: <d5f48608-5a19-434b-bb48-e60c91e01599@kernel.dk>
Date: Sun, 5 Oct 2025 19:31:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CQE repeats the first item?
To: Jacob Thompson <jacobT@beta.pyu.ca>, io-uring@vger.kernel.org
References: <20251005202115.78998140681@vultr155>
 <ef3a1c2c-f356-4b17-b0bd-2c81acde1462@kernel.dk>
 <20251005215437.GA973@vultr155>
 <57de87e9-eac2-4f91-a2b4-bd76e4de7ece@kernel.dk>
 <20251006012503.GA849@vultr155>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251006012503.GA849@vultr155>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/5/25 7:25 PM, Jacob Thompson wrote:
> On Sun, Oct 05, 2025 at 07:09:53PM -0600, Jens Axboe wrote:
>> On 10/5/25 3:54 PM, Jacob Thompson wrote:
>>> On Sun, Oct 05, 2025 at 02:56:05PM -0600, Jens Axboe wrote:
>>>> On 10/5/25 2:21 PM, Jacob Thompson wrote:
>>>>> I'm doing something wrong and I wanted to know if anyone knows what I
>>>>> did wrong from the description I'm using syscalls to call
>>>>> io_uring_setup and io_uring_enter. I managed to submit 1 item without
>>>>> an issue but any more gets me the first item over and over again. In
>>>>> my test I did a memset -1 on cqes and sqes, I memset 0 the first ten
>>>>> sqes with different user_data (0x1234 + i), and I used the opcode
>>>>> IORING_OP_NOP. I called "io_uring_enter(fd, 10, 0,
>>>>> IORING_ENTER_SQ_WAKEUP, 0)" and looked at the cq. Item 11 has the
>>>>> user_data as '18446744073709551615' which is correct, but the first 10
>>>>> all has user_data be 0x1234 which is weird AF since only one item has
>>>>> that user_data and I submited 10 I considered maybe the debugger was
>>>>> giving me incorrect values so I tried printing the user data in a
>>>>> loop, I have no idea why the first one repeats 10 times. I only called
>>>>> enter once
>>>>>
>>>>> Id is 4660
>>>>> Id is 4660
>>>>> Id is 4660
>>>>> Id is 4660
>>>>> Id is 4660
>>>>> Id is 4660
>>>>> Id is 4660
>>>>> Id is 4660
>>>>> Id is 4660
>>>>> Id is 4660
>>>>> Id is 18446744073709551615
>>>>
>>>> You're presumably not updating your side of the CQ ring correctly, see
>>>> what liburing does when you call io_uring_cqe_seen(). If that's not it,
>>>> then you're probably mishandling something else and an example would be
>>>> useful as otherwise I'd just be guessing. There's really not much to go
>>>> from in this report.
>>>>
>>>> -- 
>>>> Jens Axboe
>>>
>>> I tried reproducing it in a smaller file. Assume I did everything wrong but somehow I seem to get results and they're not correct.
>>>
>>> The codebase I'd like to use this in has very little activity (could go seconds without a single syscall), then execute a few hundreds-thousand (which I like to be async).
>>> SQPOLL sounds like the one best for my usecase. You can see I updated the sq tail before enter and I used IORING_ENTER_SQ_WAKEUP + slept for a second.
>>> The sq tail isn't zero which means I have results? and you can see its 10 of the same user_data
>>>
>>> cq head is 0 enter result was 10
>>> 1234 0
>>> 1234 0
>>> 1234 0
>>> 1234 0
>>> 1234 0
>>> 1234 0
>>> 1234 0
>>> 1234 0
>>> 1234 0
>>> 1234 0
>>> FFFFFFFF -1
>>
>> I looked at your test code, and you're setting up 10 NOP requests with
>> userdata == 0x1234, and hence you get 10 completions with that userdata.
>> For some reason you iterate 11 CQEs, which means your last one is the one
>> that you already filled with -1.
>>
>> In other words, it very much looks like it's working as it should. Any
>> reason why you're using the raw interface rather than liburing? All of
>> this seems to be not understanding how the ring works, and liburing
>> helps isolate you from that. The SQ ring doesn't tell you anything about
>> whether you have results (CQEs?), the difference between the SQ head and
>> tail just tell you if there's something to submit. The CQ ring head and
>> tail would tell you if there are CQEs to reap or not.
>>
>> -- 
>> Jens Axboe
> 
> You must be seeing something that I'm not. I had a +i in the line,
> should the user_data not increment every item? The line was
> 'sqes[i].user_data = 0x1234+i;'. The 11th iteration is intentional to
> see the value of the memset earlier.

You're not using IORING_SETUP_NO_SQARRAY, hence it's submitting index 0
every time. In other words, you're submitting the same SQE 10 times, not
10 different SQEs. That then yields 10 completions for an SQE with the
same userdata, and hence your CQEs all look identical.

-- 
Jens Axboe

