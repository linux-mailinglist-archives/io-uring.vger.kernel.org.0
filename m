Return-Path: <io-uring+bounces-11444-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A31D0157A
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F103D300889D
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E94F9239E80;
	Thu,  8 Jan 2026 07:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Gc/hznHP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1744B22097
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 07:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767856025; cv=none; b=obxgFgoH12x1YmGPeWmDy+nhiIicbAsK807n2DecwQov6DWwbT3t45YX2wC8b3L14jkQ3c5y0UpktMyheI9qxcX0mVeOGlUYfXy2kTdQhfYkl9V1d2jFULJrLXQGGVUXcsQfsN+GXmHJeMkN3h/fXkzrS8wYRfgWV54/HLec4MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767856025; c=relaxed/simple;
	bh=iYhUwMe0Sk8rm8N8c9ec2+TXBN25qmKxc9tbIyK3ZyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jIbfRBb+LxuTHbOmTnk2Yw2AhOGPeVqaSIoTpRuRB6wv4WOY0b8b4ZZ9cXeoMMKeem+0K/vMf2Gs1raLmd4k3l/IYOJtQG+iGnW0ohJVzOW1hEKl0dwxFgQ9yRbDI4hjebAbwNu6TXktLL35KJZgBfwQh5BD/OKH59RYEYfStPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Gc/hznHP; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-11bba84006dso249816c88.2
        for <io-uring@vger.kernel.org>; Wed, 07 Jan 2026 23:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767856022; x=1768460822; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HfaBcy8tb5KfvL9qS1tptXYCuks8r8SRbJn5dBFC3zc=;
        b=Gc/hznHP/t90XDrVG/7rtNC8+FFCF+LiXyNkFNMx/OAIlTF92QgHzLi89yeeSdPeMP
         cXiQLUyzrEoSzimB85/Y2CtX7391AWmeK8RCShEkjrBMvF3I3HRNDW2/uUY8y6uZE0Q/
         pc8qfrQ01tI00EpGvfyHwqkkCHnvk8LGLHTYHlIrT4KtWJ/G9kiDdAl0vt0+1PRz7yFZ
         kF8hspiBmY6esOrTifQ6TyfbE+KxiSgP7Qc38nSaW0x7jkH/R4nhI8BlWizLypAjledV
         HqNSsTU1Zupg1NDqd5xMAKOGQcQz2VvQ7XeFZiBUcNVCcRPCsivIOrXUrYJz8mArHi+t
         4uLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767856022; x=1768460822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HfaBcy8tb5KfvL9qS1tptXYCuks8r8SRbJn5dBFC3zc=;
        b=QJD5SUQqCbTwcmXdBKe8UgbSFJ9VoA2vegN1ZQkFGM9/5PzYlHBzfcGw6BV88gyx1x
         FPB2kmDfTzaBL36KP1nASJpTpql4wiejpCZruodtOr1Lmyl/zbQJ7+ETYXyCX83TPW0t
         Dml3pAxbBnH1bmUtTfWZF5/qhYSalHbS5bg9ybN44MwX5kUoomwJr+w01RyL5pU37yKB
         XOiQly+IXPZIXvPMhfXHsjUz41q0I3NTfIAogagYByLlfx6XapBwgfShyYBRVj6I1lON
         1Gfqpk64S6zOsg9w+iU+taCr7MSAzd50EmLaXIvIPrQPLz331QNKbrii5rkKRcJ36bYc
         oVYA==
X-Forwarded-Encrypted: i=1; AJvYcCUxsUII1w81I7trVP2XTuq5m2NTTZnfLq46AbFHeVvAku/OUVVeFY/4DN5Zrz2WUCTQgOE/aZ6v3w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMAl2Isxus7Bqb77d1aohD79N9V4PgN/z1jAPoyFxeHKsdBC+z
	l0IJwmc0JuIjGL1U7t14/qJIB53qJnVuDAU6UbsyYJTj8Yal4+RnMhAEedzBWfTMPaOe0fJdipD
	NhLSq1YcwysJT/K4du+SVFbXp2MhptFbfP5mre2hOSfgZ8dzz6tFFR3s=
