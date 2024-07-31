Return-Path: <io-uring+bounces-2620-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E7FD39423D9
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 02:32:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B5E6B21515
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 00:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCB6838C;
	Wed, 31 Jul 2024 00:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F50QiAw5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2445D366;
	Wed, 31 Jul 2024 00:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722385962; cv=none; b=j8IdFkaWhoWsj7eAauFvNGwqFg1cNsWy4LL/DGCH2do3FGaBoVrAcsxD+69flvRc88B2Smm6c4zcphNIpWneiZJ4M3fMFXE9FDR7wP8RZTKQXDEBhdUanJsvnQ6/vzYDV7wzv+jtE2cnWn0+5kZ/ghpP5gg4XxOp3CiqStZ7H3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722385962; c=relaxed/simple;
	bh=oUwiESMRM4hR3kzxV4xNUXnL9EERKytaxyZWCmeiz6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O9MVxjVhpmDG2GKYf7O/iT76GmRyLAy8Sywn4uuhk4GVVJ8dGKMj8303vUZgmvnx0yg1nJhlnwvS16reeT08OyiTLa0VPa70bMwkTFcGP+BsYhfyvU2xqa0X8pS/bfbjf8CS0XLK24TCsoaKWXn51gh4FNN77dhRzneNkfC4Dto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F50QiAw5; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-428178fc07eso29723065e9.3;
        Tue, 30 Jul 2024 17:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722385959; x=1722990759; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VLlGCnTTNODGZRB+fh14iBJjAVZNdN/fQwJzMB+9Wpw=;
        b=F50QiAw5TpAMFXuCeJcUJMIy0zKt4b1vBx3aUhcogUmEDyScBmvp0tNh0vO2QjEC+K
         Ky5sdpRGLob50fMKbXGKG+Dx8pZoL2UaJOjePFqDgCM2ZdbEenqeZ4PjXi6ExRoXrrrY
         GPAKKIssdtBqRMPmsEOm/yJRr8hvw0NtCP2Lc/Bq1RJZ/67U2TWbCKilWLWWYCkWKEDm
         QBuIFZPuwqpUdaJIu/0dEEx9fMdeGGWv+QTTY9zf0qzDBZms5V33y0f0cnEH6qEynwIE
         OD0fNG7O+XwUs5Jnjn3G6Uaq3CrlNjf/k1SoyRCM8XvSOXOL5Aml1e1fK3kq6evuYBpe
         koKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722385959; x=1722990759;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VLlGCnTTNODGZRB+fh14iBJjAVZNdN/fQwJzMB+9Wpw=;
        b=NX9IOnrwAFHeJFglPlHWKz2hIpRRaar1A4UBtBy262esey6qLBUNA8um4/MuY1Wn9V
         25NYBjrS+/ieqZMtFC72oIx2aWpNL0USQzFT+mDGqtl3RGYD6HpIOdyfZdAk/rAfr7NJ
         On9HMwepw23V0GbNuda+BddcuY9goHhD5OKlOCYiMURNYPzRqQLwcDTpqrApQ8jIhQtx
         QXu36EI5ezwmIwqXve6Nuak9RdYjr0agLcdyeFpkYIxomeJJQjxojPuDy0OaipnE8dZ8
         shyLFOKKnptk6zwQjOlxh/0wUlSqHwOOq4YDfLTxeI3ngsGbG4WDCccq5AdFlO2ja7fv
         SNhA==
X-Forwarded-Encrypted: i=1; AJvYcCXnWzKwpbkH/HK9HWkZmPSjQzpBfGErUTMuFw/5398mtuOqp2Q3IA+Q5Vxix4OU1jfhQRMDTz+XnS4Tk7u52+Il9EtRqI4a0bs=
X-Gm-Message-State: AOJu0Ywmpn6oo0/h2FLqChI/qKXU264zA5dXpw9xVHPoHOn+sEF7q0n6
	2w3dETn3VFpr1aLUkgGtqf6rv10i10H8xGCuiKy+YLMIGcZDof1Y0ZT7bQ==
