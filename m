Return-Path: <io-uring+bounces-484-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C245183AB0D
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 14:42:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 769F72868AB
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 13:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A4277655;
	Wed, 24 Jan 2024 13:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SA9JP0xA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF01D77635
	for <io-uring@vger.kernel.org>; Wed, 24 Jan 2024 13:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706103748; cv=none; b=aJbFbG7EXts1R1Jru3M0sj91lTxqd7gFhgrQhlmsqNsqKjHZlgfHtTrLxue/rE5J7aovuoBbc1ljs21KGzy+whAT2vHZsycVdcB9Atcy4MTuSBl440E9JHwQAIYbpeosXDB84tqeXt75n04IIzSmqkGNmowDxmNfgrFUM5NDZZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706103748; c=relaxed/simple;
	bh=KmYFB2IArQ01736v29zwL54nX7sl+jfkHEcb5e+NYGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pKyUK19tGW3ICOrGOnstl5hLUw4/smfPni7DOzwPxTpEddbfQ1ddd3ULU9OQW01V9jHqssYybhqFJ+zmJ804IJMXbSp2C9w4Cz+MmFjhFHKaJjLU80zldIUo1Y7yO/DsiSbNwBqidEJpb1mLzhrJs4Qxy9dvPUkalnH03hRjxAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SA9JP0xA; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5a0dc313058so553918a12.0
        for <io-uring@vger.kernel.org>; Wed, 24 Jan 2024 05:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706103745; x=1706708545; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AKuqkyBYrVIuNgJNsr37DPOuwhgVjfvtJJKY5iLaNKA=;
        b=SA9JP0xAKgeFZrDnIHOsxHNN7P+xMvQJ3h2zfiJ7+zJHFcKdENUhymA7uHOzF77Q8t
         NuJ/GwK8ANLLwns5kMOewa+Clj8wkpSIaKtZft21rOocetjCcQ2HActSxuvphEEmbHRm
         RVvMvmrOWAcn9+yUUtovuLKF/qUy+jEguo7S2ykrYwpLhctHFX7cglvdNnVTEkUxG2XL
         Gb3Lp3nN/CAZ+CHrUu0ljObpS0x0BM8nGPiBNSSPwaRyP/kDveTFUKYWdLw0IzexJYRq
         a39CnaCcxbgcYR4iEE9gcWxhofuOT7sUZ82V+U319HjkfqpXxbq5H5jUt+GECgux56Ce
         IErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706103745; x=1706708545;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AKuqkyBYrVIuNgJNsr37DPOuwhgVjfvtJJKY5iLaNKA=;
        b=qdjYGN4+OMrg3W7lLrea6h51doLyYJtRxaIwbMWM5g+nUtMDeEV+PTppFdGAzywDfs
         jIGrI8WHkASeF6HBlyNUZgw412PA8k3yrB24OzYMTtFHgmCb2zig0JoO3xqoq0VNo9ax
         wfgUquqq7MEzJVFLd8rJxzAncjG9teD17c+BfMNCZPZ2D4NyJdAdakTC3NYZ8MvSgbXy
         Q2ziBq2HzdCA5VshIMBBzH+rWdotl7WY3eflOKX0qrey+bP/iErR9gv0Q1PEurmisxzW
         xha5qzbbBPPsiQO9DjsECVkb96mz6Wwy1T6BcQefyrVFYqOn12k4yV30o48cHAdy01jk
         zVZQ==
X-Gm-Message-State: AOJu0YwCwtEuFWKqrLxCPcEvNYDgzEUg4n19Pi22+Hm2MlsUTviWxHMS
	KZjkSMfANuvBemgWstr753QXP+dM4YAw1bZbWlxVXihBdHkqr5Mqa/QeZOqgkcY=
X-Google-Smtp-Source: AGHT+IGEdKK6FkLQccAv6oKd+o3qbYvSK/OpW2JFL3rtsCtaLoNW2f17dDuNoP2s5NHUj36qXDD2Zg==
X-Received: by 2002:a17:90a:f001:b0:290:6b5f:fb0b with SMTP id bt1-20020a17090af00100b002906b5ffb0bmr2370841pjb.0.1706103745214;
        Wed, 24 Jan 2024 05:42:25 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id sc12-20020a17090b510c00b0028d134a9223sm14025301pjb.8.2024.01.24.05.42.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jan 2024 05:42:24 -0800 (PST)
Message-ID: <11a461b0-055b-4c21-8560-c9d2de02c09c@kernel.dk>
Date: Wed, 24 Jan 2024 06:42:23 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/2] io_uring: add support for ftruncate
Content-Language: en-US
To: Cedric Blancher <cedric.blancher@gmail.com>
Cc: Tony Solomonik <tony.solomonik@gmail.com>, io-uring@vger.kernel.org,
 asml.silence@gmail.com, linux-fsdevel@vger.kernel.org
References: <20240124083301.8661-1-tony.solomonik@gmail.com>
 <CALXu0UdfZm-UJcPqF5H6+PXPp=DC2SA-QFbB-aVywmMT5X3A6g@mail.gmail.com>
 <fefaf2bf-64b7-4992-bd99-5f322c189e35@kernel.dk>
 <CALXu0UeFNiFgTNtgE+-WQbA3-WForFm9pKH18xHo=GrB97zEAw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CALXu0UeFNiFgTNtgE+-WQbA3-WForFm9pKH18xHo=GrB97zEAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/24/24 6:35 AM, Cedric Blancher wrote:
> On Wed, 24 Jan 2024 at 13:52, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 1/24/24 1:52 AM, Cedric Blancher wrote:
>>> On Wed, 24 Jan 2024 at 09:33, Tony Solomonik <tony.solomonik@gmail.com> wrote:
>>>>
>>>> This patch adds support for doing truncate through io_uring, eliminating
>>>> the need for applications to roll their own thread pool or offload
>>>> mechanism to be able to do non-blocking truncates.
>>>>
>>>> Tony Solomonik (2):
>>>>   Add ftruncate_file that truncates a struct file
>>>>   io_uring: add support for ftruncate
>>>>
>>>>  fs/internal.h                 |  1 +
>>>>  fs/open.c                     | 53 ++++++++++++++++++-----------------
>>>>  include/uapi/linux/io_uring.h |  1 +
>>>>  io_uring/Makefile             |  2 +-
>>>>  io_uring/opdef.c              | 10 +++++++
>>>>  io_uring/truncate.c           | 48 +++++++++++++++++++++++++++++++
>>>>  io_uring/truncate.h           |  4 +++
>>>>  7 files changed, 93 insertions(+), 26 deletions(-)
>>>>  create mode 100644 io_uring/truncate.c
>>>>  create mode 100644 io_uring/truncate.h
>>>>
>>>>
>>>> base-commit: d3fa86b1a7b4cdc4367acacea16b72e0a200b3d7
>>>
>>> Also fallocate() to punch holes, aka sparse files, must be implemented
>>
>> fallocate has been supported for years.
> 
> Does it support punching holes? Does lseek() with SEEK_HOLE and
> SEEK_DATA work, with more than one hole, and/or hole at the end?

It does anything that fallocate(2) will do.

-- 
Jens Axboe


