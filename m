Return-Path: <io-uring+bounces-781-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 026BB869886
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 15:37:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43B42B23744
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 14:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6988213A882;
	Tue, 27 Feb 2024 14:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qzI7svbR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D5717729
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 14:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044618; cv=none; b=bjJ8GxrkCntTDP0H+VUJ14a+tvZw/O8yk7K+GkgoA4wXs61nb3NhdDCij/rvM4HOCjFDzDoFn4vByIog27kOIZ5VmfhXKTC5CyPlJxyqpZH9TevY1ZqPl5/O3WqdsKScJR8dstynH4VuLj8pY288Jcst/wKYr5otoGrdXhuA4jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044618; c=relaxed/simple;
	bh=NPUyj3ddPUfzBXhkYiwo+nNzFdgZhK6Hf1WTu8+92AM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uT16MOmBmJVDYVvuQPjN0U4AaFVDVoViLBX8iG/pKRODswzqjsTKoOqgcWrz6QbyWZJ1YtRIn47Oxsyd3cnlJkGbSO2P9wdu1Yh/Kuke/zpGPy/oKb40EYYMR9T+Ly27oMJxgrP/GMkaFmIsZU3o7QITAODNGiE+NhFNVX86sMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qzI7svbR; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3656b1829deso350075ab.1
        for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 06:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709044615; x=1709649415; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZEqeC8VDcUMw4k/nA3ZXJ3EGr9xSBa9B/Dq+H5vzllk=;
        b=qzI7svbRotSQrRWWP5+WqBzp/z6azFCjxOttHW56+5tWnIzL+OrSTPrf7CbOrQdu/E
         tVIl0oZgF+kzxr6FElxizJl01zj1mHWWvMCxMadwk+iU7rVuHNXffI5h3Y9QkjmQaAvY
         csoxDihfJPy3Wbiy1RuJU0Uxj0k0MutBVYL4dDsPSMSUlCtD43/Wi0/K7+Kd7COVAr4M
         sXDM791LBAAKP+oStKocbLlja+ca+zRg5Bi2Xf3eTtmQWsn646B+yAVWufT9XJ/mP3MK
         NRHoNEDAW2CrE6xr8ucfLrz7lxuUR3Wxye9XAGmun+UPSt7tei7sAfqBqA00KIG/Xcg8
         sqXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709044615; x=1709649415;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZEqeC8VDcUMw4k/nA3ZXJ3EGr9xSBa9B/Dq+H5vzllk=;
        b=dcRFTZp/amerDwWUVptCZ0/dSfui5rqxrmK0G12CTwsjqytK9pcP4iNZ1HptbhBRvN
         jCTSVeVyHWXb0ezeKyq84v+6T70mM2riOrNkXQXm8eLaQ4DNiXFMqMYBvzP51E2ArKdE
         T3OyLst/Xfk6h3DMqplSnnEwHgRL7rCznx+L68SPzZWFn7bV7CsBU9roaBfmVEYQWG1p
         WYMKhdr1x2xwfKVLjeA11yG0TAf8inn8W/vgt9S2g1pdblORCVs7/HsNGB1pYHn95iQy
         Oal2/4kkSZpPFUM6vz+COPm9XUVE2ZToADPH/uqfaw2T4XMaGptMUBlVJyGLzC2RcBnZ
         X/Qg==
X-Forwarded-Encrypted: i=1; AJvYcCWV4bIma3js+AHIX40v7/w1gGmHLPtMz/tQnjGpnetyQV1VqJKI6pWmLXhpCpA78mbdIwxPVqjUXTNhkm0bh+sKqGKpB/copvQ=
X-Gm-Message-State: AOJu0YzxIzYyQ55Oy8eWEypG0Fe/99vKJWSULZ+bddUVZwoLNNwfE5Cf
	vezyifpYakqnOt93QGlRYImPyz+Cs6EPQvvSZ/VdA5DeBmqghqZoHpWal/iw2SM=
X-Google-Smtp-Source: AGHT+IHAGTGvS3GTGaePgaitWfuQcZiIHpq/Vg16qf+u32/Tr6QfUdFpNU0FlZlaFD6FShl4kgjSpw==
X-Received: by 2002:a05:6e02:214d:b0:365:3fb7:f77 with SMTP id d13-20020a056e02214d00b003653fb70f77mr9990157ilv.3.1709044614968;
        Tue, 27 Feb 2024 06:36:54 -0800 (PST)
Received: from ?IPV6:2620:10d:c085:21e1::1138? ([2620:10d:c090:400::5:6000])
        by smtp.gmail.com with ESMTPSA id f13-20020aa79d8d000000b006e3d79e74dcsm6120756pfq.141.2024.02.27.06.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 06:36:54 -0800 (PST)
Message-ID: <94284465-0b46-4df4-842e-a0c65dee5908@kernel.dk>
Date: Tue, 27 Feb 2024 07:36:52 -0700
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
References: <0d0fda8f-36c1-49f4-aef0-527a79a34448@kernel.dk>
 <CGME20240227054554epcas5p3ada1c39620d0156e6db87f05449dd624@epcas5p3.samsung.com>
 <20240227054545.1184805-1-xiaobing.li@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240227054545.1184805-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/24 10:45 PM, Xiaobing Li wrote:
