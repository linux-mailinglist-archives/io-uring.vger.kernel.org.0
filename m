Return-Path: <io-uring+bounces-947-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F57B87C3B4
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 20:29:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F2911F2349F
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 19:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 022EB7603D;
	Thu, 14 Mar 2024 19:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KrQUwth4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D337976037
	for <io-uring@vger.kernel.org>; Thu, 14 Mar 2024 19:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710444556; cv=none; b=RWHhoyQ7VZGiTWya1PhWpi30kcty3rGBhqpw5nKwsejRXn/B99Lscv9GnohxwvYCsRI7NPYefVtSN1HOJdxeIOirUsEMp9Pa5L0PQP727FonIwFpXteZ5r1sxqmTkJ4/9kZCGQJ9W9gPSM0X48EGLj2ULC/8QChwPFPunBtNNwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710444556; c=relaxed/simple;
	bh=j370lb0qDBwQ17RgRxbnS+RhhoggV3WG+mP+d9ZizRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vE+/KW+OVH5CWcZvo21i6UnG6ma8fvybPy/gm+7uGWUaXX7jQUFQzUoA/ewcODU1AyOsHC2T/XZEFcp15U9y2wOe1nVcuNcUVTgQhSWIcXcaHlIW3slb3NTCWn6VOJtKSOYR6OqBtskx7Zj+DWrIx0chV+BQT1wiES5+CAf2wig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KrQUwth4; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3663903844bso2145535ab.1
        for <io-uring@vger.kernel.org>; Thu, 14 Mar 2024 12:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710444552; x=1711049352; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tQVXW4pqUc+5MvS+fpWDH4aAzF9Z4lrhR/aL1NZ4TIQ=;
        b=KrQUwth42/xei+2h9bSdkVReYS9vydXkZIjEhBA1+9LrhhOrmhhG2OX3cHpOb/o/5k
         KNlciErfzLuQuek7CoV6VwW7EhvPh83d8l/q8apH3aInncSjnvnZ803wvar8LAI2Ukrj
         x2dasU5e9dVGE+RKgEb6VpttCwFwLTu/Y2SRpZ048z6oS0ZUP8NRxP38MSQJnOshzAvj
         nV0uJ5+tDNI3ZzASHB/qdr8h5yAwxUeX1tau8afX+SnYodPGjYgN0FnHkbEB1+ye/RXc
         V5SPhJ9p/r8uYwy2BueyYJGMJWHbuCPInD93xZCmNfrgwu02wEkdv24N7d8R70hnnLoI
         HAhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710444552; x=1711049352;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tQVXW4pqUc+5MvS+fpWDH4aAzF9Z4lrhR/aL1NZ4TIQ=;
        b=hzDlTX9aZO3xulYA7/tQKwDKgoXJP0pcYKBET1qlSGQQHOnhnxp9IMZewQUYAZwXnv
         wGysmCkHUvzUodeQJwRZm1//rqnU1BdCaodGvEGhBNHaq23WXzUAIco5s7bpED7Mx75g
         aDVIBr3cw8JXPMZrroFdUuO+lKd1lT7EGxt97f7xA+61cFEkHy7Ov7QoX8nXCqzkQsP0
         birtzYSgrv8alNzKpFgNicH8p/45VfHWdoQ0VP3hpinnrMRNW3OtMrNr3wHSQMBXzRQD
         10V9dQ7RhjSsb1uUgyWx+ZN0Xm0Ux036GKA3acGzrZdSv50X4f+sN6SAoouEZ2oYPaZa
         JDBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXbB7CzMdZ2FQ1oLLDBX212lLejzeBVn6o5so27ey63l2EJ4SkOZkgNO2sHilTwkEq6Lxjp3QLKJn5gqs0z3KZdoPuPF2zkQQ=
X-Gm-Message-State: AOJu0YzoOHBAf28zJgSKjd6WiirC9l9woVAHfk7DKzsH7m9N+DDLFWAW
	NFxer5EpNyGdxZ+QBKw0DRQ5J0SoVhwV8uhRLDTKI8M6mZGhFxp04aOfjIa+cT8=
X-Google-Smtp-Source: AGHT+IFnRFRmvFHBWikJqk1InfxIyI1mPjv9exDYI7mEo9NnA42myZHRsEIgotQ8Y7Ss4bvUI6aiZg==
X-Received: by 2002:a6b:5c0f:0:b0:7c8:d3ac:2d31 with SMTP id z15-20020a6b5c0f000000b007c8d3ac2d31mr3088651ioh.2.1710444551935;
        Thu, 14 Mar 2024 12:29:11 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id fz9-20020a0566381ec900b00476e8efd3f2sm322036jab.155.2024.03.14.12.29.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Mar 2024 12:29:11 -0700 (PDT)
Message-ID: <16df2125-fdf3-49e9-9924-425a8d7e1377@kernel.dk>
Date: Thu, 14 Mar 2024 13:29:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: extract the function that checks the legitimacy
 of sq/cq entries
Content-Language: en-US
To: Xin Wang <yw987194828@gmail.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, Xin Wang <yw987194828@163.com>
References: <20240312194446.114312-1-yw987194828@163.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240312194446.114312-1-yw987194828@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/12/24 1:44 PM, Xin Wang wrote:
> In the io_uring_create function, the sq_entries and cq_entries passed
> in by the user are examined. The checking logic is the same for both, so
> the common code can be extracted for reuse.

Looks fine to me, though not sure how helpful it really is, it's not
like it's a lot of code and it's easy enough to read as it is. However,
a few minor comments:

>  					 O_RDWR | O_CLOEXEC, NULL);
>  }
>  
> +static bool io_validate_entries(unsigned int *entries, unsigned int max_entries, __u32 flags)

Line too long, please break list other functions. Also needs a better
name, probably io_validate_ring_entries() would be better.

> +{
> +	if (!(*entries))
> +		return false;
> +	if (*entries > max_entries) {
> +		if (!(flags & IORING_SETUP_CLAMP))
> +			return false;
> +		*entries = max_entries;
> +	}
> +	return true;
> +}

And I don't know why you use parens for the first *entries check, but
then not for the next? Should be consistent, at least.

> @@ -3854,13 +3861,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
>  		 * to a power-of-two, if it isn't already. We do NOT impose
>  		 * any cq vs sq ring sizing.
>  		 */
> -		if (!p->cq_entries)
> +		if (!io_validate_entries(&(p->cq_entries), IORING_MAX_CQ_ENTRIES, p->flags))

Again not sure what these parens are doing here?

-- 
Jens Axboe


