Return-Path: <io-uring+bounces-3231-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C6897C30C
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 04:59:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2832E1F2281C
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 02:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF13B156E4;
	Thu, 19 Sep 2024 02:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NOgV1qXV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69085125DE
	for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 02:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726714777; cv=none; b=gz0rlU/++ISeAiwJ9sasE8pbELmSyberLyM6BxM+kDp98aHa3BrgxsW4gzwtWkkNMGIefYtD8kx7/ubU5iPUka7sccWt3C0/dyz2opjCSMSTLkWVOiBt5B1JTTmZINu687KTSMPg5SZf2mlM4TJpfRHZyMq4JX2fVEbCY3GED5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726714777; c=relaxed/simple;
	bh=JomdbaigvuCqbsbgeRQWsLuld5x+bjvG+g/+e+z//8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ar/EkIDKjfp+n0hwAxM9W1jAOnbYZElHFKl14TfAHE1dhiEDYfq9dpsXPdC9v2bgt6f4ib3wHImiMn2/wNBgPAZKFj3KxITwvJdKqgIVypqsfWF5FK9kn/ASOKYUEzH543H6Vlr2JoWiIf56T3aUPBgZR5LxppRJnIiFK+DWPso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NOgV1qXV; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a8d29b7edc2so36313066b.1
        for <io-uring@vger.kernel.org>; Wed, 18 Sep 2024 19:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726714771; x=1727319571; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R55u0GBo+bW9A/PWdjSvmvFDkYExmph5qqMGKGkkhjg=;
        b=NOgV1qXVhJvYY3G7zXy0nDqydirXHHDukz9G4IFqMgh/W02zXrs8rxzvWEoyZT9rR4
         vGcZpYkkzVaGsEuyzG6X+xKvzEazHz5O/82QCWD+z3FplcDY4LrfN2ElB0sJVgpft0wU
         QZR3X0TTFQ5XemgspX6rYFwe2KuohyskI2pRfmydev5MybwlyaBHtK/ROfKefzrO4HFX
         9WdeWgcYeJI4LDjeSx85his5Tjw7bnwuib94T5ISzJ4NENc9/XHjHdNqxQtImnAUMA0O
         8aGLuulfcdtqwC7zP31SEUroKNy4175/oW59XOLcVXXI8U0S/BTMdN34k+AUmewNo8K8
         sOgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726714771; x=1727319571;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R55u0GBo+bW9A/PWdjSvmvFDkYExmph5qqMGKGkkhjg=;
        b=tl4nP3Yq08IYbb6MTscZCeBN5/Sahfh96ztlwYmEQC0Pz5VgNZH2wuk82AlygT1DWf
         UL2Z34sEmG9DJ37LuVPrkwgaqAKREvHqIJh7B5c+8cOhjPJyu1syH92pvv3C7le+joSH
         aWwKxOrCKt+lrR9kXIyyUjXheEkbiBwe8dQMMdh8/STWb+lR6nC3sL1v8Q2unLLg/lWH
         KIgoWfnr8rZvyA+tjDQzHduv3x1HLWLQ2GVx9UYzxvFerb7ufTsiPJ8AV+BG6NG0tYwL
         ga3xXpAOSaY87Oi8bXSThbR/3fUWLBI4rpmlabeg5OdXlRozlltMFaISqaenmJkKArW0
         RE4g==
X-Forwarded-Encrypted: i=1; AJvYcCX5d5QijyviXrNXBEPrkyUKjtMTTghizQxMUr6yQp/EZhvp5oK0y8zIHcx4T4e8F5nS+hz/qHHvlg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEyQhRgek263pFGEFRVrUuoJPZncTD36SnBYWmJ3AAzOQlMp0X
	JZxKQqCT2IOKYiPbFC7VvqyF1x97vXnK5aIagsIfKc/wnyaPi6Rm2vabb0IUVjeKgDgjmwT3Hrx
	+9rOMbw==
X-Google-Smtp-Source: AGHT+IEGgPqm99mswfeZ6bScibJgvJ0z7TbURgFL0I6nkLxiYX10y1e1d8O5SBnKWkjuxuKYTgv1PQ==
X-Received: by 2002:a17:907:7b8a:b0:a90:b67e:7aa9 with SMTP id a640c23a62f3a-a90b67e809dmr368370566b.55.1726714771250;
        Wed, 18 Sep 2024 19:59:31 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90610966e2sm669803566b.16.2024.09.18.19.59.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 19:59:29 -0700 (PDT)
