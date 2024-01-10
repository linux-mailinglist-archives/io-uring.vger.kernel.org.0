Return-Path: <io-uring+bounces-378-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD726829E4D
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 17:15:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E292282F90
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 16:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8809A4CB2C;
	Wed, 10 Jan 2024 16:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="q+MWziIt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39484CB23
	for <io-uring@vger.kernel.org>; Wed, 10 Jan 2024 16:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-360576be804so2620385ab.0
        for <io-uring@vger.kernel.org>; Wed, 10 Jan 2024 08:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1704903320; x=1705508120; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qePtiqcGdjHToKIdeAIkY7ztZz8Quvi+iB4Bqy+oLxY=;
        b=q+MWziIt1L7RcX7SXho/i5bITHjw4XjdHb1Rt6P+/V4nZcUHdmwP+0o/ThFqZOZMpk
         oIcpiNZwRZl7NO1qqKNhYF9wQbVT6LxmQdINPHKHyLIz8pUosH2+EtNRD8LjtYk4NUrW
         tNzd0nkm/Yla6PgEsbaR7jDEt1drB3M4fFr40qzZ3ql9kC5NAxGuD/sTVFlZL+bzzdgE
         YCJD0MNfE6qeXesvbuFGnS16u6JS2g74TGJTzbeYbcvnNVNtLtcKk3pfwKo0eT37j7pc
         4sZb8ih50OH+QRiAqGl69ANL+zM69ahXpQRaa76HLALvPLWgxiL3sKD/+Nnow35q+CHc
         ER/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704903320; x=1705508120;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qePtiqcGdjHToKIdeAIkY7ztZz8Quvi+iB4Bqy+oLxY=;
        b=QZBvkCc3O/rGEEsw7g+1HYrSUwF0P2GqodYmomltLfcTkSP1LzG06qNv13jukzWxdJ
         qNyZ/6WYjZJhuVARQ2EPXCJyIvppHulP2hxsKllMZTupJVyljHdzN5Yp6j8eFJoocl33
         LTrb0H1trapTeeAvm1FpAilwGvdQviSUCGkuTEWB8mBblPFCZFmFWCWquVp+zTV/hynt
         sQ+t1f2kQHgl/tEAvvkw+sRkfXPHDMRz4smqwgPPse9GdHSLfN8Kkc13MxzZatlW49ma
         icNMh3hywYbwzin2RGIc5bnbUBe5riJduV27J3cVCs1SGHO9RjIRVfVmtMkBH2h2+jI1
         fJbg==
X-Gm-Message-State: AOJu0YwJzEvRNYQQcQH1ybR9dyur5tm16vhj2HeZid+uaYD9UgdDadw5
	ZPkXZ0/zZDZJGeRVGlASJ8LrliCsZaPjKg==
X-Google-Smtp-Source: AGHT+IH3Qsg+xqG8H5lyPjeEqT/e10YrqvTQK2p4BASAIH3CWo7Zd5kRW07UsumCkEpWkkJm8xG2jQ==
X-Received: by 2002:a92:c266:0:b0:360:7937:6f7 with SMTP id h6-20020a92c266000000b00360793706f7mr2717839ild.3.1704903320688;
        Wed, 10 Jan 2024 08:15:20 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w2-20020a92d2c2000000b0035d6f8d02d7sm1325038ilg.7.2024.01.10.08.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jan 2024 08:15:19 -0800 (PST)
Message-ID: <b0c67327-5131-4cde-a8bd-df69b1f300e5@kernel.dk>
Date: Wed, 10 Jan 2024 09:15:18 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] io_uring: Statistics of the true utilization of sq
 threads.
Content-Language: en-US
To: Xiaobing Li <xiaobing.li@samsung.com>, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com
References: <c9505525-54d9-4610-a47a-5f8d2d3f8de6@gmail.com>
 <CGME20240110091327epcas5p493e0d77a122a067b6cd41ecbf92bd6eb@epcas5p4.samsung.com>
 <20240110090523.1612321-1-xiaobing.li@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240110090523.1612321-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/10/24 2:05 AM, Xiaobing Li wrote:
> On 1/5/24 04:02 AM, Pavel Begunkov wrote:
>> On 1/3/24 05:49, Xiaobing Li wrote:
>>> On 12/30/23 9:27 AM, Pavel Begunkov wrote:
>>>> Why it uses jiffies instead of some task run time?
>>>> Consequently, why it's fine to account irq time and other
>>>> preemption? (hint, it's not)
>>>>
>>>> Why it can't be done with userspace and/or bpf? Why
>>>> can't it be estimated by checking and tracking
>>>> IORING_SQ_NEED_WAKEUP in userspace?
>>>>
>>>> What's the use case in particular? Considering that
>>>> one of the previous revisions was uapi-less, something
>>>> is really fishy here. Again, it's a procfs file nobody
>>>> but a few would want to parse to use the feature.
>>>>
>>>> Why it just keeps aggregating stats for the whole
>>>> life time of the ring? If the workload changes,
>>>> that would either totally screw the stats or would make
>>>> it too inert to be useful. That's especially relevant
>>>> for long running (days) processes. There should be a
>>>> way to reset it so it starts counting anew.
>>>
>>> Hi, Jens and Pavel,
>>> I carefully read the questions you raised.
>>> First of all, as to why I use jiffies to statistics time, it
>>> is because I have done some performance tests and found that
>>> using jiffies has a relatively smaller loss of performance
>>> than using task run time. Of course, using task run time is
>>
>> How does taking a measure for task runtime looks like? I expect it to
>> be a simple read of a variable inside task_struct, maybe with READ_ONCE,
>> in which case the overhead shouldn't be realistically measurable. Does
>> it need locking?
> 
> The task runtime I am talking about is similar to this:
> start = get_system_time(current);
> do_io_part();
> sq->total_time += get_system_time(current) - start;

Not sure what get_system_time() is, don't see that anywhere.

> Currently, it is not possible to obtain the execution time of a piece of 
> code by a simple read of a variable inside task_struct. 
> Or do you have any good ideas?

I must be missing something, because it seems like all you need is to
read task->stime? You could possible even make do with just logging busy
loop time, as getrusage(RUSAGE_THREAD, &stat) from userspace would then
give you the total time.

stat.ru_stime would then be the total time, the thread ran, and
1 - (above_busy_stime / stat.ru_stime) would give you the time the
percentage of time the thread ran and did useful work (eg not busy
looping.

Hmm?

-- 
Jens Axboe


