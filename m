Return-Path: <io-uring+bounces-6517-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF2A0A3AA05
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 21:53:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D50F1897495
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 20:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F6A71D6DB1;
	Tue, 18 Feb 2025 20:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Myt10RHN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0265117A313
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 20:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739910747; cv=none; b=Rq/GsF6K9oCSpDp81UznViDi4YZxDg2Wb1kMrFa03iVNNzGV3kyMYsFI/cuSR9Nb7hLeZbDw+2qPtX1Uxw+inOifdnaRDCmi7tjc/Zu7mW+SnXTO9dIcZ/dcfFrPFEL1QTGgCkt4ISrvOI6qIIz1AU5OmX/Z10Vq3vSBlYV5Lrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739910747; c=relaxed/simple;
	bh=ng7PHnSWzxjjTD4UV9cpc2Ik/NmPfuym7FJCo0ggYIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UYSzibdDFukKUH9yR1ynUzt9ObLD+xQvQ9d9/fVDFVG5T2pLjm3GDTLmOpK8eYetZ4iA2hj/2k9EzIVGfYtZyXkpG35UUaMGSZlIHABPOTrnsVmlZeTF/H8qvoW4RnLSvpCC8V494tcd7+W0czx8pNdbyz+cXRiYjYKcLmKVo3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Myt10RHN; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2fc29ac55b5so1124542a91.2
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 12:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739910744; x=1740515544; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5dhYuka/+Mx/dXvX0WJh+W+hns0N58TA+J9CqyJKUc0=;
        b=Myt10RHNY5HzNyMkABJdaVKTgDuEU6JixfwF7DnHTfiVQjh3R8Wx0ha9WRl+i7SdXl
         EDD3PscWVd9D+AVOHxOoqnGfTU+P3HdEc6tk1QTmLxGHGjPhRxYIg4WKb8Yko8dselit
         XOCY232bUORteabzMT147n0n3A16t2U8CoXu0pZEK4IypH6evwXkNczSn9DOw2SwV/mT
         s9xdmrmkh3cksf2dGLOQBFmsYDseqtxtiOb7lVazW51cwqbfYU+Dn6pE0lQrlcBw4qRh
         +0uZiPQSkDphp9OHofnIGSu7TXJBOhuNtYUiggDQ5xd/lQVDGXMhiJUp+ZiT2se6mr01
         vPNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739910744; x=1740515544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5dhYuka/+Mx/dXvX0WJh+W+hns0N58TA+J9CqyJKUc0=;
        b=fJULhIp2EJPqroJxJD27KjtF5YfzaQ+IrORhPWLPU5mD7H+VyeSqHQ+tZBNJgB4CYW
         peq2Aq4ofk7VTzlgckNznije3kRI3OHpwn2F/F/SWP80/tJJ3gdLtA4acCOVFZYLioew
         jaUlgUVnv2w4cUIcsk3+xlODSQtktqBoPpDbX6m+VaLercMRWzVebx89YrFSDc4KomRX
         KbTV209ND7uEh7ENc25q3/JHmtc0l931SfeOqOu8ok+QBBJwGfbL/L6ZTtDS6fg9rH9R
         2I2OtIyow4LEd1GjrZecl4df0Q8T40cwCK1+/MBqpD9mo9DBgEThdf1C28S62vxwhVd9
         U+EQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXzCvO6sO0KRO57WHCdunbgYwxK3XRE04ErbPtYexRcuhNojDSNgyyEVnn2Mb+LPX0NbdKz8OhoA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzhYojjZXwzO5a92cp6mC72218CLePulDcBmQKDeWxhvj/LxHyf
	wraWuHorqLSO2thvYr63DA3XL401a6Pg9PNJoyajVHqCU238XR3S+bhQp9PKPY2P9GeMmWXS+YH
	2f3RwhkKgu1Sl2fGJObJnBChcATIbhc6we7eJYA==
X-Gm-Gg: ASbGncsqfCPrGfmDEHDvacFWvC6fq1zcKJN+w4Ud7lemyV+mLrtE0h6tu1vktjag0Ym
	KKZ/bAYH7//rHwCxqlJlergxq03pSyPnGiz+sHtuv2mVA5TUAhk4Y16vJtXk6R9fPoE/MgY0=
X-Google-Smtp-Source: AGHT+IFN1O6Yk2DsEsk3tpGOBXeMR3j05DG8KhzBZl01q+YTp0QdtDhdOLGo9GRF/h72n8L3zKEmdqNFvP/j1WBU5Y4=
X-Received: by 2002:a17:90b:384a:b0:2ee:cbc9:d50b with SMTP id
 98e67ed59e1d1-2fc4103d1ebmr8955280a91.4.1739910744110; Tue, 18 Feb 2025
 12:32:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250214154348.2952692-1-kbusch@meta.com> <20250214154348.2952692-2-kbusch@meta.com>
