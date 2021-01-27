Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E483305162
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 05:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbhA0Ep1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 23:45:27 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:56499 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728942AbhA0Bxl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 20:53:41 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UN.xDoX_1611712346;
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UN.xDoX_1611712346)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Jan 2021 09:52:26 +0800
Subject: Re: [PATCH 5.11] io_uring: fix wqe->lock/completion_lock deadlock
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <9c4f7eb623ae774f3f17afbc1702749480ee19be.1611703952.git.asml.silence@gmail.com>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <9c4e03b0-b506-efb6-7ecf-cf290780de6d@linux.alibaba.com>
Date:   Wed, 27 Jan 2021 09:52:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <9c4f7eb623ae774f3f17afbc1702749480ee19be.1611703952.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 1/27/21 7:35 AM, Pavel Begunkov wrote:
> Joseph reports following deadlock:
> 
> CPU0:
> ...
> io_kill_linked_timeout  // &ctx->completion_lock
> io_commit_cqring
> __io_queue_deferred
> __io_queue_async_work
> io_wq_enqueue
> io_wqe_enqueue  // &wqe->lock
> 
> CPU1:
> ...
> __io_uring_files_cancel
> io_wq_cancel_cb
> io_wqe_cancel_pending_work  // &wqe->lock
> io_cancel_task_cb  // &ctx->completion_lock
> 
> Only __io_queue_deferred() calls queue_async_work() while holding
> ctx->completion_lock, enqueue drained requests via io_req_task_queue()
> instead.
> 
We should follow &wqe->lock > &ctx->completion_lock from now on, right?
I was thinking getting completion_lock first before:(

Moreover, there are so many locks and no suggested locking order in
comments, so that it is hard for us to participate in the work.

> Cc: stable@vger.kernel.org # 5.9+
> Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index bb0270eeb8cb..c218deaf73a9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1026,6 +1026,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
>  			     const struct iovec *fast_iov,
>  			     struct iov_iter *iter, bool force);
>  static void io_req_drop_files(struct io_kiocb *req);
> +static void io_req_task_queue(struct io_kiocb *req);
>  
>  static struct kmem_cache *req_cachep;
>  
> @@ -1634,18 +1635,11 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
>  	do {
>  		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
>  						struct io_defer_entry, list);
> -		struct io_kiocb *link;
>  
>  		if (req_need_defer(de->req, de->seq))
>  			break;
>  		list_del_init(&de->list);
> -		/* punt-init is done before queueing for defer */
> -		link = __io_queue_async_work(de->req);
> -		if (link) {
> -			__io_queue_linked_timeout(link);
> -			/* drop submission reference */
> -			io_put_req_deferred(link, 1);
> -		}
> +		io_req_task_queue(de->req);
>  		kfree(de);
>  	} while (!list_empty(&ctx->defer_list));
>  }
> 
