Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F072E1194
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 03:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgLWCOd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Dec 2020 21:14:33 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:54437 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725300AbgLWCOd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Dec 2020 21:14:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UJUdFTJ_1608689629;
Received: from 30.225.32.217(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UJUdFTJ_1608689629)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Dec 2020 10:13:49 +0800
Subject: Re: [PATCH] io_uring: hold uring_lock to complete faild polled io in
 io_wq_submit_work()
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20201214154941.10907-1-xiaoguang.wang@linux.alibaba.com>
 <b82a6652-4895-4669-fb8f-167e5150e9e8@gmail.com>
 <27952c41-111c-b505-e7f1-78b299f4b786@gmail.com>
 <78388381-c8cf-a024-457d-1ad31207d2ef@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <a3f8e499-012c-e66a-9e48-1e0a6b0c66b8@linux.alibaba.com>
Date:   Wed, 23 Dec 2020 10:12:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <78388381-c8cf-a024-457d-1ad31207d2ef@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 12/20/20 12:36 PM, Pavel Begunkov wrote:
>> On 20/12/2020 19:34, Pavel Begunkov wrote:
>>> On 14/12/2020 15:49, Xiaoguang Wang wrote:
>>>> io_iopoll_complete() does not hold completion_lock to complete polled
>>>> io, so in io_wq_submit_work(), we can not call io_req_complete() directly,
>>>> to complete polled io, otherwise there maybe concurrent access to cqring,
>>>> defer_list, etc, which is not safe. Commit dad1b1242fd5 ("io_uring: always
>>>> let io_iopoll_complete() complete polled io") has fixed this issue, but
>>>> Pavel reported that IOPOLL apart from rw can do buf reg/unreg requests(
>>>> IORING_OP_PROVIDE_BUFFERS or IORING_OP_REMOVE_BUFFERS), so the fix is
>>>> not good.
>>>>
>>>> Given that io_iopoll_complete() is always called under uring_lock, so here
>>>> for polled io, we can also get uring_lock to fix this issue.
>>>
>>> This returns it to the state it was before fixing + mutex locking for
>>> IOPOLL, and it's much better than having it half-broken as it is now.
>>
>> btw, comments are over 80, but that's minor.
> 
> I fixed that up, but I don't particularly like how 'req' is used after
> calling complete. How about the below variant - same as before, just
> using the ctx instead to determine if we need to lock it or not.
It looks better, thanks.

Regards,
Xiaoguang Wang
> 
> 
> commit 253b60e7d8adcb980be91f77e64968a58d836b5e
> Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> Date:   Mon Dec 14 23:49:41 2020 +0800
> 
>      io_uring: hold uring_lock while completing failed polled io in io_wq_submit_work()
>      
>      io_iopoll_complete() does not hold completion_lock to complete polled io,
>      so in io_wq_submit_work(), we can not call io_req_complete() directly, to
>      complete polled io, otherwise there maybe concurrent access to cqring,
>      defer_list, etc, which is not safe. Commit dad1b1242fd5 ("io_uring: always
>      let io_iopoll_complete() complete polled io") has fixed this issue, but
>      Pavel reported that IOPOLL apart from rw can do buf reg/unreg requests(
>      IORING_OP_PROVIDE_BUFFERS or IORING_OP_REMOVE_BUFFERS), so the fix is not
>      good.
>      
>      Given that io_iopoll_complete() is always called under uring_lock, so here
>      for polled io, we can also get uring_lock to fix this issue.
>      
>      Fixes: dad1b1242fd5 ("io_uring: always let io_iopoll_complete() complete polled io")
>      Cc: <stable@vger.kernel.org> # 5.5+
>      Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>      Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
>      [axboe: don't deref 'req' after completing it']
>      Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b27f61e3e0d6..0a8cf3fad955 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6332,19 +6332,28 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
>   	}
>   
>   	if (ret) {
> +		struct io_ring_ctx *lock_ctx = NULL;
> +
> +		if (req->ctx->flags & IORING_SETUP_IOPOLL)
> +			lock_ctx = req->ctx;
> +
>   		/*
> -		 * io_iopoll_complete() does not hold completion_lock to complete
> -		 * polled io, so here for polled io, just mark it done and still let
> -		 * io_iopoll_complete() complete it.
> +		 * io_iopoll_complete() does not hold completion_lock to
> +		 * complete polled io, so here for polled io, we can not call
> +		 * io_req_complete() directly, otherwise there maybe concurrent
> +		 * access to cqring, defer_list, etc, which is not safe. Given
> +		 * that io_iopoll_complete() is always called under uring_lock,
> +		 * so here for polled io, we also get uring_lock to complete
> +		 * it.
>   		 */
> -		if (req->ctx->flags & IORING_SETUP_IOPOLL) {
> -			struct kiocb *kiocb = &req->rw.kiocb;
> +		if (lock_ctx)
> +			mutex_lock(&lock_ctx->uring_lock);
>   
> -			kiocb_done(kiocb, ret, NULL);
> -		} else {
> -			req_set_fail_links(req);
> -			io_req_complete(req, ret);
> -		}
> +		req_set_fail_links(req);
> +		io_req_complete(req, ret);
> +
> +		if (lock_ctx)
> +			mutex_unlock(&lock_ctx->uring_lock);
>   	}
>   
>   	return io_steal_work(req);
> 
