Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB5B43475C
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 10:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhJTIyc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 04:54:32 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:55849 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229677AbhJTIy2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 04:54:28 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Ut1O3RY_1634719932;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Ut1O3RY_1634719932)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 20 Oct 2021 16:52:12 +0800
Subject: Re: [PATCH 5.15] io_uring: apply max_workers limit to all future
 users
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <51d0bae97180e08ab722c0d5c93e7439cfb6f697.1634683237.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <67688dc3-e28a-5457-0984-90df0f2bcfc5@linux.alibaba.com>
Date:   Wed, 20 Oct 2021 16:52:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <51d0bae97180e08ab722c0d5c93e7439cfb6f697.1634683237.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/20 上午6:43, Pavel Begunkov 写道:
> Currently, IORING_REGISTER_IOWQ_MAX_WORKERS applies only to the task
> that issued it, it's unexpected for users. If one task creates a ring,
> limits workers and then passes it to another task the limit won't be
> applied to the other task.
> 
> Another pitfall is that a task should either create a ring or submit at
> least one request for IORING_REGISTER_IOWQ_MAX_WORKERS to work at all,
> furher complicating the picture.
> 
> Change the API, save the limits and apply to all future users. Note, it
> should be done first before giving away the ring or submitting new
> requests otherwise the result is not guaranteed.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> Change the API as it was introduced in this cycles. Tested by hand
> observing the number of workers created, but there are no regression
> tests.
> 
>   fs/io_uring.c | 29 +++++++++++++++++++++++------
>   1 file changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e68d27829bb2..e8b71f14ac8b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -456,6 +456,8 @@ struct io_ring_ctx {
>   		struct work_struct		exit_work;
>   		struct list_head		tctx_list;
>   		struct completion		ref_comp;
> +		u32				iowq_limits[2];
> +		bool				iowq_limits_set;
>   	};
>   };
>   
> @@ -9638,7 +9640,16 @@ static int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
>   		ret = io_uring_alloc_task_context(current, ctx);
>   		if (unlikely(ret))
>   			return ret;
> +
>   		tctx = current->io_uring;
> +		if (ctx->iowq_limits_set) {
> +			unsigned int limits[2] = { ctx->iowq_limits[0],
> +						   ctx->iowq_limits[1], };
> +
> +			ret = io_wq_max_workers(tctx->io_wq, limits);
> +			if (ret)
> +				return ret;
> +		}
>   	}
>   	if (!xa_load(&tctx->xa, (unsigned long)ctx)) {
>   		node = kmalloc(sizeof(*node), GFP_KERNEL);
> @@ -10674,13 +10685,19 @@ static int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
>   		tctx = current->io_uring;
>   	}
>   
> -	ret = -EINVAL;
> -	if (!tctx || !tctx->io_wq)
> -		goto err;
> +	BUILD_BUG_ON(sizeof(new_count) != sizeof(ctx->iowq_limits));
>   
> -	ret = io_wq_max_workers(tctx->io_wq, new_count);
> -	if (ret)
> -		goto err;
> +	memcpy(ctx->iowq_limits, new_count, sizeof(new_count));
> +	ctx->iowq_limits_set = true;
> +
> +	ret = -EINVAL;
> +	if (tctx && tctx->io_wq) {
> +		ret = io_wq_max_workers(tctx->io_wq, new_count);
Hi Pavel,
The ctx->iowq_limits_set limits the future ctx users, but not the past
ones, how about update the numbers for all the current ctx users here?
I know the number of workers that a current user uses may already
exceeds the newest limitation, but at least this will make it not to
grow any more, and may decrement it to the limitation some time later.

Regards,
Hao
> +		if (ret)
> +			goto err;
> +	} else {
> +		memset(new_count, 0, sizeof(new_count));
> +	}
>   
>   	if (sqd) {
>   		mutex_unlock(&sqd->lock);
> 

