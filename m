Return-Path: <io-uring+bounces-7129-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B8D8A68E5C
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 14:59:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0468188D28C
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 13:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E5BA2FC23;
	Wed, 19 Mar 2025 13:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fPEeKXil"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5A5374EA
	for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 13:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742392267; cv=none; b=gXemXn4HXiHHNMJnvRVLjqulMqQmiR4l6LtBKPtvCygdAcgrxUp7ZrWhtGbirBE7hN84tnWcsSjg7LhpdDbuE/UyF+gqNCqqygdlaGhkiC+kCSoxMablwdaqNVfSSidwmr350dZh4AfLIy7CVUJjYWzAshMthB2hzPKVGzcT2II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742392267; c=relaxed/simple;
	bh=9h4yrDbJTQ2nrIwLEI1MvkBMzEf7Z2GjBg4elQFZEvU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=R6fdkL+2lG+YrFr8R3m/R0bvvlfVPwcd2RBF8Fy1gmilwCpbkrz3lV+FCvrrK3INjY6FZFsIsDxpgscrGJ3lmiAK4iszYQafEOXBAVR8o3/gw9Pyjrxi4Etqh3EacX5u/bTKxNVeiPH8aKaqxVOW9CfwyZoEU1tAxRYuXCORgqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fPEeKXil; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-85e15dc801aso52505439f.2
        for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 06:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742392264; x=1742997064; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mf0ZY3RkAnGlVXskDazzHa97ybeJQ7TVxm1TpoxB27M=;
        b=fPEeKXilfa0Tf+LbQ891KGzDGbtXvwUkY4W9sTyKwlyyS1J4hVHPdHouFQ+jQ7Tn1I
         C+f1GP3MXbYed+uCnQELda6tsd1lXXCbLzQq41Od2pw94ihVeCQZeqYf0UvUiPLOJWzx
         twq/dmqltPLg9GhG9tdrcjsKJ/6DY+w28+SE9fTQ8wvAvHYwM7+c3WQETOCSJMkGA7Hl
         f/nKBRSfXa6D/elufJ1Bbi6mc/ZsbtXrbKrJ/pFYpeChlkHoL1jHBuHpW7eesdItX+UA
         XgxklhbJpLOhxg783x4pFe03jWAy8rWcdgMt0jA/UM7U5KHSB+4pCMq/TQm01SogsgXg
         BhPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742392264; x=1742997064;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mf0ZY3RkAnGlVXskDazzHa97ybeJQ7TVxm1TpoxB27M=;
        b=Lmv/pVNEoHvUTQAENPEyR1j5hp1k7URGBhYm7Fx50qTtUF8/CXW3VHgAGd/xKJkhz8
         /sJBWMDSUBTps+rPUx2RzfItLTR1LWUy/ON7I1hHFGa2OpBGF8uAOFcif713eJCEnOw6
         GjepnquH8HpyLEd4pl5SbVZAvRC+EDPbM7fqKc+CV8OX1lRNYGqjgjjMDm1AF8Bz/eYJ
         gjk1zZSsZFRS2GxCFH5Xtsg1jZs76FsIoPRzhfnsPby89QyBYLVVhR/0aXUXK3BKpiek
         xJaooCiiRNkwoZvvDk/7jm7+Eb6tMLluPOPIkgQz/Ih201/c9BKwe0Tcu9RBbkVzPRfJ
         rZYA==
X-Forwarded-Encrypted: i=1; AJvYcCWJfKauK0EsZ1ZPzM0pFjpJOpBkl8aTT77/ekBhh5KD5vkOO+yFTcaxY63X28WtmcXPfI5li+koTw==@vger.kernel.org
X-Gm-Message-State: AOJu0YweTWhmLGnQkAfPOkppumaTJRYz2oOrSZAcIr8OSASCWTv6JQNE
	D8Zct0LkV9eL0zrEFY/cZYIwvevrdK3fwKkjznBEgZeSpJyYxY0kW/J6b+C6Azg=
