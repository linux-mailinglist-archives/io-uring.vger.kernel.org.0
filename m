Return-Path: <io-uring+bounces-374-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7EFB824D96
	for <lists+io-uring@lfdr.de>; Fri,  5 Jan 2024 05:12:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B96B285D46
	for <lists+io-uring@lfdr.de>; Fri,  5 Jan 2024 04:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9028522F;
	Fri,  5 Jan 2024 04:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Txq4EHQy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D46C5225;
	Fri,  5 Jan 2024 04:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-33674f60184so1077792f8f.1;
        Thu, 04 Jan 2024 20:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704427969; x=1705032769; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OLFgjsm/ePBrhreKAVD6iKPTAL6Ej79d9/IiFEfTBI0=;
        b=Txq4EHQyesep1UExecuo5xg613qImSNdTVyqQ2bOzpuCb23oIsvHAM/ujUm9vu5jyL
         AF7C4XAZxeoDx0/ANqjlQFbwiitvb3wYC0kzECxRrK6hNRJ4wUkDdXEL8vEhlIkxUYZt
         1qErX2n/QZkHvU/oDsJFXt6qfkcG5dU5lvpa7oiEjyVxgcSZiti9KyD3kRxR+Hwfxxas
         NO9GlntgNlWtffdkYhJWHZy/+qCembgftjHrwbEakmdJIAIGGLZAWmVSlxBXPi5dgScD
         e2xavoNA54fbgiMV1jNYeQcmsb7PibmRTtt373nsg+ecURgPeIs1zUMWwetUg6TgmCeP
         gXEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704427969; x=1705032769;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OLFgjsm/ePBrhreKAVD6iKPTAL6Ej79d9/IiFEfTBI0=;
        b=fwUPHF6Lkt8BsVjjU2otxTRuq2XGA07U27rwOo5CoH5VSE4p75FC8pRCThGAwwurwu
         gNlT+8kxxfuY2cmz7sc1w92fg/ydK5SIMOa6oNGEGhvTaUHR72V2ebvD217QN4g91h/S
         xQE2wqO0Z0njxuOq2IzmlJ5eMUmOHhlPOHl+YhQjFgBeXUrXYj8U2UJV8VFXVwuq7w8H
         YzCj/Mfe0tu25WRJ668VxHjiQ/iJMcbV6P9BLsqnVqXED867u7R8wI35LE4aTod0x94p
         TpdcFMhtYNNPLgoI7B8KuV9Nd3MrmDcc1vct97FqbYymU5lDVqekjC/xQuZ/WqjWiy+G
         G0og==
X-Gm-Message-State: AOJu0YyTx6zwLAtqysU9s5zMj81TlvFkLwUMJKpJ261U7AD5HGAbmprg
	jVxYyUjmU5rP170YUWiImWuvjLi3dQ4=
X-Google-Smtp-Source: AGHT+IHclGZI4k0BauVsTmj9Gf+ZWggo3ZTfLk0x84mMZWmBhfkAmfZQ61D75J5ZE/ngXYeJwyC40g==
X-Received: by 2002:a7b:c40c:0:b0:40d:6686:eb75 with SMTP id k12-20020a7bc40c000000b0040d6686eb75mr838086wmi.161.1704427969074;
        Thu, 04 Jan 2024 20:12:49 -0800 (PST)
Received: from [192.168.8.100] ([85.255.233.36])
        by smtp.gmail.com with ESMTPSA id fa17-20020a05600c519100b0040d7b1ef521sm249118wmb.15.2024.01.04.20.12.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jan 2024 20:12:48 -0800 (PST)
Message-ID: <c9505525-54d9-4610-a47a-5f8d2d3f8de6@gmail.com>
Date: Fri, 5 Jan 2024 04:02:38 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v6] io_uring: Statistics of the true utilization of sq
 threads.
To: Xiaobing Li <xiaobing.li@samsung.com>, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com
References: <7967c7a9-3d17-44de-a170-2b5354460126@gmail.com>
 <CGME20240103055746epcas5p148c2b06032e09956ddcfc72894abc82a@epcas5p1.samsung.com>
 <20240103054940.2121301-1-xiaobing.li@samsung.com>
Content-Language: en-US
In-Reply-To: <20240103054940.2121301-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/3/24 05:49, Xiaobing Li wrote:
> On 12/30/23 9:27 AM, Pavel Begunkov wrote:
>> Why it uses jiffies instead of some task run time?
>> Consequently, why it's fine to account irq time and other
>> preemption? (hint, it's not)
>>
>> Why it can't be done with userspace and/or bpf? Why
>> can't it be estimated by checking and tracking
>> IORING_SQ_NEED_WAKEUP in userspace?
>>
>> What's the use case in particular? Considering that
>> one of the previous revisions was uapi-less, something
>> is really fishy here. Again, it's a procfs file nobody
>> but a few would want to parse to use the feature.
>>
>> Why it just keeps aggregating stats for the whole
>> life time of the ring? If the workload changes,
>> that would either totally screw the stats or would make
>> it too inert to be useful. That's especially relevant
>> for long running (days) processes. There should be a
>> way to reset it so it starts counting anew.
> 
> Hi, Jens and Pavel,
> I carefully read the questions you raised.
> First of all, as to why I use jiffies to statistics time, it
> is because I have done some performance tests and found that
> using jiffies has a relatively smaller loss of performance
> than using task run time. Of course, using task run time is

How does taking a measure for task runtime looks like? I expect it to
be a simple read of a variable inside task_struct, maybe with READ_ONCE,
in which case the overhead shouldn't be realistically measurable. Does
it need locking?

> indeed more accurate.  But in fact, our requirements for
> accuracy are not particularly high, so after comprehensive

I'm looking at it as a generic feature for everyone, and the
accuracy behaviour is dependent on circumstances. High load
networking spends quite a good share of CPU in softirq, and
preemption would be dependent on config, scheduling, pinning,
etc.

> consideration, we finally chose to use jiffies.
> Of course, if you think that a little more performance loss
> here has no impact, I can use task run time instead, but in
> this case, does the way of calculating sqpoll thread timeout
> also need to be changed, because it is also calculated through
> jiffies.

That's a good point. It doesn't have to change unless you're
directly inferring the idle time parameter from those two
time values rather than using the ratio. E.g. a simple
bisection of the idle time based on the utilisation metric
shouldn't change. But that definitely raises the question
what idle_time parameter should exactly mean, and what is
more convenient for algorithms.


> Then there’s how to use this metric.
> We are studying some optimization methods for io-uring, including
> performance and CPU utilization, but we found that there is
> currently no tool that can observe the CPU ratio of sqthread's
> actual processing IO part, so we want to merge this method  that
> can observe this value so that we can more easily observe the
> optimization effects.

-- 
Pavel Begunkov

