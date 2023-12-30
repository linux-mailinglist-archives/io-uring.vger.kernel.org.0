Return-Path: <io-uring+bounces-367-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DCA1B82089C
	for <lists+io-uring@lfdr.de>; Sat, 30 Dec 2023 23:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 568EC1F21D38
	for <lists+io-uring@lfdr.de>; Sat, 30 Dec 2023 22:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88088D26D;
	Sat, 30 Dec 2023 22:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jPKkB8Kk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D274BCA49
	for <io-uring@vger.kernel.org>; Sat, 30 Dec 2023 22:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6d2793532d2so604357b3a.1
        for <io-uring@vger.kernel.org>; Sat, 30 Dec 2023 14:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703974639; x=1704579439; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KQ8sovo2bizB+K5f8FD1flPar00AxPI0fwjU2TE0akA=;
        b=jPKkB8Kku6QZgHB54jq+jAT0VL+i64RfwugIB7UYuXHm6ajvK9Cb3KE+U9na71UF5Y
         D1qFLpRXbSuI3Kb3u7tAq1BHuw2pZAMlwyXe0qoqTKiUf9cds/OPKbuZ/tpnJU3rRmCI
         H9vzkZBBCzxI2sRhA4E9C7bLDvwVq6Ab2cYxy+iKUMnyhXN6Z49FhB5yGuaNvSz/yHFj
         yg4sfRs5qJ1rLpBm6v6rrc2CoL2hbe4ZWWMAKdPlcLYSBa0MTKYKitZ9aObDwcHrd2ny
         hHCrd2Dwhv/5Y9S19AfTvRS68KvuEeCIN7D+u4wBkpN2tRQe7iHfHE0mLyGPNKspwOO3
         espQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703974639; x=1704579439;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KQ8sovo2bizB+K5f8FD1flPar00AxPI0fwjU2TE0akA=;
        b=phF0Gy80e5oALzpaBKxli1grBrPvJn3d+Z60tsAnXrpXMlLx6ijDoMWlBc7J/dDXTO
         SNi8Nz5/q0cr5cfXT/re7llIIzo77+4eLkIQgm9OQSc5Bj7XXKTkVMucdP+1h5Vu7urQ
         HLvxBaEufpWHzt3foT3aXb6urpuUOiOnsLkVGDen6jraKwwMItBtIISidBqgirH1STYc
         r9Lh2uEuMLNF8oI9s3bwxSzPzcjKW96wz24weo+WwOkjrgGq1ThzZEl0l5PjKEFdJv+5
         zKviTEpNvUXAX8QZcDdOqb4RtXJ4j9t12O4kjSKbgdF+vsASVxux1vz15UZZzpn9MQZ3
         dGHw==
X-Gm-Message-State: AOJu0YwyP2AhI448RnwaGJ0+D3wxMFryrhN7uR0TSDoYmXLtoS/R68zT
	78ff7MbIGCZCgCh4BBNBgJVJfirNDzd73g==
X-Google-Smtp-Source: AGHT+IFwZc0N1Vsc1jp/K0NEObt8wc1MXFPN9k0Z8EY1WRITtrJhBE4EM6cG4pON5uWVyWO8VELcBQ==
X-Received: by 2002:a05:6a21:819b:b0:196:16b0:c554 with SMTP id pd27-20020a056a21819b00b0019616b0c554mr12387117pzb.5.1703974639128;
        Sat, 30 Dec 2023 14:17:19 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id n38-20020a634d66000000b005897bfc2ed3sm16381078pgl.93.2023.12.30.14.17.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Dec 2023 14:17:18 -0800 (PST)
Message-ID: <d383aaa6-8918-42c6-8ec0-73e234175770@kernel.dk>
Date: Sat, 30 Dec 2023 15:17:17 -0700
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
To: Pavel Begunkov <asml.silence@gmail.com>,
 Xiaobing Li <xiaobing.li@samsung.com>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
 cliang01.li@samsung.com, xue01.he@samsung.com
References: <CGME20231225055252epcas5p43ae8016d329b160f688def7b4f9d4ddb@epcas5p4.samsung.com>
 <20231225054438.44581-1-xiaobing.li@samsung.com>
 <170360833542.1229482.7687326255574388809.b4-ty@kernel.dk>
 <7967c7a9-3d17-44de-a170-2b5354460126@gmail.com>
 <57b81a15-58ae-46c1-a1af-9117457a31c7@kernel.dk>
 <6167a98c-35f3-4ea6-a807-dc87c0e4e1bf@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6167a98c-35f3-4ea6-a807-dc87c0e4e1bf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/30/23 2:06 PM, Pavel Begunkov wrote:
