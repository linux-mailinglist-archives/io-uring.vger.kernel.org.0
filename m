Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9734D41C33B
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 13:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245020AbhI2LS7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 07:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244819AbhI2LS6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 07:18:58 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DE1C06161C
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 04:17:17 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id t18so3697836wrb.0
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 04:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KIHAQPzB32kdsKIPUnviddp1W6urBxMnt0fo244HMq4=;
        b=JJhoJ/u0ugeF0Ta9BVNAVG7DX/9MuyRDUyRz3eY9oPQ1guJrszqf3nBuAjev4J28St
         Nvst5whfSaot1fD68CI3awENRnLKTLvUY1qeui/enS6xBBbKn8pXdyMLAi4JH6uauAeV
         yMH/KHp2cM7xwryXNDomHBvxe0FcMB1TgxMGRme9d948JWVxPpWursU0mgo7X+7v3nLF
         xGNtkLSZlccF4naCynidlAkFUcp8LC+5Xr9maJuTnqkWmndj8iPDmzXQ7w4C2U4FH/Tn
         qAn3EXre0xkmIYQhtIdYTLJjtlNqJVa3qFKA3tTkVUpT0Gx0KNOC0H7dnRcuIsFuKuKu
         8j3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KIHAQPzB32kdsKIPUnviddp1W6urBxMnt0fo244HMq4=;
        b=hDknyLiQjBXxqQiayVycNHkp6/eeMDwcUrlUMmd/eu6HFsvZFhiRagQg9b1BfPo5BJ
         kr2zPicRgb+C7JDwISWI6NfcrHQsmkld8/Tlq8rR2hGdhyh2MdI0vZ/WTj7UBEF3iUa1
         n0qk20ojnS9TXs3jgUFBQiDUzwXCqkFwvOrWstofmYxwgQQ1tgmZufFvSaRwwybP1wKJ
         4yO7Zg0WlI7OoaPn2/9jV7p/QZWwlDrCy0iFNsPALQk4ZoLdXgqZYR5vN3iV+AWmAuqS
         I3Q2eZ1Sf/J4xp5CJGy3vaQ4ubVJTeVOpqZ1P99aPngUioMRSCqWaJVNFUSq6rdiyukO
         AWLQ==
X-Gm-Message-State: AOAM533Nc2Ve1v5AsQrjlSTTOmvrsS3QF7vU2YNmadx3AN7x/PNdOT/8
        m5IOqEmklRX6rAR6G2vIgsI=
X-Google-Smtp-Source: ABdhPJyu0dXAfZ1Ikbk2MbnCel5L7ZOvflFuZ7t0VVJZckR6Pi1XDIqKiEa5gTK/EdNxGhWHIuDVTg==
X-Received: by 2002:adf:fe8c:: with SMTP id l12mr6146948wrr.210.1632914235781;
        Wed, 29 Sep 2021 04:17:15 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.229])
        by smtp.gmail.com with ESMTPSA id z8sm2277167wrm.63.2021.09.29.04.17.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 04:17:14 -0700 (PDT)
Subject: Re: [PATCH 1/2] io_uring: fix tw list mess-up by adding tw while it's
 already in tw list
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210912162345.51651-1-haoxu@linux.alibaba.com>
 <20210912162345.51651-2-haoxu@linux.alibaba.com>
 <6b9d818b-468e-e409-8dc1-9d4bd586635e@gmail.com>
 <665861ee-7688-73ca-e553-177df4159cff@linux.alibaba.com>
 <3b22fef3-8a08-2954-6288-8d43b7434745@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <dd96a690-2505-6217-ebc7-03b23f14950e@gmail.com>
Date:   Wed, 29 Sep 2021 12:16:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <3b22fef3-8a08-2954-6288-8d43b7434745@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/21 10:48 AM, Hao Xu wrote:
> 在 2021/9/15 下午6:48, Hao Xu 写道:
>> 在 2021/9/15 下午5:44, Pavel Begunkov 写道:
>>> On 9/12/21 5:23 PM, Hao Xu wrote:
>>>> For multishot mode, there may be cases like:
>>>> io_poll_task_func()
>>>> -> add_wait_queue()
>>>>                              async_wake()
>>>>                              ->io_req_task_work_add()
>>>>                              this one mess up the running task_work list
>>>>                              since req->io_task_work.node is in use.
>>>>
>>>> similar situation for req->io_task_work.fallback_node.
>>>> Fix it by set node->next = NULL before we run the tw, so that when we
>>>> add req back to the wait queue in middle of tw running, we can safely
>>>> re-add it to the tw list.
>>>
>>> It may get screwed before we get to "node->next = NULL;",
>>>
>>> -> async_wake()
>>>    -> io_req_task_work_add()
>>> -> async_wake()
>>>    -> io_req_task_work_add()
>>> tctx_task_work()
>> True, this may happen if there is second poll wait entry.
>> This pacth is for single wait entry only..
>> I'm thinking about the second poll entry issue, would be in a separate
>> patch.
> hmm, reviewed this email again and now I think I got what you were
> saying, do you mean the second async_wake() triggered before we removed
> the wait entry in the first async_wake(), like
> 
> async_wake
>                           async_wake
> ->del wait entry

Looks we had different problems in mind, let's move the conversation to
the new thread with resent patches



>>>> Fixes: 7cbf1722d5fc ("io_uring: provide FIFO ordering for task_work")
>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>> ---
>>>>
>>>>   fs/io_uring.c | 11 ++++++++---
>>>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 30d959416eba..c16f6be3d46b 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -1216,13 +1216,17 @@ static void io_fallback_req_func(struct work_struct *work)
>>>>       struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
>>>>                           fallback_work.work);
>>>>       struct llist_node *node = llist_del_all(&ctx->fallback_llist);
>>>> -    struct io_kiocb *req, *tmp;
>>>> +    struct io_kiocb *req;
>>>>       bool locked = false;
>>>>       percpu_ref_get(&ctx->refs);
>>>> -    llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
>>>> +    req = llist_entry(node, struct io_kiocb, io_task_work.fallback_node);
>>>> +    while (member_address_is_nonnull(req, io_task_work.fallback_node)) {
>>>> +        node = req->io_task_work.fallback_node.next;
>>>> +        req->io_task_work.fallback_node.next = NULL;
>>>>           req->io_task_work.func(req, &locked);
>>>> -
>>>> +        req = llist_entry(node, struct io_kiocb, io_task_work.fallback_node);
>>>> +    }
>>>>       if (locked) {
>>>>           if (ctx->submit_state.compl_nr)
>>>>               io_submit_flush_completions(ctx);
>>>> @@ -2126,6 +2130,7 @@ static void tctx_task_work(struct callback_head *cb)
>>>>                   locked = mutex_trylock(&ctx->uring_lock);
>>>>                   percpu_ref_get(&ctx->refs);
>>>>               }
>>>> +            node->next = NULL;
>>>>               req->io_task_work.func(req, &locked);
>>>>               node = next;
>>>>           } while (node);
>>>>
>>>
> 

-- 
Pavel Begunkov
