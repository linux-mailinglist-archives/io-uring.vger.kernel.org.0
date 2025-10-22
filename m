Return-Path: <io-uring+bounces-10145-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA48CBFE610
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 00:09:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87C283A90B3
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 22:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6642737EB;
	Wed, 22 Oct 2025 22:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UORxe8aW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CD92D0601
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 22:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761170957; cv=none; b=A8bSiLSVUAQW9Q4zHVJvUQuT5EH0tFpnJy1Eatsv2p3kEECRk7gSnbgtVE3QeHIqt0NfVlcK/Up0X9BXIGkPqfjo3OIWXBEE5KMIn5edsDG6KTD0qneoitxFwFHP8Lo0323UYoT0FunCKdziEZPLastafZ8T5KdFE6pkji0IjAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761170957; c=relaxed/simple;
	bh=/JGdV79ZEP2WCwKZ71GPJzb+M1pQWZ8Fy3gNTdMvnSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eZfoU6QlILegf8GsctZ7zj143PoI3Et1qp+hai80rmJsC5udA9sexqoIYoO3Jgy+jvSf99T6I0d+rpXA38heEQYbbXwidPxQCDsP1WmiCutyWsSsKiVcKRuu4V8LPOFdvmuFuLID3sAglM+rlfVbGxcVfybOenJWWgKijgayqqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UORxe8aW; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-93e7e87c21bso6076339f.3
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 15:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761170953; x=1761775753; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RCItLc9KGBVamy0aSUAR2HHXp9GzPs7MkdG1WDe9bII=;
        b=UORxe8aWxaJb++qrDm9j9NIhNBeOorYZrOWv37kHH3Na0oAIvwKhMyNsNvmmg3UnTl
         9ux41KkxNVVDGCp0qdpue0a145FPMlzQiFBDSzWlR0olhGzWF2kDNoQW7gYY8u5NFJ1n
         eGZOXSRo9XSl15VmU1H80n77hLUUcJZPxz4rlBs7J2ZzrbDJqcqDNRfDCOhyQzGQuFbj
         3UvP5lrz6RIBmHGdMKy17gt/NP/LLz6D4Nv2l891K4W/ad8CV/mh6V8SPCT7XsuB9e5P
         N80dNV/1ouqrDQWjbYZ160dDRE269ce1WUa08AliHQikbAi/4rMtFXJutVrRqwgWudgL
         +7Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761170953; x=1761775753;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RCItLc9KGBVamy0aSUAR2HHXp9GzPs7MkdG1WDe9bII=;
        b=kSJnULxi7+KnBVb65Iaycz8O9yIhG3nsOyr1aIomZRAulgBB1hi9+utRJa5O/lhgnr
         v7Pb95S/G/cv++FOMTADz4RQRwz+Na0Aoe9z4Q8kzKvKhNcYVR2SExax3QkxEBGiFlbk
         QJqfJ3XL32RQxa0aLwweKkfGV35NcYiUplzgY12eVAFE1p2zzh62J6WvgU/xnbcLWp/Q
         332YqTxf6eI3OgGN9hqPaKMfnKKE02SaRRKR90kqLUXw3agI1Rda3vTTQkBDICZd/+uY
         lPg35eIbFF3xTIjoqrXohwu93Nx1de/ku0AJnx3SPH1VbFEhQjKOoGJ/Z/wmrevT+fY1
         Yhfw==
X-Forwarded-Encrypted: i=1; AJvYcCW5TUeQZe+bEtepZ2VBKHUjV3gYmlWyeyXXVRPplEDOphFNzF5iQgmSeWrVPxJJ6fI7guTFUmZqbw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzhzmL5X26/WPXkKMmXKv2BuNeJ9KVGvJUua7E+Al5A/uGGvOid
	L9JDIGR0ysIsh3twsLT168PqZ1YNyKfKQn5EVDmTbVUaEThjsp56Ei/7sd9L4xWbmQA=
X-Gm-Gg: ASbGncujcMmyHWqV9YpVUvlehuOkjv6vq/QBIPvjV0DU2R+RDzqnp4MEERQEBA4BvQT
	pjnCSNejlPGw+8/QaAMAj2cmWHNBsd/p/odz9UwI11xV+kaZj6wEmaS4KmGjX49RRK5oSPgsm2i
	QkCr73tCWe8x2uwgv3JRZpAGTPGFdEQFuE7ReRRk2QttWoa5tb+F3rWgZWNYRqo8Mb+w3Qb/508
	JNP0gH/f5rHG+IBSHWzVtyrO0rn1OHXk94FopUi3QcrecxRLXQTA1Fd4VBzRcnPq1+VNjujTqkd
	Laega7Pi/0KT3vHFCKLFLuaysGr9Qj2JRJp2kUL3i7/Y8rkE4MnFsxU1JYXNeA3dcvBitlr0G+7
	eV1Qlj71bN5zm8t4AkBxZVHZ6ziahlHyyagWpBPgdq6z3YNtMsILC0sUd0V3ts5nllif+CqRusA
	==
X-Google-Smtp-Source: AGHT+IEC6S5xBaUq9gas40eUIwVeKZ4D+FVuXplQtBp0Y5o+w8+st5r+/ho/DZNJo5QEIWMYjaTe+Q==
X-Received: by 2002:a05:6e02:3f09:b0:430:cad8:4610 with SMTP id e9e14a558f8ab-431dc20f615mr5092935ab.23.1761170953283;
        Wed, 22 Oct 2025 15:09:13 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-431dbc21fe5sm1881785ab.3.2025.10.22.15.09.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 15:09:12 -0700 (PDT)
Message-ID: <48302ec5-22d6-44f8-a18f-749175df8c39@kernel.dk>
Date: Wed, 22 Oct 2025 16:09:11 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/fdinfo: show SQEs for no array setup
To: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <20251022205607.4035359-1-kbusch@meta.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251022205607.4035359-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/25 2:56 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The sq_head indicates the index directly in the submission queue when
> the IORING_SETUP_NO_SQARRAY option is used, so use that instead of
> skipping showing the entries.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  io_uring/fdinfo.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index 5b26b2a97e1b9..f034786030105 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -95,8 +95,10 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>  		u8 opcode;
>  
>  		if (ctx->flags & IORING_SETUP_NO_SQARRAY)
> -			break;
> -		sq_idx = READ_ONCE(ctx->sq_array[sq_head & sq_mask]);
> +			sq_idx = sq_head & sq_mask;
> +		else
> +			sq_idx = READ_ONCE(ctx->sq_array[sq_head & sq_mask]);
> +
>  		if (sq_idx > sq_mask)
>  			continue;

Huh indeed, I wonder why that was never done...

/checks notes - oh it's me. NO_SQARRAY originally forgot about
fdinfo, and hence we got a crash. Rather than change it to display,
it just added the break.

Could argue that:

Fixes: 32f5dea040ee ("io_uring/fdinfo: only print ->sq_array[] if it's there")

would be useful here?

-- 
Jens Axboe

