Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C6551E606
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 11:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382813AbiEGJaj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 05:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354899AbiEGJag (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 05:30:36 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAF454FB2;
        Sat,  7 May 2022 02:26:48 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id bg25so5810904wmb.4;
        Sat, 07 May 2022 02:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xP6kWb2DppJ6x1IqM0Tw9TyBcxMyURsIUgj1pvO/6uU=;
        b=VaIJsBjTDFyX+uI+3iS24YgoGQMHUWw2RcUYdAfQfLWL9JUY2FveV4ABq44CSJWnD7
         2bhvBqaezb5p5Km7AkJtNB87FxNOIpjnmM+1N+p1WJqiK9SP+mlGJrBsPMPBRT6dsGlM
         Knb7A72beSFUUxio9PiKUMbPfkRz2CtboFgCWaPlztkuJX5fayXJ9tqOB9Tp0z4ewP+6
         eTu5+gmB/WVzg1qTy8jHp95oNjN6qBYeOTLNphVYSil6KoP29rTdSltlGJ4Hk5gfgL0a
         SRAYmzmStPCYkWOjF5+qFm03luH+n/gfFJ1tLjkNvKfZmaCG2P8vTc6N+37ACLGxzI/7
         GpVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xP6kWb2DppJ6x1IqM0Tw9TyBcxMyURsIUgj1pvO/6uU=;
        b=D+vohVPhXvxo7F+8kb/xh3TVG2H9CxxT5b25tN8TK5WX4tzJDhYPQ26zuFMdWDuZxb
         K8vnMoWegheNWLjevoHCKzObhxCD5FjDmQvQEyz/G8XYIxrXCi1OSh7Ps3aj10kWHGa4
         KqYApmfpU4V2YHVX6bECnEGdzVAZvRjB+QbDtIHmU4soB1gEQuiyio+tvcLLSj4A/F6D
         zc8mLX4V+unf6zD4AgLBvzCY/UWziFrGkSDzclzHfXLo3aVD+eoT7HpKn6yDNZ+rWr4Z
         UA/KK/dxwk/3jauNj/0F9WjQMSlKVR5bAM4Of2OCVpcTqLTAuM54G8F33OIs07tH32S4
         7wQA==
X-Gm-Message-State: AOAM531+6Q/Xm48D7uIfkr12XsxeWNysEU17aK29ELKp51RrsETtsbQQ
        ejmrtwYXYcqEPxyIukHZOOcd4VAjehA=
X-Google-Smtp-Source: ABdhPJyGF9UIntd2VJOo2l3mbdUd3Fv7Xu27F4GxZgvEhbCvGPJHV+Xl1FDLCg+vLC0VriNBLi6CeQ==
X-Received: by 2002:a05:600c:3b0a:b0:394:6373:6c45 with SMTP id m10-20020a05600c3b0a00b0039463736c45mr13638330wms.69.1651915607305;
        Sat, 07 May 2022 02:26:47 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.237.69])
        by smtp.gmail.com with ESMTPSA id f186-20020a1c38c3000000b003942a244ec9sm7610349wma.14.2022.05.07.02.26.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 02:26:46 -0700 (PDT)
Message-ID: <e29d7079-ff52-db69-c215-7212682fd3fc@gmail.com>
Date:   Sat, 7 May 2022 10:26:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 3/5] io_uring: let fast poll support multishot
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu.linux@gmail.com>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-4-haoxu.linux@gmail.com>
 <d68381cf-a9fc-33b8-8a9c-ff8485ba8d19@gmail.com>
 <8e81111d-398c-3810-50b4-e1475e956b6f@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8e81111d-398c-3810-50b4-e1475e956b6f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 23:02, Jens Axboe wrote:
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

Right, but we don't pass the ownership into io_queue_sqe(). IOW,
it can potentially free it / use tw / etc. inside and then we
return back to io_poll_check_events() with a broken req.

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

One scenario I'd be worry about is sth like:


io_apoll_task_func()                            |
-> io_poll_check_events()                       |
   // 1st iteration                              |
   -> io_queue_sqe()                             |
                                                 | poll cancel()
                                                 |   -> set IO_POLL_CANCEL_FLAG
     -> io_accept() fails                        |
       -> io_poll_clean()                        |
     -> io_req_complete_failed()                 |
   // 2nd iteration finds IO_POLL_CANCEL_FLAG    |
     return -ECANCELLED                          |
-> io_req_complete_failed(req, ret)             |


The problem in this example is double io_req_complete_failed()

-- 
Pavel Begunkov
