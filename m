Return-Path: <io-uring+bounces-1596-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D448AAF98
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 15:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 939B5284A37
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 13:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB2612A14C;
	Fri, 19 Apr 2024 13:42:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC90712BEBE;
	Fri, 19 Apr 2024 13:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713534144; cv=none; b=eng2nG/D6iD+39DNu9lGmZjYhvVN34eq+rJhjsJXIHuMhUIz/oNZapnpx93q3BGzSS5dNK7abGrxe7rpoizK5e8/68Sa8HA+lKgjdrE/+/1s4UnrySLcP7LdZfy6afRABXvQvOAxXpJpA8OF9YqaJy7hs8m/NySCEd5X6RokLfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713534144; c=relaxed/simple;
	bh=2Th4AlJNiK8G7lYUCJU5ZRC6UwKwfk2DPXWCgGmkaZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a74iCjzKaglIZvskSIfOUNkF8XGDJmgMKuqf86pPYCDInm8v0sNrzFmHCe1wfiCExs6Usrsyt7FAcMxkOm452ZvCj0Rl8C6S0xBf3kmNOezNN5rwAtSzjdY+BpUlEYmEd+WA/2bZ6s8eQw3Z4E3gGhy0GLn14Om3eClbRroMlGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AAE6339;
	Fri, 19 Apr 2024 06:42:50 -0700 (PDT)
Received: from [10.1.30.55] (e133047.arm.com [10.1.30.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D05DF3F64C;
	Fri, 19 Apr 2024 06:42:18 -0700 (PDT)
Message-ID: <d99fd27a-dac5-4c71-b644-1213f51f2ba0@arm.com>
Date: Fri, 19 Apr 2024 14:42:16 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] cpufreq/schedutil: Remove iowait boost
To: Qais Yousef <qyousef@layalina.io>, "Rafael J. Wysocki" <rafael@kernel.org>
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
 <20240325023726.itkhlg66uo5kbljx@airbuntu>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <20240325023726.itkhlg66uo5kbljx@airbuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 25/03/2024 02:37, Qais Yousef wrote:
> On 03/18/24 18:08, Rafael J. Wysocki wrote:
>> On Mon, Mar 18, 2024 at 5:40 PM Christian Loehle
>> <christian.loehle@arm.com> wrote:
>>>
>>> On 18/03/2024 14:07, Rafael J. Wysocki wrote:
>>>> On Mon, Mar 4, 2024 at 9:17 PM Christian Loehle
>>>> <christian.loehle@arm.com> wrote:
>>>>>
>>>>> The previous commit provides a new cpu_util_cfs_boost_io interface for
>>>>> schedutil which uses the io boosted utilization of the per-task
>>>>> tracking strategy. Schedutil iowait boosting is therefore no longer
>>>>> necessary so remove it.
>>>>
>>>> I'm wondering about the cases when schedutil is used without EAS.
>>>>
>>>> Are they still going to be handled as before after this change?
>>>
>>> Well they should still get boosted (under the new conditions) and according
>>> to my tests that does work.
>>
>> OK
>>
>>> Anything in particular you're worried about?
>>
>> It is not particularly clear to me how exactly the boost is taken into
>> account without EAS.
>>
>>> So in terms of throughput I see similar results with EAS and CAS+sugov.
>>> I'm happy including numbers in the cover letter for future versions, too.
>>> So far my intuition was that nobody would care enough to include them
>>> (as long as it generally still works).
>>
>> Well, IMV clear understanding of the changes is more important.
> 
> I think the major thing we need to be careful about is the behavior when the
> task is sleeping. I think the boosting will be removed when the task is
> dequeued and I can bet there will be systems out there where the BLOCK softirq
> being boosted when the task is sleeping will matter.

Currently I see this mainly protected by the sugov rate_limit_us.
With the enqueue's being the dominating cpufreq updates it's not really an
issue, the boost is expected to survive the sleep duration, during which it
wouldn't be active.
I did experiment with some sort of 'stickiness' of the boost to the rq, but
it is somewhat of a pain to deal with if we want to remove it once enqueued
on a different rq. A sugov 1ms timer is much simpler of course.
Currently it's not necessary IMO, but for the sake of being future-proof in
terms of more frequent freq updates I might include it in v2.

> 
> FWIW I do have an implementation for per-task iowait boost where I went a step
> further and converted intel_pstate too and like Christian didn't notice
> a regression. But I am not sure (rather don't think) I triggered this use case.
> I can't tell when the systems truly have per-cpu cpufreq control or just appear
> so and they are actually shared but not visible at linux level.

Please do share your intel_pstate proposal!

Kind Regards,
Christian

