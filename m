Return-Path: <io-uring+bounces-8278-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C8E8AD0AB2
	for <lists+io-uring@lfdr.de>; Sat,  7 Jun 2025 02:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B71553A4DBC
	for <lists+io-uring@lfdr.de>; Sat,  7 Jun 2025 00:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25FF18C31;
	Sat,  7 Jun 2025 00:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JP6CM/BL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CAFD2FF
	for <io-uring@vger.kernel.org>; Sat,  7 Jun 2025 00:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749257449; cv=none; b=o1A+T6yCK6fv8Xd/TL1BpuE9eQ2FlhrRmFycbXXcmn+vo/1dp3oYZKxANQvOu9sCmPnzRvFcizYjoXrt6d1M2vt11NjLJVkkx1aMmsJbr8rr1HexVnKxdoGIFbPQ8wT4CijYNbx7zUJwjIew0qzM3XfQwRSvoqW7g+UpOwKgaEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749257449; c=relaxed/simple;
	bh=pE2+cI7/+cj9kdNLjtZTfdtGnKlDjxZlUAaaQOq5KkE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sVzf1raIr9oARrMdf+1X8txrpJyzTYQQqFZnYBqgoRX4td6OWCPYxNGcD0+W5Q0wz5neNxDK9CtyP6BVnyaoC4O+l5a6SBJHaFX7h+wzdkPuk6ZjQpbOFuLNZPxM8t2pX+AFbYLsiT9wMd0zLEYBoXgcDm4/oaCmhYqalg+kUUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JP6CM/BL; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-234eaea2e4eso4764225ad.0
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 17:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1749257447; x=1749862247; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jXQ1takpAz91RmHFV/jytQ3erFdh1YHDetAamFKmkWY=;
        b=JP6CM/BLcfGUFCNcYInKRNPQeNm/dUlG4AyZldu9Du6txQfSY5DDAcnkWtF0CAuM3M
         4SEST33cLrM4iYRlQt023ngCrODA7dK7j7dbVGMVGONC8k/VjdFuUiH04A1tdSQPaakl
         NXFTfGIyzCLSH27oDnMPn0Z/BWKPy/Aa7wAFE80Xk9mHn3FmTEmyQi856BLX2N9wHz63
         gLtvGPur9NubIbnXvhvefQyg/oaePeKtPd/2eqQ2B0+PkTozzqmYM8CqZlDEKEJUtQ1u
         v5mdpDI10vq8+wAbKGeGwnUOk55EYFGhw2q8O3J7xXM8LhQb0aRQA0QUe+KAWoG6DKCO
         Z86w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749257447; x=1749862247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jXQ1takpAz91RmHFV/jytQ3erFdh1YHDetAamFKmkWY=;
        b=W7kUKbPjuRe+pLT0AvlPC099PLFub9PnlsXpFYOJWXMDEebgulaU/ajwE8kHNBg0yL
         1rx8VC4eucdxbmeZCNbOuMlcdGEVvJ9hzPoNnfDLN+bPCWH7HwoRRjFi61yoho7/lfdo
         zs69CfpyVIr3hzDEgXuWTNHEVOJHVqQpODo/XrqFSuaTxDH+i2Qvayw+q/yWQxmQmhn4
         MYH6rkxj0EYS4MTOcw2wmjlIxlxkI39iPN+eC4UQo6YVvUw8Ircft6msv/RoL7Tp9sGf
         KoZSPTnVwpbKk5Tfy/Sm/wZrZARPhDqnuMTZTc1UxIvEdtnlyjAv1FdFAwgkeDmSM+4d
         E9Iw==
X-Gm-Message-State: AOJu0Yz7ntieAgiYDhingcWCEAN6fTntRXKAJUaEoWAvZRlADJ83DLeK
	vhaXs2rfICY3eEQ38IWK1Vg4e41mzS2Ywwb5VQx3k5gTzCW02kiWpP5wfbixklfYziD7ARPec0b
	ZLwPmMY8zmw+mRktN0PhQs1n2ukSZ/M6zkUucg2zXTW7hIIpZMxqI
X-Gm-Gg: ASbGncun5yhuFUyX+qNYkz+LujcEdTU3KLi836FTURvyrx/u5svc/sOYNBUsJTbvFkr
	igJZMBjYXQ6FWjHiwlUfOSW2DatKKI+B+eoyxYbiqupKVn7J+bkkcuM0ffuHcfL5hoJVjNze0Uz
	XXqVc4kotEL9bXQwEDypX8hN8rthWvOtHc
X-Google-Smtp-Source: AGHT+IEqxDOPYL9jNdSAWbBwIkaPdg7AR9MvhzJ9jcO365KdSNI+cUhpbHBVBzyntv5mChgDFmh8EYXabHXAb8KmnG0=
X-Received: by 2002:a17:90a:d006:b0:311:e9a6:332e with SMTP id
 98e67ed59e1d1-3134ded1839mr2486312a91.0.1749257447168; Fri, 06 Jun 2025
 17:50:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606215633.322075-1-axboe@kernel.dk> <20250606215633.322075-3-axboe@kernel.dk>
