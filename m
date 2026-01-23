Return-Path: <io-uring+bounces-11901-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iK9tKFqnc2lnxwAAu9opvQ
	(envelope-from <io-uring+bounces-11901-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 17:52:42 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 342AA78A5C
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 17:52:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7653E300232E
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 16:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D2A2D9492;
	Fri, 23 Jan 2026 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dW2XC2Rx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com [209.85.167.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC59285CBA
	for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 16:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769187160; cv=none; b=MCcxWtPtlcXVZGjM8VQAZUvcuPkcv+X1pRQIRj5FUn2wv60wqx77D4lZk7M3fflDrV2yIrsbDcPPCSMC5NYuzbIajmMGj5uZQ4+26IgVLDhmgd9MyqucurHXkMY9TNKaKZurjteJWUqvhbffco6T+XJCEK9nvxRKi/HkWDGBvKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769187160; c=relaxed/simple;
	bh=esVP2ks5MLabb1EHTOBLm+guRAZfmT1anVSyAPL10r0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=dmJZbsh6Qnd2xQmOIUOgKvRlrSP5WFqqT/97mwk86YpcJCrbHID3dy+bvnHX8WtqMQSSELHI1cSEiEgDFtrJXku/6nEZKpAreHymXpp72HMXlWEU6PZxZJY9nZrFrqYQGuV3R9n6nkBmj0DsJ4NO6GctLsZhWYm+VX9fXVD0UK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dW2XC2Rx; arc=none smtp.client-ip=209.85.167.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f193.google.com with SMTP id 5614622812f47-45c9f47e1e8so733996b6e.0
        for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 08:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769187157; x=1769791957; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HINUjvj70QFSduejzR0GqjYZg6AHoxHg1vc7HquTrMA=;
        b=dW2XC2RxbbfWIersmaxczxRk9XuiMLmEK6sFDX7HVT5s+I91ooJ9YezML55wiVk7yk
         QuvuUUVvkR846MsDyOg+/WU7w7Jzg7QF6O2j8+W2aOmLbMyFomnvniJMDIenj08SA2WU
         7NI6R6ZrKal4CwOlBz9fdeip+09nby+0Yhngi3smu5CwXNdEciicVcqr17PGtnBLNYYE
         5Dlq9VrKN+BTFR5Fq7SAXnJ8UuFBU9zrl+52VixdAbja534VARyiJ6bFOvJqbDucsfnt
         RbmfqNcwpiGlhv4kh4DNqHOpzZfPd/2NukXwAgbCmGa4C8mvVcDPU+x4Zz5aYU7dfH6K
         d2zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769187157; x=1769791957;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HINUjvj70QFSduejzR0GqjYZg6AHoxHg1vc7HquTrMA=;
        b=mt5+HayOh/5pCseEVz4r4YeBlfq8vVpVDBjqxJfebw4tU//7u9GALaVW5XTP63Dzc1
         E7nNjugt1crPY7VssbZ/K513EPn6ms3X4rxZO8B3hUgUid0F+IC8kiLWUFqoD8jMFU32
         KFnEookK18DVaqttx2I67PubDB2PZWkUPK2HL3s2Py6j2OcVtK+9ew2fQvHjCh187eWG
         tJm4woCfAkoR6atF75z3z0hZ2mtOGyhwHwuLcJF+5aF7AoJcGXWirQ/UfMn3ZRXtytml
         0zqvM8cIVfdgubUb1RcXA8X/2qR5MI3pqbOyN/p1D4vyzDeJJhfV3LGSQ36RTBXwyw/X
         +Sxw==
X-Gm-Message-State: AOJu0Yy3m4Kml8uUV3DO7Aj1QAzJxXnNhfExLTMCytghhuNxza/5jcIP
	iq7/oQ4KQER58NDCGdDNHCIvAqXkgfXfQLsBm46gzDgrwOpSEufmfQ/qIUByzcAmkmo=
X-Gm-Gg: AZuq6aK1J6exJEIEXiPti+hvWwWXX60yZXr7u7mw3N1Cxiu+FbHxBpeyyM95Zf+GHW7
	Lkcbi4aDnSabCMbJhB1EoJm5NCAw0ASYP96SaWHr8uxojioiTdS8eVfpJZOvlayOWXxFwzqO4Fn
	9D+1+tOhsdUc3PQ7g0+uEhqByIjm6cbMYl4AVmOZ/zWMGmm0VwJYMsgpgjSaKLL8v3qCc+Fwxxs
	5odv4eP0FYeBp3kr3CiPu42GY0UrCKQtXTGbUALb50BiSLnd3aJVykPhB8ZaHl5qSBri8gA0r1B
	7a2lPZERXEaWDKporYkT/chK888Ko5z3bCMTSc9xH8UHfu8SDSChIESekhrnxwf8ooVSHbVEpoy
	rvmrdJhrq1MLjMCqRbtilDye8hx8mHDozgT7HWXoMtOCo8Yfqj9rqBaqKutYlQYkx2t/C/PpuMK
	dVikns1TWoisoV+EaeHT50tlD4nGX8NR3JGWGdbPLTcgp+Aw2iAkGLLY4G7XGzvp5ZzZ4v
X-Received: by 2002:a05:6830:43a1:b0:7cf:ddb7:8823 with SMTP id 46e09a7af769-7d15a5cc5f9mr2131944a34.11.1769187156828;
        Fri, 23 Jan 2026 08:52:36 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d15b346e2asm2143281a34.2.2026.01.23.08.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jan 2026 08:52:35 -0800 (PST)
Message-ID: <eea0d7c3-9aed-4c1f-8146-23b82e611899@kernel.dk>
Date: Fri, 23 Jan 2026 09:52:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>,
 Yuhao Jiang <danisjiang@gmail.com>
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
 <efe080c9-5176-4fa1-9f65-5be44074779e@gmail.com>
 <596bc7ac-3d24-43a7-9e7e-e59189525ebc@gmail.com>
 <fc8664bb-7769-48a2-b470-71fb81828e26@kernel.dk>
 <654fe339-5a2b-4c38-9d2d-28cfc306b307@kernel.dk>
Content-Language: en-US
In-Reply-To: <654fe339-5a2b-4c38-9d2d-28cfc306b307@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11901-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 342AA78A5C
X-Rspamd-Action: no action

On 1/23/26 8:04 AM, Jens Axboe wrote:
> On 1/23/26 7:50 AM, Jens Axboe wrote:
>> On 1/23/26 7:26 AM, Pavel Begunkov wrote:
>>> On 1/22/26 21:51, Pavel Begunkov wrote:
>>> ...
>>>>>>> I already briefly touched on that earlier, for sure not going to be of
>>>>>>> any practical concern.
>>>>>>
>>>>>> Modest 16 GB can give 1M entries. Assuming 50ns-100ns per entry for the
>>>>>> xarray business, that's 50-100ms. It's all serialised, so multiply by
>>>>>> the number of CPUs/threads, e.g. 10-100, that's 0.5-10s. Account sky
>>>>>> high spinlock contention, and it jumps again, and there can be more
>>>>>> memory / CPUs / numa nodes. Not saying that it's worse than the
>>>>>> current O(n^2), I have a test program that borderline hangs the
>>>>>> system.
>>>>>
>>>>> It's definitely not worse than the existing system, which is why I don't
>>>>> think it's a big deal. Nobody has ever complained about time to register
>>>>> buffers. It's inherently a slow path, and quite slow at that depending
>>>>> on the use case. Out of curiosity, I ran some stilly testing on
>>>>> registering 16GB of memory, with 1..32 threads. Each will do 16GB, so
>>>>> 512GB registered in total for the 32 case. Before is the current kernel,
>>>>> after is with per-user xarray accounting:
>>>>>
>>>>> before
>>>>>
>>>>> nthreads 1:      646 msec
>>>>> nthreads 2:      888 msec
>>>>> nthreads 4:      864 msec
>>>>> nthreads 8:     1450 msec
>>>>> nthreads 16:    2890 msec
>>>>> nthreads 32:    4410 msec
>>>>>
>>>>> after
>>>>>
>>>>> nthreads 1:      650 msec
>>>>> nthreads 2:      888 msec
>>>>> nthreads 4:      892 msec
>>>>> nthreads 8:     1270 msec
>>>>> nthreads 16:    2430 msec
>>>>> nthreads 32:    4160 msec
>>>>>
>>>>> This includes both registering buffers, cloning all of them to another
>>>>> ring, and unregistering times, and nowhere is locking scalability an
>>>>> issue for the xarray manipulation. The box has 32 nodes and 512 CPUs. So
>>>>> no, I strongly believe this isn't an issue.
>>>>>
>>>>> IOW, accurate accounting is cheaper than the stuff we have now. None of
>>>>> them are super cheap. Does it matter? I really don't think so, or people
>>>>> would've complained already. The only complaint I got on these kinds of
>>>>> things was for cloning, which did get fixed up some releases ago.
>>>>
>>>> You need compound pages
>>>>
>>>> always > /sys/kernel/mm/transparent_hugepage/hugepages-16kB/enabled
>>>>
>>>> And use update() instead of register() as accounting dedup for
>>>> registration is broken-disabled. For the current kernel:
>>>>
>>>> Single threaded:
>>>> 1x1G: 7.5s
>>>> 2x1G: 45s
>>>> 4x1G: 190s
>>>>
>>>> 16x should be ~3000s, not going to run it. Uninterruptible and no
>>>> cond_resched, so spawn NR_CPUS threads and the system is completely
>>>> unresponsive (I guess it depends on the preemption mode).
>>> The program is below for reference, but it's trivial. THP setting
>>> is done inside for convenience. There are ways to make the runtime
>>> even worse, but that should be enough.
>>
>> Thanks for sending that. Ran it on the same box, on current -git and
>> with user_struct xarray accounting. Modified it so that 2nd arg is
>> number of threads, for easy running:
> 
> Should've tried 32x32 as well, that ends up going deep into "this sucks"
> territory:
> 
> git
> 
> good luck
> 
> git + user_struct
> 
> axboe@r7625 ~> time ./ppage 32 32
> register 32 GB, num threads 32
> 
> ________________________________________________________
> Executed in   16.34 secs    fish           external
>    usr time    0.54 secs  497.00 micros    0.54 secs
>    sys time  451.94 secs   55.00 micros  451.94 secs

OK, if we use a per-ctx btree, otherwise the code is the same:

axboe@r7625 ~> for i in 1 2 4 8 16; time ./ppage $i $i; end
register 1 GB, num threads 1

________________________________________________________
Executed in   54.06 millis    fish           external
   usr time   41.70 millis  382.00 micros   41.32 millis
   sys time   10.64 millis  314.00 micros   10.33 millis

register 2 GB, num threads 2

________________________________________________________
Executed in  105.56 millis    fish           external
   usr time   60.65 millis  485.00 micros   60.16 millis
   sys time   40.11 millis    0.00 micros   40.11 millis

register 4 GB, num threads 4

________________________________________________________
Executed in  209.98 millis    fish           external
   usr time   38.57 millis  447.00 micros   38.12 millis
   sys time  190.61 millis    0.00 micros  190.61 millis

register 8 GB, num threads 8

________________________________________________________
Executed in  423.37 millis    fish           external
   usr time  130.50 millis  470.00 micros  130.03 millis
   sys time  380.80 millis    0.00 micros  380.80 millis

register 16 GB, num threads 16

________________________________________________________
Executed in  832.71 millis    fish           external
   usr time    0.27 secs    470.00 micros    0.27 secs
   sys time    1.04 secs      0.00 micros    1.04 secs

and the crazier cases:

axboe@r7625 ~> time ./ppage 32 32
register 32 GB, num threads 32

________________________________________________________
Executed in    2.81 secs    fish           external
   usr time    0.71 secs  497.00 micros    0.71 secs
   sys time   19.57 secs  183.00 micros   19.57 secs

which isn't insane. Obviously also needs conditional rescheduling in the
page loops, as those can take a loooong time for large amounts of
memory.

-- 
Jens Axboe

