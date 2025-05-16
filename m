Return-Path: <io-uring+bounces-8018-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99738ABA64B
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 01:11:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A13F501289
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 23:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4285528540A;
	Fri, 16 May 2025 23:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="MP9Blp5e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F152A285412
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 23:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747436879; cv=none; b=UDmazKw4RBWBKyfrKe5VL3rkNkTuyr/ssgIj/SbDVS61nYZe2CuqD9kkVlbeAvPD+0vI/XvQfcJwyEP/Zs+3RmOFpxraq0+w1pbrHOcyZNXbX3dC+klGiDbXpkY9u/DNvqhz2ahBBg3OXbMVDwVrdApP7+6pt/9S361i5YjNEW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747436879; c=relaxed/simple;
	bh=4AovkvgVJPLRCf4t9Dn9rGoDTar05105FGRbPiNFTtI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d2Qxq6AP0mL6kLULCYkUGyTuGsGrEYuJeHGEbl1E4avC9BaJPw0P5JIPYs5sGIbVXn0mz5mhex4Ev7VKDd+tnz+QPQ2GsTsobd/lw4ma5I/IYzVUvF5OoSQ5Rc4rMqjAxpvmLjaCGknNd35ywmhXCo+703b0tY4eJxKnxWY5UD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=MP9Blp5e; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3032a9c7cfeso317151a91.1
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747436876; x=1748041676; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fz/YU2uCx9huTBMRjOhgitxBPAoZqkxbuvyCTu8Z/uU=;
        b=MP9Blp5et0JnMkRDuJooxqLjxbdLU0E6/Om7R1MnniObydehOHawP5XFNZLAMCa6D/
         W0nudcTkmMM5GCBSHOzX4WBJKL5+KixI1jb58s5zKNDSYUnOFucxE9p7VoFp3pzV4+cx
         MMeolsDGq3IY/GA3AYxwu3VPTdQH7H9FBPGsFQ8gFRuR6usGeV8Xm2RUBgTo4w12ZwMK
         RAvIzGm+ZmlobWMNR+ADWkm3JdAVNbrCit2Y2QNNGYuJaLurQ0W6zPq8RCJfSugWQkHg
         P4eMWPnnl4PrYyvRGf7hzqv6kIjIZYA25gMQB9SZ4dHbyvIjNI+CMVt48Q1nt82HOqkY
         +xog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747436876; x=1748041676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fz/YU2uCx9huTBMRjOhgitxBPAoZqkxbuvyCTu8Z/uU=;
        b=R63XJHj6tBObM1t2gywTNgpScDa05WP/Az4MopndKzkrJAZKU460mPneVqly4028sw
         B0/vl2rELe2QTNUWpwsupQqnV+nVFCP9kcDbCVlAXMk9EZCtE72Kk533JdmEJfUq0ARZ
         VneEisdWLjfj1Xz8hwgGal3TRt5KZ4OqdVwJYLMubEltG1WYxZU6is75eNzdI92mgnyR
         n1c7/5QczRdcCzIBtHBfe9702XU0kzU1O91/Mzm0HU5HFZ0/anwbN/D+zhX9/PpUVoQy
         yOuhrp0LR8LUx8+1ll1D2p8LqzpDs/Ebs6auOJSJs+YDm8BsGkYce4F2PMHt0Ib/Ay9h
         wXRQ==
X-Gm-Message-State: AOJu0YwjZuf7SMA9il9TD8yJ0WndKR2P2xud7jR3H2rkuKnPmwKuvVDE
	IyHGmMv7w4Md4YqNi0fUjPuV380eqGG1QxVQec2kh6Y6Y+RlLr5XbCLKn+hzL+dmR0n+/AoMICL
	qr5b0jOtfZJ/yb2OM4wxs63tBBeL8idsmqOsoLlaZKA==
X-Gm-Gg: ASbGnctQBgA+DC0YjeH5imvgrtwsvWHDfndc61fwaTMRF3v2X/7LtHAwcghy77KBNkr
	yrCcsEUSRUaq9kfq7/na0CwzBziRGzAfPELZ/QqDYGHPWWMQWCu1YDVSNRQEnbHufOnA3vgg8Wc
	u+7mffasfeUx/5Rs8UYFkGbpSVgdoE1Xw=
X-Google-Smtp-Source: AGHT+IFdqC0H33VHkk9rUBrAtCwfUgTdbIOuFwr4zPSAusFq8r9UguE1XfjZQVr/qXYU6WZYn1d5KyTBUhJFIANyjVY=
X-Received: by 2002:a17:902:fc48:b0:224:88c:9255 with SMTP id
 d9443c01a7336-231d438c7f1mr25921505ad.3.1747436876147; Fri, 16 May 2025
 16:07:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250516201007.482667-1-axboe@kernel.dk> <20250516201007.482667-4-axboe@kernel.dk>
