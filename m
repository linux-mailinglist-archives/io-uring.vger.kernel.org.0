Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4B340470A
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 10:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhIIIag (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 04:30:36 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:47256 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhIIIag (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 04:30:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UnmiPyP_1631176164;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UnmiPyP_1631176164)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Sep 2021 16:29:25 +0800
Subject: Re: [PATCH 4/6] io_uring: let fast poll support multishot
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-5-haoxu@linux.alibaba.com>
 <9a8efd19-a320-29a4-7132-7b5ae5b994ff@gmail.com>
 <8c052e2a-0ee6-7dac-1169-9d395d2ecad8@linux.alibaba.com>
 <2ba9fdb5-6d60-21f5-3e20-bc1687c9509f@linux.alibaba.com>
 <a73331f7-11ce-1a67-c312-c20553338682@gmail.com>
 <68296a16-e5ad-067c-c8b4-cfae47e920f6@linux.alibaba.com>
Message-ID: <9c955f25-446f-ee5d-f98b-31aad335c7bc@linux.alibaba.com>
Date:   Thu, 9 Sep 2021 16:29:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <68296a16-e5ad-067c-c8b4-cfae47e920f6@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/9 下午3:01, Hao Xu 写道:
> 在 2021/9/8 下午8:03, Pavel Begunkov 写道:
>> On 9/8/21 12:21 PM, Hao Xu wrote:
>>> 在 2021/9/7 下午2:48, Hao Xu 写道:
>>>> 在 2021/9/7 上午3:04, Pavel Begunkov 写道:
>>>>> On 9/3/21 12:00 PM, Hao Xu wrote:
>>>>>> For operations like accept, multishot is a useful feature, since 
>>>>>> we can
>>>>>> reduce a number of accept sqe. Let's integrate it to fast poll, it 
>>>>>> may
>>>>>> be good for other operations in the future.
>>>>>>
>>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>>>> ---
>>>>>>    fs/io_uring.c | 15 ++++++++++++---
>>>>>>    1 file changed, 12 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>> index d6df60c4cdb9..dae7044e0c24 100644
>>>>>> --- a/fs/io_uring.c
>>>>>> +++ b/fs/io_uring.c
>>>>>> @@ -5277,8 +5277,15 @@ static void io_async_task_func(struct 
>>>>>> io_kiocb *req, bool *locked)
>>>>>>            return;
>>>>>>        }
>>>>>> -    hash_del(&req->hash_node);
>>>>>> -    io_poll_remove_double(req);
>>>>>> +    if (READ_ONCE(apoll->poll.canceled))
>>>>>> +        apoll->poll.events |= EPOLLONESHOT;
>>>>>> +    if (apoll->poll.events & EPOLLONESHOT) {
>>>>>> +        hash_del(&req->hash_node);
>>>>>> +        io_poll_remove_double(req);
>>>>>> +    } else {
>>>>>> +        add_wait_queue(apoll->poll.head, &apoll->poll.wait);
>>>>>
>>>>> It looks like it does both io_req_task_submit() and adding back
>>>>> to the wq, so io_issue_sqe() may be called in parallel with
>>>>> io_async_task_func(). If so, there will be tons of all kind of
>>>>> races.
>>>> IMHO, io_async_task_func() is called in original context one by
>>>> one(except PF_EXITING is set, it is also called in system-wq), so
>>>> shouldn't be parallel case there.
>>> ping...
>>
>> fwiw, the case we're talking about:
>>
>> CPU0                            | CPU1
>> io_async_task_func()            |
>> -> add_wait_queue();            |
>> -> io_req_task_submit();        |
>>                 /* no tw run happened in between */
>>                                  | io_async_task_func()
>>                                  | --> io_req_task_submit()
>>
>> We called io_req_task_submit() twice without running tw in-between,
>> both of the calls use the same req->io_task_work.node field in the
>> request for accounting, and so the second call will screw
>> tctx->task_list and not only by not considering that
>> req->io_task_work.node is already taken/enqueued.
>>
>> io_req_task_work_add() {
>>          wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
>> }
>>
> I guess you mean io_req_task_work_add() called by async_wake() two times:
> io_async_task_func()
> -> add_wait_queue()
>                              async_wake()
>                              ->io_req_task_work_add()
>                              this one mess up the running task_work list
>                              since req->io_task_work.node is in use.
> 
> It seems the current poll_add + multishot logic has this issue too, I'll
> give it a shot(simply clean req->io_task_work.node before running
> req->io_task_work.func should work)
Similar issue for double wait entry since we didn't remove double entry
in interrupt handler:
async_wake() --> io_req_task_work_add()
io_poll_double_wake()-->async_wake()-->io_req_task_work_add()

>>>>>
>>>>>> +    }
>>>>>> +
>>>>>>        spin_unlock(&ctx->completion_lock);
>>>>>>        if (!READ_ONCE(apoll->poll.canceled))
>>>>>> @@ -5366,7 +5373,7 @@ static int io_arm_poll_handler(struct 
>>>>>> io_kiocb *req)
>>>>>>        struct io_ring_ctx *ctx = req->ctx;
>>>>>>        struct async_poll *apoll;
>>>>>>        struct io_poll_table ipt;
>>>>>> -    __poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
>>>>>> +    __poll_t ret, mask = POLLERR | POLLPRI;
>>>>>>        int rw;
>>>>>>        if (!req->file || !file_can_poll(req->file))
>>>>>> @@ -5388,6 +5395,8 @@ static int io_arm_poll_handler(struct 
>>>>>> io_kiocb *req)
>>>>>>            rw = WRITE;
>>>>>>            mask |= POLLOUT | POLLWRNORM;
>>>>>>        }
>>>>>> +    if (!(req->flags & REQ_F_APOLL_MULTISHOT))
>>>>>> +        mask |= EPOLLONESHOT;
>>>>>>        /* if we can't nonblock try, then no point in arming a poll 
>>>>>> handler */
>>>>>>        if (!io_file_supports_nowait(req, rw))
>>>>>>
>>>>>
>>>
>>

