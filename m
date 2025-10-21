Return-Path: <io-uring+bounces-10076-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E3873BF6DAF
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 15:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2EDBC506DD9
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 13:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B03BC338587;
	Tue, 21 Oct 2025 13:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V6S35WNq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE6E337B8B
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 13:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761054205; cv=none; b=gzyPYEgupRRZwkBgtaxCIfg+LsCkdVPXFuEHh4I7xXOu3dpUV1ZXlCJofeAz5cGuuDKa3aibHJoiVVdG2N3Z2D1hw/++357UsdK6w01z+DZuSnBUEcNphBUjB6b3GlfjffMj879HFRebS+gXwmCvYdFX4DbQ6MgmTJE0cnnxi4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761054205; c=relaxed/simple;
	bh=bYFZsEYCAJcfkGhFoUaPudKwUJ+sHrxl1IMpnSpAtyE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Hutgo+Nn8C/5RPT51rupep99dZsxdZ6gjRsmL3kVVrm8Ltrl9znV9xrgG4Kx7fsYqDkr/QTGzYLSyQw15PzO9m1IHPdj6ojfEh68vvl+OiuaKIpgLYNmjzU2BCj74aPURiSS3t2/ZZyD1hTIpvoSeQlO5vKzbxRD3hIA1dUNEmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V6S35WNq; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4710ff3ae81so20459695e9.0
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 06:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761054202; x=1761659002; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4j1vqtLhPvEx8ulpIUh1Id/jJvXn/Kqv/QjnubvqzrM=;
        b=V6S35WNqlqoVFqC8P5JJMbUjSf0UJsvywJUl5f15+BNmriQlUAHqwWTJFRMCSk8WJC
         W5BdgL3kgRhsZ7Q7pup/dCHHm4YBiOqgZytiaLDJr1IoZAp4Fga9rrzZY4V/Kvu+t4YX
         Lc3v9IBfLk92Kyaobfdp5ASZYVPbS/zu0b1h11/93NJtilTy3BfRKlT6SHEzaH42AMZi
         z598YEHHDf9unNgt5GMYKoz1/Ht21tCGuFKkbxFT2XpD29wagEm1+EsZGw2kSzTF36Ed
         //VRuH+raHEa7dlIBXoGsahtfqvKyxxQfBNCmXOJ32iNmcpQ6qTbkFtd2EK1HLXpq2nh
         Ofrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761054202; x=1761659002;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4j1vqtLhPvEx8ulpIUh1Id/jJvXn/Kqv/QjnubvqzrM=;
        b=gXCJs8PxAGq1lLIkfkHvXtYnNkaHa1ksPC19ZtXA969cmuJBr80MVTXD/OwqG6FDo9
         Pe1FcHhMOMR4oZyxwllnH4G6WMOS3XYgAbN0RMVzvLvhna1U5LYA8QD9to6+i3MTJsBA
         y4QjQCMhWzCKNXld4qkziL5I5DA13C9s4fHnyyzOJ2AWU61KibFK0tXlcFnzq7IYu3iX
         QwtS0kjTYn1w0HbTUCnAOJcQMEMPMWTRaTETNeE0TibWQZbrOVR9tqKPRJ6IqcefPuj7
         Ww6Tsu3JRQhXvtVCbpgM4edK733Co6pihvojxP2JzPIoxFcK0G6ylPmOzPfvCP1vT442
         BBRg==
X-Forwarded-Encrypted: i=1; AJvYcCW3eToclgH8N+n600jJQ4PWPtY4jfgSmt6bo/A57SnIQqBWY0gPxOQ48P3kWXKKWYtzWftXJQWfVA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbrBC1LdUantGq17Kb5BEokNPUScdNwqcNmyxf1heCLOeVnv6w
	A+wPcHgz8hSwj7iTFhoH+Y0vrXI5R1KovEbLXwePeDn/Joao3WJMe1nnO0su+Q==
