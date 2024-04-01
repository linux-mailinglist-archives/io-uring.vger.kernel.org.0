Return-Path: <io-uring+bounces-1346-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45B52894456
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 19:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 786BAB21C12
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 17:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B907B4EB38;
	Mon,  1 Apr 2024 17:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Pu9OWnx7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1311B4DA05
	for <io-uring@vger.kernel.org>; Mon,  1 Apr 2024 17:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711992616; cv=none; b=Oi9ASdx5iUGvFN8bPYpnyYHkLicEOi6cZYn6kFQ9deGIIGmmO5ipnxCbGyaPZVLncAQHA4NlTCd8TMkDsFB3iv+YmpylmDcPVV8Hr2hI34fXTIaARXW67boQ1BniLcNR6dsJPjryuLwVHi6pAhH78VvnufuzP+Mb2vw+Seo5DRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711992616; c=relaxed/simple;
	bh=oKbiK32bRoUqO/4BX3cZeyw4EqDjkS1n3k32I1zswP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mP2KxOIxu/gyNp192pYsiG1MCnH9F6y9G7DPZZDSWxODb6v+l3e3DnhLcO8YXe6TBzgVifNReXzcRwwM9kYfMNXRob37ypEZOSweIoLK5a4ayEFqu/pe2JLFjH1OJrm1BCK2N74zFbjuL+txrYD322bGryInwipesN3bPjfeF28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Pu9OWnx7; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e6b6f86975so2781757b3a.1
        for <io-uring@vger.kernel.org>; Mon, 01 Apr 2024 10:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1711992614; x=1712597414; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jp056mBomeeAW087Kkr99ZTHdDOW/EF0DfXMcZamcC4=;
        b=Pu9OWnx7kmGa6kkOOle6G1YYz/GBOUUtXMNAAnjdq4l54LbOxu/Nwdeii6s4HcJrXq
         /8nz0/YEqgqpK/GJEhNqoo/f5G58qVUaSxTCvJadc3LPtTq7B+G9yqQWDauxZfvTPwyi
         nN8z2MZNx+u6Y0hitjexDS5SeHwoInsxrvlAptREBEDBb9Cxa/IM0323zTUUPsjzuPqu
         OPulsTVWcyDPP56pkWHDfbu0EsMAkwuVN9w66bFwZToQy5PB8hLVhHOSJ1sfjkbFFTf3
         0d4HcpvUP+ZmBUDdl7SecwrtmV7Ce6Mgg/PuzNn3qDcEeWNCePpWyuUVIxVE7lVAVfWV
         60XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711992614; x=1712597414;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jp056mBomeeAW087Kkr99ZTHdDOW/EF0DfXMcZamcC4=;
        b=j7p+ZwtadmNRG1HRda5FWsuAc1zJWHFmYTnWCklARs5Qq/b8mIROJrENoHKQynIqv+
         FsBwDgS1dz9V37hHVaYuzGYCQSxPG1XnlgRFe2wT2cifVg8/ZR6yWx7/agTNCPqdbgse
         fU6P8r3jBfDhFSiRiINTD2sGoBaWt4hlbQg1UHOt3boADHV3ltCITiQsHB87yxWJh+Sz
         eiDcqvERiffCml6Unqk+nZY7CMv9+gpgXmFhPRKBBBcMUfJzLTo0jp0vJJ/0CjrpOSy7
         sIDVuIFNpIoGKnrYsXm6rOXxKrl2V2FsSX9dBZi1cKvct002HrLM+M5rwb+SUmRKBSrJ
         MBNg==
X-Forwarded-Encrypted: i=1; AJvYcCVnmrKw8n9fD4SLLR4oeTT6a5VImu6sDUL/aY2QE+v1Hbnv/icbljXM4dUTQ5Azt+lEDw919hstQQZzsKG/UAP3PWZntP9fitQ=
X-Gm-Message-State: AOJu0YylXIdIzrRSCMuxH1R/773TIQXRmgHuCchTVyorxZ/BgLDcLwga
	cGS9JmezijrcQHjkARygduC2fyCYF4/k2ZOrZ4Z0N0KFDohlvGCiNRaL2LgheyOd2PTIOGcScip
	m
