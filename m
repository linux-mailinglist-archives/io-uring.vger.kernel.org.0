Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FB0466F79
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 03:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350518AbhLCCE7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Dec 2021 21:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240452AbhLCCE6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Dec 2021 21:04:58 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49957C06174A
        for <io-uring@vger.kernel.org>; Thu,  2 Dec 2021 18:01:35 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id i8-20020a7bc948000000b0030db7b70b6bso3706447wml.1
        for <io-uring@vger.kernel.org>; Thu, 02 Dec 2021 18:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=HId2i941hAnsQgAeDrMaa6iGB8quNOU1gS7BjcqAREQ=;
        b=BjYmJXNncPiiVhKqrN+qYI5nih8u17/INGx1EBUOtupIt2TJL4f2/gMI+9WPkkVmrC
         CcfuECSqYvl2FdD1BFx3USSbNAXmj8VbPfaNDl3cP9OthKJeCG5irXZ2iPbOXY4HE7Zk
         sd6TT0A3zmm71RR0B+EsrP+v3xmtAKz2crNPEtZ7sfwT8wQzFmFjRmhsG3bDIN3VWyXP
         2jXjHocFkGB1t7sDgGIeSY1blygCZKCjNwUfspQP2UP2zi+WdC9q09OFI+GgL6UxqXPS
         9AkTKXUwouiFiRx7an9bJ87IwJhJHaxEQxq+2hDHRtMRb9zfR5O2jBaxV8Kjo1v3rWrW
         SFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=HId2i941hAnsQgAeDrMaa6iGB8quNOU1gS7BjcqAREQ=;
        b=nkRjBY4plqq3JF6xjLwDbvBVsv4WDeOwoYK+G7OkCA0ckLPf9KejkSYjZm8jrqpDBO
         pziE8DmYbzPNbNWOAXJPA2L+TACsAiUWjdwEWR0hFqNw5Gry88R4MraNxNF78FFFvGy2
         FV7BVUlVByKy4mIsa2phMiOK0epFEtB1ek5Bi4YaU2I+vEA39ElDdhFPIFWnCYLJGBDq
         P61KKozt7F29pR2Z7d0XfWhPHxeB1Whfiqi5JSaqgWccAYcXgPBsTXoDz4nWnO0LKtBs
         c87TnXYsY8tjLP3KM6tc3pHkgSDnhotXoPXBiSnRF5aas1NgTFXwfEGLmK/iad2yqNtl
         ylRQ==
X-Gm-Message-State: AOAM530RA8azEZQCxyW2AK+AIjs/+TquClbo9dolGVBl1GHzIx6Fe4ES
        s1f5DARcfaxVd0N/e3czHMaLzlZj2W0=
X-Google-Smtp-Source: ABdhPJyz55eA8xZr4p8s5UeTAGDb7TbGGHzCDJxVEv7She/anJPPKqUxENb+p3HoaaGOgtcgY3jQLA==
X-Received: by 2002:a7b:cd90:: with SMTP id y16mr11382580wmj.84.1638496893838;
        Thu, 02 Dec 2021 18:01:33 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.137])
        by smtp.gmail.com with ESMTPSA id c4sm1318581wrr.37.2021.12.02.18.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 18:01:33 -0800 (PST)
Message-ID: <a3515db3-2c22-fa32-746e-3210d84386e9@gmail.com>
Date:   Fri, 3 Dec 2021 02:01:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 0/6] task work optimization
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211126100740.196550-1-haoxu@linux.alibaba.com>
 <e63b44a9-72ba-09fd-82d8-448fce356a9a@gmail.com>
