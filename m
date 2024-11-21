Return-Path: <io-uring+bounces-4924-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AAB69D4EB0
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:31:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BD65282B27
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 14:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C8C74068;
	Thu, 21 Nov 2024 14:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aNht9HPU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821A920330
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 14:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732199496; cv=none; b=nDo+ZEiO1sMP3nhCuqxz5d7V4OnEwsIoStFF5dOhShALlsyO8QZAQek3Rn52Fa54AhfnnIWXC/H2+kVNbxA792dOLPPhlDb956XRpY6qHZBQ2EhDz7zct4Il36WNt7ApUaeOAYyal/FXvIPx4IVmKj5PH2xh1qJvnuTp1PbUYSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732199496; c=relaxed/simple;
	bh=/psb0axBKmNyGHrrRmp/KeV0jF/o6t+FCl7fYLyEW0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NdkAfV+lfmkJRcaqePAxL2NA/I5U/SkRkWJ0WybXP6Fh+cSM1eaYfgNFQyp+HbOxi1osQMpt9Uo2IaacfY1lseCcUGJBHPVRxERj1Gr1dY/irmPz8AwkHudt/BYkNM7hnFRwASxLPWIS5T7WxJXIiCReNOrFoIWuPNMRV1GLpOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aNht9HPU; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-71a6bfcb836so1090052a34.0
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 06:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732199491; x=1732804291; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8OmI9YuGFt2Ot1jL1EuABZfiwjXL4cro16xRHwCYlD0=;
        b=aNht9HPUVUiGkKxrfgvu0OBwgEhPPg1Ae2t2IOiaCE0v6fdSPwGSVwtaB7FGBrtO8S
         1tJJyWrqCZf55Eq4NB8/9/eQT3gRbR1erI1OCHzg0r5Co0eDXjdGDfClMzeNUG4Z/EdR
         n3JG5FfsFRzMo3IJHbtgChkrB2Zct6CssT/wLIV0UT0KzrH/zlFcy9pqVsJw1s4Ul6gQ
         Zr/Eq+0RyJ4MHlhXINWiic8bqJrDtN3kwun6ECFH8jv1guUcyHp6cuIwNfgIaCebVElm
         ylcAiMDmXCXgaH/3c8IVh7Qj4zfY1wXO8Hj6kn4nA6ZnrQnUhKGW64ieDXPUcuXUf1XK
         GzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732199491; x=1732804291;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8OmI9YuGFt2Ot1jL1EuABZfiwjXL4cro16xRHwCYlD0=;
        b=ui0M1PxzjdWJ8/X7q6jT29QA4D3537hLspvt/lx+UImcztGWtCf001TbumHuSdkOLK
         xTt9O8t5xQC1bEgUKTxCv69NSfpWF687T7uut3wh2/pA1lX+N4BfCp9K8vEPH246aMbz
         EFZ+Fz3MmkBUPD6QQF+75XBz8A1iKChfNDrshMcEMOaqbinmBgsUxhiNc5zct6BNTLEF
         iPr7Lpx2nJAOog60Q7U4axUtuMnhMwbrSnhWW3vgROaMVtA7XLj0elYMn6oNdPFy/Y3w
         OoSmStyHTq7oEJzNJA7shez/EYK+8Dh14G4PHsVFiRL500RjQj6lXwjRd7HSo+p7NrhW
         qnHA==
X-Forwarded-Encrypted: i=1; AJvYcCUxgsgKmXVeEEDX3RsWfoRIiK4phyWEBGiegkeQ6nPv3tnPe7v2tBzJZbROFcZ/N9OB1CFUTUfYDw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyPiUDf2Kk/lqWR7vkodR62zKDkj9ikjaVx0QB2Q7Zrp//ah6ku
	plAM9BNqsU19qNlxTzxscKebn0UfpSm2JlD5rowBkGgA9aIxM3TYw96+vzi00rE=
