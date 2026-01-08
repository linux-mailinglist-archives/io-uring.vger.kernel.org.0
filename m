Return-Path: <io-uring+bounces-11543-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CAAF6D06651
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 23:07:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 19ADA3032707
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 22:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C203D2D7810;
	Thu,  8 Jan 2026 22:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M7xKlTI0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AB32C3242
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 22:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767909901; cv=none; b=uiG7KLeI5YK1vPR6g7wmn3arSaFytwV22sr3N1GlqBmt54zkD4ban7uf/7sQWrQR6ZeIX67BIAOXIUhkqsgIcH9pf48zgUcKKQ5Pm+xEj52ln8rrjEzq+Bvr2M4/Gdk5IaMDqVCQ2zExBN/aJvIqTXrmVXkjyN7JNXOJ8qa0gmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767909901; c=relaxed/simple;
	bh=sh4y+Vut5ArIy7IU1WqHv8x4w8cGrhgwaBoUeVWhsy4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vANS2EseV4/6zUiViM7sulVPNJcvtEc3JGAKdZ1QiK6Yn5/S122fne1soRfmyqVCVNfwOf2sPc2ZPm42Tsv4QS+7tEUxUzGWOdUN+uPaFJiXTdjaN8oFDCw4NhfrLVKPxkLEo26GJtPCNmPozng7sEHBjiHKG80jYcGNripw7r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M7xKlTI0; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4f34c5f2f98so38290781cf.1
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 14:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767909899; x=1768514699; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0KZWRYjixtz6qB3BJkypbYcHlkVfxFeglnbcsbbNFE=;
        b=M7xKlTI0f3eFK+ZxR3HHim6zre4s+rh/pfGulAQ2OewQQKslYLKASRslxAwH2Rn8KE
         RA1X05lVYJRHt5ip+SaD2mRxDu0QkY9J09QnDJvGT6lSbwnaxFJIxVxUhxI6jtJ4Fx+y
         z79WENmgYHvN4VHC8jrC6sF/9+N2YxqxChzECDcT1tKuK0TKhZYsSaknNcaf47IIPe4y
         PIWDR+G2Eq0PceEh1Aie19woWXy4ebKfl6prC8hvPhZ9z0sbM+o0db0R2oxiIIyIzMsn
         oFPq3y0MOYzJjzsqmoZ+sOFtrqlMkcrEPEPp7pV8FmJ6SyeYlXGqyem5K2RRb/fA6yo0
         I2ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767909899; x=1768514699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l0KZWRYjixtz6qB3BJkypbYcHlkVfxFeglnbcsbbNFE=;
        b=APaY1XPflGFWjLHnjIC3SpQpPYtmE9xEx41H30mbihIa3Ooqij4lNg44tU2jMtn9XV
         sGDMrx+zk5VYIJk/x1nn3U5hrBgeeSOV47ly/KlVVKHWrP1VG6pPGnPPkIgh9/7R+mWB
         gs7fZHpEBPDe9ElaoqPVp5pnQI6xsfllor2lwONFvcax9vFecjmDyLLO3VQttpBdwjjN
         cEePMwtsUIvkcr3+6YguH15GqJLMi4ywrOLc36nVueqOoqkl90nTsYRSdwgZRg2MMKvi
         UCYv+IExoFNWEYYVFbxdt+39dRJT5X1zSsrjP9keG4lM3gfznKTqTbR/goFdmHGn33+C
         UrUg==
X-Forwarded-Encrypted: i=1; AJvYcCX7DpQ5tljvasREAszHjw4QRgOGzhCKlZ4ndPJti5euiATsqPVF+A2JHUYg0zaGP3t80S4owrRZLA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfPIcyeRtzDVwKuvgc+4umiI5shIvoGdMIblG/m9b4vPG/yAmw
	HfBwjR61PS+V7JhqPugMH0+0l3vPMVnEWWO0cseYA8WPZQCI/G94qf+gd/yfZXeyG8bUnk1aGtf
	+N3nd7tbYQxeCxDZ/XtWzDdRh0ZIHiR4=
X-Gm-Gg: AY/fxX7r9OKGDoobLzT/mGCzGCziRhXsOuiHgUpalG4c0au0FyIP9EQdZv/GDLl9K1u
	lOMjE1ydSDPM+If6EZKEUCmKvv73lou5gCWJaZUpwf43wIc1GpKED0glrWnanTECpaYcovBOe09
	khzvSKpPXlP/WAiLhc5DjhovvjzklNYrP5VoLIdk31v8fWFQoT/p8pX76jJU/8lDTAyjwft+5v1
	KT42KOtkDUI0eooD/ACfpkjhASfoZGcg6/TaPKNRzC66bs4v92VwDVirUV19ceCqMVNMA==
