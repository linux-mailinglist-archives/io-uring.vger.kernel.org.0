Return-Path: <io-uring+bounces-8044-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D981ABACDB
	for <lists+io-uring@lfdr.de>; Sun, 18 May 2025 01:30:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B72B3BD23A
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 23:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9682E15B102;
	Sat, 17 May 2025 23:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Oqhsp5Up"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8386D4CB5B
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 23:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747524647; cv=none; b=QoodNA0wzAE3XmOQne8AIjXrWZoGM05+BwlaPWc4exp7pdyD0aSm+Faflbs+n4y7qXexKiH67EJu9zwFjThDXtwjqxvoEjUrAqE1uNp9YRRvFBpAtSACdZIh7beoY40j1GcDm8jtZ0JbER8m0xq7pLmervl0JwpAKFQPyVNA8Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747524647; c=relaxed/simple;
	bh=nVrDUwA395K4nihG0xI+0zZREE4ZrrMy2JKucumY57E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o0yfDrsnFDD/OHq6nGhStWzwZYN0s8MxbGZ6eVYGYaUv1hIlGfMuG1S2L493K9eTkKrF3ABraC/N4UJzXIntjwPc3hZSzMTpnevHSfkGDxV1WNlF9ccMLkvC77uxi9RcKIIvfKRlCHPBOBRXT4TUSEANjFi/m3uiu4CDNeaaHO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Oqhsp5Up; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-30e7d9e9a47so326536a91.3
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 16:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747524645; x=1748129445; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rp4Fs1I1ofcD/mdZPJcBoSOhHjcMbXJPwDrSp+qP2qY=;
        b=Oqhsp5UpiKp4JKKIv6mVAthK54vkF7FmynpW6rAdXO/FimCIxLOVuqbhXqo/lNgzNP
         yuAwZqPyqdMRnZOWWOmE9L/9HaAdO1hiJvP80taJw0C/P29OEOJ2LklkJZ4ici4ZBuxo
         elAFh+x6+hREDIEv74NlelwTpiYKfnb+ATQjg84v2t+DQtEDgXyDrLDpGWg4eltNBxRh
         R+f8CqOU3Hw8tGAsLPfbwF0NWjiF5Fc6j2K98GaJBCHBud8bEPdCWMXUqYOSbS/qNVqz
         VBIJrJIqJOAsoecFgaL1zVU9zVPpjjSIHXH8M18Dgd+nJaF+rQMTPEHRUvPVK0Mvw+ZZ
         YkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747524645; x=1748129445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rp4Fs1I1ofcD/mdZPJcBoSOhHjcMbXJPwDrSp+qP2qY=;
        b=fxmbP3QDm1V/xByUWNIq9PBQCtvEvyZcJVFdLBsGkOqvkcfFpAqTzZBID3tyc52/kq
         xJk4joH7GRWK4dUEAuJRJehEYJSasAT/2OwQ+15sZHNFExuWTuJpwuhDWwhTGgWppgiE
         WaaRNmR+8SUkpC2G8I5PDN1O535chJJ8wyPTWQLrvnJ7WsNUIcU4mEbU4oNKKokLxoA8
         uDluZE5xmZM2KoAZCBkOzppthgkYgn2TQ/o5Go7sYqSXiYawOyXfwkABVAjNIfhNDahh
         yJGUj6O7PxuxXAxI+iYVG02doBKqVtfcqNRxXs2bXMe9U7BvtNZ8UaOQD8emAbCD9aiR
         oPCg==
X-Gm-Message-State: AOJu0YytkG9jpIDGmbqTbXFo1kmXxpZLiJTNXEi8CaDCj2gHAZSdJI5c
	Cz61jwrCEsqaCerVTgx0bKEEqc+A4b+EfprCW9gsxbdR0IphHVT14A+8+afkbonqhqdfNHG71we
	u8lbGJjLwkhrONovz/WFrnEG0F8sFqiK3yHzKQIIEcA==
