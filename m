Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F35940C3F0
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 12:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbhIOKtl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 06:49:41 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:39090 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232290AbhIOKtk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 06:49:40 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UoTgs50_1631702899;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UoTgs50_1631702899)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 15 Sep 2021 18:48:20 +0800
Subject: Re: [PATCH 1/2] io_uring: fix tw list mess-up by adding tw while it's
 already in tw list
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210912162345.51651-1-haoxu@linux.alibaba.com>
 <20210912162345.51651-2-haoxu@linux.alibaba.com>
 <6b9d818b-468e-e409-8dc1-9d4bd586635e@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <665861ee-7688-73ca-e553-177df4159cff@linux.alibaba.com>
Date:   Wed, 15 Sep 2021 18:48:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <6b9d818b-468e-e409-8dc1-9d4bd586635e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/15 下午5:44, Pavel Begunkov 写道:
> On 9/12/21 5:23 PM, Hao Xu wrote:
>> For multishot mode, there may be cases like:
>> io_poll_task_func()
>> -> add_wait_queue()
>>                              async_wake()
>>                              ->io_req_task_work_add()
>>                              this one mess up the running task_work list
>>                              since req->io_task_work.node is in use.
>>
>> similar situation for req->io_task_work.fallback_node.
>> Fix it by set node->next = NULL before we run the tw, so that when we
>> add req back to the wait queue in middle of tw running, we can safely
>> re-add it to the tw list.
> 
> It may get screwed before we get to "node->next = NULL;",
> 
> -> async_wake()
>    -> io_req_task_work_add()
> -> async_wake()
>    -> io_req_task_work_add()
> tctx_task_work()
True, this may happen if there is second poll wait entry.
This pacth is for single wait entry only..
I'm thinking about the second poll entry issue, would be in a separate
patch.
> 
> 
>> Fixes: 7cbf1722d5fc ("io_uring: provide FIFO ordering for task_work")
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>
>>   fs/io_uring.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 30d959416eba..c16f6be3d46b 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1216,13 +1216,17 @@ static void io_fallback_req_func(struct work_struct *work)
>>   	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
>>   						fallback_work.work);
>>   	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
>> -	struct io_kiocb *req, *tmp;
>> +	struct io_kiocb *req;
>>   	bool locked = false;
>>   
>>   	percpu_ref_get(&ctx->refs);
>> -	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
>> +	req = llist_entry(node, struct io_kiocb, io_task_work.fallback_node);
>> +	while (member_address_is_nonnull(req, io_task_work.fallback_node)) {
>> +		node = req->io_task_work.fallback_node.next;
>> +		req->io_task_work.fallback_node.next = NULL;
>>   		req->io_task_work.func(req, &locked);
>> -
>> +		req = llist_entry(node, struct io_kiocb, io_task_work.fallback_node);
>> +	}
>>   	if (locked) {
>>   		if (ctx->submit_state.compl_nr)
>>   			io_submit_flush_completions(ctx);
>> @@ -2126,6 +2130,7 @@ static void tctx_task_work(struct callback_head *cb)
>>   				locked = mutex_trylock(&ctx->uring_lock);
>>   				percpu_ref_get(&ctx->refs);
>>   			}
>> +			node->next = NULL;
>>   			req->io_task_work.func(req, &locked);
>>   			node = next;
>>   		} while (node);
>>
> 

