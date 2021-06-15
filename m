Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1144F3A7B30
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 11:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhFOJxh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 05:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbhFOJxg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 05:53:36 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECEDC061574;
        Tue, 15 Jun 2021 02:51:31 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l9so13759436wms.1;
        Tue, 15 Jun 2021 02:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DnmfZ3n4eX1Wg3BuVF/d3+9xjT/C4zfRFtfM4dIGrSY=;
        b=svHoH1uCzQYfAPGxQQX1bYeSIITKNc6pQZkfp+jR6/8wCbqj5HiskFvKjJBzq9Q3ys
         uEAwcQo1O8t16tuvoSUy6kADn0hLdQZKFITzqYJOVmwGh9UZtz4cKOWU9jXPKXV611iq
         Inr0KvOL0lsw+AhszVrc5UzW8N2io1VLbvMMCgye5hOL7Z88dAwbNdUSQHpQTQX9uWn9
         zCPty7Go9Ajub46i+HG3q1KGaghO5Ov8aL10fwAoVSWGHESucFXJkq3b7h9jDpYX5Zk2
         70a291Y8jtpgK4yJysV+JRFHGar2DMcJZ0vwcD71OmFd9CrD7fIvjCxFYSLpX2BHH7w6
         nBJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DnmfZ3n4eX1Wg3BuVF/d3+9xjT/C4zfRFtfM4dIGrSY=;
        b=mTHYktoiDfywJeIl5yWh4lYZ/c/IhBBKilp8wmoTVg88q0Go+wUcrf5MwBGBt+NoBq
         vyxMr5g1B6/RY1/RGcxrrN0OOrBTqJ15A6u1ZnswzYoF/NIlk1dVT6R/3A63y+rshA+C
         f5sk5TG2mSf88dmolJcD9qnkjr/Kanby7TCDIlxWSwAJSmn8XyZJgIrEN/q2it0qRcXf
         xU7dheZW+1eq3yR3RUR4Xky9ETmI0xXYjLqcSEDPIFrVc5wqLDprZelgQlXQ2vGK4zYu
         hf1wfFB1LdnIUDPzP/Oya8+S4DMyIh0GKVxE9BQ46rX2Jko6BX29MNSEwdDGedFi8ueE
         pvwA==
X-Gm-Message-State: AOAM532S3b6EWM5XLD5U/NtCeeKyoDtOtB9/MDKUTvkKsIPXCy6+y9Ht
        QPVNunCaWTVcWI33fW1LgUpKA7qA1M3B/FZr
X-Google-Smtp-Source: ABdhPJya6rIBR2V495XZJ8wEcsE5c2RPDrCCY7UgFJmZaQFOk21jB0x+gDDJL/c9XVHff4qMpfLhqw==
X-Received: by 2002:a05:600c:2194:: with SMTP id e20mr4161272wme.138.1623750689989;
        Tue, 15 Jun 2021 02:51:29 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id z10sm12696369wmp.39.2021.06.15.02.51.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 02:51:29 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] io_uring: Add to traces the req pointer when
 available
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60be7e1b.1c69fb81.a0c4.205aSMTPIN_ADDED_MISSING@mx.google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <5f5e1353-6248-0e4a-ddd3-8eb0b1ba7f5c@gmail.com>
Date:   Tue, 15 Jun 2021 10:51:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <60be7e1b.1c69fb81.a0c4.205aSMTPIN_ADDED_MISSING@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/21 7:36 AM, Olivier Langlois wrote:
> The req pointer uniquely identify a specific request.
> Having it in traces can provide valuable insights that is not possible
> to have if the calling process is reusing the same user_data value.