> On 2/21/24 10:28, Jens Axboe wrote:
>> On 2/20/24 7:04 PM, Xiaobing Li wrote:
>>> On 2/19/24 14:42, Xiaobing Li wrote:
>>>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>>>> index 976e9500f651..37afc5bac279 100644
>>>> --- a/io_uring/fdinfo.c
>>>> +++ b/io_uring/fdinfo.c
>>>> @@ -55,6 +55,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>> 	struct io_ring_ctx *ctx = f->private_data;
>>>> 	struct io_overflow_cqe *ocqe;
>>>> 	struct io_rings *r = ctx->rings;
>>>> +	struct rusage sq_usage;
>>>> 	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
>>>> 	unsigned int sq_head = READ_ONCE(r->sq.head);
>>>> 	unsigned int sq_tail = READ_ONCE(r->sq.tail);
>>>> @@ -64,6 +65,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>> 	unsigned int sq_shift = 0;
>>>> 	unsigned int sq_entries, cq_entries;
>>>> 	int sq_pid = -1, sq_cpu = -1;
>>>> +	u64 sq_total_time = 0, sq_work_time = 0;
>>>> 	bool has_lock;
>>>> 	unsigned int i;
>>>>
>>>> @@ -147,10 +149,15 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>>
>>>> 		sq_pid = sq->task_pid;
>>>> 		sq_cpu = sq->sq_cpu;
>>>> +		getrusage(sq->thread, RUSAGE_SELF, &sq_usage);
>>>> +		sq_total_time = sq_usage.ru_stime.tv_sec * 1000000 + sq_usage.ru_stime.tv_usec;
>>>> +		sq_work_time = sq->work_time;
>>>> 	}
>>>>
>>>> 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
>>>> 	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
>>>> +	seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
>>>> +	seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
>>>> 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
>>>> 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
>>>> 		struct file *f = io_file_from_index(&ctx->file_table, i);
>>>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>>>> index 65b5dbe3c850..006d7fc9cf92 100644
>>>> --- a/io_uring/sqpoll.c
>>>> +++ b/io_uring/sqpoll.c
>>>> @@ -219,10 +219,22 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
>>>> 	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
>>>> }
>>>>
>>>> +static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
>>>> +{
>>>> +		struct rusage end;
>>>> +
>>>> +		getrusage(current, RUSAGE_SELF, &end);
>>>> +		end.ru_stime.tv_sec -= start->ru_stime.tv_sec;
>>>> +		end.ru_stime.tv_usec -= start->ru_stime.tv_usec;
>>>> +
>>>> +		sqd->work_time += end.ru_stime.tv_usec + end.ru_stime.tv_sec * 1000000;
>>>> +}
>>>> +
>>>> static int io_sq_thread(void *data)
>>>> {
>>>> 	struct io_sq_data *sqd = data;
>>>> 	struct io_ring_ctx *ctx;
>>>> +	struct rusage start;
>>>> 	unsigned long timeout = 0;
>>>> 	char buf[TASK_COMM_LEN];
>>>> 	DEFINE_WAIT(wait);
>>>> @@ -251,6 +263,7 @@ static int io_sq_thread(void *data)
>>>> 		}
>>>>
>>>> 		cap_entries = !list_is_singular(&sqd->ctx_list);
>>>> +		getrusage(current, RUSAGE_SELF, &start);
>>>> 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>>>> 			int ret = __io_sq_thread(ctx, cap_entries);
>>>>
>>>> @@ -261,8 +274,10 @@ static int io_sq_thread(void *data)
>>>> 			sqt_spin = true;
>>>>
>>>> 		if (sqt_spin || !time_after(jiffies, timeout)) {
>>>> -			if (sqt_spin)
>>>> +			if (sqt_spin) {
>>>> +				io_sq_update_worktime(sqd, &start);
>>>> 				timeout = jiffies + sqd->sq_thread_idle;
>>>> +			}
>>>> 			if (unlikely(need_resched())) {
>>>> 				mutex_unlock(&sqd->lock);
>>>> 				cond_resched();
>>>> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>>>> index 8df37e8c9149..4171666b1cf4 100644
>>>> --- a/io_uring/sqpoll.h
>>>> +++ b/io_uring/sqpoll.h
>>>> @@ -16,6 +16,7 @@ struct io_sq_data {
>>>> 	pid_t			task_pid;
>>>> 	pid_t			task_tgid;
>>>>
>>>> +	u64			work_time;
>>>> 	unsigned long		state;
>>>> 	struct completion	exited;
>>>> };
>>>  
>>> Hi, Jens
>>> I have modified the code according to your suggestions.
>>> Do you have any other comments?
>>
>> Out of town this week, I'll check next week. But from a quick look,
>> looks much better now.
>  
> Hi, Jens
> Do you have time to check now?

Can I ask you to resend it against for-6.9/io_uring? For some reason I
don't see the original patch on the list.

-- 
Jens Axboe


