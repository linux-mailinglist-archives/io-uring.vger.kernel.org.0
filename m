Return-Path: <io-uring+bounces-1212-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D58F88ACA9
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 18:57:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AE041FA0865
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 17:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E392013E6DA;
	Mon, 25 Mar 2024 17:18:17 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC4813D525;
	Mon, 25 Mar 2024 17:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711387097; cv=none; b=QlnN7aGjta32a/56fFQaVEgeAkR/I6Vjp+8sQU7ysYprxEzSCzgUx8E9BOMZ/ZLn/QIRZsKuRoNkDyfjpCsAv4aaSBthnXcD1k5QhTGXk1pEVkV8jQgAiDCp3ckfhqt/2uSXLkl2mqDPSnCt0GPe0EHuTJ8+6lUzI9JD1k1mIw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711387097; c=relaxed/simple;
	bh=VOpyvpV3DKqwMNhujsBF5C0FDMEl+NlChzbkHcasLYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oq0683WRtn2miCLP0kuLLslI3dONVf3RLMw1ABrB64Wkjs/x8aJuj4zQAZ6e6swxHWxFo4oZyDgB+8gBIscOGEhrm+fl+YXfoWUGrBKW28OOiIeDlxiFgVuRGaAGMupMlwepPuy9S/WM8FYxdfJFrXXYwwi4h2a39Ge5tCTUyeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D53CD2F4;
	Mon, 25 Mar 2024 10:18:48 -0700 (PDT)
Received: from [10.1.25.33] (e133047.arm.com [10.1.25.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 669303F64C;
	Mon, 25 Mar 2024 10:18:11 -0700 (PDT)
Message-ID: <8ff1841c-ab1c-4a89-9855-c99729c78f48@arm.com>
Date: Mon, 25 Mar 2024 17:18:09 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] Introduce per-task io utilization boost
Content-Language: en-US
To: Qais Yousef <qyousef@layalina.io>,
 Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
 juri.lelli@redhat.com, mingo@redhat.com, rafael@kernel.org,
 dietmar.eggemann@arm.com, vschneid@redhat.com, Johannes.Thumshirn@wdc.com,
 adrian.hunter@intel.com, ulf.hansson@linaro.org, andres@anarazel.de,
 asml.silence@gmail.com, linux-pm@vger.kernel.org,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20240304201625.100619-1-christian.loehle@arm.com>
 <CAKfTPtDcTXBosFpu6vYW_cXLGwnqJqYCUW19XyxRmAc233irqA@mail.gmail.com>
 <20240325022051.73mfzap7hlwpsydx@airbuntu>
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <20240325022051.73mfzap7hlwpsydx@airbuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 25/03/2024 02:20, Qais Yousef wrote:
> (piggy backing on this reply)
> 
> On 03/22/24 19:08, Vincent Guittot wrote:
>> Hi Christian,
>>
>> On Mon, 4 Mar 2024 at 21:17, Christian Loehle <christian.loehle@arm.com> wrote:
>>>
>>> There is a feature inside of both schedutil and intel_pstate called
>>> iowait boosting which tries to prevent selecting a low frequency
>>> during IO workloads when it impacts throughput.
>>> The feature is implemented by checking for task wakeups that have
>>> the in_iowait flag set and boost the CPU of the rq accordingly
>>> (implemented through cpufreq_update_util(rq, SCHED_CPUFREQ_IOWAIT)).
>>>
>>> The necessity of the feature is argued with the potentially low
>>> utilization of a task being frequently in_iowait (i.e. most of the
>>> time not enqueued on any rq and cannot build up utilization).
>>>
>>> The RFC focuses on the schedutil implementation.
>>> intel_pstate frequency selection isn't touched for now, suggestions are
>>> very welcome.
>>> Current schedutil iowait boosting has several issues:
>>> 1. Boosting happens even in scenarios where it doesn't improve
>>> throughput. [1]
>>> 2. The boost is not accounted for in EAS: a) feec() will only consider
>>>  the actual utilization for task placement, but another CPU might be
>>>  more energy-efficient at that capacity than the boosted one.)
>>>  b) When placing a non-IO task while a CPU is boosted compute_energy()
>>>  will not consider the (potentially 'free') boosted capacity, but the
>>>  one it would have without the boost (since the boost is only applied
>>>  in sugov).
>>> 3. Actual IO heavy workloads are hardly distinguished from infrequent
>>> in_iowait wakeups.
>>> 4. The boost isn't associated with a task, it therefore isn't considered
>>> for task placement, potentially missing out on higher capacity CPUs on
>>> heterogeneous CPU topologies.
>>> 5. The boost isn't associated with a task, it therefore lingers on the
>>> rq even after the responsible task has migrated / stopped.
>>> 6. The boost isn't associated with a task, it therefore needs to ramp
>>> up again when migrated.
>>> 7. Since schedutil doesn't know which task is getting woken up,
>>> multiple unrelated in_iowait tasks might lead to boosting.
> 
> You forgot an important problem which what was the main request from Android
> when this first came up few years back. iowait boost is a power hungry
> feature and not all tasks require iowait boost. By having it per task we want
> to be able to prevent tasks from causing frequency spikes due to iowait boost
> when it is not warranted.

It is and most of the time I see it triggering (in day-to-day workloads) it
doesn't help in any measurable way.
Being able to toggle this per-task is the logical next step, although I would
expect very little over-boosting overall compared to the current sugov
implementation. If you observe otherwise please do tell me for which workloads!

