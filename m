Return-Path: <io-uring+bounces-7794-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D6C3AA51B4
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 18:30:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46C8A3A6D2E
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 16:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C302137C37;
	Wed, 30 Apr 2025 16:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ElgW31II"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1106319E97A
	for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 16:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746030631; cv=none; b=tWX71g8dTzhALQFUUyUWgvEw880zK4oDVlQ3fPUllxSgIuxNyrfCdGZ66NChYQ6wYLgnDgz2NRoeSR7GqbdrfOFvLpmF+D0VyhOH524P+c3qRoAPT9G4U/BPhJ6XuxlLY/sPY1adZOpyEddeE0denQRNaG6IlWmEOZBUgauebBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746030631; c=relaxed/simple;
	bh=oQjUgycwXSq6SkvdSFPI7nVp61tVGEpiZTKwlO8cTcs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B9SuFNL3tC8ER1Y5Zyl3wPAELofY7/FyzfT2QohU3c8zi1+VOAYO7e000VlYNU0v/NbZWHC5mexAapz7x0whxpHvzrTnFPJNG2imzBVkrv169doquzXzo1o7W6hPOL18jAnKMtzyJbvXdpH+Ed9/b+tGfpge5sY+pzosIt7xGJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ElgW31II; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-22403c99457so16425ad.3
        for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 09:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1746030628; x=1746635428; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DofSiTMBmY5pAgMuZj9W3vjOJDY4yg7UuqE8Ycn9Q2c=;
        b=ElgW31IIbghIHflli5hwZYCFmloAHfg8NyYGciVqVDkabKmf9kKfKR+u4YtwPwVjdc
         ya/+ReuOJ96eR6oaT+OoxZCNiXQ9KhX594r14PM/zGywO2rMzsUMswl80Xz+9cfybadp
         WyQmYIAQZ45oaX4MURiuTAAhPcgihweJFYKSfqJfUw/zcmrQBNA/M1aHqT/eKKsrp0wJ
         NG+PRmPtp9NCpgsjB4FpGgW5z3zmVJg26/a+3on9Cs2DyVjAcVUNbgsyy7Mm15rDrATV
         Gc6nmLXK0FS+/7mSdZwb71BOvYljiB2DOGtLqn/1hRw6pU7xgyaetyIy+Ndi2733tUGT
         IDOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746030628; x=1746635428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DofSiTMBmY5pAgMuZj9W3vjOJDY4yg7UuqE8Ycn9Q2c=;
        b=q5sRT/jERJcp0Ee2Ev1FE2AfnTXDkkcJm2L9SqpkuuFP6lN/9t+FTLlcfJNVYWRw5u
         WurItXvwKuFOYlZoA7stUFvuP+ScZQF8pMeQZmutBfjb2KwBh/1FHVk0bxMBwrp2mOwv
         7KeuYuwJwdSUP433iZQtcz6amYrE+1bzabQ9jv3bBQdB7L4ODM6GpQbXiNBAwazDeNlE
         mP4ZwaTnXPGrsYmp0EQTdWlLYZQyoix6F/LmBICXpekSWpjn/kchZcgodS+rb7hMn7UM
         OqM74gNZJuIU0zYh2UdULmvAKAYGKYuTqpu2cgkVgMU831uYfA4/BKXLjK6B8OQaRKuw
         em/A==
X-Forwarded-Encrypted: i=1; AJvYcCU0TetLMY0SGsmzpJ+VCYIMLV0TNoSupNj0adnYB7IbJ/rQknAghTlrW4jmNl/UQU/qKaruPSAlPQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzU7rGtS2iqgHZqo+rxxjMq2rA5lXQe8DKQeXdhkuM8p8lTnMQF
	jRFlOYr/IZin3slE9TPlSVQmMS6DTR5vX71/77TRvgQEyCkLg1a/qnTHTIIEIixX8uly569i7yE
	OYmEaZqRVHhmQiciRREtbuttJaJccVnES4ZZ/4w==
