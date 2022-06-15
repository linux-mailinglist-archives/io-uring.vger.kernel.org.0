Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C171D54CA6B
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 15:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349312AbiFONzp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 09:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349036AbiFONzo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 09:55:44 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5506926115
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 06:55:43 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id x17so15488588wrg.6
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 06:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qXeHOflVLSXvx++baP7VY4v3qOtX+J/2U0Djl2oVZKU=;
        b=XAKWYLqAIhn+ecMx9LjWX0NOY//3qCj0d8/iaU6SgMSyfj0CvAeXNjX7WiQnrnkEZk
         sAcmbCHiJXfIex/duKkEAFcvS55EfHghRQ/F4jmG8AYxlJ12Adwrl+t3WGpeC/X4d//M
         8BNUAtxpWGln1pAsIG+3Pri8LfCwoCD1eeFbLeOFB1Y0U5Wpikqvo49HlntSOqlfpp63
         t3smu8kM9sI+wwM8JKTji03dJ+yDkcLfWOe1HbL2c/nr1FnebcXcpTn/TtIsxj48L7JC
         Ecny2uS4JWQ68xmDCHnNAo914B25y9gMKmcbJnr/J/Z8U1Hxo3T6oVlCnXit7FBnfh0F
         uY/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qXeHOflVLSXvx++baP7VY4v3qOtX+J/2U0Djl2oVZKU=;
        b=NDSmAVRB90aEN39UYC04ySIg3XFKbVuweuDzR/pjpiEdH0ggyYO/zk9CSi/tAzQWPH
         Z+MUJ9cnqscy2DNErvQhXmx8sEvhjA4g6bs7LTiMIGaQcGPdiYtqb6QdlDBoOzoluOnH
         NUNcZKdjeKu/C0wxozIw52+sRtalORbzGOeyrEJvUn9mGpg34Q4E1PK3US3sUBokUqNj
         edwyf/OdRrQ0xU60X/FcJRMDtj+6t1UAI8M9xASpIBLgGGbrZ/bJ5SQuXuTxRAhYdj73
         OZ6i7hPsYbCO6OROd2/IDutjR9hwCGjlA3kRFGYulE0+Ql9hy8GnCM6gwkYg4VgSk4vj
         3OBw==
X-Gm-Message-State: AJIora+lRzaq3ZLTcxnc0YtMjpBb6E7VM/YfSOu7FrFDfl0X5Q2eCzCu
        KldOWrH6emtxepF9Jh30K9Q=
X-Google-Smtp-Source: AGRyM1uw9SrhSMjPatplq9Y2IoVYvQiIdBjayyBQiUqvXRldkcXcOXw4thH8oDTX359H97tSM+xmug==
X-Received: by 2002:a5d:648a:0:b0:217:3552:eb2d with SMTP id o10-20020a5d648a000000b002173552eb2dmr10065457wri.78.1655301341723;
        Wed, 15 Jun 2022 06:55:41 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id d7-20020a05600c3ac700b0039c60e33702sm2404723wms.16.2022.06.15.06.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 06:55:41 -0700 (PDT)
Message-ID: <bff22d5f-239e-d388-d44e-a26fb69af38d@gmail.com>
Date:   Wed, 15 Jun 2022 14:55:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next v2 25/25] io_uring: mutex locked poll hashing
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <b3250f21371e91e43ff488bc695240630cb21667.1655213915.git.asml.silence@gmail.com>
 <419df2b2-8b62-15f8-fc26-251b1337a59a@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <419df2b2-8b62-15f8-fc26-251b1337a59a@linux.dev>
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

On 6/15/22 13:53, Hao Xu wrote:
> On 6/14/22 22:37, Pavel Begunkov wrote:
>> Currently we do two extra spin lock/unlock pairs to add a poll/apoll
>> request to the cancellation hash table and remove it from there.
>>
>> On the submission side we often already hold ->uring_lock and tw
>> completion is likely to hold it as well. Add a second cancellation hash
>> table protected by ->uring_lock. In concerns for latency because of a
>> need to have the mutex locked on the completion side, use the new table
>> only in following cases:
>>
>> 1) IORING_SETUP_SINGLE_ISSUER: only one task grabs uring_lock, so there
>>     is no contention and so the main tw hander will always end up
>>     grabbing it before calling into callbacks.
> 
> This statement seems not true, the io-worker may grab the uring lock,
> and that's why the [1] place I marked below is needed, right? Or do I
> miss something?

Ok, "almost always ends up ...". The thing is io-wq is discouraged
taking the lock and if it does can do only briefly and without any
blocking/waiting. So yeah, it might be not taken at [1] but it's
rather unlikely.


