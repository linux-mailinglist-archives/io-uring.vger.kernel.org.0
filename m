Return-Path: <io-uring+bounces-6313-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA173A2CFED
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 22:43:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BC377A140A
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 21:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DECB01B0439;
	Fri,  7 Feb 2025 21:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="eStP4XSg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081AE1A0BC5
	for <io-uring@vger.kernel.org>; Fri,  7 Feb 2025 21:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738964580; cv=none; b=QOuhx/uwbh6zSw3w7u1tk12uT5Fix7W2iPGrzrDtxfD0STdoFXftRS//hVckOvN3zgK2u7G+UzCHCo2hKif2K8ONU3X+ehxp2EndSHZ3IP3CJuSg5Qc+TPqfwmHaU+rznLAf/kSnb+cDNqYFrLy9dR2/6TVUgG0O+B/3vmyZEsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738964580; c=relaxed/simple;
	bh=WYNf17jt7Muniz1iCEPbUpabyrjv1SVCpJsiy5bz71M=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=ETroEbwqxKBvgJjFJ9xwuy+CH92Rvndc6u98hIYxVBAdvL/xUitNaLxVeZ9OfAJ9+DfUTBONToBMB/CRVrKFijjnPFyELbxSRXv3VIIQ/Ee9Nv+10oxZO/SXMcj1q9DFLbhOBAHLVYPz83yuZNF3mvwDHvj2sl3egGbxPUcEW9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=eStP4XSg; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-46fa734a0b8so23905971cf.1
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2025 13:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1738964578; x=1739569378; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OyZWD04EzzeMLP2kqehBEA9qaN1gdA31HUl6m14dlVU=;
        b=eStP4XSgOZDB+nJgRj5RGEx0wHL2SUSx78Qn77CCGv1NHN5hSVLZEH/M5VRkPOFYo0
         hQjA9o7AR2CHu7kh+erpzhKGehyhcOUw0/oqhcBO8FJKs2kKnsNz98416xqobtgztSxR
         PFASo2vz2e4uaU1JiicYd3UUiBSLRT6o2iC1dVPDYpgdjnUjwX/9T9xC7Y4H+ZBG90Do
         y+ORlLsiyLX2315mSJLbNPvr4fe4OD9VrHVDyYYPYHwnfWdjqvfqzZET4Xeqf5l14G01
         ZjAZznMliaWzqR7rLDS/TFYrVIy7Bud1456LFOlCVy/YvG7e09W/lSYoZoI7KWxhNyIZ
         7k2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738964578; x=1739569378;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OyZWD04EzzeMLP2kqehBEA9qaN1gdA31HUl6m14dlVU=;
        b=MgAaj0uCa/Q8ooO9yTVthh3nA/8yrZMqmE0t8jmpH2ny6YY8IBcx2nuYs2hfnwTKc5
         gPEGc8FyZ3nQRYC+eejMeWkYmLPSrkF9YchaEc/qy687LQoZWop8Reh2zGKJtCkzHiO2
         WZiia2na3BhszmUvv/ZZltMGmJ2TLn8SqLRQbI286NmPx9lmttujfIMoR33zbujedM3L
         7Qftb9BET0G65v1RGIeW2eN6ToDik7menjcXdWpXP1W4L2ch62RU8EGy1JQCioUYjkxp
         d0vcX3aHo335nYl+BRBdwYKMU6qkZcGSSm/AYkzvjsXJ2l0KHjP2g8yCDiEXmu63feRB
         r8aA==
X-Forwarded-Encrypted: i=1; AJvYcCWqRPGVp7zdBC6/gSBoD9+bl7nBsySiJy6iKcfxXiqLzMgMLXrBW/fYHUvF8mNgIwBo0ITawPmGdg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzhrfug8EZFe/gMX4nU9+DZ9Qz5JnqR7DQRBwaI79CpJ+Y/TOsR
	+BF1YHoL/le+i6Ctk4F6vy+AhZHOZMyPX2t5R0MeiFu2JSex9Cac+LkHgkeIgw==
X-Gm-Gg: ASbGnctiDJ8Qhzew6+ENo7YpmdYu1rU8ATR7fDwzf+/AtnRFY30LVudr8HbpkYIBi4J
	42tY3cm7QvZ/50XTYEbUWxzK5bf5WA53OCI1X97esxJYLLxC8i3d+5Ybg3Rb6zujjzRXBNp5/5V
	nTkin+2RyxEFFHAq8iDxcZpIpuR9xdNN8OCyXbkuC3HRXImVzntPQjeC3q295k1E45TdqsmTZ+1
	2DpZffZi7COeO1NnldWoTO6oi+NTfJeWbxMBXyghyCZ2w0cn/FfIATkxmPxI+mTMTRBCg4MqDaV
	dInmFZRCDQ==
X-Google-Smtp-Source: AGHT+IEKZSzxjNXmRGiHG/W80iDgu7pdtltLCNjruMOjlrTdLuOgHmomS1qSW19gO/TgYVufB/n4Kw==
X-Received: by 2002:a05:622a:355:b0:471:6706:4506 with SMTP id d75a77b69052e-47167acb942mr62746741cf.36.1738964577790;
        Fri, 07 Feb 2025 13:42:57 -0800 (PST)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-47153beb6dcsm20871101cf.71.2025.02.07.13.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 13:42:57 -0800 (PST)
Date: Fri, 07 Feb 2025 16:42:56 -0500
Message-ID: <8743aa5049b129982f7784ad24b2ec48@paul-moore.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20250207_1530/pstg-lib:20250207_1633/pstg-pwork:20250207_1530
From: Paul Moore <paul@paul-moore.com>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, Jens Axboe <axboe@kernel.dk>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Pavel Begunkov <asml.silence@gmail.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, =?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>, =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>, =?UTF-8?q?Bram=20Bonn=C3=A9?= <brambonne@google.com>, Masahiro Yamada <masahiroy@kernel.org>, linux-security-module@vger.kernel.org, io-uring@vger.kernel.org, selinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] io_uring: refactor io_uring_allowed()
References: <20250127155723.67711-1-hamzamahfooz@linux.microsoft.com>
In-Reply-To: <20250127155723.67711-1-hamzamahfooz@linux.microsoft.com>

On Jan 27, 2025 Hamza Mahfooz <hamzamahfooz@linux.microsoft.com> wrote:
> 
> Have io_uring_allowed() return an error code directly instead of
> true/false. This is needed for follow-up work to guard io_uring_setup()
> with LSM.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> ---
>  io_uring/io_uring.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 7bfbc7c22367..c2d8bd4c2cfc 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3789,29 +3789,36 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
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

I'd probably just 'return 0;' here as the "allowed_lsm" goto label
doesn't make a lot of sense until patch 2/2, but otherwise this
looks okay to me.

Jens, are you okay with this patch?  If yes, can we get an ACK from you?

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
> +	return 0;
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
> -- 
> 2.47.1

--
paul-moore.com

