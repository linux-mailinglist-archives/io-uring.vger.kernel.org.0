Return-Path: <io-uring+bounces-6761-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 170C2A44E86
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 22:15:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0F881899099
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 21:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 995D521019A;
	Tue, 25 Feb 2025 21:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="B5xgEVTN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B612F20F06E
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 21:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740518094; cv=none; b=W7G7KqoOYyr+sH5No2DiTRRYzY40sed8rgyL+gzJC/tuOtFphx5VSxybUOd/MnNh9G4vh4NGqxtA1TSvO41BtEBRz/AWTJAUHA8/ZE+XodOY1ggnjy7vFsQA+8hkhJ7s05cRlCuXBvmIInATOUnizP553FY+RJ51uDnn3jUcjQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740518094; c=relaxed/simple;
	bh=n11yKJ/XUOHHHtUtLdxxZo6YMyQawd2VxE9bfT3uHmU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uu6+vjFLR+aczvrO60DFXp/u7UcPy7nYT7nqaHTuyNjFWpKD4QvYveLQMgVWp5PbipxBj8HywpqcLoXyeiX2faTVEQN47uSDzzFsIEPLAaWTzkhOhJ5kSuXZVixeAoTRxTImhOnICj8/2yeJoxDA0AW/0sx+CieqXogPFjHdwZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=B5xgEVTN; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2fbf706c9cbso1520866a91.3
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 13:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740518092; x=1741122892; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4OXvxLiWlJtD6MNQmCGa7+Dtk3fvzc2JcxyyAEw+Cl0=;
        b=B5xgEVTN7WRHAXcLvpvUOLdHK8FjR8jK1cOMR4jhi6w4InzhF0bTGisqqu47zkuLrj
         kk111Ol+pWexjX7Q1k1I7vqYNqlIfhMYcrItsJJkweToppo0RKSNv44G7FqJiH/Btf28
         BEVg3p+xsUKDRIdEA5Itnm6YRDaZAu9DiSS3rSdZoQ4ir80+Hp+jdVsoj++1B9aiRZE0
         IdWQ/2B5RQWHH2+oh4vRNJkttweP5hXNAAYyr53IFS3hzz6KWnaAub0hLaZ/k3n5U1TY
         bBqJVY/KiZKr6FnNX+owF0jeCbqViEMwzMU8bqKiZxV15GKvZLU9DW5uSrT587/TWJyp
         kPgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740518092; x=1741122892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4OXvxLiWlJtD6MNQmCGa7+Dtk3fvzc2JcxyyAEw+Cl0=;
        b=FIwuNpmxFYyd5w/zWHvocEuoim+PoAtlF6cr0aMTVjDPiLKj633jHBf+bc5z5FvedF
         Lj8cdPDW78y07MS+4kHV7GBtJGy4W8o+Is+QVB4wUmKsHGIWXz9ueK4TRLHASeUH9aio
         eFMxVSa86H67UPNEPhcQCgt5OkCN0WwukpctgtyQootW9DuU2cUHniTrB1Y2MOJU/+rL
         XFx+epUbepBctxUhOaJk8dmbxUFI9Je3bGqtg3gFsKrmp1Lh1jSPw85bL1WQX8G39ICY
         abTERAXLTSeyYErVaLmWlLBpJBIpfU096+MFdfecQuwJkEaDO/1PuYDYx+mhgCblxy7O
         kcvA==
X-Forwarded-Encrypted: i=1; AJvYcCXL+mBinKmXADS3A3A8Rooxro0mvX/ywOGBrwXwlZnlzVOW5Pa7sRbuNJYYgtlLAwRCmsm/Hfb8fA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7svBF7LOvKXDKiI+3XrTmSz959xH6DcfcdtRKh7et7oYBGfhJ
	Hv4gLuVnK3Iu2khUGvUrUqFZ2Ug0crOI9OBGammiLxZw44RmP7gz6bwNlt9tJ+8nZuaRB8QpBA2
	vI+cqdzX1gcn0bXfscgumpxSghyXooTf2qvf0IA==
X-Gm-Gg: ASbGncug9B95ERZWQQri0DToMyFV6bWr9POzxaZfUM5NManZsXWHjVJ2gF0qlN2EiLY
	mExZEeVYgJqx7LebS6GhJEwkIdOlZ7XNAm+cD0E8UXTqP47J3b6ndX4xSjQLe8Jyy9ZtHMBartE
	Ml8tTLPg==
X-Google-Smtp-Source: AGHT+IE50MjoGcSCMnJzKG2scJXjCJKX4X7FbnEkntQnInGIq3YY2rA8EuIx8/svX3TY/zMcYPIc9lLwCO7OivRbzwQ=
X-Received: by 2002:a17:90b:3b8e:b0:2ee:d372:91bd with SMTP id
 98e67ed59e1d1-2fce77a6618mr11923594a91.2.1740518091913; Tue, 25 Feb 2025
 13:14:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250224213116.3509093-1-kbusch@meta.com> <20250224213116.3509093-10-kbusch@meta.com>
