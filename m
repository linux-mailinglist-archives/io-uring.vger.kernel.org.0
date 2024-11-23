Return-Path: <io-uring+bounces-5000-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D189D66DC
	for <lists+io-uring@lfdr.de>; Sat, 23 Nov 2024 01:49:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47604B20DEB
	for <lists+io-uring@lfdr.de>; Sat, 23 Nov 2024 00:49:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D082905;
	Sat, 23 Nov 2024 00:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jDpXJDZR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08051257D
	for <io-uring@vger.kernel.org>; Sat, 23 Nov 2024 00:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732322983; cv=none; b=P4Y5zlizZLt1MvcWpj3qAmhcxAlja0peiZjg+R8381nPrKb/wm8oq0aZfKjM13VjTo3kt84xsQ9j1a7f5qiviOl4vzYUlU63zg1D6bASZBqnG5ewX4SR6EMvsZ74UqgMFOgOK2qmKwHPTEWaHawqdju5zVmal36+h9PfU9oBVMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732322983; c=relaxed/simple;
	bh=Y6GM2xHwmGNoHDmJbuKB78ziPGMbdEBp0BT0kMP2iZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fP2mIWLwL6TI5cg1658Asb47QgNi5oiABF5MWxDY6jH2EnYxlVJR736fMMccALe5CJ97rCfSeFCNC1/jyCWmwFJ0Vl951XwjVtDcaPIdrF5WFb28GTPWdBT4mEAkOLt8PttJqd0kWkSZ+YooEZejAGBXYYDpbUG+3g+FqLc71yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jDpXJDZR; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d01db666ceso1775696a12.0
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 16:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732322980; x=1732927780; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HelRoQFFlQYtqSZ+TKpMxUvKUvfk7K3G0E9Nb73PWSs=;
        b=jDpXJDZRc71tahSkBtbSw+hw/gVpXQZC97YkGKJx9sDDmMUhOnNRHxawRhv0mt1a7A
         tiLLMg5U3H1vY+nlVaw/+NKflitwXqxF0s6VoH7HbdDgBr1EKCl+ASC3nUNbVpy/noMf
         EW3fyi4Ror7H5a8V25Om9x7XxkKiUlByuiXscCecXrTylHzmKGBgQgBEsteV3gkICPW/
         VLOAdxMEwmJsB+QHjXPlWLEerOfJFvnpmyLCMhi74MLw/oni51CyaCWcF/DyM9paNEmQ
         Cq7mZk2Z8FhqaLiey/T8p36tNTpzEMbI9xRnkRYn4Xk3O/zgUc36fo+lC//dH2BgQMNj
         GnbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732322980; x=1732927780;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HelRoQFFlQYtqSZ+TKpMxUvKUvfk7K3G0E9Nb73PWSs=;
        b=GwV6FIiX8+ttmASzk6MN1PkGDN4nea5HYiDz4TQA1JTTyPiDtDCN5GIHHTm0aARg3m
         9TOifKeHBRniG4p6TQWE/seQmcT38p6CKcF874Ad1/Ea+xrcGn9dPQ87PYjLTe//mVMY
         LjJMZhPhcYUXnnRw7JB4LyGbDx747nAGq0vdYyYbnXQLE0FzuPOQWDq1BP6JbFtKWK1l
         WsaIjcxaxxsXpJPtvasxUrbOMl86+ipZZdLQFznfZfMQ06BV3iDhLCiNcs7yUEzre5yD
         lRhyiv25c3MfC4jEPsSOdRviTztAe6t6TzwyE6Rho4n9fYyg1fReU8olU9DtOpkOCg2m
         WDGg==
X-Forwarded-Encrypted: i=1; AJvYcCXu/w2v+GMN3JGRDPIgDZJgxMEy4nwtgtj1kuPqz51kDUj4jJYkeNnnsxL02n4ZuNP4o2xyCZutIg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2xFRmbMaLwvyrJ1Eiv+7aegTEdptzZJ09Xa46Ee6CTa20VI3n
	rVApWLOnH4uPIs+dny0Iaut2aBvkaYOFQTIMpfrGNsvzYXxIMEGV
X-Gm-Gg: ASbGncuCm58g2EU7RwZlKJY79c5GfLlu4fK4WYaS2unoEw4w5Wp4jgu/HBBY+T3NRXt
	UPRV0j9EmF5EHM9Hi4/DbpeYnT2foKtvTzZe4bxd0VnuonCgbrCJuwIpw2Ux7zJG8TGbMfOAPzA
	d0mf2t1IiZk65bvfrZqz5eXjgXiykQfawrnJ5v0yD/nmBz1Fabm/Jo23ftS5VqxS06bmhaGOvKw
	20oqxDKGCD66JjwSrH4QcVF7QshnwmionVYyS8DvwUujt+CdCLP1v1thWImtQ==