X-Google-Smtp-Source: AGHT+IFxQ4lNH71Av406aoOFoBXRM/jGG0FSWynRZ7IvaivBKNqdYlMpd/eyzRR7YQVp7s62SNU12A==
X-Received: by 2002:a05:6a00:14ca:b0:6e6:9942:fd97 with SMTP id w10-20020a056a0014ca00b006e69942fd97mr12433198pfu.15.1711992614079;
        Mon, 01 Apr 2024 10:30:14 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:2:c51:2090:e106:83fa? ([2620:10d:c090:500::7:95f3])
        by smtp.gmail.com with ESMTPSA id fb7-20020a056a002d8700b006eadf879a30sm7668936pfb.179.2024.04.01.10.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 10:30:13 -0700 (PDT)
Message-ID: <4787f55e-b9c3-46d6-a183-53ba2fd21445@davidwei.uk>
Date: Mon, 1 Apr 2024 10:30:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: add remote task_work execution helper
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240329201241.874888-1-axboe@kernel.dk>
 <20240329201241.874888-2-axboe@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20240329201241.874888-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-03-29 13:09, Jens Axboe wrote:
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
>  io_uring/io_uring.c | 30 ++++++++++++++++++++++--------
>  io_uring/io_uring.h |  2 ++
>  2 files changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index fddaefb9cbff..a311a244914b 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1232,9 +1232,10 @@ void tctx_task_work(struct callback_head *cb)
>  	WARN_ON_ONCE(ret);
>  }
>  
> -static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
> +static inline void io_req_local_work_add(struct io_kiocb *req,
> +					 struct io_ring_ctx *ctx,
> +					 unsigned flags)
>  {
> -	struct io_ring_ctx *ctx = req->ctx;
>  	unsigned nr_wait, nr_tw, nr_tw_prev;
>  	struct llist_node *head;
>  
> @@ -1300,9 +1301,10 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
>  	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
>  }
>  
> -static void io_req_normal_work_add(struct io_kiocb *req)
> +static void io_req_normal_work_add(struct io_kiocb *req,
> +				   struct task_struct *task)
>  {
> -	struct io_uring_task *tctx = req->task->io_uring;
> +	struct io_uring_task *tctx = task->io_uring;
>  	struct io_ring_ctx *ctx = req->ctx;
>  
>  	/* task_work already pending, we're done */
> @@ -1321,7 +1323,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
>  		return;
>  	}
>  
> -	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
> +	if (likely(!task_work_add(task, &tctx->task_work, ctx->notify_method)))
>  		return;
>  
>  	io_fallback_tw(tctx, false);
> @@ -1331,10 +1333,22 @@ void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
>  {
>  	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
>  		rcu_read_lock();
> -		io_req_local_work_add(req, flags);
> +		io_req_local_work_add(req, req->ctx, flags);
> +		rcu_read_unlock();
> +	} else {
> +		io_req_normal_work_add(req, req->task);

Why does this not require a READ_ONCE() like
io_req_task_work_add_remote()?

> +	}
> +}
> +
> +void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
> +				 unsigned flags)
> +{
> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> +		rcu_read_lock();
> +		io_req_local_work_add(req, ctx, flags);
>  		rcu_read_unlock();
>  	} else {
> -		io_req_normal_work_add(req);
> +		io_req_normal_work_add(req, READ_ONCE(ctx->submitter_task));
>  	}
>  }
>  
> @@ -1348,7 +1362,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
>  						    io_task_work.node);
>  
>  		node = node->next;
> -		io_req_normal_work_add(req);
> +		io_req_normal_work_add(req, req->task);
>  	}
>  }
>  
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 1eb65324792a..4155379ee586 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -74,6 +74,8 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
>  			       unsigned issue_flags);
>  
>  void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
> +void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
> +				 unsigned flags);
>  bool io_alloc_async_data(struct io_kiocb *req);
>  void io_req_task_queue(struct io_kiocb *req);
>  void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);

