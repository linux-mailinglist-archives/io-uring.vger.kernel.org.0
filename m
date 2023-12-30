Return-Path: <io-uring+bounces-365-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A40E5820886
	for <lists+io-uring@lfdr.de>; Sat, 30 Dec 2023 22:08:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5AEB1C21457
	for <lists+io-uring@lfdr.de>; Sat, 30 Dec 2023 21:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8E9C153;
	Sat, 30 Dec 2023 21:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IjxGLXw2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4DEC13D;
	Sat, 30 Dec 2023 21:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a2339262835so803314966b.3;
        Sat, 30 Dec 2023 13:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703970475; x=1704575275; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sHF3sKZsu4R9CnT8G/yUetsryJNI3ATWl2kq3NMJLPo=;
        b=IjxGLXw2QPjVMHSppLwlsTXrysz0oMozJrayQeiunLTvz7f5yvNlK15TFlkdYf5uzu
         ItwOJOQ05SAzp2pivyQdSGsaPURLcCWMmHfuPpgi66sP8aWnqFSW+zSeDY0DXrMf7UbX
         jDK17wqdvK02sChMAsua1zm4m2yrt7lEdVw+pnESh8qVibvyxEHSsckBxkQ+Q+RJV8j2
         X9Z7I2b9HLEoSsdvJPRYb4Nv0+xZ31s9jDYaMYYBzXepy5R3swZ1OROKhDmgWymxI1Rx
         Fmdf6j8c8RoF/SAWpvy6xkgcglGczOVa47nGGDSGRtMqawgGxjUHPIkrQLYed5G965W+
         kYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703970475; x=1704575275;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sHF3sKZsu4R9CnT8G/yUetsryJNI3ATWl2kq3NMJLPo=;
        b=FXCWHge46uEAuHlOP/mW9pOfG+KHRSjuYKjRttdaRm1TLi0G4HFEKSRHlnJ64Cb0s7
         sovbzMEBEP39X1+Q34MpaibbsXOde0RY8jHMQwXifD+jCHjeo5W2rcZylCCn7RjW5r2w
         S4xMk5TBWEhot7mCgkACkSskI+ApYu/85fs0SDAiuE5BVRvAji/fXOzYQKE5WMSjDspj
         CHKFhBA4aQTY8rcWxhLN39M/ET/EJrTUnQuG+nrpJ6d4Gj2lIq+QLtOHlq7BqFf6BZwD
         Zj6i8hMZc5FQImDVnkXTeyqVrHKcdgfyff+QBgA/ANutTxuGFCx6rZ2WoKoLwofOa3qj
         eBkw==
X-Gm-Message-State: AOJu0YyZzfEK/klG7eg0Kb5TthUFDU+WclmU3RY41z4gLRl+cTOIbT+L
	j1cUy+8N2C4zNxbZL1qdzUo=
X-Google-Smtp-Source: AGHT+IE3W3+1/5K2uOt47lp/N6mUEhP9aZKY+UiD/5HNRjQb6Y2ABwDn3LHrPc+CLw1M+obw4JHASQ==
X-Received: by 2002:a17:906:7151:b0:a26:983a:af7a with SMTP id z17-20020a170906715100b00a26983aaf7amr6228275ejj.31.1703970475234;
        Sat, 30 Dec 2023 13:07:55 -0800 (PST)
Received: from [192.168.8.100] ([185.69.144.139])
        by smtp.gmail.com with ESMTPSA id su24-20020a17090703d800b00a26ab41d0f7sm8892631ejb.26.2023.12.30.13.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Dec 2023 13:07:54 -0800 (PST)
Message-ID: <6167a98c-35f3-4ea6-a807-dc87c0e4e1bf@gmail.com>
Date: Sat, 30 Dec 2023 21:06:10 +0000
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
To: Jens Axboe <axboe@kernel.dk>, Xiaobing Li <xiaobing.li@samsung.com>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
 cliang01.li@samsung.com, xue01.he@samsung.com
