Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3EF63FAFF4
	for <lists+io-uring@lfdr.de>; Mon, 30 Aug 2021 05:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhH3DIb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Aug 2021 23:08:31 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:39858 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235637AbhH3DHK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Aug 2021 23:07:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0UmVJp4i_1630292775;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UmVJp4i_1630292775)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 30 Aug 2021 11:06:16 +0800
Subject: Re: [PATCH] io-wq: check max_worker limits if a worker transitions
 bound state
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <8b32196b-0555-8179-1fa0-496b4e68ae4c@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <10bab869-3875-4510-e38a-03193f0b6dfa@linux.alibaba.com>
Date:   Mon, 30 Aug 2021 11:06:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <8b32196b-0555-8179-1fa0-496b4e68ae4c@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/30 上午6:19, Jens Axboe 写道:
> For the two places where new workers are created, we diligently check if
> we are allowed to create a new worker. If we're currently at the limit
> of how many workers of a given type we can have, then we don't create
> any new ones.
> 
> If you have a mixed workload with various types of bound and unbounded
> work, then it can happen that a worker finishes one type of work and
> is then transitioned to the other type. For this case, we don't check
> if we are actually allowed to do so. This can cause io-wq to temporarily
> exceed the allowed number of workers for a given type.
> 
> When retrieving work, check that the types match. If they don't, check
> if we are allowed to transition to the other type. If not, then don't
> handle the new work.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Johannes Lundberg <johalun0@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 4b5fc621ab39..dced22288983 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -424,7 +424,31 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
>   	spin_unlock(&wq->hash->wait.lock);
>   }
>   
> -static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
> +/*
> + * We can always run the work if the worker is currently the same type as
> + * the work (eg both are bound, or both are unbound). If they are not the
> + * same, only allow it if incrementing the worker count would be allowed.
> + */
> +static bool io_worker_can_run_work(struct io_worker *worker,
> +				   struct io_wq_work *work)
> +{
> +	struct io_wqe_acct *acct;
> +
> +	if ((worker->flags & IO_WORKER_F_BOUND) &&
> +	    !(work->flags & IO_WQ_WORK_UNBOUND))
> +		return true;
> +	else if (!(worker->flags & IO_WORKER_F_BOUND) &&
> +		 (work->flags & IO_WQ_WORK_UNBOUND))
> +		return true;

How about:
bool a = !(worker->flags & IO_WORKER_F_BOUND);
bool b = !(work->flags & IO_WQ_WORK_UNBOUND);

if (a != b)
     return true;
> +
> +	/* not the same type, check if we'd go over the limit */
> +	acct = io_work_get_acct(worker->wqe, work);
> +	return acct->nr_workers < acct->max_workers;
> +}
> +