In-Reply-To: <e63b44a9-72ba-09fd-82d8-448fce356a9a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/3/21 01:39, Pavel Begunkov wrote:
> On 11/26/21 10:07, Hao Xu wrote:
>> v4->v5
>> - change the implementation of merge_wq_list
>>
>> v5->v6
>> - change the logic of handling prior task list to:
>>    1) grabbed uring_lock: leverage the inline completion infra
>>    2) otherwise: batch __req_complete_post() calls to save
>>       completion_lock operations.
> 
> some testing for v6, first is taking first 5 patches (1-5), and
> then all 6 (see 1-6).
> 
> modprobe null_blk no_sched=1 irqmode=1 completion_nsec=0 submit_queues=16 poll_queues=32 hw_queue_depth=128
> echo 2 | sudo tee /sys/block/nullb0/queue/nomerges
> echo 0 | sudo tee /sys/block/nullb0/queue/iostats
> mitigations=off
> 
> added this to test non-sqpoll:
> 
> @@ -2840,7 +2840,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
>                  return;
>          req->result = res;
>          req->io_task_work.func = io_req_task_complete;
> -       io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
> +       io_req_task_work_add(req, true);
>   }
> 
> # 1-5, sqpoll=0
> nice -n -20 taskset -c 0 ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 /dev/nullb0
> IOPS=3238688, IOS/call=32/32, inflight=32 (32)
> IOPS=3299776, IOS/call=32/32, inflight=32 (32)
> IOPS=3328416, IOS/call=32/32, inflight=32 (32)
> IOPS=3291488, IOS/call=32/32, inflight=32 (32)
> IOPS=3284480, IOS/call=32/32, inflight=32 (32)
> IOPS=3305248, IOS/call=32/32, inflight=32 (32)
> IOPS=3275392, IOS/call=32/32, inflight=32 (32)
> IOPS=3301376, IOS/call=32/32, inflight=32 (32)
> IOPS=3287392, IOS/call=32/32, inflight=32 (32)
> 
> # 1-5, sqpoll=1
> nice -n -20  ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 /dev/nullb0
> IOPS=2730752, IOS/call=2730752/2730752, inflight=32 (32)
> IOPS=2822432, IOS/call=-1/-1, inflight=0 (32)
> IOPS=2818464, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2802880, IOS/call=-1/-1, inflight=0 (32)
> IOPS=2773440, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2827296, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2808320, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2793120, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2769632, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2752896, IOS/call=-1/-1, inflight=32 (32)
> 
> # 1-6, sqpoll=0
> nice -n -20 taskset -c 0 ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 /dev/nullb0
> IOPS=3219552, IOS/call=32/32, inflight=32 (32)
> IOPS=3284128, IOS/call=32/32, inflight=32 (32)
> IOPS=3305024, IOS/call=32/32, inflight=32 (32)
> IOPS=3301920, IOS/call=32/32, inflight=32 (32)
> IOPS=3330592, IOS/call=32/32, inflight=32 (32)
> IOPS=3286496, IOS/call=32/32, inflight=32 (32)
> IOPS=3236160, IOS/call=32/32, inflight=32 (32)
> IOPS=3307552, IOS/call=32/32, inflight=32 (32)
> 
> # 1-6, sqpoll=1
> nice -n -20  ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 /dev/nullb0
> IOPS=2777152, IOS/call=2777152/2777152, inflight=32 (32)
> IOPS=2822080, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2785472, IOS/call=-1/-1, inflight=0 (32)
> IOPS=2763360, IOS/call=-1/-1, inflight=0 (32)
> IOPS=2789856, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2783296, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2786016, IOS/call=-1/-1, inflight=0 (32)
> IOPS=2773760, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2745408, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2764352, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2766912, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2757216, IOS/call=-1/-1, inflight=32 (32)
> 
> So, no difference here as expected, it just takes uring_lock
> as per v6 changes and goes through the old path. Than I added
> this to compare old vs new paths:
> 
> @@ -2283,7 +2283,7 @@ static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ct
>                          ctx_flush_and_put(*ctx, locked);
>                          *ctx = req->ctx;
>                          /* if not contended, grab and improve batching */
> -                       *locked = mutex_trylock(&(*ctx)->uring_lock);
> +                       // *locked = mutex_trylock(&(*ctx)->uring_lock);
>                          percpu_ref_get(&(*ctx)->refs);
>                          if (unlikely(!*locked))
>                                  spin_lock(&(*ctx)->completion_lock);
> 
> 
> # 1-6 + no trylock, sqpoll=0
> nice -n -20 taskset -c 0 ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 /dev/nullb0
> IOPS=3239040, IOS/call=32/32, inflight=32 (32)
> IOPS=3244800, IOS/call=32/32, inflight=32 (32)
> IOPS=3208544, IOS/call=32/32, inflight=32 (32)
> IOPS=3264384, IOS/call=32/32, inflight=32 (32)
> IOPS=3264000, IOS/call=32/32, inflight=32 (32)
> IOPS=3296960, IOS/call=32/32, inflight=32 (32)
> IOPS=3283424, IOS/call=32/32, inflight=32 (32)
> IOPS=3284064, IOS/call=32/32, inflight=32 (32)
> IOPS=3275232, IOS/call=32/32, inflight=32 (32)
> IOPS=3261248, IOS/call=32/32, inflight=32 (32)
> IOPS=3273792, IOS/call=32/32, inflight=32 (32)
> 
> #1-6 + no trylock, sqpoll=1
> nice -n -20  ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 /dev/nullb0
> IOPS=2676736, IOS/call=2676736/2676736, inflight=32 (32)
> IOPS=2639776, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2660000, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2639584, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2634592, IOS/call=-1/-1, inflight=0 (32)
> IOPS=2611488, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2647360, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2630720, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2663200, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2694240, IOS/call=-1/-1, inflight=32 (32)
> IOPS=2674592, IOS/call=-1/-1, inflight=32 (32)
> 
> Seems it goes a little bit down, but not much. Considering that
> it's an optimisation for cases where there is no batching at all,
> that's good.

