Return-Path: <io-uring+bounces-389-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0099482AF99
	for <lists+io-uring@lfdr.de>; Thu, 11 Jan 2024 14:23:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87879281B65
	for <lists+io-uring@lfdr.de>; Thu, 11 Jan 2024 13:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85BEB1772B;
	Thu, 11 Jan 2024 13:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GkE+6dYm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAFB38DF4;
	Thu, 11 Jan 2024 13:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-40e60e135a7so4268655e9.0;
        Thu, 11 Jan 2024 05:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704979339; x=1705584139; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sDkpti5QnC20mGTE6Quk7MeID3t58utIY/P3B/Bf2Go=;
        b=GkE+6dYmsRQ0QJHsxs77Ws3Rv7OUk3xKxEacg9twj521ty1sre6ccWlQR5zEddL55L
         yqtloLusw83a0qJHTrQHpUSmzjI1g7r6cCCLv5qoZa8/e0xBSadIi+uvJ3CLXtzesoMR
         dUAFmLN68OEuvKu+kBPHn/fxSNFk7ti1bdMbkTJkEMRbWK3rGPiC6CkZf/JvDqrvj4oP
         4Q1kf6vVLIKJUSJgESm6D2MltgY2YKX4p0PhbkKYlEKuXRxmgts6elhVYiXL6m48AVX+
         0Nn7DiXA7QF0Yz1WiLlMHP6VOQd7CaaBCh+dNE980MjrTOfIOUnJx0PgVsGrSI0uuDRT
         rPRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704979339; x=1705584139;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sDkpti5QnC20mGTE6Quk7MeID3t58utIY/P3B/Bf2Go=;
        b=C1CYdrvrwTkDU2xecyVKIw6hoQ0FUz3/XOoWRhUt68Efdh4FdB8oZyFIl2KhACuAxs
         BcLqbb+roI2STNrA5Ik2wKepaDl6GjvQwC0/ekX3QMV3A5zhLc37sraUm8x7N0GixxzU
         55dp7m84NEL8+e5TT6OCAdY2J7eKH6Oiiy1SKvobZjAQ+hhAzmV6eSHvmkIj1l2Kq9cg
         hMiRXFzFp1bY47BO69d+lI7Gisw0P8T9yMEUEo3pqZG4RQ8x9Jorm24dBabKBGn/UESO
         jBqj5lB2x/OGMo55rQqKzVPbfWHjIZAgo4wzod56JmSD3fU9uojadA28i7x+UGsWy4+4
         NiMQ==
X-Gm-Message-State: AOJu0Yzq3ANq70E3SRWKdObKRXqAwGAm5/6MlGqAgqT7/utiTEyASXaS
	rinWztS9jQQBBsb9EAQEiDTsgIg8BHw=
X-Google-Smtp-Source: AGHT+IG8TJ20wwkiN5fvnJyYn2Xy5/6wc+hbl93MAAiRwbX/x1uENpBozNWS/ndF2kUI+Ib+8lG6lA==
X-Received: by 2002:a05:600c:4e91:b0:40e:532c:7cb1 with SMTP id f17-20020a05600c4e9100b0040e532c7cb1mr505653wmq.125.1704979338631;
        Thu, 11 Jan 2024 05:22:18 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::1:18af])
        by smtp.gmail.com with ESMTPSA id fl13-20020a05600c0b8d00b0040d8cd116e4sm5854091wmb.37.2024.01.11.05.22.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jan 2024 05:22:18 -0800 (PST)
Message-ID: <bd9b3982-95ca-4789-a3d5-6c456083248b@gmail.com>
Date: Thu, 11 Jan 2024 13:12:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] io_uring: Statistics of the true utilization of sq
 threads.
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com
References: <c9505525-54d9-4610-a47a-5f8d2d3f8de6@gmail.com>
 <CGME20240110091327epcas5p493e0d77a122a067b6cd41ecbf92bd6eb@epcas5p4.samsung.com>
 <20240110090523.1612321-1-xiaobing.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240110090523.1612321-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/24 09:05, Xiaobing Li wrote:
