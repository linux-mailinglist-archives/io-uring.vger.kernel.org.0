Return-Path: <io-uring+bounces-693-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D35828625D9
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 16:48:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 600BF1F2189B
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 15:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2891317E9;
	Sat, 24 Feb 2024 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="clHvKtx0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B37146521
	for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 15:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708789695; cv=none; b=b/kI/h3bIMJ/Im6oTzIs99EEWMQOB3IsjVSaRjun1xxX74n/VmgNTIaBtJcwTsJtpyLnsa24LqJ5VOiFCt35NKv612fIKGKIAlTaiLSvTmgRRX05JibyDGKIqA1603y/ujjQCSi/wCjeYRsQ9hv44tlCY+yKiY2+QZ2rwMIyKbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708789695; c=relaxed/simple;
	bh=NdrItLg4UF7J6BjLfYpayTwNOeBP24dvYq+DPff3zOo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R3UwZN+JfhugcxpN5yiLpHR82RRB9g4wbunOuJ89RouLW3rOL42qqkeq9goeYYBJtiXzGZoW6EtFt9iJWDAzUD89eFrO7+uUNiM4XMaq6tBlb4neyyY6bjQopswhO1YxtS9RI/gE+z736nHHjlDpFARXbS7S3mZTgi74HYxjbq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=clHvKtx0; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-565c6aca5e1so11311a12.1
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 07:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708789691; x=1709394491; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PzsLhuJmvmtaiRpjIkGfpMvd9RWVa6A25MjEt9ZEv00=;
        b=clHvKtx0jnqUhz8FkFCmDXUzlfX6R4QUv4McXhjLyA6RrPzTXdBttgg7jlVamRB+m8
         ncIgDqrQYH5K3WU0tIPhYKEf68xtBaI6n63nCwxRH3qGTfi6mxgPZ20qdjLx/oRq6eOr
         +Iaewbw3dz4EESvjEnclxyewhn5mQD4XWU9J2uvI1qijc4FF6fX0+QmVSbNnXj15sG8r
         X1Qf6mUuKZMyePwVwCemdCepmweRJ7+DOBE1rTRylsSxioIzSQYnTKNt2eqbGUr91bLb
         LILykbjuVTPUrJYlRfqtDPaApwI85uRHyQ5pNqA7/mCCNd4TIAXA+v4Qfe/yBihlrtJA
         43Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708789691; x=1709394491;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PzsLhuJmvmtaiRpjIkGfpMvd9RWVa6A25MjEt9ZEv00=;
        b=PkOs2E9LGp2zmRWfDw+SBER1MaLYtv8UIsV9i9KhwFE+i7Eu0p0PKIzZmR26IU0oPS
         mwffNgh0SZN+CrxyRFhlonc6/pkeefUs/fDXMHOXwJJSRq2i+9WQ7aqHmCkY86/FR7G2
         a3fhRLtW8XV8kWaJTnjrrnrFgrwHs3rJooIShOVU4jNOOtgvoEoO1LKa5xPH1J+jcSfN
         +D+yY//8OYQZQn8anWKgBv17VlSdSWYaaHpbUjlxdXOY8ckgVUBQkITQAYMK8cIzEhBT
         QPJ2c2k9hDoZnDLFsWxraoDOFbyXk7qotxEzeRIUxTVWlKXuKUEmFkd5tGX7ROKoZVwV
         tQXw==
X-Forwarded-Encrypted: i=1; AJvYcCXgAah5NI+/GrmfC+acqmSy9jogPg2+oh9BB8DkvunQvrtkGQPvKq8rfSxucjNKqz53yE7DX1BpZD+yk/pabXXlqkolFR6sUWo=
X-Gm-Message-State: AOJu0YxhEKo4mJHub4EcBT+yfH3REsqKtEPQxz5KU7NOfRhZ4vlmXNS+
	x4AEdFyM0GUojl5m4FQdQHyXIdEjcJqRHdvQxNnjj90UDz8YJFr5r6CqQXxi
X-Google-Smtp-Source: AGHT+IE+YN/Hce7Qjkz9tMtVxdTNoEM1nKLuCgcb2UlDu7v0d1td5hmLffs+qRnFk3a9Si3ctToJOA==
X-Received: by 2002:aa7:d0c8:0:b0:565:50d4:c6dc with SMTP id u8-20020aa7d0c8000000b0056550d4c6dcmr2277740edo.16.1708789691269;
        Sat, 24 Feb 2024 07:48:11 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.140])
        by smtp.gmail.com with ESMTPSA id b18-20020a0564021f1200b00563ec73bbafsm647725edb.46.2024.02.24.07.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Feb 2024 07:48:10 -0800 (PST)
