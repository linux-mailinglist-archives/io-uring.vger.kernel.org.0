Return-Path: <io-uring+bounces-1363-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A308955D4
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 15:53:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5114D1F2333B
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 13:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B2983CC3;
	Tue,  2 Apr 2024 13:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jNsq54Yj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5069A65BBB
	for <io-uring@vger.kernel.org>; Tue,  2 Apr 2024 13:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712066034; cv=none; b=OALvTV7vDVTulz/Uim8LGKBCHFjIQcHpgD15GKOZjlDbOaVf/pSiYvt7bsxoWqbJ/GE0VqW6GhZLRcpXzC+a3PRcvIh3f53y19a1M4ykPSCNHY62JUzF/2+2jIHNvgyWMhwx6aL22wkDli8g+lkmRObGWx4RGI4EEBYhtAnsXtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712066034; c=relaxed/simple;
	bh=TYREw7ht8yrilrx21HQmkaL7CrVaSOYooeqwDn99taE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kIjvX129TyGempGAyxh6Vc0cYY7YebyUNntyNXDpSPo/Su6fU63d9VIP1qVrafegctgJLKpRcE6dbDkodcsRX3xD7jItym26ze9a7JXhxiHoD5kcUoNES12aYUnS8Toggj7SKfSmCQtBZ8o6LN3CdrukzT8lTaTAtohV6fxRxr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jNsq54Yj; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-516afb04ec7so1622442e87.2
        for <io-uring@vger.kernel.org>; Tue, 02 Apr 2024 06:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712066030; x=1712670830; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wwIWllg7hfpqOMVKtjMCxgpzLfmORmrelB34xVHRpBs=;
        b=jNsq54YjjkdLFMsq36LtCxe/GjX6XyiyGE0pVlUJE6JF3Onuwl1BG45bmnfAloZrD6
         /Mdp1A6XsV+5qoz/bTQ/86Pop+zvb8XzgXHDn/3mSgV4AEy3cj96zK/bLW07XiamcYhc
         K64rvlSDEmue3/N774NupmyhJEF3GE5D8rkUTiic42XqeSXwHcniC+idsNTjbCGxFC6V
         02RfAw1xNHU4e/oFWle6PVwv9CycawlMtFceAxL6U0BO4eM7UvevkkJxrim4GEKsN1ei
         rSsFjosE4SJNhJEHKmOuQN96WPE7fUCkEmsUnypgNnbHn7FlBsskHuWKwyq7XBKpIiNr
         rF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712066030; x=1712670830;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wwIWllg7hfpqOMVKtjMCxgpzLfmORmrelB34xVHRpBs=;
        b=TrPANHb7gT4iXS4ZFrnIax5BBCs1t/a7+k7lBt8DyJojcDyfrD0lWnM8A/t7Ne7KvB
         XmjOwA71VZaJ3yUwXRWX17GHrATV5tj7aofhLS55VfV+3T7Nx817UflNaAB5qFqaI5F/
         xiZt/KGjiFM5n1DdVSMDfZGfI5xv5vaWi1YX+tv971rxH0Xzpwxa+JPeIPJpLCYeFf2/
         ZSZqOzqElTAnKkU5Rig/elkBXAuKuOqxrroNsua1tm+sO6vckc4lzHHtKYDLyQz4OFD4
         PD143Wf8egvB7jRQoD8fwAQcx4GTxxHawvqghpPy2vvPcyKdw4xqrjPvVdsh4HAHNPYk
         jGYA==
X-Forwarded-Encrypted: i=1; AJvYcCXhiEro8NyN1sWJA3AVKFeCa6262R84Yqi66V63jbSNDaMP8A0I7642HYKMWrrzqI8tbBMhmevWHViJFpWtQz2XZziOKHseLBg=
X-Gm-Message-State: AOJu0YwEF20caW7SVO9zGRIaai4bEinZMLFk92Ngpee/4UgFFOIAXoKu
	3cALYYmohZtyNebCmK7BY7bdBFJXol6ZoVSU8+4VnuNJ5QnfYTy0mm46vnnM
X-Google-Smtp-Source: AGHT+IGLRMcIFlYWXKV48unSWytwsq7URD2gUtsUA+H0yhWcymIBmta7w3cQP5QIaH7Q/s/bey7z5A==
X-Received: by 2002:a05:6512:1313:b0:513:5ec6:348b with SMTP id x19-20020a056512131300b005135ec6348bmr12018231lfu.6.1712066030021;
        Tue, 02 Apr 2024 06:53:50 -0700 (PDT)
