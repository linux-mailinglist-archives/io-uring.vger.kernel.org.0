Return-Path: <io-uring+bounces-6095-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F44BA1A67E
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 16:04:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D6D17A1B43
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C131620F994;
	Thu, 23 Jan 2025 15:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f32AY7pD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FFA20FAB7
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737644675; cv=none; b=sLyLS92XC5y9XUU3HPtMhTVQPhbINWyWJvNc9YVKH5mToCXw2gEqg4Vno+0zsmuH502TuyLr0LRxeCDI6fHDUvk9lN8AqLRhwTgQfFT6KHJtNILzoCKgTczXElW4RAGGL3vHoooLHW6fIIy+TR1TvESYQ3qh8pi3U9gUxEo/zvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737644675; c=relaxed/simple;
	bh=KcZfNumlMpeOvfAVwgX+TCKYZp+nB8+LE4iCBYZKe8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EI0hJNmxue2JvpQiXilMvF/vJnQGK6LCUIf/jLxVItm5x9wPqJ6vLg/72OW0EoNczqDXB3RAole1sBrZh4EmQ6eyUFwh9x6OWg0Wx+euaTmZfrUJlUP+zsqC1u/a7RoL1LEIjWGzkZg78hB7FHBWkIW09JSYgjfOLZQitChoIjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f32AY7pD; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ab643063598so157790766b.2
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 07:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737644672; x=1738249472; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LHpc51u0EBf2yDgjENbWSsMVeIIonqHq353kkjUinuc=;
        b=f32AY7pD8LrUvdhkSMDCIFKHjYJcOdVBw+LzvgFixTXFbgVZAsQro65eMs8Tg8dnDU
         fSDhEy7s8trGZknfmv1X1RO+mirQ8IrqAHgDZaA1ekVPwR/JAClTWcB5FDdeTKIA3mX6
         BqdFl1m0t9AviEkMvI10g0zLsmzORPhs+DJyrcfXTy5z9nTK+Y2ZHcbkL7gzsXFLEQBq
         vW1qmjVkJcT4j6AZ+oGoXoMeEIqrAVPXDxO63HJRdGs0yIobHl9sEvqG+C1+Go0uk8P3
         6N621eIHELMBj6APo6XDOvlZwUSh29cn01UdE99ZYsS1qT8kE5oQITuSC5QuG32Bm9YK
         TeRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737644672; x=1738249472;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LHpc51u0EBf2yDgjENbWSsMVeIIonqHq353kkjUinuc=;
        b=mcaUXIFCG1zjyyqeznY72BdHrwQnX5bt9+7sYqMUOZU65uwvL1jQrM/YmdR2Ze6o7E
         pMxuQ+axtKuXTanxor3N3YiL4QpU4JWvSqoMTjAeiqlLKEmkaDKBEszzkx5ji9cByvni
         EyvrpALTlFwykGpuLnn/RMsUEUComUes2dHlzu8t4eDYP94p6/POI2ssUN9ekbfbwpPI
         dWMAEQulawchpKnH1bnSbuIp2dTi+5DicWJRlom/BZP82JmZyrGPmfweSjUBguSUtaDS
         i/kDlU1/R4gVPvNH+lxu29sKUiGz6uwW+ZVSZtnHLMK2/QPvX+ZB/kKgT0gnzrrL1rBG
         Y38w==
X-Forwarded-Encrypted: i=1; AJvYcCVe9K2qj3tU8yVR+pCTHp6kqRGhkSjlAFSOS3AEbehmpqscQj0vjBQreWjLKk0Bi/ga6A6vfynSJQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxwDAws9y/NafoSZ9zZOhbzaciUC/Ja6+oOEp0sm/TC4Fmw9whl
	Xf5aYy/zZCAWP5X7sDCXBNNa6IcWigHWrD1C3b7afUR8gOBCMhtDZt8mlw==
X-Gm-Gg: ASbGncuRZiIjlMELKDzmsvmD8IMvFADOJw0WE5BOkws01Xu1twg9L4dJMtFXA4j7BB0
	sqHq68b2JevdpYusZvrRWwsjZkBiVlZNBU/QYeF4ym9U89u/3rCI3SLDPLOtLjwEEpnzEa+e8a8
	ft8KsutaOhAPw+0XfHo1IIw/e0+3HEGzA7TcReB4oBZFRaP2aUQ2q4uoAeIPAvtL1MEJ/kbUBzu
	SGsxmk2RaDGhabyhLCr+fgoiK3SQZArKCGHN0hIKcCihzwVuv/iTlZeHd8WdXGLvKb5d4oqx5dY
	NQi8OT2RiCpIcHUvYd2nelsLYtBJdQtcoqn5hA==
