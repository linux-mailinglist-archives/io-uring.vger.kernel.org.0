Return-Path: <io-uring+bounces-10086-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54718BF823D
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 20:46:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F368D3B5764
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 18:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACFD834D905;
	Tue, 21 Oct 2025 18:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MGytseUM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C42934A3AD
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 18:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072405; cv=none; b=Q58cFJ8y7jBSWinyUduFokvTdGau8lP1H5iJTXJ9HkDb27GmeRqeT9GUd9soMKcooZg+678FWZa2M8bXjgv/c0gG3x4ahw0H2ObgsFZzo7/HKWkw8yVOa/4fPJuFKAxcs2u4CYcWyU8YIKzauDcQ9tj8Ge78LHBIpQKl3+y1dyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072405; c=relaxed/simple;
	bh=E4shV22ii4zilhw28FegpVIq/5Y6pOPWEPsS6bowNqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RlCCKld8YSfFrfY7jaWuE4h+Dom6ee5n9yk57gtulCaTIEyJQCUSQDHWDszaedrtYzOwyZH+/se3llk4wqhd5uQZqLc/782nNP0cmOVUEf/VZe5ZTqjupdsdZYokBm1gpra7EYh7b3SBjrJvil1iyerbAmVzpRUVi6rhmQ9xnRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MGytseUM; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-940d2b701a3so310005239f.0
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 11:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761072401; x=1761677201; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uR978xbgj4uXSNom1Zujk8eG53Xb+5HRmJvyLtV9LxE=;
        b=MGytseUMRJhqXEiaOUQpfyoefnpz5JWMjFUGj7wb+XUYmRnkFf7acPQPRfGKpUL0aJ
         XHvWpYpCi+mDxqfaKvlU9TJXWXHa78t8ZZElabOb8Q2XLUwv5wo/4ZH6LHbqsSamWdGb
         r1xfr66r9WG9muZMOmTF5kSVJ9n9g7XMjINY+aO1PV1+Ky9o0YdWaDg+1xNBQpNPk5iI
         LKyRnor/gRKaZnI+tCPVuDc5tFryJ6BUAcRyU2MOg8faJk5Ivb5sVnsloDjVYyPR+H42
         2ixbI6wOJrtHh0BrzjnJ+XOYR5UlBkAsBna4PANr9B83TeQdfzFZi3WY8C2vAHiXuKR3
         M4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761072401; x=1761677201;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uR978xbgj4uXSNom1Zujk8eG53Xb+5HRmJvyLtV9LxE=;
        b=K302Ln5dmMdzR7tZ4FYdxEGNSPljA52kAwdUCbLx7DSguj9RiOzFRqhaFUaxXOU/YX
         +LC3c9Wk0XmoucHOH46N4dLbNyUxSxELNRIw+ZyNPBF8kB5xa1dinvvY78pnDp5RmWYb
         w6Pbn3eBgok2bF9SKHS600iXra0/e26uu+cp3aTdHH/VY94xWyJBkvBRN57NRb1MudhW
         IoN9DX/KwH6lPp2+LQLIaWFG5lx7PYvdDt7iSIBPDptL2nT/LMnSTwxkX/HEnhV609Zw
         qnPE/8hRHOJfFT3woeNQv6mU+bCwnyuKpq9L2tBmSvLNKxTe68awCGvdtiIdFwLErJFC
         s3Tw==
X-Forwarded-Encrypted: i=1; AJvYcCUt6cG3vXRBdis1j1i6pkVtRQj7xKzNjZxA9x745wgl/mINU3y7fQpiugYDhtBf1ag/axokZG3xug==@vger.kernel.org
X-Gm-Message-State: AOJu0YzB4pTiLWvXMOrVe1NiR1TsbOlkD76nmVBEPxjN71nTycN2+XwQ
	pmncNetKJcgcNXMHGHhqOajWmepcZVftvusB54iSaaRhgLS2LJNxgtSTAPfME8jhIL77UZ7hZ3t
	EC7KfFb4=
X-Gm-Gg: ASbGncuug3GcCJEY8ybF77Zf/6V/CLcu1Bp6cX488QxunUO/XmUA844mCEIkx/m0izJ
	yN23M3gffNFmFiqKOJ+liFQM+i/fvlvXMKA11fF4A4OoyjJ7lS8uH7GRRGzt3YDRPt6+qCFtZfz
	dicAvj/XNl99qLBtaxRLc+4zUpgPmO/roRcZYUjSgO5EG/0rrf3Q69K2Bbn9LiEa8jSn7kTwqPi
	F/qiPp/MBfEPx9CUS7asd04AzSSfBAsAjkhXPcTnms+dlayL9uu78PbYkgRWbh/99XB+T8S6pI4
	1H8ExtxSgmu+H7UvipsPoGF3wFLtnLyipWaPDZR0H+J8d9l325VCK0+JjDRNk387kCe7KudBRSZ
	fOehukvild2UJFJMsH7r7HNAhX0ReHhvyTet08M3kCwtEcIP3smoIImi1gpn+ppgtvbd1e5lSmZ
	GElw6DynU=
