Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4213F546BC4
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 19:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346363AbiFJRlQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 13:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345038AbiFJRlQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 13:41:16 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1245254FA6
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 10:41:14 -0700 (PDT)
Message-ID: <c4fdf822-6514-0147-fb13-fd3d64c0ada3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654882872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NydMG2I0h7c0dEDVMQT79bimKXNpYdtmE116oTROvM0=;
        b=xew7GX2z9hZkx+WFTF8f6hDkJLTd8aBBVQh4H9y9CHpvJr2uGZdED44LHnai85YisuCL9X
        M7dL2lc0U3VfutvhlPvpcvBn+ti7MDdRlXYcG0tGTDyABsC8gX9L3VPO7r1MKLoEVbz72r
        WojVlST+NNbJB4HjuxKozw/AILzwqsY=
Date:   Sat, 11 Jun 2022 01:40:59 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] io_uring: switch cancel_hash to use per entry spinlock
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220608111259.659536-1-hao.xu@linux.dev>
 <37d73555-197b-29e1-d2cc-b7313501a394@gmail.com>
 <d5dedb44-34d2-6057-a937-f54c4545bd26@linux.dev>
 <39bbb017-7f7e-39bd-f209-f3526f30c21d@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <39bbb017-7f7e-39bd-f209-f3526f30c21d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/11/22 00:10, Pavel Begunkov wrote:
> On 6/10/22 16:45, Hao Xu wrote:
>> On 6/10/22 18:21, Pavel Begunkov wrote:
>>> On 6/8/22 12:12, Hao Xu wrote:
>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>
>>>> Add a new io_hash_bucket structure so that each bucket in cancel_hash
>>>> has separate spinlock. Use per entry lock for cancel_hash, this removes
>>>> some completion lock invocation and remove contension between different
>>>> cancel_hash entries.
>>>>
>>>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>>>> ---
>>>>
>>>> v1->v2:
>>>>   - Add per entry lock for poll/apoll task work code which was missed
>>>>     in v1
>>>>   - add an member in io_kiocb to track req's indice in cancel_hash
>>>>
>>>> v2->v3:
>>>>   - make struct io_hash_bucket align with cacheline to avoid cacheline
>>>>     false sharing.
>>>>   - re-calculate hash value when deleting an entry from cancel_hash.
>>>>     (cannot leverage struct io_poll to store the indice since it's
>>>>      already 64 Bytes)
>>>>
>>>>   io_uring/cancel.c         | 14 +++++++--
>>>>   io_uring/cancel.h         |  6 ++++
>>>>   io_uring/fdinfo.c         |  9 ++++--
>>>>   io_uring/io_uring.c       |  8 +++--
>>>>   io_uring/io_uring_types.h |  2 +-
>>>>   io_uring/poll.c           | 64 
>>>> +++++++++++++++++++++------------------
>>>>   6 files changed, 65 insertions(+), 38 deletions(-)
>>>>
>>>> diff --git a/io_uring/cancel.c b/io_uring/cancel.c
>>>> index 83cceb52d82d..bced5d6b9294 100644
>>>> --- a/io_uring/cancel.c
>>>> +++ b/io_uring/cancel.c
>>>> @@ -93,14 +93,14 @@ int io_try_cancel(struct io_kiocb *req, struct 
>>>> io_cancel_data *cd)
>>>>       if (!ret)
>>>>           return 0;
>>>> -    spin_lock(&ctx->completion_lock);
>>>>       ret = io_poll_cancel(ctx, cd);
>>>>       if (ret != -ENOENT)
>>>>           goto out;
>>>> +    spin_lock(&ctx->completion_lock);
>>>>       if (!(cd->flags & IORING_ASYNC_CANCEL_FD))
>>>>           ret = io_timeout_cancel(ctx, cd);
>>>> -out:
>>>>       spin_unlock(&ctx->completion_lock);
>>>> +out:
>>>>       return ret;
>>>>   }
>>>> @@ -192,3 +192,13 @@ int io_async_cancel(struct io_kiocb *req, 
>>>> unsigned int issue_flags)
>>>>       io_req_set_res(req, ret, 0);
>>>>       return IOU_OK;
>>>>   }
>>>> +
>>>> +inline void init_hash_table(struct io_hash_bucket *hash_table, 
>>>> unsigned size)
>>>
>>> Not inline, it can break builds
>>>
>>>> diff --git a/io_uring/cancel.h b/io_uring/cancel.h
>>>> index 4f35d8696325..b57d6706f84d 100644
>>>> --- a/io_uring/cancel.h
>>>> +++ b/io_uring/cancel.h
>>>> @@ -4,3 +4,9 @@ int io_async_cancel_prep(struct io_kiocb *req, const 
>>>> struct io_uring_sqe *sqe);
>>>>   int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
>>>>   int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd);
>>>> +inline void init_hash_table(struct io_hash_bucket *hash_table, 
>>>> unsigned size);
>>>
>>> And this inline as well
>>>
>>>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>>>> index 0df5eca93b16..515f1727e3c6 100644
>>>> --- a/io_uring/poll.c
>>>> +++ b/io_uring/poll.c
>>> [...]
>>>>   static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool 
>>>> poll_only,
>>>>                        struct io_cancel_data *cd)
>>>> -    __must_hold(&ctx->completion_lock)
>>>>   {
>>>> -    struct hlist_head *list;
>>>>       struct io_kiocb *req;
>>>> -    list = &ctx->cancel_hash[hash_long(cd->data, 
>>>> ctx->cancel_hash_bits)];
>>>> -    hlist_for_each_entry(req, list, hash_node) {
>>>> +    u32 index = hash_long(cd->data, ctx->cancel_hash_bits);
>>>> +    struct io_hash_bucket *hb = &ctx->cancel_hash[index];
>>>> +
>>>> +    spin_lock(&hb->lock);
>>>> +    hlist_for_each_entry(req, &hb->list, hash_node) {
>>>>           if (cd->data != req->cqe.user_data)
>>>>               continue;
>>>>           if (poll_only && req->opcode != IORING_OP_POLL_ADD)
>>>> @@ -569,47 +577,48 @@ static struct io_kiocb *io_poll_find(struct 
>>>> io_ring_ctx *ctx, bool poll_only,
>>>>                   continue;
>>>>               req->work.cancel_seq = cd->seq;
>>>>           }
>>>> +        spin_unlock(&hb->lock);
>>>
>>> The problem here is that after you unlock, nothing keeps the
>>> request alive. Before it was more like
>>>
>>> lock(completion_lock);
>>> req = poll_find();
>>> cancel_poll(req);
>>> unlock(completion_lock);
>>>
>>> and was relying on all of this happening under ->completion_lock.
>>> Now following io_poll_disarm() and/or io_poll_cancel_req() race.
>>> Same with io_poll_file_find().
>>
>> Looks we have to add completion_lock back for cancellation path.
> 
> It was relying on completion_lock only because it was guarding
> the hashing, so now find+cancel should happen under the per
> bucket spins, i.e.
> 
> lock(buckets[index].lock);
> req = poll_find();
> cancel_poll(req);
> unlock(buckets[index].lock);
> 
> A bit trickier to code but doable.

Ah, seems I misunderstood your words, which I'm clear with now.
Yea, it's a bit odd. I'll think about this issue before taking this
solution tomorrow.
Btw, I saw a req->refcount set for poll_add, seems it is not necessary?
(I haven't check it carefully yet)

> 

