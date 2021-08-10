Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55763E5BA7
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 15:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhHJNbb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 09:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbhHJNb3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 09:31:29 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3064C0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 06:31:06 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q11so8108905wrr.9
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 06:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=W65eS66cdmv3GPkRBhRCkXm6p3mH7dQu2roE9b1te+o=;
        b=N9NcqkzgELPzmgBrHBSkfBVtDdaNkhnbFz0UcM+tmEOOui5x0cMUCqxlkzCcnpbZ4x
         fwGm68Kzs2W3QOa1GuJ03p1ygN/grgrPDYWFvOhGfh4UcDjAm2gj+LAH/p6XuDdBbz0u
         kgJ16w/Qpuha2BLsJpcJcMvEVCseWUwxNDrB7nbfTizCgLgBxsuuni6/gZ7QjAxYvAsa
         Dd2B/pMj4IWPQb8FYpYjRlECp+00cDCxzNhPygHaIP6oWWMiT6c9fcd5ZQB3Q1vTp390
         oOZgQTmt6itO2IAapASFZyOrIVkQWq/2hRTjWUZKaY0u4UV58JxvA41cQx5ItWfDAXor
         bmBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W65eS66cdmv3GPkRBhRCkXm6p3mH7dQu2roE9b1te+o=;
        b=Q6x9LmT4Wopm5Ga43oRp+ilOXWif7zpxGCefn+d4RXLcA/LI5WN9DoXZs3LIq0GsH9
         7k+CqHc0yUvhnuMm2jdhO5N9mHjBGCKi2n3vQZuMaPa6ApNnzoVrX7jNiENl5+/SSW9e
         nX7XbDvbmJZwzzrPXXD4rBZEPR0IrY0shh/lW6LkbtOJ3iRO7IsbVbKVS9gXWWp1w+Od
         Rt6hSLcZsWdQmO73YrWdi8UkuXaLDlyRLqxKwDo0u/40yTmzkl0+mpyEQZgI2NpWnQSF
         VxAAcN3Vl5OK/Nd5wXRr66a1llBxL6t4lv3u8OTKy6a8O4wXgQ9oMYPaycOmGvoNC6MY
         VaYQ==
X-Gm-Message-State: AOAM533B+2IP2N6pIR9kEhUnaENl+puiTrrTA2bn02amY/YE3iOFDNTo
        CUPcJEIayGt1zsfeaQuF4ZmQdaLN5cQ=
X-Google-Smtp-Source: ABdhPJxx7E1LhyM7cxVmIVvI4Kovdbe/wfTlxxtaqX6HZ00WpBvQTX6C9+5d1xKdGLY50xNrAmF3QQ==
X-Received: by 2002:a5d:6b8f:: with SMTP id n15mr30575144wrx.103.1628602265232;
        Tue, 10 Aug 2021 06:31:05 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id o28sm19858175wms.14.2021.08.10.06.31.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 06:31:04 -0700 (PDT)
Subject: Re: [PATCH 5/5] io_uring: request refcounting skipping
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1628595748.git.asml.silence@gmail.com>
 <e0fcda22da389d2cbc1068f857fb01d68c9ddfb7.1628595748.git.asml.silence@gmail.com>
Message-ID: <2a60b3d5-41d0-d784-0405-dc8dbdfbb68f@gmail.com>
Date:   Tue, 10 Aug 2021 14:30:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <e0fcda22da389d2cbc1068f857fb01d68c9ddfb7.1628595748.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 1:05 PM, Pavel Begunkov wrote:
> The intention here is to skip request refcounting in most hot cases,
> and use only when it's really needed. So, it should save 2 refcount
> atomics per request for IOPOLL and IRQ completions, and 1 atomic per
> req for inline completions.
> 
> There are cases, however, where the refcounting is enabled back:
> - Polling, including apoll. Because double poll entries takes a ref.
>   Might get relaxed in the near future.
> - Link timeouts, for both, the timeout and the request it's bound to,
>   because they work in-parallel and we need to synchronise to cancel one
>   of them on completion.
> - When in io-wq, because it doesn't hold uring_lock, so the guarantees
>   described below doesn't work, and there is also io_wq_free_work().
> 
> TL;DR;
> Requests were always given with two references. One is called completion
> and is generally put at the moment I/O is completed. The second is
> submission reference, which is usually put during submission, e.g. by
> __io_queue_sqe(). It was needed, because the code actually issuing a
> request (e.g. fs, the block layer, etc.), may punt it for async
> execution, but still access associated memory while unwinding back to
> io_uring.
> 
> First, let's notice that now all requests are returned back into the
> request cache and not actually kfreed(). Also, we take requests out of
> it only under ->uring_lock. So, if I/O submission is also protected by
> the mutex, and even if io_issue_sqe() completes a request deep down the
> stack, the memory is not going to be freed and the request won't be
> re-allocated until the submission stack unwinds back and we unlock
> the mutex. If it's not protected by the mutex, we're in io-wq, which
> takes a reference anyway resembling submission referencing.

