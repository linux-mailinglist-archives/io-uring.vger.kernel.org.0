Return-Path: <io-uring+bounces-2283-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42DAD90F358
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 17:59:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 545F11C21A7C
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 15:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C28E156653;
	Wed, 19 Jun 2024 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g/UQQWIC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073DD47779
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 15:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718812071; cv=none; b=Rod6qG0Xx6PMuu/jaLQbgbUchdD3Yq4G4FS2N0x5dMPZT3wN89Xglzr/yWm1WEJoUUHIwQ7zYMSXsfRCSh3NbL+2CLV4+QjvHK5MfZM4IIBV0URyGHKSASzO/yDXy+MpSss9Q2kUbgR2TC1mg+KTp4ky0IgW4aqfNIJZIKY3nVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718812071; c=relaxed/simple;
	bh=wTeoZDSwDT1Ktztzn+SmR2arbV9o2yCoTnV2mHh+zjQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UGMmXRi3yYKRuf/sbrzMUvzwQJUlqI6O/k/XY6fOOJYJ/xQUdwl3dAVd4lrcF8yHH300NhPHRsN3LB3T9+MLn5RXr2b22bTwNK5tKZFpkBxtbKAzViXROO8z3wi3k1WddZsgovH4MQMtE2aHho+yoFAgJyI7rtAYIF5zcrKt1pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g/UQQWIC; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2c7c61f7ee3so589161a91.1
        for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 08:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718812069; x=1719416869; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIYHc/satjCtXbc1TAmT38ok0FcTH2r0ZP/WYHetLlY=;
        b=g/UQQWICjcFlj0+ZRHkJGTJxQRKIormkrDqR3TdNAAvo16iRu7ibdxwJc7JBZ55FlG
         YKeqF63LbNa+LHHFj1S++PkK1JaCewW6uNS4+cfAB6l5oT3BzM4db8OUiow/pashjE5L
         1iVu7EeWru6Ujfrl6NWKRpFt0jNucp9zfrfFqe6BIvVt0XR557UJu0y1gZHOWIUlz6Mj
         2hDdG5NSunchG85O+u3aRIqQmGvtOShIPAxkQphPvhFbF117zR0uH8SKSpNcI1fXXQMk
         yBMXwuKUFIc4TtPq5U1WBqO8dnmbEASztT3eUdzMJI+Hyzq+fc1/3yGnD5iFaJUMxmC+
         3Z0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718812069; x=1719416869;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UIYHc/satjCtXbc1TAmT38ok0FcTH2r0ZP/WYHetLlY=;
        b=hKJ/dUCIIbmOlW5K9szklsxtCLWGJhd5NJ5UZK0Z09X2WbCifMiUtTik+DGHdHX3rY
         M9CXcmmCodO6NC4xoYJP2xffaF4bja/n9ATFDUIjiRHHi9XEKlqos44a0JiiYUPsDIvS
         B6lm5LzpVJg7H+dP8smVMJ0djIig12Oh9k5dqavCCCMytv0NagR476SLVQa2QUHxDZkH
         vp9GlFuxpb6nYqvjcevBQZP+7iAcHHbQpAk4ka25seV9MYGo2w6fSe/e86+vTg6QLObi
         63odLjXqF82CKniaS7ccyoJmxKqEbLm8L1nvFxK0c8AeaeDxyKcgD0MlJib+FNXPu1z0
         OhmA==
X-Gm-Message-State: AOJu0Yy/sLbR+w9qmKE93C1c8sq4aDVJSYZIreFXcNppVD84XotecaUP
	TZluSHvpo8m5edIW2IR4XlA2+cJWUTAgU5ocDbEkksLgwyGIPFeB
X-Google-Smtp-Source: AGHT+IGWkwulzgVUkQKMwl7vRWLRZ7rXKtgL1e4rJy3DFbQy6lnF4tQTZN/mZAHn4XHKFjKlnrnfzA==
X-Received: by 2002:a17:90a:c384:b0:2c7:7708:f633 with SMTP id 98e67ed59e1d1-2c7b5b3268bmr2903165a91.13.1718812068973;
        Wed, 19 Jun 2024 08:47:48 -0700 (PDT)
Received: from [192.168.0.107] ([123.139.19.126])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4c4671209sm13019228a91.39.2024.06.19.08.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 08:47:48 -0700 (PDT)
Message-ID: <05758c01-265e-4567-8f68-8fbafec1631a@gmail.com>
Date: Wed, 19 Jun 2024 23:47:41 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: fix incorrect assignment of iter->nr_segs
 in io_import_fixed
To: Pavel Begunkov <asml.silence@gmail.com>,
 Chenliang Li <cliang01.li@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <CGME20240619063825epcas5p26224fc244b0ff14899731dea6d5a674b@epcas5p2.samsung.com>
 <20240619063819.2445-1-cliang01.li@samsung.com>
 <b51fe1ca-5a3f-46e1-a33e-a3c91ce9ad6c@gmail.com>
From: Chenliang Li <lcljoric@gmail.com>
In-Reply-To: <b51fe1ca-5a3f-46e1-a33e-a3c91ce9ad6c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2024/6/19 22:27, Pavel Begunkov 写道:
> On 6/19/24 07:38, Chenliang Li wrote:
>> In io_import_fixed when advancing the iter within the first bvec, the
>> iter->nr_segs is set to bvec->bv_len. nr_segs should be the number of
>> bvecs, plus we don't need to adjust it here, so just remove it.
>
> Good catch, quite old. It's our luck that bvec iteration
> honours the length and doesn't step outside of the first entry.
>
>> Fixes: b000ae0ec2d7 ("io_uring/rsrc: optimise single entry advance")
>> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
>> ---
>>   io_uring/rsrc.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index 60c00144471a..a860516bf448 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -1049,7 +1049,6 @@ int io_import_fixed(int ddir, struct iov_iter 
>> *iter,
>>                * branch doesn't expect non PAGE_SIZE'd chunks.
>>                */
>>               iter->bvec = bvec;
>> -            iter->nr_segs = bvec->bv_len;
>
> iter->nr_segs = 1, please
Why 1? There could be multiple bvecs.
>
>
>>               iter->count -= offset;
>>               iter->iov_offset = offset;
>>           } else {
>>
>> base-commit: 3b87184f7eff27fef7d7ee18b65f173152e1bb81
>

