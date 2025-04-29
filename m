Return-Path: <io-uring+bounces-7766-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B85BA9FE89
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 02:43:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CF231A8199B
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 00:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94AC013B2A9;
	Tue, 29 Apr 2025 00:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="PXllZCAg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9712C148
	for <io-uring@vger.kernel.org>; Tue, 29 Apr 2025 00:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745887407; cv=none; b=uIhsY/FYJPlbHnpl37vXHhpsS5R+w4mF9f0H8RM5dFvZj8NKRkd0ZwFGYB3rE8H08DkgdKSHwSfeZjkKjdzPV++VwlJrnWF9R9dj0ACPOC2154+ptrTaaosT3Qj3/+xVhzfNWY23YoMSHBdcymD1vbmlYS3mtGZMaGOJUr6eEb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745887407; c=relaxed/simple;
	bh=qvO2ugwbwgySij5oEbnyQ/CyTviX4pyztAgxxytE/yQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i4ClYewIub3UC0RSpNiQ52DX8E4B/du426BWCVvFWvlKNn3xKpkQvFTeqlWZdSmdrTmEni7XbXfghlqNPDVf7YnrlAAt8vTWljCctO7DqVQ5FkqyXr/GScJMWyKQFVd5yiHBjnLELW8t9u2gJPQb7/o1I4Sjlzrz//7Bl0GifVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=PXllZCAg; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-224172f32b3so12961425ad.2
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 17:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1745887404; x=1746492204; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uqCCsAC+PJU6X8dhYCe5wf2IDjINWrtnTDvL86ONH7Y=;
        b=PXllZCAgoe8Gnb2TmgaoJqTXs8JQBXSRI2XvJn4Ax0kkBkI5Vhyi5QzwPE9bAOXC4e
         AjWLKq3AZSvmUtkvNqwJZmiLvGrueXPOGfOD2YSQWOygiBR/xYO3/BgDUmA2lhdbanTT
         zGYZCCfCqdgxG1hR29UKrCAWOzTxnSGRmkx/DifN/YlW4/jKFEoKgVzUIN6OfV3fcxVB
         vBZdo/6Ln8zP5yHj7GFnj8DOXyvfGl/irbvOwYDgSRmyVpoeuOIHOD/CzaiBVyZs6v08
         P3q2FaHoMYAdYGEAVP/K5SGzEXXUbUDDb1ZsR4bLcK6v+vjBb8y+WvLh2Y4XGK7uXOBz
         SzHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745887404; x=1746492204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uqCCsAC+PJU6X8dhYCe5wf2IDjINWrtnTDvL86ONH7Y=;
        b=hgnmmTja/drWMDYeK2bgFVBRltLEUNaWCrHbthJ77q4/5HLzA76EpnL4FZBCAqXJbZ
         QYRDqk1Q1jox7QO/lMI/Jj/e/pfoSWsQH96uX9QmPszWbo3C9soG9uRJoBO3secKVhlE
         qzjckzeV8/tm3TSeRY8pH+DiIJj3tBb6rDGhKJpWYIuTJCaiqH7hvPgke74q7YBFDvvO
         EVHC1BEVRBwm+q53YoWduW42e5TxJSQEBcvqotpUUL9WNzy+nQkOEiR3x53oM5qIh0ke
         t55eYO4ZlPGCPfVJDEPPb2q+p3DcuHdZO3OA7YtLO2rTtGvqX7LXyHRThnO5tpuuDvzG
         RmwQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5hrZEzDXOA/vfhhRZL8CFerb+CfExVmy36DJb/woMiDHfCg3hSYYOuhifxJetFGF/fXpu6u56Pg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyV182YhBq2WozAAd3e4CgM1NC4E8A5tXOqh9a67k41rOJwbI6o
	bLJnTtq2vqP2CbVkAK61YsoMY2TikzECh0H+r7MVlgVWpTa5FdkoM4MbyJGaTwLha+iVaVGWU5w
	Rb3coA6/OJpF1a+KaeIdTYHBP+/wppBwCxIb/CQ==
X-Gm-Gg: ASbGnct3SJ7Aai8CiJOCvcITXnSkt4upVIyYITBVRWI8uNs/lmsYfQ8mIyxeMpuULV6
	Ykm1bnKoEqVNnY7iEvkNUseMVvTBtRVEMZH3zbmyuQZs2q0z3yzYFuB51gd+Pj5f3SxApjw/1lW
	yUqq5f3DlV1/ZbfexAgd0cIhG/kalVSSA=
X-Google-Smtp-Source: AGHT+IFyLKuenhjgW1ETPdMItVSa5f5tbjQsNiJuTQd0zX6A0GdEbjT8LicOp+Z9krsrGFfGZWnytCJrboJ8h9TVbOM=
X-Received: by 2002:a17:903:2cf:b0:216:30f9:93c5 with SMTP id
 d9443c01a7336-22de6e9afd7mr6468415ad.6.1745887403866; Mon, 28 Apr 2025
 17:43:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428094420.1584420-1-ming.lei@redhat.com> <20250428094420.1584420-4-ming.lei@redhat.com>
In-Reply-To: <20250428094420.1584420-4-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 28 Apr 2025 17:43:12 -0700
X-Gm-Features: ATxdqUEBDgUXvObnt9AGGgF8WlwaJuwIdhvlYu9_URmdnPZxWoAZiVI_BgSPfzU
Message-ID: <CADUfDZrXTzXM4tA6vRcOz1qn61he+Y6p5UsLeprbmhDVJe0gbg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/7] io_uring: support to register bvec buffer to
 specified io_uring
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org, 
	Uday Shankar <ushankar@purestorage.com>, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2025 at 2:44=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> Extend io_buffer_register_bvec() and io_buffer_unregister_bvec() for
