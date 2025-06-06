Return-Path: <io-uring+bounces-8260-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF951AD0790
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 19:37:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A35C17362C
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 17:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A037289819;
	Fri,  6 Jun 2025 17:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Myly4K7F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F31D1DFD9A
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 17:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749231422; cv=none; b=byGlwKQQZTyfdvMc9XhWxowMfzUmK9NDH9jakt3+dP6bJECgsEbBYCvLyYLqseF2hnkoMQvPlTE0Y+RcereA7VzMRdZhch83LbNDDUcsgPWxBX+PA635jUATEo1Xmxe55kr5pLVC+AuSBYgOzFh/8UFHaqgKDMw64OGrnYa5aZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749231422; c=relaxed/simple;
	bh=AjSlyEWsnz18aQyFrw2Tyh421JrJDrsGeQHaXLs18VU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BJtK57ADeOhSS4XWo0IjDNQdZXp9aVDXoCG7N3tUDCUnX7kxR4NMT+EVekTAFhh44/ppxK0apAyX96uwAW8+Oej8y7uOglrQSDGP1jDgmWv+Zg+armH+CFvmUJ/HqM2utFhD9ClEhMB4gSIi+sLMUgXX9QqeKOU5839BNJF9AiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Myly4K7F; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-31232d5b1deso225840a91.3
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 10:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1749231420; x=1749836220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0o29O/JMWm17K+dIBKj99vwB29cxPG9vBjb/ptV69R0=;
        b=Myly4K7FSv2LndCgPwAbTgvqTBALNeiZkMllrWE9wJARXNwKCyvtKTe35OTbx81rXu
         qMBTInbNHsIkN03I/Rll/OtpxwfbuLsJp48QGYj6X0pkkSeTIgSCEgCgVDVWq2dAoMnS
         stTj+mU9DpFLbQtmeQpCXgH0mmYvnJhlkZGuvNY6C1N0ImxHDll6PDSf9t2NGHjFRr7i
         SCroeM7j0lSAP2c/A2kQXV1qrk+Ez96MTY3NULDBAPgAdExrUAv62vBVhkO6mmE8wgk4
         W3mcA/JMsMuaAUtCuWu7o+L6+ACEueApRfRTdordrV7azKtTBUtdRWh1ekoz7+LJo12k
         sdzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749231420; x=1749836220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0o29O/JMWm17K+dIBKj99vwB29cxPG9vBjb/ptV69R0=;
        b=LqmRsqW0+ev9tsF1ML6QtORDvvgaVUGbEguoKSUSzlUo3mybdye480nTrCiY/beuSf
         ZvJCUxL4eFjdhgEBg8OGHAunz6JGNWPOA/gWIwArLObssaPMutkaotuRP4maWdu1t/1C
         5/cuVZqq1x+TU0yMng7VuUC77PH6ScgtiAqfnSjNqGmKmTxGa0V+NQHivyb4jO3h+q2M
         fiYuBolFLYgj400lnIY1PTsjF1rbiXTt9oLoR38se5caAhrir2VkgxjpJh//aLf2qB/T
         hbM/Kw9GyxvxU3QiUfLLkFc0ltjCovgLJvh4Ee94Bu3cl3snb/eDssJUH3uJul7wyR8f
         DShg==
X-Gm-Message-State: AOJu0YxImm860JsoXYpmK9nZwNgmPJywGZARCaEu/RETOfpmuc59D8re
	YDmgQ0uDN+PoQPPxLwBXTBeUbSOVVSRHN+QOo1GKO04kbXqiH5dDcFThjdSeYf2NmZn41FUu0db
	MJkNMFeGvGzAbI+zXbhY70KCpTnerqyw4TcMx5gawgsdhF/azDCLj