X-Gm-Gg: ASbGncuk8gvaq4s8omWtPQj4dxrhq0Ats8dV+CpswQWBLyy+rju4a8rhqQ7rOcPFX2W
	4+8Ps6YbP39Ie24Y7gtcixwUeL++qD/oyMktZMs7/XecZwh4+MHbyTQoUy4m2Xs6NpPiTHS7G47
	vDsCSsYSsdj/M8X0PJZ/QHd8r03CvD0eA=
X-Google-Smtp-Source: AGHT+IGNQvMtBCbkE7G5iiSSojDt/FZfsWZD9QaJI5lIQOklm2x7MLcZTnV9TXsi59JY+aVDXAhYfqps0eoQW3MnwJs=
X-Received: by 2002:a17:902:e80c:b0:224:216e:38bd with SMTP id
 d9443c01a7336-231d43b7fb7mr42519825ad.5.1747524644718; Sat, 17 May 2025
 16:30:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250517114938.533378-1-axboe@kernel.dk> <20250517114938.533378-3-axboe@kernel.dk>
In-Reply-To: <20250517114938.533378-3-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Sat, 17 May 2025 16:30:33 -0700
X-Gm-Features: AX0GCFvYCgd11P_d80g5ONJU_QS1lizKHo0TlYpv038NmAkEZF6dZILPVfQCvyM
Message-ID: <CADUfDZqC5M8vH0PJ9Pqc-oesznP=OX0BN2sK9DdosHGhmV-VYg@mail.gmail.com>
Subject: Re: [PATCH 2/5] io_uring: split alloc and add of overflow
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 17, 2025 at 4:49=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> Add a new helper, io_alloc_ocqe(), that simply allocates and fills an
> overflow entry. Then it can get done outside of the locking section,
> and hence use more appropriate gfp_t allocation flags rather than always
> default to GFP_ATOMIC.
>
> Inspired by a previous series from Pavel:
>
> https://lore.kernel.org/io-uring/cover.1747209332.git.asml.silence@gmail.=
com/
>
> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/io_uring.c | 75 +++++++++++++++++++++++++++------------------
>  1 file changed, 45 insertions(+), 30 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index e4d6e572eabc..b564a1bdc068 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -697,20 +697,11 @@ static __cold void io_uring_drop_tctx_refs(struct t=
ask_struct *task)
>         }
>  }
>
> -static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_d=
ata,
> -                                    s32 res, u32 cflags, u64 extra1, u64=
 extra2)