In-Reply-To: <20250606215633.322075-3-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 6 Jun 2025 17:50:35 -0700
X-Gm-Features: AX0GCFu58LhX0nTKOH24X-w50JJ9LXzi5Q-fKG31wL019BVu1QClLecbvNxmJPU
Message-ID: <CADUfDZq45a9K9SHEeTTFU5vpbbkFtOhjpW_ovAiV_Y-Xbdy=uA@mail.gmail.com>
Subject: Re: [PATCH 2/4] io_uring: add struct io_cold_def->sqe_copy() method
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 2:56=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Will be called by the core of io_uring, if inline issue is not going
> to be tried for a request. Opcodes can define this handler to defer
> copying of SQE data that should remain stable.
>
> Only called if IO_URING_F_INLINE is set. If it isn't set, then there's a
> bug in the core handling of this, and -EFAULT will be returned instead
> to terminate the request. This will trigger a WARN_ON_ONCE(). Don't
> expect this to ever trigger, and down the line this can be removed.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/io_uring.c | 25 ++++++++++++++++++++++---
>  io_uring/opdef.h    |  1 +
>  2 files changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 0f9f6a173e66..9799a31a2b29 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1935,14 +1935,31 @@ struct file *io_file_get_normal(struct io_kiocb *=
req, int fd)
>         return file;
>  }
>
> -static void io_queue_async(struct io_kiocb *req, int ret)
> +static int io_req_sqe_copy(struct io_kiocb *req, unsigned int issue_flag=
s)
> +{
> +       const struct io_cold_def *def =3D &io_cold_defs[req->opcode];
> +
> +       if (!def->sqe_copy)
> +               return 0;
> +       if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_INLINE)))

I'm pretty confident that every initial async path under
io_submit_sqe() will call io_req_sqe_copy(). But I'm not positive that
io_req_sqe_copy() won't get called *additional* times from non-inline
contexts. One example scenario:
- io_submit_sqe() calls io_queue_sqe()
- io_issue_sqe() returns -EAGAIN, so io_queue_sqe() calls io_queue_async()
- io_queue_async() calls io_req_sqe_copy() in inline context
- io_queue_async() calls io_arm_poll_handler(), which returns
IO_APOLL_READY, so io_req_task_queue() is called
- Some other I/O to the file (possibly on a different task) clears the
ready poll events
- io_req_task_submit() calls io_queue_sqe() in task work context
- io_issue_sqe() returns -EAGAIN again, so io_queue_async() is called
- io_queue_async() calls io_req_sqe_copy() a second time in non-inline
(task work) context

If this is indeed possible, then I think we may need to relax this
check so it only verifies that IO_URING_F_INLINE is set *the first
time* io_req_sqe_copy() is called for a given req. (Or just remove the
IO_URING_F_INLINE check entirely.)

> +               return -EFAULT;
> +       def->sqe_copy(req);
> +       return 0;
> +}
> +
> +static void io_queue_async(struct io_kiocb *req, unsigned int issue_flag=
s, int ret)
>         __must_hold(&req->ctx->uring_lock)
>  {
>         if (ret !=3D -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
> +fail:
>                 io_req_defer_failed(req, ret);
>                 return;
>         }
>
> +       ret =3D io_req_sqe_copy(req, issue_flags);
> +       if (unlikely(ret))
> +               goto fail;
> +
>         switch (io_arm_poll_handler(req, 0)) {
>         case IO_APOLL_READY:
>                 io_kbuf_recycle(req, 0);
> @@ -1971,7 +1988,7 @@ static inline void io_queue_sqe(struct io_kiocb *re=
q, unsigned int extra_flags)
>          * doesn't support non-blocking read/write attempts
>          */
>         if (unlikely(ret))
> -               io_queue_async(req, ret);
> +               io_queue_async(req, issue_flags, ret);
>  }
>
>  static void io_queue_sqe_fallback(struct io_kiocb *req)
> @@ -1986,6 +2003,8 @@ static void io_queue_sqe_fallback(struct io_kiocb *=
req)
>                 req->flags |=3D REQ_F_LINK;
>                 io_req_defer_failed(req, req->cqe.res);
>         } else {
> +               /* can't fail with IO_URING_F_INLINE */
> +               io_req_sqe_copy(req, IO_URING_F_INLINE);
>                 if (unlikely(req->ctx->drain_active))
>                         io_drain_req(req);
>                 else
> @@ -2201,7 +2220,7 @@ static inline int io_submit_sqe(struct io_ring_ctx =
*ctx, struct io_kiocb *req,
>                 link->last =3D req;
>
>                 if (req->flags & IO_REQ_LINK_FLAGS)
> -                       return 0;
> +                       return io_req_sqe_copy(req, IO_URING_F_INLINE);

I still think this misses the last req in a linked chain, which will
be issued async but won't have IO_REQ_LINK_FLAGS set. Am I missing
something?

Best,
Caleb


>                 /* last request of the link, flush it */
>                 req =3D link->head;
>                 link->head =3D NULL;
> diff --git a/io_uring/opdef.h b/io_uring/opdef.h
> index 719a52104abe..c2f0907ed78c 100644
> --- a/io_uring/opdef.h
> +++ b/io_uring/opdef.h
> @@ -38,6 +38,7 @@ struct io_issue_def {
>  struct io_cold_def {
>         const char              *name;
>
> +       void (*sqe_copy)(struct io_kiocb *);
>         void (*cleanup)(struct io_kiocb *);
>         void (*fail)(struct io_kiocb *);
>  };
> --
> 2.49.0
>

