Return-Path: <io-uring+bounces-10959-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DE03CA4F80
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 19:42:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C4D66300D548
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 18:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D21286D63;
	Thu,  4 Dec 2025 18:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eJY9BPV4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0911923D7E3
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 18:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764873711; cv=none; b=i3UMAMEl/nhb+d+dqtxBG2cxtFSmSL3qLY39ur/Qi7Ns9kvC8zsmDiOVq521UjTtPOlxZp6MPIdOr7hZBkiAgl8kXI6DenaZeuHl+MMD1nDMHBGr314lXUR1gUZo3PWdcx+pmN9nlzbop9WrH+oZfIWTL+o5ZnhqU/GWVW3oisA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764873711; c=relaxed/simple;
	bh=oMxtseEHZHa9YPb72NIgSljc1Ghrok0Q/j2CLZ8SOwM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=efl1E85nQVyt+gOVSrbaWwoCJlAPgeowgfcsA7ongzur21750mXNcSSZcUZp2CU3AvDyDFtcktYAzXr6lt8c5FyBrXEMd5YAuwVDdATcpDVFPnIJmQigdk/LxsIvMf/2uRsHxp/elBpz5uf4Y46SqsliNvRtCebCY/nIEEIf50c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eJY9BPV4; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ee158187aaso12275061cf.0
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 10:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764873707; x=1765478507; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xHUuZbyhOsjTm6zi6UjvRRrq0uw47xR4EWsXhEDK7YA=;
        b=eJY9BPV4MMQ4u73bVzr3ZG7umpc3SE9dOxfAEkHUoA4BTQ/lJOyywbra8fdZtABvbm
         EPcBRPftz/MoKPwXLc8l+1Xahy9CZo/50NqVCKCS+X59vVEtySxxZ4K/CSmhVp+LwRiQ
         3q+lCLw5NG6r6GmAhBGI/0s+vi4l0WkYGTNhESE46svvCHW2Z5uh3eoCaLqgEdnDhhC9
         20Yi5IYPRpnq10azRdjcVuf7RMNeU6yDnOkEPP1am90HyHEcUyUtM/42ta492Jt20iLA
         s7hbc16zmAJHRnNPbFLltzXhQE66CC1fkHQ08ZoZY04VqPMMxoGkLKD1vp4tIndO6rN6
         IL9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764873707; x=1765478507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xHUuZbyhOsjTm6zi6UjvRRrq0uw47xR4EWsXhEDK7YA=;
        b=BepllrUxbjM9Z1xstrc3g5/oGw3MLzSsVPdluKaHv68PzvzCx14syXXHghmkvqFegH
         Ljs5OlTUTfKwQJCKUCs2akyoxoMTwC9uf4nLM4n4fI5lH5IzJBZWB0pdUXWhLLNP0yxc
         YeybxVqCB5SlNDtX6eTtzo26cBhRl1ZXuxSuEOKtmxbePAm3KIuboTlSXkxqqCNG3YBx
         WuJsl+hqAIveA/2D8+5w1jPry+BCUkWJ04TUTH3Krx88MwIXffDfZKHobLp6VHSEE91F
         H+XzTyHJ3bGty6bWPKxOOcYuowWGHBmDA9fdItB/lbK8LvGIGLd8f7iNm3SGcLGfQHZA
         Vs3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWa0Qrsm1c9kSwOGYL6WJvfZ3tSHR/vGtTDUvbM3mMqhhiUyb2TnYbD0TXIBkJo8CfaTZhYGP5aMg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmy0CcUz5nJR2n9xA5Seg2AuSvyUsxQAMzh4IEMza/X2Zgd6uS
	TZV15oDQ1JmqYFL68POcRcgbG0pX/Rg6kAX5Hb2JH5bcerU2g6cuQmMr/mFTJiybp/qN6eK4EHJ
	KbOOJMBUaKr4D8kBqWG5plt6FFq/fFbI=
X-Gm-Gg: ASbGncuQUH6Wl2GPtSjFqjzEz8qMs0kXOcwasBr3b3ET/f16RUzvey1oE+Ltxw8z+aJ
	MNQPqqAiwbCtRbdxz0Gevdswgc74NeiudVWFqb4qBZ9X3PjqtS+SwuQ8gdgflrqY0H90CI3jmhx
	MbPf2CKq+i6TdQhb5K/E3lZQ5PmMfbE10hQ44YIpafxKZ7DXyLXYV2aSlWg5R4ONxz1rh/7t+ly
	9T6Z6qe29Gq9hsBW/AEapNqle7AOhGcJ2WnlScxxMhkuhDd1KovB0IsGk/AUeGyWOa20A==
