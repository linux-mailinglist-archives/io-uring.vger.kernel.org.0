Return-Path: <io-uring+bounces-9756-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 586F5B5393B
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 18:28:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B9B21C81237
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 16:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5385A35334F;
	Thu, 11 Sep 2025 16:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="A9PJQOeJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EAE35A289
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 16:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757608054; cv=none; b=H8+oEoeM2OqLBJtBqOAwuPXT5eqS1Ww3Q6P8NaEbQ2tuTU0Tqo/MKJBPhc2goceuw44op5UTr74NwI8PHzdVNR7/88wAkf0YaAg9aedcwRVl5dtNtWvatcBQFP9DXgK7MJpur8sComCTi6wjt1gFYEz2VNBfW2eMafQ+m8yQOEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757608054; c=relaxed/simple;
	bh=DtGfCkd5Q7Avapnz1RxUqJbfWLQGCJJpANvMzpC+NX8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pe8MbIDCj67dyh3eHP47CIwJog6+XX5fhk5A1I+ZtfO8ELkzeEYPo6uvbtUNWJUNRueuDrh2cIpYLwOUSBbRnxR9DImBUkFFd5CtkRz5hQ7fVip8wJD1lOZJaovXvKIFlEhVb3l/VKUqQfznTQbR7EO7Gd8mnTvPLzgcMQ5llQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=A9PJQOeJ; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24498e93b8fso1328505ad.3
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 09:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757608052; x=1758212852; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RZGCp7/3WAb2Ib/3+AZ09RgSeq6gU/I2U881MAVg0yw=;
        b=A9PJQOeJ4AzqvOKvuAL+4lWjAZgsMl/Gn2nl0cSVvePpTvq7J7hx+KywJScys5YUIz
         86pq4JHKdk8JF+NZaxvZ9NcicsSp3qvQW3XczoMFIAEhLX5pv2cUdmm8zQFSdjZdaGUB
         8gAI8fMrDovvxyo1o+5ZXF+t8rG+rm9o5/C4UDA5Wx5R8rVEqN/Fu8atSEoTF4cxfU/Z
         5m8+METS9PqW1BtrxK9/kcsoJgcn9QzOrq41GeGVJZONeB2pTeF9gIPkAkoquUIj0a8y
         4OgZyvr5B2y8yv1IurBjHCo78itRHSatjRjlMoKXo0c7tXlHeNcxJwylxU5slX0ZOLto
         M4Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757608052; x=1758212852;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RZGCp7/3WAb2Ib/3+AZ09RgSeq6gU/I2U881MAVg0yw=;
        b=pzC8wQMHY94VHautM+yez8OCrIZTXcwneHfhNW5I/OK9//UPeENdpOcoXHEyv1v1ux
         nLj29BzUuuXt3WUV6W8NbfMXfLGzMvQj7entLG+Mg2CWDfcrCNzp6g3vjdaQO9Vi9OXW
         bTFDyFI6u3xNqZtDh78MMrAiNlhM+fVMLgYiQ1ZYXpukczBFIl/VAVYAchpZIcact7qx
         lYMMHX1ZyblJA4czhtjKw9Full6UEz4pnne8JfgP2Jxf3mM21sON5zawQBvAfR2S7kRD
         sNqUqCw+g/hYDdx93xVn+FtGoCxiskALkvmY0xjWTOV696Z3IlzgWPxnMYu1mMwzzD1p
         wG1w==
X-Gm-Message-State: AOJu0YyefPqSkSti4LxjbDNwIRnzhwK11vrcdL4zdUAD8jIg2gKgH+93
	Y2XgXSJql18HGRR1uoRqohYFJ1se4JBc7eRtcfD3nW8HqSErgbhrhHoOSx9BBzhK8lM6y84H7++
	E6mA5NdypdqU2YKlCx94hLqkS++ppeq+HoUCbR28ANQ==
X-Gm-Gg: ASbGncuz7stVXhnfyFOIkWv4aiaY9IJpSQ0OY5bFapOpjBeYfEo7d+82V+QduNODk8C
	pUug/rNHcLJP210czhUvB1W2o/EI3vcOZQ656YBfAX5bnn9MBK5iJBgFKIr5tHl3n5wMu7ZkARf
	M+w4eAqcRNa7MqKmSz+YJxko/4zRgIynpSfxEVun0iSwR6jPQXhdb1mWyWp229eA/sguMGk/8Nb
	eHv1AYpYJHKju5IkqBPi7KppPeW6xWpH21kgMw=
