Return-Path: <io-uring+bounces-695-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D458862647
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 18:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 472801C20B0D
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 17:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40F273D97D;
	Sat, 24 Feb 2024 17:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="zJtAryyZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C31012B69
	for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 17:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708795233; cv=none; b=h8EsxMo8XVfP7fjhdtV1Dvq2Y1wxe2rxpdor8qxEP9f0xTU5Pq2uAcpJVWhU/s0ycdSaaoHcw+oANcv+pMb8MA1MakmEvVzlZrsqToZh/mh2FFsMfl5Up1YjnvStojMTEzlom+XGGfIQmRcNkr51mKstTr69ZIARze+yHySS6bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708795233; c=relaxed/simple;
	bh=5fuqECdnRWfGNppfVH4YcVu+3FUhEL520NG1wBlHxcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cg0UjHsFSnlJxMCFIV35pMJ4UgumJv5CE5wzIVAHzSmIUnTzDqrSK1DWpveU39v+6ZgIfZAYvQB3xg0YGyc1fB+NAldaZ2uHwUFJFoNBEP3YOe6qlmAQ60n9isP3kKEg9YuDX3A3rXEBt+yt9HhDYJCpG/TaCafelELITeR8Izs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=zJtAryyZ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d7881b1843so14785315ad.3
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 09:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1708795231; x=1709400031; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wch3uukdiIochmzA1jOJlmpZDdhZLK7KCp1NDqBBr3A=;
        b=zJtAryyZD3k1lZp1NhHRavVHnN0ASBhFdhtdDMkjGnLS6AfMyzTp/1epsZaIh34y2a
         VB63C+2KTCmeDLCpagCFgkdQ4mZRkfKbKJsh6fZqbity6G6T/MKttxgW5nk7OjRJ7AZ+
         EKP3O7CNF47in5uof2qqovwL6PJUtcTKzNb3Rnl5vagMyjdNfpDSgTCZ9hefPXxmmaf9
         6H10wzJ8xSWeQTVVSQ4cD4Lt9XgvneU6QQa64wsBNW7NvN6SBHS0kEkvRUP7uWsUPhTX
         t6rr9p71xflRgdb62gFbdjBJEW2XJSYjOSgdLFSsG9LUKKy8l3IjGJ5TuGJhIqJYNps+
         seow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708795231; x=1709400031;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wch3uukdiIochmzA1jOJlmpZDdhZLK7KCp1NDqBBr3A=;
        b=Aa0a+lgke5IzbI+ZwOqA3CWoKeIg8z4f+q6GfnYY7cKej/nJK0wRQrEL6a/z7i5swx
         WKSq5q+8pYzkPNiNAiXdClsgGZiTeD7YcVtaByWWdPl1PQ9BNemQCI95Id1vNXxKEDmA
         LnAcwdWxU44F+XkdGXYcUVmKTBMuppbz55xMKL0/EkQtJVb2/RqE9jcVqIvrUhhAZzlZ
         trw0DV4TtDFWKHNznneNZErEpJ9KQMw+n5POctauihM2r1UB3kFDP2tP2efaGa5eYXJE
         hHfJfngx2M4XbLs7xcq9SH9914yZuK1GC/k63i6N7FZ+iZPla3NZ/BJ3ivpUesxNLx9t
         7obQ==
X-Forwarded-Encrypted: i=1; AJvYcCUex9dw3GbSUWpeG2rKgOHqbL+X3CNSvag+1G0x3HNGFik6uUSmJ1ACRwxN5AYL66chIy7ZPW7lIohhM5dND1YfJtIibokYA5I=
X-Gm-Message-State: AOJu0YxdVnBNgeH5SXVuj/qOAK4QlTm5Omm2HNi+p9RLQgbv08U+EG3o
	16/sTtuy+AmQxauk85N7OH8UFdIpuh5L8z6MfjqBWEUSdIsiSPx2egQbEFMAWHQ=
X-Google-Smtp-Source: AGHT+IGv5QO7SJAkiYuE2SeiqqokXJecSvcGebIAi/PgKC2F0zTA0c3tm4zh6a63D1aWRHiXWKVEFA==
X-Received: by 2002:a17:902:9a08:b0:1dc:6b72:6467 with SMTP id v8-20020a1709029a0800b001dc6b726467mr3318090plp.38.1708795230875;
        Sat, 24 Feb 2024 09:20:30 -0800 (PST)
Received: from [192.168.1.24] (71-212-1-72.tukw.qwest.net. [71.212.1.72])
        by smtp.gmail.com with ESMTPSA id g12-20020a170902f74c00b001dbba4c8289sm1232711plw.202.2024.02.24.09.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Feb 2024 09:20:30 -0800 (PST)
Message-ID: <2106a112-35ca-4e02-a501-546f8d734103@davidwei.uk>
Date: Sat, 24 Feb 2024 09:20:29 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] io_uring: only account cqring wait time as iowait
 if enabled for a ring
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20240224050735.1759733-1-dw@davidwei.uk>
 <678382b5-0448-4f4d-b7b7-8df7592d77a4@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <678382b5-0448-4f4d-b7b7-8df7592d77a4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-02-24 07:31, Pavel Begunkov wrote:
