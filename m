Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BFB249FBE
	for <lists+io-uring@lfdr.de>; Wed, 19 Aug 2020 15:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgHSN0E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Aug 2020 09:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgHSNQK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Aug 2020 09:16:10 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AD1C061757;
        Wed, 19 Aug 2020 06:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6OmaKKadGGCbbfJkvWKVfWa9O8hEFuHEWndvy5gHwGo=; b=Vs5d92An2unRgCOXkYuOlup+XS
        AZ35hH21bLHlG31aLN6sizaN7ank+eQl0aD1fi6OQ/I4G5+mEETjs6SCull5ijE9QJUvnPnMpZB36
        aA7ImgGnoH02ArGKJA9gZkFPb5XIT4w1S63HKofniAGrWNwCtzxMniJzGkAhk8pSq4gqj8fZoaonV
        Hb86MdsuWHtIvRTord5hhA720erjFR9WiSNY9NDk4a1FcYydnXtbJnlavOu2hn6nuHXrd0Ea9rL+Q
        WhH5ZSbTsTjBVQ63FsP17Dh7AaL6JPrl1mtqs0WFk0p1QV5d1dYUg1kxCAKYciRNzka+H15jE6tMn
        aKNksZLA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8Nvq-0005k6-Oc; Wed, 19 Aug 2020 13:15:10 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 400CE301179;
        Wed, 19 Aug 2020 15:15:07 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 08DF72BC988B4; Wed, 19 Aug 2020 15:15:07 +0200 (CEST)
Date:   Wed, 19 Aug 2020 15:15:07 +0200
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
Message-ID: <20200819131507.GC2674@hirez.programming.kicks-ass.net>
References: <20200819123758.6v45rj2gvojddsnn@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819123758.6v45rj2gvojddsnn@linutronix.de>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 19, 2020 at 02:37:58PM +0200, Sebastian Andrzej Siewior wrote:

> I don't see a significant reason why this lock should become a
> raw_spinlock_t therefore I suggest to move it after the
> tsk_is_pi_blocked() check.

> Any feedback on this vs raw_spinlock_t?
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  fs/io-wq.c          |  8 ++++----
>  kernel/sched/core.c | 10 +++++-----
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 3bbb60b97c73c..b76c0f27bd95e 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4694,18 +4694,18 @@ static inline void sched_submit_work(struct task_struct *tsk)
>  	 * in the possible wakeup of a kworker and because wq_worker_sleeping()
>  	 * requires it.
>  	 */
> -	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER)) {
> +	if (tsk->flags & PF_WQ_WORKER) {
>  		preempt_disable();
> -		if (tsk->flags & PF_WQ_WORKER)
> -			wq_worker_sleeping(tsk);
> -		else
> -			io_wq_worker_sleeping(tsk);
> +		wq_worker_sleeping(tsk);
>  		preempt_enable_no_resched();
>  	}
>  
>  	if (tsk_is_pi_blocked(tsk))
>  		return;
>  
> +	if (tsk->flags & PF_IO_WORKER)
> +		io_wq_worker_sleeping(tsk);
> +

Urgh, so this adds a branch in what is normally considered a fairly hot
path.

I'm thinking that the raw_spinlock_t option would permit leaving that
single:

	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER))

branch intact?