X-Gm-Gg: ASbGncsJI5XrC5siuARcgNCPVFprg2BkEH+HOwuavxDt2eLHSZq+y3ukOeovE4JaZ1B
	RPtNk9XLOyoJm3WFdtfapb9ODX5/0w51PihkFEvv67IgOK4DOZy4Qhr4qxdZHypnDj2wvX492Op
	McEVzpR1iEDGN5etgE8vg2
X-Google-Smtp-Source: AGHT+IFhPlXJ3dr4dHz7nD/ls/UhEcsFNOIjJIfHnI1vsJk/uK12XmNfWbgNZ4LnSPQD4H+erpf0rnt8u9cUdeYx69Q=
X-Received: by 2002:a17:903:3c6b:b0:224:13a2:ab9a with SMTP id
 d9443c01a7336-22df57b001amr17468525ad.7.1746030628093; Wed, 30 Apr 2025
 09:30:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428094420.1584420-1-ming.lei@redhat.com> <20250428094420.1584420-7-ming.lei@redhat.com>
 <CADUfDZrFDbYmnm7LEt94UVhn-tqGM6Fnfqvc2fuq8OqQPdNu3Q@mail.gmail.com> <aBJFk0FuWwt9GpC_@fedora>
In-Reply-To: <aBJFk0FuWwt9GpC_@fedora>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 30 Apr 2025 09:30:16 -0700
X-Gm-Features: ATxdqUE3bPhror1fT4Kv4SHKjs9zwuOqvGTjOUKvi2UNh1sGNtR8FGVQhISkoI4
Message-ID: <CADUfDZq=3it0OAaSysHtdQ_+EdMwCNJ38HH1R6EdJM5U3JdkOA@mail.gmail.com>
Subject: Re: [RFC PATCH 6/7] ublk: register buffer to specified io_uring & buf
 index via UBLK_F_AUTO_BUF_REG
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org, 
	Uday Shankar <ushankar@purestorage.com>, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2025 at 8:45=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Mon, Apr 28, 2025 at 05:52:28PM -0700, Caleb Sander Mateos wrote:
