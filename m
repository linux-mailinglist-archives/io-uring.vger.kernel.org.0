Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8CE2A67F9
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 16:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbgKDPoi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 10:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730391AbgKDPoi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 10:44:38 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D9DC0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 07:44:36 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id p22so2807113wmg.3
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 07:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mky55MBQKYFKbsI0Xr2dVFEw5etuLLC/uqciVKcuhog=;
        b=Ac72lx2HdQGpgDKE4qJqtSBx2qZMSkhWPFaqpa8s/0UjC6mw6XhhHj17CkgeQPvvGM
         ypD9WB/xoeguNocRFBBSV115rPyVT66N3ZhBrSpfH0gUbKGgepvJ0daCws8un1R7VaN7
         ndPfVcdDLBlP2FjViVkxU2tiLNjzgAfKGMbiPjb8XnUOnNdNtzaEOnHnb41gMxCcc/3Z
         hs1lF1n2XorGwwG3E0baazCSWj4qlghlbsFCqRrlohAPRN8LBQNMCb3G1/BK9zgFfWge
         P6A2tOfor0GtwDj7gYF2hwEl7vhY9R1F5ZiHQnnSytgaiC9BknghhIu7Qa7dEED3y9uJ
         QAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mky55MBQKYFKbsI0Xr2dVFEw5etuLLC/uqciVKcuhog=;
        b=pBuZMV5rlc2/J2bDOkHe/ll2X7jAAqtvgtJflAwj4a5uCNeZG46OZgxH6O8cKRCojv
         y+mhDL7zweMWIUpDV+ffceOiyoy/ZbSqtzQnCnPPxZqbiRMFqx3rxyHulCjIYfF57Xy6
         9Ua2YH9GHS0RwZtPNB7vEHZQu9cbXCzgUI5TWT26hidMMWfeltfgwIBbBTn5wCdSnk6q
         GpgGFHa++xp2kqc9mRCNw0/CP0AtV7j1jTOQvfxQDlL/wkmNXzCUzJ8fI6wlOFJquMpZ
         +Q3aQLMnO4/Mt3yqjb546NUdKcRqG5swVlozFMTAxUCvacswCU/dU4ux1IEuvPokBiiA
         ovbw==
X-Gm-Message-State: AOAM532iWtgQehbSo9kmZDKnRJttr0PypEhxvdjWo16ZEHcaecei8rhs
        bLNqGIFUqQnQTrfa/PKq7KGVsC3j8mfAFg==
X-Google-Smtp-Source: ABdhPJx00PNoDTUEm1vtYZg5O4tYBQXJsao+HT2p0FTxksIdfuSIdRwibVTMKWlbO+mevu2Z6BqlIw==
X-Received: by 2002:a1c:2901:: with SMTP id p1mr5425500wmp.170.1604504674670;
        Wed, 04 Nov 2020 07:44:34 -0800 (PST)
Received: from [192.168.1.121] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id k22sm2691454wmi.34.2020.11.04.07.44.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 07:44:34 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <9d97c12a0833617f7adff44f16dc543242d9a1f7.1604496692.git.asml.silence@gmail.com>
 <dcbb9f34-9943-8a80-14c0-a968e02254b6@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.10] io_uring: fix overflowed cancel w/ linked ->files
Message-ID: <f0fb77b2-fd84-0a62-3499-567d575f31ff@gmail.com>
Date:   Wed, 4 Nov 2020 15:41:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <dcbb9f34-9943-8a80-14c0-a968e02254b6@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/11/2020 15:25, Jens Axboe wrote:
> On 11/4/20 6:39 AM, Pavel Begunkov wrote:
>> Current io_match_files() check in io_cqring_overflow_flush() is useless
>> because requests drop ->files before going to the overflow list, however
>> linked to it request do not, and we don't check them.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>
>> Jens, there will be conflicts with 5.11 patches, I'd appreciate if you
>> could ping me when/if you merge it into 5.11
> 
> Just for this one:
> 
> io_uring: link requests with singly linked list
> 
> How does the below look, now based on top of this patch added to
> io_uring-5.10:

Yep, it looks exactly like in my 5.11!

