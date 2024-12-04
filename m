Return-Path: <io-uring+bounces-5236-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C233B9E43D5
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 19:55:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CAC1166887
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D447B1B4130;
	Wed,  4 Dec 2024 18:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aTR/dz+S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A4323919E;
	Wed,  4 Dec 2024 18:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733338555; cv=none; b=J8bZM9ATt/jTkK8ewXLzRzfy26M1lRSdcHa2HR6tAaUImqhsUr+KIseSKifwRPY6kCk0flk7qscc2KtTUZTkGHYB9y3wj2zP4ASDr+MbhfxBQN8d2Do65HADgDDSCqJOR6cpYVDPQDxrc+f/BikSpDTsRZV6Gb2um8bfZaTpsj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733338555; c=relaxed/simple;
	bh=rrCSpxSMBTZkXH4OKCZMhZd+9JuXhbVBPB5EXdOtRYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lu2crVlled+zupJTqtvIG//Ogw7DWSAfVnQH2jNbaJGVLG0SqM2Xd1r9OX23wRuB8g66K2TLcqrGZDX1HWm6z25grfSRmydPqkXiVqz0VvYHPNP6MuydwUlSPsz7il+6hbdq/Y5S9rOAeDJ6bDtJYzr1KrHaKHAX9jkqKSR9k0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aTR/dz+S; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2ffc016f301so333671fa.1;
        Wed, 04 Dec 2024 10:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733338552; x=1733943352; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0vCv00u3o9o7cLmyk3lOENhk5E/DDECo95HGyRPd6SM=;
        b=aTR/dz+S16QI5b814OKWGN19jKFmT8Wn5wBeX00EMJasNp67m7FBL1K+5BqxnwGWGJ
         GyeJEfV1XCN9wcUqVqquRPuJ4sJEvFvKLp5lrltqt7RTmoEzPYLitEN2vyszWq6y6Wj/
         +83fT6VsSd4jpejEn6nRmKrknwDb5hniMi2JJDIv+pX7cljpplH9X2012CM9kAkzItsf
         gIypOPqLPEozzQue/XBOmI2eZNOqChJAhViqMkdonK0//ID9UiyjVbEEZsf9nOrSwZkX
         Xsia1kHxuIJNsJssop9nUpUwHYZnFyK7Dn6l4cTzThdsmqCeLh+1PJG/1u3bGSAdIjjX
         uFnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733338552; x=1733943352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0vCv00u3o9o7cLmyk3lOENhk5E/DDECo95HGyRPd6SM=;
        b=gPYcEeV2jV2T47KnOZL2QVgrynYSaY1yiAGMh3g7/YsoLYeoG3jjG/jFEpHEE9sC1R
         LYzY05vkAgbwe+pSCQULU5tAtAqiZ1VpUeRBDGwXKm/WMGLTgWevotb++4tlN/EiOEur
         ddSmUp4295CEPPIk4ERyzBPOswcwYBRP6iuj69QzW3zp8wCigf/sTCqvdfqzOenEsW1R
         W9lNhS/nsZjB2q+z6sGLwIRSJfEgsEHjNC67aqZhHVh8flK5CSA4bwxrbdI7sfK0/W80
         lilwQxtcXaOTCBNyY2OqNlRPwoBnz0BquuPwPoyqHC7iyWUIhmq3cOx8UUjeE5LtnyEr
         0fvw==
X-Forwarded-Encrypted: i=1; AJvYcCUHDEriwiUVB2NC6phtV0Vc+LPHzoabZTSqODfWhQJVstI/f8jNfkKL3pC25VYsvpcSqoT+BWPsfW1Dv2/5@vger.kernel.org, AJvYcCXOpd9BuQeFQIG71uBqJjAxwfBXmn5EhsbDGN6EjXG8PhODyUYhs+OPrzoVaUs4qR7zKtT6pxT94g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYOBT3EsqE+/3d/2SaRg24Z3zDtsZw8w140tNKEGhjGezs0Px6
	5vYlIK2yOQgBwFBCSOWnt2PX/IE/hqYaLCckZ0z6kt6La1aAIlzXk8rYhaVRaW9OZA1OUO+zce0
	C9xzal8bquCLvO5IfiOrQ+kMU68I=
X-Gm-Gg: ASbGncvH98iGm5N0IMu8MXzbKMVSeb8m0JMcpkGcJ8DLWoxwG9H2fUSB4QzHElDc9ss
	JviEXYqvU+8ZvfQreojP64QVL+PjzlKmx/PozAvjhaRANiqwpUAB0dIRPPW8ynzrH
X-Google-Smtp-Source: AGHT+IFqGahxJn1hPUTzrqUH9EcK5HRL6a82LgSuzvC0Q2shkiWUtCEH3yHpMFMEbD5qdiffwxWQxpjrczcakalOxSI=
X-Received: by 2002:a2e:a9a6:0:b0:300:1aa5:4938 with SMTP id
 38308e7fff4ca-3001aa556a7mr12345711fa.18.1733338551906; Wed, 04 Dec 2024
 10:55:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67505f88.050a0220.17bd51.0069.GAE@google.com> <6be84787-b1d9-4a20-85f3-34d8d9a0d492@kernel.dk>
 <a41eb55f-01b3-4388-a98c-cc0de15179bd@kernel.dk> <CAJ-ks9kN_qddZ3Ne5d=cADu5POC1rHd4rQcbVSD_spnZOrLLZg@mail.gmail.com>
 <1ab4e254-0254-4089-888b-2ec2ce152302@kernel.dk> <Z1CCbyZVOXQRDz_2@casper.infradead.org>
 <CAJ-ks9k5BZ1eSezMZX2oRT8JbNDra1-PoFa+dWnboW_kT4d11A@mail.gmail.com>
 <CAJ-ks9mfswrDNPjbakUsEtCTY-GbEoOGkOCrfAymDbDvUFgz5g@mail.gmail.com> <Z1Ckrl-gC3HpPj0W@casper.infradead.org>
In-Reply-To: <Z1Ckrl-gC3HpPj0W@casper.infradead.org>
From: Tamir Duberstein <tamird@gmail.com>
Date: Wed, 4 Dec 2024 13:55:15 -0500
Message-ID: <CAJ-ks9my1amcMNsc7nTE4opeOC=YA46=2_6M9X4T-a=mm7_Nkw@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Write in sys_io_uring_register
To: Matthew Wilcox <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, 
	syzbot <syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com>, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 1:51=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Wed, Dec 04, 2024 at 01:39:37PM -0500, Tamir Duberstein wrote:
> > > I thought I did, but when I ran it again just now, this test did catc=
h
> > > it. So there is coverage.
> >
> > Matthew, would you consider a patch that migrates the xarray tests to k=
unit?
>
> how would that help?  it's already a kernel module as well as being a
> userspace testsuite.  kunit just seemed to add useless boilerplate last
> tie i looked.

The primary benefit is integration with kunit.py that presents nicer
human-readable output compared to the existing machinery. It does add
some boilerplate (~120 loc out of ~2300).

