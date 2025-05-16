Return-Path: <io-uring+bounces-8021-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13AF9ABA667
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 01:17:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED30DA205A2
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 23:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A09723504D;
	Fri, 16 May 2025 23:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="IhcwewJL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EFD8488
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 23:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747437439; cv=none; b=JVHwf2H2Sa114cynEQB2riyxhYecN0Epo1LFomAXuxhiHUcASBkC4SH4rBt6KdmoWZkE6Er3Bep8FZwspxLWz13g+wTGtXqEMnQfD7FV1fEmqJAdiVs4vAVQs8XbmgBsaLPbRvzkVSEaTNNY+Zhm+oo+YfVqHYt9U7JuMswNv0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747437439; c=relaxed/simple;
	bh=W9NffHh+XC9HZVA7BVfCwJbDcSj5Fc5xPQdPIZhMA6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K/NHtDvGSsPsGzQctZg8EJYTVcQX64hS8qOtEh+JcH0CZ+dA5/0G4glYRCsIySNSla//hPFDe4T5uTY97Ev1P2emyaP0gllaYXk85+4WEyOrAXxiwV8gwfdNLoSj8tANj7+wDo14vx7SU55ljD57or7OLnZljackqcGSO82u6xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=IhcwewJL; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-30c5a5839e3so573982a91.1
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747437437; x=1748042237; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yLwyZT3/gOXXhjd5Xg+FhRj6xA3l9UMbaSCGYBON2Eo=;
        b=IhcwewJLftYysDvtmNIhdMkc+k+Q5Mn2iZ4yEDMcfpS+FowkRNtmHVlmsWXyQw2Gin
         PBTLq/JSzvky3ssv9J5uQklXgkr+lVmhSfovAGk5dFJmpRnICFDdRJ2AnH4M8nyszRMC
         SoEq1akhiggC1Rp5vWRP8pNuyMtwiTpaZZko/4YNLJUItAtYAcqGO9SggZc5W+v+9XYa
         b8hNLdcG7gPjtqj5PwZK6U7aOmX9hqArisruO74ElZrwM2idaNycxSbKSG0HgH3PpM16
         iYq9Er1JaoSoTc5PVEGj72bU+tFegzPYM3Vs7lnYJYblD5l7/Ot541xQv2MF+KFUewk1
         hsCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747437437; x=1748042237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yLwyZT3/gOXXhjd5Xg+FhRj6xA3l9UMbaSCGYBON2Eo=;
        b=onKrbeCYUonfg/KuxeHJt6ok4MHixBcLhTsS3PfZpr594yWCQixzTKNx2vt+AJ22LQ
         81VtXS67/LV//3OSzERhg3YaOwinvm0XkOI1HO4wO1I5AZ5PO4bQc7parDrb25/SaZ9l
         OGNoDmUXVjD9L6E//KCx1dO9mTfOwGsJSfVzshJFTwdDWSZvkC6rzLpM8uk+VGiJ8Tkd
         4vH+Rn78X57t5Im55Hz5Yt5zWIH3+6gMY5DVIeYweFkiV90hoajlQQ4GvZR5xP+fbX6X
         n9aVhmRdt+P5/Or5cA83P2iFyzOlO+DOT9ZINYZATVQ3GAwhoqpGh7icN9eCc8zTAqAa
         SujQ==
X-Gm-Message-State: AOJu0YxjVp7lUeNJ1oJDwoB7UyDl93n0PFWFno/by3soD/MQSe0Cu0pW
	9DfqsEB4nrNIe+yLge/ycILSAPxR3BGPrfTnp3p4UlccJghuC8mZ2t+ovfnHYqJElq/LgQUaxvA
	s6DbQFbnsEi43k8/4SQEYY8mdXokztke2E6EMFaidbfpdeTOLPjMvOjow0Q==
X-Gm-Gg: ASbGnct1ZcehHf3xyk+OJtGC2PqAZuoKlTYXQbQMoHJYq1NyzHmurs9vekLGmXyRrvb
	f0YaBjKKXAJejc94N+mIa+A1Lh2izx+GOuz0ubhWgBo2EAMLgs34bMKC5EUrW7kQXzvXUuJplkW
	7coScdjBGLhRcBvm41fhDU4bFW+Y6DKGY=
X-Google-Smtp-Source: AGHT+IHZG3jwqOFVeb85MVvu/RK9Iy2yci4as06V0whBKAu8GxG3Trr45gNySaetMvnSPpAnm6+KtDDYl5g11Gui3bM=
X-Received: by 2002:a17:903:24e:b0:22e:62da:2e58 with SMTP id
 d9443c01a7336-231d4526b5fmr26645085ad.10.1747437436756; Fri, 16 May 2025
 16:17:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250516201007.482667-1-axboe@kernel.dk> <20250516201007.482667-6-axboe@kernel.dk>
