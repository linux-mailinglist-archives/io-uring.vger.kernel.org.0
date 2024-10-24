Return-Path: <io-uring+bounces-3981-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9DAC9AEB03
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:48:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7070E1F2399C
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 15:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE8BA1D63E5;
	Thu, 24 Oct 2024 15:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GmZTJCiw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4651F668B
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729784914; cv=none; b=UBpjBCoTMG6CcIvUcgzg80Y9rk+Vyx2IM2eSzpQ51KKNPbnF4ylfNOZ+PE8ZmI1pXAKwuWIzKCpGbzBwYwBtNUpdbnJfc5FXeSQFJR4vFqBDWCImL6GjtghO0XTkD8nPyiW0XnKJYp+UZUZI/qC7XG+APC5IfYyoFsIL1iNdBRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729784914; c=relaxed/simple;
	bh=li40jr+UGgDlW8ZJwO1fYdr9fdmZtqCYKHabEnmnhzY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tPXSFqOIlTj5Zf7xHiQO+Tmd4BEFzA4dJdVFkbIWzIzQ0iaApJ57X9d6XJonVo9XBYNF5EkGhfFDTrMBmi+lXzHOZaRIY1J7/nxyFU1qFgkxnYqmmxptiMhQFzC3tNIjt8Kbu9oBKLP2z/Hgg/v0MstBB2l5BJPr+zIchajkiP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GmZTJCiw; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43153c6f70aso183025e9.1
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 08:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729784911; x=1730389711; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=li40jr+UGgDlW8ZJwO1fYdr9fdmZtqCYKHabEnmnhzY=;
        b=GmZTJCiwAH1bF8C98fobeJFwN4YYZECbX3TCGpOYbkA6x9ar6eZ7myEyL3NZp6srRw
         OmZhZft6ibH+BKthm/piiePv5E+6leJ1pKFjsrOOh4LD/MapYu6ppDmVpxkiuNiARwK7
         mZI5taGgpZ32mrP3uw+keE0r52S3LdyNuvRVuNcxtUfW/Mj6hvUDDtdMtmsZtmOzAZ3v
         W2kHYHumCmunWksPmCl2RsthnW+6dOJigM92s4bzyg2S8TmY9NQz1W7milQQAmm0HD26
         unxRjwCbqMcC5E7ILz6ycXFr7AVGKacHVahz6vPW4PhFQ2g9/5sqA0XDd4GmTifFaHmT
         1zgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729784911; x=1730389711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=li40jr+UGgDlW8ZJwO1fYdr9fdmZtqCYKHabEnmnhzY=;
        b=Vt7+zOmk5IW6udDXMRCmsEGiiQCX+JNdSNf6n8qDXbXFCEP0j6qmpE7dkHvIiq6ePY
         G5ghMW3oo/XiNr+6S+il7uWEmtr4MpvUmE+xt8putJ7MNbnXk9PXWxeLx2hx2UcvhqWf
         bF1Q523WYNPwbLv4SsmLVJ0nSQHELatSlslCrcsXQ0zUv7mMJcCdSm0NnK+spV4L4pov
         a5b4UGgDS8pm2iipkxiZFts9T6nRSjdZaqCK0c90/0AwLpMog0LMAwKbENqkkZMuSTSc
         xZfXcCxugf/IeOtZGaCSIUrbETIwHfb41SgJ1fTv4jBRZ1GlbutOnSVaVQ3fsvmruDoy
         Bv0g==
X-Gm-Message-State: AOJu0Yy5qhzBoXnNNGHdG4S2h8A02nAOH0OyNDh9ZONZZTmH6rPZi12S
	Wi3EdDvvBd/q8MiMRTzsSu+cVg7pCrgDRj1QUyp/dPJyLRdUvXf+643qn5yoIYVYgkv7RHgAx8Z
	7/9imHgkxPQHHbIP00KpR07FmEe0KxSiitzTfBRrBgfPKaa0DlG8b4vo=
X-Google-Smtp-Source: AGHT+IEN6DYE43tTQ4qnQdjsIfenRK1YRsOayK2hVf2e0auYW8U5vyT4z5e9Nj5t1edFOD6mkwKPRTBFwo6nKDa7T8Q=
X-Received: by 2002:a05:600c:1e24:b0:431:3baa:2508 with SMTP id
 5b1f17b1804b1-4318afc6f77mr4202205e9.3.1729784910558; Thu, 24 Oct 2024
 08:48:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241022021159.820925-1-axboe@kernel.dk>
In-Reply-To: <20241022021159.820925-1-axboe@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Thu, 24 Oct 2024 17:47:52 +0200
Message-ID: <CAG48ez2OMzMddB1-oCgKOgez4jUGb7E+aiku_c5f5nwZeuwJ3Q@mail.gmail.com>
Subject: Re: [PATCHSET RFC 0/3] Add support for ring resizing
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 22, 2024 at 4:08=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
> Here's a stab at supporting ring resizing. It supports resizing of
> both rings, SQ and CQ, as it's really no different than just doing
> the CQ ring itself. liburing has a 'resize-rings' branch with a bit
> of support code, and a test case:
>
> https://git.kernel.dk/cgit/liburing/log/?h=3Dresize-rings
>
> and these patches can also be found here:
>
> https://git.kernel.dk/cgit/linux/log/?h=3Dio_uring-ring-resize

You'd need to properly synchronize that path with io_uring_mmap(),
right? Take a lock that prevents concurrent mmap() from accessing
ctx->ring_pages while the resize is concurrently freeing that array,
so that you don't get UAF?

And I guess ideally you'd also zap the already-mapped pages from
corresponding VMAs with something like unmap_mapping_range(), though
that won't make a difference security-wise since the pages are
refcounted by the userspace mapping anyway.

