Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70305466F2F
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 02:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377968AbhLCBnS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Dec 2021 20:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377969AbhLCBnS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Dec 2021 20:43:18 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA807C06174A
        for <io-uring@vger.kernel.org>; Thu,  2 Dec 2021 17:39:54 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id j3so2483838wrp.1
        for <io-uring@vger.kernel.org>; Thu, 02 Dec 2021 17:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=SbrgZd0SZ/lfKkVT+rR8/XBqOQeej0B/tc0wGiCxBs0=;
        b=bD5SjFGMbiUJuiLz32a1IJv7TbyXsrFSF8c2SaejD6hNKnpU8EV2ZqgULGKXnifEL1
         B2JpHUBKC/oqhr60TTkd7UNe4Bhv64dqaYi7Avj5dr+xLovAHubmFzSSfCnI/u3lbQH5
         HbFYTaT+D3PPqrbVp8ApO0YZG7rI1GPMbJUYQCdEIE11Lrrul8kG2DnI9IhdMkDwF4ji
         BCPgCNq1iU3hTUqF3oOyZdokw4IfN1Bv5luake0YF3Sp6+ErrRtCS3gmWeRD1kd/beku
         3cycVhvk4jkr2uAvpt6svEWx0p/7NGfLdoxOQ4710wJiUYs2ILGdyiIBb2lYDWwWup7P
         NcGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=SbrgZd0SZ/lfKkVT+rR8/XBqOQeej0B/tc0wGiCxBs0=;
        b=doW5BEIsuzjXVy+IRTsaSkcpITfdPbNdmo/Og4vP36fa59zeMRFyTlyOUry0ab/LOW
         A6BbtrpqoUpP99FuwjpQJNWiCHw7q2jkWKQ2vm7DtOUcT05V/QYPtsv7VrK7ui3HPzYI
         ORQLlYQzTRnCgK1xTvPMkXnNHPhDM6jBm5+GU8UzxW6tw72pGP/xWwvUdfIKpPchh2Ul
         SOGn0QXYxAiS68AITFalEcpOisrsmfaaeNyaX06VyPcWfovPy2BDrNH6IPhAm6JrnHxh
         xqtkchA2k5sl9h2J/uzNnWCBifF0ogF+lax3i/nvWB+kN4T9+HEKeqT48hbSW5492Ggl
         mXuw==
X-Gm-Message-State: AOAM533FbCbL8MHr92NPUie17Z/MyipH6IaDOulKocP7W1+NGscKZvkJ
        jLsYtZe4piMTQNvzDR8N2nMQusLcvVA=
X-Google-Smtp-Source: ABdhPJzo9ay6ofybGLBpYRWY3n9npQVEJL4OghPvf10jULgJ9g0+5BWYZbV4mG1NKAmcGudeIVkatQ==
X-Received: by 2002:a05:6000:1869:: with SMTP id d9mr17502566wri.416.1638495593105;
        Thu, 02 Dec 2021 17:39:53 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.137])
        by smtp.gmail.com with ESMTPSA id l22sm1123927wmp.34.2021.12.02.17.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 17:39:52 -0800 (PST)
Message-ID: <e63b44a9-72ba-09fd-82d8-448fce356a9a@gmail.com>
Date:   Fri, 3 Dec 2021 01:39:55 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v6 0/6] task work optimization
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211126100740.196550-1-haoxu@linux.alibaba.com>
Content-Language: en-US
In-Reply-To: <20211126100740.196550-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/26/21 10:07, Hao Xu wrote:
> v4->v5
> - change the implementation of merge_wq_list
> 
> v5->v6
> - change the logic of handling prior task list to:
>    1) grabbed uring_lock: leverage the inline completion infra
>    2) otherwise: batch __req_complete_post() calls to save
>       completion_lock operations.

some testing for v6, first is taking first 5 patches (1-5), and
then all 6 (see 1-6).

modprobe null_blk no_sched=1 irqmode=1 completion_nsec=0 submit_queues=16 poll_queues=32 hw_queue_depth=128
echo 2 | sudo tee /sys/block/nullb0/queue/nomerges
echo 0 | sudo tee /sys/block/nullb0/queue/iostats
mitigations=off

added this to test non-sqpoll:

@@ -2840,7 +2840,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
                 return;
         req->result = res;
         req->io_task_work.func = io_req_task_complete;
-       io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
+       io_req_task_work_add(req, true);
  }

# 1-5, sqpoll=0
nice -n -20 taskset -c 0 ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 /dev/nullb0
IOPS=3238688, IOS/call=32/32, inflight=32 (32)
IOPS=3299776, IOS/call=32/32, inflight=32 (32)
IOPS=3328416, IOS/call=32/32, inflight=32 (32)
IOPS=3291488, IOS/call=32/32, inflight=32 (32)
IOPS=3284480, IOS/call=32/32, inflight=32 (32)
IOPS=3305248, IOS/call=32/32, inflight=32 (32)
IOPS=3275392, IOS/call=32/32, inflight=32 (32)
IOPS=3301376, IOS/call=32/32, inflight=32 (32)
IOPS=3287392, IOS/call=32/32, inflight=32 (32)

