Return-Path: <io-uring+bounces-9603-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E977B4636E
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 21:18:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1FB2A06D1E
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 19:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E769315D5D;
	Fri,  5 Sep 2025 19:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cdFQwwZi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93857225A29
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 19:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757099786; cv=none; b=tspEVQeLjC6DoBL8CrByFbFEjZvOfWVstzmsUljjFXt8IMAx87wD2MCa4HlCKrEt/JjZPJtHx8cl5ixN5rmSqwa4yBtQQ++k0oHOpBGe/Hb5uY5eqO+tuL9QkOzqoSymowgtnBlZm/z/EFBSqh9NDs9gSVP/ZRuopKObd4pWNDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757099786; c=relaxed/simple;
	bh=l+eIAbchEH1foTT9oClPfD2ccD3oLKevpTByElW1z4k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QS4a+IE0raCSYlmWHJjP2EMTkVKfNd4M8BDW5biTIV+uTOMkqI39IdAq1DpgbLeKG83tI53UZZtGf6elXUHG2TUbUFg+tpVpS6IsGYu+rGlKmLx2ssc7AmSqqBW0OoeC1EDNaiTcZ6kmXvqFGg0uRb9VRnVFqAO3kHyHuvcQCD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cdFQwwZi; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-723960ded6bso26792037b3.3
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 12:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757099782; x=1757704582; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2FvVjSd+gjkzhI4BuKsqLq/aKkbLRey2znFDsvr54js=;
        b=cdFQwwZiI5f3LAUYlwgBHc13lafN1V99udRO4iABnKSA/VI7+oRLUqmbzD0Grh+2E0
         Ka9ry8jQZEJGoQmN/bAVqX0c3iQoo7e1y6wdoEYCWGY7o4hfSB5JB5ZxGavJAMfpuj95
         Kj66Yf5inf2RJGdr9mk9C6EPSScYsXk6efXyMoPGf7Ebq7mrfDrBV7oDv0uEn6tpfp8S
         n7dqLXcDKEm1ESmRqAbEAWwwK3gmxoZu2eYLFnmoKgaVuDRW6Xw6WGs1/nXg4z1GxlP7
         xsyuO+0kEzKng10N5AnQ28CSXGV8Y3yvxL4c0XzvwhYQEDMDyEqTgKhGJIpJrDSHdsPY
         nPzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099782; x=1757704582;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2FvVjSd+gjkzhI4BuKsqLq/aKkbLRey2znFDsvr54js=;
        b=XGSUW2qPMtAE7Hz6Dl7BKxSbltVWuQ94Mb+YcHudlh68FF2IY0J27B5vsXOmuBaLTl
         YydPzKzBNbllKL+EEvvh6+RtWx7n9pEwlEpcwFkFegDHUgvmRW1LSBWD7On42tt0qBnB
         bYTDHj0XunzRCG0rwrI5xqjXLsN24ByuJTG7QDDpIZZId1Ry1HZx+E94J3C30ajSk4B6
         /5LlOfVcn6chL8Z8+NMq8bGSG2zqUe1vHq03RYkPkF+1xrUMFUp9OZ3a8gG7Hx0J0qxv
         6PS83O97gvsY4CxoTZUkjWU9/T4F0DVIX1cAOjrFonUixyCEgd1sL+VVdIEcxpQ29IKx
         97mQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3CZbvF23H/L2khg3rRBtXba7SgjnjYPWXKuC6VqSCJ+smBEIPQDmiq4YU48LLZ/bG2/E3UXSV8g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKg8asYyou9snqLHYjWEWXQU+O3BFefXbGDcjPqap86Qm0AtVC
	MQMd7IxHqR2ldn6XKAVefTT4TlHsVeckMaFeFivy8R/ayv8IBcyJuBQOa+PYQOq16Ps=
X-Gm-Gg: ASbGncvWlP5WyuELSs/pb92LymP8PspJjSQVbUvzBoxn3WF3icpdPJWic+rP2IG7FX6
	SVaEm4vor30i/MY7nVcGN6w0JhjL5RxGszCMEztvJinW0UBimgOLD3lgz+5PETPPUKBe+71xmjt
	ubt2Hjsvt9C2dhwDC65MxVxmP+kunemUbI/qEIh96VbHPHq8qnigFV23haGVnd8X+sAdVKIuowN
	zZ3SMohm7pp2SmiWXSkPftyT+MyYwK9RL4Iqkv8GmCqiweVND9YWc7MbjlqPQga/OZuAykIb1iK
	YQNLSB3We1jYHmGdZAQJJ6muxo78wk49SAqvSVcvVAglE8Fk68JkdN0Gy/n1xPdZQb3lpJsSFGx
	0ykIIuwsiDEx0JevXg6s=
X-Google-Smtp-Source: AGHT+IEzAVa+gSgSYDoekwHWXknUw2QfU7BZlk9cGb03baNQFJ4Pu294FqXRa4sPu51wBXkpLOy49w==
X-Received: by 2002:a05:690c:30a:b0:71f:a867:3fa8 with SMTP id 00721157ae682-727f3686507mr54967b3.20.1757099782229;
        Fri, 05 Sep 2025 12:16:22 -0700 (PDT)
Received: from [172.17.0.109] ([50.168.186.2])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-5ff8555d262sm2742927d50.2.2025.09.05.12.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 12:16:21 -0700 (PDT)
Message-ID: <18e33aa8-34a8-428e-bff0-ec6839a5028a@kernel.dk>
Date: Fri, 5 Sep 2025 13:16:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 io-uring <io-uring@vger.kernel.org>,
 Konstantin Ryabitsev <konstantin@linuxfoundation.org>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk>
 <CADUfDZr+pvC5o-y2f1WqwyxButkTN2Lesu0Ya5qrg2nVXVF9pQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZr+pvC5o-y2f1WqwyxButkTN2Lesu0Ya5qrg2nVXVF9pQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/5/25 1:13 PM, Caleb Sander Mateos wrote:
> On Fri, Sep 5, 2025 at 12:04?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 9/5/25 11:24 AM, Linus Torvalds wrote:
>>> On Fri, 5 Sept 2025 at 04:18, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> Just a single fix for an issue with the resource node rewrite that
>>>> happened a few releases ago. Please pull!
>>>
>>> I've pulled this, but the commentary is strange, and the patch makes
>>> no sense to me, so I unpulled it again.
>>>
>>> Yes, it changes things from kvmalloc_array() to kvcalloc(). Fine.
>>>
>>> And yes, kvcalloc() clearly clears the resulting allocation. Also fine.
>>>
>>> But even in the old version, it used __GFP_ZERO.
>>>
>>> In fact, afaik the *ONLY* difference between kvcalloc() and
>>> kvmalloc_array() array is that kvcalloc() adds the __GFP_ZERO to the
>>> flags argument:
>>>
>>>    #define kvcalloc_node_noprof(_n,_s,_f,_node)  \
>>>       kvmalloc_array_node_noprof(_n,_s,(_f)|__GFP_ZERO,_node)
>>>
>>> so afaik, this doesn't actually fix anything at all.
>>
>> Agree, I think I was too hasty in queueing that up. I overlooked that we
>> already had __GFP_ZERO in there. On the road this week and tending to
>> these kinds of duties in between, my bad. Caleb??
> 
> Sorry, this is my fault. I misread the code, the __GFP_ZERO does
> ensure the correct behavior. kvcalloc() might more clearly indicate
> the intent, but there's no bug. Apologies for the hasty patch, and
> agree it can be dropped.

The fact that there isn't a bug in there in the first place is good
news, so no worries!

-- 
Jens Axboe

