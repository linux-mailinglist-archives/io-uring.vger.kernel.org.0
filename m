Return-Path: <io-uring+bounces-8158-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3125AC9175
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 16:25:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BAEFA44882
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D71A232367;
	Fri, 30 May 2025 14:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knZ8wac7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FB422F386
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 14:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748615101; cv=none; b=dMUb6LHSIwCSOOxkcK8wkjBIlekNSKbUVeZT/ZxTSQo44sMpIX4W9kNBo1Ui7XrttmcPU/kgJe8ZgLvBlbxR3X99zbKyVxLoqhYqM/NQwx/w1NvpgRLtMY4TOn3eLUJ0RjhoGfzb/6NSXR//x+tIBsh+3/0PEjKmwaZPQMn+ToM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748615101; c=relaxed/simple;
	bh=6mF76HBr8frKIOb4x+TwGS+KZdYPsUB4B3V2yHHRVBU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=kgNZ0rgimcB/olj+d43wFtid+fos8I50vN5e3YKfqZxB+y1PPLutW6rvsRSwO/VFWAjZgMG7qA4wO4q5X8AjDOhcBT80PhAnjEywew8DCkXXI2mCJqf2xz+wsVxxcHr4uRuS0zdvS4KikctLowlf1mhAiOhoQhj07ovk1/YKLDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=knZ8wac7; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ad88eb71eb5so251317966b.0
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 07:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748615098; x=1749219898; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ADsf3Kl9LOLXzJtGniV9deNQ/g6IYyu9m147yjv2Ne0=;
        b=knZ8wac7VTTX85CL40XkuGUEX3ktq0ItcDElyqXPb8rIVI8cjH88lxlpI3M+T/DLOB
         Htq39QvsCBVxKeLWDGwDCgbV09sedSbP+y6rqWopGyh8hPrM5p3PWmLAIroSI6Qaf6RF
         4zrkMS5MoEwtkoxOczGPqzv5A0XEWWnwNRU6QGdUxJsmZ84ti+d4h0h1ZCblwTTrY0qs
         oG+ieje+RMRIFRiGGhYQUVN9UxSs6GtnLSSfPCaC9hZ93fdNQOXahf5D+1BRrHHdqr/Y
         PsBtvGn021N+f+oqNZaET+kAawwCt2x1rFCOZdsAfz647+zUpJcKYVG/8JR8/jl1hgp3
         x2qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748615098; x=1749219898;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ADsf3Kl9LOLXzJtGniV9deNQ/g6IYyu9m147yjv2Ne0=;
        b=sdzm6Whdu3NUyD+EjS7/QcKgl0r3cwYQ4FsOVcF9nzLp0+8rl2AJNp7mK3f6SPT4ib
         myaLFGA2nzRShxNPi8PgaTTLY3vNRYQhRWg+XZWRLckasf+tRbyc1eKKQeFP6NMthrjn
         Ew2EY3Hiy4Gb2j39A8ThG3vj6e+O2rY6yGACUEokJblA80qM5wwAvgdKyJHk2sgQYwS6
         D5lhAMIi/yoEI9zgQW6iDqXcPahWCarvrpY2OanOXFce5tU1AHnljb3KR2wbgwHyvw/V
         V7pBITf6wzLRniS6Up6e7hLsqkUByu4Z+MWSbbZ2LByVUoe6fwAEPKCWj4JuPv3NvDr+
         gWOw==
X-Forwarded-Encrypted: i=1; AJvYcCVW+70oDbsQiQKUunZT1hAp7zXW0I8xpLmv75RqLA4ce9z0K5d3iWzeLT6SMZndWuIu0idrA5ZmVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwdG81heuRY3albEBiAcXtJ6DOxb10THzlSyGV6stfQpmfUeist
	NA2gwVZIYCIiJ7TirVt/LmC93F/zL6HJWsP6sbn7pf8kZpo7FA5+rCPE
