Return-Path: <io-uring+bounces-7770-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75ED6A9FE9C
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 02:52:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86BBD5A4F03
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 00:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8729C8837;
	Tue, 29 Apr 2025 00:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="LAjfjoiO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BB22AEFB
	for <io-uring@vger.kernel.org>; Tue, 29 Apr 2025 00:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745887963; cv=none; b=KFTjxxufH2RmOw4as5ShKsKpulgFvFkGSfyIcbyPRgcLmWboQ3Kr0yFJEt5LvpnSgeEZAZZRH45PWv1VpIJpfXfnwvdxyXZbe/e1AMGE6bp7bb1E8qeQfMV/hojBSs/4UNctvIdXGUePj0CSQtR1gxn33KuwktxUCRLTLe1+/Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745887963; c=relaxed/simple;
	bh=XBW4PdYmoJwv7cr2F+SjA/TIZHLvre4tERkia1y8Zvk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f7OxcAzS/5Vg3ZnhnEWR1mURdF68x/jn9Zk8z1/WIE9Hu4FShcVtgcrS41cWhOGY5H9xsUGIW+v3PLAI9whiIlp2cEfXCY/srHS4IcAqLwm6DRO/u+eStaeE2cOMXixcL5hkxxOkiJVlh6n/hK2n7J2LGHfGW37KfkdMOhWOC6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=LAjfjoiO; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-af5499ca131so583032a12.3
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 17:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1745887960; x=1746492760; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=leZG6VNjzi4cxvLRuL6zWtXVaJUcCgfQ98z1HUj4Z20=;
        b=LAjfjoiO590owarj2tvPQXPjDjBtT/jAsmoDOzTI6i5PbwoClDN7w3u74sFvMJekcH
         o8C/70AwD1x0P8Aooj4fbYMtgAzdDPc7g9bPrMX7MQvtWn+7OrHn4qsxrMoGh6Yd4DFT
         KQoeo+TX4FGcjdSnb+KtqCuR9Y7tO/MdLby0T2zfEeHrWmQxRmOMAnLnqmZ2BdKzTttu
         ReL7fEzkcnvZUFvmyq+lOL4+zBpyLocxqgOrGytPMQwWgDDGrh57d5UBmQskf7+9oHUH
         bS7duwLEPn6W+4vO30sjXedD9gl0Od42v8QFUskZ50RQ7sK1TtE3RCsAoR8WNrNcPVEd
         dfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745887960; x=1746492760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=leZG6VNjzi4cxvLRuL6zWtXVaJUcCgfQ98z1HUj4Z20=;
        b=BndNXfBTSTzy/91nKg9Ix5oh8qaS8JLaWwnZFqjO5hAeApNaQ1AWOkQVAtXYEI7uIu
         oblao5kaEzhxOLclGQWN0a1Iq/C8iBkY9XUMJMo2W5fT5PAti2rJD+uTEqOPYX6lw1AE
         Vk6XH4Qek7hKItZnU7kiDPHxGlYe47UWjXBYhe8FzgCgpgiVBli5SsgaJEt8OdE4h1L/
         +F4qiwBii9Luae6ClfXwW8Pbfn5nqKjsGdLXpOhADboTin3914PjwbYrjiL5qhMgpJqa
         co1/SiXMSksRPiH/u1bthKcAl3jgcp0xuaysDPAlifxO0yz+CviP0gIMVeprDvT18+QT
         VVqg==
X-Forwarded-Encrypted: i=1; AJvYcCUp4u1iMUlQBY3BSOkTAlYVXrrsU8G12QEfNqElnodWAekFqVW901ZXgJpTchB8ia8s4gj04oZf1A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwTb7mbUNgS7oVE4dpejWVzBu/Q/zwI3SnGY7fM67Y5SOcHhWRC
	SfWQR1QyzS8KlN0d5HHA3kpTT/u+b7rJ41jNJZJUgOL5OV9JANeudfTT+OxTOWf9E/6uMGLw2iA
	orSwuTLoBHswwaVZ6jCkNqwSBsSoUr1Rut0RSGivgbHWJe6fh1gvxZg==
X-Gm-Gg: ASbGncsj2qeFi4TWsOLHh+HgVnEoNYZdL04tKIefnj3EbCTvAn4/LkYOf44+UbnFxdt
	kX8w/85WycxpVlF8llQdjvGWJjSN+DKQJwzXbXQDkdyMtZOslNf9KgebTkl5G4QBeFLAMbf2f7T
	Jp/BC80RXaUGN1vUdb/Xc0
