Return-Path: <io-uring+bounces-7665-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EF1EA98A9A
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 15:14:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75CD317C5AE
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 13:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97FA335957;
	Wed, 23 Apr 2025 13:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ulz+dBB0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142FE8BEA
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 13:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745414053; cv=none; b=cEZ0s9Tpy9/4ycGsYoeUuKPUIm34cRq+bfWDN07X+cuwu9ZHYfieNrGpJeeH7FfMhXbSAHbbDZ5ijZw5jk+9nDqvPJ6/dmmM2ErzaZAFEFDda83PrmBPoIcCyLPEk6pgv1FLIeZuwxprgiU/y2WIBXJP8ayeO5y7AdBkXDmxTps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745414053; c=relaxed/simple;
	bh=X5cE5E609nIHESL8kGnfxEc0UApvIg0KhUx5Gjz3xMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aUFVjmnSZHUSjoV81HmvJV3U6exs/56EWILnBmvpMOr9w1KURfr26givKH17Av6Pz52opKL8ohz97kkFfExbiYE+Vhx2pBhZZUUERdc0b0fVWu1tkSiEeGGX3IZDJuS1GEaoPxDX5cVMHcVYNlyk5f8x6nhubu9qNf3eGF2RTjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ulz+dBB0; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-85de3e8d0adso100595839f.1
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 06:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745414048; x=1746018848; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X/+Ozk66zDZEbftV2Qxmcl+7JMg41fT16eIsKvKzgiI=;
        b=ulz+dBB0RrKgjXLR+8+SXfC8F7L+otFENSdMk/+hAjs2L5NZj1rxEDaP/01CuusMVd
         etEcPzoCva0WPY2f5FnbZBrmzW22HYxfpoaFh7zv42UMSc2Q9jr9UmvPht7yr3d2IGpy
         u9619w7b1MvM9ZBLqD9GL7pLqEBRd7xQxryeXGnCQBRdPpylEqiiTPpp7Lp88XdL+WL6
         FowcwpA6qHYqChrnPbn/PBNufnF2PZb6owPr+/P4FtiuK9TZTsxhtKrK7EPLKfmd0J8c
         AP5PHnDdd+RwAwRqYLTiZ9xFYZ0VrbL0S4CVc2VfFa/C4fDKWNLa0pduHh1K3li1ts08
         bDLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745414048; x=1746018848;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X/+Ozk66zDZEbftV2Qxmcl+7JMg41fT16eIsKvKzgiI=;
        b=YN0CsnPdeZMYa8mr/rayTPLTQgIPiF1IhdcUVTdfAFfAEb77QUqjNNxJMoDCfqdXMk
         cwlK3DLxPLVH1unx/vxEnMBc1Iun4du5zddi1A9E2aIouxwFqf6EeWugXIvqRKqkCsjn
         OAwpMob/SVET8vH3HcfU16F7UHSzXymTUixYUXCT/JgNOl8gQsn8EA366P3kjTbe4Qp/
         VhENeZ2o13x4eE3trmN3oWBicvW0vb1jUPsRHm0KapBYPwhiPysbIowLeTjnmywBsYHZ
         LanuAhigGMaRpgQ6CnarL92d1aZGedz94M+JtA0Vm+hvj0ET/Kvk5EOqE4dcy8Wi4F9L
         E29w==
X-Gm-Message-State: AOJu0Yx1tUNQ3B9uRbfJYP85+z6Dvb+LmHaKT6rOjbjCGLsVR5rC3PnQ
	fm1D9kX5vB4410NXrfj0oqSCkEHZJehzHpuoH0JUgf/NVXA7ifGexmt5kaWHfxs=
X-Gm-Gg: ASbGncuO1NMPICExFu0fPBW53v8ulUVqKxEwD2XxisxdHtxl/C+SXNSiRO/NGzHyTex
	EIVwzxxdnUd6c3Oq1Dnfs1NQlNwSQma1FyzV/4zcF+8rGE2x6wvQlCfQ36DqgFe+LjX9OLz4PKT
	asORCTD2KtMN0K2n/+2FMBq0KJxhxnIc5FKdrdr9Xx+OVckMR2EebuwxG41VyLWsMohL+d15YV8
	z3BX0YJaZR0EK7TX5mJAGCUDTiiu7xn/zJZJZaLWKiuLAbe28X1VdCjNJ4kTw0CYDAX8sgkT58U
	gPrqE9bB8xseR/bceNgY/DZYGMfoVcJBtRSdEg==
X-Google-Smtp-Source: AGHT+IHMF6/i6nEI/QTCy0TYFwKnCYx1Ze+LxEUVuXi5HdWu8XVYQVJeFg6549g1khaz0U6JImISrw==
X-Received: by 2002:a05:6602:3e90:b0:85e:183e:4c00 with SMTP id ca18e2360f4ac-861dbdc7268mr2133909239f.1.1745414047691;
        Wed, 23 Apr 2025 06:14:07 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86444719d9esm30538939f.3.2025.04.23.06.14.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 06:14:06 -0700 (PDT)
Message-ID: <46aa0cb5-87e6-47e8-b949-7e414e5723e3@kernel.dk>
Date: Wed, 23 Apr 2025 07:14:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring/zcrx: add support for multiple ifqs
To: Pavel Begunkov <asml.silence@gmail.com>,
 Dan Carpenter <dan.carpenter@linaro.org>
Cc: io-uring@vger.kernel.org
References: <aAiTlrx6uXuyoCkf@stanley.mountain>
 <6047214a-794f-400b-993c-5b5ef9e6daf6@gmail.com>
 <83595e5a-ae53-4ca8-86a9-5909833b77bd@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <83595e5a-ae53-4ca8-86a9-5909833b77bd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/23/25 4:30 AM, Pavel Begunkov wrote:
> On 4/23/25 11:04, Pavel Begunkov wrote:
>> On 4/23/25 08:15, Dan Carpenter wrote:
>>> Hello Pavel Begunkov,
>>>
>>> Commit 9c2a1c508442 ("io_uring/zcrx: add support for multiple ifqs")
>>> from Apr 20, 2025 (linux-next), leads to the following Smatch static
>>> checker warning:
>>>
>>>     io_uring/zcrx.c:457 io_register_zcrx_ifq()
>>>     error: uninitialized symbol 'id'.
>>>
>>> io_uring/zcrx.c
>> ...
>>>      396         ifq = io_zcrx_ifq_alloc(ctx);
>>>      397         if (!ifq)
>>>      398                 return -ENOMEM;
>>>      399
>>>      400         scoped_guard(mutex, &ctx->mmap_lock) {
>>>      401                 /* preallocate id */
>>>      402                 ret = xa_alloc(&ctx->zcrx_ctxs, &id, NULL, xa_limit_31b, GFP_KERNEL);
>>>      403                 if (ret)
>>>      404                         goto err;
>>>
>>> Potentially uninitialized on this path.  Presumably we don't need to
>>> erase id if alloc fails.
>>
>> Thanks for letting know
> 
> Jens, do you want a separate patch or to fix it up as it's the top
> patch? This should do

I can just fold it in - done!

-- 
Jens Axboe


