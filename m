Return-Path: <io-uring+bounces-1205-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB2E9889680
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 09:52:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A3901C303B5
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 08:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C57F613E3ED;
	Mon, 25 Mar 2024 07:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=layalina-io.20230601.gappssmtp.com header.i=@layalina-io.20230601.gappssmtp.com header.b="h0AFdGMi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4C01826E8
	for <io-uring@vger.kernel.org>; Mon, 25 Mar 2024 03:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711337460; cv=none; b=aQxvSX0+MgFfvtu9l5HDbcvjBCgSUu99J7hEtS0XLQR4rX+FDgxwRBMfXjKejCRHXA4vFKVKvm7ljK6xY5V34GJoVqXKHj0k24/6Nb2B4T8ToXrMeDlDzUpm3Co/5zfE6wlTow5v4+52B1qepGB3aSBZdJwuA6gHk91tMNFyYxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711337460; c=relaxed/simple;
	bh=GJdcmBdNREudk1C4VIw+dY27dvA5JjiC7qeQqzfIAmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kmq882ELzJRbVbTZ3QlaIITiIymyW27J1oM0yyn0/XQifQqWFZmqdkis0uNYTHR5d7inDqp8kedYz6rW0QjpP7h1+OxEHfp6xBCbZETTybYPjGH4v+jNKMo/tvs61iCGUyLY4dlZJXympEtOjLatmGZJhV25sJhg8f7NJzLVS0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=layalina.io; spf=pass smtp.mailfrom=layalina.io; dkim=pass (2048-bit key) header.d=layalina-io.20230601.gappssmtp.com header.i=@layalina-io.20230601.gappssmtp.com header.b=h0AFdGMi; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=layalina.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=layalina.io
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-512e4f4e463so4089897e87.1
        for <io-uring@vger.kernel.org>; Sun, 24 Mar 2024 20:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20230601.gappssmtp.com; s=20230601; t=1711337455; x=1711942255; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BzUUc6wah96C0KF16Z7WuQSFK5nXBsbNhg4viIXGm0M=;
        b=h0AFdGMiuJ3i7nC4UDYN38E5sPK2XF85sY8kDqa2c4QdOsC+3fUMWTuPkY9ZbyiSEr
         uwRZD8Sz7i/G02UYpql1wiznVCMoZjSK8hpMtgL69u87SFTBKF76HJ3Smzgt5/zaIUrG
         NWHQc2QmUkzzrAkzVmyHQy8M61T0jOoKxcu1sFyrWzll8xEKC3MW315hz5Ein3MU2MDs
         XGS2AHfN7OETC/fqZx82ziogoVpG55ZoUOZKuUOf3Zx2nxmHSfFFESxr/X27oUFQi4Eg
         EEK+IyuyYGqdRO5v97C17HGpu3KwHAAZ8taUY2f7Y14lMsSoCOPZPRdKTUiSkGxUhiqK
         xHWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711337455; x=1711942255;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BzUUc6wah96C0KF16Z7WuQSFK5nXBsbNhg4viIXGm0M=;
        b=gt3dNwuZqvZ+mmD9uCy1t5G+WEoBJ2z1E5rMV849BX94L5dIzZ6ph7LMH1weJy9Bx4
         z3cJPn+RlhFm5EwP+I+CXQhyaDWFq07ZICJ32O4d3AT7BxBkTkH2/s4bG003gu6DT/GL
         HyXThggXrpKMgRCTu+qiAHs3dyNP3U5RbmtVrmythTFHEIvv2SIeTsU/5qw8dTE/U4W8
         5v/aq2AGVcXP1rRJmERyASZBKMLCYpP7jZ5zNl1x3hDvdM2pjfniB31E7UDZTRWiTaEr
         Zm+NyCSx4VcagxJe3D3uAk1JFyQLFU6UGqHO1vPWBIDcV/o7kErHCh9J7Vm4msmiE8pV
         R0QQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNlcTs7u/OVElhydmzGhqF15GDDSoeWLZ1HvdcCBPo4nznIGUgGYyZPbrCi/HAP0VSej+0Q77YFpPclaOc0kMTeI7looJTS8Q=
