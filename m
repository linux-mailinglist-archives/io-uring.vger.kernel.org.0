Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD7D4D4D7B
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 16:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241160AbiCJPjg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 10:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241390AbiCJPjf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 10:39:35 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D36E8698
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 07:38:33 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id d3so3996822ilr.10
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 07:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=lQB1sA+w30TYL6gKCOpEpyokxqm9padULLz7oxpt5Ks=;
        b=ymbwAG1x2ELhXcvChqTN42Xa4KsIg5x3gjcN1+gBhCm5Zo6e0wbhvV32uNeI4XgP4l
         FIjHAwLX2SnSpaps9CJxFaDaQZtXLp6fiw1gw90wUVZmmGqZTjZO9IMR3e/GUo0GDElZ
         9eUK7P7XOExGyeia5mbKlql0D7/aSRF9Luct06W0HGhOKlbm7PfQEvmf7ysGJSVgsf99
         I9zgKdyfH0ExkTRfvEG2ALKlzWCtBPah2nei89CvaVksOjpTwT5D5qjzqRB8oPRAK72f
         ZeU/DRD4dF7Q2sdID5DK0f0fSP5Gm/EG/r3WP0Z7mGQTMVmze9JImje2Q35v8LR/yxNy
         HxIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lQB1sA+w30TYL6gKCOpEpyokxqm9padULLz7oxpt5Ks=;
        b=adN9LqxMhK07pOoB9/Q5eRt4FJFVtT0SKVkjyRjoDGxj21lIVvWK2JQ5TxWMd9Hxu3
         YPr0vFnMKwv2DyRjwdoYjdzRSCajukZoubpioGmR9sPD9TSiJ2J423DwtLMQn5LxiICn
         DDCafmCgi5w1Bn99YnVJw+7P3h4X9yzWsfo1llJnr23SpCTrdEtJxw5tiqoMclPWbfoF
         Xx91mcHESD07oSJNp8CssyZtCBMTn6tg6Lwz+IiyLn20q1PN/PqGIZyeA1b/Td4IMVnV
         cNW/JW4FPVtdRkYz6oPaVM2NJ80fB2g8OgYJFuJT8oT40n/akPKzTGtEnmNyC1Y5G5wY
         a2Sw==
X-Gm-Message-State: AOAM532jB2C1K41Fh3wxkaMDQu5lQLk5RWHrILpvXX4xw0d6mHkMDSap
        Q3xmo4jcM0/oWW4TNUhzqiKPhhyHIx+k6Frl
X-Google-Smtp-Source: ABdhPJwOCLsxxefqvioesTFuPOaBMHMYqc0ooHVhmeoyzmbqBARFZC+iGdB+7CcWWrEPUEdL8KqfUw==
X-Received: by 2002:a05:6e02:1c28:b0:2c6:6d6e:6db1 with SMTP id m8-20020a056e021c2800b002c66d6e6db1mr4201329ilh.83.1646926712503;
        Thu, 10 Mar 2022 07:38:32 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p10-20020a92c10a000000b002c64b46cd94sm2865457ile.52.2022.03.10.07.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 07:38:32 -0800 (PST)
Message-ID: <83ee4c7d-e222-9760-cd4e-5cf2265d54cf@kernel.dk>
Date:   Thu, 10 Mar 2022 08:38:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
 <f4db0d4c-0ea3-3efa-7e28-bc727b7bc05a@kernel.dk>
 <1f58dbfa-9b1f-5627-89aa-2dda3e2844ab@kernel.dk>
 <c483c170-9bb7-2f97-744a-267b06b2f142@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c483c170-9bb7-2f97-744a-267b06b2f142@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/10/22 6:53 AM, Pavel Begunkov wrote:
