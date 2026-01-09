Return-Path: <io-uring+bounces-11549-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 762E1D06A00
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 01:38:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5163D30321EF
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 00:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71DA14F112;
	Fri,  9 Jan 2026 00:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LLxNKDPh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD19919CCF5
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 00:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767919110; cv=none; b=JhpkMLm6Kc7FMs2KbxGN7Rcxd+ZjIOD8sBn+VBwAFN0XYm0DqH8PwDr/kt+sKupgGkQnDIjQstgcv/EIMQKNVMD/OB8GDR+8Ls7ka2HE/N3BieF0Ez/5SXJBAtZkyUSt8hyXl1gXK32hYbi64Ie8HDjZopIGueY4RtXQq4jiNVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767919110; c=relaxed/simple;
	bh=2Ja+vuDMzM6XAOLx2DkiGuo2zzMfRPI9eTb+dL6CJkg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OfAIymv+ySyU6aXPYQqUqq0XGKboWCmVBlC5ancDfSHbMLlzSJzPCyf4qRUCvwgXTZ/RYH7/FkxTLyMkrDw+9FVZ/m3/OreAMMvKRffi/nDhRFckGpQzjJbcps2qXyUnnWLmMxuF2AifTpwT8gsdelqNcPwZPeTWUfCAv8P9HK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LLxNKDPh; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4f1b212ba25so32422361cf.2
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 16:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767919107; x=1768523907; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZA2wrUNNfeaUB8bBTIRPXsTlDkNkN3e3OFp4KgAdPxI=;
        b=LLxNKDPhurCh3BF6DmO5UUYkg2RjVXCVgMNda50MtXMWnYhNfL5mO2WwKAphy92QA2
         4yGNWO/8xwIg7vwQvLUeF4GKUv2VE0l/w1lWyvKR4QK1rqPUNJw8mBFH4WKbQgG8bvMW
         KK42aEGsBbTpodPkOti4Qy2nozRz7cMQ+zuyyJDRNbDnkUySnNwL5YcwRI3f9n+jW2or
         Bhh5hYe/RIXRbVowJdNT2WjaqQZWjINMFeXjjkRdvlNGCzPYCobqXvc3ekq2M8ioEwxz
         MURheUo8KZ6lYPd3SAdh6YgB9rGLMDkentxHZRfZsHVgx9kTzaTURj3vHxlYqLHuTrLL
         Vjhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767919107; x=1768523907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZA2wrUNNfeaUB8bBTIRPXsTlDkNkN3e3OFp4KgAdPxI=;
        b=d5Ascvvn8fnDb9577PSj4gRtaeebh1+d1khm5te9CGHlbng30S+8A3uyYMPZHGrWEp
         2easAa2mm7lO7MlicmJ8wjaE3oOrf1plRvLzlB19y4GjINI5YJPryclI2tigewu57QQZ
         lpLkB0SKXKy0xWgfmRtwEz163qpnaG+xkzTEoYKXxGfqTc7FRGF8uBXP1bCD/X7RAB8L
         wPzbyqMSwotqTdIcpIhxkQufEzWQnNqa4Mf63sahNG45NH6t5s0MLPjlEZWh6kQnHplC
         WLHZZ3E7HPQPq44TeLHiCqbyRWT0HlzjLgaaJJCXCbFuy93lRyvEP1qS/Xuq54RVfpl7
         CI1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWb0T/cKtVjHpiT7jAXnLSdpXLR+uZNDbfMkz2cKp8qwJ0+BRFbikGgBcPH4pf5n68EVEYnZRZUfg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxgY6yg82OCEUf0pSUekMllqLIFJp4roIYCD6rtMfGLs3Kv/VeS
	d2lgNtL8Ni9oHIFmAkc3VOb93b6eLiWU6H7HkHy3WoBBALcaGoyiI3r0LdmRLAc7H/HGevDZaEv
	BCc/Ux3xn+jR03ixJk6Ps6PNC9esafOgLR3nU
