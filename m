Return-Path: <io-uring+bounces-4925-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E889D4EB9
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:35:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BB1C1F212D0
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 14:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41C814A02;
	Thu, 21 Nov 2024 14:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wEa69jkH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488931D7E4C
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 14:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732199703; cv=none; b=e6VXZqORFbPbYuwoMF7NR0G3DWxt0MSM/vI2opCI5pCjBGS4TP2LOSUIkNZY/IIX7IspCwLSqQyhNqAPWAZ30HR0EuNyuBY0Xtvw6AYDFEFfJd2sz31aDX98Lb0N7MeheYcCrDl2ilLsZz4DSW6qy0QJOpSJK9SuRKSpH8U5cxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732199703; c=relaxed/simple;
	bh=GhGlCq/U3jIwGUbdGBZrrVYQN2Uq7xTjOK5vVXlobrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=l26kx3BC5cKOViUikvtqQPG6C/gP6Yy/L+7EIIeuTSDh9wGPTVpZvO+Oyj3FPHN+xfJA0ZnVOiPfFJawXFNdt6pwA39zCzCrcSQLqolUZmt/sd6AF1cqa3qHyH8+OwlzDihJh8XjU1LEK7bcOxI2qrroqtGUjc2yBIXxUZTAQKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wEa69jkH; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3e5fcf464ecso622433b6e.0
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 06:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732199699; x=1732804499; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b/lHA0tY9xvDEAvZZx3Psq/BnosxfVR3PYmnhOVgAn0=;
        b=wEa69jkHkOA8qY8AMrqawxIAH9wWE4cT2GevgCCdcqH8YeN5Hsbl5J0T5NyaWBo+Yd
         NwMzraFS3Jhyi7Pev8nt8p+XOCLS7zip5tnXwFCWI8EPnbdtPrMW9Pgiu0Q9vL+IMg0F
         nKN25Kupc7WtqEuykLeLEp0PoLuDAjtzHtPwtg1DTR7HFX6UGOqdgkLkZB9LsqWr5XJ+
         QuguWufdiHY/9OhgQc2JukPPPObuX9FjOejLRhu82iE1wIHwT6HAO2l2JsBBw0s0VX5B
         q9d68hyTa73nq2uy3aoDD8Lx6PmI8us7xXytbB1+8FSz7ZlHiBGMa6vO5ahDCHW5TzHF
         D03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732199699; x=1732804499;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b/lHA0tY9xvDEAvZZx3Psq/BnosxfVR3PYmnhOVgAn0=;
        b=Z3ZsAXWqP2mcBbAOsUpkOSSRgB7jxZrEj8If2DrRBFDCy2Hl+dvzmr/kI0jzOI5TJo
         0YVxMt7kEmhtEPakqv9V7sck3/70K/RwY2AJUo4Ruv3Eci/DCY7Z21R0CnyAIBtOJ9Il
         v7O92UD98UuUZbIyP30QlMv7gTgQXko/MC6pMnTkFveySoSV+Gtwckj+N/fV6MCQ0Dax
         UHHo6vwPQ14yzRTW3VHxc9ZQwPMSTwnKYhOQiY3w3Eu0IljgmZFNZpcCB2IVJxawRJTT
         AkbQi+L330HpBFMHtBL5Gtsb8m7rpgxO2OgO8MN/s/aOg6pDEz3EAYmAeb7+4o1qGIVu
         3dAw==
X-Forwarded-Encrypted: i=1; AJvYcCVG33kDbThW+3OBCmdCkSbAdNrZRe+ek3RaMWzM795yL/LaZvdYKxOKLi53k0BJx+UShgPQPElXSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzX0DadqB5wG0LdtWvHUZQm8b1PR9CkjaM51EQQYxg1ODmh1rJh
	m1skLpWzUEbmUi8DFDWqVxD/tZA/bCgMBjzZlawPK16/8yPpwKuwKQN1HXSG7jmo/3KzZBx1mlW
	dgNw=