X-Gm-Gg: ASbGncsIhaVaQQvJuJBFYxp95Pn+fC2TMqS5hiobsLzo5nPJS6DHaulJ0T96Wz6+tou
	lqkiawQNs2uze6l2pvKfukJw2B1hCmrlKrNKj3YyReui1+19o6gRbgMhxIQxYOLEp+Sizprxbc0
	AeUIEe4oA/xTvKCxO04VPGYr4+6UtOkEj6p8HPOS4fchWoFKpxwOxg6p82pal3QnFgD3GQV4nE+
	5b5kcKjDWTZx0x/GadJgupBmX/4IjmH8avaiAxV/Xr83A==
X-Google-Smtp-Source: AGHT+IF/EbIZVjMdxLruDRlKfgi7D+h9C4XcIpPU+FnszyKDrtqTtrO53lahbb+MmzIVMDPKJaZziA==
X-Received: by 2002:a05:6830:1e90:b0:718:d38:7bbe with SMTP id 46e09a7af769-71b0e598d3cmr1699766a34.11.1732199491401;
        Thu, 21 Nov 2024 06:31:31 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-296518526c1sm4801093fac.10.2024.11.21.06.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 06:31:30 -0800 (PST)
Message-ID: <b7170b8e-9346-465b-be60-402c8f125e54@kernel.dk>
Date: Thu, 21 Nov 2024 07:31:29 -0700
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <614ce5a4-d289-4c3a-be5b-236769566557@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/24 7:25 AM, Pavel Begunkov wrote:
> On 11/21/24 01:12, Jens Axboe wrote:
>> On 11/20/24 4:56 PM, Pavel Begunkov wrote:
>>> On 11/20/24 22:14, David Wei wrote:
> ...
>>> One thing that is not so nice is that now we have this handling and
>>> checks in the hot path, and __io_run_local_work_loop() most likely
>>> gets uninlined.
>>
>> I don't think that really matters, it's pretty light. The main overhead
>> in this function is not the call, it's reordering requests and touching
>> cachelines of the requests.
>>
>> I think it's pretty light as-is and actually looks pretty good. It's
> 
> It could be light, but the question is importance / frequency of
> the new path. If it only happens rarely but affects a high 9,
> then it'd more sense to optimise it from the common path.

I'm more worried about the outlier cases. We don't generally expect this
to trigger very much obviously, if long chains of task_work was the norm
then we'd have other reports/issues related to that. But the common
overhead here is really just checking if another (same cacheline)
pointer is non-NULL, and ditto on the run side. Really don't think
that's anything to worry about.

>> also similar to how sqpoll bites over longer task_work lines, and
>> arguably a mistake that we allow huge depths of this when we can avoid
>> it with deferred task_work.
>>
>>> I wonder, can we just requeue it via task_work again? We can even
>>> add a variant efficiently adding a list instead of a single entry,
>>> i.e. local_task_work_add(head, tail, ...);
>>
>> I think that can only work if we change work_llist to be a regular list
>> with regular locking. Otherwise it's a bit of a mess with the list being
> 
> Dylan once measured the overhead of locks vs atomics in this
> path for some artificial case, we can pull the numbers up.

I did it more recently if you'll remember, actually posted a patch I
think a few months ago changing it to that. But even that approach adds
extra overhead, if you want to add it to the same list as now you need
to re-grab (and re-disable interrupts) the lock to add it back. My gut
says that would be _worse_ than the current approach. And if you keep a
separate list instead, well then you're back to identical overhead in
terms of now needing to check both when needing to know if anything is
pending, and checking both when running it.

>> reordered, and then you're spending extra cycles on potentially
>> reordering all the entries again.
> 
> That sucks, I agree, but then it's same question of how often
> it happens.

At least for now, there's a real issue reported and we should fix it. I
think the current patches are fine in that regard. That doesn't mean we
can't potentially make it better, we should certainly investigate that.
But I don't see the current patches as being suboptimal really, they are
definitely good enough as-is for solving the issue.

-- 
Jens Axboe

