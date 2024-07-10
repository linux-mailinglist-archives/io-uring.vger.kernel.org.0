Return-Path: <io-uring+bounces-2487-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 077BC92D7C5
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 19:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BF0D1F2260C
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 17:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C98CC195383;
	Wed, 10 Jul 2024 17:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="biyGnZ9l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6BC194A42;
	Wed, 10 Jul 2024 17:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720633999; cv=none; b=A0TjvDZlZfBhoPsW4qnKNKuHMhX5txTA6y8oefyzdF70ezWrhgY9Ot9EBHcyJu0wV6mgNJPGcxBHd+j+v6+TTXUX+OTXabvzorthU549TnjVJ2kj3U9orGPUz1UPWJg6dBIk0dOhJRumJspIr/SHRCVFqIvHsPI+r8HRK8ryQO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720633999; c=relaxed/simple;
	bh=Xq2De5RSGg1NmnAIQvQ91dbnaUJe8oskkK/ToRdTpeE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ngbHPJ0pKooYiv+5NnbkSrTXHESglDqvM7HqxNoF7GJpY2OVaQwEfy8MCC7XhRMVV6DjwCoA8tNGakpq+N9+qlD03Zd8r9oO41ckMcx0MKIARMOVJviKXePk0I2y0ROJ2HCq+nrf93QsXQnxZrhLy4VOEJKyEWGTjO7Pi2sRit0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=biyGnZ9l; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-585e774fd3dso27510a12.0;
        Wed, 10 Jul 2024 10:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720633996; x=1721238796; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2AkJn534ghJu7YwSCibF8mdGkKnNNVFldDG6paceURc=;
        b=biyGnZ9l3TEXpyQukMWr5jr/C3U69c00pf+XUNiV2W4xCILbfVRXACyvvXQhvnUIh/
         xT1uizaGB7A1cEolCwXDogvt6I3rkHrXzo+PwIuMVLLCjOg63qWt6ho/Ieq4NqjOGw4/
         +mkFjvZINoXsTJ9Q6qLs+4SyA9AdgJzLXHmaU3iq3eG2HhmBx4m4Xd/G2kwdWjxaTH6k
         XrITwr3LL1HvVbB/c9uHtRMbKkkdlvYCcQafK6sSJbrbE7qDPPWalpIQCtR3zLpQE2S8
         5EfnI8UHcz/j3pMI+kUntGLvHKerOSieSRJSR5MUTZIv6pgtxqXXRlZL13A9onaiPMrn
         UAcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720633996; x=1721238796;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2AkJn534ghJu7YwSCibF8mdGkKnNNVFldDG6paceURc=;
        b=AWWqLKbHQvD1WOLLzLPo3FV9w1EzbE6TOVs2PhrE+Poc8DIQHEUMj75DAQ7H60lzRU
         xN86ICuOGPOZ3JdON0FRGGf59WnaI7Xy8enFDAtRxoAin1qFyXGzX8tLdKAP0VXgWqF4
         GveMMePAni2NywxUNxgg68FGmbxpeTW32OoqB50xi1U5JoSv3hM8OAY10OWxzc9IG6uI
         EQSE2bqaUFMZDM3KEznH25kjEdXHN9AtwughNTLfgEgR7U+UGN0gAikEEgoW8vd3fI4k
         PvB+vhiTqOV33wi+iGRBdu2/B+3l3fDdJbr8Fjkmm0m6yGStb94kpqxOuzkkjQ9y6CL6
         5jpQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8pRL9Kp7fDaV681KyMXqqp/WlT0ONhy5omH7FbofhNrrJ1QAA9ECTNfFbHrjnmXceqbnxd2OYPQJ7aKkJ/7oJjNsZQVR+WlA5C+6U+Rt6acm3j+Da9D9mhy8JjARF78Q3dB89ujg=
X-Gm-Message-State: AOJu0Yziaqhrf4AOegv39AHIkblZnZRaBHc+eFzYGLCSjBbJIV0kyBuE
	bf4pF7t+9AeiauhjDNbKT+jHzUaNXg+fuUSQNPI59CQN9R3xkh1i
X-Google-Smtp-Source: AGHT+IHT7B3oKYmPm0YZHF0+OmcYnvb8qL8CRz0AUI+iyXmC12ZJRRGvbadITN1ppbA4s4ABVVLhng==
X-Received: by 2002:a05:6402:3512:b0:57d:692:92d9 with SMTP id 4fb4d7f45d1cf-594ba98e73amr4587113a12.4.1720633977357;
        Wed, 10 Jul 2024 10:52:57 -0700 (PDT)
Received: from [192.168.42.235] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-594bd459ddasm2452569a12.64.2024.07.10.10.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jul 2024 10:52:56 -0700 (PDT)
Message-ID: <933e7957-7a73-4c9a-87a7-c85b702a3a32@gmail.com>
Date: Wed, 10 Jul 2024 18:53:03 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] kernel: rerun task_work while freezing in
 get_signal()
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, io-uring@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>,
 Tycho Andersen <tandersen@netflix.com>, Thomas Gleixner
 <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
 Julian Orth <ju.orth@gmail.com>, Peter Zijlstra <peterz@infradead.org>
References: <1d935e9d87fd8672ef3e8a9a0db340d355ea08b4.1720368770.git.asml.silence@gmail.com>
 <20240708104221.GA18761@redhat.com>
 <62c11b59-c909-4c60-8370-77729544ec0a@gmail.com>
 <20240709103617.GB28495@redhat.com>
 <658da3fe-fa02-423b-aff0-52f54e1332ee@gmail.com>
 <Zo1ntduTPiF8Gmfl@slm.duckdns.org> <20240709190743.GB3892@redhat.com>
 <d2667002-1631-4f42-8aad-a9ea56c0762b@gmail.com>
 <20240709193828.GC3892@redhat.com>
 <d9c00f01-576c-46cd-a88c-76e244460dac@gmail.com>
 <Zo3bt3AJHSG5rVnZ@slm.duckdns.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zo3bt3AJHSG5rVnZ@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/10/24 01:54, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jul 09, 2024 at 08:55:43PM +0100, Pavel Begunkov wrote:
> ...
>>>> CRIU, I assume. I'll try it ...
>>>
>>> Than I think we can forget about task_works and this patch. CRIU dumps
>>> the tasks in TASK_TRACED state.
>>
>> And would be hard to test, io_uring (the main source of task_work)
>> is not supported
>>
>> (00.466022) Error (criu/proc_parse.c:477): Unknown shit 600 (anon_inode:[io_uring])
>> ...
>> (00.467642) Unfreezing tasks into 1
>> (00.467656)     Unseizing 15488 into 1
>> (00.468149) Error (criu/cr-dump.c:2111): Dumping FAILED.
> 
> Yeah, the question is: If CRIU is to use cgroup freezer to freeze the tasks
> and then go around tracing each to make dump, would the freezer be enough in
> avoiding interim state changes? Using CRIU implementation is a bit arbitrary
> but I think checkpoint-restart is a useful bar to measure what should stay
> stable while a cgroup is frozen.

Sounds like in the long run we might want to ignore task_work while
it's frozen, but hard to say for all task_work users.

-- 
Pavel Begunkov

