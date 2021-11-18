Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C4B455942
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 11:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245717AbhKRKnE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 05:43:04 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:43883 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245334AbhKRKmw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 05:42:52 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UxBVrB2_1637231989;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UxBVrB2_1637231989)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 18 Nov 2021 18:39:50 +0800
Subject: Re: [PATCH 6/6] io_uring: batch completion in prior_task_list
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211029122237.164312-1-haoxu@linux.alibaba.com>
 <20211029122237.164312-7-haoxu@linux.alibaba.com>
 <743d74dd-84c6-8a74-d7fb-780634cd59f7@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <d6d298b5-fbd5-a58d-8fa1-610517a4ca1d@linux.alibaba.com>
Date:   Thu, 18 Nov 2021 18:39:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <743d74dd-84c6-8a74-d7fb-780634cd59f7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/11/18 上午6:55, Pavel Begunkov 写道:
> On 10/29/21 13:22, Hao Xu wrote:
>> In previous patches, we have already gathered some tw with
>> io_req_task_complete() as callback in prior_task_list, let's complete
>> them in batch regardless uring lock. For instance, we are doing simple
>> direct read, most task work will be io_req_task_complete(), with this
>> patch we don't need to hold uring lock there for long time.
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 52 ++++++++++++++++++++++++++++++++++++++++++---------
>>   1 file changed, 43 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 694195c086f3..565cd0b34f18 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2166,6 +2166,37 @@ static inline unsigned int 
>> io_put_rw_kbuf(struct io_kiocb *req)
>>       return io_put_kbuf(req, req->kbuf);
>>   }
>> +static void handle_prior_tw_list(struct io_wq_work_node *node)
>> +{
>> +    struct io_ring_ctx *ctx = NULL;
>> +
>> +    do {
>> +        struct io_wq_work_node *next = node->next;
>> +        struct io_kiocb *req = container_of(node, struct io_kiocb,
>> +                            io_task_work.node);
>> +        if (req->ctx != ctx) {
>> +            if (ctx) {
>> +                io_commit_cqring(ctx);
>> +                spin_unlock(&ctx->completion_lock);
>> +                io_cqring_ev_posted(ctx);
>> +                percpu_ref_put(&ctx->refs);
>> +            }
>> +            ctx = req->ctx;
>> +            percpu_ref_get(&ctx->refs);
>> +            spin_lock(&ctx->completion_lock);
>> +        }
>> +        __io_req_complete_post(req, req->result, io_put_rw_kbuf(req));
>> +        node = next;
>> +    } while (node);
>> +
>> +    if (ctx) {
>> +        io_commit_cqring(ctx);
>> +        spin_unlock(&ctx->completion_lock);
>> +        io_cqring_ev_posted(ctx);
>> +        percpu_ref_put(&ctx->refs);
>> +    }
>> +}
>> +
>>   static void handle_tw_list(struct io_wq_work_node *node, struct 
>> io_ring_ctx **ctx, bool *locked)
>>   {
>>       do {
>> @@ -2193,25 +2224,28 @@ static void tctx_task_work(struct 
>> callback_head *cb)
>>                             task_work);
>>       while (1) {
>> -        struct io_wq_work_node *node;
>> -        struct io_wq_work_list *merged_list;
>> +        struct io_wq_work_node *node1, *node2;
>> -        if (!tctx->prior_task_list.first &&
>> -            !tctx->task_list.first && locked)
>> +        if (!tctx->task_list.first &&
>> +            !tctx->prior_task_list.first && locked)
>>               io_submit_flush_completions(ctx);
>>           spin_lock_irq(&tctx->task_lock);
>> -        merged_list = wq_list_merge(&tctx->prior_task_list, 
>> &tctx->task_list);
>> -        node = merged_list->first;
>> +        node1 = tctx->prior_task_list.first;
>> +        node2 = tctx->task_list.first;
>>           INIT_WQ_LIST(&tctx->task_list);
>>           INIT_WQ_LIST(&tctx->prior_task_list);
>> -        if (!node)
>> +        if (!node2 && !node1)
>>               tctx->task_running = false;
>>           spin_unlock_irq(&tctx->task_lock);
>> -        if (!node)
>> +        if (!node2 && !node1)
>>               break;
>> -        handle_tw_list(node, &ctx, &locked);
>> +        if (node1)
>> +            handle_prior_tw_list(node1);
> 
> IIUC, it moves all IRQ rw completions to this new path even when we already
> have the lock. One concern is that io_submit_flush_completions() is better
> optimised. Should probably be visible for one threaded apps and a bunch of
> other cases.
> 
> How about a combined scheme? if we can grab the lock, go through the old
> path, otherwise handle_prior_tw_list(). The rest looks good, will formally
> review once we deal with this one.
Thanks Pavel, I'll look into this patchset soon after
finishing some tests to my io-wq patchset.
> 
>> +
>> +        if (node2)
>> +            handle_tw_list(node2, &ctx, &locked);
>>           cond_resched();
>>       }
>>
> 

