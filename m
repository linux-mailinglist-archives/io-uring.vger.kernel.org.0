Return-Path: <io-uring+bounces-7792-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA7CAA50A6
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 17:45:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 769C14A05DE
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 15:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A6EF213E61;
	Wed, 30 Apr 2025 15:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PIsDFk41"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE5717C208
	for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 15:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746027940; cv=none; b=HAJh+ACHYEw2xPaM4iOUF1ORrlSt77i0o+89TmcBXdQflJi8YYe8qyxXA0woFaBHJ6VBmZOlixruzxGmUDq6pwDZPDEq8NljJAYa7R/FLymfMd9otlnMq7d6ovfvcNy1iGnoxXLqFFXs/H44Zr0tZ/AsVZgGz03V2/V+viiQY2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746027940; c=relaxed/simple;
	bh=RyGVPkWYS+/VV1uZ+cR/9FQvC7S8InZgmsAcvPNs368=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lwn/L88ncGexsPLceI/bsRUcRBsoKosKyXQfYqUkZ7i7aHp1C5a8PuZg3ACSVR/XeCCwvUyRmXZQrF7+IvSJiT368+RayqHrBAMq9+ElDgsGmvp5rnW6RYIqTAIuJTLGODK+VuC6p+59UyYUd/b1X8Cy3+g8rdthO9p5ygiuCi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PIsDFk41; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746027937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AkxAQ8Ac1h09FrUsrv0c5VWKxJ0IZI6QzEiN6TIA6DQ=;
	b=PIsDFk41+aOuAwG9oIVajB79/59mQ6gX8Kz/f1HdDm/aU2DpIcTM8B26n3BX2eUxoU4KTK
	9GnooMKridhixMfw/MGXzxTuUwEcZHvjqxcVAQSHvi14UyMhIn8U4lh/TFC5eNpULUiNae
	n6F58lHUeiyumz1MQ3wp/gO25CtIws0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-xmyxc27tMJWu9u0QskiE1g-1; Wed,
 30 Apr 2025 11:45:33 -0400
X-MC-Unique: xmyxc27tMJWu9u0QskiE1g-1
X-Mimecast-MFC-AGG-ID: xmyxc27tMJWu9u0QskiE1g_1746027932
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B26819560B2;
	Wed, 30 Apr 2025 15:45:32 +0000 (UTC)
Received: from fedora (unknown [10.72.116.59])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D791230002C2;
	Wed, 30 Apr 2025 15:45:27 +0000 (UTC)
Date: Wed, 30 Apr 2025 23:45:23 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH 6/7] ublk: register buffer to specified io_uring &
 buf index via UBLK_F_AUTO_BUF_REG
Message-ID: <aBJFk0FuWwt9GpC_@fedora>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
 <20250428094420.1584420-7-ming.lei@redhat.com>
 <CADUfDZrFDbYmnm7LEt94UVhn-tqGM6Fnfqvc2fuq8OqQPdNu3Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZrFDbYmnm7LEt94UVhn-tqGM6Fnfqvc2fuq8OqQPdNu3Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Apr 28, 2025 at 05:52:28PM -0700, Caleb Sander Mateos wrote:
> On Mon, Apr 28, 2025 at 2:45 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > Add UBLK_F_AUTO_BUF_REG for supporting to register buffer automatically
> > to specified io_uring context and buffer index.
> >
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/block/ublk_drv.c      | 56 ++++++++++++++++++++++++++++-------
> >  include/uapi/linux/ublk_cmd.h | 38 ++++++++++++++++++++++++
> >  2 files changed, 84 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> > index 1fd20e481a60..e82618442749 100644
> > --- a/drivers/block/ublk_drv.c
> > +++ b/drivers/block/ublk_drv.c
> > @@ -66,7 +66,8 @@
> >                 | UBLK_F_USER_COPY \
> >                 | UBLK_F_ZONED \
> >                 | UBLK_F_USER_RECOVERY_FAIL_IO \
> > -               | UBLK_F_UPDATE_SIZE)
> > +               | UBLK_F_UPDATE_SIZE \
> > +               | UBLK_F_AUTO_BUF_REG)
> >
> >  #define UBLK_F_ALL_RECOVERY_FLAGS (UBLK_F_USER_RECOVERY \
> >                 | UBLK_F_USER_RECOVERY_REISSUE \
> > @@ -146,7 +147,10 @@ struct ublk_uring_cmd_pdu {
> >
> >  struct ublk_io {
> >         /* userspace buffer address from io cmd */
> > -       __u64   addr;
> > +       union {
> > +               __u64   addr;
> > +               struct ublk_auto_buf_reg buf;
> 
> Maybe add a comment justifying why these fields can overlap? From my
> understanding, buf is valid iff UBLK_F_AUTO_BUF_REG is set on the
> ublk_queue and addr is valid iff neither UBLK_F_USER_COPY,
> UBLK_F_SUPPORT_ZERO_COPY, nor UBLK_F_AUTO_BUF_REG is set.

->addr is for storing the userspace buffer, which is only used in
non-zc cases(zc, auto_buf_reg) or user copy case.

> 
> > +       };
> >         unsigned int flags;
> >         int res;
> >
> > @@ -626,7 +630,7 @@ static inline bool ublk_support_zero_copy(const struct ublk_queue *ubq)
> >
> >  static inline bool ublk_support_auto_buf_reg(const struct ublk_queue *ubq)
> >  {
> > -       return false;
> > +       return ubq->flags & UBLK_F_AUTO_BUF_REG;
> >  }
> >
> >  static inline bool ublk_support_user_copy(const struct ublk_queue *ubq)
> > @@ -1177,6 +1181,16 @@ static inline void __ublk_abort_rq(struct ublk_queue *ubq,
> >                 blk_mq_end_request(rq, BLK_STS_IOERR);
> >  }
> >
> > +
> > +static inline void ublk_init_auto_buf_reg(const struct ublk_io *io,
> > +                                         struct io_buf_data *data)
> > +{
> > +       data->index = io->buf.index;
> > +       data->ring_fd = io->buf.ring_fd;
> > +       data->has_fd = true;
> > +       data->registered_fd = io->buf.flags & UBLK_AUTO_BUF_REGISTERED_RING;
> > +}
> > +
> >  static bool ublk_auto_buf_reg(struct ublk_queue *ubq, struct request *req,
> >                               struct ublk_io *io, unsigned int issue_flags)
> >  {
> > @@ -1187,6 +1201,9 @@ static bool ublk_auto_buf_reg(struct ublk_queue *ubq, struct request *req,
> >         };
> >         int ret;
> >
> > +       if (ublk_support_auto_buf_reg(ubq))
> 
> This check seems redundant with the check in the caller? Same comment
> about ublk_auto_buf_unreg(). That would allow you to avoid adding the
> ubq argument to ublk_auto_buf_unreg().

Yeah, actually I removed one feature which just registers buffer to
the uring command context, then forget to update the check.

> 
> > +               ublk_init_auto_buf_reg(io, &data);
> > +
> >         /* one extra reference is dropped by ublk_io_release */
> >         ublk_init_req_ref(ubq, req, 2);
> >         ret = io_buffer_register_bvec(io->cmd, &data, issue_flags);
> > @@ -2045,7 +2062,7 @@ static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_queue *ubq,
> >                  */
> >                 if (!buf_addr && !ublk_need_get_data(ubq))
> >                         goto out;
> > -       } else if (buf_addr) {
> > +       } else if (buf_addr && !ublk_support_auto_buf_reg(ubq)) {
> >                 /* User copy requires addr to be unset */
> >                 ret = -EINVAL;
> >                 goto out;
> > @@ -2058,13 +2075,17 @@ static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_queue *ubq,
> >         return ret;
> >  }
> >
> > -static void ublk_auto_buf_unreg(struct ublk_io *io, struct io_uring_cmd *cmd,
> > +static void ublk_auto_buf_unreg(const struct ublk_queue *ubq,
> > +                               struct ublk_io *io, struct io_uring_cmd *cmd,
> >                                 struct request *req, unsigned int issue_flags)
> >  {
> >         struct io_buf_data data = {
> >                 .index = req->tag,
> >         };
> >
> > +       if (ublk_support_auto_buf_reg(ubq))
> > +               ublk_init_auto_buf_reg(io, &data);
> > +
> >         WARN_ON_ONCE(io_buffer_unregister_bvec(cmd, &data, issue_flags));
> >         io->flags &= ~UBLK_IO_FLAG_AUTO_BUF_REG;
> >  }
> > @@ -2088,7 +2109,8 @@ static int ublk_commit_and_fetch(const struct ublk_queue *ubq,
> >                 if (!ub_cmd->addr && (!ublk_need_get_data(ubq) ||
> >                                         req_op(req) == REQ_OP_READ))
> >                         return -EINVAL;
> > -       } else if (req_op(req) != REQ_OP_ZONE_APPEND && ub_cmd->addr) {
> > +       } else if ((req_op(req) != REQ_OP_ZONE_APPEND &&
> > +                               !ublk_support_auto_buf_reg(ubq)) && ub_cmd->addr) {
> >                 /*
> >                  * User copy requires addr to be unset when command is
> >                  * not zone append
> > @@ -2097,7 +2119,7 @@ static int ublk_commit_and_fetch(const struct ublk_queue *ubq,
> >         }
> >
> >         if (io->flags & UBLK_IO_FLAG_AUTO_BUF_REG)
> > -               ublk_auto_buf_unreg(io, cmd, req, issue_flags);
> > +               ublk_auto_buf_unreg(ubq, io, cmd, req, issue_flags);
> >
> >         ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
> >
> > @@ -2788,6 +2810,11 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_cmd *header)
> >         else if (!(info.flags & UBLK_F_UNPRIVILEGED_DEV))
> >                 return -EPERM;
> >
> > +       /* F_AUTO_BUF_REG and F_SUPPORT_ZERO_COPY can't co-exist */
> > +       if ((info.flags & UBLK_F_AUTO_BUF_REG) &&
> > +                       (info.flags & UBLK_F_SUPPORT_ZERO_COPY))
> > +               return -EINVAL;
> > +
> >         /* forbid nonsense combinations of recovery flags */
> >         switch (info.flags & UBLK_F_ALL_RECOVERY_FLAGS) {
> >         case 0:
> > @@ -2817,8 +2844,11 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_cmd *header)
> >                  * For USER_COPY, we depends on userspace to fill request
> >                  * buffer by pwrite() to ublk char device, which can't be
> >                  * used for unprivileged device
> > +                *
> > +                * Same with zero copy or auto buffer register.
> >                  */
> > -               if (info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY))
> > +               if (info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY |
> > +                                       UBLK_F_AUTO_BUF_REG))
> >                         return -EINVAL;
> >         }
> >
> > @@ -2876,17 +2906,22 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_cmd *header)
> >                 UBLK_F_URING_CMD_COMP_IN_TASK;
> >
> >         /* GET_DATA isn't needed any more with USER_COPY or ZERO COPY */
> > -       if (ub->dev_info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY))
> > +       if (ub->dev_info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY |
> > +                               UBLK_F_AUTO_BUF_REG))
> >                 ub->dev_info.flags &= ~UBLK_F_NEED_GET_DATA;
> >
> >         /*
> >          * Zoned storage support requires reuse `ublksrv_io_cmd->addr` for
> >          * returning write_append_lba, which is only allowed in case of
> >          * user copy or zero copy
> > +        *
> > +        * UBLK_F_AUTO_BUF_REG can't be enabled for zoned because it need
> > +        * the space for getting ring_fd and buffer index.
> >          */
> >         if (ublk_dev_is_zoned(ub) &&
> >             (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) || !(ub->dev_info.flags &
> > -            (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY)))) {
> > +            (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY)) ||
> > +            (ub->dev_info.flags & UBLK_F_AUTO_BUF_REG))) {
> >                 ret = -EINVAL;
> >                 goto out_free_dev_number;
> >         }
> > @@ -3403,6 +3438,7 @@ static int __init ublk_init(void)
> >
> >         BUILD_BUG_ON((u64)UBLKSRV_IO_BUF_OFFSET +
> >                         UBLKSRV_IO_BUF_TOTAL_SIZE < UBLKSRV_IO_BUF_OFFSET);
> > +       BUILD_BUG_ON(sizeof(struct ublk_auto_buf_reg) != sizeof(__u64));
> >
> >         init_waitqueue_head(&ublk_idr_wq);
> >
> > diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.h
> > index be5c6c6b16e0..3d7c8c69cf06 100644
> > --- a/include/uapi/linux/ublk_cmd.h
> > +++ b/include/uapi/linux/ublk_cmd.h
> > @@ -219,6 +219,30 @@
> >   */
> >  #define UBLK_F_UPDATE_SIZE              (1ULL << 10)
> >
> > +/*
> > + * request buffer is registered automatically to ublk server specified
> > + * io_uring context before delivering this io command to ublk server,
> > + * meantime it is un-registered automatically when completing this io
> > + * command.
> > + *
> > + * For using this feature:
> > + *
> > + * - ublk server has to create sparse buffer table
> > + *
> > + * - pass io_ring context FD from `ublksrv_io_cmd.buf.ring_fd`, and the FD
> > + *   can be registered io_ring FD if `UBLK_AUTO_BUF_REGISTERED_RING` is set
> > + *   in `ublksrv_io_cmd.flags`, or plain FD
> > + *
> > + * - pass buffer index from `ublksrv_io_cmd.buf.index`
> > + *
> > + * This way avoids extra cost from two uring_cmd, but also simplifies backend
> > + * implementation, such as, the dependency on IO_REGISTER_IO_BUF and
> > + * IO_UNREGISTER_IO_BUF becomes not necessary.
> > + *
> > + * This feature isn't available for UBLK_F_ZONED
> > + */
> > +#define UBLK_F_AUTO_BUF_REG    (1ULL << 11)
> > +
> >  /* device state */
> >  #define UBLK_S_DEV_DEAD        0
> >  #define UBLK_S_DEV_LIVE        1
> > @@ -339,6 +363,14 @@ static inline __u32 ublksrv_get_flags(const struct ublksrv_io_desc *iod)
> >         return iod->op_flags >> 8;
> >  }
> >
> > +struct ublk_auto_buf_reg {
> > +       __s32  ring_fd;
> > +       __u16  index;
> > +#define UBLK_AUTO_BUF_REGISTERED_RING            (1 << 0)
> > +       __u8   flags;
> 
> The flag could potentially be stored in ublk_io's flags field instead
> to avoid taking up this byte.

`ublk_auto_buf_reg` takes the exact ->addr space in both 'struct ublk_io'
and 'struct ublksrv_io_cmd', this way won't take extra byte, but keep code simple
and reuse for dealing with auto_buf_reg from both 'struct ublk_io' and
'struct ublksrv_io_cmd'.


Thanks, 
Ming


