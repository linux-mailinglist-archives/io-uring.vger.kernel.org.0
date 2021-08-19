Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304F53F1F11
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 19:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhHSR1D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 13:27:03 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:43041 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233365AbhHSR1B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 13:27:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0Uk6gmj1_1629393982;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uk6gmj1_1629393982)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 20 Aug 2021 01:26:23 +0800
Subject: Re: [PATCH] io_uring: remove PF_EXITING checking in io_poll_rewait()
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <0d53b4d3-b388-bd82-05a6-d4815aafff49@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <71755898-060a-6975-88b8-164fc3fff366@linux.alibaba.com>
Date:   Fri, 20 Aug 2021 01:26:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0d53b4d3-b388-bd82-05a6-d4815aafff49@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/19 下午11:48, Jens Axboe 写道:
> We have two checks of task->flags & PF_EXITING left:
> 
> 1) In io_req_task_submit(), which is called in task_work and hence always
>     in the context of the original task. That means that
>     req->task == current, and hence checking ->flags is totally fine.
> 
> 2) In io_poll_rewait(), where we need to stop re-arming poll to prevent
>     it interfering with cancelation. Here, req->task is not necessarily
>     current, and hence the check is racy. Use the ctx refs state instead
>     to check if we need to cancel this request or not.
Hi Jens,
I saw cases that io_req_task_submit() and io_poll_rewait() in one
function, why one is safe and the other one not? btw, it seems both two
executes in task_work context..and task_work_add() may fail and then
work goes to system_wq, is that case safe?
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 30edc329d803..ffce959c2370 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2114,6 +2114,7 @@ static void io_req_task_submit(struct io_kiocb *req)
>   
>   	/* ctx stays valid until unlock, even if we drop all ours ctx->refs */
>   	mutex_lock(&ctx->uring_lock);
> +	/* req->task == current here, checking PF_EXITING is safe */
>   	if (likely(!(req->task->flags & PF_EXITING)))
>   		__io_queue_sqe(req);
>   	else
> @@ -4895,7 +4896,11 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
>   
> -	if (unlikely(req->task->flags & PF_EXITING))
> +	/*
> +	 * Pairs with spin_unlock() in percpu_ref_kill()
> +	 */
> +	smp_rmb();
> +	if (unlikely(percpu_ref_is_dying(&ctx->refs)))
>   		WRITE_ONCE(poll->canceled, true);
>   
>   	if (!req->result && !READ_ONCE(poll->canceled)) {
> 

