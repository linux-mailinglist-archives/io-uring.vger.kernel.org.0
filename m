Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347F038FC9C
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 10:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhEYIXN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 May 2021 04:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhEYIXM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 May 2021 04:23:12 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE228C061756;
        Tue, 25 May 2021 01:21:41 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id s5-20020a7bc0c50000b0290147d0c21c51so12304368wmh.4;
        Tue, 25 May 2021 01:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DZKdaoY2tJMCSuwqn4+mekRONX6nXxFgjXEO/MLUIgs=;
        b=DpdTjyTTJnB8b2ig4S8krjY1oXH2PopKMVoQcLa/AR6tUC2ckA3lVQwvCSek40MF8j
         KCftYxhlKpThZgEt+vXK9uYnBFN65LwyMIfuYydqr9xgh+VhxQQTc6AJ/O9oDXkUOSv/
         c17D3HJvf6iOaVttI9ddyDyP0MyzmSsOsjC66jHvmbVdH6uJjYk2HjKe26HmsLL5lbvt
         9NCy67nmFYOimG8PP3UN4unekrOgiKCAxNPsSTZ45+oj2wRJo8WaBuHIxC3JspNUeqS9
         Yl003xQq9YCt/omLHX+RHM9gjU803vL5u6krqLkNvZWWtT5yyYlXaf0vYUOOEOXi8WVx
         ghNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DZKdaoY2tJMCSuwqn4+mekRONX6nXxFgjXEO/MLUIgs=;
        b=iaVWYf/3NcArrvnNXg8PTRepUsUxyPjOqjrmGJPAtIBmS6mcNUlqdV2Hv3nBHscAl0
         +kj+JKgmMwBUk/IowGQDkXZVSOc0/OKdRSE6LWygvpE7DHk1TRoMO1MN0H+Y92J02vOk
         Z/WMSpUXokX2wRXSoW9HSU3IxSvVzJKZRSCtPZpTyfZZoUs2stv35QTETOoe0ll8MZOo
         zDO5ot27eB4ARdJWttQZw3st44GhuVxcltQT1UQOLI5jZjslGgzj3JkzrMnQJ5ZChhAN
         hHXk8uiHBESZpX+Lxj6O61qIaE4rHJc+ilNVnNYXn+OETGknH87CmYyg9/Tv/C0/4AEx
         U4/Q==
X-Gm-Message-State: AOAM532DLZRvvamT/fmAC+pbxIlikriD2QSQjZfL01ucTaywN2xe7NWV
        VxkJNdvozGrgM0oSK/GcU5xFJCULC23TDlVF
X-Google-Smtp-Source: ABdhPJxAXigq5iGuonLj2moOBtQt5VNqrXohtEZ+/qTkHefSqU/frQzqeU4kVaeK/H32OmRsPyHd/w==
X-Received: by 2002:a05:600c:b44:: with SMTP id k4mr2733712wmr.152.1621930899509;
        Tue, 25 May 2021 01:21:39 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id m11sm9837730wmq.33.2021.05.25.01.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 01:21:38 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60ac946e.1c69fb81.5efc2.65deSMTPIN_ADDED_MISSING@mx.google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: Add to traces the req pointer when available
Message-ID: <439a2ab8-765d-9a77-5dfd-dde2bd6884c4@gmail.com>
Date:   Tue, 25 May 2021 09:21:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <60ac946e.1c69fb81.5efc2.65deSMTPIN_ADDED_MISSING@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/25/21 6:54 AM, Olivier Langlois wrote:
> The req pointer uniquely identify a specific request.
> Having it in traces can provide valuable insights that is not possible
> to have if the calling process is reusing the same user_data value.

How about hashing kernel pointers per discussed? Even if it's better
to have it done by tracing or something as you mentioned, there is no
such a thing at the moment, so should be done by hand.

Btw, I'd incline you to split it in two patches, a cleanup and one
adding req, because it's unreadable and hides the real change