X-Google-Smtp-Source: AGHT+IHA6zCMxRaTCdhqdalWAjT0MfyJIMTikalTv6GpeUjaqDiIwGM53zCH/dcaAcWCEua4NkhnPw==
X-Received: by 2002:a17:907:778b:b0:aa4:9ab1:1982 with SMTP id a640c23a62f3a-aa50997617cmr426867566b.4.1732322979973;
        Fri, 22 Nov 2024 16:49:39 -0800 (PST)
Received: from [192.168.42.180] ([148.252.140.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa524615e8fsm83370366b.182.2024.11.22.16.49.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 16:49:39 -0800 (PST)
Message-ID: <e5dac423-ba5a-4fc7-b3f0-09e2a03082da@gmail.com>
Date: Sat, 23 Nov 2024 00:50:32 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
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
 <390502d5-2de4-42e0-a899-a0e25d1ee5d7@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <390502d5-2de4-42e0-a899-a0e25d1ee5d7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/22/24 17:08, Jens Axboe wrote:
> On 11/22/24 10:01 AM, Pavel Begunkov wrote:
>> On 11/21/24 17:05, Jens Axboe wrote:
>>> On 11/21/24 9:57 AM, Jens Axboe wrote:
>>>> I did run a basic IRQ storage test as-is, and will compare that with the
>>>> llist stuff we have now. Just in terms of overhead. It's not quite a
>>>> networking test, but you do get the IRQ side and some burstiness in
>>>> terms of completions that way too, at high rates. So should be roughly
>>>> comparable.
>>>
>>> Perf looks comparable, it's about 60M IOPS. Some fluctuation with IRQ
>>
>> 60M with iopoll? That one normally shouldn't use use task_work
> 
> Maybe that wasn't clear, but it's IRQ driven IO. Otherwise indeed
> there'd be no task_work in use.
> 
>>> driven, so won't render an opinion on whether one is faster than the
>>> other. What is visible though is that adding and running local task_work
>>> drops from 2.39% to 2.02% using spinlock + io_wq_work_list over llist,
>>
>> Do you summed it up with io_req_local_work_add()? Just sounds a bit
>> weird since it's usually run off [soft]irq. I have doubts that part
>> became faster. Running could be, especially with high QD and
>> consistency of SSD. Btw, what QD was it? 32?

Why I asked about QD is because storage tests reliably give
you a list of QD task work items, the longer the list the
more expensive the reverse with washing out cache lines.

For QD=32 it's 32 entry list reversal, so I'd get if you're
seeing some perf imrpovement. With QD=1 would be the opposite.
With David's thing is similar, he gets a long list because of
wait based batching. Users who don't do it might get a worse
performance (which might be fine).

> It may just trigger more in frequency in terms of profiling, since the
> list reversal is done. Profiling isn't 100% exact.
> 
>>> and we entirely drop 2.2% of list reversing in the process.
>>
>> We actually discussed it before but in some different patchset,
>> perf is not helpful much here, the overhead and cache loading
>> moves around a lot between functions.
>>
>> I don't think we have a solid proof here, especially for networking
>> workloads, which tend to hammer it more from more CPUs. Can we run
>> some net benchmarks? Even better to do a good prod experiment.
> 
> Already in motion. I ran some here and didn't show any differences at
> all, but task_work load was also fairly light. David is running the
> networking side and we'll see what it says.

That's great, if it survives high traffic prod there should be
less need to worry about it in terms of regressing.

The eerie part is that we're switching it back and forth rediscovering
same problems. Even the reordering issue was mentioned and warned
about before the wait-free list got merged, but successfully ignored
until we've got latency issues. And now we're back the full circle.
Would be nice to find some peace (or something inarguably better).


> I don't particularly love list + lock for this, but at the end of the
> day, the only real downside is the irq disabling nature of it.
> Everything else is both simpler, and avoids the really annoying LIFO
> nature of llist. I'd expect, all things being equal, that list + lock is
> going to be ever so slightly slower. Both will bounce the list
> cacheline, no difference in cost on that side. But when you add list
> reversal to the mix, that's going to push it to being an overall win.
> 

-- 
Pavel Begunkov

