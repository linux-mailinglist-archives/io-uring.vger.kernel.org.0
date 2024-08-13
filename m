Return-Path: <io-uring+bounces-2734-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1796F94FAE5
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 02:59:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C7C8B21850
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 00:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8324680B;
	Tue, 13 Aug 2024 00:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="b/QoHjdg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77623AD21
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 00:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723510775; cv=none; b=mfJDIWXP6EaCgXNAWjwDZTdUyvemG9EkikMFOND7s1UOQAy00/0eEckyfKV0WGp7Vb1N7q0S8QY0lWtq06LS1QXHdbvFNfwkhaqS+UVv+LfYkQGPfcCj6hOpmD7hRFdYHv3pc8YeGmHDM6W2uEONm/toz8zor7vRmT/lhbEhQSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723510775; c=relaxed/simple;
	bh=g0N+btzTpkXchFvvvH84llxuH0/w47k+UL5fVn+KEjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jJEZLEBlRYEuh05lDQbtz/0USVW4/06jJwmBaSW/nsOfTnQ5u1yc1Kp3/OuduBFTVXhGDeKDhHN02p+l8z0I6KaE+K0BCFuPYkq/04j0latqDrKlXA0LnIzgavMRRCb5JUlHNX3/Mq5WbhgjP85SQf38pw5QYxzuQSRqEYEkRlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=b/QoHjdg; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2cdba9c71ebso982271a91.2
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 17:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723510770; x=1724115570; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vwyr4Pu0RI4SCg1K4MxYLvkzXZGHpeS+YGSQtgCsdrI=;
        b=b/QoHjdgPMh6DHMUrOb9/9dEbjl+63tJS1cC+Y0tXPvAcKcYbit6lDU+nWOCra6LAP
         DZL2sfo/EbrPQZ0yQgFkOOxgIj8N/D8QSbREmcyim2x7Aco/XzIt2nCGeYUDsZZbQRyK
         mov9/DqpkKfQoF6K+GUGIqjNWEsKvk5kPQRHkp6/aTWU4oh8CUPyPp5kXsvvvh1EbeMO
         Ri0pw3S1q2B6LP9o6e+U4TPpPJJW18C9Lpt/2gFCOvzSc5Jn3QwoRBdUUGqKdDEPCGyz
         IVwlLrcwZqdBQAHfXhigWpJBpxXneO1gNopcRCh9e82V5zcQIeJvGW4OnlYorZiF8OQc
         fnEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723510770; x=1724115570;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vwyr4Pu0RI4SCg1K4MxYLvkzXZGHpeS+YGSQtgCsdrI=;
        b=sQ6nKPz2SKMWzrbs25Wu16hTNT9f0RGwqXe7ZqIgGcnKvN9TtwX5A9/69uBCcObPPf
         4+//s5W+UeGHlSOq9dVh9DGE+LJxM4ByYBC2zhMC6h6s1irN+EaN03pm2TOYAVcqB/kr
         RQHHGqCEfuTfOjQMv0IG/9nbmRhnWJJUWcfvp+LmD22LDRdI8X4FQ0ieblk/Px58EJ+F
         Lwdebf25QoDQpFhBVmzY2bSFjIMWRIcfgkfgc6u10s/xFyVj1YOQG+hKMsR41gLYdoFa
         IhhS/xnvN0m3stOmRopt/7wYm3saAOctBNCetuZ4Zf5/dqjdPzgZihaPzpyGjnYJlvei
         Sptw==
X-Forwarded-Encrypted: i=1; AJvYcCUa0f5FJb09JjM9sPy+5uuBncrHvbgINpVCWU9K59NXi6Y0pmvKZckUciP0LbMQFXxwI3CIPMjuf5BwxxeJumKPa6GQXmHOVIo=
X-Gm-Message-State: AOJu0YwDSlQHRqq1jva1mxiVuOv1Pd6yyqxqPgy6b5b+gP/RkxYI3juU
	RvKvRTrX9UVzxsJnumNGnX3M/MttRfcqe0gNfTB0vaFXgkqiQ39X68a+6JoFWe0=
X-Google-Smtp-Source: AGHT+IG152Cv+aOfVb0epesdFoLFc1tcyPTdOZvfQBx5csrZoUp2Bn5nAlNl3sNWslT6V7wtw2JHxw==
X-Received: by 2002:a17:90a:db94:b0:2ca:63a7:6b9d with SMTP id 98e67ed59e1d1-2d3968f3b3bmr518269a91.3.1723510770007;
        Mon, 12 Aug 2024 17:59:30 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1fcec6b47sm5917833a91.13.2024.08.12.17.59.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 17:59:29 -0700 (PDT)
Message-ID: <78d5648d-7698-44b9-ab66-6ef1edee40ad@kernel.dk>
Date: Mon, 12 Aug 2024 18:59:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] clodkid and abs mode CQ wait timeouts
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Lewis Baker <lewissbaker@gmail.com>
References: <cover.1723039801.git.asml.silence@gmail.com>
 <98f30ada-e6a9-4a44-ac93-49665041c1ff@kernel.dk>
 <6ad98d50-75f4-4f7d-9062-75bfbf0ec75d@kernel.dk>
 <61b2c7c1-7607-4bd9-b430-b190b6166117@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <61b2c7c1-7607-4bd9-b430-b190b6166117@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/12/24 6:50 PM, Pavel Begunkov wrote:
> On 8/12/24 19:30, Jens Axboe wrote:
>> On 8/12/24 12:13 PM, Jens Axboe wrote:
>>> On 8/7/24 8:18 AM, Pavel Begunkov wrote:
>>>> Patch 3 allows the user to pass IORING_ENTER_ABS_TIMER while waiting
>>>> for completions, which makes the kernel to interpret the passed timespec
>>>> not as a relative time to wait but rather an absolute timeout.
>>>>
>>>> Patch 4 adds a way to set a clock id to use for CQ waiting.
>>>>
>>>> Tests: https://github.com/isilence/liburing.git abs-timeout
>>>
>>> Looks good to me - was going to ask about tests, but I see you have those
>>> already! Thanks.
>>
>> Took a look at the test, also looks good to me. But we need the man
>> pages updated, or nobody will ever know this thing exists.
> 
> If we go into that topic, people not so often read manuals
> to learn new features, a semi formal tutorial would be much
> more useful, I believe.
> 
> Regardless, I can update mans before sending the tests, I was
> waiting if anyone have feedback / opinions on the api.

I regularly get people sending corrections or questions after having
read man pages, so I'd have to disagree. In any case, if there's one
spot that SHOULD have the documentation, it's the man pages. Definitely
any addition should be added there too.

I'd love for the man pages to have more section 7 additions, like one on
fixed buffers and things like that, so that it would be THE spot to get
to know about these features. Tutorials always useful (even if they tend
often age poorly), but that should be an addition to the man pages, not
instead of. On the GH wiki is where they can go, and I believe you have
write access there too :-)

-- 
Jens Axboe


