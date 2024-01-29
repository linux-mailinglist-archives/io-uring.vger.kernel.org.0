Return-Path: <io-uring+bounces-491-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87EA98407BC
	for <lists+io-uring@lfdr.de>; Mon, 29 Jan 2024 15:00:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42D0528156F
	for <lists+io-uring@lfdr.de>; Mon, 29 Jan 2024 14:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D4F7657B5;
	Mon, 29 Jan 2024 14:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QAESJruz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C86F657BD
	for <io-uring@vger.kernel.org>; Mon, 29 Jan 2024 14:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706536845; cv=none; b=H3Y7gwXFjbwhUIy24OfxGwW79DLuBEpjWOHAXoFajybHS7Jpp4Tr36kRbqGjNW0zQHNvFlfQSIvIBFHpyP4tOX78w6T/B/h2zEC2x9VtcNxBGjFK0x22/wqSK6Vm0DzzrHelcVzVTSpCQPwtRVB1cKAaBi/3tK4YEH03ZXl0kv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706536845; c=relaxed/simple;
	bh=SQ04STe/aYVjnCBxYeWBjsaMc9GpyngM0NMmL+Lhc24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BL9lFQdyJxol+yORN/JROznEa1mRigKjkZzbqKwAg4rIWA/mYrs9xsql/4tGNoKOBBhLQMYe8yiJC1Hna85LfAyxJ3Uxnf9NbYcLo6Sy/tM7te6jgEIkB5e4yWMS8JzZDhIysgQksNF3Nx1+Va+U9Vk8NhaBE8Jj4eFPYxQr6U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QAESJruz; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d8e374f167so894085ad.1
        for <io-uring@vger.kernel.org>; Mon, 29 Jan 2024 06:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706536842; x=1707141642; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DPwleXPZEicef5bpuduhRFgNi3FvwGm9SY6PNmOkghM=;
        b=QAESJruzc6Ul4WUtsezjJyP37fftVpXQHOkS9mGGLZZx67mL+MEPNTczo4sGps516S
         JTIoE81Ia8PQOqLsn5mlMxbiUGSwWeKspn3z64LUerA4UHfpMFL+FfhJbjwWLqUIgdml
         lVP2LnrO29rjetqfQHayzU4VttDssIJ6lYKKyFAGZZwH1PTRdQfLbZYDOgo5KPHjJ/I+
         4IBxKSlfZJFVBTZz7EeAuYY242xbqhJSWKpzbJN7G/cuWTKl/MM4cZwgzynFtaUvCPw1
         O6PW0Mk7zjNyYwAw7cLtSXGtE6nXMO/HCmmRCF+D1qatJGDVz3rqSHGqSzSr7+OIOhJx
         Hpqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706536842; x=1707141642;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DPwleXPZEicef5bpuduhRFgNi3FvwGm9SY6PNmOkghM=;
        b=XSa74WMbY2CH65KlAFZOkJhNc3YHNNYg2hCDILL7Hy64tqXDaPn6xqQFFlGnYXh34/
         tFwJPJa7ektgxxUsEfNyXqh6HQCo5J/FUNqA9IvOdxIEs3ucnT5e2AbUqzbLTZ1wGkfl
         UW3sKcByCVUUksMhQ3Hk0+ksgy4m0Y7jtJGSsf8qLDSP5z7LGVV9ud4ObKpDr0z8FU6U
         rNDAnZMx7Wm3UsY7ppoaUH4zDpAOw2SW/9maM/2oyV1ho5PugZXsNUnsGysWfWa7KcEf
         ogjvFkeWW8O0mFfDYQ4y+Cv2wdtH4cozZ8a4uFT3qqEqeETsYhHE7o5iqq59vIap4cU5
         0r8A==
