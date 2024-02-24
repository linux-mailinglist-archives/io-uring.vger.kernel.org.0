Return-Path: <io-uring+bounces-694-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9253D86260C
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 17:40:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 276281F21EE1
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 16:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF5D3C129;
	Sat, 24 Feb 2024 16:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="MHwqQA0W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2197EECE
	for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 16:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708792798; cv=none; b=g5mumUz3baAHd91gmqCQ7gKk3onEsZdNpn+GC3aIwIQ9yfecIKOZqRqQTZ3V1w29xBc2uT7g5AxCxEM4f5BGcctBnX9iia0i7fkjvBeE7EeKXV3FJ7FpuS+M5txXPPiiNnRqUynq+zu92sCsZvHp4DARba3zOtSHzRDo8LTu7/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708792798; c=relaxed/simple;
	bh=7qHPFe1mswNhoJDTzd/cTaUERuUNnJ1ZX3IfjOJ0KQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g3gcwm83+dIBBPPvWu4uJW5zCiIXZ+rjWO5dE9M+/xZtriFo9HvicZJaCNA0terOQqXSl1o/tNazVg+zCdyilMgLEAwlhhEk14IClVNuwIGI2cDG1GBN0e/DnF6MY/U0itZL3Y+SbEJyjga0XM7K04knwFwMp2L3VPgWJM/S3Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=MHwqQA0W; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e45d0c9676so934182b3a.0
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 08:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1708792796; x=1709397596; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4zwx78bIA/sCiZL7lcX52XGiKoiJhoi7TJ3IM2HiaJM=;
        b=MHwqQA0WftNxR70L3x3eAra7+Fisb7iFy3eQBCuCZ+Me3nr6cGRD+uWc/aFBLIIW3S
         jUWK1iRH+S/Sy9PksV7xs3uMQUAk3SArpRWhajX6KniNL8B1vZA63VtKK8W/LMLnZpMt
         WtM/tteMHZTJ3A2o3At50JpwI/j1kAQemKMOgdUMqTo5ugK0JfpttYvtdlL4EWLhLYwU
         pkFcN4sp6lYtMNY6uyfMRtzMXl7C+FlEJssZUd/oHv4dkPmL6pGMUbmCRVJBYA5wmmgS
         H9t7dkxV4BQp9VDCss5sz/wBZj2hezXid52NObEUzzB2s7ISvEqYgZRClWK9M5ZRmUuC
         HeYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708792796; x=1709397596;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4zwx78bIA/sCiZL7lcX52XGiKoiJhoi7TJ3IM2HiaJM=;
        b=CSQxYCZQu4NQB1V2T8jTWT/bAtl4EnuOic4VWkBYGOs7FtZ/yySfxsIOUHXJprTMlj
         W8x3NxMTIc3aMU4E9BTirfArsDSmY4P8RZCdADKliYJ2kwAC6x4jJMOksSQyGRHqT5FS
         XJ7BzFOrmzEn6EVJ1R+jCea/OSrVU9N0wMgb28kYQlAy+2YLJMhvoLffKjMxm5q8E5YT
         xtvOB7loAKy8lsJTSxl+OdQxzPjsKqML9xN2tx/Mt8YZWNYdhB25A1hmXWslCf4QVqtZ
         ukbtg9uVLXkwJFbYI8odQYfiljQUo9WBweUDCazK2wZIDuvxUKTsZtqcyZA0WMYvNA52
         /YPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXo8H+T+C/eP87QOcIKXpv59z1LHOuDglDft+otO9AwClp0VQNuTb6vtOXn9CfzNQ984Ohvik3A2IjIo7aVIZ9TX9Ds0kZqZ18=
X-Gm-Message-State: AOJu0YwFX7WDJEG5OrXkV+P49imwCDNdM2trPKxM8rvcOHTtfcDEKkfU
	SsfRYkbo3yqKqCTgMFZpANK9J1jPv2xgJ/3kFttEUldCQh5KUuPiZHwMcrMugGY=
X-Google-Smtp-Source: AGHT+IGYaznl0wxDSjsc0gl69Q/lb895k/nJzNSIzW7GeLs6mfI1EiIUjTRx3fSoczgkq6Tg3z8OVg==
X-Received: by 2002:a05:6a21:3942:b0:1a0:decd:1b6a with SMTP id ac2-20020a056a21394200b001a0decd1b6amr4747530pzc.16.1708792796353;
        Sat, 24 Feb 2024 08:39:56 -0800 (PST)
Received: from [192.168.1.24] (71-212-1-72.tukw.qwest.net. [71.212.1.72])
        by smtp.gmail.com with ESMTPSA id f13-20020aa79d8d000000b006e3d79e74dcsm1323868pfq.141.2024.02.24.08.39.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Feb 2024 08:39:55 -0800 (PST)
Message-ID: <752bd679-22d7-44be-a323-29a621512a54@davidwei.uk>
Date: Sat, 24 Feb 2024 08:39:55 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/4] liburing: add helper for IORING_REGISTER_IOWAIT
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20240224050735.1759733-1-dw@davidwei.uk>
 <20240224050735.1759733-3-dw@davidwei.uk>
 <ed86f5e4-2f2b-4d56-9770-95ed3475f2c6@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <ed86f5e4-2f2b-4d56-9770-95ed3475f2c6@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-02-24 07:29, Jens Axboe wrote:
> On 2/23/24 10:07 PM, David Wei wrote:
>> From: David Wei <davidhwei@meta.com>
>>
>> Sync include/liburing/io_uring.h and add io_uring_register_iowait()
>> helper function.
>>
>> Currently we unconditionally account time spent waiting for events in CQ
>> ring as iowait time.
>>
>> Some userspace tools consider iowait time to be CPU util/load which can
>> be misleading as the process is sleeping. High iowait time might be
>> indicative of issues for storage IO, but for network IO e.g. socket
>> recv() we do not control when the completions happen so its value
>> misleads userspace tooling.
>>
>> Add io_uring_register_iowait() which gates the previously unconditional
>> iowait accounting. By default time is not accounted as iowait, unless
>> this is explicitly enabled for a ring. Thus userspace can decide,
>> depending on the type of work it expects to do, whether it wants to
>> consider cqring wait time as iowait or not.
> 
> This looks fine, would you be up for writing the man page? If not. I can
> do it.

Oh shoot I totally forgot about that. Yeah, I'll write one up.

