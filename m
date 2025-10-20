Return-Path: <io-uring+bounces-10072-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CEC33BF2F22
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 20:32:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CAFE84E4CD6
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 18:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2561DE4E0;
	Mon, 20 Oct 2025 18:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KkBfKX5t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA0D1A262A
	for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 18:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760985164; cv=none; b=CkWde6yV5m2WqC/xhObp4KWHF7ED4szxH4cTVDqWNvPXzQbVPySYMD/yvzYWLGJbvBGPWptQd1LPcI1FliAbfynooIv+zsO+M8QFUltNnLOUt/jlw3h1VMM6b6JlGdHfCk64egA3VSdVRJMpNWS37Rbx/ZPou28y1QsLFrIOWFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760985164; c=relaxed/simple;
	bh=WmnsBf5aXBGvoqkvP8ZSKKKwb+uKFIR0cS+4dvymQbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XRQ9o9v8+11AJKVartXd3QkpcZkB25UhaMbK6461o0dudjiRgIdAt+eD6B/Yf6b0mEc68cnHOV5iCeibjLrlCM/HFNY7jO1ZVeHtt51lCJRAZwuCXnnWDgiNJYwHQz/Ag7u81MTfU3Lqv8aG0wrJmXZQn7eQ0EsNIniDPVPEfsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KkBfKX5t; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4711f156326so34046175e9.1
        for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 11:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760985161; x=1761589961; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DBdeuCJ2Ioyk+Uv8FbNSdv+gIwloNLsTARDLQcYJP54=;
        b=KkBfKX5t0KgsxRkKwCbDQ4GWq7h5e7rnhSa5SObaNRVEdXIad7fPlVTjhLYpzaikzP
         AaZ4NB3RsQNGSCpFAuxZBkpKXkZvq7V+HLmBUAFKbzmTwnNaDiWk7lwusBKQBaeqqMJE
         7PjrhG0AtvOoSMRAM9iBQG8Kzh89Zec55JJUGtyibft5Rm895P0A4lk14NPmxCQyf2fV
         bWcFhTt2/BD93Ve9QTCGwsS0lDAJxs0aBks+gVa91O1MIKvba57C0brKDDod3HTIHghh
         OjjU9z2+13LDmxrJOaiHJ3UxqS2UJwSL/5qjFJkLepidzGCBSJZX8uJ06MXxIGPTsWQ0
         WGMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760985161; x=1761589961;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DBdeuCJ2Ioyk+Uv8FbNSdv+gIwloNLsTARDLQcYJP54=;
        b=U/o7li6oUr/ICje36At3319yU+xLxCFnahFXQeZqnCnqjBWmI6PzWou6+chEgWk+gl
         voRh+rRtpWPWcSeMx62R6GOXNHuhQnv6oswwYhsj1SaZRDxCd2/T6vaWX2enFpjo6U25
         3pxXA9TF1UcH8nJnvU5GOPmuN48eYFfE9D2F1prSFFN4HDXsghYMnRl84bC0vXnQWU4Q
         jerFbTKp7iBYIvH9TIoZCYJx/rfIae2zRV6YVRT+/j/k5+bk39VhaHNymVaE9MZVYGKB
         JdFfHGX2w4W0blerf5gEfYnF2woeP6lcKwJaZ0hin0z+AibYHdondKY2V1AFtwP4YqYM
         Q9Sw==
X-Forwarded-Encrypted: i=1; AJvYcCUQkmGAJWUrdAOWx04vvGHxZy4wGtgMmFFLxjBW1MNUWpBIxTMxpeg52eN89nl9zWrvF/FzHGdUaQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx5iWmt1bvVVPoKGgRoAZxcbJeoel64fVcydEngCu+blcrjB7c
	L04Ihafjd1+6TRTyhs5trzzSLnPbk4jKX2wKx5pogJkWA1SmS7af+2TT
