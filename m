Return-Path: <io-uring+bounces-7395-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2495BA7C004
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 16:55:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21B9C189A132
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 14:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 844181F4261;
	Fri,  4 Apr 2025 14:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="v5azehZ+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EEB1F3BBD
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743778512; cv=none; b=lHI7lqpLN6ZlX1XaaA8ReMp9RkmDaNWFeJHDs5LYNgNPetPqJwPy39CvI7llkNAKgtminpi8x1qF5u9gi7d4150wTH1FxIcTUJTB6l39rEV21XAK18h1IK0+bdGBwTdj4DWdp2Se1SjMIhgK8+WYSbpG+rO7hifb/V7Cz175VrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743778512; c=relaxed/simple;
	bh=g2iVz5KDdNQzrCeHV2s7Yp4wrfWMk0qxezoWg++RRvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=n0UMAdaqDArO1svG//iWVvVEHJMKIMwEZfD8jrkDhtgicmZIhlFu5gqeNkJcfiicd+mDkmFJRE985MMfPXFJtyNH9rgjjJOqs2kqVDOlTw4oEWcMJ0RYSBohX3YMN2CLdAUMHIh3ZOgt7/q7CLIIv5zjMJFJ8kBvnKNb8Gr7LoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=v5azehZ+; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d45503af24so19010965ab.2
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 07:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743778508; x=1744383308; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6DP2PJHRDTKBlqcenbzADf6woDWcTPJihRbtD0yhxQg=;
        b=v5azehZ+b00qjrf4MzZtuo7ZBnBYaGkltGlEn+a2QD7fQgyzoSj52ARVwqnUCev0/3
         fNM28OptsUJmc0QqA3lobjD8Y1S/yfOZQKg9LEH0LzfYWWkKfWAcJ61tNDwf6tyQQRFm
         Lj951SSxtmIkZBKuPhlFV+pcsqspOI6fi0paUQQuk3R8gvJfdDcZYjTrA9utv5IpkwRc
         V8t3gl8VRzJYlAvHh94DV2+SjLdZou2T24JBmGkckltVaDAxU67/ro41KdZtmQr4EQM9
         blhVqpD2UhayMSiydptQ25JQpJkM/HAKI5hZ6824d+JmU6oOz4lszujarAHPOrWCbpB9
         kTbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743778508; x=1744383308;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6DP2PJHRDTKBlqcenbzADf6woDWcTPJihRbtD0yhxQg=;
        b=F0VnX9vg2JEzihJ8MT5emu23ly1e0CakDkv/9nbhR50e2SA1D8ZbufCCxcOlqM34eI
         CMI1s/e38NNx3xKH2I4D8HfUQYiwFhP0mO4JxUFwzpdmR+nvnSVFnbzwnk/izBiV/Khb
         T5dRMr+WiWj9Nr0+Ro4x+jZVfwGi9SvdRlbcr7BlbLR01MBlI0vZQU90oFMBD6V/Gjw9
         q6C2djRAiswFKnyEhbwGqkkriP7ziDAoYzCoIdWvEELyBMHcT7iYrGlbzg0Logp91Jrv
         xjqvPzuXt+kA50b0hV6AHfGI+CC2c5z/HAD3eZ11peqCyQI45039CALa83g9NaKFnend
         SIHA==
X-Forwarded-Encrypted: i=1; AJvYcCXWulA0rYHAwG48nTgSugXCpuKgOUEpwDSTqv7u4cmxIxpkEy9fEC/gur1S/hFhHQPdezZ8+fBYxg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjIOgTSQ1prn0pNFSaXg4x+bKrCcJp1ekWo1eegbVeMhpFA0yG
	Xo80EMWfbmA01uCfd1C8V0MBQICXNoHK6Y+CO5dBguSYXYjkYjQ4PF8vX+oIHRQ=
X-Gm-Gg: ASbGncsa78FDSDx0znhmQPfXDxhAU9eYixLLfu6BRi8axDJCpUTZtv8bY9wIl1bzIv9
	Et/F7hF8ucZbVHNL7+yic1ipD9zfidhgcWM6nByGiVwA3H+/Bm1AqLG5tFEpuYPJcVXG/zquFUv
	YEc7VWONc1Th7LX38m99+b9hjQ66LMb4AEn5YGipP5DZ4CVZ+Aa4GClDl3TceNMIOAk4zuO18CY
	QE9XzihCIACg2Qr4yvMaAkHsjzmaVHJ2WRVffd1QTNQDbnnvj8zNS27HpyPHnTdS8qOZfcZgB86
	O3IJ6x5XuVdLAjV+2QF4U/um9WxsY5acczL+1KOQ
X-Google-Smtp-Source: AGHT+IE+UL+06Hv6t2cDVBhB3Keo/el3OkdSFkICjDLWeg53SwTjoq1zXri+WRVT+9E0OExJmor1ZQ==
X-Received: by 2002:a92:c269:0:b0:3d4:3db1:77ae with SMTP id e9e14a558f8ab-3d6e3f659c6mr41315415ab.18.1743778508019;
        Fri, 04 Apr 2025 07:55:08 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d6de972a2bsm8451875ab.67.2025.04.04.07.55.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 07:55:07 -0700 (PDT)
Message-ID: <655729ed-7950-4b8b-baa6-5615eb11b8c4@kernel.dk>
Date: Fri, 4 Apr 2025 08:55:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: fix rsrc tagging on registration failure
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <c514446a8dcb0197cddd5d4ba8f6511da081cf1f.1743777957.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c514446a8dcb0197cddd5d4ba8f6511da081cf1f.1743777957.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/4/25 8:46 AM, Pavel Begunkov wrote:
> Buffer / file table registration is all or nothing, if fails all
> resources we might have partially registered are dropped and the table
> is killed. When that happens it doesn't suppose to post any rsrc tag
> CQEs, that would be a surprise to the user and it can't be handled.

Needs a bit of editing, but I can do that.

> Cc: stable@vger.kernel.org

We should either put a backport target on this, or a Fixes tag.
I guess a 6.1+ would suffice?

-- 
Jens Axboe


