Return-Path: <io-uring+bounces-10085-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FECBBF8220
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 20:44:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5807D4E4946
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 18:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DBC34D933;
	Tue, 21 Oct 2025 18:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRr9KBp0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7959D34D916
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 18:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072242; cv=none; b=KXWyhI7o5fuF4DwjPqFV8N3Fgmjz3VHxwqKwDWgkSq9bY9I080SHwb+rC6Levn3qc4w2hxYPGtC/CMnQ24wqjbu/PdPVJAdqUcDjHlgQ0xbP86R8ktyTuIqhrQ5osfxS1KM4F00DmjDrb+Cbl9GlUm+221U4QFnAJ1gtJ2FhhvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072242; c=relaxed/simple;
	bh=dMZ543gFRLhcsx2twBkuNEhLYQ0/xNV/1po2I47bkCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LyqhRbHsbmtkKrg/GP9S3KdijM/Uy5SsSVzXAj6fH6YhzAtP5DNFN3FdH982QBEMB5umSKNvYiQEupB9gtCLL68/Fyq7bOz3iI0vw4Kc5C5n1E7KnqkGcCs1Df0jzTzY12PmF7P51W0xm1aweL0M7znPc7FrVqJxXj1ywoeOHo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRr9KBp0; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46b303f7469so48112275e9.1
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 11:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761072238; x=1761677038; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kh/XMPdb04T4Y7WROE/G9lj01BJ7DWnUDuqhPKcmtX0=;
        b=BRr9KBp0Fb4gZAbPdXol03bED1hQjbHCsy4TgQYvRiggCucstXwpCCOJ2efz+IS4K7
         qMWcy6cBhrEQwu3eHxZUetHCDW9IX962yBxh2hzxdxWv6WMAUS5P+BiFR74lK5X92Pbg
         ec1D2qeTJ0MHQJeehiFoaxNIvZCIa566i8Fgk40Zz1/quO3fx4vM8uM9BGjnWGxXEkXF
         +Gxu1EYTkZrCJyRKHq0IJ6w4hTpISXo/jqPXBLiKb3VfnfPuCHGwIFQ3FKbM8x+WSVwI
         wT837wDs3FxNR+sQyD5HkveOXkWwCxD8aj0w12qhuXdsO6EBfzNQv/ueT/VPzGYR8etA
         ikOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761072238; x=1761677038;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kh/XMPdb04T4Y7WROE/G9lj01BJ7DWnUDuqhPKcmtX0=;
        b=qo7ejOVBj5MNhsO3i1zF6TQ2SARuRJyThnHfVgPZFcAIDnVBvqROX1p+tSryNl2uNq
         JV4qCYMc2bHj6VxHyEjw43STAzuCO0vyTm8lHTnR8wzmL44tHH89NR9YwNAGtEKOW4c3
         1gGOEO5sTfKeiaV0xOCGNfkxNAqbU75PSS10SSm2zJTFNTGJa+hn8qbLxJfim82mQTQi
         recS6lTQHRyXXQDKw4p1rQLyo75ivPFipNDuOA70W3oEZ9A2lj2BOkZuIpnJqvwIoIQM
         4sKFOLgQ6DtfoMPb4ziYkSODWhJbHbeoauy+66F8Yiv9ZUB/CNxfJlAD5+79q1GEEZja
         KWGg==
X-Forwarded-Encrypted: i=1; AJvYcCVhDwEPwI3CcTqaL1SxKGO3153iFQJIr0D/nstfI8NGFwQxH9u8fYCfqDH64Y/aaKD5V0GKOlxeDw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3T0iFQ277hvleoV+Kov/1jVu4THHtXc8uwMH67qXkSRmfgp1Y
	qAiMShyOBCU+zSASEedVDwauMkCr6pIPQA692J9MLnLdUx4ebW1ohbnR
X-Gm-Gg: ASbGncuztxVI7X45rH9feDZFD0ltdAfj2uLy2E3i5/rPfYry0Uqg9k1XnJSo23LrK/D
	E+d6A50XRN5CPDPL1DNGNu3iIPVQIxSbvr8MAEtAdY2TZ/kXkxdjksYgCfBkVLqI+4fmZuJYrxD
	TauoaJ5+/6d3kI9ZDyV82b8+LezLVswAJ7WHPTM0CQlwHnMRVHwWy+c0Y97a+uC8qvCT6DVuFWs
	flG952laJURn77tx8CyapkPKmP9mJ95s90RObtOP0cMWm2hxYX1Cncym2Md83B7KFCVglIuBnJE
	uX6l1Bnq/Drpu59Qp6/p+HsA/E5/ZOZKZ/H1sQ2bgbttd4hrnHHEy2HTpSCLTHtxSW3pCD14RJ5
	zABcGk54b6kY7ETjfxM/jtT6GXQQtWPcIqyM6eZYkVLbvf/S/vdlIlzn/HtP2RyskfMrayIwP8o
	YEUHnY/RXAElYElFmyRjOhI6vemrtbUKgKezssBzSUM6U9p//5vrg=