X-Gm-Gg: ASbGncv/cBcgTl7J0jWFyUfNUF3/H/iAEIhXlm9S/mh3rv0gtaSI6dM7sIlS7qJTssO
	MOD2WZ/td0QahqvNbhZ+3GPMtZ749XA7xBGYT0zV11Pxvr4ajjO+W9s0HVMesFYcZVb+wY5a6/W
	GvdMfsd/Wh0WMf9kZzujmp1uUSPLLEmeEgVWL0w26jGkuShlTcwuOxkz1+q+CDIAJmqvZBNj6Ql
	Ot0dvC8ZUkf/PsRImLuzxuU53MPeFrtL9dykMKQSlO8c8zWykgX3ie2Gq9xLj0MCekCojtW3+Ba
	I2DzoBbVumZlSgY4/A5Uzia6Xa1rpy9xl/rXzFe/
X-Google-Smtp-Source: AGHT+IF5tihSvg6sYp+HsiOElzFbkZks9n7c92h1aR2beYXIBTdkUxMb0S2TthzIJ6ra3b8Nqhx3Hw==
X-Received: by 2002:a05:6602:4815:b0:85b:4941:3fe6 with SMTP id ca18e2360f4ac-85e137dfce5mr320217739f.7.1742392263760;
        Wed, 19 Mar 2025 06:51:03 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637faa36sm3215415173.77.2025.03.19.06.51.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 06:51:03 -0700 (PDT)
Message-ID: <5d5c5b74-2da6-4118-9559-4dee0e9d9a72@kernel.dk>
Date: Wed, 19 Mar 2025 07:51:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] liburing: test: replace ublk test with kernel
 selftests
From: Jens Axboe <axboe@kernel.dk>
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
References: <20250319092641.4017758-1-ming.lei@redhat.com>
 <b49e66d9-d7d7-4450-b124-c2a1cb6277b7@kernel.dk>
Content-Language: en-US
In-Reply-To: <b49e66d9-d7d7-4450-b124-c2a1cb6277b7@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/19/25 7:47 AM, Jens Axboe wrote:
> On 3/19/25 3:26 AM, Ming Lei wrote:
>> Hi Jens,
>>
>> The 1st patch removes the liburing ublk test source, and the 2nd patch
>> adds the test back with the kernel ublk selftest source.
>>
>> The original test case is covered, and io_uring kernel fixed buffer and
>> ublk zero copy is covered too.
>>
>> Now the ublk source code is one generic ublk server implementation, and
>> test code is shell script, this way is flexible & easy to add new tests.
> 
> Fails locally here, I think you'll need a few ifdefs for having a not
> completely uptodate header:
> 
> ublk//kublk.c: In function ?cmd_dev_get_features?:
> ublk//kublk.c:997:30: error: ?UBLK_F_USER_RECOVERY_FAIL_IO? undeclared (first use in this function); did you mean ?UBLK_F_USER_RECOVERY_REISSUE??
>   997 |                 [const_ilog2(UBLK_F_USER_RECOVERY_FAIL_IO)] = "RECOVERY_FAIL_IO",
>       |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> With
> 
> #ifndef UBLK_F_USER_RECOVERY_FAIL_IO
> #define UBLK_F_USER_RECOVERY_FAIL_IO   (1ULL << 9)
> #endif
> 
> added it works as expected for me, but might not be a bad idea to
> include a few more? Looks like there's a good spot for it in kublk.h
> where there's already something for UBLK_U_IO_REGISTER_IO_BUF.
> 
> Outside of that, when running this in my usual vm testing, I see:
> 
> Running test ublk/test_stress_02.sh                                 modprobe: FATAL: Module ublk_drv not found in directory /lib/modules/6.14.0-rc7-00360-ge07e8363c5e8
> 
> as I have ublk built-in. The test still runs, but would be nice to
> get rid of that complaint.

Oh, and looks like it should also skip the test if an argument is
passed in. My usual setup has 4-5 devices/paths defined for
testing, and tests that don't take a file argument should just
skip.

Forgot to mention, that unifying the selftests and liburing test
is a really good idea! Will make it easier to sync them up and
get coverage both ways.

-- 
Jens Axboe


