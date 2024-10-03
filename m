Return-Path: <io-uring+bounces-3394-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 203A098ECF9
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 12:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39E4E1C20EAB
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 10:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B77D1494DB;
	Thu,  3 Oct 2024 10:31:01 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE8A1B969;
	Thu,  3 Oct 2024 10:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727951461; cv=none; b=mSgnwQ5NRF6J1i736XLJ6UJ0BFE06qSKs6BaY3gaIaS7mAA2VclD0+4QiV+aOES1DlPLnSnYIJMcYbQmVA2VN4RW09dywldyTZuIeif/j0ZMNF6YS2XI+Cm3o8AlvSwg7VWIul56XpHkmAtx+Fe3QWELicQYDO20ilh6fKAH9oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727951461; c=relaxed/simple;
	bh=28Rp7iMfYu9uJMVMaa86uq9UWaNfDuDfeBBD55rbIZA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HG6OPjK98BUhUL4sT8YccemaR+IJbAQxYv6REiHbiRQTDKjbAPebzdrjb/whI9Hw+eNiBexk4vhaXQtyMH50p7cnAufoSUlUw764Dt6uMwMrmenn3LTM7R2ZSHtxOG0cv54b/gx1ZyRW+h5pTMJEPKKVb2F2J+GodrYqpDFjglU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2422339;
	Thu,  3 Oct 2024 03:31:27 -0700 (PDT)
Received: from [10.1.38.55] (e127648.arm.com [10.1.38.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1EB173F64C;
	Thu,  3 Oct 2024 03:30:53 -0700 (PDT)
Message-ID: <6e21e8f1-e3b4-4915-87cc-6ce77f54cc8a@arm.com>
Date: Thu, 3 Oct 2024 11:30:52 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/8] cpufreq/schedutil: Remove iowait boost
To: Quentin Perret <qperret@google.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>
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
 <Zv5oTvxPsiTWCJIo@google.com>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <Zv5oTvxPsiTWCJIo@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/3/24 10:47, Quentin Perret wrote:
> On Monday 30 Sep 2024 at 18:34:24 (+0200), Rafael J. Wysocki wrote:
>> On Thu, Sep 5, 2024 at 11:27 AM Christian Loehle
>> <christian.loehle@arm.com> wrote:
>>>
>>> iowait boost in schedutil was introduced by
>>> commit ("21ca6d2c52f8 cpufreq: schedutil: Add iowait boosting").
>>> with it more or less following intel_pstate's approach to increase
>>> frequency after an iowait wakeup.
>>> Behaviour that is piggy-backed onto iowait boost is problematic
>>> due to a lot of reasons, so remove it.
>>>
>>> For schedutil specifically these are some of the reasons:
>>> 1. Boosting is applied even in scenarios where it doesn't improve
>>> throughput.
>>
>> Well, I wouldn't argue this way because it is kind of like saying that
>> air conditioning is used even when it doesn't really help.  It is
>> sometimes hard to know in advance whether or not it will help though.
>>
>>> 2. The boost is not accounted for in EAS: a) feec() will only consider
>>>  the actual task utilization for task placement, but another CPU might
>>>  be more energy-efficient at that capacity than the boosted one.)
>>>  b) When placing a non-IO task while a CPU is boosted compute_energy()
>>>  assumes a lower OPP than what is actually applied. This leads to
>>>  wrong EAS decisions.
>>
>> That's a very good point IMV and so is the one regarding UCLAMP_MAX (8
>> in your list).
> 
> I would actually argue that this is also an implementation problem
> rather than something fundamental about boosting. EAS could be taught
> about iowait boosting and factor that into the decisions.

Definitely, and I did do exactly that.

> 
>> If the goal is to set the adequate performance for a given utilization
>> level (either actual or prescribed), boosting doesn't really play well
>> with this and it shouldn't be used at least in these cases.
> 
> There's plenty of cases where EAS will correctly understand that
> migrating a task away will not reduce the OPP (e.g. another task on the
> rq has a uclamp_min request, or another CPU in the perf domain has a
> higher request), so iowait boosting could probably be added.
> 
> In fact if the iowait boost was made a task property, EAS could easily
> understand the effect of migrating that boost with the task (it's not
> fundamentally different from migrating a task with a high uclamp_min
> from the energy model perspective).