> 
> 
> commit f5a63f6bb1ecfb8852ac2628d53dc3e9644f7f3f
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Tue Oct 27 23:25:37 2020 +0000
> 
>     io_uring: link requests with singly linked list
>     
>     Singly linked list for keeping linked requests is enough, because we
>     almost always operate on the head and traverse forward with the
>     exception of linked timeouts going 1 hop backwards.
>     
>     Replace ->link_list with a handmade singly linked list. Also kill
>     REQ_F_LINK_HEAD in favour of checking a newly added ->list for NULL
>     directly.
>     
>     That saves 8B in io_kiocb, is not as heavy as list fixup, makes better
>     use of cache by not touching a previous request (i.e. last request of
>     the link) each time on list modification and optimises cache use further
>     in the following patch, and actually makes travesal easier removing in
>     the end some lines. Also, keeping invariant in ->list instead of having
>     REQ_F_LINK_HEAD is less error-prone.
>     
>     Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 3f6bc98a91da..a701e8fe6716 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -598,7 +598,6 @@ enum {
>  	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
>  	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
>  
> -	REQ_F_LINK_HEAD_BIT,
>  	REQ_F_FAIL_LINK_BIT,
>  	REQ_F_INFLIGHT_BIT,
>  	REQ_F_CUR_POS_BIT,
> @@ -630,8 +629,6 @@ enum {
>  	/* IOSQE_BUFFER_SELECT */
>  	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
>  
> -	/* head of a link */
> -	REQ_F_LINK_HEAD		= BIT(REQ_F_LINK_HEAD_BIT),
>  	/* fail rest of links */
>  	REQ_F_FAIL_LINK		= BIT(REQ_F_FAIL_LINK_BIT),
>  	/* on inflight list */
> @@ -713,7 +710,7 @@ struct io_kiocb {
>  	struct task_struct		*task;
>  	u64				user_data;
>  
> -	struct list_head		link_list;
> +	struct io_kiocb			*link;
>  
>  	/*
>  	 * 1. used with ctx->iopoll_list with reads/writes
> @@ -1021,6 +1018,9 @@ struct sock *io_uring_get_socket(struct file *file)
>  }
>  EXPORT_SYMBOL(io_uring_get_socket);
>  
> +#define io_for_each_link(pos, head) \
> +	for (pos = (head); pos; pos = pos->link)
> +
>  static inline void io_clean_op(struct io_kiocb *req)
>  {
>  	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
> @@ -1505,10 +1505,8 @@ static void io_prep_async_link(struct io_kiocb *req)
>  {
>  	struct io_kiocb *cur;
>  
> -	io_prep_async_work(req);
> -	if (req->flags & REQ_F_LINK_HEAD)
> -		list_for_each_entry(cur, &req->link_list, link_list)
> -			io_prep_async_work(cur);
> +	io_for_each_link(cur, req)
> +		io_prep_async_work(cur);
>  }
>  
>  static struct io_kiocb *__io_queue_async_work(struct io_kiocb *req)
> @@ -1691,20 +1689,15 @@ static inline bool __io_match_files(struct io_kiocb *req,
>  		req->work.identity->files == files;
>  }
>  
> -static bool io_match_files(struct io_kiocb *req,
> -			   struct files_struct *files)
> +static bool io_match_files(struct io_kiocb *head, struct files_struct *files)
>  {
> -	struct io_kiocb *link;
> +	struct io_kiocb *req;
>  
>  	if (!files)
>  		return true;
> -	if (__io_match_files(req, files))
> -		return true;
> -	if (req->flags & REQ_F_LINK_HEAD) {
> -		list_for_each_entry(link, &req->link_list, link_list) {
> -			if (__io_match_files(link, files))
> -				return true;
> -		}
> +	io_for_each_link(req, head) {
> +		if (__io_match_files(req, files))
> +			return true;
>  	}
>  	return false;
>  }
> @@ -1971,6 +1964,14 @@ static void __io_free_req(struct io_kiocb *req)
>  	percpu_ref_put(&ctx->refs);
>  }
>  
> +static inline void io_remove_next_linked(struct io_kiocb *req)
> +{
> +	struct io_kiocb *nxt = req->link;
> +
> +	req->link = nxt->link;
> +	nxt->link = NULL;
> +}
> +
>  static void io_kill_linked_timeout(struct io_kiocb *req)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
> @@ -1979,8 +1980,8 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&ctx->completion_lock, flags);
> -	link = list_first_entry_or_null(&req->link_list, struct io_kiocb,
> -					link_list);
> +	link = req->link;
> +
>  	/*
>  	 * Can happen if a linked timeout fired and link had been like
>  	 * req -> link t-out -> link t-out [-> ...]
> @@ -1989,7 +1990,7 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
>  		struct io_timeout_data *io = link->async_data;
>  		int ret;
>  
> -		list_del_init(&link->link_list);
> +		io_remove_next_linked(req);
>  		link->timeout.head = NULL;
>  		ret = hrtimer_try_to_cancel(&io->timer);
>  		if (ret != -1) {
> @@ -2007,41 +2008,22 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
>  	}
>  }
>  
> -static struct io_kiocb *io_req_link_next(struct io_kiocb *req)
> -{
> -	struct io_kiocb *nxt;
> -
> -	/*
> -	 * The list should never be empty when we are called here. But could
> -	 * potentially happen if the chain is messed up, check to be on the
> -	 * safe side.
> -	 */
> -	if (unlikely(list_empty(&req->link_list)))
> -		return NULL;
> -
> -	nxt = list_first_entry(&req->link_list, struct io_kiocb, link_list);
> -	list_del_init(&req->link_list);
> -	if (!list_empty(&nxt->link_list))
> -		nxt->flags |= REQ_F_LINK_HEAD;
> -	return nxt;
> -}
>  
> -/*
> - * Called if REQ_F_LINK_HEAD is set, and we fail the head request
> - */
>  static void io_fail_links(struct io_kiocb *req)
>  {
> +	struct io_kiocb *link, *nxt;
>  	struct io_ring_ctx *ctx = req->ctx;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&ctx->completion_lock, flags);
> -	while (!list_empty(&req->link_list)) {
> -		struct io_kiocb *link = list_first_entry(&req->link_list,
> -						struct io_kiocb, link_list);
> +	link = req->link;
> +	req->link = NULL;
>  
> -		list_del_init(&link->link_list);
> -		trace_io_uring_fail_link(req, link);
> +	while (link) {
> +		nxt = link->link;
> +		link->link = NULL;
>  
> +		trace_io_uring_fail_link(req, link);
>  		io_cqring_fill_event(link, -ECANCELED);
>  
>  		/*
> @@ -2053,8 +2035,8 @@ static void io_fail_links(struct io_kiocb *req)
>  			io_put_req_deferred(link, 2);
>  		else
>  			io_double_put_req(link);
> +		link = nxt;
>  	}
> -
>  	io_commit_cqring(ctx);
>  	spin_unlock_irqrestore(&ctx->completion_lock, flags);
>  
> @@ -2063,7 +2045,6 @@ static void io_fail_links(struct io_kiocb *req)
>  
>  static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
>  {
> -	req->flags &= ~REQ_F_LINK_HEAD;
>  	if (req->flags & REQ_F_LINK_TIMEOUT)
>  		io_kill_linked_timeout(req);
>  
> @@ -2073,15 +2054,19 @@ static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
>  	 * dependencies to the next request. In case of failure, fail the rest
>  	 * of the chain.
>  	 */
> -	if (likely(!(req->flags & REQ_F_FAIL_LINK)))
> -		return io_req_link_next(req);
> +	if (likely(!(req->flags & REQ_F_FAIL_LINK))) {
> +		struct io_kiocb *nxt = req->link;
> +
> +		req->link = NULL;
> +		return nxt;
> +	}
>  	io_fail_links(req);
>  	return NULL;
>  }
>  
> -static struct io_kiocb *io_req_find_next(struct io_kiocb *req)
> +static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
>  {
> -	if (likely(!(req->flags & REQ_F_LINK_HEAD)))
> +	if (likely(!(req->link) && !(req->flags & REQ_F_LINK_TIMEOUT)))
>  		return NULL;
>  	return __io_req_find_next(req);
>  }
> @@ -2176,7 +2161,7 @@ static void io_req_task_queue(struct io_kiocb *req)
>  	}
>  }
>  
> -static void io_queue_next(struct io_kiocb *req)
> +static inline void io_queue_next(struct io_kiocb *req)
>  {
>  	struct io_kiocb *nxt = io_req_find_next(req);
>  
> @@ -2233,8 +2218,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
>  		io_free_req(req);
>  		return;
>  	}
> -	if (req->flags & REQ_F_LINK_HEAD)
> -		io_queue_next(req);
> +	io_queue_next(req);
>  
>  	if (req->task != rb->task) {
>  		if (rb->task) {
> @@ -6003,11 +5987,10 @@ static u32 io_get_sequence(struct io_kiocb *req)
>  {
>  	struct io_kiocb *pos;
>  	struct io_ring_ctx *ctx = req->ctx;
> -	u32 total_submitted, nr_reqs = 1;
> +	u32 total_submitted, nr_reqs = 0;
>  
> -	if (req->flags & REQ_F_LINK_HEAD)
> -		list_for_each_entry(pos, &req->link_list, link_list)
> -			nr_reqs++;
> +	io_for_each_link(pos, req)
> +		nr_reqs++;
>  
>  	total_submitted = ctx->cached_sq_head - ctx->cached_sq_dropped;
>  	return total_submitted - nr_reqs;
> @@ -6362,7 +6345,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
>  	 * race with the completion of the linked work.
>  	 */
>  	if (prev && refcount_inc_not_zero(&prev->refs))
> -		list_del_init(&req->link_list);
> +		io_remove_next_linked(prev);
>  	else
>  		prev = NULL;
>  	spin_unlock_irqrestore(&ctx->completion_lock, flags);
> @@ -6380,8 +6363,8 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
>  static void __io_queue_linked_timeout(struct io_kiocb *req)
>  {
>  	/*
> -	 * If the list is now empty, then our linked request finished before
> -	 * we got a chance to setup the timer
> +	 * If the back reference is NULL, then our linked request finished
> +	 * before we got a chance to setup the timer
>  	 */
>  	if (req->timeout.head) {
>  		struct io_timeout_data *data = req->async_data;
> @@ -6406,16 +6389,10 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
>  
>  static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
>  {
> -	struct io_kiocb *nxt;
> -
> -	if (!(req->flags & REQ_F_LINK_HEAD))
> -		return NULL;
> -	if (req->flags & REQ_F_LINK_TIMEOUT)
> -		return NULL;
> +	struct io_kiocb *nxt = req->link;
>  
> -	nxt = list_first_entry_or_null(&req->link_list, struct io_kiocb,
> -					link_list);
> -	if (!nxt || nxt->opcode != IORING_OP_LINK_TIMEOUT)
> +	if (!nxt || (req->flags & REQ_F_LINK_TIMEOUT) ||
> +	    nxt->opcode != IORING_OP_LINK_TIMEOUT)
>  		return NULL;
>  
>  	nxt->timeout.head = req;
> @@ -6563,7 +6540,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  			return ret;
>  		}
>  		trace_io_uring_link(ctx, req, head);
> -		list_add_tail(&req->link_list, &head->link_list);
> +		link->last->link = req;
>  		link->last = req;
>  
>  		/* last request of a link, enqueue the link */
> @@ -6577,9 +6554,6 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  			ctx->drain_next = 0;
>  		}
>  		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
> -			req->flags |= REQ_F_LINK_HEAD;
> -			INIT_LIST_HEAD(&req->link_list);
> -
>  			ret = io_req_defer_prep(req, sqe);
>  			if (unlikely(ret))
>  				req->flags |= REQ_F_FAIL_LINK;
> @@ -6712,6 +6686,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  	req->file = NULL;
>  	req->ctx = ctx;
>  	req->flags = 0;
> +	req->link = NULL;
>  	/* one is dropped after submission, the other at completion */
>  	refcount_set(&req->refs, 2);
>  	req->task = current;
> @@ -8663,14 +8638,10 @@ static bool io_match_link(struct io_kiocb *preq, struct io_kiocb *req)
>  {
>  	struct io_kiocb *link;
>  
> -	if (!(preq->flags & REQ_F_LINK_HEAD))
> -		return false;
> -
> -	list_for_each_entry(link, &preq->link_list, link_list) {
> +	io_for_each_link(link, preq->link) {
>  		if (link == req)
>  			return true;
>  	}
> -
>  	return false;
>  }
>  
> 

-- 
Pavel Begunkov
