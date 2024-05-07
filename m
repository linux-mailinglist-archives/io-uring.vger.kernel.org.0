Return-Path: <io-uring+bounces-1807-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 24B6E8BE753
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 17:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E188B26752
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 15:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 853751635C0;
	Tue,  7 May 2024 15:19:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBCBE1635AD;
	Tue,  7 May 2024 15:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715095172; cv=none; b=MUa9YvvciFrYdGvDrmrrCwvZs945sKL2JNHkYabz/18ZOWq1kxbc9jxNZTzo3BiPK4ZgaIsrrwDgX2DI3J3AiOVkaYrtvGS3CjfBiLskfAnR8anPqQcfElkKXsB22jDLuD1JSXXeD/ihJsbbOB4W4Tsho+y4zMwUutzBjokUzrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715095172; c=relaxed/simple;
	bh=HCiNuMOgUWLAa2QGV+NRM5PIIgw4/qkm4rQshhilttE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hFq+e7vbzuhUL183fepk5cpq+0/21LRea4QI6SFqHRoYaNjJngwtzu88a9FJ4rA/Voa8ZXmrb/mMYPcZ+c6LXyRtZTN8sp2f6VqD4XiwNxfG5Ut/hs11QH5vOcCR0TduimtFjg5jwlspHjLGPiqGWg4it7fwRiahaHVXL0vW11k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1F1A1063;
	Tue,  7 May 2024 08:19:51 -0700 (PDT)
Received: from [10.1.34.28] (e133047.arm.com [10.1.34.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F3D23F587;
	Tue,  7 May 2024 08:19:22 -0700 (PDT)
Message-ID: <80da988f-899e-4b93-a648-ffd0680d4000@arm.com>
Date: Tue, 7 May 2024 16:19:20 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] cpufreq/schedutil: Remove iowait boost
To: Qais Yousef <qyousef@layalina.io>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org,
 peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com,
 dietmar.eggemann@arm.com, vschneid@redhat.com, vincent.guittot@linaro.org,
 Johannes.Thumshirn@wdc.com, adrian.hunter@intel.com, ulf.hansson@linaro.org,
 andres@anarazel.de, asml.silence@gmail.com, linux-pm@vger.kernel.org,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20240304201625.100619-1-christian.loehle@arm.com>
 <20240304201625.100619-3-christian.loehle@arm.com>
 <CAJZ5v0gMni0QJTBJXoVOav=kOtQ9W--NyXAgq+dXA+m-bciG8w@mail.gmail.com>
 <5060c335-e90a-430f-bca5-c0ee46a49249@arm.com>
 <CAJZ5v0janPrWRkjcLkFeP9gmTC-nVRF-NQCh6CTET6ENy-_knQ@mail.gmail.com>
 <20240325023726.itkhlg66uo5kbljx@airbuntu>
 <d99fd27a-dac5-4c71-b644-1213f51f2ba0@arm.com>
 <20240429111816.mqok5biihvy46eba@airbuntu>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <20240429111816.mqok5biihvy46eba@airbuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29/04/2024 12:18, Qais Yousef wrote:
> On 04/19/24 14:42, Christian Loehle wrote:
> 
>>> I think the major thing we need to be careful about is the behavior when the
>>> task is sleeping. I think the boosting will be removed when the task is
>>> dequeued and I can bet there will be systems out there where the BLOCK softirq
>>> being boosted when the task is sleeping will matter.
>>
>> Currently I see this mainly protected by the sugov rate_limit_us.
>> With the enqueue's being the dominating cpufreq updates it's not really an
>> issue, the boost is expected to survive the sleep duration, during which it
>> wouldn't be active.
>> I did experiment with some sort of 'stickiness' of the boost to the rq, but
>> it is somewhat of a pain to deal with if we want to remove it once enqueued
>> on a different rq. A sugov 1ms timer is much simpler of course.
>> Currently it's not necessary IMO, but for the sake of being future-proof in
>> terms of more frequent freq updates I might include it in v2.
> 
> Making sure things work with purpose would be really great. This implicit
> dependency is not great IMHO and make both testing and reasoning about why
> things are good or bad harder when analysing real workloads. Especially by non
> kernel developers.

Agreed.
Even without your proposed changes [1] relying on sugov rate_limit_us is
unfortunate.
There is a problem with an arbitrarily low rate_limit_us more generally, not
just because we kind of rely on the CPU being boosted right before the task is
actually enqueued (for the interrupt/softirq part of it), but also because of
the latency from requested frequency improvement to actually running on that
frequency. If the task is 90% done by the time it sees the improvement and
the frequency will be updated (back to a lower one) before the next enqueue,
then that's hardly worth the effort.
Currently this is covered by rate_limit_us probabillistically and that seems
to be good enough in practice, but it's not very pleasing (and also EAS can't
take it into consideration).
That's not just exclusive for iowait wakeup tasks of course, but in theory any
that is off the rq frequently (and still requests a higher frequency than it can
realistically build up through util_avg like through uclamp_min).

>>>
>>> FWIW I do have an implementation for per-task iowait boost where I went a step
>>> further and converted intel_pstate too and like Christian didn't notice
>>> a regression. But I am not sure (rather don't think) I triggered this use case.
>>> I can't tell when the systems truly have per-cpu cpufreq control or just appear
>>> so and they are actually shared but not visible at linux level.
>>
>> Please do share your intel_pstate proposal!
> 
> This is what I had. I haven't been working on this for the past few months, but
> I remember tried several tests on different machines then without a problem.
> I tried to re-order patches at some point though and I hope I didn't break
> something accidentally and forgot the state.
> 
> https://github.com/torvalds/linux/compare/master...qais-yousef:linux:uclamp-max-aggregation
> 

Thanks for sharing, that looks reasonable with consolidating it into uclamp_min.
Couple of thoughts on yours, I'm sure you're aware, but consider it me thinking out
loud:
- iowait boost is taken into consideration for task placement, but with just the
4 steps that made it more aggressive on HMP. (Potentially 2-3 consecutive iowait
wakeups to land on the big instead of running at max OPP of a LITTLE).
- If the current iowait boost decay is sensible is questionable, but there should
probably be some decay. Taken to the extreme this would mean something
like blk_wait_io() demands 1024 utilization, if it waits for a very long time.
Repeating myself here, but iowait wakeups itself is tricky to work with (and I
try to work around that).
- The intel_pstate solution will increase boost even if
previous_wakeup->iowait_boost > current->iowait_boost
right? But using current->iowait_boost is a clever idea.

[1]
https://lore.kernel.org/lkml/ZgKFT5b423hfQdl9@gmail.com/T/

Kind Regards,
Christian

