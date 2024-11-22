Return-Path: <io-uring+bounces-4984-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05D889D62C0
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 18:09:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B96A0282244
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 17:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F1B1DF96A;
	Fri, 22 Nov 2024 17:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QtIRa0oR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A501DF250
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 17:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732295345; cv=none; b=V5VF60nwWv90ke92SomaWG40LHyMGYdDtXStIDzhwJ9XRKrRYo8EXX6ywfvYqo60FBF0ldf9ybVknr/dB7c+MIw87AmUEsRHIGC/BrFT1yd9o+RRjwsUKRHiPUNZhc67Kg2biyuDyZXfIlTqgo6HKfwA4o0hmwCK87S0I0bts1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732295345; c=relaxed/simple;
	bh=7X/tSSWLlpC+tFB6poNbJxeupVYeRdsPI9I/9nxdb0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MgkBaSy4tle2l/csK/XrHY6lBqKX0HStIkAzc2KyeDXxoq8KEjujMSbj8+5DEwsh4CaQJwh3dwPT7N8Mxh5Eg3rECJR7pRNrEUEQOzIp2QwpigJJ7bUHrh0wmShLq+VgmKAHM1dYwntKcCYyBBTfNN5ro2vwsjR2nz1f6jqjzCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QtIRa0oR; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-71807ad76a8so1184350a34.0
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 09:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732295341; x=1732900141; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wA9VYwn6OCMzS1xHNvABJTTkPcb/agUdsygoysLoaTQ=;
        b=QtIRa0oRhZySRoiHZ1659oemN/eBhpPty6nyOvHnHe53bNB5nMZfIjf+wnwQSR25oZ
         3RK16289IMXWkQ/IV46mFjW+DzNHJZkLkg8x7ydwi7wTu56BuDuUfbH1bhw9oTsOeaCB
         C3US/IIuTQq1avajbG5Lmy5lidaeAlXbn8R57bEXmMb8fyheM0AXsA7Yl1qmHClhsEbm
         I5wRV+ZFUsdNp7fjiuAvT9niTGYxGMx002sM80fP0m10bpIWjOG5uvQTcLqbW2bYbydw
         jZCSz0FVLcHqCDwz4XH7WLUaEYKdRhXChc6eXn2ER9STVCUfZccpFemnJ/8E685Ok/Fu
         RZiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732295341; x=1732900141;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wA9VYwn6OCMzS1xHNvABJTTkPcb/agUdsygoysLoaTQ=;
        b=dS+y9Cg/08T3bXT+8/G4I2CXNj0m1IvGU7Pw/cE+OTL8MNStZFRoFXNehKqODqNXmv
         N4wZA3UjCIKU3iH24Bo43jwYN+Lm/C3iSEXgdZ9XZVEg4lS4ON1pXbe5O7eEJ6H0Ualu
         Bgqd2+D0J/UZb3wctNwJg7SFpwWPgVKO/2HlukYKupvTTC6d2E8BqntrtBmrfnnQlsJ5
         i+ozwHDkO5Qw6GIfhmGxphq6PC6f75wQZzaYB5TX0ahQWIko4MU7VWi+YBa7O9ruANuo
         tjn+x2AHJwR1AtZk2zKAZAlzzSfb4eLHSHUV/Tg5wSi995eFztQYcJgmsjk870UoCybm
         CsEg==
X-Forwarded-Encrypted: i=1; AJvYcCXqqGFyB4f5Q8lvh0+TeLxkg9YfuMEAwABQ3AgGRpIHlffL2yt3WSOtRsLkBx0HbJWti4LwBLnn4g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/tKMsk3X0Q2uW1EHiOnGbCnIaEy2WzsQcr3gCNyriuDchWXbB
	V+c2ODYeI5gqbSV5QqDt0qMKIE0+TBKlzCwkMai1uTZonuE+1cxvCF/avBUNAn2ts0MvP+7ODEI
	sjX0=
X-Gm-Gg: ASbGncv/OgKsrCOzKDIrytOQSqgaFPHUBOgLTPU/QJLFFFoRjGLSfEYBNbJ6Mhj+MUc
	iYw4tT6hEuUH4HzOQJEwYg31OKiKXFFtfo6QWUI8ceFPlWeiq/SEt5mmfS9MCFJViNBXwOoMpzX
	n0R1Y+j9nQ+JFtgsgnPb6YVmW6W0fUj0Ntvp6AQmoO3IA8pbfv6FJGii6aQ+V298RKP9/qiehs2
	DaS3R65jsBl+bJem15ESXgg/YzQcdYcW6O4xCGZI2fY8w==
