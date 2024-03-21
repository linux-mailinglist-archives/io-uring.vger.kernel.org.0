Return-Path: <io-uring+bounces-1192-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DD48886021
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 18:57:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6217A1F22CA0
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 17:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA68913174F;
	Thu, 21 Mar 2024 17:57:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47BB6762EB;
	Thu, 21 Mar 2024 17:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711043830; cv=none; b=eUvLeAAnXciSkqMcFjVu6fvcNtLI+szufdXQE3ckqs4Vl2x1jDk0HOQRITUjEq/0O/i7p33L+bHYDOovWmbvkDxBH4joGNSNxcUH3Vq2+ZhHsl92NKRwAq4+51Ev8ZGtJXeKFvhnKsYSbCju035EKKgKVTvLnK1LUCcj4g5owOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711043830; c=relaxed/simple;
	bh=gdoOn/QbAFqhhBtis3LypfJJKRE9dWh0ydUahYILvYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VJHjf4TLKRCtnuRYzPSDqk0NUoSlLtRBVdjqeX55cSdIbGPjEWHbYAbrhoqlK2GPRd5NNOiPr9ySHajwpwiV3UAZbUeqlt1b4HiX4Gma1jPZTVTe4NVF48u8fYUs+Tx8k1uXp1kWtNYiimFMQYLssUH/NpzmJeqVpduzc8JT8KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A3EE1007;
	Thu, 21 Mar 2024 10:57:40 -0700 (PDT)
Received: from [10.1.27.56] (e133047.arm.com [10.1.27.56])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 511E63F67D;
	Thu, 21 Mar 2024 10:57:02 -0700 (PDT)
Message-ID: <1ff973fc-66a4-446e-8590-ec655c686c90@arm.com>
Date: Thu, 21 Mar 2024 17:57:00 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] Introduce per-task io utilization boost
Content-Language: en-US
To: Qais Yousef <qyousef@layalina.io>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
 peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com,
 rafael@kernel.org, dietmar.eggemann@arm.com, vschneid@redhat.com,
 vincent.guittot@linaro.org, Johannes.Thumshirn@wdc.com,
 adrian.hunter@intel.com, ulf.hansson@linaro.org, andres@anarazel.de,
 asml.silence@gmail.com, linux-pm@vger.kernel.org,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org,
 linux-mmc@vger.kernel.org
References: <20240304201625.100619-1-christian.loehle@arm.com>
 <86f0af00-8765-4481-9245-1819fb2c6379@acm.org>
 <0dc6a839-2922-40ac-8854-2884196da9b9@arm.com>
 <c5b7fc1f-f233-4d25-952b-539607c2a0cc@acm.org>
 <2784c093-eea1-4b73-87da-1a45f14013c8@arm.com>
 <20240321123935.zqscwi2aom7lfhts@airbuntu>
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <20240321123935.zqscwi2aom7lfhts@airbuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/03/2024 12:39, Qais Yousef wrote:
[snip]
>> On 05/03/2024 18:36, Bart Van Assche wrote:
>>> On 3/5/24 01:13, Christian Loehle wrote:
>>>> On 05/03/2024 00:20, Bart Van Assche wrote:
>>>>> On 3/4/24 12:16, Christian Loehle wrote:
>>>>>> - Higher cap is not always beneficial, we might place the task away
>>>>>> from the CPU where the interrupt handler is running, making it run
>>>>>> on an unboosted CPU which may have a bigger impact than the difference
>>>>>> between the CPU's capacity the task moved to. (Of course the boost will
>>>>>> then be reverted again, but a ping-pong every interval is possible).
>>>>>
>>>>> In the above I see "the interrupt handler". Does this mean that the NVMe
>>>>> controller in the test setup only supports one completion interrupt for
>>>>> all completion queues instead of one completion interrupt per completion
>>>>> queue? There are already Android phones and developer boards available
>>>>> that support the latter, namely the boards equipped with a UFSHCI 4.0 controller.
>>>>
>>>> No, both NVMe test setups have one completion interrupt per completion queue,
>>>> so this caveat doesn't affect them, higher capacity CPU is strictly better.
>>>> The UFS and both mmc setups (eMMC with CQE and sdcard) only have one completion
>>>> interrupt (on CPU0 on my setup).
>>>
>>> I think that measurements should be provided in the cover letter for the
>>> two types of storage controllers: one series of measurements for a
>>> storage controller with a single completion interrupt and a second
>>> series of measurements for storage controllers with one completion
>>> interrupt per CPU.
>>
>> Of the same type of storage controller? Or what is missing for you in
>> the cover letter exactly (ufs/emmc: single completion interrupt,
>> nvme: one completion interrupt per CPU).
>>
>>>
>>>> FWIW you do gain an additional ~20% (in my specific setup) if you move the ufshcd
>>>> interrupt to a big CPU, too. Similarly for the mmc.
>>>> Unfortunately the infrastructure is far from being there for the scheduler to move the
>>>> interrupt to the same performance domain as the task, which is often optimal both in
>>>> terms of throughput and in terms of power.
>>>> I'll go looking for a stable testing platform with UFS as you mentioned, benefits of this
>>>> patch will of course be greatly increased.
>>>
>>> I'm not sure whether making the completion interrupt follow the workload
>>> is a good solution. I'm concerned that this would increase energy
>>> consumption by keeping the big cores active longer than necessary. I
>>> like this solution better (improves storage performance on at least
>>> devices with a UFSHCI 3.0 controller): "[PATCH v2 0/2] sched: blk:
>>> Handle HMP systems when completing IO"
>>> (https://lore.kernel.org/linux-block/20240223155749.2958009-1-qyousef@layalina.io/).
>>
>> That patch is good, don't get me wrong, but you still lose out by running everything
>> up to blk_mq_complete_request() on (potentially) a LITTlE (that might be run on a low OPP),
>> while having a big CPU available at a high OPP anyway ("for free").
>> It is only adjacent to the series but I've done some measurements (Pixel6 again, same device
>> as cover letter, Base is Android 6.6 mainline kernel (so without my series, but I somewhat forced
>> the effects by task pinning), Applied is with both of sched: blk: Handle HMP systems when completing IO):
> 
> So you want the hardirq to move to the big core? Unlike softirq, there will be
> a single hardirq for the controller (to my limited knowledge), so if there are
> multiple requests I'm not sure we can easily match which one relates to which
> before it triggers. So we can end up waking up the wrong core.

