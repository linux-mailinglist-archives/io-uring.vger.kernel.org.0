Return-Path: <io-uring+bounces-6961-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06C5EA4F235
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 01:13:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2ACD93AA5B1
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 00:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A358F54;
	Wed,  5 Mar 2025 00:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kiyB8H2Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D938460;
	Wed,  5 Mar 2025 00:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741133595; cv=none; b=BUV/JcYLv2ExULzVCxtUc1eR3U/6JSp3AGdScmxfZKVuxjqcgOYla2hpwU05q5lanjWWQeI4qDjxD5IhrYBZoKCsvM7EFYQEj+tOAblgvc8aXyEKMGkkqqDl6ukbmeaE2Vhu/TRPcR0uT2aAiU/eBmVoRpXv4zjcwmmCMD0JKJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741133595; c=relaxed/simple;
	bh=/NMG+TkUsLf+Gpl4yGEpk6rCebR2sm8ZJtsrneu+iSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aKE88Iuz/Wghbab2jBjoFFOJX3FCVi13DZmmRU/e5RcYZs1NmqKicX1LI0L0yk4rw4ewMkI1LJHJvckIR5w4cYZmWua3GWhq0OCl0uJmCw++q4vX9UXTyoofVazxsmTA5DMdjOuA8Ax5QxMd3H+09GASQ6+pyQEX7I2VridTA+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kiyB8H2Y; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-439ac3216dcso42332925e9.1;
        Tue, 04 Mar 2025 16:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741133592; x=1741738392; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZGDYWToi51HAr4FUfzKygqXeMjBB7qFkR/KOntX10mk=;
        b=kiyB8H2Yl3AeBHBL2H0pyTKW27AIATBagHL03R9A95UTOdHFdu2Sy3L6brYFb2hxo6
         ExkmdA+iy8M0SekMekexP15Rubnrcv9biWGriDXQMF0T+8Ji6BF/uGfCp5WZx0UTvMYC
         vkWwdEFsveEZyfJR0Zxw7BMZNn4mq7Winx5fZrlA0rqpxuD4C94vtNplVqfUaqJ2kTqh
         m42Lfa1vPBV0ubbREgmYh8+7LJb5mmchadp0PBSsEWstCpFppqSGCUvF8DCul0hi/tiX
         JY6b8vQuFaJdXsUQCpKYl40sFdEb+yDOzK27YDo8WI1k7+jOZqERxTNXW0tVmgBPsWW9
         ElWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741133592; x=1741738392;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZGDYWToi51HAr4FUfzKygqXeMjBB7qFkR/KOntX10mk=;
        b=Jl1SQNONIL+ma+6UC6dIfxrGUSewVvJxIy92aSju8QwSI21waTwsXLQh4Slpvsx57I
         Yi1/dkCQNfdXJ1tAVWSXICeE2y8cuQ6TFLNzQRfPm/ymsks4j6e+LshvbsrVCFXZfyDU
         /rJlCZJRSfTpN9bf1RpB6ArGRT6S5XwKEbmrKNvEdK9qZTZpXKGg95oigXRJa1hXjCXk
         4V3wlDn+EaSNdVDRdWSBMLQY9eqVduxM2dEQKlfZ48n/i7OJj2HI8yTibvKCli9VABJO
         wt4XD9jF5TTnqYKKRkP1Ky/YhlewmCvnxfVb0kko5a1K/3hRgm3uDHuWVDqVMlntSihq
         NB+g==
X-Forwarded-Encrypted: i=1; AJvYcCUCIc4Qy9cdfivXkfDvamYSJ7+XrZ4RVZyMMal2e3smNwXTxQqEAtnaO7y73SeZOT6VY9y3qeTwutD3uaGUmQ==@vger.kernel.org, AJvYcCUnVWSZE1RsLFijOsBsAel/PYHlv27Sc6iwO6ypx816omFOPfHHxu8LSNF/sdyvhcV5k8u47sOoADHZ@vger.kernel.org, AJvYcCXfOr2ZgHMQZjptJ3ynZx+fJg0NGAgM7JwJlAeiGd9b132IJVF4pgprR5Ufb1mN7KbX5dUaEldFGg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLjizmUrMsZvow3OpfxbwKPW3Tkl3NocVOb590pg/f+GA4V++w
	SOrWZMOgpqvQG5JYmccWLne7P+IlueH+sreRoYquj7C60p5QKA3r
