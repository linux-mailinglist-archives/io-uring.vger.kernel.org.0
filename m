Return-Path: <io-uring+bounces-11013-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 96AADCB5A01
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 12:19:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 28DBD3007264
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 11:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FEFD2D9EF4;
	Thu, 11 Dec 2025 11:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JWQE536z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6647F29C351
	for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 11:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765451980; cv=none; b=QBtZ6rKI4XGI2wADu33fs1hXSGaIJRS9cdtq1T6DJ6j5K1E77GxuU86iKLS9NtiHW4ET8jkvugh02v2Z/E71rg1i1GIgq5hTEQIsAPOnUxksef9ZmG/kKh6h5okVEGAZzKbK2rG7BwxuG32OM+f8PQupr3Z8C3Eddt6Ze9nRpR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765451980; c=relaxed/simple;
	bh=gLC5FL2CQeUhlYvN5NDEaqSv365JQIExChqFWRdvits=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ah6tuxpf80CFSFYncRrHGfv2gFcpmbGO8yhihF8QSJu6PRxZVOfxyJgUrz7s/jD+54zj3scHsDCnuIWjKlL+HYICIBtxep8n8wtIeAamDg5fOkoD44J24fIB6cRoGFyhgpoNo9YFNMuXbn6MfHLJxfGF60L+gPSSOu9hDxcVl4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JWQE536z; arc=none smtp.client-ip=209.85.215.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-c05d66dbab2so860634a12.0
        for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 03:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765451976; x=1766056776; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a1pPoW64yHO2FAq4ZSUJsw3oLxF6tPrjN6IopcTo1lQ=;
        b=JWQE536z8mNUBA93lK4FRs3nO37/t8UekAbeNmHU2qeCCSR02+bx+MgaxIGoprOQfo
         s4shdLfkAHyJ5nhBO7vBaltcd5S+M0o8uqMSeaTMIWYHfJ6voUJe+MJ3sOlUnx794D/o
         GlTHGayCH3GHR0eWVZ6xsoUSqIZyLP9hgUgobx832VI5rXVkbIUlUJfp0tdTXSo/hrGG
         bzfWFe66dyH44D0J0Si6i0yYd6qevMEs9GgC/X9hI70XhoDrFhkphaSvtoPr8jSBT1y/
         Mo2UEsOxqXIzL2zmX8qqeGytJvr6sy0ziwyo2q10xOHcTFjHylvv1FxqqBRkohwkjYjf
         VTDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765451976; x=1766056776;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a1pPoW64yHO2FAq4ZSUJsw3oLxF6tPrjN6IopcTo1lQ=;
        b=HE4I8EaM+T5btnzl5qSQbCx8oVGeuV2QDUVl44ZRaflJ9m84EH9Q8MTbSCIogqj7Uw
         DqBxLN/daRolJ3/b88jbjHqWOwuUjwUh6NC3QTOfh8cm7+WyGEg7LW3tz4daf/k0b/At
         GCh+0XJgxqytmnGJqA376xVtAGLjPbsbzg8mj3AiOQBZTwwZp+LDYUw5n/SlJzl27flM
         YPuKj7mI5ptIW9b17Y5YSiJ5QhOf48v11bfdP4er+2yo+h4jMgQlh4nJsLmONyT+zEK7
         uxfFykTotG+HqwDN4IwVvbfDBSphrD8MfI6TBfyhVaXXcPtg4qVHLwT7HFAlkxuz7yEQ
         9Z2w==
X-Forwarded-Encrypted: i=1; AJvYcCXIXX5vY0fvaHfLIP5ejTvvAGgYG9YjkuyeO7EkiWwVR8ObwQEF9lYl08VaZS0s5tgxP/lezBuJ9Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywas1waO6JufSm8NWOxwaKlGwyi+YoFzIFKXCExMZ+zVQaXeI5c
	FR35y+A23e1Px8wxPIT+QS9fzQdGtbctKSu6otF2iTPj60YOjLDFN5BYxG4OYWrOomO2pV8JIUV
	vTk3xHFHn8cv5
X-Gm-Gg: AY/fxX42dYfd5IZPQVVkgezaXRQyVZqFDkSictDCF7wcu4016EDLblcZkAGZgBo7Qss
	h7sAOkEOLhxvSTnGt+8VTwpbT/Eyxown2LOc9UPBkPoQ9K5vd4heWBcedxk4bXF4ZSGiQu6gy29
	2M77mcs29MWXovMJ0tmkUTixI7byUfAMXqbwuUhRG0yE5w9W1eUpNfkZjqruZfGb5ov/eoRi3zI
	/VQKkBQ6JhYiop2/ddYRv8Te20WHKREB+vLYMreCJM5nt3qwGfHNso7JiesxnjSRqApIML3/UDd
	RILgU64V7FmMr9TDJEstXahS7AUDEwjfgYdAm1h/i8Acd5gn8wSp16NJRKzDl6wPoRqpfBlRfpq
	kik0crGy6VG2dTTuYDg1snztz54ThSxYFuV6pjEMnKXiCdBUQjCX/yj0J0t+Im9kjh5tDF7sGxi
	nu4nq+3UeexPFKav8w4JCobH/uKfNjuIywwghtjHB8ddj/LUd82Q==
X-Google-Smtp-Source: AGHT+IGcKXSV92bQFMCz/fZRuCi59pEqeGNKKU64MVv/hBuoq0yPVC8UvrQF+bJx/WqybOHLoqGQpw==
X-Received: by 2002:a05:7022:6199:b0:11b:98e8:6274 with SMTP id a92af1059eb24-11f2967d817mr4238781c88.13.1765451975567;
        Thu, 11 Dec 2025 03:19:35 -0800 (PST)