X-Google-Smtp-Source: AGHT+IE1daJxhmsKaXDDVSe010AZpkzRvy8SFhQ9biw5L739xgo/EjSDy0r8dWiYL8I4WfCcdbe9AQ==
X-Received: by 2002:a05:6e02:2506:b0:430:ad76:a5d3 with SMTP id e9e14a558f8ab-430c522d94dmr282016735ab.11.1761072401008;
        Tue, 21 Oct 2025 11:46:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-430d06fa874sm45510875ab.4.2025.10.21.11.46.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 11:46:40 -0700 (PDT)
Message-ID: <13aa4d5d-bcf1-409d-ac22-ddd4b9cec768@kernel.dk>
Date: Tue, 21 Oct 2025 12:46:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: move zcrx into a separate branch
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com>
 <175571404643.442349.8062239826788948822.b4-ty@kernel.dk>
 <64a4c560-1f81-49da-8421-7bf64bb367a0@gmail.com>
 <7a8c84a4-5e8f-4f46-a8df-fbc8f8144990@kernel.dk>
 <b10cb42e-0fb5-4616-bb44-db3e7172ccdc@gmail.com>
 <12e1e244-4b85-4916-83ab-3358b83d8c3c@kernel.dk>
 <57bf5caa-e25e-44e6-ba55-b26bb3930917@gmail.com>
 <f49721ac-d8bb-45f5-ab4b-f75f7ac4c2cc@gmail.com>
 <0cc942d8-20a4-43ff-82b6-88a6119662d8@kernel.dk>
 <88391433-98ba-47ae-85fd-b7bbe41402e6@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <88391433-98ba-47ae-85fd-b7bbe41402e6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/25 12:45 PM, Pavel Begunkov wrote:
> On 10/21/25 16:42, Jens Axboe wrote:
>> On 10/21/25 7:44 AM, Pavel Begunkov wrote:
>>> On 10/20/25 19:34, Pavel Begunkov wrote:
>>>> On 10/20/25 19:01, Jens Axboe wrote:
>>>>> On 10/20/25 11:41 AM, Pavel Begunkov wrote:
>>>>>> On 10/20/25 18:07, Jens Axboe wrote:
>>>>>>> On 10/17/25 6:37 AM, Pavel Begunkov wrote:
>>>>>>>> On 8/20/25 19:20, Jens Axboe wrote:
>>>>>>>>>
>>>>>>>>> On Sun, 17 Aug 2025 23:43:14 +0100, Pavel Begunkov wrote:
>>>>>>>>>> Keep zcrx next changes in a separate branch. It was more productive this
>>>>>>>>>> way past month and will simplify the workflow for already lined up
>>>>>>>>>> changes requiring cross tree patches, specifically netdev. The current
>>>>>>>>>> changes can still target the generic io_uring tree as there are no
>>>>>>>>>> strong reasons to keep it separate. It'll also be using the io_uring
>>>>>>>>>> mailing list.
>>>>>>>>>>
>>>>>>>>>> [...]
>>>>>>>>>
>>>>>>>>> Applied, thanks!
>>>>>>>>
>>>>>>>> Did it get dropped in the end? For some reason I can't find it.
>>>>>>>
>>>>>>> A bit hazy, but I probably did with the discussions on the netdev side
>>>>>>> too as they were ongoing.
>>>>>>
>>>>>> The ones where my work is maliciously blocked with a good email
>>>>>> trace to prove that? How is that relevant though?
>>>>>
>>>>> I have no horse in that game so don't know which thread(s) that is (nor
>>>>> does it sound like I need to know), I just recall Mina and/or someone
>>>>> else having patches for this too. Hence I dropped it to get everyone
>>>>> come to an agreement on what the appropriate entry would be.
>>>>>
>>>>> FWIW, I don't think there's much point to listing a separate branch.
>>>>
>>>> I sent this patch because last cycle I was waiting for roughly a
>>>> month for zcrx to be merged, and hence I started managing a branch
>>>> anyway, which also turned out to be simpler and more convenient for
>>>> me than the usual workflow. Not blaming anyone, but that's how it went.
>>>> And there were a couple of (trivial) patches from folks.
>>>
>>> To get some clarity, are you going to pick it up?
>>
>> Wasn't planning on it, please work with Jakub/Mina/netdev crew for an
>> entry that everybody is happy with.
> 
> Not really a crew, only Jakub has a problem. And I still don't see
> how it's relevant to the project written by me and David with zero
> contribution from Jakub apart from endless delays. But I can
> understand why you'd be standing for a fellow maintainer, even if
> he's abusing the maintainership, while screwing and impeding my
> work on zcrx.

Let's try and keep it cordial...

Just send out an updated patch that fits the criteria to the best of
your understanding, with the folks CC'ed. I'll be happy to apply it,
even if it needs some massaging.

-- 
Jens Axboe