> On 12/30/23 17:41, Jens Axboe wrote:
>> On 12/30/23 9:27 AM, Pavel Begunkov wrote:
>>> On 12/26/23 16:32, Jens Axboe wrote:
>>>>
>>>> On Mon, 25 Dec 2023 13:44:38 +0800, Xiaobing Li wrote:
>>>>> Count the running time and actual IO processing time of the sqpoll
>>>>> thread, and output the statistical data to fdinfo.
>>>>>
>>>>> Variable description:
>>>>> "work_time" in the code represents the sum of the jiffies of the sq
>>>>> thread actually processing IO, that is, how many milliseconds it
>>>>> actually takes to process IO. "total_time" represents the total time
>>>>> that the sq thread has elapsed from the beginning of the loop to the
>>>>> current time point, that is, how many milliseconds it has spent in
>>>>> total.
>>>>>
>>>>> [...]
>>>>
>>>> Applied, thanks!
>>>>
>>>> [1/1] io_uring: Statistics of the true utilization of sq threads.
>>>>         commit: 9f7e5872eca81d7341e3ec222ebdc202ff536655
>>>
>>> I don't believe the patch is near complete, there are still
>>> pending question that the author ignored (see replies to
>>> prev revisions).
>>
>> We can drop and defer, that's not an issue. It's still sitting top of
>> branch.
>>
>> Can you elaborate on the pending questions?
> 
> I guess that wasn't clear, but I duplicated all of them in the
> email you're replying to for convenience
> 
>>> Why it uses jiffies instead of some task run time?
>>> Consequently, why it's fine to account irq time and other
>>> preemption? (hint, it's not)
>>
>> Yeah that's a good point, might be better to use task run time. Jiffies
>> is also an annoying metric to expose, as you'd need to then get the tick
>> rate as well. Though I suspect the ratio is the interesting bit here.
> 
> I agree that seconds are nicer, but that's not my point. That's
> not about jiffies, but that the patch keeps counting regardless
> whether the SQ task was actually running, or the CPU was serving
> irq, or even if it was force descheduled.

Right, guess I wasn't clear, I did very much agree with using task run
time to avoid cases like that where it's perceived running, but really
isn't. For example.

> I even outlined what a solution may look like, i.e. replace jiffies
> with task runtime, which should already be counted in the task.

Would be a good change to make. And to be fair, I guess they originally
wanted something like that, as the very first patch had some scheduler
interactions. Just wasn't done quite right.

>>> Why it can't be done with userspace and/or bpf? Why
>>> can't it be estimated by checking and tracking
>>> IORING_SQ_NEED_WAKEUP in userspace?
>>
>> Asking people to integrate bpf for this is a bit silly imho. Tracking
> 
> I haven't seen any mention of the real use case, did I miss it?
> Because otherwise I fail to see how it can possibly be called
> silly when it's not clear how exactly it's used.
> 
> Maybe it's a bash program printing stats to a curious user? Or
> maybe it's to track once at start, and then nobody cares about
> it, in which case NEED_WAKEUP would be justified.
> 
> I can guess it's for adjusting the sq timeouts, but who knows.

I only know what is in those threads, but the most obvious use case
would indeed be to vet the efficiency of the chosen timeout value and
balance cpu usage with latency like that.

>> NEED_WAKEUP is also quite cumbersome and would most likely be higher
>> overhead as well.
> 
> Comparing to reading a procfs file or doing an io_uring
> register syscall? I doubt that. It's also not everyone
> would be using that.

What's the proposed integration to make NEED_WAKEUP sampling work? As
far as I can tell, you'd need to either do that kind of accounting every
time you do io_uring_submit(), or make it conditional which would then
at least still have a branch.

The kernel side would obviously not be free either, but at least it
would be restricted to the SQPOLL side of things and not need to get
entangled with the general IO path that doesn't use SQPOLL.

If we put it in there and have some way to enable/query/disable, then it
least it would just be a branch or two in there rather than in the
generic path.

>>> What's the use case in particular? Considering that
>>> one of the previous revisions was uapi-less, something
>>> is really fishy here. Again, it's a procfs file nobody
>>> but a few would want to parse to use the feature.
>>
>> I brought this up earlier too, fdinfo is not a great API. For anything,
>> really.
> 
> I saw that comment, that's why I mentioned, but the
> point is that I have doubts the author is even using
> the uapi.

Not sure I follow... If they aren't using the API, what's the point of
the patch? Or are you questioning whether this is being done for an
actual use case, or just as a "why not, might be handy" kind of thing?

-- 
Jens Axboe