X-Google-Smtp-Source: AGHT+IHr0iQk3v0BbhQBRDlhZ35X9zZoZIO1EtchjEWn+WTE3Y8DjLTSOXLPvS2F3HiG8EQW5e/m5qAAHiPJooz2q8I=
X-Received: by 2002:a17:902:fb10:b0:24c:e213:ca4a with SMTP id
 d9443c01a7336-25d246db35bmr180705ad.2.1757608051679; Thu, 11 Sep 2025
 09:27:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904192716.3064736-1-kbusch@meta.com> <20250904192716.3064736-2-kbusch@meta.com>
In-Reply-To: <20250904192716.3064736-2-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 11 Sep 2025 09:27:19 -0700
X-Gm-Features: Ac12FXxi0kPySdHxaO4x8rRmvlHPQmxBE5dVR6k8elms976HO8zyFqhtMvpDRQc
Message-ID: <CADUfDZq-fNG=4d8d=fy=q=Zw9O5qoHjaaLrDieqNJFoDeJHeXA@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/3] Add support IORING_SETUP_SQE_MIXED
To: Keith Busch <kbusch@meta.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 12:27=E2=80=AFPM Keith Busch <kbusch@meta.com> wrote=
:
>
> From: Keith Busch <kbusch@kernel.org>
>
> This adds core support for mixed sized SQEs in the same SQ ring. Before
> this, SQEs were either 64b in size (the normal size), or 128b if
> IORING_SETUP_SQE128 was set in the ring initialization. With the mixed
> support, an SQE may be either 64b or 128b on the same SQ ring. If the
> SQE is 128b in size, then IOSQE_SQE_128B will be set in the sqe flags.
> The client may post a NOP SQE with IOSQE_CQE_SKIP_SUCCESS set that the
> kernel should simply ignore as it's just a pad filler that is posted
> when required.
>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  src/include/liburing.h          | 31 +++++++++++++++++++++++++++++++
>  src/include/liburing/io_uring.h |  9 +++++++++
>  2 files changed, 40 insertions(+)
>
> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index 7ea876e1..97c70fa7 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -1853,6 +1853,37 @@ IOURINGINLINE struct io_uring_sqe *_io_uring_get_s=
qe(struct io_uring *ring)
>         return sqe;
>  }
>
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
> +       if ((tail & sq->ring_mask) + 1 =3D=3D sq->ring_entries) {

The condition you used on the kernel side is probably a bit more efficient:
(tail + 1) & sq->ring_mask =3D=3D 0

> +               sqe =3D _io_uring_get_sqe(ring);
> +               if (!sqe)
> +                       return NULL;
> +
> +               io_uring_prep_nop(sqe);
> +               sqe->flags |=3D IOSQE_CQE_SKIP_SUCCESS;
> +               tail =3D sq->sqe_tail;
> +       }
> +
> +       if ((tail + 1) - head >=3D sq->ring_entries)
> +               return NULL;

Would it make sense to check for a full SQ before creating a NOP SQE
to avoid wasted work if the actual SQE can't be posted?

Best,
Caleb

> +
> +       sqe =3D &sq->sqes[tail & sq->ring_mask];
> +       sq->sqe_tail =3D tail + 2;
> +       io_uring_initialize_sqe(sqe);
> +       sqe->flags |=3D IOSQE_SQE_128B;
> +
> +       return sqe;
> +}
> +
>  /*
>   * Return the appropriate mask for a buffer ring of size 'ring_entries'
>   */
> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
> index 643514e5..fd02fa52 100644
> --- a/src/include/liburing/io_uring.h
> +++ b/src/include/liburing/io_uring.h
> @@ -126,6 +126,7 @@ enum io_uring_sqe_flags_bit {
>         IOSQE_ASYNC_BIT,
>         IOSQE_BUFFER_SELECT_BIT,
>         IOSQE_CQE_SKIP_SUCCESS_BIT,
> +       IOSQE_SQE_128B_BIT,
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
> --
> 2.47.3
>

