Return-Path: <io-uring+bounces-6537-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 156D9A3AEF1
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 02:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45B9F3AD6FD
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 01:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8BC57DA9C;
	Wed, 19 Feb 2025 01:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="MmkoViz8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7925282488
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 01:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928493; cv=none; b=DmXqYVYgvRv+zfNuVvdhH4M5PdKJjtyFIqV5I2U5dEZK22YG+1TvAnI1HazYqoEhGE5t7haotaxEKyxbCJs3OSsUczMfMefcYhb6u4tTreDb+st4svNHz5xO7g0ZYGWXYogvsuklcTzym8L93UmZ3MnqSmV95ElcgU8R54MU4zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928493; c=relaxed/simple;
	bh=WCnxEF6rZad1sACWX9eDXbNtNVGpYG4Xdvsmy7+U2Ow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i/ib6QxpNJrnLMXq8uoKXOoqKNE/TuL2cDt/ff7HSShxc+vSOu84SQeSGYFaTbl6wqCrsiE/Ma3v1n8i8sNyAN/5zzRaWVffyyKAWQUk826fIfsGwJYDpSAO9mR3STeGwz22cP3Jw7/fca4YfnjmJT/Df5Ud4UrerTNBGdooLfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=MmkoViz8; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-220d47b035fso14932135ad.1
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739928491; x=1740533291; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3EPw+cokOW43CEcRjwK/I3t7lHKF7n5R8FM2ULp/19M=;
        b=MmkoViz879AoVnfgPlSjshsFKIRKBdTzuf/kKNoVGfGhBbOiwUV/TpcWP3xlovkZ5U
         g7hxaMCgO/Frxw8ED4Ce+6kkWr2p5NDMgg8YN9LTmhaSN3G/LxeQgWoDeOKwx0TYGIbO
         D+cJQvijd06RlkgOocUdrZrDk8ajCSkcUNRTtXoD+OXSS6wgLy8m/P0WL5Vtgs2fCF/Y
         3P1anSNBXgq/2t3hMREEnMGN4dUJh2ap58DcL4y6bC3BfGFLeXhkbbaY/BQLQsORz0Bv
         TL302tHarJQbKaVXYhj/RrzV85J/OUMkoOh1QHmen6lavPaKcRZYSwEi9pfPb2Mt0M4I
         RL3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928491; x=1740533291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3EPw+cokOW43CEcRjwK/I3t7lHKF7n5R8FM2ULp/19M=;
        b=bM6JOYOyVXzA50XFGA4v9u1VUuhM7MwNBwKZQH0ycdal9mgHcrA5xSKp9S4v7o3lY5
         dIso/wL6pz88OMeISm//lgbFX9TwPChS4ces7UXvVO2YFyGWqn92T8PE8R6RoqyXY/OP
         d7btHeu3E1IO0kD9+oKuqj1Hb++Og4KJeIJKy1HoDPo7+dqnQb7GUhSgXA5hCH1f6Bjf
         NSSTwjTOJ3/zmtFYDvsVuodu+hM/eYPoFmUcW0Aa1G6D5Y+I7yRWh3fIIvHU2/n+PKb0
         ehbgJGWUER7zj/1LVGZ2/fn7NWE8LxB/p7EeyJ7z/wbXMp8hXTG4F6LyM2wrQS+xUhxC
         X0Eg==
X-Forwarded-Encrypted: i=1; AJvYcCUf7hZ1hNq7RJFp9U6P+KAsbqyl5eZFKhhGNl91f5FPnOl5LfMkq3nHK4tDx7LxNgYJTeNifDt+kQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YypLiaxBRnfPjX4DGu9449B332nbATuCuWsXdgRU/jYZT8SPRgd
	3CDIW4W6XZBgw/S7LMXwIGZlMp89FkYRPzw0nZKYDonkHVHtBqTm1Xbr58pZoTBiYjVYBbuDLQn
	n4ueFJJ12jufMCW4aSHTkJYBz2jDnUP3diOJBJA==
X-Gm-Gg: ASbGncukhxJ3QfEPQp2SYwGF9px8HHQNIs7oixIkufvGHt7tRxNQT0/E67226PxXtbK
	B8EdUSyLR4Bw0Ok257F/Wdm7MNTD7bZbZ0ByFFxUtMnRxKEtD1/9ZLZBMiH84i1GBAY0TsU0=
