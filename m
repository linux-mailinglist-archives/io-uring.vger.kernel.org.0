Return-Path: <io-uring+bounces-619-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 269DD8596E8
	for <lists+io-uring@lfdr.de>; Sun, 18 Feb 2024 13:45:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 281671C20985
	for <lists+io-uring@lfdr.de>; Sun, 18 Feb 2024 12:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99CD163125;
	Sun, 18 Feb 2024 12:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pMPXiKr1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627D91D6A7
	for <io-uring@vger.kernel.org>; Sun, 18 Feb 2024 12:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708260322; cv=none; b=ih/FmlqxIrnTMWPtBEqimlhOC/zeCC+mW2ceYjw3uj36tEpZNOhMRGV6CbxbnvYvuwarcU2hEzxQoZnZAV/tWaFVlHBxKJspCo6irGi0KRF2hsdNcJCxL+gxqQrXrWmgeuFickvMOzkloIsa9S62PjlZVdbQLgvJkZt0TnW6S9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708260322; c=relaxed/simple;
	bh=qOsvK8DXGP2m+hr2c3+5eDoiqjvovviL9OkSOVd6+xE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T9VyJhoaZSnAE5JBjTBWzS5a9McVfj+bk9JUORE2saTvVs7nrToThu2rVl9/4mhquV/lqv/EygR39PZEEGuhBTsj8GyDb25ZH4hGNSc0fL4/uHRgnRjmyFhXENBV+BEg7aUAKFVk2zPJ4LeB/Y4LTPBxmG0Mm/PX3Uuu8kANMTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pMPXiKr1; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-29593a27fcaso984251a91.1
        for <io-uring@vger.kernel.org>; Sun, 18 Feb 2024 04:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708260318; x=1708865118; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IpqTiU/7yQrm0r8tMp8al7wzn/Zvghd4JxEhQBfnYt8=;
        b=pMPXiKr1yslMDT0uJt0JwGTsolNdLQjC/H1YBCCuCcqukNLbYYmlQ2LyPX21wXIDvz
         rRRgKeAXuv7ikFe75SdedKUccQh5n1+LCJOvYP/sHqQo7F/HNn4ua5X3l42cEjJqAWZy
         uqoSgtS1MOukgMDTWC5shFgpJ8sEMJqka6gR72bjmYIG8fyzJYSgYOuqXjvpxdYpy2Uc
         O5BW8vzQGlfZkJ9VxAeUAI9NP3sWgwSCXmtvysVhM2nj7kXlaute6JenAKyrvPzT2mxp
         iBrGF5RK+6LS4t2+QKWZyWP0OPcibOTZ5g6kzRVdw/49Cu7QgLV8QYxEIWAiPdxJS7ap
         XTmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708260318; x=1708865118;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IpqTiU/7yQrm0r8tMp8al7wzn/Zvghd4JxEhQBfnYt8=;
        b=CpvLPht5k94YQ3Jzkpg7z2MXuo9+2CQGMnFv+E8/zNVbHsWRslSXk4k95TLwLyDsr8
         bHHt0o3fo03GYZ1jJ0415wQZhof0Vj/FxBIcPpDrIhOZzcSyO7sk6plebXaMpOQs1oNo
         Y/OVFb/KqrOPaNJ3f5ValG312PGHNwslPT86O6nVv56pmP5WxaDKCJJ1IS0LyTjysMJO
         leUoDJz447uXIL/TXL8TiXhK16f4U7g7lEFKqmc4fDd3n/V/UHtkaUS5djK7VGnSPqmG
         VrENcqyvebkIzx6tpFr58JwP2N0u/8h1H1tWFAAmLt1nd46XtyDeVxWzQmfQTiYmV64a
         VXWA==
X-Forwarded-Encrypted: i=1; AJvYcCXAEuLTNt5h9+Z0OhmAZKV7zNY/+4ZLJa2MesXhiNtM/JkQFRoYIhwO3ZlAYpc1AFUG6r+qbh++4kaGhU+SDNv8kcQXAr2w1AY=
X-Gm-Message-State: AOJu0YyrEoAmFy3uGmGr69R48PfnHJmK9ht5j46UX75QV1wjqVvoqEoI
	Q/UNn1/dy/7KizK+p1S+vWA21edZiQPB0bIApcnUVi3iNXt881eMvungVY6a48I=
