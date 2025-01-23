Return-Path: <io-uring+bounces-6092-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 342EBA1A664
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C6EF1886125
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D6120FAB7;
	Thu, 23 Jan 2025 14:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sEtPXEla"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4323121128D
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 14:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737644335; cv=none; b=gebiU1V4A8V6l/bgrqYcLf5vPlTtlx7bCG2eMX3DVyDyxQIVCPEIx5wy2/wAMvuJVe3saWQE69Zh4VJli2f61heZ5yA3dceYjFlnrz7CM2TM9POHHiXiRW12NToooI8g39aAGFzLX4AaTorvEQyXi+48+Ohmoo85w9bGba4AVbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737644335; c=relaxed/simple;
	bh=wBWEJzJyycm55nVaBbT1C18Z9DsFALtgL+R2sfxgTj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Au4C/PEtDL6CEZZXlkKdszrXN5SXDJD5Cfg1FfKS4egq46X329nn307ftgqQ9jraAJhdc62TLZUHhck5v+UAYQWrdy+Af5G7yAM/kCYUjVmGZa77Qjr2wjwP9Vv6WV9Ov0hUPhrwBGPKeTEn+bGk/a0vEmB60d6yFLjP5sLsq0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sEtPXEla; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3ce4b009465so2487135ab.0
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 06:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737644332; x=1738249132; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mx/0FTuNCu/uYyk9u35TZWuIBJ3djjing28fIsYcmFw=;
        b=sEtPXElaublC3bnoaVPtuVaPFC1y6wMlUys1Hgwfift3MjWaYRLUfXIMjqL2OMk91n
         n19g5KJeisxoKZKPMfsMIiUq/2TCAZ49+hticSusw9L4aEb2i/Wkpl2AbK5RXM46PQ0Y
         /T0ebJrFMGDO3E/Og4AT4WL51c+kytGbX309AORIZleNPIiWuLZutHdBhVLbgXJ80CFA
         zSCAkMh7QbO1/JixH7fCoyT0eHfVGtwEx6rkuQ+DgA62M4zV6/Kz7KnFjKkKKPXNAiak
         RuPZN9HgJEkEwo23FEDYnzhzsrXbMHFRgb8HDGpk9pxseBEV3bbSaMQ3uoGFmnCziV58
         XiUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737644332; x=1738249132;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mx/0FTuNCu/uYyk9u35TZWuIBJ3djjing28fIsYcmFw=;
        b=RerePC0luhU8DMrL+4JVEYwOgkcBv9KKwnkZVElLmY9ihu1lBwBPBN4kKwX1N35m47
         +6uyFwPleXnRmL2cUra1GzGX3SbA/S0441efCEaG6/RtXg5bBRPl//8Id02s3Qh+pb5L
         2leHmxGDtukvqsP/BmB0XWE0iWlijBie5zl3DWt0G66mm0gc4hiKLVJaMV65tOsdNwVr
         B0ImUb/zbpN5oB/6jfDmc8QcQs/rp/YXCvyfQLZYkGZSPjdj8i3EIAV3jfJqb1+CZsi0
         pbGaIaYxrkNrHSkwVaSXR4tc/E0wMvUtvpCUD1ijLnXFZAo273F2LH8+shzAsPjLnZ49
         +muA==
X-Forwarded-Encrypted: i=1; AJvYcCUhYGiljGst/N0aesXYWXXEyo5FBmYW4NlwX7WqJFsTxeOy4b81zJsOs7MB+VlTkRjqb6N//vsF6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwvjvXup3KpfpeudhZwFFhbtjRTTrK6x326zcRIBcQbMXGdzbZU
	DvFPyHnBrfimRTZsqWYpoojRj4BPjzB+yd11bGvfIIvzTOBijtavUeJSFDC9Y34=
