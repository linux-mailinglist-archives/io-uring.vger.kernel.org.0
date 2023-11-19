Return-Path: <io-uring+bounces-99-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 230DF7F091F
	for <lists+io-uring@lfdr.de>; Sun, 19 Nov 2023 22:23:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53F751C2074C
	for <lists+io-uring@lfdr.de>; Sun, 19 Nov 2023 21:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916F91864E;
	Sun, 19 Nov 2023 21:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bz9UrMSJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E555E5
	for <io-uring@vger.kernel.org>; Sun, 19 Nov 2023 13:23:23 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-27fe16e8e02so615697a91.0
        for <io-uring@vger.kernel.org>; Sun, 19 Nov 2023 13:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700429003; x=1701033803; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cDZ0tr7sLw15e0Y2zQ+3wWYWoAA+Epud7awZIvr58DQ=;
        b=Bz9UrMSJbC+fgS1mq2tBW+GEaYUM6c/I9xh0UFHUnyVnsjBv/3n2RiLibpOLanl4oC
         RF1BDsDFIlWLtwvh/DRV/ZlXBwIbvA7OG6FFupgDjdDcsetgKXf4G0zupaOkcQOhPtRu
         AlTUGE2r2kBNjCGmLhIgkQNm7VRSCMBoQt/FNnGwsstpyve0Xy57ftWe7oVsaTYjCU3p
         24R3C534Ae+pMqrF/cgrEppB+PdV3XjZ3MpoRGjzHVLTZnnVbv/payy10f4ns3CslZTI
         ELwUH/zkXwSCdiTIYXAl0emW/UKlXALU1flFe0WM9Pg/GIwnZGHUd+PWuTuLBpb69vNq
         uQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700429003; x=1701033803;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cDZ0tr7sLw15e0Y2zQ+3wWYWoAA+Epud7awZIvr58DQ=;
        b=tkeboarRasl2nZo9zyJ4fMLjorpxJc6sJicCP8GjMwZ3MfAC1V0iHVmaJGcw8vEMUt
         a6dKPCpgvqX9q+62UWpM2AaGB1W9ih33uY0jyPPiu2ED+//etlP5PuHnE4OnfvFZsvKh
         R7qEIjXsQmuxmZxkp2+k68XrfIpfyvRK3qPPlLl8NDSsZUpjGlh28JkEPQvA+1zPf6Zl
         GGdeqb+bE17bvmCiLcARMkh35VVRfZZuRBoEVvFaHbyyIPl73rBMn82Gi6KwrILEl0BI
         ZndsJaKLwOXOwWcn9ar+VvHBIla321Sk4KtfAl+G9NbDtLbtWdca5xR4CO5i3UtxHIRb
         5SUw==
X-Gm-Message-State: AOJu0YxAV2TSCMVFufNATzW8pyktsWhomLCL9MlP4UeMCololPGlMG9E
	k6t8NnmHqxzZJKmwck5YG/nyUvm2s/NP56IAOy9EBQ==
X-Google-Smtp-Source: AGHT+IEQbeZQaO4oqco/CsKpjQzGLYk8ebqLTudDkjx+mdzQFu2rslBQXRq3Qxac1/Yj0oqvRsoiXA==
X-Received: by 2002:a17:90b:4392:b0:283:a179:963f with SMTP id in18-20020a17090b439200b00283a179963fmr5912567pjb.2.1700429002853;
        Sun, 19 Nov 2023 13:23:22 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id r21-20020a17090aa09500b0027782f611d1sm6216653pjp.36.2023.11.19.13.23.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Nov 2023 13:23:22 -0800 (PST)
Message-ID: <2d187279-0f9d-4062-a319-79c73adc5cde@kernel.dk>
Date: Sun, 19 Nov 2023 14:23:20 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io_uring/fdinfo: remove need for sqpoll lock for
 thread/pid retrieval