X-Gm-Message-State: AOJu0YyveBBOlRAdPJ9CB4mlqYRnaedfiuWmvgRGqgIpTBQT+Jqm/6I2
	u56EG+0L50775wFhBleAY1tcXRnsymVFLAXodZa9bLpwav3v97DemaKkOvwo3kk=
X-Google-Smtp-Source: AGHT+IFRGoQDtCWCWqva0YLUy5VtHMRpXNRfJRnA6yjvyeiWTF1yAi1TQUciNrOr7jvbHQyyLmEkcA==
X-Received: by 2002:a2e:8654:0:b0:2d6:a9be:19e with SMTP id i20-20020a2e8654000000b002d6a9be019emr3983449ljj.46.1711337454931;
        Sun, 24 Mar 2024 20:30:54 -0700 (PDT)
Received: from airbuntu (host81-157-90-255.range81-157.btcentralplus.com. [81.157.90.255])
        by smtp.gmail.com with ESMTPSA id r16-20020a05600c35d000b004147de73a5asm6870862wmq.24.2024.03.24.20.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Mar 2024 20:30:54 -0700 (PDT)
Date: Mon, 25 Mar 2024 03:30:52 +0000
From: Qais Yousef <qyousef@layalina.io>
To: Christian Loehle <christian.loehle@arm.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
	juri.lelli@redhat.com, mingo@redhat.com, rafael@kernel.org,
	dietmar.eggemann@arm.com, vschneid@redhat.com,
	vincent.guittot@linaro.org, Johannes.Thumshirn@wdc.com,
	adrian.hunter@intel.com, ulf.hansson@linaro.org, andres@anarazel.de,
	asml.silence@gmail.com, linux-pm@vger.kernel.org,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] sched/fair: Introduce per-task io util boost
Message-ID: <20240325033052.utd6rsmv27xtole6@airbuntu>
References: <20240304201625.100619-1-christian.loehle@arm.com>
 <20240304201625.100619-2-christian.loehle@arm.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240304201625.100619-2-christian.loehle@arm.com>

I didn't spend much time on it, but some higher level comments

On 03/04/24 20:16, Christian Loehle wrote:
> Implement an io boost utilization enhancement that is tracked for each
> task_struct. Tasks that wake up from in_iowait frequently will have
> a io_boost associated with them, which counts iowait wakeups and only
> boosts when it seems to improve the per-task throughput.
> 
> The patch is intended to replace the current iowait boosting strategy,
> implemented in both schedutil and intel_pstate which boost the CPU for
> iowait wakeups on the rq.
> The primary benefits are:
> 1. EAS can take the io boost into account.
> 2. Boosting is limited when it doesn't seem to improve throughput.
> 3. io boost is being carried with the task when it migrates.

4. io boost can be wasteful not restricted to save power by tasks that don't
   need it e.g: background tasks with no perf requirements

> 
> This is implemented by observing the iowait wakeups for an interval.
> The boost is divided into 8 levels. If the task achieves the
> required number of iowait wakeups per interval it's boost level is
> increased.

So one of the other problems I am looking at is the response time of the
system. And I must stress *time*. Did you measure how long to go from 0 to max
with your new logic? (edit: I think I found the answer below)

As mentioned elsewhere, better split the logic to make iowait per-task from the
algorithm improvements.

> To reflect that we can't expect an increase of iowait wakeups linear
> to the applied boost (the time the task spends in iowait isn't
> decreased by boosting) we scale the intervals.
> Intervals for the lower boost levels are shorter, also allowing for
> a faster ramp up.
> 
> If multiple tasks are io-boosted their boost will be max-aggregated
> per rq. The energy calculations of EAS have been adapted to reflect
> this.
> 
> Signed-off-by: Christian Loehle <christian.loehle@arm.com>
> ---
>  include/linux/sched.h            |  15 +++
>  kernel/sched/cpufreq_schedutil.c |   6 ++
>  kernel/sched/fair.c              | 165 +++++++++++++++++++++++++++++--
>  kernel/sched/sched.h             |   4 +-
>  4 files changed, 181 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ffe8f618ab86..4e0dfa6fbd65 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1547,6 +1547,21 @@ struct task_struct {
>  	struct user_event_mm		*user_event_mm;
>  #endif
>  
> +	/* IO boost tracking */
> +	u64		io_boost_timeout;
> +	u64		io_boost_interval_start;
> +#define IO_BOOST_INTERVAL_MSEC	25
> +/* Require 1000 iowait wakeups per second to start the boosting */
> +#define IO_BOOST_IOWAITS_MIN	(IO_BOOST_INTERVAL_MSEC)
> +#define IO_BOOST_LEVELS		8
> +/* The util boost given to the task per io boost level, account for headroom */
> +#define IO_BOOST_UTIL_STEP		((unsigned long)((SCHED_CAPACITY_SCALE / 1.25) / IO_BOOST_LEVELS))
> +#define IO_BOOST_IOWAITS_STEP		5

This is too crammed to be readable :)

