Return-Path: <io-uring+bounces-11891-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8KAHHPWbcmkFnAAAu9opvQ
	(envelope-from <io-uring+bounces-11891-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 22:51:49 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4EA16DF3D
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 22:51:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D7B6B301E941
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 21:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98F3534DB66;
	Thu, 22 Jan 2026 21:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lZKdn7EA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ADF29B8D3
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 21:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769118682; cv=none; b=bzQ+H4590E4AxY9n9RKzvDzpAjpY3Qg49S8UCZ7z9uDL5nEprhuyQNEZkW9vzsNtQNvjoX3hzV5BHaOhTm1XW+8ePZTXSkMOdposLg8QnhxBctmyM8IjCsk2w6cFjbvnVd0IzKlWkYDSqLCK+MMxesy/GUwymMcsBD44JmLiKiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769118682; c=relaxed/simple;
	bh=/u+ZErAt/dSlC5m863c/9Cp4PgYSc0bXVyQfWIL1XNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mg2It6Sa4lU3Elhef7mc/YqfuG0bcGSQJuXvc20usJrVDu2vg43z9KG9jqe8m+zI98mdlOfhmvMFhqX3gDYxU+c0Xk/g1oo8rHjNVrrtihYCqkEp7OP14VvaMe7Og7zY+QLGji3+isOulLJOJQiJwyscNDtH8VS+Rm65YFWI0+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lZKdn7EA; arc=none smtp.client-ip=209.85.128.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-47d63594f7eso13408645e9.0
        for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 13:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769118675; x=1769723475; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e0ISmEwBHp05TAPm+EEbFkb53tTfIWH4DgA6isaTgsE=;
        b=lZKdn7EAywldaNah9QT/mDq1UnHaMtoJhUeJPLHSVJq0Wx7adLNwcRXgieNrbL2duD
         LBFWFGYfb26SMwHUwHultFuZNVIaOfc2GW4hzDZIaAIZHSFpLb6otFuE9NtZsIevKa1K
         1+hvN5/9ZGpxGirLf0BTG75++yBgJEg9SI5ymGMTtnBi8WOr+GmMuiddDtNNI9hyn6hK
         38MhabynlgfbCmC/zLp65bCESNLcoDJnqpC3I+v2lpI+0Kvani+kDnVk4sdMM8uWDr2r
         LI1uCYA/q9v37HoyV6/HlFWh+oAET8jFb445RaknaUNLMb6a3yJcL4BCQfU8ekFo2Niu
         8djw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769118675; x=1769723475;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e0ISmEwBHp05TAPm+EEbFkb53tTfIWH4DgA6isaTgsE=;
        b=N0tjzteh4EhvGVwDOMPcIU/Z69fgkY73WKIB0iPKKnQaNsujMBWZ/HDUmX/5zAL7Xj
         PXqcjeYWEx2tbN3grQKeXe1PbOz32dq1GeSWt1cDTrZ7dohSMUYYEVv3gVi4mA5FSZyT
         U04UJshfK5f6aAbLqTa/6tnfJ+56iKYyaVS2nsvftmchyNT+vjxL4sexPLoc03YKJEs7
         7+wyRAc2I9R/iyLShqboF8m4UQPLkpagser/EEPn53fonN8Op1ZTgOt2pr8UPVZDz2NK
         jOsZsJUqebr/4eE1SaCUPTnrt9nAjz8jcWczMiG46rajNzc0I6XC4Yvxjh9y8l7g66G8
         Ztbg==
X-Gm-Message-State: AOJu0Yy95DYmjU/hsUg/X/BbOKAs3DYntQI9auv5zphLDDWGCIdc7g8y
	EUG4Jp5OJC//tw+l/lN3N2gtZ6ejlqVNqtcZFhEZjZ/pJvrEsurboqtI
X-Gm-Gg: AZuq6aKeLezJBmk8kgWee/lt+CArX/qBNSk3RwvfmIh1Z9WVMDvKIjXmGODiGqog4+/
	G7PWm2pc1BGT2jjTAHcq8bKJpcP1KBGvPFMR9toCshAUyOexo5klNj8jJJM7LFVTZO6GPxP4tTV
	WP/b5O1MofIuhFtIxHWUGlL5fjJuEVyRDFPl9NuZ13WWWPlyAOvifkxvTaSACrf/cWd2RJDBgXO
	yzKbqMr3mMkAg75aRh7i1SziadVckCWr2jixffcgMyn+HGVBXZeOna2MG4oRl35xTFukmEm5k72
	FBUjHV0VXBYcv2t5LkFxlYdTRQRBOryGKDuMjTHIZVWnuQ9aHn7dVuY6E+NaR3IqCzCtEEkGkuV
	ItsbgtIuIpzdj4vCuN/UG4rFxocJ3n2tsfC58+kjcxNJHhQ5U9+gm418vktaCYf964nsIzYqRlE
	9OblTuC3RC8JtoIKygg/GoxroBU5hYs6yQ1WkhKWon87HGT1TCcNu/y7cJ90ynxQ0SiteuYvdiw
	95EsyQVVnBJVTLrvUTyXyDQtLm5LH8AiCYqr+ZYY1KrDyud1wlo3RZL1hyJKTx85L3Vbcpu6R3C
X-Received: by 2002:a05:600c:4692:b0:477:55c9:c3ea with SMTP id 5b1f17b1804b1-4804c9ca73amr18662255e9.35.1769118674489;
        Thu, 22 Jan 2026 13:51:14 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1f7c8efsm1774230f8f.42.2026.01.22.13.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 13:51:13 -0800 (PST)
Message-ID: <efe080c9-5176-4fa1-9f65-5be44074779e@gmail.com>
Date: Thu, 22 Jan 2026 21:51:10 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
To: Jens Axboe <axboe@kernel.dk>, Yuhao Jiang <danisjiang@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260119071039.2113739-1-danisjiang@gmail.com>
 <bc2e8ec1-8809-4603-9519-788cfff2ae12@kernel.dk>
 <CAHYQsXTHfRKBuTDYWus9r5jDLO2WLBeopt4_bGH_vVm=0z7mWw@mail.gmail.com>
 <2919f3c5-2510-4e97-ab7f-c9eef1c76a69@kernel.dk>
 <CAHYQsXQK4nKu+fcni71__=V241RN=QxUHrvNQMQtPMzeL_z=BA@mail.gmail.com>
 <d8d28435-2a89-4b25-925e-14fdb346839b@gmail.com>
 <8c6a9114-82e9-416e-804b-ffaa7a679ab7@kernel.dk>
 <2be71481-ac35-4ff2-b6a9-a7568f81f728@gmail.com>
 <2fcf583a-f521-4e8d-9a89-0985681ca85b@kernel.dk>
 <d2fc2ff2-98d9-49f8-af95-968100174d55@gmail.com>
 <3b7e6088-7d92-4d5c-96c7-f8c0e2cc7745@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3b7e6088-7d92-4d5c-96c7-f8c0e2cc7745@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11891-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C4EA16DF3D
X-Rspamd-Action: no action

On 1/22/26 17:47, Jens Axboe wrote:
> On 1/22/26 4:43 AM, Pavel Begunkov wrote:
>> On 1/21/26 14:58, Jens Axboe wrote:
>>> On 1/20/26 2:45 PM, Pavel Begunkov wrote:
>>>> On 1/20/26 17:03, Jens Axboe wrote:
>>>>> On 1/20/26 5:05 AM, Pavel Begunkov wrote:
>>>>>> On 1/20/26 07:05, Yuhao Jiang wrote:
>>>> ...
>>>>>>>
>>>>>>> I've been implementing the xarray-based ref tracking approach for v3.
>>>>>>> While working on it, I discovered an issue with buffer cloning.
>>>>>>>
>>>>>>> If ctx1 has two buffers sharing a huge page, ctx1->hpage_acct[page] = 2.
>>>>>>> Clone to ctx2, now both have a refcount of 2. On cleanup both hit zero
>>>>>>> and unaccount, so we double-unaccount and user->locked_vm goes negative.
>>>>>>>
>>>>>>> The per-context xarray can't coordinate across clones - each context
>>>>>>> tracks its own refcount independently. I think we either need a global
>>>>>>> xarray (shared across all contexts), or just go back to v2. What do
>>>>>>> you think?
>>>>>>
>>>>>> The Jens' diff is functionally equivalent to your v1 and has
>>>>>> exactly same problems. Global tracking won't work well.
>>>>>
>>>>> Why not? My thinking was that we just use xa_lock() for this, with
>>>>> a global xarray. It's not like register+unregister is a high frequency
>>>>> thing. And if they are, then we've got much bigger problems than the
>>>>> single lock as the runtime complexity isn't ideal.
>>>>
>>>> 1. There could be quite a lot of entries even for a single ring
>>>> with realistic amount of memory. If lots of threads start up
>>>> at the same time taking it in a loop, it might become a chocking
>>>> point for large systems. Should be even more spectacular for
>>>> some numa setups.
>>>
>>> I already briefly touched on that earlier, for sure not going to be of
>>> any practical concern.
>>
>> Modest 16 GB can give 1M entries. Assuming 50ns-100ns per entry for the
>> xarray business, that's 50-100ms. It's all serialised, so multiply by
>> the number of CPUs/threads, e.g. 10-100, that's 0.5-10s. Account sky
>> high spinlock contention, and it jumps again, and there can be more
>> memory / CPUs / numa nodes. Not saying that it's worse than the
>> current O(n^2), I have a test program that borderline hangs the
>> system.
> 
> It's definitely not worse than the existing system, which is why I don't
> think it's a big deal. Nobody has ever complained about time to register
> buffers. It's inherently a slow path, and quite slow at that depending
> on the use case. Out of curiosity, I ran some stilly testing on
> registering 16GB of memory, with 1..32 threads. Each will do 16GB, so
> 512GB registered in total for the 32 case. Before is the current kernel,
> after is with per-user xarray accounting:
> 
> before
> 
> nthreads 1:      646 msec
> nthreads 2:      888 msec
> nthreads 4:      864 msec
> nthreads 8:     1450 msec
> nthreads 16:    2890 msec
> nthreads 32:    4410 msec
> 
> after
> 
> nthreads 1:      650 msec
> nthreads 2:      888 msec
> nthreads 4:      892 msec
> nthreads 8:     1270 msec
> nthreads 16:    2430 msec
> nthreads 32:    4160 msec
> 
> This includes both registering buffers, cloning all of them to another
> ring, and unregistering times, and nowhere is locking scalability an
> issue for the xarray manipulation. The box has 32 nodes and 512 CPUs. So
> no, I strongly believe this isn't an issue.
> 
> IOW, accurate accounting is cheaper than the stuff we have now. None of
> them are super cheap. Does it matter? I really don't think so, or people
> would've complained already. The only complaint I got on these kinds of
> things was for cloning, which did get fixed up some releases ago.

You need compound pages

always > /sys/kernel/mm/transparent_hugepage/hugepages-16kB/enabled

And use update() instead of register() as accounting dedup for
registration is broken-disabled. For the current kernel:

Single threaded:
1x1G: 7.5s
2x1G: 45s
4x1G: 190s

16x should be ~3000s, not going to run it. Uninterruptible and no
cond_resched, so spawn NR_CPUS threads and the system is completely
unresponsive (I guess it depends on the preemption mode).

-- 
Pavel Begunkov


