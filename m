Return-Path: <io-uring+bounces-6504-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39BEDA3A38D
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 18:06:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93DF7167651
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 17:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A800526FD8F;
	Tue, 18 Feb 2025 17:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vRhYaWe5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5505726FD81
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739898341; cv=none; b=Gki1utek62x/VUuJpoWFlHYOWPRWDzNMvESq/4aQXhxTu3tlYjqjdm7Xp9zvsNdft+fBjkSzYSUb0bLZ63IzsgwV3/Bgs2+Hf3HPS+TtqENgjlCbxRMX1zsWsw3TkcsDshQOZ8xyqv3O8Wzdcajy5IUcN4YljTFF/luN9LwpugM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739898341; c=relaxed/simple;
	bh=QgEUeXH02kizS3A9UTGGVTUTmQIWnE8f+V3uIUP+1ec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dhVyTMKdbctE+DD+IkwSc0uN2B57ydfXFtfVPB2NaoiNiwzcRwytMlvrO7yPMAP/ymNGtfnmw7fqFmWvTrU7TOjmxoFmB/0j0QKzCXUjBmXuGECHflletCa9sRGJzFe92D6CrHaRcqeTqzbjbFva4tlYXqNB+L/AbNCABVfJ+Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vRhYaWe5; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-855a1f50a66so42181239f.3
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 09:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739898338; x=1740503138; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7t93Bi/FWhUyTYBj2REjOls9Fp4SBxb6uy+juVf/1ZU=;
        b=vRhYaWe5y4TSGzr0CN/T/bhDpvDvJKtjips071w8r+P6KtZTiUbcDeymDtw3wrOrYo
         bJQBr4ncQ6H9DNAkueRoWUdR3V5diPtqIhg1i1rzYIbhIZgJTg9zgiTl5+zxq2HmJl+I
         n0BsLW7Yi+UqhH635/rZ072Rlcru205dBgX39NGwl7DIzvpe7KAr8nk1ZtLE98zyMrbp
         jnDzeMSjohbxIcWD4H3tE5bi6BoE1eVIRVrotGuV/KLGvyhiJfFf+0a9CmF40iJdqGkK
         V26hhmW3X2f8Tai5xua9OjrduY+j7bJRGpDMD7RR7QJ3Bm0xH/aCiouOsMZpqzgVzuSK
         QvhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739898338; x=1740503138;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7t93Bi/FWhUyTYBj2REjOls9Fp4SBxb6uy+juVf/1ZU=;
        b=a8Qsx8BPqG1vVWGOLQC9nydHZBP8IfxsGomspG3f32YpMRe2CIngHjp6H3flSy0Re6
         srIluGkBd7yK+4bh2obgEuGVb1Fyw7kmzSoKEj+opCa0Wm2fHOW417R/XYLwrRtjOunO
         WAPN8pKc1rT88+89vSXXOjZjAT44r7VkPzoMwyy2IJY5e9R6XD6U/znj6C7YuXFdRZ9z
         21WB7LMNpRte9PorxxdnX6ssYkrsCEKWdbUCTiEyCmYx+LsiCfbvVj5Z9U2jFjjHNeXL
         8vc0CWIQ2z14TaffW61QJXEyUzHYTxORhEeI/JCBhwPMyEVutH5XKRhXGnTTz79Da1Jl
         kWuw==
X-Forwarded-Encrypted: i=1; AJvYcCUxBCa3xzPmLsRVDXY9kVyyn/W4fvU/YdGE0IuUfTR4YCDRyhcNz7AJUTJPi3PkwlbguKL/rozFaA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc4gq6rha9Phso4JTW6D6ric4ZgJD10gxMiBE+tznhrnTBM4Bj
	rzKrNLnCiEHXwQSr0R+p2DWUomYBlsSkzx5f0y92aIq/E3Dvy0J+PyE0ldC4+QCJpdfW6JHgihb
	G
X-Gm-Gg: ASbGnctd6n/IA+eEdHYZKTu5k1GmVnIvkVP64qCZ+lBHUhII/1Ar0WysS5XvIuPXrBZ
	NOO2+vavvMs/9EvSzhrA/m46saoW8xAX8OOHRsVUi1460WIph4PKkdvW030xF2lGqkNTsdQUlir
	MAnXNFeUwBlhJZ/WKbjWh7kPVw/iM/SG1lzPe++LZHEyvzFdIMcrhJ1Uy+rnGRH09Z3DEPARBai
	QaVwqRM7UHApmIMQIgc+ngI9U++lxJyuR861aP7ITqEdvPzwrZnOGduP7o0gTxcebUB904oYm2P
	A6k39Rjc4zfO
X-Google-Smtp-Source: AGHT+IEHJrjaoVOXz1SvqKcvOyeEOk/CbtHkozIHpAFRy9DIBQLJEfVsOGcmX80gblX6xPvd+q97Kw==
X-Received: by 2002:a05:6e02:12e5:b0:3d1:97dc:2f93 with SMTP id e9e14a558f8ab-3d2b538ad3cmr2724035ab.20.1739898338268;
        Tue, 18 Feb 2025 09:05:38 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed282acca3sm2703089173.79.2025.02.18.09.05.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 09:05:37 -0800 (PST)
Message-ID: <4276270d-0fe3-48fb-b44c-79734a945319@kernel.dk>
Date: Tue, 18 Feb 2025 10:05:37 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1 2/3] zcrx: add basic support
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20250215041857.2108684-1-dw@davidwei.uk>
 <20250215041857.2108684-3-dw@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250215041857.2108684-3-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/14/25 9:18 PM, David Wei wrote:
> diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
> index 83593a33826a..cedc71383547 100644
> --- a/src/liburing-ffi.map
> +++ b/src/liburing-ffi.map
> @@ -222,6 +222,7 @@ LIBURING_2.9 {
>  		io_uring_register_wait_reg;
>  		io_uring_submit_and_wait_reg;
>  		io_uring_clone_buffers_offset;
> +		io_uring_register_ifq;
>  		io_uring_register_region;
>  		io_uring_sqe_set_buf_group;
>  } LIBURING_2.8;
> diff --git a/src/liburing.map b/src/liburing.map
> index 9f7b21171218..81dd6ab9b8cc 100644
> --- a/src/liburing.map
> +++ b/src/liburing.map
> @@ -109,5 +109,6 @@ LIBURING_2.9 {
>  		io_uring_register_wait_reg;
>  		io_uring_submit_and_wait_reg;
>  		io_uring_clone_buffers_offset;
> +		io_uring_register_ifq;
>  		io_uring_register_region;
>  } LIBURING_2.8;

This isn't right - 2.9 has already been released, you can't add new
symbols to an existing release. I usually bump the version post release,
but looks like I didn't this time - corrected now, with a new empty
section for 2.10 symbols as well where these should go.

-- 
Jens Axboe

