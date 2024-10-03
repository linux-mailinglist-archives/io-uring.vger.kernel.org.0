Return-Path: <io-uring+bounces-3392-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0179098EC0F
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 11:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 243211C213F5
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 09:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16BCC13DBB1;
	Thu,  3 Oct 2024 09:10:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1486126C13;
	Thu,  3 Oct 2024 09:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727946651; cv=none; b=bpqnuZ1cfPozR8tTQQ73lYV58fnHDkLR26gavfDhjEtoKP6kCWWCwU2D1eFWeVGRlZnxGQhtULsoai0Zz/uV2t7QBk66zWElsZPWZjYu/LwbovL77c8cjaglRbuQWtS8hOLZpvPlrnZaqeBK5zRdqy2ublA8urCg/qLmZ7H6VuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727946651; c=relaxed/simple;
	bh=uGC8uf7Ag5AeV9OKxPQvM6LpMczuiDRZTeqo8Xz56+Y=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=t+7xbBact4NHNOeu4LeV+TmFvFvemBtvNN50QAopjpFiFGFJeyg9GHhkZmUMY7ykY1JDA2FCuM/ujbR5exOuqGdkhcRKXrpK5mxN3vyt9fRVHEtx7/LrM7UsV/mc8+qBap9dEaex3jsl1ArpYduWYYEwGgfkwSuf3pJ/+QylBRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A9277339;
	Thu,  3 Oct 2024 02:11:16 -0700 (PDT)
Received: from [10.1.38.55] (e127648.arm.com [10.1.38.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42F0B3F640;
	Thu,  3 Oct 2024 02:10:43 -0700 (PDT)
Message-ID: <61565cd6-a6e7-4ed5-a52e-dc3bc3e99869@arm.com>
Date: Thu, 3 Oct 2024 10:10:41 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Christian Loehle <christian.loehle@arm.com>
Subject: Re: [RFC PATCH 5/8] cpufreq/schedutil: Remove iowait boost
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
 peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com,
 dietmar.eggemann@arm.com, vschneid@redhat.com, vincent.guittot@linaro.org,
 Johannes.Thumshirn@wdc.com, adrian.hunter@intel.com, ulf.hansson@linaro.org,
 bvanassche@acm.org, andres@anarazel.de, asml.silence@gmail.com,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org, qyousef@layalina.io,
 dsmythies@telus.net, axboe@kernel.dk
References: <20240905092645.2885200-1-christian.loehle@arm.com>
 <20240905092645.2885200-6-christian.loehle@arm.com>
 <CAJZ5v0hJWwsErT193i394bHOczvCQwU_5AVVTJ1oKDe7kTW82g@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAJZ5v0hJWwsErT193i394bHOczvCQwU_5AVVTJ1oKDe7kTW82g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/30/24 17:34, Rafael J. Wysocki wrote:
> On Thu, Sep 5, 2024 at 11:27 AM Christian Loehle
> <christian.loehle@arm.com> wrote:
>>
>> iowait boost in schedutil was introduced by
>> commit ("21ca6d2c52f8 cpufreq: schedutil: Add iowait boosting").
>> with it more or less following intel_pstate's approach to increase
>> frequency after an iowait wakeup.
>> Behaviour that is piggy-backed onto iowait boost is problematic
>> due to a lot of reasons, so remove it.
>>
>> For schedutil specifically these are some of the reasons:
>> 1. Boosting is applied even in scenarios where it doesn't improve
>> throughput.
> 
> Well, I wouldn't argue this way because it is kind of like saying that
> air conditioning is used even when it doesn't really help.  It is
> sometimes hard to know in advance whether or not it will help though.

Right, it's a heuristic that's often wrong and costs energy when it
triggers is what I was trying to say.

> 
>> 2. The boost is not accounted for in EAS: a) feec() will only consider
>>  the actual task utilization for task placement, but another CPU might
>>  be more energy-efficient at that capacity than the boosted one.)
>>  b) When placing a non-IO task while a CPU is boosted compute_energy()
>>  assumes a lower OPP than what is actually applied. This leads to
>>  wrong EAS decisions.
> 
> That's a very good point IMV and so is the one regarding UCLAMP_MAX (8
> in your list).
> 
> If the goal is to set the adequate performance for a given utilization
> level (either actual or prescribed), boosting doesn't really play well
> with this and it shouldn't be used at least in these cases.
> 
>> 3. Actual IO heavy workloads are hardly distinguished from infrequent
>> in_iowait wakeups.
> 
> Do infrequent in_iowait wakeups really cause the boosting to be
> applied at full swing?