X-Google-Smtp-Source: AGHT+IGPO8x50CgpLXr/qTZKQVBotFxGO1VNmKCIJtfTX/F8Zv68Tp0DvxNzOBfOMNRfQkJlrXGnFAvXmkHFcuTBDCU=
X-Received: by 2002:a17:90b:1c92:b0:305:5f31:6c63 with SMTP id
 98e67ed59e1d1-30a220f0442mr701573a91.6.1745887960143; Mon, 28 Apr 2025
 17:52:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428094420.1584420-1-ming.lei@redhat.com> <20250428094420.1584420-7-ming.lei@redhat.com>
In-Reply-To: <20250428094420.1584420-7-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 28 Apr 2025 17:52:28 -0700
X-Gm-Features: ATxdqUGco17VJBbTA1kkMaxnpql1LkS1kUajLakqLD1r_sP5m-AdIWRemExdYMo
Message-ID: <CADUfDZrFDbYmnm7LEt94UVhn-tqGM6Fnfqvc2fuq8OqQPdNu3Q@mail.gmail.com>
Subject: Re: [RFC PATCH 6/7] ublk: register buffer to specified io_uring & buf
 index via UBLK_F_AUTO_BUF_REG
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org, 
	Uday Shankar <ushankar@purestorage.com>, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2025 at 2:45=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> Add UBLK_F_AUTO_BUF_REG for supporting to register buffer automatically
