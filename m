Return-Path: <io-uring+bounces-10927-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DCFCAC9DBB6
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 05:13:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A25254E0359
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 04:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95F0526561E;
	Wed,  3 Dec 2025 04:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Jp1d7JwX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E9E23D294
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 04:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764735212; cv=none; b=tR2Ub/BqFBy6RwkPDN0fjqLmSbFmbs0f0dYhsXdC5iyD73wmkJXo76ax6mnTsuFc7VA/LzD0E5zA7CX6NnBbHxaWk74n854dp/K1xWPzsK/AZa+P+IW6alcOPswoGFLn5+rcV9fiAIIr3Rj45r9D+W9pE8RvYZcVizErXLiKIKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764735212; c=relaxed/simple;
	bh=22hrq76GMqLwaIE0iua86BlDSKBm/9IiS84ASBsE3qA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QOqAwaofWkcV/qjteOO5Ciil+Nwy1CtFAPFtPBGApkjw28Ezk53qWcN46CBSi9kIoLaW2kp1ChpB8xE2p5vtwc/k/K9X+eSPvqjWpcxrhY1juOm/kgADMGJdBUU2pSyrdZZqFoyskOSiouFmrB6BiDozFkDJpoRfWkObxcJ1qjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Jp1d7JwX; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29806bd4776so11338565ad.0
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 20:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764735210; x=1765340010; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q3/Sjao4Sals8cXe+ER5196tMY6uLigV67FJu5L8zqM=;
        b=Jp1d7JwXaRArVOVwabIAn596zQNZKJjbZzwvM9wR9RyNRTVtXCWqBR668+UPC7hvps
         j+fX1Xe1eJ/UU0Iob1ts+l8FvDqm5Zsg1FEPZJQmwZSKQlF3FlTjRwWlHICoPZcHwF7V
         LXu33Yp6Kvx2wtGhztQDojRmEjqbkZFDINzH8Uf4yROmT59ZesxMahNPIi2tN9GR1NID
         L5JJ26YBRPFIU0e1sgUoLWORGC8sSebKzOF8s4DK0PDO4Dm2/SnjGSxAcl9Tf5W1li2O
         SR/rZfBshZriciZaFBGVgJnrymNiIL6E19LgIvoEcWlMC4DxE5WWJoBirEnwSBrWx7OB
         VUlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764735210; x=1765340010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q3/Sjao4Sals8cXe+ER5196tMY6uLigV67FJu5L8zqM=;
        b=BUSIc3OeyHBaNMjlfb6JJIla4mMT855lTyrXofx+64rE61svUU3Z8ZMLpc1lvPk8vg
         ihsCYdsOaQBEGFiyfQtKv9W9zOvbaySVOa+LGTIaOJfqeFNxdXPxCRGOvCjBw3/Z2vYI
         mk9S6aHbxG1Z1OBXo/wrB9qUbAHlMratKRB5mkNOvr64PFGKB++GJUYqdLBrDJYGKP8k
         G7aOiqd2LS9PjGQGgCz4jaR8xj8Gg5ArU4OsDuVwRnIScv+XB6GXDT2YKlIewFTU3obp
         9MSrZzt8eCSS0OybiqgjWo/U0/EatpiUKINv2OanjUGi+BtfQNOEPPXR8qqbA2SY/NFG
         +jqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSFLxhmqPJ/617S6B4SKqAc6QrSI/MFXvwxPsNJUHvy2W4WA1h6haR42Sa413GTvycsTPkor9p7g==@vger.kernel.org
X-Gm-Message-State: AOJu0YydBteBB+Z5nYWuwF8N+v/Yk7x/s5fsOUE1PSAPDTXsmBV9LYf9
	at3aJTwpFwhCAdpIjtk+aqTETi0PsZaDH35Z9rvR5SMpigSxsz6RJqz2uJS0tAZ56qHg/6Ica2O
	hdxQvw02Zs1PKC+i7v42dL46755K3lK/1FCMxP9XCHw==