X-Gm-Gg: AY/fxX79Ce/owmGjO8JnXo6pxwTYeo4Cruy8av7a4/nn7//aaS6yp58HRUFb1oUKXEq
	TKxZ2XLN77nUZPwYyvnKtgN+PUhQHrJT2TZm1M6wkcVNJkq2MJpc5xETlNkG65nxOI/m1evTqmJ
	AB0yAORW7JpH54riAMSdTCohxtmt93qoqhPTfTzSkbYeNKgYilVZFuJJ/GJ/gLaV0N3Z1NFupYx
	fOL8PM7Gn20yN8iofwOcWduS8BT887dnzXVqG9N2DKMMMN2wXYERRN3bucdMz4ggHM4VfVh
X-Google-Smtp-Source: AGHT+IEYasnyDaYZATTTmpxZBR2V8l9ev4wpn02pLGPoxQcsfHUWeNXhenE4Q+jmy13IuN2ycTn+Gez/3N7H1mlErHM=
X-Received: by 2002:a05:7022:f415:b0:119:e56b:46b6 with SMTP id
 a92af1059eb24-121f8a30d8emr2507084c88.0.1767856021944; Wed, 07 Jan 2026
 23:07:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260105210543.3471082-1-csander@purestorage.com>
 <20260105210543.3471082-3-csander@purestorage.com> <CAJnrk1YBQdCgOHG2T_D6wV_94kLLftP_G6sLyocRf2wCLTsweg@mail.gmail.com>
In-Reply-To: <CAJnrk1YBQdCgOHG2T_D6wV_94kLLftP_G6sLyocRf2wCLTsweg@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 7 Jan 2026 23:06:50 -0800
X-Gm-Features: AQt7F2rjv1UO5kt6yQ38qsN73qFLG4Oyqa0CxL7aeS4Gqsz7ZNIv5SEz6dApqEU
Message-ID: <CADUfDZqYRgMpRATciSzW+Gha_W-RJiX0RYF0K-RLoT_s3OX5qg@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] io_uring/msg_ring: drop unnecessary submitter_task checks
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 8:25=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> On Mon, Jan 5, 2026 at 1:05=E2=80=AFPM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > __io_msg_ring_data() checks that the target_ctx isn't
> > IORING_SETUP_R_DISABLED before calling io_msg_data_remote(), which call=
s
> > io_msg_remote_post(). So submitter_task can't be modified concurrently
> > with the read in io_msg_remote_post(). Additionally, submitter_task mus=
t
> > exist, as io_msg_data_remote() is only called for io_msg_need_remote(),
> > i.e. task_complete is set, which requires IORING_SETUP_DEFER_TASKRUN,
> > which in turn requires IORING_SETUP_SINGLE_ISSUER. And submitter_task i=
s
> > assigned in io_uring_create() or io_register_enable_rings() before
> > enabling any IORING_SETUP_SINGLE_ISSUER io_ring_ctx.
> > Similarly, io_msg_send_fd() checks IORING_SETUP_R_DISABLED and
> > io_msg_need_remote() before calling io_msg_fd_remote(). submitter_task
> > therefore can't be modified concurrently with the read in
> > io_msg_fd_remote() and must be non-null.
> > io_register_enable_rings() can't run concurrently because it's called
> > from io_uring_register() -> __io_uring_register() with uring_lock held.
> > Thus, replace the READ_ONCE() and WRITE_ONCE() of submitter_task with
> > plain loads and stores. And remove the NULL checks of submitter_task in
> > io_msg_remote_post() and io_msg_fd_remote().
> >
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > ---
> >  io_uring/io_uring.c |  7 +------
> >  io_uring/msg_ring.c | 18 +++++-------------
> >  io_uring/register.c |  2 +-
> >  3 files changed, 7 insertions(+), 20 deletions(-)
> >
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index ec27fafcb213..b31d88295297 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -3663,17 +3663,12 @@ static __cold int io_uring_create(struct io_ctx=
_config *config)
> >                 ret =3D -EFAULT;
> >                 goto err;
> >         }
> >
> >         if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
> > -           && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
> > -               /*
> > -                * Unlike io_register_enable_rings(), don't need WRITE_=
ONCE()
> > -                * since ctx isn't yet accessible from other tasks
> > -                */
> > +           && !(ctx->flags & IORING_SETUP_R_DISABLED))
> >                 ctx->submitter_task =3D get_task_struct(current);
> > -       }
> >
> >         file =3D io_uring_get_file(ctx);
> >         if (IS_ERR(file)) {
> >                 ret =3D PTR_ERR(file);
> >                 goto err;
> > diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> > index 87b4d306cf1b..57ad0085869a 100644
> > --- a/io_uring/msg_ring.c
> > +++ b/io_uring/msg_ring.c
> > @@ -78,26 +78,21 @@ static void io_msg_tw_complete(struct io_tw_req tw_=
req, io_tw_token_t tw)
> >         io_add_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, req->cqe.=
flags);
> >         kfree_rcu(req, rcu_head);
> >         percpu_ref_put(&ctx->refs);
> >  }
> >
> > -static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb=
 *req,