> +static bool io_cqring_add_overflow(struct io_ring_ctx *ctx,
> +                                  struct io_overflow_cqe *ocqe)
>  {
> -       struct io_overflow_cqe *ocqe;
> -       size_t ocq_size =3D sizeof(struct io_overflow_cqe);
> -       bool is_cqe32 =3D (ctx->flags & IORING_SETUP_CQE32);
> -
>         lockdep_assert_held(&ctx->completion_lock);
>
> -       if (is_cqe32)
> -               ocq_size +=3D sizeof(struct io_uring_cqe);
> -
> -       ocqe =3D kmalloc(ocq_size, GFP_ATOMIC | __GFP_ACCOUNT);
> -       trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
>         if (!ocqe) {
>                 struct io_rings *r =3D ctx->rings;
>
> @@ -728,17 +719,35 @@ static bool io_cqring_event_overflow(struct io_ring=
_ctx *ctx, u64 user_data,
>                 atomic_or(IORING_SQ_CQ_OVERFLOW, &ctx->rings->sq_flags);
>
>         }
> -       ocqe->cqe.user_data =3D user_data;
> -       ocqe->cqe.res =3D res;
> -       ocqe->cqe.flags =3D cflags;
> -       if (is_cqe32) {
> -               ocqe->cqe.big_cqe[0] =3D extra1;
> -               ocqe->cqe.big_cqe[1] =3D extra2;
> -       }
>         list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
>         return true;
>  }
>
> +static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
> +                                            u64 user_data, s32 res, u32 =
cflags,
> +                                            u64 extra1, u64 extra2, gfp_=
t gfp)
> +{
> +       struct io_overflow_cqe *ocqe;
> +       size_t ocq_size =3D sizeof(struct io_overflow_cqe);
> +       bool is_cqe32 =3D (ctx->flags & IORING_SETUP_CQE32);
> +
> +       if (is_cqe32)
> +               ocq_size +=3D sizeof(struct io_uring_cqe);
> +
> +       ocqe =3D kmalloc(ocq_size, gfp | __GFP_ACCOUNT);
> +       trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
> +       if (ocqe) {
> +               ocqe->cqe.user_data =3D user_data;
> +               ocqe->cqe.res =3D res;
> +               ocqe->cqe.flags =3D cflags;
> +               if (is_cqe32) {
> +                       ocqe->cqe.big_cqe[0] =3D extra1;
> +                       ocqe->cqe.big_cqe[1] =3D extra2;
> +               }
> +       }
> +       return ocqe;
> +}
> +
>  /*
>   * writes to the cq entry need to come after reading head; the
>   * control dependency is enough as we're using WRITE_ONCE to
> @@ -803,8 +812,12 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 us=
er_data, s32 res, u32 cflags
>
>         io_cq_lock(ctx);
>         filled =3D io_fill_cqe_aux(ctx, user_data, res, cflags);
> -       if (!filled)
> -               filled =3D io_cqring_event_overflow(ctx, user_data, res, =
cflags, 0, 0);
> +       if (unlikely(!filled)) {
> +               struct io_overflow_cqe *ocqe;
> +
> +               ocqe =3D io_alloc_ocqe(ctx, user_data, res, cflags, 0, 0,=
 GFP_ATOMIC);
> +               filled =3D io_cqring_add_overflow(ctx, ocqe);
> +       }
>         io_cq_unlock_post(ctx);
>         return filled;
>  }
> @@ -819,8 +832,11 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 use=
r_data, s32 res, u32 cflags)
>         lockdep_assert(ctx->lockless_cq);
>
>         if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
> +               struct io_overflow_cqe *ocqe;
> +
> +               ocqe =3D io_alloc_ocqe(ctx, user_data, res, cflags, 0, 0,=
 GFP_KERNEL);
>                 spin_lock(&ctx->completion_lock);
> -               io_cqring_event_overflow(ctx, user_data, res, cflags, 0, =
0);
> +               io_cqring_add_overflow(ctx, ocqe);
>                 spin_unlock(&ctx->completion_lock);
>         }
>         ctx->submit_state.cq_flush =3D true;
> @@ -1425,20 +1441,19 @@ void __io_submit_flush_completions(struct io_ring=
_ctx *ctx)
>                  */
>                 if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
>                     unlikely(!io_fill_cqe_req(ctx, req))) {
> +                       gfp_t gfp =3D ctx->lockless_cq ? GFP_KERNEL : GFP=
_ATOMIC;
> +                       struct io_overflow_cqe *ocqe;
> +
> +                       ocqe =3D io_alloc_ocqe(ctx, req->cqe.user_data, r=
eq->cqe.res,
> +                                            req->cqe.flags, req->big_cqe=
.extra1,
> +                                            req->big_cqe.extra2, gfp);
>                         if (ctx->lockless_cq) {
>                                 spin_lock(&ctx->completion_lock);
> -                               io_cqring_event_overflow(req->ctx, req->c=
qe.user_data,
> -                                                       req->cqe.res, req=
->cqe.flags,
> -                                                       req->big_cqe.extr=
a1,
> -                                                       req->big_cqe.extr=
a2);
> +                               io_cqring_add_overflow(ctx, ocqe);
>                                 spin_unlock(&ctx->completion_lock);
>                         } else {
> -                               io_cqring_event_overflow(req->ctx, req->c=
qe.user_data,
> -                                                       req->cqe.res, req=
->cqe.flags,
> -                                                       req->big_cqe.extr=
a1,
> -                                                       req->big_cqe.extr=
a2);
> +                               io_cqring_add_overflow(ctx, ocqe);
>                         }
> -
>                         memset(&req->big_cqe, 0, sizeof(req->big_cqe));

Stray whitespace change. Either drop it or move it to the previous
patch which added the blank line?

Best,
Caleb

