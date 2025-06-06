Return-Path: <io-uring+bounces-8262-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0B76AD0799
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 19:39:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C7247A3C9B
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 17:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23BDD1DF991;
	Fri,  6 Jun 2025 17:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="G+1upf8C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F3C17BEBF
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 17:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749231559; cv=none; b=NgNjWZEyZxO1uV8rQ4Inh/0JOLXREqRbQeXOZJImp3NSoJM9e0bmEbyPNpj49AdfvD5jhtjeOQ1HN1HaVzBfU+38d3Np9gbHjgERJSZ6DqaBu6r6QSmX0K3nVA8F8Uvn33euHaCtsqmoYTohxOfg0Mv6WFW/YyJbRLB+Qzomvtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749231559; c=relaxed/simple;
	bh=2pOPCiBO3XEkfSRD2z9HJ9BxpoaaWbTgIMFOAx5k4sw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hLzoW2FD8DsmPFCOCJm3lhq5TtldhIebDYsG3TvLzZW2fAyjvhB/OLWNlzoTSYGTnBvE4MCUjm9WDzarpiPnHCbcLK4WEabcZsvsHK1chXLvW7D61RFP5raYwLMBapfOhAUYTkWgKB/md4RuTiv2e61yUe76rG56dOG/7uUNB58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=G+1upf8C; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b26ed911f4cso253108a12.3
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 10:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1749231556; x=1749836356; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oJMUJ3giv5pYavVFIvlW+eP/3sripYlRefOZVIb6RYQ=;
        b=G+1upf8CtaPrnt8OgfMsY99GpXZhLjzTCTGyXhZ4sF2GxhBfw0fo5Y3uPHkEZeYCdC
         g5GwWa/17GnG85W7/06kDk9RN2NHN3QYYchPlMVpoFK+fQ+/mZZLLuFzVj+AZsbY9yGy
         6YIo8d3jx57uOM1gNJpFUekERYfpLlPVBAKq+3mCtAJyQONFDaa57tF/78f4KcDVlPoP
         Y3Tg8T02ZHcyjjhrq7w9mLMt4599Fb07s0rCkXJ0Z+Bkew+BpgnC3R+1+S3sbntm3hFu
         yRv6xNbxubWGyzIv3g9MXFY+l++bjmxE58v+obVMtc0lg4Yi6tn1hszblMgXhbJBu1bU
         z9Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749231556; x=1749836356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oJMUJ3giv5pYavVFIvlW+eP/3sripYlRefOZVIb6RYQ=;
        b=uYSd/KrVZ5BRThWewtwW84MMH0eZv2qp1uiEVTFumatVi7ACOOk5h3iDsBsdJZCkWX
         sd/uK29Kd4Ptw2SvDcp7zGBLG3ILK7gRGZCp8L45UeaD0u8KwTDnS0Igbx8ZKWeKMKb/
         RvIsI521MAuq6xcsM+MfPxdOEf+OP7CZqSaPUomvA1KkHOUkyLBoAAvfza5hUZb3B+fY
         MacT9a1XYpAGhXHujOanpviFHCSc7txic6qruDHINuaxmeTbs4IyXyNYu54QBqylglXx
         u8pJUKPevIwMQtBRusgGyDGJnpLbxUaE0u4d+aW3N3KfjaUmywjUMlvmc/3CC6xqp7VX
         7vqQ==
X-Gm-Message-State: AOJu0YwXgKVOeKHe3V8ixQFi0O1Ksu8huKOBVQSHVANUYR2pEDlfkJdn
	1V/QKtF4GHxtpyfwKcnnzFsuuikfEbPBsrFy8w/LMV9vuR9LRRR4xM1VHnC5hZKc8c+8ZrURhAE
	cHCAhjIW+I54L37SfBEwAqgJA4ZtcQcpFPwo/LKHCdVL5joqK01Zzcmk=
X-Gm-Gg: ASbGncsTkaroPiVTsJf4GGiVJO/Kx7H9D8qKtvaPt21sIV5VqXSFmlyfULMjTM6qgWZ
	cS/mXFvXwL2T4+QnHTw35MHRm5jiXQka10sr4Ij5igcU1Ou6UsgLjmpekOoSdf7eEVr6JGBgeuZ
	7cUsY740pDaCf1HYWGok+w1qHA+1TX0uQdFNhWLVqfgoY=
X-Google-Smtp-Source: AGHT+IE8v6Ot8MDp0WU5LlsbccMQVnOFug+ts9YLKnsyS6SKH9UKjXEDVxpfxEdlyujxSm6siFmh9ayhWYiY5Km2IT4=
X-Received: by 2002:a17:90b:1b52:b0:313:151a:8653 with SMTP id
 98e67ed59e1d1-3134e4196ecmr1621840a91.8.1749231556454; Fri, 06 Jun 2025
 10:39:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605194728.145287-1-axboe@kernel.dk> <20250605194728.145287-5-axboe@kernel.dk>