# 1-5, sqpoll=1
nice -n -20  ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 /dev/nullb0
IOPS=2730752, IOS/call=2730752/2730752, inflight=32 (32)
IOPS=2822432, IOS/call=-1/-1, inflight=0 (32)
IOPS=2818464, IOS/call=-1/-1, inflight=32 (32)
IOPS=2802880, IOS/call=-1/-1, inflight=0 (32)
IOPS=2773440, IOS/call=-1/-1, inflight=32 (32)
IOPS=2827296, IOS/call=-1/-1, inflight=32 (32)
IOPS=2808320, IOS/call=-1/-1, inflight=32 (32)
IOPS=2793120, IOS/call=-1/-1, inflight=32 (32)
IOPS=2769632, IOS/call=-1/-1, inflight=32 (32)
IOPS=2752896, IOS/call=-1/-1, inflight=32 (32)

# 1-6, sqpoll=0
nice -n -20 taskset -c 0 ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 /dev/nullb0
IOPS=3219552, IOS/call=32/32, inflight=32 (32)
IOPS=3284128, IOS/call=32/32, inflight=32 (32)
IOPS=3305024, IOS/call=32/32, inflight=32 (32)
IOPS=3301920, IOS/call=32/32, inflight=32 (32)
IOPS=3330592, IOS/call=32/32, inflight=32 (32)
IOPS=3286496, IOS/call=32/32, inflight=32 (32)
IOPS=3236160, IOS/call=32/32, inflight=32 (32)
IOPS=3307552, IOS/call=32/32, inflight=32 (32)

# 1-6, sqpoll=1
nice -n -20  ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 /dev/nullb0
IOPS=2777152, IOS/call=2777152/2777152, inflight=32 (32)
IOPS=2822080, IOS/call=-1/-1, inflight=32 (32)
IOPS=2785472, IOS/call=-1/-1, inflight=0 (32)
IOPS=2763360, IOS/call=-1/-1, inflight=0 (32)
IOPS=2789856, IOS/call=-1/-1, inflight=32 (32)
IOPS=2783296, IOS/call=-1/-1, inflight=32 (32)
IOPS=2786016, IOS/call=-1/-1, inflight=0 (32)
IOPS=2773760, IOS/call=-1/-1, inflight=32 (32)
IOPS=2745408, IOS/call=-1/-1, inflight=32 (32)
IOPS=2764352, IOS/call=-1/-1, inflight=32 (32)
IOPS=2766912, IOS/call=-1/-1, inflight=32 (32)
IOPS=2757216, IOS/call=-1/-1, inflight=32 (32)

So, no difference here as expected, it just takes uring_lock
as per v6 changes and goes through the old path. Than I added
this to compare old vs new paths:

@@ -2283,7 +2283,7 @@ static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ct
                         ctx_flush_and_put(*ctx, locked);
                         *ctx = req->ctx;
                         /* if not contended, grab and improve batching */
-                       *locked = mutex_trylock(&(*ctx)->uring_lock);
+                       // *locked = mutex_trylock(&(*ctx)->uring_lock);
                         percpu_ref_get(&(*ctx)->refs);
                         if (unlikely(!*locked))
                                 spin_lock(&(*ctx)->completion_lock);


# 1-6 + no trylock, sqpoll=0
nice -n -20 taskset -c 0 ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 /dev/nullb0
IOPS=3239040, IOS/call=32/32, inflight=32 (32)
IOPS=3244800, IOS/call=32/32, inflight=32 (32)
IOPS=3208544, IOS/call=32/32, inflight=32 (32)
IOPS=3264384, IOS/call=32/32, inflight=32 (32)
IOPS=3264000, IOS/call=32/32, inflight=32 (32)
IOPS=3296960, IOS/call=32/32, inflight=32 (32)
IOPS=3283424, IOS/call=32/32, inflight=32 (32)
IOPS=3284064, IOS/call=32/32, inflight=32 (32)
IOPS=3275232, IOS/call=32/32, inflight=32 (32)
IOPS=3261248, IOS/call=32/32, inflight=32 (32)
IOPS=3273792, IOS/call=32/32, inflight=32 (32)

#1-6 + no trylock, sqpoll=1
nice -n -20  ./io_uring -d32 -s32 -c32 -p0 -B1 -F1 -b512 /dev/nullb0
IOPS=2676736, IOS/call=2676736/2676736, inflight=32 (32)
IOPS=2639776, IOS/call=-1/-1, inflight=32 (32)
IOPS=2660000, IOS/call=-1/-1, inflight=32 (32)
IOPS=2639584, IOS/call=-1/-1, inflight=32 (32)
IOPS=2634592, IOS/call=-1/-1, inflight=0 (32)
IOPS=2611488, IOS/call=-1/-1, inflight=32 (32)
IOPS=2647360, IOS/call=-1/-1, inflight=32 (32)
IOPS=2630720, IOS/call=-1/-1, inflight=32 (32)
IOPS=2663200, IOS/call=-1/-1, inflight=32 (32)
IOPS=2694240, IOS/call=-1/-1, inflight=32 (32)
IOPS=2674592, IOS/call=-1/-1, inflight=32 (32)

Seems it goes a little bit down, but not much. Considering that
it's an optimisation for cases where there is no batching at all,
that's good.

-- 
Pavel Begunkov
