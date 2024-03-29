Return-Path: <io-uring+bounces-1319-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 678EA891F2A
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 15:59:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E82B288EFF
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 14:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB7E41C0DF3;
	Fri, 29 Mar 2024 12:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7Iqm1AM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B351C0DEF
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 12:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711716712; cv=none; b=aEDkXWcNKEQDb9tZqnrrMPOHExWE4K8JEG2rTkOjxAshtkvafQH3pJXwSB09UCDs5Y9TZk+UWnA9AdIecmSOgFSYJrxcAV0fRTmBp0NFuKWzdQTqJ+99f7QOOS0uhlquc59Ap4MQIU50w50IgROGZ+BZrM3HyAkAvGXeOw4Hv70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711716712; c=relaxed/simple;
	bh=lImCGp04cnhamA4Z6AnN663XttMr1l8n5PfKDmXJav4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bn0qW/QP+9Vgj1MzXTLX+3jUTfQoTUD8q4W/JZMKwbIBSOdn7gCVHd2GX07UOJA+Jau+FgnSgnoUgpOB0DVxgz0LJ2A6Rb9Z53XN54YGoLHuBaRIovlsUiblKuyKhZDAVo1vwSD9IZdE9rO+ZItwcBie14gEb8LfhKv0jShNMYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D7Iqm1AM; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-56c5d05128dso633246a12.0
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 05:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711716709; x=1712321509; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BW5AaBWqKSvbDN87WMlaUbqSKyEbmpTy840FzuwQBqk=;
        b=D7Iqm1AMJ3wdtm07GOfqzUbxk1T4l5d2nNE+Wx8p8cCcjFJZSWvCRIjmDT0ii0tn57
         A0L/l54T+smak/kEeoEyMftHTVvgR4PJjGF8FjDOwLE2FAroO4FB4WvpobTCiPVOqrQM
         qxZXmo3GPczDANvi0ypjlr/Mh1C1ntHqpbaRf7w1ewB+z6cW93MRQzr99NLPuOVs1msu
         nXiPMpjAIvwY4o6zPo7tNcpu5IprtLg4EbwipbAbkvc2kMeE/ILyqwj/O/N1q586qhoj
         d0jpODTbbqAolAfrGqObpoNy92Q57WNj5hfy/PKMGTpKG0HA6qZeUk589yPIrAFixMyk
         EyKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711716709; x=1712321509;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BW5AaBWqKSvbDN87WMlaUbqSKyEbmpTy840FzuwQBqk=;
        b=mFp/PMsrsDVpEG+ycgAXTLpmOFLrlEWdhrjRi6EZz2MXdoVETAUio20VkCdRfX2ux/
         dh5qg37Miz4FVCAkHSnSnjy1PD6L5KnWbdrvvygfQmydfQHTvrppLKhWO1OWRaDA+jdb
         JYORRoVP1D3PXccsoNFker6iOS/K3pQoJUdjx1Lqhv5XZPdjuEwEHvoij9j7p2D7zuBx
         CrWRzmNBm+Ed/WqGd2+L5OSB78vpGb2nyqhdK6Ww5WFb9bPYKshVSBWJdgAEIUJ8Wci1
         LSIFJowahODWTaRCJTQTfJSiGnTE/j30eeIdUNHBxCeuSgelWK7oroHSX22kDTV+MDLd
         KpkA==
X-Forwarded-Encrypted: i=1; AJvYcCXHB7/hV8j/ZNkqaylSLOEYsi4DyaX+qT28MGA0WlxRR/A3KCZCflZ4oJUuwLSk1RaX2GYsqtCaLnGKedgMASMFM5D0n2+uxO4=
X-Gm-Message-State: AOJu0YzdiOUoWLHfDNSMlm75p58eCvWoatc8kE79EDGL7s5/mOyOE2i8
	6k5/3qIWVxgc/OpnvoDJuNdTUUyYBW0i2XohKk167ziPbho9rZdt7I/dXY62
X-Google-Smtp-Source: AGHT+IF/Vt9n3dx4nura2YiJXCjGWQfm+Ru04jj5KyR9uNOPe8A/ASZLhbebjP7BQ0+mzk2Y6eXZoQ==
X-Received: by 2002:a50:8e1d:0:b0:567:504e:e779 with SMTP id 29-20020a508e1d000000b00567504ee779mr1262682edw.25.1711716709143;
        Fri, 29 Mar 2024 05:51:49 -0700 (PDT)