> On 2/24/24 05:07, David Wei wrote:
>> Currently we unconditionally account time spent waiting for events in CQ
>> ring as iowait time.
>>
>> Some userspace tools consider iowait time to be CPU util/load which can
>> be misleading as the process is sleeping. High iowait time might be
>> indicative of issues for storage IO, but for network IO e.g. socket
>> recv() we do not control when the completions happen so its value
>> misleads userspace tooling.
>>
>> This patch gates the previously unconditional iowait accounting behind a
>> new IORING_REGISTER opcode. By default time is not accounted as iowait,
>> unless this is explicitly enabled for a ring. Thus userspace can decide,
>> depending on the type of work it expects to do, whether it wants to
>> consider cqring wait time as iowait or not.
> 
> I don't believe it's a sane approach. I think we agree that per
> cpu iowait is a silly and misleading metric. I have hard time to
> define what it is, and I'm sure most probably people complaining
> wouldn't be able to tell as well. Now we're taking that metric
> and expose even more knobs to userspace.
> 
> Another argument against is that per ctx is not the right place
> to have it. It's a system metric, and you can imagine some system
> admin looking for it. Even in cases when had some meaning w/o
> io_uring now without looking at what flags io_uring has it's
> completely meaningless, and it's too much to ask.> 
> I don't understand why people freak out at seeing hi iowait,
> IMHO it perfectly fits the definition of io_uring waiting for
> IO / completions, but at this point it might be better to just
> revert it to the old behaviour of not reporting iowait at all.

Irrespective of how misleading iowait is, many tools include it in its
CPU util/load calculations and users then use those metrics for e.g.
load balancing. In situations with storage workloads, iowait can be
useful even if its usefulness is limited. The problem that this patch is
trying to resolve is in mixed storage/network workloads on the same
system, where iowait has some usefulness (due to storage workloads)
_but_ I don't want network workloads contributing to the metric.

This does put the onus on userspace to do the right thing - decide
whether iowait makes sense for a workload or not. I don't have enough
kernel experience to know whether this expectation is realistic or not.
But, it is turned off by default so if userspace does not set it (which
seems like the most likely thing) then iowait accounting is off just
like the old behaviour. Perhaps we need to make it clearer to storage
use-cases to turn it on in order to get the optimisation?

> And if we want to save the cpu freq iowait optimisation, we
> should just split notion of iowait reporting and iowait cpufreq
> tuning.

Yeah, that could be an option. I'll take a look at it.

> 
> 
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>   include/linux/io_uring_types.h |  1 +
>>   include/uapi/linux/io_uring.h  |  3 +++
>>   io_uring/io_uring.c            |  9 +++++----
>>   io_uring/register.c            | 17 +++++++++++++++++
>>   4 files changed, 26 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index bd7071aeec5d..c568e6b8c9f9 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -242,6 +242,7 @@ struct io_ring_ctx {
>>           unsigned int        drain_disabled: 1;
>>           unsigned int        compat: 1;
>>           unsigned int        iowq_limits_set : 1;
>> +        unsigned int        iowait_enabled: 1;
>>             struct task_struct    *submitter_task;
>>           struct io_rings        *rings;
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 7bd10201a02b..b068898c2283 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -575,6 +575,9 @@ enum {
>>       IORING_REGISTER_NAPI            = 27,
>>       IORING_UNREGISTER_NAPI            = 28,
>>   +    /* account time spent in cqring wait as iowait */
>> +    IORING_REGISTER_IOWAIT            = 29,
>> +
>>       /* this goes last */
>>       IORING_REGISTER_LAST,
>>   diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index cf2f514b7cc0..7f8d2a03cce6 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -2533,12 +2533,13 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>           return 0;
>>         /*
>> -     * Mark us as being in io_wait if we have pending requests, so cpufreq
>> -     * can take into account that the task is waiting for IO - turns out
>> -     * to be important for low QD IO.
>> +     * Mark us as being in io_wait if we have pending requests if enabled
>> +     * via IORING_REGISTER_IOWAIT, so cpufreq can take into account that
>> +     * the task is waiting for IO - turns out to be important for low QD
>> +     * IO.
>>        */
>>       io_wait = current->in_iowait;
>> -    if (current_pending_io())
>> +    if (ctx->iowait_enabled && current_pending_io())
>>           current->in_iowait = 1;
>>       ret = 0;
>>       if (iowq->timeout == KTIME_MAX)
>> diff --git a/io_uring/register.c b/io_uring/register.c
>> index 99c37775f974..fbdf3d3461d8 100644
>> --- a/io_uring/register.c
>> +++ b/io_uring/register.c
>> @@ -387,6 +387,17 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
>>       return ret;
>>   }
>>   +static int io_register_iowait(struct io_ring_ctx *ctx, int val)
>> +{
>> +    int was_enabled = ctx->iowait_enabled;
>> +
>> +    if (val)
>> +        ctx->iowait_enabled = 1;
>> +    else
>> +        ctx->iowait_enabled = 0;
>> +    return was_enabled;
>> +}
>> +
>>   static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>>                      void __user *arg, unsigned nr_args)
>>       __releases(ctx->uring_lock)
>> @@ -563,6 +574,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>>               break;
>>           ret = io_unregister_napi(ctx, arg);
>>           break;
>> +    case IORING_REGISTER_IOWAIT:
>> +        ret = -EINVAL;
>> +        if (arg)
>> +            break;
>> +        ret = io_register_iowait(ctx, nr_args);
>> +        break;
>>       default:
>>           ret = -EINVAL;
>>           break;
> 

