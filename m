Return-Path: <io-uring+bounces-827-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1F33872238
	for <lists+io-uring@lfdr.de>; Tue,  5 Mar 2024 15:59:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE028285D6C
	for <lists+io-uring@lfdr.de>; Tue,  5 Mar 2024 14:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 409361DFF8;
	Tue,  5 Mar 2024 14:59:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2AAB126F09
	for <io-uring@vger.kernel.org>; Tue,  5 Mar 2024 14:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709650769; cv=none; b=o/b7fwPNF4YFSp3LIqO3GCH2s+KTd4xDn/DpbGKAhS/JW4dYSEhCckAXkCA21JFFL49L6WvFU4CWHG6Q8qVU5aHE3QIiGVWRclTz2dImzVz2S5Hkq16+EuYSrZmGvDZPf0+rHaHUHsoGxDXhcync7nVPvYvua+40DRVGvb/NRqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709650769; c=relaxed/simple;
	bh=GARfNhnsY6ShY17IS1nkif2gYvvN8n2QCysVUMA8ipM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ELEkvbTWpx+a+KjpLyJVXecTiNmO+PqvBPCG8V8TTKc1owHyXM3TGlPGamOXZf5w1BApNDU9nGeut9jvLGCVJJWM81vBf9HTSMjdutdR8gNvf6HXYY8iCfZmGD3Xc8STRQuHCaAtZnYccyb7SLi8OAA8Dxy4PjmrF41UGU8e5uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBE771FB;
	Tue,  5 Mar 2024 07:00:02 -0800 (PST)
Received: from [10.1.29.29] (e133047.arm.com [10.1.29.29])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 481353F762;
	Tue,  5 Mar 2024 06:59:25 -0800 (PST)
Message-ID: <8237858c-6bdf-444d-8355-5b200766f589@arm.com>
Date: Tue, 5 Mar 2024 14:59:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] io_uring: only account cqring wait time as iowait
 if enabled for a ring
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
References: <20240224050735.1759733-1-dw@davidwei.uk>
 <678382b5-0448-4f4d-b7b7-8df7592d77a4@gmail.com>
 <ce348f24-8e11-49e9-aebb-7c87f45138d0@kernel.dk>
 <2bdf6fa7-35d8-438b-be20-e1da78ca0151@gmail.com>
 <05dc2185-2935-4eac-a8e7-f407035f9315@kernel.dk>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <05dc2185-2935-4eac-a8e7-f407035f9315@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi folks,

On 25/02/2024 16:39, Jens Axboe wrote:
> On 2/24/24 5:58 PM, Pavel Begunkov wrote:
>> On 2/24/24 18:51, Jens Axboe wrote:
>>> On 2/24/24 8:31 AM, Pavel Begunkov wrote:
>>>> On 2/24/24 05:07, David Wei wrote:
>>>>> Currently we unconditionally account time spent waiting for events in CQ
>>>>> ring as iowait time.
>>>>>
>>>>> Some userspace tools consider iowait time to be CPU util/load which can
>>>>> be misleading as the process is sleeping. High iowait time might be
>>>>> indicative of issues for storage IO, but for network IO e.g. socket
>>>>> recv() we do not control when the completions happen so its value
>>>>> misleads userspace tooling.
>>>>>
>>>>> This patch gates the previously unconditional iowait accounting behind a
>>>>> new IORING_REGISTER opcode. By default time is not accounted as iowait,
>>>>> unless this is explicitly enabled for a ring. Thus userspace can decide,
>>>>> depending on the type of work it expects to do, whether it wants to
>>>>> consider cqring wait time as iowait or not.
>>>>
>>>> I don't believe it's a sane approach. I think we agree that per
>>>> cpu iowait is a silly and misleading metric. I have hard time to
>>>> define what it is, and I'm sure most probably people complaining
>>>> wouldn't be able to tell as well. Now we're taking that metric
>>>> and expose even more knobs to userspace.
>>>
>>> For sure, it's a stupid metric. But at the same time, educating people
>>> on this can be like talking to a brick wall, and it'll be years of doing
>>> that before we're making a dent in it. Hence I do think that just
>>> exposing the knob and letting the storage side use it, if they want, is
>>> the path of least resistance. I'm personally not going to do a crusade
>>> on iowait to eliminate it, I don't have the time for that. I'll educate
>>
>> Exactly my point but with a different conclusion. The path of least
> 
> I think that's because I'm a realist, and you are an idealist ;-)
> 
>> resistance is to have io_uring not accounted to iowait. That's how
>> it was so nobody should complain about it, you don't have to care about
>> it at all, you don't have to educate people on iowait when it comes up
>> with in the context of that knob, and you don't have to educate folks
>> on what this knob is and wtf it's there, and we're not pretending that
>> it works when it's not.
> 
> I don't think anyone cares about iowait going away for waiting on events
> with io_uring, but some would very much care about losing the cpufreq
> connection which is why it got added in the first place. If we can
> trivially do that without iowait, then we should certainly just do that
> and call it good. THAT is the main question to answer, in form of a
> patch.

I commented on Jens' patch regarding iowait and iowait_acct, which is
probably the path of least resistance for that specific issue, but let
me expand a bit on the cpufreq iowait connection problem.
cpufreq iowait handling and cpuidle iowait handling I would consider vastly
different in that respect and it seems to me that improving cpufreq should
be feasible effort (if it only catches 90% of scenarios at first then so
be it).
I'm thinking something of a in_iowait_boost (or the opposite in_iowait_queue_full
full meaning reasonably non-empty).
The current behaviour of boosting CPU frequency on anything is just very
unfortunate and for io_uring in particular destroys all of the power-savings
it could have due to reduced CPU usage.
(Just to be clear, current iowait boosting is not just broken in io_uring,
but rather everywhere, particularly because of the lack of definition what
iowait even means and when it should be set. Thus boosting on any iowait seen
is like taking a sledgehammer to crack a nut.)
I'm happy to propose some io_uring patch (that is probably nonsensical because
of a lot of reasons) or test whatever ideas you have.
Something like
if pending_requests > device_queue_size: Don't boost
would be an improvement from what I can tell.

And I know I'm heavily reducing io_uring to block IO here and am aware of how
wrong that is, but storage device IO was the original story that got iowait
boosting introduced in the first place.
If you have any cpufreq (or rather DVFS) related issues with anything else
io_uring like networking I'll give reproducing that a shot as well.
Would love to hear your thoughts!

Kind Regards,
Christian