X-Google-Smtp-Source: AGHT+IEIr4rKO7n5cQBt6PbdPUMCAKodh3mCOwCgNsomYc1h8wMSZ95iTgZQdoRZ5NO+nmlFamw392K1oD2IZkR0rUs=
X-Received: by 2002:a05:622a:99b:b0:4ee:2721:9ebe with SMTP id
 d75a77b69052e-4ffb49e6755mr113458641cf.53.1767909894414; Thu, 08 Jan 2026
 14:04:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260105210543.3471082-1-csander@purestorage.com>
 <20260105210543.3471082-3-csander@purestorage.com> <CAJnrk1YBQdCgOHG2T_D6wV_94kLLftP_G6sLyocRf2wCLTsweg@mail.gmail.com>
 <CADUfDZqYRgMpRATciSzW+Gha_W-RJiX0RYF0K-RLoT_s3OX5qg@mail.gmail.com>
In-Reply-To: <CADUfDZqYRgMpRATciSzW+Gha_W-RJiX0RYF0K-RLoT_s3OX5qg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 8 Jan 2026 14:04:42 -0800
X-Gm-Features: AQt7F2oafVpheYgFGrHzyNxFcskIJgLJfoBbfF042H59nQ0ZuAov_CYldIeEV0A
Message-ID: <CAJnrk1b_GC9Kh7rxRM1JKdzx+SOEoz_tpvfTu5ouMx_pUYY-kg@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] io_uring/msg_ring: drop unnecessary submitter_task checks
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 11:07=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Wed, Jan 7, 2026 at 8:25=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > On Mon, Jan 5, 2026 at 1:05=E2=80=AFPM Caleb Sander Mateos
> > <csander@purestorage.com> wrote:
> > >
> > > __io_msg_ring_data() checks that the target_ctx isn't
> > > IORING_SETUP_R_DISABLED before calling io_msg_data_remote(), which ca=
lls
> > > io_msg_remote_post(). So submitter_task can't be modified concurrentl=
y
> > > with the read in io_msg_remote_post(). Additionally, submitter_task m=
ust
> > > exist, as io_msg_data_remote() is only called for io_msg_need_remote(=
),
> > > i.e. task_complete is set, which requires IORING_SETUP_DEFER_TASKRUN,
> > > which in turn requires IORING_SETUP_SINGLE_ISSUER. And submitter_task=
 is
