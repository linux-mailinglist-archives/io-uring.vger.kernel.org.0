Return-Path: <io-uring+bounces-4974-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71C339D61A8
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 16:57:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 323F52831E1
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 15:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03A8D1D5164;
	Fri, 22 Nov 2024 15:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T424dOsA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED2513CA81
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 15:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732291021; cv=none; b=CQrDWykCcD6A/MhAhtFO6rL/Df9qHvRouX0kSnpG9cHd7C5aIalhmggSiM8bfVdqzLlDBe2HG5u60XTsBOecUsWyAyeKKAbjXOCghIFBQ51hxcr4WWCc1mLeAzr2aMhHffVh9FQypNt6USwopoUU2gHcf2CxrvsOVC+fZLXLKDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732291021; c=relaxed/simple;
	bh=LQlCVcq5O4NlthMRuLbmFQDxjBZ60rIX0g/P2ZmFVUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AxA50ikuFC68qyd4aBWiJ1kwhG7/KPYj0C0aLLLyRrS3iKRaECkXdC/eW8zk41Uwi/hiv0572D0CuKH9if0EF2lpiIyxkujKqHgxrC03eR0LSlbUMFENRV7SA2w/+dwLd8AZ2O0AMtU93MriGUDLMFHRppwpW+GOs6BTsWeRXVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T424dOsA; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a9f1c590ecdso387265666b.1
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 07:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732291018; x=1732895818; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WiDFzOg3dgWV03/czVpYBr83+oBvJro7qfqw5cSafwI=;
        b=T424dOsASyMmyfv3dKyCued5jQmlTvoK41YebwMx5APkDn4A6DfjAV+loZj35yt8LV
         NFA+6NFZvBm2hd8zxLsr5VFb7VPzV+DNisjI9/jjntE36HfpACgnEvV4M+gHc/gnyH1J
         ggW0vL3XHpXrltbF4QW/QJk+Q7XeYuXvRyOJQDMCToJ4p60rp7z7pAT5fgnEptmKpz2S
         eAGenLW0sw2zNpnCS97P83CHi9jbluqzj4ldFFeaZXJbaUKrqs5Ep8jhsw/0ElikFZWs
         RFoYJpLatSshnYvZfuFHjmeIM93azS26Gz4pXOIzOk7N5GkvGLrozQl/gFNT+zxZC9GF
         woow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732291018; x=1732895818;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WiDFzOg3dgWV03/czVpYBr83+oBvJro7qfqw5cSafwI=;
        b=wSGDNmJUZ/I/sLNw9iIHiBLaN0BGSV9CBQIv2LgquqWFWexPid1Ia0Y+IT53GYLL7B
         k8zZl9dBkoXvWDvuOV0LvZw8BoMrRx0t7Az86mtbtH5vcNC5ySejCNZBOegm9VngZX7G
         H8bKv9bsk1CGqqj+3Hll7T9S6LkJT/Nx3TF+2E20vVIyiNY2FTrMS8T0e1aZX2V25a5t
         epWQ3xb5/6KWEPUYntwHRdAg5oJug3fAmwdyKa2ZkHvWd6rh/3aCTu7HdbNW0eohJavZ
         5L3vKo9A6CSVrNwTojbVdDHj8BUeRoWpum6GXVuNzkz8SbN1wMrZ9BnOTUmxJkmbC4Ed
         jYxA==
X-Forwarded-Encrypted: i=1; AJvYcCUVhCJHqPPCCRoD1ZOuO8YMkQfe9QDgK345ClG7+HRTdWVnspUgHBZY6EY5IOJeFxDRpAYZpICV2A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzPCY9w8opiXHEyL3ktJY9/I47TNwPtydffTn3Quc68JsJa0f77
	mu/NfBwcQF9UPKjsbd/jbR3B6FRrmANBnvpp+e6dfCGKW2elQCLHVNV4Fw==
X-Gm-Gg: ASbGnctDj3PP1gIIoUSJmMxNwkojsYYNzRiPM6ezs+++UVRIIK3h3OCVVX0lq3TVMfk
	NMVlprZFW4MMH/CxmvvZLt14RR42fZD4V9hqbzz/CI6YGKnCPzND+Zja/u+uVBlJPeAR1dhcgsh
	WHUXSuqD/itlfsF0p6FFNxEAmmWIrJGEJ7PE9MIHT18veBI+EesKEAYQUPFuzXaunthM8Azde1q
	TZbdcNfNWbne2W8RX6D2k+rvcOpTGup3uKJFiG4cSAnZqHs/1sozL2bBik=