X-Gm-Gg: ASbGnctKUQn5xTbgRWzZ+5YTEUBYu0+dVuiN1KY6yhhoEGIWDTl7ML3qzugzAqThb+p
	74EBymjgtP/U/Y1gxBVIyEp4zHDr/Y4SlEQaE99idD3/SSKhsu7jwPiSo5A9gFBywZ+lIgOykGZ
	o51NB4waf/AnVY4imZOnt4goOE0vyweFD1saJ1886tsbo=
X-Google-Smtp-Source: AGHT+IF1djzUaSGcQlkzHZIbT4Kl/lGSrb+mkoA0/8EgqGPmllJXxxnOkUJmQvhVX4Rzb0QQZJLE1K6rgNYWXH1E+os=
X-Received: by 2002:a17:90b:4c50:b0:311:fde5:c4ae with SMTP id
 98e67ed59e1d1-3134e3ff1c9mr1556127a91.6.1749231420410; Fri, 06 Jun 2025
 10:37:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605194728.145287-1-axboe@kernel.dk> <20250605194728.145287-3-axboe@kernel.dk>
In-Reply-To: <20250605194728.145287-3-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 6 Jun 2025 10:36:48 -0700
X-Gm-Features: AX0GCFuVfBnfJ184-n9MXIaamrEsJ6IflH2n3fquq1He8fJIiWCh7kzhm7OqZSM
Message-ID: <CADUfDZq1LaxzeuTDqMjF0H8L5cC36-dqZRhBYEsGQDjZFrZycw@mail.gmail.com>
Subject: Re: [PATCH 2/4] io_uring: add struct io_cold_def->sqe_copy() method
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 12:47=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Will be called by the core of io_uring, if inline issue is not going
> to be tried for a request. Opcodes can define this handler to defer
> copying of SQE data that should remain stable.
>
> Called with IO_URING_F_INLINE set if this is an inline issue, and that
> flag NOT set if it's an out-of-line call. The handler can use this to
> determine if it's still safe to copy the SQE. The core should always
> guarantee that it will be safe, but by having this flag available the
> handler is able to check and fail.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/io_uring.c | 32 ++++++++++++++++++++++++--------
>  io_uring/opdef.h    |  1 +
>  2 files changed, 25 insertions(+), 8 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 079a95e1bd82..fdf23e81c4ff 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -147,7 +147,7 @@ static bool io_uring_try_cancel_requests(struct io_ri=
ng_ctx *ctx,
>                                          bool cancel_all,
>                                          bool is_sqpoll_thread);
>
> -static void io_queue_sqe(struct io_kiocb *req);
> +static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe=
 *sqe);
>  static void __io_req_caches_free(struct io_ring_ctx *ctx);
>
>  static __read_mostly DEFINE_STATIC_KEY_FALSE(io_key_has_sqarray);
> @@ -1377,7 +1377,7 @@ void io_req_task_submit(struct io_kiocb *req, io_tw=
_token_t tw)
>         else if (req->flags & REQ_F_FORCE_ASYNC)
>                 io_queue_iowq(req);
>         else
> -               io_queue_sqe(req);
> +               io_queue_sqe(req, NULL);

Passing NULL here is a bit weird. As I mentioned on patch 1, I think
it would make more sense to consider this task work path a
"non-inline" issue.

>  }
>
>  void io_req_task_queue_fail(struct io_kiocb *req, int ret)
> @@ -1935,14 +1935,30 @@ struct file *io_file_get_normal(struct io_kiocb *=
req, int fd)
>         return file;
>  }
>
> -static void io_queue_async(struct io_kiocb *req, int ret)
> +static int io_req_sqe_copy(struct io_kiocb *req, const struct io_uring_s=
qe *sqe,
> +                          unsigned int issue_flags)
> +{
> +       const struct io_cold_def *def =3D &io_cold_defs[req->opcode];
> +
> +       if (!def->sqe_copy)
> +               return 0;
> +       return def->sqe_copy(req, sqe, issue_flags);
> +}
> +
> +static void io_queue_async(struct io_kiocb *req, const struct io_uring_s=
qe *sqe,
> +                          int ret)
>         __must_hold(&req->ctx->uring_lock)
>  {
>         if (ret !=3D -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
> +fail:
>                 io_req_defer_failed(req, ret);
>                 return;
>         }
>
> +       ret =3D io_req_sqe_copy(req, sqe, 0);
> +       if (unlikely(ret))
> +               goto fail;

It seems possible to avoid the goto by just adding "|| unlikely(ret =3D
io_req_sqe_copy(req, sqe, 0))" to the if condition above. But the
control flow isn't super convoluted with the goto, so I don't feel
strongly.

