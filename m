Return-Path: <io-uring+bounces-2120-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 868918FD154
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 17:01:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20C7A282A45
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 15:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F621D524;
	Wed,  5 Jun 2024 15:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NOTJgNo9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5747E134B6
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 15:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717599687; cv=none; b=Vycl9EKLab9r52wwbZtWR/2GIicjbKvHob+P2I5HtlTftkoHxNgZ/8FsVqp+nQUNG5vtKyd7Gp8z5IU/BjG917rN8PWrmfNWEve8pJ9TfrUbllbXrJFZJgz+g6YpH/UG6WZzL/X83uR+y2YoWQ2L3d6OV/CE4YqgIJ5MwryFovw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717599687; c=relaxed/simple;
	bh=/7LTwi5b3uSo95blteYs+nEtjSHgqJpF0DFkk/rQmFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Hqz0QOafWNSeJT2N9Bqu3z1c1c3zK6CVcnufxUpDFX8CVbJAZYsI5jDfxZAlOXdUkgdRUjtYjiFsur24b4UGyh3sMH6LrurCN3DAA5ILx8hAGgBnDDL3NAGgzyGwkuEl3wY3qK4auDuSOdqOMFPm/7QkbA+6BuejJbu8bE7PAWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NOTJgNo9; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-57a52dfd081so4659143a12.2
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 08:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717599683; x=1718204483; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QbCst/OJ3B42J06wiHSAfyHYiKvu61o0RpCzZyCZLh4=;
        b=NOTJgNo9d9velqAxMxjDaxQyVi84tEj+pv0QZ0XV0EIa6pHVAKJDA0YDH2/JKap8CR
         RU1UXa6h3grrRcuo07b6p/a5+7sXfAvhVvGZO3ri74+0OOoauqWrC5nYyqUrmXPDhfvP
         TEQhx2Jn3tdOpQ9PrQQNDOtQADQtbPenGObsuf/17vdpjLyqQiWL6utEbAEPtSXuf1w3
         Zr+q2QXlbZn4Qcu9iPihVUUlwkiuvc4c56bhpwVkXSAyYrw1iF32FGCUAmXXIW188Utb
         0fUwvjWfrF4sdH0lfZiFgoFod6ssHuH3Aq8RfAx3IZrDxRSz/3lhAdoUK5pj9FA28aGY
         bxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717599683; x=1718204483;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QbCst/OJ3B42J06wiHSAfyHYiKvu61o0RpCzZyCZLh4=;
        b=AoAyKAPRyFxEiq2jW0qh2IEhlKMMcOwu2OhIXU5AfKZ8Cv4y9Qwd64oc02QAIAM1Da
         eBm+P4mrdJAJ5fx4AsZBpTLBGJiDOu7TZJn0/ijiczvyNxYb+TMHJo4chPPVQE2J8UNY
         +D6KT3mI+a85zMzoagAHOBVCnLf7BC/h+OoRlvc0GimfavfRuY18dRfckjZtgkATZjXm
         tgJHjy3mKBjf7xoJ1ASuAF+6odIqvs824asZfTPLRO1FesCYSTz3spzIT19SWCi/S23S
         uHzJAejnwfTJfcWzdDlq2+s4s6s7cARU+h0y61+QfNvHemh3s8a9c8xCbwRaFms3JEjo
         nPdA==
X-Forwarded-Encrypted: i=1; AJvYcCXxfo6pM1zy45A75TC3N2dqKhQnciHj5e8mK5gg0lKe31GZFW51+ir9IHo1jbjtHiKuq0BrQKmbmre1rAzSsekMAGvy8K2+FYI=
X-Gm-Message-State: AOJu0YxwfEMfh9K/1PFJ1VvtTFjtdTZpAdH3XwfU1FC8EPoSnVSkS9Cn
	YWluTsumIZkHnT0LWbTHzw8DfbPrdjNXs8huOtJyXYKE8Zj5CDnHyDNw8Q==
