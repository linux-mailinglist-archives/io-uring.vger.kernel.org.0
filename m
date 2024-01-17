Return-Path: <io-uring+bounces-421-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC8CC830FF1
	for <lists+io-uring@lfdr.de>; Thu, 18 Jan 2024 00:04:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0BB81C2091F
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 23:04:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42FD3286BD;
	Wed, 17 Jan 2024 23:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="k+GkIeKE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6133924B2A
	for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 23:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705532667; cv=none; b=VHDEB5CuwKPACkUV6B37smX43mBghj7GVoiunf+LLCgXwx58dEVzkREzZojSww4GWDYGAg/CUtG36/65jEF/2AMb2u8fYAKk7PFKNDnAK/zV2mnfSfr8cUFZdbdDSa40DxZXosol/7TcisGOoYN0ocR6SxYgBmxmWi1XsvrMDAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705532667; c=relaxed/simple;
	bh=nIy8rn2sGR7SXFwc4gKM4r8s3RaW0NqpXIxGO0LCCnY=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:
	 To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=JvYt2vQ+fvD1yShajxYxg+hLMzjdJpFc3+a5vtb40hW7EkgQUQAkeKroo6jzyCOFCYbxA+iCvP9xbnIJV4htM3V1emmOLPM1+oJWGvxHB5iBoL0UBiL/sGS+0uPeHy0TeriB/ujs07bR7ZHokCuObEFQjx5FZdNnxiP8Ccf9zj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=k+GkIeKE; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7bb5be6742fso111869139f.1
        for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 15:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705532663; x=1706137463; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sKiOkgpupfu/xZ9c0nKrOyJ57HTRtTh2I6NcqVJ0RnM=;
        b=k+GkIeKEvVE2429hv2MldemFuNZhPw825xqk8LcstJ0oCQZwHAOdw95MKPrsg2nZrv
         8vWp453T9KwTbTR+ao3syDa1iE0tqAJ3hYh4a3GnLfGQl5byNgcAP9K1XIseihni1rbB
         vWplUTd+uBwI8BFo0TADaKeS0Nwc5WmqIsmN0RuUujg8+E5SSqOdPfUUvVB1JKDcocjZ
         Is25ESyzwWqncUgPWS4cIMTMl+VWOmEfs6Kc6cQpGcH45KfqkPY+2M636xD+B68hiuin
         j3Es1ef5Ui3xkBXLEhLaUltX+nVWuTyxze3bZOQ8GBHI1umGfoVVqdrufMA6qAerficW
         te/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705532663; x=1706137463;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sKiOkgpupfu/xZ9c0nKrOyJ57HTRtTh2I6NcqVJ0RnM=;
        b=siZwUJp5/iYQcnSIjeUOHqMB+zxn52rPtpse32l9rnd4cGgpUitfpcDN9MLF+5C17V
         suo5tkLqsTKI5CdM1KG6/JK9N9qzF3QH9Vbh0S4d3R6AnsUIwGa5SGduZYxF3LSaU71Z
         9nLL00MJba9w6CkztheI3G6iqVQXiQHdobKaNAv8VEETORJrSy+uYXWfmbiFZkh6jSs9
         x9qCbuae8D8eV9YFUWYkkFPDZFpEFOHWvoe/9Q7AiTp9W6Muix/k5oir4bzrwbA0gp4g
         LY8k59QSBiSwuRW9987yNm+xmf37lCOcJyJdmJfW/1Ae5oUZNT04GxPVq0KL2atGOB1n
         uT0Q==
X-Gm-Message-State: AOJu0YxL1uxtqS2RWLtdou6Hf0+fwp9Ri4EHhkKoazPX8V4Z9tRBfhBt
	qdcrqHwVtGRH4YmlynzPQhuqb2bF6MCvb1XpzgxVi9fn1dgBCKu5w5hUcPxNqy8=
X-Google-Smtp-Source: AGHT+IEUZWtCW1i58OmCKzwJnxtc2X4O+gs7VjFKChLEza/hxLiwtaf8lMHNtIyt5gy4nBKaSN4SLw==
X-Received: by 2002:a5e:d70c:0:b0:7be:edbc:629f with SMTP id v12-20020a5ed70c000000b007beedbc629fmr94956iom.0.1705532663485;
        Wed, 17 Jan 2024 15:04:23 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id s11-20020a056638258b00b0046dda6b83c1sm670895jat.25.2024.01.17.15.04.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 15:04:22 -0800 (PST)
Message-ID: <0a626e1a-939a-44e5-bb82-0275c19f7143@kernel.dk>
Date: Wed, 17 Jan 2024 16:04:22 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] io_uring: Statistics of the true utilization of sq
 threads.
Content-Language: en-US
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
 joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
 ruyi.zhang@samsung.com
References: <e117f6e0-a8bc-4068-8bce-65a7c4e129cf@kernel.dk>
 <CGME20240117084516epcas5p2f0961781ff761ac3a3794c5ea80df45f@epcas5p2.samsung.com>
 <20240117083706.11766-1-xiaobing.li@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240117083706.11766-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/17/24 1:37 AM, Xiaobing Li wrote:
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
> eg?
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
> 
> seq_printf(m, "SqThread:\t%d\n", sq_pid);
> seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
> +seq_printf(m, "SqTotalTime:\t%ldus\n", sq_total_time);
> +seq_printf(m, "SqWorkTime:\t%ldus\n", sq_work_time);
> seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
> 
> The working time of the sqpoll thread is obtained through ktime_get().
> eg?
> 
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

Possibly, can you send an actual patch? Would be easier to review that
way. Bonus points for crafting test cases that can help vet that it
calculates the right thing (eg test case that does 50% idle, 25% idle,
75% idle, that kind of thing).

-- 
Jens Axboe


