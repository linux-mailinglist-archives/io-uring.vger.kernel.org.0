Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BFA54C606
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239220AbiFOK02 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbiFOK01 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:26:27 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4776D38DA1
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:26:26 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id h5so14789779wrb.0
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=r4FocqlJ+JxAIBoCO0d5F9wB7uv4n/84nJEZ+zqr0tE=;
        b=q6qJz6JWDKJneH7S7FgMj8XsqSt593FYgQchEXtqcacFiOsB4mvfq2CGTz0Q4FNqJQ
         bgX7aeF7nQIdmT688rIppe26hT63ygA8Lt1zz2NoLOX6LFbL3K5YOYpS9uhkZJBZ5tYA
         valElBoWlHuoC9Yrb/5vapHiAigSSpzmHJDaSwG/Q1mM5IP0ao9hVhzlKiF5jI2xBBys
         nNWgQMH27YKkSwiLT/ciAG+M0+zkvH+GizvNU7sWLI7r1EjtgzjoDsjZ0w1cPRT1AetT
         9QPR1MmRSkhWsoMqQ8lkQunYakF5v5TgdYsVB5fWSfnEGRK5w1v/XxcuxkjyieMiLv5X
         INIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r4FocqlJ+JxAIBoCO0d5F9wB7uv4n/84nJEZ+zqr0tE=;
        b=nJ9prSuQx63QsWSx/7/zWxqetDiAMk5JXZhSHXQRHKH3KudwY6pM9CtunDxsnBad5M
         spsKdnU4qYDH7P3oAEj/LAgTunZLMxsonpRH8/DEJE99kLZkmsOYhVgPVGMG8X/u27hm
         qDx80/CgBNrkoHI5nmAw3YD6SfA0xhIAXRGtIhrHpkYMfkhgj5twLk/shVE4pgHzEq37
         4J9EHYAxVNXxe0geNbrFpegDI8KYbFwPQgM/XRpXoTF98kpODEutgWZ4QBfVy9MXQhlV
         Yl2SRiiSK34CKVa+7mOghT6Ru5IykwqX1UdpIeHpW2+NC0/sy2oC51G5Cej7lh6665i8
         qpJg==
X-Gm-Message-State: AJIora+3BuKdaI9u5D8FZkQcouO7PTmg+zh80GhK7KMWwFV7XT4eK6tH
        7XNcqzwmWyPktUeDqcLMd3Y=
X-Google-Smtp-Source: AGRyM1vqH90qgypXtaceK/Cy63OdVa2KxQmSZI5DeyHQRXtaUdzYbwIZyuN34WEXBNybqR2QGULh3A==
X-Received: by 2002:a5d:5581:0:b0:20f:fc51:7754 with SMTP id i1-20020a5d5581000000b0020ffc517754mr9173998wrv.413.1655288784757;
        Wed, 15 Jun 2022 03:26:24 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id m12-20020a5d6a0c000000b0020cdcb0efa2sm14170151wru.34.2022.06.15.03.26.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 03:26:24 -0700 (PDT)
Message-ID: <e156bf54-3bdf-b03b-2737-7e02b2762111@gmail.com>
Date:   Wed, 15 Jun 2022 11:26:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next v2 21/25] io_uring: add
 IORING_SETUP_SINGLE_ISSUER
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <d6235e12830a225584b90cf3b29f09a0681acc95.1655213915.git.asml.silence@gmail.com>
 <40197f84-35e3-4e37-fe73-3c7f4c21d513@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <40197f84-35e3-4e37-fe73-3c7f4c21d513@linux.dev>
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

On 6/15/22 10:41, Hao Xu wrote:
> On 6/14/22 22:37, Pavel Begunkov wrote:
>> Add a new IORING_SETUP_SINGLE_ISSUER flag and the userspace visible part
>> of it, i.e. put limitations of submitters. Also, don't allow it together
>> with IOPOLL as we're not going to put it to good use.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   include/uapi/linux/io_uring.h |  5 ++++-
>>   io_uring/io_uring.c           |  7 +++++--
>>   io_uring/io_uring_types.h     |  1 +
>>   io_uring/tctx.c               | 27 ++++++++++++++++++++++++---
>>   io_uring/tctx.h               |  4 ++--
>>   5 files changed, 36 insertions(+), 8 deletions(-)
>>
[...]
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 15d209f334eb..4b90439808e3 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -3020,6 +3020,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
>>       io_destroy_buffers(ctx);
>>       if (ctx->sq_creds)
>>           put_cred(ctx->sq_creds);
>> +    if (ctx->submitter_task)
>> +        put_task_struct(ctx->submitter_task);
>>       /* there are no registered resources left, nobody uses it */
>>       if (ctx->rsrc_node)
>> @@ -3752,7 +3754,7 @@ static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
>>       if (fd < 0)
>>           return fd;
>> -    ret = io_uring_add_tctx_node(ctx);
>> +    ret = __io_uring_add_tctx_node(ctx, false);

                                             ^^^^^^

Note this one


>>       if (ret) {
>>           put_unused_fd(fd);
>>           return ret;
>> @@ -3972,7 +3974,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
>>               IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
>>               IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
>>               IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
>> -            IORING_SETUP_SQE128 | IORING_SETUP_CQE32))
>> +            IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
>> +            IORING_SETUP_SINGLE_ISSUER))
>>           return -EINVAL;
>>       return io_uring_create(entries, &p, params);
>> diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
>> index aba0f8cd6f49..f6d0ad25f377 100644
>> --- a/io_uring/io_uring_types.h
>> +++ b/io_uring/io_uring_types.h
>> @@ -241,6 +241,7 @@ struct io_ring_ctx {
>>       /* Keep this last, we don't need it for the fast path */
>>       struct io_restriction        restrictions;
>> +    struct task_struct        *submitter_task;
>>       /* slow path rsrc auxilary data, used by update/register */
>>       struct io_rsrc_node        *rsrc_backup_node;
>> diff --git a/io_uring/tctx.c b/io_uring/tctx.c
>> index 6adf659687f8..012be261dc50 100644
>> --- a/io_uring/tctx.c
>> +++ b/io_uring/tctx.c
>> @@ -81,12 +81,32 @@ __cold int io_uring_alloc_task_context(struct task_struct *task,
>>       return 0;
>>   }
>> -int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
>> +static int io_register_submitter(struct io_ring_ctx *ctx)
>> +{
>> +    int ret = 0;
>> +
>> +    mutex_lock(&ctx->uring_lock);
>> +    if (!ctx->submitter_task)
>> +        ctx->submitter_task = get_task_struct(current);
>> +    else if (ctx->submitter_task != current)
>> +        ret = -EEXIST;
>> +    mutex_unlock(&ctx->uring_lock);
>> +
>> +    return ret;
>> +}
> 
> Seems we don't need this uring_lock:
> When we create a ring, we setup ctx->submitter_task before uring fd is
> installed so at that time nobody else can enter this code.
> when we enter this code later in io_uring_enter, we just read it.

Not really, we specifically don't set it just to the ring's
creator but to the first submitter. That's needed to be able to
create a ring in one task and pass it over to another.

-- 
Pavel Begunkov
