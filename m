Return-Path: <io-uring+bounces-88-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2FCE7EBB37
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 03:34:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21D661C20912
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 02:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F7117E;
	Wed, 15 Nov 2023 02:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="u8clWkIa"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45305395
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 02:34:27 +0000 (UTC)
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F8FC8
	for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 18:34:26 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-779d0c05959so66608885a.1
        for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 18:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700015665; x=1700620465; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kuboZ7P9JaqBfHE5a1R6pwyUh8T1a6sVJgVAWQe5ckA=;
        b=u8clWkIasMsilStKhxg16aeNXTKvhBt/gjPqZp1xZKg0swOxvCZ62GjtvjeLcqktHu
         EQ1rbFUM+6l45ZROK+S5K+icjRE/i9+7HroLW56YJuDz2CQN+Io8LEApSyKdHe08mRQS
         oft5offqslgcfIsHspXUqTpcrg8pW8xG3QPXTSqbrVyTEIDvghVdj5hyVyDvYG0xQd06
         nI2YsQkFuLE89gEVOOxPtMv6oXSfCks5rdMtAQ1P0tJyJtl9LtAdW0VMpbm+Kye7czV9
         xZX0bjfWOmzxaZlgN6DqiZqjq8XLMGkSCoXAEf3xqipagI7Z04NzC6ng/gAXJUh93bEb
         8fyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700015665; x=1700620465;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kuboZ7P9JaqBfHE5a1R6pwyUh8T1a6sVJgVAWQe5ckA=;
        b=UiZS6IwQepbwexhrXFubV8AwIx1Q/iODDyX8okVRloe9Nt5+1v+Aph4PUO6TfdZzEJ
         O0WO5VGq+mTCIP17IMPviI1Cl8p2bqTXkRcnrQN1BepjmA5IZ7LHQJBhvYbu/Nf+h0yY
         bhTMGK+2CNbhQ2Ew5aI0cjB4iQRHieG5Nxb54Cnn2plTQOIbkjajCqTdFPa/Er8W0i7Y
         mQ4hej8h5a4PWpsnuaTLi1Fmgjlyn6GtgxYegSPEsyHsax8nnzhKe13Kw/CmZL4rtDVO
         IClXHHnlFAyEeHeD6t3lU//9svns00IIXPWMkVmZNLEHpM5Y/RBhR3XAepCuB3QaLvZF
         hTFQ==
X-Gm-Message-State: AOJu0YweUFmNgqZ5kOLg7ZsBdg9RFLjpql1RXlqo1lxl5iyVenDOCP9f
	DtOR3ayDsFtYAyjJoWT/7QpTNg==
X-Google-Smtp-Source: AGHT+IFd9YBWf6P+K8TCeSXMaAgR3okMXfjIDQyIfU+FjyfKUs2oNAeUjSZcU3rZwzGyyK+ZJKAzVg==
X-Received: by 2002:a05:622a:7704:b0:41c:c821:d5b5 with SMTP id ki4-20020a05622a770400b0041cc821d5b5mr3803924qtb.2.1700015665529;
        Tue, 14 Nov 2023 18:34:25 -0800 (PST)
Received: from ?IPV6:2600:380:916a:612a:1723:80aa:a58a:abfa? ([2600:380:916a:612a:1723:80aa:a58a:abfa])
        by smtp.gmail.com with ESMTPSA id s23-20020ac85297000000b00419c39dd28fsm3172919qtn.20.2023.11.14.18.34.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Nov 2023 18:34:24 -0800 (PST)
Message-ID: <58d54401-6e8f-4052-8421-399a197cb502@kernel.dk>
Date: Tue, 14 Nov 2023 19:34:23 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/fdinfo: remove need for sqpoll lock for
 thread/pid retrieval
Content-Language: en-US
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring <io-uring@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>
References: <202966f7-3e79-4913-a7db-6b2fc230dda7@kernel.dk>
 <871qcs3qp1.fsf@suse.de>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <871qcs3qp1.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/14/23 3:39 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> A previous commit added a trylock for getting the SQPOLL thread info via
>> fdinfo, but this introduced a regression where we often fail to get it if
>> the thread is busy. For that case, we end up not printing the current CPU
>> and PID info.
>>
>> Rather than rely on this lock, just print the pid we already stored in
>> the io_sq_data struct, and ensure we update the current CPU every time we
>> are going to sleep. The latter won't potentially be 100% accurate, but
>> that wasn't the case before either as the task can get migrated at any
>> time unless it has been pinned at creation time.
>>
>> We retain keeping the io_sq_data dereference inside the ctx->uring_lock,
>> as it has always been, as destruction of the thread and data happen below
>> that. We could make this RCU safe, but there's little point in doing that.
>>
>> With this, we always print the last valid information we had, rather than
>> have spurious outputs with missing information.
>>
>> Fixes: 7644b1a1c9a7 ("io_uring/fdinfo: lock SQ thread while retrieving thread cpu/pid")
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> v2: actually remember to use the cached values... also update ->sq_cpu
>>     when we initially set it up, if it's not pinned to a given CPU.
>>
>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>> index f04a43044d91..976e9500f651 100644
>> --- a/io_uring/fdinfo.c
>> +++ b/io_uring/fdinfo.c
>> @@ -145,13 +145,8 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>  	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
>>  		struct io_sq_data *sq = ctx->sq_data;
>>  
>> -		if (mutex_trylock(&sq->lock)) {
>> -			if (sq->thread) {
>> -				sq_pid = task_pid_nr(sq->thread);
>> -				sq_cpu = task_cpu(sq->thread);
>> -			}
>> -			mutex_unlock(&sq->lock);
>> -		}
>> +		sq_pid = sq->task_pid;
>> +		sq_cpu = sq->sq_cpu;
>>  	}
>>  
>>  	seq_printf(m, "SqThread:\t%d\n", sq_pid);
>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>> index bd6c2c7959a5..ecb00322a4e5 100644
>> --- a/io_uring/sqpoll.c
>> +++ b/io_uring/sqpoll.c
>> @@ -229,10 +229,12 @@ static int io_sq_thread(void *data)
>>  	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
>>  	set_task_comm(current, buf);
>>  
>> -	if (sqd->sq_cpu != -1)
>> +	if (sqd->sq_cpu != -1) {
>>  		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
>> -	else
>> +	} else {
>>  		set_cpus_allowed_ptr(current, cpu_online_mask);
>> +		sqd->sq_cpu = task_cpu(current);
>> +	}
>>  
>>  	mutex_lock(&sqd->lock);
>>  	while (1) {
>> @@ -291,6 +293,7 @@ static int io_sq_thread(void *data)
>>  			}
>>  
>>  			if (needs_sched) {
>> +				sqd->sq_cpu = task_cpu(current);
> 
> Don't you also need to update sqd->sq_cpu in io_sqd_handle_event before
> releasing the lock?  sqpoll might get migrated after the following
> schedule and then parked, in which case sqd->sq_cpu will not be up to
> date for a while.
> 
> Other than that, I think the patch is fine.

We probably should, and I also forgot that we can just use
raw_smp_processor_id() at this point. I'll send out a v3.

-- 
Jens Axboe


