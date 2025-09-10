Return-Path: <io-uring+bounces-9709-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2545EB51F4D
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 19:45:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6F841BC57AD
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 17:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CAB3261B9A;
	Wed, 10 Sep 2025 17:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="YiFiFuxK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C4F33A002
	for <io-uring@vger.kernel.org>; Wed, 10 Sep 2025 17:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757526266; cv=none; b=Tzn8qjXHl+iIMn9Tek2Oi0H55e0tY0Xq3xWMvJkLi5wS4nNYZ42gDncAn/4h5ov3DyO+mXZAu6+BYKcYWaXr/0emoMuyN0Dbql7Nhyi+RIEY5L6YyGxYRFAksmZpQMBZeVgq/yQ3RacoA5jroHxVLHwbOqqPsjiadP8FuhibZ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757526266; c=relaxed/simple;
	bh=TF+j5eoJF0zjdetvc8p78toNBXNUhR56mORyJDpx/Nk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GvAMisHNxIqPSk3UZenmddSZhq2QKrAb6G37qvfF6qMC0CyV7ftDsDiqSMoj0z6Aae0QqWfQxY5NL++B+6tTQUnwMeFkUEpG8zUoqVDLYbXhMo1injz6CKanuAczfJXcEjqcwow0Ymp1JJmEgY4cqDUA5FLiQmhKmpPzwtlH2fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=YiFiFuxK; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-248e01cd834so14880635ad.0
        for <io-uring@vger.kernel.org>; Wed, 10 Sep 2025 10:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757526263; x=1758131063; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3MPGW3DYJQcZt21zbPRLrPJ7N9lrsHTcbP15c0gjR8s=;
        b=YiFiFuxKDI20Vww12JVw9x2+rH+3aivHjIMGNAP7G8FesNkr1KpHIkZu2SDETQA0F3
         Ztrv3hipDf28jul6gyd4AAoDOSsvyU95gTsLnIwHsgIZBhmBJoz7phWR02HzPH1GBeW6
         OebWxKvNsXwHRIptVvFfua8N7mw1QjDA7ejm0HUgfWvhlvJ6xREz0NzppPMq8ziB15PS
         hruJaBsWygzTUaGTW8qsxjcVlPxM5j7FFFKa41nd+rDA0AU62TBSD757k95i4T0DVGTX
         jAmxQBpjGIG1Ria4PTRcGqcYU5AnxCi/HdN8Wp7ptpsXVdfVJhl8/JjmTJ4EtyUuu0bT
         RZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757526263; x=1758131063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3MPGW3DYJQcZt21zbPRLrPJ7N9lrsHTcbP15c0gjR8s=;
        b=hY/bMoKhQaiwNByoqdkh+GZjYmo0uus7hU9YB5Pk3CwNwAwmofHe+4zHJeUjQ/UDDk
         mthZQDsH2iQNv8Fm9fkwqkH1Tj2Q5y0bMz5prO5+hnkrpUDOtr06iRCIJJg0vZlnpwUj
         +8ho4ILuHZYgJhNlzxIFO6C2ZkxUPVB/iDETbdRTfbkOSJ/YurgLVOSdSKplDBc873Q2
         WQjVHLSdVAgLkrQDvgvjrPlDlNxnLlsQIlG4oiQEgmGPQaibppesYiH0DXsE/9LSbSDs
         WbNQmXra/251XU4Ea8G+J8TwEBjSo0u0wQty1ZtL7lR2VwNw6BZrPhTDvbcX8vANxWOu
         1c3A==
X-Gm-Message-State: AOJu0YxsC91JCcF0Ayltp7DU2Qc2+18/jHEov7ky2Zvy68oXrBxr2Uof
	F1Y8FdzJkUGXfh99KXPCKuo4WIHdI+RMvGNV9ExC+BE9gegBcPtXMswZjNFAbBmfCinvkAE0J11
	tuaVaEsqsFszoDYGis5tsvcWkn4W9JHkBcCFSmWpIUQ==
X-Gm-Gg: ASbGncuvFdEU7nAZOyznvWPkAzQVPd6ISC0TOpIoEJYyGiDCrLPyhtfSuTIDOJep2gj
	1TdZS16EHjF0sdlIhZyLrjazaujRo8iGYZ0dcSnYK+IsGD9w0AmKPogxAewKuxKBFvSmnCZYGN5
	ridMUzipqw8+7ABtOytp4I4sAGo7hf2d4IysX6PtI5n1jPah4WpLtiiV/hTlVRm3DyZRsM4kMOX
	UKV0JgeIKrytAtEsXY=
