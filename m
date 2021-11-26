Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F17C45E6B2
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 05:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358326AbhKZEDX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 23:03:23 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:35193 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241872AbhKZEBO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 23:01:14 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UyKaAxQ_1637899080;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UyKaAxQ_1637899080)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 26 Nov 2021 11:58:01 +0800
Subject: Re: [PATCH v5 0/6] task work optimization
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211124122202.218756-1-haoxu@linux.alibaba.com>
 <28685b5a-5484-809c-38d7-ef60f359b535@gmail.com>
 <9682cd7d-bdc6-cbc9-b209-311e65a5fce9@linux.alibaba.com>
 <876d367c-91d5-b0bf-9e88-acfaa98e77b9@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <29df82ba-fdf1-af45-3529-aaef100526a2@linux.alibaba.com>
Date:   Fri, 26 Nov 2021 11:58:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <876d367c-91d5-b0bf-9e88-acfaa98e77b9@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/11/25 下午11:27, Pavel Begunkov 写道:
> On 11/25/21 11:37, Hao Xu wrote:
>> 在 2021/11/25 上午5:41, Pavel Begunkov 写道:
>>> On 11/24/21 12:21, Hao Xu wrote:
>>>> v4->v5
>>>> - change the implementation of merge_wq_list
>>>
>>> They only concern I had was about 6/6 not using inline completion
>>> infra, when it's faster to grab ->uring_lock. i.e.
>>> io_submit_flush_completions(), which should be faster when batching
>>> is good.
>>>
>>> Looking again through the code, the only user is SQPOLL
>>>
>>> io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
>>>
>>> And with SQPOLL the lock is mostly grabbed by the SQPOLL task only,
>>> IOW for pure block rw there shouldn't be any contention.
>> There still could be other type of task work, like async buffered reads.
>> I considered generic situation where different kinds of task works mixed
>> in the task list, then the inline completion infra always handle the
>> completions at the end, while in this new batching, we first handle the
>> completions and commit_cqring then do other task works.
> 
> I was talking about 6/6 in particular. The reordering (done by first
> 2 or 3 patches) sound plausible, but if compare say 1-5 vs same but
> + patch 6/6
Ah, sorry.. misremember the content of 6/6 and the previous ones.
> 
>> Btw, I'm not sure the inline completion infra is faster than this
>> batching in pure rw completion(where all the task works are completion)
>> case, from the code, seems they are similar. Any hints about this?
> 
> Was looking through, and apparently I placed task_put optimisation
> into io_req_complete_post() as well, see io_put_task().
> 
> pros of io_submit_flush_completions:
> 1) batched rsrc refs put
> 2) a bit better on assembly
> 3) shorter spin section (separate loop)
> 4) enqueueing right into ctx->submit_state.free_list, so no
>     1 io_flush_cached_reqs() per IO_COMPL_BATCH=32
> 
> pros of io_req_complete_post() path:
> 1) no uring_lock locking (not contended)
> 2) de-virtualisation
> 3) no extra (yet another) list traversal and io_req_complete_state()
> 
> So, with put_task optimised, indeed not so clear which would win > Did you use fixed rsrc for testing? (files or buffers)
No, I didn't. Let's first play it safe as you said:
if (locked) flush_completions
else new stuff
> 

