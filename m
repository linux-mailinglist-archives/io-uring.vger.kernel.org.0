Return-Path: <io-uring+bounces-8196-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A938ACC9C7
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 17:05:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5231916D543
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 15:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DABE2239561;
	Tue,  3 Jun 2025 15:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ACfxZ/H5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D181622A813
	for <io-uring@vger.kernel.org>; Tue,  3 Jun 2025 15:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748963154; cv=none; b=K5mbDx8KGOImA4s2fhMdJ1EU5yKmefVkxjNq8CsSDZOSjQGHnInyZBDt2qmvVlt9zxm2JfbgV1zITtnpw7Vf/FIKDP3SJyuJshP7ouImSOtaejbInrLUeD9p6lzsNzcZPJSDCGamqoQFSxWlX2t7ognPd4ZE5gPv8vOmSGZYMf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748963154; c=relaxed/simple;
	bh=nDX2weWH+2WbrBLYtAiazEJPTIXQMk/OB+2aWRmhy4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EuNN29Usp0F6mDt5hpUBbNkZ7gpem0kWu8EXZFZh/tn+bdLMpKgykMBYJe6kIr0meOLpoGZfzNGQmDWrhkTWq6g8kqv/dP0xxQbcqvCdatgVE7GU9xsIn8SWZBm5G86G8359/a19GUCmsoeo/jeNS5jI5Fq5puzZDoNnvrFq9IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ACfxZ/H5; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b2c43cbce41so529059a12.2
        for <io-uring@vger.kernel.org>; Tue, 03 Jun 2025 08:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1748963152; x=1749567952; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SlDK8hpV5tzY7ElHDjzNJ2aa1VfDYw8hGQ9kc+y0IxE=;
        b=ACfxZ/H5ettbmzQkwqCl5awoz6j90tMjzhKoRft1s7V8otqEABH3418AB1uzfaLWTO
         t7143TyVp2Rv4xzKACCrOr/z9TO19oi8ITMcp2FYQJnYf1wF2H1W9jD59mtWDW8Leen1
         e4rHeVMbckSRM91uLrgqwGznqkbkUz8pZNIlFKHUKYQttIXvDJXJmJaD+KDPD9inE5QP
         IWFYaUjVmTvz4Rty7jYBdDleLhugX0Vns9dxoKwYOWSEtvfKqPGnVhLMDTVzGZxeTw7r
         YPtdhCLsDmz/q4IUAq45p3OAV4d2TMtHcg/V8RoHLhQeKt0grVGfz1mybIcCFkTNxxqK
         P9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748963152; x=1749567952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SlDK8hpV5tzY7ElHDjzNJ2aa1VfDYw8hGQ9kc+y0IxE=;
        b=vJI1FFCIxtQxS1IL2yT6h6mx5WD1HIKgs/R5PZUgyJrpFkSX8DGN0tqtVnKR4bqDLZ
         haCEZsag9Ns0GFrmRzjc9A6JG9V7y/tIqQ/1M4GyHSDgjVUO19omAGoWJ1F29+1/EmFc
         oIR1ki8PTBbr+SysyVZnCzrzQEOIFyms+/gPpDDVw2x6lTqlboBFHNJKVRPd3ILKm0fT
         1oIGdKEQgPBLpF4fC0nATWlJh2oYL5PzCdgNE77nVjwtwTK0VGbaYuynL25SmQoNgrzd
         1alzxAghza+K83zD8Z5dY03ySZePA4QRDZPEmc3TKaM5SAqraReBHOt3qpunTcZf8A+N
         w9rQ==
X-Gm-Message-State: AOJu0YyTIm0KKCm/XS+tyA0i9aKjwqLD7raH2LVumSwI0/bRf1QXJKIn
	afoWFGTXge+OeKRzyd045wzHIiqqGNyKEI8yd8np3lgH+evGLUC74Xqff3WBFnUUjnt0Z5VslhV
	SQJcBuRgFRBpbAHE4c0oAmrtu32DkuMHWVirWaOsNccx6i5hgcyiG6N8=
X-Gm-Gg: ASbGncscpAw0nZVwPMmkMmT3db7fkRHx/6bfguI52s37x2B9N5timOQxqtJun1M+jMV
	EX2RJhpD1XyhP0cmxkJBclc9zOFW05IW1/Ga6b60OHTEJq9R66Qtfm2LZU68WxwS4YUe/bED754
	1/tY3XT6Sx1YkFwmvBhMvqwyIWlIIlNN/t
X-Google-Smtp-Source: AGHT+IFQpiH2kPkpqCZ8m4snhz5+zwTybLsJ+s0o2KeQMX8lxnyQrXocLuWVK99KdUMFRFMV/PDn0mxgTbGwQi1upGY=
X-Received: by 2002:a17:90b:384e:b0:312:639:a06d with SMTP id
 98e67ed59e1d1-3124db30c05mr9984504a91.5.1748963151741; Tue, 03 Jun 2025
 08:05:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5d03de61-1419-443f-b3a4-e1f2ac2fe137@kernel.dk>