X-Google-Smtp-Source: AGHT+IE+7veVMXZpKAaVpwqboXR9kcGJugfg50LuzJJRIhurucaf7GDRuklWynPr9IYxTqqwWtGJFoOuIaQcIt6wE3g=
X-Received: by 2002:a17:902:ce08:b0:215:2bfb:3cd7 with SMTP id
 d9443c01a7336-2210408b39dmr100398965ad.10.1739928490521; Tue, 18 Feb 2025
 17:28:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218224229.837848-1-kbusch@meta.com> <20250218224229.837848-2-kbusch@meta.com>
In-Reply-To: <20250218224229.837848-2-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 18 Feb 2025 17:27:59 -0800
X-Gm-Features: AWEUYZnkp0PQcaRqe56wjeVQ05KAOROYbYYmFgS8fUCrE5jshoapkOB6ZKxcc4g
Message-ID: <CADUfDZrN5LqmoSb1+e2DHejQM_xewOaVxXmU99LsXxc=erCy3A@mail.gmail.com>
Subject: Re: [PATCHv4 1/5] io_uring: move fixed buffer import to issue path
To: Keith Busch <kbusch@meta.com>
Cc: ming.lei@redhat.com, asml.silence@gmail.com, axboe@kernel.dk, 
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2025 at 2:43=E2=80=AFPM Keith Busch <kbusch@meta.com> wrote=
:
>
> From: Keith Busch <kbusch@kernel.org>
>
> Similar to the fixed file path, requests may depend on a previous one
> to set up an index, so we need to allow linking them. The prep callback
> happens too soon for linked commands, so the lookup needs to be deferred
> to the issue path. Change the prep callbacks to just set the buf_index
> and let generic io_uring code handle the fixed buffer node setup, just
> like it already does for fixed files.
>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  include/linux/io_uring_types.h |  3 +++
>  io_uring/io_uring.c            | 19 ++++++++++++++
>  io_uring/net.c                 | 25 ++++++-------------
>  io_uring/nop.c                 | 22 +++--------------
>  io_uring/rw.c                  | 45 ++++++++++++++++++++++++----------
>  io_uring/uring_cmd.c           | 16 ++----------
>  6 files changed, 67 insertions(+), 63 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index c0fe8a00fe53a..0bcaefc4ffe02 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -482,6 +482,7 @@ enum {
>         REQ_F_DOUBLE_POLL_BIT,
>         REQ_F_APOLL_MULTISHOT_BIT,
>         REQ_F_CLEAR_POLLIN_BIT,
> +       REQ_F_FIXED_BUFFER_BIT,

Move this to the end of the REQ_F_*_BIT definitions (before __REQ_F_LAST_BI=
T)?

>         /* keep async read/write and isreg together and in order */
>         REQ_F_SUPPORT_NOWAIT_BIT,
>         REQ_F_ISREG_BIT,
> @@ -574,6 +575,8 @@ enum {
>         REQ_F_BUF_NODE          =3D IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
>         /* request has read/write metadata assigned */
>         REQ_F_HAS_METADATA      =3D IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
> +       /* request has a fixed buffer at buf_index */
> +       REQ_F_FIXED_BUFFER      =3D IO_REQ_FLAG(REQ_F_FIXED_BUFFER_BIT),
>  };
>
>  typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw)=
;
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 58528bf61638e..7800edbc57279 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1721,6 +1721,23 @@ static bool io_assign_file(struct io_kiocb *req, c=
onst struct io_issue_def *def,
>         return !!req->file;
>  }
>
> +static bool io_assign_buffer(struct io_kiocb *req, unsigned int issue_fl=
ags)
> +{
> +       struct io_ring_ctx *ctx =3D req->ctx;
> +       struct io_rsrc_node *node;
> +
> +       if (req->buf_node || !(req->flags & REQ_F_FIXED_BUFFER))
> +               return true;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +       node =3D io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
> +       if (node)
> +               io_req_assign_buf_node(req, node);
> +       io_ring_submit_unlock(ctx, issue_flags);
> +
> +       return !!node;
> +}
> +
>  static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>  {
>         const struct io_issue_def *def =3D &io_issue_defs[req->opcode];
> @@ -1729,6 +1746,8 @@ static int io_issue_sqe(struct io_kiocb *req, unsig=
ned int issue_flags)
>
>         if (unlikely(!io_assign_file(req, def, issue_flags)))
>                 return -EBADF;
> +       if (unlikely(!io_assign_buffer(req, issue_flags)))
> +               return -EFAULT;
>
>         if (unlikely((req->flags & REQ_F_CREDS) && req->creds !=3D curren=
t_cred()))
>                 creds =3D override_creds(req->creds);
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 000dc70d08d0d..39838e8575b53 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -1373,6 +1373,10 @@ int io_send_zc_prep(struct io_kiocb *req, const st=
ruct io_uring_sqe *sqe)
>  #endif
>         if (unlikely(!io_msg_alloc_async(req)))
>                 return -ENOMEM;
> +       if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
> +               req->buf_index =3D zc->buf_index;

Can the buf_index field of io_sr_msg be removed now that it's only
used within io_send_zc_prep()?

> +               req->flags |=3D REQ_F_FIXED_BUFFER;
> +       }
>         if (req->opcode !=3D IORING_OP_SENDMSG_ZC)
>                 return io_send_setup(req, sqe);
>         return io_sendmsg_setup(req, sqe);
> @@ -1434,25 +1438,10 @@ static int io_send_zc_import(struct io_kiocb *req=
, unsigned int issue_flags)
>         struct io_async_msghdr *kmsg =3D req->async_data;
>         int ret;
>
> -       if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
> -               struct io_ring_ctx *ctx =3D req->ctx;
> -               struct io_rsrc_node *node;
> -
> -               ret =3D -EFAULT;
> -               io_ring_submit_lock(ctx, issue_flags);
> -               node =3D io_rsrc_node_lookup(&ctx->buf_table, sr->buf_ind=
ex);
> -               if (node) {
> -                       io_req_assign_buf_node(sr->notif, node);
> -                       ret =3D 0;
> -               }
> -               io_ring_submit_unlock(ctx, issue_flags);
> -
> -               if (unlikely(ret))
> -                       return ret;
> -
> +       if (req->flags & REQ_F_FIXED_BUFFER) {
>                 ret =3D io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter,
> -                                       node->buf, (u64)(uintptr_t)sr->bu=
f,
> -                                       sr->len);
> +                                       req->buf_node->buf,
> +                                       (u64)(uintptr_t)sr->buf, sr->len)=
;
>                 if (unlikely(ret))
>                         return ret;
>                 kmsg->msg.sg_from_iter =3D io_sg_from_iter;
> diff --git a/io_uring/nop.c b/io_uring/nop.c
> index 5e5196df650a1..989908603112f 100644
> --- a/io_uring/nop.c
> +++ b/io_uring/nop.c
> @@ -16,7 +16,6 @@ struct io_nop {
>         struct file     *file;
>         int             result;
>         int             fd;
> -       int             buffer;
>         unsigned int    flags;
>  };
>
> @@ -39,10 +38,10 @@ int io_nop_prep(struct io_kiocb *req, const struct io=
_uring_sqe *sqe)
>                 nop->fd =3D READ_ONCE(sqe->fd);
>         else
>                 nop->fd =3D -1;
> -       if (nop->flags & IORING_NOP_FIXED_BUFFER)
> -               nop->buffer =3D READ_ONCE(sqe->buf_index);
> -       else
> -               nop->buffer =3D -1;
> +       if (nop->flags & IORING_NOP_FIXED_BUFFER) {
> +               req->buf_index =3D READ_ONCE(sqe->buf_index);
> +               req->flags |=3D REQ_F_FIXED_BUFFER;
> +       }
>         return 0;
>  }
>
> @@ -63,19 +62,6 @@ int io_nop(struct io_kiocb *req, unsigned int issue_fl=
ags)
>                         goto done;
>                 }
>         }
> -       if (nop->flags & IORING_NOP_FIXED_BUFFER) {
> -               struct io_ring_ctx *ctx =3D req->ctx;
> -               struct io_rsrc_node *node;
> -
> -               ret =3D -EFAULT;
> -               io_ring_submit_lock(ctx, issue_flags);
> -               node =3D io_rsrc_node_lookup(&ctx->buf_table, nop->buffer=
);
> -               if (node) {
> -                       io_req_assign_buf_node(req, node);
> -                       ret =3D 0;
> -               }
> -               io_ring_submit_unlock(ctx, issue_flags);
> -       }
>  done:
>         if (ret < 0)
>                 req_set_fail(req);
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 16f12f94943f7..2d8910d9197a0 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -353,25 +353,14 @@ int io_prep_writev(struct io_kiocb *req, const stru=
ct io_uring_sqe *sqe)
>  static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_=
sqe *sqe,
>                             int ddir)
>  {
> -       struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
> -       struct io_ring_ctx *ctx =3D req->ctx;
> -       struct io_rsrc_node *node;
> -       struct io_async_rw *io;
>         int ret;
>
>         ret =3D io_prep_rw(req, sqe, ddir, false);
>         if (unlikely(ret))
>                 return ret;
>
> -       node =3D io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
> -       if (!node)
> -               return -EFAULT;
> -       io_req_assign_buf_node(req, node);
> -
> -       io =3D req->async_data;
> -       ret =3D io_import_fixed(ddir, &io->iter, node->buf, rw->addr, rw-=
>len);
> -       iov_iter_save_state(&io->iter, &io->iter_state);
> -       return ret;
> +       req->flags |=3D REQ_F_FIXED_BUFFER;
> +       return 0;
>  }
>
>  int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *=
sqe)
> @@ -954,10 +943,36 @@ static int __io_read(struct io_kiocb *req, unsigned=
 int issue_flags)