X-Google-Smtp-Source: AGHT+IEXqmdYq7NWbh0lEr3OP77o/zq7hwCM7BW2t0yMD4BoTcUEH86kyL1ZuT11ypXZ6uf7smMqiiOGZjm6B2OqvIM=
X-Received: by 2002:a05:622a:1a11:b0:4ef:bd18:e20f with SMTP id
 d75a77b69052e-4f0176cf76cmr90222301cf.82.1764873706906; Thu, 04 Dec 2025
 10:41:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-7-joannelkoong@gmail.com> <CADUfDZqzpfnq8zfYNT7qQdauMmQQ=z6xi9Am-KyQc148oxwAxA@mail.gmail.com>
In-Reply-To: <CADUfDZqzpfnq8zfYNT7qQdauMmQQ=z6xi9Am-KyQc148oxwAxA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 4 Dec 2025 10:41:35 -0800
X-Gm-Features: AWmQ_blFgkVmktTumcbh6U6UTiyBFhMQS1VT4QDoCvoJxMOw5ECuYMNLnDE3VQ8
Message-ID: <CAJnrk1aNWCNJw9C0TpNysnfg64fQjg06OSE+GYy6Eh0BMfiPDA@mail.gmail.com>
Subject: Re: [PATCH v1 06/30] io_uring/kbuf: add buffer ring pinning/unpinning
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 8:13=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > Add kernel APIs to pin and unpin buffer rings, preventing userspace fro=
m
> > unregistering a buffer ring while it is pinned by the kernel.
> >
> > This provides a mechanism for kernel subsystems to safely access buffer
> > ring contents while ensuring the buffer ring remains valid. A pinned
> > buffer ring cannot be unregistered until explicitly unpinned. On the
> > userspace side, trying to unregister a pinned buffer will return -EBUSY=
.
> > Pinning an already-pinned bufring is acceptable and returns 0.
> >
> > The API accepts a "struct io_ring_ctx *ctx" rather than a cmd pointer,
> > as the buffer ring may need to be unpinned in contexts where a cmd is
> > not readily available.
> >
> > This is a preparatory change for upcoming fuse usage of kernel-managed
> > buffer rings. It is necessary for fuse to pin the buffer ring because
> > fuse may need to select a buffer in atomic contexts, which it can only
> > do so by using the underlying buffer list pointer.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/io_uring/buf.h | 28 +++++++++++++++++++++++
> >  io_uring/kbuf.c              | 43 ++++++++++++++++++++++++++++++++++++
> >  io_uring/kbuf.h              |  5 +++++
> >  3 files changed, 76 insertions(+)
> >  create mode 100644 include/linux/io_uring/buf.h
> >
> > diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> > index 00ab17a034b5..ddda1338e652 100644
> > --- a/io_uring/kbuf.c
> > +++ b/io_uring/kbuf.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/poll.h>
> >  #include <linux/vmalloc.h>
> >  #include <linux/io_uring.h>
> > +#include <linux/io_uring/buf.h>
> >
> >  #include <uapi/linux/io_uring.h>
> >
> > @@ -237,6 +238,46 @@ struct io_br_sel io_buffer_select(struct io_kiocb =
*req, size_t *len,
> >         return sel;
> >  }
> >
> > +int io_uring_buf_ring_pin(struct io_ring_ctx *ctx, unsigned buf_group,
> > +                         unsigned issue_flags, struct io_buffer_list *=
*bl)
> > +{
> > +       struct io_buffer_list *buffer_list;
> > +       int ret =3D -EINVAL;
> > +
> > +       io_ring_submit_lock(ctx, issue_flags);
> > +
> > +       buffer_list =3D io_buffer_get_list(ctx, buf_group);
> > +       if (likely(buffer_list) && (buffer_list->flags & IOBL_BUF_RING)=
) {
>
> Since there's no reference-counting of pins, I think it might make
> more sense to fail io_uring_buf_ring_pin() if the buffer ring is
> already pinned. Otherwise, the buffer ring will be unpinned in the
> first call to io_uring_buf_ring_unpin(), when it might still be in use
> by another caller of io_uring_buf_ring_pin().

That makes sense, I'll change this to return -EALREADY then if it's
already pinned.

Thanks,
Joanne
>
> Best,
> Caleb
>

