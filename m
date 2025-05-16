Return-Path: <io-uring+bounces-7992-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A740ABA0CD
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:32:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA8FC1B63235
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 16:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC6E486359;
	Fri, 16 May 2025 16:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="gtEwSkqX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D6F23CB
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747413125; cv=none; b=rxvx919IXlvvZ4tRgR8dybLxeDNI4y9NO6XAzjKuS0/J4Yzfzd3aqyXlmST3I0dtv5I/1klcxtICJh1c65HG2jNV6V7WqjippnbS9yMrh+aWjnTwshRFf5o4VXWvG1aDv7rQ5mR9f9J8iDoXKOkGuIhGUShgdsAEbrPdqPEmu4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747413125; c=relaxed/simple;
	bh=2tZVk+/H38Kno0UzH6W9stqUeicLXDZ2OU9N411r/+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VbzWmOsuf15wNHVIbdbtTD9wIrDAYQ0Ik38Ek3kJ54zCWphQxXp8DxArv3kXJnjjJv18GAAdQM7LrkWK3pR9+JopUoVhJ/jglu9VKswnzsjtHzNyuWpe0M0eJ1p2m42MBNfl8FZShy7PfgsyifvfuHNMlkFbnn4txgmVtgw80fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=gtEwSkqX; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7390294782bso350964b3a.0
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 09:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747413123; x=1748017923; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bMOGjCWLaXmvFhLy6tBaf8boVTlgnV0/L7LIMGViQQk=;
        b=gtEwSkqXhEQ4ubC9eJu6WLOPXI6s0UyjZvlL0IXNanuJWZIlbpAxPjoI1PJ+zyBYH3
         IPx7Lw6kP7toDZClVi2uloHwPFG3o7JFL6JxLM/XyokKvHaYORuSPAZh03zr9QOHJG1c
         2B9EZ5DmMJElZJLyrc8Tp3S/tMNC+FQcevVKWBI19dmlC1mRDcg3n0TXQOza3o/pNpSt
         zjYleNsvQt4ClgqM2EqWZA+X5Fyb2wlhbRbmg31qom/gUd0ossY6OFnFAJUkEOzvYUD0
         DpUOkvg4GB6++Pwx3I/eEPxbG0L4luAlkrOWfSRRD19ueZNw0FK3yNZpcKFDToIgNhR+
         smXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747413123; x=1748017923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bMOGjCWLaXmvFhLy6tBaf8boVTlgnV0/L7LIMGViQQk=;
        b=qT4LAik/iI6COYjfdzCmDQn3wdWTUOs66x4Q5DAGaeoY7QsopHDKVu4OIitOkewkFJ
         RjLE1gtB3s8Tc9oIxGP90vdfWNLVh10z8L7491T2fEPCG1v691V1PK42Fs/OykXa0hta
         R2nKgbpOMxpycYqPUAk4iQtVrt6vktxy6DGU81SX/pdI1ltuf17Ymz6jYtkQ8TZGUVz9
         DF67mJgS79DD9ALAVCgpOfTjDLZ4RgUt1QWUXCUjpIwQfRu7wd38ZnsqWHR1JgzgcRkj
         Ga1WBVdnakf3wSjINrGuoWFrxbGMg/Y+Y4+rODA00opgE3VH9i756dbV7pEAIQnA4N8B
         xKKg==
X-Gm-Message-State: AOJu0Yz17yJY/HUo+nfWXZbBcCUptgI2XCsHLeBQs+21T0ZPGyHvTi76
	rQB3Z42LxIQZrMxcRruRaEDLLbt9nAxzOSi8bEsFpyJ/6iwmHE7huEFAeEAbx0gz/A0fD6szy06
	ZGPRbUoO91U4zGTca8CwAF3pPYSoKNBcXG5V0+rczbw==
