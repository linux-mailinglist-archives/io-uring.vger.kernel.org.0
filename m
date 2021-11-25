Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9FE45D961
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 12:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238411AbhKYLm0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 06:42:26 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:51501 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234605AbhKYLk0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 06:40:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UyGZRP7_1637840232;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UyGZRP7_1637840232)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Nov 2021 19:37:13 +0800
Subject: Re: [PATCH v5 0/6] task work optimization
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211124122202.218756-1-haoxu@linux.alibaba.com>
 <28685b5a-5484-809c-38d7-ef60f359b535@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <9682cd7d-bdc6-cbc9-b209-311e65a5fce9@linux.alibaba.com>
Date:   Thu, 25 Nov 2021 19:37:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <28685b5a-5484-809c-38d7-ef60f359b535@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/11/25 上午5:41, Pavel Begunkov 写道:
> On 11/24/21 12:21, Hao Xu wrote:
>> v4->v5
>> - change the implementation of merge_wq_list
> 
> They only concern I had was about 6/6 not using inline completion
> infra, when it's faster to grab ->uring_lock. i.e.
> io_submit_flush_completions(), which should be faster when batching
> is good.
> 
> Looking again through the code, the only user is SQPOLL
> 
> io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
> 
> And with SQPOLL the lock is mostly grabbed by the SQPOLL task only,
> IOW for pure block rw there shouldn't be any contention.
There still could be other type of task work, like async buffered reads.
I considered generic situation where different kinds of task works mixed
in the task list, then the inline completion infra always handle the
completions at the end, while in this new batching, we first handle the
completions and commit_cqring then do other task works.
Btw, I'm not sure the inline completion infra is faster than this
batching in pure rw completion(where all the task works are completion)
case, from the code, seems they are similar. Any hints about this?

Regards,
Hao
> Doesn't make much sense, what am I missing?
> How many requests are completed on average per tctx_task_work()?
> 
> 
> It doesn't apply to for-5.17/io_uring, here is a rebase:
> https://github.com/isilence/linux.git haoxu_tw_opt
> link: https://github.com/isilence/linux/tree/haoxu_tw_opt
> 
> With that first 5 patches look good, so for them:
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> but I still don't understand how 6/6 is better. Can it be because of
> indirect branching? E.g. would something like this give the result?
> 
> - req->io_task_work.func(req, locked);
> + INDIRECT_CALL_1(req->io_task_work.func, io_req_task_complete, req, 
> locked);
> 
> 
>> Hao Xu (6):
>>    io-wq: add helper to merge two wq_lists
>>    io_uring: add a priority tw list for irq completion work
>>    io_uring: add helper for task work execution code
>>    io_uring: split io_req_complete_post() and add a helper
>>    io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
>>    io_uring: batch completion in prior_task_list
>>
>>   fs/io-wq.h    |  22 +++++++
>>   fs/io_uring.c | 158 +++++++++++++++++++++++++++++++++-----------------
>>   2 files changed, 128 insertions(+), 52 deletions(-)
>>
> 