X-Gm-Gg: ASbGncs0HVc4W5iaVoVmhSVcc0fDa9cKXhg13qqg90EBFiXSzU4Q/UrA9X+q5gkyfAc
	OUvJQQ3ThzTRjvOsbF5ftjaDW+z4KcmGpmzwvWhDWLmpNkaIBEgqTwJDr5zm4zqLWub1E5DKnmb
	dOLUo9vTOqjsUTliChRWkt/iOB1XZCTtuI16CDzjrwM+wgWRUXyNCmhNERzch0TMiF6GtkigK5K
	cmSd91RLQkS6rBh93MTDLkgcBTrcgLCIQJAzsgwXdZCGLN09Z76UM+4L0MEKV2NVcw7QW9WAqkF
	1zTWZgCwbWnQgSVr5m4vCdAFFWiVSdc4Ubr+Vk7K18cPaW4xvUaj+KOitEDZIPyIl4R2u1+pFwp
	DhnA3vZFUmQMb1ivJ6Ft3djhaJjjsVC/4KJTAgN7PO+3F3HxVLvP960uTatoPoVW2mHzXw0OtNZ
	D6yjaHz6+goD05AE2o37psurQMO+gZ0YxK/KNybkgybTfkaGX+V58=
X-Google-Smtp-Source: AGHT+IF94V8MOhuTqy3nuqI89RdhcYEsvwnB0+acyIHMK8Yrm6kKtG7O4KM124QJ23XyDoximgiMUA==
X-Received: by 2002:a05:600c:3553:b0:471:a73:a9d2 with SMTP id 5b1f17b1804b1-471178a6484mr101244775e9.11.1760985160833;
        Mon, 20 Oct 2025 11:32:40 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47494ae5510sm1521305e9.3.2025.10.20.11.32.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 11:32:40 -0700 (PDT)
Message-ID: <57bf5caa-e25e-44e6-ba55-b26bb3930917@gmail.com>
Date: Mon, 20 Oct 2025 19:34:02 +0100
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <12e1e244-4b85-4916-83ab-3358b83d8c3c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/25 19:01, Jens Axboe wrote:
> On 10/20/25 11:41 AM, Pavel Begunkov wrote:
>> On 10/20/25 18:07, Jens Axboe wrote:
>>> On 10/17/25 6:37 AM, Pavel Begunkov wrote:
>>>> On 8/20/25 19:20, Jens Axboe wrote:
>>>>>
>>>>> On Sun, 17 Aug 2025 23:43:14 +0100, Pavel Begunkov wrote:
>>>>>> Keep zcrx next changes in a separate branch. It was more productive this
>>>>>> way past month and will simplify the workflow for already lined up
>>>>>> changes requiring cross tree patches, specifically netdev. The current
>>>>>> changes can still target the generic io_uring tree as there are no
>>>>>> strong reasons to keep it separate. It'll also be using the io_uring
>>>>>> mailing list.
>>>>>>
>>>>>> [...]
>>>>>
>>>>> Applied, thanks!
>>>>
>>>> Did it get dropped in the end? For some reason I can't find it.
>>>
>>> A bit hazy, but I probably did with the discussions on the netdev side
>>> too as they were ongoing.
>>
>> The ones where my work is maliciously blocked with a good email
>> trace to prove that? How is that relevant though?
> 
> I have no horse in that game so don't know which thread(s) that is (nor
> does it sound like I need to know), I just recall Mina and/or someone
> else having patches for this too. Hence I dropped it to get everyone
> come to an agreement on what the appropriate entry would be.
> 
> FWIW, I don't think there's much point to listing a separate branch.

I sent this patch because last cycle I was waiting for roughly a
month for zcrx to be merged, and hence I started managing a branch
anyway, which also turned out to be simpler and more convenient for
me than the usual workflow. Not blaming anyone, but that's how it went.
And there were a couple of (trivial) patches from folks.

> It's all supposed to go upstream to the main tree sooner rather than
> later, once it's ready. And since it's basically just you working on the
> zcrx bits, there's no risk of conflicts. If there was a conflict, then
> yeah we'd just resolve it and route things appropriately. But it also
> doesn't really matter to me what's listed in there, as long as things
> are on the list as well. And iirc the netdev side was the same, they
> just want to ensure they see patches for zcrx. For me, the entry was

Taking everything into account, I have no doubts what started the
discussion was purely about blocking my work, but I'll spare the
details from this thread and since you said you don't need to know.

> more about ensuring you get CC'ed on relevant patches.
> 
> Which is why I figured that you and the netdev side would discuss this
> and come up with an entry that everybody was happy with, then we can get
> that upstream.
-- 
Pavel Begunkov


