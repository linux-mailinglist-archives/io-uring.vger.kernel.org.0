Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177D64038AD
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 13:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351119AbhIHLWo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 07:22:44 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:35359 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351422AbhIHLWg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 07:22:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Ungt6B5_1631100083;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Ungt6B5_1631100083)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Sep 2021 19:21:24 +0800
Subject: Re: [PATCH 4/6] io_uring: let fast poll support multishot
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-5-haoxu@linux.alibaba.com>
 <9a8efd19-a320-29a4-7132-7b5ae5b994ff@gmail.com>
 <8c052e2a-0ee6-7dac-1169-9d395d2ecad8@linux.alibaba.com>
Message-ID: <2ba9fdb5-6d60-21f5-3e20-bc1687c9509f@linux.alibaba.com>
Date:   Wed, 8 Sep 2021 19:21:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <8c052e2a-0ee6-7dac-1169-9d395d2ecad8@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/7 下午2:48, Hao Xu 写道:
> 在 2021/9/7 上午3:04, Pavel Begunkov 写道:
>> On 9/3/21 12:00 PM, Hao Xu wrote:
>>> For operations like accept, multishot is a useful feature, since we can
>>> reduce a number of accept sqe. Let's integrate it to fast poll, it may
>>> be good for other operations in the future.
>>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io_uring.c | 15 ++++++++++++---
>>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index d6df60c4cdb9..dae7044e0c24 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -5277,8 +5277,15 @@ static void io_async_task_func(struct io_kiocb 
>>> *req, bool *locked)
>>>           return;
>>>       }
>>> -    hash_del(&req->hash_node);
>>> -    io_poll_remove_double(req);
>>> +    if (READ_ONCE(apoll->poll.canceled))
>>> +        apoll->poll.events |= EPOLLONESHOT;
>>> +    if (apoll->poll.events & EPOLLONESHOT) {
>>> +        hash_del(&req->hash_node);
>>> +        io_poll_remove_double(req);
>>> +    } else {
>>> +        add_wait_queue(apoll->poll.head, &apoll->poll.wait);
>>
>> It looks like it does both io_req_task_submit() and adding back
>> to the wq, so io_issue_sqe() may be called in parallel with
>> io_async_task_func(). If so, there will be tons of all kind of
>> races.
> IMHO, io_async_task_func() is called in original context one by
> one(except PF_EXITING is set, it is also called in system-wq), so
> shouldn't be parallel case there.
ping...
>>
>>> +    }
>>> +
>>>       spin_unlock(&ctx->completion_lock);
>>>       if (!READ_ONCE(apoll->poll.canceled))
>>> @@ -5366,7 +5373,7 @@ static int io_arm_poll_handler(struct io_kiocb 
>>> *req)
>>>       struct io_ring_ctx *ctx = req->ctx;
>>>       struct async_poll *apoll;
>>>       struct io_poll_table ipt;
>>> -    __poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
>>> +    __poll_t ret, mask = POLLERR | POLLPRI;
>>>       int rw;
>>>       if (!req->file || !file_can_poll(req->file))
>>> @@ -5388,6 +5395,8 @@ static int io_arm_poll_handler(struct io_kiocb 
>>> *req)
>>>           rw = WRITE;
>>>           mask |= POLLOUT | POLLWRNORM;
>>>       }
>>> +    if (!(req->flags & REQ_F_APOLL_MULTISHOT))
>>> +        mask |= EPOLLONESHOT;
>>>       /* if we can't nonblock try, then no point in arming a poll 
>>> handler */
>>>       if (!io_file_supports_nowait(req, rw))
>>>
>>

