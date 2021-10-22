Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF6243708D
	for <lists+io-uring@lfdr.de>; Fri, 22 Oct 2021 05:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhJVDqD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Oct 2021 23:46:03 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:49476 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232859AbhJVDqC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Oct 2021 23:46:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UtDN3YM_1634874223;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UtDN3YM_1634874223)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Oct 2021 11:43:44 +0800
Subject: Re: [PATCH v3] io_uring: implement async hybrid mode for pollable
 requests
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211018133445.103438-1-haoxu@linux.alibaba.com>
Message-ID: <22cc3825-7378-3e30-b3da-36fc0512c2be@linux.alibaba.com>
Date:   Fri, 22 Oct 2021 11:43:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211018133445.103438-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ping this one..
在 2021/10/18 下午9:34, Hao Xu 写道:
> The current logic of requests with IOSQE_ASYNC is first queueing it to
> io-worker, then execute it in a synchronous way. For unbound works like
> pollable requests(e.g. read/write a socketfd), the io-worker may stuck
> there waiting for events for a long time. And thus other works wait in
> the list for a long time too.
> Let's introduce a new way for unbound works (currently pollable
> requests), with this a request will first be queued to io-worker, then
> executed in a nonblock try rather than a synchronous way. Failure of
> that leads it to arm poll stuff and then the worker can begin to handle
> other works.
> The detail process of this kind of requests is:
> 
> step1: original context:
>             queue it to io-worker
> step2: io-worker context:
>             nonblock try(the old logic is a synchronous try here)
>                 |
>                 |--fail--> arm poll
>                              |
>                              |--(fail/ready)-->synchronous issue
>                              |
>                              |--(succeed)-->worker finish it's job, tw
>                                             take over the req
> 
> This works much better than the old IOSQE_ASYNC logic in cases where
> unbound max_worker is relatively small. In this case, number of
> io-worker eazily increments to max_worker, new worker cannot be created
> and running workers stuck there handling old works in IOSQE_ASYNC mode.
> 
> In my 64-core machine, set unbound max_worker to 20, run echo-server,
> turns out:
> (arguments: register_file, connetion number is 1000, message size is 12
> Byte)
> original IOSQE_ASYNC: 76664.151 tps
> after this patch: 166934.985 tps
> 
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> v1-->v2:
>   - tweak added code in io_wq_submit_work to reduce overhead
> v2-->v3:
>   - remove redundant IOSQE_ASYNC_HYBRID stuff
> 
> 
>   fs/io_uring.c | 36 +++++++++++++++++++++++++++++++++++-
>   1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b3546eef0289..86819c7917df 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6747,8 +6747,18 @@ static void io_wq_submit_work(struct io_wq_work *work)
>   		ret = -ECANCELED;
>   
>   	if (!ret) {
> +		bool needs_poll = false;
> +		unsigned int issue_flags = IO_URING_F_UNLOCKED;
> +
> +		if (req->flags & REQ_F_FORCE_ASYNC) {
> +			needs_poll = req->file && file_can_poll(req->file);
> +			if (needs_poll)
> +				issue_flags |= IO_URING_F_NONBLOCK;
> +		}
> +
>   		do {
> -			ret = io_issue_sqe(req, IO_URING_F_UNLOCKED);
> +issue_sqe:
> +			ret = io_issue_sqe(req, issue_flags);
>   			/*
>   			 * We can get EAGAIN for polled IO even though we're
>   			 * forcing a sync submission from here, since we can't
> @@ -6756,6 +6766,30 @@ static void io_wq_submit_work(struct io_wq_work *work)
>   			 */
>   			if (ret != -EAGAIN)
>   				break;
> +			if (needs_poll) {
> +				bool armed = false;
> +
> +				ret = 0;
> +				needs_poll = false;
> +				issue_flags &= ~IO_URING_F_NONBLOCK;
> +
> +				switch (io_arm_poll_handler(req)) {
> +				case IO_APOLL_READY:
> +					goto issue_sqe;
> +				case IO_APOLL_ABORTED:
> +					/*
> +					 * somehow we failed to arm the poll infra,
> +					 * fallback it to a normal async worker try.
> +					 */
> +					break;
> +				case IO_APOLL_OK:
> +					armed = true;
> +					break;
> +				}
> +
> +				if (armed)
> +					break;
> +			}
>   			cond_resched();
>   		} while (1);
>   	}
> 

