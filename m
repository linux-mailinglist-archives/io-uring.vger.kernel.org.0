Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63575407F61
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 20:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhILSZj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 14:25:39 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:55929 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhILSZj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 14:25:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uo5AOS3_1631471057;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uo5AOS3_1631471057)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 13 Sep 2021 02:24:18 +0800
Subject: Re: [PATCH 1/3] io_uring: clean cqe filling functions
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1631367587.git.asml.silence@gmail.com>
 <c1c50ac6b6badf319006f580715b8da6438e8e23.1631367587.git.asml.silence@gmail.com>
Cc:     Joseph Qi <joseph.qi@linux.alibaba.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <3099ae18-5e15-eb7d-b9b8-ddd1217f1a04@linux.alibaba.com>
Date:   Mon, 13 Sep 2021 02:24:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <c1c50ac6b6badf319006f580715b8da6438e8e23.1631367587.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/11 下午9:52, Pavel Begunkov 写道:
> Split io_cqring_fill_event() into a couple of more targeted functions.
> The first on is io_fill_cqe_aux() for completions that are not
> associated with request completions and doing the ->cq_extra accounting.
> Examples are additional CQEs from multishot poll and rsrc notifications.
> 
> The second is io_fill_cqe_req(), should be called when it's a normal
> request completion. Nothing more to it at the moment, will be used in
> later patches.
> 
> The last one is inlined __io_fill_cqe() for a finer grained control,
> should be used with caution and in hottest places.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 58 ++++++++++++++++++++++++++-------------------------
>   1 file changed, 30 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e6ccdae189b0..1703130ae8df 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1078,8 +1078,8 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>   					 bool cancel_all);
>   static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
>   
> -static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
> -				 long res, unsigned int cflags);
> +static void io_fill_cqe_req(struct io_kiocb *req, long res, unsigned int cflags);
> +
>   static void io_put_req(struct io_kiocb *req);
>   static void io_put_req_deferred(struct io_kiocb *req);
>   static void io_dismantle_req(struct io_kiocb *req);
> @@ -1491,7 +1491,7 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
>   		atomic_set(&req->ctx->cq_timeouts,
>   			atomic_read(&req->ctx->cq_timeouts) + 1);
>   		list_del_init(&req->timeout.list);
> -		io_cqring_fill_event(req->ctx, req->user_data, status, 0);
> +		io_fill_cqe_req(req, status, 0);
>   		io_put_req_deferred(req);
>   	}
>   }
> @@ -1760,8 +1760,8 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
>   	return true;
>   }
>   
> -static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
> -					  long res, unsigned int cflags)
> +static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
> +				 long res, unsigned int cflags)
>   {
>   	struct io_uring_cqe *cqe;
>   
> @@ -1782,11 +1782,17 @@ static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data
>   	return io_cqring_event_overflow(ctx, user_data, res, cflags);
>   }
>   
> -/* not as hot to bloat with inlining */
> -static noinline bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
> -					  long res, unsigned int cflags)
> +static noinline void io_fill_cqe_req(struct io_kiocb *req, long res,
> +				     unsigned int cflags)
> +{
> +	__io_fill_cqe(req->ctx, req->user_data, res, cflags);
> +}
> +
> +static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
> +				     long res, unsigned int cflags)
>   {
> -	return __io_cqring_fill_event(ctx, user_data, res, cflags);
> +	ctx->cq_extra++;
> +	return __io_fill_cqe(ctx, user_data, res, cflags);
>   }
>   
>   static void io_req_complete_post(struct io_kiocb *req, long res,
> @@ -1795,7 +1801,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
>   	struct io_ring_ctx *ctx = req->ctx;
>   
>   	spin_lock(&ctx->completion_lock);
> -	__io_cqring_fill_event(ctx, req->user_data, res, cflags);
> +	__io_fill_cqe(ctx, req->user_data, res, cflags);
>   	/*
>   	 * If we're the last reference to this request, add to our locked
>   	 * free_list cache.
> @@ -2021,8 +2027,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
>   		link->timeout.head = NULL;
>   		if (hrtimer_try_to_cancel(&io->timer) != -1) {
>   			list_del(&link->timeout.list);
> -			io_cqring_fill_event(link->ctx, link->user_data,
> -					     -ECANCELED, 0);
> +			io_fill_cqe_req(link, -ECANCELED, 0);
>   			io_put_req_deferred(link);
>   			return true;
>   		}
> @@ -2046,7 +2051,7 @@ static void io_fail_links(struct io_kiocb *req)
>   		link->link = NULL;
>   
>   		trace_io_uring_fail_link(req, link);
> -		io_cqring_fill_event(link->ctx, link->user_data, res, 0);
> +		io_fill_cqe_req(link, res, 0);
>   		io_put_req_deferred(link);
>   		link = nxt;
>   	}
> @@ -2063,8 +2068,7 @@ static bool io_disarm_next(struct io_kiocb *req)
>   		req->flags &= ~REQ_F_ARM_LTIMEOUT;
>   		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
>   			io_remove_next_linked(req);
> -			io_cqring_fill_event(link->ctx, link->user_data,
> -					     -ECANCELED, 0);
> +			io_fill_cqe_req(link, -ECANCELED, 0);
>   			io_put_req_deferred(link);
>   			posted = true;
>   		}
> @@ -2335,8 +2339,8 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   	for (i = 0; i < nr; i++) {
>   		struct io_kiocb *req = state->compl_reqs[i];
>   
> -		__io_cqring_fill_event(ctx, req->user_data, req->result,
> -					req->compl.cflags);
> +		__io_fill_cqe(ctx, req->user_data, req->result,
> +			      req->compl.cflags);
>   	}
>   	io_commit_cqring(ctx);
>   	spin_unlock(&ctx->completion_lock);
> @@ -2454,8 +2458,8 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>   			continue;
>   		}
>   
> -		__io_cqring_fill_event(ctx, req->user_data, req->result,
> -					io_put_rw_kbuf(req));
> +		__io_fill_cqe(ctx, req->user_data, req->result,
> +			      io_put_rw_kbuf(req));
>   		(*nr_events)++;
>   
>   		if (req_ref_put_and_test(req))
> @@ -5293,13 +5297,12 @@ static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
>   	}
>   	if (req->poll.events & EPOLLONESHOT)
>   		flags = 0;
> -	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
> +	if (!(flags & IORING_CQE_F_MORE)) {
> +		io_fill_cqe_req(req, error, flags);
We should check the return value of io_fill_cqe_req() and do
req->poll.done = true if the return value is false, which means ocqe
allocation failed. Though I think the current poll.done logic itself
is not right.(I've changed it in another patch)
> +	} else if (!io_fill_cqe_aux(ctx, req->user_data, error, flags)) {
>   		req->poll.done = true;
>   		flags = 0;
>   	}
> -	if (flags & IORING_CQE_F_MORE)
> -		ctx->cq_extra++;
> -
>   	return !(flags & IORING_CQE_F_MORE);
>   }
>   
> @@ -5627,9 +5630,9 @@ static bool io_poll_remove_one(struct io_kiocb *req)
>   	do_complete = __io_poll_remove_one(req, io_poll_get_single(req), true);
>   
>   	if (do_complete) {
> -		io_cqring_fill_event(req->ctx, req->user_data, -ECANCELED, 0);
> -		io_commit_cqring(req->ctx);
>   		req_set_fail(req);
> +		io_fill_cqe_req(req, -ECANCELED, 0);
> +		io_commit_cqring(req->ctx);
>   		io_put_req_deferred(req);
>   	}
>   	return do_complete;
> @@ -5924,7 +5927,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
>   		return PTR_ERR(req);
>   
>   	req_set_fail(req);
> -	io_cqring_fill_event(ctx, req->user_data, -ECANCELED, 0);
> +	io_fill_cqe_req(req, -ECANCELED, 0);
>   	io_put_req_deferred(req);
>   	return 0;
>   }
> @@ -8122,8 +8125,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
>   
>   			io_ring_submit_lock(ctx, lock_ring);
>   			spin_lock(&ctx->completion_lock);
> -			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
> -			ctx->cq_extra++;
> +			io_fill_cqe_aux(ctx, prsrc->tag, 0, 0);
>   			io_commit_cqring(ctx);
>   			spin_unlock(&ctx->completion_lock);
>   			io_cqring_ev_posted(ctx);
> 

