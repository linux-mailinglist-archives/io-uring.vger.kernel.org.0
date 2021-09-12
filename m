Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19EE407E05
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 17:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbhILPhT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 11:37:19 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:59804 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhILPhS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 11:37:18 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Uo4H.DJ_1631460961;
Received: from 30.30.116.57(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uo4H.DJ_1631460961)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 12 Sep 2021 23:36:02 +0800
Subject: Re: [PATCH -next] io-wq: Remove duplicate code in
 io_workqueue_create()
To:     Bixuan Cui <cuibixuan@huawei.com>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210911085847.34849-1-cuibixuan@huawei.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <49d9bb13-a7b3-48b5-20ef-d3b72052f92b@linux.alibaba.com>
Date:   Sun, 12 Sep 2021 23:36:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210911085847.34849-1-cuibixuan@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/11 下午4:58, Bixuan Cui 写道:
> While task_work_add() in io_workqueue_create() is true,
> then duplicate code is executed:
> 
>    -> clear_bit_unlock(0, &worker->create_state);
>    -> io_worker_release(worker);
>    -> atomic_dec(&acct->nr_running);
>    -> io_worker_ref_put(wq);
>    -> return false;
> 
>    -> clear_bit_unlock(0, &worker->create_state); // back to io_workqueue_create()
>    -> io_worker_release(worker);
>    -> kfree(worker);
> 
> The io_worker_release() and clear_bit_unlock() are executed twice.
> 
> Fixes: 3146cba99aa2 ("io-wq: make worker creation resilient against signals")
> Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
> ---
>   fs/io-wq.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 6c55362c1f99..95d0eaed7c00 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -329,8 +329,10 @@ static bool io_queue_worker_create(struct io_worker *worker,
>   
>   	init_task_work(&worker->create_work, func);
>   	worker->create_index = acct->index;
> -	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL))
> +	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL)) {
> +		clear_bit_unlock(0, &worker->create_state);
>   		return true;
> +	}
>   	clear_bit_unlock(0, &worker->create_state);
>   fail_release:
>   	io_worker_release(worker);
> @@ -723,11 +725,8 @@ static void io_workqueue_create(struct work_struct *work)
>   	struct io_worker *worker = container_of(work, struct io_worker, work);
>   	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
>   
> -	if (!io_queue_worker_create(worker, acct, create_worker_cont)) {
> -		clear_bit_unlock(0, &worker->create_state);
> -		io_worker_release(worker);
> +	if (!io_queue_worker_create(worker, acct, create_worker_cont))
>   		kfree(worker);
> -	}
>   }
>   
>   static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
> 
AFAIK, this looks reasonable for me.