X-Gm-Gg: ASbGncsxFSu0ZlfbN+UJ0dZ59vqA1k6yFey/VjpX+DkeN9Zzx5YiuEKV/QJj6Z/qKp8
	I9lLyt51nNO8kzgCZXV6j+wGowg69Cbrv5X4gTDoE0wGTb8gJOLltu6cZ7f2chJpW22oRmUCAA1
	Gm9UwgNw0C2jUcVI3Sqg5Z9Qytb1o5T9mwJuzydBc3G6ywtcln5i7EkZV0khxhW3UpUiXUTPLC3
	rstPmEskbthk0Gpu94dJ9iaiJ2mCLT/Cbk5fP/p4Xz30iVjhHglJ3DFpL0jpG7zrJEYeaD/+a2s
	YK/3gRBUnv5/GfMk2ninfmeLUxLsNKrUe31hkGXIyKPW5Evl9L+TvyHbKhG03Ny85Gt8dHdLHSb
	TeiuPRbMqlfC9+In5ujiatbRxzHpIeYvQxA562sXrB4tETfE49RMO0Y0YpwEopQtEcSU9oc6zDL
	XS1FkUCG7GdwIspprXdUl8CigeuZLNAJIWJFNarK7x7mfuWR2HPJbp3uKH99NfFQ==
X-Google-Smtp-Source: AGHT+IEsGzOiOfDPe5o4My+0UYHLbGgrmt06MvPDfTrcRl+pYQZaxfIqQAu1+TrFy7VO0AQEDP3zKg==
X-Received: by 2002:a05:600c:3e07:b0:471:13fc:e356 with SMTP id 5b1f17b1804b1-471178760f8mr125221825e9.3.1761054201837;
        Tue, 21 Oct 2025 06:43:21 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-474949f0312sm18717335e9.0.2025.10.21.06.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 06:43:21 -0700 (PDT)
Message-ID: <f49721ac-d8bb-45f5-ab4b-f75f7ac4c2cc@gmail.com>
Date: Tue, 21 Oct 2025 14:44:42 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: move zcrx into a separate branch
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com>
 <175571404643.442349.8062239826788948822.b4-ty@kernel.dk>
 <64a4c560-1f81-49da-8421-7bf64bb367a0@gmail.com>
 <7a8c84a4-5e8f-4f46-a8df-fbc8f8144990@kernel.dk>
 <b10cb42e-0fb5-4616-bb44-db3e7172ccdc@gmail.com>
 <12e1e244-4b85-4916-83ab-3358b83d8c3c@kernel.dk>
 <57bf5caa-e25e-44e6-ba55-b26bb3930917@gmail.com>
Content-Language: en-US
In-Reply-To: <57bf5caa-e25e-44e6-ba55-b26bb3930917@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/25 19:34, Pavel Begunkov wrote:
> On 10/20/25 19:01, Jens Axboe wrote:
>> On 10/20/25 11:41 AM, Pavel Begunkov wrote:
>>> On 10/20/25 18:07, Jens Axboe wrote:
>>>> On 10/17/25 6:37 AM, Pavel Begunkov wrote:
>>>>> On 8/20/25 19:20, Jens Axboe wrote:
>>>>>>
>>>>>> On Sun, 17 Aug 2025 23:43:14 +0100, Pavel Begunkov wrote:
>>>>>>> Keep zcrx next changes in a separate branch. It was more productive this
>>>>>>> way past month and will simplify the workflow for already lined up
>>>>>>> changes requiring cross tree patches, specifically netdev. The current
>>>>>>> changes can still target the generic io_uring tree as there are no
>>>>>>> strong reasons to keep it separate. It'll also be using the io_uring
>>>>>>> mailing list.
>>>>>>>
>>>>>>> [...]
>>>>>>
>>>>>> Applied, thanks!
>>>>>
>>>>> Did it get dropped in the end? For some reason I can't find it.
>>>>
>>>> A bit hazy, but I probably did with the discussions on the netdev side
>>>> too as they were ongoing.
>>>
>>> The ones where my work is maliciously blocked with a good email
>>> trace to prove that? How is that relevant though?
>>
>> I have no horse in that game so don't know which thread(s) that is (nor
>> does it sound like I need to know), I just recall Mina and/or someone
>> else having patches for this too. Hence I dropped it to get everyone
>> come to an agreement on what the appropriate entry would be.
>>
>> FWIW, I don't think there's much point to listing a separate branch.
> 
> I sent this patch because last cycle I was waiting for roughly a
> month for zcrx to be merged, and hence I started managing a branch
> anyway, which also turned out to be simpler and more convenient for
> me than the usual workflow. Not blaming anyone, but that's how it went.
> And there were a couple of (trivial) patches from folks.

To get some clarity, are you going to pick it up?

-- 
Pavel Begunkov