> supporting to register/unregister bvec buffer to specified io_uring,
> which FD is usually passed from userspace.
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/io_uring/cmd.h |  4 ++
>  io_uring/rsrc.c              | 83 +++++++++++++++++++++++++++---------
>  2 files changed, 67 insertions(+), 20 deletions(-)
>
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 78fa336a284b..7516fe5cd606 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -25,6 +25,10 @@ struct io_uring_cmd_data {
>
>  struct io_buf_data {
>         unsigned short index;
> +       bool has_fd;
> +       bool registered_fd;
> +
> +       int ring_fd;
>         struct request *rq;
>         void (*release)(void *);
>  };
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 5f8ab130a573..701dd33fecf7 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -969,21 +969,6 @@ static int __io_buffer_register_bvec(struct io_ring_=
ctx *ctx,
>         return 0;
>  }
>
> -int io_buffer_register_bvec(struct io_uring_cmd *cmd,
> -                           struct io_buf_data *buf,
> -                           unsigned int issue_flags)
> -{
> -       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> -       int ret;
> -
> -       io_ring_submit_lock(ctx, issue_flags);
> -       ret =3D __io_buffer_register_bvec(ctx, buf);
> -       io_ring_submit_unlock(ctx, issue_flags);
> -
> -       return ret;
> -}
> -EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
> -
>  static int __io_buffer_unregister_bvec(struct io_ring_ctx *ctx,
>                                        struct io_buf_data *buf)
>  {
> @@ -1006,19 +991,77 @@ static int __io_buffer_unregister_bvec(struct io_r=
ing_ctx *ctx,
>         return 0;
>  }
>
> -int io_buffer_unregister_bvec(struct io_uring_cmd *cmd,
> -                             struct io_buf_data *buf,
> -                             unsigned int issue_flags)
> +static inline int do_reg_unreg_bvec(struct io_ring_ctx *ctx,
> +                                   struct io_buf_data *buf,
> +                                   unsigned int issue_flags,
> +                                   bool reg)
>  {
> -       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
>         int ret;
>
>         io_ring_submit_lock(ctx, issue_flags);
> -       ret =3D __io_buffer_unregister_bvec(ctx, buf);
> +       if (reg)
> +               ret =3D __io_buffer_register_bvec(ctx, buf);
> +       else
> +               ret =3D __io_buffer_unregister_bvec(ctx, buf);

It feels like unifying __io_buffer_register_bvec() and
__io_buffer_unregister_bvec() would belong better in the prior patch
that changes their signatures.

>         io_ring_submit_unlock(ctx, issue_flags);
>
>         return ret;
>  }
> +
> +static int io_buffer_reg_unreg_bvec(struct io_ring_ctx *ctx,
> +                                   struct io_buf_data *buf,
> +                                   unsigned int issue_flags,
> +                                   bool reg)
> +{
> +       struct io_ring_ctx *remote_ctx =3D ctx;
> +       struct file *file =3D NULL;
> +       int ret;
> +
> +       if (buf->has_fd) {
> +               file =3D io_uring_register_get_file(buf->ring_fd, buf->re=
gistered_fd);
> +               if (IS_ERR(file))
> +                       return PTR_ERR(file);

It would be good to avoid the overhead of this lookup and
reference-counting in the I/O path. Would it be possible to move this
lookup to when UBLK_IO_FETCH_REQ (and UBLK_IO_COMMIT_AND_FETCH_REQ, if
it specifies a different ring_fd) is submitted? I guess that might
require storing an extra io_ring_ctx pointer in struct ublk_io.

> +               remote_ctx =3D file->private_data;
> +               if (!remote_ctx)
> +                       return -EINVAL;
> +       }
> +
> +       if (remote_ctx =3D=3D ctx) {
> +               do_reg_unreg_bvec(ctx, buf, issue_flags, reg);
> +       } else {
> +               if (!(issue_flags & IO_URING_F_UNLOCKED))
> +                       mutex_unlock(&ctx->uring_lock);
> +
> +               do_reg_unreg_bvec(remote_ctx, buf, IO_URING_F_UNLOCKED, r=
eg);
> +
> +               if (!(issue_flags & IO_URING_F_UNLOCKED))
> +                       mutex_lock(&ctx->uring_lock);
> +       }
> +
> +       if (file)
> +               fput(file);
> +
> +       return ret;
> +}
> +
> +int io_buffer_register_bvec(struct io_uring_cmd *cmd,
> +                           struct io_buf_data *buf,
> +                           unsigned int issue_flags)

If buf->has_fd is set, this struct io_uring_cmd *cmd is unused. Could
you define separate functions that take a struct io_uring_cmd * vs. a
ring_fd?

Best,
Caleb


> +{
> +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> +
> +       return io_buffer_reg_unreg_bvec(ctx, buf, issue_flags, true);
> +}
> +EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
> +
> +int io_buffer_unregister_bvec(struct io_uring_cmd *cmd,
> +                             struct io_buf_data *buf,
> +                             unsigned int issue_flags)
> +{
> +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> +
> +       return io_buffer_reg_unreg_bvec(ctx, buf, issue_flags, false);
> +}
>  EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
>
>  static int validate_fixed_range(u64 buf_addr, size_t len,
> --
> 2.47.0
>

