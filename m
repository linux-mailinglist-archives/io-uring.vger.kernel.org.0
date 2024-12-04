Return-Path: <io-uring+bounces-5207-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A3369E4154
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:23:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3BDB9B2B84C
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 16:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5492D1F1316;
	Wed,  4 Dec 2024 16:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NSHhA1dJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9554923BB;
	Wed,  4 Dec 2024 16:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733329866; cv=none; b=Sl+LSrde1qGOGWI8/jCss6fEcx84+MIGzBcBn1V10PLTZmEFF+ahLd6TuTmiVT+kERDXEZJS5Q0vsc6bSBq/gatPleCIZPszsHMgWjddPcP/59UMZ2wcU4aYLdv7t8A894Xo9xKo2U+xdAaqEIO1Jh01IMO9a9KPLJG1aAklI7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733329866; c=relaxed/simple;
	bh=CsrXA5416l2IYRWcR6d7oNUF9vC31crT8AA0rDUnZ3g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h0QTR5Wl3bG275eeh5m+fFFSLYIIFxvFejPF5CJdYxUOHppYVizAmS/cqBQTjmYmttD7VTvLZq8rqXg5vHjVo2ymnncGhNC0DHS1E+XZfs+LhSCtajX5KBPuBqtkwA1+40xN7JTcO3Dm83+gDgxr+V7Kb4XFA4m/r+0UpiPHkqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NSHhA1dJ; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2ffa97d99d6so71653781fa.1;
        Wed, 04 Dec 2024 08:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733329863; x=1733934663; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1NacqQweZL2ZRpwzejzKHzHAYa4r44TWJmVad/FV5fQ=;
        b=NSHhA1dJgVgJ3/LbARmMTJYHpnPv2D1OJrUHTmlq9w+21vZmCIaEjT7jkGu3SM1Uf0
         tf70F/wXSyYj5b5ccCz1lck5WOWdZ6PjN3g7AWelTYM+2gRvheFys3IhmGnkufLEN7v1
         /+8hThOWJcHTt+CMyNzWCh81Hrhms88eFQUV3XMdRbhfm158aEyLIdWYyl0QOplvYv0D
         bphGkXBa3qVnaWlF/AEY6Ifn6nSeAxnysyMZBggv9C2Wt6zBJtNF82ALOdTsvejirhOF
         h7yt1n/C6EhA6f7vfqPv7zA8lMCL5ut+jpGJhHqVSb+CdgyLZ4ouPqYhxnuWLT3sNR5r
         yhew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733329863; x=1733934663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1NacqQweZL2ZRpwzejzKHzHAYa4r44TWJmVad/FV5fQ=;
        b=wqs717BYhlo+m7fVP6PMkbsJM5RAn5cyMRWiVE/zxD2VCScEhWRrh5aMgNNqUloV15
         4qkpXNa2b+YilwSc+RU9uzU26n7U4+/gh2V6ce1D23+k+mAs5C6XLTGkGZVoQwsAXExG
         I39t1otqn3jfjXUJFVZphp3qYfdlyZJ9eEGWfkRJJrK5i0i62mthCjjbbgSdH+QrXNpH
         T749QspMxnKM+jzZHT2gXD0vNXiSi/m/Y+4rpA6RrPc1xVI3FLPATl54GOz0SUgZHS7D
         7sklkz+fInbyuPU8cS8ARBaoVifjWOinHSqn/wcAM0zWvaviN9gKjxKnhNHxRyFIRHZ+
         LPOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvVAF1nWMRQnltneBiEu30tbOVoPWbPG+veORbhlcyGG9XoRKXL1gKeu8PtnVkz2bN3GGP1JnGWNKmNI4G@vger.kernel.org, AJvYcCVUwOnuZgyd+yLgl2uudO+8H3rSOC9xSEYBgDtLRMXc0sDSF5jPbm4tnYI7GIpdNQO9Xza/PJe/Rw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq+VpfYXGg63IIp4jKlnrCVvJWWWlMmRwblWkLOao/+Ot8HNGV
	VXko69EFWTTly41BuONXz32lqmhlVoNEP6A3ym2Gt7Kz1FJD/BAgTOStI79FwmEt8X35lNK3qjk
	49jtf1L4vo2viTpM6soEjdJiPdbA=