X-Google-Smtp-Source: AGHT+IEWuELY0MRTZrMelLVtMUrJIVC6n4Wy3NuGAi73ADVy348aOBI36znJyTIWGSda8o2Y9NurVg==
X-Received: by 2002:a05:600c:6b06:b0:426:6f1e:ce93 with SMTP id 5b1f17b1804b1-42811dfe3d0mr82924125e9.33.1722385958824;
        Tue, 30 Jul 2024 17:32:38 -0700 (PDT)
Received: from [192.168.8.113] ([85.255.235.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4282bb226b0sm468085e9.46.2024.07.30.17.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 17:32:38 -0700 (PDT)
Message-ID: <43c27aa1-d955-4375-8d96-cd4201aecf50@gmail.com>
Date: Wed, 31 Jul 2024 01:33:10 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring NAPI busy poll RCU is causing 50 context switches/second
 to my sqpoll thread
To: Olivier Langlois <olivier@trillion01.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
References: <b1ad0ab3a7e70b72aa73b0b7cab83273358b2e1d.camel@trillion01.com>
 <00918946-253e-43c9-a635-c91d870407b7@gmail.com>
 <bcd3b198697e16059ec69566251ad23c4c78e7a7.camel@trillion01.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bcd3b198697e16059ec69566251ad23c4c78e7a7.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/24 00:14, Olivier Langlois wrote:
> On Tue, 2024-07-30 at 21:25 +0100, Pavel Begunkov wrote:
>>
>> Removing an entry or two once every minute is definitely not
>> going to take 50% CPU, RCU machinery is running in background
>> regardless of whether io_uring uses it or not, and it's pretty
>> cheap considering ammortisation.
>>
>> If anything it more sounds from your explanation like the
>> scheduler makes a wrong decision and schedules out the sqpoll
>> thread even though it could continue to run, but that's need
>> a confirmation. Does the CPU your SQPOLL is pinned to stays
>> 100% utilised?
> 
> Here are the facts as they are documented in the github issue.
> 
> 1. despite thinking that I was doing NAPI busy polling, I was not
> because my ring was not receiving any sqe after its initial setup.
> 
> This is what the patch developped with your input
> https://lore.kernel.org/io-uring/382791dc97d208d88ee31e5ebb5b661a0453fb79.1722374371.git.olivier@trillion01.com/T/#u
> 
> is addressing
> 
> (BTW, I should check if there is such a thing, but I would love to know
> if the net code is exposing a tracepoint when napi_busy_poll is called
> because it is very tricky to know if it is done for real or not)
> 
> 2. the moment a second ring has been attached to the sqpoll thread that
> was receving a lot of sqe, the NAPI busy loop started to be made for
> real and the sqpoll cpu usage unexplicably dropped from 99% to 55%
> 
> 3. here is my kernel cmdline:
> hugepages=72 isolcpus=0,1,2 nohz_full=0,1,2 rcu_nocbs=0,1,2
> rcu_nocb_poll irqaffinity=3 idle=nomwait processor.max_cstate=1
> intel_idle.max_cstate=1 nmi_watchdog=0
> 
> there is absolutely nothing else on CPU0 where the sqpoll thread
> affinity is set to run.
> 
> 4. I got the idea of doing this:
> echo common_pid == sqpoll_pid > /sys/kernel/tracing/events/sched/filter
> echo 1 > /sys/kernel/tracing/events/sched/sched_switch/enable
> 
> and I have recorded over 1,000 context switches in 23 seconds with RCU
> related kernel threads.
> 
> 5. just for the fun of checking out, I have disabled NAPI polling on my
> io_uring rings and the sqpoll thread magically returned to 99% CPU
> usage from 55%...
> 
> I am open to other explanations for what I have observed but my current
> conclusion is based on what I am able to see... the evidence appears
> very convincing to me...

You're seeing something that doesn't make much sense to me, and we need
to understand what that is. There might be a bug _somewhere_, that's
always a possibility, but before saying that let's get a bit more data.

While the app is working, can you grab a profile and run mpstat for the
CPU on which you have the SQPOLL task?

perf record -g -C <CPU number> --all-kernel &
mpstat -u -P <CPU number> 5 10 &

And then as usual, time it so that you have some activity going on,
mpstat interval may need adjustments, and perf report it as before.

-- 
Pavel Begunkov

