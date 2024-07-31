Return-Path: <io-uring+bounces-2621-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 040F0942400
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 02:59:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 505F4B22688
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 00:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC516748D;
	Wed, 31 Jul 2024 00:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LB2ZiEu8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F371746B5;
	Wed, 31 Jul 2024 00:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722387583; cv=none; b=nYCSoTpcVBKywsvOFQj8K8zwaHSq1gmjROPeNWm6O1n0l3OSSlxKQDOY686uxfuXxTjd/0FimogyFRGGDueJKGKnw9sbtl7XoqR4J+6y4KpVci8AeMiiyCUmrc2iruY57+CEF3uTU2HHJTaBm3uXOKYW7D5S3vCC2x76kiFH55k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722387583; c=relaxed/simple;
	bh=+y5QEE3AMSBTEkdNVukqfIgmOEgEwSQCiOTZeiQt4AA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=tHIJtqG8KJ4IR0N4bMXDaUDDQZUvQlBbHsy2CLK72hLgW6/it69C33wwJK0kUGuya/ohYWpIV+PGr3W6gfNS4ZZbTYWxDdkD6TMW4iVwDZX6QQM3Gj2ZChJoosYKcHNu45h8Q0HevF8yIrYq9shDkXJ6bJO7LbBb0matRu6Aw4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LB2ZiEu8; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-42803bbf842so41877785e9.1;
        Tue, 30 Jul 2024 17:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722387580; x=1722992380; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OKr49gkwSZ1Bv1kgxbL5t2qWAvBYKzC4SKLSAp2ANC8=;
        b=LB2ZiEu8GHRcAsfzeLJ7nldqSgsCOg4DEEhdToxapFqGtEP0zrePj2gfKeT971t+7B
         ec0n5u/zTAdXVBetry6SSlayT5Gu+b568lZvOKGVoSh2GJvT6v4afmzm4pYPzBM+43im
         2B/e8UNkkH/7Z1xnrNDE+Wjv13+uOiaqz3cqPuK1DPuU9txQrsVZzsDl9JlCpA8LP2bT
         wGca+io3P/nJDNqKUajIW8YoXC7xdTloLt2NZilCfunShaHuFUWtgRT40W/FCZD1mwoO
         TOMJT1GS6qeGVqOPXhfY/ECSQ+lntjLexQL2ZKHAzwEERDoSmYy4P/2kyFMH6jAIoED3
         u2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722387580; x=1722992380;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OKr49gkwSZ1Bv1kgxbL5t2qWAvBYKzC4SKLSAp2ANC8=;
        b=N7CKorc9HpeX9QfXQNMFHMfqE7PmdYsnfyaf0BqHZ6dJ+UXLOVQV5t8uC0QFWrsQEI
         58C/JnioIyj4R6gPLR+GEuOh9ku+ZGkwirTvikpHaLQ0Jr7qkrUr+h3hKkubh3iTNEn6
         h2yJycrWvyuUTDFLQGqpCRiUT0QISZ9SQmMUHbAwGFhRHlMNlhaLFiWSm5CwXrKT8TLG
         vk/skS8rfJxT6ZNxBSvZM/UGyHRZY23+3IxdwgccleUBBC8VE1GdqXvE+jps2Kfsi4ZA
         ndF1l160RdidKRMOuw9MDG9rIpzN01n4y6vj7Qx2f3dCLO41k7+KNbB6e+I46iQM4csh
         e5rg==
X-Forwarded-Encrypted: i=1; AJvYcCUwlSIx+/PmgkZhB6nytxltiDbByemvlxCJFecPsa7GVTIes+QQ31xyyjUESfWBwIJSiQst8o4T2ABqD3iJPUfMD0UCMqxvD8Y=
X-Gm-Message-State: AOJu0Yy6qb0dKv4IHKix18+VIAcqixiSuFcUpF+r5mQ+WbCp1ZGY1i0t
	xzHQGCE7q5onVZlKsje3KTZannBw/0iSD8TKKP+oo90G2UjC7QSxB6a1wQ==
X-Google-Smtp-Source: AGHT+IFGzLiH0ilYlz67NfCKQr6/lFBJtDoyqYVJRk2FHMuquNQNBvY/EC0p9pAkjsZbVrkBIrGoug==
X-Received: by 2002:a05:600c:310e:b0:428:15b0:c8dd with SMTP id 5b1f17b1804b1-42815b0cb56mr101921525e9.20.1722387580100;
        Tue, 30 Jul 2024 17:59:40 -0700 (PDT)