>>>
>>> We attempt to mitigate all of the above by reworking the way the
>>> iowait boosting (io boosting from here on) works in two major ways:
>>> - Carry the boost in task_struct, so it is a per-task attribute and
>>> behaves similar to utilization of the task in some ways.
>>> - Employ a counting-based tracking strategy that only boosts as long
>>> as it sees benefits and returns to no boosting dynamically.
>>
>> Thanks for working on improving IO boosting. I have started to read
>> your patchset and have few comments about your proposal:
>>
>> The main one is that the io boosting decision should remain a cpufreq
>> governor decision and so the io boosting value should be applied by
>> the governor like in sugov_effective_cpu_perf() as an example instead
>> of everywhere in the scheduler code.
> 
> I have similar thoughts.
> 
> I think we want the scheduler to treat iowait boost like uclamp_min, but
> requested by block subsystem rather than by the user.
> 
> I think we should create a new task_min/max_perf() and replace all current
> callers in scheduler to uclamp_eff_value() with task_min/max_perf() where
> task_min/max_perf()
> 
> unsigned long task_min_perf(struct task_struct *p)
> {
> 	return max(uclamp_eff_value(p, UCLAMP_MIN), p->iowait_boost);
> }
> 
> unsigned long task_max_perf(struct task_struct *p)
> {
> 	return uclamp_eff_value(p, UCLAMP_MAX);
> }
> 
> then all users of uclamp_min in the scheduler will see the request for boost
> from iowait and do the correct task placement decision. Including under thermal
> pressure and ensuring that they don't accidentally escape uclamp_max which I am
> not sure if your series caters for with the open coding it. You're missing the
> load balancer paths from what I see.

io_boost doesn't have to be clamped at the load balancer path because it isn't
included there (unless I messed up).
Essentially io_boost should never trigger a load balance, we are talking about
tasks that get constantly enqueued and only spend very little time on the CPU
until sleeping again, so any load balancing should be overkill.
For the rest I'm open to anything, it's all a 'minor' implementation detail for
me :)

> 
> It will also solve the problem I mention above. The tasks that should not use
> iowait boost are likely restricted with uclamp_max already. If we treat iowait
> boost as an additional source of min_perf request, then uclamp_max will prevent
> it from going above a certain perf level and give us the desired impact without
> any additional hint. I don't think it is important to disable it completely but
> rather have a way to prevent tasks from consuming too much resources when not
> needed, which we already have from uclamp_max.
> 
> I am not sure it makes sense to have a separate control where a task can run
> fast due to util but can't have iowait boost or vice versa. I think existing
> uclamp_max should be enough to restrict tasks from exceeding a performance
> limit.
> 
>>
>> Then, the algorithm to track the right interval bucket and the mapping
>> of intervals into utilization really looks like a policy which has
>> been defined with heuristics and as a result further seems to be a
>> governor decision
> 
> Hmm do you think this should not be a per-task value then Vincent?

That's how I understood Vincent anyway.
See my other reply.

> 
> Or oh, I think I see what you mean. Make effective_cpu_util() set min parameter
> correctly. I think that would work too, yes. iowait boost is just another min
> perf request and as long as it is treated as such, it is good for me. We'll
> just need to add a new parameter for the task like I did in remove uclamp max
> aggregation serires.

I did have that at some point, too, although before Vincent's rework.
Should be fine from what I can see now.

> 
> Generally I think it's better to split the patches so that the conversion to
> iowait boost with current algorithm to being per-task as a separate patch. And
> then look at improving the algorithm logic on top. These are two different
> problems IMHO.

That's possible, although the current iowait boosting is based on consecutiveness
of the iowait wakeups on the rq (oversimplifying away all that rate_limit_us
stuff), which doesn't really translate well into a per-task property, but
I can come up with something that works just well enough here.
As I said in my other reply this entire piggybacking ontop of iowait wakeups
is such an unfortunate beast, see all the different occurrences of io_schedule*()
and mutex_lock_io(). The entire interval-based tracking strategy attempts to
mitigate that somewhat without going to the entire tree.

> One major problem and big difference in per-task iowait that I see Christian
> alluded to is that the CPU will no longer be boosted when the task is sleeping.
> I think there will be cases out there where some users relied on that for the
> BLOCK softirq to run faster too. We need an additional way to ensure that the
> softirq runs at a similar performance level to the task that initiated the
> request. So we need a way to hold the cpufreq policy's min perf until the
> softirq is serviced. Or just keep the CPU boosted until the task is migrated.
> I'm not sure what is better yet.

Yes, right now rate_limit_us (which is usually at least TICK_NSEC currently)
'protects' this. Almost all of the cpufreq updates will come from the iowait
task(s) enqueue anyway (in cases we apply some io boost).
Having the per-task boost 'linger' around at the runqueue more explicitly is
a bit awkward though, as you would have to remove if the scheduler picks a
different CPU once the task is being re-enqueued.
Not impossible to do but lots of awkwardness there.

>>
>> Finally adding some atomic operation in the fast path is not really desirable
> 
> Yes I was thinking if we can apply the value when we set the p->in_iowait flag
> instead?

Yeah thought about it, too, again the awkwardness is that you don't know on which
rq the task will be enqueued on after the wake up.
(Boost current CPU and then remove if we switched CPUs can be done, but then we
also need to arm a timer for tasks that go into iowait for a long time (and thus
don't deserve boosting anymore)).
Might be worse than the current atomic.
But I'll come up with something, should be the least critical part of this series ;)

Thanks for taking a look, I'll gather some additional numbers for the other replies
and get back to you.

Kind Regards,
Christian

