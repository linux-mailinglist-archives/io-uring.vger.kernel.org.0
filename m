Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77525546BDE
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 19:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347127AbiFJRrW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 13:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350219AbiFJRrO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 13:47:14 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001EE562E2
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 10:47:12 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id q15so11078045wmj.2
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 10:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qyLBBAibSa0UF0KvdmWHnasKRYAp/IkOsADnuwFIh5g=;
        b=BRSs9zRydf53+nnCxhMuzZOYViAKwqqLDi/GldvCr4gBLgB+pBb8uDNWdk3EDAfxoP
         NY6YYVBuNWoZefXm/vUvxXcbynlB58XGgr+6awYH/g5CAUMvrNRSOHXZIa0KVl4eVvHZ
         FhalmxiQUpTMv2uxI5ou8bwlQMklIHOGTbVqkQmK/JsAD3MgeBi5k5941ZDT7KuLlx7r
         suB0g92JzKvZqy3NjeZHG2jSvqu808dMNIM9MkklISYdtggd/LeRtZmja6CHavB8h+DL
         u0b8zLtlwL7nT3xF1tQwd5wrR7ytDy7ggAZWCf9X9nVfqb4m5XDpEdgh2hmF0mTIHkPf
         KkJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qyLBBAibSa0UF0KvdmWHnasKRYAp/IkOsADnuwFIh5g=;
        b=HxkTolmheD0ngh8v62/CZYupUaP+c+4JtSf73z1XXFJPM2riQ9UBW+xi6qfqlf2JLx
         Ud9LmXYrQ7mmZx0A/+nb3RCmp/80yECX78CyDriGRJh4FMRUQ+r++RY92ACuyHyUoO26
         BRQprJi/e0Aff39r6yfYFriqxpSsgnJbh/Uc9qYBm8e7XuLsCVMwvwMtfUSb44tKiG+O
         9/SI0MJ1UGGVT+KD5SRqrXA+L27VvJJPbB7rZVfQ4F0MCAeWgUkG1Lwaka1DCq2jKmU5
         y7IbYQmPFVLbozs0Gnao7XWHeig4o8uOsBvtbKEc+hLN8YcfNO5PKGE/EAT3y/TsBKq+
         OaBA==
X-Gm-Message-State: AOAM531MnwtG8g9c+psMlxFbZH/dR94bgPY5FDKRe4zfwl1Mc3bfnyTD
        Nb5DxZg20tIXNRF6pOS74GQAxaHeaxl+Sg==
X-Google-Smtp-Source: ABdhPJxti/P4nnimEpZjboJFBGZ6uiUmQdtkRBgSZSkY8l4+nDAZrO/B79B0XJx3NxXuk+0vHmt0/w==
X-Received: by 2002:a05:600c:1d91:b0:39c:544b:abdd with SMTP id p17-20020a05600c1d9100b0039c544babddmr888229wms.70.1654883231433;
        Fri, 10 Jun 2022 10:47:11 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id q3-20020a7bce83000000b003976fbfbf00sm3624170wmj.30.2022.06.10.10.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 10:47:10 -0700 (PDT)
Message-ID: <868b3da5-7555-1fbc-3acf-1a3930162a75@gmail.com>
Date:   Fri, 10 Jun 2022 18:45:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3] io_uring: switch cancel_hash to use per entry spinlock
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220608111259.659536-1-hao.xu@linux.dev>
 <37d73555-197b-29e1-d2cc-b7313501a394@gmail.com>
 <d5dedb44-34d2-6057-a937-f54c4545bd26@linux.dev>
 <39bbb017-7f7e-39bd-f209-f3526f30c21d@gmail.com>
 <c4fdf822-6514-0147-fb13-fd3d64c0ada3@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c4fdf822-6514-0147-fb13-fd3d64c0ada3@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/10/22 18:40, Hao Xu wrote:
> On 6/11/22 00:10, Pavel Begunkov wrote:
>> On 6/10/22 16:45, Hao Xu wrote:
>>> On 6/10/22 18:21, Pavel Begunkov wrote:
>>>> On 6/8/22 12:12, Hao Xu wrote:
>>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>>
>>>>> Add a new io_hash_bucket structure so that each bucket in cancel_hash
>>>>> has separate spinlock. Use per entry lock for cancel_hash, this removes
>>>>> some completion lock invocation and remove contension between different
>>>>> cancel_hash entries.
>>>>>
>>>>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>>>>> ---
>>>>>
>>>>> v1->v2:
>>>>>   - Add per entry lock for poll/apoll task work code which was missed
>>>>>     in v1
>>>>>   - add an member in io_kiocb to track req's indice in cancel_hash
>>>>>
>>>>> v2->v3:
>>>>>   - make struct io_hash_bucket align with cacheline to avoid cacheline
>>>>>     false sharing.
>>>>>   - re-calculate hash value when deleting an entry from cancel_hash.
>>>>>     (cannot leverage struct io_poll to store the indice since it's
>>>>>      already 64 Bytes)
>>>>>
>>>>>   io_uring/cancel.c         | 14 +++++++--
>>>>>   io_uring/cancel.h         |  6 ++++
>>>>>   io_uring/fdinfo.c         |  9 ++++--
>>>>>   io_uring/io_uring.c       |  8 +++--
>>>>>   io_uring/io_uring_types.h |  2 +-
>>>>>   io_uring/poll.c           | 64 +++++++++++++++++++++------------------
>>>>>   6 files changed, 65 insertions(+), 38 deletions(-)
>>>>>
>>>>> diff --git a/io_uring/cancel.c b/io_uring/cancel.c
>>>>> index 83cceb52d82d..bced5d6b9294 100644
>>>>> --- a/io_uring/cancel.c
>>>>> +++ b/io_uring/cancel.c
>>>>> @@ -93,14 +93,14 @@ int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
>>>>>       if (!ret)
>>>>>           return 0;
>>>>> -    spin_lock(&ctx->completion_lock);
>>>>>       ret = io_poll_cancel(ctx, cd);
>>>>>       if (ret != -ENOENT)
>>>>>           goto out;
>>>>> +    spin_lock(&ctx->completion_lock);
>>>>>       if (!(cd->flags & IORING_ASYNC_CANCEL_FD))
>>>>>           ret = io_timeout_cancel(ctx, cd);
>>>>> -out:
>>>>>       spin_unlock(&ctx->completion_lock);
>>>>> +out:
>>>>>       return ret;
>>>>>   }
>>>>> @@ -192,3 +192,13 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
>>>>>       io_req_set_res(req, ret, 0);
>>>>>       return IOU_OK;
>>>>>   }
>>>>> +
>>>>> +inline void init_hash_table(struct io_hash_bucket *hash_table, unsigned size)
>>>>
>>>> Not inline, it can break builds
>>>>
>>>>> diff --git a/io_uring/cancel.h b/io_uring/cancel.h
>>>>> index 4f35d8696325..b57d6706f84d 100644
>>>>> --- a/io_uring/cancel.h
>>>>> +++ b/io_uring/cancel.h
>>>>> @@ -4,3 +4,9 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
>>>>>   int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
>>>>>   int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd);
>>>>> +inline void init_hash_table(struct io_hash_bucket *hash_table, unsigned size);
>>>>
>>>> And this inline as well
>>>>
>>>>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>>>>> index 0df5eca93b16..515f1727e3c6 100644
>>>>> --- a/io_uring/poll.c
>>>>> +++ b/io_uring/poll.c
>>>> [...]
>>>>>   static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
>>>>>                        struct io_cancel_data *cd)
>>>>> -    __must_hold(&ctx->completion_lock)
>>>>>   {
>>>>> -    struct hlist_head *list;
>>>>>       struct io_kiocb *req;
>>>>> -    list = &ctx->cancel_hash[hash_long(cd->data, ctx->cancel_hash_bits)];
>>>>> -    hlist_for_each_entry(req, list, hash_node) {
>>>>> +    u32 index = hash_long(cd->data, ctx->cancel_hash_bits);
>>>>> +    struct io_hash_bucket *hb = &ctx->cancel_hash[index];
>>>>> +
>>>>> +    spin_lock(&hb->lock);
>>>>> +    hlist_for_each_entry(req, &hb->list, hash_node) {
>>>>>           if (cd->data != req->cqe.user_data)
>>>>>               continue;
>>>>>           if (poll_only && req->opcode != IORING_OP_POLL_ADD)
>>>>> @@ -569,47 +577,48 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
>>>>>                   continue;
>>>>>               req->work.cancel_seq = cd->seq;
>>>>>           }
>>>>> +        spin_unlock(&hb->lock);
>>>>
>>>> The problem here is that after you unlock, nothing keeps the
>>>> request alive. Before it was more like
>>>>
>>>> lock(completion_lock);
>>>> req = poll_find();
>>>> cancel_poll(req);
>>>> unlock(completion_lock);
>>>>
>>>> and was relying on all of this happening under ->completion_lock.
>>>> Now following io_poll_disarm() and/or io_poll_cancel_req() race.
>>>> Same with io_poll_file_find().
>>>
>>> Looks we have to add completion_lock back for cancellation path.
>>
>> It was relying on completion_lock only because it was guarding
>> the hashing, so now find+cancel should happen under the per
>> bucket spins, i.e.
>>
>> lock(buckets[index].lock);
>> req = poll_find();
>> cancel_poll(req);
>> unlock(buckets[index].lock);
>>
>> A bit trickier to code but doable.
> 
> Ah, seems I misunderstood your words, which I'm clear with now.
> Yea, it's a bit odd. I'll think about this issue before taking this
> solution tomorrow.

yeah, it is "a request won't be freed awhile hashed" kind of
synchronisation here.

> Btw, I saw a req->refcount set for poll_add, seems it is not necessary?
> (I haven't check it carefully yet)

In io_poll_add_prep()? Shouldn't be needed, I forgot to kill it
after adding ->poll_refs.

-- 
Pavel Begunkov
