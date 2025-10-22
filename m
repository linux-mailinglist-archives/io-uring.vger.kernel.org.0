Return-Path: <io-uring+bounces-10115-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C69F6BFD698
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 18:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 58F3F4FFC26
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 16:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6659535B156;
	Wed, 22 Oct 2025 16:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="s3qodkyT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FB235B136
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 16:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761151726; cv=none; b=AngiAvPrwY/LT64jmveCvmsjrAbBD7Aecc4xJa/F2yQzMM3NIpKKtdida1IZmCHc6/dzT7rEupsosiNW05HI5AIChOyQo/aIL6Em5In46q84h57iU1Z0gSvpKnyJCzyhPLnNnHBU08XTF50DClIKI6Ed6N84k84ksSrMVsUdJaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761151726; c=relaxed/simple;
	bh=cXXlxOryLhpoil0xaDUUECoDJ8mGRDgrUJYRq3Usfw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HeR6VG0R7iuYyJM9kdCvNNGeQ6MYtoe7tefYi2GLbFIqdLjyS3e4QFEJU7yZtDKzdaWqdSpAKcimN3ZahrShtWn22MwNeLTAzkwJQoqiMoo1DRl70x4yZjZWxxrL1Kkslw2s4hpjcwyL8kgZuJ8lbrbu/RWzz9eih7+uaEnNEJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=s3qodkyT; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-430e182727dso13745375ab.1
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 09:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761151721; x=1761756521; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lwpd3rmy29H1ooJYC2gH6QQxli+wXCcDxKShQQGlixI=;
        b=s3qodkyTkdBVX5VCQ4D8GW/vizTa/Gk+zIgJ5x7ZLOCy82gibra+rwIQrhU0SReUWi
         WpLl0SQ2l1dyTmbvNvbzNIVrQoFhvJZGoXNPSyZWfhdCaUShWIvuO01SiZ7Dzp9HWqZn
         tMRmWpws2/aywnGAM1l03fySIWiuyU27pdqv+TjUhipLyRU+x4EAN7I5RlbZ/kauHfjr
         pFG8vpi6T40NiWnsf2qKO6Z6kpDgsKJ7p5GTsYPoS/j0MftbkFolncomajdH+IwDkyPs
         1VGmbuhPE1VuNVD8Fru4ScYPugKTKX1FG3tJLJ76CZChCMwrL5Ku+qqmYQsFsHrZ4D/Y
         Nzhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761151721; x=1761756521;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lwpd3rmy29H1ooJYC2gH6QQxli+wXCcDxKShQQGlixI=;
        b=qzqsEsXbT52NK02di/tRLiobLXrFkRvZ9Gh9Lr/NHBxG2D/uPU1j6xRTO6a+svyWXF
         A1lLMyp/TsB9VYqk0uU9xf0TkNOYLEe5HZ+E5OLHJex+CLBnN8Ec2M6JiAJI001BtSeA
         v+OW2T6xdlL9PbJBPGSCHckoCNs8S0KpIWcA7S6AcbTyZVfR5dMSsXFbExklS54ZArJ5
         Z/YhYYPLUt0czOT1rfIKJTHLEqN5sYJd6xSl+xXigyPvdYx9RATZUxVClfLR6K+VicIH
         5pODJUabSrMLY0Tk40LZKE9mewPrZ5pTKloS7PWjYyVg/SZJswane+8gxafa1yMF2gV0
         Wb2Q==
X-Gm-Message-State: AOJu0YzMmrFA254blS9SIQhetGloav0rqwf7tPiSi77mgemq4YJdRYaW
	/eju+5Ic26My5jwEOhGY33L/6KX5qZRULDT6Tx8DwiBmYcPdByHfYZshs4zLL8rqgptopFUkx4S
	hN/dy+fg=
X-Gm-Gg: ASbGncuGkOaZLMFaDIE0epy9jSQAAEX58UdLhN0Zn3tJf05U6h1cyi4LXBK0huoMM0R
	4vDo58lrsJLvVwAQjT8HQ6StYK60uctSR2y16WrfneeX4vh1dMJsvtSKDmFUVTrSM7lycBWnLOg
	ST3WHV5p8nnHVKzWE5nuOx3+3N5F7ToSZyZne5WeUdyCeTWupXJNI9ZfBLzcahnkuIjrTbsCt2T
	tz4sTvDGgYS2bh+2B2VSXEeNoLSoYnzeg7pYTZApgtC+aR2ZKiQPEFMWyF1kK2DItxt5S6XZ2fl
	AME//1hIGeItqCBg0YtFneadATRRo+GvcLC5xOSn0U3ysYEmiBdPYZ6olD1ifYIzxnrhi+UoGRj
	JXjq97S4hVMOS+r6yk3f03is5Rsg6qESmgpw2GzXjWzzoLx7OKWM9wmI2GUIYCA4oNFJGDfTZAl
	95RSk04k4=