X-Gm-Gg: ASbGncvJN1fYbGa7FX+gdjUB1FJ1Cai5kmS2ydoNvuTpkyHnMhM1OKm1/1Uhcw6LA1I
	JpLnTzciad0+SdRqmvhLgzyumAv2x0K/D0AeMiOsX/n1c95KX87C4PyYuT3P3DUN+5O/sEmWDG2
	13LwPs1Lkp9+oRlnoJc6E6Ngf6to3L5jqd8OnaLzY8S8XDbBzJYgo2l+EOREGoX94C/p3T+hQGi
	kyTaLW18E23o2Z9N15REdZ3wiPY+hkjuyCO/3sY56UQF6MAv1QyNY9RquAt61aHrYb7q1uNqkmH
	6kVc4P7FnsAW1q3r0y4ttLTUS/M81iFfaCNR3WRojegmrRnXDptFCERpfrZp5x3+qupp2AP7MOw
	=
X-Google-Smtp-Source: AGHT+IGRInbRQrEzv/nD6XeYoDyXXBshbSYjFFOExWtOdXQgOXMpqFrx6L5Sm9qvf14BspPKwCK19Q==
X-Received: by 2002:a17:907:9813:b0:ad5:577a:1733 with SMTP id a640c23a62f3a-adb3259894bmr321274866b.51.1748615097940;
        Fri, 30 May 2025 07:24:57 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::15c? ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adb2da5e9d9sm219716566b.21.2025.05.30.07.24.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 07:24:57 -0700 (PDT)
Message-ID: <8cdda5c4-5b05-4960-90e2-478417be6faf@gmail.com>
Date: Fri, 30 May 2025 15:26:10 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] io_uring/mock: add basic infra for test mock files
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>
 <cf2e4b4b-c229-408d-ac86-ab259a87e90e@kernel.dk>
 <eb81c562-7030-48e0-85de-6192f3f5845a@gmail.com>
 <e6ea9f6c-c673-4767-9405-c9179edbc9c6@gmail.com>
Content-Language: en-US
In-Reply-To: <e6ea9f6c-c673-4767-9405-c9179edbc9c6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/30/25 15:12, Pavel Begunkov wrote:
> On 5/30/25 15:09, Pavel Begunkov wrote:
>> On 5/30/25 14:28, Jens Axboe wrote:
>>> On 5/30/25 6:51 AM, Pavel Begunkov wrote:
>>>> diff --git a/init/Kconfig b/init/Kconfig
>>>> index 63f5974b9fa6..9e8a5b810804 100644
>>>> --- a/init/Kconfig
>>>> +++ b/init/Kconfig
>>>> @@ -1774,6 +1774,17 @@ config GCOV_PROFILE_URING
>>>>         the io_uring subsystem, hence this should only be enabled for
>>>>         specific test purposes.
>>>> +config IO_URING_MOCK_FILE
>>>> +    tristate "Enable io_uring mock files (Experimental)" if EXPERT
>>>> +    default n
>>>> +    depends on IO_URING && KASAN
>>>> +    help
>>>> +      Enable mock files for io_uring subststem testing. The ABI might
>>>> +      still change, so it's still experimental and should only be enabled
>>>> +      for specific test purposes.
>>>> +
>>>> +      If unsure, say N.
>>>
>>> As mentioned in the other email, I don't think we should include KASAN
>>> here.
>>
>> I disagree. It's supposed to give a superset of coverage, if not,
>> mocking should be improved. It might be seen as a nuisance that you
>> can't run it with a stock kernel, but that desire is already half
>> step from "let's enable it for prod kernels for testing", and then
>> distributions will start forcing it on, because as you said "People
>> do all sorts of weird stuff".
> 
> The purpose is to get the project even more hardened / secure through
> elaborate testing, that would defeat the purpose if non test systems
> will start getting errors because of some mess up, let's say in the
> driver.

Alternatively, it doesn't help with bloating, but tainting the kernel
might be enough to serve the purpose.

-- 
Pavel Begunkov


