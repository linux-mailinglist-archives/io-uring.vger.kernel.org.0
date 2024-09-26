Return-Path: <io-uring+bounces-3317-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 756379879FC
	for <lists+io-uring@lfdr.de>; Thu, 26 Sep 2024 22:08:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 256F4283A4B
	for <lists+io-uring@lfdr.de>; Thu, 26 Sep 2024 20:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49507156256;
	Thu, 26 Sep 2024 20:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iOzYRWUr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878931BC58;
	Thu, 26 Sep 2024 20:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727381317; cv=none; b=TYJCALgDCxRXkdTKF3WaVZO2p8NfrHOoM9zD6sBSbUSGpPfla7EZCy0WZY8W/OwK+imrUBHjmSgG5TCMmYBDpstBb7sAmMy2zMi2YN4dAFeWlkM0uqOMD40O7fs3Dj88A+dfthQhzBupBiKo6CavTypYI3aXfjb5PNYZvEmOINk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727381317; c=relaxed/simple;
	bh=1GbYnWKzSVy3cpllGDN6AI05mWhQlZ4Y15ZaoU/FG38=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rWxtmK169+IkduK6MOZ3rnKecDwwXJNAT8oRGqUGkTG8vnGjPjwkNlRNsWmuIgbTeJ3lrXWxDegP3KQzcwgTMGB0h+8KBVzzHqAURedGAAyRhaviOijINMSS7Ae7P/ErJl/xsJh8T/9lPcDB4aC4pozxPBpthwcbpdF0SNv2QgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iOzYRWUr; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42cbc38a997so9331635e9.1;
        Thu, 26 Sep 2024 13:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727381314; x=1727986114; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qja+XDs7guUN35rttc9FL0qVA6mpRjfv1Lp+wNX5FBc=;
        b=iOzYRWUrZX/gQ+Ky65JvL67ZlkB23Xv1UxEvhnal0BpGjNgZYwhV3j0SDS0UxZPlHV
         JOARx0fec73zqQMbnUPpjZHMgYMk7Ij7PDvPnhOU75dTQ/C9ctQrRbZUxCzM9T0isam9
         AJ+qwX6MURGKpYcHUkGe9uBr7IU/LRvp0x+dTtB4/ruzJc7Zgi3Mo6Mm+F0WKxSxkPtS
         Uu/bwjpL1+SRBVFxmwnk/LLPJY0k3fS0B3a/U7Tx+19/MbBDARL8s3ObNzG//KnWzH3I
         0BpFVTQUyL0BdxJTnz2BAX/KFN34bzahXLKQ6gEPOYg0xkm9wakQF7bom2Po5JG34LeE
         Eavw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727381314; x=1727986114;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qja+XDs7guUN35rttc9FL0qVA6mpRjfv1Lp+wNX5FBc=;
        b=Kui14rgESh6fkxC2iCiFwgAa8KfQn5299iz/qHALnfXan1M2tKGSHBmi5k6NXcL0Px
         BcEKWWXYGakYCxyfBw2QjHpQoagruYtKa3f0tkqZTMapdZeEjxlTwXJ7eqCsS57GOa5Y
         hR0C5m7e6Gufa9EvoMw2QCLlrQMQWe5mPlw6mVf5yhwVnRC783nZGj+L/g2zUXL3mlcU
         W+9YlQ08KZ/Y66caCRSf+j2s2oBhI9t6PpxZD4zHqKbV8WwlaYbG6WToFkHa0aBYG9D1
         KA7uwjztu/V8cEO0L6vM9LtVOw5/gdx0uGjsVgSWLK8NjNoau+Bmb4JSubq7QQ+vuifr
         m9SQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1EHBejFXnY8VQ0Zl+betPoYrDfxCGfT9pMFi04FKGP51BetLqLWokvW2rYSSUQoTod/VqnSaXsqSsXMI=@vger.kernel.org, AJvYcCWTTriTI3KLDW7r4PE7Lt93ys8Jgm4b7aoGsmhuUsR8jGgBZxKvMwZOptN1oIH5NrDAfNa0n2qgQ9Hh7f880g==@vger.kernel.org, AJvYcCXhfW/FfkfwCE2sprmu3SGL2bOA5Xwmzr6/w1Dltq+dkLQ02ZNY6M2RZ6cQwloDi6WrMcu2yAqv8w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYUZfPzb+PvKAixO5A7UYSFWWrKtjnVetgzrsGIbF7vC7wBs4k
	gQ3pWG0pFQUVpoByKj9JpzgYzhcmagJ2Ma0vujsSyQXx31LOqqCC