Message-ID: <678382b5-0448-4f4d-b7b7-8df7592d77a4@gmail.com>
Date: Sat, 24 Feb 2024 15:31:30 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] io_uring: only account cqring wait time as iowait
 if enabled for a ring
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20240224050735.1759733-1-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240224050735.1759733-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/24 05:07, David Wei wrote:
> Currently we unconditionally account time spent waiting for events in CQ
> ring as iowait time.
> 
> Some userspace tools consider iowait time to be CPU util/load which can
> be misleading as the process is sleeping. High iowait time might be
> indicative of issues for storage IO, but for network IO e.g. socket
> recv() we do not control when the completions happen so its value
> misleads userspace tooling.
> 
> This patch gates the previously unconditional iowait accounting behind a
> new IORING_REGISTER opcode. By default time is not accounted as iowait,
> unless this is explicitly enabled for a ring. Thus userspace can decide,
> depending on the type of work it expects to do, whether it wants to
> consider cqring wait time as iowait or not.

I don't believe it's a sane approach. I think we agree that per
cpu iowait is a silly and misleading metric. I have hard time to
define what it is, and I'm sure most probably people complaining
wouldn't be able to tell as well. Now we're taking that metric
and expose even more knobs to userspace.

Another argument against is that per ctx is not the right place
to have it. It's a system metric, and you can imagine some system
admin looking for it. Even in cases when had some meaning w/o
io_uring now without looking at what flags io_uring has it's
completely meaningless, and it's too much to ask.

I don't understand why people freak out at seeing hi iowait,
IMHO it perfectly fits the definition of io_uring waiting for
IO / completions, but at this point it might be better to just
revert it to the old behaviour of not reporting iowait at all.
And if we want to save the cpu freq iowait optimisation, we
should just split notion of iowait reporting and iowait cpufreq
tuning.


> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>   include/linux/io_uring_types.h |  1 +
>   include/uapi/linux/io_uring.h  |  3 +++
>   io_uring/io_uring.c            |  9 +++++----
>   io_uring/register.c            | 17 +++++++++++++++++
>   4 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index bd7071aeec5d..c568e6b8c9f9 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -242,6 +242,7 @@ struct io_ring_ctx {
>   		unsigned int		drain_disabled: 1;
>   		unsigned int		compat: 1;
>   		unsigned int		iowq_limits_set : 1;
> +		unsigned int		iowait_enabled: 1;
>   
>   		struct task_struct	*submitter_task;
>   		struct io_rings		*rings;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 7bd10201a02b..b068898c2283 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -575,6 +575,9 @@ enum {
>   	IORING_REGISTER_NAPI			= 27,
>   	IORING_UNREGISTER_NAPI			= 28,
>   
> +	/* account time spent in cqring wait as iowait */
> +	IORING_REGISTER_IOWAIT			= 29,
> +
>   	/* this goes last */
>   	IORING_REGISTER_LAST,
>   
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index cf2f514b7cc0..7f8d2a03cce6 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2533,12 +2533,13 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>   		return 0;
>   
>   	/*
> -	 * Mark us as being in io_wait if we have pending requests, so cpufreq
> -	 * can take into account that the task is waiting for IO - turns out
> -	 * to be important for low QD IO.
> +	 * Mark us as being in io_wait if we have pending requests if enabled
> +	 * via IORING_REGISTER_IOWAIT, so cpufreq can take into account that
> +	 * the task is waiting for IO - turns out to be important for low QD
> +	 * IO.
>   	 */
>   	io_wait = current->in_iowait;
> -	if (current_pending_io())
> +	if (ctx->iowait_enabled && current_pending_io())
>   		current->in_iowait = 1;
>   	ret = 0;
>   	if (iowq->timeout == KTIME_MAX)
> diff --git a/io_uring/register.c b/io_uring/register.c
> index 99c37775f974..fbdf3d3461d8 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -387,6 +387,17 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
>   	return ret;
>   }
>   
> +static int io_register_iowait(struct io_ring_ctx *ctx, int val)
> +{
> +	int was_enabled = ctx->iowait_enabled;
> +
> +	if (val)
> +		ctx->iowait_enabled = 1;
> +	else
> +		ctx->iowait_enabled = 0;
> +	return was_enabled;
> +}
> +
>   static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>   			       void __user *arg, unsigned nr_args)
>   	__releases(ctx->uring_lock)
> @@ -563,6 +574,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>   			break;
>   		ret = io_unregister_napi(ctx, arg);
>   		break;
> +	case IORING_REGISTER_IOWAIT:
> +		ret = -EINVAL;
> +		if (arg)
> +			break;
> +		ret = io_register_iowait(ctx, nr_args);
> +		break;
>   	default:
>   		ret = -EINVAL;
>   		break;

-- 
Pavel Begunkov

