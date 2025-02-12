Return-Path: <io-uring+bounces-6361-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56CD9A3291A
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 15:50:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10BBD1607E5
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 14:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C43209F35;
	Wed, 12 Feb 2025 14:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rZaDLPF6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F56F271800
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 14:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739371843; cv=none; b=sqkmxt7ZzAmAkkol1aZtJxPbpL9VInoELhfi1y5iU3zQHgxFKO/jfiFzKjRuBevK7iVZPD+Omtc5qr17wWBDhDvR2O2ItDPdzE8QzwOXN02A0+E/KTr4ojb8YNdsx9QART5aynVuvsuyXCj6kFoRHz7q1ajiTpbcqZK48pwfRxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739371843; c=relaxed/simple;
	bh=x12Rg1O/ihpcTLOBYbsro6dbc7IHgCIMhbS6FEZokI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MqYx8AYYKVK4V2cOdi5W8z1z3hz1mW4sfr88EpTSRQlKgo5BmSTx8jHeZCjfbThn3sO5iaV9+Ga4Abi+LTyGWKYB8Ox1pb75RM8nhYs4gBnGaKmqo0X7p3Z5kHvYCq9PMLhj2LkoH4/DZsrIVFEM3mjnerGC8rmluWQRaM4iQks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rZaDLPF6; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-8553534922dso95175839f.2
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 06:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739371840; x=1739976640; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vijM9YkyBX7o+7ABNYM8odsbFppJ4LRUKbiEnaBtTGU=;
        b=rZaDLPF6CjldkuGsnJEUIrVNJ3kWv2vZrM/DAa/K4ryBFpUusRjEmHLjzFBv98YFiy
         03jJwt28WKJQShAFkXSU3PLMtiO9xteDN765ALSSCRemNO8Gak7XM2gQQZqb7Qz7nBmp
         J4os1b/YhwPOrcrJTflwPE35PQQlK9Qlr5Dpfd0u/rGIaDSnxVxI8JU3qTAnGj5H7cBJ
         VWOBro1Zxd/dw8WPLakpWBpSy0bENIjYIov1hiMNukMW/GCUahC/dgMqSihv8yQygGOd
         /L3xAJngb4PG2iV1Hnnpk/VQG1bfZ99hGMzWx3gFZWLHixyZ7n/BShR1JwEqPHrOSSWW
         8Vrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739371840; x=1739976640;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vijM9YkyBX7o+7ABNYM8odsbFppJ4LRUKbiEnaBtTGU=;
        b=fPgc7JcviUB0SoexIc2m+Oxw5oRwwNMP48sgX2mHzV/TfKp2KNcElw8p6dddOKnc4E
         zs7CFjcihIZFLHBiIBd0jLxux4MrdGGAMgpbv6P2U6INNiYiYRJCaaLZsMgRNhZ1jDPN
         liA+Deq9SIq3JDZO7TliCRTT5mRDYXmd6pwvLSOYvqqTE8GWMrvYuzXtso188sTfIe3D
         yRBYKEPLivafkkdvoOQEVlM0LtrDkEoS85qkYJuGBx67vY+soGTcL4Ec/mntn51ba/1g
         HdFfTG+IltedV09xMfXo4lrzinu1dZBKkfdx3o20fRbel2Hq3BHk+kpaW8KEEXsBKqtZ
         BKkA==
X-Gm-Message-State: AOJu0YxCstks8dRZlRaM4IiFctTi9OvBAFYWPwo9SGIgOBJWYGzneAEK
	qkj6erQGrDrBL7LrliJCK6Lx1pK4Ct/+hR1iGycSXYgcO1QjD8Qp+Jy7uXkZdR8=
X-Gm-Gg: ASbGncumkWVhWGGVkSxPOXIbOpfu8z6Ff6mSlejFugmsdpkobZS5neq0uCWhytsiDS4
	AnC50nfWsrgG4gSugliIW1140RimUkYDULPvnX6EFro4nsSBz5Uk39rok0HABKINOagh1FFSEsb
	vMqXwfzxfdVM7qE0jrjaB5c5lusWPRAtV3FgCjnJ/noCG1LJ07tLAzs5ThQfmvu5Ru1VCEWRN3a
	6wgvHNfuNJqL6VnuSO/eh0HLbfOjS3gYgh6psHTC12XzcjRcJG+XjN/bye5yG1ogTGw2EsjeA/d
	2gpWT9s0B8I=
X-Google-Smtp-Source: AGHT+IGUuXpTLMKIPyPN/4T1RaOT1aBqMghOF8MrGl17TV+ltTnO6Y+6WB4gfB3pJToSKmKJ0lSyEw==
X-Received: by 2002:a05:6602:1543:b0:855:3ed8:ee8b with SMTP id ca18e2360f4ac-85555c7a306mr338951639f.5.1739371840578;
        Wed, 12 Feb 2025 06:50:40 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed0e1746fasm845136173.89.2025.02.12.06.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 06:50:39 -0800 (PST)
Message-ID: <aa209ef0-bd9e-4e7a-8667-1be40ccbe28d@kernel.dk>
Date: Wed, 12 Feb 2025 07:50:39 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: pass struct io_tw_state by value
To: Pavel Begunkov <asml.silence@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250211214539.3378714-1-csander@purestorage.com>
 <8c21acb0-aee5-4628-a267-a4edc85616c4@kernel.dk>
 <b478f8fd-d43b-429c-aa6c-1b94951421ab@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b478f8fd-d43b-429c-aa6c-1b94951421ab@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/12/25 7:49 AM, Pavel Begunkov wrote:
> On 2/12/25 14:33, Jens Axboe wrote:
>> On 2/11/25 2:45 PM, Caleb Sander Mateos wrote:
>>> 8e5b3b89ecaf ("io_uring: remove struct io_tw_state::locked") removed the
>>> only field of io_tw_state but kept it as a task work callback argument
>>> to "forc[e] users not to invoke them carelessly out of a wrong context".
>>> Passing the struct io_tw_state * argument adds a few instructions to all
>>> callers that can't inline the functions and see the argument is unused.
>>>
>>> So pass struct io_tw_state by value instead. Since it's a 0-sized value,
>>> it can be passed without any instructions needed to initialize it.
>>>
>>> Also add a comment to struct io_tw_state to explain its purpose.
>>
>> This is nice, reduces the code generated. It'll conflict with the
>> fix that Pavel posted, but I can just mangle this one once I get
>> the 6.15 branch rebased on top of -rc3. No need to send a v2.
> 
> Hold on this one, we're better to adjust the patch, I'll
> follow up later today.

Sure no problem, it'll be early next week on the 6.15 front anyway,
nothing is being committed right now.


-- 
Jens Axboe


