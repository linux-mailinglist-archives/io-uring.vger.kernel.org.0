Return-Path: <io-uring+bounces-8294-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73C82AD3BAA
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 16:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AAB23A203D
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 14:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3CD20A5E5;
	Tue, 10 Jun 2025 14:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ciq3IK0T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AAA201034
	for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 14:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749567049; cv=none; b=PXJUFIvK2rCUQvj+Q/+kZpzZ+1Ia0MKV6bPyu36sUHd2j5rM+2EEZl5jXRGmIh7ghy+92IcINnwYQjfK7tSk2Uguzf4S/tmvvmgUmAtQjVfdazFxoEwIa/VJE4VeMfPyrdvg+X7eOYEm8xvyaWy/xKKr1DyydOzAyswpL7AA4Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749567049; c=relaxed/simple;
	bh=MKwzSPjVR1RRZ9z95yQnaAyTwZx4ZDB45F5JLQJ8YUw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GYWoHdrApWZBb+M7h6ooNQosQ3eEm47qu1bPNvNzkXkgln5+Du0heUzulpDVQR8saZSAcnUNFvu1fQ1KPzNwJA2LbGUsSMwqg4F6jNJW9X3KNGbsYfiHLPks22bAos7/TuT/JK0i56HcpHqrLwwO+ds0AmGAOUynA7sV9GRfW/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ciq3IK0T; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3ddcf0edef6so13648225ab.0
        for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 07:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749567046; x=1750171846; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6hz6prXsHPvpgVzV/TKtvgGnQnOAwGsuAJARZIquvRA=;
        b=ciq3IK0TEZXILvRwMvwKwciu+DC1LO6TgIlWth7GYXjCnmc4HmvyHFdkbyu/UnoqqN
         1dZRjPvcJbOUSV1c5OJwYhAGxZRXe/AeWkwtRQFWcTh3jKpmKhIabncl/0FPdh2alrNr
         PtzucqfQ0i5C8QO3L8VhLvl0qDsZNFkiEspKAgu6WRLqunAS746H3KgFqjYagl4kuQ34
         U4tjWziMOi1QEZr9mvu0URJbyMANIteBc6g60gKSctCOntUkk5QjuWgCCBskPpFtU5ii
         UM7fK6KJ3Krt5GKF0L0dAHiy/xcQJikgGR1UrF/bTkpKmf5BPDRB1vsPMiE9GZgbNACH
         Totg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749567046; x=1750171846;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6hz6prXsHPvpgVzV/TKtvgGnQnOAwGsuAJARZIquvRA=;
        b=alsCwUZhyXxTlIhXBXemYMHoDwfor/9l3KwjS3wduho2MCDVR7dGGsjbn6mffMjsNP
         JzbZD+EblwbAi7mh0VoGT1baL9mgb+TH6Fy2DJD2H50TeBcHuSzQQwRU/xEn7GkSYrqJ
         5zLs6VMlNhyhMMzXWp6i58pl8yRBJwdFkkuzXWKu/mCQzMsn9qgRivJ/V530wS+3b1K7
         B7b3K9OeS8cUAv7GxPutPECET/ncN8eCmATU/aO5oelh1BqY5nqjlYVS0yrz2HQ8optt
         zZ8gMAFF1pbxZ2zDA0Cokzea01CGSmTpPS/Gc3QljqowEaA7UorvEE5qED8NuY/P83le
         aRvA==
X-Gm-Message-State: AOJu0YxbfsmS4LMmi6m95KO4rsUP12gMz2B+ieLUY/sj1eLmkxS6Q461
	+OBnlP47yk1zmR+0FyZhU/NEROsQugdqqyxwR4AWJaLsBj0rMOiD2cCMwZl1sofI7fM=
X-Gm-Gg: ASbGncsV/4M6ErszRj6z77X0pC/X7IUWlrB2+kGJZGVWE+h4OzGpYz5F/q0qeRPFCFq
	BpOcEW20157dRt+09bmNaJvd0WrvlLMBQHcFRxLKGYp0jY6zITCZjpQGTDIGxpbuiYcnDT3w466
	PObx7HZu2jqa0YkLflbJVYkLky9Sht3cWgJlO6H1iZYPWousFhr6qGFhmtMtAWZ40qqEZNUTXBp
	/NLeUMu0WKTlf2E+2SVTnXzkfF6qDEPbx2ipCz35Dvlm94m7yi34HbTgovp/HokAyVWNAG3jjqv
	N39UOKho5qaArV+djjcKavVFEFGM1iVVniwTPY4vx8rPFpiYCpGOzQT1o2s=
