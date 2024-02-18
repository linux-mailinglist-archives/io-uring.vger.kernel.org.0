Return-Path: <io-uring+bounces-620-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 535F18596FE
	for <lists+io-uring@lfdr.de>; Sun, 18 Feb 2024 13:55:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EFC71C20BCA
	for <lists+io-uring@lfdr.de>; Sun, 18 Feb 2024 12:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E22166BFA0;
	Sun, 18 Feb 2024 12:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="z+luHfuv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5146BB4E
	for <io-uring@vger.kernel.org>; Sun, 18 Feb 2024 12:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708260944; cv=none; b=mI3A1EBi4XhO+qHTaZI3r6AHhd0if+I8CfvOqJv+5vKF7QJp6vbRIO1EsG9Q2ZjJjGh4NfhOw0qV6kA3JrSTT6/RiZ8xvqLlCtONvdgPeEW1tlzpJ6aRKZQNO1aEJ6BOhUkRiCGa8fCwjfNSGyZMGlFs3UWtZenX5/mBDGhivfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708260944; c=relaxed/simple;
	bh=QqNtIzDTyZoN2LKeC51whUxZXhXE9Z1UlRa4PhZ3wsk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=quJ0gn246/4q57pkJI1LJ663kDKhTjspuCjqP918lFVME9V6MvlDgBVkNCjpM8rLe5T/brBnHuIjwNxMRjMcAEzjb2YRZPXLf/uqCJsTpfBDolKZuM7PA7mVH1+FOUzfbS2qbLslwzXpJhYYI8irRhwpjyYLYRtWEFoNWSHWehs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=z+luHfuv; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e33db9118cso89144b3a.1
        for <io-uring@vger.kernel.org>; Sun, 18 Feb 2024 04:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708260940; x=1708865740; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KLvIqFTcCWTBWR0stNfnzEKTeehbvUhICSkQBNo+aow=;
        b=z+luHfuv2FEAFmHZfuyv13QMArh8LZy4nJnj54TvBAXqsgwgqq9pZwrnS/K9j5bdAA
         8PJ92+jEGvvjvvm7ytOpkUgu+Kd/oR3UUX5r4ORYSo6BN7OEy8/8yCfbggGs2UWWlwFH
         iAP/aDIhyNxiooawU8xxH54MeylCbPaWvUypaBf1XU635KWEpeYvxK7/I/Nv/8f7FAqj
         xbZY0v36PcYEFCRsIHmgJwa/j1sO07N4tMDXmZVqasIyS+bb2WHY4JcIJfqOYtOtqyk9
         pXmhvPxpiyAM8l39Drum66oww1+03bc1x7+KMNTpy9qsezjPYRQeA3o0/jfs8doU38c3
         ZrQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708260940; x=1708865740;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KLvIqFTcCWTBWR0stNfnzEKTeehbvUhICSkQBNo+aow=;
        b=peKRYM237cCYKweBFkfnyvJCUBvRGPpUo2A0INInijjdC9D2j+kDhDZN6M0GTk9T8Q
         mn2S8EiBUO3Ja+S4YpGkkCaRdtkChNJZ4cDoAeZojKd7c6x++3iGUD76ZgOnFIblxwdV
         xsNyHYfDL7ts4F7JdIcC8UtYvB4lO3dfg7NO9VDiHWpYHxX6eSr80AmFRkHc8b7uytnW
         cypZYk2VpYF1otjK37V7PQE8By2fdlh4Zg9xiYhSzyRaJb4DTzMfwQnogOP5WVwpPksN
         AVWb3qDDqsM5U06BrDN5gLAO78CkyynHHRffy+UBPWFHB9+VT/77EDnLMw++OWPhLOz3
         TO1w==
X-Forwarded-Encrypted: i=1; AJvYcCW7HOdC7rT+9PRRDmSSEFQhoA5Copu2yj77fEZ6idn1O/qEoYQ7cnruTuWTpx/pgjhv8GRQqG+KELhHwYivL56ovlntFhlrMig=
X-Gm-Message-State: AOJu0YxFlgKcNjX+BoaycxZlPbIU/fK1I1Jzi40knOaqk2maoypVMSVp
	CddrrKmMJKF62DZF+ABltcYbGXurZMWKDwDQ9NMVDxCGgviiF4qdXyHlZU52iuJsGBJEOYoig1G
	C
X-Google-Smtp-Source: AGHT+IFKSjl5q99+iMh5G1jgiB2ZL2MycRwAYSbkuqfsR3mD2GdM6G10l/T7pyHgfMetlnEJJCosqw==
X-Received: by 2002:aa7:9dd0:0:b0:6e4:5e66:6824 with SMTP id g16-20020aa79dd0000000b006e45e666824mr877683pfq.1.1708260940143;
        Sun, 18 Feb 2024 04:55:40 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id ei7-20020a056a0080c700b006dd8985e7c6sm2995277pfb.1.2024.02.18.04.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Feb 2024 04:55:39 -0800 (PST)
