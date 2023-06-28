Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CF6740D29
	for <lists+io-uring@lfdr.de>; Wed, 28 Jun 2023 11:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjF1JiO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jun 2023 05:38:14 -0400
Received: from out-32.mta1.migadu.com ([95.215.58.32]:26424 "EHLO
        out-32.mta1.migadu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbjF1JTP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jun 2023 05:19:15 -0400
Message-ID: <f7991f24-5fa6-5799-c082-2eecb53f0258@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687943954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NAOxp7e2Ly9aGXTSgvDmAyxhU8Vqid+SijhTyxadzwU=;
        b=rTHjnL/rkc7ISG88QRNcb5fMGTWFiSnIMJ9wJOc3ObiEStC1DQcWdslHsLimy2m3UHFX31
        +QNq/g19uX5SlUH0JKiBTUnx8bHtASNcrcLc03Hyns1T9aMvZD1x02d0cNWaCGied8Mi2u
        4tznGYva39G6EWlfdzgjryYvK1ulaD0=
Date:   Wed, 28 Jun 2023 17:19:06 +0800
MIME-Version: 1.0
Subject: Re: [RFC PATCH 00/11] fixed worker
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20230609122031.183730-1-hao.xu@linux.dev>
Content-Language: en-US
In-Reply-To: <20230609122031.183730-1-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Gently ping this series
No idea why the mail threading is a mess, it looks fine in fsdevel list.


On 6/9/23 20:20, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> The initial feature request by users is here:
> https://github.com/axboe/liburing/issues/296
> 
> Fixed worker provide a way for users to control the io-wq threads. A
> fixed worker is worker thread which exists no matter there are works
> to do or not. We provide a new register api to register fixed workers,
> and a register api to unregister them as well. The parameter of the
> register api is the number of fixed workers users want.
> 
> For example:
> 
> ```c
> io_uring_register_iowq_fixed_workers(&ring, { .nr_workers = 5 })
> do I/O works
> io_uring_unregister_iowq_fixed_workers(&ring)
> 
> ```
> 
> After registration, there will be 5 fixed workers. User can setup their
> affinity, priority etc. freely, without adding any new register api to
> set up attributions. These workers won't be destroyed until users call
> unregister api.
> 
> Note, registering some fixed workers doesn't mean no creating normal
> workers. When there is no free workers, new normal workers can be
> created when works come. So a work may be picked up by fixed workers or
> normal workers.
> 
> If users want to offload works only to fixed workers, they can specify
> a flag FIXED_ONLY when registering fixed workers.
> 
> ```c
> io_uring_register_iowq_fixed_workers(&ring, { .nr_workers = 5, .flags |=
> FIXED_ONLY })
> 
> ```
> 
> In above case, no normal workers will be created before calling
> io_uring_register_iowq_fixed_workers().
> 
> Note:
>   - When registering fixed workers, those fixed workers are per io-wq.
>     So if an io_uring instance is shared by multiple tasks, and you want
>     all tasks to use fixed workers, all tasks have to call the regitser
>     api.
>   - if specifying FIXED_ONLY when registering fixed workers, that is per
>     io_uring instance. all works in this instance are handled by fixed
>     workers.
> 
> Therefore, if an io_uring instance is shared by two tasks, and you want
> all requests in this instance to be handled only by fixed workers, you
> have to call the register api in these two tasks and specify FIXED_ONLY
> at least once when calling register api.
> 
> 
> Hao Xu (11):
>    io-wq: fix worker counting after worker received exit signal
>    io-wq: add a new worker flag to indicate worker exit
>    io-wq: add a new type io-wq worker
>    io-wq: add fixed worker members in io_wq_acct
>    io-wq: add a new parameter for creating a new fixed worker
>    io-wq: return io_worker after successful inline worker creation
>    io_uring: add new api to register fixed workers
>    io_uring: add function to unregister fixed workers
>    io-wq: add strutures to allow to wait fixed workers exit
>    io-wq: distinguish fixed worker by its name
>    io_uring: add IORING_SETUP_FIXED_WORKER_ONLY and its friend
> 
>   include/uapi/linux/io_uring.h |  20 +++
>   io_uring/io-wq.c              | 275 ++++++++++++++++++++++++++++++----
>   io_uring/io-wq.h              |   3 +
>   io_uring/io_uring.c           | 132 +++++++++++++++-
>   4 files changed, 397 insertions(+), 33 deletions(-)
> 

