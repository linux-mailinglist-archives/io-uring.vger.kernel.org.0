Return-Path: <io-uring+bounces-423-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB81D831199
	for <lists+io-uring@lfdr.de>; Thu, 18 Jan 2024 03:58:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70F87284C14
	for <lists+io-uring@lfdr.de>; Thu, 18 Jan 2024 02:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 395E753A8;
	Thu, 18 Jan 2024 02:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6hJIbuJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0142F38;
	Thu, 18 Jan 2024 02:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705546715; cv=none; b=BwjYp3L4TOlnu7Rli590/TcghBjLObD5USJG0axj3ZtguX26eNHlTxe+PazuMbW1yfobiwkHargZcP+6Vzd8jMjQE3W2vc9p/r1IVuG4R4cEF0OXVeeva4auIYQ1qdTmAhWTL/QMCUfed+7z7Ute2P+kaHwQJ7aZa/n8T3zaMak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705546715; c=relaxed/simple;
	bh=ptDDxqi9ai0mSu+Viwu8VChjR49X5ys2oRJkEXp/M0k=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=kkNz+Rie/jxAD3Wg3z6kJ0uD9/gRPFhbtPskERiFbsdqd6o/idO6IuakH5E95FDJKiXXj3oeztw/dutHiRMbukLApTwXHzNDBKzMh/oVYJBc8u1LDYEGXG9iqt1bqKi39jaCBb5bzcM5NCrbh0z4BNFbyzTNP+rHqw/547pawl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O6hJIbuJ; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-40e8d3b32eeso9468335e9.1;
        Wed, 17 Jan 2024 18:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705546711; x=1706151511; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lmS8hsrnFfM30GV9w0Fu6Ej0srTZRziSKaA98H/KigQ=;
        b=O6hJIbuJNoH+2Rph3dM2bsGA8VxkMm2jRYF2K1BTUlMPxAtT7ERrgNKvG/PJ8M0unW
         8IQbKkMRYrL2fCYlEBPizxEZwUXQOYs5qZEu++RVOWuWweR4gNyUXfMU2KGcxY/QjvyT
         //Cb+nXzbhuph1rKSgUb4ZWOYP/NNkWfxLrwM3QFzvuJvuWaux4OLR+sIYUoIx40WZ1P
         26uA/kEZrs9JpjBB2mR6mfYuyMvB+rRG6lJ39T0MEZQtnEJcWKYlWw53swf2+DsU41Lk
         o1RE2yZI35kNcq9DlcyT1ByPPxsWlG/wk6MZmlayrxxDEi6M2HXqjFye6C8gswKTCciq
         XcKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705546711; x=1706151511;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lmS8hsrnFfM30GV9w0Fu6Ej0srTZRziSKaA98H/KigQ=;
        b=u6/Mx1bBEx2/i/2Os5Bd7Lo0+4FAvXcWOf6+ol+4G31404UQgNo69/K5nuFiRvXHTB
         3uWuhpAIeHqs5wUwyEfa5lHlz5yiNIJ3dEME9o34JKs7FFespr+LxrVCSIAJVHmKjr7i
         x05y6Zp2uMDfORVhoRiWC0Y83DNi9yohcpUhG6COLmWNsZIsZ7pXsm0cDZvDjWp0Xn1s
         L86H76Eg3Xlgj32msk3L2Ql5EBOCVdHdh7DNqKdvjVsUkydWR9kTDOuXkw7jpphVSLq0
         kDbbjPGxllEkBShRGgi9DQ3YNTkBL9/gtErRUEM4fZLAZHxE2T+dn1ItjSCyO3BrDa/3
         P9Jg==
X-Gm-Message-State: AOJu0Yxeo7wqqx8IC17u1cYOGAyW+u9LRN+JOVgtlitfyF2uIha0um7J
	Dr52Mx4+W3D9uGkMTm/yCz3UZaUOSWpUx3SXddOsrD4KRqhXarADte7E5xvo
X-Google-Smtp-Source: AGHT+IGWxlj83bcCPiU6HaMB+hDowVXv8gMkMtRdTrmjx1jASrFekpHiLFEfHryVOUStBGohV7i+RA==
X-Received: by 2002:a7b:c349:0:b0:40e:4a76:2b74 with SMTP id l9-20020a7bc349000000b0040e4a762b74mr79543wmj.165.1705546711261;
        Wed, 17 Jan 2024 18:58:31 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.25])
        by smtp.gmail.com with ESMTPSA id v21-20020a05600c445500b0040e3bdff98asm27791945wmn.23.2024.01.17.18.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 18:58:31 -0800 (PST)
Message-ID: <01dc95c9-a327-4310-9b70-6fcb977db3d9@gmail.com>
Date: Thu, 18 Jan 2024 02:56:26 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] io_uring: Statistics of the true utilization of sq
 threads.
To: Xiaobing Li <xiaobing.li@samsung.com>, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com
References: <e117f6e0-a8bc-4068-8bce-65a7c4e129cf@kernel.dk>
 <CGME20240117084516epcas5p2f0961781ff761ac3a3794c5ea80df45f@epcas5p2.samsung.com>
 <20240117083706.11766-1-xiaobing.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240117083706.11766-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/17/24 08:37, Xiaobing Li wrote:
> On 1/12/24 2:58 AM, Jens Axboe wrote:
>> On 1/11/24 6:12 PM, Xiaobing Li wrote:
>>> On 1/10/24 16:15 AM, Jens Axboe wrote:
>>>> On 1/10/24 2:05 AM, Xiaobing Li wrote:
>>>>> On 1/5/24 04:02 AM, Pavel Begunkov wrote:
>>>>>> On 1/3/24 05:49, Xiaobing Li wrote:
>>>>>>> On 12/30/23 9:27 AM, Pavel Begunkov wrote:
>>>>>>>> Why it uses jiffies instead of some task run time?
>>>>>>>> Consequently, why it's fine to account irq time and other
>>>>>>>> preemption? (hint, it's not)
>>>>>>>>
>>>>>>>> Why it can't be done with userspace and/or bpf? Why
>>>>>>>> can't it be estimated by checking and tracking
>>>>>>>> IORING_SQ_NEED_WAKEUP in userspace?
>>>>>>>>
>>>>>>>> What's the use case in particular? Considering that
>>>>>>>> one of the previous revisions was uapi-less, something
>>>>>>>> is really fishy here. Again, it's a procfs file nobody
>>>>>>>> but a few would want to parse to use the feature.
>>>>>>>>
>>>>>>>> Why it just keeps aggregating stats for the whole
>>>>>>>> life time of the ring? If the workload changes,
>>>>>>>> that would either totally screw the stats or would make
>>>>>>>> it too inert to be useful. That's especially relevant
>>>>>>>> for long running (days) processes. There should be a
>>>>>>>> way to reset it so it starts counting anew.
>>>>>>>
>>>>>>> Hi, Jens and Pavel,
>>>>>>> I carefully read the questions you raised.
>>>>>>> First of all, as to why I use jiffies to statistics time, it
>>>>>>> is because I have done some performance tests and found that
>>>>>>> using jiffies has a relatively smaller loss of performance
>>>>>>> than using task run time. Of course, using task run time is
>>>>>>
>>>>>> How does taking a measure for task runtime looks like? I expect it to
>>>>>> be a simple read of a variable inside task_struct, maybe with READ_ONCE,
>>>>>> in which case the overhead shouldn't be realistically measurable. Does
>>>>>> it need locking?
>>>>>
>>>>> The task runtime I am talking about is similar to this:
>>>>> start = get_system_time(current);
>>>>> do_io_part();
>>>>> sq->total_time += get_system_time(current) - start;
>>>>
>>>> Not sure what get_system_time() is, don't see that anywhere.
>>>>
>>>>> Currently, it is not possible to obtain the execution time of a piece of
>>>>> code by a simple read of a variable inside task_struct.
>>>>> Or do you have any good ideas?
>>>>
>>>> I must be missing something, because it seems like all you need is to
>>>> read task->stime? You could possible even make do with just logging busy
>>>> loop time, as getrusage(RUSAGE_THREAD, &stat) from userspace would then
>>>> give you the total time.
>>>>
>>>> stat.ru_stime would then be the total time, the thread ran, and
>>>> 1 - (above_busy_stime / stat.ru_stime) would give you the time the
>>>> percentage of time the thread ran and did useful work (eg not busy
>>>> looping.
>>>
>>> getrusage can indeed get the total time of the thread, but this
>>> introduces an extra function call, which is relatively more
>>> complicated than defining a variable. In fact, recording the total
>>> time of the loop and the time of processing the IO part can achieve
>>> our observation purpose. Recording only two variables will have less
>>> impact on the existing performance, so why not  choose a simpler and
>>> effective method.
>>
>> I'm not opposed to exposing both of them, it does make the API simpler.
>> If we can call it an API... I think the main point was using task->stime
>> for it rather than jiffies etc.
> 
> Hi, Jens and Pavel
> I modified the code according to your opinions.
> 
> I got the total time of the sqpoll thread through getrusage.
> eg：
> 
> fdinfo.c:
> +long sq_total_time = 0;
> +long sq_work_time = 0;
> if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
> 	struct io_sq_data *sq = ctx->sq_data;
> 
> 	sq_pid = sq->task_pid;
> 	sq_cpu = sq->sq_cpu;
> +	struct rusage r;
> +	getrusage(sq->thread, RUSAGE_SELF, &r);
> +	sq_total_time = r.ru_stime.tv_sec * 1000000 + r.ru_stime.tv_usec;
> +	sq_work_time = sq->work_time;
> }

That's neat, but fwiw my concerns are mostly about what's
exposed to the user space.

> seq_printf(m, "SqThread:\t%d\n", sq_pid);
> seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
> +seq_printf(m, "SqTotalTime:\t%ldus\n", sq_total_time);
> +seq_printf(m, "SqWorkTime:\t%ldus\n", sq_work_time);
> seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
> 
> The working time of the sqpoll thread is obtained through ktime_get().
> eg：

Just like with jiffies, ktime_get() is wall clock time, but
uncomfortably much more expensive. Why not stime Jens dug up
last time?

> sqpoll.c:
> +ktime_t start, diff;
> +start = ktime_get();
> list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> 	int ret = __io_sq_thread(ctx, cap_entries);
> 
> 	if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
> 		sqt_spin = true;
> }
> if (io_run_task_work())
> 	sqt_spin = true;
> 
> +diff = ktime_sub(ktime_get(), start);
> +if (sqt_spin == true)
> +	sqd->work_time += ktime_to_us(diff);
> 
> The test results are as follows:
> Every 2.0s: cat /proc/9230/fdinfo/6 | grep -E Sq
> SqMask: 0x3
> SqHead: 3197153
> SqTail: 3197153
> CachedSqHead:   3197153
> SqThread:       9231
> SqThreadCpu:    11
> SqTotalTime:    92215321us
> SqWorkTime:     15106578us
> 
> Do you think this solution work?

I'm curious, is the plan to leave it only accessible via
procfs? It's not machine readable well, so should be quite
an annoyance parsing it every time.

-- 
Pavel Begunkov

