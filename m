Return-Path: <io-uring+bounces-670-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BDA8C85E48B
	for <lists+io-uring@lfdr.de>; Wed, 21 Feb 2024 18:29:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BC5B1F24E99
	for <lists+io-uring@lfdr.de>; Wed, 21 Feb 2024 17:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D42383CBA;
	Wed, 21 Feb 2024 17:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jM9Cq3n7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC1E7E10F
	for <io-uring@vger.kernel.org>; Wed, 21 Feb 2024 17:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708536540; cv=none; b=TU9ekxIx7maEOHlyowTB2vmGuOz1fpOyOhiI1NkIaNyk8BdreZfQRbUHqgZDHn++Qco7LJV9Y9em5SXGkGStwg0ByVupq6NL/gVjtANB/FL6G1YrIKjukmip6Lxc5RDYjKyJ59ibKcoxWMYBSnTWpDqXgWVjKkzXzModeYgGA6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708536540; c=relaxed/simple;
	bh=jaDN3cORrBGht2nMnO/gE2RYJ+leAh9xD2DDv35eYHs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rWeNVEl/0fSBFpkIxoQ9IMjuTMX5ywA9u13pWgvW3TSIoBl0dQvevgKxJdt7gdgpyagVNLjkHop356dGCOjWkopmNo0JYwWwe3MrVY/OcDRR1U5YWX6q3qQKjHRugZht7Inm/hjd//cGhHnMZWuGVbiCrIObuElT81HTNbCK2E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jM9Cq3n7; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5cfb8126375so1966278a12.1
        for <io-uring@vger.kernel.org>; Wed, 21 Feb 2024 09:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708536537; x=1709141337; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rDXNaqwZ7rKb0os0jpqAPzyizKXlOuImA3Swq0SLHvI=;
        b=jM9Cq3n7X3yCw51yarzp+tLrOKIjluao9P7U8kCXw/9iCaMNhEwkED8uFNIW3kjFL/
         4hjFTEHm9J0NnA8+7If43HpFb+wFYc4hkhQRj69NwhxjE6rs+ly7VdbB+HSjyrMdDrsl
         zmXIqUZDoOO5ISaNiwEkBtQ3nmDpfzbpgRTOYoD2IvkCIPy3VzrEl+yoMV1fkQRV1nef
         TGuHepoqwQ0gUxPC6KH7HqV0v1Kk4w0gcg1NHLLmXk4PTwtl94w+t2BdT+HfUTNCCFkF
         Sv+dJmsxZKeqXLC8RMAmhEvJ3KlMvMRoAq7VbWRBbv4q07LLyJAEyIR1SobTKam+95nP
         2nMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708536537; x=1709141337;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rDXNaqwZ7rKb0os0jpqAPzyizKXlOuImA3Swq0SLHvI=;
        b=eDaA+p//kopoKvY/QdqMHR3jktUdHbm7xbSLmfozHnrlaqSFKw4FMMjDJ8J+0g3PEw
         MAd0+NbPETNOyiIub2noE8o6bRLxDXkwMDw0UrG9sHPmMetvc3Otdqnou3WeaTdx66DB
         liKD98N6DgWy/twkE1a0O8d4smDR33EcL+AgGeWBJjJkblgSMClMBUgIjAAzj0ziTW2u
         iCf4vwp6rU/yuI5vid6Smn5jWkVYyjB1Oqse1Gd7Vuksop4x8/NF5o1lqzVCCzL+7VGB
         NkmYORLHsORxlCfhGbJ5WOyQJbT3ciNO/4kKfzWrxfqyYXKsyZXhkHEAFKU6uXhFVk/X
         Ymwg==
X-Forwarded-Encrypted: i=1; AJvYcCXoJ8CWVkMKPscJ205rni0wR3ZEeLJerxxJX5Wf+zyfDMggPIRCcECoKkxWedEnIEFQr3395nS00s44SnuUFVZO7WBUwYSAPmk=
X-Gm-Message-State: AOJu0Yxg6PkYDJwSIlOYliRCy6PPZT3R3933FKv/Q3LTr2dqvVKvtzeQ
	htgdH1zviHStdAOuWBDsUv/oYc2tSSKQjdudlct5ij0xJNexr6YULI8a2o3au2Y=
X-Google-Smtp-Source: AGHT+IGkvu8JRmAknWH/uRyFmsBeeJKf7Ofjox6AxJ5b3PPIn09+j8/EJhtOV4BPXityTOwf9sgGWw==
X-Received: by 2002:a17:90a:1bc8:b0:299:1ae1:51ae with SMTP id r8-20020a17090a1bc800b002991ae151aemr27172pjr.3.1708536536596;
        Wed, 21 Feb 2024 09:28:56 -0800 (PST)