In-Reply-To: <20250605194728.145287-5-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 6 Jun 2025 10:39:04 -0700
X-Gm-Features: AX0GCFvxz55D7L8f0c6NcH6LaNOiGWsvWF5-p0vwy9jDGG7bpqn069Qfaaz7A5k
Message-ID: <CADUfDZrXup5LN250NS9BbSCC5Mq5ek82zJ89W2KyqUKaWNwpTw@mail.gmail.com>
Subject: Re: [PATCH 4/4] io_uring/uring_cmd: implement ->sqe_copy() to avoid
 unnecessary copies
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 12:47=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> uring_cmd currently copies the full SQE at prep time, just in case it
> needs it to be stable. Opt in to using ->sqe_copy() to let the core of
> io_uring decide when to copy SQEs.
>
> This provides two checks to see if ioucmd->sqe is still valid:
>
> 1) If ioucmd->sqe is not the uring copied version AND IO_URING_F_INLINE
>    isn't set, then the core of io_uring has a bug. Warn and return
>    -EFAULT.
>
> 2) If sqe is NULL AND IO_URING_F_INLINE isn't set, then the core of
>    io_uring has a bug. Warn and return -EFAULT.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/opdef.c     |  1 +
>  io_uring/uring_cmd.c | 35 ++++++++++++++++++++++++-----------
>  io_uring/uring_cmd.h |  2 ++
>  3 files changed, 27 insertions(+), 11 deletions(-)
>
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 6e0882b051f9..287f9a23b816 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -759,6 +759,7 @@ const struct io_cold_def io_cold_defs[] =3D {
>         },
>         [IORING_OP_URING_CMD] =3D {
>                 .name                   =3D "URING_CMD",
> +               .sqe_copy               =3D io_uring_cmd_sqe_copy,
>                 .cleanup                =3D io_uring_cmd_cleanup,
>         },
>         [IORING_OP_SEND_ZC] =3D {
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index e204f4941d72..f682b9d442e1 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -205,16 +205,25 @@ int io_uring_cmd_prep(struct io_kiocb *req, const s=
truct io_uring_sqe *sqe)
>         if (!ac)
>                 return -ENOMEM;
>         ac->data.op_data =3D NULL;
> +       ioucmd->sqe =3D sqe;
> +       return 0;
> +}
> +
> +int io_uring_cmd_sqe_copy(struct io_kiocb *req, const struct io_uring_sq=
e *sqe,
> +                         unsigned int issue_flags)

Is it necessary to pass the sqe? Wouldn't it always be ioucmd->sqe?
Presumably any other opcode that implements ->sqe_copy() would also
have the sqe pointer stashed somewhere. Seems like it would simplify
the core io_uring code a bit not to have to thread the sqe through
several function calls.

> +{
> +       struct io_uring_cmd *ioucmd =3D io_kiocb_to_cmd(req, struct io_ur=
ing_cmd);
> +       struct io_async_cmd *ac =3D req->async_data;
> +
> +       if (sqe !=3D ac->sqes) {

Maybe return early if sqe =3D=3D ac->sqes to reduce indentation?

> +               if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_INLINE)))
> +                       return -EFAULT;
> +               if (WARN_ON_ONCE(!sqe))
> +                       return -EFAULT;
> +               memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
> +               ioucmd->sqe =3D ac->sqes;
> +       }
>
> -       /*
> -        * Unconditionally cache the SQE for now - this is only needed fo=
r
> -        * requests that go async, but prep handlers must ensure that any
> -        * sqe data is stable beyond prep. Since uring_cmd is special in
> -        * that it doesn't read in per-op data, play it safe and ensure t=
hat
> -        * any SQE data is stable beyond prep. This can later get relaxed=
.
> -        */
> -       memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
> -       ioucmd->sqe =3D ac->sqes;
>         return 0;
>  }
>
> @@ -251,8 +260,12 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int =
issue_flags)
>         }
>
>         ret =3D file->f_op->uring_cmd(ioucmd, issue_flags);
> -       if (ret =3D=3D -EAGAIN || ret =3D=3D -EIOCBQUEUED)
> -               return ret;
> +       if (ret =3D=3D -EAGAIN) {
> +               io_uring_cmd_sqe_copy(req, ioucmd->sqe, issue_flags);

Is it necessary to call io_uring_cmd_sqe_copy() here? Won't the call
in io_queue_async() already handle this case?

> +               return -EAGAIN;
> +       } else if (ret =3D=3D -EIOCBQUEUED) {

nit: else could be omitted since the if case diverges

Best,
Caleb

> +               return -EIOCBQUEUED;
> +       }
>         if (ret < 0)
>                 req_set_fail(req);
>         io_req_uring_cleanup(req, issue_flags);
> diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
> index e6a5142c890e..f956b0e7c351 100644
> --- a/io_uring/uring_cmd.h
> +++ b/io_uring/uring_cmd.h
> @@ -11,6 +11,8 @@ struct io_async_cmd {
>
>  int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
>  int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *s=
qe);
> +int io_uring_cmd_sqe_copy(struct io_kiocb *req, const struct io_uring_sq=
e *sqe,
> +                         unsigned int issue_flags);
>  void io_uring_cmd_cleanup(struct io_kiocb *req);
>
>  bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
> --
> 2.49.0
>

