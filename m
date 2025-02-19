Return-Path: <io-uring+bounces-6547-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A505BA3AFAF
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 03:37:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EBEA3AA06F
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 02:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D76E9198E9B;
	Wed, 19 Feb 2025 02:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="QCgYVPla"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EB418870C
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 02:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739932603; cv=none; b=D0YoKn88Yux5dN2xpD86h6zIJmKdiB/RYA96g36Q+eyEB6XM+4PcOlTxNfBBFtT6jBPG80+bpEga8U+5o9JPeiGahHJ+E9Lei6mWIRX3l0rEoc23xOIqtJeuvxHw6z1NUdN6M7wEwRgaV0GsUVhO+gjQY55blaOMtbILvToXZm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739932603; c=relaxed/simple;
	bh=Abejg+VcI06exCcW4EB0t78Zjsepxt2XHv1Tgr6Mxgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=icLhl92luH68tbT4UlkBfgRfDeYcfUU+Pt3V01c+0kVMmCLwiod79CrdyKsZLzfSau3V7y+gIYNnOHiiYi2fRWkUX0U8KOZ17wpDkhcT4IZgBNiHU4B9DrzuMtVVYyMK27opmVbFaQJb5kDo7gTeO+RbkpN6HOlCuly0Oj0OErQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=QCgYVPla; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-220cb083491so13262725ad.3
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 18:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739932600; x=1740537400; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7AAsPzh5+U6yIGHp+5EbW3l+rMiLquCu3XdoxsLq+g=;
        b=QCgYVPlabPevqKeGL3VY/RAv6EkpDiq5mMl3FhZLRpsME6D/YgMKCxtNFbYZwh1sXn
         6VGrOTNIx0xLw3UArXK9YfliaG0EwW1swpDgLNEHE6zXttMcT+h3z16djx+dIaruJXkl
         jUJoSO2et5nE1J9b4GvmHbPsEoSwSQWSnSzR+71CqXD4vsg/JtUcnTaulB4eUcmPeU1U
         6nJzn7uoBcaZeJmLMcAYeVzgr97VViL54gYKnyM0uTjmaxHncmBl9FR2YK2EHhgH6AxJ
         0fVGQrknOhnfVrvt9190OCw5RnOtwvNraLQ1qEdnQLWLk0CiuYszn4EOIok3QDYLsWtB
         VI+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739932600; x=1740537400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l7AAsPzh5+U6yIGHp+5EbW3l+rMiLquCu3XdoxsLq+g=;
        b=vu2WxPXCtdWe6bStCGgklIk4S4WBvGWxwIqAwhD4SKbWVw/auImOrS00Hudb2dBmgH
         QzrsmtaW7UgpBqU0RRf1y8TTnVtyco72UEjR7BDr6rhSAHQU+HK1Rb/Ird44ndJHMx6p
         oynl9G6KzOAyto3F2Cb+qG6pN9j+z1rUtF8ypUeV8gdgBO8AIRFNpXecCi8YzDkjmGua
         zhVEptIaReI3MrJFERK9+oBZ4Y63457s7HJNQsWORW6aFDPTyqcJRrjAocJY+1iR2nSG
         Mopog67i8OZq+b+DyBDJqPIeMJvQ27GcKvqxHeksl0vWvqOyOpUCxhygGxzhyJu/5Kiu
         bPew==
X-Forwarded-Encrypted: i=1; AJvYcCWVIRambi+z2SdmUKyuu1Tm4GzQ5gQ1Jaqz1+9Ma2JfxSET8WH47K7serXhf6DeMUg+3WWbZP5czQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWSMqLZwshpKlYvnALnGYpfgRPMNNIYYjw2SkMLfPACfc0fIFX
	0mFvoUSi6JDC/6Dy8eUNycAYv+/TAKUmYMciHyYgHzqkkSGmc5ps2qT0lHKEphikWf/vsdUh4Tn
	xQwRsBrm2SDWFdjHjNccv6jciKRn3fZGKAk9PIg==
X-Gm-Gg: ASbGncv5GS8CTxLbBqTgi1wIZR5m5LeXRkQ9LAtf/G32IqPlrSLDDHRzVK4U7jFh224
	uz/sCA2XJu/C8rQoTENMkxIBNc5NJsXwwuOaYnhAleacd7s+ZRGxKZ5StUagvAR0VsRBgnCM=
X-Google-Smtp-Source: AGHT+IH+F1ujTBitxv0cCLPp2x2fv8qje21byagQPoXFIvhBnbyA16mRNX3RitItbxRfg3Na6DHXfo91UH74q9Fkj5E=
X-Received: by 2002:a17:902:c947:b0:21f:139c:5995 with SMTP id
 d9443c01a7336-22104012425mr97718955ad.4.1739932600440; Tue, 18 Feb 2025
 18:36:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218224229.837848-1-kbusch@meta.com> <20250218224229.837848-4-kbusch@meta.com>