Received: from [172.20.8.9] (071-095-160-189.biz.spectrum.com. [71.95.160.189])
        by smtp.gmail.com with ESMTPSA id d13-20020a17090ad98d00b002997e87b390sm2063505pjv.29.2024.02.21.09.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 09:28:56 -0800 (PST)
Message-ID: <0d0fda8f-36c1-49f4-aef0-527a79a34448@kernel.dk>
Date: Wed, 21 Feb 2024 10:28:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9] io_uring: Statistics of the true utilization of sq
 threads.
Content-Language: en-US
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
 joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
 ruyi.zhang@samsung.com, cliang01.li@samsung.com, xue01.he@samsung.com
References: <20240219064241.20531-1-xiaobing.li@samsung.com>
 <CGME20240221020432epcas5p4d3f6dcf44a4c2be392e94889786c75bc@epcas5p4.samsung.com>
 <20240221020427.309568-1-xiaobing.li@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240221020427.309568-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/20/24 7:04 PM, Xiaobing Li wrote:
> On 2/19/24 14:42, Xiaobing Li wrote:
>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>> index 976e9500f651..37afc5bac279 100644
>> --- a/io_uring/fdinfo.c
>> +++ b/io_uring/fdinfo.c
>> @@ -55,6 +55,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>> 	struct io_ring_ctx *ctx = f->private_data;
>> 	struct io_overflow_cqe *ocqe;
>> 	struct io_rings *r = ctx->rings;
>> +	struct rusage sq_usage;
>> 	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
>> 	unsigned int sq_head = READ_ONCE(r->sq.head);
>> 	unsigned int sq_tail = READ_ONCE(r->sq.tail);
>> @@ -64,6 +65,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>> 	unsigned int sq_shift = 0;
>> 	unsigned int sq_entries, cq_entries;
>> 	int sq_pid = -1, sq_cpu = -1;
>> +	u64 sq_total_time = 0, sq_work_time = 0;
>> 	bool has_lock;
>> 	unsigned int i;
>>
>> @@ -147,10 +149,15 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>
>> 		sq_pid = sq->task_pid;
>> 		sq_cpu = sq->sq_cpu;
>> +		getrusage(sq->thread, RUSAGE_SELF, &sq_usage);
>> +		sq_total_time = sq_usage.ru_stime.tv_sec * 1000000 + sq_usage.ru_stime.tv_usec;
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
>> index 65b5dbe3c850..006d7fc9cf92 100644
>> --- a/io_uring/sqpoll.c
>> +++ b/io_uring/sqpoll.c
>> @@ -219,10 +219,22 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
>> 	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
>> }
>>
>> +static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
>> +{
>> +		struct rusage end;
>> +
>> +		getrusage(current, RUSAGE_SELF, &end);
>> +		end.ru_stime.tv_sec -= start->ru_stime.tv_sec;
>> +		end.ru_stime.tv_usec -= start->ru_stime.tv_usec;
>> +
>> +		sqd->work_time += end.ru_stime.tv_usec + end.ru_stime.tv_sec * 1000000;
>> +}
>> +
>> static int io_sq_thread(void *data)
>> {
>> 	struct io_sq_data *sqd = data;
>> 	struct io_ring_ctx *ctx;
>> +	struct rusage start;
>> 	unsigned long timeout = 0;
>> 	char buf[TASK_COMM_LEN];
>> 	DEFINE_WAIT(wait);
>> @@ -251,6 +263,7 @@ static int io_sq_thread(void *data)
>> 		}
>>
>> 		cap_entries = !list_is_singular(&sqd->ctx_list);
>> +		getrusage(current, RUSAGE_SELF, &start);
>> 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>> 			int ret = __io_sq_thread(ctx, cap_entries);
>>
>> @@ -261,8 +274,10 @@ static int io_sq_thread(void *data)
>> 			sqt_spin = true;
>>
>> 		if (sqt_spin || !time_after(jiffies, timeout)) {
>> -			if (sqt_spin)
>> +			if (sqt_spin) {
>> +				io_sq_update_worktime(sqd, &start);
>> 				timeout = jiffies + sqd->sq_thread_idle;
>> +			}
>> 			if (unlikely(need_resched())) {
>> 				mutex_unlock(&sqd->lock);
>> 				cond_resched();
>> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>> index 8df37e8c9149..4171666b1cf4 100644
>> --- a/io_uring/sqpoll.h
>> +++ b/io_uring/sqpoll.h
>> @@ -16,6 +16,7 @@ struct io_sq_data {
>> 	pid_t			task_pid;
>> 	pid_t			task_tgid;
>>
>> +	u64			work_time;
>> 	unsigned long		state;
>> 	struct completion	exited;
>> };
>  
> Hi, Jens
> I have modified the code according to your suggestions.
> Do you have any other comments?

Out of town this week, I'll check next week. But from a quick look,
looks much better now.

-- 
Jens Axboe


