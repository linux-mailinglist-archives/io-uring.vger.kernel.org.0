Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B545A1177
	for <lists+io-uring@lfdr.de>; Thu, 25 Aug 2022 15:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242327AbiHYNFk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Aug 2022 09:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242004AbiHYNFP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Aug 2022 09:05:15 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC3FB5E71
        for <io-uring@vger.kernel.org>; Thu, 25 Aug 2022 06:04:08 -0700 (PDT)
Message-ID: <8b0af4e0-67ef-7f3a-0835-79ae1f330bb6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661432645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fGScHOhQUyT2WH4S0KYD7xigiPCJ3OnnGn9QF2T15cg=;
        b=FLNWtgOFPTE6oWq+RjXPE5Q6zZSCmRYbbziUpnDKLshNxmK3oRPoEDpO2X/pf3DvxqG/UW
        /fMicsn6kmE6fthlmGkJTgfs7qM2OPVn85Wm5u+j8ECu3u3IRF4W7kiqiQiItKN8QcjWiP
        3VTT/kzzvkUjF168oJ2+dGH/tJw9TOw=
Date:   Thu, 25 Aug 2022 21:03:59 +0800
MIME-Version: 1.0
Subject: Re: [RFC 00/19] uringlet
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20220819152738.1111255-1-hao.xu@linux.dev>
In-Reply-To: <20220819152738.1111255-1-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/22 23:27, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Hi Jens and all,
> 
> This is an early RFC for a new way to do async IO. Currently io_uring
> works in a way like:
>   - issue an IO request in nowait way
>     here nowait means return error(EAGAIN) to io_uring layer when it would
>     block in deeper kernel stack.
> 
>   - issue an IO request in a normal(block) way
>     io_uring catches the EAGAIN error and create/wakeup a io-worker to
>     redo the IO request in a block way. The original context turns to
>     issue other requests. (some type of requests like buffered reads,
>     leverage task work to wipe out io-workers)
> 
> This has two main disadvantages:
>   - we have to find every block point along the kernel code path and
>     modify it to support nowait.
>     e.g.  alloc_memory() ----> if (alloc_memory() fails) return -EAGAIN
>     This hugely adds programming complexisity, especially when the code
>     path is long and complicated. For example, buffered write, we have
>     to handle locks, possibly journal part, meta data like extent node
>     misses.
> 
>   - By create/wakeup a new worker, we redo a IO request from the very
>     beginning, which means we re-walk the path from beginning to the
>     previous block point.
>     The original context backtracks to the io_uring layer from the block
>     point to submit other requests. While it's better to directly start
>     the new submission.
> 
> This RFC provides a new way to do it.
>   - We maintain a worker pool for each io_uring instance and each worker
>     in it can submit requests. The original task only needs to create the
>     first worker and return to userspace. Later it doesn't need to call
>     io_uring_enter.[1]
> 
>   - the created worker begins to submit requests. When it blocks, just
>     let it be blocked. Create/wakeup another worker to do the submission
> 
> [1] I currently keep these workers until the io_uring context exits. In
>      other words, a worker does submission, sleep, wake up, but won't
>      exit. Thus the original task don't need to create/wakeup workers.
> 
> I've done some testing:
> name: buffered write
> fs: xfs
> env: qemu box, 4 cpu, 8G mem.
> tool: fio
> 
>   - single file test:
> 
>     fio ioengine=io_uring, size=10M, bs=1024, direct=0,
>         thread=1, rw=randwrite, time_based=1, runtime=180
> 
>     async buffered writes:
>     iodepth
>        1      write: IOPS=428k, BW=418MiB/s (438MB/s)(73.5GiB/180000msec);
>        2      write: IOPS=406k, BW=396MiB/s (416MB/s)(69.7GiB/180002msec);
>        4      write: IOPS=382k, BW=373MiB/s (391MB/s)(65.6GiB/180000msec);
>        8      write: IOPS=255k, BW=249MiB/s (261MB/s)(43.7GiB/180001msec);
>        16     write: IOPS=399k, BW=390MiB/s (409MB/s)(68.5GiB/180000msec);
>        32     write: IOPS=433k, BW=423MiB/s (443MB/s)(74.3GiB/180000msec);
> 
>        1      lat (nsec): min=547, max=2929.3k, avg=1074.98, stdev=6498.72
>        2      lat (nsec): min=607, max=84320k, avg=3619.15, stdev=109104.36
>        4      lat (nsec): min=891, max=195941k, avg=9062.16, stdev=213600.71
>        8      lat (nsec): min=684, max=204164k, avg=29308.56, stdev=542490.72
>        16     lat (nsec): min=1002, max=77279k, avg=38716.65, stdev=461785.55
>        32     lat (nsec): min=674, max=75279k, avg=72673.91, stdev=588002.49
> 
> 
>     uringlet:
>     iodepth
>       1       write: IOPS=120k, BW=117MiB/s (123MB/s)(20.6GiB/180006msec);
>       2       write: IOPS=273k, BW=266MiB/s (279MB/s)(46.8GiB/180010msec);
>       4       write: IOPS=336k, BW=328MiB/s (344MB/s)(57.7GiB/180002msec);
>       8       write: IOPS=373k, BW=365MiB/s (382MB/s)(64.1GiB/180000msec);
>       16      write: IOPS=442k, BW=432MiB/s (453MB/s)(75.9GiB/180001msec);
>       32      write: IOPS=444k, BW=434MiB/s (455MB/s)(76.2GiB/180010msec);
> 
>       1       lat (nsec): min=684, max=10790k, avg=6781.23, stdev=10000.69
>       2       lat (nsec): min=650, max=91712k, avg=5690.52, stdev=136818.11
>       4       lat (nsec): min=785, max=79038k, avg=10297.04, stdev=227375.52
>       8       lat (nsec): min=862, max=97493k, avg=19804.67, stdev=350809.60
>       16      lat (nsec): min=823, max=81279k, avg=34681.33, stdev=478427.17
>       32      lat (usec): min=6, max=105935, avg=70.55, stdev=696.08
> 
> uringlet behaves worse on IOPS and lantency in small iodepth. I think
> the reason is there are more sleep and wakeup.(not sure about it, I'll
> look into it later)
> 
> The downside of uringlet:
>   - it costs more cpu resource, the reason is similar with the sqpoll case: a
>     uringlet worker keeps checking sqring to reduce latency.[2]
>   - task->plug is disabled for now since uringlet is buggy with it.
> 
> [2] For now, I allow a uringlet worker spin on the empty sqring for some
> times.
> 
> Any comments are welcome, This early RFC only supports buffered write for
> now and if the idea under it is proved to be the right way, I'll change
> it to a formal patchset and resolve the detail technical issues and try
> to support more io_uring features.
> 
> Regards,
> Hao
> 

Friendly ping...
Jens, any thoughts on this one?
