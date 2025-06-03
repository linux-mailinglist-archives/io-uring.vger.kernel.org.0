Return-Path: <io-uring+bounces-8192-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B211ACC75A
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 15:07:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54FE31893812
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 13:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF011229B12;
	Tue,  3 Jun 2025 13:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P6sRAuSV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9640F1EDA0B
	for <io-uring@vger.kernel.org>; Tue,  3 Jun 2025 13:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748956036; cv=none; b=KE51Xhpbq6GnPppGIop5JvxohuTqXjM4X0bKrm8MGWhA81XW76u8xwohpRW+r/bqmQX3WHP0BMhBfcX+NCC4PXV7WoauGSrL0JzfBBsnibANKUZQddCDDaUzoDF51v6yOjAtDceZ1+kmR/cumKJM4vsLuhCWx5a3UDnO6YuS0jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748956036; c=relaxed/simple;
	bh=AqpmXxayC8SAniHh0ZDzD09L8DO9mSIoDCFeKysn1x4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U1if5PFkODJB37UH1HbmHw40IE03v7ups5swBFwKw/tgs+OggVh+UmAEl6tdvIDm48Ov2YTmRjE62FwH/qxzaZqipAjfHjsJpbBbSXnYHjHcY95O4mFKudocKTH8uSmHWjOfi6UAr+TuheDkPY0cQqqq6ktD2X6r2T6bZVioQgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P6sRAuSV; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3dca299003cso50075605ab.3
        for <io-uring@vger.kernel.org>; Tue, 03 Jun 2025 06:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748956031; x=1749560831; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L0jmSOuAQFJrO/JaK3pmqLdDkXzudNfYAUErODZqvjU=;
        b=P6sRAuSVGMgqdzXa+Eqfy6B7LcEksw/kE0KGQ5MhfwUTzCep7wqjWcOabkAUzJpPMB
         KszYtPu6tmxkOUX33z7Mp311a19yHzIy7tREux7LxFLUoWG4BOZU+7eqoU1PnLpMr8ab
         JYWGXr2ExOLotnBjzmxKl5xcpxMOUG+mVuU3b5WhEje1H0BjG8daImhIMUXUYU46x3He
         8sDWZHeJ83u1m+PYW/j8WAeiEl2V4kP7g2sV3rGoH2iMXSo8T5mxVBRZ+6g/0i/B2s0d
         A5//hV4MRP4BZTS0jOGuqFDandFbiFJ549asCDu1B6DYXMBXbMRlJp5GWnHyn5uidRyG
         a//Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748956031; x=1749560831;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L0jmSOuAQFJrO/JaK3pmqLdDkXzudNfYAUErODZqvjU=;
        b=kutD8My9ONnljpNHLVV9QIHM0M1+MFX0rCpNa3vQO6YVNmVSBVM33k/0sAnoWYeHfV
         QLVPsHNk2wU5+VOuo0WuhevFHaw5OIIgLzTYr/KNLIQAtZYCGHuqSpGt8tJvdUE1ukYw
         DUY3ToVTtYuZQsVZihcBJ1xCBXL7UwaUpZS2heJkNM9iP60BrnxxG+SY9rici0KtMj0P
         YNQd/lEpW8WkXDQ9B4g3rpGKo0EOdum4f7YVnM4dC9lrj5HP+swIDK9MdFTGzv352zAe
         Z3YpeDZSJ6O7G0EzTrWeHPIhblRf1z55Nt6uMCegQuA6ET8OduAbw1yhYfIpNEw5JtNa
         zh+w==
X-Gm-Message-State: AOJu0YzfpRsdctovwoVg9P5EYgsXSAqUpmdR2ZMOqFRH1yK6jYGffVuu
	yh3vuOXP721Js8LXNJONrL68zvHOni+EA2XZc5IFMMwjxu0xWdR70I+5niuH5kYjWSg=
X-Gm-Gg: ASbGncspny5tSVWp2gb4w+Y+s4aPlSDomjISW6Or4UJ1cpu3GCi5+1IK7xIuYLJXitO
	GbqN2wkYTqDy3iLITdJ1KUO0crIxMjAHpR6qiXVsN2T4anPKim/22Rp26GuvjCIv63GnU6p5Aqu
	vS1Q2AHGSjhY1ssIWSz2hQCkCaNvSMBYdGGqhrLjNLxYxYE8O0uXpVW97E0LRc7QwAS3jsJPUk5
	+ThtWVYuYEHJtNycYpk7o4bGRcW9AeLcBhWc/YSclG4HqQ7ABcfp1yQxEfxA3/q7PrZ1h29yUG3
	hjRD76p2sXv0AsrQm7jgjZh6wuaigeq0uUKH1Xd6pSh2KYc=
X-Google-Smtp-Source: AGHT+IGvfV4h+Z0WE0fXjoOUWJN7so+tRC3QF0WZ+ZscHcAa0XVHmUfxAJFXyfRedzOzoCgyAx/V/A==
X-Received: by 2002:a05:6e02:1a23:b0:3dc:8058:ddfc with SMTP id e9e14a558f8ab-3dda3363edamr104433635ab.11.1748956031488;
        Tue, 03 Jun 2025 06:07:11 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7ed8682sm2225403173.75.2025.06.03.06.07.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 06:07:11 -0700 (PDT)
Message-ID: <996da65f-05d0-42a4-9f48-c5f89f097cbd@kernel.dk>
Date: Tue, 3 Jun 2025 07:07:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: miscellaneous spelling fixes
To: Dmitry Antipov <dmantipov@yandex.ru>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20250603092045.384197-1-dmantipov@yandex.ru>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250603092045.384197-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/3/25 3:20 AM, Dmitry Antipov wrote:
> Correct spelling here and there as suggested by codespell.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  io_uring/cancel.c    | 4 ++--
>  io_uring/io-wq.c     | 2 +-
>  io_uring/io_uring.c  | 8 ++++----
>  io_uring/notif.c     | 2 +-
>  io_uring/poll.c      | 2 +-
>  io_uring/rw.c        | 4 ++--
>  io_uring/tctx.h      | 2 +-
>  io_uring/uring_cmd.c | 2 +-
>  io_uring/waitid.c    | 2 +-
>  9 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/io_uring/cancel.c b/io_uring/cancel.c
> index 6d57602304df..6d46a0ac278a 100644
> --- a/io_uring/cancel.c
> +++ b/io_uring/cancel.c
> @@ -306,8 +306,8 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg)
>  	}
>  
>  	/*
> -	 * Keep looking until we get -ENOENT. we'll get woken everytime
> -	 * every time a request completes and will retry the cancelation.
> +	 * Keep looking until we get -ENOENT. We'll get woken every
> +	 * time a request completes and will retry the cancellation.

Didn't look through all of these, but cancelation is a perfectly
valid spelling. That aside, I tend to not do spelling fixes unless
you're also needing to change the comment anyway. It's just noise
that can make patch backporting more difficult.

-- 
Jens Axboe

