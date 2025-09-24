Return-Path: <io-uring+bounces-9875-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 36FC9B9BD7F
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 22:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD1F87B7E76
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 20:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885A4327A39;
	Wed, 24 Sep 2025 20:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="AFRKM1/8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAEA3128B7
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 20:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745258; cv=none; b=p9+sMFyJ3I81xh9mb4YF8Q+wJ3Nj87PCWOSInbEEHRMIUjVj2ryJiY9ZZUlNbhnXpw9hJpFZ2ZRKxn5IcnCbuMTiOc1IKYsrv0fLZRAJwZY1SwwjocHdyiK3wZTB4TfzzwZvQ2JPBQ25mVUcQpQcmID3HiQHW2lR+xf7kAFDBsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745258; c=relaxed/simple;
	bh=z9Lh2qyVYJev0sW08ZgFSNJuSDIfN3EalzrOIDe0xVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JjIn45XlHXvwY814OIJ8IrpmRwzD7JL8nu3SWE5ykt0bSt/TPKwbl7FoxJWXa1BLzEryEWcn5BcV/kbpPDG55UHcoAI26cKeVz9H0AHvrcL+5BWiiiDinK+GmfIDB0IwUjuId/I9Baa2AoqQbDf9SzK31MR/0IXkc6jHf4G9g1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=AFRKM1/8; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-267f15eb5d3so361215ad.3
        for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 13:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1758745256; x=1759350056; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l5L22oYkMKwG6Zu58GYHxrdM0LkuEZHnuZ7mlkbE/x0=;
        b=AFRKM1/8XnsfML/Kzq6oHH72Enu3C5hErUJWn49TI8urHGtfn/+bY0PhC80UEweMiQ
         SkVUV63XU9NNltYbqjs5jWVzZdOVhIHC69wtz/IvWkPc0pst4Nk4VcXmtfD7LsUwORrj
         HdWs9IBY86afeK9egA1Np4AosAHBVU3KZDw0mSPJ0h96DQDytX1dhXUaWOGvGjcPjns5
         kHk/Ut6Sg0SHy8hq99jJI0bGNMzTr9oTrR2zk3LxoFzzDW3oO0eC5n6tfxKOQHe6ovwB
         JFK8QCImtNBc/vOwpbExfOJJc9RDfnI3dI3wD3BQcCqT9JlFuJWPhNn8ncrB7U/TE9mH
         slwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758745256; x=1759350056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l5L22oYkMKwG6Zu58GYHxrdM0LkuEZHnuZ7mlkbE/x0=;
        b=wraWg7ioFQ85/dQqfV12lg1hF2aOxZuRqkTGDInkj8fhs5SGu04uK3I2dLQY8BiYh9
         DrUQVCJNad9jhW3StvhGO1/vB1dNjI/YzAD+kA+69avykiqKm89lq2vx1tpYcehsVcYr
         M5fklWGULtp668CiWYa6uboKYQuU6QWuhLdhCbcT6k0Nazr7e/98pdvdDpPCYroTIo3m
         r71IgnRBMo9wBrs0AMbNVfnjTZZAYpLSdFchzuG4EfAvX5Wmbc8Wo5qPYkOg1aw745Qr
         8SJiIZzxJNiN0ctPm9vgETG6L8q6T+JdGjJQyMzllehFYxUokAzJ87gsz8xNqn8m3ltY
         j8/w==
X-Gm-Message-State: AOJu0YxUC6RLwI852r6nfgin0FBHLoKb5hxPCTpuOnvgwSAMgN/pz32b
	EbH31Z9WMM/I+bjparCjXz2IlUHcvknchTv+QlN17jKjKa/gk0cYdaJM2iUReC6W24KMpvORA3L
	LV2xpCnTdwoSrUYyiY0lyn/amKLXIMSxgb6LdWDAqmA==
X-Gm-Gg: ASbGnctOxID/IcGQk51vcj3ig7m4Nq9AfL3GDdO/LWRvOtEdlZDOYEtfJztyezM9brv
	7rliGfcFNceshVb33J8mEqcYat+QoVEaON8zP9SpN8P0W3GEI4V92J7lDdT+z7/XhaqvS3DjQdP
	i3Y94KPWgvPBjuqghYBCtFrgSvdqTHKDDwkSRELkgUarydpVNrBUfAV5eJjJlPUfqu/klHy628W
	ZQmyG+T8h08NktZVpAdaHMbpmkPcaUh1IUtJbQ=