X-Gm-Gg: ASbGncvzPZsZPgrDvC2h80Qb887LmB4CNy6juuXfpCHim+R/EXVAXAmnToUFuo6jenu
	YuJy60Z0Ed90KqnNzNQbOqMIp0Q7jjMHj6k2A7psKd12CV2kex29sLOmmZ7k1AfVxbw==
X-Google-Smtp-Source: AGHT+IGo6X4WvDvWh7GVi3qy8Q1hzgU1W7HelK+qTO+jbdpbCv+ASz8/hzTHDpi5Ayqtnvg1GaUvYkxme8e5tr/x4v8=
X-Received: by 2002:a2e:bc1d:0:b0:2ff:a7c1:8c50 with SMTP id
 38308e7fff4ca-30009c52bb7mr33937911fa.19.1733329862395; Wed, 04 Dec 2024
 08:31:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67505f88.050a0220.17bd51.0069.GAE@google.com> <6be84787-b1d9-4a20-85f3-34d8d9a0d492@kernel.dk>
 <a41eb55f-01b3-4388-a98c-cc0de15179bd@kernel.dk> <CAJ-ks9kN_qddZ3Ne5d=cADu5POC1rHd4rQcbVSD_spnZOrLLZg@mail.gmail.com>
 <1ab4e254-0254-4089-888b-2ec2ce152302@kernel.dk> <Z1CCbyZVOXQRDz_2@casper.infradead.org>
In-Reply-To: <Z1CCbyZVOXQRDz_2@casper.infradead.org>
From: Tamir Duberstein <tamird@gmail.com>
Date: Wed, 4 Dec 2024 11:30:25 -0500
Message-ID: <CAJ-ks9k5BZ1eSezMZX2oRT8JbNDra1-PoFa+dWnboW_kT4d11A@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Write in sys_io_uring_register
To: Matthew Wilcox <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, 
	syzbot <syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com>, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 11:25=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Dec 04, 2024 at 09:17:27AM -0700, Jens Axboe wrote:
> > >   XA_STATE(xas, xa, index);
> > > - return xas_result(&xas, xas_store(&xas, NULL));
> > > + return xas_result(&xas, xa_zero_to_null(xas_store(&xas, NULL)));
> > >  }
> > >  EXPORT_SYMBOL(__xa_erase);
> > >
> > > This would explain deletion of a reserved entry returning
> > > `XA_ZERO_ENTRY` rather than `NULL`.
> >
> > Yep this works.
> >
> > > My apologies for this breakage. Should I send a new version? A new
> > > "fixes" patch?
> >
> > Since it seems quite drastically broken, and since it looks like Andrew
> > is holding it, seems like the best course of action would be to have it
> > folded with the existing patch.
>
> ... and please include an addition to the test-suite that would catch
> this bug.
>
> Wait, why doesn't this one catch it?  You did run the test-suite, right?
>
>         /* xa_insert treats it as busy */
>         XA_BUG_ON(xa, xa_reserve(xa, 12345678, GFP_KERNEL) !=3D 0);
>         XA_BUG_ON(xa, xa_insert(xa, 12345678, xa_mk_value(12345678), 0) !=
=3D
>                         -EBUSY);
>         XA_BUG_ON(xa, xa_empty(xa));
>         XA_BUG_ON(xa, xa_erase(xa, 12345678) !=3D NULL);
>         XA_BUG_ON(xa, !xa_empty(xa));

I thought I did, but when I ran it again just now, this test did catch
it. So there is coverage.

