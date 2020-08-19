Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F9424A78E
	for <lists+io-uring@lfdr.de>; Wed, 19 Aug 2020 22:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHSULt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Aug 2020 16:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHSULt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Aug 2020 16:11:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B61BC061757;
        Wed, 19 Aug 2020 13:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aWJlZuyBEoP4j5aoc4JrDsUNwgvnVjmYGVt0UgJZ9d0=; b=Ji3IzFdBJP0RJnXsOKuepMkSP3
        Dry6qmMNImqRP/gKYNREt724rVeU3rOs/ANZVz8gD74oH+K58RAqd8GUuB8InXFCG0y/MyjCtOhBu
        rJdf1PyCMELT8EjVyz0fwj4/AzCF46m04DSdgnKMezRM4qzmDjZHh+rMaDESMZLI2D1OgaNrMF4zz
        n5H35+fg2ksMi0RhPJdqNp0IwJJ/CGGB4owBNNORj0I12xhazRXLofFt9E10J74hwqtRjconQpLg/
        fZ0/noTQg++0r/vFE9XhHURfgqP/Y4NL490Jc3kLnOWnlN7xbO0jJm76iLOBxfLGvDiO9HPNfajPs
        59FgxwcQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8UQk-00041q-1O; Wed, 19 Aug 2020 20:11:31 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 48069980C9E; Wed, 19 Aug 2020 22:11:27 +0200 (CEST)
Date:   Wed, 19 Aug 2020 22:11:27 +0200
From:   Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [PATCH 2/2] sched: Cache task_struct::flags in
 sched_submit_work()
Message-ID: <20200819201127.GP3982@worktop.programming.kicks-ass.net>
References: <20200819142134.GD2674@hirez.programming.kicks-ass.net>
 <20200819195505.y3fxk72sotnrkczi@linutronix.de>
 <20200819200025.lqvmyefqnbok5i4f@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819200025.lqvmyefqnbok5i4f@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 19, 2020 at 10:00:25PM +0200, Sebastian Andrzej Siewior wrote:
> sched_submit_work() is considered to be a hot path. The preempt_disable()
> instruction is a compiler barrier and forces the compiler to load
> task_struct::flags for the second comparison.
> By using a local variable, the compiler can load the value once and keep it in
> a register for the second comparison.
> 
> Verified on x86-64 with gcc-10.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> 
> Optimisation at molecule level, part two. Drop this in case this branch
> isn't consider *that* hot and the cache hot value can be loaded again.
> But then the value is around and be speculated early on :)

That's fine, task->flags can only be changed by current.

Patches look good to me, I'll stuff them in tomorrow. Thanks!