X-Google-Smtp-Source: AGHT+IFHp3ANywv9NZ0W+i4Gfy+B0OhWDx4ptxYPyFGoafiuqDJsmvI8mo7DRjNlkd902UCLg91BKA==
X-Received: by 2002:a17:907:82a8:b0:a99:f6ee:1ee3 with SMTP id a640c23a62f3a-aa509d21918mr256074266b.43.1732291018328;
        Fri, 22 Nov 2024 07:56:58 -0800 (PST)
Received: from [192.168.42.9] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa50b52fb96sm114037166b.131.2024.11.22.07.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 07:56:57 -0800 (PST)
Message-ID: <677f07d2-213f-4c63-9379-385d282aa4f3@gmail.com>
Date: Fri, 22 Nov 2024 15:57:52 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: David Wei <dw@davidwei.uk>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <95470d11-c791-4b00-be95-45c2573c6b86@kernel.dk>
 <614ce5a4-d289-4c3a-be5b-236769566557@gmail.com>
 <b7170b8e-9346-465b-be60-402c8f125e54@kernel.dk>
 <66fa0bfd-13aa-4608-a390-17ea5f333940@gmail.com>
 <8dfe2a9b-52f8-4206-a670-ecede76ab637@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8dfe2a9b-52f8-4206-a670-ecede76ab637@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/21/24 17:53, David Wei wrote:
> On 2024-11-21 07:07, Pavel Begunkov wrote:
>> On 11/21/24 14:31, Jens Axboe wrote:
>>> On 11/21/24 7:25 AM, Pavel Begunkov wrote:
>>>> On 11/21/24 01:12, Jens Axboe wrote:
>>>>> On 11/20/24 4:56 PM, Pavel Begunkov wrote:
>>>>>> On 11/20/24 22:14, David Wei wrote:
>> ...
>>>>> I think that can only work if we change work_llist to be a regular list
>>>>> with regular locking. Otherwise it's a bit of a mess with the list being
>>>>
>>>> Dylan once measured the overhead of locks vs atomics in this
>>>> path for some artificial case, we can pull the numbers up.
>>>
>>> I did it more recently if you'll remember, actually posted a patch I
>>> think a few months ago changing it to that. But even that approach adds
>>
>> Right, and it's be a separate topic from this set.
>>
>>> extra overhead, if you want to add it to the same list as now you need
>>
>> Extra overhead to the retry path, which is not the hot path,
>> and coldness of it is uncertain.
>>
>>> to re-grab (and re-disable interrupts) the lock to add it back. My gut
>>> says that would be _worse_ than the current approach. And if you keep a
>>> separate list instead, well then you're back to identical overhead in
>>> terms of now needing to check both when needing to know if anything is
>>> pending, and checking both when running it.
>>>
>>>>> reordered, and then you're spending extra cycles on potentially
>>>>> reordering all the entries again.
>>>>
>>>> That sucks, I agree, but then it's same question of how often
>>>> it happens.
>>>
>>> At least for now, there's a real issue reported and we should fix it. I
>>> think the current patches are fine in that regard. That doesn't mean we
>>> can't potentially make it better, we should certainly investigate that.
>>> But I don't see the current patches as being suboptimal really, they are
>>> definitely good enough as-is for solving the issue.
>>
>> That's fair enough, but I still would love to know how frequent
>> it is. There is no purpose in optimising it as hot/slow path if
>> it triggers every fifth run or such. David, how easy it is to
>> get some stats? We can hack up some bpftrace script
>>
> 
> Here is a sample distribution of how many task work is done per
> __io_run_local_work():
> 
> @work_done:
> [1]             15385954  |@                                                   |
> [2, 4)          33424809  |@@@@                                                |
> [4, 8)          196055270 |@@@@@@@@@@@@@@@@@@@@@@@@                            |
> [8, 16)         419060191 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
> [16, 32)        48395043  |@@@@@@                                              |
> [32, 64)         1573469  |                                                    |
> [64, 128)          98151  |                                                    |
> [128, 256)         14288  |                                                    |
> [256, 512)          2035  |                                                    |
> [512, 1K)            268  |                                                    |
> [1K, 2K)              13  |                                                    |

Nice

> This workload had wait_nr set to 20 and the timeout set to 500 µs.
> 
> Empirically, I know that any task work done > 50 will violate the
> latency limit for this workload. In these cases, all the requests must
> be dropped. So even if excessive task work happens in a small % of time,
> the impact is far larger than this.

So you've got a long tail, which spikes your nines, that makes sense.
On the other hand it's perhaps 5-10% of total, though hard to judge
as the [16,32) bucket is split by the constant 20. My guess would be
a small optimisation for the normal case adding a bit more to the
requeue may well worth it but depends on how sharp the skew in the
bucket is.

-- 
Pavel Begunkov