X-Gm-Gg: ASbGnctEQ+6cDcnrPdWSPJ9KyMQxAHM1uxRlQK3/jllSvJ9hVvTxRCwVwRz1pNtnrnk
	00+7ESwXWeWiYohv6IRwGEKqtef9sMU6HzNL+AS8gn7ZCBx+C3R0zCAJ9E1rE1OgKWvUG7JK6Hs
	Xq6wmc/4i1ycfnjeBVUypCgKmLNq3MV7n0qu/tRKjU/iJr9R65jvnGY8lPGV7U9XuLHD7DZfFVd
	ccDjJDY1d2mJ5a7jDwwyz5cIj396njMbvEVQ8QJON7Q9Np/R1IXtxNOAIBQ9alJeUQVrd4l
X-Google-Smtp-Source: AGHT+IGgAM5RM5y/tjjnQemI9ILGUJNZJ/v2TY7IwRod8OjHrqpwnHvdecIZ/q/FPBwrhYtMQ0NCSDmwteIiqUE1Sl4=
X-Received: by 2002:a05:7022:f902:10b0:11b:65e:f33 with SMTP id
 a92af1059eb24-11df25290acmr23031c88.1.1764735209716; Tue, 02 Dec 2025
 20:13:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com> <20251203003526.2889477-7-joannelkoong@gmail.com>