>         return ret;
>  }
>
> +static int io_import_fixed_buffer(struct io_kiocb *req, int ddir)
> +{
> +       struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
> +       struct io_async_rw *io;
> +       int ret;
> +
> +       if (!(req->flags & REQ_F_FIXED_BUFFER))
> +               return 0;
> +
> +       io =3D req->async_data;
> +       if (io->bytes_done)
> +               return 0;
> +
> +       ret =3D io_import_fixed(ddir, &io->iter, req->buf_node->buf, rw->=
addr,
> +                             rw->len);
> +       if (ret)
> +               return ret;
> +
> +       iov_iter_save_state(&io->iter, &io->iter_state);
> +       return 0;
> +}
> +
>  int io_read(struct io_kiocb *req, unsigned int issue_flags)
>  {
>         int ret;
>
> +       ret =3D io_import_fixed_buffer(req, READ);
> +       if (unlikely(ret))
> +               return ret;
> +
>         ret =3D __io_read(req, issue_flags);
>         if (ret >=3D 0)
>                 return kiocb_done(req, ret, issue_flags);
> @@ -1062,6 +1077,10 @@ int io_write(struct io_kiocb *req, unsigned int is=
sue_flags)
>         ssize_t ret, ret2;
>         loff_t *ppos;
>
> +       ret =3D io_import_fixed_buffer(req, WRITE);
> +       if (unlikely(ret))
> +               return ret;
> +
>         ret =3D io_rw_init_file(req, FMODE_WRITE, WRITE);
>         if (unlikely(ret))
>                 return ret;
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 8bdf2c9b3fef9..112b49fde23e5 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -200,19 +200,8 @@ int io_uring_cmd_prep(struct io_kiocb *req, const st=
ruct io_uring_sqe *sqe)
>                 return -EINVAL;
>
>         if (ioucmd->flags & IORING_URING_CMD_FIXED) {
> -               struct io_ring_ctx *ctx =3D req->ctx;
> -               struct io_rsrc_node *node;
> -               u16 index =3D READ_ONCE(sqe->buf_index);
> -
> -               node =3D io_rsrc_node_lookup(&ctx->buf_table, index);
> -               if (unlikely(!node))
> -                       return -EFAULT;
> -               /*
> -                * Pi node upfront, prior to io_uring_cmd_import_fixed()
> -                * being called. This prevents destruction of the mapped =
buffer
> -                * we'll need at actual import time.
> -                */
> -               io_req_assign_buf_node(req, node);
> +               req->buf_index =3D READ_ONCE(sqe->buf_index);
> +               req->flags |=3D REQ_F_FIXED_BUFFER;
>         }
>         ioucmd->cmd_op =3D READ_ONCE(sqe->cmd_op);
>
> @@ -262,7 +251,6 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long=
 len, int rw,
>         struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
>         struct io_rsrc_node *node =3D req->buf_node;
>
> -       /* Must have had rsrc_node assigned at prep time */
>         if (node)
>                 return io_import_fixed(rw, iter, node->buf, ubuf, len);

Is it possible for node to be NULL? If the buffer lookup failed,
io_issue_sqe() would have returned early and not called ->issue(), so
this function wouldn't have been called.

Best,
Caleb

>
> --
> 2.43.5
>

