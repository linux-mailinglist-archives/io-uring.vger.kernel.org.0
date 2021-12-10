Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AFA4708FC
	for <lists+io-uring@lfdr.de>; Fri, 10 Dec 2021 19:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245468AbhLJSmH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Dec 2021 13:42:07 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:47132 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242061AbhLJSmG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Dec 2021 13:42:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0V-BPx1O_1639161508;
Received: from 192.168.31.207(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V-BPx1O_1639161508)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 11 Dec 2021 02:38:29 +0800
Subject: Re: [PATCH] io-wq: check for wq exit after adding new worker
 task_work
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <6ec527b1-3d50-d484-912d-eff86849241d@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <8b8c624d-788b-86dd-4fd2-a72b7117ec2b@linux.alibaba.com>
Date:   Sat, 11 Dec 2021 02:38:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6ec527b1-3d50-d484-912d-eff86849241d@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


在 2021/12/10 下午11:35, Jens Axboe 写道:
> We check IO_WQ_BIT_EXIT before attempting to create a new worker, and
> wq exit cancels pending work if we have any. But it's possible to have
> a race between the two, where creation checks exit finding it not set,
> but we're in the process of exiting. The exit side will cancel pending
> creation task_work, but there's a gap where we add task_work after we've
> canceled existing creations at exit time.
>
> Fix this by checking the EXIT bit post adding the creation task_work.
> If it's set, run the same cancelation that exit does.
>
> Reported-by: syzbot+b60c982cb0efc5e05a47@syzkaller.appspotmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---

Looks good.

Reviewed-by: Hao Xu <haoxu@linux.alibaba.com>

>
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 35da9d90df76..8d2bb818a3bb 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -142,6 +142,7 @@ static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
>   					struct io_wqe_acct *acct,
>   					struct io_cb_cancel_data *match);
>   static void create_worker_cb(struct callback_head *cb);
> +static void io_wq_cancel_tw_create(struct io_wq *wq);
>   
>   static bool io_worker_get(struct io_worker *worker)
>   {
> @@ -357,10 +358,22 @@ static bool io_queue_worker_create(struct io_worker *worker,
>   	    test_and_set_bit_lock(0, &worker->create_state))
>   		goto fail_release;
>   
> +	atomic_inc(&wq->worker_refs);
>   	init_task_work(&worker->create_work, func);
>   	worker->create_index = acct->index;
> -	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL))
> +	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL)) {
> +		/*
> +		 * EXIT may have been set after checking it above, check after
> +		 * adding the task_work and remove any creation item if it is
> +		 * now set. wq exit does that too, but we can have added this
> +		 * work item after we canceled in io_wq_exit_workers().
> +		 */
> +		if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
> +			io_wq_cancel_tw_create(wq);
> +		io_worker_ref_put(wq);
>   		return true;
> +	}
> +	io_worker_ref_put(wq);
>   	clear_bit_unlock(0, &worker->create_state);
>   fail_release:
>   	io_worker_release(worker);
> @@ -1196,13 +1209,9 @@ void io_wq_exit_start(struct io_wq *wq)
>   	set_bit(IO_WQ_BIT_EXIT, &wq->state);
>   }
>   
> -static void io_wq_exit_workers(struct io_wq *wq)
> +static void io_wq_cancel_tw_create(struct io_wq *wq)
>   {
>   	struct callback_head *cb;
> -	int node;
> -
> -	if (!wq->task)
> -		return;
>   
>   	while ((cb = task_work_cancel_match(wq->task, io_task_work_match, wq)) != NULL) {
>   		struct io_worker *worker;
> @@ -1210,6 +1219,16 @@ static void io_wq_exit_workers(struct io_wq *wq)
>   		worker = container_of(cb, struct io_worker, create_work);
>   		io_worker_cancel_cb(worker);
>   	}
> +}
> +
> +static void io_wq_exit_workers(struct io_wq *wq)
> +{
> +	int node;
> +
> +	if (!wq->task)
> +		return;
> +
> +	io_wq_cancel_tw_create(wq);
>   
>   	rcu_read_lock();
>   	for_each_node(node) {
>
