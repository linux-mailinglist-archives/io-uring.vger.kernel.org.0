Return-Path: <io-uring+bounces-7765-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A66DA9FE76
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 02:41:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D72703A453B
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 00:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB1721C9DC6;
	Tue, 29 Apr 2025 00:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Za0IEsi3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A681C5F1E
	for <io-uring@vger.kernel.org>; Tue, 29 Apr 2025 00:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745887001; cv=none; b=DKsAVv02l0WHdSElPYmJKEKHqjNxrW1GqmnZAFnvouJv30detQXZFvNc+UED9XH2tNlpqY0+jK2m5LB20qW61BK32BR4gyhT14NDtLABCvpa5u52xpbjUxQoGKaNJ9R6ucIcS0UhI8qVskUnLgDdjm6Y2WkxVLh4xpMccaWodC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745887001; c=relaxed/simple;
	bh=YV128YWuem3NUBiyOuUSgc+P69KzpuVfFAcg7eo8iL8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ROXDPA/yublc+ULPvs4AjL7W083WHaFWWCkRcs9uumoq9tMUQImTJVzjQ6iT3kjz+shztKJne6binIXIcTwOv8a73G4oUogaOa/DaaYoHownRlmXMonOj3WG8FkFpcrri4eu3G5N4C1tO7EISoRzJ6TR9Q6bexRX/I0L4WWGM0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Za0IEsi3; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-73b71a9a991so765294b3a.2
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 17:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1745886999; x=1746491799; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUY2HZtfj4SceC9gAAHYPYBj8Sh0u+yOl+JrQ3WQwfE=;
        b=Za0IEsi3Xv9j7/5wn2rwW1fI4TY8myno3ufzLSYv2KKCBKZ8AXJAgijWJg9fRbhhVd
         GePSp0MlfRNPnWI+nKRg3Bx94YYHvi+xiF3a9YR3ALaCYJXlFxzrQ/f3sRwnvXswnhzO
         PciOMIxEFJcgTgLSkXid3Cgm2tOWkaN0a45x/lkQDX0aCwrMUYsF5KqPtvzIl/DiMskE
         HNBN2t1Qrq1v6aTPaQNOLIq7kC+HB5OFjVX/MREJNBX4Uf6+UgTpTnWHL5ZRH9XDbxB7
         n+NEpGlM56yWmScYwY5EqFP8MZm0SLzixxIsDDBPdRb//ZShp3z7CDqjbLNsLezDG8DY
         cXGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745886999; x=1746491799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CUY2HZtfj4SceC9gAAHYPYBj8Sh0u+yOl+JrQ3WQwfE=;
        b=X9jr/10Z53fT39Z6oDinuxHFNSXhNo2S4sIAl8HNr/T0WiOsLxAzG+gD89oqkW9B8x
         DSLCVJpF2RMAAHFrjQPWT7HcGY5v4f6OOgMr7UT6yd4MSoDsVluklibjjGqRaAIAfiXe
         IG2Fb0mSUENHZbKJ8VMfRGSme2JhqOU6Gw20AsoD2ohVnA89YBJSro+N6K+0sFgHChks
         QKOzzOqZQPhzNMYFvPY1IvcmEHDslX3NzuZOmVEvNRgluGLvqUHEoI7buzMFSdh2rbc3
         BCjkloXS7hNqYOl+XVPRKoqg3J/ZWOiRGIx2Luv4VEN1kCrAt9NMlvdXW4IWMIBJvFrh
         GiZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVb3yUKatZN5RFVD6KoW2QHJp+x+3JOBuEE0uiH7XV7tacD6O1dYMEUjCTT645EFTnBv18/czCAmA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyNSePXtR9gOVS0cwBW1P5Jf7z/G7kLFPOp53flFNae/BjgydER
	oPmsLz1itikkzicokr2joUN5f8LSYtmfyaPgotkMnkQhww5sn8fsIDwfV7jzhZxM3vN1my7w2gY
	0rQ5ztq3wdK4EQsPrhK6ttiUL6r06R0Btb207HpqrKaPq6vOuA/o1XQ==
X-Gm-Gg: ASbGncsjjJJSHEnYJbgykcptZdM3YrUMOL7KeZHvloYH9NTbRBDDt9Rbr6Ys+wLE5lY
	gvBp4USKp9HCUjK53JLwdXLzmKeF4R8LhztIQyt9oyvJ4pq6vji8zyXpqtHuI4G23fxSJ0kwC7u
	IsFlcRm/0/8yGodPmK79DVyY7/bfINGL0=
X-Google-Smtp-Source: AGHT+IEsKM/XARtoR/+hM6PD6zfgoAlXEa7lYxhw1x4kmw477DQoL9u7PQhhlNlrQseVJUQinHSYKHOY2vhDF7FEslw=
X-Received: by 2002:a17:90b:4d0c:b0:306:e75e:dbc7 with SMTP id
 98e67ed59e1d1-30a21f8bdc0mr700135a91.0.1745886999196; Mon, 28 Apr 2025
 17:36:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428094420.1584420-1-ming.lei@redhat.com> <20250428094420.1584420-3-ming.lei@redhat.com>
