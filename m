Return-Path: <io-uring+bounces-7517-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72510A91D0C
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 14:55:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81C80167A67
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 12:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59383BB48;
	Thu, 17 Apr 2025 12:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ip3jTnVX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6B535979
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 12:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744894501; cv=none; b=sod/4CZ2XqEk61faDi2GnSIqUxsbdE4299We1D22vbUusc0kJ4bot7tqXL3BI7urFE/L2S/pwCojlZ0DCtgRC/17v1eWBPgvsyicgwBSLpKmtB8viCuFCccgFOrp9uusOQcGN+LQYWilPcDDdNWmqvFMoXvYvohlzesQIWd4/lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744894501; c=relaxed/simple;
	bh=oMT6XfQjZQAD1Kh+awkdswrM78G5USKeDbUubQpcEoM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pTNbIBiU1RglaQbrY9zp/nVMKEYCwHVnCardW12/0lpeSwnpCVALr25A7C9Q63Mh541XNzEIKqIPdT/HxKFjJI0q7UJYFm6ieqU+YCCl2xWlgSv8qD/cM005WhvU/8cKjxPbY48QHRe1SdWMAuiz1Haw/UWvt0AspS8LP5pSYgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ip3jTnVX; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e5e22e6ed2so1214033a12.3
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 05:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744894498; x=1745499298; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2KmhjthjhIhmUI0erOyZlQuygVfx1VkzuiKcQN+daVE=;
        b=ip3jTnVXbq/dGbwk2BNCRYaS9u9a4iMZAyEZ+4BwTMtuNymXu8Aghai+oQKg0v4tMJ
         X+167X+/rKBxh+40hU3y/iEk1RlBCTWCAd+cKGrEbhSahdAmQRbCn7762hUpDQwxxfw4
         I6gRfavgborPBQLgkq9PWSAPK0PJq9SRxCRw+kd5GokPW3y3ID0NNjXHOWX1FeUVxHHq
         77ndoVlrZlzC61EbuvuDfz0vadJ6vOElVCH1NIDSAji5GwY4rH4DdIvHUBGMQMCf32iI
         w5t+aLDJVgp48pHj+z8wLUnWKnKOIbMaUGKGdLYCBhuIrPkHqNbq04jdlpuRBqX/UY37
         3IXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744894498; x=1745499298;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2KmhjthjhIhmUI0erOyZlQuygVfx1VkzuiKcQN+daVE=;
        b=pDbRzS9u99Ub/uOGUvs/RGNteAHLBomIplE8K4ztc+Kfekul/Sff4amb8p2ytiet1H
         wwPegKJmxrbzje4y9HA2yZZbnLOYq8VFW1FEhLlwx/aN1CwuhH59DrNHmxRwGRhduZX3
         3XPVNS89jio7QqKOuOgfMrE7GGjgP9nTaU2f9GSCzcA0KRn8z+tt0mXmwVpGQI2h9XUa
         aQgcEBgv6qwFoRRDQbkNMW7EYIJuHjJUJeVNOZT1w8eioao3t8MfQS2cI289TCw5SBds
         clnVMBh0QFYs19PWEkcNT8v5j+wzIjOe18rFkvyeLuQ6tAc+x4xOLtm+2EvXtVQ1k2KB
         CIPw==
X-Gm-Message-State: AOJu0Yymlg94pB/qjcWHQr49UsxVsQXi4M9Tz4Y5X7U1xLruEjITasfD
	8Qyk1lZpnh6mAg0A+TLkTHudMBlZXoJWCEuasMkZe4nZQl6aelRzznqihg==
X-Gm-Gg: ASbGncvafwGnBgNWAW3dAn63ZKRn/vHAOJ2NQ5AQQpXfVwQ8HM8jYwTp+NH5tAFzb2B
	AYzwM6wys94lEpnGAj24yC2F/v/6dOPc2dvxVkWjc6RKDcR7smcJJdCLryfFARJTQFxAh68F26E
	cjZVhlakAW854vqU8xyvHgJf1TPExOWGMuwVXXJXFS5IiIIE0AYYQn7dAsrqzUF5KD1OXRsCLxx
	H7n/WBExwD3X3VjSOX5tMdNnU58E8V9UxhLJYXghxDtjckDHM9acgsBtCSrYaShBxHYwDIZpsyi
	8mS6xXfgG5MTlc3Qk0eR6Xk5Bo4pulnaeS1JKiIuWkM3B04798o9gQ==