X-Google-Smtp-Source: AGHT+IH9iJ75z4pguCPs2l7FVxHyPVeRwiw4RUvwPijLc2Atph5exoVhcW5yPw61aweQ9sK3yP+Pzw==
X-Received: by 2002:a9d:6f18:0:b0:718:157a:efad with SMTP id 46e09a7af769-71c04ba3084mr3951600a34.13.1732295340817;
        Fri, 22 Nov 2024 09:09:00 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71c03790782sm492274a34.40.2024.11.22.09.09.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 09:09:00 -0800 (PST)
Message-ID: <390502d5-2de4-42e0-a899-a0e25d1ee5d7@kernel.dk>
Date: Fri, 22 Nov 2024 10:08:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <95470d11-c791-4b00-be95-45c2573c6b86@kernel.dk>
 <614ce5a4-d289-4c3a-be5b-236769566557@gmail.com>
 <b7170b8e-9346-465b-be60-402c8f125e54@kernel.dk>
 <66fa0bfd-13aa-4608-a390-17ea5f333940@gmail.com>
 <9859667c-0fbf-4aa5-9779-dae91a9c128b@kernel.dk>
 <3e6a574c-27ae-47f4-a3e3-2be2c385f89b@kernel.dk>
 <357a3a72-5918-44e1-b84f-54ae093cf419@gmail.com>
 <375a1b30-5e68-439d-be55-444eaa19d7ef@kernel.dk>
 <c2f80710-7253-4dfb-a275-6698f65ab25c@gmail.com>
 <80eeba88-2738-405e-b539-516d67f0dcd2@kernel.dk>
 <e7a2ed0e-fe0a-4a19-86bf-90bd38bc6b61@kernel.dk>
 <c7c5f1e6-e794-4cef-a45e-773e05aa4d71@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c7c5f1e6-e794-4cef-a45e-773e05aa4d71@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/22/24 10:01 AM, Pavel Begunkov wrote:
> On 11/21/24 17:05, Jens Axboe wrote:
>> On 11/21/24 9:57 AM, Jens Axboe wrote:
>>> I did run a basic IRQ storage test as-is, and will compare that with the
>>> llist stuff we have now. Just in terms of overhead. It's not quite a
>>> networking test, but you do get the IRQ side and some burstiness in
>>> terms of completions that way too, at high rates. So should be roughly
>>> comparable.
>>
>> Perf looks comparable, it's about 60M IOPS. Some fluctuation with IRQ
> 
> 60M with iopoll? That one normally shouldn't use use task_work

Maybe that wasn't clear, but it's IRQ driven IO. Otherwise indeed
there'd be no task_work in use.

>> driven, so won't render an opinion on whether one is faster than the
>> other. What is visible though is that adding and running local task_work
>> drops from 2.39% to 2.02% using spinlock + io_wq_work_list over llist,
> 
> Do you summed it up with io_req_local_work_add()? Just sounds a bit
> weird since it's usually run off [soft]irq. I have doubts that part
> became faster. Running could be, especially with high QD and
> consistency of SSD. Btw, what QD was it? 32?

It may just trigger more in frequency in terms of profiling, since the
list reversal is done. Profiling isn't 100% exact.

>> and we entirely drop 2.2% of list reversing in the process.
> 
> We actually discussed it before but in some different patchset,
> perf is not helpful much here, the overhead and cache loading
> moves around a lot between functions.
> 
> I don't think we have a solid proof here, especially for networking
> workloads, which tend to hammer it more from more CPUs. Can we run
> some net benchmarks? Even better to do a good prod experiment.

Already in motion. I ran some here and didn't show any differences at
all, but task_work load was also fairly light. David is running the
networking side and we'll see what it says.

I don't particularly love list + lock for this, but at the end of the
day, the only real downside is the irq disabling nature of it.
Everything else is both simpler, and avoids the really annoying LIFO
nature of llist. I'd expect, all things being equal, that list + lock is
going to be ever so slightly slower. Both will bounce the list
cacheline, no difference in cost on that side. But when you add list
reversal to the mix, that's going to push it to being an overall win.

-- 
Jens Axboe