X-Google-Smtp-Source: AGHT+IGLC2MFY3RroJIXRfFdb+LhU5S92uRRlB0uIos80fJ8iiu7aUhWzR8BZd9wW0IQAqGju28cIw==
X-Received: by 2002:a17:907:80e:b0:a63:41e4:ee57 with SMTP id a640c23a62f3a-a699faa8568mr235147166b.15.1717599683394;
        Wed, 05 Jun 2024 08:01:23 -0700 (PDT)
Received: from [192.168.42.45] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a67ea586975sm786119366b.100.2024.06.05.08.01.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 08:01:22 -0700 (PDT)
Message-ID: <a9d5af1e-533a-46c9-9a74-41998eb75288@gmail.com>
Date: Wed, 5 Jun 2024 16:01:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] io_uring: mark exit side kworkers as task_work
 capable
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240604191314.454554-1-axboe@kernel.dk>
 <20240604191314.454554-3-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240604191314.454554-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/4/24 20:01, Jens Axboe wrote:
> There are two types of work here:
> 
> 1) Fallback work, if the task is exiting
> 2) The exit side cancelations
> 
> and both of them may do the final fput() of a file. When this happens,
> fput() will schedule delayed work. This slows down exits when io_uring
> needs to wait for that work to finish. It is possible to flush this via
> flush_delayed_fput(), but that's a big hammer as other unrelated files
> could be involved, and from other tasks as well.
> 
> Add two io_uring helpers to temporarily clear PF_NO_TASKWORK for the
> worker threads, and run any queued task_work before setting the flag
> again. Then we can ensure we only flush related items that received
> their final fput as part of work cancelation and flushing.
> 
> For now these are io_uring private, but could obviously be made
> generically available, should there be a need to do so.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/io_uring.c | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 96f6da0bf5cd..3ad915262a45 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -234,6 +234,20 @@ static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx
>   	wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
>   }
>   
> +static __cold void io_kworker_tw_start(void)
> +{
> +	if (WARN_ON_ONCE(!(current->flags & PF_NO_TASKWORK)))
> +		return;
> +	current->flags &= ~PF_NO_TASKWORK;
> +}
> +
> +static __cold void io_kworker_tw_end(void)
> +{
> +	while (task_work_pending(current))
> +		task_work_run();

Clear TIF_NOTIFY_SIGNAL/RESUME? Maybe even retrying task_work_run()
after and looping around if there are items to execute.


> +	current->flags |= PF_NO_TASKWORK;
> +}
> +
>   static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
>   {
>   	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
> @@ -249,6 +263,8 @@ static __cold void io_fallback_req_func(struct work_struct *work)
>   	struct io_kiocb *req, *tmp;
>   	struct io_tw_state ts = {};
>   
> +	io_kworker_tw_start();
> +
>   	percpu_ref_get(&ctx->refs);
>   	mutex_lock(&ctx->uring_lock);
>   	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
> @@ -256,6 +272,7 @@ static __cold void io_fallback_req_func(struct work_struct *work)
>   	io_submit_flush_completions(ctx);
>   	mutex_unlock(&ctx->uring_lock);
>   	percpu_ref_put(&ctx->refs);
> +	io_kworker_tw_end();
>   }
>   
>   static int io_alloc_hash_table(struct io_hash_table *table, unsigned bits)
> @@ -2720,6 +2737,8 @@ static __cold void io_ring_exit_work(struct work_struct *work)
>   	struct io_tctx_node *node;
>   	int ret;
>   
> +	io_kworker_tw_start();
> +
>   	/*
>   	 * If we're doing polled IO and end up having requests being
>   	 * submitted async (out-of-line), then completions can come in while
> @@ -2770,6 +2789,8 @@ static __cold void io_ring_exit_work(struct work_struct *work)
>   		 */
>   	} while (!wait_for_completion_interruptible_timeout(&ctx->ref_comp, interval));
>   
> +	io_kworker_tw_end();
> +
>   	init_completion(&exit.completion);
>   	init_task_work(&exit.task_work, io_tctx_exit_cb);
>   	exit.ctx = ctx;

-- 
Pavel Begunkov