X-Google-Smtp-Source: AGHT+IHQWGKRQw38Oj1Cs6UgA2PT5SHYB/sqFOeM96ThMdw/uwYv0/jJc6l/Od1ZzeOyuKBVThl7BxHmZyuFdKuCRNI=
X-Received: by 2002:a17:902:f551:b0:267:bd8d:1b6 with SMTP id
 d9443c01a7336-27ed4a2e4b5mr5661055ad.6.1758745255674; Wed, 24 Sep 2025
 13:20:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250924151210.619099-1-kbusch@meta.com> <20250924151210.619099-2-kbusch@meta.com>
In-Reply-To: <20250924151210.619099-2-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 24 Sep 2025 13:20:44 -0700
X-Gm-Features: AS18NWBe07XrsOQh7iGA9N7QL6rq_5VNiotmBMs8OdkBCwE9_8JX_gEX3rLHOSo
Message-ID: <CADUfDZrmFphH5AwNkLs=OtPg9qfnpciJB--28PVQ4q=5Fh21TQ@mail.gmail.com>
Subject: Re: [PATCHv3 1/3] Add support IORING_SETUP_SQE_MIXED
To: Keith Busch <kbusch@meta.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, ming.lei@redhat.com, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2025 at 8:12=E2=80=AFAM Keith Busch <kbusch@meta.com> wrote=
:
>
> From: Keith Busch <kbusch@kernel.org>
>
> This adds core support for mixed sized SQEs in the same SQ ring. Before
> this, SQEs were either 64b in size (the normal size), or 128b if
> IORING_SETUP_SQE128 was set in the ring initialization. With the mixed
> support, an SQE may be either 64b or 128b on the same SQ ring. If the
> SQE is 128b in size, then a 128b opcode will be set in the sqe op. When
> acquiring a large sqe at the end of the sq, the client may post a NOP
> SQE with IOSQE_CQE_SKIP_SUCCESS set that the kernel should simply ignore
> as it's just a pad filler that is posted when required.
>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  src/include/liburing.h          | 50 +++++++++++++++++++++++++++++++++
>  src/include/liburing/io_uring.h | 11 ++++++++
>  2 files changed, 61 insertions(+)
>
> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index 052d6b56..66f1b990 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -575,6 +575,7 @@ IOURINGINLINE void io_uring_initialize_sqe(struct io_=
uring_sqe *sqe)
>         sqe->buf_index =3D 0;
>         sqe->personality =3D 0;
>         sqe->file_index =3D 0;
> +       sqe->addr2 =3D 0;

Why is this necessary for mixed SQE size support? It looks like this
field is already initialized in io_uring_prep_rw() via the unioned off
field. Though, to be honest, I can't say I understand why the
initialization of the SQE fields is split between
io_uring_initialize_sqe() and io_uring_prep_rw().