X-Google-Smtp-Source: AGHT+IEXpRLwGhZISY/C9ok9HpSY3ahcqlZhNsgTh2cWKHUWv8zdnRZGmAWfQe7R3ijOvhZLzQbKkA==
X-Received: by 2002:a05:6e02:2701:b0:3dd:b4f4:2bba with SMTP id e9e14a558f8ab-3ddce49a9bbmr216660205ab.22.1749567046049;
        Tue, 10 Jun 2025 07:50:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-500df58e63csm2360810173.74.2025.06.10.07.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 07:50:44 -0700 (PDT)
Message-ID: <a9bd6c47-f54d-466f-8d33-fceb62b0e985@kernel.dk>
Date: Tue, 10 Jun 2025 08:50:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix use-after-free of sq->thread in
 __io_uring_show_fdinfo()
From: Jens Axboe <axboe@kernel.dk>
To: Penglei Jiang <superman.xpt@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+531502bbbe51d2f769f4@syzkaller.appspotmail.com
References: <20250610111721.37036-1-superman.xpt@gmail.com>
 <ab764b69-6b94-4163-b114-f4889a043040@kernel.dk>
Content-Language: en-US
In-Reply-To: <ab764b69-6b94-4163-b114-f4889a043040@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/10/25 8:33 AM, Jens Axboe wrote:
> On 6/10/25 5:17 AM, Penglei Jiang wrote:
>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>> index e9355276ab5d..2911352bbae1 100644
>> --- a/io_uring/fdinfo.c
>> +++ b/io_uring/fdinfo.c
>> @@ -141,19 +141,23 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>>  
>>  	if (ctx->flags & IORING_SETUP_SQPOLL) {
>>  		struct io_sq_data *sq = ctx->sq_data;
>> +		struct task_struct *tsk;
>>  
>> +		rcu_read_lock();
>> +		tsk = rcu_dereference(sq->thread);
>>  		/*
>>  		 * sq->thread might be NULL if we raced with the sqpoll
>>  		 * thread termination.
>>  		 */
>> -		if (sq->thread) {
>> +		if (tsk) {
>>  			sq_pid = sq->task_pid;
>>  			sq_cpu = sq->sq_cpu;
>> -			getrusage(sq->thread, RUSAGE_SELF, &sq_usage);
>> +			getrusage(tsk, RUSAGE_SELF, &sq_usage);
>>  			sq_total_time = (sq_usage.ru_stime.tv_sec * 1000000
>>  					 + sq_usage.ru_stime.tv_usec);
>>  			sq_work_time = sq->work_time;
>>  		}
>> +		rcu_read_unlock();
>>  	}
> 
> Don't think this will work, if we're racing with the mmput and then end
> up doing that inside an RCU read locked region...

I think it needs to look more like:

rcu_read_lock();
tsk = rcu_dereference(sq->thread);

if (tsk) {
	get_task_struct(tsk);
	rcu_read_unlock();
	[...] /* getrusage stuff */
	put_task_struct(tsk);
} else {
	rcu_read_unlock();
}

and then it would be sane and avoid calling getrusage() with the rcu
read lock held.

If you agree, can you send a v2 with those changes?

>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>> index 03c699493b5a..0625a421626f 100644
>> --- a/io_uring/sqpoll.c
>> +++ b/io_uring/sqpoll.c
>> @@ -270,7 +270,8 @@ static int io_sq_thread(void *data)
>>  	/* offload context creation failed, just exit */
>>  	if (!current->io_uring) {
>>  		mutex_lock(&sqd->lock);
>> -		sqd->thread = NULL;
>> +		rcu_assign_pointer(sqd->thread, NULL);
>> +		put_task_struct(current);
>>  		mutex_unlock(&sqd->lock);
>>  		goto err_out;
>>  	}
> 
> You do this in both spots, why the put_task_struct(current)? That seems
> like that would be very wrong and instantly break. Did you run this
> patch?

For some reason I read this as the io_uring.c hunk - the puts here look
fine, ignore the noise on that part...

> ommit 3fcb9d17206e31630f802a3ab52081d1342b8ed9
> Author: Xiaobing Li <xiaobing.li@samsung.com>
> Date:   Wed Feb 28 17:12:51 2024 +0800
> 
>     io_uring/sqpoll: statistics of the true utilization of sq threads
> 
> as that is the one that added prodding at sq->thread from fdinfo.

This should still be the Fixes target though, imho.

-- 
Jens Axboe