In-Reply-To: <20250214154348.2952692-2-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 18 Feb 2025 12:32:12 -0800
X-Gm-Features: AWEUYZm3tS_rHwCaq0FXl4V9wjAgfe_rsO-pTr9Ppgf6rQ5xUEEjHgWsSmVp8MY
Message-ID: <CADUfDZqKrEObsiKKHtGZKLfPZDKW6Y94dL2PWu0v19kbv_T3TQ@mail.gmail.com>
Subject: Re: [PATCHv3 1/5] io_uring: move fixed buffer import to issue path
To: Keith Busch <kbusch@meta.com>
Cc: ming.lei@redhat.com, asml.silence@gmail.com, axboe@kernel.dk, 
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2025 at 7:45=E2=80=AFAM Keith Busch <kbusch@meta.com> wrote=
:
>
> From: Keith Busch <kbusch@kernel.org>
>
> Similiar to the fixed file path, requests may depend on a previous

typo: "Similiar" -> "Similar"

> command to set up an index, so we need to allow linking them. The prep
> callback happens too soon for linked commands, so the lookup needs to be
> defered to the issue path. Change the prep callbacks to just set the

typo: "defered" -> "deferred"

> buf_index and let generic io_uring code handle the fixed buffer node
> setup, just like it does for fixed files.
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
> index e2fef264ff8b8..d5bf336882aa8 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -469,6 +469,7 @@ enum {
>         REQ_F_DOUBLE_POLL_BIT,
>         REQ_F_APOLL_MULTISHOT_BIT,
>         REQ_F_CLEAR_POLLIN_BIT,
> +       REQ_F_FIXED_BUFFER_BIT,
>         /* keep async read/write and isreg together and in order */
>         REQ_F_SUPPORT_NOWAIT_BIT,
>         REQ_F_ISREG_BIT,
> @@ -561,6 +562,8 @@ enum {
>         REQ_F_BUF_NODE          =3D IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
>         /* request has read/write metadata assigned */
>         REQ_F_HAS_METADATA      =3D IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
> +       /* request has a fixed buffer at buf_index */
> +       REQ_F_FIXED_BUFFER      =3D IO_REQ_FLAG(REQ_F_FIXED_BUFFER_BIT),
>  };
>
>  typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_stat=
e *ts);
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 4a0944a57d963..a5be6ec99d153 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1720,6 +1720,23 @@ static bool io_assign_file(struct io_kiocb *req, c=
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
> +       node =3D io_rsrc_node_lookup(&ctx->buf_table.data, req->buf_index=
);

This patch fails to compile on its own:
io_uring/io_uring.c: In function 'io_assign_buffer':
io_uring/io_uring.c:1894:51: error: 'struct io_rsrc_data' has no
member named 'data'
 1894 |         node =3D io_rsrc_node_lookup(&ctx->buf_table.data,
req->buf_index);
      |                                                   ^

The data field appears to be added by the later patch "io_uring: add
abstraction for buf_table rsrc data". Probably .data should be dropped
in this patch and added in the later one instead.

Best,
Caleb

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
> @@ -1728,6 +1745,8 @@ static int io_issue_sqe(struct io_kiocb *req, unsig=
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
> index 10344b3a6d89c..0185925e40bfb 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -1299,6 +1299,10 @@ int io_send_zc_prep(struct io_kiocb *req, const st=
ruct io_uring_sqe *sqe)
>  #endif
>         if (unlikely(!io_msg_alloc_async(req)))
>                 return -ENOMEM;
> +       if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
> +               req->buf_index =3D zc->buf_index;
> +               req->flags |=3D REQ_F_FIXED_BUFFER;
> +       }
>         if (req->opcode !=3D IORING_OP_SENDMSG_ZC)
>                 return io_send_setup(req, sqe);
>         return io_sendmsg_setup(req, sqe);
> @@ -1360,25 +1364,10 @@ static int io_send_zc_import(struct io_kiocb *req=
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
> index 7aa1e4c9f64a3..f37cd883d1625 100644
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
> index 1f6a82128b475..70210b4e0b0f6 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -202,19 +202,8 @@ int io_uring_cmd_prep(struct io_kiocb *req, const st=
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
> @@ -272,7 +261,6 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long=
 len, int rw,
>         struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
>         struct io_rsrc_node *node =3D req->buf_node;
>
> -       /* Must have had rsrc_node assigned at prep time */
>         if (node)
>                 return io_import_fixed(rw, iter, node->buf, ubuf, len);
>
> --
> 2.43.5
>
>