X-Google-Smtp-Source: AGHT+IECVBMYxZNk/vP2MiJPkmrQ4JB7C0Ivw5Fl0+CKBMqRmr9TgnFrLLY2uS80X1AGnQDRPQSYBQ==
X-Received: by 2002:a05:600c:5903:b0:42c:b7e1:a9c with SMTP id 5b1f17b1804b1-42f58bd7a9dmr3414365e9.5.1727381313633;
        Thu, 26 Sep 2024 13:08:33 -0700 (PDT)
Received: from [192.168.42.227] (218.173.55.84.rev.sfr.net. [84.55.173.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e96a56fd1sm54617485e9.48.2024.09.26.13.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2024 13:08:32 -0700 (PDT)
Message-ID: <3f4b4b60-d9f7-4dc7-9045-d41a560e2ad3@gmail.com>
Date: Thu, 26 Sep 2024 21:09:13 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] io_uring: enable per-io hinting capability
To: Kanchan Joshi <joshi.k@samsung.com>, Hannes Reinecke <hare@suse.de>,
 axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
 martin.petersen@oracle.com, brauner@kernel.org, viro@zeniv.linux.org.uk,
 jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
 bvanassche@acm.org
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
 gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com,
 Nitesh Shetty <nj.shetty@samsung.com>
References: <20240924092457.7846-1-joshi.k@samsung.com>
 <CGME20240924093257epcas5p174955ae79ae2d08a886eeb45a6976d53@epcas5p1.samsung.com>
 <20240924092457.7846-4-joshi.k@samsung.com>
 <28419703-681c-4d8c-9450-bdc2aff19d56@suse.de>
 <678921a8-584c-f95e-49c8-4d9ce9db94ab@samsung.com>
 <cb3302c0-56dd-4173-9866-c8e40659becb@gmail.com>
 <8665404f-604e-ef64-e8d7-2a2e9de60ba7@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8665404f-604e-ef64-e8d7-2a2e9de60ba7@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/24 14:21, Kanchan Joshi wrote:
> On 9/25/2024 5:53 PM, Pavel Begunkov wrote:
>> On 9/25/24 12:09, Kanchan Joshi wrote:
>>> On 9/25/2024 11:27 AM, Hannes Reinecke wrote:
>> ...
>>> As it stands the new struct will introduce
>>>> a hole of 24 bytes after 'hint_type'.
>>>
>>> This gets implicitly padded at this point [1][2], and overall size is
>>> still capped by largest struct (which is of 16 bytes, placed just above
>>> this).
>>
>> For me it's about having hardly usable in the future by anyone else
>> 7 bytes of space or how much that will be. Try to add another field
>> using those bytes and endianess will start messing with you. And 7
>> bytes is not that convenient.
>>
>> I have same problem with how commands were merged while I was not
>> looking. There was no explicit padding, and it split u64 into u32
>> and implicit padding, so no apps can use the space to put a pointer
>> anymore while there was a much better option of using one of existing
>> 4B fields.
> 
> How would you prefer it. Explicit padding (7 bytes), hint_type as u16 or
> anything else?

Explicit padding is better than the current version. Ideally,
I'd like the new fields gone (e.g. if it goes in the direction
of per file hints) or prefer to minimise the size and make the
leftover padding reusable, but that depends on what the feature
needs to be extendable.

And what hint types do we expect in the future? Another question,
don't we want an apui that allows to pass multiple hints? Quite
similar to what I asked about "meta" rw, and it might actually
make a lot of sense to combine them into common infra, like what
cmsg is for networking.

meta[] = [ {INTEGRITY, integrity_params},
            {write_hint, ...},
            ...];

Even though an actual impl would need to be a bit more elaborated.

-- 
Pavel Begunkov

