Return-Path: <io-uring+bounces-1948-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1362A8CB448
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 21:32:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 442941C234A5
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 19:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A154B1DFE8;
	Tue, 21 May 2024 19:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="i+8snbxG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1567F148FE2
	for <io-uring@vger.kernel.org>; Tue, 21 May 2024 19:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716319967; cv=none; b=UwPNGRQaocR07OwNSxETgaoGtxCI0xOnSOLpUQd3N/HtevbJPOwHi1F/4ebfCcNOc9/VqcucF8P1vCz+SCQSeSRzfRxdcYMT9y65HaBFWIac73IC9WGMm5Wxcyr+vvFDzxCtGvZXgzuyT8XZofYWAzpkrP4j71TL3nS1fj7IjvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716319967; c=relaxed/simple;
	bh=D/VHu7kx71sDpMTRhMP9yDWsN/tWB8PlzoH6I+ET40A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TMjG04TxZ+Geh54oFXnuPUF4fPeTRdCXWbetgeN3h9AfRQtbY+DkAC3DA7+UKcV2tI2pHGV/T8IECFZxpSyqsNnhSjDq9KlGbKSkr7UvMGbOAkXctT+m9H08HHpOKjISVPt5T7yGCWAJIqZmVNCHuRdhbjCD/jrQyvVWKOy4j30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=i+8snbxG; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-36c31c23ab6so1411615ab.0
        for <io-uring@vger.kernel.org>; Tue, 21 May 2024 12:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716319964; x=1716924764; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=evgLX76dSsYFNFDmlUKN2rF7iLSPrgjgS6ECYRNIJr4=;
        b=i+8snbxGxC+U3vBbI77r4141LrFzlOgKE2khVoTzNSvswFyha2o38JbIOP9XVV2+YT
         arF8i2d4taR7NruvaFC4xCp0VoCy8Oy3I/HRmu5PtNZBjR0TgaRAHCQXr8FxYnueCVIB
         bv3MhcNLh+x0a+tikHe7xNIP6WIPzKlptq1TzoIvLb4tTX9ln0oOIxJn8HsALeL5uwKv
         9v5NttxluZS6DZErQB4ryc134bFFKo5eWRp8NRp5lOxC8j3aXy7M8OJzJPrJDjRb7eJh
         1f/N+ewDz2imIClzWmXH0jeZXDUE2cooYDFMLL827guX7VSlbJRJHXSV4AC9W/YVfx7A
         ndcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716319964; x=1716924764;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=evgLX76dSsYFNFDmlUKN2rF7iLSPrgjgS6ECYRNIJr4=;
        b=jrzW61fmkcXOt4EDcmWO4oqdESrom++VA0wS+Of22ponbJ/UAO8GTjwR8O9ZsC4Hhx
         19ukCGkf+L3Jta8qSADsWqyHxELjpzUBDcdNfquQmfrGoSQPqLjGjLuQUO6nTv55nyER
         qBXGd97OdORARneaY3khspJbZSjMUU46qHfx8+46ALuJAMyIgr1bIj6cO8swQe6QS6HP
         XwUecd8eB8nIUGLfrw7BVaDD3AaafTxxOzFqRderXAySgMrQ+gYhKdr2AO1a39yzyoJl
         CZcwU9ibCBvArZ2G5xujPvgpAwcHJlOJ9D9DXTa+q5ZCvimOvFEoipgFBTfGsLh932h+
         e1Tg==
X-Forwarded-Encrypted: i=1; AJvYcCURBHULRRyf7oEbdds2N+6VXr6487G4q+T1D4gXBaD8HQwydT/8MqzA+IZ1+VjmhGKKqzAxYpvk+rDd40PJcUuqCFoKjaE4FCo=
X-Gm-Message-State: AOJu0Yy9r2Q4kDIUx7sx2PMhN0rBkLVQFWTalSk7zLkya+IBXytaRjyS
	ragLuvfI+fZ5DXbaBDXZe2IqDwHpMksbim15IhkCvMPI86dX0Px2V4h4Iv0/3MgxShcvXuMRpjO
	0
X-Google-Smtp-Source: AGHT+IHuArI40gSH5aKyn8S6mXad9veMsLHXc/jnFYqt01HuYx4sfgEeeo3XLnBT5qXlouZYT3OZYA==
X-Received: by 2002:a5d:84ca:0:b0:7de:f48e:36c3 with SMTP id ca18e2360f4ac-7e360c17344mr248039f.0.1716319964176;
        Tue, 21 May 2024 12:32:44 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e1e412dcd1sm494088039f.18.2024.05.21.12.32.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 12:32:43 -0700 (PDT)
Message-ID: <2b810757-4aeb-43c6-b92c-d8ffb7c34c64@kernel.dk>
Date: Tue, 21 May 2024 13:32:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ETXTBSY when running Yarn (Node) since af5d68f
To: Andrew Udvare <audvare@gmail.com>, Christian Heusel <christian@heusel.eu>
Cc: regressions@lists.linux.dev, io-uring <io-uring@vger.kernel.org>
References: <313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com>
 <8979ae0b-c443-4b45-8210-6394471dddd1@kernel.dk>
 <8de221f7-fe5a-4da9-899e-de2a856a4ddc@kernel.dk>
 <yywbp7fjnwgqxvc66zimea4hgdc2eysjx5nezky3vndr7xw25l@jv76rdseqm3e>
 <b8018270-6e9a-4888-87fd-69620d62c4e5@kernel.dk>
 <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>
 <5a1649cb-2711-4767-8313-0f6bfe0e4cd7@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5a1649cb-2711-4767-8313-0f6bfe0e4cd7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/24 1:30 PM, Andrew Udvare wrote:
> On 21/05/2024 14:29, Jens Axboe wrote:
>> On 5/21/24 12:25 PM, Jens Axboe wrote:
>>> Outside of that, only other thing I can think of is that the final
>>> close would be punted to task_work by fput(), which means there's also
>>> a dependency on the task having run its kernel task_work before it's
>>> fully closed.
>>
>> Yep I think that's it, the below should fix it.
>>
>>
>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>> index 554c7212aa46..68a3e3290411 100644
>> --- a/io_uring/sqpoll.c
>> +++ b/io_uring/sqpoll.c
>> @@ -241,6 +241,8 @@ static unsigned int io_sq_tw(struct llist_node **retry_list, int max_entries)
>>               return count;
>>           max_entries -= count;
>>       }
>> +    if (task_work_pending(current))
>> +        task_work_run();
>>         *retry_list = tctx_task_work_run(tctx, max_entries, &count);
>>       return count;
>>
> 
> This patch works for me on 6.9.1.
> 
>  $ yarn
> yarn install v1.22.22
> warning package.json: "test" is also the name of a node core module
> info No lockfile found.
> warning test@1.0.0: "test" is also the name of a node core module
> [1/4] Resolving packages...
> [2/4] Fetching packages...
> [3/4] Linking dependencies...
> [4/4] Building fresh packages...
> success Saved lockfile.
> Done in 3.32s.
> 
>  $ uname -a
> Linux limelight 6.9.1-gentoo-limelight #2 SMP PREEMPT_DYNAMIC TKG Tue May 21 15:21:33 EDT 2024

Great, thank you for testing!

-- 
Jens Axboe