X-Gm-Gg: ASbGncuKfWQTbrSjuOAat5wRjHQkc6AddEZG+xGXRSycEUTdXgnzhE2/S3FPffJpGNJ
	asnm69T0ChFTxcSK1c6mreU5Zbz0fJFPovfAolwHc0V/m/35W1rt8fshPsi4g98IO9v7PbWvxHB
	cLpjHv35L41ysGahi9pQCfDdkfb+EwqlvvutArYv+BiXEO/besbwd25QCi0gOJtSnSTVkE8Kurc
	3FxN6gtwa6W6zEangrU5Y3C+Rli1W0XAsDWkcovAt3GDr3M9uDB8BhsyXPPlLh9qipbodyIJ5HU
X-Google-Smtp-Source: AGHT+IGENCHrrBQPzWAwKHTrHzpVeGIy6E9ig9Ml6VAgDxUhrvfN7Qb4Xb8hA49ZVdvXpNSwLKyY9Q==
X-Received: by 2002:a05:6e02:1f86:b0:3cf:bbd5:69ad with SMTP id e9e14a558f8ab-3cfbbd56bffmr35418765ab.1.1737644332297;
        Thu, 23 Jan 2025 06:58:52 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea75495f77sm4860819173.69.2025.01.23.06.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 06:58:51 -0800 (PST)
Message-ID: <48c4b36b-67c4-49ee-b1ff-dab921f1075b@kernel.dk>
Date: Thu, 23 Jan 2025 07:58:50 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/uring_cmd: cleanup struct io_uring_cmd_data
 layout
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: krisman@suse.de
References: <20250123142301.409846-1-axboe@kernel.dk>
 <20250123142301.409846-2-axboe@kernel.dk>
 <914661c1-4718-4637-ab2b-6aa5af675d23@gmail.com>
 <832dd761-32ad-4b7e-8d6b-1fae9caf5a83@kernel.dk>
 <2fbf17ab-b7c3-4a5e-a435-f658a42ac8a2@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <2fbf17ab-b7c3-4a5e-a435-f658a42ac8a2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/25 7:57 AM, Pavel Begunkov wrote:
> On 1/23/25 14:54, Jens Axboe wrote:
>> On 1/23/25 7:38 AM, Pavel Begunkov wrote:
>>> On 1/23/25 14:21, Jens Axboe wrote:
>>>> A few spots in uring_cmd assume that the SQEs copied are always at the
>>>> start of the structure, and hence mix req->async_data and the struct
>>>> itself.
>>>>
>>>> Clean that up and use the proper indices.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>    io_uring/uring_cmd.c | 6 +++---
>>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>> index 3993c9339ac7..6a63ec4b5445 100644
>>>> --- a/io_uring/uring_cmd.c
>>>> +++ b/io_uring/uring_cmd.c
>>>> @@ -192,8 +192,8 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
>>>>            return 0;
>>>>        }
>>>>    -    memcpy(req->async_data, sqe, uring_sqe_size(req->ctx));
>>>> -    ioucmd->sqe = req->async_data;
>>>> +    memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
>>>> +    ioucmd->sqe = cache->sqes;
>>>>        return 0;
>>>>    }
>>>>    @@ -260,7 +260,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>>>            struct io_uring_cmd_data *cache = req->async_data;
>>>>              if (ioucmd->sqe != (void *) cache)
>>>> -            memcpy(cache, ioucmd->sqe, uring_sqe_size(req->ctx));
>>>> +            memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
>>>
>>> 3347fa658a1b ("io_uring/cmd: add per-op data to struct io_uring_cmd_data")
>>>
>>> IIUC the patch above is queued for 6.14, and with that this patch
>>> looks like a fix? At least it feels pretty dangerous without.
>>
>> It's not a fix, the sqes are first in the struct even with that patch.
> 
> Ah yes
> 
>> So I'd consider it a cleanup. In any case, targeting 6.14 for these
>> alloc cache cleanups as it got introduced there as well.
> 
> That's good, makes it not that brittle

Yep it was too easy to miss, don't like them being aliased like that
even if the usage was currently fine.

-- 
Jens Axboe

