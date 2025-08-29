Return-Path: <io-uring+bounces-9483-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7C2EB3C443
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 23:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BE523A4AA0
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 21:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E4C220F2C;
	Fri, 29 Aug 2025 21:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ead/T6Qi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BBC20B22
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 21:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756502993; cv=none; b=u31QaEdK0AMpdtK0rFmJOirwjjwaC1cBzunooJXbDGYa43wplaTAaufNklLktv7gsaVDbRMDxcyYZAs05PO1u/GH1Yt3ygWghoR+CKstx8ai20DLv8BN+1cjsdXmlJa2DpqwGmdAu2jscPcQXNZHZ/B22/617itFoBZ9PlocDug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756502993; c=relaxed/simple;
	bh=4vlEoAi1bYg78/IonbYIuAgyUe6m4AUpaLkGOnFJuZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cXzNgPZ0r+be9OAN72UAEl0pYkNXMYb/hiuSsiMUVDqPGDOpxvuTzHbPGQVWQ0c1adcqo2zBBkXg31gSCvpqd+G9NKabBMkFhwQqqt6Iv5JjoTfJvmluGL0HJOjIxwbsmi9pMVF8C23fGkCK37w4oKJEc9fyBl+fSwvJMsgxnmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ead/T6Qi; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2489359cc48so5213325ad.2
        for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 14:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756502991; x=1757107791; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9b5JaHZtBWb64bDwTHafcoAnFK/FqPN/aNIkGx7Of6U=;
        b=ead/T6Qi7hdSYsS42tyRNVXpCfrh7/XjS5aFfs1uTBL2w3pdhIo5R7MlgxVw5MgGml
         yrP+Z86g34d5S9dcQfIoBgRbSXHx2IH57j5VlHGfahRBAoF6kSMUhTl9Cu8q8ydrZKet
         5bmrbh1qCCu76J2Itgyi8Pk3VSpQ/g/Be9JqNFLWzBgaLzPaWJdDA+XYbX8wRHCBKRom
         p38ookw7gs9l4ns70czwJeg03Qp7uxPYwjSlBAi0Avuhu2OloKWXJc4U7kNZf59HA9HJ
         +FYvaH6j9bQdmD329/VLkQsUB0jqxpcIFg8XlSSTsGWs4ZeKRdKo47tmSZwJ7X8SX7JL
         YYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756502991; x=1757107791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9b5JaHZtBWb64bDwTHafcoAnFK/FqPN/aNIkGx7Of6U=;
        b=kzx3m9/FWtP4XrGe8sIdPFNRbSCntEWXHGFV5fXR4FSFqEzFNy7EMa/mtekgQNrL91
         0fj1MgnOu1umfOhMp5dLAR6umfK2U883Xl4NxTrSoHDo4EuPPeuRDTAGufEZYfqRDQB7
         2aFj1slokbuPKQ4ss2Xjtuf3a79NbhpohM7wwKzfckIAo+ksWDNyG/SzeaJGrFqgrifF
         zUP2twSRT/dih9zgQWN29GDfTlVOpD5MxfceueX5tp/O35JIrSrBHC08luQJeyp6ojHn
         057sWKCEHFL+/RieqfWhiXOhpmsm6JfvvsyeDfw5HxD7ZgCk61faSwigPLXu7tz3ZA7T
         Y8Vw==
X-Forwarded-Encrypted: i=1; AJvYcCV+1FxRZK61SrnSpLM6ssLLAWzhiiFQ5ivKUtcyOghPjLrWCPj3A1/C1DtoiGBDI/6kLtsg0O7XKA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLmFtuTjD7m/xUSIUtj5++grDJg00Fwc8w39+PTbkP4VvlVBi5
	lTGrJuGD6KZwr6X7uQ+kjXOCzjAQYV3NcoxuiEZ5kkw0Qbw6QcOdcUSIRo/INkddbug7asUNqLC
	FrNY3tGMKzqx11wEuZGdef4srpS3lypi1mL1IacFzKaCCYXioZtF0to9YRg==