X-Google-Smtp-Source: AGHT+IEXraZ6ANCCm4hz2YzAmUW9E8gEjXyQrjgH72KjrHlU01VwhpwtzguzunZ1QfUVew/uvX4aMoWYP0QubfaO3g8=
X-Received: by 2002:a17:902:e543:b0:258:a3a1:9aa5 with SMTP id
 d9443c01a7336-258a3a1a63dmr58985045ad.0.1757526263361; Wed, 10 Sep 2025
 10:44:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904192716.3064736-1-kbusch@meta.com> <20250904192716.3064736-3-kbusch@meta.com>
In-Reply-To: <20250904192716.3064736-3-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 10 Sep 2025 10:44:10 -0700
X-Gm-Features: Ac12FXxoRwNubHjGaa9O_MYFa9WQkoM4xmeeu3iStssqYgeZZBRxAhjVG0u5cB8
Message-ID: <CADUfDZrmuJyqkBx7-8qcqKCsCJDnKTUYMk4L7aCOTJGSeMzq6g@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
To: Keith Busch <kbusch@meta.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 12:27=E2=80=AFPM Keith Busch <kbusch@meta.com> wrote=
:
>
> From: Keith Busch <kbusch@kernel.org>
>
> Normal rings support 64b SQEs for posting submissions, while certain
> features require the ring to be configured with IORING_SETUP_SQE128, as
> they need to convey more information per submission. This, in turn,
> makes ALL the SQEs be 128b in size. This is somewhat wasteful and
> inefficient, particularly when only certain SQEs need to be of the
> bigger variant.
>
> This adds support for setting up a ring with mixed SQE sizes, using
> IORING_SETUP_SQE_MIXED. When setup in this mode, SQEs posted to the ring
> may be either 64b or 128b in size. If a SQE is 128b in size, then
> IOSQE_SQE_128B flag is set in the SQE flags to indicate that this is the
> case. If this flag isn't set, the SQE is the normal 64b variant.

I mentioned this on the previous revision, but it might be helpful to
document that IOSQE_SQE_128B also implies skipping an entry in the SQ
indirection array (when not using IORING_SETUP_NO_SQARRAY). There's no
obvious need to burn an entry in this array, as only a single u32
index is needed to refer to the SQE regardless of the SQE size. But it
certainly simplifies the implementation on the userspace side if it's
using an identity mapping in the SQ indirection array.