In-Reply-To: <20250516201007.482667-6-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 16 May 2025 16:17:05 -0700
X-Gm-Features: AX0GCFvS6fsH-2NYeuhWE8tMnPyKEqwz8SdSkT3e7H-bDqI6TiKJsfU7k545OS0
Message-ID: <CADUfDZq19zOMkX2ZnaAuftb=jCGXRfje+UNu9xmR3gnGBSACMA@mail.gmail.com>
Subject: Re: [PATCH 5/5] io_uring: add new helpers for posting overflows
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2025 at 1:10=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Add two helpers, one for posting overflows for lockless_cq rings, and
> one for non-lockless_cq rings. The former can allocate sanely with
> GFP_KERNEL, but needs to grab the completion lock for posting, while the
> latter must do non-sleeping allocs as it already holds the completion
> lock.
>
> While at it, mark the overflow handling functions as __cold as well, as
> they should not generally be called during normal operations of the
> ring.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/io_uring.c | 50 ++++++++++++++++++++++++++-------------------
>  1 file changed, 29 insertions(+), 21 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index c66fc4b7356b..52087b079a0c 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -697,8 +697,8 @@ static __cold void io_uring_drop_tctx_refs(struct tas=
k_struct *task)
>         }
>  }
>
> -static bool io_cqring_add_overflow(struct io_ring_ctx *ctx,
> -                                  struct io_overflow_cqe *ocqe)
> +static __cold bool io_cqring_add_overflow(struct io_ring_ctx *ctx,
> +                                         struct io_overflow_cqe *ocqe)
>  {
>         lockdep_assert_held(&ctx->completion_lock);
>
> @@ -808,6 +808,27 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx,=
 u64 user_data, s32 res,
>         return false;
>  }
>
> +static __cold void io_cqe_overflow_lockless(struct io_ring_ctx *ctx,
> +                                           struct io_cqe *cqe,
> +                                           struct io_big_cqe *big_cqe)

Naming nit: "lockless" seems a bit misleading since this does still
take the completion_lock. Maybe name this function "io_cqe_overflow()"
and the other "io_cqe_overflow_locked()"?

Otherwise,

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

> +{
> +       struct io_overflow_cqe *ocqe;
> +
> +       ocqe =3D io_alloc_ocqe(ctx, cqe, big_cqe, GFP_KERNEL);
> +       spin_lock(&ctx->completion_lock);
> +       io_cqring_add_overflow(ctx, ocqe);
> +       spin_unlock(&ctx->completion_lock);
> +}
> +
> +static __cold bool io_cqe_overflow(struct io_ring_ctx *ctx, struct io_cq=
e *cqe,
> +                                  struct io_big_cqe *big_cqe)
> +{
> +       struct io_overflow_cqe *ocqe;
> +
> +       ocqe =3D io_alloc_ocqe(ctx, cqe, big_cqe, GFP_ATOMIC);
> +       return io_cqring_add_overflow(ctx, ocqe);
> +}
> +
>  #define io_init_cqe(user_data, res, cflags)    \
>         (struct io_cqe) { .user_data =3D user_data, .res =3D res, .flags =
=3D cflags }
>
> @@ -818,11 +839,9 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 us=
er_data, s32 res, u32 cflags
>         io_cq_lock(ctx);
>         filled =3D io_fill_cqe_aux(ctx, user_data, res, cflags);
>         if (unlikely(!filled)) {
> -               struct io_overflow_cqe *ocqe;
>                 struct io_cqe cqe =3D io_init_cqe(user_data, res, cflags)=
;
>
> -               ocqe =3D io_alloc_ocqe(ctx, &cqe, NULL, GFP_ATOMIC);
> -               filled =3D io_cqring_add_overflow(ctx, ocqe);
> +               filled =3D io_cqe_overflow(ctx, &cqe, NULL);
>         }
>         io_cq_unlock_post(ctx);
>         return filled;
> @@ -838,13 +857,9 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 use=
r_data, s32 res, u32 cflags)
>         lockdep_assert(ctx->lockless_cq);
>
>         if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
> -               struct io_overflow_cqe *ocqe;
>                 struct io_cqe cqe =3D io_init_cqe(user_data, res, cflags)=
;
>
> -               ocqe =3D io_alloc_ocqe(ctx, &cqe, NULL, GFP_KERNEL);
> -               spin_lock(&ctx->completion_lock);
> -               io_cqring_add_overflow(ctx, ocqe);
> -               spin_unlock(&ctx->completion_lock);
> +               io_cqe_overflow_lockless(ctx, &cqe, NULL);
>         }
>         ctx->submit_state.cq_flush =3D true;
>  }
> @@ -1448,17 +1463,10 @@ void __io_submit_flush_completions(struct io_ring=
_ctx *ctx)
>                  */
>                 if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
>                     unlikely(!io_fill_cqe_req(ctx, req))) {
> -                       gfp_t gfp =3D ctx->lockless_cq ? GFP_KERNEL : GFP=
_ATOMIC;
> -                       struct io_overflow_cqe *ocqe;
> -
> -                       ocqe =3D io_alloc_ocqe(ctx, &req->cqe, &req->big_=
cqe, gfp);
> -                       if (ctx->lockless_cq) {
> -                               spin_lock(&ctx->completion_lock);
> -                               io_cqring_add_overflow(ctx, ocqe);
> -                               spin_unlock(&ctx->completion_lock);
> -                       } else {
> -                               io_cqring_add_overflow(ctx, ocqe);
> -                       }
> +                       if (ctx->lockless_cq)
> +                               io_cqe_overflow_lockless(ctx, &req->cqe, =
&req->big_cqe);
> +                       else
> +                               io_cqe_overflow(ctx, &req->cqe, &req->big=
_cqe);
>                 }
>         }
>         __io_cq_unlock_post(ctx);
> --
> 2.49.0
>