> > +static void io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kioc=
b *req,
> >                               int res, u32 cflags, u64 user_data)
> >  {
> > -       if (!READ_ONCE(ctx->submitter_task)) {
> > -               kfree_rcu(req, rcu_head);
> > -               return -EOWNERDEAD;
> > -       }
> >         req->opcode =3D IORING_OP_NOP;
> >         req->cqe.user_data =3D user_data;
> >         io_req_set_res(req, res, cflags);
> >         percpu_ref_get(&ctx->refs);
> >         req->ctx =3D ctx;
> >         req->tctx =3D NULL;
> >         req->io_task_work.func =3D io_msg_tw_complete;
> >         io_req_task_work_add_remote(req, IOU_F_TWQ_LAZY_WAKE);
> > -       return 0;
> >  }
> >
> >  static int io_msg_data_remote(struct io_ring_ctx *target_ctx,
> >                               struct io_msg *msg)
> >  {
> > @@ -109,12 +104,12 @@ static int io_msg_data_remote(struct io_ring_ctx =
*target_ctx,
> >                 return -ENOMEM;
> >
> >         if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
> >                 flags =3D msg->cqe_flags;
> >
> > -       return io_msg_remote_post(target_ctx, target, msg->len, flags,
> > -                                       msg->user_data);
> > +       io_msg_remote_post(target_ctx, target, msg->len, flags, msg->us=
er_data);
> > +       return 0;
> >  }
> >
> >  static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
> >                               struct io_msg *msg, unsigned int issue_fl=
ags)
> >  {
> > @@ -125,11 +120,11 @@ static int __io_msg_ring_data(struct io_ring_ctx =
*target_ctx,
> >                 return -EINVAL;
> >         if (!(msg->flags & IORING_MSG_RING_FLAGS_PASS) && msg->dst_fd)
> >                 return -EINVAL;
> >         /*
> >          * Keep IORING_SETUP_R_DISABLED check before submitter_task loa=
d
> > -        * in io_msg_data_remote() -> io_msg_remote_post()
> > +        * in io_msg_data_remote() -> io_req_task_work_add_remote()
> >          */
> >         if (smp_load_acquire(&target_ctx->flags) & IORING_SETUP_R_DISAB=
LED)
> >                 return -EBADFD;
> >
> >         if (io_msg_need_remote(target_ctx))
> > @@ -225,14 +220,11 @@ static void io_msg_tw_fd_complete(struct callback=
_head *head)
> >
> >  static int io_msg_fd_remote(struct io_kiocb *req)
> >  {
> >         struct io_ring_ctx *ctx =3D req->file->private_data;
> >         struct io_msg *msg =3D io_kiocb_to_cmd(req, struct io_msg);
> > -       struct task_struct *task =3D READ_ONCE(ctx->submitter_task);
> > -
> > -       if (unlikely(!task))
> > -               return -EOWNERDEAD;
> > +       struct task_struct *task =3D ctx->submitter_task;
>
> Is the if !task check here still needed? in the
> io_register_enable_rings() logic I see
>
> if (ctx->flags & IORING_SETUP_SINGLE_ISSUER && !ctx->submitter_task) {
>         ctx->submitter_task =3D get_task_struct(current);
>         ...
> }
> and then a few lines below
> ctx->flags &=3D ~IORING_SETUP_R_DISABLED;
>
> but I'm not seeing any memory barrier stuff that prevents these from
> being reordered.
>
> In io_msg_send_fd() I see that we check "if (target_ctx->flags &
> IORING_SETUP_R_DISABLED) return -EBADFD;" before calling into
> io_msg_fd_remote() here but if the ctx->submitter_task assignment and
> IORING_SETUP_R_DISABLED flag clearing logic are reordered, then it
> seems like this opens a race condition where there could be a null ptr
> crash when task_work_add() gets called below?

Shouldn't patch 1's switch to use smp_store_release() for the clearing
of IORING_SETUP_R_DISABLED and smp_load_acquire() for the check of
IORING_SETUP_R_DISABLED in io_msg_send_fd() ensure the necessary
ordering? Or am I missing something?

Thanks,
Caleb

