Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F5E4670B1
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 04:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240202AbhLCD1f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Dec 2021 22:27:35 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:42451 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230294AbhLCD1f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Dec 2021 22:27:35 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UzEPFvI_1638501849;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UzEPFvI_1638501849)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Dec 2021 11:24:10 +0800
Subject: Re: [PATCH v6 0/6] task work optimization
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211126100740.196550-1-haoxu@linux.alibaba.com>
 <e63b44a9-72ba-09fd-82d8-448fce356a9a@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <e1f0a017-2aa4-a585-f35b-aefafd035de4@linux.alibaba.com>
Date:   Fri, 3 Dec 2021 11:24:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <e63b44a9-72ba-09fd-82d8-448fce356a9a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/12/3 上午9:39, Pavel Begunkov 写道:
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
> modprobe null_blk no_sched=1 irqmode=1 completion_nsec=0 
> submit_queues=16 poll_queues=32 hw_queue_depth=128
> echo 2 | sudo tee /sys/block/nullb0/queue/nomerges
> echo 0 | sudo tee /sys/block/nullb0/queue/iostats
> mitigations=off
> 
> added this to test non-sqpoll:
> 
> @@ -2840,7 +2840,7 @@ static void io_complete_rw(struct kiocb *kiocb, 
> long res)
>                  return;
>          req->result = res;
>          req->io_task_work.func = io_req_task_complete;
> -       io_req_task_work_add(req, !!(req->ctx->flags & 
> IORING_SETUP_SQPOLL));
> +       io_req_task_work_add(req, true);
>   }
> 
> # 1-5, sqpoll=0
> nice -n -20 taskset -c 0 ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 
> /dev/nullb0
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
> nice -n -20 taskset -c 0 ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 
> /dev/nullb0
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
> @@ -2283,7 +2283,7 @@ static void handle_prior_tw_list(struct 
> io_wq_work_node *node, struct io_ring_ct
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
> nice -n -20 taskset -c 0 ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 
> /dev/nullb0
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
Nice, thanks for testing this, now it's clear that the inline completion
path is faster.

Regards,
Hao
> 

