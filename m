Return-Path: <io-uring+bounces-1006-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CB9487D81C
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 03:55:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27B8A2824A7
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 02:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 159A21C36;
	Sat, 16 Mar 2024 02:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LjBU9i/2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A6D393;
	Sat, 16 Mar 2024 02:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710557734; cv=none; b=os8pqdZKD7mvxkMaP9D5vz6CDj94mH5nv1m5kK7fBNUUrAllErPg6v5Cf+bK4kyWJWRrCTcIkpvyoLGJ44YalN0DhJ8H5t3353md4lXpB5bf03JJd6NhQbuRYuVH0R+Y/1ppaysRiWi2h7pyj8gMVRkOKPMI/c1ccpT0dve8Yys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710557734; c=relaxed/simple;
	bh=/ncSNOISJXYLMQBt907owyxgmUI5ot+qzXLFZYSWwHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=io8/FGJBrvAZ2qdQWxr/yZGMghRX6zXG8mPw06+r0n+rVYE242CiiIDLXMvlpQJtJEuG1XbKBtoDNeXrqJNHTSgrx+H/77/3ZiZ67v8Z+T5CEazdPexZB4uXS+71x/O7FxO3+E397420nxD7GtU+JIKt8b9JkHNF6FTRLRhlJ4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LjBU9i/2; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-33ed7ba1a42so339171f8f.2;
        Fri, 15 Mar 2024 19:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710557731; x=1711162531; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bBeJQdj8sVU38HiwxRAqBNideRlWYRjrGmK9XL6SCio=;
        b=LjBU9i/2ZHV6+ttimTiPTpBVTlPy6Bu96ks9IhHxl3hNoodRmWfe5crN7AlyCovozv
         WQSyWXcrCoGfYn4OMAPIIfiqaswegTW/aUIC6eFMllOWMDtueXVfYRhM5yEkR4iqlfuo
         2lV43eJcby/Op/cpAsVtXGgqqPtc5Rp2lAp8HSORUKxwLJGrzA1oyYWXzSl1quhcSGWh
         woGD6s84XweSqO6jLPFcREjAzLI8aDH3+SkXL2brQWlp7cR4tdR+BaIPpWmq/VZHQGt9
         bLxfv4be1Xj7CFpDG4AUZm29ADHNI/8T9mtpJG1B8ova4fRCQJzRlnRT/Q7i8fPbCQtP
         YCRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710557731; x=1711162531;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bBeJQdj8sVU38HiwxRAqBNideRlWYRjrGmK9XL6SCio=;
        b=eNEpQNGrT/DiDNInIWS6Bs3d4icKpPCwcxlqdYyu2MyrsSN7JrrW1Yl9w3Rud9xbeT
         GVyjxylqVbo1mmjuq467f5knUtx2aiAXNDYuyQoFTre2VCunkIukmWAyfuXrc2Pgzcbg
         NtIjY5vlq/UFvin3alHM1t39o9Yjx5i2SaYMVXYNvpC3qj0k9B3R1hrKfmWXKCXKkS0o
         e+TVCcmymO2ywfRYRIWRML28F6NT+kI7lNXzdKGlmyVOTOJWsMslUUoT1Xpe4jcMHxq3
         9UG36YHpC+/QY1sLv2YBdm8YqywEca6x0EFDLDAwRRQhNyg1EhjBek5gMF/J9Kj6CzVp
         gPNg==
X-Forwarded-Encrypted: i=1; AJvYcCX4ChsQh5myCeWPBHMyYIQF+RZb5VgNqUhYELrbpuMIIVqQrcF7bburnClK4fuKRdw66kA9Ti2dP7FRjtYPaax5ha78qpZzcsicnIU=
X-Gm-Message-State: AOJu0YzdS8gep+3y3HAnVLSEEwDyKwcXuW9ZtlOG+CKh8rwDnwIgwXmF
	G27JgoFOuycMkXHBoiAQAQZD6jZgz/FINJ8JOefeXAmdxiRHNzW3nthLivlG
X-Google-Smtp-Source: AGHT+IFL6G1jd0obgRCT6FHpfvsSchERX99ZLCMGeAxeC5I+xnE7tN5CnfRi2uequnzyHdfCHg12dA==
X-Received: by 2002:a5d:5910:0:b0:33e:ce0f:5c79 with SMTP id v16-20020a5d5910000000b0033ece0f5c79mr4125247wrd.9.1710557730302;
        Fri, 15 Mar 2024 19:55:30 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id n16-20020adffe10000000b0033de2f2a88dsm4366159wrr.103.2024.03.15.19.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 19:55:30 -0700 (PDT)
Message-ID: <6dcd9e5d-f5c7-4c05-aa48-1fab7b0072ea@gmail.com>
Date: Sat, 16 Mar 2024 02:54:19 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
 <ZfT+CDCl+07rlRIp@fedora>
 <CAFj5m9LXFxaeVyWgPGMiJLaueXkpcLz=506Bp_mhpjKU59eEnw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAFj5m9LXFxaeVyWgPGMiJLaueXkpcLz=506Bp_mhpjKU59eEnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/16/24 02:24, Ming Lei wrote:
> On Sat, Mar 16, 2024 at 10:04 AM Ming Lei <ming.lei@redhat.com> wrote:
>>
>> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
>>>
>>> On Fri, 15 Mar 2024 15:29:50 +0000, Pavel Begunkov wrote:
>>>> Patch 1 is a fix.
>>>>
>>>> Patches 2-7 are cleanups mainly dealing with issue_flags conversions,
>>>> misundertsandings of the flags and of the tw state. It'd be great to have
>>>> even without even w/o the rest.
>>>>
>>>> 8-11 mandate ctx locking for task_work and finally removes the CQE
>>>> caches, instead we post directly into the CQ. Note that the cache is
>>>> used by multishot auxiliary completions.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>
>> Hi Jens and Pavel,
>>
>> Looks this patch causes hang when running './check ublk/002' in blktests.
> 
> Not take close look, and  I guess it hangs in
> 
> io_uring_cmd_del_cancelable() -> io_ring_submit_lock

Thanks, the trace doesn't completely explains it, but my blind spot
was io_uring_cmd_done() potentially grabbing the mutex. They're
supposed to be irq safe mimicking io_req_task_work_add(), that's how
nvme passthrough uses it as well (but at least it doesn't need the
cancellation bits).

One option is to replace it with a spinlock, the other is to delay
the io_uring_cmd_del_cancelable() call to the task_work callback.
The latter would be cleaner and more preferable, but I'm lacking
context to tell if that would be correct. Ming, what do you think?


-- 
Pavel Begunkov