Message-ID: <050c85eb-177f-4ef5-93ed-b5d1179b4015@kernel.dk>
Date: Wed, 18 Sep 2024 20:59:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] io_uring/napi: add static napi tracking strategy
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1726589775.git.olivier@trillion01.com>
 <edca1df43f5114f91f9d8ea95e2e8769ec6792b4.1726589775.git.olivier@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <edca1df43f5114f91f9d8ea95e2e8769ec6792b4.1726589775.git.olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/18/24 6:59 AM, Olivier Langlois wrote:
> add the static napi tracking strategy that allows the user to manually
> manage the napi ids list to busy poll and offload the ring from
> dynamically update the list.

Add the static napi tracking strategy. That allows the user to manually
manage the napi ids list for busy polling, and eliminate the overhead of
dynamically updating the list from the fast path.

Maybe?

> index b1e0e0d85349..6f0e40e1469c 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -46,6 +46,46 @@ static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +static __cold void common_tracking_show_fdinfo(struct io_ring_ctx *ctx,
> +					       struct seq_file *m,
> +					       const char *tracking_strategy)
> +{
> +	seq_puts(m, "NAPI:\tenabled\n");
> +	seq_printf(m, "napi tracking:\t%s\n", tracking_strategy);
> +	seq_printf(m, "napi_busy_poll_dt:\t%llu\n", ctx->napi_busy_poll_dt);
> +	if (ctx->napi_prefer_busy_poll)
> +		seq_puts(m, "napi_prefer_busy_poll:\ttrue\n");
> +	else
> +		seq_puts(m, "napi_prefer_busy_poll:\tfalse\n");
> +}
> +
> +static __cold void napi_show_fdinfo(struct io_ring_ctx *ctx,
> +				    struct seq_file *m)
> +{
> +	unsigned int mode = READ_ONCE(ctx->napi_track_mode);
> +
> +	switch (mode) {
> +	case IO_URING_NAPI_TRACKING_INACTIVE:
> +		seq_puts(m, "NAPI:\tdisabled\n");
> +		break;
> +	case IO_URING_NAPI_TRACKING_DYNAMIC:
> +		common_tracking_show_fdinfo(ctx, m, "dynamic");
> +		break;
> +	case IO_URING_NAPI_TRACKING_STATIC:
> +		common_tracking_show_fdinfo(ctx, m, "static");
> +		break;
> +	default:
> +		seq_printf(m, "NAPI:\tunknown mode (%u)\n", mode);
> +	}
> +}
> +#else
> +static inline void napi_show_fdinfo(struct io_ring_ctx *ctx,
> +				    struct seq_file *m)
> +{
> +}
> +#endif

I think this code should go in napi.c, with the stub
CONFIG_NET_RX_BUSY_POLL in napi.h. Not a huge deal.

This also conflicts with your previous napi patch adding fdinfo support.
What kernel is this patchset based on? You should rebase it
for-6.12/io_uring, then it should apply to the development branch going
forward too.

> diff --git a/io_uring/napi.c b/io_uring/napi.c
> index 6fc127e74f10..d98b87d346ca 100644
> --- a/io_uring/napi.c
> +++ b/io_uring/napi.c
> @@ -38,22 +38,14 @@ static inline ktime_t net_to_ktime(unsigned long t)
>  	return ns_to_ktime(t << 10);
>  }
>  
> -void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
> +int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id)
>  {
>  	struct hlist_head *hash_list;
> -	unsigned int napi_id;
> -	struct sock *sk;
>  	struct io_napi_entry *e;
>  
> -	sk = sock->sk;
> -	if (!sk)
> -		return;
> -
> -	napi_id = READ_ONCE(sk->sk_napi_id);
> -
>  	/* Non-NAPI IDs can be rejected. */
>  	if (napi_id < MIN_NAPI_ID)
> -		return;
> +		return -EINVAL;
>  
>  	hash_list = &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx->napi_ht))];
>  
> @@ -62,13 +54,13 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
>  	if (e) {
>  		WRITE_ONCE(e->timeout, jiffies + NAPI_TIMEOUT);
>  		rcu_read_unlock();
> -		return;
> +		return -EEXIST;
>  	}
>  	rcu_read_unlock();
>  
>  	e = kmalloc(sizeof(*e), GFP_NOWAIT);
>  	if (!e)
> -		return;
> +		return -ENOMEM;
>  
>  	e->napi_id = napi_id;
>  	e->timeout = jiffies + NAPI_TIMEOUT;
> @@ -77,12 +69,37 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
>  	if (unlikely(io_napi_hash_find(hash_list, napi_id))) {
>  		spin_unlock(&ctx->napi_lock);
>  		kfree(e);
> -		return;
> +		return -EEXIST;
>  	}