And there is still ->file that might be dropped in the middle and
other bits from io_clean_op(), so will be racy.

> 
> Same with other parts that may get accessed on the way back,
> ->async_data deallocation is delayed up to io_alloc_req(), and
> rsrc deallocation is also now protected by the mutex.
> 
> With all that we can kill off submission references. And next, in most
> cases we have only one reference travelling along the execution path,
> so we can replace it with a flag allowing to enable refcounting when
> needed.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 58 ++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 36 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5a08cc967199..d65621247709 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -712,6 +712,7 @@ enum {
>  	REQ_F_REISSUE_BIT,
>  	REQ_F_DONT_REISSUE_BIT,
>  	REQ_F_CREDS_BIT,
> +	REQ_F_REFCOUNT_BIT,
>  	/* keep async read/write and isreg together and in order */
>  	REQ_F_NOWAIT_READ_BIT,
>  	REQ_F_NOWAIT_WRITE_BIT,
> @@ -767,6 +768,8 @@ enum {
>  	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
>  	/* has creds assigned */
>  	REQ_F_CREDS		= BIT(REQ_F_CREDS_BIT),
> +	/* skip refcounting if not set */
> +	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
>  };
>  
>  struct async_poll {
> @@ -1090,26 +1093,40 @@ EXPORT_SYMBOL(io_uring_get_socket);
>  
>  static inline bool req_ref_inc_not_zero(struct io_kiocb *req)
>  {
> +	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
>  	return atomic_inc_not_zero(&req->refs);
>  }
>  
>  static inline bool req_ref_put_and_test(struct io_kiocb *req)
>  {
> +	if (likely(!(req->flags & REQ_F_REFCOUNT)))
> +		return true;
> +
>  	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
>  	return atomic_dec_and_test(&req->refs);
>  }
>  
>  static inline void req_ref_put(struct io_kiocb *req)
>  {
> +	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
>  	WARN_ON_ONCE(req_ref_put_and_test(req));
>  }
>  
>  static inline void req_ref_get(struct io_kiocb *req)
>  {
> +	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
>  	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
>  	atomic_inc(&req->refs);
>  }
>  
> +static inline void io_req_refcount(struct io_kiocb *req)
> +{
> +	if (!(req->flags & REQ_F_REFCOUNT)) {
> +		req->flags |= REQ_F_REFCOUNT;
> +		atomic_set(&req->refs, 1);
> +	}
> +}
> +
>  static inline void io_req_set_rsrc_node(struct io_kiocb *req)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
> @@ -1706,7 +1723,6 @@ static inline void io_req_complete(struct io_kiocb *req, long res)
>  static void io_req_complete_failed(struct io_kiocb *req, long res)
>  {
>  	req_set_fail(req);
> -	io_put_req(req);
>  	io_req_complete_post(req, res, 0);
>  }
>  
> @@ -1761,7 +1777,14 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
>  	return nr != 0;
>  }
>  
> +/*
> + * A request might get retired back into the request caches even before opcode
> + * handlers and io_issue_sqe() are done with it, e.g. inline completion path.
> + * Because of that, io_alloc_req() should be called only under ->uring_lock
> + * and with extra caution to not get a request that is still worked on.
> + */
>  static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
> +	__must_hold(&req->ctx->uring_lock)
>  {
>  	struct io_submit_state *state = &ctx->submit_state;
>  	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
> @@ -1883,8 +1906,6 @@ static void io_fail_links(struct io_kiocb *req)
>  
>  		trace_io_uring_fail_link(req, link);
>  		io_cqring_fill_event(link->ctx, link->user_data, -ECANCELED, 0);
> -
> -		io_put_req(link);
>  		io_put_req_deferred(link);
>  		link = nxt;
>  	}
> @@ -2166,8 +2187,6 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
>  	for (i = 0; i < nr; i++) {
>  		struct io_kiocb *req = state->compl_reqs[i];
>  
> -		/* submission and completion refs */
> -		io_put_req(req);
>  		if (req_ref_put_and_test(req))
>  			io_req_free_batch(&rb, req, &ctx->submit_state);
>  	}
> @@ -2272,7 +2291,6 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>  		if (READ_ONCE(req->result) == -EAGAIN && resubmit &&
>  		    !(req->flags & REQ_F_DONT_REISSUE)) {
>  			req->iopoll_completed = 0;
> -			req_ref_get(req);
>  			io_req_task_queue_reissue(req);
>  			continue;
>  		}
> @@ -2787,7 +2805,6 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
>  	if (check_reissue && (req->flags & REQ_F_REISSUE)) {
>  		req->flags &= ~REQ_F_REISSUE;
>  		if (io_resubmit_prep(req)) {
> -			req_ref_get(req);
>  			io_req_task_queue_reissue(req);
>  		} else {
>  			int cflags = 0;
> @@ -3213,9 +3230,6 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
>  
>  	req->rw.kiocb.ki_flags &= ~IOCB_WAITQ;
>  	list_del_init(&wait->entry);
> -
> -	/* submit ref gets dropped, acquire a new one */
> -	req_ref_get(req);
>  	io_req_task_queue(req);
>  	return 1;
>  }
> @@ -5220,6 +5234,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>  	req->apoll = apoll;
>  	req->flags |= REQ_F_POLLED;
>  	ipt.pt._qproc = io_async_queue_proc;
> +	io_req_refcount(req);
>  
>  	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
>  					io_async_wake);
> @@ -5267,10 +5282,6 @@ static bool io_poll_remove_one(struct io_kiocb *req)
>  		io_cqring_fill_event(req->ctx, req->user_data, -ECANCELED, 0);
>  		io_commit_cqring(req->ctx);
>  		req_set_fail(req);
> -
> -		/* non-poll requests have submit ref still */
> -		if (req->opcode != IORING_OP_POLL_ADD)
> -			io_put_req(req);
>  		io_put_req_deferred(req);
>  	}
>  	return do_complete;
> @@ -5414,6 +5425,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>  	if (flags & ~IORING_POLL_ADD_MULTI)
>  		return -EINVAL;
>  
> +	io_req_refcount(req);
>  	poll->events = io_poll_parse_events(sqe, flags);
>  	return 0;
>  }
> @@ -6290,6 +6302,10 @@ static void io_wq_submit_work(struct io_wq_work *work)
>  	struct io_kiocb *timeout;
>  	int ret = 0;
>  
> +	io_req_refcount(req);
> +	/* will be dropped by ->io_free_work() after returning to io-wq */
> +	req_ref_get(req);
> +
>  	timeout = io_prep_linked_timeout(req);
>  	if (timeout)
>  		io_queue_linked_timeout(timeout);
> @@ -6312,11 +6328,8 @@ static void io_wq_submit_work(struct io_wq_work *work)
>  	}
>  
>  	/* avoid locking problems by failing it from a clean context */
> -	if (ret) {
> -		/* io-wq is going to take one down */
> -		req_ref_get(req);
> +	if (ret)
>  		io_req_task_queue_fail(req, ret);
> -	}
>  }
>  
>  static inline struct io_fixed_file *io_fixed_file_slot(struct io_file_table *table,
> @@ -6450,6 +6463,11 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
>  	    nxt->opcode != IORING_OP_LINK_TIMEOUT)
>  		return NULL;
>  
> +	/* linked timeouts should have two refs once prep'ed */
> +	io_req_refcount(req);
> +	io_req_refcount(nxt);
> +	req_ref_get(nxt);
> +
>  	nxt->timeout.head = req;
>  	nxt->flags |= REQ_F_LTIMEOUT_ACTIVE;
>  	req->flags |= REQ_F_LINK_TIMEOUT;
> @@ -6478,8 +6496,6 @@ static void __io_queue_sqe(struct io_kiocb *req)
>  			state->compl_reqs[state->compl_nr++] = req;
>  			if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
>  				io_submit_flush_completions(ctx);
> -		} else {
> -			io_put_req(req);
>  		}
>  	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
>  		switch (io_arm_poll_handler(req)) {
> @@ -6559,8 +6575,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  	req->user_data = READ_ONCE(sqe->user_data);
>  	req->file = NULL;
>  	req->fixed_rsrc_refs = NULL;
> -	/* one is dropped after submission, the other at completion */
> -	atomic_set(&req->refs, 2);
>  	req->task = current;
>  
>  	/* enforce forwards compatibility on users */
> 

-- 
Pavel Begunkov
