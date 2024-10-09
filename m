Return-Path: <io-uring+bounces-3475-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F272996624
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 11:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2F9A289CF1
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 09:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF8618FDAF;
	Wed,  9 Oct 2024 09:54:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC6D18FC93;
	Wed,  9 Oct 2024 09:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728467668; cv=none; b=MozJbKU3/Wa+mFOZfFfUPvCRtBcaWhY6Hp+51BHqcpWU9g+DSwxDlRxv/clqk/jUnIONiQanQKPVDrIt+AsCJjDL/YpwrPokzvPURedFVQhF0aQCU9VmPnLkfdPpZBgQwPpokVaqWdSeTUFEwLfb9YsL71ReDA3Yfm29ip/qxm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728467668; c=relaxed/simple;
	bh=VBotJtPDGGEmR2CyFHFYZxMHWD41xoURujuuBIez2GI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oz0VsCvRq71W5DCEr98oF6wnjeNl84a2ng9XN5YonnIlRfwfDC9KKVFAsdkwlHwh3FTnrLGapQHUaP8Ji7gDe2Gab5LwFBJSFfd6IaAwSi68JpWseJh78FKXQ+zu+nSYaAkxxiblpNEQd6ox7tt4sPVmcnZNJ7ArH5hnbSzusxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83E14FEC;
	Wed,  9 Oct 2024 02:54:55 -0700 (PDT)
Received: from [10.1.30.40] (e127648.arm.com [10.1.30.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A79E3F64C;
	Wed,  9 Oct 2024 02:54:21 -0700 (PDT)
Message-ID: <c53236ad-b94e-4508-8f3a-7229e32f62bc@arm.com>
Date: Wed, 9 Oct 2024 10:54:18 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/8] cpufreq/schedutil: Remove iowait boost
To: Andres Freund <andres@anarazel.de>
Cc: Quentin Perret <qperret@google.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
 peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com,
 dietmar.eggemann@arm.com, vschneid@redhat.com, vincent.guittot@linaro.org,
 Johannes.Thumshirn@wdc.com, adrian.hunter@intel.com, ulf.hansson@linaro.org,
 bvanassche@acm.org, asml.silence@gmail.com, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, qyousef@layalina.io, dsmythies@telus.net,
 axboe@kernel.dk
References: <20240905092645.2885200-1-christian.loehle@arm.com>
 <20240905092645.2885200-6-christian.loehle@arm.com>
 <CAJZ5v0hJWwsErT193i394bHOczvCQwU_5AVVTJ1oKDe7kTW82g@mail.gmail.com>
 <Zv5oTvxPsiTWCJIo@google.com> <6e21e8f1-e3b4-4915-87cc-6ce77f54cc8a@arm.com>
 <io3xcj5vpqbkojoktbp3fuuj77gqqkf2v3gg62i4aep4ps36dc@we2zwwp5hsyt>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <io3xcj5vpqbkojoktbp3fuuj77gqqkf2v3gg62i4aep4ps36dc@we2zwwp5hsyt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/5/24 01:39, Andres Freund wrote:
> Hi,
> 
> 
> A caveat: I'm a userspace developer that occasionally strays into kernel land
> (see e.g. the io_uring iowait thing). So I'm likely to get some kernel side
> things wrong.

Thank you for your input!

> 
> On 2024-10-03 11:30:52 +0100, Christian Loehle wrote:
>> These are the main issues with transforming the existing mechanism into
>> a per-task attribute.
>> Almost unsolvable is: Does reducing "iowait pressure" (be it per-task or per-rq)
>> actually improve throughput even (assuming for now that this throughput is
>> something we care about, I'm sure you know that isn't always the case, e.g.
>> background tasks). With MCQ devices and some reasonable IO workload that is
>> IO-bound our iowait boosting is often just boosting CPU frequency (which uses
>> power obviously) to queue in yet another request for a device which has essentially
>> endless pending requests. If pending request N+1 arrives x usecs earlier or
>> later at the device then makes no difference in IO throughput.
> 
> That's sometimes true, but definitely not all the time? There are plenty
> workloads with low-queue-depth style IO. Which often are also rather latency
> sensitive.
> 
> E.g. the device a database journal resides on will typically have a low queue
> depth. It's extremely common in OLTPish workloads to be bound by the latency
> of journal flushes. If, after the journal flush completes, the CPU is clocked
> low and takes a while to wake up, you'll see substantially worse performance.

Yeah absolutely and if we knew what a latency-sensitive journal flush is tuning
cpuidle and cpufreq to it would probably be reasonable.
I did test mmtests filebench-oltp that looked fine, do you have any other
benchmarks you would like to see?

>> If boosting would improve e.g. IOPS (of that device) is something the block layer
>> (with a lot of added infrastructure, but at least in theory it would know what
>> device we're iowaiting on, unlike the scheduler) could tell us about. If that is
>> actually useful for user experience (i.e. worth the power) only userspace can decide
>> (and then we're back at uclamp_min anyway).
> 
> I think there are many cases where userspace won't realistically be able to do
> anything about that.
> 
> For one, just because, for some workload, a too deep idle state is bad during
> IO, doesn't mean userspace won't ever want to clock down. And it's probably
> going to be too expensive to change any attributes around idle states for
> individual IOs.

So the kernel currently applies these to all of them essentially.

> 
> Are there actually any non-privileged APIs around this that userspace *could*
> even change? I'd not consider moving to busy-polling based APIs a realistic
> alternative.

No and I'm not sure an actual non-privileged API would be a good idea, would
it? It is essentially changing hardware behavior.
So does busy-polling of course, but the kernel can at least curb that and
maintain fairness and so forth.

> 
> For many workloads cpuidle is way too aggressive dropping into lower states
> *despite* iowait. But just disabling all lower idle states obviously has
> undesirable energy usage implications. It surely is the answer for some
> workloads, but I don't think it'd be good to promote it as the sole solution.

Right, but we (cpuidle) don't know how to distinguish the two, we just do it
for all of them. Whether kernel or userspace applies the same (awful) heuristic
doesn't make that much of a difference in practice.

> 
> It's easy to under-estimate the real-world impact of a change like this. When
> benchmarking we tend to see what kind of throughput we can get, by having N
> clients hammering the server as fast as they can. But in the real world that's
> pretty rare for anything latency sensitive to go full blast - rather there's a
> rate of requests incoming and that the clients are sensitive to requests being
> processed more slowly.

Agreed, this series is posted as RFT and I'm happy to take a look at any
regressions for both the cpufreq and cpuidle parts of it.

> 
> 
> That's not to say that the current situation can't be improved - I've seen way
> too many workloads where the only ways to get decent performance were one of:
> 
> - disable most idle states (via sysfs or /dev/cpu_dma_latency)
> - just have busy loops when idling - doesn't work when doing synchronous
>   syscalls that block though
> - have some lower priority tasks scheduled that just burns CPU
> 
> I'm just worried that removing iowait will make this worse.

I just need to mention again that almost all of what you replied does refer to
cpuidle, not cpufreq (which this particular patch was about), not to create more
confusion.

Regards,
Christian