Better put the defines somewhere on top. And I think they probably belong to
schedutil as Vincent pointed out.

> +	/* Minimum number of iowaits per interval to maintain current boost */
> +	unsigned int	io_boost_threshold_down;
> +	unsigned int	io_boost_level;
> +	unsigned int	io_boost_curr_ios;
> +
>  	/*
>  	 * New fields for task_struct should be added above here, so that
>  	 * they are included in the randomized portion of task_struct.
> diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> index eece6244f9d2..cd0ca3cbd212 100644
> --- a/kernel/sched/cpufreq_schedutil.c
> +++ b/kernel/sched/cpufreq_schedutil.c
> @@ -198,7 +198,13 @@ unsigned long sugov_effective_cpu_perf(int cpu, unsigned long actual,
>  static void sugov_get_util(struct sugov_cpu *sg_cpu, unsigned long boost)
>  {
>  	unsigned long min, max, util = cpu_util_cfs_boost(sg_cpu->cpu);
> +	unsigned long io_boost = cpu_util_io_boost(sg_cpu->cpu);
>  
> +	/*
> +	 * XXX: This already includes io boost now, makes little sense with
> +	 * sugov iowait boost on top
> +	 */
> +	util = max(util, io_boost);
>  	util = effective_cpu_util(sg_cpu->cpu, util, &min, &max);

I am not keen on this open coding and another max aggregation.

I think this new boost is better treated like a new min_perf request and either
make effective_cpu_util() fill up &min here correctly (you'd need to extend it
like I did in [1]) or generalize the concept of perf_min like I suggested.
Seems Vincent has a preference for the former.

[1] https://lore.kernel.org/lkml/20231208015242.385103-3-qyousef@layalina.io/

