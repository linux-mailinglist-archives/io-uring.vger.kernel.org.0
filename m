Return-Path: <io-uring+bounces-11442-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BD909D00F6A
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 05:25:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5C4873013EEE
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 04:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A2B8215F5C;
	Thu,  8 Jan 2026 04:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DH9GHjAr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D996A7494
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 04:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767846346; cv=none; b=RReQ9n6kyKpt5P8MzJK2D+sWVz6zBPn81mJ1xbJ6x92q84DdsogmujituzMRCYC3lFLpwO7z+Uo698zAQ6drf1z0MQlFRcQ15L5ko42dUHPDYw2Qwtpf13Bn2sxKTZON7EGo8nHuhZfVTHeqfauEV9sgVngC2QALoU4kuNNdfiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767846346; c=relaxed/simple;
	bh=s74b5qF4mA00vEDsjgkN+eo8i9liUvAxL0Z6v6D0QLQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=keYyJemDghvOAP1QADAavQuRaTnP+vOFc2ik616M4RHPLuoibN6MYe6jLl9ZljYagWdxZbBWD3hngFtWrF+JSbSgSAlbhw3NT+wNWKKhF70XHME0/n5RHmw8CXm3wWpkJC1nHmN4pe14jqjsJlkp0M4pmboAZA4QUTYDYUgPUbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DH9GHjAr; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4eda6a8cc12so30424311cf.0
        for <io-uring@vger.kernel.org>; Wed, 07 Jan 2026 20:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767846344; x=1768451144; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSQ6uLTn+2yGXvcWZUyRTJur49JjSt9QKEYcIVqf5nw=;
        b=DH9GHjArlBkH+5J3bKMpao2jc77TU8GY9hhW1gAhTczcX+0l2xvjxZnq4ixsmJ84O1
         unQHJoxouMsozI6dY3PRNfuoWt2LA/4IYLqMjZXdsroSlKD18Vs4aSl2EFgcbq+DiCaH
         UabuLivGMySlhH32n1+kfX2RmJdaYJlPAzJOoQHF0BD2kEsqI8fqHHf39mKEh814k6E0
         5brsCofo02OJinwaZLMpHvLlKOrw/ySPyADk4ZYQuv301P3B8Vv0Xi9yMw9+P9VxLHso
         PZPgiT0HrexH6lyHApg2wtnjbiZWeHEZ9Fdzkz5Kq2oUpqzWV3Amqa9fniGqcMLGMeRk
         kdZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767846344; x=1768451144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bSQ6uLTn+2yGXvcWZUyRTJur49JjSt9QKEYcIVqf5nw=;
        b=Mw36uUsCEfl3C2cHymG7BhizBGBT5UI0uKqCY1zq+9gehfH4If/EV19EwTLAySt16Y
         d5KHJrKu3ZRDvvWojTP+/oDTqjYTrhshw1VHOh70CApKM8rWyqCdTPpU+7whweN+RTAX
         ixvF/OYenv/ISbnouyI6pKVCZl9RNDArPGeUYa0qxcg9QTSVlc2VVbIwWG2baDcyhkEv
         vfivaVghhBVpAm0XCJUvDv/R5uDj23ITl2/Xmi3+jRYJm/uk5TX9Cch+bxhyfjy1lONU
         BEE4AouEYhz0JjRnf2Ar+qr0z67kieLO+IfoZ9xiXGlc3lUaNreJBabVn76SvOUJATOE
         Uqeg==
X-Forwarded-Encrypted: i=1; AJvYcCVVzfkluhHFJzi48WKHHo0wJXnadtOpcK0cnI3rWiKtE7sAheFJKwdsSTA/yvOlgERbImoTSBboxg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf/JDpgBivdjwYzyngCXyenorDzy176pXRaBK00786PJxt/64p
	Ifk5Y4AFlFAbZSWdpryOOc9MURmQ6QfcxIgWhU3DKUleKVVOPnWURBGIS4vof28vnLdov/5cnln
	EEhauadUsvheUGooXO0xh3V4NUT5lUtg=
X-Gm-Gg: AY/fxX52LKBXu1Fq7+u4Hj0nt5x3ALgHLePVtJ8OCD07dO+eWfNHQEw88tTCydw1EnE
	1LIDH7lm7m1O2Kpy0T+LT9iCHhu5im82On8lt+DECFHrd/b2NYCPQoEMwqd+dr+n7AuVBPWYl/I
	8sDEDprdtvBZDp/HnlkWf9hPmMvejOuYmNfNUbJ8DTEFS3uLWpU/2NW2FYnwXeNxdBCoPnuUztW
	ZgVHUEGiDwlLklulBbCbAhIxJm61g9JLMzMcC28dj4ES92zRmSM5SjTs1qOGyXyupuKgA==