X-Google-Smtp-Source: AGHT+IFr7A/aVGCIUcI1UUXj1s4OIp8IrE1ytpEmuwyNvLtTitauFMcna1H4yHMv6AKlxHzgYWr21w==
X-Received: by 2002:a05:6402:4313:b0:5db:f5e9:6760 with SMTP id 4fb4d7f45d1cf-5dbf5e96a10mr16216965a12.2.1737644671665;
        Thu, 23 Jan 2025 07:04:31 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:7d36])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc124ac16dsm551927a12.56.2025.01.23.07.04.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 07:04:31 -0800 (PST)
Message-ID: <c779efa7-e5c2-4ab9-a851-fadad19c167d@gmail.com>
Date: Thu, 23 Jan 2025 15:05:04 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: get rid of alloc cache init_once handling
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: krisman@suse.de
References: <20250123142301.409846-1-axboe@kernel.dk>
 <20250123142301.409846-3-axboe@kernel.dk>
 <cebeb4b6-0604-43cb-b916-e03ee79cf713@gmail.com>
 <f3c9c1bf-4356-4cb7-9fd1-980444db83a6@gmail.com>
 <c8e4efdb-4f41-41a5-8470-14afb963c9e4@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c8e4efdb-4f41-41a5-8470-14afb963c9e4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/25 14:55, Jens Axboe wrote:
> On 1/23/25 7:47 AM, Pavel Begunkov wrote:
>> On 1/23/25 14:27, Pavel Begunkov wrote:
>>> On 1/23/25 14:21, Jens Axboe wrote:
>>>> init_once is called when an object doesn't come from the cache, and
>>>> hence needs initial clearing of certain members. While the whole
>>>> struct could get cleared by memset() in that case, a few of the cache
>>>> members are large enough that this may cause unnecessary overhead if
>>>> the caches used aren't large enough to satisfy the workload. For those
>>>> cases, some churn of kmalloc+kfree is to be expected.
>>>>
>>>> Ensure that the 3 users that need clearing put the members they need
>>>> cleared at the start of the struct, and place an empty placeholder
>>>> 'init' member so that the cache initialization knows how much to
>>>> clear.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>    include/linux/io_uring/cmd.h   |  3 ++-
>>>>    include/linux/io_uring_types.h |  3 ++-
>>>>    io_uring/alloc_cache.h         | 30 +++++++++++++++++++++---------
>>>>    io_uring/futex.c               |  4 ++--
>>>>    io_uring/io_uring.c            | 13 ++++++++-----
>>>>    io_uring/io_uring.h            |  5 ++---
>>>>    io_uring/net.c                 | 11 +----------
>>>>    io_uring/net.h                 |  7 +++++--
>>>>    io_uring/poll.c                |  2 +-
>>>>    io_uring/rw.c                  | 10 +---------
>>>>    io_uring/rw.h                  |  5 ++++-
>>>>    io_uring/uring_cmd.c           | 10 +---------
>>>>    12 files changed, 50 insertions(+), 53 deletions(-)
>>>>
>>>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>>>> index a3ce553413de..8d7746d9fd23 100644
>>>> --- a/include/linux/io_uring/cmd.h
>>>> +++ b/include/linux/io_uring/cmd.h
>>>> @@ -19,8 +19,9 @@ struct io_uring_cmd {
>>>>    };
>>>>    struct io_uring_cmd_data {
>>>> -    struct io_uring_sqe    sqes[2];
>>>>        void            *op_data;
>>>> +    int            init[0];
>>>
>>> What do you think about using struct_group instead?
>>
>> And why do we care not clearing it all on initial alloc? If that's
>> because of kasan, we can disable it until ("kasan, mempool: don't
>> store free stacktrace in io_alloc_cache objects") lands.
> 
> Not sure I follow - on initial alloc they do need clearing, that's when
> they need clearing. If they are coming from the cache, the state should
> be consistent.

If we forget about kasan, ->init_clear is only really used right
after allocation().

+	obj = kmalloc(cache->elem_size, gfp);
+	if (obj && cache->init_clear)
+		memset(obj, 0, cache->init_clear);

Why not kzalloc() it?

-- 
Pavel Begunkov


