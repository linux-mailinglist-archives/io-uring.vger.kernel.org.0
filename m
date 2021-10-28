Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEFC43DB14
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 08:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhJ1G3b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 02:29:31 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:45347 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhJ1G3a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 02:29:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Utz8C2H_1635402421;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Utz8C2H_1635402421)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Oct 2021 14:27:02 +0800
Subject: Re: [PATCH 6/8] io_uring: add nr_ctx to record the number of ctx in a
 task
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211027140216.20008-1-haoxu@linux.alibaba.com>
 <20211027140216.20008-7-haoxu@linux.alibaba.com>
Message-ID: <1b168dde-6c62-cbac-158b-a9b824222639@linux.alibaba.com>
Date:   Thu, 28 Oct 2021 14:27:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211027140216.20008-7-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/27 下午10:02, Hao Xu 写道:
> This is used in the next patch for task_work batch optimization.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
haven't done the sqpoll part. nr_ctx works for
non-sqpoll mode for now.
> ---
>   fs/io_uring.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index db5d9189df3a..7c6d90d693b8 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -470,6 +470,7 @@ struct io_uring_task {
>   	struct io_wq_work_list	prior_task_list;
>   	struct callback_head	task_work;
>   	bool			task_running;
> +	unsigned int		nr_ctx;
>   };
>   
>   /*
> @@ -9655,6 +9656,9 @@ static int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
>   		mutex_lock(&ctx->uring_lock);
>   		list_add(&node->ctx_node, &ctx->tctx_list);
>   		mutex_unlock(&ctx->uring_lock);
> +		spin_lock_irq(&tctx->task_lock);
> +		tctx->nr_ctx++;
> +		spin_unlock_irq(&tctx->task_lock);
>   	}
>   	tctx->last = ctx;
>   	return 0;
> @@ -9692,6 +9696,9 @@ static __cold void io_uring_del_tctx_node(unsigned long index)
>   	mutex_lock(&node->ctx->uring_lock);
>   	list_del(&node->ctx_node);
>   	mutex_unlock(&node->ctx->uring_lock);
> +	spin_lock_irq(&tctx->task_lock);
> +	tctx->nr_ctx--;
> +	spin_unlock_irq(&tctx->task_lock);
>   
>   	if (tctx->last == node->ctx)
>   		tctx->last = NULL;
> 

