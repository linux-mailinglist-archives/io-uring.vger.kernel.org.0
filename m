Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA871408681
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 10:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237849AbhIMIbw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 04:31:52 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:56038 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234575AbhIMIbv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 04:31:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UoBP7.._1631521833;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UoBP7.._1631521833)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 13 Sep 2021 16:30:34 +0800
Subject: Re: [PATCH 2/4] io-wq: code clean of io_wqe_create_worker()
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210911194052.28063-1-haoxu@linux.alibaba.com>
 <20210911194052.28063-3-haoxu@linux.alibaba.com>
Message-ID: <12edf0f5-2b68-f8ec-6689-79e8f70be4b3@linux.alibaba.com>
Date:   Mon, 13 Sep 2021 16:30:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210911194052.28063-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/12 上午3:40, Hao Xu 写道:
> Remove do_create to save a local variable.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io-wq.c | 19 +++++++------------
>   1 file changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 1b102494e970..0e1288a549eb 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -246,8 +246,6 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe,
>    */
>   static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
>   {
> -	bool do_create = false;
> -
>   	/*
>   	 * Most likely an attempt to queue unbounded work on an io_wq that
>   	 * wasn't setup with any unbounded workers.
> @@ -256,18 +254,15 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
>   		pr_warn_once("io-wq is not configured for unbound workers");
>   
>   	raw_spin_lock(&wqe->lock);
> -	if (acct->nr_workers < acct->max_workers) {
> -		acct->nr_workers++;
> -		do_create = true;
> +	if (acct->nr_workers == acct->max_workers) {
> +		raw_spin_unlock(&wqe->lock);
> +		return false;
Hi Jens, would you like to tweak it to return true or would like me to
send a fix.
>   	}
> +	acct->nr_workers++;
>   	raw_spin_unlock(&wqe->lock);
> -	if (do_create) {
> -		atomic_inc(&acct->nr_running);
> -		atomic_inc(&wqe->wq->worker_refs);
> -		return create_io_worker(wqe->wq, wqe, acct->index);
> -	}
> -
> -	return false;
> +	atomic_inc(&acct->nr_running);
> +	atomic_inc(&wqe->wq->worker_refs);
> +	return create_io_worker(wqe->wq, wqe, acct->index);
>   }
>   
>   static void io_wqe_inc_running(struct io_worker *worker)
> 

