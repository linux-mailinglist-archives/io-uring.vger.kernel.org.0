Return-Path: <io-uring+bounces-492-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2BA684095B
	for <lists+io-uring@lfdr.de>; Mon, 29 Jan 2024 16:09:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9941328D992
	for <lists+io-uring@lfdr.de>; Mon, 29 Jan 2024 15:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54A281534F9;
	Mon, 29 Jan 2024 15:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f6185pWX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BBD1534E7;
	Mon, 29 Jan 2024 15:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706540985; cv=none; b=HYnMxEWFxpYM5lLqkCCKUJPBiet6ohN63lBHDpYc+AMOcxWcKWL2B1+8KyLLz9EeG5ZwcXSQe0zhNzFBkz1zoAlhks0s9f/10ZX2Rme3kEp2x8Y6vbm4BB4IEtuOGs2jVN8xJOIGRyL+JiQhqFszjLpIgy/AEjLNR22b0g1tdjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706540985; c=relaxed/simple;
	bh=zWjB4xu87yavbw/DFgkZQzWvTM81dFw7CJCcI9l5udI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R6D7lNSSR34u6bvRvJrL3n83wucAMMKwjlOXyhsrO8h9Xzef/00RoKv0TXajemn3BT8yePDi9qEobs+PdMoAJuMciX0+7D2oYtJ8BJAxkRiEFmlGbwR5o82fhNCv3VAfdDUthA7m9tK9AIURfyDbXL0nZIM6NYnjPGubkKCd06U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f6185pWX; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-40ef207c654so14068755e9.1;
        Mon, 29 Jan 2024 07:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706540982; x=1707145782; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DGb4uBVS7iO27T2jl05xw7OckCPf0XMpAqqhmH5aYcM=;
        b=f6185pWXfelS9wneaZa+Y0g6oRgydW9wEdDLINfO47hVKvYopp+vvL+RwRM894JNON
         PVsKUsTh8gQe/V5cwt6J8Ca3boMZ6tLVG6eJXliI7JoVqyoq+pQEvmJhjosEjdeHOj1h
         gTUXdBUx2hjRlbyPUjJJZYTbzEiMkGBNEyp6GJYuCBx44rnuuF25zPwMSIX2b7xBXV7Y
         pjPM5zyQ/j0otmV7OSuhXlbV13X4HxEG3QYHRzBlIztG0bAnO4QOC97oBF2TNxF2YhQt
         lmT6vIUXsLH4MvMUNmg+1qWTUjVOCKLyNgK039xCOLtmjZtYAj0VrUkQqBikuvXvihre
         RJcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706540982; x=1707145782;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DGb4uBVS7iO27T2jl05xw7OckCPf0XMpAqqhmH5aYcM=;
        b=w2h63IybGgA2Lt5U4OXOEpVTWGhpBWLmi8SJBBRk9VBjtuTmuxRq0SQen7z4BXD9+d
         Yr78+pK4HnaUfi1oXdLbLIGpb6FWhFFP+AzKL60KPorlZfBIslWhIuqB9yWIvURYyX2i
         3X0FqqmK6O9QWr9AM+T5EQTcaGu3XCDdZhbx+mRVrD9UrHDNDYmCmfP+KAo9Ir4tdhSR
         3d798Osk6XQK7zRP9Vpv343u5ZkApOnvARBu1kNVs+UQ37UuRZoVv9GeRsYF0qBg9YZw
         wBXs9ltyGECBFMnfvFJ6Bn+L48dzyVX/LsyCznBrm4jXzDUt6YKtb4ZrENzWijQmD80x
         zWoQ==
X-Gm-Message-State: AOJu0Ywa3dS/44BogEzVeuPZtgjooFjs/bkGngIIAEKWJWNy6hy9oUQU
	0TlLQ4C1gNqlWVJS+ORuJ5SpVTYXZQzqCmHSyCgsRoHyp2eQYRiZQwD/weQq
X-Google-Smtp-Source: AGHT+IFcamrjxuq3HqGypkGyDzGdXxUJSEOz9GB6g6Ua4UYEWk2no7i99kBIJSy4dYPm3Y3Q1/WEFg==
X-Received: by 2002:a05:600c:524c:b0:40e:f62b:eec0 with SMTP id fc12-20020a05600c524c00b0040ef62beec0mr3380324wmb.17.1706540981738;
        Mon, 29 Jan 2024 07:09:41 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWjWmmQNzjWVW5eT4XAC21v6nEVpgqFvBGMDvbUuOfuZVrG6B1c1TvPiBXDn6Ifi1q4Nn5SwczbN4YqZf5UqfdytJq/36oX9H2FiQMiDHFNYu7c2PNuJmFnfG8pxavMWRJrXSaw/VFIrdwuOan5t+DJfyVQoMutFKD2KfpkP1dm4ZSdrgpAzTVmELp+MdGEdEnRpCuj0pKK3rwD+Zp7Qn6jXqr+wiuNmGSSQDF/Q13o9MKwahuJ7qigtxpRi8G1pkcRks0cYu7FZwfNHqVfBeDxdM7C8z1jtG4sy7FyQ8pKZvcfJ8Tx
Received: from [192.168.8.100] ([148.252.128.211])
        by smtp.gmail.com with ESMTPSA id ck8-20020a5d5e88000000b003392986585esm8420500wrb.41.2024.01.29.07.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 07:09:41 -0800 (PST)
Message-ID: <3044a700-252c-4e87-a0cf-a1fec6e83f8f@gmail.com>
Date: Mon, 29 Jan 2024 15:01:43 +0000
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
To: Xiaobing Li <xiaobing.li@samsung.com>, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com
References: <8e104175-7388-4930-b6a2-405fb9143a2d@kernel.dk>
 <CGME20240129072655epcas5p35d140dba2234e1658b7aa40770b93314@epcas5p3.samsung.com>
 <20240129071844.317225-1-xiaobing.li@samsung.com>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240129071844.317225-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/29/24 07:18, Xiaobing Li wrote:
> On 1/18/24 19:34, Jens Axboe wrote:
>>> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>>> index 8df37e8c9149..c14c00240443 100644
>>> --- a/io_uring/sqpoll.h
>>> +++ b/io_uring/sqpoll.h
>>> @@ -16,6 +16,7 @@ struct io_sq_data {
>>>   	pid_t			task_pid;
>>>   	pid_t			task_tgid;
>>>   
>>> +	long long			work_time;
>>>   	unsigned long		state;
>>>   	struct completion	exited;
>>>   };
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

I wouldn't mind if it's fdinfo only for now, that can be changed later
if needed. I'm more concerned that reading fdinfo and then parsing it
is incompatible with the word performance, which you mentioned in the
context of using 1 vs 2 syscalls to get the stats.

That can be left to be resolved later, however. Let's just be clear
in docs that stats could be 0, which means the feature is not
working/disabled.

Another question I raised in my reply (v6 thread), why it's using
ktime_get(), which same as jiffies but more precise, instead of a
task time?


> If you think it is troublesome to obtain the PID,  then I can provide

I missed the context, where do we need to know PIDs?


>   a shell script to output the total_time and work_time of all sqpoll threads
>   to the terminal, so that we do not have to manually obtain the PID of each
>   thread (the script can be placed in tools/ include/io_uring).
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

-- 
Pavel Begunkov

