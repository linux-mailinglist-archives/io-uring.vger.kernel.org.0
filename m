Return-Path: <io-uring+bounces-8022-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7137ABA6B2
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 01:48:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 859514E257B
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 23:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C4E23644F;
	Fri, 16 May 2025 23:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="V+uEQBq9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820901A256B
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 23:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747439306; cv=none; b=nnIZLZSdQlmqUjje/CsfnE4uJIM5qNR3sVCuJa57EgAH74RYcaAxzvAsY6cx337nz9X6IyYpSOVYbdMRzvb4GuuhPbqQAMisSV4ixh0lrlJvyS7/Ge7no5emvooVsmKQT8+/3bpYHTd24gpkEcEE68KAPimWMkl66w7KqXhaPfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747439306; c=relaxed/simple;
	bh=lbSK5cElxOKKnTAKx7wb2iYNxUO9sqOEzNBV/2wiopg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XPFCW2Ti3o/k6j9qlnHcCQ4pQ2OCxRIPM1ExnwgoPAIs0GiXLX5WRzDGnjO1II52lrXgnW+DTWct4Rhn1hbznPYrzTq0cYtQwnTHWLgNy3gt52QSl6sZLNgqQrVjaH5tSAKkX2oYMUX6Q7MbA7k5BctRfqHflWoNisuostYVZEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=V+uEQBq9; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3db87f6f106so7800565ab.1
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747439301; x=1748044101; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZR4kV8LtpsI6692BzEmxTX1bOMtZ91avQdhjafyKQis=;
        b=V+uEQBq9D4S14ej+4gftU+F6tQkv7QZGpkl72jlrECXf8LaXEWyJSZ87tjicjvFW/E
         CHzW703O3nDT3+8cdepO3l1Zyz3p4DsynPMJR23IbZOWF88NM4nLftnV/u9BbOPbIHPj
         ftSOjdJPifVc8Zb7MlUPurmSEe5AZJy57gkAeDpRPUAvYFEOCmgabdxbLaOpHIinkc4k
         ihAAHxlE2VJVuCUugD4l/V5+0ONImsziHtr6r8aSbxAUW66VLed9T1D8YXi1Wrsw0knH
         p3MnBTO1abi9uMlP8tHXrFZ5P7KbQKRtuZxSVkUEPWoEL6uSyohmI3XodgQpvvDd27JJ
         R70g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747439301; x=1748044101;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZR4kV8LtpsI6692BzEmxTX1bOMtZ91avQdhjafyKQis=;
        b=WxlgrdhgfS3Sx+0Fx7khaLr9ZGeJ3Q9rCTvvVbqWNH1m7livbakLICD8YoVbXsMohk
         Qo0eZAU+ZEETtRDhrgZF5hX/fjby2zrexwOBsOuveXVH90ciVyxWPHboLhPFIvNnBYyQ
         PqGCS8YUJm7gj8EFTqnF8oBEcRyPEKYmFYyDVL/tpnM2p0fasRsZiptn57WR5uXEvjhy
         o4KZn+MnZJUhJ1CRrrTwW6/+uzQ+fHUFw0F7b/samm0stSl2zx2KXmpdnYtnZUJtaRbM
         mvHAkG6EUvV65PFangjH9Zweisq4zSzMVHA+A5trcmEpcW08I743aBHEGT23TekZ0XAE
         Cvqg==
X-Gm-Message-State: AOJu0YxcVK/5PG1KFUeyvZ5MuMNcFo/rVCWI87ovcGxwskE7/hGR0+6G
	qgxidd2cpTKrH4nsAKe5w4x7VfqMOJWRpk2MJFti8amEbCGxvSSjhf36UQcw/HTL2C0=
X-Gm-Gg: ASbGncsLdoUEA7M8XmHOWGAW7eSXMsBPmTO23Ev8M0knvfygUDooZjD7CYbZ81kBQtA
	10qOyQCJ9EHp7KlhLG5I0i5EniINJPDBdxHBGmAxKsetgS0ywCFHS0LrewohX2ziZFMm3Ptbv4b
	V908X/sKSNG3qI8T/iRLJcqTlSTFMRYK84wOxjUxgZ3i+CT3s5huj5T1sqBhd8F0us3NIKBk8CA
	AN6ns1aIQ6ACxYvKcMwEjSjOy4nGrSVJIuqUMJjQI0btfQf5mJuvm1DNN+AZuApBCtHZp863h5/
	Klzsz2xRI6znTHKf8T6vDOMGa7ghvtotf/gV31AwEHPhQfIJ
X-Google-Smtp-Source: AGHT+IETPJJ6V91x6CSgcReyD4trxbkuC3G/ifUZVrXkUbLXMgU5p+HITBTo0xWmy2L1XL13FpzBqw==
X-Received: by 2002:a05:6e02:3b89:b0:3ce:8ed9:ca94 with SMTP id e9e14a558f8ab-3db84321c68mr64381265ab.14.1747439301570;
        Fri, 16 May 2025 16:48:21 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc48c4c1sm633543173.95.2025.05.16.16.48.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 16:48:20 -0700 (PDT)
Message-ID: <40e35c3b-d3a3-4ad9-9975-7fc2fc61ff90@kernel.dk>
Date: Fri, 16 May 2025 17:48:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: make io_alloc_ocqe() take a struct io_cqe
 pointer
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
References: <20250516201007.482667-1-axboe@kernel.dk>
 <20250516201007.482667-4-axboe@kernel.dk>
 <CADUfDZqueYi3XNc3RjXfURwsDgbNgp6pwa8eOReKKv0h+g+RCg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CADUfDZqueYi3XNc3RjXfURwsDgbNgp6pwa8eOReKKv0h+g+RCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/16/25 5:07 PM, Caleb Sander Mateos wrote:
> On Fri, May 16, 2025 at 1:10?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> The number of arguments to io_alloc_ocqe() is a bit unwieldy. Make it
>> take a struct io_cqe pointer rather than three sepearate CQE args. One
> 
> typo: "separate"
> 
>> path already has that readily available, add an io_init_cqe() helper for
>> the remainding two.
> 
> typo: "remaining"

Thanks, will fix those.

>> @@ -806,6 +806,9 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
>>         return false;
>>  }
>>
>> +#define io_init_cqe(user_data, res, cflags)    \
>> +       (struct io_cqe) { .user_data = user_data, .res = res, .flags = cflags }
> 
> The arguments and result should be parenthesized to prevent unexpected
> groupings. Better yet, make this a static inline function.

Sure, will do (make it a static inline).

>> @@ -1444,8 +1449,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>>                         gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;
>>                         struct io_overflow_cqe *ocqe;
>>
>> -                       ocqe = io_alloc_ocqe(ctx, req->cqe.user_data, req->cqe.res,
>> -                                            req->cqe.flags, req->big_cqe.extra1,
>> +                       ocqe = io_alloc_ocqe(ctx, &req->cqe, req->big_cqe.extra1,
>>                                              req->big_cqe.extra2, gfp);
> 
> If the req->big_cqe type were named, these 2 arguments could be
> combined into just &req->big_cqe.

I see you saw the next patch post that, so will just ignore this one.

-- 
Jens Axboe