But testing with liburing tests I'm getting the stuff below,
e.g. cq-overflow hits it every time. Double checked that
I took [RESEND] version of 6/6.

[   30.360370] BUG: scheduling while atomic: cq-overflow/2082/0x00000000
[   30.360520] Call Trace:
[   30.360523]  <TASK>
[   30.360527]  dump_stack_lvl+0x4c/0x63
[   30.360536]  dump_stack+0x10/0x12
[   30.360540]  __schedule_bug.cold+0x50/0x5e
[   30.360545]  __schedule+0x754/0x900
[   30.360551]  ? __io_cqring_overflow_flush+0xb6/0x200
[   30.360558]  schedule+0x55/0xd0
[   30.360563]  schedule_timeout+0xf8/0x140
[   30.360567]  ? prepare_to_wait_exclusive+0x58/0xa0
[   30.360573]  __x64_sys_io_uring_enter+0x69c/0x8e0
[   30.360578]  ? io_rsrc_buf_put+0x30/0x30
[   30.360582]  do_syscall_64+0x3b/0x80
[   30.360588]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   30.360592] RIP: 0033:0x7f9f9680118d
[   30.360618]  </TASK>
[   30.362295] BUG: scheduling while atomic: cq-overflow/2082/0x7ffffffe
[   30.362396] Call Trace:
[   30.362397]  <TASK>
[   30.362399]  dump_stack_lvl+0x4c/0x63
[   30.362406]  dump_stack+0x10/0x12
[   30.362409]  __schedule_bug.cold+0x50/0x5e
[   30.362413]  __schedule+0x754/0x900
[   30.362419]  schedule+0x55/0xd0
[   30.362423]  schedule_timeout+0xf8/0x140
[   30.362427]  ? prepare_to_wait_exclusive+0x58/0xa0
[   30.362431]  __x64_sys_io_uring_enter+0x69c/0x8e0
[   30.362437]  ? io_rsrc_buf_put+0x30/0x30
[   30.362440]  do_syscall_64+0x3b/0x80
[   30.362445]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   30.362449] RIP: 0033:0x7f9f9680118d
[   30.362470]  </TASK>
<repeated>


-- 
Pavel Begunkov