Maybe not full swing, but the relatively high rate_limit_us and TICK_NSEC
found on Android deivces does indeed lead to occasional boosting periods
even for 'infrequent'/unrelated wakeups.

> 
>> 4. The boost isn't accounted for in task placement.
> 
> I'm not sure what exactly this means.  "Big" vs "little" or something else?

That should be "[...] in task placement for HMP", you're right.
Essentially if we were to consider a task to be 100% of capacity boost-worthy,
we need to consider that at task placement. Now we cap out at the local CPU,
which might be rather small. (~10% of the biggest CPU on mobile).
Logically this argument (a CAS argument essentially), should probably come
before the EAS one to make more sense.

>> 5. The boost isn't associated with a task, it therefore lingers on the
>> rq even after the responsible task has migrated / stopped.
> 
> Fair enough, but this is rather a problem with the implementation of
> boosting and not with the basic idea of it.

Unfortunately the lingering (or to use a term with less negative connotation:
holding) almost is a necessity, too, as described in the cover-letter.
If we only boost at enqueue (and immediately scale down on dequeue) we lose
out massively, as the interrupt isn't boosted and we have to run at the lower
frequency for the DVFS transition delay (even if on x86 that may be close to
negligible). IMO this is the main reason why the mechanism can't evolve (into
something like a per-task strategy).
Even a per-task strategy would need to a) set a timer in case the iowait
period is too long and b) remove boost from prev_cpu if enqueued somewhere
else.

> 
>> 6. The boost isn't associated with a task, it therefore needs to ramp
>> up again when migrated.
> 
> Well, that again is somewhat implementation-related IMV, and it need
> not be problematic in principle.  Namely, if a task migrates and it is
> not the only one in the "new" CPUs runqueue, and the other tasks in
> there don't use in_iowait, maybe it's better to not boost it?

Agreed, this can be argued about (and also isn't a huge problem in
practice).

> 
> It also means that boosting is not very consistent, though, which is a
> valid point.
> 
>> 7. Since schedutil doesn't know which task is getting woken up,
>> multiple unrelated in_iowait tasks lead to boosting.
> 
> Well, that's by design: it boosts, when "there is enough IO pressure
> in the runqueue", so to speak.> 
> Basically, it is a departure from the "make performance follow
> utilization" general idea and it is based on the observation that in
> some cases performance can be improved by taking additional
> information into account.
> 
> It is also about pure performance, not about energy efficiency.

And the lines between those become more and more blurry, see the GFX
regression. There's very few free lunches up for grabs these days, if
you're boosting performance on X, you're likely paying for it on Y.
That is fine as long as boosting X is deliberate which iowait boosting
very much is not.

> 
>> 8. Boosting is hard to control with UCLAMP_MAX (which is only active
>> when the task is on the rq, which for boosted tasks is usually not
>> the case for most of the time).
>>
>> One benefit of schedutil specifically is the reliance on the
>> scheduler's utilization signals, which have evolved a lot since it's
>> original introduction. Some cases that benefitted from iowait boosting
>> in the past can now be covered by e.g. util_est.
> 
> And it would be good to give some examples of this.
> 
> IMV you have a clean-cut argument in the EAS and UCLAMP_MAX cases, but
> apart from that it is all a bit hand-wavy.

Thanks Rafael, you brought up some good points!


