Return-Path: <io-uring+bounces-1208-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D04C888A5E6
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 16:10:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00FE61C3B56D
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 15:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7205B1F8;
	Mon, 25 Mar 2024 12:24:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C654A5A10E;
	Mon, 25 Mar 2024 12:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711369451; cv=none; b=IP9Cqcok2yKSLv9HmCqxF4KEDE49zGXx3aGeqvYzuNLREc8e05cZ3cC19HNLA8M17/zTYdgbstKEPRbV1YRPkzAa9n7fJsBPLIPLOHMtetijeTdlC04vCjcQ/9S4UjH3JEKWCie6O9z2LyQ8ywT2rN79Hl+13HzJTyyq+JwDAxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711369451; c=relaxed/simple;
	bh=WLZLZRzN8/OLDT6OPOMADL/GkziHijAZbwkxBipU9Is=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gM2dkmBJj/zT37+Mv9BgwZzy3AgLGXJjo+/EHJ1njkdzKL9MOroSYJ6THD4tTjnpSZjgcYJtFtD9MpC5Rbve8isuoLmwg7oUReqKEu3wYCESL9ZgFqvbOjeFAFKdBLvtVJnLnMRBdtFo9M8M4jZrQbWGzeliDHqht6wrCIc97ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2DD01FB;
	Mon, 25 Mar 2024 05:24:41 -0700 (PDT)
Received: from [10.1.25.33] (e133047.arm.com [10.1.25.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B245F3F67D;
	Mon, 25 Mar 2024 05:24:04 -0700 (PDT)
Message-ID: <92ecab7f-6e35-4e23-a8b7-097a9c26f551@arm.com>
Date: Mon, 25 Mar 2024 12:24:02 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] Introduce per-task io utilization boost
Content-Language: en-US
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
 juri.lelli@redhat.com, mingo@redhat.com, rafael@kernel.org,
 dietmar.eggemann@arm.com, vschneid@redhat.com, Johannes.Thumshirn@wdc.com,
 adrian.hunter@intel.com, ulf.hansson@linaro.org, andres@anarazel.de,
 asml.silence@gmail.com, linux-pm@vger.kernel.org,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20240304201625.100619-1-christian.loehle@arm.com>
 <CAKfTPtDcTXBosFpu6vYW_cXLGwnqJqYCUW19XyxRmAc233irqA@mail.gmail.com>
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <CAKfTPtDcTXBosFpu6vYW_cXLGwnqJqYCUW19XyxRmAc233irqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/03/2024 18:08, Vincent Guittot wrote:
> Hi Christian,
Hi Vincent,
thanks for taking a look.

> 
> On Mon, 4 Mar 2024 at 21:17, Christian Loehle <christian.loehle@arm.com> wrote:
>>
>> There is a feature inside of both schedutil and intel_pstate called
>> iowait boosting which tries to prevent selecting a low frequency
>> during IO workloads when it impacts throughput.
>> The feature is implemented by checking for task wakeups that have
>> the in_iowait flag set and boost the CPU of the rq accordingly
>> (implemented through cpufreq_update_util(rq, SCHED_CPUFREQ_IOWAIT)).
>>
>> The necessity of the feature is argued with the potentially low
>> utilization of a task being frequently in_iowait (i.e. most of the
>> time not enqueued on any rq and cannot build up utilization).
>>
>> The RFC focuses on the schedutil implementation.
>> intel_pstate frequency selection isn't touched for now, suggestions are
>> very welcome.
>> Current schedutil iowait boosting has several issues:
>> 1. Boosting happens even in scenarios where it doesn't improve
>> throughput. [1]
>> 2. The boost is not accounted for in EAS: a) feec() will only consider
>>  the actual utilization for task placement, but another CPU might be
>>  more energy-efficient at that capacity than the boosted one.)
>>  b) When placing a non-IO task while a CPU is boosted compute_energy()
>>  will not consider the (potentially 'free') boosted capacity, but the
>>  one it would have without the boost (since the boost is only applied
>>  in sugov).
>> 3. Actual IO heavy workloads are hardly distinguished from infrequent
>> in_iowait wakeups.
>> 4. The boost isn't associated with a task, it therefore isn't considered
>> for task placement, potentially missing out on higher capacity CPUs on
>> heterogeneous CPU topologies.
>> 5. The boost isn't associated with a task, it therefore lingers on the
>> rq even after the responsible task has migrated / stopped.
>> 6. The boost isn't associated with a task, it therefore needs to ramp
>> up again when migrated.
>> 7. Since schedutil doesn't know which task is getting woken up,
>> multiple unrelated in_iowait tasks might lead to boosting.
>>
>> We attempt to mitigate all of the above by reworking the way the
>> iowait boosting (io boosting from here on) works in two major ways:
>> - Carry the boost in task_struct, so it is a per-task attribute and
>> behaves similar to utilization of the task in some ways.
>> - Employ a counting-based tracking strategy that only boosts as long
>> as it sees benefits and returns to no boosting dynamically.
> 
> Thanks for working on improving IO boosting. I have started to read
> your patchset and have few comments about your proposal:
> 
> The main one is that the io boosting decision should remain a cpufreq
> governor decision and so the io boosting value should be applied by
> the governor like in sugov_effective_cpu_perf() as an example instead
> of everywhere in the scheduler code
Having it move into the scheduler is to enable it for EAS (e.g. boosting
a LITTLE to it's highest OPP often being much less energy-efficient than
having a higher cap CPU at a lower OPP) and to enable higher capacities
reachable on other CPUs, too.
I guess for you the first one is the more interesting one.

> 
> Then, the algorithm to track the right interval bucket and the mapping
> of intervals into utilization really looks like a policy which has
> been defined with heuristics and as a result further seems to be a
> governor decision

I did have a comparable thing as a governor decision, but the entire
"Test if util boost increases iowaits seen per interval and only boost
accordingly" really only works if the interval is long enough, my proposed
starting length of 25ms really being the lower limit for the storage devices
we want to cover (IO latency not being constant and therefore iowaits per
interval being somewhat noisy).
Given that the IO tasks will be enqueued/dequeued very frequently it just
isn't credible to expect them to land on the same CPU for many intervals,
unless your system is very bare-bones and idle, but even on an idle Android
I see any interval above 50ms to be unusable and not provide any throughput
improvement.
The idea of tracking the iowaits I do find the best option in this vague and
noisy environment of "iowait wakeups" and definitely worth having, so that's
why I opted for it being in the scheduler code, but I'd love to hear your
thoughts/alternatives.
I'd also like an improvement on the definition of iowait or some more separate
flag for boostable IO, the entire "boost on any iowait wakeup" is groping in
the dark which I'm trying to combat, but it's somewhat out of scope here.

> 
> Finally adding some atomic operation in the fast path is not really desirable
Agreed, I'll look into it, for now I wanted as much feedback on the two major
changes:
- iowait boost now per-task
- boosting based upon iowaits seen per interval

> 
> I will continue to review your patchset

Thank you, looking forward to seeing your review.

>>[snip]
Kind Regards,
Christian

