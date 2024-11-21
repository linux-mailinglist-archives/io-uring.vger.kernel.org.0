Return-Path: <io-uring+bounces-4940-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 23E599D522B
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 18:54:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E31CB21487
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 17:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F094155CBF;
	Thu, 21 Nov 2024 17:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="esB3NE9p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADBE6CDAF
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 17:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732211644; cv=none; b=dWTyVVpdBjnLjgyNiHdVzNUyMqIaN8L33gHj7P0GL3+aEM5fzTBdNYQzOPQRcVpcmBqqV2kOjXFL/iuB8Uu89B4wPOvQzYz62dE4KPUB0/QV1bln5+Kv4UaIEyXqm/x2KCTxqngYKOynMNjUKJoh+uHVCEuD3f622UpkcE1Xzwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732211644; c=relaxed/simple;
	bh=aUkO2DLhPDOMNtrqZVYo7uniBmPPHkuN8Czf06h7yHA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=inQQlXBsX1C7qyceVOmxDWYv4TsNdAeJsxOrOEb47w5waA+zTeNC4a6Y18ldGcEPvKTa0VV3dIjpf2UnY1jp3agUmp/G+r0/9dyHTj28AmMp14p40BXa1HFi/l3t3gE3y1btmo46V9mFkId3Z+yiNyEdkqv6vNL20LEAZVjteUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=esB3NE9p; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-72467c35ddeso1806799b3a.0
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 09:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1732211642; x=1732816442; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xNfbOs3rYNqmSxZro+5y4KXxU97Uq5JLxpUMPaUd0ew=;
        b=esB3NE9pZ5FAbguLSdQY+rga+mIATmXWUpQUGpSdHPiStvqPdDbAgsFMtiyP4iJv3R
         0H78X7oUiPIJV3c43OfcBmgGxmZFOS1KAcXRxAzYAmD9EGK6gZBMdILZn/1j4ig/xhFF
         rzQUCQZ4qGvw+nh4yD8OcWQ0A+08zjl7GGL7UX5JPNKdkq4ML02XONnkxxlGdJduqYRX
         yXWoQZKF3tAFFhwEaaTUM2I1Z8znmK0/XfJvFJwVXzunRZ7Nezddt1xwpsMaZO/kbFgU
         mzeD0C9wmMbVloHqmCUeRGT3G+6Yncxcglk8XtJNHNFoNGNUWbv2WOa4rr5R6vDeMaVK
         jpMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732211642; x=1732816442;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xNfbOs3rYNqmSxZro+5y4KXxU97Uq5JLxpUMPaUd0ew=;
        b=tBl1dStw9xXVND1hM/poKVxYXSl9PiCTTrGleN3u3Lo71BqinNLAW1+YpUatpesYDJ
         gAXX1kWqwzDwjkiNz8CWLK0Oc4g/AY64L01CgA+rAkiGU4V/cdJIVH6791rhXJJGm5y5
         3UI/COu+qsG02q/QX4iTQxTuwyWL2cPXoRPdx2Wg2Hy6IqhuOil0c249WSCXfwMgzaWf
         VFmrXQTf24BMGwpMGotWtKORcejKi7NFPnyMWB1lPD8SAN6nstn1wlWYV3x4f7SnuRT2
         9/r4EzCwOyfsYGd2H3Fi8afPcmN1qpE4JVEi9S03cK8StZmvpZ3X98SU1JnxwmyHRZWq
         Vj6w==
X-Forwarded-Encrypted: i=1; AJvYcCX4ZS+FryTHqVuGfWupL9fXYrERLk/v8P9zXwPTZaXuVNJl44bFrenn1UsUoMDGOWeIKLPdibPqMA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/vFiI7V7hB+pm6bspx5lCo0ePZ3IuoCZI1928gbMpADdZaMqg
	c256eMlt2uBfYjoRJ339oct3nJ1JuLUUH3RDFe6yTqtFcpMI1SgJm9fkV0AzC6A=
X-Gm-Gg: ASbGncv4QLdvv4eyxxmD8KmV8MdgvlBdikEztEGeaxwfSNLq6chu5KMO7K1Cp0g6BQ2
	clkajO54OfM2oT8H7n2sWsVYqFrw1UINIfW50oSySXiYKvvFKQtAMUEMzSYJrQzZauFrbVjhfRV
	M4coFvF7iY+8RLBisUXWnsCQnjriHjgifsbB9fTmTaANUIFP7XXMr/qHTyOe+E2ugiVEf4vE9Qu
	Kaz9QBQ8t/rStXx18Cyt8UI5QBUtG+2DAL9JBfNxEu98TOPaGgqlxa5UjXTab0ScAr2pTVfkmnq
	arMQF4qpwWM=
