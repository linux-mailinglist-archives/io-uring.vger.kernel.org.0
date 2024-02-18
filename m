Return-Path: <io-uring+bounces-621-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A8C859700
	for <lists+io-uring@lfdr.de>; Sun, 18 Feb 2024 14:00:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 484AB281D54
	for <lists+io-uring@lfdr.de>; Sun, 18 Feb 2024 13:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 184FB6BFBA;
	Sun, 18 Feb 2024 13:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wsUtZUUM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDE56BFDB
	for <io-uring@vger.kernel.org>; Sun, 18 Feb 2024 13:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708261227; cv=none; b=G/17py4yzu5xfRBXb0qN+UAjFC51hVA21xrgCM4k09TIAZGRvVVB+IYKrnt8mvF9xoNvRWHahGrNZpcWCVyIM4oWAGuPNn/3BG31/A3oTNuj6mF0DCiWr9g8QOTAQIRZHYGQNL8nlyL+x0Fo5wVgq1fOFQkVu788A79L7uS2Hys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708261227; c=relaxed/simple;
	bh=hRiD6dLKoUyrGjRFujHiRdx70/odMTcB4P8yipX7AkE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k8QupUSjgSdQVsnjhhfOBsJiACMj2WfPhL1GbmJW3kySLMqLFWiaRTye7nzhmWo/ytd86zwi67vRIJLF4oK4fCc/bPgCoO+P8W7ByYISsoWEZoLt0mcLZsQH0Hg1qgiC+ehGIJNBgGLlzx+Y+wnPRk/PJUJwTCM5xW98vamyAYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wsUtZUUM; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-29593a27fcaso987669a91.1
        for <io-uring@vger.kernel.org>; Sun, 18 Feb 2024 05:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708261211; x=1708866011; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5DawyGrCFv8MWM89ldx7BIpHWYPaoK4RaQ5rwdaLsT0=;
        b=wsUtZUUMjTpUb8qpLctVUTL45iv/OHM0cIZj/jyBrT8Wb5vf9n/hpBBeBhfS9/fspA
         uGfZElHERt7d55UyCgGTcSka0bpl2VMyGxoFyH74CBDik8wFTKsnWeUu8ORqM6gRyG1U
         lE2fq5lpWh4WPRPQ1oaf8CgpEvRkJptQo5nmmbTdkazHiVXYwJbHm5m7yQgFBVWXcLF0
         zj/jPF0aZlHka87tRVLWy0ND20no1o6OLS4OT45ehidUdJQXg/1ZEov84kdIf4IlZN1T
         dRZ44EY4c7GLnUEyRK8HwI+4ijI9An4UgjrKkRr8WKgz3k5XNNDeS1kEtCD+9+8giYP8
         qhVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708261211; x=1708866011;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5DawyGrCFv8MWM89ldx7BIpHWYPaoK4RaQ5rwdaLsT0=;
        b=JvXhIfpFOtcFCBnQrZDB9gqkpVYM/DmoSFOTo0Fh45M+BoyjVV00IRnMWNW0OKZa9z
         T4HN0608NH2ywbAiwpZcH2yizkPMV/Z0ef5YuT38iGO2Fhg4SzoxDIS4ecaMk1jA/8jr
         +w6y5czO9I2QYOjykkSrECGBBaa5UVU8hQ6xPBa8e8x0hldHDCDJbSKSQFIg8j2ytzzJ
         +GEyM7dvuo4PV+kpvOTdHB8Biw/yianxrkjy6nCWs5GOc0NtvrLtBdL7YNort0+PLU/f
         KKCJK/B+oBgK9emsiHdPrUiLBhDdx59x0YQLjTip+2Sy3PPAGFWqfTnkAQnOHFxUFiBp
         mZ6w==
X-Forwarded-Encrypted: i=1; AJvYcCW3pIb+5bDyCvTgdlJix72Lyq/XU1eAonY5BfFf6oGzUhZ5zn+YmruVyBsCnizQZbdoouPL/usI8jVRfUUQiPOQueoU+Tzfm/A=
X-Gm-Message-State: AOJu0Ywa9A5RZ/Mk/S87GUWlbQxKgnPeK+Bjc+bfEmyds70ixN70msuT
	P9Z2aP3peWF0gXMOlZswwFXCWglMT/eUU8y8xF/pj7e3DDvmia5uLcqt7EBvhYI=
X-Google-Smtp-Source: AGHT+IGVFIzcZQSKZ28IfoCt8YS0LbF/Ky/GXgEYfked2me8fWHg4mU85AYxlUGNZG6fuYO4ZwYzeg==
X-Received: by 2002:a05:6a21:1a4:b0:1a0:810e:5f40 with SMTP id le36-20020a056a2101a400b001a0810e5f40mr10357528pzb.4.1708261211014;
        Sun, 18 Feb 2024 05:00:11 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id 18-20020a631052000000b005d553239b16sm2906268pgq.20.2024.02.18.05.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Feb 2024 05:00:10 -0800 (PST)
Message-ID: <522c03d9-a8ba-459d-9f7c-dfbf461dcf6b@kernel.dk>
Date: Sun, 18 Feb 2024 06:00:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] io_uring: Statistics of the true utilization of sq
 threads.
Content-Language: en-US
To: Xiaobing Li <xiaobing.li@samsung.com>, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
 cliang01.li@samsung.com, xue01.he@samsung.com
References: <CGME20240206024726epcas5p1d90e29244e62ede67813da5fcd582151@epcas5p1.samsung.com>
 <20240206023910.11307-1-xiaobing.li@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240206023910.11307-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/5/24 7:39 PM, Xiaobing Li wrote:
> Count the running time and actual IO processing time of the sqpoll
> thread, and output the statistical data to fdinfo.
> 
> Variable description:
> "work_time" in the code represents the sum of the jiffies of the sq
> thread actually processing IO, that is, how many milliseconds it
> actually takes to process IO. "total_time" represents the total time
> that the sq thread has elapsed from the beginning of the loop to the
> current time point, that is, how many milliseconds it has spent in
> total.
> 
> The test tool is fio, and its parameters are as follows:
> [global]
> ioengine=io_uring
> direct=1
> group_reporting
> bs=128k
> norandommap=1
> randrepeat=0
> refill_buffers
> ramp_time=30s
> time_based
> runtime=1m
> clocksource=clock_gettime
> overwrite=1
> log_avg_msec=1000
> numjobs=1
> 
> [disk0]
> filename=/dev/nvme0n1
> rw=read
> iodepth=16
> hipri
> sqthread_poll=1
> 
> ---

If you put --- in here, then the rest of the commit message disappears.
The way you format commit messages it to put things you don't want in
the git log below it... This one should not be here.

> 
> ---
> The test results corresponding to different iodepths are as follows:

Same with this one...

> |-----------|-------|-------|-------|------|-------|
> |   iodepth |   1   |   4   |   8   |  16  |  64   |
> |-----------|-------|-------|-------|------|-------|
> |utilization| 2.9%  | 8.8%  | 10.9% | 92.9%| 84.4% |
> |-----------|-------|-------|-------|------|-------|
> |    idle   | 97.1% | 91.2% | 89.1% | 7.1% | 15.6% |
> |-----------|-------|-------|-------|------|-------|
> 
> changes?
> v8:

Here you need it, the changelog should be below the one and only --- you
put in the commit message.

>  - Get the work time of the sqpoll thread through getrusage
> 
> v7:
>  - Get the total time of the sqpoll thread through getrusage
>  - The working time of the sqpoll thread is obtained through ktime_get()
> 
> v6:
>  - Replace the percentages in the fdinfo output with the actual running
> time and the time actually processing IO
> 
> v5?
>  - list the changes in each iteration.
> 
> v4?
>  - Resubmit the patch based on removing sq->lock
> 
> v3?
>  - output actual working time as a percentage of total time
>  - detailed description of the meaning of each variable
>  - added test results
> 
> v2?
>  - output the total statistical time and work time to fdinfo
> 
> v1?
>  - initial version
>  - Statistics of total time and work time
> 
> Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>

And since your Signed-off-by is here, it also does not go into the
commit message, which it must.

> index 976e9500f651..18c6f4aa4a48 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -64,6 +64,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>  	unsigned int sq_shift = 0;
>  	unsigned int sq_entries, cq_entries;
>  	int sq_pid = -1, sq_cpu = -1;
> +	u64 sq_total_time = 0, sq_work_time = 0;
>  	bool has_lock;
>  	unsigned int i;
>  
> @@ -147,10 +148,17 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>  
>  		sq_pid = sq->task_pid;
>  		sq_cpu = sq->sq_cpu;
> +		struct rusage r;

Here, and in one other spot, you're mixing variable declarations and
code. Don't do that, they need to be top of that scope and before any
code.

> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 65b5dbe3c850..9155fc0b5eee 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -251,6 +251,9 @@ static int io_sq_thread(void *data)
>  		}
>  
>  		cap_entries = !list_is_singular(&sqd->ctx_list);
> +		struct rusage start, end;
> +
> +		getrusage(current, RUSAGE_SELF, &start);

Ditto, move the variables to the top of the scope.

>  		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>  			int ret = __io_sq_thread(ctx, cap_entries);
>  
> @@ -260,6 +263,11 @@ static int io_sq_thread(void *data)
>  		if (io_run_task_work())
>  			sqt_spin = true;
>  
> +		getrusage(current, RUSAGE_SELF, &end);
> +		if (sqt_spin == true)
> +			sqd->work_time += (end.ru_stime.tv_sec - start.ru_stime.tv_sec) *
> +					1000000 + (end.ru_stime.tv_usec - start.ru_stime.tv_usec);
> +

and this should go in a helper instead. It's trivial code, but the way
too long lines makes it hard to read. Compare the above to eg:

static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
{
       struct rusage end;

       getrusage(current, RUSAGE_SELF, &end);
       end.ru_stime.tv_sec -= start->ru_stime.tv_sec;
       end_ru_stime.tv_usec -= start->ru_stime.tv_usec;

       sqd->work_time += end.ru_stime.tv_usec + end.ru_stime.tv_sec * 1000000;
}

which is so much nicer to look at.

We're already doing an sqt_spin == true check right below, here:

>  		if (sqt_spin || !time_after(jiffies, timeout)) {
>  			if (sqt_spin)
>  				timeout = jiffies + sqd->sq_thread_idle;

why not just put io_sq_update_worktime(sqd, &start); inside this check?

> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
> index 8df37e8c9149..e99f5423a3c3 100644
> --- a/io_uring/sqpoll.h
> +++ b/io_uring/sqpoll.h
> @@ -16,6 +16,7 @@ struct io_sq_data {
>  	pid_t			task_pid;
>  	pid_t			task_tgid;
>  
> +	u64					work_time;
>  	unsigned long		state;
>  	struct completion	exited;
>  };

Not sure why this addition is indented differently than everything else
in there?

-- 
Jens Axboe


