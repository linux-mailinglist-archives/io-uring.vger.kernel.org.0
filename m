Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC0635E4D9
	for <lists+io-uring@lfdr.de>; Tue, 13 Apr 2021 19:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345759AbhDMRUA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Apr 2021 13:20:00 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:33741 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345795AbhDMRT7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Apr 2021 13:19:59 -0400
Received: by mail-wr1-f49.google.com with SMTP id g9so1185192wrx.0
        for <io-uring@vger.kernel.org>; Tue, 13 Apr 2021 10:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c+AO+pcruZ6JJv6DIPkzWdMEnGNAXxD18jdmuzOFbKY=;
        b=WhGCe2XYUntz2qeoNZJ5+lCtaofgXQQucSX/pd5Bj0gkBGu/JJROyUXHqS1mKV7JyA
         5PJlH+UcSv9G2M9XX027srMRoSSYDTsyJZN1j2K05queTGK00QLqfYNk08LAZ5bJ/Mk/
         gxSuk6rj6bZxSw9g9dvTQPkZ4EIRCiH/htIVagfwHGm+ecY3WUPIPmJFu+JJlzvIZXzR
         MSpYWBBrx4owNGgtqOWbTIxjlIDBDNf39y7EpOWbQpqxkx2Ym2SV3uuu4tHhRsBQxNfE
         hPTyq3iBjEyQ1M5kplgQeDm7EP4lSXe54NyZ8PV1Cy/LUK8BxCDIwXOCuzb2qRpoh9w9
         uXPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c+AO+pcruZ6JJv6DIPkzWdMEnGNAXxD18jdmuzOFbKY=;
        b=niYblLkcYpKt8iW/TNp9kks1XKjUG5OdNW7JaBnHskBAbsvzSTS80d6tXhAIZux8gh
         +66NwxkYd9s6ZTGBbfd+erDgLI5FYKwGR7ZTiqCCme4mr8Vdxktqy9PfKUz2KNjeATHr
         V8O/BXAQWTeCTsH6cVO7crZ2mjWOamU7UNATKCGntZqmiuw4Yb/aTExfXg899iR4FO/S
         2mjs1iaG8jcLNjPtiOB9dn1X7iHe9+b6qBRzQE2tWDzlZGu/5sVxM3AuYc0dgZrsDM47
         fpkNxNQ7gDMbOp4AtrKcai58zOD7FcNa25/NyM8S1yPnztWkVZ6zgUtFYgJnUj100BPf
         K8gQ==
X-Gm-Message-State: AOAM53105cUOG5fqpT3qHI134yiDsXLbNE9rWlW3vBti76BS4Oewkbe4
        w/t4hz6ujHDkjMqBKFFwAHTgoqD9G8FC9Q==
X-Google-Smtp-Source: ABdhPJwyYWhJX1Vj8hfZTQmPAfmQnz8Zh05TKO1Kw4i9In4uzHYHGE3B4LNvuRMJw40wCxsjC9vOdA==
X-Received: by 2002:adf:f308:: with SMTP id i8mr18580630wro.209.1618334318816;
        Tue, 13 Apr 2021 10:18:38 -0700 (PDT)
Received: from [192.168.8.181] ([148.252.128.208])
        by smtp.gmail.com with ESMTPSA id b15sm20998531wrx.73.2021.04.13.10.18.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 10:18:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1618278933.git.asml.silence@gmail.com>
 <b2f74d64ffebb57a648f791681af086c7211e3a4.1618278933.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 3/9] io_uring: split poll and poll update structures
Message-ID: <f726ee43-4c19-8551-3f34-d769a8eacf89@gmail.com>
Date:   Tue, 13 Apr 2021 18:14:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b2f74d64ffebb57a648f791681af086c7211e3a4.1618278933.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 13/04/2021 02:58, Pavel Begunkov wrote:
> struct io_poll_iocb became pretty nasty combining also update fields.
> Split them, so we would have more clarity to it.

I think we should move update into IORING_OP_POLL_REMOVE until it's
not too late. Would have better struct layouts and didn't get in
way of POLL_ADD, which should be more popular.

Another thing, looks IORING_OP_POLL_REMOVE may cancel apoll, that
doesn't sound great. IMHO we need to limit it to only poll requests,
rather confusing otherwise. note: it can't be used reliably from
the userspace, so we may probably not care about change in behaviour

> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 55 ++++++++++++++++++++++++++++++---------------------
>  1 file changed, 32 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 429ee5fd9044..a0f207e62e32 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -490,15 +490,16 @@ struct io_poll_iocb {
>  	__poll_t			events;
>  	bool				done;
>  	bool				canceled;
> +	struct wait_queue_entry		wait;
> +};
> +
> +struct io_poll_update {
> +	struct file			*file;
> +	u64				old_user_data;
> +	u64				new_user_data;
> +	__poll_t			events;
>  	bool				update_events;
>  	bool				update_user_data;
> -	union {
> -		struct wait_queue_entry	wait;
> -		struct {
> -			u64		old_user_data;
> -			u64		new_user_data;
> -		};
> -	};
>  };
>  
>  struct io_poll_remove {
> @@ -715,6 +716,7 @@ enum {
>  	REQ_F_COMPLETE_INLINE_BIT,
>  	REQ_F_REISSUE_BIT,
>  	REQ_F_DONT_REISSUE_BIT,
> +	REQ_F_POLL_UPDATE_BIT,
>  	/* keep async read/write and isreg together and in order */
>  	REQ_F_ASYNC_READ_BIT,
>  	REQ_F_ASYNC_WRITE_BIT,
> @@ -762,6 +764,8 @@ enum {
>  	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
>  	/* don't attempt request reissue, see io_rw_reissue() */
>  	REQ_F_DONT_REISSUE	= BIT(REQ_F_DONT_REISSUE_BIT),
> +	/* switches between poll and poll update */
> +	REQ_F_POLL_UPDATE	= BIT(REQ_F_POLL_UPDATE_BIT),
>  	/* supports async reads */
>  	REQ_F_ASYNC_READ	= BIT(REQ_F_ASYNC_READ_BIT),
>  	/* supports async writes */
> @@ -791,6 +795,7 @@ struct io_kiocb {
>  		struct file		*file;
>  		struct io_rw		rw;
>  		struct io_poll_iocb	poll;
> +		struct io_poll_update	poll_update;
>  		struct io_poll_remove	poll_remove;
>  		struct io_accept	accept;
>  		struct io_sync		sync;
> @@ -4989,7 +4994,6 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
>  	poll->head = NULL;
>  	poll->done = false;
>  	poll->canceled = false;
> -	poll->update_events = poll->update_user_data = false;
>  #define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
>  	/* mask in events that we always want/need */
>  	poll->events = events | IO_POLL_UNMASK;
> @@ -5366,7 +5370,6 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
>  
>  static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
> -	struct io_poll_iocb *poll = &req->poll;
>  	u32 events, flags;
>  
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
> @@ -5383,20 +5386,26 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>  #endif
>  	if (!(flags & IORING_POLL_ADD_MULTI))
>  		events |= EPOLLONESHOT;
> -	poll->update_events = poll->update_user_data = false;
> +	events = demangle_poll(events) |
> +				(events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
>  
>  	if (flags & (IORING_POLL_UPDATE_EVENTS|IORING_POLL_UPDATE_USER_DATA)) {
> -		poll->old_user_data = READ_ONCE(sqe->addr);
> -		poll->update_events = flags & IORING_POLL_UPDATE_EVENTS;
> -		poll->update_user_data = flags & IORING_POLL_UPDATE_USER_DATA;
> -		if (poll->update_user_data)
> -			poll->new_user_data = READ_ONCE(sqe->off);
> +		struct io_poll_update *poll_upd = &req->poll_update;
> +
> +		req->flags |= REQ_F_POLL_UPDATE;
> +		poll_upd->events = events;
> +		poll_upd->old_user_data = READ_ONCE(sqe->addr);
> +		poll_upd->update_events = flags & IORING_POLL_UPDATE_EVENTS;
> +		poll_upd->update_user_data = flags & IORING_POLL_UPDATE_USER_DATA;
> +		if (poll_upd->update_user_data)
> +			poll_upd->new_user_data = READ_ONCE(sqe->off);
>  	} else {
> +		struct io_poll_iocb *poll = &req->poll;
> +
> +		poll->events = events;
>  		if (sqe->off || sqe->addr)
>  			return -EINVAL;
>  	}
> -	poll->events = demangle_poll(events) |
> -				(events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
>  	return 0;
>  }
>  
> @@ -5434,7 +5443,7 @@ static int io_poll_update(struct io_kiocb *req)
>  	int ret;
>  
>  	spin_lock_irq(&ctx->completion_lock);
> -	preq = io_poll_find(ctx, req->poll.old_user_data);
> +	preq = io_poll_find(ctx, req->poll_update.old_user_data);
>  	if (!preq) {
>  		ret = -ENOENT;
>  		goto err;
> @@ -5464,13 +5473,13 @@ static int io_poll_update(struct io_kiocb *req)
>  		return 0;
>  	}
>  	/* only mask one event flags, keep behavior flags */
> -	if (req->poll.update_events) {
> +	if (req->poll_update.update_events) {
>  		preq->poll.events &= ~0xffff;
> -		preq->poll.events |= req->poll.events & 0xffff;
> +		preq->poll.events |= req->poll_update.events & 0xffff;
>  		preq->poll.events |= IO_POLL_UNMASK;
>  	}
> -	if (req->poll.update_user_data)
> -		preq->user_data = req->poll.new_user_data;
> +	if (req->poll_update.update_user_data)
> +		preq->user_data = req->poll_update.new_user_data;
>  
>  	spin_unlock_irq(&ctx->completion_lock);
>  
> @@ -5489,7 +5498,7 @@ static int io_poll_update(struct io_kiocb *req)
>  
>  static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
>  {
> -	if (!req->poll.update_events && !req->poll.update_user_data)
> +	if (!(req->flags & REQ_F_POLL_UPDATE))
>  		return __io_poll_add(req);
>  	return io_poll_update(req);
>  }
> 

-- 
Pavel Begunkov
