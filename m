Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E63341376
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 04:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhCSDbv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 23:31:51 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:58480 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229948AbhCSDb3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Mar 2021 23:31:29 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0USVAfjt_1616124686;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0USVAfjt_1616124686)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 19 Mar 2021 11:31:27 +0800
Subject: Re: [PATCH 9/9] io_uring: allow events update of running poll
 requests
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20210317162943.173837-1-axboe@kernel.dk>
 <20210317162943.173837-10-axboe@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <5c62f6bf-057c-e4b1-5cbf-102e73f8bfcc@linux.alibaba.com>
Date:   Fri, 19 Mar 2021 11:31:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210317162943.173837-10-axboe@kernel.dk>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ÔÚ 2021/3/18 ÉÏÎç12:29, Jens Axboe Ð´µÀ:
> This adds a new POLL_ADD flag, IORING_POLL_UPDATE. As with the other
> POLL_ADD flag, this one is masked into sqe->len. If set, the POLL_ADD
> will have the following behavior:
> 
> - sqe->addr must contain the the user_data of the poll request that
>    needs to be modified. This field is otherwise invalid for a POLL_ADD
>    command.
> 
> - sqe->poll_events must contain the new mask for the existing poll
>    request. There are no checks for whether these are identical or not,
>    if a matching poll request is found, then it is re-armed with the new
>    mask.
> 
> A POLL_ADD with the IORING_POLL_UPDATE flag set may complete with any
> of the following results:
> 
> 1) 0, which means that we successfully found the existing poll request
>     specified, and performed the re-arm procedure. Any error from that
>     re-arm will be exposed as a completion event for that original poll
>     request, not for the update request.
> 2) -ENOENT, if no existing poll request was found with the given
>     user_data.
> 3) -EALREADY, if the existing poll request was already in the process of
>     being removed/canceled/completing.
> 4) -EACCES, if an attempt was made to modify an internal poll request
>     (eg not one originally issued ass IORING_OP_POLL_ADD).
> 
> The usual -EINVAL cases apply as well, if any invalid fields are set
> in the sqe for this command type.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/io_uring.c                 | 73 ++++++++++++++++++++++++++++++++---
>   include/uapi/linux/io_uring.h |  4 ++
>   2 files changed, 72 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8ed363bd95aa..79a40364e041 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -467,10 +467,14 @@ struct io_ring_ctx {
>    */
>   struct io_poll_iocb {
>   	struct file			*file;
> -	struct wait_queue_head		*head;
> +	union {
> +		struct wait_queue_head	*head;
> +		u64			addr;
> +	};
>   	__poll_t			events;
>   	bool				done;
>   	bool				canceled;
> +	bool				update;
>   	struct wait_queue_entry		wait;
>   };
>   
> @@ -5004,6 +5008,7 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
>   	poll->head = NULL;
>   	poll->done = false;
>   	poll->canceled = false;
> +	poll->update = false;
>   	poll->events = events;
>   	INIT_LIST_HEAD(&poll->wait.entry);
>   	init_waitqueue_func_entry(&poll->wait, wake_func);
> @@ -5382,24 +5387,32 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>   
>   	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>   		return -EINVAL;
> -	if (sqe->addr || sqe->ioprio || sqe->off || sqe->buf_index)
> +	if (sqe->ioprio || sqe->off || sqe->buf_index)
>   		return -EINVAL;
>   	flags = READ_ONCE(sqe->len);
> -	if (flags & ~IORING_POLL_ADD_MULTI)
> +	if (flags & ~(IORING_POLL_ADD_MULTI | IORING_POLL_UPDATE))
>   		return -EINVAL;
>   
>   	events = READ_ONCE(sqe->poll32_events);
>   #ifdef __BIG_ENDIAN
>   	events = swahw32(events);
>   #endif
> -	if (!flags)
> +	if (!(flags & IORING_POLL_ADD_MULTI))
>   		events |= EPOLLONESHOT;
> +	if (flags & IORING_POLL_UPDATE) {
> +		poll->update = true;
> +		poll->addr = READ_ONCE(sqe->addr);
> +	} else {
> +		if (sqe->addr)
> +			return -EINVAL;
> +		poll->update = false;
Hi Jens, is `poll->update = false` redundant?
> +	}
>   	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP |
>   		       (events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
>   	return 0;
>   }
>   
> -static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
> +static int __io_poll_add(struct io_kiocb *req)
>   {
>   	struct io_poll_iocb *poll = &req->poll;
>   	struct io_ring_ctx *ctx = req->ctx;
> @@ -5425,6 +5438,56 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
>   	return ipt.error;
>   }
>   
> +static int io_poll_update(struct io_kiocb *req)
> +{
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct io_kiocb *preq;
> +	int ret;
> +
> +	spin_lock_irq(&ctx->completion_lock);
> +	preq = io_poll_find(ctx, req->poll.addr);
> +	if (!preq) {
> +		ret = -ENOENT;
> +		goto err;
> +	} else if (preq->opcode != IORING_OP_POLL_ADD) {
> +		/* don't allow internal poll updates */
> +		ret = -EACCES;
> +		goto err;
> +	}
> +	if (!__io_poll_remove_one(preq, &preq->poll)) {
> +		/* in process of completing/removal */
> +		ret = -EALREADY;
> +		goto err;
> +	}
> +	/* we now have a detached poll request. reissue. */
> +	ret = 0;
> +err:
> +	spin_unlock_irq(&ctx->completion_lock);
> +	if (ret < 0) {
> +		req_set_fail_links(req);
> +finish:
> +		io_req_complete(req, ret);
> +		return 0;
> +	}
> +	/* only mask one event flags, keep behavior flags */
> +	preq->poll.events &= ~0xffff;
> +	preq->poll.events |= req->poll.events & 0xffff;
> +	ret = __io_poll_add(preq);
> +	if (ret < 0) {
> +		req_set_fail_links(preq);
> +		io_req_complete(preq, ret);
> +	}
> +	ret = 0;
> +	goto finish;
> +}
> +
> +static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	if (!req->poll.update)
> +		return __io_poll_add(req);
> +	return io_poll_update(req);
> +}
> +
>   static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
>   {
>   	struct io_timeout_data *data = container_of(timer,
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 76c967621601..44fe7f80c851 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -166,8 +166,12 @@ enum {
>    * IORING_POLL_ADD_MULTI	Multishot poll. Sets IORING_CQE_F_MORE if
>    *				the poll handler will continue to report
>    *				CQEs on behalf of the same SQE.
> + *
> + * IORING_POLL_UPDATE		Update existing poll request, matching
> + *				sqe->addr as the old user_data field.
>    */
>   #define IORING_POLL_ADD_MULTI	(1U << 0)
> +#define IORING_POLL_UPDATE	(1U << 1)
>   
>   /*
>    * IO completion data structure (Completion Queue Entry)
> 

