Return-Path: <io-uring+bounces-2736-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10DD294FB17
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 03:32:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96911B21894
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 01:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C1711C20;
	Tue, 13 Aug 2024 01:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fwk3tfvL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94B21860
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 01:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723512744; cv=none; b=GAaMid7XchRn0fCa+ksg8mFtanD/PIuyL25U49U23tx90l4Aw3iVtMNEVgkIvKkz0XCrXTkg6gCDKvvTTE8xALxhVlbYRN8OfJvXSsBGk3ZKk3ypov4dvyZecrUkPSoLjjsJ2KuTEHNp7Ll6YkCC2/ASqefsbjKJXiTEn1313ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723512744; c=relaxed/simple;
	bh=ZmpJDs+GO4HyzxpGvuhirOhN8h3kO7/TTwgA75v8eBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yv+Yhpqeb29GdpldtmW4rDuIJkqpMCmF+QwHooqnDTBD/p5pkaVP2K+Ik1mGCYJOnlyNuKlbjlVtWMFZpaSj7hrnY7Va8xNThL3+aFMS+TnMejGCizUY1jRoDeQlrSV70pU03er7nw95+l42jkEq79nQvikskP7pQAemVE2b1gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fwk3tfvL; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3685a564bafso2256030f8f.3
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 18:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723512741; x=1724117541; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+AYxU8poIp+07/I9u7ymOSRafGNyZnPLf2rHog/ZhYc=;
        b=fwk3tfvLeNWvTCp3arh2g9dx3fOIy3ELry+aRZYg2kK78O+TSCDrh8YWDGDbp/ZHDm
         K8paK4h/DG+oy2Spd6B9CLbSmdh8oGVL5NLcVGf2tSkvEV06OxDJL1ekAMHZumntghf3
         aSeXdXtHw32xU950wNPtfOBS1K1swnDQOI86BAuAp6T42KjnQBBvUiOTU2ZyZJTwZejf
         7u8etFIUrKwoPEa9/Qjzu6+0mRjDFT5FO6tOPmjc4T3WeDYRdWM+KCEdYGvqZlokTfsL
         Q1zHRNXhWQFOPZQRz/EGrNXsqY/J2UxMtpZNBn4A427IDiZ90e9jz38xi7cK5FAOvzeV
         SQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723512741; x=1724117541;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+AYxU8poIp+07/I9u7ymOSRafGNyZnPLf2rHog/ZhYc=;
        b=Up6sJVxdBMSjRZnsv2rwWSUM5HT/qMnf+SE+7ji11eKWVcsy46DAJviFEdf6kfas+1
         2z9JQLxHCH/eZiE1ybInPuW8IhQUxjTNqR3mgnsGT2UxzwPJNPIuEHQiKOovIzntm5aA
         dlV/kH+TasulBvdA6cJF2iAdu0KJW0q0w/fCYtee891b3fGdGeqbVfvpgnLkmUZhN0R8
         m9jyh3R52yUSciYpskCqWfE+R7o5PAMYRCUen736p+I8LNj/6XFlKNXujG14SxMZEGIT
         L48/kkDf51eADucEs5Z7odYo5GB/5rBy3EfUspzChqrF8YdoHG5TdKliFwC/eKT/aGEg
         6wVA==
X-Forwarded-Encrypted: i=1; AJvYcCXDHYEgPKBUciYyemKwca3W5TBsbJH9hjvTrlnNepZWolRB1TNxr0G53Ru0CnTt3IoCik8IbQHqyogEu5AQniT73Dcz7hwdgZk=
X-Gm-Message-State: AOJu0Yw3xjo+8Cxa6HRO+va0KGtLhGQq1iC1uPX9fdhao8+hHfQCQZ+j
	bJN6I5yBMjJWtN2MtI7vGh39vh5TqpgUPOA8hf6hfGjreLSWWGhK
X-Google-Smtp-Source: AGHT+IEbPWiuaUIw1hMa7mRWXmyQN7sI9nNmGT0zH7Em1Qal/CIoTeyLzA/Vt+5//rBKvCq/QFsZ2Q==
X-Received: by 2002:adf:890a:0:b0:368:327c:372b with SMTP id ffacd0b85a97d-3716ccef022mr1156128f8f.19.1723512740857;
        Mon, 12 Aug 2024 18:32:20 -0700 (PDT)
Received: from [192.168.42.116] ([85.255.232.227])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429c751a547sm120275885e9.23.2024.08.12.18.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 18:32:20 -0700 (PDT)
Message-ID: <0b661e9c-1625-4153-93b8-d0e03fea81dd@gmail.com>
Date: Tue, 13 Aug 2024 02:32:49 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] clodkid and abs mode CQ wait timeouts
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Lewis Baker <lewissbaker@gmail.com>
References: <cover.1723039801.git.asml.silence@gmail.com>
 <98f30ada-e6a9-4a44-ac93-49665041c1ff@kernel.dk>
 <6ad98d50-75f4-4f7d-9062-75bfbf0ec75d@kernel.dk>
 <61b2c7c1-7607-4bd9-b430-b190b6166117@gmail.com>
 <78d5648d-7698-44b9-ab66-6ef1edee40ad@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <78d5648d-7698-44b9-ab66-6ef1edee40ad@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/24 01:59, Jens Axboe wrote:
> On 8/12/24 6:50 PM, Pavel Begunkov wrote:
>> On 8/12/24 19:30, Jens Axboe wrote:
>>> On 8/12/24 12:13 PM, Jens Axboe wrote:
>>>> On 8/7/24 8:18 AM, Pavel Begunkov wrote:
>>>>> Patch 3 allows the user to pass IORING_ENTER_ABS_TIMER while waiting
>>>>> for completions, which makes the kernel to interpret the passed timespec
>>>>> not as a relative time to wait but rather an absolute timeout.
>>>>>
>>>>> Patch 4 adds a way to set a clock id to use for CQ waiting.
>>>>>
>>>>> Tests: https://github.com/isilence/liburing.git abs-timeout
>>>>
>>>> Looks good to me - was going to ask about tests, but I see you have those
>>>> already! Thanks.
>>>
>>> Took a look at the test, also looks good to me. But we need the man
>>> pages updated, or nobody will ever know this thing exists.
>>
>> If we go into that topic, people not so often read manuals
>> to learn new features, a semi formal tutorial would be much
>> more useful, I believe.
>>
>> Regardless, I can update mans before sending the tests, I was
>> waiting if anyone have feedback / opinions on the api.
> 
> I regularly get people sending corrections or questions after having
> read man pages, so I'd have to disagree. In any case, if there's one

That doesn't necessarily mean they've learned about the feature from
the man page. In my experience, people google a problem, find some
clue like a name of the feature they need and then go to a manual
(or other source) to learn more.

Which is why I'm not saying that man pages don't have a purpose, on
the contrary, but there are often more convenient ways of discovering
in the long run.

> spot that SHOULD have the documentation, it's the man pages. Definitely
> any addition should be added there too.
> 
> I'd love for the man pages to have more section 7 additions, like one on
> fixed buffers and things like that, so that it would be THE spot to get
> to know about these features. Tutorials always useful (even if they tend
> often age poorly), but that should be an addition to the man pages, not

"tutorials" could be different, they can be kept in the repo and
up to date. bpftrace manual IMHO is a good example, it's more
'leisurely' readable, whereas manual pages need to be descriptive
and hence verbose to cover all edge cases and conditions.

https://github.com/bpftrace/bpftrace/blob/master/man/adoc/bpftrace.adoc


> instead of. On the GH wiki is where they can go, and I believe you have
> write access there too :-)

-- 
Pavel Begunkov

