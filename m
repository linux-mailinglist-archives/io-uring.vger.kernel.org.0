Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E9B50B328
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 10:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445561AbiDVIr4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 04:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445586AbiDVIrz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 04:47:55 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639EF2673
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 01:45:01 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id j8so9381849pll.11
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 01:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=HpTRWral8qMHFi3pkOjqR8XH13XkANqWgkyUKS83Ipw=;
        b=Q33fvZb5p35kqm1YnrAV/n7vtpnUVnpksnAX/vFmpHOHc2Jz9MzWYnU6cTUCvD9j6g
         OoRCVKFOHzgOqhnbm0YHR3fsvkvdj3XyFogQ+JTs60va2UFnBYtz2ppgi86I0a0hZ3nY
         H0kXUvQlWwMydfXkNK1MJFmCQJ1rH7lyBUkrztslPAdYxuh7mcfyXkXQq2OqML4t156S
         /lVDw6DTNIkgztbhyJ7Fg1QxLScs4F8qOL9bfN0DoHI4Quk/L2NddFwXhPGfOUGU3/OL
         sD2NU7bWEwZFYJvGu0gVumbu3s84QgxhWclQCDz1e5JbhTEM7v6JJke8/3Xtw1UBN4i6
         Ud/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HpTRWral8qMHFi3pkOjqR8XH13XkANqWgkyUKS83Ipw=;
        b=cB2F4rklkFG4LFffmVwz/DKgm9GjqaHmjfj5BKE5XWJSaI1CkOUjiNjikYZP5HZEc6
         9KUWNdgC86X0SSFZWjQ3dVufVqhLg7HuI8zyjUTAkdW46DiiphJfvGhbWztVHMvlC8z3
         DWpG7X7bMkSOL0iDXEeK7hqVp9/WcmefZpApY5XbTShgEQP+knLeQjCFP978gO/L00m9
         lLn8uu8ZQ4jsDjsLt1rcwVDFZ9w6mnORsTK4ycoKOMfz7Pq/ihkckaZvxk+JQBOx/0Gk
         3eqaubwt1u6xtyx0iOU1WU4MpL72lVF9J3yxezEWoksWWw6tdmH/PT5c2774OdTD/jNo
         nlHA==
X-Gm-Message-State: AOAM533lW6Tu1n1ZW1nvPG2CkrBahawiFQWkUI0mqH557C7knQ6gvswg
        WoYFDFZCs1F0yBfVctRUi+9G0brPef0hUw==
X-Google-Smtp-Source: ABdhPJznQsRFqFHMWmyNIZ3bdnY7Bj6dMRpPcRv+LuNy6VtsO44cXOWea9IjgF2Hp1EjExpWfR4Gdg==
X-Received: by 2002:a17:902:e38c:b0:15b:40ca:37c8 with SMTP id g12-20020a170902e38c00b0015b40ca37c8mr3325221ple.23.1650617100856;
        Fri, 22 Apr 2022 01:45:00 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id l15-20020a62be0f000000b005059cc9cc34sm1752730pff.92.2022.04.22.01.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 01:45:00 -0700 (PDT)
Message-ID: <5d12619b-73c8-24c0-065c-d9322e7776e9@gmail.com>
Date:   Fri, 22 Apr 2022 16:45:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [RFC 00/11] io_uring specific task_work infra
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1650548192.git.asml.silence@gmail.com>
 <6088470f-d7f8-f5d3-1860-2f5aeda32935@gmail.com>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <6088470f-d7f8-f5d3-1860-2f5aeda32935@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,
在 2022/4/21 下午10:50, Pavel Begunkov 写道:
> On 4/21/22 14:44, Pavel Begunkov wrote:
>> For experiments only. If proves to be useful would need to make it
>> nicer on the non-io_uring side.
>>
>> 0-10 save 1 spinlock/unlock_irq pair and 2 cmpxchg per batch. 11/11 in
>> general trades 1 per tw add spin_lock/unlock_irq and 2 per batch 
>> spinlocking
>> with 2 cmpxchg to 1 per tw add cmpxchg and 1 per batch cmpxchg.
> 
> null_blk irqmode=1 completion_nsec=0 submit_queues=32 poll_queues=32
> echo -n 0 > /sys/block/nullb0/queue/iostats
> echo -n 2 > /sys/block/nullb0/queue/nomerges
> io_uring -d<QD> -s<QD> -c<QD> -p0 -B1 -F1 -b512 /dev/nullb0
This series looks good to me, by the way, what does -s and -c mean? and
what is the tested workload?

Regards,
Hao
> 
> 
>       | base | 1-10         | 1-11
> ___________________________________________
> QD1  | 1.88 | 2.15 (+14%)  | 2.19 (+16.4%)
> QD4  | 2.8  | 3.06 (+9.2%) | 3.11 (+11%)
> QD32 | 3.61 | 3.81 (+5.5%) | 3.96 (+9.6%)
> 
> The numbers are in MIOPS, (%) is relative diff with the baseline.
> It gives more than I expected, but the testing is not super
> consistent, so a part of it might be due to variance.
> 
> 
>> Pavel Begunkov (11):
>>    io_uring: optimise io_req_task_work_add
>>    io_uringg: add io_should_fail_tw() helper
>>    io_uring: ban tw queue for exiting processes
>>    io_uring: don't take ctx refs in tctx_task_work()
>>    io_uring: add dummy io_uring_task_work_run()
>>    task_work: add helper for signalling a task
>>    io_uring: run io_uring task_works on TIF_NOTIFY_SIGNAL
>>    io_uring: wire io_uring specific task work
>>    io_uring: refactor io_run_task_work()
>>    io_uring: remove priority tw list
>>    io_uring: lock-free task_work stack
>>
>>   fs/io-wq.c                |   1 +
>>   fs/io_uring.c             | 213 +++++++++++++++-----------------------
>>   include/linux/io_uring.h  |   4 +
>>   include/linux/task_work.h |   4 +
>>   kernel/entry/kvm.c        |   1 +
>>   kernel/signal.c           |   2 +
>>   kernel/task_work.c        |  33 +++---
>>   7 files changed, 115 insertions(+), 143 deletions(-)
>>
> 