X-Gm-Gg: AY/fxX643jVFOONLZa8shGhzbvta/Wowo1ZHnM/rvQHq0rTGV6PbMeCUp5aH3Ojg0Dp
	rg8Opv5jkA/13aaMhNwdLvVg05UoSpscrIv5splQWFATv27kBAZTzJDXR3y2kB+d5RjJ8PARnYa
	mcmNhrG30eYiZy9EoV55FprUCxlINBswV+dhF15dGrlnb+7keZjNmL5kvHl8mJDA/dlDg565qRh
	lnM9TqaPBMyXcgMXM8aYrmw+xdfgY16gJepOU4MmJeI1h+vg+OnIX6YWUT4UmSLzrpDEw==
X-Google-Smtp-Source: AGHT+IH84R5SLiROEgQ9e7cxds3MkGSVNv/ZcRsl2xfFmsxfuGnR0HV9/fhCJ9VxBTJQjIvB8S2dSZXXWI5Eu2Zwrew=
X-Received: by 2002:a05:622a:5905:b0:4ee:4422:5a75 with SMTP id
 d75a77b69052e-4ffb4866306mr113811961cf.14.1767919106610; Thu, 08 Jan 2026
 16:38:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-11-joannelkoong@gmail.com> <CADUfDZqHhVi1RY71dvEFbWsHmrzLbTSgev5o8yRXxExV5=XY2g@mail.gmail.com>
In-Reply-To: <CADUfDZqHhVi1RY71dvEFbWsHmrzLbTSgev5o8yRXxExV5=XY2g@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 8 Jan 2026 16:38:15 -0800
X-Gm-Features: AQt7F2pylK_hSqMqxiXmGQu7R6bV5DpAl_WfJKo8Cv6Oi5s-3OROqaGWj5_cmYY
Message-ID: <CAJnrk1ZQqgQmQyC8v47rpP0TrpcwGRzw6r9w4Z=TQO8EpQOF3g@mail.gmail.com>
Subject: Re: [PATCH v3 10/25] io_uring/kbuf: export io_ring_buffer_select()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 12:34=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Mon, Dec 22, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > Export io_ring_buffer_select() so that it may be used by callers who
> > pass in a pinned bufring without needing to grab the io_uring mutex.
> >
> > This is a preparatory patch that will be needed by fuse io-uring, which
> > will need to select a buffer from a kernel-managed bufring while the
> > uring mutex may already be held by in-progress commits, and may need to
> > select a buffer in atomic contexts.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/io_uring/buf.h | 25 +++++++++++++++++++++++++
> >  io_uring/kbuf.c              |  8 +++++---
> >  2 files changed, 30 insertions(+), 3 deletions(-)
> >  create mode 100644 include/linux/io_uring/buf.h
> >
> > diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/buf.=
h
> > new file mode 100644
> > index 000000000000..3f7426ced3eb
> > --- /dev/null
> > +++ b/include/linux/io_uring/buf.h
> > @@ -0,0 +1,25 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +#ifndef _LINUX_IO_URING_BUF_H
> > +#define _LINUX_IO_URING_BUF_H
> > +
> > +#include <linux/io_uring_types.h>
> > +
> > +#if defined(CONFIG_IO_URING)
> > +struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *l=
en,
>
> I think struct io_kiocb isn't intended to be exposed outside of
> io_uring internal code. Is there a reason not to instead expose a
> wrapper function that takes struct io_uring_cmd * instead?

Oh interesting... I see struct io_kiocb defined in
include/linux/io_uring_types.h, so I assumed this was fine to use.
Hmm, we could wrap this in io_uring_cmd * instead, but that adds an
extra layer and I think it clashes with the philosophy of io_uring_cmd
being a "general user interface" (or maybe my interpretation of
io_uring_cmd is incorrect) whereas this api is pretty io-uring
internal specific (eg bypasses the io ring lock which means it'll be
responsible for having to do its own synchronization, passing the
io_buffer_list pointer directly, etc.).

Thanks,
Joanne

>
> Best,
> Caleb
>
> > +                                      struct io_buffer_list *bl,
> > +                                      unsigned int issue_flags);
> > +#else
> > +static inline struct io_br_sel io_ring_buffer_select(struct io_kiocb *=
req,
> > +                                                    size_t *len,
> > +                                                    struct io_buffer_l=
ist *bl,
> > +                                                    unsigned int issue=
_flags)
> > +{
> > +       struct io_br_sel sel =3D {
> > +               .val =3D -EOPNOTSUPP,
> > +       };
> > +
> > +       return sel;
> > +}
> > +#endif /* CONFIG_IO_URING */