X-Gm-Gg: ASbGncsf02SDfn4WD4Pzlw9dLhVkl09ZI8IonaKKciQ+7yc9AIydFQykreIMUGQAo+V
	3aqpUK2bWdA94Z7K7Ry982iaH2BRLtdCneTQ6yEVGjH6YlCE1aKWWoqAWp1/YlW8cDRWoqTbaCD
	qvLE/t9Y+xChVIjJeFOnE5IFyXjkC1hZCWWzu1REShdYwo9y9aHPm7NefVcJd4acRnwbedqwJa5
	9d/qVcAt5jE/isMvl2UsPw=
X-Google-Smtp-Source: AGHT+IHPyCkcUBKAzsPst9Pfopj/X/1oddH+uWNKF2c4lIEguS2fRt2wl23+noo54W/4QdnHaI9A0CYqDW5y3UilpcU=
X-Received: by 2002:a17:902:d2cb:b0:240:280a:5443 with SMTP id
 d9443c01a7336-2491e5df37cmr22750985ad.3.1756502991089; Fri, 29 Aug 2025
 14:29:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250829193935.1910175-1-kbusch@meta.com> <20250829193935.1910175-3-kbusch@meta.com>
In-Reply-To: <20250829193935.1910175-3-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 29 Aug 2025 14:29:39 -0700
X-Gm-Features: Ac12FXyakzNzdW-0CQ7nkcBPYqAqusKzUyb-aFKbZDVatWMc8O7yS77ORbOZUIY
Message-ID: <CADUfDZqpTsEOROA0Tkrq1WprpBvmzvhMPiFXZwLT4WMTSmAXqQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2025 at 12:41=E2=80=AFPM Keith Busch <kbusch@meta.com> wrot=
e:
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
>
> SQEs on these types of mixed rings may also utilize NOP with skip
> success set.  This can happen if the ring is one (small) SQE entry away
> from wrapping, and an attempt is made to post a 128b SQE. As SQEs must be
> contigious in the SQ ring, a 128b SQE cannot wrap the ring. For this

typo: contiguous"

> case, a single NOP SQE is posted with the SKIP flag set. The kernel
> should simply ignore those.
>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  include/uapi/linux/io_uring.h |  9 +++++++++
>  io_uring/fdinfo.c             | 21 ++++++++++-----------
>  io_uring/io_uring.c           | 15 ++++++++++++++-
>  3 files changed, 33 insertions(+), 12 deletions(-)
>
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
> index 5c73398387690..4eb6dbb9807be 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -65,15 +65,10 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
 *ctx, struct seq_file *m)
