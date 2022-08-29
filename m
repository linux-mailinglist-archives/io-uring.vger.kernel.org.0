Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A52B5A437C
	for <lists+io-uring@lfdr.de>; Mon, 29 Aug 2022 09:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiH2HB2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Aug 2022 03:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiH2HB0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Aug 2022 03:01:26 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF9C474E6
        for <io-uring@vger.kernel.org>; Mon, 29 Aug 2022 00:01:25 -0700 (PDT)
Message-ID: <887cc470-3a1a-2f84-bb8c-fc2139f5f7a2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661756484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SR0N17bCVt16Pof4vOaMYmO84PRLQzwEa+1FJfa8mj4=;
        b=Q/wp8ynQezIL/c96sSXxs75tkB5Nvz+o0bGTjQo2NaB1u293xPR6Oau8N1GCgFw6RQzpH8
        MKQRSAdK6CKXFwUmRcLc7Z+E3pBmxQET5EUb6l08o5aBM2iOS7pDllUzLMMDhHTTLKp8nj
        tf5Fb5jOB3Bj3y1Io5VDJ1LBOA98g3k=
Date:   Mon, 29 Aug 2022 15:01:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next v3 0/7] io_uring: defer task work to when it is
 needed
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
References: <20220819121946.676065-1-dylany@fb.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <20220819121946.676065-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/22 20:19, Dylan Yudaken wrote:
> We have seen workloads which suffer due to the way task work is currently
> scheduled. This scheduling can cause non-trivial tasks to run interrupting
> useful work on the workload. For example in network servers, a large async
> recv may run, calling memcpy on a large packet, interrupting a send. Which
> would add latency.
> 
> This series adds an option to defer async work until user space calls
> io_uring_enter with the GETEVENTS flag. This allows the workload to choose
> when to schedule async work and have finer control (at the expense of
> complexity of managing this) of scheduling.
> 
> Patches 1,2 are prep patches
> Patch 3 changes io_uring_enter to not pre-run task work
> Patch 4/5/6 adds the new flag and functionality
> Patch 7 adds tracing for the local task work running
> 
> Changes since v2:
>   - add a patch to trace local task work run
>   - return -EEXIST if calling from the wrong task
>   - properly handle shutting down due to an exec
>   - remove 'all' parameter from io_run_task_work_ctx
>   
> Changes since v1:
>   - Removed the first patch (using ctx variable) which was broken
>   - Require IORING_SETUP_SINGLE_ISSUER and make sure waiter task
>     is the same as the submitter task
>   - Just don't run task work at the start of io_uring_enter (Pavel's
>     suggestion)
>   - Remove io_move_task_work_from_local
>   - Fix locking bugs
> 
> Dylan Yudaken (7):
>    io_uring: remove unnecessary variable
>    io_uring: introduce io_has_work
>    io_uring: do not run task work at the start of io_uring_enter
>    io_uring: add IORING_SETUP_DEFER_TASKRUN
>    io_uring: move io_eventfd_put
>    io_uring: signal registered eventfd to process deferred task work
>    io_uring: trace local task work run
> 
>   include/linux/io_uring_types.h  |   3 +
>   include/trace/events/io_uring.h |  29 ++++
>   include/uapi/linux/io_uring.h   |   7 +
>   io_uring/cancel.c               |   2 +-
>   io_uring/io_uring.c             | 264 ++++++++++++++++++++++++++------
>   io_uring/io_uring.h             |  29 +++-
>   io_uring/rsrc.c                 |   2 +-
>   7 files changed, 285 insertions(+), 51 deletions(-)
> 
> 
> base-commit: 5993000dc6b31b927403cee65fbc5f9f070fa3e4
> prerequisite-patch-id: cb1d024945aa728d09a131156140a33d30bc268b

Apart from the comments, others looks good to me,

Acked-by: Hao Xu <howeyxu@tencent.com>