Received: from [192.168.8.113] ([85.255.235.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4282b89aa93sm1098955e9.10.2024.07.30.17.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 17:59:39 -0700 (PDT)
Message-ID: <66f7bc8a-e4a9-4912-9ea7-c88dbb6fb999@gmail.com>
Date: Wed, 31 Jul 2024 02:00:11 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring NAPI busy poll RCU is causing 50 context switches/second
 to my sqpoll thread
From: Pavel Begunkov <asml.silence@gmail.com>
To: Olivier Langlois <olivier@trillion01.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
References: <b1ad0ab3a7e70b72aa73b0b7cab83273358b2e1d.camel@trillion01.com>
 <00918946-253e-43c9-a635-c91d870407b7@gmail.com>
 <bcd3b198697e16059ec69566251ad23c4c78e7a7.camel@trillion01.com>
 <43c27aa1-d955-4375-8d96-cd4201aecf50@gmail.com>
Content-Language: en-US
In-Reply-To: <43c27aa1-d955-4375-8d96-cd4201aecf50@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/24 01:33, Pavel Begunkov wrote:
> On 7/31/24 00:14, Olivier Langlois wrote:
>> On Tue, 2024-07-30 at 21:25 +0100, Pavel Begunkov wrote:
>>>
>>> Removing an entry or two once every minute is definitely not
>>> going to take 50% CPU, RCU machinery is running in background
>>> regardless of whether io_uring uses it or not, and it's pretty
>>> cheap considering ammortisation.
>>>
>>> If anything it more sounds from your explanation like the
>>> scheduler makes a wrong decision and schedules out the sqpoll
>>> thread even though it could continue to run, but that's need
>>> a confirmation. Does the CPU your SQPOLL is pinned to stays
>>> 100% utilised?
>>
>> Here are the facts as they are documented in the github issue.
>>
>> 1. despite thinking that I was doing NAPI busy polling, I was not
>> because my ring was not receiving any sqe after its initial setup.
>>
>> This is what the patch developped with your input
>> https://lore.kernel.org/io-uring/382791dc97d208d88ee31e5ebb5b661a0453fb79.1722374371.git.olivier@trillion01.com/T/#u
>>
>> is addressing
>>
>> (BTW, I should check if there is such a thing, but I would love to know
>> if the net code is exposing a tracepoint when napi_busy_poll is called
>> because it is very tricky to know if it is done for real or not)
>>
>> 2. the moment a second ring has been attached to the sqpoll thread that
>> was receving a lot of sqe, the NAPI busy loop started to be made for
>> real and the sqpoll cpu usage unexplicably dropped from 99% to 55%
>>
>> 3. here is my kernel cmdline:
>> hugepages=72 isolcpus=0,1,2 nohz_full=0,1,2 rcu_nocbs=0,1,2
>> rcu_nocb_poll irqaffinity=3 idle=nomwait processor.max_cstate=1
>> intel_idle.max_cstate=1 nmi_watchdog=0
>>
>> there is absolutely nothing else on CPU0 where the sqpoll thread
>> affinity is set to run.
>>
>> 4. I got the idea of doing this:
>> echo common_pid == sqpoll_pid > /sys/kernel/tracing/events/sched/filter
>> echo 1 > /sys/kernel/tracing/events/sched/sched_switch/enable
>>
>> and I have recorded over 1,000 context switches in 23 seconds with RCU
>> related kernel threads.
>>
>> 5. just for the fun of checking out, I have disabled NAPI polling on my
>> io_uring rings and the sqpoll thread magically returned to 99% CPU
>> usage from 55%...
>>
>> I am open to other explanations for what I have observed but my current
>> conclusion is based on what I am able to see... the evidence appears
>> very convincing to me...
> 
> You're seeing something that doesn't make much sense to me, and we need
> to understand what that is. There might be a bug _somewhere_, that's
> always a possibility, but before saying that let's get a bit more data.
> 
> While the app is working, can you grab a profile and run mpstat for the
> CPU on which you have the SQPOLL task?
> 
> perf record -g -C <CPU number> --all-kernel &
> mpstat -u -P <CPU number> 5 10 &
> 
> And then as usual, time it so that you have some activity going on,
> mpstat interval may need adjustments, and perf report it as before

I forgot to add, ~50 switches/second for relatively brief RCU handling
is not much, not enough to take 50% of a CPU. I wonder if sqpoll was
still running but napi busy polling time got accounted to softirq
because of disabled bh and you didn't include it, hence asking CPU
stats. Do you see any latency problems for that configuration?

-- 
Pavel Begunkov

