Return-Path: <io-uring+bounces-11899-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0LpDHdWKc2l0xAAAu9opvQ
	(envelope-from <io-uring+bounces-11899-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 15:51:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4C39773E3
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 15:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7664B301FA52
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 14:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23791272816;
	Fri, 23 Jan 2026 14:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="saEdZ7XL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f68.google.com (mail-oa1-f68.google.com [209.85.160.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4139328246
	for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769179858; cv=none; b=baC7ruwX68il/yfOwMXnhx8st3rQei7fz3mjGGmsSSqQH+GDhFlRnCZttvBXq/ZeIpnUc9LQd6A7mG2ChoTTDxiOLDyDG7YPQWZmZqNzRKMxQsTLGAXELVtOUvEGnTKf9igQRdS8jPeYT8Jm6g2iFNCsdz/dVo0PWVE8icI8bFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769179858; c=relaxed/simple;
	bh=h1fIbtgalU8SMhDJ12aS8Btj1f1FAuMkkhZULvJ+Frs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQqDD2AimRcOZpWpj++xor6ahM1kKJ0kL5NM1NWg38NG7cxOzSSQR+esdGrEGm/iC0Z5Ik2U8ItvvQDOqS/U82pFQyeJWh1jznAUTEOQijlyXCH37FOIAGPunXwRV/xlH4da7F3dWgYkqpdqbk3XuIa8kupkQkcjRFDACO1bi4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=saEdZ7XL; arc=none smtp.client-ip=209.85.160.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f68.google.com with SMTP id 586e51a60fabf-40423dbe98bso957458fac.2
        for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 06:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769179854; x=1769784654; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8ATysOTaWMj8cri7Y7aGpL+3qMQPpUctvJVa9MsnzBA=;
        b=saEdZ7XLD9VnYjcqC8+4qZ7MCuna79BGoa8W46u2Aw3Xoh7QUrGV7Chsh4pMoUAXUQ
         g8WPEWN6o0KmXftUeQG+JAFvGNZ3xMcUifrbd6aaGMdnAxGQAb7/cA2ZbkoZIdSSS5/N
         SnuXq7YYqVww2HAViyYai9LEwGkppXvsjF//FdmWq/dF6OxcEoBCSknPsOOwyVVy/UUB
         tLqZHepniZ//z/vGhGE0e24q1MPU12MLCQZS5SpcpQQO7s32hYjPafRcDtiOoBuZ6cqB
         dkeQmdW/6t2ZqcZhmnouV8qxMgGJYGNaOybsubA3Q0pWhdLYV5gvYWc0Xgr/yeQct0wo
         NEAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769179854; x=1769784654;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ATysOTaWMj8cri7Y7aGpL+3qMQPpUctvJVa9MsnzBA=;
        b=XJPgUNL13ugxsqxOzRdhS2+Vj0aieYnbpzWDrrfe+IBuSzQPGEy83YUaXHOKa4PIMM
         GdD5bDSgU1pfffVDrebJrkQSuaYoXFudxSrtn9CNaYahtIbraXNCgGKv/mlBPkZFzERj
         e5STspwgG2YFmBezRKL+RC0VicXGTEEHXfSNCW+p9O0sWe29EKRJpu7MZ9dWudSLj/kF
         Ih2baDWEBWoYeSCU8lnqM+dQL9/JeAP/c8835n+nNjgYqhi6tefoGjDlN3VRagYHXy8P
         VjigrJ+iK6pBNip5nLz4W9V6vrF4pu89Awb1ea6250HvwGHk58E8sBO4gccdEIpSyu/u
         lD1g==
X-Gm-Message-State: AOJu0YxfNKScxhmX7DbllehJfMeVc5DdfZ4jKj2p6xqe+HGMELZewSL6
	EHSVlkqqKlEzT/QAo4M6BP0u9Mpog3o2AE6OJECFeFPRBhMpZLvKcmg+uYDFLYMV0Xs=
X-Gm-Gg: AZuq6aJUBfDLauCwlNJoJgQlSr+B3XgqvHD/FqMAHnKBFsmnzJnrtEIwPjldspYEX7n
	w1hT6imJNMQ5C2mXU5HwaEUwBGAc6o7puNlfIjY8IAy/D4AZ/7rvMXYL8vszwTmEIHWY+0d6yns
	ihNBmi+lkwGztZDvYGG+8fTA/w6dQjBXWPTDXCNfg0cadyWac16uJe2fa1X52wOLVYEmXXJiASJ
	GAjfj/HdeawVX3MnoUaQSsroRZwYoug/DJ2Ep9sjCPekM1Tt6wsvjumpgLxpxR2PURf6y0ITIWf
	rT9fFO5x5blIjdwCZeC8gTBqLjrlNRHHvE30jqfxzQh9n6ZB0dG4y9z5M+A2bQEbkHxQxqKIWnl
	k1Z84poKNZJ2TlQqlbjAQT8svPW8bQH/oe/OB1tvV9JtB5l4KBYOvvFRcC5LId27A36C+wEJ+N2
	SMxDeiENqrq4GphjMWYU0154PLpgd95MPf1iULvMyS6HGyyyx9jzbNqPcatb+KSAttP+yt
X-Received: by 2002:a05:6870:f14e:b0:315:6935:9f68 with SMTP id 586e51a60fabf-408aac73102mr1712604fac.0.1769179854351;
        Fri, 23 Jan 2026 06:50:54 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-408afba7305sm1604869fac.11.2026.01.23.06.50.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jan 2026 06:50:53 -0800 (PST)
Message-ID: <fc8664bb-7769-48a2-b470-71fb81828e26@kernel.dk>
Date: Fri, 23 Jan 2026 07:50:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <596bc7ac-3d24-43a7-9e7e-e59189525ebc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11899-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,r7625:email,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: C4C39773E3
X-Rspamd-Action: no action

On 1/23/26 7:26 AM, Pavel Begunkov wrote:
> On 1/22/26 21:51, Pavel Begunkov wrote:
> ...
>>>>> I already briefly touched on that earlier, for sure not going to be of
>>>>> any practical concern.
>>>>
>>>> Modest 16 GB can give 1M entries. Assuming 50ns-100ns per entry for the
>>>> xarray business, that's 50-100ms. It's all serialised, so multiply by
>>>> the number of CPUs/threads, e.g. 10-100, that's 0.5-10s. Account sky
>>>> high spinlock contention, and it jumps again, and there can be more
>>>> memory / CPUs / numa nodes. Not saying that it's worse than the
>>>> current O(n^2), I have a test program that borderline hangs the
>>>> system.
>>>
>>> It's definitely not worse than the existing system, which is why I don't
>>> think it's a big deal. Nobody has ever complained about time to register
>>> buffers. It's inherently a slow path, and quite slow at that depending
>>> on the use case. Out of curiosity, I ran some stilly testing on
>>> registering 16GB of memory, with 1..32 threads. Each will do 16GB, so
>>> 512GB registered in total for the 32 case. Before is the current kernel,
>>> after is with per-user xarray accounting:
>>>
>>> before
>>>
>>> nthreads 1:      646 msec
>>> nthreads 2:      888 msec
>>> nthreads 4:      864 msec
>>> nthreads 8:     1450 msec
>>> nthreads 16:    2890 msec
>>> nthreads 32:    4410 msec
>>>
>>> after
>>>
>>> nthreads 1:      650 msec
>>> nthreads 2:      888 msec
>>> nthreads 4:      892 msec
>>> nthreads 8:     1270 msec
>>> nthreads 16:    2430 msec
>>> nthreads 32:    4160 msec
>>>
>>> This includes both registering buffers, cloning all of them to another
>>> ring, and unregistering times, and nowhere is locking scalability an
>>> issue for the xarray manipulation. The box has 32 nodes and 512 CPUs. So
>>> no, I strongly believe this isn't an issue.
>>>
>>> IOW, accurate accounting is cheaper than the stuff we have now. None of
>>> them are super cheap. Does it matter? I really don't think so, or people
>>> would've complained already. The only complaint I got on these kinds of
>>> things was for cloning, which did get fixed up some releases ago.
>>
>> You need compound pages
>>
>> always > /sys/kernel/mm/transparent_hugepage/hugepages-16kB/enabled
>>
>> And use update() instead of register() as accounting dedup for
>> registration is broken-disabled. For the current kernel:
>>
>> Single threaded:
>> 1x1G: 7.5s
>> 2x1G: 45s
>> 4x1G: 190s
>>
>> 16x should be ~3000s, not going to run it. Uninterruptible and no
>> cond_resched, so spawn NR_CPUS threads and the system is completely
>> unresponsive (I guess it depends on the preemption mode).
> The program is below for reference, but it's trivial. THP setting
> is done inside for convenience. There are ways to make the runtime
> even worse, but that should be enough.

Thanks for sending that. Ran it on the same box, on current -git and
with user_struct xarray accounting. Modified it so that 2nd arg is
number of threads, for easy running:

current -git

axboe@r7625 ~> cat /sys/kernel/mm/transparent_hugepage/hugepages-16kB/enabled
[always] inherit madvise never
axboe@r7625 ~> for i in 1 2 4 8 16; time ./ppage $i $i; end
register 1 GB, num threads 1

________________________________________________________
Executed in  178.91 millis    fish           external
   usr time    9.82 millis  313.00 micros    9.51 millis
   sys time  161.83 millis  149.00 micros  161.68 millis

register 2 GB, num threads 2

________________________________________________________
Executed in  638.49 millis    fish           external
   usr time    0.03 secs    285.00 micros    0.03 secs
   sys time    1.14 secs    135.00 micros    1.14 secs

register 4 GB, num threads 4

________________________________________________________
Executed in    2.17 secs    fish           external
   usr time    0.05 secs  314.00 micros    0.05 secs
   sys time    6.31 secs  150.00 micros    6.31 secs

register 8 GB, num threads 8

________________________________________________________
Executed in    4.97 secs    fish           external
   usr time    0.12 secs  299.00 micros    0.12 secs
   sys time   28.97 secs  142.00 micros   28.97 secs

register 16 GB, num threads 16

________________________________________________________
Executed in   10.34 secs    fish           external
   usr time    0.20 secs  294.00 micros    0.20 secs
   sys time  126.42 secs  140.00 micros  126.42 secs


-git + user_struct xarray for accounting

axboe@r7625 ~> cat /sys/kernel/mm/transparent_hugepage/hugepages-16kB/enabled
[always] inherit madvise never
axboe@r7625 ~> for i in 1 2 4 8 16; time ./ppage $i $i; end
register 1 GB, num threads 1

________________________________________________________
Executed in   54.05 millis    fish           external
   usr time   10.66 millis  327.00 micros   10.34 millis
   sys time   41.60 millis  259.00 micros   41.34 millis

register 2 GB, num threads 2

________________________________________________________
Executed in  105.70 millis    fish           external
   usr time   34.38 millis  206.00 micros   34.17 millis
   sys time   68.55 millis  206.00 micros   68.35 millis

register 4 GB, num threads 4

________________________________________________________
Executed in  214.72 millis    fish           external
   usr time   48.10 millis  193.00 micros   47.91 millis
   sys time  182.25 millis  193.00 micros  182.06 millis

register 8 GB, num threads 8

________________________________________________________
Executed in  441.96 millis    fish           external
   usr time  123.26 millis  195.00 micros  123.07 millis
   sys time  568.20 millis  195.00 micros  568.00 millis

register 16 GB, num threads 16

________________________________________________________
Executed in  917.70 millis    fish           external
   usr time    0.17 secs    202.00 micros    0.17 secs
   sys time    2.48 secs    202.00 micros    2.48 secs


-- 
Jens Axboe

