Return-Path: <io-uring+bounces-1112-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 262F987EDBB
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 17:40:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3F78281FA8
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 16:40:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5758C53394;
	Mon, 18 Mar 2024 16:40:43 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27DE218029;
	Mon, 18 Mar 2024 16:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710780043; cv=none; b=Cr4x+G/8nQF2OWcyeDYzgAAGs+erMzRxB/KIdH/hmk5bXHRXGG/AZ8bSkaNy2Mu4dYxU60Og4sOUGPg1tnXB7VtorT5OMKpoaQb+0njxUejQ2TiaIDUdbCtluF4D6BJxZSlyeRHQZzVg6JGA+MOxm5OhTezuWJxNEpUDbX/Y44Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710780043; c=relaxed/simple;
	bh=Os9aEBxep6Ro2bkZKu8nIVUYR+o95VcsB1ChCPHzA9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DIGUpKL0yQ16EtnqPtFYL7MRurTeVVuM3CgczG3JrxoJt0WheM2DVDQnHK0xf+0MxV3Wz8mVITK0ZRZ23E674z3DKop71wNNr4hN1Ue4udIwP1xNZKmH+wkAIVmrRCWpzy+xeHCBlyaCCbett6iDByuBtLAt0IFuhGnlyNs6+AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F79C1FB;
	Mon, 18 Mar 2024 09:41:14 -0700 (PDT)
Received: from [10.1.30.38] (e133047.arm.com [10.1.30.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F86B3F67D;
	Mon, 18 Mar 2024 09:40:35 -0700 (PDT)
Message-ID: <5060c335-e90a-430f-bca5-c0ee46a49249@arm.com>
Date: Mon, 18 Mar 2024 16:40:33 +0000
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
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <CAJZ5v0gMni0QJTBJXoVOav=kOtQ9W--NyXAgq+dXA+m-bciG8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 18/03/2024 14:07, Rafael J. Wysocki wrote:
> On Mon, Mar 4, 2024 at 9:17 PM Christian Loehle
> <christian.loehle@arm.com> wrote:
>>
>> The previous commit provides a new cpu_util_cfs_boost_io interface for
>> schedutil which uses the io boosted utilization of the per-task
>> tracking strategy. Schedutil iowait boosting is therefore no longer
>> necessary so remove it.
> 
> I'm wondering about the cases when schedutil is used without EAS.
> 
> Are they still going to be handled as before after this change?

Well they should still get boosted (under the new conditions) and according
to my tests that does work. Anything in particular you're worried about?

So in terms of throughput I see similar results with EAS and CAS+sugov.
I'm happy including numbers in the cover letter for future versions, too.
So far my intuition was that nobody would care enough to include them
(as long as it generally still works).

Kind Regards,
Christian