In-Reply-To: <20251203003526.2889477-7-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 2 Dec 2025 20:13:18 -0800
X-Gm-Features: AWmQ_bnHkjTWNU-VMv9EOHDGCIEYZQubHrGGZhg_eVdoHpfqQ3t5K1M7nriexTY
Message-ID: <CADUfDZqzpfnq8zfYNT7qQdauMmQQ=z6xi9Am-KyQc148oxwAxA@mail.gmail.com>
Subject: Re: [PATCH v1 06/30] io_uring/kbuf: add buffer ring pinning/unpinning
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> Add kernel APIs to pin and unpin buffer rings, preventing userspace from
> unregistering a buffer ring while it is pinned by the kernel.
>
> This provides a mechanism for kernel subsystems to safely access buffer
> ring contents while ensuring the buffer ring remains valid. A pinned
> buffer ring cannot be unregistered until explicitly unpinned. On the
> userspace side, trying to unregister a pinned buffer will return -EBUSY.
> Pinning an already-pinned bufring is acceptable and returns 0.
>
> The API accepts a "struct io_ring_ctx *ctx" rather than a cmd pointer,
> as the buffer ring may need to be unpinned in contexts where a cmd is
> not readily available.
>
> This is a preparatory change for upcoming fuse usage of kernel-managed
> buffer rings. It is necessary for fuse to pin the buffer ring because
> fuse may need to select a buffer in atomic contexts, which it can only
> do so by using the underlying buffer list pointer.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring/buf.h | 28 +++++++++++++++++++++++
>  io_uring/kbuf.c              | 43 ++++++++++++++++++++++++++++++++++++
>  io_uring/kbuf.h              |  5 +++++
>  3 files changed, 76 insertions(+)
>  create mode 100644 include/linux/io_uring/buf.h
>
> diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/buf.h
> new file mode 100644
> index 000000000000..7a1cf197434d
> --- /dev/null
> +++ b/include/linux/io_uring/buf.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef _LINUX_IO_URING_BUF_H
> +#define _LINUX_IO_URING_BUF_H
> +
> +#include <linux/io_uring_types.h>
> +
> +#if defined(CONFIG_IO_URING)
> +int io_uring_buf_ring_pin(struct io_ring_ctx *ctx, unsigned buf_group,
> +                         unsigned issue_flags, struct io_buffer_list **b=
l);
> +int io_uring_buf_ring_unpin(struct io_ring_ctx *ctx, unsigned buf_group,
> +                           unsigned issue_flags);
> +#else
> +static inline int io_uring_buf_ring_pin(struct io_ring_ctx *ctx,
> +                                       unsigned buf_group,
> +                                       unsigned issue_flags,
> +                                       struct io_buffer_list **bl);
> +{
> +       return -EOPNOTSUPP;
> +}
> +static inline int io_uring_buf_ring_unpin(struct io_ring_ctx *ctx,
> +                                         unsigned buf_group,
> +                                         unsigned issue_flags)
> +{
> +       return -EOPNOTSUPP;
> +}
> +#endif /* CONFIG_IO_URING */
> +
> +#endif /* _LINUX_IO_URING_BUF_H */
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 00ab17a034b5..ddda1338e652 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -9,6 +9,7 @@
>  #include <linux/poll.h>
>  #include <linux/vmalloc.h>
>  #include <linux/io_uring.h>
> +#include <linux/io_uring/buf.h>
>
>  #include <uapi/linux/io_uring.h>
>
> @@ -237,6 +238,46 @@ struct io_br_sel io_buffer_select(struct io_kiocb *r=
eq, size_t *len,
>         return sel;
>  }
>
> +int io_uring_buf_ring_pin(struct io_ring_ctx *ctx, unsigned buf_group,
> +                         unsigned issue_flags, struct io_buffer_list **b=
l)
> +{
> +       struct io_buffer_list *buffer_list;
> +       int ret =3D -EINVAL;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +
> +       buffer_list =3D io_buffer_get_list(ctx, buf_group);
> +       if (likely(buffer_list) && (buffer_list->flags & IOBL_BUF_RING)) =
{

Since there's no reference-counting of pins, I think it might make
more sense to fail io_uring_buf_ring_pin() if the buffer ring is
already pinned. Otherwise, the buffer ring will be unpinned in the
first call to io_uring_buf_ring_unpin(), when it might still be in use
by another caller of io_uring_buf_ring_pin().

Best,
Caleb

> +               buffer_list->flags |=3D IOBL_PINNED;
> +               ret =3D 0;
> +               *bl =3D buffer_list;
> +       }
> +
> +       io_ring_submit_unlock(ctx, issue_flags);
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(io_uring_buf_ring_pin);
> +
> +int io_uring_buf_ring_unpin(struct io_ring_ctx *ctx, unsigned buf_group,
> +                           unsigned issue_flags)
> +{
> +       struct io_buffer_list *bl;
> +       int ret =3D -EINVAL;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +
> +       bl =3D io_buffer_get_list(ctx, buf_group);
> +       if (likely(bl) && (bl->flags & IOBL_BUF_RING) &&
> +           (bl->flags & IOBL_PINNED)) {
> +               bl->flags &=3D ~IOBL_PINNED;
> +               ret =3D 0;
> +       }
> +
> +       io_ring_submit_unlock(ctx, issue_flags);
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(io_uring_buf_ring_unpin);
> +
>  /* cap it at a reasonable 256, will be one page even for 4K */
>  #define PEEK_MAX_IMPORT                256
>
> @@ -743,6 +784,8 @@ int io_unregister_buf_ring(struct io_ring_ctx *ctx, v=
oid __user *arg)
>                 return -ENOENT;
>         if (!(bl->flags & IOBL_BUF_RING))
>                 return -EINVAL;
> +       if (bl->flags & IOBL_PINNED)
> +               return -EBUSY;
>
>         scoped_guard(mutex, &ctx->mmap_lock)
>                 xa_erase(&ctx->io_bl_xa, bl->bgid);
> diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
> index 11d165888b8e..781630c2cc10 100644
> --- a/io_uring/kbuf.h
> +++ b/io_uring/kbuf.h
> @@ -12,6 +12,11 @@ enum {
>         IOBL_INC                =3D 2,
>         /* buffers are kernel managed */
>         IOBL_KERNEL_MANAGED     =3D 4,
> +       /*
> +        * buffer ring is pinned and cannot be unregistered by userspace =
until
> +        * it has been unpinned
> +        */
> +       IOBL_PINNED             =3D 8,
>  };
>
>  struct io_buffer_list {
> --
> 2.47.3
>

