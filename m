Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E13350B696
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 13:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbiDVL5n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 07:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbiDVL5n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 07:57:43 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E015642B
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 04:54:49 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id c10so10731025wrb.1
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 04:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=K66nqswH2g9RoKUeC1Y6RweLKwPwTF6ycgHWWGeMj/k=;
        b=oosNpxnytCQXunQqAv/4Aip5R+rbCPfyUWxdAHgE1b9sUeiHV0gCojrQ4Qp9txofGP
         4TJq2C54zwAQlYEmGIzcoFw9QMfFD5aQAKPI3Mbva5MsZaueeJ5LF1z5N4ZXEIBuzb+J
         CjOwyFhZN/yO3afZNGryKj5/I8LMdfeCWCgfCuUifQXhvket+XI2B7hgDu6r5zvaSm/j
         1FnVTXzha99Polfdc5SQjIPxGhsrBh4hc2SdaM2jil4FP5LRMJtr9VZmMWpndTDhvxj4
         2uvdw4IS/Z3h0wLFtQSm3LEG756vqds4aBX2HdJf1GTBIXdL1NYi6JoD8+G+EXiA4YUd
         QZxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K66nqswH2g9RoKUeC1Y6RweLKwPwTF6ycgHWWGeMj/k=;
        b=fvg0tQPZkJCLZ9C9M2a7J6AwQNEjpwAn7GIi6YscBsq4q5jDqyIfWhKOu67tS9QJ9A
         jsLhpbKACisJASnWnjUqOab0+HEKvmghiJJqbUjvbJCNdl4v6VptbR7aXzZR6qD7NuRB
         8cdInUirj8SeO7AZo/gw8Xg3qiHnrDNtLYg/C2JdjGjQXBMN+cs35cW0hzeMvO5UvdMI
         svWuni5FVXqtpMhmRHeRdUqb1yaywgaA54xJkEht+ZkRf0ELaX939edHXjNnFhXgz8BO
         EgeZ5HYcUkJbzMp0mH0Qx8vf8q5OjEFMKIMrHFZq/p/N77SjUz/JNJkuyWFhQAYpYwUq
         +4aA==
X-Gm-Message-State: AOAM531+EMi8/zFr+3MLBK40TBxpkMrH9iUBVnD3FjGiIVGaq+Jc8Qiu
        Lxg04U8seBQKdwzq4oohnWbqV1jUalI=
X-Google-Smtp-Source: ABdhPJwK+LEK1AkiOzI+f3xw/C68oHhf+7nfVlPHOk5Q5Zgxi9wJ6Ye9X7dsy3zUuDN5GiXextM1Hw==
X-Received: by 2002:adf:e3c1:0:b0:20a:aba9:9b38 with SMTP id k1-20020adfe3c1000000b0020aaba99b38mr3297880wrm.673.1650628488120;
        Fri, 22 Apr 2022 04:54:48 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.144.28])
        by smtp.gmail.com with ESMTPSA id l14-20020adffe8e000000b00207af9cdd90sm1497094wrr.39.2022.04.22.04.54.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 04:54:47 -0700 (PDT)
Message-ID: <5799d69a-6212-b270-ee61-102ab2abad6d@gmail.com>
Date:   Fri, 22 Apr 2022 12:54:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [RFC 00/11] io_uring specific task_work infra
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1650548192.git.asml.silence@gmail.com>
 <6088470f-d7f8-f5d3-1860-2f5aeda32935@gmail.com>
 <5d12619b-73c8-24c0-065c-d9322e7776e9@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5d12619b-73c8-24c0-065c-d9322e7776e9@gmail.com>
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

On 4/22/22 09:45, Hao Xu wrote:
> Hi,
> 在 2022/4/21 下午10:50, Pavel Begunkov 写道:
>> On 4/21/22 14:44, Pavel Begunkov wrote:
>>> For experiments only. If proves to be useful would need to make it
>>> nicer on the non-io_uring side.
>>>
>>> 0-10 save 1 spinlock/unlock_irq pair and 2 cmpxchg per batch. 11/11 in
>>> general trades 1 per tw add spin_lock/unlock_irq and 2 per batch spinlocking
>>> with 2 cmpxchg to 1 per tw add cmpxchg and 1 per batch cmpxchg.
>>
>> null_blk irqmode=1 completion_nsec=0 submit_queues=32 poll_queues=32
>> echo -n 0 > /sys/block/nullb0/queue/iostats
>> echo -n 2 > /sys/block/nullb0/queue/nomerges
>> io_uring -d<QD> -s<QD> -c<QD> -p0 -B1 -F1 -b512 /dev/nullb0
> This series looks good to me, by the way, what does -s and -c mean? and
> what is the tested workload?

It was a standard testing tool from fio/t/. It just does random reads
keeping QD. The flags are submission and completion batching respectively,
i.e. how many requests it submits and waits per syscall.



> 
> Regards,
> Hao
>>
>>
>>       | base | 1-10         | 1-11
>> ___________________________________________
>> QD1  | 1.88 | 2.15 (+14%)  | 2.19 (+16.4%)
>> QD4  | 2.8  | 3.06 (+9.2%) | 3.11 (+11%)
>> QD32 | 3.61 | 3.81 (+5.5%) | 3.96 (+9.6%)
>>
>> The numbers are in MIOPS, (%) is relative diff with the baseline.
>> It gives more than I expected, but the testing is not super
>> consistent, so a part of it might be due to variance.
>>
>>
>>> Pavel Begunkov (11):
>>>    io_uring: optimise io_req_task_work_add
>>>    io_uringg: add io_should_fail_tw() helper
>>>    io_uring: ban tw queue for exiting processes
>>>    io_uring: don't take ctx refs in tctx_task_work()
>>>    io_uring: add dummy io_uring_task_work_run()
>>>    task_work: add helper for signalling a task
>>>    io_uring: run io_uring task_works on TIF_NOTIFY_SIGNAL
>>>    io_uring: wire io_uring specific task work
>>>    io_uring: refactor io_run_task_work()
>>>    io_uring: remove priority tw list
>>>    io_uring: lock-free task_work stack
>>>
>>>   fs/io-wq.c                |   1 +
>>>   fs/io_uring.c             | 213 +++++++++++++++-----------------------
>>>   include/linux/io_uring.h  |   4 +
>>>   include/linux/task_work.h |   4 +
>>>   kernel/entry/kvm.c        |   1 +
>>>   kernel/signal.c           |   2 +
>>>   kernel/task_work.c        |  33 +++---
>>>   7 files changed, 115 insertions(+), 143 deletions(-)
>>>
>>
> 

-- 
Pavel Begunkov