Content-Language: en-US
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
 joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
 ruyi.zhang@samsung.com
References: <605eac76-ec47-436b-872a-f6e8b4094293@kernel.dk>
 <CGME20231118032740epcas5p20b6aad6264323376fa024bc2a56f0990@epcas5p2.samsung.com>
 <20231118031951.21764-1-xiaobing.li@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231118031951.21764-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/17/23 8:19 PM, Xiaobing Li wrote:
> On 11/15/23 6:42 AM, Jens Axboe wrote:
>> 	 */
>> 	has_lock = mutex_trylock(&ctx->uring_lock);
>>
>> -	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
>> -		struct io_sq_data *sq = ctx->sq_data;
>> -
>> -		sq_pid = sq->task_pid;
>> -		sq_cpu = sq->sq_cpu;
>> +	if (ctx->flags & IORING_SETUP_SQPOLL) {
>> +		struct io_sq_data *sq;
>> +
>> +		rcu_read_lock();
>> +		sq = READ_ONCE(ctx->sq_data);
>> +		if (sq) {
>> +			sq_pid = sq->task_pid;
>> +			sq_cpu = sq->sq_cpu;
>> +		}
>> +		rcu_read_unlock();
>> 	}
>>
>> 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>> index 65b5dbe3c850..583c76945cdf 100644
>> --- a/io_uring/sqpoll.c
>> +++ b/io_uring/sqpoll.c
>> @@ -70,7 +70,7 @@ void io_put_sq_data(struct io_sq_data *sqd)
>> 		WARN_ON_ONCE(atomic_read(&sqd->park_pending));
>>
>> 		io_sq_thread_stop(sqd);
>> -		kfree(sqd);
>> +		kfree_rcu(sqd, rcu);
>> 	}
>> }
>>
>> @@ -313,7 +313,7 @@ static int io_sq_thread(void *data)
>> 	}
>>
>> 	io_uring_cancel_generic(true, sqd);
>> -	sqd->thread = NULL;
>> +	WRITE_ONCE(sqd->thread, NULL);
>> 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>> 		atomic_or(IORING_SQ_NEED_WAKEUP, &ctx->rings->sq_flags);
>> 	io_run_task_work();
>> @@ -411,7 +411,7 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
>> 			goto err_sqpoll;
>> 		}
>>
>> -		sqd->thread = tsk;
>> +		WRITE_ONCE(sqd->thread, tsk);
>> 		ret = io_uring_alloc_task_context(tsk, ctx);
>> 		wake_up_new_task(tsk);
>> 		if (ret)
>> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>> index 8df37e8c9149..0cf0c5833a27 100644
>> --- a/io_uring/sqpoll.h
>> +++ b/io_uring/sqpoll.h
>> @@ -18,6 +18,8 @@ struct io_sq_data {
>>
>> 	unsigned long		state;
>> 	struct completion	exited;
>> +
>> +	struct rcu_head		rcu;
>> };
>>
>> int io_sq_offload_create(struct io_ring_ctx *ctx, struct io_uring_params *p);
> 
> I tested this and it worked after adding RCU lock.
> It consistently outputs correct results.
> 
> The results of a simple test are as follows:
> Every 0.5s: cat /proc/10212/fdinfo/6 | grep Sq
> SqMask: 0x3
> SqHead: 17422716
> SqTail: 17422716
> CachedSqHead:   17422716
> SqThread:       10212
> SqThreadCpu:    73
> SqBusy: 97%
> -------------------------------------------------------------
> But the name of the sq thread is "iou-sqp-" + "the PID of its parent process":
>     PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
>   10211 root      20   0  184408   8192      0 R  99.9   0.0   4:01.42 fio
>   10212 root      20   0  184408   8192      0 R  99.9   0.0   4:01.48 iou-sqp-10211
> Is this the originally desired effect?

That's how it has always been, it's the sqpoll thread belonging to that
parent.

-- 
Jens Axboe