> ---
>  fs/io_uring.c                   |  8 +--
>  include/trace/events/io_uring.h | 95 ++++++++++++++++++++++-----------
>  2 files changed, 67 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5f82954004f6..496588ca984c 100644
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
> @@ -6578,7 +6578,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  		goto fail_req;
>  
>  	/* don't need @sqe from now on */
> -	trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
> +	trace_io_uring_submit_sqe(ctx, req, req->opcode, req->user_data,
>  				true, ctx->flags & IORING_SETUP_SQPOLL);
>  
>  	/*
> diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
> index abb8b24744fd..12861e98c08d 100644
> --- a/include/trace/events/io_uring.h
> +++ b/include/trace/events/io_uring.h
> @@ -129,7 +129,7 @@ TRACE_EVENT(io_uring_file_get,
>   *
>   * @ctx:	pointer to a ring context structure
>   * @hashed:	type of workqueue, hashed or normal
> - * @req:	pointer to a submitted request
> + * @req:	pointer to a queued request
>   * @work:	pointer to a submitted io_wq_work
>   *
>   * Allows to trace asynchronous work submission.
> @@ -142,9 +142,9 @@ TRACE_EVENT(io_uring_queue_async_work,
>  	TP_ARGS(ctx, rw, req, work, flags),
>  
>  	TP_STRUCT__entry (
> -		__field(  void *,				ctx		)
> -		__field(  int,					rw		)
> -		__field(  void *,				req		)
> +		__field(  void *,			ctx	)
> +		__field(  int,				rw	)
> +		__field(  void *,			req	)
>  		__field(  struct io_wq_work *,		work	)
>  		__field(  unsigned int,			flags	)
>  	),
> @@ -196,10 +196,10 @@ TRACE_EVENT(io_uring_defer,
>  
>  /**
>   * io_uring_link - called before the io_uring request added into link_list of
> - * 				   another request
> + *		   another request
>   *
> - * @ctx:			pointer to a ring context structure
> - * @req:			pointer to a linked request
> + * @ctx:		pointer to a ring context structure
> + * @req:		pointer to a linked request
>   * @target_req:		pointer to a previous request, that would contain @req
>   *
>   * Allows to track linked requests, to understand dependencies between requests
> @@ -212,8 +212,8 @@ TRACE_EVENT(io_uring_link,
>  	TP_ARGS(ctx, req, target_req),
>  
>  	TP_STRUCT__entry (
> -		__field(  void *,	ctx			)
> -		__field(  void *,	req			)
> +		__field(  void *,	ctx		)
> +		__field(  void *,	req		)
>  		__field(  void *,	target_req	)
>  	),
>  
> @@ -244,7 +244,7 @@ TRACE_EVENT(io_uring_cqring_wait,
>  	TP_ARGS(ctx, min_events),
>  
>  	TP_STRUCT__entry (
> -		__field(  void *,	ctx			)
> +		__field(  void *,	ctx		)
>  		__field(  int,		min_events	)
>  	),
>  
> @@ -272,7 +272,7 @@ TRACE_EVENT(io_uring_fail_link,
>  	TP_ARGS(req, link),
>  
>  	TP_STRUCT__entry (
> -		__field(  void *,	req		)
> +		__field(  void *,	req	)
>  		__field(  void *,	link	)
>  	),
>  
> @@ -314,15 +314,15 @@ TRACE_EVENT(io_uring_complete,
>  	),
>  
>  	TP_printk("ring %p, user_data 0x%llx, result %ld, cflags %x",
> -			  __entry->ctx, (unsigned long long)__entry->user_data,
> -			  __entry->res, __entry->cflags)
> +		   __entry->ctx, (unsigned long long)__entry->user_data,
> +		   __entry->res, __entry->cflags)
>  );
>  
> -
>  /**
>   * io_uring_submit_sqe - called before submitting one SQE
>   *
>   * @ctx:		pointer to a ring context structure
> + * @req:		pointer to a submitted request
>   * @opcode:		opcode of request
>   * @user_data:		user data associated with the request
>   * @force_nonblock:	whether a context blocking or not
> @@ -333,13 +333,14 @@ TRACE_EVENT(io_uring_complete,
>   */
>  TRACE_EVENT(io_uring_submit_sqe,
>  
> -	TP_PROTO(void *ctx, u8 opcode, u64 user_data, bool force_nonblock,
> -		 bool sq_thread),
> +	TP_PROTO(void *ctx, void *req, u8 opcode, u64 user_data,
> +		 bool force_nonblock, bool sq_thread),
>  
> -	TP_ARGS(ctx, opcode, user_data, force_nonblock, sq_thread),
> +	TP_ARGS(ctx, req, opcode, user_data, force_nonblock, sq_thread),
>  
>  	TP_STRUCT__entry (
>  		__field(  void *,	ctx		)
> +		__field(  void *,	req		)
>  		__field(  u8,		opcode		)
>  		__field(  u64,		user_data	)
>  		__field(  bool,		force_nonblock	)
> @@ -348,26 +349,42 @@ TRACE_EVENT(io_uring_submit_sqe,
>  
>  	TP_fast_assign(
>  		__entry->ctx		= ctx;
> +		__entry->req		= req;
>  		__entry->opcode		= opcode;
>  		__entry->user_data	= user_data;
>  		__entry->force_nonblock	= force_nonblock;
>  		__entry->sq_thread	= sq_thread;
>  	),
>  
> -	TP_printk("ring %p, op %d, data 0x%llx, non block %d, sq_thread %d",
> -			  __entry->ctx, __entry->opcode,
> -			  (unsigned long long) __entry->user_data,
> -			  __entry->force_nonblock, __entry->sq_thread)
> +	TP_printk("ring %p, req %p, op %d, data 0x%llx, non block %d, "
> +		  "sq_thread %d",  __entry->ctx, __entry->req,
> +		  __entry->opcode, (unsigned long long)__entry->user_data,
> +		  __entry->force_nonblock, __entry->sq_thread)
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
> +	TP_ARGS(ctx, req, opcode, user_data, events, fd),
>  
>  	TP_STRUCT__entry (
>  		__field(  void *,	ctx		)
> +		__field(  void *,	req		)
>  		__field(  u8,		opcode		)
>  		__field(  u64,		user_data	)
>  		__field(  int,		mask		)
> @@ -376,16 +393,17 @@ TRACE_EVENT(io_uring_poll_arm,
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
> @@ -440,27 +458,40 @@ TRACE_EVENT(io_uring_task_add,
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