> > > assigned in io_uring_create() or io_register_enable_rings() before
> > > enabling any IORING_SETUP_SINGLE_ISSUER io_ring_ctx.
> > > Similarly, io_msg_send_fd() checks IORING_SETUP_R_DISABLED and
> > > io_msg_need_remote() before calling io_msg_fd_remote(). submitter_tas=
k
> > > therefore can't be modified concurrently with the read in
> > > io_msg_fd_remote() and must be non-null.
> > > io_register_enable_rings() can't run concurrently because it's called
> > > from io_uring_register() -> __io_uring_register() with uring_lock hel=
d.
> > > Thus, replace the READ_ONCE() and WRITE_ONCE() of submitter_task with
> > > plain loads and stores. And remove the NULL checks of submitter_task =
in
> > > io_msg_remote_post() and io_msg_fd_remote().
> > >
> > > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > > ---
> > >  io_uring/io_uring.c |  7 +------
> > >  io_uring/msg_ring.c | 18 +++++-------------
> > >  io_uring/register.c |  2 +-
> > >  3 files changed, 7 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > > index ec27fafcb213..b31d88295297 100644
> > > --- a/io_uring/io_uring.c
> > > +++ b/io_uring/io_uring.c
> > > @@ -3663,17 +3663,12 @@ static __cold int io_uring_create(struct io_c=
tx_config *config)
> > >                 ret =3D -EFAULT;
> > >                 goto err;
> > >         }
> > >
> > >         if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
> > > -           && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
> > > -               /*
> > > -                * Unlike io_register_enable_rings(), don't need WRIT=
E_ONCE()
> > > -                * since ctx isn't yet accessible from other tasks
> > > -                */
> > > +           && !(ctx->flags & IORING_SETUP_R_DISABLED))
> > >                 ctx->submitter_task =3D get_task_struct(current);
> > > -       }
> > >
> > >         file =3D io_uring_get_file(ctx);
> > >         if (IS_ERR(file)) {
> > >                 ret =3D PTR_ERR(file);
> > >                 goto err;
> > > diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> > > index 87b4d306cf1b..57ad0085869a 100644
> > > --- a/io_uring/msg_ring.c
> > > +++ b/io_uring/msg_ring.c
> > > @@ -78,26 +78,21 @@ static void io_msg_tw_complete(struct io_tw_req t=
w_req, io_tw_token_t tw)
> > >         io_add_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, req->cq=
e.flags);
> > >         kfree_rcu(req, rcu_head);
> > >         percpu_ref_put(&ctx->refs);
> > >  }
> > >
> > > -static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kio=
cb *req,
> > > +static void io_msg_remote_post(struct io_ring_ctx *ctx, struct io_ki=
ocb *req,
> > >                               int res, u32 cflags, u64 user_data)
> > >  {
> > > -       if (!READ_ONCE(ctx->submitter_task)) {
> > > -               kfree_rcu(req, rcu_head);
> > > -               return -EOWNERDEAD;
> > > -       }
> > >         req->opcode =3D IORING_OP_NOP;
> > >         req->cqe.user_data =3D user_data;
> > >         io_req_set_res(req, res, cflags);
> > >         percpu_ref_get(&ctx->refs);
> > >         req->ctx =3D ctx;
> > >         req->tctx =3D NULL;
> > >         req->io_task_work.func =3D io_msg_tw_complete;
> > >         io_req_task_work_add_remote(req, IOU_F_TWQ_LAZY_WAKE);
> > > -       return 0;
> > >  }
> > >
> > >  static int io_msg_data_remote(struct io_ring_ctx *target_ctx,
> > >                               struct io_msg *msg)
> > >  {
> > > @@ -109,12 +104,12 @@ static int io_msg_data_remote(struct io_ring_ct=
x *target_ctx,
> > >                 return -ENOMEM;
> > >
> > >         if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
> > >                 flags =3D msg->cqe_flags;
> > >
> > > -       return io_msg_remote_post(target_ctx, target, msg->len, flags=
,
> > > -                                       msg->user_data);
> > > +       io_msg_remote_post(target_ctx, target, msg->len, flags, msg->=
user_data);
> > > +       return 0;
> > >  }
> > >
> > >  static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
> > >                               struct io_msg *msg, unsigned int issue_=
flags)
> > >  {
> > > @@ -125,11 +120,11 @@ static int __io_msg_ring_data(struct io_ring_ct=
x *target_ctx,
> > >                 return -EINVAL;
> > >         if (!(msg->flags & IORING_MSG_RING_FLAGS_PASS) && msg->dst_fd=
)
> > >                 return -EINVAL;
> > >         /*
> > >          * Keep IORING_SETUP_R_DISABLED check before submitter_task l=
oad
> > > -        * in io_msg_data_remote() -> io_msg_remote_post()
> > > +        * in io_msg_data_remote() -> io_req_task_work_add_remote()
> > >          */
> > >         if (smp_load_acquire(&target_ctx->flags) & IORING_SETUP_R_DIS=
ABLED)
> > >                 return -EBADFD;
> > >
> > >         if (io_msg_need_remote(target_ctx))
> > > @@ -225,14 +220,11 @@ static void io_msg_tw_fd_complete(struct callba=
ck_head *head)
> > >
> > >  static int io_msg_fd_remote(struct io_kiocb *req)
> > >  {
> > >         struct io_ring_ctx *ctx =3D req->file->private_data;
> > >         struct io_msg *msg =3D io_kiocb_to_cmd(req, struct io_msg);
> > > -       struct task_struct *task =3D READ_ONCE(ctx->submitter_task);
> > > -
> > > -       if (unlikely(!task))
> > > -               return -EOWNERDEAD;
> > > +       struct task_struct *task =3D ctx->submitter_task;
> >
> > Is the if !task check here still needed? in the
> > io_register_enable_rings() logic I see
> >
> > if (ctx->flags & IORING_SETUP_SINGLE_ISSUER && !ctx->submitter_task) {
> >         ctx->submitter_task =3D get_task_struct(current);
> >         ...
> > }
> > and then a few lines below
> > ctx->flags &=3D ~IORING_SETUP_R_DISABLED;
> >
> > but I'm not seeing any memory barrier stuff that prevents these from
> > being reordered.
> >
> > In io_msg_send_fd() I see that we check "if (target_ctx->flags &
> > IORING_SETUP_R_DISABLED) return -EBADFD;" before calling into
> > io_msg_fd_remote() here but if the ctx->submitter_task assignment and
> > IORING_SETUP_R_DISABLED flag clearing logic are reordered, then it
> > seems like this opens a race condition where there could be a null ptr
> > crash when task_work_add() gets called below?
>
> Shouldn't patch 1's switch to use smp_store_release() for the clearing
> of IORING_SETUP_R_DISABLED and smp_load_acquire() for the check of
> IORING_SETUP_R_DISABLED in io_msg_send_fd() ensure the necessary
> ordering? Or am I missing something?
>

Nice, yes, that addresses my concern. I had skipped your changes in patch 1=
.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

Thanks,
Joanne

> Thanks,
> Caleb