Received: from [192.168.42.254] ([148.252.147.117])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906301100b00a45c9945251sm6531463ejz.192.2024.04.02.06.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 06:53:49 -0700 (PDT)
Message-ID: <2d331587-b5e3-4ca8-9de1-5fd598b5ce2e@gmail.com>
Date: Tue, 2 Apr 2024 14:53:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] io_uring: add remote task_work execution helper
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240401175757.1054072-1-axboe@kernel.dk>
 <20240401175757.1054072-2-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240401175757.1054072-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/24 18:56, Jens Axboe wrote:
> All our task_work handling is targeted at the state in the io_kiocb
> itself, which is what it is being used for. However, MSG_RING rolls its
> own task_work handling, ignoring how that is usually done.
> 
> In preparation for switching MSG_RING to be able to use the normal
> task_work handling, add io_req_task_work_add_remote() which allows the
> caller to pass in the target io_ring_ctx.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/io_uring.c | 30 ++++++++++++++++++++++--------
>   io_uring/io_uring.h |  2 ++
>   2 files changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 9986e9bb825a..df4d9c9aeeab 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1232,9 +1232,10 @@ void tctx_task_work(struct callback_head *cb)
>   	WARN_ON_ONCE(ret);
>   }
>   
> -static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
> +static inline void io_req_local_work_add(struct io_kiocb *req,
> +					 struct io_ring_ctx *ctx,
> +					 unsigned flags)
>   {
> -	struct io_ring_ctx *ctx = req->ctx;
>   	unsigned nr_wait, nr_tw, nr_tw_prev;
>   	struct llist_node *head;
>   
> @@ -1300,9 +1301,10 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
>   	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
>   }
>   
> -static void io_req_normal_work_add(struct io_kiocb *req)
> +static void io_req_normal_work_add(struct io_kiocb *req,
> +				   struct task_struct *task)
>   {
> -	struct io_uring_task *tctx = req->task->io_uring;
> +	struct io_uring_task *tctx = task->io_uring;
>   	struct io_ring_ctx *ctx = req->ctx;
>   
>   	/* task_work already pending, we're done */
> @@ -1321,7 +1323,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
>   		return;
>   	}
>   
> -	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
> +	if (likely(!task_work_add(task, &tctx->task_work, ctx->notify_method)))
>   		return;
>   
>   	io_fallback_tw(tctx, false);
> @@ -1331,10 +1333,22 @@ void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
>   {
>   	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
>   		rcu_read_lock();
> -		io_req_local_work_add(req, flags);
> +		io_req_local_work_add(req, req->ctx, flags);
> +		rcu_read_unlock();
> +	} else {
> +		io_req_normal_work_add(req, req->task);
> +	}
> +}
> +
> +void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
> +				 unsigned flags)
> +{
> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> +		rcu_read_lock();

Let's move rcu section into io_req_local_work_add().

Perhaps the easiest way is to

guard(rcu)();

> +		io_req_local_work_add(req, ctx, flags);
>   		rcu_read_unlock();
>   	} else {
> -		io_req_normal_work_add(req);
> +		io_req_normal_work_add(req, READ_ONCE(ctx->submitter_task));

->submitter_task can be null.

Why do you care about ->submitter_task? SINGLE_ISSUER allows
CQE posting and all other stuff from a random context, most
optimisations shifted into a more stricter DEFER_TASKRUN.

But let's say it's queued it to a valid task. tw run kicks in,
it splices the req, takes req->ctx, locks it and executes from
there, at which point the callback would probably assume that
the target ctx is locked and do all kinds of messy stuff
without sync. Even funnier if the original ctx is DEFER_TASKRUN,
then you have both deferred and normal tw for that ctx, and
it should never happen.

Let's not pretend that io_req_normal_work_add to a foreign
context would work and limit io_req_task_work_add_remote()
to !DEFER_TASKRUN?



>   	}
>   }
>   
> @@ -1348,7 +1362,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
>   						    io_task_work.node);
>   
>   		node = node->next;
> -		io_req_normal_work_add(req);
> +		io_req_normal_work_add(req, req->task);
>   	}
>   }
>   
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 1eb65324792a..4155379ee586 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -74,6 +74,8 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
>   			       unsigned issue_flags);
>   
>   void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
> +void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
> +				 unsigned flags);
>   bool io_alloc_async_data(struct io_kiocb *req);
>   void io_req_task_queue(struct io_kiocb *req);
>   void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);

-- 
Pavel Begunkov

