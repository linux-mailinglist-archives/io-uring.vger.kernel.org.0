Return-Path: <io-uring+bounces-7392-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3A16A7BCBB
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 14:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8113C1760C6
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 12:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7591D7E26;
	Fri,  4 Apr 2025 12:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Yqlmvctq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15661C84DC
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 12:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743770228; cv=none; b=dbwfy6LoSDVAWFaHo8cJWgcWjen/UCkz46WsfgEVONQp2G1eC6GAb0QTDTiQ/rLgxwX/GBXy6EHnNICLZwIEYOdLeJ/c006A5W3Jb9oza2v/Ct1AaPspN23QIVgoW5nr0OhXPF/zUdyqtrJooanP+AQYYlm2+G1WAqc+n0RVcpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743770228; c=relaxed/simple;
	bh=aplL9E3hJUV1UqoDfkhbZpQSX9j0hQP2QnpBtcr4/DM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Erh6KSOwOr7zR15AKmdzbigIf/oPgVGwmCxgbdKFErDGjJS2jUv1HF9KflPuJt352wn7/tA/nIW/F7rDupKMvkoHNIWotnZioRYnqdpSqVw0JZw7VIEw0DIpDq2jT5l1BDy0DtZpFU2+iiz1+jSxQSjo/2cx2bm4veYuAXSrSZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Yqlmvctq; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-85dac9729c3so143908739f.2
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 05:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743770224; x=1744375024; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dQGKTRH5vF2qFa6MbP5J8To+Y3RTEV7XoDx03Wd1LbY=;
        b=YqlmvctqdQWxuoQtYR4Acew4J7W6iGrA/BOZiKhbBVOeycDyjXGNdvKQJze2rrX8GU
         YVJymGy+7F32uduknxNbBlqkZQOzj23fzu6XfcBjjR4YqufIEDgaUrUQQmbD3h99yEat
         0wjv5CAnauRDym4fXyFQpbgn/fdj5cSDPzmU21+vRgH1HhRObLtRXExaK+BqMwOQp5yv
         SBGsNtUMPtAb1BxBOgkyqeBKzCL4kwQYPvXlT+mcd8RHncc0+y0KznzzdlW6I7pDnTFX
         6/QYrx08g0Ic8XY53cyoIiJ9daEgZcaL15v8dExGVKr/PuFKuZfJL+QRrJXG1HTOal+P
         dTIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743770224; x=1744375024;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dQGKTRH5vF2qFa6MbP5J8To+Y3RTEV7XoDx03Wd1LbY=;
        b=ZVf1gWBYc2DN9/KpoE65Ehzf6rFSWMZebe1x1NYAl76U2/hmwVFeCLnUg9WmaNsO6o
         gtqZBmbwy4mxkzMkdAUtaQ7VkBCgGcaIz3i1upIyNqOj8XmS7T7MraF2r7dR/dMJnnNn
         COLaoi8TMi3ziMO8jzDwsJxpCRC6kllNIrwOCJiB6MjtbjHAoC0+HOG8GkkZZn8Jve3A
         VN6+2IDGEBNb0eqLMxTp4+iuTe4N8pTZF8oQ8Xo1af7GUzLuq4a31SH6/hO57/5LuCzo
         hFOVaIh58ywPM0c2PIS9kgQoHzZPSTPqKzmGvHHBC5Mu9CTUes+gPfQi8ONNto8+a+gm
         kexw==
X-Gm-Message-State: AOJu0YxaRPlY0zbwOFAZ/WX+KjHiiU1vCiR3Ls2TM0Y0+C7ZFEUg1zPC
	YfC5/ABgob2UoCYyDTbxHMwfll7q0jQMG+lc7WGZXE9coYRUy8GWvPBZFCDiYBY=
X-Gm-Gg: ASbGncv+y5XmiVdPv2pIm1m8AW0fHaVHkEFGrkL0d2CvLByienER7ZdFBMyiysSbZ9W
	dCLRPh3vSh8FIr8C5kX+6E1zaFThpk9LfkEfB8QHaK2FIbWUS1EZtxV8Q9ewrcp5KqY6Q3cOV2E
	jhU9/9tK5Pg47X9pFSZz0rUF9m68+5j4X4/v1nA9Xqv9gs6dDjx0yOKzMYYI7xoXXcbDpvpiO1j
	DLrhzrCFZBokm+pjBvu05G2docOSN8BF8DVRsz7vh6EJryIb60edd5xAqanRgzYtqZr4TReUBuG
	oFqVJsw/S8k2S3cepZ5Q8fM8OS1Saftv/XwSw3Gbpw==
X-Google-Smtp-Source: AGHT+IEJdhBHtUPEsx9xZjNjGG8BoogSqvJZW5fAfgJdCbBftaee9VNgnXITu8XeA4eoLukybvnqhA==
X-Received: by 2002:a05:6602:3605:b0:85b:3449:faa2 with SMTP id ca18e2360f4ac-8611b4d9f96mr356776139f.9.1743770224689;
        Fri, 04 Apr 2025 05:37:04 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-861113a75e5sm64045639f.40.2025.04.04.05.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 05:37:04 -0700 (PDT)
Message-ID: <4a6d39c1-f893-47e4-9328-1df3042aff53@kernel.dk>
Date: Fri, 4 Apr 2025 06:37:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: ublk: fix test_stripe_04
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>,
 Uday Shankar <ushankar@purestorage.com>
References: <20250404001849.1443064-1-ming.lei@redhat.com>
 <174373319721.1127267.3756134797323684566.b4-ty@kernel.dk>
 <Z-9WD-sqnPEzUqyh@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Z-9WD-sqnPEzUqyh@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/3/25 9:46 PM, Ming Lei wrote:
> On Thu, Apr 03, 2025 at 08:19:57PM -0600, Jens Axboe wrote:
>>
>> On Fri, 04 Apr 2025 08:18:49 +0800, Ming Lei wrote:
>>> Commit 57ed58c13256 ("selftests: ublk: enable zero copy for stripe target")
>>> added test entry of test_stripe_04, but forgot to add the test script.
>>>
>>> So fix the test by adding the script file.
>>>
>>>
>>
>> Applied, thanks!
>>
>> [1/1] selftests: ublk: fix test_stripe_04
>>       (no commit info)
> 
> Hi Jens,
> 
> Commit 57ed58c13256 ("selftests: ublk: enable zero copy for stripe target")
> is in io_uring-6.15, so this patch should be merged to io_uring-6.15 instead
> of block-6.15.

Both branches already went to Linus yesterday, which is why this one is
in the block branch now as there are no dependencies left.

-- 
Jens Axboe

