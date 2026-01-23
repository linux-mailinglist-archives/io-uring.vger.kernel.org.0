Return-Path: <io-uring+bounces-11900-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yPiuHAKQc2l0xAAAu9opvQ
	(envelope-from <io-uring+bounces-11900-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 16:13:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 12DDE77925
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 16:13:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E2ABA307DCA2
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 15:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30B912FF155;
	Fri, 23 Jan 2026 15:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yyv7UixE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f67.google.com (mail-oa1-f67.google.com [209.85.160.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1D533BBC4
	for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 15:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180694; cv=none; b=QEwHjhWn/ZQlEpk7Ul1GhxFNTUNDU+3Xl1g1rw55iw4V8MIV4l5Ld80XTtWjDAgV1Uw2BpMMfPgP6D+pFrWqbTu5Mg3hKNkRM8uEbEy5jAbXDR0QnfS3VyCJAGyXspZ1D8HiOJ31VkX7XvJU6JpH1odQgR5217nTIqGWX4FFnDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180694; c=relaxed/simple;
	bh=GtoJMAV3JMEw5u0PkRh1Ohg8essRu+nn9weTSPQUFWI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=he0ojjKWBUhAjCbXvkbK3h6vzwcLajahw1zdJ7gCWR+PMQMPIgnv09vEqjZHnvOM2s+Bdl3gn7WgTVXpeH3t0GoAIbPQftkzXMop4V/eccb4Q7M5oYz6obREp8W/T7ru3gZd71bqyEbxqApGmAwsx7ospnLA9K2j9BZdA2PNVAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yyv7UixE; arc=none smtp.client-ip=209.85.160.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f67.google.com with SMTP id 586e51a60fabf-404263bd58fso2273573fac.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 07:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769180691; x=1769785491; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C0mzcb/MlZDJODBRwhXegE9ctUcOjJ+6el+uFNaQtwg=;
        b=yyv7UixECEK1530EPpPZ6ZwUqCS5nMJyEKh8XLR/p0iyyUSEpkvRl+kkirnpsHCN2b
         8aA1pja0aN5fMt5gYrUdKMDoa4B+rOyBSmzht8ir9qGygxRt9q0mN+mELzJVS6BmM8sU
         6TucC2tJxq/TWhlOG4NdamkeDW9d1ZbFk+9SbIz06qe6BuIKyc00cyLUozJvYmJifQrJ
         J/P3VknwE7TMtaBvWMg4262KhfwboJk/x7bgQ5DU6ew02mWti9MM/uRHa1v2o/xP4WqZ
         C5APD2S3LLyBZ5SS3AvQT1fZVieun7zrJlbDuSFI8Er9S2LOGwlZH5z8jwa19jukIfGf
         LE7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769180691; x=1769785491;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C0mzcb/MlZDJODBRwhXegE9ctUcOjJ+6el+uFNaQtwg=;
        b=u4GoSHEFobEPkmKektf7pWvSaOjNcCMXPZc13dwgo0gxgw8WR5gIiH6WpUC/wZ5Bkw
         V7ra3wwl17sTGHbnPC8ZmTyvadAEMFLFLTGdoRoU05789h/EyUspRkPjogVm+fEZxoK2
         fYqcszpLbvjhYQE33CQx+zMPSRtLzOwADiAQjrxjGdzfur4BkE+FEpTrWvsboxqgpY0d
         j//VLsvvRaolCbWilMQiLMaa1iagOZgBoLK5SVcO1W6HfJ+norOUvJonlM+ZwoqyNl1t
         TLh3CGCdCXwrEKpj+R3iykkou9J7Nfxxyn886VzHlIIzDiQuNC/Dj/lTX8LxUKeT02g5
         W24Q==
X-Gm-Message-State: AOJu0YyQ1b4Oko9LW3JhwwQZDYDX3HFeF/mGUa4gE2KKmW7cN6Rpq7cQ
	4+muaJnNZW9jI3tRy9YEWzNw0Vq5VmZ78Gl3aB779N0DwhU/+s4FVr2xfhafKJQ8DAM=
X-Gm-Gg: AZuq6aK9Sk7zaF6epboKd/nyNtgcxcO9ciY028BflQVXYpJbetARwLIZjsx3hnrd0oc
	/zziJ0rp2I8RhoGtkV/SrKRPgd0eo6RkBXCga6g0fbBnZl2LzavboK2edUVnSJFXSni7K4B5XSA
	Tw8BkJcHtZ5JHet7JT6mPj8Fz5a4kg9CmMIjjeaw4qC7KpLiMtOXaR5AJWPUPV0Z4ElXy4mWdto
	YDG9biBfniVBHyIyA6btxfVJVhLfXnx1+j1jw68+aAtkpClYDafUZcpa2Vaf1zsFHfhshqoYMf/
	vlKJVRztx5J+E3Jh5gMgu6DBsph4VnyZXiTSOQoid5cdH2guCXTFY6PhqoiLIXAZVZI9/FW8I/Q
	gQuf5m2ZI5vsANFjC4vJJYrGuWJvTBiqn5KErJc+nS60ZQUBQs76BVRWU3Ui7aZDiSlzC5U3KPg
	8JAIgHwiYmBM+qWpDJnX6yZVbNwNIiYSjzfOzzQNoT0YAIIzwwaWuZiEVq1kEfxnDeftVhm49Oj
	1W46qo=
X-Received: by 2002:a05:6820:4d4c:20b0:661:1580:bf84 with SMTP id 006d021491bc7-662caf90a02mr1265746eaf.34.1769180690515;
        Fri, 23 Jan 2026 07:04:50 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-662cb651194sm1245674eaf.12.2026.01.23.07.04.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jan 2026 07:04:50 -0800 (PST)
Message-ID: <654fe339-5a2b-4c38-9d2d-28cfc306b307@kernel.dk>
Date: Fri, 23 Jan 2026 08:04:49 -0700
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
Content-Language: en-US
In-Reply-To: <fc8664bb-7769-48a2-b470-71fb81828e26@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11900-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[r7625:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 12DDE77925
X-Rspamd-Action: no action

On 1/23/26 7:50 AM, Jens Axboe wrote:
> On 1/23/26 7:26 AM, Pavel Begunkov wrote:
>> On 1/22/26 21:51, Pavel Begunkov wrote:
>> ...
>>>>>> I already briefly touched on that earlier, for sure not going to be of
>>>>>> any practical concern.
>>>>>
>>>>> Modest 16 GB can give 1M entries. Assuming 50ns-100ns per entry for the
>>>>> xarray business, that's 50-100ms. It's all serialised, so multiply by
>>>>> the number of CPUs/threads, e.g. 10-100, that's 0.5-10s. Account sky
>>>>> high spinlock contention, and it jumps again, and there can be more
>>>>> memory / CPUs / numa nodes. Not saying that it's worse than the
>>>>> current O(n^2), I have a test program that borderline hangs the
>>>>> system.
>>>>
>>>> It's definitely not worse than the existing system, which is why I don't
>>>> think it's a big deal. Nobody has ever complained about time to register
>>>> buffers. It's inherently a slow path, and quite slow at that depending
>>>> on the use case. Out of curiosity, I ran some stilly testing on
>>>> registering 16GB of memory, with 1..32 threads. Each will do 16GB, so
>>>> 512GB registered in total for the 32 case. Before is the current kernel,
>>>> after is with per-user xarray accounting:
>>>>
>>>> before
>>>>
>>>> nthreads 1:      646 msec
>>>> nthreads 2:      888 msec
>>>> nthreads 4:      864 msec
>>>> nthreads 8:     1450 msec
>>>> nthreads 16:    2890 msec
>>>> nthreads 32:    4410 msec
>>>>
>>>> after
>>>>
>>>> nthreads 1:      650 msec
>>>> nthreads 2:      888 msec
>>>> nthreads 4:      892 msec
>>>> nthreads 8:     1270 msec
>>>> nthreads 16:    2430 msec
>>>> nthreads 32:    4160 msec
>>>>
>>>> This includes both registering buffers, cloning all of them to another
>>>> ring, and unregistering times, and nowhere is locking scalability an
>>>> issue for the xarray manipulation. The box has 32 nodes and 512 CPUs. So
>>>> no, I strongly believe this isn't an issue.
>>>>
>>>> IOW, accurate accounting is cheaper than the stuff we have now. None of
>>>> them are super cheap. Does it matter? I really don't think so, or people
>>>> would've complained already. The only complaint I got on these kinds of
>>>> things was for cloning, which did get fixed up some releases ago.
>>>
>>> You need compound pages
>>>
>>> always > /sys/kernel/mm/transparent_hugepage/hugepages-16kB/enabled
>>>
>>> And use update() instead of register() as accounting dedup for
>>> registration is broken-disabled. For the current kernel:
>>>
>>> Single threaded:
>>> 1x1G: 7.5s
>>> 2x1G: 45s
>>> 4x1G: 190s
>>>
>>> 16x should be ~3000s, not going to run it. Uninterruptible and no
>>> cond_resched, so spawn NR_CPUS threads and the system is completely
>>> unresponsive (I guess it depends on the preemption mode).
>> The program is below for reference, but it's trivial. THP setting
>> is done inside for convenience. There are ways to make the runtime
>> even worse, but that should be enough.
> 
> Thanks for sending that. Ran it on the same box, on current -git and
> with user_struct xarray accounting. Modified it so that 2nd arg is
> number of threads, for easy running:

Should've tried 32x32 as well, that ends up going deep into "this sucks"
territory:

git

good luck

git + user_struct

axboe@r7625 ~> time ./ppage 32 32
register 32 GB, num threads 32

________________________________________________________
Executed in   16.34 secs    fish           external
   usr time    0.54 secs  497.00 micros    0.54 secs
   sys time  451.94 secs   55.00 micros  451.94 secs

-- 
Jens Axboe