Message-ID: <d2f22b33-6b55-4f02-9a7e-956b5c60d992@kernel.dk>
Date: Sun, 18 Feb 2024 05:55:37 -0700
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
From: Jens Axboe <axboe@kernel.dk>
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
 joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
 ruyi.zhang@samsung.com
References: <20240206023910.11307-1-xiaobing.li@samsung.com>
 <CGME20240218055523epcas5p390fe990f970cf2b9b1f96edd5d7bc9b5@epcas5p3.samsung.com>
 <20240218055513.38601-1-xiaobing.li@samsung.com>
 <1f7fa75e-f920-47d8-ae4f-cc7595b5e732@kernel.dk>
In-Reply-To: <1f7fa75e-f920-47d8-ae4f-cc7595b5e732@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/18/24 5:45 AM, Jens Axboe wrote:
> On 2/17/24 10:55 PM, Xiaobing Li wrote:
>> On 2/6/24 10:39 AM, Xiaobing Li wrote:
>>> io_uring/fdinfo.c | 8 ++++++++
>>> io_uring/sqpoll.c | 8 ++++++++
>>> io_uring/sqpoll.h | 1 +
>>> 3 files changed, 17 insertions(+)
>>>
>>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>>> index 976e9500f651..18c6f4aa4a48 100644
>>> --- a/io_uring/fdinfo.c
>>> +++ b/io_uring/fdinfo.c
>>> @@ -64,6 +64,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>> 	unsigned int sq_shift = 0;
>>> 	unsigned int sq_entries, cq_entries;
>>> 	int sq_pid = -1, sq_cpu = -1;
>>> +	u64 sq_total_time = 0, sq_work_time = 0;
>>> 	bool has_lock;
>>> 	unsigned int i;
>>>
>>> @@ -147,10 +148,17 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>
>>> 		sq_pid = sq->task_pid;
>>> 		sq_cpu = sq->sq_cpu;
>>> +		struct rusage r;
>>> +
>>> +		getrusage(sq->thread, RUSAGE_SELF, &r);
>>> +		sq_total_time = r.ru_stime.tv_sec * 1000000 + r.ru_stime.tv_usec;
>>> +		sq_work_time = sq->work_time;
>>> 	}
>>>
>>> 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
>>> 	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
>>> +	seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
>>> +	seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
>>> 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
>>> 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
>>> 		struct file *f = io_file_from_index(&ctx->file_table, i);
>>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>>> index 65b5dbe3c850..9155fc0b5eee 100644
>>> --- a/io_uring/sqpoll.c
>>> +++ b/io_uring/sqpoll.c
>>> @@ -251,6 +251,9 @@ static int io_sq_thread(void *data)
>>> 		}
>>>
>>> 		cap_entries = !list_is_singular(&sqd->ctx_list);
>>> +		struct rusage start, end;
>>> +
>>> +		getrusage(current, RUSAGE_SELF, &start);
>>> 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>>> 			int ret = __io_sq_thread(ctx, cap_entries);
>>>
>>> @@ -260,6 +263,11 @@ static int io_sq_thread(void *data)
>>> 		if (io_run_task_work())
>>> 			sqt_spin = true;
>>>
>>> +		getrusage(current, RUSAGE_SELF, &end);
>>> +		if (sqt_spin == true)
>>> +			sqd->work_time += (end.ru_stime.tv_sec - start.ru_stime.tv_sec) *
>>> +					1000000 + (end.ru_stime.tv_usec - start.ru_stime.tv_usec);
>>> +
>>> 		if (sqt_spin || !time_after(jiffies, timeout)) {
>>> 			if (sqt_spin)
>>> 				timeout = jiffies + sqd->sq_thread_idle;
>>> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>>> index 8df37e8c9149..e99f5423a3c3 100644
>>> --- a/io_uring/sqpoll.h
>>> +++ b/io_uring/sqpoll.h
>>> @@ -16,6 +16,7 @@ struct io_sq_data {
>>> 	pid_t			task_pid;
>>> 	pid_t			task_tgid;
>>>
>>> +	u64					work_time;
>>> 	unsigned long		state;
>>> 	struct completion	exited;
>>> };
>>  
>> Hi, Jens and Pavel
>> This patch has been modified according to your previous opinions.
>> Do you have any other comments?
> 
> I don't have any further complaints on the patch, I think it looks
> pretty straight forward now. I'll get it applied, thanks.

I take that back, I'll reply to the patch...

-- 
Jens Axboe