X-Google-Smtp-Source: AGHT+IFPLDCW8/HAE4ow/tOxx6Sk4P8EPksTPUKIZa9iNaxJTwXj7i1Qi+yyd8tHkQLWNh5vRzXHZ6htXEC/H03dwUQ=
X-Received: by 2002:a05:622a:4888:b0:4f1:cce7:bd4e with SMTP id
 d75a77b69052e-4ffb48b807dmr65706571cf.7.1767846343710; Wed, 07 Jan 2026
 20:25:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260105210543.3471082-1-csander@purestorage.com> <20260105210543.3471082-3-csander@purestorage.com>
In-Reply-To: <20260105210543.3471082-3-csander@purestorage.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 7 Jan 2026 20:25:32 -0800
X-Gm-Features: AQt7F2p2FMGY9acuzKLRcD-qg0N5X_kUuTU4zA0um6ehrxxp6irBGAg-a_BPCHc
Message-ID: <CAJnrk1YBQdCgOHG2T_D6wV_94kLLftP_G6sLyocRf2wCLTsweg@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] io_uring/msg_ring: drop unnecessary submitter_task checks
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 1:05=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> __io_msg_ring_data() checks that the target_ctx isn't
> IORING_SETUP_R_DISABLED before calling io_msg_data_remote(), which calls
> io_msg_remote_post(). So submitter_task can't be modified concurrently
> with the read in io_msg_remote_post(). Additionally, submitter_task must
> exist, as io_msg_data_remote() is only called for io_msg_need_remote(),
> i.e. task_complete is set, which requires IORING_SETUP_DEFER_TASKRUN,
> which in turn requires IORING_SETUP_SINGLE_ISSUER. And submitter_task is
> assigned in io_uring_create() or io_register_enable_rings() before
> enabling any IORING_SETUP_SINGLE_ISSUER io_ring_ctx.
> Similarly, io_msg_send_fd() checks IORING_SETUP_R_DISABLED and
> io_msg_need_remote() before calling io_msg_fd_remote(). submitter_task
> therefore can't be modified concurrently with the read in
> io_msg_fd_remote() and must be non-null.
> io_register_enable_rings() can't run concurrently because it's called
> from io_uring_register() -> __io_uring_register() with uring_lock held.
> Thus, replace the READ_ONCE() and WRITE_ONCE() of submitter_task with
> plain loads and stores. And remove the NULL checks of submitter_task in
> io_msg_remote_post() and io_msg_fd_remote().
>
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  io_uring/io_uring.c |  7 +------
>  io_uring/msg_ring.c | 18 +++++-------------
>  io_uring/register.c |  2 +-
>  3 files changed, 7 insertions(+), 20 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index ec27fafcb213..b31d88295297 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3663,17 +3663,12 @@ static __cold int io_uring_create(struct io_ctx_c=
onfig *config)
>                 ret =3D -EFAULT;
>                 goto err;
>         }
>
>         if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
> -           && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
> -               /*
> -                * Unlike io_register_enable_rings(), don't need WRITE_ON=
CE()
> -                * since ctx isn't yet accessible from other tasks
> -                */
> +           && !(ctx->flags & IORING_SETUP_R_DISABLED))
>                 ctx->submitter_task =3D get_task_struct(current);
> -       }
>
>         file =3D io_uring_get_file(ctx);
>         if (IS_ERR(file)) {
>                 ret =3D PTR_ERR(file);
>                 goto err;
> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> index 87b4d306cf1b..57ad0085869a 100644
> --- a/io_uring/msg_ring.c
> +++ b/io_uring/msg_ring.c
> @@ -78,26 +78,21 @@ static void io_msg_tw_complete(struct io_tw_req tw_re=
q, io_tw_token_t tw)
>         io_add_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, req->cqe.fl=
ags);
>         kfree_rcu(req, rcu_head);
>         percpu_ref_put(&ctx->refs);
>  }
>
> -static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *=
req,
> +static void io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb =
*req,
>                               int res, u32 cflags, u64 user_data)
>  {
> -       if (!READ_ONCE(ctx->submitter_task)) {
> -               kfree_rcu(req, rcu_head);
> -               return -EOWNERDEAD;
> -       }
>         req->opcode =3D IORING_OP_NOP;
>         req->cqe.user_data =3D user_data;
>         io_req_set_res(req, res, cflags);
>         percpu_ref_get(&ctx->refs);
>         req->ctx =3D ctx;
>         req->tctx =3D NULL;
>         req->io_task_work.func =3D io_msg_tw_complete;
>         io_req_task_work_add_remote(req, IOU_F_TWQ_LAZY_WAKE);
> -       return 0;
>  }
>
>  static int io_msg_data_remote(struct io_ring_ctx *target_ctx,
>                               struct io_msg *msg)
>  {
> @@ -109,12 +104,12 @@ static int io_msg_data_remote(struct io_ring_ctx *t=
arget_ctx,
>                 return -ENOMEM;
>
>         if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
>                 flags =3D msg->cqe_flags;
>
> -       return io_msg_remote_post(target_ctx, target, msg->len, flags,
> -                                       msg->user_data);
> +       io_msg_remote_post(target_ctx, target, msg->len, flags, msg->user=
_data);
> +       return 0;
>  }
>
>  static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
>                               struct io_msg *msg, unsigned int issue_flag=
s)
>  {
> @@ -125,11 +120,11 @@ static int __io_msg_ring_data(struct io_ring_ctx *t=
arget_ctx,
>                 return -EINVAL;
>         if (!(msg->flags & IORING_MSG_RING_FLAGS_PASS) && msg->dst_fd)
>                 return -EINVAL;
>         /*
>          * Keep IORING_SETUP_R_DISABLED check before submitter_task load
> -        * in io_msg_data_remote() -> io_msg_remote_post()
> +        * in io_msg_data_remote() -> io_req_task_work_add_remote()
>          */
>         if (smp_load_acquire(&target_ctx->flags) & IORING_SETUP_R_DISABLE=
D)
>                 return -EBADFD;
>
>         if (io_msg_need_remote(target_ctx))
> @@ -225,14 +220,11 @@ static void io_msg_tw_fd_complete(struct callback_h=
ead *head)
>
>  static int io_msg_fd_remote(struct io_kiocb *req)
>  {
>         struct io_ring_ctx *ctx =3D req->file->private_data;
>         struct io_msg *msg =3D io_kiocb_to_cmd(req, struct io_msg);
> -       struct task_struct *task =3D READ_ONCE(ctx->submitter_task);
> -
> -       if (unlikely(!task))
> -               return -EOWNERDEAD;
> +       struct task_struct *task =3D ctx->submitter_task;

Is the if !task check here still needed? in the
io_register_enable_rings() logic I see

if (ctx->flags & IORING_SETUP_SINGLE_ISSUER && !ctx->submitter_task) {
        ctx->submitter_task =3D get_task_struct(current);
        ...
}
and then a few lines below
ctx->flags &=3D ~IORING_SETUP_R_DISABLED;

but I'm not seeing any memory barrier stuff that prevents these from
being reordered.

In io_msg_send_fd() I see that we check "if (target_ctx->flags &
IORING_SETUP_R_DISABLED) return -EBADFD;" before calling into
io_msg_fd_remote() here but if the ctx->submitter_task assignment and
IORING_SETUP_R_DISABLED flag clearing logic are reordered, then it
seems like this opens a race condition where there could be a null ptr
crash when task_work_add() gets called below?

Thanks,
Joanne

>
>         init_task_work(&msg->tw, io_msg_tw_fd_complete);
>         if (task_work_add(task, &msg->tw, TWA_SIGNAL))
>                 return -EOWNERDEAD;
>
> diff --git a/io_uring/register.c b/io_uring/register.c
> index 12318c276068..8104728af294 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -179,11 +179,11 @@ static int io_register_enable_rings(struct io_ring_=
ctx *ctx)
>  {
>         if (!(ctx->flags & IORING_SETUP_R_DISABLED))
>                 return -EBADFD;
>
>         if (ctx->flags & IORING_SETUP_SINGLE_ISSUER && !ctx->submitter_ta=
sk) {
> -               WRITE_ONCE(ctx->submitter_task, get_task_struct(current))=
;
> +               ctx->submitter_task =3D get_task_struct(current);
>                 /*
>                  * Lazy activation attempts would fail if it was polled b=
efore
>                  * submitter_task is set.
>                  */
>                 if (wq_has_sleeper(&ctx->poll_wq))
> --
> 2.45.2
>