>> 2) IORING_SETUP_SQPOLL: same as with single issuer, only one task is
>>     using ->uring_lock.
> 
> same as above.
> 
>>
>> 3) apoll: we normally grab the lock on the completion side anyway to
>>     execute the request, so it's free.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/io_uring.c       |   9 +++-
>>   io_uring/io_uring_types.h |   4 ++
>>   io_uring/poll.c           | 111 ++++++++++++++++++++++++++++++--------
>>   3 files changed, 102 insertions(+), 22 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 4bead16e57f7..1395176bc2ea 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -731,6 +731,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>>       hash_bits = clamp(hash_bits, 1, 8);
>>       if (io_alloc_hash_table(&ctx->cancel_table, hash_bits))
>>           goto err;
>> +    if (io_alloc_hash_table(&ctx->cancel_table_locked, hash_bits))
>> +        goto err;
>>       ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
>>       if (!ctx->dummy_ubuf)
>> @@ -773,6 +775,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>>   err:
>>       kfree(ctx->dummy_ubuf);
>>       kfree(ctx->cancel_table.hbs);
>> +    kfree(ctx->cancel_table_locked.hbs);
>>       kfree(ctx->io_bl);
>>       xa_destroy(&ctx->io_bl_xa);
>>       kfree(ctx);
>> @@ -3056,6 +3059,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
>>       if (ctx->hash_map)
>>           io_wq_put_hash(ctx->hash_map);
>>       kfree(ctx->cancel_table.hbs);
>> +    kfree(ctx->cancel_table_locked.hbs);
>>       kfree(ctx->dummy_ubuf);
>>       kfree(ctx->io_bl);
>>       xa_destroy(&ctx->io_bl_xa);
>> @@ -3217,12 +3221,13 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
>>           __io_cqring_overflow_flush(ctx, true);
>>       xa_for_each(&ctx->personalities, index, creds)
>>           io_unregister_personality(ctx, index);
>> +    if (ctx->rings)
>> +        io_poll_remove_all(ctx, NULL, true);
>>       mutex_unlock(&ctx->uring_lock);
>>       /* failed during ring init, it couldn't have issued any requests */
>>       if (ctx->rings) {
>>           io_kill_timeouts(ctx, NULL, true);
>> -        io_poll_remove_all(ctx, NULL, true);
>>           /* if we failed setting up the ctx, we might not have any rings */
>>           io_iopoll_try_reap_events(ctx);
>>       }
>> @@ -3347,7 +3352,9 @@ static __cold void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>>           }
>>           ret |= io_cancel_defer_files(ctx, task, cancel_all);
>> +        mutex_lock(&ctx->uring_lock);
>>           ret |= io_poll_remove_all(ctx, task, cancel_all);
>> +        mutex_unlock(&ctx->uring_lock);
>>           ret |= io_kill_timeouts(ctx, task, cancel_all);
>>           if (task)
>>               ret |= io_run_task_work();
>> diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
>> index ce2fbe6749bb..557b8e7719c9 100644
>> --- a/io_uring/io_uring_types.h
>> +++ b/io_uring/io_uring_types.h
>> @@ -189,6 +189,7 @@ struct io_ring_ctx {
>>           struct xarray        io_bl_xa;
>>           struct list_head    io_buffers_cache;
>> +        struct io_hash_table    cancel_table_locked;
>>           struct list_head    cq_overflow_list;
>>           struct list_head    apoll_cache;
>>           struct xarray        personalities;
>> @@ -323,6 +324,7 @@ enum {
>>       /* keep async read/write and isreg together and in order */
>>       REQ_F_SUPPORT_NOWAIT_BIT,
>>       REQ_F_ISREG_BIT,
>> +    REQ_F_HASH_LOCKED_BIT,
>>       /* not a real bit, just to check we're not overflowing the space */
>>       __REQ_F_LAST_BIT,
>> @@ -388,6 +390,8 @@ enum {
>>       REQ_F_APOLL_MULTISHOT    = BIT(REQ_F_APOLL_MULTISHOT_BIT),
>>       /* recvmsg special flag, clear EPOLLIN */
>>       REQ_F_CLEAR_POLLIN    = BIT(REQ_F_CLEAR_POLLIN_BIT),
>> +    /* hashed into ->cancel_hash_locked */
>> +    REQ_F_HASH_LOCKED    = BIT(REQ_F_HASH_LOCKED_BIT),
>>   };
>>   typedef void (*io_req_tw_func_t)(struct io_kiocb *req, bool *locked);
>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>> index 07157da1c2cb..d20484c1cbb7 100644
>> --- a/io_uring/poll.c
>> +++ b/io_uring/poll.c
>> @@ -93,6 +93,26 @@ static void io_poll_req_delete(struct io_kiocb *req, struct io_ring_ctx *ctx)
>>       spin_unlock(lock);
>>   }
>> +static void io_poll_req_insert_locked(struct io_kiocb *req)
>> +{
>> +    struct io_hash_table *table = &req->ctx->cancel_table_locked;
>> +    u32 index = hash_long(req->cqe.user_data, table->hash_bits);
>> +
>> +    hlist_add_head(&req->hash_node, &table->hbs[index].list);
>> +}
>> +
>> +static void io_poll_tw_hash_eject(struct io_kiocb *req, bool *locked)
>> +{
>> +    struct io_ring_ctx *ctx = req->ctx;
>> +
>> +    if (req->flags & REQ_F_HASH_LOCKED) {
>> +        io_tw_lock(ctx, locked);
> 
>                            [1]
> 
>> +        hash_del(&req->hash_node);
>> +    } else {
>> +        io_poll_req_delete(req, ctx);
>> +    }
>> +}
>> +

-- 
Pavel Begunkov
