Return-Path: <io-uring+bounces-293-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BCF48186FB
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 13:06:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBBE81F24961
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 12:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817D718022;
	Tue, 19 Dec 2023 12:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="XrZKKm2s"
X-Original-To: io-uring@vger.kernel.org
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB2B179A7;
	Tue, 19 Dec 2023 12:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1702987556;
	bh=26lrHcQfnoq0P3eDGcD/6wC6C+pTFV1KRGECV4Wp3dk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XrZKKm2sK/dqby8SVweE+b0JVyN/S/wf/IHyluSOg7Fts0XfB2zF+Rh3BOrPoyiVK
	 1m0VYPfJtRfz48g0ZvQyOeacjkjSTMoJ4BXEpJ2jBD0FXapLCxw9VgRy7bLvmpeRHS
	 ppuS5BRjYZPbgZicMnoO2ISsSluiZyiNd3EP/IVFYq8p1uLmKKpO0pHC3V8THSWrRI
	 7rGjhD8XaaNi42YrlG4z7xHDm8pZOhwTwZeIJOuHi9xVdRM199nmXvgxJxwFsMN8Pl
	 haRRch/SJWV5SObqPU0MMcBXAcCOT65K4LC/vPFPMUsYcPMVdEHCFAo2908scZe0Gy
	 Yol6AMCbuWuvQ==
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by gnuweeb.org (Postfix) with ESMTPSA id C7B9F24C1A7;
	Tue, 19 Dec 2023 19:05:56 +0700 (WIB)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d3ad3ad517so9978085ad.0;
        Tue, 19 Dec 2023 04:05:56 -0800 (PST)
X-Gm-Message-State: AOJu0YyVsgqJQE/qgV9zdtwRUWx8qMDC1/6LwdQJHNzvsO5SnsE9VuLt
	g7x+6bXT4H+mfehDvn9Bd5fmW884xnxnSiJjN5A=
X-Google-Smtp-Source: AGHT+IHDs/Fo/z4xwpOWfja653H002HMKNwLfbTm+78Jr7DOFHnjl0FMk4VXluS/Brsvlus5sGjIjlqu6pfRRsY+7qk=
X-Received: by 2002:a17:902:d486:b0:1d3:65b0:8399 with SMTP id
 c6-20020a170902d48600b001d365b08399mr5476484plg.59.1702987555969; Tue, 19 Dec
 2023 04:05:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219115423.222134-1-ammarfaizi2@gnuweeb.org> <20231219115423.222134-3-ammarfaizi2@gnuweeb.org>
In-Reply-To: <20231219115423.222134-3-ammarfaizi2@gnuweeb.org>
From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date: Tue, 19 Dec 2023 19:05:44 +0700
X-Gmail-Original-Message-ID: <CAOG64qMdX08_apxfsvxg1wvyo7EWv9K-Swti3AN2vt_Lxfdcjw@mail.gmail.com>
Message-ID: <CAOG64qMdX08_apxfsvxg1wvyo7EWv9K-Swti3AN2vt_Lxfdcjw@mail.gmail.com>
Subject: Re: [PATCH liburing v1 2/2] t/no-mmap-inval: Replace `valloc()` with `t_posix_memalign()`
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: Jens Axboe <axboe@kernel.dk>, Michael William Jonathan <moe@gnuweeb.org>, 
	io-uring Mailing List <io-uring@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	"GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 19, 2023 at 6:54=E2=80=AFPM Ammar Faizi wrote:
> Address the limitations of valloc(). This function, which is primarily
> used for allocating page-aligned memory, is not only absent in some
> systems but is also marked as obsolete according to the `man 3 valloc`.
>
> Replace valloc() with t_posix_memalign() to fix the following build
> error:
>
>   no-mmap-inval.c:28:56: warning: call to undeclared function 'valloc'; I=
SO C99 and \
>   later do not support implicit function declarations [-Wimplicit-functio=
n-declaration]
>           p.cq_off.user_addr =3D (unsigned long long) (uintptr_t) valloc(=
8192);
>                                                                 ^
>   1 warning generated.
>
>   ld.lld: error: undefined symbol: valloc
>   >>> referenced by no-mmap-inval.c:28
>   >>>               /tmp/no-mmap-inval-ea16a2.o:(main)
>   >>> did you mean: calloc
>   >>> defined in: /system/lib64/libc.so
>   clang-15: error: linker command failed with exit code 1 (use -v to see =
invocation)
>   make[1]: *** [Makefile:239: no-mmap-inval.t] Error 1
>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

-- Viro