In-Reply-To: <20250516201007.482667-4-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 16 May 2025 16:07:45 -0700
X-Gm-Features: AX0GCFtJCXicTNc-p0CJZCk4F9QPEL21aNmIrWFtEqzUewSupypDO7LQeR54Dqo
Message-ID: <CADUfDZqueYi3XNc3RjXfURwsDgbNgp6pwa8eOReKKv0h+g+RCg@mail.gmail.com>
Subject: Re: [PATCH 3/5] io_uring: make io_alloc_ocqe() take a struct io_cqe pointer
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2025 at 1:10=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> The number of arguments to io_alloc_ocqe() is a bit unwieldy. Make it
> take a struct io_cqe pointer rather than three sepearate CQE args. One

typo: "separate"

> path already has that readily available, add an io_init_cqe() helper for
> the remainding two.

typo: "remaining"

>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/io_uring.c | 24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index b564a1bdc068..b50c2d434e74 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -724,8 +724,8 @@ static bool io_cqring_add_overflow(struct io_ring_ctx=
 *ctx,
>  }
>
>  static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
> -                                            u64 user_data, s32 res, u32 =
cflags,
> -                                            u64 extra1, u64 extra2, gfp_=
t gfp)
> +                                            struct io_cqe *cqe, u64 extr=
a1,
> +                                            u64 extra2, gfp_t gfp)
>  {
>         struct io_overflow_cqe *ocqe;
>         size_t ocq_size =3D sizeof(struct io_overflow_cqe);
> @@ -735,11 +735,11 @@ static struct io_overflow_cqe *io_alloc_ocqe(struct=
 io_ring_ctx *ctx,
>                 ocq_size +=3D sizeof(struct io_uring_cqe);
>
>         ocqe =3D kmalloc(ocq_size, gfp | __GFP_ACCOUNT);
> -       trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
> +       trace_io_uring_cqe_overflow(ctx, cqe->user_data, cqe->res, cqe->f=
lags, ocqe);
>         if (ocqe) {
> -               ocqe->cqe.user_data =3D user_data;
> -               ocqe->cqe.res =3D res;
> -               ocqe->cqe.flags =3D cflags;
> +               ocqe->cqe.user_data =3D cqe->user_data;
> +               ocqe->cqe.res =3D cqe->res;
> +               ocqe->cqe.flags =3D cqe->flags;
>                 if (is_cqe32) {
>                         ocqe->cqe.big_cqe[0] =3D extra1;
>                         ocqe->cqe.big_cqe[1] =3D extra2;
> @@ -806,6 +806,9 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, =
u64 user_data, s32 res,
>         return false;
>  }
>
> +#define io_init_cqe(user_data, res, cflags)    \
> +       (struct io_cqe) { .user_data =3D user_data, .res =3D res, .flags =
=3D cflags }

The arguments and result should be parenthesized to prevent unexpected
groupings. Better yet, make this a static inline function.

> +
>  bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags)
>  {
>         bool filled;
> @@ -814,8 +817,9 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 use=
r_data, s32 res, u32 cflags
>         filled =3D io_fill_cqe_aux(ctx, user_data, res, cflags);
>         if (unlikely(!filled)) {
>                 struct io_overflow_cqe *ocqe;
> +               struct io_cqe cqe =3D io_init_cqe(user_data, res, cflags)=
;
>
> -               ocqe =3D io_alloc_ocqe(ctx, user_data, res, cflags, 0, 0,=
 GFP_ATOMIC);
> +               ocqe =3D io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_ATOMIC);
>                 filled =3D io_cqring_add_overflow(ctx, ocqe);
>         }
>         io_cq_unlock_post(ctx);
> @@ -833,8 +837,9 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user=
_data, s32 res, u32 cflags)
>
>         if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
>                 struct io_overflow_cqe *ocqe;
> +               struct io_cqe cqe =3D io_init_cqe(user_data, res, cflags)=
;
>
> -               ocqe =3D io_alloc_ocqe(ctx, user_data, res, cflags, 0, 0,=
 GFP_KERNEL);
> +               ocqe =3D io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_KERNEL);
>                 spin_lock(&ctx->completion_lock);
>                 io_cqring_add_overflow(ctx, ocqe);
>                 spin_unlock(&ctx->completion_lock);
> @@ -1444,8 +1449,7 @@ void __io_submit_flush_completions(struct io_ring_c=
tx *ctx)
>                         gfp_t gfp =3D ctx->lockless_cq ? GFP_KERNEL : GFP=
_ATOMIC;
>                         struct io_overflow_cqe *ocqe;
>
> -                       ocqe =3D io_alloc_ocqe(ctx, req->cqe.user_data, r=
eq->cqe.res,
> -                                            req->cqe.flags, req->big_cqe=
.extra1,
> +                       ocqe =3D io_alloc_ocqe(ctx, &req->cqe, req->big_c=
qe.extra1,
>                                              req->big_cqe.extra2, gfp);

If the req->big_cqe type were named, these 2 arguments could be
combined into just &req->big_cqe.

Best,
Caleb

>                         if (ctx->lockless_cq) {
>                                 spin_lock(&ctx->completion_lock);
> --
> 2.49.0
>

