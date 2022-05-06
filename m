Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E024051E18A
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 00:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444662AbiEFWGU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 18:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444665AbiEFWGT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 18:06:19 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61F56D959
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 15:02:35 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d17so8726219plg.0
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 15:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cIzYna/YEl2NhWK3pU6KnqI6mAaFoXTCE8kbRq6Vi0s=;
        b=wW20NCXgQpd2v7jNG5eADv5lYiVGQxYZACu+zWNdwR4kp4fX0K4Y/L8LaPfgIL7NnX
         c9TmyUBdYqNqBQsthH4wED6t/gk69f9rAVG0ZDrh8JMotKamqjbSj4CMgDHYULSDYasv
         czLMWrZs2Y8wGiQXok4+o4zw9+mUfNXS+k4QREjl6Km50nwmz0xjoXGDPWO1wg25Ca8i
         KwCWl07nN47Z45UUG7rvFMjhs0tg1RChYmZQHMtxdJvyaoygZC1spfCta7nuK8ZynqvI
         0IRQJ//4uoifcIUhYglbAX7nGgwBP1Kq2GYnHCrTUSdd0IzN2wRio0q9T9crCSl0F4KY
         /+mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cIzYna/YEl2NhWK3pU6KnqI6mAaFoXTCE8kbRq6Vi0s=;
        b=UsGCwb8/uDdaXNsguDFPB9dbdZD4kUNwhWqqfZvAJDJWVk9YqHD4hVH2P8Cok9r2ZA
         UhMqp89hZOc5SKzQ9GQhK9I+DG13jGz31dDcMFfGNwULeRlzkVjlYodijil765wxfi/2
         qPIdz8XMLLZ3CT6B3vvkwse6nTpMwz+HbBGMm8qBgG+oF5pm08nfpdypap1M3rEv/GzU
         491X6tdpP5Ld1iXFgfpq6OIHcYUg13CeHMtwWfuhDaoTPwni0AoZmpsB2ENrFSYOfFOj
         jC+kJiartnpeIBUINwyjI/fVtMFZ1hd2eWZxHiAL9CVAujaTMIXb6WEysM1XiPRku9ZJ
         qjBQ==
X-Gm-Message-State: AOAM533Uty4E7rlRxlqVE4Z7/9lCTcEb4AAMyI6sf4xwQ4KwiRk6a0cO
        aX1eFb9EeedbDhcHmV201m6RRprbSMwofw==
X-Google-Smtp-Source: ABdhPJyCz+3zBak6a3HzIwwi6Mpi98YDzL4KdwBqjl+i7Qt3MYrW+j9aPZ8qrMRaujKNDE256Z6WGA==
X-Received: by 2002:a17:90b:1b03:b0:1dc:a80b:8004 with SMTP id nu3-20020a17090b1b0300b001dca80b8004mr14653328pjb.182.1651874554739;
        Fri, 06 May 2022 15:02:34 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id y15-20020a170902b48f00b0015e8d4eb211sm2243226plr.91.2022.05.06.15.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 15:02:34 -0700 (PDT)
Message-ID: <8e81111d-398c-3810-50b4-e1475e956b6f@kernel.dk>
Date:   Fri, 6 May 2022 16:02:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 3/5] io_uring: let fast poll support multishot
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-4-haoxu.linux@gmail.com>
 <d68381cf-a9fc-33b8-8a9c-ff8485ba8d19@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d68381cf-a9fc-33b8-8a9c-ff8485ba8d19@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 11:19 AM, Pavel Begunkov wrote:
> On 5/6/22 08:01, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> For operations like accept, multishot is a useful feature, since we can
>> reduce a number of accept sqe. Let's integrate it to fast poll, it may
>> be good for other operations in the future.
>>
>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>> ---
>>   fs/io_uring.c | 41 ++++++++++++++++++++++++++---------------
>>   1 file changed, 26 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 8ebb1a794e36..d33777575faf 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5952,7 +5952,7 @@ static void io_poll_remove_entries(struct io_kiocb *req)
>>    * either spurious wakeup or multishot CQE is served. 0 when it's done with
>>    * the request, then the mask is stored in req->cqe.res.
>>    */
>> -static int io_poll_check_events(struct io_kiocb *req, bool locked)
>> +static int io_poll_check_events(struct io_kiocb *req, bool *locked)
>>   {
>>       struct io_ring_ctx *ctx = req->ctx;
>>       int v;
>> @@ -5981,17 +5981,26 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
>>             /* multishot, just fill an CQE and proceed */
>>           if (req->cqe.res && !(req->apoll_events & EPOLLONESHOT)) {
>> -            __poll_t mask = mangle_poll(req->cqe.res & req->apoll_events);
>> -            bool filled;
>> -
>> -            spin_lock(&ctx->completion_lock);
>> -            filled = io_fill_cqe_aux(ctx, req->cqe.user_data, mask,
>> -                         IORING_CQE_F_MORE);
>> -            io_commit_cqring(ctx);
>> -            spin_unlock(&ctx->completion_lock);
>> -            if (unlikely(!filled))
>> -                return -ECANCELED;
>> -            io_cqring_ev_posted(ctx);
>> +            if (req->flags & REQ_F_APOLL_MULTISHOT) {
>> +                io_tw_lock(req->ctx, locked);
>> +                if (likely(!(req->task->flags & PF_EXITING)))
>> +                    io_queue_sqe(req);
> 
> That looks dangerous, io_queue_sqe() usually takes the request
> ownership and doesn't expect that someone, i.e.
> io_poll_check_events(), may still be actively using it.

I took a look at this, too. We do own the request at this point, but
it's still on the poll list. If io_accept() fails, then we do run the
poll_clean.

> E.g. io_accept() fails on fd < 0, return an error, io_queue_sqe() ->
> io_queue_async() -> io_req_complete_failed() kills it. Then
> io_poll_check_events() and polling in general carry on using the freed
> request => UAF. Didn't look at it too carefully, but there might other
> similar cases.

But we better have done poll_clean() before returning the error. What am
I missing here?

-- 
Jens Axboe