Patchset are usually accompanied with a cover letter. Also, there is
something wrong as b4 refuses to find the patch. Anyway...

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  fs/io_uring.c                   | 11 ++---
>  include/trace/events/io_uring.h | 71 ++++++++++++++++++++++++---------
>  2 files changed, 59 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 903458afd56c..0737b0e76b91 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5059,7 +5059,7 @@ static void io_async_task_func(struct callback_head *cb)
>  	struct async_poll *apoll = req->apoll;
>  	struct io_ring_ctx *ctx = req->ctx;
>  
> -	trace_io_uring_task_run(req->ctx, req->opcode, req->user_data);
> +	trace_io_uring_task_run(req->ctx, req, req->opcode, req->user_data);
>  
>  	if (io_poll_rewait(req, &apoll->poll)) {
>  		spin_unlock_irq(&ctx->completion_lock);
> @@ -5192,8 +5192,8 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>  		return false;
>  	}
>  	spin_unlock_irq(&ctx->completion_lock);
> -	trace_io_uring_poll_arm(ctx, req->opcode, req->user_data, mask,
> -					apoll->poll.events);
> +	trace_io_uring_poll_arm(ctx, req, req->opcode, req->user_data,
> +				mask, apoll->poll.events);
>  	return true;
>  }
>  
> @@ -6578,8 +6578,9 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  		goto fail_req;
>  
>  	/* don't need @sqe from now on */
> -	trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
> -				true, ctx->flags & IORING_SETUP_SQPOLL);
> +	trace_io_uring_submit_sqe(ctx, req, req->opcode, req->user_data,
> +				  req->flags, true,
> +				  ctx->flags & IORING_SETUP_SQPOLL);
>  
>  	/*
>  	 * If we already have a head request, queue this one for async
> diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
> index abb8b24744fd..12addad1f837 100644
> --- a/include/trace/events/io_uring.h
> +++ b/include/trace/events/io_uring.h
> @@ -323,8 +323,10 @@ TRACE_EVENT(io_uring_complete,
>   * io_uring_submit_sqe - called before submitting one SQE
>   *
>   * @ctx:		pointer to a ring context structure
> + * @req:		pointer to a submitted request
>   * @opcode:		opcode of request
>   * @user_data:		user data associated with the request
> + * @flags		request flags
>   * @force_nonblock:	whether a context blocking or not
>   * @sq_thread:		true if sq_thread has submitted this SQE
>   *
> @@ -333,41 +335,60 @@ TRACE_EVENT(io_uring_complete,
>   */
>  TRACE_EVENT(io_uring_submit_sqe,
>  
> -	TP_PROTO(void *ctx, u8 opcode, u64 user_data, bool force_nonblock,
> -		 bool sq_thread),
> +	TP_PROTO(void *ctx, void *req, u8 opcode, u64 user_data, u32 flags,
> +		 bool force_nonblock, bool sq_thread),
>  
> -	TP_ARGS(ctx, opcode, user_data, force_nonblock, sq_thread),
> +	TP_ARGS(ctx, req, opcode, user_data, flags, force_nonblock, sq_thread),
>  
>  	TP_STRUCT__entry (
>  		__field(  void *,	ctx		)
> +		__field(  void *,	req		)
>  		__field(  u8,		opcode		)
>  		__field(  u64,		user_data	)
> +		__field(  u32,		flags		)
>  		__field(  bool,		force_nonblock	)
>  		__field(  bool,		sq_thread	)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->ctx		= ctx;
> +		__entry->req		= req;
>  		__entry->opcode		= opcode;
>  		__entry->user_data	= user_data;
> +		__entry->flags		= flags;
>  		__entry->force_nonblock	= force_nonblock;
>  		__entry->sq_thread	= sq_thread;
>  	),
>  
> -	TP_printk("ring %p, op %d, data 0x%llx, non block %d, sq_thread %d",
> -			  __entry->ctx, __entry->opcode,
> -			  (unsigned long long) __entry->user_data,
> -			  __entry->force_nonblock, __entry->sq_thread)
> +	TP_printk("ring %p, req %p, op %d, data 0x%llx, flags %u, "
> +		  "non block %d, sq_thread %d", __entry->ctx, __entry->req,
> +		  __entry->opcode, (unsigned long long)__entry->user_data,
> +		  __entry->flags, __entry->force_nonblock, __entry->sq_thread)
>  );
>  
> +/*
> + * io_uring_poll_arm - called after arming a poll wait if successful
> + *
> + * @ctx:		pointer to a ring context structure
> + * @req:		pointer to the armed request
> + * @opcode:		opcode of request
> + * @user_data:		user data associated with the request
> + * @mask:		request poll events mask
> + * @events:		registered events of interest
> + *
> + * Allows to track which fds are waiting for and what are the events of
> + * interest.
> + */
>  TRACE_EVENT(io_uring_poll_arm,
>  
> -	TP_PROTO(void *ctx, u8 opcode, u64 user_data, int mask, int events),
> +	TP_PROTO(void *ctx, void *req, u8 opcode, u64 user_data,
> +		 int mask, int events),
>  
> -	TP_ARGS(ctx, opcode, user_data, mask, events),
> +	TP_ARGS(ctx, req, opcode, user_data, mask, events),
>  
>  	TP_STRUCT__entry (
>  		__field(  void *,	ctx		)
> +		__field(  void *,	req		)
>  		__field(  u8,		opcode		)
>  		__field(  u64,		user_data	)
>  		__field(  int,		mask		)
> @@ -376,16 +397,17 @@ TRACE_EVENT(io_uring_poll_arm,
>  
>  	TP_fast_assign(
>  		__entry->ctx		= ctx;
> +		__entry->req		= req;
>  		__entry->opcode		= opcode;
>  		__entry->user_data	= user_data;
>  		__entry->mask		= mask;
>  		__entry->events		= events;
>  	),
>  
> -	TP_printk("ring %p, op %d, data 0x%llx, mask 0x%x, events 0x%x",
> -			  __entry->ctx, __entry->opcode,
> -			  (unsigned long long) __entry->user_data,
> -			  __entry->mask, __entry->events)
> +	TP_printk("ring %p, req %p, op %d, data 0x%llx, mask 0x%x, events 0x%x",
> +		  __entry->ctx, __entry->req, __entry->opcode,
> +		  (unsigned long long) __entry->user_data,
> +		  __entry->mask, __entry->events)
>  );
>  
>  TRACE_EVENT(io_uring_poll_wake,
> @@ -440,27 +462,40 @@ TRACE_EVENT(io_uring_task_add,
>  			  __entry->mask)
>  );
>  
> +/*
> + * io_uring_task_run - called when task_work_run() executes the poll events
> + *                     notification callbacks
> + *
> + * @ctx:		pointer to a ring context structure
> + * @req:		pointer to the armed request
> + * @opcode:		opcode of request
> + * @user_data:		user data associated with the request
> + *
> + * Allows to track when notified poll events are processed
> + */
>  TRACE_EVENT(io_uring_task_run,
>  
> -	TP_PROTO(void *ctx, u8 opcode, u64 user_data),
> +	TP_PROTO(void *ctx, void *req, u8 opcode, u64 user_data),
>  
> -	TP_ARGS(ctx, opcode, user_data),
> +	TP_ARGS(ctx, req, opcode, user_data),
>  
>  	TP_STRUCT__entry (
>  		__field(  void *,	ctx		)
> +		__field(  void *,	req		)
>  		__field(  u8,		opcode		)
>  		__field(  u64,		user_data	)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->ctx		= ctx;
> +		__entry->req		= req;
>  		__entry->opcode		= opcode;
>  		__entry->user_data	= user_data;
>  	),
>  
> -	TP_printk("ring %p, op %d, data 0x%llx",
> -			  __entry->ctx, __entry->opcode,
> -			  (unsigned long long) __entry->user_data)
> +	TP_printk("ring %p, req %p, op %d, data 0x%llx",
> +		  __entry->ctx, __entry->req, __entry->opcode,
> +		  (unsigned long long) __entry->user_data)
>  );
>  
>  #endif /* _TRACE_IO_URING_H */
> 

-- 
Pavel Begunkov
