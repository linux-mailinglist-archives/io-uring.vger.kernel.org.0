Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0A043FE3A
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 16:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhJ2OPs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 10:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbhJ2OP1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 10:15:27 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1C2C061766
        for <io-uring@vger.kernel.org>; Fri, 29 Oct 2021 07:12:58 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id b12so11935892wrh.4
        for <io-uring@vger.kernel.org>; Fri, 29 Oct 2021 07:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=h06eYIS2A0loMB0fvTtxJvYAr0saGP3KM0XzAX1WDpU=;
        b=XM7KNdnfoiWgsNYN+cnRYNUK5vZJo72zv2u1joxqgl+Xbrk+0Ywk6D7HOiz+iumJMT
         DXMum2+J+pzp6jh0Gz/zl7/DnZRgP3RPM1o4oPT9zhL3MwEhxMzeLOahSukvrnoon0/x
         GjveWZ6ej+68PrL681QjauHC24mu7FtCs3HQqlghFFfawQH284sMwLJ80FUsAMAE1SkM
         UkzsimdGx8gwVgZJUifvEVGmjair2WdrpraTqHuh0ByuzHMpCiZMw1uGO7XXUKwYway9
         alw9brvkqS3u1f+F9wwLgLOzFDttitPfvOtZsAX1MgncrxO2TbIXY8fMOdmeqwB0kybd
         q3hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h06eYIS2A0loMB0fvTtxJvYAr0saGP3KM0XzAX1WDpU=;
        b=sywD3caBFywLOhvdwgp8Fw6Jsdc2M/SNd1FMG/vO7Y6OAZLpTHjrnD7I07tvww0zgH
         uOIfqnlt7a+VsFGhf5fJAGOWzGm7WHCd5h2mG5zuqWOO98WIEe9eyq1QCz+Hpnt0lgqJ
         F+BKRSzI5RLB4lzSzNd4zUlkoNU0oV61Hu0yMUSwTLT7Fn0o/TQ/4SqIAYK+SisoRf6T
         +N6DcrKNyCgpQ5uORC+Ekb2cnSEUWWJ6LfSrL+SJH71GsL/nVI2tl6H+rAwVY5QQVDR5
         nGLV7E7ep1kuxMFaRK27v6LQwvZKw/qKScijtwyxhJv3eGRUE4YHOmxemPrIFKMC9tM2
         NxYg==
X-Gm-Message-State: AOAM532qr3UQNu42LoBbezmxzCfs+KzyhBc4uEW/iVImwpBVRiirr73l
        RUZ7k8mkEOViWR6N3UzXxpLKaPcgvfA=
X-Google-Smtp-Source: ABdhPJywG2do+YW4AkKfdGg8sJYDm28yUrXq4Q+XHbrjdt1h6sr2FRYCzgR98jwLvd9/BwX1fdyRug==
X-Received: by 2002:adf:a350:: with SMTP id d16mr14835975wrb.136.1635516777331;
        Fri, 29 Oct 2021 07:12:57 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.16])
        by smtp.gmail.com with ESMTPSA id v6sm7271072wrx.17.2021.10.29.07.12.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 07:12:57 -0700 (PDT)
Message-ID: <68dced19-6f11-4db8-321a-856217505539@gmail.com>
Date:   Fri, 29 Oct 2021 15:12:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 2/3] io_uring: reduce frequent add_wait_queue()
 overhead for multi-shot poll request
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
 <20211025053849.3139-3-xiaoguang.wang@linux.alibaba.com>
 <7dd1823d-0324-36d1-2562-362f2ef0399b@gmail.com>
 <7e6c2a36-adf5-ece5-9109-cd5c4429e79d@linux.alibaba.com>
 <a448c9b6-65d8-c602-7716-d6630c1f2254@gmail.com>
 <bede0dc1-dc6f-3674-9650-e0f3e60c3d01@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bede0dc1-dc6f-3674-9650-e0f3e60c3d01@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/29/21 14:37, Xiaoguang Wang wrote:
> hi,
> 
>> On 10/29/21 03:57, Xiaoguang Wang wrote:
>>> hi,
>>>
>>>> On 10/25/21 06:38, Xiaoguang Wang wrote:
>>>>> Run echo_server to evaluate io_uring's multi-shot poll performance, perf
>>>>> shows that add_wait_queue() has obvious overhead. Intruduce a new state
>>>>> 'active' in io_poll_iocb to indicate whether io_poll_wake() should queue
>>>>> a task_work. This new state will be set to true initially, be set to false
>>>>> when starting to queue a task work, and be set to true again when a poll
>>>>> cqe has been committed. One concern is that this method may lost waken-up
>>>>> event, but seems it's ok.
>>>>>
>>>>>    io_poll_wake                io_poll_task_func
>>>>> t1                       |
>>>>> t2                       | WRITE_ONCE(req->poll.active, true);
>>>>> t3                       |
>>>>> t4                       |    io_commit_cqring(ctx);
>>>>> t5                       |
>>>>> t6                       |
>>>>>
>>>>> If waken-up events happens before or at t4, it's ok, user app will always
>>>>> see a cqe. If waken-up events happens after t4 and IIUC, io_poll_wake()
>>>>> will see the new req->poll.active value by using READ_ONCE().
>>>>>
>>>>> Echo_server codes can be cloned from:
>>>>> https://codeup.openanolis.cn/codeup/storage/io_uring-echo-server.git,
>>>>> branch is xiaoguangwang/io_uring_multishot.
>>>>>
>>>>> Without this patch, the tps in our test environment is 284116, with
>>>>> this patch, the tps is 287832, about 1.3% reqs improvement, which
>>>>> is indeed in accord with the saved add_wait_queue() cost.
>>>>>
>>>>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>>>> ---
>>>>>   fs/io_uring.c | 57 +++++++++++++++++++++++++++++++++------------------------
>>>>>   1 file changed, 33 insertions(+), 24 deletions(-)
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index 18af9bb9a4bc..e4c779dac953 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -481,6 +481,7 @@ struct io_poll_iocb {
>>>>>       __poll_t            events;
>>>>>       bool                done;
>>>>>       bool                canceled;
>>>>> +    bool                active;
>>>>>       struct wait_queue_entry        wait;
>>>>>   };
>>>>>   @@ -5233,8 +5234,6 @@ static inline int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *pol
>>>>>   {
>>>>>       trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
>>>>>   -    list_del_init(&poll->wait.entry);
>>>>> -
>>>>
>>>> As I mentioned to Hao some time ago, we can't allow this function or in
>>>> particular io_req_task_work_add() to happen twice before the first
>>>> task work got executed, they use the same field in io_kiocb and those
>>>> will corrupt the tw list.
>>>>
>>>> Looks that's what can happen here.
>>> If I have understood scenario your described correctly, I think it won't happen :)
>>> With this patch, if the first io_req_task_work_add() is issued, poll.active
>>> will be set to false, then no new io_req_task_work_add() will be issued.
>>> Only the first task_work installed by the first io_req_task_work_add() has
>>> completed, poll.active will be set to true again.
>>
>> Ah, I see now, the active dance is in io_poll_wake(). That won't work
>> with READ_ONCE/WRITE_ONCE though, you would need real atomics
>>
>> The easiest race to explain is:
>>
>> CPU1                        | CPU2
>> io_poll_wake                | io_poll_wake
>> if (p->active) return 0;    | if (p->active) return 0;
> it's "if (!p->active) return 0;" in my patch :)

hah, yeah, email draft-coding

>> // p->active is false in both cases, continue
>> p->active = false;          | p->active = false;
>> task_work_add()             | task_work_add()
> io_poll_wake() is called with poll->head->lock, so there will no concurrent
> io_poll_wake() calls.

The problem is that the poll implementation is too wobbly, can't count
how many corner cases there are... We can get to the point that your
patches are "proven" to work, but I'll be more on the cautious side as
the current state is hell over complicated.

-- 
Pavel Begunkov