In-Reply-To: <20250218224229.837848-4-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 18 Feb 2025 18:36:28 -0800
X-Gm-Features: AWEUYZkqAD0yKTvh2JfHuJBof6qeGLGotLF-ok24s1NzcEqdJmujY1DK0KFncWw
Message-ID: <CADUfDZq-LnAeP17GAdqGAPzCY77hrj+V+yEVi7G=_Uv4a3txaw@mail.gmail.com>
Subject: Re: [PATCHv4 3/5] ublk: zc register/unregister bvec
To: Keith Busch <kbusch@meta.com>
Cc: ming.lei@redhat.com, asml.silence@gmail.com, axboe@kernel.dk, 
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry, I sent these comments on v3 to you directly and forgot to CC
the list. Copying them here.

On Tue, Feb 18, 2025 at 2:43=E2=80=AFPM Keith Busch <kbusch@meta.com> wrote=
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
>  drivers/block/ublk_drv.c      | 137 +++++++++++++++++++++++++---------
>  include/uapi/linux/ublk_cmd.h |   4 +
>  2 files changed, 105 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 529085181f355..0c753176b14e9 100644
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
> @@ -1747,6 +1750,96 @@ static inline void ublk_prep_cancel(struct io_urin=
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
> +                               struct ublk_queue *ubq, int tag,
> +                               const struct ublksrv_io_cmd *ub_cmd,
> +                               unsigned int issue_flags)
> +{
> +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> +       struct ublk_device *ub =3D cmd->file->private_data;
> +       int index =3D (int)ub_cmd->addr, ret;

Make index an unsigned to match io_buffer_register_bvec()? Same
comment for ublk_unregister_io_buf().

> +       struct ublk_rq_data *data;
> +       struct request *req;
> +
> +       if (!ub)
> +               return -EPERM;

__ublk_ch_uring_cmd() has already dereferenced ub =3D
cmd->file->private_data, how is it possible to hit this? Same comment
for ublk_unregister_io_buf()

> +
> +       req =3D __ublk_check_and_get_req(ub, ubq, tag, 0);

Consider moving the offset > blk_rq_bytes(req) check from
__ublk_check_and_get_req() to ublk_check_and_get_req() so we don't
need to pass an unused offset here.

> +       if (!req)
> +               return -EINVAL;
> +
> +       data =3D blk_mq_rq_to_pdu(req);

data appears unused in this function. Same comment for ublk_unregister_io_b=
uf().

> +       ret =3D io_buffer_register_bvec(ctx, req, ublk_io_release, index,
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
> +                                 struct ublk_queue *ubq, int tag,
> +                                 const struct ublksrv_io_cmd *ub_cmd,
> +                                 unsigned int issue_flags)

Make tag an unsigned to match __ublk_ch_uring_cmd() and
blk_mq_tag_to_rq()? Same comment for ublk_register_io_buf().

> +{
> +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> +       struct ublk_device *ub =3D cmd->file->private_data;
> +       int index =3D (int)ub_cmd->addr;
> +       struct ublk_rq_data *data;
> +       struct request *req;
> +
> +       if (!ub)
> +               return -EPERM;
> +
> +       req =3D blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);
> +       if (!req)
> +               return -EINVAL;
> +
> +       data =3D blk_mq_rq_to_pdu(req);
> +       io_buffer_unregister_bvec(ctx, index, issue_flags);

Should we check that the registered bvec actually corresponds to this
ublk request? Otherwise, I don't see a reason for the unregister
command to involve the ublk request at all. Perhaps a generic io_uring
"unregister buffer index" operation similar to IORING_OP_FILES_UPDATE
would make more sense?

Best,
Caleb

> +       return 0;
> +}
> +
>  static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
>                                unsigned int issue_flags,
>                                const struct ublksrv_io_cmd *ub_cmd)
> @@ -1798,6 +1891,11 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd=
 *cmd,
>
>         ret =3D -EINVAL;
>         switch (_IOC_NR(cmd_op)) {
> +       case UBLK_IO_REGISTER_IO_BUF:
> +               return ublk_register_io_buf(cmd, ubq, tag, ub_cmd, issue_=
flags);
> +       case UBLK_IO_UNREGISTER_IO_BUF:
> +               return ublk_unregister_io_buf(cmd, ubq, tag, ub_cmd,
> +                                             issue_flags);
>         case UBLK_IO_FETCH_REQ:
>                 /* UBLK_IO_FETCH_REQ is only allowed before queue is setu=
p */
>                 if (ublk_queue_ready(ubq)) {
> @@ -1872,36 +1970,6 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd=
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
> @@ -2527,9 +2595,6 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *c=
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
> @@ -2860,7 +2925,7 @@ static int ublk_ctrl_get_features(struct io_uring_c=
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