In-Reply-To: <5d03de61-1419-443f-b3a4-e1f2ac2fe137@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 3 Jun 2025 08:05:40 -0700
X-Gm-Features: AX0GCFuNUqQreQgjDyq2RQQPvq3XMRCJnr-S4UOxj3qDP1hSnFBDGJMdPsv5zYY
Message-ID: <CADUfDZo=mbiz=0wxKSihhw9cxRdj5Uojh=XO0aPxKOZKtEc22A@mail.gmail.com>
Subject: Re: [PATCH] io_uring/uring_cmd: be smarter about SQE copying
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 31, 2025 at 1:52=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> uring_cmd currently copies the SQE unconditionally, which was introduced
> as a work-around in commit:
>
> d6211ebbdaa5 ("io_uring/uring_cmd: unconditionally copy SQEs at prep time=
")
>
> because the checking for whether or not this command may have ->issue()
> called from io-wq wasn't complete. Rectify that, ensuring that if the
> request is marked explicitly async via REQ_F_FORCE_ASYNC or if it's
> part of a link chain, then the SQE is copied upfront.
>
> Always copying can be costly, particularly when dealing with SQE128
> rings. But even a normal 64b SQE copy is noticeable at high enough
> rates.
>
> Reported-by: Caleb Sander Mateos <csander@purestorage.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 929cad6ee326..cb4b867a2656 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -181,29 +181,42 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd,=
 ssize_t ret, u64 res2,
>  }
>  EXPORT_SYMBOL_GPL(io_uring_cmd_done);
>
> +static void io_uring_sqe_copy(struct io_kiocb *req, struct io_uring_cmd =
*ioucmd)
> +{
> +       struct io_async_cmd *ac =3D req->async_data;
> +
> +       if (ioucmd->sqe !=3D ac->sqes) {
> +               memcpy(ac->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
> +               ioucmd->sqe =3D ac->sqes;
> +       }
> +}
> +
>  static int io_uring_cmd_prep_setup(struct io_kiocb *req,
>                                    const struct io_uring_sqe *sqe)
>  {
>         struct io_uring_cmd *ioucmd =3D io_kiocb_to_cmd(req, struct io_ur=
ing_cmd);
> +       struct io_ring_ctx *ctx =3D req->ctx;
>         struct io_async_cmd *ac;
>
>         /* see io_uring_cmd_get_async_data() */
>         BUILD_BUG_ON(offsetof(struct io_async_cmd, data) !=3D 0);
>
> -       ac =3D io_uring_alloc_async_data(&req->ctx->cmd_cache, req);
> +       ac =3D io_uring_alloc_async_data(&ctx->cmd_cache, req);
>         if (!ac)
>                 return -ENOMEM;
>         ac->data.op_data =3D NULL;
>
>         /*
> -        * Unconditionally cache the SQE for now - this is only needed fo=
r
> -        * requests that go async, but prep handlers must ensure that any
> -        * sqe data is stable beyond prep. Since uring_cmd is special in
> -        * that it doesn't read in per-op data, play it safe and ensure t=
hat
> -        * any SQE data is stable beyond prep. This can later get relaxed=
.
> +        * Copy SQE now, if we know we're going async. Drain will set
> +        * FORCE_ASYNC, and assume links may cause it to go async. If not=
,
> +        * copy is deferred until issue time, if the request doesn't issu=
e
> +        * or queue inline.
>          */
> -       memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
> -       ioucmd->sqe =3D ac->sqes;
> +       ioucmd->sqe =3D sqe;
> +       if (req->flags & (REQ_F_FORCE_ASYNC| REQ_F_LINK | REQ_F_HARDLINK)=
 ||
> +           ctx->submit_state.link.head)

To check my understanding, io_init_req() will set REQ_F_FORCE_ASYNC on
any request with IOSQE_IO_DRAIN as well as all subsequent requests
until the IOSQE_IO_DRAIN request completes? Looks like this condition
should work then. I think you can drop REQ_F_LINK | REQ_F_HARDLINK,
though; the initial request of a linked chain will be issued
synchronously, and ctx->submit_state.link.head will be set for the
subsequent requests.

I do share Pavel's concern that whether or not a request will be
initially issued asynchronously is up to the core io_uring code, so it
seems a bit fragile to make these assumptions in the uring_cmd layer.
I think I would prefer either passing a bool issue_async to the
->prep() handler, or adding an optional ->prep_async() hook called if
the initial issue may happen asynchronously.

> +               io_uring_sqe_copy(req, ioucmd);
> +
>         return 0;
>  }
>
> @@ -259,6 +272,12 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int =
issue_flags)
>         }
>
>         ret =3D file->f_op->uring_cmd(ioucmd, issue_flags);
> +       if (ret =3D=3D -EAGAIN) {
> +               io_uring_sqe_copy(req, ioucmd);
> +               return ret;
> +       } else if (ret =3D=3D -EIOCBQUEUED) {
> +               return ret;
> +       }
>         if (ret =3D=3D -EAGAIN || ret =3D=3D -EIOCBQUEUED)
>                 return ret;

This if condition is always false now, remove it?

Best,
Caleb

>         if (ret < 0)
>
> --
> Jens Axboe
>