> On 3/10/22 02:33, Jens Axboe wrote:
>> On 3/9/22 6:55 PM, Jens Axboe wrote:
>>> On 3/9/22 6:36 PM, Jens Axboe wrote:
>>>> On 3/9/22 4:49 PM, Artyom Pavlov wrote:
>>>>> Greetings!
>>>>>
>>>>> A common approach for multi-threaded servers is to have a number of
>>>>> threads equal to a number of cores and launch a separate ring in each
>>>>> one. AFAIK currently if we want to send an event to a different ring,
>>>>> we have to write-lock this ring, create SQE, and update the index
>>>>> ring. Alternatively, we could use some kind of user-space message
>>>>> passing.
>>>>>
>>>>> Such approaches are somewhat inefficient and I think it can be solved
>>>>> elegantly by updating the io_uring_sqe type to allow accepting fd of a
>>>>> ring to which CQE must be sent by kernel. It can be done by
>>>>> introducing an IOSQE_ flag and using one of currently unused padding
>>>>> u64s.
>>>>>
>>>>> Such feature could be useful for load balancing and message passing
>>>>> between threads which would ride on top of io-uring, i.e. you could
>>>>> send NOP with user_data pointing to a message payload.
>>>>
>>>> So what you want is a NOP with 'fd' set to the fd of another ring, and
>>>> that nop posts a CQE on that other ring? I don't think we'd need IOSQE
>>>> flags for that, we just need a NOP that supports that. I see a few ways
>>>> of going about that:
>>>>
>>>> 1) Add a new 'NOP' that takes an fd, and validates that that fd is an
>>>>     io_uring instance. It can then grab the completion lock on that ring
>>>>     and post an empty CQE.
>>>>
>>>> 2) We add a FEAT flag saying NOP supports taking an 'fd' argument, where
>>>>     'fd' is another ring. Posting CQE same as above.
>>>>
>>>> 3) We add a specific opcode for this. Basically the same as #2, but
>>>>     maybe with a more descriptive name than NOP.
>>>>
>>>> Might make sense to pair that with a CQE flag or something like that, as
>>>> there's no specific user_data that could be used as it doesn't match an
>>>> existing SQE that has been issued. IORING_CQE_F_WAKEUP for example.
>>>> Would be applicable to all the above cases.
>>>>
>>>> I kind of like #3 the best. Add a IORING_OP_RING_WAKEUP command, require
>>>> that sqe->fd point to a ring (could even be the ring itself, doesn't
>>>> matter). And add IORING_CQE_F_WAKEUP as a specific flag for that.
>>>
>>> Something like the below, totally untested. The request will complete on
>>> the original ring with either 0, for success, or -EOVERFLOW if the
>>> target ring was already in an overflow state. If the fd specified isn't
>>> an io_uring context, then the request will complete with -EBADFD.
>>>
>>> If you have any way of testing this, please do. I'll write a basic
>>> functionality test for it as well, but not until tomorrow.
>>>
>>> Maybe we want to include in cqe->res who the waker was? We can stuff the
>>> pid/tid in there, for example.
>>
>> Made the pid change, and also wrote a test case for it. Only change
>> otherwise is adding a completion trace event as well. Patch below
>> against for-5.18/io_uring, and attached the test case for liburing.
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 2e04f718319d..b21f85a48224 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1105,6 +1105,9 @@ static const struct io_op_def io_op_defs[] = {
>>       [IORING_OP_MKDIRAT] = {},
>>       [IORING_OP_SYMLINKAT] = {},
>>       [IORING_OP_LINKAT] = {},
>> +    [IORING_OP_WAKEUP_RING] = {
>> +        .needs_file        = 1,
>> +    },
>>   };
>>     /* requests with any of those set should undergo io_disarm_next() */
>> @@ -4235,6 +4238,44 @@ static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
>>       return 0;
>>   }
>>   +static int io_wakeup_ring_prep(struct io_kiocb *req,
>> +                   const struct io_uring_sqe *sqe)
>> +{
>> +    if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index || sqe->off ||
>> +             sqe->len || sqe->rw_flags || sqe->splice_fd_in ||
>> +             sqe->buf_index || sqe->personality))
>> +        return -EINVAL;
>> +
>> +    if (req->file->f_op != &io_uring_fops)
>> +        return -EBADFD;
>> +
>> +    return 0;
>> +}
>> +
>> +static int io_wakeup_ring(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +    struct io_uring_cqe *cqe;
>> +    struct io_ring_ctx *ctx;
>> +    int ret = 0;
>> +
>> +    ctx = req->file->private_data;
>> +    spin_lock(&ctx->completion_lock);
>> +    cqe = io_get_cqe(ctx);
>> +    if (cqe) {
>> +        WRITE_ONCE(cqe->user_data, 0);
>> +        WRITE_ONCE(cqe->res, 0);
>> +        WRITE_ONCE(cqe->flags, IORING_CQE_F_WAKEUP);
>> +    } else {
>> +        ret = -EOVERFLOW;
>> +    }
> 
> io_fill_cqe_aux(), maybe? Handles overflows better, increments cq_extra,
> etc. Might also make sense to kick cq_timeouts, so waiters are forced to
> wake up.

I think the main question here is if we want to handle overflows at all,
I deliberately didn't do that. But apart from that io_fill_cqe_aux()
does to everything we need.

I guess the nice thing about actually allocating an overflow entry is
that there's no weird error handling on the submitter side. Let's go
with that.

-- 
Jens Axboe

