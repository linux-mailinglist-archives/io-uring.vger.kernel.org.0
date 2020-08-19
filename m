Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC24024A198
	for <lists+io-uring@lfdr.de>; Wed, 19 Aug 2020 16:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHSOV7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Aug 2020 10:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgHSOV6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Aug 2020 10:21:58 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A798C061757;
        Wed, 19 Aug 2020 07:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OM9WQWb562JnQ8J9qmB6TNE93wwhfVi68/R72R/S3h0=; b=BUM4YlZD5Yzmb8kaTUCuZ6lBKL
        sDkrBxK8WowYEFSqfVTPPZMnOn8zTD2mLHohwdxCiIDp92t/Gs0Da+jg9LgTXbCOXXmH5vXocflo3
        4cQrotNxKJ994S1WlTq8sVi+GhSNXq9fBNY0FmxCEw/pqL6a02cINpbs3s9kGcVAJugcl4u0QfvcG
        Jzp0W4//UkQV81HYqI5VCVAaQc7hnJRt72wcDM+htFYNRFfwXOWkFmcGaVlBcHM9+1sL+w1xc/G8r
        xEIBJQ+DOcVJUNPf5PqDb405kHSlQ8HXtH8busyTSb3Uk68tXQwhMgVzlZRwNY44I5zS0U+tvFsrZ
        kFnJgdlA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8Oy9-0004od-0T; Wed, 19 Aug 2020 14:21:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C297F3003E1;
        Wed, 19 Aug 2020 16:21:34 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AB49F20D805B3; Wed, 19 Aug 2020 16:21:34 +0200 (CEST)
Date:   Wed, 19 Aug 2020 16:21:34 +0200
From:   peterz@infradead.org
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] sched: Invoke io_wq_worker_sleeping() with enabled
 preemption
Message-ID: <20200819142134.GD2674@hirez.programming.kicks-ass.net>
References: <20200819123758.6v45rj2gvojddsnn@linutronix.de>
 <20200819131507.GC2674@hirez.programming.kicks-ass.net>
 <20200819133320.bxwb3ikjswyhmsyg@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819133320.bxwb3ikjswyhmsyg@linutronix.de>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 19, 2020 at 03:33:20PM +0200, Sebastian Andrzej Siewior wrote:
> On 2020-08-19 15:15:07 [+0200], peterz@infradead.org wrote:

> If you want to optimize further, we could move PF_IO_WORKER to an lower
> bit. x86 can test for both via
> (gcc-10)
> |         testl   $536870944, 44(%rbp)    #, _11->flags
> |         jne     .L1635  #,
> 
> (clang-9)
> |         testl   $536870944, 44(%rbx)    # imm = 0x20000020
> |         je      .LBB112_6
> 
> 
> but ARM can't and does
> |          ldr     r1, [r5, #16]   @ tsk_3->flags, tsk_3->flags
> |         mov     r2, #32 @ tmp157,
> |         movt    r2, 8192        @ tmp157,
> |         tst     r2, r1  @ tmp157, tsk_3->flags
> |         beq     .L998           @,
> 
> same ARM64
> |         ldr     w0, [x20, 60]   //, _11->flags
> |         and     w0, w0, 1073741792      // tmp117, _11->flags,
> |         and     w0, w0, -536870849      // tmp117, tmp117,
> |         cbnz    w0, .L453       // tmp117,
> 
> using 0x10 for PF_IO_WORKER instead will turn this into:
> |         ldr     w0, [x20, 60]   //, _11->flags
> |         tst     w0, 48  // _11->flags,
> |         bne     .L453           //,
> 
> ARM:
> |         ldr     r2, [r5, #16]   @ tsk_3->flags, tsk_3->flags
> |         tst     r2, #48 @ tsk_3->flags,
> |         beq     .L998           @,

Good point, AFAICT there's a number of low bits still open (and we can
shuffle if we have to), so sure put a patch in to that effect while
you're at it.