X-Gm-Gg: ASbGnctNjDOqG/awD/l4CtDXIziUVoJmBmqYitIaLsEzUxHj69a1IO5bnGCb2EzJFVu
	F2Fm5AW0cRos9C9KO4y2yDQsBsj6DGR3ejcuknHOnGXL09H1Tv+k0wwD+96XfujPzJpESanDBji
	PHDI7v2fwroj7arqfGrlTPg9CyhddHt+Wnh9Y/b05GWEuCh9+fgLWjAN9Zt3rd+RjUqBjZnddXD
	UaKczydmO7vN6LyNzTP7X6cfMgtrwC51LVRxt4YZ9SibOyKS5tO9i3Aj1Ak0fZydTPUIxGSLOKN
	M744dOJ5VYP5pm4hU28Ogpzj/MNtLYo8AP7RfZe+SJPacH75E0/hWg==
X-Google-Smtp-Source: AGHT+IHdwHCN+ZucN0bMC4qc13SbHe9Zn6LvULS4Ryq2FWrWeBIMGNbgjZRKOz8dtja5liQt92OwGQ==
X-Received: by 2002:a05:6000:1562:b0:38d:e6f4:5a88 with SMTP id ffacd0b85a97d-3911f749c86mr573478f8f.12.1741133592112;
        Tue, 04 Mar 2025 16:13:12 -0800 (PST)
Received: from [192.168.8.100] ([185.69.144.147])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e4844514sm19181494f8f.76.2025.03.04.16.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 16:13:11 -0800 (PST)
Message-ID: <0113b102-2bc9-4f0a-817b-54a6f2fe0a3c@gmail.com>
Date: Wed, 5 Mar 2025 00:14:19 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 wu lei <uwydoc@gmail.com>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
 <Z8cxVLEEEwmUigjz@infradead.org>
 <1e7bbcdf-f677-43e4-b888-7a4614515c62@kernel.dk>
 <Z8eMPU7Tvduo0IVw@infradead.org>
 <876fa989-ee26-41b3-9cd4-2663343d21f7@kernel.dk>
 <Z8eReV3_yMOVOe3k@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z8eReV3_yMOVOe3k@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/25 23:49, Christoph Hellwig wrote:
> On Tue, Mar 04, 2025 at 04:43:29PM -0700, Jens Axboe wrote:
>> On 3/4/25 4:26 PM, Christoph Hellwig wrote:
>>> On Tue, Mar 04, 2025 at 10:36:16AM -0700, Jens Axboe wrote:
>>>> stable and actual production certainly do. Not that this should drive
>>>> upstream development in any way, it's entirely unrelated to the problem
>>>> at hand.
>>>
>>> And that's exactly what I'm saying.  Do the right thing instead of
>>> whining about backports to old kernels.
>>
>> Yep we agree on that, that's obvious. What I'm objecting to is your
>> delivery, which was personal rather than factual, which you should imho
>> apologize for.
> 
> I thus sincerly apologize for flaming Pavel for whining about

Again, pretty interesting choice of words, because it was more akin
to a tantrum. I hope you don't think you'd be taken seriously after
that, I can't, and not only from this conversation.

> backporting, but I'd still prefer he would have taken up that proposal
> on technical grounds as I see absolutely no alternatively to
> synchronously returning an error.

The "You have to do X" hardly reveals any details to claim "technical
grounds". Take stable out of the question, and I would still think
that a simple understandable fix for upstream is better than jumping
to a major rework right away.

>> And honestly pretty tiring that this needs to be said, still. Really.
> 
> An I'm really tired of folks whining about backporting instead of
> staying ontopic.



-- 
Pavel Begunkov


