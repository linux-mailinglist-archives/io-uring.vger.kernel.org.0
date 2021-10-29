Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728DF43FD6A
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 15:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJ2Njy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 09:39:54 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:58556 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230252AbhJ2Njy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 09:39:54 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Uu9J4xR_1635514643;
Received: from legedeMacBook-Pro.local(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Uu9J4xR_1635514643)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Oct 2021 21:37:24 +0800
Subject: Re: [PATCH v3 2/3] io_uring: reduce frequent add_wait_queue()
 overhead for multi-shot poll request
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
 <20211025053849.3139-3-xiaoguang.wang@linux.alibaba.com>
 <7dd1823d-0324-36d1-2562-362f2ef0399b@gmail.com>
 <7e6c2a36-adf5-ece5-9109-cd5c4429e79d@linux.alibaba.com>
 <a448c9b6-65d8-c602-7716-d6630c1f2254@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <bede0dc1-dc6f-3674-9650-e0f3e60c3d01@linux.alibaba.com>
Date:   Fri, 29 Oct 2021 21:37:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a448c9b6-65d8-c602-7716-d6630c1f2254@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 10/29/21 03:57, Xiaoguang Wang wrote:
>> hi,
>>
>>> On 10/25/21 06:38, Xiaoguang Wang wrote:
>>>> Run echo_server to evaluate io_uring's multi-shot poll performance, 
>>>> perf
>>>> shows that add_wait_queue() has obvious overhead. Intruduce a new 
>>>> state
>>>> 'active' in io_poll_iocb to indicate whether io_poll_wake() should 
>>>> queue
>>>> a task_work. This new state will be set to true initially, be set 
>>>> to false
>>>> when starting to queue a task work, and be set to true again when a 
>>>> poll
>>>> cqe has been committed. One concern is that this method may lost 
>>>> waken-up
>>>> event, but seems it's ok.
>>>>
>>>>    io_poll_wake                io_poll_task_func
>>>> t1                       |
>>>> t2                       | WRITE_ONCE(req->poll.active, true);
>>>> t3                       |
>>>> t4                       |    io_commit_cqring(ctx);
>>>> t5                       |
>>>> t6                       |
>>>>
>>>> If waken-up events happens before or at t4, it's ok, user app will 
>>>> always
>>>> see a cqe. If waken-up events happens after t4 and IIUC, 
>>>> io_poll_wake()
>>>> will see the new req->poll.active value by using READ_ONCE().
>>>>
>>>> Echo_server codes can be cloned from:
>>>> https://codeup.openanolis.cn/codeup/storage/io_uring-echo-server.git,
>>>> branch is xiaoguangwang/io_uring_multishot.
>>>>
>>>> Without this patch, the tps in our test environment is 284116, with
>>>> this patch, the tps is 287832, about 1.3% reqs improvement, which
>>>> is indeed in accord with the saved add_wait_queue() cost.
>>>>
>>>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>>> ---
>>>>   fs/io_uring.c | 57 
>>>> +++++++++++++++++++++++++++++++++------------------------
>>>>   1 file changed, 33 insertions(+), 24 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 18af9bb9a4bc..e4c779dac953 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -481,6 +481,7 @@ struct io_poll_iocb {
>>>>       __poll_t            events;
>>>>       bool                done;
>>>>       bool                canceled;
>>>> +    bool                active;
>>>>       struct wait_queue_entry        wait;
>>>>   };
>>>>   @@ -5233,8 +5234,6 @@ static inline int __io_async_wake(struct 
>>>> io_kiocb *req, struct io_poll_iocb *pol
>>>>   {
>>>>       trace_io_uring_task_add(req->ctx, req->opcode, 
>>>> req->user_data, mask);
>>>>   -    list_del_init(&poll->wait.entry);
>>>> -
>>>
>>> As I mentioned to Hao some time ago, we can't allow this function or in
>>> particular io_req_task_work_add() to happen twice before the first
>>> task work got executed, they use the same field in io_kiocb and those
>>> will corrupt the tw list.
>>>
>>> Looks that's what can happen here.
>> If I have understood scenario your described correctly, I think it 
>> won't happen :)
>> With this patch, if the first io_req_task_work_add() is issued, 
>> poll.active
>> will be set to false, then no new io_req_task_work_add() will be issued.
>> Only the first task_work installed by the first 
>> io_req_task_work_add() has
>> completed, poll.active will be set to true again.
>
> Ah, I see now, the active dance is in io_poll_wake(). That won't work
> with READ_ONCE/WRITE_ONCE though, you would need real atomics
>
> The easiest race to explain is:
>
> CPU1                        | CPU2
> io_poll_wake                | io_poll_wake
> if (p->active) return 0;    | if (p->active) return 0;
it's "if (!p->active) return 0;" in my patch :)
> // p->active is false in both cases, continue
> p->active = false;          | p->active = false;
> task_work_add()             | task_work_add()
io_poll_wake() is called with poll->head->lock, so there will no concurrent
io_poll_wake() calls.

Regards,
Xiaoguang Wang
>
>
> But there are more subtle races.
>