> +
>         switch (io_arm_poll_handler(req, 0)) {
>         case IO_APOLL_READY:
>                 io_kbuf_recycle(req, 0);
> @@ -1957,7 +1973,7 @@ static void io_queue_async(struct io_kiocb *req, in=
t ret)
>         }
>  }
>
> -static inline void io_queue_sqe(struct io_kiocb *req)
> +static inline void io_queue_sqe(struct io_kiocb *req, const struct io_ur=
ing_sqe *sqe)
>         __must_hold(&req->ctx->uring_lock)
>  {
>         int ret;
> @@ -1970,7 +1986,7 @@ static inline void io_queue_sqe(struct io_kiocb *re=
q)
>          * doesn't support non-blocking read/write attempts
>          */
>         if (unlikely(ret))
> -               io_queue_async(req, ret);
> +               io_queue_async(req, sqe, ret);
>  }
>
>  static void io_queue_sqe_fallback(struct io_kiocb *req)
> @@ -2200,7 +2216,7 @@ static inline int io_submit_sqe(struct io_ring_ctx =
*ctx, struct io_kiocb *req,
>                 link->last =3D req;
>
>                 if (req->flags & IO_REQ_LINK_FLAGS)
> -                       return 0;
> +                       return io_req_sqe_copy(req, sqe, IO_URING_F_INLIN=
E);

This only copies the SQE for the middle reqs in a linked chain. Don't
we need to copy it for the last req too? I would call
io_req_sqe_copy() unconditionally before the req->flags &
IO_REQ_LINK_FLAGS check.

>                 /* last request of the link, flush it */
>                 req =3D link->head;
>                 link->head =3D NULL;
> @@ -2216,10 +2232,10 @@ static inline int io_submit_sqe(struct io_ring_ct=
x *ctx, struct io_kiocb *req,
>  fallback:
>                         io_queue_sqe_fallback(req);
>                 }
> -               return 0;
> +               return io_req_sqe_copy(req, sqe, IO_URING_F_INLINE);

The first req in a linked chain hits this code path too, but it
doesn't usually need its SQE copied since it will still be issued
synchronously by default. (The io_queue_sqe_fallback() to handle
unterminated links in io_submit_state_end() might be an exception.)
But I am fine with copying the SQE for the first req too if it keeps
the code simpler. If the first req in a chain also has
REQ_F_FORCE_ASYNC | REQ_F_FAIL set, it will actually reach this
io_req_sqe_copy() twice (the second time from the goto fallback path).
I think the io_req_sqe_copy() can just move into the fallback block?

>         }
>
> -       io_queue_sqe(req);
> +       io_queue_sqe(req, sqe);
>         return 0;
>  }
>
> diff --git a/io_uring/opdef.h b/io_uring/opdef.h
> index 719a52104abe..71bfaa3c8afd 100644
> --- a/io_uring/opdef.h
> +++ b/io_uring/opdef.h
> @@ -38,6 +38,7 @@ struct io_issue_def {
>  struct io_cold_def {
>         const char              *name;
>
> +       int (*sqe_copy)(struct io_kiocb *, const struct io_uring_sqe *, u=
nsigned int issue_flags);

nit: this line is a tad long

Best,
Caleb

>         void (*cleanup)(struct io_kiocb *);
>         void (*fail)(struct io_kiocb *);
>  };
> --
> 2.49.0
>