X-Google-Smtp-Source: AGHT+IHaS9nO2KGQ7sUcLkw09UU6o+4x1oWyWuxhRlzroStm/gdvZPtsD9KmbgC2Ef7AkbxLTX8eOg==
X-Received: by 2002:a05:6402:278d:b0:5e6:17fb:d3c6 with SMTP id 4fb4d7f45d1cf-5f4b75dd00dmr4883017a12.25.1744894498034;
        Thu, 17 Apr 2025 05:54:58 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1e4? ([2620:10d:c092:600::1:f7d5])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f36f069d90sm10589486a12.42.2025.04.17.05.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 05:54:57 -0700 (PDT)
Message-ID: <ca357dbb-cc51-487c-919e-c71d3856f915@gmail.com>
Date: Thu, 17 Apr 2025 13:56:13 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/rsrc: send exact nr_segs for fixed buffer
To: Nitesh Shetty <nj.shetty@samsung.com>
Cc: io-uring@vger.kernel.org
References: <cover.1744882081.git.asml.silence@gmail.com>
 <7a1a49a8d053bd617c244291d63dbfbc07afde36.1744882081.git.asml.silence@gmail.com>
 <d699cc5b-acc9-4e47-90a4-2a36dc047dc5@gmail.com>
 <CGME20250417103133epcas5p32c1e004e7f8a5135c4c7e3662b087470@epcas5p3.samsung.com>
 <20250417102307.y2f6ac2cfw5uxfpk@ubuntu>
 <20250417115016.d7kw4gch7mig6bje@ubuntu>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250417115016.d7kw4gch7mig6bje@ubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/17/25 12:50, Nitesh Shetty wrote:
> On 17/04/25 03:53PM, Nitesh Shetty wrote:
>> On 17/04/25 10:34AM, Pavel Begunkov wrote:
>>> On 4/17/25 10:32, Pavel Begunkov wrote:
>>>> From: Nitesh Shetty <nj.shetty@samsung.com>
>>> ...
>>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>>> index 5cf854318b1d..4099b8225670 100644
>>>> --- a/io_uring/rsrc.c
>>>> +++ b/io_uring/rsrc.c
>>>> @@ -1037,6 +1037,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>>                u64 buf_addr, size_t len)
>>>> {
>>>>     const struct bio_vec *bvec;
>>>> +    size_t folio_mask;
>>>>     unsigned nr_segs;
>>>>     size_t offset;
>>>>     int ret;
>>>> @@ -1067,6 +1068,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>>      * 2) all bvecs are the same in size, except potentially the
>>>>      *    first and last bvec
>>>>      */
>>>> +    folio_mask = (1UL << imu->folio_shift) - 1;
>>>>     bvec = imu->bvec;
>>>>     if (offset >= bvec->bv_len) {
>>>>         unsigned long seg_skip;
>>>> @@ -1075,10 +1077,10 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>>         offset -= bvec->bv_len;
>>>>         seg_skip = 1 + (offset >> imu->folio_shift);
>>>>         bvec += seg_skip;
>>>> -        offset &= (1UL << imu->folio_shift) - 1;
>>>> +        offset &= folio_mask;
>>>>     }
>>>> -    nr_segs = imu->nr_bvecs - (bvec - imu->bvec);
>>>> +    nr_segs = (offset + len + folio_mask) >> imu->folio_shift;
>>>
>>> Nitesh, let me know if you're happy with this version.
>>>
>> This looks great to me, I tested this series and see the
>> improvement in IOPS from 7.15 to 7.65M here.
>>
> 
> There is corner case where this might not work,
> This happens when there is a first bvec has non zero offset.
> Let's say bv_offset = 256, len = 512, iov_offset = 3584 (512*7, 8th IO),
> here we expect IO to have 2 segments with present codebase, but this
> patch set produces 1 segment.
> 
> So having a fix like this solves the issue,
> +    nr_segs = (offset + len + bvec->bv_offset + folio_mask) >> imu->folio_shift;

Ah yes, looks like the right fix up. We can make it nicer, but
that's for later. It'd also be great to have a test for it.


> Note:
> I am investigating whether this is a valid case or not, because having a
> 512 byte IO with 256 byte alignment feel odd. So have sent one patch for

Block might filter it out, but for example net/ doesn't care,
fs as well. IIUC what you mean, either way we definitely should
correct that.

> that as well[1]. If that patch[1] is upstreamed then above case is taken
> care of, so we can use this series as it is.
> 
> Thanks,
> Nitesh
> 
> [1]
> https://lore.kernel.org/all/20250415181419.16305-1-nj.shetty@samsung.com/
> 
> 

-- 
Pavel Begunkov


