Return-Path: <io-uring+bounces-6314-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E13F1A2CFF0
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 22:43:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 174257A2098
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 21:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996721AF0AF;
	Fri,  7 Feb 2025 21:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="U3lj2Y/H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27F41A8406
	for <io-uring@vger.kernel.org>; Fri,  7 Feb 2025 21:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738964581; cv=none; b=rOglHmuAfUEKSkbf4rO3yHykzJM3wtqrqkJES99o6edoRTk/nh4ZDWty4sZDHWHPEh8Fes5ShXW8+9Lba3Dt9SjIRAlD5ko8s2SdWK3rDhsOAOd7KZYr8iRFh0VtorAXSm5Iz9rA/HU8pHrczr4sQVhTysX2/59XjX0PCNSA10Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738964581; c=relaxed/simple;
	bh=YY45Gnycd+3o7hKOW8C8JWYriuERUUgTq475FPmCvGI=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=OlAlDCdrS6UXnvIau54TwncJ8anbXJ7HjNH2M5XVpYCHtchJNmpdK2mg6yBy8Qdh7Dc0+u5uj/0RpZZmODjyK4q/VhIm5ZAilOLeIlhJf6VBiH7b5x5cpGO+vWs6a00H2gkdDn0Jvxe9ssCfzg9Z7JNASu4lcBnuciAm5aIEdm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=U3lj2Y/H; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6e44fda56e3so3938666d6.1
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2025 13:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1738964578; x=1739569378; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IvI4JoqoZo9YGBOkVNl+HIo1GyCi9K0UiyKNezQvlcg=;
        b=U3lj2Y/Hx5rw231y8IvfEZA+lYWKI2a/kzxlcQ8vJa/yp7+fGbyE40xukdNfaPhLBS
         eyeDnWgB5AA8dq9i/vKzwxnC9ODoz6u7VLzacFdmcaG5qP9mSgTEd/+akTpspOncMGuB
         eGO4GX9HdY7HcVy7hLgPRbXbexsqMMXVGXE3kNBNBI2wkNY6ApWORKUc1VjMhyX9ewfa
         AjWGpToEHycw8wORMj1lwuSUk17dnep90bRZD8M+Nhobnvrzm0sp4yMdyN3TuAYupkbU
         imjbUreNvBUyeHuWItTJeMTj8mBBy+8jETR8lPzeBfbDVpJ9TttR5w/t47qQFv6iVTj3
         A9mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738964578; x=1739569378;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IvI4JoqoZo9YGBOkVNl+HIo1GyCi9K0UiyKNezQvlcg=;
        b=kuUi7tnjhI/dcyrqKWXNuxKmq+r58I23xkca093pgw+wu93eSGuO0jar/O8p61/41U
         THGjYEEEHD3YKwpKSr19xkFordK/0t35rwCSL7ZnvlptA9bCcuw3fZZa7bd+tqmvXYAo
         a8TmFKCepP/CEj6aZSqvNjoxDYc203wB5i0mv7zG7sn2qmFzydrWdpl7CwEmfWzagIgV
         bArcFd96+0c/fIEHxADLBjz6LIMdEaiahq3hAxCPcMGdkq4Us8ZM7FEvG1i5eVI0K7n0
         gkn/979AaPGWjqjm2da1MLLRUg9LAjBS0eX9GObO4kGEXYklkAtjOAZ+t3sfN3RSv2jR
         hdMg==
X-Forwarded-Encrypted: i=1; AJvYcCU+W9Ls5cmPyfBwQ19Ilgbur9kcjgaSmO2Qo6tK4jjUQ7QMHwX6retpcOWLoHhLvPlFBgOeM6xWCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg+sqhLP1HRZITWD9o09lFPJa85AktoxjLylvTmODbemEdblvp
	j8a1sXsD02pxLULGDSbd2/ppLmaX/atanoyXuEs3b+QhLDezQgE7sb5Vpv6vHg==
X-Gm-Gg: ASbGncvhsW5lJuCuBc4ezyPa7ak+q+HAD/fVp3LJWQslXjTtndv/CPKIkMbpqh57UPc
	+5Q+rNV6pSlo5iykUSFUH8OAcSD02S15j1WzBGosIUrqAmldI2SXvDIL5q0VewTqndsoK9c3kPj
	42WSg6FWo/4jTRmom5EGVHDdePPZav4wnRSmckrvNCKaGtmlufIBRrguuDFqISEWtGCGiuvbLgQ
	xzvSBJ9Rg0MszfVQxaN4SiUEoEXUk87NF7KQWp0A0h3DXZIXRewSVxmMEJuq2/gdcVHWoZRSz8N
	zal0vxMtEw==
X-Google-Smtp-Source: AGHT+IFs+6UcZosHd2iDR62Ugi6tG8vmQY7p/Mreyxu8ihzV+H08wfaEH+7KqK5h9qrbMMnVoHlMRw==
X-Received: by 2002:a05:6214:21c9:b0:6e4:2479:d59b with SMTP id 6a1803df08f44-6e445a1f182mr86494526d6.16.1738964578659;
        Fri, 07 Feb 2025 13:42:58 -0800 (PST)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-6e44b159663sm8220186d6.100.2025.02.07.13.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 13:42:58 -0800 (PST)
Date: Fri, 07 Feb 2025 16:42:57 -0500
Message-ID: <a4541fab007858c599aed1d1e3e98883@paul-moore.com>
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
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, linux-kernel@vger.kernel.org
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, =?UTF-8?q?Bram=20Bonn=C3=A9?= <brambonne@google.com>, =?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>, =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>, Masahiro Yamada <masahiroy@kernel.org>, linux-security-module@vger.kernel.org, io-uring@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH v3 2/2] lsm,io_uring: add LSM hooks for io_uring_setup()
References: <20250127155723.67711-2-hamzamahfooz@linux.microsoft.com>
In-Reply-To: <20250127155723.67711-2-hamzamahfooz@linux.microsoft.com>

On Jan 27, 2025 Hamza Mahfooz <hamzamahfooz@linux.microsoft.com> wrote:
> 
> It is desirable to allow LSM to configure accessibility to io_uring
> because it is a coarse yet very simple way to restrict access to it. So,
> add an LSM for io_uring_allowed() to guard access to io_uring.
> 
> Cc: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> ---
>  include/linux/lsm_hook_defs.h       |  1 +
>  include/linux/security.h            |  5 +++++
>  io_uring/io_uring.c                 |  2 +-
>  security/security.c                 | 12 ++++++++++++
>  security/selinux/hooks.c            | 14 ++++++++++++++
>  security/selinux/include/classmap.h |  2 +-
>  6 files changed, 34 insertions(+), 2 deletions(-)

Thanks Hamza, this looks good to me, but we need to wait until we get an
ACK from Jens on path 1/2; he's pretty responsive so I don't think we'll
have to wait too long.

As far as the return/label issue in patch 1/2, as long as there are no
other issues, and you are okay with the change, I can fix that up when
merging your patches.

--
paul-moore.com