>  	util = max(util, boost);
>  	sg_cpu->bw_min = min;
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 533547e3c90a..b983e4399c53 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4959,6 +4959,11 @@ static inline void util_est_update(struct cfs_rq *cfs_rq,
>  	trace_sched_util_est_se_tp(&p->se);
>  }
>  
> +static inline unsigned int io_boost_util(struct task_struct *p)
> +{
> +	return p->io_boost_level * IO_BOOST_UTIL_STEP;
> +}
> +
>  static inline int util_fits_cpu(unsigned long util,
>  				unsigned long uclamp_min,
>  				unsigned long uclamp_max,
> @@ -6695,6 +6700,137 @@ static int sched_idle_cpu(int cpu)
>  }
>  #endif
>  
> +static unsigned long io_boost_rq(struct cfs_rq *cfs_rq)
> +{
> +	int i;
> +
> +	for (i = IO_BOOST_LEVELS; i > 0; i--)
> +		if (atomic_read(&cfs_rq->io_boost_tasks[i - 1]))

Why cfs_rq not rq?

So uclamp has taught it something about keeping stuff at the rq level. And that
things can get complex and not work as well - beside cause undesirable cache
bouncing effects. Though for uclamp_min it is not that bad, but we want to
remove uclamp accounting at rq level and I am not keen on adding similar type
of accounting here.

One way we can address this until my work (hopefully) is done; is to send
a special cpufreq update to the governor for it to actually do the tracking.

For iowait boost we do have an additional complexity where the boost must be
applied for when the task is sleeping.

I think this needs to be something taken care of by schedutil/cpufreq governor
where it remembers that it needs to keep iowait boost sticky for a period of
time.

Let's try to keep the clutter out of the scheduler and make cpufreq governors
do the work they ought to in terms of keeping track of info when needed. Like
stickiness of the boost and the current level.

I hope my work to make cpufreq updates done at context switch will help
simplify these decisions. Generally hardware has gotten a lot better in DVFS
and we want to ensure cpufreq governor can take best advantage of hardware
without any policy enforced by the scheduler. So deferring to the governor is
better in general.

> +			return i * IO_BOOST_UTIL_STEP;
> +	return 0;
> +}
> +
> +static inline unsigned long io_boost_interval_nsec(unsigned int io_boost_level)
> +{
> +	/*
> +	 * We require 5 iowaits per interval increase to consider the boost
> +	 * worth having, that leads to:
> +	 * level 0->1:   25ms -> 200 iowaits per second increase
> +	 * level 1->2:   50ms -> 125 iowaits per second increase
> +	 * level 2->3:   75ms ->  66 iowaits per second increase
> +	 * level 3->4:  100ms ->  50 iowaits per second increase
> +	 * level 4->5:  125ms ->  40 iowaits per second increase
> +	 * level 5->6:  150ms ->  33 iowaits per second increase
> +	 * level 6->7:  175ms ->  28 iowaits per second increase
> +	 * level 7->8:  200ms ->  25 iowaits per second increase

Ah seems this is the answer to my question above. 200ms is the time to reach
max perf point of the system? It almost matches utilization ramp up time. Good.
Though not 100% accurate (it actually depends on the capacity of the 2nd
highest freq) but can't complain for now.

> +	 * => level 8 can be maintained with >=1567 iowaits per second.
> +	 */
> +	return (io_boost_level + 1) * IO_BOOST_INTERVAL_MSEC * NSEC_PER_MSEC;
> +}
> +
> +static inline void io_boost_scale_interval(struct task_struct *p, bool inc)
> +{
> +	unsigned int level = p->io_boost_level + (inc ? 1 : -1);
> +
> +	p->io_boost_level = level;
> +	/* We change interval length, scale iowaits per interval accordingly. */
> +	if (inc)
> +		p->io_boost_threshold_down = (p->io_boost_curr_ios *
> +			(level + 1) / level) + IO_BOOST_IOWAITS_STEP;
> +	else
> +		p->io_boost_threshold_down = (p->io_boost_curr_ios *
> +			level / (level + 1)) - IO_BOOST_IOWAITS_STEP;
> +}
> +
> +static void enqueue_io_boost(struct cfs_rq *cfs_rq, struct task_struct *p)
> +{
> +	u64 now = sched_clock();
> +
> +	/* Only what's necessary here because this is the critical path */
> +	if (now > p->io_boost_timeout) {
> +		/* Last iowait took too long, reset boost */
> +		p->io_boost_interval_start = 0;
> +		p->io_boost_level = 0;
> +	}
> +	if (p->io_boost_level)
> +		atomic_inc(&cfs_rq->io_boost_tasks[p->io_boost_level - 1]);
> +}
> +
> +static inline void io_boost_start_interval(struct task_struct *p, u64 now)
> +{
> +	p->io_boost_interval_start = now;
> +	p->io_boost_curr_ios = 1;
> +}
> +
> +static void dequeue_io_boost(struct cfs_rq *cfs_rq, struct task_struct *p)
> +{
> +	u64 now;
> +
> +	if (p->io_boost_level)
> +		atomic_dec(&cfs_rq->io_boost_tasks[p->io_boost_level - 1]);
> +
> +	/*
> +	 * Doing all this at dequeue instead of at enqueue might seem wrong,
> +	 * but it really doesn't matter as the task won't be enqueued anywhere
> +	 * anyway. At enqueue we then only need to check if the in_iowait
> +	 * wasn't too long. We can then act as if the current in_iowait has
> +	 * already completed 'in time'.
> +	 * Doing all this at dequeue has a performance benefit as at this time
> +	 * the io is issued and we aren't in the io critical path.
> +	 */
> +
> +	if (!p->in_iowait) {
> +		/* Even if no boost is active, we reset the interval */
> +		p->io_boost_interval_start = 0;
> +		p->io_boost_level = 0;
> +		return;
> +	}
> +
> +	/* The maximum in_iowait time we allow to continue boosting */
> +	now = sched_clock();
> +	p->io_boost_timeout = now + 10 * NSEC_PER_MSEC;
> +
> +	if (!p->io_boost_interval_start) {
> +		io_boost_start_interval(p, now);
> +		return;
> +	}
> +	p->io_boost_curr_ios++;
> +
> +	if (now < p->io_boost_interval_start +
> +			io_boost_interval_nsec(p->io_boost_level))
> +		return;
> +
> +	if (!p->io_boost_level) {
> +		if (likely(p->io_boost_curr_ios < IO_BOOST_IOWAITS_MIN)) {
> +			io_boost_start_interval(p, now);
> +			return;
> +		}
> +		io_boost_scale_interval(p, true);
> +	} else if (p->io_boost_curr_ios < IO_BOOST_IOWAITS_MIN) {
> +		p->io_boost_level = 0;
> +	} else if (p->io_boost_curr_ios > p->io_boost_threshold_down + IO_BOOST_IOWAITS_STEP) {
> +		/* Increase boost */
> +		if (p->io_boost_level < IO_BOOST_LEVELS)
> +			io_boost_scale_interval(p, true);
> +		else
> +			p->io_boost_threshold_down =
> +				p->io_boost_curr_ios - IO_BOOST_IOWAITS_STEP;
> +	} else if (p->io_boost_curr_ios < p->io_boost_threshold_down) {
> +		/* Reduce boost */
> +		if (p->io_boost_level > 1)
> +			io_boost_scale_interval(p, true);
> +		else
> +			p->io_boost_level = 0;
> +	} else if (p->io_boost_level == IO_BOOST_LEVELS) {
> +		/* Allow for reducing boost on max when conditions changed. */
> +		p->io_boost_threshold_down = max(p->io_boost_threshold_down,
> +				p->io_boost_curr_ios - IO_BOOST_IOWAITS_STEP);
> +	}
> +	/* On maintaining boost we just start a new interval. */
> +
> +	io_boost_start_interval(p, now);
> +}

