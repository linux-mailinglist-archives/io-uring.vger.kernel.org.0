Return-Path: <io-uring+bounces-39-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5AE17E28F6
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 16:47:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 220771C20B63
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 15:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C3E228E0D;
	Mon,  6 Nov 2023 15:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HajMOlua"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605241EB21
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 15:47:02 +0000 (UTC)
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FC2FA
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 07:47:00 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-7748ca56133so42166439f.0
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 07:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699285620; x=1699890420; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fv64/67oLSoCr8XGY3hiMEDjbCSiQ5Km7WXL0H2bqsE=;
        b=HajMOluaUsHEIsWdhcsnf2WV/AWmHK35WwntD0CmTHE5KOXhCR+Y4/ZnmpOzmC7DNk
         UvV9gdR4XcG5+ZM6SFnSVHKbWnvACcYdcq7O3xWVYLB5qlHFxVjuECDM+yaZYBV31LAk
         G5cV4KuVAmUIoGjegEsUPEDVcH3tw+ZL1GkiFAC5s3voovHoVzQBwIp3Vg5XmQvrXloq
         lvJNIXxyvrEPuTUSN/k/YRnIYoitfxOOyjml2TqWZHCX86FIvlUZZf8Y0yFYBNRc6OX8
         wHL8bMsT/l3EN5hIQ5oS3cte9DsLpLYRacrsLrKh8WyDotjHH5uzlC526kwbQSqq6RZO
         JUug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699285620; x=1699890420;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fv64/67oLSoCr8XGY3hiMEDjbCSiQ5Km7WXL0H2bqsE=;
        b=cBbK1LPcPtfakmlNGUqg1I2VJeFt2lhUuAZPKVoRuOcFGQTlKQB9Uix5am6RDs4GYG
         /E2xbyQvBq2lhW/vvUYqKb2HIH0UEgh3ngGWsTo7SDmkRmg0oXp5PCyPDgr2eejyuuoi
         iFcjfUoycs3qatl9shIBw4tz1KqijQ6NLJyyNX2APJEr2FdbkE58SXrH/tTQFqaYTSvC
         QB0iovOcw3MA4M7cDcBsfUpINW5qZ/R4FBjZ+UhkiQ7maZNjpmc632pxt0cAdIuRHxeU
         thcW92UOqUL2LkNTJWxsnK9ArFu7DTj94TJlkCMAE8SvPxnuZmyCnQcQnwo5GS890Wor
         /qyA==
X-Gm-Message-State: AOJu0YzDkGAqwteAKkXCo19aCZbLKUEChnx7rgoiUHIIUwrXfvax5Vcf
	d4KFXwz7aUdDW3/B23kG1Ny0IA==
X-Google-Smtp-Source: AGHT+IGdcE9dtesbiHu/cSB+Yf725ZzJ1JddhDqytftKQBBp7kn7bYuwxknl6b90T9E9Rcv8xLAENA==
X-Received: by 2002:a6b:f00b:0:b0:7a9:6f8f:b5ed with SMTP id w11-20020a6bf00b000000b007a96f8fb5edmr28710802ioc.2.1699285620120;
        Mon, 06 Nov 2023 07:47:00 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id m4-20020a5e8d04000000b00785cfdd968bsm2425138ioj.5.2023.11.06.07.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 07:46:59 -0800 (PST)
Message-ID: <249f2e9f-12c2-4a1a-9b90-4b38ee8db3a5@kernel.dk>
Date: Mon, 6 Nov 2023 08:46:58 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: do not clamp read length for multishot read
Content-Language: en-US
To: Dylan Yudaken <dyudaken@gmail.com>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
References: <20231105223008.125563-1-dyudaken@gmail.com>
 <20231105223008.125563-3-dyudaken@gmail.com>
 <b6db6eeb-3940-43ab-8cae-fb81ff109e41@kernel.dk>
 <CAO_Yeogr9D+MH2m4GGq40mKHfyvVgUscdPsjh2STi0Y2TZGNBQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAO_Yeogr9D+MH2m4GGq40mKHfyvVgUscdPsjh2STi0Y2TZGNBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/23 8:33 AM, Dylan Yudaken wrote:
> On Mon, Nov 6, 2023 at 2:46?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 11/5/23 3:30 PM, Dylan Yudaken wrote:
>>> When doing a multishot read, the code path reuses the old read
>>> paths. However this breaks an assumption built into those paths,
>>> namely that struct io_rw::len is available for reuse by __io_import_iovec.
>>>
>>> For multishot this results in len being set for the first receive
>>> call, and then subsequent calls are clamped to that buffer length incorrectly.
>>
>> Should we just reset this to 0 always in io_read_mshot()? And preferably
>> with a comment added as well as to why that is necessary to avoid
>> repeated clamping.
> 
> Unfortunately I don't think (without testing) that will work.
> Sometimes the request
> comes into io_read_mshot with the buffer already selected, and the
> length cannot
> be touched in that case.
> 
> We could check if the buffer is set, and if not clear the length I guess.
> I'm a bit unsure which is better - both seem equally ugly to be honest.

I mean do it at the end when we complete it, so it's reset for the next
iteration. But yeah, I'd want to have the test case verify this first
:-)

-- 
Jens Axboe


