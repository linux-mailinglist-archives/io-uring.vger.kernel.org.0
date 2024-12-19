Return-Path: <io-uring+bounces-5574-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A0409F863A
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 21:46:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F63D189676D
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 20:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2187A1BEF81;
	Thu, 19 Dec 2024 20:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="herbTaDF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1673E1A76B0
	for <io-uring@vger.kernel.org>; Thu, 19 Dec 2024 20:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734641146; cv=none; b=uqhYa9LpIyIzgpW7E6fwld6eKAq2rP25EnOzl18VTOY7q1jcVSZj3NeWAO5HKCsA+/ttIvijJPoangZGVghnLa7darzdxPUSoy/0ECcgdYHPEjdiW4jHKuq4lKt9HjWXQE5UrllRxB51GJVVQTs/uUPcek/TfaQEI7Bl0139d1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734641146; c=relaxed/simple;
	bh=EXHvnoGK4LzozmsS1APMYygdmEh4PtL1Gw6DZu1bVxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jY5eBxWIdJAqLKEbdH3AIXVvrWLy4ZhiIkREDx83zYXfoX+DUzfb6oMcm8h6txDgxus62EuuV5GZOTOM++CJezuBD/CnImez1P255I4799vWdWYawMRLEUNvP26Qh2R92w3iit6ziYnGKIfGvG8EcZov2++mNv7OpXlV+HwTetc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=herbTaDF; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-844ee15d6f4so93831639f.1
        for <io-uring@vger.kernel.org>; Thu, 19 Dec 2024 12:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734641143; x=1735245943; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wRdYDdHbyZXzcPCpB7wABkwUTOuxolmnucq278Cp6Tc=;
        b=herbTaDFSF+fLrp05YktrbfUY99QMKq8ATHfKlZqAq9rNjJC6BuvR9+L1FOH8l0nX9
         z8CiZ7DHm4LFa1zTg2fUicA2f95uM9Pv72Tryk5Zn8BNAKyAe1sjtfOzlNOGh8bsrc77
         uDC7Rf5Mkm6ms5EM9lAL801GogxvJslyw12f3cr1VZjvHteMZhyIvpa1i5B12AuL19Ok
         9lbnT/GgMZOjJnffCpiP30vcfD0hG81C1BWFxZCXmaKWSXzjYrsX8cDexB6/BSssFy5t
         GxC8dnyn2B+bSoGOlEN+f5q9tJVqQDn/l8PGOPRJv7IEqH5hZaIzsafLk4Dz30DClD6r
         dE2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734641143; x=1735245943;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wRdYDdHbyZXzcPCpB7wABkwUTOuxolmnucq278Cp6Tc=;
        b=GMpoenEL/7zatcHoIF0a1N18WXazIVj/O7OtsATfRCyeRKyLYvdT3HAUEXjkdEe9nY
         DoBOQWCqCfaiavx7THwON0nyuoBeK16CbQZ5Q60mYeG88DIm5dtisDgFGEdVqwFEIuFd
         hEqZe9JZlgrcL6tcPYykLszlUpnDDdTuu1mOD4qPItANogiAFkWLiZFb7nFfph2K9SrX
         KsEoTl2nmB3Svq3x+DDiCtAPWNP0IECFO0IGVLQef85ZwIxitOETflYdfpKz7Q8XofLw
         DOWCgsfN7zREzxGawy35EDdIMsm3lvBSmlVV47WGcHxSckUfZIt4BHuReciJ6mp3/ulQ
         L2pA==
X-Forwarded-Encrypted: i=1; AJvYcCXuKABJ9OscbqwS6TQ3wdNoe8HfX/3SZueCHWs2MSKhPrHhr1szwgXaDglIcuybPlQZyl5aUGV0fQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1yqfwF1gQwy9mfkhME6xd3KFqj+U+Vj9GE/NtIrsDqwB/NXGm
	y8DYjlmlVWUY9I0/eh5kVxdRlefH3feI0xf8hcpk8hrWbdJV1HVwjeLms2cLnMM=
X-Gm-Gg: ASbGncuHSpJ3Sb1R5QRRUSrFIN0hJORz/NWfrJ/s6PjFygKFvBpxgVbEU/325eWd1jd
	7GhCJ0S0tWPsRzl72D8q6IumfYvcYv0D/QrVmbeTH+ENPCl51qiVYvb/Q0bvtQptXN73eC70EQY
	mgQcL5QfimKgtPiXvVS6M6eYcIOuemiF5YLRkIXLsQCQDH9Kdg9FN2FUYDOHyBNkLdPz5VyO0gX
	MTf8bdKaH/PHnHRLQYfLHPR1fRnYgTDryNahRF7V0OE82H62L6M
X-Google-Smtp-Source: AGHT+IFxSutrUvWsiAV11hP3721+cW/ZW7QVXOWP5b/gzeaAb8Kzg89614qhyJXX7v9wmOje6hR6ow==
X-Received: by 2002:a05:6e02:19cc:b0:3a7:6e97:9877 with SMTP id e9e14a558f8ab-3c2d5a27dd7mr5124115ab.24.1734641143213;
        Thu, 19 Dec 2024 12:45:43 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68bf7ed01sm457933173.66.2024.12.19.12.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2024 12:45:42 -0800 (PST)
Message-ID: <f72a3036-fe4f-4a94-963a-b994d946d5af@kernel.dk>
Date: Thu, 19 Dec 2024 13:45:41 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks for io_uring_setup()
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
 linux-security-module@vger.kernel.org, io-uring@vger.kernel.org
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Pavel Begunkov
 <asml.silence@gmail.com>, Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?=
 <tweek@google.com>, Masahiro Yamada <masahiroy@kernel.org>,
 =?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>,
 linux-kernel@vger.kernel.org, selinux@vger.kernel.org
References: <20241219204143.74736-1-hamzamahfooz@linux.microsoft.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241219204143.74736-1-hamzamahfooz@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/19/24 1:41 PM, Hamza Mahfooz wrote:
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 06ff41484e29..0922bb0724c0 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3806,29 +3806,36 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
>  	return io_uring_create(entries, &p, params);
>  }
>  
> -static inline bool io_uring_allowed(void)
> +static inline int io_uring_allowed(void)
>  {
>  	int disabled = READ_ONCE(sysctl_io_uring_disabled);
>  	kgid_t io_uring_group;
>  
>  	if (disabled == 2)
> -		return false;
> +		return -EPERM;
>  
>  	if (disabled == 0 || capable(CAP_SYS_ADMIN))
> -		return true;
> +		goto allowed_lsm;
>  
>  	io_uring_group = make_kgid(&init_user_ns, sysctl_io_uring_group);
>  	if (!gid_valid(io_uring_group))
> -		return false;
> +		return -EPERM;
> +
> +	if (!in_group_p(io_uring_group))
> +		return -EPERM;
>  
> -	return in_group_p(io_uring_group);
> +allowed_lsm:
> +	return security_uring_allowed();
>  }
>  
>  SYSCALL_DEFINE2(io_uring_setup, u32, entries,
>  		struct io_uring_params __user *, params)
>  {
> -	if (!io_uring_allowed())
> -		return -EPERM;
> +	int ret;
> +
> +	ret = io_uring_allowed();
> +	if (ret)
> +		return ret;
>  
>  	return io_uring_setup(entries, params);
>  }

Please do a prep patch that makes io_uring_allowed() return the actual
error rather than true/false, then the rest of your patch can stand
alone.

-- 
Jens Axboe

