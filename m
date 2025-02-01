Return-Path: <io-uring+bounces-6213-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31540A249D7
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2025 16:30:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1E021884BFA
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2025 15:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58A8B1ADC95;
	Sat,  1 Feb 2025 15:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="bDdHWCRb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB2135953
	for <io-uring@vger.kernel.org>; Sat,  1 Feb 2025 15:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738423825; cv=none; b=IE5HE7KG4gy1cwiSa9w83hzYCJFa4/r53+s5Fbhnz1pkrP3KIAJgK0J2kBvrkHTviF1GrBLO6KE/8grhTUxpJcYZZGog+5AlaCLRdu/6yxK7EOz3TxkAZF5TaY/pahh7PjNU8zYv0m1UgPPdAwr/JUjwrUh3bqbwDRJbj4+g7xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738423825; c=relaxed/simple;
	bh=jLAFeOa4B/Ui1zQ/QRR3Ay8hxmZN3q4aytmcl4FjB88=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j0104LFADb8yGv/7EDLCRzXDfvk35ASnRhcxnkueYU3uxxPjruBttwUs/0YIpzm+nUGT4SzGT/RFbInsoRUXCX/RnVCH1TTHxxUeTfh1WgS68FHRMYigkYFqwlMx2NXGLWRru3G5pYRuO/JBojRiASzWeWTSloDBaGth7gBFap0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=bDdHWCRb; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ab69bba49e2so440344066b.2
        for <io-uring@vger.kernel.org>; Sat, 01 Feb 2025 07:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738423821; x=1739028621; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jLAFeOa4B/Ui1zQ/QRR3Ay8hxmZN3q4aytmcl4FjB88=;
        b=bDdHWCRbrJTQHW/t6UBBd+9h89pXdjWvq0qaFJpE6ZI+9VV8kzyTwV6opPwZ5iJHg7
         wnUz9k20njSnj06DSRkKp3JqSjkk3jByiBzMRYSIEUwx9ZW1rNem0XVRzNQPyYwDpEEC
         8RYmHIeaLxSyPkndEO48GQXJ1Bew6Q3pjXanufYccN5QvVDDfVGK38HWzUx8kXDvZ+m/
         ZfTIgPM30npnz3AA3oVa07Uui9I9Gl63/UptwuM5URNm32WLySsGAMk8cQJZcI2APoiB
         eRewXUDm/P/LBhdSPbxHuHesOSBzCettrNMCmxBMhF2V3wx4olZ1yik6Q+KQlj87R6Hs
         xLAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738423821; x=1739028621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jLAFeOa4B/Ui1zQ/QRR3Ay8hxmZN3q4aytmcl4FjB88=;
        b=hV83/zbGRY5BXm8LIvov/gGnAc8jMHMTTEMf8Up5Tx6Hl8j7Me3a3i0d/cFKxAs4jp
         1so3e+fmkjgPIPXBQlCY+I1DwCjg+WrizrcEiLHCYApz771JFcHWbVPVYXdxsnPz4H6K
         WvRg28415SgDUHzssL8nHKNY3hwzzcThejlSiOFDxZJxOv/l8L+b+doRBPdEWwX5CPRP
         e4CQQCR8+pok8WuOFNpbciLml5j9bz49xqvgQySprbNOzkcHlYD7kE5sHuRYpQwhKlc7
         xTHqYjoMBe/3wyFEAkOiS97MESTEvnToU0pdXwYRczn13aMlFW1HAkyt44KfclFXakCY
         WZXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvIHXn7av0fIGTJiNGCoKwKc0gY1KTVijpeHhA8944drTZUtAS/QCaXpb+TTJS4PA3IaSLzSjbkw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwYFrBklRc1/hr2nVBznat0WrjC7hA1DG5qihl+dU3iNGJF0kOP
	QE050AkI6tNlaNNdMvypjhMhEkfYVQTtpywTYGmAHn/AZZ2ea30wOzmCmFB3e8skcBZPyHwOk/2
	r9op+exRyoR8+ZXdGOGD73+F32UFacrM+esoeMA==
X-Gm-Gg: ASbGncuG9jxedPtZ+T2OmJz7iPQyLdaDRnfM03L+srCdeXvq21NAd7nSnOpBisU1T96
	hFbxj+0PEexEth/3T6O565AYqu0flbQEM/s/01cHTKDiFURb+vBdDmWO2mXpRyw9JQyLJ2PMOgC
	r4y8s6/2b9Pj+xeKvnUt0/Wisazw==
X-Google-Smtp-Source: AGHT+IFFfVIGpqQJoDACtjvcQRkIcsgXRPVYG0JR7kLuxe3GgL7axL6RzBLZ9L8GIQHNcLs2mhYll9C7B+CqrxPawts=
X-Received: by 2002:a05:6402:5205:b0:5d9:ae5:8318 with SMTP id
 4fb4d7f45d1cf-5dc5efec050mr35634701a12.20.1738423820832; Sat, 01 Feb 2025
 07:30:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <7f046e6e-bb9d-4e72-9683-2cdfeabf51bc@kernel.dk> <CAKPOu+90YT8KSbadN8jsag+3OnwPKWUDABv+RUFdBgj73yzgWQ@mail.gmail.com>
 <f76158fc-7dc2-4701-9a61-246656aa4a61@kernel.dk> <CAKPOu+-GgXRj-O9K1vdGezTUGZS64w5vpkZg2MM-96vmwqGEnA@mail.gmail.com>
 <daaed11f-02c4-4580-9594-fcaef35a35fd@kernel.dk> <a6fa1317-f1bf-4179-9da4-a77f86b7523f@kernel.dk>
In-Reply-To: <a6fa1317-f1bf-4179-9da4-a77f86b7523f@kernel.dk>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Sat, 1 Feb 2025 16:30:09 +0100
X-Gm-Features: AWEUYZmz9mAYxPgfq5lQNW0GlIwU_G0PYShDHmlvC05ISUvP8Ww8dmTy8WqAP3Q
Message-ID: <CAKPOu+8Xi3oBz3zwr1bJx+LN=6cZN5eiBsrvRLZ_vOMJuOpZ9Q@mail.gmail.com>
Subject: Re: [PATCH 0/8] Various io_uring micro-optimizations (reducing lock contention)
To: Jens Axboe <axboe@kernel.dk>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 1, 2025 at 4:26=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> > Not a huge fan of adding more epoll logic to io_uring, but you are righ=
t
> > this case may indeed make sense as it allows you to integrate better
> > that way in existing event loops. I'll take a look.
>
> Here's a series doing that:
>
> https://git.kernel.dk/cgit/linux/log/?h=3Dio_uring-epoll-wait
>
> Could actually work pretty well - the last patch adds multishot support
> as well, which means we can avoid the write lock dance for repeated
> triggers of this epoll event. That should actually end up being more
> efficient than regular epoll_wait(2).

Nice, thanks Jens! I will integrate this in our I/O event loop and
test it next week. This will eliminate the io_uring poll wakeup
overhead completely.