True.
> 
>>> 3. Actual IO heavy workloads are hardly distinguished from infrequent
>>> in_iowait wakeups.
>>
>> Do infrequent in_iowait wakeups really cause the boosting to be
>> applied at full swing?
>>
>>> 4. The boost isn't accounted for in task placement.
>>
>> I'm not sure what exactly this means.  "Big" vs "little" or something else?
>>
>>> 5. The boost isn't associated with a task, it therefore lingers on the
>>> rq even after the responsible task has migrated / stopped.
>>
>> Fair enough, but this is rather a problem with the implementation of
>> boosting and not with the basic idea of it.
> 
> +1
> 
>>> 6. The boost isn't associated with a task, it therefore needs to ramp
>>> up again when migrated.
>>
>> Well, that again is somewhat implementation-related IMV, and it need
>> not be problematic in principle.  Namely, if a task migrates and it is
>> not the only one in the "new" CPUs runqueue, and the other tasks in
>> there don't use in_iowait, maybe it's better to not boost it?
>>
>> It also means that boosting is not very consistent, though, which is a
>> valid point.
>>
>>> 7. Since schedutil doesn't know which task is getting woken up,
>>> multiple unrelated in_iowait tasks lead to boosting.
>>
>> Well, that's by design: it boosts, when "there is enough IO pressure
>> in the runqueue", so to speak.
>>
>> Basically, it is a departure from the "make performance follow
>> utilization" general idea and it is based on the observation that in
>> some cases performance can be improved by taking additional
>> information into account.
>>
>> It is also about pure performance, not about energy efficiency.
>>
>>> 8. Boosting is hard to control with UCLAMP_MAX (which is only active
>>> when the task is on the rq, which for boosted tasks is usually not
>>> the case for most of the time).
> 
> Sounds like another reason to make iowait boosting per-task to me :-)
> 
> I've always thought that turning iowait boosting into some sort of
> in-kernel uclamp_min request would be a good approach for most of the
> issues mentioned above. Note that I'm not necessarily saying to use the
> actual uclamp infrastructure (though it's valid option), I'm really just
> talking about the concept. Is that something you've considered?
> 
> I presume we could even factor out the 'logic' part of the code that
> decides out to request the boost into its own thing, and possibly have
> different policies for different use-cases, but that might be overkill.

See the cover-letter part on per-task iowait boosting, specifically:
[1]
v1 per-task io boost
https://lore.kernel.org/lkml/20240304201625.100619-1-christian.loehle@arm.com/
v2 per-task io boost
https://lore.kernel.org/lkml/20240518113947.2127802-2-christian.loehle@arm.com/
[2]
OSPM24 discussion iowait boosting
https://www.youtube.com/watch?v=MSQGEsSziZ4

These are the main issues with transforming the existing mechanism into
a per-task attribute.
Almost unsolvable is: Does reducing "iowait pressure" (be it per-task or per-rq)
actually improve throughput even (assuming for now that this throughput is
something we care about, I'm sure you know that isn't always the case, e.g.
background tasks). With MCQ devices and some reasonable IO workload that is
IO-bound our iowait boosting is often just boosting CPU frequency (which uses
power obviously) to queue in yet another request for a device which has essentially
endless pending requests. If pending request N+1 arrives x usecs earlier or
later at the device then makes no difference in IO throughput.
If boosting would improve e.g. IOPS (of that device) is something the block layer
(with a lot of added infrastructure, but at least in theory it would know what
device we're iowaiting on, unlike the scheduler) could tell us about. If that is
actually useful for user experience (i.e. worth the power) only userspace can decide
(and then we're back at uclamp_min anyway).
(The above all assumes that iowait even means "is waiting for block IO and
about to send another block IO" which is far from reality.)

Thanks Quentin for getting involved, your input is very much appreciated!

Regards,
Christian