Received: from [192.168.42.210] (82-132-222-240.dab.02.net. [82.132.222.240])
        by smtp.gmail.com with ESMTPSA id en9-20020a056402528900b005697d77570dsm1961667edb.66.2024.03.29.05.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 05:51:48 -0700 (PDT)
Message-ID: <4e8b5815-322e-4511-b529-6db745e8d0e0@gmail.com>
Date: Fri, 29 Mar 2024 12:51:45 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: add remote task_work execution helper
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240328185413.759531-1-axboe@kernel.dk>
 <20240328185413.759531-2-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240328185413.759531-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/24 18:52, Jens Axboe wrote:
> All our task_work handling is targeted at the state in the io_kiocb
> itself, which is what it is being used for. However, MSG_RING rolls its
> own task_work handling, ignoring how that is usually done.
> 
> In preparation for switching MSG_RING to be able to use the normal
> task_work handling, add io_req_task_work_add_remote() which allows the
> caller to pass in the target io_ring_ctx and task.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/io_uring.c | 27 +++++++++++++++++++--------
>   io_uring/io_uring.h |  2 ++
>   2 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 9978dbe00027..609ff9ea5930 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1241,9 +1241,10 @@ void tctx_task_work(struct callback_head *cb)
>   	WARN_ON_ONCE(ret);
>   }
>   
> -static inline void io_req_local_work_add(struct io_kiocb *req, unsigned tw_flags)
> +static inline void io_req_local_work_add(struct io_kiocb *req,
> +					 struct io_ring_ctx *ctx,
> +					 unsigned tw_flags)
>   {
> -	struct io_ring_ctx *ctx = req->ctx;
>   	unsigned nr_wait, nr_tw, nr_tw_prev;
>   	unsigned long flags;
>   
> @@ -1291,9 +1292,10 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned tw_flags
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
>   	unsigned long flags;
>   	bool was_empty;
> @@ -1319,7 +1321,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
>   		return;
>   	}
>   
> -	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
> +	if (likely(!task_work_add(task, &tctx->task_work, ctx->notify_method)))
>   		return;
>   
>   	io_fallback_tw(tctx, false);
> @@ -1328,9 +1330,18 @@ static void io_req_normal_work_add(struct io_kiocb *req)
>   void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
>   {
>   	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
> -		io_req_local_work_add(req, flags);
> +		io_req_local_work_add(req, req->ctx, flags);
> +	else
> +		io_req_normal_work_add(req, req->task);
> +}
> +
> +void io_req_task_work_add_remote(struct io_kiocb *req, struct task_struct *task,
> +				 struct io_ring_ctx *ctx, unsigned flags)

Urgh, even the declration screams that there is something wrong
considering it _either_ targets @ctx or @task.

Just pass @ctx, so it either use ctx->submitter_task or
req->task, hmm?

A side note, it's a dangerous game, I told it before. At least
it would've been nice to abuse lockdep in a form of:

io_req_task_complete(req, tw, ctx) {
	lockdep_assert(req->ctx == ctx);
	...
}

but we don't have @ctx there, maybe we'll add it to tw later.


> +{
> +	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
> +		io_req_local_work_add(req, ctx, flags);
>   	else
> -		io_req_normal_work_add(req);
> +		io_req_normal_work_add(req, task);
>   }
>   
>   static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
> @@ -1349,7 +1360,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
>   						    io_task_work.node);
>   
>   		node = node->next;
> -		io_req_normal_work_add(req);
> +		io_req_normal_work_add(req, req->task);
>   	}
>   }
>   
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index bde463642c71..a6dec5321ec4 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -74,6 +74,8 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
>   			       unsigned issue_flags);
>   
>   void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
> +void io_req_task_work_add_remote(struct io_kiocb *req, struct task_struct *task,
> +				 struct io_ring_ctx *ctx, unsigned flags);
>   bool io_alloc_async_data(struct io_kiocb *req);
>   void io_req_task_queue(struct io_kiocb *req);
>   void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);

-- 
Pavel Begunkov