In-Reply-To: <20250428094420.1584420-3-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 28 Apr 2025 17:36:28 -0700
X-Gm-Features: ATxdqUHn3FL8XO3lr-nEJNDqefT73CwxW5EvfTWIeGxsnLoK9USitZDbXJmlOuk
Message-ID: <CADUfDZpTnntS0r40rBV4aeBx6Sf=X8jQiZDiB+C8Vch7CdaPtQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/7] io_uring: add helper __io_buffer_[un]register_bvec
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org, 
	Uday Shankar <ushankar@purestorage.com>, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2025 at 2:44=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> Add helper __io_buffer_[un]register_bvec and prepare for supporting to
> register bvec buffer into specified io_uring and buffer index.
>
> No functional change.
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  io_uring/rsrc.c | 88 ++++++++++++++++++++++++++-----------------------
>  1 file changed, 46 insertions(+), 42 deletions(-)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 66d2c11e2f46..5f8ab130a573 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -918,11 +918,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx,=
 void __user *arg,
>         return ret;
>  }
>
> -int io_buffer_register_bvec(struct io_uring_cmd *cmd,
> -                           struct io_buf_data *buf,
> -                           unsigned int issue_flags)
> +static int __io_buffer_register_bvec(struct io_ring_ctx *ctx,
> +                                    struct io_buf_data *buf)

__must_hold(&ctx->uring_lock) ? Same comment about
__io_buffer_unregister_bvec().

Best,
Caleb

>  {
> -       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
>         struct io_rsrc_data *data =3D &ctx->buf_table;
>         unsigned int index =3D buf->index;
>         struct request *rq =3D buf->rq;
> @@ -931,32 +929,23 @@ int io_buffer_register_bvec(struct io_uring_cmd *cm=
d,
>         struct io_rsrc_node *node;
>         struct bio_vec bv, *bvec;
>         u16 nr_bvecs;
> -       int ret =3D 0;
>
> -       io_ring_submit_lock(ctx, issue_flags);
> -       if (index >=3D data->nr) {
> -               ret =3D -EINVAL;
> -               goto unlock;
> -       }
> -       index =3D array_index_nospec(index, data->nr);
> +       if (index >=3D data->nr)
> +               return -EINVAL;
>
> -       if (data->nodes[index]) {
> -               ret =3D -EBUSY;
> -               goto unlock;
> -       }
> +       index =3D array_index_nospec(index, data->nr);
> +       if (data->nodes[index])
> +               return -EBUSY;
>
>         node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
> -       if (!node) {
> -               ret =3D -ENOMEM;
> -               goto unlock;
> -       }
> +       if (!node)
> +               return -ENOMEM;
>
>         nr_bvecs =3D blk_rq_nr_phys_segments(rq);
>         imu =3D io_alloc_imu(ctx, nr_bvecs);
>         if (!imu) {
>                 kfree(node);
> -               ret =3D -ENOMEM;
> -               goto unlock;
> +               return -ENOMEM;
>         }
>
>         imu->ubuf =3D 0;
> @@ -976,43 +965,58 @@ int io_buffer_register_bvec(struct io_uring_cmd *cm=
d,
>
>         node->buf =3D imu;
>         data->nodes[index] =3D node;
> -unlock:
> +
> +       return 0;
> +}
> +
> +int io_buffer_register_bvec(struct io_uring_cmd *cmd,
> +                           struct io_buf_data *buf,
> +                           unsigned int issue_flags)
> +{
> +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> +       int ret;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +       ret =3D __io_buffer_register_bvec(ctx, buf);
>         io_ring_submit_unlock(ctx, issue_flags);
> +
>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
>
> -int io_buffer_unregister_bvec(struct io_uring_cmd *cmd,
> -                             struct io_buf_data *buf,
> -                             unsigned int issue_flags)
> +static int __io_buffer_unregister_bvec(struct io_ring_ctx *ctx,
> +                                      struct io_buf_data *buf)
>  {
> -       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
>         struct io_rsrc_data *data =3D &ctx->buf_table;
>         unsigned index =3D buf->index;
>         struct io_rsrc_node *node;
> -       int ret =3D 0;
>
> -       io_ring_submit_lock(ctx, issue_flags);
> -       if (index >=3D data->nr) {
> -               ret =3D -EINVAL;
> -               goto unlock;
> -       }
> -       index =3D array_index_nospec(index, data->nr);
> +       if (index >=3D data->nr)
> +               return -EINVAL;
>
> +       index =3D array_index_nospec(index, data->nr);
>         node =3D data->nodes[index];
> -       if (!node) {
> -               ret =3D -EINVAL;
> -               goto unlock;
> -       }
> -       if (!node->buf->is_kbuf) {
> -               ret =3D -EBUSY;
> -               goto unlock;
> -       }
> +       if (!node)
> +               return -EINVAL;
> +       if (!node->buf->is_kbuf)
> +               return -EBUSY;
>
>         io_put_rsrc_node(ctx, node);
>         data->nodes[index] =3D NULL;
> -unlock:
> +       return 0;
> +}
> +
> +int io_buffer_unregister_bvec(struct io_uring_cmd *cmd,
> +                             struct io_buf_data *buf,
> +                             unsigned int issue_flags)
> +{
> +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> +       int ret;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +       ret =3D __io_buffer_unregister_bvec(ctx, buf);
>         io_ring_submit_unlock(ctx, issue_flags);
> +
>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
> --
> 2.47.0
>

