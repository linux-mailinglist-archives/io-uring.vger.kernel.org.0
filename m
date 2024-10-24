Return-Path: <io-uring+bounces-4009-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D5AE9AF353
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 22:08:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EA691F2300B
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 20:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11412189F33;
	Thu, 24 Oct 2024 20:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AHoMbXDx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D551B22B67B
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 20:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729800523; cv=none; b=GkLHP86mH2l6yMjP0N/GasCL5u3auqjuEJHAB5oX6L7AyAQnm7sdpwAcBa4jKxHFpwNY6z3T8vXzy4kn1n6UN6tTOpxfngyTTut5+zd7hcrDUbiyAsVkFU36AkMSM//RGXdDoybfkaP+tZat1LJgpyfEz3uqWR3Gmfhn/3/6V6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729800523; c=relaxed/simple;
	bh=R0ZyA75k6equvcHFazRjszW/teO9JnFuu+STl9lXjaw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t1cdbR1V04SxvvmYCtaDWQeDDRFnkHHs0qFJmBmvIrJJ5LajBot8Lp1Vly9ak0fiPQU2wAXWmBZQdvTc1xlQnvj+uPavr/evqoZMGGS69xM9T0KBhfr3gAJY++dPslid1UQW/0ojYTrcTALd01woVQ/5WBPYaHHv6AXaGOsa/nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AHoMbXDx; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43150ea2db6so60825e9.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 13:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729800519; x=1730405319; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SJao2MePchN3INhBw2ZKOHjXbEuYMIX++st2kGbTh8A=;
        b=AHoMbXDxVRSQRdB5rpI4TAVte3ouvT28V+qgaGMv/bKYU7LtVPCH6M+APPS76z1rEB
         nJst4YyJ98wNRCDR0zrr56BtYGOQpgQFUGDBt5v1QJwUoLR1pItb0OiExJY4zaAaf71S
         YybYBDYoOXZNgF7pVpF4NVkHbSBlUe+l07LYQZyWsWhKHtOo4nlBssj5TjaqbQ9b+H/p
         /GGIxhxiid2F3zBAMnu+d0CzqF4ABbujo0o5bBj3LJU2ECYnr5MLyu7FcU0NILj+LktV
         EXv4lKmpE6m56fKfnZ9We071P+vu12TRWSY0PE1lKHDmrOC+vVzj2+/zldwusm+YSlHF
         lAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729800519; x=1730405319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SJao2MePchN3INhBw2ZKOHjXbEuYMIX++st2kGbTh8A=;
        b=bXO0SN/EapDODZYZoq1lBGvSX7BdTRjQ4UxktcG3kDFpN2A8nTz5s3IHgb1RtOGkRO
         ECXwV2ypjEYAqhh0rByO6EhAKZKAMRggV6L9Olfr0i9tH9IkU/nO4sL2i/tFNSvKhpXa
         yehO/rugPbWtpJfvLLaZvc7Q3B90wAoi5TjRTU9DMLjS8EQV7AWNu1E71ghoz5SWIf+w
         o886BaFzP1hkk5vZIqD1vw3Wbh8/ccQ0i0I7w2bAxlHi7OL/PQeEjdCBc+SI/sfotZXA
         OKsTMhtNxqVAgPWvKsYCz+Ow3RDFlhKFD6NF2rnGLxJQWNQgbpqEWxasWWasbDNWROr6
         M7zA==
X-Gm-Message-State: AOJu0YwFg1DdH9K3V/qT09EwXm7c5vYgeeaAL34Q5flP6+23KMuxaMdU
	dYSFvGH3gSL7ohVunqTh0k+FvS0LIV8vtSQQe09Boqzb5N4eNUEeqLNwYLpPC3huJ0GgUhtRkyY
	R7CygQ4bjacmyNuEOLgUqdCzyMJXdZRdwBN10Kg5E32z5Zk4zWtlh
X-Google-Smtp-Source: AGHT+IHYzCfBZe5YBdKYMMU/l07jfZmA7mx3zmAJOaHPV40uWMTzgCbtpijjgNStEV9rUMr4Yi1PPTxpYZrZH51BVQg=
X-Received: by 2002:a05:600c:5013:b0:426:7018:2e2f with SMTP id
 5b1f17b1804b1-4319239394fmr867675e9.5.1729800518693; Thu, 24 Oct 2024
 13:08:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241024170829.1266002-1-axboe@kernel.dk> <20241024170829.1266002-5-axboe@kernel.dk>
 <CAG48ez3kqabFd3F6r8H7eRnwKg7GZj_bRu5CoNAjKgWr9k=GZw@mail.gmail.com>
 <aaa3a0f3-a4f8-4e99-8143-1f81a5e39604@kernel.dk> <CAG48ez3KJwLr8REE8hPebWtkAF6ybEGQtRnEXYYKKJKbbDYbSg@mail.gmail.com>
 <1384e3fe-d6e9-4d43-b992-9c389422feaa@kernel.dk>
In-Reply-To: <1384e3fe-d6e9-4d43-b992-9c389422feaa@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Thu, 24 Oct 2024 22:08:02 +0200
Message-ID: <CAG48ez2iUrx7SauNXL3wAHHr7ceEv8zGNcaAiv+u2T8_cDO7HA@mail.gmail.com>
Subject: Re: [PATCH 4/4] io_uring/register: add IORING_REGISTER_RESIZE_RINGS
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2024 at 9:59=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> On 10/24/24 1:53 PM, Jann Horn wrote:
> > On Thu, Oct 24, 2024 at 9:50?PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 10/24/24 12:13 PM, Jann Horn wrote:
> >>> On Thu, Oct 24, 2024 at 7:08?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> Add IORING_REGISTER_RESIZE_RINGS, which allows an application to res=
ize
> >>>> the existing rings. It takes a struct io_uring_params argument, the =
same
> >>>> one which is used to setup the ring initially, and resizes rings
> >>>> according to the sizes given.
> >>> [...]
> >>>> +        * We'll do the swap. Clear out existing mappings to prevent=
 mmap
> >>>> +        * from seeing them, as we'll unmap them. Any attempt to mma=
p existing
> >>>> +        * rings beyond this point will fail. Not that it could proc=
eed at this
> >>>> +        * point anyway, as we'll hold the mmap_sem until we've done=
 the swap.
> >>>> +        * Likewise, hold the completion * lock over the duration of=
 the actual
> >>>> +        * swap.
> >>>> +        */
> >>>> +       mmap_write_lock(current->mm);
> >>>
> >>> Why does the mmap lock for current->mm suffice here? I see nothing in
> >>> io_uring_mmap() that limits mmap() to tasks with the same mm_struct.
> >>
> >> Ehm does ->mmap() not hold ->mmap_sem already? I was under that
> >> understanding. Obviously if it doesn't, then yeah this won't be enough=
.
> >> Checked, and it does.
> >>
> >> Ah I see what you mean now, task with different mm. But how would that
> >> come about? The io_uring fd is CLOEXEC, and it can't get passed.
> >
> > Yeah, that's what I meant, tasks with different mm. I think there are
> > a few ways to get the io_uring fd into a different task, the ones I
> > can immediately think of:
> >
> >  - O_CLOEXEC only applies on execve(), fork() should still inherit the =
fd
> >  - O_CLOEXEC can be cleared via fcntl()
> >  - you can use clone() to create two tasks that share FD tables
> > without sharing an mm
>
> OK good catch, yes then it won't be enough. Might just make sense to
> exclude mmap separately, then. Thanks, I'll work on that for v4!

Yeah, that sounds reasonable to me.

