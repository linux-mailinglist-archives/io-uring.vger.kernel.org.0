Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A272596E95
	for <lists+io-uring@lfdr.de>; Wed, 17 Aug 2022 14:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiHQMoC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Aug 2022 08:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236031AbiHQMn6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Aug 2022 08:43:58 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA108993B
        for <io-uring@vger.kernel.org>; Wed, 17 Aug 2022 05:43:57 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a4so4348829wrq.1
        for <io-uring@vger.kernel.org>; Wed, 17 Aug 2022 05:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=McHvWOV7iurMIqwqIUkr2jLZCyZx5oOqneSxd1U0LZM=;
        b=oS/bJ0coRbxx32LWunbds6XLNwAmrtP2QCMo77B+e4pHKqWcECW1jJkOi+yyOX5oAt
         IpogtK6ubL92pC325tV2cLLC2dH9fX8lpILCT6atWqb0hdZKWM3S2NzIiMPBsuyl+FQE
         d8fU2j3j4k5xuRau5xLpWjoemfnvMnPj1k4uhREWqURWPYYi24qpY4SwNt8ibRAZCi3v
         sESsWiGLtDZcqzKuIRrNlQRuYwhC47mXfFcX/4OT8qTt5dUEZvml19+JpsbwrFMaa5wo
         ml4reyrT8sef/AnZhmwgsCUiR7M9A3KCLHQVpnPCN7bYn+uuOQHINYUFCTlNnK8AMcsk
         hxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=McHvWOV7iurMIqwqIUkr2jLZCyZx5oOqneSxd1U0LZM=;
        b=PVG4TfqApTJZ/AyrE2ZfKtPF0jo25iZwfIBIrAamZKVpy8xS3LF0xbZuS9KsBJiN6z
         pJdxieaLR6B4YwxvdFw5rOz2VWEpzX/1FSyQHXxZFV5Cxq6dHSAtRQo6zfBqtHONbuIT
         t4Njq102wZGKda4BlQrwjN/+LTxZ3FTYWJBuEVysysngzJylvpOa9458+rmpPFsoQwhW
         sxzi4HLHao3tLcH+GawmpSCCicPLRu35y16CA+u6KjCloosc+g8FjtNyTiZkkrjpUo9g
         6kFjyyySejvEnOE4GvNvOiezFKMyY4VBnwzDYNSd6JAQEL9vBo3bp4I9fTd4eI1cYW3e
         eBzw==
X-Gm-Message-State: ACgBeo2ebRwFyTd6oNXZx3WZDi8zSCmibzOjtiZiPXInsYxtn4pQBFY0
        yeFo2sEdfJi4dww9Z59SMV2k19EglkY=
X-Google-Smtp-Source: AA6agR49ZqTIfODH4ovtwBrfGlcLsDNoEOkbsdFfFrRjM7LIO0yGJjFNPnQa1zNa1NkLY+1oN34QPQ==
X-Received: by 2002:a5d:4dcb:0:b0:220:60c0:dc4b with SMTP id f11-20020a5d4dcb000000b0022060c0dc4bmr14134068wru.401.1660740235849;
        Wed, 17 Aug 2022 05:43:55 -0700 (PDT)
Received: from [192.168.8.198] (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id v5-20020a05600c214500b003a536d5aa2esm2029966wml.11.2022.08.17.05.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 05:43:55 -0700 (PDT)
Message-ID: <9b998187-b985-2938-1494-0bc8c189a3b6@gmail.com>
Date:   Wed, 17 Aug 2022 13:42:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC 2/2] io_uring/net: allow to override notification tag
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>
References: <cover.1660635140.git.asml.silence@gmail.com>
 <6aa0c662a3fec17a1ade512e7bbb519aa49e6e4d.1660635140.git.asml.silence@gmail.com>
 <bf3d5a0f-c337-f6f3-8bf4-b8665f92acaa@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bf3d5a0f-c337-f6f3-8bf4-b8665f92acaa@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/22 09:23, Stefan Metzmacher wrote:
> Am 16.08.22 um 09:42 schrieb Pavel Begunkov:
>> Considering limited amount of slots some users struggle with
>> registration time notification tag assignment as it's hard to manage
>> notifications using sequence numbers. Add a simple feature that copies
>> sqe->user_data of a send(+flush) request into the notification CQE it
>> flushes (and only when it's flushes).
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   include/uapi/linux/io_uring.h | 4 ++++
>>   io_uring/net.c                | 6 +++++-
>>   2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 20368394870e..91e7944c9c78 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -280,11 +280,15 @@ enum io_uring_op {
>>    *
>>    * IORING_RECVSEND_NOTIF_FLUSH    Flush a notification after a successful
>>    *                successful. Only for zerocopy sends.
>> + *
>> + * IORING_RECVSEND_NOTIF_COPY_TAG Copy request's user_data into the notification
>> + *                  completion even if it's flushed.
>>    */
>>   #define IORING_RECVSEND_POLL_FIRST    (1U << 0)
>>   #define IORING_RECV_MULTISHOT        (1U << 1)
>>   #define IORING_RECVSEND_FIXED_BUF    (1U << 2)
>>   #define IORING_RECVSEND_NOTIF_FLUSH    (1U << 3)
>> +#define IORING_RECVSEND_NOTIF_COPY_TAG    (1U << 4)
>>   /* cqe->res mask for extracting the notification sequence number */
>>   #define IORING_NOTIF_SEQ_MASK        0xFFFFU
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index bd3fad9536ef..4d271a269979 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -858,7 +858,9 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>       zc->flags = READ_ONCE(sqe->ioprio);
>>       if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
>> -              IORING_RECVSEND_FIXED_BUF | IORING_RECVSEND_NOTIF_FLUSH))
>> +              IORING_RECVSEND_FIXED_BUF |
>> +              IORING_RECVSEND_NOTIF_FLUSH |
>> +              IORING_RECVSEND_NOTIF_COPY_TAG))
>>           return -EINVAL;
>>       if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
>>           unsigned idx = READ_ONCE(sqe->buf_index);
>> @@ -1024,6 +1026,8 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
>>           if (ret == -ERESTARTSYS)
>>               ret = -EINTR;
>>       } else if (zc->flags & IORING_RECVSEND_NOTIF_FLUSH) {
>> +        if (zc->flags & IORING_RECVSEND_NOTIF_COPY_TAG)
>> +            notif->cqe.user_data = req->cqe.user_data;
>>           io_notif_slot_flush_submit(notif_slot, 0);
>>       }
> 
> This would work but it seems to be confusing.
> 
> Can't we have a slot-less mode, with slot_idx==U16_MAX,
> where we always allocate a new notif for each request,
> this would then get the same user_data and would be referenced on the
> request in order to reuse the same notif on an async retry after a short send.

Ok, retries may make slots managing much harder, let me think

> And this notif will always be flushed at the end of the request.
> 
> This:
> 
> struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
>                                  struct io_notif_slot *slot)
> 
> would change to:
> 
> struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
>                                  __u64 cqe_user_data,
>                  __s32 cqe_res)
> 
> 
> and:
> 
> void io_notif_slot_flush(struct io_notif_slot *slot) __must_hold(&ctx->uring_lock)
> 
> (__must_hold looks wrong there...)

Nope, it should be there

> could just be:
> 
> void io_notif_flush(struct io_notif_*notif)
> 
> What do you think? It would remove the whole notif slot complexity
> from caller using IORING_RECVSEND_NOTIF_FLUSH for every request anyway.

The downside is that requests then should be pretty large or it'll
lose in performance. Surely not a problem for 8MB per request but
even 4KB won't suffice. And users may want to put in smaller chunks
on the wire instead of waiting for mode data to let tcp handle
pacing and potentially improve latencies by sending earlier.

On the other hand that one notification per request idea mentioned
before can extended to 1-2 CQEs per request, which is interestingly
the approach zc send discussions started with.

-- 
Pavel Begunkov
