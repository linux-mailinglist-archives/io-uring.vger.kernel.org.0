Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9DA40396A
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 14:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349209AbhIHMEr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 08:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbhIHMEq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 08:04:46 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAF8C061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 05:03:39 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id g16so2932882wrb.3
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 05:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LRbktXegaJKSVRL9d31bRmsbZtAVR7sG+N4HNv5kDj8=;
        b=Jlm8SIakVD8LToT05m3/YZH8zv55e4wUJZ/+qqNoMg5pf93S5ZIJE9ixmHa71F96dV
         a3u6xDtv0ZhrPIUjCFiNPEHhS88SNaF7+z7dmJ82emP/PAJhYG6EtMLKIgdZkF3YR83t
         bsjJv/Y1V3jDv+deETyRZ0nehFOqr9ud2272l5WoePUU39a1LeCSUJUl73NrcgPvhiTc
         Meh8XJf4WE0S74mWNAbkyVMywwpiR3WuAlTeRJVsFPK49Usm2RAgV3zPXO5fXM7irhaR
         iGGS/kBlK2mwQALh5fuq019P9NUS5JkFJLDoUJTRpqsY9G+dBNcsCZTFMet+lvy1vQDd
         v96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LRbktXegaJKSVRL9d31bRmsbZtAVR7sG+N4HNv5kDj8=;
        b=SN5wv3uhpNDejZ9BqNencAvgcSAqoCX+vdfqTNE7IoHZn5xWzvasCh/nNtThIMTFp9
         SfUdNWLcqPKhgBOofzEd82E5q1m5+9xmHfJIouAZqRbw047M/olfihtBfU2uno861+1P
         ix/Gydvm9m4rvCCHNEI0tsZ6k5CuxGYPcPbDhi0WM4I4swee86QDyausFhEXax6cQiEg
         trfCf9hRqmWCjmAsU0AphnDQjp5Gix1xOh3Qxu+O8KvF4wo/8XzNdPTWTqn09MToQFjs
         7bCfObMbj3D+Wd9QOH12dLvHF27p5eWwcGh3Op2ar845eiLIfl5AgJTAFFg3ZCtILQeD
         YQEA==
X-Gm-Message-State: AOAM530E7k2ImWQh1L3lWAPTn/xjSmkF2NTLW/FgVWyfTuKLTwS/ETc+
        RjpMdN7fhl1JU1ASQSUHKzQ=
X-Google-Smtp-Source: ABdhPJyI8F3rGb8nTooXUgovxYUQJtzwjyKhvLm6/c5YgauQ5mUcFWFg8BbRjjVR2gF7j6iDqCdCUw==
X-Received: by 2002:adf:80eb:: with SMTP id 98mr3702455wrl.348.1631102617493;
        Wed, 08 Sep 2021 05:03:37 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id z1sm1854376wmi.34.2021.09.08.05.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 05:03:37 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-5-haoxu@linux.alibaba.com>
 <9a8efd19-a320-29a4-7132-7b5ae5b994ff@gmail.com>
 <8c052e2a-0ee6-7dac-1169-9d395d2ecad8@linux.alibaba.com>
 <2ba9fdb5-6d60-21f5-3e20-bc1687c9509f@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 4/6] io_uring: let fast poll support multishot
Message-ID: <a73331f7-11ce-1a67-c312-c20553338682@gmail.com>
Date:   Wed, 8 Sep 2021 13:03:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <2ba9fdb5-6d60-21f5-3e20-bc1687c9509f@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 12:21 PM, Hao Xu wrote:
> 在 2021/9/7 下午2:48, Hao Xu 写道:
>> 在 2021/9/7 上午3:04, Pavel Begunkov 写道:
>>> On 9/3/21 12:00 PM, Hao Xu wrote:
>>>> For operations like accept, multishot is a useful feature, since we can
>>>> reduce a number of accept sqe. Let's integrate it to fast poll, it may
>>>> be good for other operations in the future.
>>>>
>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>> ---
>>>>   fs/io_uring.c | 15 ++++++++++++---
>>>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index d6df60c4cdb9..dae7044e0c24 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -5277,8 +5277,15 @@ static void io_async_task_func(struct io_kiocb *req, bool *locked)
>>>>           return;
>>>>       }
>>>> -    hash_del(&req->hash_node);
>>>> -    io_poll_remove_double(req);
>>>> +    if (READ_ONCE(apoll->poll.canceled))
>>>> +        apoll->poll.events |= EPOLLONESHOT;
>>>> +    if (apoll->poll.events & EPOLLONESHOT) {
>>>> +        hash_del(&req->hash_node);
>>>> +        io_poll_remove_double(req);
>>>> +    } else {
>>>> +        add_wait_queue(apoll->poll.head, &apoll->poll.wait);
>>>
>>> It looks like it does both io_req_task_submit() and adding back
>>> to the wq, so io_issue_sqe() may be called in parallel with
>>> io_async_task_func(). If so, there will be tons of all kind of
>>> races.
>> IMHO, io_async_task_func() is called in original context one by
>> one(except PF_EXITING is set, it is also called in system-wq), so
>> shouldn't be parallel case there.
> ping...

fwiw, the case we're talking about:

CPU0                            | CPU1
io_async_task_func()            |
-> add_wait_queue();            |
-> io_req_task_submit();        |
               /* no tw run happened in between */
                                | io_async_task_func()
                                | --> io_req_task_submit()

We called io_req_task_submit() twice without running tw in-between,
both of the calls use the same req->io_task_work.node field in the
request for accounting, and so the second call will screw
tctx->task_list and not only by not considering that
req->io_task_work.node is already taken/enqueued.

io_req_task_work_add() {
        wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
}

>>>
>>>> +    }
>>>> +
>>>>       spin_unlock(&ctx->completion_lock);
>>>>       if (!READ_ONCE(apoll->poll.canceled))
>>>> @@ -5366,7 +5373,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>>>>       struct io_ring_ctx *ctx = req->ctx;
>>>>       struct async_poll *apoll;
>>>>       struct io_poll_table ipt;
>>>> -    __poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
>>>> +    __poll_t ret, mask = POLLERR | POLLPRI;
>>>>       int rw;
>>>>       if (!req->file || !file_can_poll(req->file))
>>>> @@ -5388,6 +5395,8 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>>>>           rw = WRITE;
>>>>           mask |= POLLOUT | POLLWRNORM;
>>>>       }
>>>> +    if (!(req->flags & REQ_F_APOLL_MULTISHOT))
>>>> +        mask |= EPOLLONESHOT;
>>>>       /* if we can't nonblock try, then no point in arming a poll handler */
>>>>       if (!io_file_supports_nowait(req, rw))
>>>>
>>>
> 

-- 
Pavel Begunkov