X-Google-Smtp-Source: AGHT+IH24HwrBk8tEWIT7JqmpPJrZ/d4JKpTlgjSlcTALopVPOXPC97qtBxXOGQUj4oQ/TdfbN+HGw==
X-Received: by 2002:a05:6a00:2d96:b0:6e1:bcb:d4e3 with SMTP id fb22-20020a056a002d9600b006e10bcbd4e3mr12343970pfb.1.1708260318493;
        Sun, 18 Feb 2024 04:45:18 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id z16-20020aa791d0000000b006e141794208sm2968092pfa.165.2024.02.18.04.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Feb 2024 04:45:17 -0800 (PST)
Message-ID: <1f7fa75e-f920-47d8-ae4f-cc7595b5e732@kernel.dk>
Date: Sun, 18 Feb 2024 05:45:15 -0700
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
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
 joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
 ruyi.zhang@samsung.com
References: <20240206023910.11307-1-xiaobing.li@samsung.com>
 <CGME20240218055523epcas5p390fe990f970cf2b9b1f96edd5d7bc9b5@epcas5p3.samsung.com>
 <20240218055513.38601-1-xiaobing.li@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240218055513.38601-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/17/24 10:55 PM, Xiaobing Li wrote:
> On 2/6/24 10:39 AM, Xiaobing Li wrote:
>> io_uring/fdinfo.c | 8 ++++++++
>> io_uring/sqpoll.c | 8 ++++++++
>> io_uring/sqpoll.h | 1 +
>> 3 files changed, 17 insertions(+)
>>
>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>> index 976e9500f651..18c6f4aa4a48 100644
>> --- a/io_uring/fdinfo.c
>> +++ b/io_uring/fdinfo.c
>> @@ -64,6 +64,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>> 	unsigned int sq_shift = 0;
>> 	unsigned int sq_entries, cq_entries;
>> 	int sq_pid = -1, sq_cpu = -1;
>> +	u64 sq_total_time = 0, sq_work_time = 0;
>> 	bool has_lock;
>> 	unsigned int i;
>>
>> @@ -147,10 +148,17 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>
>> 		sq_pid = sq->task_pid;
>> 		sq_cpu = sq->sq_cpu;
>> +		struct rusage r;
>> +
>> +		getrusage(sq->thread, RUSAGE_SELF, &r);
>> +		sq_total_time = r.ru_stime.tv_sec * 1000000 + r.ru_stime.tv_usec;
>> +		sq_work_time = sq->work_time;
>> 	}
>>
>> 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
>> 	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
>> +	seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
>> +	seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
>> 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
>> 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
>> 		struct file *f = io_file_from_index(&ctx->file_table, i);
>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>> index 65b5dbe3c850..9155fc0b5eee 100644
>> --- a/io_uring/sqpoll.c
>> +++ b/io_uring/sqpoll.c
>> @@ -251,6 +251,9 @@ static int io_sq_thread(void *data)
>> 		}
>>
>> 		cap_entries = !list_is_singular(&sqd->ctx_list);
>> +		struct rusage start, end;
>> +
>> +		getrusage(current, RUSAGE_SELF, &start);
>> 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>> 			int ret = __io_sq_thread(ctx, cap_entries);
>>
>> @@ -260,6 +263,11 @@ static int io_sq_thread(void *data)
>> 		if (io_run_task_work())
>> 			sqt_spin = true;
>>
>> +		getrusage(current, RUSAGE_SELF, &end);
>> +		if (sqt_spin == true)
>> +			sqd->work_time += (end.ru_stime.tv_sec - start.ru_stime.tv_sec) *
>> +					1000000 + (end.ru_stime.tv_usec - start.ru_stime.tv_usec);
>> +
>> 		if (sqt_spin || !time_after(jiffies, timeout)) {
>> 			if (sqt_spin)
>> 				timeout = jiffies + sqd->sq_thread_idle;
>> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>> index 8df37e8c9149..e99f5423a3c3 100644
>> --- a/io_uring/sqpoll.h
>> +++ b/io_uring/sqpoll.h
>> @@ -16,6 +16,7 @@ struct io_sq_data {
>> 	pid_t			task_pid;
>> 	pid_t			task_tgid;
>>
>> +	u64					work_time;
>> 	unsigned long		state;
>> 	struct completion	exited;
>> };
>  
> Hi, Jens and Pavel
> This patch has been modified according to your previous opinions.
> Do you have any other comments?

I don't have any further complaints on the patch, I think it looks
pretty straight forward now. I'll get it applied, thanks.

-- 
Jens Axboe