>         unsigned int sq_tail =3D READ_ONCE(r->sq.tail);
>         unsigned int cq_head =3D READ_ONCE(r->cq.head);
>         unsigned int cq_tail =3D READ_ONCE(r->cq.tail);
> -       unsigned int sq_shift =3D 0;
> -       unsigned int sq_entries;
>         int sq_pid =3D -1, sq_cpu =3D -1;
>         u64 sq_total_time =3D 0, sq_work_time =3D 0;
>         unsigned int i;
>
> -       if (ctx->flags & IORING_SETUP_SQE128)
> -               sq_shift =3D 1;
> -
>         /*
>          * we may get imprecise sqe and cqe info if uring is actively run=
ning
>          * since we get cached_sq_head and cached_cq_tail without uring_l=
ock
> @@ -89,18 +84,19 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
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
>
>                 if (ctx->flags & IORING_SETUP_NO_SQARRAY)
>                         break;
> -               sq_idx =3D READ_ONCE(ctx->sq_array[entry & sq_mask]);
> +               sq_idx =3D READ_ONCE(ctx->sq_array[sq_head & sq_mask]);
>                 if (sq_idx > sq_mask)
>                         continue;
> -               sqe =3D &ctx->sq_sqes[sq_idx << sq_shift];
> +               sqe =3D &ctx->sq_sqes[sq_idx];

We still need to double the sq_idx in the IORING_SETUP_SQE128 case, right?

> +               if (sqe->flags & IOSQE_SQE_128B || ctx->flags & IORING_SE=
TUP_SQE128)
> +                       sqe128 =3D true;
>                 seq_printf(m, "%5u: opcode:%s, fd:%d, flags:%x, off:%llu,=
 "
>                               "addr:0x%llx, rw_flags:0x%x, buf_index:%d "
>                               "user_data:%llu",
> @@ -108,7 +104,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
 *ctx, struct seq_file *m)
>                            sqe->flags, (unsigned long long) sqe->off,
>                            (unsigned long long) sqe->addr, sqe->rw_flags,
>                            sqe->buf_index, sqe->user_data);
> -               if (sq_shift) {
> +               if (sqe128) {
>                         u64 *sqeb =3D (void *) (sqe + 1);

Needs to check that IOSQE_SQE_128B isn't set on the last entry in the
SQE array to avoid accessing past the end of it?

>                         int size =3D sizeof(struct io_uring_sqe) / sizeof=
(u64);
>                         int j;
> @@ -120,6 +116,9 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
 *ctx, struct seq_file *m)
>                         }
>                 }
>                 seq_printf(m, "\n");
> +               sq_head++;
> +               if (sqe128)
> +                       sq_head++;
>         }
>         seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
>         while (cq_head < cq_tail) {
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 6c07efac977ce..7788292be8560 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2416,6 +2416,8 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, con=
st struct io_uring_sqe **sqe)
>         if (ctx->flags & IORING_SETUP_SQE128)
>                 head <<=3D 1;
>         *sqe =3D &ctx->sq_sqes[head];
> +       if (ctx->flags & IORING_SETUP_SQE_MIXED && (*sqe)->flags & IOSQE_=
SQE_128B)

Use READ_ONCE() to read userspace-mapped memory?

Do we also need to check that this isn't the last entry in the SQEs
array? Otherwise, it seems like buggy/malicious userspace can cause
the kernel to read past the end of the array.

> +               ctx->cached_sq_head++;

Probably worth documenting that when using the SQ indirection array
(i.e. not IORING_SETUP_NO_SQARRAY), the index into the indirection
array is expected to increment twice for a 128-byte SQE even though it
still only uses a single unsigned entry in this array. I can see how
this behavior eases the liburing implementation of this (so the
indirection array is always an identity mapping to the SQE array), but
it might be surprising for applications that reuse SQEs and only
modify the indirection array that they have to skip an extra entry in
the indirection array.

io_get_sequence() seems to have some funky logic that assumes
cached_sq_head counts full I/Os rather than SQEs, so this might break
it.

io_sqring_entries() also computes sq.tail - cached_sq_head, which I
don't think works in the presence of IOSQE_SQE_128B. io_submit_sqes()
probably needs to compare cached_sq_head to the (cached) value of
sq.tail to tell when all the SQEs have been consumed.

>         return true;
>  }
>
> @@ -2793,6 +2795,10 @@ unsigned long rings_size(unsigned int flags, unsig=
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
> @@ -3724,6 +3730,13 @@ static int io_uring_sanitise_params(struct io_urin=
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
> @@ -3952,7 +3965,7 @@ static long io_uring_setup(u32 entries, struct io_u=
ring_params __user *params)
>                         IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_T=
ASKRUN |
>                         IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD=
_ONLY |
>                         IORING_SETUP_NO_SQARRAY | IORING_SETUP_HYBRID_IOP=
OLL |
> -                       IORING_SETUP_CQE_MIXED))
> +                       IORING_SETUP_CQE_MIXED | IORING_SETUP_SQE_MIXED))

There are a few other users of IORING_SETUP_SQE128 that likely need to
be made aware of IOSQE_SQE_128B. For one, uring_sqe_size(), which is
used to determine how large the SQE payload is when copying it for a
uring_cmd that goes async. And the logic for setting IO_URING_F_SQE128
in io_uring_cmd() also needs to be adjusted.

Best,
Caleb

>                 return -EINVAL;
>
>         return io_uring_create(entries, &p, params);
> --
> 2.47.3
>
>