> On 1/5/24 04:02 AM, Pavel Begunkov wrote:
>> On 1/3/24 05:49, Xiaobing Li wrote:
>>> On 12/30/23 9:27 AM, Pavel Begunkov wrote:
>>>> Why it uses jiffies instead of some task run time?
>>>> Consequently, why it's fine to account irq time and other
>>>> preemption? (hint, it's not)
>>>>
>>>> Why it can't be done with userspace and/or bpf? Why
>>>> can't it be estimated by checking and tracking
>>>> IORING_SQ_NEED_WAKEUP in userspace?
>>>>
>>>> What's the use case in particular? Considering that
>>>> one of the previous revisions was uapi-less, something
>>>> is really fishy here. Again, it's a procfs file nobody
>>>> but a few would want to parse to use the feature.
>>>>
>>>> Why it just keeps aggregating stats for the whole
>>>> life time of the ring? If the workload changes,
>>>> that would either totally screw the stats or would make
>>>> it too inert to be useful. That's especially relevant
>>>> for long running (days) processes. There should be a
>>>> way to reset it so it starts counting anew.
>>>
>>> Hi, Jens and Pavel,
>>> I carefully read the questions you raised.
>>> First of all, as to why I use jiffies to statistics time, it
>>> is because I have done some performance tests and found that
>>> using jiffies has a relatively smaller loss of performance
>>> than using task run time. Of course, using task run time is
>>
>> How does taking a measure for task runtime looks like? I expect it to
>> be a simple read of a variable inside task_struct, maybe with READ_ONCE,
>> in which case the overhead shouldn't be realistically measurable. Does
>> it need locking?
> 
> The task runtime I am talking about is similar to this:
> start = get_system_time(current);
> do_io_part();
> sq->total_time += get_system_time(current) - start;
> 
> Currently, it is not possible to obtain the execution time of a piece of
> code by a simple read of a variable inside task_struct.
> Or do you have any good ideas?

Jens answered it well

>>> indeed more accurate.  But in fact, our requirements for
>>> accuracy are not particularly high, so after comprehensive
>>
>> I'm looking at it as a generic feature for everyone, and the
>> accuracy behaviour is dependent on circumstances. High load
>> networking spends quite a good share of CPU in softirq, and
>> preemption would be dependent on config, scheduling, pinning,
>> etc.
> 
> Yes, I quite agree that the accuracy behaviour is dependent on circumstances.
> In fact, judging from some test results we have done, the current solution
> can basically meet everyone's requirements, and the error in the calculation
> result of utilization is estimated to be within 0.5%.

Which sounds more than fine, but there are cases where irqs are
eating up 10s of percents of CPU, which is likely to be more
troublesome.

>>> consideration, we finally chose to use jiffies.
>>> Of course, if you think that a little more performance loss
>>> here has no impact, I can use task run time instead, but in
>>> this case, does the way of calculating sqpoll thread timeout
>>> also need to be changed, because it is also calculated through
>>> jiffies.
>>
>> That's a good point. It doesn't have to change unless you're
>> directly inferring the idle time parameter from those two
>> time values rather than using the ratio. E.g. a simple
>> bisection of the idle time based on the utilisation metric
>> shouldn't change. But that definitely raises the question
>> what idle_time parameter should exactly mean, and what is
>> more convenient for algorithms.
> 
> We think that idle_time represents the time spent by the sqpoll thread
> except for submitting IO.

I mean the idle_time parameter, i.e.
struct io_uring_params :: sq_thread_idle, which is how long an SQPOLL
thread should be continuously starved of any work to go to sleep.

For example:
sq_thread_idle = 10ms

   -> 9ms starving -> (do work) -> ...
   -> 9ms starving -> (do work) -> ...
   -> 11ms starving -> (more than idle, go sleep)

And the question was whether to count those delays in wall clock
time, as it currently is, and which is likely to be more natural
for userspace, or otherwise theoretically it could be task local time.
  

> In a ring, it may take time M to submit IO, or it may not submit IO in the
> entire cycle. Then we can optimize the efficiency of the sqpoll thread in
> two directions. The first is to reduce the number of rings that no IO submit,
> The second is to increase the time M to increase the proportion of time
> submitted IO in the ring.
> In order to observe the CPU ratio of sqthread's actual processing IO part,
> we need this patch.

-- 
Pavel Begunkov

