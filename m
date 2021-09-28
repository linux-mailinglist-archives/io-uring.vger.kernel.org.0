Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFC841AC23
	for <lists+io-uring@lfdr.de>; Tue, 28 Sep 2021 11:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239977AbhI1Jny (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Sep 2021 05:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239549AbhI1Jny (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Sep 2021 05:43:54 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEADEC061575
        for <io-uring@vger.kernel.org>; Tue, 28 Sep 2021 02:42:14 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r23so31565358wra.6
        for <io-uring@vger.kernel.org>; Tue, 28 Sep 2021 02:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bXv22yzSHLAWR0sUiecehOsdPzSKuB8d+5xhJF3RHWk=;
        b=SwQpMH0jMTZvDjeBUDcarAuM+y5ks423CPizdLELVo50I2CkSbuVKA+ljC752GP6qv
         xj7BY4bmZD8lRADOyBxl3my0h1F3oA/p/7/B8qdMMwbVBqFIs/nci4tDav6E9cz0Rmeg
         6fBgkeFJT4kwt++WZ4klbYmvI3HCQ6fMSmfn8UFSsSqQ6EfJ7nRkCgirFvj0fqSkSu9C
         HX1qfPPPGw9SsdFdq3SpXYHCx0qT6IAONfQJaPzPRHStyAjIwJ3+taBpGYgKP2OyFNlU
         JWwmfSQop9fj0x5oik48PrHqvys2cUlpaROV9Jk1BxJCFHM0Wr8LIjr0dyU6xvrBOSEU
         KWfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bXv22yzSHLAWR0sUiecehOsdPzSKuB8d+5xhJF3RHWk=;
        b=nbafeVa55UsTHHhV/mvYQDvGRJxMhpWkmBK/3kNc/+1XPSu91qAK2vhSjhL8lr8/Ve
         eBFzWW/g/KJPFg5JRL9gXQA7IjrOrIX/XJRNGK9kr+ClDKAn1oXY45ojdHxIgfeBuI5K
         gCvJUVmQWfucrE9fkAg188k2CyZQe0/zM514fbAyjZUplVTH4WMpPsRunIuU1/wXc7T2
         YnXZpFMpVGpkpIp7YOTwjtMXq5JIZDBuvl4lItrXysq0aTpuW7zLr1hqvIzYy+ebPywT
         9VkNUb7+Chzg07rHeidlLGwWATaJhOhsgdJQtwlgthIlyoem+oMclYYsyBODRor8n+/B
         1Y2w==
X-Gm-Message-State: AOAM5300WhmrFI4Rv38M/Tqvno5F1lAK88fdf31cA10uI0uVXKMtiTaA
        nQ2qVYYlGcwKwIdvuzvmEz5ixjzxq04=
X-Google-Smtp-Source: ABdhPJw1ZIg50mBF4W8Ozp8MrGyIRkWkdcXIwh47+TqW1sv9ezGaltMy9hCZwmIbFg2jpDG4nwveyQ==
X-Received: by 2002:adf:a10f:: with SMTP id o15mr5372725wro.286.1632822133118;
        Tue, 28 Sep 2021 02:42:13 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.229])
        by smtp.gmail.com with ESMTPSA id z12sm2074008wmf.21.2021.09.28.02.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 02:42:12 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1632516769.git.asml.silence@gmail.com>
 <a666826f2854d17e9fb9417fb302edfeb750f425.1632516769.git.asml.silence@gmail.com>
 <c4b3163b-fc75-059e-1cc9-2b5ed9ce93a3@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v2 04/24] io_uring: use slist for completion batching
