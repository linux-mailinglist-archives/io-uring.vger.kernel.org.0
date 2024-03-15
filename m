Return-Path: <io-uring+bounces-975-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9FAC87D160
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 17:46:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C3841F25C8D
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D01D482FA;
	Fri, 15 Mar 2024 16:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DuXrsHhm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7246F3BB28;
	Fri, 15 Mar 2024 16:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710521110; cv=none; b=p3V8ogb+1VC0+ogDa9tAjWMDyjg/SsNZFqz1q/zFECdl2dNdyjhotG8A/ws0/+TZWp3uneT/clmLHAsUZX+VawCOzgUHiYcKVgle05mktA/x3n5cqWefgj9tOpxJ9yEhvDxSNJgNuRx2U5Sc9xHcSakh9GWaDMX3XA7P7XYKQbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710521110; c=relaxed/simple;
	bh=6ocWOhxuFBCbWoaCNynzwb5vX0ZTvIO65y+LKbV0DD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PHgo8W1tLZHBtf0nqnlQx0z0sRWRg2lFlTeBX5NKPhzQdOkXqUJGiKA2sv5U3SQ6Sq5svsobvjgCcTsq669Hhc+5WN8NG7CHDUzen6H5lrsEflc2jXhGPdZO5nsJJlUpPCkAhn0NWrhMMFkc2J6AkCkvp+z6BmY+J2TLRWBesl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DuXrsHhm; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-566e869f631so2699210a12.0;
        Fri, 15 Mar 2024 09:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710521107; x=1711125907; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Pn1N9hdh/92IjJvyEpoRwaBX67+5A1Da617ojNcO94=;
        b=DuXrsHhm0uQE0yeIqv7CBUu8OgY/YwcDswC64kKp3kK2XE2l+QXiXkhQwNZkQzHMJ8
         YQ6wGy7sg+BZ5Ue7rmyF74Qn9rTe1oOp89013UNYhlYsdzwBeo/oxt1qoKQ4bPDzVO5f
         qwANQ9M+A/enBrqS+QTbJbIEKCI5l0UNELJNRGaQdoNFyXobu6KpbMVY6ujiCH78k+Jm
         OxPunZuYmE+t1JgHQt5YAkkQWUtKlOxFyAxkNR+xMeQnAHH+xDdwZdExD9AEUtrMi8Ok
         OBD/b24suB20bjpGH1K8jsRrXnVldCs5cKcgSINGKEgrdNeNVe09Hj+oy6ZIfb1zPs0g
         5b1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710521107; x=1711125907;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Pn1N9hdh/92IjJvyEpoRwaBX67+5A1Da617ojNcO94=;
        b=XzQU7wAhEr6Nth3xI5Fw26Siv71MDvQITvWQDfS+STKJz0KiVD7HF6GLSIkWQ5Cgnh
         +81qBLz8u/ayYhWGHfGdiSGVZAfGopcSalmuqK5dRvrkbTwFLqVhlEx6+ffJYIc22O3h
         uNL1SzG4xg59W/OKo3foO/czl8PiY/9nXoYmtClUOKNa+Enr75WzQpBiUKsdZK0m2Fhp
         hIIynHTJfCTEw5FL/FoW8OyiLbaa3gbslcRBUMzHorc8rIgY3JIGZgXz7Es0JVSgdYmN
         2MkYLchuJm1lCarLqJ6JiUbHVHW7ymsEHHINbvvkcHKOoWoFDRfJJoB59ub5FKTZBAMQ
         7jcA==
X-Forwarded-Encrypted: i=1; AJvYcCW+sWGXv/XsV5E291JcNcE4nOYSb9SFfJ4fnfOVI8bdWAoMZfwqbCjq3NUWHsUN95IL0J0RuEdB0hkqd/Ox4W/+tMJXwqhrI1Q=
X-Gm-Message-State: AOJu0Yw0IDo3zcJD+TMob+dzgcIrsc8lfN+QRLwuuhYU7u4yhRYJtAFu
	TTUjrl/J2BlUwpJigK2QgRv15lMe4NSmOD2PHJJVEgGDyA0JeJnF
X-Google-Smtp-Source: AGHT+IG533g1xrlq+qyxGCNfLR+U3QZGsTLakzHI4bemWrpGt2WXan496MoA1lwDtMDi9pxIOV2iBw==
X-Received: by 2002:a05:6402:28cc:b0:568:b447:163d with SMTP id ef12-20020a05640228cc00b00568b447163dmr1564280edb.9.1710521106742;
        Fri, 15 Mar 2024 09:45:06 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id 6-20020a0564021f4600b005682a0e915fsm1825340edz.76.2024.03.15.09.45.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 09:45:06 -0700 (PDT)
Message-ID: <e40448f1-11b4-41a8-81ab-11b4ffc1b717@gmail.com>
Date: Fri, 15 Mar 2024 16:44:01 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] io_uring: get rid of intermediate aux cqe caches
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
 Ming Lei <ming.lei@redhat.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <0eb3f55722540a11b036d3c90771220eb082d65e.1710514702.git.asml.silence@gmail.com>
 <6e5d55a8-1860-468f-97f4-0bd355be369a@kernel.dk>
 <7a6b4d7f-8bbd-4259-b1f1-e026b5183350@gmail.com>
 <70e18e4c-6722-475d-818b-dc739d67f7e7@kernel.dk>
 <dfdfcafe-199f-4652-9e79-7fb0e7b2ab4f@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <dfdfcafe-199f-4652-9e79-7fb0e7b2ab4f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/24 16:27, Jens Axboe wrote:
> On 3/15/24 10:25 AM, Jens Axboe wrote:
>> On 3/15/24 10:23 AM, Pavel Begunkov wrote:
>>> On 3/15/24 16:20, Jens Axboe wrote:
>>>> On 3/15/24 9:30 AM, Pavel Begunkov wrote:
>>>>> io_post_aux_cqe(), which is used for multishot requests, delays
>>>>> completions by putting CQEs into a temporary array for the purpose
>>>>> completion lock/flush batching.
>>>>>
>>>>> DEFER_TASKRUN doesn't need any locking, so for it we can put completions
>>>>> directly into the CQ and defer post completion handling with a flag.
>>>>> That leaves !DEFER_TASKRUN, which is not that interesting / hot for
>>>>> multishot requests, so have conditional locking with deferred flush
>>>>> for them.
>>>>
>>>> This breaks the read-mshot test case, looking into what is going on
>>>> there.
>>>
>>> I forgot to mention, yes it does, the test makes odd assumptions about
>>> overflows, IIRC it expects that the kernel allows one and only one aux
>>> CQE to be overflown. Let me double check
>>
>> Yeah this is very possible, the overflow checking could be broken in
>> there. I'll poke at it and report back.
> 
> It does, this should fix it:
> 
> 
> diff --git a/test/read-mshot.c b/test/read-mshot.c
> index 8fcb79857bf0..501ca69a98dc 100644
> --- a/test/read-mshot.c
> +++ b/test/read-mshot.c
> @@ -236,7 +236,7 @@ static int test(int first_good, int async, int overflow)
>   		}
>   		if (!(cqe->flags & IORING_CQE_F_MORE)) {
>   			/* we expect this on overflow */
> -			if (overflow && (i - 1 == NR_OVERFLOW))
> +			if (overflow && i >= NR_OVERFLOW)

Which is not ideal either, e.g. I wouldn't mind if the kernel stops
one entry before CQ is full, so that the request can complete w/o
overflowing. Not supposing the change because it's a marginal
case, but we shouldn't limit ourselves.

-- 
Pavel Begunkov