X-Gm-Gg: ASbGncvEPnul+wq+UlCT2VjnUNwpLJrueX6Pr+jdpcyvr0h42Bcnci79b/0Vpo5xqM3
	6qPrTs1pG6ytQBwBRKctIidmIiG0qOI/l5Sei1yGZCpRHPQSOicPyG7k1IL7rAXn91mn4pj2bNJ
	As1YPOim4x2vBxfNafKw0GtRgqkNWW1uk=
X-Google-Smtp-Source: AGHT+IE40e+OnC0fyRQv8B7fPs0ghW0snXMZbmMNfVtt+k7XpT6YfEp4KPU+WWtSkK8+rUy/x0bqAoXTgyMlkAA/eWY=
X-Received: by 2002:a17:903:32c1:b0:231:7fbc:19c9 with SMTP id
 d9443c01a7336-231d438c956mr18406055ad.1.1747413122688; Fri, 16 May 2025
 09:32:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250516161452.395927-1-axboe@kernel.dk> <20250516161452.395927-2-axboe@kernel.dk>
In-Reply-To: <20250516161452.395927-2-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 16 May 2025 09:31:51 -0700
X-Gm-Features: AX0GCFsJ_KFMJ7IRy0kEToFYVfPQWDQSQ82D8jJYMCwu--Q6XJA1bp7TQ4XYJOE
Message-ID: <CADUfDZrp-Qq93g5uZn4_=amFhzF=j2Yk0MqJ5zqi_qYC4ZdhUQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring: split alloc and add of overflow
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2025 at 9:15=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> Add a new helper, io_alloc_ocqe(), that simply allocates and fills an
> overflow entry. Then it can get done outside of the locking section,
> and hence use more appropriate gfp_t allocation flags rather than always
> default to GFP_ATOMIC.
>
> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/io_uring.c | 75 +++++++++++++++++++++++++++++----------------
>  1 file changed, 48 insertions(+), 27 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 9a9b8d35349b..2519fab303c4 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -718,20 +718,11 @@ static __cold void io_uring_drop_tctx_refs(struct t=
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
> @@ -749,22 +740,44 @@ static bool io_cqring_event_overflow(struct io_ring=
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
> -static void io_req_cqe_overflow(struct io_kiocb *req)
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
> +static void io_req_cqe_overflow(struct io_kiocb *req, gfp_t gfp)
>  {
> -       io_cqring_event_overflow(req->ctx, req->cqe.user_data,
> -                               req->cqe.res, req->cqe.flags,
> -                               req->big_cqe.extra1, req->big_cqe.extra2)=
;
> +       struct io_ring_ctx *ctx =3D req->ctx;
> +       struct io_overflow_cqe *ocqe;
> +
> +       ocqe =3D io_alloc_ocqe(ctx, req->cqe.user_data, req->cqe.res,
> +                            req->cqe.flags, req->big_cqe.extra1,
> +                            req->big_cqe.extra2, gfp);
> +       io_cqring_add_overflow(ctx, ocqe);
>         memset(&req->big_cqe, 0, sizeof(req->big_cqe));
>  }
>
> @@ -832,8 +845,12 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 us=
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
> @@ -848,8 +865,11 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 use=
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
> @@ -1442,10 +1462,11 @@ void __io_submit_flush_completions(struct io_ring=
_ctx *ctx)
>                     unlikely(!io_fill_cqe_req(ctx, req))) {
>                         if (ctx->lockless_cq) {
>                                 spin_lock(&ctx->completion_lock);
> -                               io_req_cqe_overflow(req);
> +                               io_req_cqe_overflow(req, GFP_ATOMIC);
>                                 spin_unlock(&ctx->completion_lock);
>                         } else {
> -                               io_req_cqe_overflow(req);
> +                               gfp_t gfp =3D ctx->lockless_cq ? GFP_KERN=
EL : GFP_ATOMIC;

This is in the else case of an if (ctx->lockless_cq). Isn't
ctx->lockless_cq known to be false?

Best,
Caleb

> +                               io_req_cqe_overflow(req, gfp);
>                         }
>                 }
>         }
> --
> 2.49.0
>
>