In-Reply-To: <20250224213116.3509093-10-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 25 Feb 2025 13:14:40 -0800
X-Gm-Features: AWEUYZmlDAOCvhcNkpfhcW755PQ6MyJDFj18xWwb2Ynp2yNFCT9B59GtWKB7q24
Message-ID: <CADUfDZo_--ha_GyLp_b6OfLx5JohnyHiGbQ6Je0yZYawCgCb6w@mail.gmail.com>
Subject: Re: [PATCHv5 09/11] ublk: zc register/unregister bvec
To: Keith Busch <kbusch@meta.com>
Cc: ming.lei@redhat.com, asml.silence@gmail.com, axboe@kernel.dk, 
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2025 at 1:31=E2=80=AFPM Keith Busch <kbusch@meta.com> wrote=
:
>
> From: Keith Busch <kbusch@kernel.org>
>
> Provide new operations for the user to request mapping an active request
> to an io uring instance's buf_table. The user has to provide the index
> it wants to install the buffer.
>
> A reference count is taken on the request to ensure it can't be
> completed while it is active in a ring's buf_table.
>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  drivers/block/ublk_drv.c      | 117 +++++++++++++++++++++++-----------
>  include/uapi/linux/ublk_cmd.h |   4 ++
>  2 files changed, 85 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 529085181f355..a719d873e3882 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -51,6 +51,9 @@
>  /* private ioctl command mirror */
>  #define UBLK_CMD_DEL_DEV_ASYNC _IOC_NR(UBLK_U_CMD_DEL_DEV_ASYNC)
>
> +#define UBLK_IO_REGISTER_IO_BUF                _IOC_NR(UBLK_U_IO_REGISTE=
R_IO_BUF)
> +#define UBLK_IO_UNREGISTER_IO_BUF      _IOC_NR(UBLK_U_IO_UNREGISTER_IO_B=
UF)
> +
>  /* All UBLK_F_* have to be included into UBLK_F_ALL */
>  #define UBLK_F_ALL (UBLK_F_SUPPORT_ZERO_COPY \
>                 | UBLK_F_URING_CMD_COMP_IN_TASK \
> @@ -201,7 +204,7 @@ static inline struct ublksrv_io_desc *ublk_get_iod(st=
ruct ublk_queue *ubq,
>                                                    int tag);
>  static inline bool ublk_dev_is_user_copy(const struct ublk_device *ub)
>  {
> -       return ub->dev_info.flags & UBLK_F_USER_COPY;
> +       return ub->dev_info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZE=
RO_COPY);
>  }
>
>  static inline bool ublk_dev_is_zoned(const struct ublk_device *ub)
> @@ -581,7 +584,7 @@ static void ublk_apply_params(struct ublk_device *ub)
>
>  static inline bool ublk_support_user_copy(const struct ublk_queue *ubq)
>  {
> -       return ubq->flags & UBLK_F_USER_COPY;
> +       return ubq->flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY)=
;
>  }
>
>  static inline bool ublk_need_req_ref(const struct ublk_queue *ubq)
> @@ -1747,6 +1750,77 @@ static inline void ublk_prep_cancel(struct io_urin=
g_cmd *cmd,
>         io_uring_cmd_mark_cancelable(cmd, issue_flags);
>  }
>
> +static inline struct request *__ublk_check_and_get_req(struct ublk_devic=
e *ub,
> +               struct ublk_queue *ubq, int tag, size_t offset)
> +{
> +       struct request *req;
> +
> +       if (!ublk_need_req_ref(ubq))
> +               return NULL;
> +
> +       req =3D blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);
> +       if (!req)
> +               return NULL;
> +
> +       if (!ublk_get_req_ref(ubq, req))
> +               return NULL;
> +
> +       if (unlikely(!blk_mq_request_started(req) || req->tag !=3D tag))
> +               goto fail_put;
> +
> +       if (!ublk_rq_has_data(req))
> +               goto fail_put;
> +
> +       if (offset > blk_rq_bytes(req))
> +               goto fail_put;
> +
> +       return req;
> +fail_put:
> +       ublk_put_req_ref(ubq, req);
> +       return NULL;
> +}
> +
> +static void ublk_io_release(void *priv)
> +{
> +       struct request *rq =3D priv;
> +       struct ublk_queue *ubq =3D rq->mq_hctx->driver_data;
> +
> +       ublk_put_req_ref(ubq, rq);
> +}
> +
> +static int ublk_register_io_buf(struct io_uring_cmd *cmd,
> +                               struct ublk_queue *ubq, unsigned int tag,
> +                               const struct ublksrv_io_cmd *ub_cmd,
> +                               unsigned int issue_flags)
> +{
> +       struct ublk_device *ub =3D cmd->file->private_data;
> +       int index =3D (int)ub_cmd->addr, ret;
> +       struct request *req;
> +
> +       req =3D __ublk_check_and_get_req(ub, ubq, tag, 0);
> +       if (!req)
> +               return -EINVAL;
> +
> +       ret =3D io_buffer_register_bvec(cmd, req, ublk_io_release, index,
> +                                     issue_flags);
> +       if (ret) {
> +               ublk_put_req_ref(ubq, req);
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int ublk_unregister_io_buf(struct io_uring_cmd *cmd,
> +                                 const struct ublksrv_io_cmd *ub_cmd,
> +                                 unsigned int issue_flags)
> +{
> +       int index =3D (int)ub_cmd->addr;
> +
> +       io_buffer_unregister_bvec(cmd, index, issue_flags);
> +       return 0;
> +}
> +
>  static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
>                                unsigned int issue_flags,
>                                const struct ublksrv_io_cmd *ub_cmd)
> @@ -1798,6 +1872,10 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd=
 *cmd,
>
>         ret =3D -EINVAL;
>         switch (_IOC_NR(cmd_op)) {
> +       case UBLK_IO_REGISTER_IO_BUF:
> +               return ublk_register_io_buf(cmd, ubq, tag, ub_cmd, issue_=
flags);
> +       case UBLK_IO_UNREGISTER_IO_BUF:
> +               return ublk_unregister_io_buf(cmd, ub_cmd, issue_flags);

In the other cases, completion happens asynchronously by returning
-EIOCBQUEUED and calling io_uring_cmd_done() when the command
finishes. It looks like that's necessary because
ublk_ch_uring_cmd_cb() ignores the return value from
__ublk_ch_uring_cmd()/ublk_ch_uring_cmd_local(). (In the non-task-work
case, ublk_ch_uring_cmd() does propagate the return value.) Maybe
ublk_ch_uring_cmd_cb() should check the return value and call
io_uring_cmd_done() if it's not -EIOCBQUEUED.

Best,
Caleb


>         case UBLK_IO_FETCH_REQ:
>                 /* UBLK_IO_FETCH_REQ is only allowed before queue is setu=
p */
>                 if (ublk_queue_ready(ubq)) {
> @@ -1872,36 +1950,6 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd=
 *cmd,
>         return -EIOCBQUEUED;
>  }
>
> -static inline struct request *__ublk_check_and_get_req(struct ublk_devic=
e *ub,
> -               struct ublk_queue *ubq, int tag, size_t offset)
> -{
> -       struct request *req;
> -
> -       if (!ublk_need_req_ref(ubq))
> -               return NULL;
> -
> -       req =3D blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);
> -       if (!req)
> -               return NULL;
> -
> -       if (!ublk_get_req_ref(ubq, req))
> -               return NULL;
> -
> -       if (unlikely(!blk_mq_request_started(req) || req->tag !=3D tag))
> -               goto fail_put;
> -
> -       if (!ublk_rq_has_data(req))
> -               goto fail_put;
> -
> -       if (offset > blk_rq_bytes(req))
> -               goto fail_put;
> -
> -       return req;
> -fail_put:
> -       ublk_put_req_ref(ubq, req);
> -       return NULL;
> -}
> -
>  static inline int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
>                 unsigned int issue_flags)
>  {
> @@ -2527,9 +2575,6 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *c=
md)
>                 goto out_free_dev_number;
>         }
>
> -       /* We are not ready to support zero copy */
> -       ub->dev_info.flags &=3D ~UBLK_F_SUPPORT_ZERO_COPY;
> -
>         ub->dev_info.nr_hw_queues =3D min_t(unsigned int,
>                         ub->dev_info.nr_hw_queues, nr_cpu_ids);
>         ublk_align_max_io_size(ub);
> @@ -2860,7 +2905,7 @@ static int ublk_ctrl_get_features(struct io_uring_c=
md *cmd)
>  {
>         const struct ublksrv_ctrl_cmd *header =3D io_uring_sqe_cmd(cmd->s=
qe);
>         void __user *argp =3D (void __user *)(unsigned long)header->addr;
> -       u64 features =3D UBLK_F_ALL & ~UBLK_F_SUPPORT_ZERO_COPY;
> +       u64 features =3D UBLK_F_ALL;
>
>         if (header->len !=3D UBLK_FEATURES_LEN || !header->addr)
>                 return -EINVAL;
> diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.=
h
> index a8bc98bb69fce..74246c926b55f 100644
> --- a/include/uapi/linux/ublk_cmd.h
> +++ b/include/uapi/linux/ublk_cmd.h
> @@ -94,6 +94,10 @@
>         _IOWR('u', UBLK_IO_COMMIT_AND_FETCH_REQ, struct ublksrv_io_cmd)
>  #define        UBLK_U_IO_NEED_GET_DATA         \
>         _IOWR('u', UBLK_IO_NEED_GET_DATA, struct ublksrv_io_cmd)
> +#define        UBLK_U_IO_REGISTER_IO_BUF       \
> +       _IOWR('u', 0x23, struct ublksrv_io_cmd)
> +#define        UBLK_U_IO_UNREGISTER_IO_BUF     \
> +       _IOWR('u', 0x24, struct ublksrv_io_cmd)
>
>  /* only ABORT means that no re-fetch */
>  #define UBLK_IO_RES_OK                 0
> --
> 2.43.5
>

