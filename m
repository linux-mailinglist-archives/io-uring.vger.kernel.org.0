Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DAA3F0054
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 11:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhHRJXQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 05:23:16 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:37980 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232634AbhHRJXN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 05:23:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Ujhx.oq_1629278557;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Ujhx.oq_1629278557)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Aug 2021 17:22:38 +0800
Subject: Re: [PATCH for-5.15] io-wq: move nr_running and worker_refs out of
 wqe->lock protection
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210810125554.99229-1-haoxu@linux.alibaba.com>
Message-ID: <f2db1235-1939-f8de-40f3-a3433bf9f805@linux.alibaba.com>
Date:   Wed, 18 Aug 2021 17:22:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810125554.99229-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/10 下午8:55, Hao Xu 写道:
ping
> We don't need to protect nr_running and worker_refs by wqe->lock, so
> narrow the range of raw_spin_lock_irq - raw_spin_unlock_irq
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io-wq.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 4ce83bb48021..8da9bb103916 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -256,16 +256,17 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
>   
>   		raw_spin_lock_irq(&wqe->lock);
>   		if (acct->nr_workers < acct->max_workers) {
> -			atomic_inc(&acct->nr_running);
> -			atomic_inc(&wqe->wq->worker_refs);
>   			if (!acct->nr_workers)
>   				first = true;
>   			acct->nr_workers++;
>   			do_create = true;
>   		}
>   		raw_spin_unlock_irq(&wqe->lock);
> -		if (do_create)
> +		if (do_create) {
> +			atomic_inc(&acct->nr_running);
> +			atomic_inc(&wqe->wq->worker_refs);
>   			create_io_worker(wqe->wq, wqe, acct->index, first);
> +		}
>   	}
>   }
>   
> 