Message-ID: <f3631cc8-59e9-3a82-1982-1ee5f84f4674@gmail.com>
Date:   Tue, 28 Sep 2021 10:41:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <c4b3163b-fc75-059e-1cc9-2b5ed9ce93a3@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/21 7:57 AM, Hao Xu wrote:
> 在 2021/9/25 上午4:59, Pavel Begunkov 写道:
>> Currently we collect requests for completion batching in an array.
>> Replace them with a singly linked list. It's as fast as arrays but
>> doesn't take some much space in ctx, and will be used in future patches.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   fs/io_uring.c | 52 +++++++++++++++++++++++++--------------------------
>>   1 file changed, 25 insertions(+), 27 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 9c14e9e722ba..9a76c4f84311 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -322,8 +322,8 @@ struct io_submit_state {
>>       /*
>>        * Batch completion logic
>>        */
>> -    struct io_kiocb        *compl_reqs[IO_COMPL_BATCH];
>> -    unsigned int        compl_nr;
>> +    struct io_wq_work_list    compl_reqs;
> Will it be better to rename struct io_wq_work_list to something more
> generic, io_wq_work_list is a bit confused, we are now using this
> type of linked list (stack as well) for various aim, not just to link
> iowq works.

Was thinking about it, e.g. io_slist, but had been already late --
lots of conflicts and a good chance to add a couple of extra bugs
on rebase. I think we can do it afterward (if ever considering
it troubles backporting)


>> +
>>       /* inline/task_work completion list, under ->uring_lock */
>>       struct list_head    free_list;
>>   };
>> @@ -883,6 +883,8 @@ struct io_kiocb {
>>       struct io_wq_work        work;
>>       const struct cred        *creds;
>>   +    struct io_wq_work_node        comp_list;
>> +
>>       /* store used ubuf, so we can prevent reloading */
>>       struct io_mapped_ubuf        *imu;
>>   };
>> @@ -1169,7 +1171,7 @@ static inline void req_ref_get(struct io_kiocb *req)
>>     static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
>>   {
>> -    if (ctx->submit_state.compl_nr)
>> +    if (!wq_list_empty(&ctx->submit_state.compl_reqs))
>>           __io_submit_flush_completions(ctx);
>>   }
>>   @@ -1326,6 +1328,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>>       INIT_LIST_HEAD(&ctx->submit_state.free_list);
>>       INIT_LIST_HEAD(&ctx->locked_free_list);
>>       INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
>> +    INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
>>       return ctx;
>>   err:
>>       kfree(ctx->dummy_ubuf);
>> @@ -1831,11 +1834,16 @@ static inline bool io_req_needs_clean(struct io_kiocb *req)
>>   static void io_req_complete_state(struct io_kiocb *req, long res,
>>                     unsigned int cflags)
>>   {
>> +    struct io_submit_state *state;
>> +
>>       if (io_req_needs_clean(req))
>>           io_clean_op(req);
>>       req->result = res;
>>       req->compl.cflags = cflags;
>>       req->flags |= REQ_F_COMPLETE_INLINE;
>> +
>> +    state = &req->ctx->submit_state;
>> +    wq_list_add_tail(&req->comp_list, &state->compl_reqs);
>>   }
>>     static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
>> @@ -2324,13 +2332,14 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
>>   static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>>       __must_hold(&ctx->uring_lock)
>>   {
>> +    struct io_wq_work_node *node, *prev;
>>       struct io_submit_state *state = &ctx->submit_state;
>> -    int i, nr = state->compl_nr;
>>       struct req_batch rb;
>>         spin_lock(&ctx->completion_lock);
>> -    for (i = 0; i < nr; i++) {
>> -        struct io_kiocb *req = state->compl_reqs[i];
>> +    wq_list_for_each(node, prev, &state->compl_reqs) {
>> +        struct io_kiocb *req = container_of(node, struct io_kiocb,
>> +                            comp_list);
>>             __io_cqring_fill_event(ctx, req->user_data, req->result,
>>                       req->compl.cflags);
>> @@ -2340,15 +2349,18 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>>       io_cqring_ev_posted(ctx);
>>         io_init_req_batch(&rb);
>> -    for (i = 0; i < nr; i++) {
>> -        struct io_kiocb *req = state->compl_reqs[i];
>> +    node = state->compl_reqs.first;
>> +    do {
>> +        struct io_kiocb *req = container_of(node, struct io_kiocb,
>> +                            comp_list);
>>   +        node = req->comp_list.next;
>>           if (req_ref_put_and_test(req))
>>               io_req_free_batch(&rb, req, &ctx->submit_state);
>> -    }
>> +    } while (node);
>>         io_req_free_batch_finish(ctx, &rb);
>> -    state->compl_nr = 0;
>> +    INIT_WQ_LIST(&state->compl_reqs);
>>   }
>>     /*
>> @@ -2668,17 +2680,10 @@ static void io_req_task_complete(struct io_kiocb *req, bool *locked)
>>       unsigned int cflags = io_put_rw_kbuf(req);
>>       long res = req->result;
>>   -    if (*locked) {
>> -        struct io_ring_ctx *ctx = req->ctx;
>> -        struct io_submit_state *state = &ctx->submit_state;
>> -
>> +    if (*locked)
>>           io_req_complete_state(req, res, cflags);
>> -        state->compl_reqs[state->compl_nr++] = req;
>> -        if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
>> -            io_submit_flush_completions(ctx);
>> -    } else {
>> +    else
>>           io_req_complete_post(req, res, cflags);
>> -    }
>>   }
>>     static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
>> @@ -6969,15 +6974,8 @@ static void __io_queue_sqe(struct io_kiocb *req)
>>        * doesn't support non-blocking read/write attempts
>>        */
>>       if (likely(!ret)) {
>> -        if (req->flags & REQ_F_COMPLETE_INLINE) {
>> -            struct io_ring_ctx *ctx = req->ctx;
>> -            struct io_submit_state *state = &ctx->submit_state;
>> -
>> -            state->compl_reqs[state->compl_nr++] = req;
>> -            if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
>> -                io_submit_flush_completions(ctx);
>> +        if (req->flags & REQ_F_COMPLETE_INLINE)
>>               return;
>> -        }
>>             linked_timeout = io_prep_linked_timeout(req);
>>           if (linked_timeout)
>>
> 

-- 
Pavel Begunkov