Can we avoid doing updates at enqueue/dequeue and do them instead when we
set/unset p->in_iowait instead?


Cheers

--
Qais Yousef

> +
>  /*
>   * The enqueue_task method is called before nr_running is
>   * increased. Here we update the fair scheduling stats and
> @@ -6716,11 +6852,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  	 */
>  	util_est_enqueue(&rq->cfs, p);
>  
> -	/*
> -	 * If in_iowait is set, the code below may not trigger any cpufreq
> -	 * utilization updates, so do it here explicitly with the IOWAIT flag
> -	 * passed.
> -	 */
> +	if (p->in_iowait || p->io_boost_interval_start)
> +		enqueue_io_boost(&rq->cfs, p);
> +	/* Ensure new io boost can be applied. */
>  	if (p->in_iowait)
>  		cpufreq_update_util(rq, SCHED_CPUFREQ_IOWAIT);
>  
> @@ -6804,6 +6938,8 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  
>  	util_est_dequeue(&rq->cfs, p);
>  
> +	dequeue_io_boost(&rq->cfs, p);
> +
>  	for_each_sched_entity(se) {
>  		cfs_rq = cfs_rq_of(se);
>  		dequeue_entity(cfs_rq, se, flags);
> @@ -7429,11 +7565,13 @@ select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
>  	int fits, best_fits = 0;
>  	int cpu, best_cpu = -1;
>  	struct cpumask *cpus;
> +	unsigned long io_boost = io_boost_util(p);
>  
>  	cpus = this_cpu_cpumask_var_ptr(select_rq_mask);
>  	cpumask_and(cpus, sched_domain_span(sd), p->cpus_ptr);
>  
>  	task_util = task_util_est(p);
> +	task_util = max(task_util, io_boost);
>  	util_min = uclamp_eff_value(p, UCLAMP_MIN);
>  	util_max = uclamp_eff_value(p, UCLAMP_MAX);
>  
> @@ -7501,7 +7639,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
>  	 */
>  	if (sched_asym_cpucap_active()) {
>  		sync_entity_load_avg(&p->se);
> -		task_util = task_util_est(p);
> +		task_util = max(task_util_est(p), io_boost_util(p));
>  		util_min = uclamp_eff_value(p, UCLAMP_MIN);
>  		util_max = uclamp_eff_value(p, UCLAMP_MAX);
>  	}
> @@ -7615,12 +7753,17 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
>  	return target;
>  }
>  
> +unsigned long cpu_util_io_boost(int cpu)
> +{
> +	return io_boost_rq(&cpu_rq(cpu)->cfs);
> +}
> +
>  /**
>   * cpu_util() - Estimates the amount of CPU capacity used by CFS tasks.
>   * @cpu: the CPU to get the utilization for
>   * @p: task for which the CPU utilization should be predicted or NULL
>   * @dst_cpu: CPU @p migrates to, -1 if @p moves from @cpu or @p == NULL
> - * @boost: 1 to enable boosting, otherwise 0
> + * @boost: 1 to enable runnable boosting, otherwise 0
>   *
>   * The unit of the return value must be the same as the one of CPU capacity
>   * so that CPU utilization can be compared with CPU capacity.
> @@ -7843,8 +7986,10 @@ eenv_pd_max_util(struct energy_env *eenv, struct cpumask *pd_cpus,
>  	for_each_cpu(cpu, pd_cpus) {
>  		struct task_struct *tsk = (cpu == dst_cpu) ? p : NULL;
>  		unsigned long util = cpu_util(cpu, p, dst_cpu, 1);
> +		unsigned long io_boost = max(io_boost_util(p), cpu_util_io_boost(cpu));
>  		unsigned long eff_util, min, max;
>  
> +		util = max(util, io_boost);
>  		/*
>  		 * Performance domain frequency: utilization clamping
>  		 * must be considered since it affects the selection
> @@ -7970,7 +8115,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
>  	target = prev_cpu;
>  
>  	sync_entity_load_avg(&p->se);
> -	if (!task_util_est(p) && p_util_min == 0)
> +	if (!task_util_est(p) && p_util_min == 0 && io_boost_util(p) == 0)
>  		goto unlock;
>  
>  	eenv_task_busy_time(&eenv, p, prev_cpu);
> @@ -7983,6 +8128,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
>  		unsigned long cur_delta, base_energy;
>  		int max_spare_cap_cpu = -1;
>  		int fits, max_fits = -1;
> +		unsigned long p_io_boost = io_boost_util(p);
>  
>  		cpumask_and(cpus, perf_domain_span(pd), cpu_online_mask);
>  
> @@ -7999,6 +8145,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
>  
>  		for_each_cpu(cpu, cpus) {
>  			struct rq *rq = cpu_rq(cpu);
> +			unsigned long io_boost;
>  
>  			eenv.pd_cap += cpu_thermal_cap;
>  
> @@ -8009,6 +8156,8 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
>  				continue;
>  
>  			util = cpu_util(cpu, p, cpu, 0);
> +			io_boost = max(p_io_boost, cpu_util_io_boost(cpu));
> +			util = max(util, io_boost);
>  			cpu_cap = capacity_of(cpu);
>  
>  			/*
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 001fe047bd5d..5f42b72b3cde 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -598,6 +598,8 @@ struct cfs_rq {
>  	struct sched_entity	*curr;
>  	struct sched_entity	*next;
>  
> +	atomic_t		io_boost_tasks[IO_BOOST_LEVELS];
> +
>  #ifdef	CONFIG_SCHED_DEBUG
>  	unsigned int		nr_spread_over;
>  #endif
> @@ -3039,7 +3041,7 @@ static inline unsigned long cpu_util_dl(struct rq *rq)
>  	return READ_ONCE(rq->avg_dl.util_avg);
>  }
>  
> -
> +extern unsigned long cpu_util_io_boost(int cpu);
>  extern unsigned long cpu_util_cfs(int cpu);
>  extern unsigned long cpu_util_cfs_boost(int cpu);
>  
> -- 
> 2.34.1
> 