It would be beneficial to move the hardirq to a big core if the IO task
is using it anyway.
I'm not sure I actually want to. There are quite a few pitfalls (like you
mentioned) that the scheduler really shouldn't be concerned about.
Moving the hardirq, if implemented in the kernel, would have to be done by the
host controller driver anyway, which would explode this series.
(host controller drivers are quite fragmented e.g. on mmc)

The fact that having a higher capacity CPU available ("running faster") for an
IO task doesn't (always) imply higher throughput because of the hardirq staying
on some LITTLE CPU is bothering (for this series), though.

> 
> Generally this should be a userspace policy. If there's a scenario where the
> throughput is that important they can easily move the hardirq to the big core
> unconditionally and move it back again once this high throughput scenario is no
> longer important.

It also feels wrong to let this be a userspace policy, as the hardirq must be
migrated to the perf domain of the task, which userspace isn't aware of.
Unless you expect userspace to do
CPU_affinity_task=big_perf_domain_0 && hardirq_affinity=big_perf_domain_0
but then you could just as well ask them to set performance governor for
big_perf_domain_0 (or uclamp_min=1024) and need neither this series nor
any iowait boosting.

Furthermore you can't generally expect userspace to know if their IO will lead
to any interrupt at all, much less which one. They ideally don't even know if
the file IO they are doing is backed by any physical storage in the first place.
(Or even further, that they are doing file IO at all, they might just be
e.g. page-faulting.)

> 
> Or where you describing a different problem?

That is the problem I mentioned in the series and Bart and I were discussing.
It's a problem of the series as in "the numbers aren't that impressive".
Current iowait boosting on embedded/mobile systems will perform quite well by
chance, as the (low util) task will often be on the same perf domain the hardirq
will be run on. As can be seen in the cover letter the benefit of running the
task on a (2xLITTLE capacity) big CPU therefore are practically non-existent,
for tri-gear systems where big CPU is more like 10xLITTLE capacity the benefit
will be much greater.
I just wanted to point this out. We might just acknowledge the problem and say
"don't care" about the potential performance benefits of those scenarios that
would require hardirq moving.
In the long-term it looks like for UFS the problem will disappear as we are
expected to get one queue/hardirq per CPU (as Bart mentioned), on NVMe that
is already the case.

I CC'd Uffe and Adrian for mmc, to my knowledge the only subsystem where
'fast' (let's say >10K IOPS) devices are common, but only one queue/hardirq
is available (and it doesn't look like this is changing anytime soon).
I would also love to hear what Bart or other UFS folks think about it.
Furthermore if I forgot any storage subsystem with the same behavior in that
regards do tell me.

Lastly, you could consider the IO workload:
IO task being in iowait very frequently [1] with just a single IO inflight [2]
and only very little time being spent on the CPU in-between iowaits[3],
therefore the interrupt handler being on the critical path for IO throughput
to a non-negligible degree, to be niche, but it's precisely the use-case where
iowait boosting shows it's biggest benefit.

Sorry for the abomination of a sentence, see footnotes for the reasons.

[1] If sugov doesn't see significantly more than 1 iowait per TICK_NSEC it
won't apply any significant boost currently.
[2] If the storage devices has enough in-flight requests to serve, iowait
boosting is unnecessary/wasteful, see cover letter.
[3] If the task actually uses the CPU in-between iowaits, it will build up
utilization, iowait boosting benefit diminishes.

> 
> Glad to see your series by the way :-) I'll get a chance to review it over the
> weekend hopefully.

Thank you!
Apologies for not CCing you in the first place, I am curious about your opinion
on the concept!

FWIW I did mess up a last-minute, what was supposed to be, cosmetic change that
only received a quick smoke test, so 1/2 needs the following:

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4aaf64023b03..2b6f521be658 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6824,7 +6824,7 @@ static void dequeue_io_boost(struct cfs_rq *cfs_rq, struct task_struct *p)
        } else if (p->io_boost_curr_ios < p->io_boost_threshold_down) {
                /* Reduce boost */
                if (p->io_boost_level > 1)
-                       io_boost_scale_interval(p, true);
+                       io_boost_scale_interval(p, false);
                else
                        p->io_boost_level = 0;
        } else if (p->io_boost_level == IO_BOOST_LEVELS) {


I'll probably send a v2 rebased on 6.9 when it's out anyway, but so far the
changes are mostly cosmetic and addressing Bart's comments about the benchmark
numbers in the cover letter.

Kind Regards,
Christian

