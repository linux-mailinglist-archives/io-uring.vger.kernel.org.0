Return-Path: <io-uring+bounces-9865-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02484B9511C
	for <lists+io-uring@lfdr.de>; Tue, 23 Sep 2025 10:50:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B74EB2E0191
	for <lists+io-uring@lfdr.de>; Tue, 23 Sep 2025 08:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 728EC31D72B;
	Tue, 23 Sep 2025 08:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DNIskspX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57B830EF7C
	for <io-uring@vger.kernel.org>; Tue, 23 Sep 2025 08:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758617454; cv=none; b=imUGWooyx6hMoHT6caioTnPec/vWPmVwLDidMFc8CHWu1ZB0IK4vhwW5Ck0Loz/Kcx6WphpAhN0xc10RD+4IZ9zA2T1t69PGtAV9CJCexsydx2Dpx4bj50utTYcf0ev0sBdEk/F6L+h8ST6suwgAtWvGWYphflCYea/uJ5S2yL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758617454; c=relaxed/simple;
	bh=REocMjmsu6AX81gp/uzAIKIwKXDw2DKeLsxi6s3GM3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jQM4QFBU+JyOn87LpHJMxumn35YvwzESYppdcZcwIhnNC40OSmzxhAZ/JKet4kuEo4dXibLzQ62ZTZO94Ny9OVN7CDIjXAiOjN2ym4nSR94FbUzjsoA6xR7JrcsPR/mTKwOGDvai60EGrGjsdFpFdtum7OImfYS0XT8CqNLl67c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DNIskspX; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-26d0fbe238bso30281105ad.3
        for <io-uring@vger.kernel.org>; Tue, 23 Sep 2025 01:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758617451; x=1759222251; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TElWDiK48oXYCouZ3wAyzgEnzHydL1jtaDbh0rIsFlk=;
        b=DNIskspX3tvq0ZGDMZWlF/CocJWN4NaTQz02Bn2zW5ildekaTqAkgrA6EOYoq97K++
         PHdRyiscv9y4n1BFhrTj6opJkXNRzoN8NzlhigLzQaf6hSrecy3fB4E3EdR6nPjUd8TV
         3mwnsJH7LLifDcHtYkS64tH4fKMYgZ7ECkPeAhX25eYJmIg43hGSfEM0Bd+MTo/YXbGB
         OAjnPf0DghKKNx1ppNX7DgSbsnLvtKO9OoMQFWJokqf3vqVSFSLT0/2dzyGtdzZYouor
         8Go/o2eWGhnFBVYTwyDFPU+qTTEq6U0F5cHG7mX5lWVqjBFg7A2b9dPGMQgW8NlSUpoN
         q6XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758617451; x=1759222251;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TElWDiK48oXYCouZ3wAyzgEnzHydL1jtaDbh0rIsFlk=;
        b=lOcUKAASyLGUnlzHioyaY24+GamZ3TaB6u7qoxx8ERaCQ1HXe3o1qa2wFhFRyDQID4
         uNkDRQ53SfUDLYR02gUNJqrFP8sNCSizGOaFrAfNhEn6RWe+mE0T77p2Zx88AdfAkjEC
         Am9QX1Is182xzdtd3kxMJiWVsYdHAFOrG4G2Z+nugxYB/vGOnKrER8DaoBteL0GQAwK7
         EeacBkB8EZUTRfQmFrQnsxRVmlcsoacwbXi8CMrfRIh+HK/XjQq1Y4loXan6Cm2jXtlU
         NWuRWU5PjMX+pbpAh7nCb0RSCbg9oHqjUyFz5VZ+ovz+Yrn8xDdEMqvlV8CkYw/P1loq
         HMAw==
X-Gm-Message-State: AOJu0YxXirSQlfPOpSdyfHPBj6ILO+RHbN8yFmrcEzusLhPXXtA15xqc
	d429Dw+wash1u4Y0MrbAnY06gNM3C/guzIP+IaPNTuLZvCc8dl/UefDxKcOWPd0Elktp5iCZejR
	awAJyBJM=
X-Gm-Gg: ASbGncvN8YhsNB7qeOBTzHu6OPdzLotMwjnPzubixY/QrHksPi2Si+8Sl18lqIAhbp/
	5bof/rFwRUQUXU07E+KLlHGrpwIl+q8VwU1qztDHvKqtpfKfCVK1uvDybOiRf5m1KmGEfnrfN5a
	6sEPWrjXB7heoXMcK2GgiVpJJCd/GzgpsTCjPbYstmomjaScvukMut44REIyUhClAR+2K58yckB
	gNVBhfzDB8i+Ua6cs/0v46l39f89JlIXNmJ7H3AAUjcTlSh4dx0IyQluy9VUKHa8LcoHEQsOZAM
	FHTaBSAoYamGo9uOlKs5ttVjjnKfcFgWvR16cedg85Jtee2ySlFgDPhENrUGvILxgNCdTR/hSSN
	rp+wNSj0KGfkHH9yupluexYc9a0IFRZNtqXRnsq8mRZIlG/P64M9WR6AFRQOoYZlnfw==
X-Google-Smtp-Source: AGHT+IFQOpul0tUxq1oXdL2Hhgnzczxm+Zls0iozp3haPh5dKFynoX8TDzhJyfVZuaTiPwkXybDupw==
X-Received: by 2002:a17:903:388d:b0:271:479d:3de2 with SMTP id d9443c01a7336-27cc1e1e758mr25738465ad.13.1758617450986;
        Tue, 23 Sep 2025 01:50:50 -0700 (PDT)
Received: from ?IPV6:2600:380:465e:7d48:c981:e35c:e96a:4ed1? ([2600:380:465e:7d48:c981:e35c:e96a:4ed1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26980053decsm155900555ad.11.2025.09.23.01.50.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 01:50:50 -0700 (PDT)
Message-ID: <b0b0db4c-ac91-482a-85a4-2acd2884e5ae@kernel.dk>
Date: Tue, 23 Sep 2025 02:50:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: remove unnecessary check on resv2
To: clingfei <clf700383@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CADPKJ-7cb9fcPbP3gDNauc22nSbqmddhYzmKeVSiLpkc_u88KA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADPKJ-7cb9fcPbP3gDNauc22nSbqmddhYzmKeVSiLpkc_u88KA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/23/25 2:41 AM, clingfei wrote:
> From b52509776e0f7f9ea703d0551ccaeeaa49ab6440 Mon Sep 17 00:00:00 2001
> From: clingfei <clf700383@gmail.com>
> Date: Tue, 23 Sep 2025 16:30:30 +0800
> Subject: [PATCH] io_uring/rsrc: remove unnecessary check on resv2
> 
> The memset sets the up.resv2 to be 0,
> and the copy_from_user does not touch it,
> thus up.resv2 will always be false.

Please wrap commit messages at around ~72 chars.

> Signed-off-by: clingfei <clf700383@gmail.com>
> ---
>  io_uring/rsrc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index f75f5e43fa4a..7006b3ca5404 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -372,7 +372,7 @@ int io_register_files_update(struct io_ring_ctx
> *ctx, void __user *arg,
>     memset(&up, 0, sizeof(up));
>     if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
>         return -EFAULT;
> -   if (up.resv || up.resv2)
> +   if (up.resv)
>         return -EINVAL;
>     return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_args);
>  }

White space damaged patch, but more importantly, I don't think this is
worth adding. Yes it'll never overwrite resv2 because of the different
sizes. Curious how you ran into this?

-- 
Jens Axboe