X-Google-Smtp-Source: AGHT+IHZwLM1SCR8Z7osArU+ysFq1z14LxS43NTyZMZBZiLfzDJw7HMmJlrto9Vx+gsWijTSr/W1jA==
X-Received: by 2002:aa7:91cc:0:b0:724:d05e:3845 with SMTP id d2e1a72fcca58-724d05e39b0mr4471862b3a.4.1732211641998;
        Thu, 21 Nov 2024 09:54:01 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::6:7483])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724de531308sm31112b3a.110.2024.11.21.09.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 09:54:01 -0800 (PST)
Message-ID: <8dfe2a9b-52f8-4206-a670-ecede76ab637@davidwei.uk>
Date: Thu, 21 Nov 2024 09:53:59 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <95470d11-c791-4b00-be95-45c2573c6b86@kernel.dk>
 <614ce5a4-d289-4c3a-be5b-236769566557@gmail.com>
 <b7170b8e-9346-465b-be60-402c8f125e54@kernel.dk>
 <66fa0bfd-13aa-4608-a390-17ea5f333940@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <66fa0bfd-13aa-4608-a390-17ea5f333940@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024-11-21 07:07, Pavel Begunkov wrote:
> On 11/21/24 14:31, Jens Axboe wrote:
>> On 11/21/24 7:25 AM, Pavel Begunkov wrote:
>>> On 11/21/24 01:12, Jens Axboe wrote:
>>>> On 11/20/24 4:56 PM, Pavel Begunkov wrote:
>>>>> On 11/20/24 22:14, David Wei wrote:
> ...
>>>> I think that can only work if we change work_llist to be a regular list
>>>> with regular locking. Otherwise it's a bit of a mess with the list being
>>>
>>> Dylan once measured the overhead of locks vs atomics in this
>>> path for some artificial case, we can pull the numbers up.
>>
>> I did it more recently if you'll remember, actually posted a patch I
>> think a few months ago changing it to that. But even that approach adds
> 
> Right, and it's be a separate topic from this set.
> 
>> extra overhead, if you want to add it to the same list as now you need
> 
> Extra overhead to the retry path, which is not the hot path,
> and coldness of it is uncertain.
> 
>> to re-grab (and re-disable interrupts) the lock to add it back. My gut
>> says that would be _worse_ than the current approach. And if you keep a
>> separate list instead, well then you're back to identical overhead in
>> terms of now needing to check both when needing to know if anything is
>> pending, and checking both when running it.
>>
>>>> reordered, and then you're spending extra cycles on potentially
>>>> reordering all the entries again.
>>>
>>> That sucks, I agree, but then it's same question of how often
>>> it happens.
>>
>> At least for now, there's a real issue reported and we should fix it. I
>> think the current patches are fine in that regard. That doesn't mean we
>> can't potentially make it better, we should certainly investigate that.
>> But I don't see the current patches as being suboptimal really, they are
>> definitely good enough as-is for solving the issue.
> 
> That's fair enough, but I still would love to know how frequent
> it is. There is no purpose in optimising it as hot/slow path if
> it triggers every fifth run or such. David, how easy it is to
> get some stats? We can hack up some bpftrace script
> 

Here is a sample distribution of how many task work is done per
__io_run_local_work():

@work_done:
[1]             15385954  |@                                                   |
[2, 4)          33424809  |@@@@                                                |
[4, 8)          196055270 |@@@@@@@@@@@@@@@@@@@@@@@@                            |
[8, 16)         419060191 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[16, 32)        48395043  |@@@@@@                                              |
[32, 64)         1573469  |                                                    |
[64, 128)          98151  |                                                    |
[128, 256)         14288  |                                                    |
[256, 512)          2035  |                                                    |
[512, 1K)            268  |                                                    |
[1K, 2K)              13  |                                                    |

This workload had wait_nr set to 20 and the timeout set to 500 µs.

Empirically, I know that any task work done > 50 will violate the
latency limit for this workload. In these cases, all the requests must
be dropped. So even if excessive task work happens in a small % of time,
the impact is far larger than this.

