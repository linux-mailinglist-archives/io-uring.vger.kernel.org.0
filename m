Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1EE151E499
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 08:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351761AbiEGGfk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 02:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237563AbiEGGfj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 02:35:39 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6C645AD3;
        Fri,  6 May 2022 23:31:53 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c11so9360204plg.13;
        Fri, 06 May 2022 23:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=OzdNfZxxmkcZgQmcrr/fMou7WbepUbdCKxZFmXlJ3Vg=;
        b=dWYzdn9T7cKZ5BiAcTVmluX1pOnqbUbNreFbH0//vZnGggWaVlZW+O57dO7TuM12Ls
         SNV3kyQJ8IbthKLO2CN+gO4B9DReUhXGRssVl3K72uNQZq34R2+Jf0VbDZPFzFwKB0mh
         yYBpuVl+In0oM2FYXDnRVnk3RfCjqYbBEJvOBqWBbCGBUmuzYn2HlYADzgVJyTsKb1/k
         3fEeXK9jXsYZhSKxQ6HCLjOcQ5slnnUDe8JFCZIlY2oGcl7EY4sPLtFrxcTMmew1WDTr
         sHuE6shWmpWr3yqiGOYMue1MKl64YHsZL6A4hIWkcY4HV3lRVIYpTeRE6mn5yubgv6aA
         D3Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OzdNfZxxmkcZgQmcrr/fMou7WbepUbdCKxZFmXlJ3Vg=;
        b=1Y0ndhpXSrk31S6D7WBxN5S0P6CIx8n9zI/3jH7svr0PpIHGfkTswyMnb2L+cM0hwB
         fa/KgkYKgSFKGp+tcPivezdvVWBmeHO3L8R8jUt0QLGKv6B5dSH4VRVo0iGiQvfLXT2F
         kVnQfehbs3cR42wzxaWJIjRtGb1yTm7RgefDDcVtenbdFzZHhXQDHxAWKnIWg+cMQRNf
         YzElbNfzEtCKo93pOMaoyBRwCqj7dj9iIS6B4zuNH/TU4Ke8mEt/x2ybiiVEiXWyRRwn
         0/icQM2skVcTbulFqHgQ+WDejp4T7qLUn5BXZ13OUZGCHxbDETeGNlyWInyJ9hlXkmr7
         DArw==
X-Gm-Message-State: AOAM5330o1WgXsl3VtUEdIIqYgU7bpwKIO4sKUuYmL8+ZqxRX4cuMa6f
        ZXtRR2gPQExEO4rYmtxbqUE=
X-Google-Smtp-Source: ABdhPJx9jxhTeN3M6bgGkiygyBhgaQPxXrSuzcd5ZXTT+szK8WkXknBBhK6G6NHJJpQZHyS/el2Mlg==
X-Received: by 2002:a17:90b:1e49:b0:1dc:81d9:2d97 with SMTP id pi9-20020a17090b1e4900b001dc81d92d97mr16627343pjb.221.1651905113104;
        Fri, 06 May 2022 23:31:53 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id b2-20020a056a0002c200b0050dc7628143sm4394648pft.29.2022.05.06.23.31.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 23:31:52 -0700 (PDT)
Message-ID: <8b934240-4388-d0ff-0d36-69acb253a2a6@gmail.com>
Date:   Sat, 7 May 2022 14:32:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 3/5] io_uring: let fast poll support multishot
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-4-haoxu.linux@gmail.com>
 <d68381cf-a9fc-33b8-8a9c-ff8485ba8d19@gmail.com>
 <8e81111d-398c-3810-50b4-e1475e956b6f@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <8e81111d-398c-3810-50b4-e1475e956b6f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/7 上午6:02, Jens Axboe 写道:
> On 5/6/22 11:19 AM, Pavel Begunkov wrote:
>> On 5/6/22 08:01, Hao Xu wrote:
>>> From: Hao Xu <howeyxu@tencent.com>
>>>
>>> For operations like accept, multishot is a useful feature, since we can
>>> reduce a number of accept sqe. Let's integrate it to fast poll, it may
>>> be good for other operations in the future.
>>>
>>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>>> ---
>>>    fs/io_uring.c | 41 ++++++++++++++++++++++++++---------------
>>>    1 file changed, 26 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 8ebb1a794e36..d33777575faf 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -5952,7 +5952,7 @@ static void io_poll_remove_entries(struct io_kiocb *req)
>>>     * either spurious wakeup or multishot CQE is served. 0 when it's done with
>>>     * the request, then the mask is stored in req->cqe.res.
>>>     */
>>> -static int io_poll_check_events(struct io_kiocb *req, bool locked)
>>> +static int io_poll_check_events(struct io_kiocb *req, bool *locked)
>>>    {
>>>        struct io_ring_ctx *ctx = req->ctx;
>>>        int v;
>>> @@ -5981,17 +5981,26 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
>>>              /* multishot, just fill an CQE and proceed */
>>>            if (req->cqe.res && !(req->apoll_events & EPOLLONESHOT)) {
>>> -            __poll_t mask = mangle_poll(req->cqe.res & req->apoll_events);
>>> -            bool filled;
>>> -
>>> -            spin_lock(&ctx->completion_lock);
>>> -            filled = io_fill_cqe_aux(ctx, req->cqe.user_data, mask,
>>> -                         IORING_CQE_F_MORE);
>>> -            io_commit_cqring(ctx);
>>> -            spin_unlock(&ctx->completion_lock);
>>> -            if (unlikely(!filled))
>>> -                return -ECANCELED;
>>> -            io_cqring_ev_posted(ctx);
>>> +            if (req->flags & REQ_F_APOLL_MULTISHOT) {
>>> +                io_tw_lock(req->ctx, locked);
>>> +                if (likely(!(req->task->flags & PF_EXITING)))
>>> +                    io_queue_sqe(req);
>>
>> That looks dangerous, io_queue_sqe() usually takes the request
>> ownership and doesn't expect that someone, i.e.
>> io_poll_check_events(), may still be actively using it.
> 
> I took a look at this, too. We do own the request at this point, but
> it's still on the poll list. If io_accept() fails, then we do run the
> poll_clean.
> 
>> E.g. io_accept() fails on fd < 0, return an error, io_queue_sqe() ->
>> io_queue_async() -> io_req_complete_failed() kills it. Then
>> io_poll_check_events() and polling in general carry on using the freed
>> request => UAF. Didn't look at it too carefully, but there might other
>> similar cases.
> 
> But we better have done poll_clean() before returning the error. What am
> I missing here?

Sorry, I don't get it. I've done the poll_clean() before returnning
error in io_accept()
> 

