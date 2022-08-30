Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4655A65E4
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 16:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiH3OE6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 10:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiH3OE4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 10:04:56 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA268DF6
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 07:04:53 -0700 (PDT)
Message-ID: <13e855cc-cfc5-8f36-e051-d7aa18aa21fd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661868292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NMNKtdgXNsmZWDWXaUFSegK2I2YOZJpYwkLoz6xWOzg=;
        b=OPAXnfHtyKeGMjnj5LVzzvdlK1OY6777GPGCNQXoZL+axZz7/s+yDQfpxtvZZVmrmm+CLM
        okq3h/AcZ60HCjFmB+ORK94yV75iaiGXXGeGG6nbKFfpXXhMlMY1VWCffMW3FdLo97MlbP
        T1CGJ8n+r+SEabjkIFkzkGic6sbeNTU=
Date:   Tue, 30 Aug 2022 22:04:10 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next v3 4/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     Kernel Team <Kernel-team@fb.com>
References: <20220819121946.676065-1-dylany@fb.com>
 <20220819121946.676065-5-dylany@fb.com>
 <3e328ad8-e06a-f6be-f6fb-1d9b2fbbe9ae@linux.dev>
 <8ef2606d55d1097a17c24062fa64e39d43903755.camel@fb.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <8ef2606d55d1097a17c24062fa64e39d43903755.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/30/22 21:34, Dylan Yudaken wrote:
> On Tue, 2022-08-30 at 21:19 +0800, Hao Xu wrote:
>> On 8/19/22 20:19, Dylan Yudaken wrote:
>>> Allow deferring async tasks until the user calls io_uring_enter(2)
>>> with
>>> the IORING_ENTER_GETEVENTS flag. Enable this mode with a flag at
>>> io_uring_setup time. This functionality requires that the later
>>> io_uring_enter will be called from the same submission task, and
>>> therefore
>>> restrict this flag to work only when IORING_SETUP_SINGLE_ISSUER is
>>> also
>>> set.
>>>
>>> Being able to hand pick when tasks are run prevents the problem
>>> where
>>> there is current work to be done, however task work runs anyway.
>>>
>>> For example, a common workload would obtain a batch of CQEs, and
>>> process
>>> each one. Interrupting this to additional taskwork would add
>>> latency but
>>> not gain anything. If instead task work is deferred to just before
>>> more
>>> CQEs are obtained then no additional latency is added.
>>>
>>> The way this is implemented is by trying to keep task work local to
>>> a
>>> io_ring_ctx, rather than to the submission task. This is required,
>>> as the
>>> application will want to wake up only a single io_ring_ctx at a
>>> time to
>>> process work, and so the lists of work have to be kept separate.
>>>
>>> This has some other benefits like not having to check the task
>>> continually
>>> in handle_tw_list (and potentially unlocking/locking those), and
>>> reducing
>>> locks in the submit & process completions path.
>>>
>>> There are networking cases where using this option can reduce
>>> request
>>> latency by 50%. For example a contrived example using [1] where the
>>> client
>>> sends 2k data and receives the same data back while doing some
>>> system
>>> calls (to trigger task work) shows this reduction. The reason ends
>>> up
>>> being that if sending responses is delayed by processing task work,
>>> then
>>> the client side sits idle. Whereas reordering the sends first means
>>> that
>>> the client runs it's workload in parallel with the local task work.
>>>
>>
>> Sorry, seems I misunderstood the purpose of this patchset. Allow me
>> to
>> ask a question: "we always first submit sqes then handle task work
>> (in IORING_SETUP_COOP_TASKRUN mode), how could the sending be
>> interrupted by task works?"
> 
> IORING_SETUP_COOP_TASKRUN causes the task to not be interrupted simply
> for task work, however it will still be run on every system call even
> if completions are not about to be processed.
> 

gotcha, then sqpoll may not be a tenant of this feature..


> IoUring task work (unlike say epoll wakeups) can take a non-trivial
> amount of time, and so running them closer to when they are used can
> reduce latency of other unrelated operations by not unnecessarily
> stalling them.
> 