X-Forwarded-Encrypted: i=0; AJvYcCXB5UzudyIwynVFfytcsCpScJ70cr0Mw7qf76eIUV3zmuFo8mXtHKYSr0D7XeCcvaK5KLHFYgEcf+fi0/sNwuXFGdSTVn3MMJI=
X-Gm-Message-State: AOJu0YzA6RUrOdR4QV4TNSGVbIOqSambyrgTorlI9D4mhWuC7D+ydhs6
	F2WwoHFyUiZ6UaY3rnz/sVjS9dHaL3Qoyw+bju5UPF6U5bpP3e89rvzMWSaSMlk=
X-Google-Smtp-Source: AGHT+IGECYKLe+3ih3dbmJmXhd+Ud4nfFuMaOsev360L1iI0PLRcAM13Jno4R0i5Y1dRZV0aqbpz2Q==
X-Received: by 2002:a17:903:32c5:b0:1d3:e503:5b55 with SMTP id i5-20020a17090332c500b001d3e5035b55mr8368129plr.2.1706536841622;
        Mon, 29 Jan 2024 06:00:41 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id x5-20020a1709029a4500b001d5d736d1b2sm5354692plv.261.2024.01.29.06.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 06:00:41 -0800 (PST)
Message-ID: <e2a84850-95a3-48a8-b4ce-e5b005fbf186@kernel.dk>
Date: Mon, 29 Jan 2024 07:00:39 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] io_uring: Statistics of the true utilization of sq
 threads.
Content-Language: en-US
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
 joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
 ruyi.zhang@samsung.com
References: <8e104175-7388-4930-b6a2-405fb9143a2d@kernel.dk>
 <CGME20240129072655epcas5p35d140dba2234e1658b7aa40770b93314@epcas5p3.samsung.com>
 <20240129071844.317225-1-xiaobing.li@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240129071844.317225-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/29/24 12:18 AM, Xiaobing Li wrote:
> On 1/18/24 19:34, Jens Axboe wrote:
>>> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>>> index 8df37e8c9149..c14c00240443 100644
>>> --- a/io_uring/sqpoll.h
>>> +++ b/io_uring/sqpoll.h
>>> @@ -16,6 +16,7 @@ struct io_sq_data {
>>>  	pid_t			task_pid;
>>>  	pid_t			task_tgid;
>>>  
>>> +	long long			work_time;
>>>  	unsigned long		state;
>>>  	struct completion	exited;
>>>  };
>>
>> Probably just make that an u64.
>>
>> As Pavel mentioned, I think we really need to consider if fdinfo is the
>> appropriate API for this. It's fine if you're running stuff directly and
>> you're just curious, but it's a very cumbersome API in general as you
>> need to know the pid of the task holding the ring, the fd of the ring,
>> and then you can get it as a textual description. If this is something
>> that is deemed useful, would it not make more sense to make it
>> programatically available in addition, or even exclusively?
> 
> Hi, Jens and Pavel
> sorry for the late reply.
> 
> I've tried some other methods, but overall, I haven't found a more suitable 
> method than fdinfo.
> If you think it is troublesome to obtain the PID,  then I can provide
>  a shell script to output the total_time and work_time of all sqpoll threads 
>  to the terminal, so that we do not have to manually obtain the PID of each 
>  thread (the script can be placed in tools/ include/io_uring).
> 
> eg:
> 
> PID    WorkTime(us)   TotalTime(us)   COMMAND
> 9330   1106578        2215321         iou-sqp-9329
> 9454   1510658        1715321         iou-sqp-9453
> 9478   165785         223219          iou-sqp-9477
> 9587   106578         153217          iou-sqp-9586
> 
> What do you think of this solution?

I don't think it's a great interface, but at the same time, I don't feel
that strongly about it and perhaps bundling a script that outputs the
above in liburing would be Good Enough. I'm a bit reluctant to add a
stats API via io_uring_register() just for this.

So maybe spin a v8 with the s/long long/u64 change and include your
script as well?

-- 
Jens Axboe


