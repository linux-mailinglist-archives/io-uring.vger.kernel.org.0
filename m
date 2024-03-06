Return-Path: <io-uring+bounces-836-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7E5A8734C9
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 11:49:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 220C51C20A7A
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 10:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF7C605B2;
	Wed,  6 Mar 2024 10:49:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C4E5FBB7;
	Wed,  6 Mar 2024 10:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709722170; cv=none; b=EaWyxRva73VOV1mq4GLWX3kl3jnE5rD1zi/g7mTHmfsX6xSKPi52r98n9dD79sVSmNGQlNHfJA3yZirwjOMGuAHZeAWiHBdUV73dzurd/f4zbz3ce7vRXF8xI2xXvnOu62GAtn7EAHX6AxjVbMeZjhFpA+hc0Ng2Bt2ZE7xq+eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709722170; c=relaxed/simple;
	bh=tQdJcE5Yp1cHqnDbMCItQBYZ7I5dYkfnQ07VTUZueJY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jisGl+eoKIZlrYCP2FJ26+lBLK1yyC5WDueUvxS9TaYwtFM798dMBRZ4bSZ0jXt6SYCdMIFAqXtWNbk3V6Y2zEK0ZRNFuZ/BIz6+RCZxDduabLO++sb2NO/GO8A+GX0hz8KSX20rridCZh/tN/waUyB42puJSXNt/sp/hfLgIRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34CE31FB;
	Wed,  6 Mar 2024 02:50:05 -0800 (PST)
Received: from [10.57.95.153] (unknown [10.57.95.153])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56E5F3F738;
	Wed,  6 Mar 2024 02:49:24 -0800 (PST)
Message-ID: <2784c093-eea1-4b73-87da-1a45f14013c8@arm.com>
Date: Wed, 6 Mar 2024 10:49:22 +0000
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
 <0dc6a839-2922-40ac-8854-2884196da9b9@arm.com>
 <c5b7fc1f-f233-4d25-952b-539607c2a0cc@acm.org>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <c5b7fc1f-f233-4d25-952b-539607c2a0cc@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Bart,

On 05/03/2024 18:36, Bart Van Assche wrote:
> On 3/5/24 01:13, Christian Loehle wrote:
>> On 05/03/2024 00:20, Bart Van Assche wrote:
>>> On 3/4/24 12:16, Christian Loehle wrote:
>>>> - Higher cap is not always beneficial, we might place the task away
>>>> from the CPU where the interrupt handler is running, making it run
>>>> on an unboosted CPU which may have a bigger impact than the difference
>>>> between the CPU's capacity the task moved to. (Of course the boost will
>>>> then be reverted again, but a ping-pong every interval is possible).
>>>
>>> In the above I see "the interrupt handler". Does this mean that the NVMe
>>> controller in the test setup only supports one completion interrupt for
>>> all completion queues instead of one completion interrupt per completion
>>> queue? There are already Android phones and developer boards available
>>> that support the latter, namely the boards equipped with a UFSHCI 4.0 controller.
>>
>> No, both NVMe test setups have one completion interrupt per completion queue,
>> so this caveat doesn't affect them, higher capacity CPU is strictly better.
>> The UFS and both mmc setups (eMMC with CQE and sdcard) only have one completion
>> interrupt (on CPU0 on my setup).
> 
> I think that measurements should be provided in the cover letter for the
> two types of storage controllers: one series of measurements for a
> storage controller with a single completion interrupt and a second
> series of measurements for storage controllers with one completion
> interrupt per CPU.

Of the same type of storage controller? Or what is missing for you in
the cover letter exactly (ufs/emmc: single completion interrupt,
nvme: one completion interrupt per CPU).

> 
>> FWIW you do gain an additional ~20% (in my specific setup) if you move the ufshcd
>> interrupt to a big CPU, too. Similarly for the mmc.
>> Unfortunately the infrastructure is far from being there for the scheduler to move the
>> interrupt to the same performance domain as the task, which is often optimal both in
>> terms of throughput and in terms of power.
>> I'll go looking for a stable testing platform with UFS as you mentioned, benefits of this
>> patch will of course be greatly increased.
> 
> I'm not sure whether making the completion interrupt follow the workload
> is a good solution. I'm concerned that this would increase energy
> consumption by keeping the big cores active longer than necessary. I
> like this solution better (improves storage performance on at least
> devices with a UFSHCI 3.0 controller): "[PATCH v2 0/2] sched: blk:
> Handle HMP systems when completing IO"
> (https://lore.kernel.org/linux-block/20240223155749.2958009-1-qyousef@layalina.io/).

That patch is good, don't get me wrong, but you still lose out by running everything
up to blk_mq_complete_request() on (potentially) a LITTlE (that might be run on a low OPP),
while having a big CPU available at a high OPP anyway ("for free").
It is only adjacent to the series but I've done some measurements (Pixel6 again, same device
as cover letter, Base is Android 6.6 mainline kernel (so without my series, but I somewhat forced
the effects by task pinning), Applied is with both of sched: blk: Handle HMP systems when completing IO):

Pretty numbers (IOPS):
Base irq@CPU0 median: 6969
Base irq@CPU6 median: 8407 (+20.6%)
Applied irq@CPU0 median: 7144 (+2.5%)
Applied irq@CPU6 median: 8288 (18.9%)

This is with psyncx1 4K Random Read again, of course anything with queue depth
takes advantage of batch completions to significantly reduce irq pressure.

Not so pretty numbers and full list commands used:

w/o patch:
irq on CPU0 (default):
psyncx1: 7000 6969 7025 6954 6964
io_uring4x128: 28766 28280 28339 28310 28349
irq on CPU6:
psyncx1: 8342 8492 8355 8407 8532
io_uring4x128: 28641 28356 25908 25787 25853

with patch:
irq on CPU0:
psyncx1: 7672 7144 7301 6976 6889
io_uring4x128: 28266 26314 27648 24482 25301
irq on CPU6:
psyncx1: 8208 8401 8351 8221 8288
io_uring4x128: 25603 25438 25453 25514 25402


for i in $(seq 0 4); do taskset c0 /data/local/tmp/fio_aosp_build --name=test --rw=randread --bs=4k --runtime=30 --time_based --filename=/dev/block/sda --minimal | awk -F ";" '{print $8}'; sleep 30; done

for i in $(seq 0 4); do taskset c0 /data/local/tmp/fio_aosp_build --name=test --rw=randread --bs=4k --runtime=30 --time_based --filename=/dev/block/sda --ioengine=io_uring --iodepth=128 --numjobs=4 --group_reporting --minimal | awk -F ";" '{print $8}'; sleep 30; done

echo 6 > /proc/irq/296/smp_affinity_list


Kind Regards,
Christian