>         sqe->addr3 =3D 0;
>         sqe->__pad2[0] =3D 0;
>  }
> @@ -799,6 +800,12 @@ IOURINGINLINE void io_uring_prep_nop(struct io_uring=
_sqe *sqe)
>         io_uring_prep_rw(IORING_OP_NOP, sqe, -1, NULL, 0, 0);
>  }
>
> +IOURINGINLINE void io_uring_prep_nop128(struct io_uring_sqe *sqe)
> +       LIBURING_NOEXCEPT
> +{
> +       io_uring_prep_rw(IORING_OP_NOP128, sqe, -1, NULL, 0, 0);
> +}
> +
>  IOURINGINLINE void io_uring_prep_timeout(struct io_uring_sqe *sqe,
>                                          struct __kernel_timespec *ts,
>                                          unsigned count, unsigned flags)
> @@ -1882,6 +1889,49 @@ IOURINGINLINE struct io_uring_sqe *_io_uring_get_s=
qe(struct io_uring *ring)
>         return sqe;
>  }
>
> +/*
> + * Return a 128B sqe to fill. Applications must later call io_uring_subm=
it()
> + * when it's ready to tell the kernel about it. The caller may call this
> + * function multiple times before calling io_uring_submit().
> + *
> + * Returns a vacant 128B sqe, or NULL if we're full. If the current tail=
 is the
> + * last entry in the ring, this function will insert a nop + skip comple=
te such
> + * that the 128b entry wraps back to the beginning of the queue for a
> + * contiguous big sq entry. It's up to the caller to use a 128b opcode i=
n order
> + * for the kernel to know how to advance its sq head pointer.
> + */
> +IOURINGINLINE struct io_uring_sqe *io_uring_get_sqe128_mixed(struct io_u=
ring *ring)
> +       LIBURING_NOEXCEPT
> +{
> +       struct io_uring_sq *sq =3D &ring->sq;
> +       unsigned head =3D io_uring_load_sq_head(ring), tail =3D sq->sqe_t=
ail;
> +       struct io_uring_sqe *sqe;
> +
> +       if (!(ring->flags & IORING_SETUP_SQE_MIXED))
> +               return NULL;
> +
> +       if (((tail + 1) & sq->ring_mask) =3D=3D 0) {
> +               if ((tail + 2) - head >=3D sq->ring_entries)
> +                       return NULL;
> +
> +               sqe =3D _io_uring_get_sqe(ring);
> +               if (!sqe)
> +                       return NULL;

This case should be impossible since we just checked there is an empty
SQ slot at the end of the ring plus two more at the beginning.

> +
> +               io_uring_prep_nop(sqe);
> +               sqe->flags |=3D IOSQE_CQE_SKIP_SUCCESS;
> +               tail =3D sq->sqe_tail;
> +       } else if ((tail + 1) - head >=3D sq->ring_entries) {
> +               return NULL;
> +       }
> +
> +       sqe =3D &sq->sqes[tail & sq->ring_mask];
> +       sq->sqe_tail =3D tail + 2;
> +       io_uring_initialize_sqe(sqe);
> +
> +       return sqe;
> +}
> +
>  /*
>   * Return the appropriate mask for a buffer ring of size 'ring_entries'
>   */
> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
> index 31396057..1e0b6398 100644
> --- a/src/include/liburing/io_uring.h
> +++ b/src/include/liburing/io_uring.h
> @@ -126,6 +126,7 @@ enum io_uring_sqe_flags_bit {
>         IOSQE_ASYNC_BIT,
>         IOSQE_BUFFER_SELECT_BIT,
>         IOSQE_CQE_SKIP_SUCCESS_BIT,
> +       IOSQE_SQE_128B_BIT,

I thought we decided against using an SQE flag bit for this? Looks
like this needs to be re-synced with the kernel uapi header.

Best,
Caleb

>  };
>
>  /*
> @@ -145,6 +146,8 @@ enum io_uring_sqe_flags_bit {
>  #define IOSQE_BUFFER_SELECT    (1U << IOSQE_BUFFER_SELECT_BIT)
>  /* don't post CQE if request succeeded */
>  #define IOSQE_CQE_SKIP_SUCCESS (1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
> +/* this is a 128b/big-sqe posting */
> +#define IOSQE_SQE_128B          (1U << IOSQE_SQE_128B_BIT)
>
>  /*
>   * io_uring_setup() flags
> @@ -211,6 +214,12 @@ enum io_uring_sqe_flags_bit {
>   */
>  #define IORING_SETUP_CQE_MIXED         (1U << 18)
>
> +/*
> + *  Allow both 64b and 128b SQEs. If a 128b SQE is posted, it will have
> + *  IOSQE_SQE_128B set in sqe->flags.
> + */
> +#define IORING_SETUP_SQE_MIXED         (1U << 19)
> +
>  enum io_uring_op {
>         IORING_OP_NOP,
>         IORING_OP_READV,
> @@ -275,6 +284,8 @@ enum io_uring_op {
>         IORING_OP_READV_FIXED,
>         IORING_OP_WRITEV_FIXED,
>         IORING_OP_PIPE,
> +       IORING_OP_NOP128,
> +       IORING_OP_URING_CMD128,
>
>         /* this goes last, obviously */
>         IORING_OP_LAST,
> --
> 2.47.3
>

