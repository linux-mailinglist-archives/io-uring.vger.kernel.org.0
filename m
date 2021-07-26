Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303BF3D5BE7
	for <lists+io-uring@lfdr.de>; Mon, 26 Jul 2021 16:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhGZN7a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jul 2021 09:59:30 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:50348 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233206AbhGZN7Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jul 2021 09:59:25 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uh4Jw3J_1627310392;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uh4Jw3J_1627310392)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 26 Jul 2021 22:39:52 +0800
Subject: Re: [PATCH io_uring-5.14 v2] io_uring: remove double poll wait entry
 for pure poll
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210723092227.137526-1-haoxu@linux.alibaba.com>
 <c628d5bc-ee34-bf43-c7bc-5b52cf983cb1@gmail.com>
 <824dcbe0-34da-a075-12eb-ce7529f3e3f7@linux.alibaba.com>
 <28ce8b3d-e9d2-2fed-e73c-fb09913eea78@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <a5321436-9ba5-5f07-6081-4567f9469631@linux.alibaba.com>
Date:   Mon, 26 Jul 2021 22:39:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <28ce8b3d-e9d2-2fed-e73c-fb09913eea78@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/7/26 下午8:40, Pavel Begunkov 写道:
> On 7/24/21 5:48 AM, Hao Xu wrote:
>> 在 2021/7/23 下午10:31, Pavel Begunkov 写道:
>>> On 7/23/21 10:22 AM, Hao Xu wrote:
>>>> For pure poll requests, we should remove the double poll wait entry.
>>>> And io_poll_remove_double() is good enough for it compared with
>>>> io_poll_remove_waitqs().
>>>
>>> 5.14 in the subject hints me that it's a fix. Is it?
>>> Can you add what it fixes or expand on why it's better?
>> Hi Pavel, I found that for poll_add() requests, it doesn't remove the
>> double poll wait entry when it's done, neither after vfs_poll() or in
>> the poll completion handler. The patch is mainly to fix it.
> 
> Ok, sounds good. Please resend with updated description, and
> let's add some tags.
> 
> Fixes: 88e41cf928a6 ("io_uring: add multishot mode for IORING_OP_POLL_ADD")
> Cc: stable@vger.kernel.org # 5.13+
> 
> Also, I'd prefer the commit title to make more clear that it's a
> fix. E.g. "io_uring: fix poll requests leaking second poll entries".
> 
> Btw, seems it should fix hangs in ./poll-mshot-update
Sure，I'll send v3 soon, sorry for my unprofessionalism..
> 
> 
>>>
>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>> ---
>>>>
>>>> v1-->v2
>>>>     delete redundant io_poll_remove_double()
>>>>
>>>>    fs/io_uring.c | 5 ++---
>>>>    1 file changed, 2 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index f2fe4eca150b..c5fe8b9e26b4 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -4903,7 +4903,6 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
>>>>        if (req->poll.events & EPOLLONESHOT)
>>>>            flags = 0;
>>>>        if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
>>>> -        io_poll_remove_waitqs(req);
>> Currently I only see it does that with io_poll_remove_waitqs() when
>> cqring overflow and then ocqe allocation failed. Using
>> io_poll_remove_waitqs() here is not very suitable since (1) it calls
>> __io_poll_remove_one() which set poll->cancelled = true, why do we set
>> poll->cancelled and poll->done to true at the same time though I think
>> that doesn't cause any problem. (2) it does
>> list_del_init(&poll->wait.entry) and hash_del(&req->hash_node) which
>> has been already done.
>> Correct me if I'm wrong since I may misunderstand the code.
>>
>> Regards,
>> Hao
>>>>            req->poll.done = true;
>>>>            flags = 0;
>>>>        }
>>>> @@ -4926,6 +4925,7 @@ static void io_poll_task_func(struct io_kiocb *req)
>>>>              done = io_poll_complete(req, req->result);
>>>>            if (done) {
>>>> +            io_poll_remove_double(req);
>>>>                hash_del(&req->hash_node);
>>>>            } else {
>>>>                req->result = 0;
>>>> @@ -5113,7 +5113,7 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
>>>>            ipt->error = -EINVAL;
>>>>          spin_lock_irq(&ctx->completion_lock);
>>>> -    if (ipt->error)
>>>> +    if (ipt->error || (mask && (poll->events & EPOLLONESHOT)))
>>>>            io_poll_remove_double(req);
>>>>        if (likely(poll->head)) {
>>>>            spin_lock(&poll->head->lock);
>>>> @@ -5185,7 +5185,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>>>>        ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
>>>>                        io_async_wake);
>>>>        if (ret || ipt.error) {
>>>> -        io_poll_remove_double(req);
>>>>            spin_unlock_irq(&ctx->completion_lock);
>>>>            if (ret)
>>>>                return IO_APOLL_READY;
>>>>
>>>
>>
> 

