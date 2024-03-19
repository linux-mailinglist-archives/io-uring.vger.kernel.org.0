Return-Path: <io-uring+bounces-1140-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D5087FF31
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 14:58:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A4541C224BB
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 13:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D464681AB4;
	Tue, 19 Mar 2024 13:58:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0EB480612;
	Tue, 19 Mar 2024 13:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710856713; cv=none; b=GtLw2R20a1ENkRXD6U/XCPcpdNY81NocKvbOCooKYK4Qs76zLox4PNDjnNzNe1dOPEP9eUveKC7EwkVCvGTZsro8RVmSfMHeosNJjdAYRYhRFImlVjDiJ5NLu33axPK3FyWo9oB+6l+oQoLXQovz8ERUvuZIxlaxu0x4WsSr12w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710856713; c=relaxed/simple;
	bh=326Hw1hWsSH5t0M5mX/zPteXPCm3CkE3FAEzEbcG674=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pjcnu7j6BqSxN+GqsGWindum19CLf5iIH8pG6BZ9DtATYf/f4T86oGn8vUJbT7UQaoMigifpHnfmNLKg3/9mFeNJeWBueRa3n9th+7c4dPHPx7aomGkH/ScCp9k4ctUovDlTfzhYmJsiszjmoXDFC7k1RMaF7UIqoFcyOE2dxd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C11FE106F;
	Tue, 19 Mar 2024 06:59:03 -0700 (PDT)
Received: from [10.1.30.38] (e133047.arm.com [10.1.30.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9AF7D3F762;
	Tue, 19 Mar 2024 06:58:25 -0700 (PDT)
Message-ID: <16a23fcc-9909-49ca-a692-cafca24c8a5b@arm.com>
Date: Tue, 19 Mar 2024 13:58:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] cpufreq/schedutil: Remove iowait boost
Content-Language: en-US
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
 juri.lelli@redhat.com, mingo@redhat.com, dietmar.eggemann@arm.com,
 vschneid@redhat.com, vincent.guittot@linaro.org, Johannes.Thumshirn@wdc.com,
 adrian.hunter@intel.com, ulf.hansson@linaro.org, andres@anarazel.de,
 asml.silence@gmail.com, linux-pm@vger.kernel.org,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20240304201625.100619-1-christian.loehle@arm.com>
 <20240304201625.100619-3-christian.loehle@arm.com>
 <CAJZ5v0gMni0QJTBJXoVOav=kOtQ9W--NyXAgq+dXA+m-bciG8w@mail.gmail.com>
 <5060c335-e90a-430f-bca5-c0ee46a49249@arm.com>
 <CAJZ5v0janPrWRkjcLkFeP9gmTC-nVRF-NQCh6CTET6ENy-_knQ@mail.gmail.com>
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <CAJZ5v0janPrWRkjcLkFeP9gmTC-nVRF-NQCh6CTET6ENy-_knQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 18/03/2024 17:08, Rafael J. Wysocki wrote:
> On Mon, Mar 18, 2024 at 5:40 PM Christian Loehle
> <christian.loehle@arm.com> wrote:
>>
>> On 18/03/2024 14:07, Rafael J. Wysocki wrote:
>>> On Mon, Mar 4, 2024 at 9:17 PM Christian Loehle
>>> <christian.loehle@arm.com> wrote:
>>>>
>>>> The previous commit provides a new cpu_util_cfs_boost_io interface for
>>>> schedutil which uses the io boosted utilization of the per-task
>>>> tracking strategy. Schedutil iowait boosting is therefore no longer
>>>> necessary so remove it.
>>>
>>> I'm wondering about the cases when schedutil is used without EAS.
>>>
>>> Are they still going to be handled as before after this change?
>>
>> Well they should still get boosted (under the new conditions) and according
>> to my tests that does work.
> 
> OK
> 
>> Anything in particular you're worried about?
> 
> It is not particularly clear to me how exactly the boost is taken into
> account without EAS.

So a quick rundown for now, I'll try to include something along the lines in
future versions then, too.
Every task_struct carries an io_boost_level in the range of [0..8] with it.
The boost is in units of utilization (w.r.t SCHED_CAPACITY_SCALE, independent
of CPU the task might be currently enqueued on).
The boost is taken into account for:
1. sugov frequency selection with
io_boost = cpu_util_io_boost(sg_cpu->cpu);
util = max(util, io_boost);

The io boost of all tasks enqueued on the rq will be max-aggregated with the
util here. (See cfs_rq->io_boost_tasks).

2. Task placement, for EAS in feec();
Otherwise select_idle_sibling() / select_idle_capacity() to ensure the CPU
satisfies the requested io_boost of the task to be enqueued.

Determining the io_boost_level is a bit more involved than with sugov's
implementation and happens in dequeue_io_boost(), hopefully that part
is reasonably understandable from the code.

Hope that helps.

Kind Regards,
Christian


> 
>> So in terms of throughput I see similar results with EAS and CAS+sugov.
>> I'm happy including numbers in the cover letter for future versions, too.
>> So far my intuition was that nobody would care enough to include them
>> (as long as it generally still works).
> 
> Well, IMV clear understanding of the changes is more important.


