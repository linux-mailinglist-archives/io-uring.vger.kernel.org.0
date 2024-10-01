Return-Path: <io-uring+bounces-3345-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F270398B8BD
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 11:57:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A26B41F21E62
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 09:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4481019F431;
	Tue,  1 Oct 2024 09:57:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7B419D8B3;
	Tue,  1 Oct 2024 09:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727776632; cv=none; b=ngPc1HHrgYMNryDbbJIloEDXlC/Rj39aJfmC1mgWA0YSyXB0FUMVWFK6jOrOnsgrX+sdcs3XWdUIHnkzQoRSedF2jWMb6y3zrhoRxo4971pTrvlOZTG0Ow3+mwL/x+1bSqhKrvbXRxIdMb/Vbk5Gfd/NxmQk6vgsaefGRJbjA4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727776632; c=relaxed/simple;
	bh=H0q9iztMRd0pzuiH5IupS+REpCUjAfJeJx6mUfo/qhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pmBwrwCB9G/fqD8rOCy2GQM0PVnchdu4iD+1JjLx/ScQ73zvVCCo81+s6Bwy2O8T+93BkNDAavc3cjfU+mYkWQE+V0aWm6B1yjNVV/wld72gwP9wCntyp5ahpknSYCMo5VOa0GRDkz/NHsu2nBYc8Bz9T3WGna2ZfCzoyzmiEuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1285F339;
	Tue,  1 Oct 2024 02:57:39 -0700 (PDT)
Received: from [10.1.28.63] (e127648.arm.com [10.1.28.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78FFB3F58B;
	Tue,  1 Oct 2024 02:57:05 -0700 (PDT)
Message-ID: <fa623b5e-721a-47fd-84c8-1088d9a6a24a@arm.com>
Date: Tue, 1 Oct 2024 10:57:03 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 6/8] cpufreq: intel_pstate: Remove iowait boost
To: srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
 peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com,
 dietmar.eggemann@arm.com, vschneid@redhat.com, vincent.guittot@linaro.org,
 Johannes.Thumshirn@wdc.com, adrian.hunter@intel.com, ulf.hansson@linaro.org,
 bvanassche@acm.org, andres@anarazel.de, asml.silence@gmail.com,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org, qyousef@layalina.io,
 dsmythies@telus.net, axboe@kernel.dk
References: <20240905092645.2885200-1-christian.loehle@arm.com>
 <20240905092645.2885200-7-christian.loehle@arm.com>
 <CAJZ5v0i3ULQ-Mzu=6yzo4whnWne0g1sxcgPL_u828Jyy1Qu1Zg@mail.gmail.com>
 <0a0186cad5a9254027d0ac6a7f39e39f5473665c.camel@linux.intel.com>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <0a0186cad5a9254027d0ac6a7f39e39f5473665c.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/30/24 21:35, srinivas pandruvada wrote:
> On Mon, 2024-09-30 at 20:03 +0200, Rafael J. Wysocki wrote:
>> +Srinivas who can say more about the reasons why iowait boosting
>> makes
>> a difference for intel_pstate than I do.
>>

Hi Srinivas,

> It makes difference on Xeons and also GFX performance.

AFAIU the GFX performance with iowait boost is a regression though,
because it cuts into the system power budget (CPU+GPU), especially
on desktop and mobile chips (but also some servers), no?
https://lore.kernel.org/lkml/20180730220029.81983-1-srinivas.pandruvada@linux.intel.com/
https://lore.kernel.org/lkml/e7388bf4-deb1-34b6-97d7-89ced8e78ef1@intel.com/
Or is there a reported case where iowait boosting helps
graphics workloads?

> The actual gains will be model specific as it will be dependent on
> hardware algorithms and EPP.
> 
> It was introduced to solve regression in Skylake xeons. But even in the
> recent servers there are gains.
> Refer to
> https://lkml.iu.edu/hypermail/linux/kernel/1806.0/03574.html

Did you look into PELT utilization values at that time?
I see why intel_pstate might be worse off than schedutil wrt removing
iowait boosting and do see two remedies essentially:
1. Boost after all sleeps (less aggressively), although I'm not a huge fan of
this.
2. If the gap between util_est and HWP-determined frequency is too large
then apply some boost. A sort of fallback on a schedutil strategy.
That would of course require util_est to be significantly large in those
scenarios.

I might try to propose something for 2, although as you can probably
guess, playing with HWP is somewhat uncharted waters for me.

Since intel_pstate will actually boost into unsustainable P-states,
there should be workloads that regress with iowait boosting. I'll
go looking for those.