X-Gm-Gg: ASbGnctRMdbg2en4l3+HRHbZQEK5LDQIev+NaTaW5C9A5AI0mmsFuQvc2oBnqULbh8V
	wcYfzHcrgfJHwPN5AVXFOnVTFqzxPtmmwYzoERxU0BVFsAuaADn+8MY0IvmS6a7dVwiL6QDl+7A
	z1n85lzNgZXNTGr5DTJdXTE61KrJUsy2pL8SuvR7jbmox/hU3SM3GKMDWoRqcWHLD/Y3mup6NOp
	ukIvVeBfuhO+JX8xVRuCm2/JBJhzMcKH/KZZO4EeA+qwg==
X-Google-Smtp-Source: AGHT+IFDwBOzu8cpXzBeHrnu4rY5ZmCyXGwsnX4vxGyDANC46YkjZTh/o/4qVXjZgtlh436iU/gqtA==
X-Received: by 2002:a05:6808:3c8c:b0:3e6:2956:9104 with SMTP id 5614622812f47-3e7eb7e51f2mr8491005b6e.35.1732199699316;
        Thu, 21 Nov 2024 06:34:59 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e7bcd2121dsm4700868b6e.23.2024.11.21.06.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 06:34:58 -0800 (PST)
Message-ID: <7e7243ae-db29-4a96-aece-d66897080a41@kernel.dk>
Date: Thu, 21 Nov 2024 07:34:57 -0700
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
 <4d71017c-8a88-40bb-a643-0efb92413d3d@davidwei.uk>
 <1d98f35c-d338-4852-ac8c-b5262c0020ac@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1d98f35c-d338-4852-ac8c-b5262c0020ac@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/24 7:29 AM, Pavel Begunkov wrote:
> On 11/21/24 00:52, David Wei wrote:
>> On 2024-11-20 15:56, Pavel Begunkov wrote:
>>> On 11/20/24 22:14, David Wei wrote:
> ...
>>> One thing that is not so nice is that now we have this handling and
>>> checks in the hot path, and __io_run_local_work_loop() most likely
>>> gets uninlined.
>>>
>>> I wonder, can we just requeue it via task_work again? We can even
>>> add a variant efficiently adding a list instead of a single entry,
>>> i.e. local_task_work_add(head, tail, ...);
>>
>> That was an early idea, but it means re-reversing the list and then
>> atomically adding each node back to work_llist concurrently with e.g.
>> io_req_local_work_add().
>>
>> Using a separate retry_llist means we don't need to concurrently add to
>> either retry_llist or work_llist.
>>
>>>
>>> I'm also curious what's the use case you've got that is hitting
>>> the problem?
>>>
>>
>> There is a Memcache-like workload that has load shedding based on the
>> time spent doing work. With epoll, the work of reading sockets and
>> processing a request is done by user, which can decide after some amount
>> of time to drop the remaining work if it takes too long. With io_uring,
>> the work of reading sockets is done eagerly inside of task work. If
>> there is a burst of work, then so much time is spent in task work
>> reading from sockets that, by the time control returns to user the
>> timeout has already elapsed.
> 
> Interesting, it also sounds like instead of an arbitrary 20 we
> might want the user to feed it to us. Might be easier to do it
> with the bpf toy not to carve another argument.

David and I did discuss that, and I was not in favor of having an extra
argument. We really just need some kind of limit to prevent it
over-running. Arguably that should always be min_events, which we
already have, but that kind of runs afoul of applications just doing
io_uring_wait_cqe() and hence asking for 1. That's why the hand wavy
number exists, which is really no different than other hand wavy numbers
we have to limit running of "something" - eg other kinds of retries.

Adding another argument to this just again doubles wait logic complexity
in terms of the API. If it's needed down the line for whatever reason,
then yeah we can certainly do it, probably via the wait regions. But
adding it to the generic wait path would be a mistake imho.

I also strongly suggest this is the last we'll ever hear of this, and
for that reason alone I don't think it's worth any kind of extra
arguments or added complexity.

-- 
Jens Axboe

