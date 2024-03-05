Return-Path: <io-uring+bounces-826-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9848A87193E
	for <lists+io-uring@lfdr.de>; Tue,  5 Mar 2024 10:13:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D36B11C21BDD
	for <lists+io-uring@lfdr.de>; Tue,  5 Mar 2024 09:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D3B50263;
	Tue,  5 Mar 2024 09:13:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643B14DA1F;
	Tue,  5 Mar 2024 09:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709630001; cv=none; b=ffZ7JDtOXu9dTItT/cYgUvBUdkuh5zHRTYpS9Zw/hfoLRaD+ikZBhv5j8LbzD/Jvmpeo6K2CuqLEwfPBKKgoiUHWZtzR1PREapbLDSSk7x1k6voAJ65J1RWNJNF94BuKWQnUTA0wi5WOQ1zqzGvw80q4akE3JSQwHz4lXGwB/j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709630001; c=relaxed/simple;
	bh=8yEMbLlsXSdgz1MHS6KtgJSRcTWMl7TRJdDzd5wFNtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q2OZvQAWZvdOwDOSCllBw2kXH6FK5Jg8rDrAPzGMOzoT6PvEn4qC07gvJI72kYVFbMM4sCQWXC5l4jmoBqT+Z3T8FmQpjTV7/k9fBiU2g1xDcxbADSmWz/9t2K34AVc70HjcnOljatjhU5cDuCIf4t7Tbs4N9fbLISVeMtkL+4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DD8BDA7;
	Tue,  5 Mar 2024 01:13:55 -0800 (PST)
Received: from [10.1.29.29] (e133047.arm.com [10.1.29.29])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 305C03F762;
	Tue,  5 Mar 2024 01:13:16 -0800 (PST)
Message-ID: <0dc6a839-2922-40ac-8854-2884196da9b9@arm.com>
Date: Tue, 5 Mar 2024 09:13:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] Introduce per-task io utilization boost
To: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com,
 rafael@kernel.org, dietmar.eggemann@arm.com, vschneid@redhat.com,
 vincent.guittot@linaro.org, Johannes.Thumshirn@wdc.com,
 adrian.hunter@intel.com, ulf.hansson@linaro.org, andres@anarazel.de,
 asml.silence@gmail.com, linux-pm@vger.kernel.org,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org,
 Qais Yousef <qyousef@layalina.io>
References: <20240304201625.100619-1-christian.loehle@arm.com>
 <86f0af00-8765-4481-9245-1819fb2c6379@acm.org>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <86f0af00-8765-4481-9245-1819fb2c6379@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Bart,

On 05/03/2024 00:20, Bart Van Assche wrote:
> On 3/4/24 12:16, Christian Loehle wrote:
>> Pixel 6 ufs Android 14 (7 runs for because device showed some variance)
>> [6605, 6622, 6633, 6652, 6690, 6697, 6754] sugov mainline
>> [7141, 7173, 7198, 7220, 7280, 7427, 7452] per-task tracking
>> [2390, 2392, 2406, 2437, 2464, 2487, 2813] sugov no iowait boost
>> [7812, 7837, 7837, 7851, 7900, 7959, 7980] performance governor
> 
> Variance of performance results for Pixel devices can be reduced greatly
> by disabling devfreq scaling, e.g. as follows (this may cause thermal
> issues if the system load is high enough):
> 
>      for d in $(adb shell echo /sys/class/devfreq/*); do
>     adb shell "cat $d/available_frequencies |
>         tr ' ' '\n' |
>         sort -n |
>         case $devfreq in
>             min) head -n1;;
>             max) tail -n1;;
>         esac > $d/min_freq"
>     done
> 

Thanks for the hint!

>> Showcasing some different IO scenarios, again all random read,
>> median out of 5 runs, all on rk3399 with NVMe.
>> e.g. io_uring6x4 means 6 threads with 4 iodepth each, results can be
>> obtained using:
>> fio --minimal --time_based --name=test --filename=/dev/nvme0n1 --runtime=30 --rw=randread --bs=4k --ioengine=io_uring --iodepth=4 --numjobs=6 --group_reporting | cut -d \; -f 8
> 
> So buffered I/O was used during this test? Shouldn't direct I/O be used
> for this kind of tests (--buffered=0)? Additionally, which I/O scheduler
> was configured? I recommend --ioscheduler=none for this kind of tests.

Yes I opted for buffered I/O, I guess it's the eternal question if you
should benchmark the device/stack (O_DIRECT) or be more realistic to actual
use cases (probably). I opted for the latter, but since it's 4K randread
on significantly large devices the results don't differ too much.


>> - Higher cap is not always beneficial, we might place the task away
>> from the CPU where the interrupt handler is running, making it run
>> on an unboosted CPU which may have a bigger impact than the difference
>> between the CPU's capacity the task moved to. (Of course the boost will
>> then be reverted again, but a ping-pong every interval is possible).
> 
> In the above I see "the interrupt handler". Does this mean that the NVMe
> controller in the test setup only supports one completion interrupt for
> all completion queues instead of one completion interrupt per completion
> queue? There are already Android phones and developer boards available
> that support the latter, namely the boards equipped with a UFSHCI 4.0 controller.

No, both NVMe test setups have one completion interrupt per completion queue,
so this caveat doesn't affect them, higher capacity CPU is strictly better.
The UFS and both mmc setups (eMMC with CQE and sdcard) only have one completion
interrupt (on CPU0 on my setup).
The difference between the CPU capacities on the Pixel6 is able to make up for this.
The big CPU is still the best to run these single-threaded fio benchmarks on in terms
of throughput.
FWIW you do gain an additional ~20% (in my specific setup) if you move the ufshcd
interrupt to a big CPU, too. Similarly for the mmc.
Unfortunately the infrastructure is far from being there for the scheduler to move the
interrupt to the same performance domain as the task, which is often optimal both in
terms of throughput and in terms of power.
I'll go looking for a stable testing platform with UFS as you mentioned, benefits of this
patch will of course be greatly increased.
Thanks!

Best Regards,
Christian