References: <CGME20231225055252epcas5p43ae8016d329b160f688def7b4f9d4ddb@epcas5p4.samsung.com>
 <20231225054438.44581-1-xiaobing.li@samsung.com>
 <170360833542.1229482.7687326255574388809.b4-ty@kernel.dk>
 <7967c7a9-3d17-44de-a170-2b5354460126@gmail.com>
 <57b81a15-58ae-46c1-a1af-9117457a31c7@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <57b81a15-58ae-46c1-a1af-9117457a31c7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/30/23 17:41, Jens Axboe wrote:
> On 12/30/23 9:27 AM, Pavel Begunkov wrote:
>> On 12/26/23 16:32, Jens Axboe wrote:
>>>
>>> On Mon, 25 Dec 2023 13:44:38 +0800, Xiaobing Li wrote:
>>>> Count the running time and actual IO processing time of the sqpoll
>>>> thread, and output the statistical data to fdinfo.
>>>>
>>>> Variable description:
>>>> "work_time" in the code represents the sum of the jiffies of the sq
>>>> thread actually processing IO, that is, how many milliseconds it
>>>> actually takes to process IO. "total_time" represents the total time
>>>> that the sq thread has elapsed from the beginning of the loop to the
>>>> current time point, that is, how many milliseconds it has spent in
>>>> total.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>>
>>> [1/1] io_uring: Statistics of the true utilization of sq threads.
>>>         commit: 9f7e5872eca81d7341e3ec222ebdc202ff536655
>>
>> I don't believe the patch is near complete, there are still
>> pending question that the author ignored (see replies to
>> prev revisions).
> 
> We can drop and defer, that's not an issue. It's still sitting top of
> branch.
> 
> Can you elaborate on the pending questions?

I guess that wasn't clear, but I duplicated all of them in the
email you're replying to for convenience

>> Why it uses jiffies instead of some task run time?
>> Consequently, why it's fine to account irq time and other
>> preemption? (hint, it's not)
> 
> Yeah that's a good point, might be better to use task run time. Jiffies
> is also an annoying metric to expose, as you'd need to then get the tick
> rate as well. Though I suspect the ratio is the interesting bit here.

I agree that seconds are nicer, but that's not my point. That's
not about jiffies, but that the patch keeps counting regardless
whether the SQ task was actually running, or the CPU was serving
irq, or even if it was force descheduled.

I even outlined what a solution may look like, i.e. replace jiffies
with task runtime, which should already be counted in the task.

>> Why it can't be done with userspace and/or bpf? Why
>> can't it be estimated by checking and tracking
>> IORING_SQ_NEED_WAKEUP in userspace?
> 
> Asking people to integrate bpf for this is a bit silly imho. Tracking

I haven't seen any mention of the real use case, did I miss it?
Because otherwise I fail to see how it can possibly be called
silly when it's not clear how exactly it's used.

Maybe it's a bash program printing stats to a curious user? Or
maybe it's to track once at start, and then nobody cares about
it, in which case NEED_WAKEUP would be justified.

I can guess it's for adjusting the sq timeouts, but who knows.

> NEED_WAKEUP is also quite cumbersome and would most likely be higher
> overhead as well.

Comparing to reading a procfs file or doing an io_uring
register syscall? I doubt that. It's also not everyone
would be using that.

>> What's the use case in particular? Considering that
>> one of the previous revisions was uapi-less, something
>> is really fishy here. Again, it's a procfs file nobody
>> but a few would want to parse to use the feature.
> 
> I brought this up earlier too, fdinfo is not a great API. For anything,
> really.

I saw that comment, that's why I mentioned, but the
point is that I have doubts the author is even using
the uapi.

>> Why it just keeps aggregating stats for the whole
>> life time of the ring? If the workload changes,
>> that would either totally screw the stats or would make
>> it too inert to be useful. That's especially relevant
>> for long running (days) processes. There should be a
>> way to reset it so it starts counting anew.
> 
> I don't see a problem there with the current revision, as the app can
> just remember the previous two numbers and do the appropriate math
> "since last time".

I assumed it only prints the ratio. Looked it up, there
are 2 values, so you're right, can be easily recalculated.

>> I say the patch has to be removed until all that is
>> figured, but otherwise I'll just leave a NACK for
>> history.
> 
> That's fine, I can drop it for now and we can get the rest addressed.

-- 
Pavel Begunkov

