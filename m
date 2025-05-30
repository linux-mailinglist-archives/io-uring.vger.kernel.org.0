Return-Path: <io-uring+bounces-8131-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F82AC8CF2
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD1E017E1E8
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 11:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3631C229B3D;
	Fri, 30 May 2025 11:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vExm2oWN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB55521CA1F
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 11:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748604698; cv=none; b=LUSKhNGoFutTmmiLJmEClFwqadsTvbOHq9Agd1HqAd+9l8QkuQDsqvffqngw5VnRPAQA0Tk7NaAA17H30JaedDshBtad/Aqt9gqZfOaybnP4KScW06I4TkGDQ0d5Bcd37/oJgYF7tw6nr/i6pZMJKJxHx639zv7K9+DjhgARLuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748604698; c=relaxed/simple;
	bh=6x0SfuJZ3i6+fygyZlrp2Jtrmef6ClcpR8r0mqJRUy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rWOlR1aKiTTu33hIYTy8mVWCHuqxxk+hGvoUfnU96Om0A9iD2tSVOP5LsT5JobUQHCKljgObOokjDjiVTvhqzv5mBxopWrdoRpwPThDrlfgbiMSm7Dfh3Oa03nM7098CN+wgOGUXA3EMp0B078+jzC8AU2wV2EE8EH3X3UmqZQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vExm2oWN; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-85e15dc8035so56138939f.0
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 04:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748604695; x=1749209495; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mjFb2tQIPwjAScUCBD+i4HGPsYvkeHXmYmS9+KColI0=;
        b=vExm2oWNBijgLN3FHR3vO6YHYMwLInlcLuVOX+TMHFbrlsCAN8Ytyyy9j+mQh77jvY
         aKBxI08/U9aJ9LOte0uXb/oQfA6nXpJpt/gJXYIVa1BB76DR/NWgpLfpYrMHJUslhwLL
         o/vMEU1LAOb2bzFDyCILFLtMqBTFQn7aedEsB77XhxLDX0XrZKrBY2zuc/VK80ZHhlbs
         jUtXbc+LADaYw1F7UJWmdIWKDgPhifecKLZ8qZkNo7ZwZQ8wJbJ5KpmQsVM+cmDw7ell
         5dhZX1UhJjrAH4PUZctqig+17MZqzZe72UTVpntNn29kcX21k57VJptd2/j8m7HwWrs8
         q7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748604695; x=1749209495;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mjFb2tQIPwjAScUCBD+i4HGPsYvkeHXmYmS9+KColI0=;
        b=UIEH7+kD8kLjkJg0QyVDXbpATT/EXsgnloc4YeIeYDeF/Sqn9AiR08sK+ZHcmAc4Mf
         Yof15HF2292whxaMapoW1IuXPpgN5XWIcWj7B5kIClQTe/REW1NJDzBThXJKIO0AV6m2
         CHDudd/cyIAo7kO383vk+VgG2JAGZRNvth6Spke0Mt/YO8NrftIx9aBlX5tlcpVcbxYh
         dQQjfgJ+m/WypCCNDkL9FOTdcckqlkaywlLBahjt9c8e0PgiovjTqF6wMuSsJL9xsPzK
         zW77Y3e5L6wFXB8Lkx1LcUJj2dUDEBxcmwrDm0vl77nphnAWxdCjW+hSHcxN2b2+Fapl
         /RqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxua9QZC1TCtIvl8nexSsqCD/+2YT0t3vP7qqqR06LkTvPZLRtYf3jYoJnuXnZ4s6R1wISsU7/YA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwOjUAzc1mGiwE3f+Ufs9pKMKyG+GYDP8zGADqi/SJl6T8/cFAa
	vRVri8braUxgvGxjOTRF88SMGYFCV1poL+48GmAOo0uAb5/7R/3ATX8CzYnX2uCBKo4=
X-Gm-Gg: ASbGncufKuo2X6PfWBzesqNbierP4z6AEYC0yTBGcBCdKykThExOll5ef9VNmY7p2Nf
	wYyLMlEsvVToulUPHLUNulSqeE+OtX78MPBBphjuoVY3yAimlk1M/3pzMG3dCyWAvV0FWjR2lFY
	e+l/EHPdv2G32hXeDjIXA+AstPiRO0ES+EpxgPMPaQobxNDzCYT2ngHd/HC1MlhpEIH6qswzIDQ
	it1qi71cyE3v/N+vGbUq5buU5c1AWFzCoTj+6PLqQiZgwNVSprNwz7BmuFcKNq5AC52kK8HmxVe
	0M5v74oganHnKqrqoJ6tLOVAHNKLfkMPL9YZ6LrVXc8kX/Ll
X-Google-Smtp-Source: AGHT+IEH4f8AXczCXvXxfHHUdiTxZKxJu0xw48zhqhT3yBzVUliYHf1CzE+Yxh9d4VjBBsAsFCYVJQ==
X-Received: by 2002:a05:6e02:248b:b0:3dc:8b57:b752 with SMTP id e9e14a558f8ab-3dd9cc02d78mr14382235ab.19.1748604694868;
        Fri, 30 May 2025 04:31:34 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7e3be98sm396937173.60.2025.05.30.04.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 04:31:34 -0700 (PDT)
Message-ID: <f3941c74-5afa-43fe-93c1-f605b4cbeb82@kernel.dk>
Date: Fri, 30 May 2025 05:31:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] io_uring/mock: add basic infra for test mock files
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1748594274.git.asml.silence@gmail.com>
 <5e09d2749eec4dead0f86aa18ae757551d9b2334.1748594274.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5e09d2749eec4dead0f86aa18ae757551d9b2334.1748594274.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 2:38 AM, Pavel Begunkov wrote:
> io_uring commands provide an ioctl style interface for files to
> implement file specific operations. io_uring provides many features and
> advanced api to commands, and it's getting hard to test as it requires
> specific files/devices.
> 
> Add basic infrastucture for creating special mock files that will be
> implementing the cmd api and using various io_uring features we want to
> test. It'll also be useful to test some more obscure read/write/polling
> edge cases in the future.

Do we want to have the creation of a mock file be a privileged
operation?

-- 
Jens Axboe