X-Google-Smtp-Source: AGHT+IGWelL5DwWwNY8vHNsoNzzlZ/TZLEsXApTIRHCLR84bM9cvhrxzkPAU3U7RrNKybWEn5qjLvA==
X-Received: by 2002:a05:6000:1867:b0:427:5ed:296d with SMTP id ffacd0b85a97d-42705ed297cmr10708644f8f.28.1761072237628;
        Tue, 21 Oct 2025 11:43:57 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00b9fa8sm21971823f8f.38.2025.10.21.11.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 11:43:56 -0700 (PDT)
Message-ID: <88391433-98ba-47ae-85fd-b7bbe41402e6@gmail.com>
Date: Tue, 21 Oct 2025 19:45:17 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: move zcrx into a separate branch
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com>
 <175571404643.442349.8062239826788948822.b4-ty@kernel.dk>
 <64a4c560-1f81-49da-8421-7bf64bb367a0@gmail.com>
 <7a8c84a4-5e8f-4f46-a8df-fbc8f8144990@kernel.dk>
 <b10cb42e-0fb5-4616-bb44-db3e7172ccdc@gmail.com>
 <12e1e244-4b85-4916-83ab-3358b83d8c3c@kernel.dk>
 <57bf5caa-e25e-44e6-ba55-b26bb3930917@gmail.com>
 <f49721ac-d8bb-45f5-ab4b-f75f7ac4c2cc@gmail.com>
 <0cc942d8-20a4-43ff-82b6-88a6119662d8@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0cc942d8-20a4-43ff-82b6-88a6119662d8@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/25 16:42, Jens Axboe wrote:
> On 10/21/25 7:44 AM, Pavel Begunkov wrote:
>> On 10/20/25 19:34, Pavel Begunkov wrote:
>>> On 10/20/25 19:01, Jens Axboe wrote:
>>>> On 10/20/25 11:41 AM, Pavel Begunkov wrote:
>>>>> On 10/20/25 18:07, Jens Axboe wrote:
>>>>>> On 10/17/25 6:37 AM, Pavel Begunkov wrote:
>>>>>>> On 8/20/25 19:20, Jens Axboe wrote:
>>>>>>>>
>>>>>>>> On Sun, 17 Aug 2025 23:43:14 +0100, Pavel Begunkov wrote:
>>>>>>>>> Keep zcrx next changes in a separate branch. It was more productive this
>>>>>>>>> way past month and will simplify the workflow for already lined up
>>>>>>>>> changes requiring cross tree patches, specifically netdev. The current
>>>>>>>>> changes can still target the generic io_uring tree as there are no
>>>>>>>>> strong reasons to keep it separate. It'll also be using the io_uring
>>>>>>>>> mailing list.
>>>>>>>>>
>>>>>>>>> [...]
>>>>>>>>
>>>>>>>> Applied, thanks!
>>>>>>>
>>>>>>> Did it get dropped in the end? For some reason I can't find it.
>>>>>>
>>>>>> A bit hazy, but I probably did with the discussions on the netdev side
>>>>>> too as they were ongoing.
>>>>>
>>>>> The ones where my work is maliciously blocked with a good email
>>>>> trace to prove that? How is that relevant though?
>>>>
>>>> I have no horse in that game so don't know which thread(s) that is (nor
>>>> does it sound like I need to know), I just recall Mina and/or someone
>>>> else having patches for this too. Hence I dropped it to get everyone
>>>> come to an agreement on what the appropriate entry would be.
>>>>
>>>> FWIW, I don't think there's much point to listing a separate branch.
>>>
>>> I sent this patch because last cycle I was waiting for roughly a
>>> month for zcrx to be merged, and hence I started managing a branch
>>> anyway, which also turned out to be simpler and more convenient for
>>> me than the usual workflow. Not blaming anyone, but that's how it went.
>>> And there were a couple of (trivial) patches from folks.
>>
>> To get some clarity, are you going to pick it up?
> 
> Wasn't planning on it, please work with Jakub/Mina/netdev crew for an
> entry that everybody is happy with.

Not really a crew, only Jakub has a problem. And I still don't see
how it's relevant to the project written by me and David with zero
contribution from Jakub apart from endless delays. But I can
understand why you'd be standing for a fellow maintainer, even if
he's abusing the maintainership, while screwing and impeding my
work on zcrx.

-- 
Pavel Begunkov