You could abstract this out to a prep patch, having __io_napi_add()
return an error value. That would leave the meat of your patch simpler
and easier to review.

> +static int __io_napi_del_id(struct io_ring_ctx *ctx, unsigned int napi_id)
> +{
> +	struct hlist_head *hash_list;
> +	struct io_napi_entry *e;
> +
> +	/* Non-NAPI IDs can be rejected. */
> +	if (napi_id < MIN_NAPI_ID)
> +		return -EINVAL;
> +
> +	hash_list = &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx->napi_ht))];
> +	spin_lock(&ctx->napi_lock);
> +	e = io_napi_hash_find(hash_list, napi_id);
> +	if (unlikely(!e)) {
> +		spin_unlock(&ctx->napi_lock);
> +		return -ENOENT;
> +	}
> +
> +	list_del_rcu(&e->list);
> +	hash_del_rcu(&e->node);
> +	kfree_rcu(e, rcu);
> +	spin_unlock(&ctx->napi_lock);
> +	return 0;
>  }

For new code, not a bad idea to use:

	guard(spinlock)(&ctx->napi_lock);

Only one cleanup path here, but...

>  static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
> @@ -141,8 +158,26 @@ static bool io_napi_busy_loop_should_end(void *data,
>  	return false;
>  }
>  
> -static bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
> -				   void *loop_end_arg)
> +/*
> + * never report stale entries
> + */
> +static bool static_tracking_do_busy_loop(struct io_ring_ctx *ctx,
> +					 void *loop_end_arg)
> +{
> +	struct io_napi_entry *e;
> +	bool (*loop_end)(void *, unsigned long) = NULL;
> +
> +	if (loop_end_arg)
> +		loop_end = io_napi_busy_loop_should_end;
> +
> +	list_for_each_entry_rcu(e, &ctx->napi_list, list)
> +		napi_busy_loop_rcu(e->napi_id, loop_end, loop_end_arg,
> +				   ctx->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
> +	return false;
> +}
> +
> +static bool dynamic_tracking_do_busy_loop(struct io_ring_ctx *ctx,
> +					  void *loop_end_arg)
>  {
>  	struct io_napi_entry *e;
>  	bool (*loop_end)(void *, unsigned long) = NULL;

This is somewhat convoluted, but I think it'd be cleaner to have a prep
patch that just passes in both loop_end and loop_end_arg to the caller?
Some of this predates your changes here, but seems there's room for
cleaning this up. What do you think?

> diff --git a/io_uring/napi.h b/io_uring/napi.h
> index 27b88c3eb428..220574522484 100644
> --- a/io_uring/napi.h
> +++ b/io_uring/napi.h
> @@ -54,13 +54,20 @@ static inline void io_napi_add(struct io_kiocb *req)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
>  	struct socket *sock;
> +	struct sock *sk;
>  
> -	if (!READ_ONCE(ctx->napi_enabled))
> +	if (READ_ONCE(ctx->napi_track_mode) != IO_URING_NAPI_TRACKING_DYNAMIC)
>  		return;
>  
>  	sock = sock_from_file(req->file);
> -	if (sock)
> -		__io_napi_add(ctx, sock);
> +	if (!sock)
> +		return;
> +
> +	sk = sock->sk;
> +	if (!sk)
> +		return;
> +
> +	__io_napi_add_id(ctx, READ_ONCE(sk->sk_napi_id));
>  }

I like having this follow the expected outcome, which is that sock and
sk are valid.

	sock = sock_from_file(req->file);
	if (sock && sock->sk)
		__io_napi_add_id(ctx, READ_ONCE(sock->sk->sk_napi_id));

or something like that. At least to me that's more readable.

-- 
Jens Axboe