>
> SQEs on these types of mixed rings may also utilize NOP with skip
> success set.  This can happen if the ring is one (small) SQE entry away
> from wrapping, and an attempt is made to post a 128b SQE. As SQEs must be
> contiguous in the SQ ring, a 128b SQE cannot wrap the ring. For this
> case, a single NOP SQE is posted with the SKIP flag set. The kernel
> should simply ignore those.
>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  include/linux/io_uring_types.h |  3 +++
>  include/uapi/linux/io_uring.h  |  9 +++++++++
>  io_uring/fdinfo.c              | 32 +++++++++++++++++++++++++-------
>  io_uring/io_uring.c            | 20 +++++++++++++++++++-
>  io_uring/register.c            |  2 +-
>  io_uring/uring_cmd.c           |  4 +++-
>  6 files changed, 60 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index d1e25f3fe0b3a..d6e1c73400820 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -489,6 +489,7 @@ enum {
>         REQ_F_FORCE_ASYNC_BIT   =3D IOSQE_ASYNC_BIT,
>         REQ_F_BUFFER_SELECT_BIT =3D IOSQE_BUFFER_SELECT_BIT,
>         REQ_F_CQE_SKIP_BIT      =3D IOSQE_CQE_SKIP_SUCCESS_BIT,
> +       REQ_F_SQE_128B_BIT      =3D IOSQE_SQE_128B_BIT,
>
>         /* first byte is taken by user flags, shift it to not overlap */
>         REQ_F_FAIL_BIT          =3D 8,
> @@ -547,6 +548,8 @@ enum {
>         REQ_F_BUFFER_SELECT     =3D IO_REQ_FLAG(REQ_F_BUFFER_SELECT_BIT),
>         /* IOSQE_CQE_SKIP_SUCCESS */
>         REQ_F_CQE_SKIP          =3D IO_REQ_FLAG(REQ_F_CQE_SKIP_BIT),
> +       /* IOSQE_SQE_128B */
> +       REQ_F_SQE_128B          =3D IO_REQ_FLAG(REQ_F_SQE_128B_BIT),
>
>         /* fail rest of links */
>         REQ_F_FAIL              =3D IO_REQ_FLAG(REQ_F_FAIL_BIT),
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
> index 04ebff33d0e62..9cef9085f52ee 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -146,6 +146,7 @@ enum io_uring_sqe_flags_bit {
>         IOSQE_ASYNC_BIT,
>         IOSQE_BUFFER_SELECT_BIT,
>         IOSQE_CQE_SKIP_SUCCESS_BIT,
> +       IOSQE_SQE_128B_BIT,

Have you given any thought to how we would handle the likely scenario
that we want to define more SQE flags in the future? Are there
existing unused bytes of the SQE where the new flags could go? If not,
we may need to repurpose some existing but rarely used field. And then
we'd likely want to reserve this last flag bit to specify whether the
SQE is using this "extended flags" field.

>  };
>
>  /*
> @@ -165,6 +166,8 @@ enum io_uring_sqe_flags_bit {
>  #define IOSQE_BUFFER_SELECT    (1U << IOSQE_BUFFER_SELECT_BIT)
>  /* don't post CQE if request succeeded */
>  #define IOSQE_CQE_SKIP_SUCCESS (1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
> +/* this is a 128b/big-sqe posting */
> +#define IOSQE_SQE_128B         (1U << IOSQE_SQE_128B_BIT)
>
>  /*
>   * io_uring_setup() flags
> @@ -231,6 +234,12 @@ enum io_uring_sqe_flags_bit {
>   */
>  #define IORING_SETUP_CQE_MIXED         (1U << 18)
>
> +/*
> + * Allow both 64b and 128b SQEs. If a 128b SQE is posted, it will have
> + * IOSQE_SQE_128B set in sqe->flags.
> + */
> +#define IORING_SETUP_SQE_MIXED         (1U << 19)
> +
>  enum io_uring_op {
>         IORING_OP_NOP,
>         IORING_OP_READV,
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index 5c73398387690..ef0d17876a7b9 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -66,7 +66,6 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *=
ctx, struct seq_file *m)
>         unsigned int cq_head =3D READ_ONCE(r->cq.head);
>         unsigned int cq_tail =3D READ_ONCE(r->cq.tail);
>         unsigned int sq_shift =3D 0;
> -       unsigned int sq_entries;
>         int sq_pid =3D -1, sq_cpu =3D -1;
>         u64 sq_total_time =3D 0, sq_work_time =3D 0;
>         unsigned int i;
> @@ -89,26 +88,44 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
 *ctx, struct seq_file *m)
>         seq_printf(m, "CqTail:\t%u\n", cq_tail);
>         seq_printf(m, "CachedCqTail:\t%u\n", data_race(ctx->cached_cq_tai=
l));
>         seq_printf(m, "SQEs:\t%u\n", sq_tail - sq_head);
> -       sq_entries =3D min(sq_tail - sq_head, ctx->sq_entries);
> -       for (i =3D 0; i < sq_entries; i++) {
> -               unsigned int entry =3D i + sq_head;
> +       while (sq_head < sq_tail) {
>                 struct io_uring_sqe *sqe;
>                 unsigned int sq_idx;
> +               bool sqe128 =3D false;
> +               u8 sqe_flags;
>
>                 if (ctx->flags & IORING_SETUP_NO_SQARRAY)
>                         break;
> -               sq_idx =3D READ_ONCE(ctx->sq_array[entry & sq_mask]);
> +               sq_idx =3D READ_ONCE(ctx->sq_array[sq_head & sq_mask]);
>                 if (sq_idx > sq_mask)
>                         continue;
>                 sqe =3D &ctx->sq_sqes[sq_idx << sq_shift];
> +               sqe_flags =3D READ_ONCE(sqe->flags);
> +               if (sq_shift)
> +                       sqe128 =3D true;
> +               else if (sqe_flags & IOSQE_SQE_128B) {
> +                       if (!(ctx->flags & IORING_SETUP_SQE_MIXED)) {
> +                               seq_printf(m,
> +                                       "%5u: invalid sqe, 128B entry on =
non-mixed sq\n",
> +                                       sq_idx);
> +                               break;
> +                       }
> +                       if ((++sq_head & sq_mask) =3D=3D 0) {
> +                               seq_printf(m,
> +                                       "%5u: corrupted sqe, wrapping 128=
B entry\n",
> +                                       sq_idx);
> +                               break;
> +                       }
> +                       sqe128 =3D true;
> +               }
>                 seq_printf(m, "%5u: opcode:%s, fd:%d, flags:%x, off:%llu,=
 "
>                               "addr:0x%llx, rw_flags:0x%x, buf_index:%d "
>                               "user_data:%llu",
>                            sq_idx, io_uring_get_opcode(sqe->opcode), sqe-=
>fd,
> -                          sqe->flags, (unsigned long long) sqe->off,
> +                          sqe_flags, (unsigned long long) sqe->off,
>                            (unsigned long long) sqe->addr, sqe->rw_flags,
>                            sqe->buf_index, sqe->user_data);
> -               if (sq_shift) {
> +               if (sqe128) {
>                         u64 *sqeb =3D (void *) (sqe + 1);
>                         int size =3D sizeof(struct io_uring_sqe) / sizeof=
(u64);
>                         int j;
> @@ -120,6 +137,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
 *ctx, struct seq_file *m)
>                         }
>                 }
>                 seq_printf(m, "\n");
> +               sq_head++;
>         }
>         seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
>         while (cq_head < cq_tail) {
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 6c07efac977ce..78a81e882fce7 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2180,6 +2180,13 @@ static int io_init_req(struct io_ring_ctx *ctx, st=
ruct io_kiocb *req,
>         }
>         opcode =3D array_index_nospec(opcode, IORING_OP_LAST);
>
> +       if (ctx->flags & IORING_SETUP_SQE_MIXED &&
> +           req->flags & REQ_F_SQE_128B) {

Could use the local variable sqe_flags instead of req->flags

> +               if ((ctx->cached_sq_head & (ctx->sq_entries - 1)) =3D=3D =
0)
> +                       return io_init_fail_req(req, -EINVAL);
> +               ctx->cached_sq_head++;

I think the double increment of cached_sq_head breaks the logic in
io_sqring_entries(). The current assumption is that the difference
between the SQ tail and cached_sq_head is the number of SQEs available
to dispatch. And io_submit_sqes() will happily submit that many SQEs
without checking whether cached_sq_head has reached the SQ tail. This
assumption is broken now that one SQE may count for 2 increments of
the SQ indices.

> +       }
> +
>         def =3D &io_issue_defs[opcode];
>         if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
>                 /* enforce forwards compatibility on users */
> @@ -2793,6 +2800,10 @@ unsigned long rings_size(unsigned int flags, unsig=
ned int sq_entries,
>                 if (cq_entries < 2)
>                         return SIZE_MAX;
>         }
> +       if (flags & IORING_SETUP_SQE_MIXED) {
> +               if (sq_entries < 2)
> +                       return SIZE_MAX;
> +       }
>
>  #ifdef CONFIG_SMP
>         off =3D ALIGN(off, SMP_CACHE_BYTES);
> @@ -3724,6 +3735,13 @@ static int io_uring_sanitise_params(struct io_urin=
g_params *p)
>         if ((flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED)) =3D=3D
>             (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED))
>                 return -EINVAL;
> +       /*
> +        * Nonsensical to ask for SQE128 and mixed SQE support, it's not
> +        * supported to post 64b SQEs on a ring setup with SQE128.
> +        */
> +       if ((flags & (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED)) =3D=3D
> +           (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED))
> +               return -EINVAL;
>
>         return 0;
>  }
> @@ -3952,7 +3970,7 @@ static long io_uring_setup(u32 entries, struct io_u=
ring_params __user *params)
>                         IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_T=
ASKRUN |
>                         IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD=
_ONLY |
>                         IORING_SETUP_NO_SQARRAY | IORING_SETUP_HYBRID_IOP=
OLL |
> -                       IORING_SETUP_CQE_MIXED))
> +                       IORING_SETUP_CQE_MIXED | IORING_SETUP_SQE_MIXED))
>                 return -EINVAL;
>
>         return io_uring_create(entries, &p, params);
> diff --git a/io_uring/register.c b/io_uring/register.c
> index aa5f56ad83584..29aa7d3b4e820 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -397,7 +397,7 @@ static void io_register_free_rings(struct io_ring_ctx=
 *ctx,
>  #define RESIZE_FLAGS   (IORING_SETUP_CQSIZE | IORING_SETUP_CLAMP)
>  #define COPY_FLAGS     (IORING_SETUP_NO_SQARRAY | IORING_SETUP_SQE128 | =
\
>                          IORING_SETUP_CQE32 | IORING_SETUP_NO_MMAP | \
> -                        IORING_SETUP_CQE_MIXED)
> +                        IORING_SETUP_CQE_MIXED | IORING_SETUP_SQE_MIXED)
>
>  static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user=
 *arg)
>  {
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 5562e8491c5bd..8dd409774fd87 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -239,7 +239,9 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int i=
ssue_flags)
>         if (ret)
>                 return ret;
>
> -       if (ctx->flags & IORING_SETUP_SQE128)
> +       if (ctx->flags & IORING_SETUP_SQE128 ||
> +           (ctx->flags & IORING_SETUP_SQE_MIXED &&
> +            req->flags & REQ_F_SQE_128B))
>                 issue_flags |=3D IO_URING_F_SQE128;

uring_sqe_size() still seems to be missing this REQ_F_SQE_128B logic?

Best,
Caleb

>         if (ctx->flags & (IORING_SETUP_CQE32 | IORING_SETUP_CQE_MIXED))
>                 issue_flags |=3D IO_URING_F_CQE32;
> --
> 2.47.3
>

