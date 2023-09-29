Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3E27B2991
	for <lists+io-uring@lfdr.de>; Fri, 29 Sep 2023 02:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjI2AcA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 20:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjI2Ab7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 20:31:59 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5DEF3;
        Thu, 28 Sep 2023 17:31:57 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1695947516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+u3TarIa0+rVWEyaTPpwPe6AaLChhJ6eXR4yVtzasdM=;
        b=QhDTpHGuYz4qr01JALc3074ZllK0avf1T4U89sin9QMQoVlx76dq72h7xeeCTYyr0Wzl6z
        AMKfks/nLQbUp0GmJlu0uW0Ok/fLmVgjnsAOJ+J2dADqjxy5sjOHSeyhvY9zH/SalamHhv
        lUCfjAibXoUSINWxkBaxD5phCy72BOoZwmuGOEmuZx8xofk548pIXNNSKTlrjJSrVnuMj3
        kYK01spglqpLXLfMFyylulE0l/gWeavVgc99poCw7y+VZhhDIt/I8IecJDfcBOZsSitWVw
        4+zabl9pTOJZCWiN6CEqloa3ZTRKtJF2PVKxGj0aL2smXF4pMkHRRuphoevw6g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1695947516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+u3TarIa0+rVWEyaTPpwPe6AaLChhJ6eXR4yVtzasdM=;
        b=u5xb8PfuMNvjweQ8H2fogC9936FKKaBAbVUqJGIBa6uwAu7qbs6xmc61shvwb3d35bgUkP
        cTnRsodj2nKiJDAQ==
To:     Xiaobing Li <xiaobing.li@samsung.com>, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, axboe@kernel.dk,
        asml.silence@gmail.com
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, kun.dou@samsung.com,
        peiwei.li@samsung.com, joshi.k@samsung.com,
        kundan.kumar@samsung.com, wenwen.chen@samsung.com,
        ruyi.zhang@samsung.com, Xiaobing Li <xiaobing.li@samsung.com>
Subject: Re: [PATCH 1/3] SCHEDULER: Add an interface for counting real
 utilization.
In-Reply-To: <20230928022228.15770-2-xiaobing.li@samsung.com>
References: <20230928022228.15770-1-xiaobing.li@samsung.com>
 <CGME20230928023007epcas5p276b6e029a67001a6ed8ab28c05b2be9c@epcas5p2.samsung.com>
 <20230928022228.15770-2-xiaobing.li@samsung.com>
Date:   Fri, 29 Sep 2023 02:31:55 +0200
Message-ID: <87edihes5g.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 28 2023 at 10:22, Xiaobing Li wrote:
> Since pelt takes the running time of the thread as utilization, and for
> some threads, although they are running, they are not actually
> processing any transactions and are in an idling state.
> our goal is to count the effective working time of the thread, so as to
> Calculate the true utilization of threads.

Sorry. I can't figure out from the above what you are trying to achieve
and which problem this is actualy solving.

> +void get_sqthread_util(struct task_struct *p)
> +{
> +	struct task_struct **sqstat = kcpustat_this_cpu->sq_util;
> +
> +	for (int i = 0; i < MAX_SQ_NUM; i++) {
> +		if (sqstat[i] && (task_cpu(sqstat[i]) != task_cpu(p)
> +		|| sqstat[i]->__state == TASK_DEAD))
> +			sqstat[i] = NULL;
> +	}

This is unreadable.

> +
> +	if (strncmp(p->comm, "iou-sqp", 7))
> +		return;

You really want to do hard coded string parsing on every invocation of
this function, which happens at least once per tick, right?

What's so special about iou-sqp?

Nothing at all. It might be special for your particular workload but its
completely irrelevant to everyone else.

We are not adding random statistics to the hotpath just because.

Please come back once you have a proper justification for imposing this
On everyone which is not using iouring at all.

Thanks

        tglx
