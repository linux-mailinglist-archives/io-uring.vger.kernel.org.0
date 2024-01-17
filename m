Return-Path: <io-uring+bounces-418-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 794AC830A54
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 17:04:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7909E1C239E1
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 16:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E2E722301;
	Wed, 17 Jan 2024 16:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MLvbiLKH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF832232F
	for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 16:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705507453; cv=none; b=dlQ3dW/rgzIKsU/bd19nNoWY0AbbpR7IfCwbh8GfyRctOavBLX6THApUn+h9ZzmANNsLWa7V4JSDod7BiX1t0nyteSsFe6IGPyxJYig1STXWbzZoLp59kAICNY92xr3RqEy6B69vqb+GqWPkiLR3rSwRZUECewPZhfmOSIm7ZmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705507453; c=relaxed/simple;
	bh=oQ0RqE3JrkeHIV7xjTtQZx2OcjAS+noNHSH0YhBLn+k=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:
	 To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=HpemHc/zOFhKniRlnRp1ZB2trPntEpm0MdudWqCEY6sHmPrDDesLSafmZ84vsmdKmIx+eJSpvoxkyH/Ih8Xi8VvKRk2B59IWWd2AlctFhcLlm2aRJzNWQx+i+Z+VYE1GI+REF/1OmbkRh4MoDZ3iAA1UdwbBjZqfj4dehGnQYB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MLvbiLKH; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7bee01886baso46990939f.1
        for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 08:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705507449; x=1706112249; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B+RlLfKXCPQRXZ/iE6H4TuCQ+OnQ4UMsCc6kMW3ZWgA=;
        b=MLvbiLKHvGp0uU1jEpFDc6itx//UmSPWKMWrJJow5oUnRPGpW07SMDbZmfheTnKN87
         5zy7wHkpQBB+kGSBcyXjdNiNWRUk3It9mv2bD7oNBlJeBi993xoaaYRlh0kUEnU2/De8
         OjzqjQ1x29C6vM5RN8MdZme3pW6Cx/K3m0phJV8ukIJYK4pR5LnsVmLxLZIK7XBC4F9K
         lgTnEV8dfqNij75NEbtnJWpKOd+khlZBiWZOLW5O0wI9ybNDLOchPtCqwWZl6s2hDYG1
         u7Fs3WdcmQnqOULMcVO8BMiyEwBP3uF0b48tQjc4Q0lzwTzuyg5YjzPToDUu4qwandXv
         l6qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705507449; x=1706112249;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B+RlLfKXCPQRXZ/iE6H4TuCQ+OnQ4UMsCc6kMW3ZWgA=;
        b=NGclrMZ5oJVgavBh+35VWOv3jhOIyGxc9HUZ/ujG2WzcKuNnKgPFWRCO09oOnQGSfi
         JDb7O5ZHJozR2q6DBCToVgJ3izSMjon+FmxVPTBzrdhAo1Y5t+/JTXCfr8hGefXiLjql
         YBESb4sjQ/BmoeAbCnJqP2GXrDLXXoNZWK399B0G0Y6kUk/kwm1Kz9+UtOng4zBDVehq
         ax07llbK2PzA7jpTHIMCORHXngtHKJI1hCPExMbSGp6BGXS80B7cytnyioMl0xISY9lq
         NnuL7dz3Nj/xIwJhrVr+9OiyWIe3zmY0hoTeovBZQPoNM5ou/M+i2DZxNphKet2K1icY
         xANA==
X-Gm-Message-State: AOJu0YwJLSsO6MJQ8QvueQogIQb8SmeuW65hpQLm87Jt+cOp8p7Ckc+u
	6nVULuBHWzRUljPH4wd6kDy6bOKQ437TSY9zP8rG8ttDN/ZVkw==
X-Google-Smtp-Source: AGHT+IHiuLM+y8kcrI2XLyjlQfhzHXSzmSs5L1QOnRBJahBjIWyT30lDYBe9/9fA8iqeO9cWBSAmcg==
X-Received: by 2002:a6b:6810:0:b0:7be:e376:fc44 with SMTP id d16-20020a6b6810000000b007bee376fc44mr14929456ioc.2.1705507449302;
        Wed, 17 Jan 2024 08:04:09 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e40-20020a02862b000000b0046ea72f2152sm487401jai.47.2024.01.17.08.04.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 08:04:08 -0800 (PST)
Message-ID: <80491979-03ce-412e-b7d7-719f3cf18566@kernel.dk>
Date: Wed, 17 Jan 2024 09:04:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/register: guard compat syscall with
 CONFIG_COMPAT
Content-Language: en-US
To: Jeff Moyer <jmoyer@redhat.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <80eceef8-b2d7-47e8-9ef9-7264249dedbb@kernel.dk>
 <x49il3suf1q.fsf@segfault.usersys.redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <x49il3suf1q.fsf@segfault.usersys.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/17/24 8:59 AM, Jeff Moyer wrote:
> Hi, Jens,
> 
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Add compat.h include to avoid a potential build issue:
>>
>> io_uring/register.c:281:6: error: call to undeclared function 'in_compat_syscall'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
>>
>> if (in_compat_syscall()) {
>>     ^
>> 1 warning generated.
>> io_uring/register.c:282:9: error: call to undeclared function 'compat_get_bitmap'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
>> ret = compat_get_bitmap(cpumask_bits(new_mask),
>>       ^
>>
>> Fixes: c43203154d8a ("io_uring/register: move io_uring_register(2) related code to register.c")
>> Reported-by: Manu Bretelle <chantra@meta.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/io_uring/register.c b/io_uring/register.c
>> index 708dd1d89add..5e62c1208996 100644
>> --- a/io_uring/register.c
>> +++ b/io_uring/register.c
>> @@ -14,6 +14,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/uaccess.h>
>>  #include <linux/nospec.h>
>> +#include <linux/compat.h>
>>  #include <linux/io_uring.h>
>>  #include <linux/io_uring_types.h>
> 
> This makes sense to me, but I wasn't able to reproduce that build error
> after disabling CONFIG_COMPAT.

I couldn't either, but apparently it happened internally with our kdump
config variant.

>> @@ -278,13 +279,14 @@ static __cold int io_register_iowq_aff(struct io_ring_ctx *ctx,
>>  	if (len > cpumask_size())
>>  		len = cpumask_size();
>>  
>> -	if (in_compat_syscall()) {
>> +#ifdef CONFIG_COMPAT
>> +	if (in_compat_syscall())
> 
> I don't think this is needed.
> 
> linux/compat.h:
> ...
> #else /* !CONFIG_COMPAT */
> 
> #define is_compat_task() (0)
> /* Ensure no one redefines in_compat_syscall() under !CONFIG_COMPAT */
> #define in_compat_syscall in_compat_syscall
> static inline bool in_compat_syscall(void) { return false; }
> 
> Isn't the code fine as-is?

It probably is, but this makes it consistent with the other spots we do
compat handling. Hence I'd prefer to keep it like that, and then perhaps
we can prune them all at some point.

Thanks for taking a look!

-- 
Jens Axboe