> to specified io_uring context and buffer index.
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/block/ublk_drv.c      | 56 ++++++++++++++++++++++++++++-------
>  include/uapi/linux/ublk_cmd.h | 38 ++++++++++++++++++++++++
>  2 files changed, 84 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 1fd20e481a60..e82618442749 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -66,7 +66,8 @@
>                 | UBLK_F_USER_COPY \
>                 | UBLK_F_ZONED \
>                 | UBLK_F_USER_RECOVERY_FAIL_IO \
> -               | UBLK_F_UPDATE_SIZE)
> +               | UBLK_F_UPDATE_SIZE \
> +               | UBLK_F_AUTO_BUF_REG)
>
>  #define UBLK_F_ALL_RECOVERY_FLAGS (UBLK_F_USER_RECOVERY \
>                 | UBLK_F_USER_RECOVERY_REISSUE \
> @@ -146,7 +147,10 @@ struct ublk_uring_cmd_pdu {
>
>  struct ublk_io {
>         /* userspace buffer address from io cmd */
> -       __u64   addr;
> +       union {
> +               __u64   addr;
> +               struct ublk_auto_buf_reg buf;

Maybe add a comment justifying why these fields can overlap? From my
understanding, buf is valid iff UBLK_F_AUTO_BUF_REG is set on the
ublk_queue and addr is valid iff neither UBLK_F_USER_COPY,
UBLK_F_SUPPORT_ZERO_COPY, nor UBLK_F_AUTO_BUF_REG is set.

> +       };
>         unsigned int flags;
>         int res;
>
> @@ -626,7 +630,7 @@ static inline bool ublk_support_zero_copy(const struc=
t ublk_queue *ubq)
>
>  static inline bool ublk_support_auto_buf_reg(const struct ublk_queue *ub=
q)
>  {
> -       return false;
> +       return ubq->flags & UBLK_F_AUTO_BUF_REG;
>  }
>
>  static inline bool ublk_support_user_copy(const struct ublk_queue *ubq)
> @@ -1177,6 +1181,16 @@ static inline void __ublk_abort_rq(struct ublk_que=
ue *ubq,
>                 blk_mq_end_request(rq, BLK_STS_IOERR);
>  }
>
> +
> +static inline void ublk_init_auto_buf_reg(const struct ublk_io *io,
> +                                         struct io_buf_data *data)
> +{
> +       data->index =3D io->buf.index;
> +       data->ring_fd =3D io->buf.ring_fd;
> +       data->has_fd =3D true;
> +       data->registered_fd =3D io->buf.flags & UBLK_AUTO_BUF_REGISTERED_=
RING;
> +}
> +
>  static bool ublk_auto_buf_reg(struct ublk_queue *ubq, struct request *re=
q,
>                               struct ublk_io *io, unsigned int issue_flag=
s)
>  {
> @@ -1187,6 +1201,9 @@ static bool ublk_auto_buf_reg(struct ublk_queue *ub=
q, struct request *req,
>         };
>         int ret;
>
> +       if (ublk_support_auto_buf_reg(ubq))

This check seems redundant with the check in the caller? Same comment
about ublk_auto_buf_unreg(). That would allow you to avoid adding the
ubq argument to ublk_auto_buf_unreg().

> +               ublk_init_auto_buf_reg(io, &data);
> +
>         /* one extra reference is dropped by ublk_io_release */
>         ublk_init_req_ref(ubq, req, 2);
>         ret =3D io_buffer_register_bvec(io->cmd, &data, issue_flags);
> @@ -2045,7 +2062,7 @@ static int ublk_fetch(struct io_uring_cmd *cmd, str=
uct ublk_queue *ubq,
>                  */
>                 if (!buf_addr && !ublk_need_get_data(ubq))
>                         goto out;
> -       } else if (buf_addr) {
> +       } else if (buf_addr && !ublk_support_auto_buf_reg(ubq)) {
>                 /* User copy requires addr to be unset */
>                 ret =3D -EINVAL;
>                 goto out;
> @@ -2058,13 +2075,17 @@ static int ublk_fetch(struct io_uring_cmd *cmd, s=
truct ublk_queue *ubq,
>         return ret;
>  }
>
> -static void ublk_auto_buf_unreg(struct ublk_io *io, struct io_uring_cmd =
*cmd,
> +static void ublk_auto_buf_unreg(const struct ublk_queue *ubq,
> +                               struct ublk_io *io, struct io_uring_cmd *=
cmd,
>                                 struct request *req, unsigned int issue_f=
lags)
>  {
>         struct io_buf_data data =3D {
>                 .index =3D req->tag,
>         };
>
> +       if (ublk_support_auto_buf_reg(ubq))
> +               ublk_init_auto_buf_reg(io, &data);
> +
>         WARN_ON_ONCE(io_buffer_unregister_bvec(cmd, &data, issue_flags));
>         io->flags &=3D ~UBLK_IO_FLAG_AUTO_BUF_REG;
>  }
> @@ -2088,7 +2109,8 @@ static int ublk_commit_and_fetch(const struct ublk_=
queue *ubq,
>                 if (!ub_cmd->addr && (!ublk_need_get_data(ubq) ||
>                                         req_op(req) =3D=3D REQ_OP_READ))
>                         return -EINVAL;
> -       } else if (req_op(req) !=3D REQ_OP_ZONE_APPEND && ub_cmd->addr) {
> +       } else if ((req_op(req) !=3D REQ_OP_ZONE_APPEND &&
> +                               !ublk_support_auto_buf_reg(ubq)) && ub_cm=
d->addr) {
>                 /*
>                  * User copy requires addr to be unset when command is
>                  * not zone append
> @@ -2097,7 +2119,7 @@ static int ublk_commit_and_fetch(const struct ublk_=
queue *ubq,
>         }
>
>         if (io->flags & UBLK_IO_FLAG_AUTO_BUF_REG)
> -               ublk_auto_buf_unreg(io, cmd, req, issue_flags);
> +               ublk_auto_buf_unreg(ubq, io, cmd, req, issue_flags);
>
>         ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
>
> @@ -2788,6 +2810,11 @@ static int ublk_ctrl_add_dev(const struct ublksrv_=
ctrl_cmd *header)
>         else if (!(info.flags & UBLK_F_UNPRIVILEGED_DEV))
>                 return -EPERM;
>
> +       /* F_AUTO_BUF_REG and F_SUPPORT_ZERO_COPY can't co-exist */
> +       if ((info.flags & UBLK_F_AUTO_BUF_REG) &&
> +                       (info.flags & UBLK_F_SUPPORT_ZERO_COPY))
> +               return -EINVAL;
> +
>         /* forbid nonsense combinations of recovery flags */
>         switch (info.flags & UBLK_F_ALL_RECOVERY_FLAGS) {
>         case 0:
> @@ -2817,8 +2844,11 @@ static int ublk_ctrl_add_dev(const struct ublksrv_=
ctrl_cmd *header)
>                  * For USER_COPY, we depends on userspace to fill request
>                  * buffer by pwrite() to ublk char device, which can't be
>                  * used for unprivileged device
> +                *
> +                * Same with zero copy or auto buffer register.
>                  */
> -               if (info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_=
COPY))
> +               if (info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_=
COPY |
> +                                       UBLK_F_AUTO_BUF_REG))
>                         return -EINVAL;
>         }
>
> @@ -2876,17 +2906,22 @@ static int ublk_ctrl_add_dev(const struct ublksrv=
_ctrl_cmd *header)
>                 UBLK_F_URING_CMD_COMP_IN_TASK;
>
>         /* GET_DATA isn't needed any more with USER_COPY or ZERO COPY */
> -       if (ub->dev_info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_=
COPY))
> +       if (ub->dev_info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_=
COPY |
> +                               UBLK_F_AUTO_BUF_REG))
>                 ub->dev_info.flags &=3D ~UBLK_F_NEED_GET_DATA;
>
>         /*
>          * Zoned storage support requires reuse `ublksrv_io_cmd->addr` fo=
r
>          * returning write_append_lba, which is only allowed in case of
>          * user copy or zero copy
> +        *
> +        * UBLK_F_AUTO_BUF_REG can't be enabled for zoned because it need
> +        * the space for getting ring_fd and buffer index.
>          */
>         if (ublk_dev_is_zoned(ub) &&
>             (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) || !(ub->dev_info.flags &
> -            (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY)))) {
> +            (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY)) ||
> +            (ub->dev_info.flags & UBLK_F_AUTO_BUF_REG))) {
>                 ret =3D -EINVAL;
>                 goto out_free_dev_number;
>         }
> @@ -3403,6 +3438,7 @@ static int __init ublk_init(void)
>
>         BUILD_BUG_ON((u64)UBLKSRV_IO_BUF_OFFSET +
>                         UBLKSRV_IO_BUF_TOTAL_SIZE < UBLKSRV_IO_BUF_OFFSET=
);
> +       BUILD_BUG_ON(sizeof(struct ublk_auto_buf_reg) !=3D sizeof(__u64))=
;
>
>         init_waitqueue_head(&ublk_idr_wq);
>
> diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.=
h
> index be5c6c6b16e0..3d7c8c69cf06 100644
> --- a/include/uapi/linux/ublk_cmd.h
> +++ b/include/uapi/linux/ublk_cmd.h
> @@ -219,6 +219,30 @@
>   */
>  #define UBLK_F_UPDATE_SIZE              (1ULL << 10)
>
> +/*
> + * request buffer is registered automatically to ublk server specified
> + * io_uring context before delivering this io command to ublk server,
> + * meantime it is un-registered automatically when completing this io
> + * command.
> + *
> + * For using this feature:
> + *
> + * - ublk server has to create sparse buffer table
> + *
> + * - pass io_ring context FD from `ublksrv_io_cmd.buf.ring_fd`, and the =
FD
> + *   can be registered io_ring FD if `UBLK_AUTO_BUF_REGISTERED_RING` is =
set
> + *   in `ublksrv_io_cmd.flags`, or plain FD
> + *
> + * - pass buffer index from `ublksrv_io_cmd.buf.index`
> + *
> + * This way avoids extra cost from two uring_cmd, but also simplifies ba=
ckend
> + * implementation, such as, the dependency on IO_REGISTER_IO_BUF and
> + * IO_UNREGISTER_IO_BUF becomes not necessary.
> + *
> + * This feature isn't available for UBLK_F_ZONED
> + */
> +#define UBLK_F_AUTO_BUF_REG    (1ULL << 11)
> +
>  /* device state */
>  #define UBLK_S_DEV_DEAD        0
>  #define UBLK_S_DEV_LIVE        1
> @@ -339,6 +363,14 @@ static inline __u32 ublksrv_get_flags(const struct u=
blksrv_io_desc *iod)
>         return iod->op_flags >> 8;
>  }
>
> +struct ublk_auto_buf_reg {
> +       __s32  ring_fd;
> +       __u16  index;
> +#define UBLK_AUTO_BUF_REGISTERED_RING            (1 << 0)
> +       __u8   flags;

The flag could potentially be stored in ublk_io's flags field instead
to avoid taking up this byte.

Best,
Caleb


> +       __u8   _pad;
> +};
> +
>  /* issued to ublk driver via /dev/ublkcN */
>  struct ublksrv_io_cmd {
>         __u16   q_id;
> @@ -363,6 +395,12 @@ struct ublksrv_io_cmd {
>                  */
>                 __u64   addr;
>                 __u64   zone_append_lba;
> +
> +               /*
> +                * for AUTO_BUF_REG feature, F_ZONED can't be supported,
> +                * and ->addr isn't used for zero copy
> +                */
> +               struct ublk_auto_buf_reg auto_buf;
>         };
>  };
>
> --
> 2.47.0
>