X-Google-Smtp-Source: AGHT+IGbr9XnR2TUbKEnjg/86hT46+IWS1oykTlATWHGDSD8RC49VTaKnuN6LrFfvK2SIQeDITKEKw==
X-Received: by 2002:a05:6e02:348f:b0:431:da5b:9ef3 with SMTP id e9e14a558f8ab-431da5ba0a2mr12818015ab.27.1761151721532;
        Wed, 22 Oct 2025 09:48:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-430d0611b4csm57438185ab.0.2025.10.22.09.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 09:48:40 -0700 (PDT)
Message-ID: <78c19746-132d-4e85-b4bf-9b251435cb77@kernel.dk>
Date: Wed, 22 Oct 2025 10:48:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/sqpoll: switch away from getrusage() for CPU
 accounting
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, changfengnan@bytedance.com,
 xiaobing.li@samsung.com, lidiangang@bytedance.com, stable@vger.kernel.org
References: <20251021175840.194903-1-axboe@kernel.dk>
 <20251021175840.194903-2-axboe@kernel.dk>
 <87cy6f25h9.fsf@mailhost.krisman.be>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <87cy6f25h9.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/25 5:35 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> getrusage() does a lot more than what the SQPOLL accounting needs, the
>> latter only cares about (and uses) the stime. Rather than do a full
>> RUSAGE_SELF summation, just query the used stime instead.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 3fcb9d17206e ("io_uring/sqpoll: statistics of the true utilization of sq threads")
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/fdinfo.c |  9 +++++----
>>  io_uring/sqpoll.c | 34 ++++++++++++++++++++--------------
>>  io_uring/sqpoll.h |  1 +
>>  3 files changed, 26 insertions(+), 18 deletions(-)
>>
>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>> index ff3364531c77..966e06b078f6 100644
>> --- a/io_uring/fdinfo.c
>> +++ b/io_uring/fdinfo.c
>> @@ -59,7 +59,6 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>>  {
>>  	struct io_overflow_cqe *ocqe;
>>  	struct io_rings *r = ctx->rings;
>> -	struct rusage sq_usage;
>>  	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
>>  	unsigned int sq_head = READ_ONCE(r->sq.head);
>>  	unsigned int sq_tail = READ_ONCE(r->sq.tail);
>> @@ -152,14 +151,16 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>>  		 * thread termination.
>>  		 */
>>  		if (tsk) {
>> +			struct timespec64 ts;
>> +
>>  			get_task_struct(tsk);
>>  			rcu_read_unlock();
>> -			getrusage(tsk, RUSAGE_SELF, &sq_usage);
>> +			ts = io_sq_cpu_time(tsk);
>>  			put_task_struct(tsk);
>>  			sq_pid = sq->task_pid;
>>  			sq_cpu = sq->sq_cpu;
>> -			sq_total_time = (sq_usage.ru_stime.tv_sec * 1000000
>> -					 + sq_usage.ru_stime.tv_usec);
>> +			sq_total_time = (ts.tv_sec * 1000000
>> +					 + ts.tv_nsec / 1000);
>>  			sq_work_time = sq->work_time;
>>  		} else {
>>  			rcu_read_unlock();
>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>> index a3f11349ce06..8705b0aa82e0 100644
>> --- a/io_uring/sqpoll.c
>> +++ b/io_uring/sqpoll.c
>> @@ -11,6 +11,7 @@
>>  #include <linux/audit.h>
>>  #include <linux/security.h>
>>  #include <linux/cpuset.h>
>> +#include <linux/sched/cputime.h>
>>  #include <linux/io_uring.h>
>>  
>>  #include <uapi/linux/io_uring.h>
>> @@ -169,6 +170,22 @@ static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
>>  	return READ_ONCE(sqd->state);
>>  }
>>  
>> +struct timespec64 io_sq_cpu_time(struct task_struct *tsk)
>> +{
>> +	u64 utime, stime;
>> +
>> +	task_cputime_adjusted(tsk, &utime, &stime);
>> +	return ns_to_timespec64(stime);
>> +}
>> +
>> +static void io_sq_update_worktime(struct io_sq_data *sqd, struct timespec64 start)
>> +{
>> +	struct timespec64 ts;
>> +
>> +	ts = timespec64_sub(io_sq_cpu_time(current), start);
>> +	sqd->work_time += ts.tv_sec * 1000000 + ts.tv_nsec / 1000;
>> +}
> 
> Hi Jens,
> 
> Patch looks good. I'd just mention you are converting ns to timespec64,
> just to convert it back to ms when writing to sqd->work_time and
> sq_total_time.  I think wraparound is not a concern for
> task_cputime_adjusted since this is the actual system cputime of a
> single thread inside a u64.  So io_sq_cpu_time could just return ms
> directly and io_sq_update_worktime would be trivial:
> 
>   sqd->work_time = io_sq_pu_time(current) - start.

That's a good point - I'll update both patches, folding and incremental
like the below in. Thanks!

-- 
Jens Axboe