> > On Mon, Apr 28, 2025 at 2:45=E2=80=AFAM Ming Lei <ming.lei@redhat.com> =
wrote:
> > >
> > > Add UBLK_F_AUTO_BUF_REG for supporting to register buffer automatical=
ly
> > > to specified io_uring context and buffer index.
> > >
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > ---
> > >  drivers/block/ublk_drv.c      | 56 ++++++++++++++++++++++++++++-----=
--
> > >  include/uapi/linux/ublk_cmd.h | 38 ++++++++++++++++++++++++
> > >  2 files changed, 84 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> > > index 1fd20e481a60..e82618442749 100644
> > > --- a/drivers/block/ublk_drv.c
> > > +++ b/drivers/block/ublk_drv.c
> > > @@ -66,7 +66,8 @@
> > >                 | UBLK_F_USER_COPY \
> > >                 | UBLK_F_ZONED \
> > >                 | UBLK_F_USER_RECOVERY_FAIL_IO \
> > > -               | UBLK_F_UPDATE_SIZE)
> > > +               | UBLK_F_UPDATE_SIZE \
> > > +               | UBLK_F_AUTO_BUF_REG)
> > >
> > >  #define UBLK_F_ALL_RECOVERY_FLAGS (UBLK_F_USER_RECOVERY \
> > >                 | UBLK_F_USER_RECOVERY_REISSUE \
> > > @@ -146,7 +147,10 @@ struct ublk_uring_cmd_pdu {
> > >
> > >  struct ublk_io {
> > >         /* userspace buffer address from io cmd */
> > > -       __u64   addr;
> > > +       union {
> > > +               __u64   addr;
> > > +               struct ublk_auto_buf_reg buf;
> >
> > Maybe add a comment justifying why these fields can overlap? From my
> > understanding, buf is valid iff UBLK_F_AUTO_BUF_REG is set on the
> > ublk_queue and addr is valid iff neither UBLK_F_USER_COPY,
> > UBLK_F_SUPPORT_ZERO_COPY, nor UBLK_F_AUTO_BUF_REG is set.
>
> ->addr is for storing the userspace buffer, which is only used in
> non-zc cases(zc, auto_buf_reg) or user copy case.

Right, could you add a comment to that effect? I think using
overlapping fields is subtle and has the potential to break in the
future if the usage of the fields changes. Documenting the assumptions
clearly would go a long way.

>
> >
> > > +       };
> > >         unsigned int flags;
> > >         int res;
> > >
> > > @@ -626,7 +630,7 @@ static inline bool ublk_support_zero_copy(const s=
truct ublk_queue *ubq)
> > >
> > >  static inline bool ublk_support_auto_buf_reg(const struct ublk_queue=
 *ubq)
> > >  {
> > > -       return false;
> > > +       return ubq->flags & UBLK_F_AUTO_BUF_REG;
> > >  }
> > >
> > >  static inline bool ublk_support_user_copy(const struct ublk_queue *u=
bq)
> > > @@ -1177,6 +1181,16 @@ static inline void __ublk_abort_rq(struct ublk=
_queue *ubq,
> > >                 blk_mq_end_request(rq, BLK_STS_IOERR);
> > >  }
> > >
> > > +
> > > +static inline void ublk_init_auto_buf_reg(const struct ublk_io *io,
> > > +                                         struct io_buf_data *data)
> > > +{
> > > +       data->index =3D io->buf.index;
> > > +       data->ring_fd =3D io->buf.ring_fd;
> > > +       data->has_fd =3D true;
> > > +       data->registered_fd =3D io->buf.flags & UBLK_AUTO_BUF_REGISTE=
RED_RING;
> > > +}
> > > +
> > >  static bool ublk_auto_buf_reg(struct ublk_queue *ubq, struct request=
 *req,
> > >                               struct ublk_io *io, unsigned int issue_=
flags)
> > >  {
> > > @@ -1187,6 +1201,9 @@ static bool ublk_auto_buf_reg(struct ublk_queue=
 *ubq, struct request *req,
> > >         };
> > >         int ret;
> > >
> > > +       if (ublk_support_auto_buf_reg(ubq))
> >
> > This check seems redundant with the check in the caller? Same comment
> > about ublk_auto_buf_unreg(). That would allow you to avoid adding the
> > ubq argument to ublk_auto_buf_unreg().
>
> Yeah, actually I removed one feature which just registers buffer to
> the uring command context, then forget to update the check.
>
> >
> > > +               ublk_init_auto_buf_reg(io, &data);
> > > +
> > >         /* one extra reference is dropped by ublk_io_release */
> > >         ublk_init_req_ref(ubq, req, 2);
> > >         ret =3D io_buffer_register_bvec(io->cmd, &data, issue_flags);
> > > @@ -2045,7 +2062,7 @@ static int ublk_fetch(struct io_uring_cmd *cmd,=
 struct ublk_queue *ubq,
> > >                  */
> > >                 if (!buf_addr && !ublk_need_get_data(ubq))
> > >                         goto out;
> > > -       } else if (buf_addr) {
> > > +       } else if (buf_addr && !ublk_support_auto_buf_reg(ubq)) {
> > >                 /* User copy requires addr to be unset */
> > >                 ret =3D -EINVAL;
> > >                 goto out;
> > > @@ -2058,13 +2075,17 @@ static int ublk_fetch(struct io_uring_cmd *cm=
d, struct ublk_queue *ubq,
> > >         return ret;
> > >  }
> > >
> > > -static void ublk_auto_buf_unreg(struct ublk_io *io, struct io_uring_=
cmd *cmd,
> > > +static void ublk_auto_buf_unreg(const struct ublk_queue *ubq,
> > > +                               struct ublk_io *io, struct io_uring_c=
md *cmd,
> > >                                 struct request *req, unsigned int iss=
ue_flags)
> > >  {
> > >         struct io_buf_data data =3D {
> > >                 .index =3D req->tag,
> > >         };
> > >
> > > +       if (ublk_support_auto_buf_reg(ubq))
> > > +               ublk_init_auto_buf_reg(io, &data);
> > > +
> > >         WARN_ON_ONCE(io_buffer_unregister_bvec(cmd, &data, issue_flag=
s));
> > >         io->flags &=3D ~UBLK_IO_FLAG_AUTO_BUF_REG;
> > >  }
> > > @@ -2088,7 +2109,8 @@ static int ublk_commit_and_fetch(const struct u=
blk_queue *ubq,
> > >                 if (!ub_cmd->addr && (!ublk_need_get_data(ubq) ||
> > >                                         req_op(req) =3D=3D REQ_OP_REA=
D))
> > >                         return -EINVAL;
> > > -       } else if (req_op(req) !=3D REQ_OP_ZONE_APPEND && ub_cmd->add=
r) {
> > > +       } else if ((req_op(req) !=3D REQ_OP_ZONE_APPEND &&
> > > +                               !ublk_support_auto_buf_reg(ubq)) && u=
b_cmd->addr) {
> > >                 /*
> > >                  * User copy requires addr to be unset when command i=
s
> > >                  * not zone append
> > > @@ -2097,7 +2119,7 @@ static int ublk_commit_and_fetch(const struct u=
blk_queue *ubq,
> > >         }
> > >
> > >         if (io->flags & UBLK_IO_FLAG_AUTO_BUF_REG)
> > > -               ublk_auto_buf_unreg(io, cmd, req, issue_flags);
> > > +               ublk_auto_buf_unreg(ubq, io, cmd, req, issue_flags);
> > >
> > >         ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
> > >
> > > @@ -2788,6 +2810,11 @@ static int ublk_ctrl_add_dev(const struct ublk=
srv_ctrl_cmd *header)
> > >         else if (!(info.flags & UBLK_F_UNPRIVILEGED_DEV))
> > >                 return -EPERM;
> > >
> > > +       /* F_AUTO_BUF_REG and F_SUPPORT_ZERO_COPY can't co-exist */
> > > +       if ((info.flags & UBLK_F_AUTO_BUF_REG) &&
> > > +                       (info.flags & UBLK_F_SUPPORT_ZERO_COPY))
> > > +               return -EINVAL;
> > > +
> > >         /* forbid nonsense combinations of recovery flags */
> > >         switch (info.flags & UBLK_F_ALL_RECOVERY_FLAGS) {
> > >         case 0:
> > > @@ -2817,8 +2844,11 @@ static int ublk_ctrl_add_dev(const struct ublk=
srv_ctrl_cmd *header)
> > >                  * For USER_COPY, we depends on userspace to fill req=
uest
> > >                  * buffer by pwrite() to ublk char device, which can'=
t be
> > >                  * used for unprivileged device
> > > +                *
> > > +                * Same with zero copy or auto buffer register.
> > >                  */
> > > -               if (info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_Z=
ERO_COPY))
> > > +               if (info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_Z=
ERO_COPY |
> > > +                                       UBLK_F_AUTO_BUF_REG))
> > >                         return -EINVAL;
> > >         }
> > >
> > > @@ -2876,17 +2906,22 @@ static int ublk_ctrl_add_dev(const struct ubl=
ksrv_ctrl_cmd *header)
> > >                 UBLK_F_URING_CMD_COMP_IN_TASK;
> > >
> > >         /* GET_DATA isn't needed any more with USER_COPY or ZERO COPY=
 */
> > > -       if (ub->dev_info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_Z=
ERO_COPY))
> > > +       if (ub->dev_info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_Z=
ERO_COPY |
> > > +                               UBLK_F_AUTO_BUF_REG))
> > >                 ub->dev_info.flags &=3D ~UBLK_F_NEED_GET_DATA;
> > >
> > >         /*
> > >          * Zoned storage support requires reuse `ublksrv_io_cmd->addr=
` for
> > >          * returning write_append_lba, which is only allowed in case =
of
> > >          * user copy or zero copy
> > > +        *
> > > +        * UBLK_F_AUTO_BUF_REG can't be enabled for zoned because it =
need
> > > +        * the space for getting ring_fd and buffer index.
> > >          */
> > >         if (ublk_dev_is_zoned(ub) &&
> > >             (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) || !(ub->dev_info.flag=
s &
> > > -            (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY)))) {
> > > +            (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY)) ||
> > > +            (ub->dev_info.flags & UBLK_F_AUTO_BUF_REG))) {
> > >                 ret =3D -EINVAL;
> > >                 goto out_free_dev_number;
> > >         }
> > > @@ -3403,6 +3438,7 @@ static int __init ublk_init(void)
> > >
> > >         BUILD_BUG_ON((u64)UBLKSRV_IO_BUF_OFFSET +
> > >                         UBLKSRV_IO_BUF_TOTAL_SIZE < UBLKSRV_IO_BUF_OF=
FSET);
> > > +       BUILD_BUG_ON(sizeof(struct ublk_auto_buf_reg) !=3D sizeof(__u=
64));
> > >
> > >         init_waitqueue_head(&ublk_idr_wq);
> > >
> > > diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_=
cmd.h
> > > index be5c6c6b16e0..3d7c8c69cf06 100644
> > > --- a/include/uapi/linux/ublk_cmd.h
> > > +++ b/include/uapi/linux/ublk_cmd.h
> > > @@ -219,6 +219,30 @@
> > >   */
> > >  #define UBLK_F_UPDATE_SIZE              (1ULL << 10)
> > >
> > > +/*
> > > + * request buffer is registered automatically to ublk server specifi=
ed
> > > + * io_uring context before delivering this io command to ublk server=
,
> > > + * meantime it is un-registered automatically when completing this i=
o
> > > + * command.
> > > + *
> > > + * For using this feature:
> > > + *
> > > + * - ublk server has to create sparse buffer table
> > > + *
> > > + * - pass io_ring context FD from `ublksrv_io_cmd.buf.ring_fd`, and =
the FD
> > > + *   can be registered io_ring FD if `UBLK_AUTO_BUF_REGISTERED_RING`=
 is set
> > > + *   in `ublksrv_io_cmd.flags`, or plain FD
> > > + *
> > > + * - pass buffer index from `ublksrv_io_cmd.buf.index`
> > > + *
> > > + * This way avoids extra cost from two uring_cmd, but also simplifie=
s backend
> > > + * implementation, such as, the dependency on IO_REGISTER_IO_BUF and
> > > + * IO_UNREGISTER_IO_BUF becomes not necessary.
> > > + *
> > > + * This feature isn't available for UBLK_F_ZONED
> > > + */
> > > +#define UBLK_F_AUTO_BUF_REG    (1ULL << 11)
> > > +
> > >  /* device state */
> > >  #define UBLK_S_DEV_DEAD        0
> > >  #define UBLK_S_DEV_LIVE        1
> > > @@ -339,6 +363,14 @@ static inline __u32 ublksrv_get_flags(const stru=
ct ublksrv_io_desc *iod)
> > >         return iod->op_flags >> 8;
> > >  }
> > >
> > > +struct ublk_auto_buf_reg {
> > > +       __s32  ring_fd;
> > > +       __u16  index;
> > > +#define UBLK_AUTO_BUF_REGISTERED_RING            (1 << 0)
> > > +       __u8   flags;
> >
> > The flag could potentially be stored in ublk_io's flags field instead
> > to avoid taking up this byte.
>
> `ublk_auto_buf_reg` takes the exact ->addr space in both 'struct ublk_io'
> and 'struct ublksrv_io_cmd', this way won't take extra byte, but keep cod=
e simple
> and reuse for dealing with auto_buf_reg from both 'struct ublk_io' and
> 'struct ublksrv_io_cmd'.

Sure, either way is fine by me.

Best,
Caleb

