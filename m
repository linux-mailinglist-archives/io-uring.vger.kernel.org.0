Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90C3403A64
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 15:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbhIHNPY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 09:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbhIHNPY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 09:15:24 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192FCC061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 06:14:16 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m2so1736642wmm.0
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 06:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OoWb/llx1GpYUptX7QN3yAZR5OhrZP1hWEflejzuq4g=;
        b=LYgUG4NRbIId1d9mQpokmCQK4Db7QUtcas6Dan+zwmvugKD3VS/YLnvxBR1KmP0vmD
         zzrhM9H0st6sgA/Ugm999g1GznRg2Xkn0L/cQm8xiX/3j+qnqBj39FF71Pxo0tQWMDFw
         k2bEdFhjyJifI3l98qVgi2e5HzA+h+XIHcw640noyLoA8qqQv9hcPK5Fr/+belZIOjsI
         +lIoCAS8sPst3HdCM4VonSzVf7x/ewb9hUSFSnky3+Rta1B2bJcL9OQ+ywthUP1soxVX
         dqYUIlhFpHyTo6sj55XlQMsHVPHg5dmJmFNZjzIcaPUP5fKH3YORBqGQTc39vqhp92h2
         4V+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OoWb/llx1GpYUptX7QN3yAZR5OhrZP1hWEflejzuq4g=;
        b=Gei0hMgHf5ahJRW4a4Tjk7fJpFsRhgvlyEFjuzvt+12RAE4H/DOhqKxV8u0HIbbkyt
         JbOc5W3z4vxTsWV0D4COAMNbBqrzfi4vfPosorZgP+XxdOu+dOy43Jkmq2lLoU/cWWqP
         Konu03CojdCM/Y5F9Nlo3WBBqEI/5B7taWuzBCXj7ma1R6SFKH2V3LCnZhH/q4gwAuKB
         djClGTfxU30/wli0Q8pJ5ZhuS/nEWN7ZNm3/661uf0fOAuEOXiCq7IoyKK33Imit0DnU
         gjO+y8Ojo38W/S4fzyqavM1XLTWwDGcjFlX7xodztdmawfUrwnL9OciNuFnd0pjayWrz
         ISHQ==
X-Gm-Message-State: AOAM531niL4ntoqP3qgSY/RhM3Cn9hhbVPOciInZ9OKZ9iCynz4uaQLU
        0CxA7y7vls3vbgSOqxEwK0Q=
X-Google-Smtp-Source: ABdhPJxf8wY3S6Y1wmtZJu9dYXTRYkjddKr7E6kqO0RyWZmsGVYL7ROzYCA8ifJtkmqYK1Ly9QBgww==
X-Received: by 2002:a1c:1d88:: with SMTP id d130mr1141769wmd.161.1631106854557;
        Wed, 08 Sep 2021 06:14:14 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id h18sm2170279wrb.33.2021.09.08.06.14.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 06:14:14 -0700 (PDT)
Subject: Re: [PATCH 4/6] io_uring: let fast poll support multishot
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-5-haoxu@linux.alibaba.com>
 <9a8efd19-a320-29a4-7132-7b5ae5b994ff@gmail.com>
 <8c052e2a-0ee6-7dac-1169-9d395d2ecad8@linux.alibaba.com>
 <2ba9fdb5-6d60-21f5-3e20-bc1687c9509f@linux.alibaba.com>
 <a73331f7-11ce-1a67-c312-c20553338682@gmail.com>
Message-ID: <0b7643a0-a5ab-4612-4d8c-d204374ea3c0@gmail.com>
Date:   Wed, 8 Sep 2021 14:13:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <a73331f7-11ce-1a67-c312-c20553338682@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 1:03 PM, Pavel Begunkov wrote:
> On 9/8/21 12:21 PM, Hao Xu wrote:
>> 在 2021/9/7 下午2:48, Hao Xu 写道:
>>> 在 2021/9/7 上午3:04, Pavel Begunkov 写道:
>>>> On 9/3/21 12:00 PM, Hao Xu wrote:
>>>>> For operations like accept, multishot is a useful feature, since we can
>>>>> reduce a number of accept sqe. Let's integrate it to fast poll, it may
>>>>> be good for other operations in the future.
>>>>>
>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>>> ---
>>>>>   fs/io_uring.c | 15 ++++++++++++---
>>>>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index d6df60c4cdb9..dae7044e0c24 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -5277,8 +5277,15 @@ static void io_async_task_func(struct io_kiocb *req, bool *locked)
>>>>>           return;
>>>>>       }
>>>>> -    hash_del(&req->hash_node);
>>>>> -    io_poll_remove_double(req);
>>>>> +    if (READ_ONCE(apoll->poll.canceled))
>>>>> +        apoll->poll.events |= EPOLLONESHOT;
>>>>> +    if (apoll->poll.events & EPOLLONESHOT) {
>>>>> +        hash_del(&req->hash_node);
>>>>> +        io_poll_remove_double(req);
>>>>> +    } else {
>>>>> +        add_wait_queue(apoll->poll.head, &apoll->poll.wait);
>>>>
>>>> It looks like it does both io_req_task_submit() and adding back
>>>> to the wq, so io_issue_sqe() may be called in parallel with
>>>> io_async_task_func(). If so, there will be tons of all kind of
>>>> races.
>>> IMHO, io_async_task_func() is called in original context one by
>>> one(except PF_EXITING is set, it is also called in system-wq), so
>>> shouldn't be parallel case there.
>> ping...
> 
> fwiw, the case we're talking about:
> 
> CPU0                            | CPU1
> io_async_task_func()            |
> -> add_wait_queue();            |
> -> io_req_task_submit();        |
>                /* no tw run happened in between */
>                                 | io_async_task_func()
>                                 | --> io_req_task_submit()
> 
> We called io_req_task_submit() twice without running tw in-between,
> both of the calls use the same req->io_task_work.node field in the
> request for accounting, and so the second call will screw
> tctx->task_list and not only by not considering that
> req->io_task_work.node is already taken/enqueued.
> 
> io_req_task_work_add() {
>         wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
> }

fwiw, can be just 1 CPU, just

io_req_task_work_add();
io_req_task_work_add();
task_work_run(); // first one

is buggy in current constraints.

> 
>>>>
>>>>> +    }
>>>>> +
>>>>>       spin_unlock(&ctx->completion_lock);
>>>>>       if (!READ_ONCE(apoll->poll.canceled))
>>>>> @@ -5366,7 +5373,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>>>>>       struct io_ring_ctx *ctx = req->ctx;
>>>>>       struct async_poll *apoll;
>>>>>       struct io_poll_table ipt;
>>>>> -    __poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
>>>>> +    __poll_t ret, mask = POLLERR | POLLPRI;
>>>>>       int rw;
>>>>>       if (!req->file || !file_can_poll(req->file))
>>>>> @@ -5388,6 +5395,8 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>>>>>           rw = WRITE;
>>>>>           mask |= POLLOUT | POLLWRNORM;
>>>>>       }
>>>>> +    if (!(req->flags & REQ_F_APOLL_MULTISHOT))
>>>>> +        mask |= EPOLLONESHOT;
>>>>>       /* if we can't nonblock try, then no point in arming a poll handler */
>>>>>       if (!io_file_supports_nowait(req, rw))
>>>>>
>>>>
>>
> 

-- 
Pavel Begunkov
