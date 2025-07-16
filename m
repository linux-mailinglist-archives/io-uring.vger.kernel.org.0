Return-Path: <io-uring+bounces-8696-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCE0B0780A
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 16:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E39A4A56FB
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 14:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CEF23CF12;
	Wed, 16 Jul 2025 14:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="IlXqtqZt"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540D623E320;
	Wed, 16 Jul 2025 14:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752676114; cv=none; b=D6CBlt2AE2B3GkzSanwBdXE/DxuHEN09limjs8lyIyPQQlZBKTnxWBrU1kQEo4MulI04RKICrYAOaQTSWwlFhGqFSS8YHRXSgeJ9aa8zvWMH0nY5Fv9x9bStrD7wdNtULmNca6TiNTFee0YOat+AqxlTTPrNMoiJBg696WGqiRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752676114; c=relaxed/simple;
	bh=AHQ6lrNq6iSTc6k7qOEAi2qvRl2kI8gDoOuVIT9MnU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OuqSkSpaAM+ds/pFAEPypn4zCQowow1O7JeOkhnGHeBhY0tEpKRapAMuYJ69kJWcECGjsF4RYeDyJszfcCVfJx2W5OR00LzycAGTPwN9UD/hN++jz2iUlqbL7GIDKBFQhAI8uISeHxrxlFqXGd2yIqc29sl7S1Rfc/7BrfdmVwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=IlXqtqZt; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1752676104;
	bh=AHQ6lrNq6iSTc6k7qOEAi2qvRl2kI8gDoOuVIT9MnU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=IlXqtqZtXIEbA6GHfy3tBQ+pF6K8zpz9iAXEk0p5jEDE6HH3WxGEWfUjfXPUt3xjl
	 Y2yfl08SDLbHD7w/AbvzMM4VYc+8esnZDakczW2PYzmf27FaA0WVr0msdgC9Z5gU2t
	 cFqYB0g4uzs1cP0Z3VZ5158kiRjHxoyoNOJ1uFx7wjOoBY+naHuSHDoH+5CmZ69hG9
	 nL8RWVH0/ARb/GdOt1EmCsDg4cX9VMCTcJo2mJh6zr7mWWTMfi941hUzGQjn80FqYj
	 cFGJP9UVdISoJ+k2Q1aR7JTkPzlsQU4lSa0thzQjd6e3wyfyUosZD4C+pOqCGX7VKZ
	 c6SeNExnWsmLA==
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 62FA72109A96;
	Wed, 16 Jul 2025 14:28:24 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b3182c6d03bso7678020a12.0;
        Wed, 16 Jul 2025 07:28:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUOoQk1LGSeEVKBm9ODZATNU1Qe22aFmNuIlq1rw7pDwsv03flPcfrnTJWqOtybr3KucvGd7f2QBHJcBVgb@vger.kernel.org, AJvYcCWnSAMEMc82Axy2GcghsYz4pIK7sRdpXj12t5OO9j/tqWpwLu+BTlRqmPUc4qZfGHdnHRGh5coIGA==@vger.kernel.org
X-Gm-Message-State: AOJu0YySqx7ZCQtTQogiveTb4Rqq+cUaG9n99+Y6eQwYLU+faosIX5ub
	5buOsfgG6hJI9ymp/kZUPNpldZnY1/BYPvBs43hkDl0zmuXYeZ9zpv8J1qdJYqjX4x8a1m/llLH
	FL3yBf5Ly6IJvViF+5mkopzUeakG7PHo=
X-Google-Smtp-Source: AGHT+IEJ1CauHduTIvjMHMuDpALR+gE4f6ohatyea/fpLmVvybnxVxapdIbfv5wSPwclmJ9iqlvu8ecg8N5Q5JK3/Pc=
X-Received: by 2002:a17:90b:2c8f:b0:312:db8f:9a09 with SMTP id
 98e67ed59e1d1-31c9e70011fmr5070799a91.14.1752676102713; Wed, 16 Jul 2025
 07:28:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250716004402.3902648-1-alviro.iskandar@gnuweeb.org> <3b28fddb-2171-4f2f-9729-0c0ed14d20cc@kernel.dk>
In-Reply-To: <3b28fddb-2171-4f2f-9729-0c0ed14d20cc@kernel.dk>
From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Wed, 16 Jul 2025 21:28:10 +0700
X-Gmail-Original-Message-ID: <CAOG64qO1S+hd+cgabQn6uYMPGAMm7V-FRmm6btytZE270bEebA@mail.gmail.com>
X-Gm-Features: Ac12FXxrV6tiGo8ULER39Gv57B0cLjlkYhJnE_tLBP51pU2O_Z9KMhwMYxO0HRI
Message-ID: <CAOG64qO1S+hd+cgabQn6uYMPGAMm7V-FRmm6btytZE270bEebA@mail.gmail.com>
Subject: Re: [PATCH liburing v2 0/3] Bring back `CONFIG_HAVE_MEMFD_CREATE` to
 fix Android build error
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>, "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	io-uring Mailing List <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2025 at 7:41=E2=80=AFPM Jens Axboe wrote:
> For patch 1, maybe just bring back the configure test and not bother
> with a revert style commit? There is nothing in test/ that uses
> memfd_create, so there's no point bringing it back in there.

Ah yea. That'd be easier. I'll copy the configure part instead of
modifying the git revert result =F0=9F=98=86

> IOW, patch 2 can be dropped, as it's really just dropping bits
> that patch 1 re-added for some reason.
>
> All that's needed is to add it to the examples/ helpers. If it's
> needed for test/ later, then it can get added at that time.
>
> All of that to say, I'd just add the configure bit and the examples/
> helper in a single patch and not worry about test/ at all.

Understandable. I'll send a v3 revision shortly.

-- Viro

