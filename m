Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082CB4187F0
	for <lists+io-uring@lfdr.de>; Sun, 26 Sep 2021 11:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhIZJuT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Sep 2021 05:50:19 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:39898 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229755AbhIZJuT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 26 Sep 2021 05:50:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Upbnz8v_1632649719;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Upbnz8v_1632649719)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 26 Sep 2021 17:48:40 +0800
Subject: Re: [PATCH 1/2] io_uring: fix tw list mess-up by adding tw while it's
 already in tw list
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210912162345.51651-1-haoxu@linux.alibaba.com>
 <20210912162345.51651-2-haoxu@linux.alibaba.com>
 <6b9d818b-468e-e409-8dc1-9d4bd586635e@gmail.com>
 <665861ee-7688-73ca-e553-177df4159cff@linux.alibaba.com>
Message-ID: <3b22fef3-8a08-2954-6288-8d43b7434745@linux.alibaba.com>
Date:   Sun, 26 Sep 2021 17:48:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <665861ee-7688-73ca-e553-177df4159cff@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/15 下午6:48, Hao Xu 写道:
> 在 2021/9/15 下午5:44, Pavel Begunkov 写道:
>> On 9/12/21 5:23 PM, Hao Xu wrote:
>>> For multishot mode, there may be cases like:
>>> io_poll_task_func()
>>> -> add_wait_queue()
>>>                              async_wake()
>>>                              ->io_req_task_work_add()
>>>                              this one mess up the running task_work list
>>>                              since req->io_task_work.node is in use.
>>>
>>> similar situation for req->io_task_work.fallback_node.
>>> Fix it by set node->next = NULL before we run the tw, so that when we
>>> add req back to the wait queue in middle of tw running, we can safely
>>> re-add it to the tw list.
>>
>> It may get screwed before we get to "node->next = NULL;",
>>
>> -> async_wake()
>>    -> io_req_task_work_add()
>> -> async_wake()
>>    -> io_req_task_work_add()
>> tctx_task_work()
> True, this may happen if there is second poll wait entry.
> This pacth is for single wait entry only..
> I'm thinking about the second poll entry issue, would be in a separate
> patch.
hmm, reviewed this email again and now I think I got what you were
saying, do you mean the second async_wake() triggered before we removed
the wait entry in the first async_wake(), like

async_wake
                           async_wake
->del wait entry

>>
>>
>>> Fixes: 7cbf1722d5fc ("io_uring: provide FIFO ordering for task_work")
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>
>>>   fs/io_uring.c | 11 ++++++++---
>>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 30d959416eba..c16f6be3d46b 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -1216,13 +1216,17 @@ static void io_fallback_req_func(struct 
>>> work_struct *work)
>>>       struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
>>>                           fallback_work.work);
>>>       struct llist_node *node = llist_del_all(&ctx->fallback_llist);
>>> -    struct io_kiocb *req, *tmp;
>>> +    struct io_kiocb *req;
>>>       bool locked = false;
>>>       percpu_ref_get(&ctx->refs);
>>> -    llist_for_each_entry_safe(req, tmp, node, 
>>> io_task_work.fallback_node)
>>> +    req = llist_entry(node, struct io_kiocb, 
>>> io_task_work.fallback_node);
>>> +    while (member_address_is_nonnull(req, 
>>> io_task_work.fallback_node)) {
>>> +        node = req->io_task_work.fallback_node.next;
>>> +        req->io_task_work.fallback_node.next = NULL;
>>>           req->io_task_work.func(req, &locked);
>>> -
>>> +        req = llist_entry(node, struct io_kiocb, 
>>> io_task_work.fallback_node);
>>> +    }
>>>       if (locked) {
>>>           if (ctx->submit_state.compl_nr)
>>>               io_submit_flush_completions(ctx);
>>> @@ -2126,6 +2130,7 @@ static void tctx_task_work(struct callback_head 
>>> *cb)
>>>                   locked = mutex_trylock(&ctx->uring_lock);
>>>                   percpu_ref_get(&ctx->refs);
>>>               }
>>> +            node->next = NULL;
>>>               req->io_task_work.func(req, &locked);
>>>               node = next;
>>>           } while (node);
>>>
>>