Received: from [172.20.4.188] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e1bb3b4sm6944937c88.4.2025.12.11.03.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 03:19:34 -0800 (PST)
Message-ID: <545bf70d-0155-49e7-9356-d296d9c17562@kernel.dk>
Date: Thu, 11 Dec 2025 04:19:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
To: Fengnan Chang <fengnanchang@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
 Diangang Li <lidiangang@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
 <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
 <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
 <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com>
 <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk>
 <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk>
 <9a63350f-b599-4f00-8d0b-4da2dbe99fc2@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9a63350f-b599-4f00-8d0b-4da2dbe99fc2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/11/25 4:13 AM, Fengnan Chang wrote:
> 
> 
> ? 2025/12/11 18:33, Jens Axboe ??:
>> On 12/11/25 3:22 AM, Jens Axboe wrote:
>>> On 12/11/25 12:38 AM, Fengnan wrote:
>>>>
>>>> ? 2025/12/11 12:10, Jens Axboe ??:
>>>>> On 12/10/25 7:15 PM, Jens Axboe wrote:
>>>>>> On 12/10/25 1:55 AM, Fengnan Chang wrote:
>>>>>>> In the io_do_iopoll function, when the poll loop of iopoll_list ends, it
>>>>>>> is considered that the current req is the actual completed request.
>>>>>>> This may be reasonable for multi-queue ctx, but is problematic for
>>>>>>> single-queue ctx because the current request may not be done when the
>>>>>>> poll gets to the result. In this case, the completed io needs to wait
>>>>>>> for the first io on the chain to complete before notifying the user,
>>>>>>> which may cause io accumulation in the list.
>>>>>>> Our modification plan is as follows: change io_wq_work_list to normal
>>>>>>> list so that the iopoll_list list in it can be removed and put into the
>>>>>>> comp_reqs list when the request is completed. This way each io is
>>>>>>> handled independently and all gets processed in time.
>>>>>>>
>>>>>>> After modification,  test with:
>>>>>>>
>>>>>>> ./t/io_uring -p1 -d128 -b4096 -s32 -c32 -F1 -B1 -R1 -X1 -n1 -P1
>>>>>>> /dev/nvme6n1
>>>>>>>
>>>>>>> base IOPS is 725K,  patch IOPS is 782K.
>>>>>>>
>>>>>>> ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 -P1
>>>>>>> /dev/nvme6n1
>>>>>>>
>>>>>>> Base IOPS is 880k, patch IOPS is 895K.
>>>>>> A few notes on this:
>>>>>>
>>>>>> 1) Manipulating the list in io_complete_rw_iopoll() I don't think is
>>>>>>      necessarily safe. Yes generally this is invoked from the
>>>>>>      owning/polling task, but that's not guaranteed.
>>>>>>
>>>>>> 2) The patch doesn't apply to the current tree, must be an older
>>>>>>      version?
>>>>>>
>>>>>> 3) When hand-applied, it still throws a compile warning about an unused
>>>>>>      variable. Please don't send untested stuff...
>>>>>>
>>>>>> 4) Don't just blatantly bloat the io_kiocb. When you change from a
>>>>>>      singly to a doubly linked list, you're growing the io_kiocb size. You
>>>>>>      should be able to use a union with struct io_task_work for example.
>>>>>>      That's already 16b in size - win/win as you don't need to slow down
>>>>>>      the cache management as that can keep using the linkage it currently
>>>>>>      is using, and you're not bloating the io_kiocb.
>>>>>>
>>>>>> 5) The already mentioned point about the cache free list now being
>>>>>>      doubly linked. This is generally a _bad_ idea as removing and adding
>>>>>>      entries now need to touch other entries too. That's not very cache
>>>>>>      friendly.
>>>>>>
>>>>>> #1 is kind of the big one, as it means you'll need to re-think how you
>>>>>> do this. I do agree that the current approach isn't necessarily ideal as
>>>>>> we don't process completions as quickly as we could, so I think there's
>>>>>> merrit in continuing this work.
>>>>> Proof of concept below, entirely untested, at a conference. Basically
>>>>> does what I describe above, and retains the list manipulation logic
>>>>> on the iopoll side, rather than on the completion side. Can you take
>>>>> a look at this? And if it runs, can you do some numbers on that too?
>>>> This patch works, and in my test case, the performance is identical to
>>>> my patch.
>>> Good!
>>>
>>>> But there is a small problem, now looking for completed requests,
>>>> always need to traverse the whole iopoll_list. this can be a bit
>>>> inefficient in some cases, for example if the previous sent 128K io ,
>>>> the last io is 4K, the last io will be returned much earlier, this
>>>> kind of scenario can not be verified in the current test. I'm not sure
>>>> if it's a meaningful scenario.
>>> Not sure that's a big problem, you're just spinning to complete anyway.
>>> You could add your iob->nr_reqs or something, and break after finding
>>> those know have completed. That won't necessarily change anything, could
>>> still be the last one that completed. Would probably make more sense to
>>> pass in 'min_events' or similar and stop after that. But I think mostly
>>> tweaks that can be made after the fact. If you want to send out a new
>>> patch based on the one I sent, feel free to.
>> Eg, something like this on top would do that. Like I mentioned earlier,
>> you cannot do the list manipulation where you did it, it's not safe. You
>> have to defer it to reaping time. If we could do it from the callback
>> where we mark it complete, then that would surely make things more
>> trivial and avoid iteration when not needed.
> 
> Yes, it's not safe do the list manipulation in io_complete_rw_iopoll.
> It looks more reasonable with the following modifications.
> Your changes look good enough, but please give me more time, I'd
> like to do some more testing and rethink this.

Of course, there's no rush - we're in the merge window anyway, so this
will be targeted for 6.20/7.0 either way.

-- 
Jens Axboe

