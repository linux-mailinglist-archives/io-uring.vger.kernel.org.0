Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777B541C4C6
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 14:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343531AbhI2Mco (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 08:32:44 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:35839 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343628AbhI2Mcn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 08:32:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uq1oePc_1632918660;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uq1oePc_1632918660)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 29 Sep 2021 20:31:01 +0800
Subject: Re: [PATCH 3/8] io_uring: add a limited tw list for irq completion
 work
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210927105123.169301-1-haoxu@linux.alibaba.com>
 <20210927105123.169301-4-haoxu@linux.alibaba.com>
Message-ID: <6c6f1f1c-e1f5-7144-f3d1-c368ecbfc531@linux.alibaba.com>
Date:   Wed, 29 Sep 2021 20:31:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210927105123.169301-4-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/27 下午6:51, Hao Xu 写道:
> Now we have a lot of task_work users, some are just to complete a req
> and generate a cqe. Let's put the work to a new tw list which has a
> higher priority, so that it can be handled quickly and thus to reduce
> avg req latency. an explanatory case:
> 
> origin timeline:
>      submit_sqe-->irq-->add completion task_work
>      -->run heavy work0~n-->run completion task_work
> now timeline:
>      submit_sqe-->irq-->add completion task_work
>      -->run completion task_work-->run heavy work0~n
> 
> One thing to watch out is sometimes irq completion TWs comes
> overwhelmingly, which makes the new tw list grows fast, and TWs in
> the old list are starved. So we have to limit the length of the new
> tw list. A practical value is 1/3:
>      len of new tw list < 1/3 * (len of new + old tw list)
> 
> In this way, the new tw list has a limited length and normal task get
> there chance to run.
> 
> Tested this patch(and the following ones) by manually replace
> __io_queue_sqe() to io_req_task_complete() to construct 'heavy' task
> works. Then test with fio:
> 
> ioengine=io_uring
> thread=1
> bs=4k
> direct=1
> rw=randread
> time_based=1
> runtime=600
> randrepeat=0
> group_reporting=1
> filename=/dev/nvme0n1
> 
> Tried various iodepth.
> The peak IOPS for this patch is 314K, while the old one is 249K.
> For avg latency, difference shows when iodepth grow:
> depth and avg latency(usec):
> 	depth      new          old
> 	 1        22.80        23.77
> 	 2        23.48        24.54
> 	 4        24.26        25.57
> 	 8        29.21        32.89
> 	 16       53.61        63.50
> 	 32       106.29       131.34
> 	 64       217.21       256.33
> 	 128      421.59       513.87
> 	 256      815.15       1050.99
> 
> 95%, 99% etc more data in cover letter.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io_uring.c | 46 +++++++++++++++++++++++++++++++++-------------
>   1 file changed, 33 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8317c360f7a4..582ef7f55a35 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -461,6 +461,7 @@ struct io_ring_ctx {
>   	};
>   };
>   
> +#define MAX_EMERGENCY_TW_RATIO	3
>   struct io_uring_task {
>   	/* submission side */
>   	int			cached_refs;
> @@ -475,6 +476,9 @@ struct io_uring_task {
>   	spinlock_t		task_lock;
>   	struct io_wq_work_list	task_list;
>   	struct callback_head	task_work;
> +	struct io_wq_work_list	prior_task_list;
> +	unsigned int		nr;
> +	unsigned int		prior_nr;
>   	bool			task_running;
>   };
>   
> @@ -2131,13 +2135,18 @@ static void tctx_task_work(struct callback_head *cb)
>   
>   	while (1) {
>   		struct io_wq_work_node *node;
> +		struct io_wq_work_list *merged_list;
>   
> -		if (!tctx->task_list.first && locked)
> +		if (!tctx->prior_task_list.first &&
> +		    !tctx->task_list.first && locked)
>   			io_submit_flush_completions(ctx);
>   
>   		spin_lock_irq(&tctx->task_lock);
> -		node = tctx->task_list.first;
> +		merged_list = wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
> +		node = merged_list->first;
>   		INIT_WQ_LIST(&tctx->task_list);
> +		INIT_WQ_LIST(&tctx->prior_task_list);
> +		tctx->nr = tctx->prior_nr = 0;
>   		if (!node)
>   			tctx->task_running = false;
>   		spin_unlock_irq(&tctx->task_lock);
> @@ -2166,19 +2175,26 @@ static void tctx_task_work(struct callback_head *cb)
>   	ctx_flush_and_put(ctx, &locked);
>   }
>   
> -static void io_req_task_work_add(struct io_kiocb *req)
> +static void io_req_task_work_add(struct io_kiocb *req, bool emergency)
>   {
>   	struct task_struct *tsk = req->task;
>   	struct io_uring_task *tctx = tsk->io_uring;
>   	enum task_work_notify_mode notify;
>   	struct io_wq_work_node *node;
> +	struct io_wq_work_list *merged_list;
>   	unsigned long flags;
>   	bool running;
>   
>   	WARN_ON_ONCE(!tctx);
>   
>   	spin_lock_irqsave(&tctx->task_lock, flags);
> -	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
> +	if (emergency && tctx->prior_nr * MAX_EMERGENCY_TW_RATIO < tctx->nr) {
                                       this definitely should be <= to
avoid inverted completion TWs.. will update it in next version.
> +		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
> +		tctx->prior_nr++;
> +	} else {
> +		wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
> +	}
> +	tctx->nr++;
>   	running = tctx->task_running;
>   	if (!running)
>   		tctx->task_running = true;
> @@ -2202,9 +2218,12 @@ static void io_req_task_work_add(struct io_kiocb *req)
>   	}
>   
>   	spin_lock_irqsave(&tctx->task_lock, flags);
> +	tctx->nr = tctx->prior_nr = 0;
>   	tctx->task_running = false;
> -	node = tctx->task_list.first;
> +	merged_list = wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
> +	node = merged_list->first;
>   	INIT_WQ_LIST(&tctx->task_list);
> +	INIT_WQ_LIST(&tctx->prior_task_list);
>   	spin_unlock_irqrestore(&tctx->task_lock, flags);
>   
>   	while (node) {
> @@ -2241,19 +2260,19 @@ static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
>   {
>   	req->result = ret;
>   	req->io_task_work.func = io_req_task_cancel;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, true);
>   }
>   
>   static void io_req_task_queue(struct io_kiocb *req)
>   {
>   	req->io_task_work.func = io_req_task_submit;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>   }
>   
>   static void io_req_task_queue_reissue(struct io_kiocb *req)
>   {
>   	req->io_task_work.func = io_queue_async_work;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>   }
>   
>   static inline void io_queue_next(struct io_kiocb *req)
> @@ -2373,7 +2392,7 @@ static inline void io_put_req_deferred(struct io_kiocb *req)
>   {
>   	if (req_ref_put_and_test(req)) {
>   		req->io_task_work.func = io_free_req_work;
> -		io_req_task_work_add(req);
> +		io_req_task_work_add(req, false);
>   	}
>   }
>   
> @@ -2693,7 +2712,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
>   		return;
>   	req->result = res;
>   	req->io_task_work.func = io_req_task_complete;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, true);
>   }
>   
>   static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
> @@ -5256,7 +5275,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
>   	 * of executing it. We can't safely execute it anyway, as we may not
>   	 * have the needed state needed for it anyway.
>   	 */
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>   	return 1;
>   }
>   
> @@ -5934,7 +5953,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
>   	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
>   
>   	req->io_task_work.func = io_req_task_timeout;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>   	return HRTIMER_NORESTART;
>   }
>   
> @@ -6916,7 +6935,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
>   	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
>   
>   	req->io_task_work.func = io_req_task_link_timeout;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>   	return HRTIMER_NORESTART;
>   }
>   
> @@ -8543,6 +8562,7 @@ static int io_uring_alloc_task_context(struct task_struct *task,
>   	task->io_uring = tctx;
>   	spin_lock_init(&tctx->task_lock);
>   	INIT_WQ_LIST(&tctx->task_list);
> +	INIT_WQ_LIST(&tctx->prior_task_list);
>   	init_task_work(&tctx->task_work, tctx_task_work);
>   	return 0;
>   }
> 

