Return-Path: <io-uring+bounces-9168-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A18D0B2FFFC
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 18:26:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 359CC5C0806
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:23:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73FB27602A;
	Thu, 21 Aug 2025 16:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZCERKOxb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC7726FA77
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 16:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755793411; cv=none; b=tlv67ZesA5/VVeCvqgAq4TjBerzZpk6YbadMXG+j6+mYQk8emkCC3XuCNDbtadmuq7PHcj5HcnYW5gYOcAEQGgfXuS/LO+MArbimAjfeislFFlPz0RSYHywcLYsvsKiO2wK9zR++i4bCkDJf6JH659dBvrvV1oYYDbvIQijKr0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755793411; c=relaxed/simple;
	bh=0OI728n1HNaxI2nsckfhxI5RrqrS3OEr9MASdVEFHfs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g3TDWX2faKePq1CZcYlOIi1j787AuXbFwgIZ/zu9iNmBG3tVIb2/56MovFoS+SK2iG5Y3bTAbE9s9jT8PALd0mdvApODkgeX+ssVAUCOyRDKofgseY6Big0cQMVTYjA4tOQYl5RUkTfn1lcFF2nfj9qd569pj6iBnvmn0m3m4nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZCERKOxb; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2445813f6d1so2007645ad.2
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 09:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1755793409; x=1756398209; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bAtbdYijXSmt7cy2UTmkEkvEYPPwCb9wghGcJcsLsIM=;
        b=ZCERKOxbjgg7GQSMnE0ITVv7cXSJ766ms8R20/SOibyjxZsfMJfjDE/ekLwjZqkNmc
         quATYQKfDjj7T341uhRdB14iL/HL+ETfcrnVH05+XnOmw15rNqKvu8gFGy/FFgyEfF2O
         3X2NE9cUnx4Dr72t486lbi0Su0aLcOBoQFLX17z4YXlgXlRuZY5BckHioREoDNw+nHpy
         cL1z+aiAAkc4KaWTkJNmrZ9u6anUpmBuWGhOIlYlH47UvEP2eGdyyGN/m9bajmK2CaU8
         7Or2ift+DDdrAsL/WCzqwZSyILY4scZyYXqaeO8Nl2NcI24f6+2Xm1RnnVWh03xoyi6t
         KTDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755793409; x=1756398209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bAtbdYijXSmt7cy2UTmkEkvEYPPwCb9wghGcJcsLsIM=;
        b=S5McJ4vaRslVDqvcjcIE18ucEuX8GFobwnMHuQgyCZ/CeVNEptWfV1FQlOjIvN+OV6
         DCwj0eTFPdfmI52wvZlv/ktcEknbsSpH43zSK9aS0PqlkMBmC1SrbPC4Kqbm0vL7gdaL
         GAMinHV2n0ojxku/7uqShhANJdU34c+qOOF0UbiIFqfgIriUTUzESRdCV+PdT9xD1nKq
         4BTg6zGEbwbJUus48wSqMFnCq1Xjs2mTrhdrzM6BiBlUhHRmpAV4GR+FnI6Hn7vuJiEa
         TXJLzV4FVQzxHKUKkNaY+rogKTPbdwyjDzLT8lVSFLicW4wzh3aE2PcmQS9F8WQgkYiU
         Dv2w==
X-Forwarded-Encrypted: i=1; AJvYcCXkbu6lrrIwhNg159LgDaDzfEX3K8o5iFYdv2V9/LPXT/DanTQwVxjjypuR/bkde67hZsx9DBCg5A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0E0MEcr4m5h2yML9xTBfidRbZN6S6F5lH0pXVauO+zL5ywTQc
	ixBP+tc86iaoAVLLfPZhytXN4eDPsXVPhImDh7JzgmLODnu3yP1JehIdm4aVZ0bspWQsQk6yfYV
	0uSA7IN7S2KSRiGRxxEnWGi4iaXjOWt9qDO8mUB9D3g==
X-Gm-Gg: ASbGncuueT+7YI3MZz+2YDpu7KQIunJIEUEO63YP9NWxWizljDxXXF5mf8xuLiPhFMC
	ApHehlw9C29uJyKMiC8n1leBka3K9HTTp92B3XjXEpKcu8GKV/1Hre7a89RdOZXPJK/sfkC66nL
	B13JkGeajsEUtYmdqKS/w1dMIafnbUpii22O4WaTKiahIFeMvpfAEB1TAeG2rbETpufsUMlNwNz
	cU6zN8hVNGAN+eL0EEhUxcFx5S4mg==
X-Google-Smtp-Source: AGHT+IERt/HHYHcCLECD8PKxjCbQgIqrXV5ZHvoXruwHugk0jiZ2SFBmRXAl5Pa30XKQKuRLxzFB6Fkr2agB6dZwavI=
X-Received: by 2002:a17:903:22cb:b0:240:bd35:c4ec with SMTP id
 d9443c01a7336-245feda2417mr26099895ad.6.1755793408699; Thu, 21 Aug 2025
 09:23:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821040210.1152145-1-ming.lei@redhat.com> <20250821040210.1152145-3-ming.lei@redhat.com>
In-Reply-To: <20250821040210.1152145-3-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 21 Aug 2025 09:23:16 -0700
X-Gm-Features: Ac12FXzD3FFamx6ArRg9vM0c_0aRxQd24zeX0HZFOzH0PUvq5LMqLPRstOc3k6U
Message-ID: <CADUfDZruvf+RTVRdH16X0xfUO-FmgLZAx6zvwHN3s0LoCcUAQA@mail.gmail.com>
Subject: Re: [PATCH V5 2/2] io_uring: uring_cmd: add multishot support
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 9:02=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> Add UAPI flag IORING_URING_CMD_MULTISHOT for supporting multishot
> uring_cmd operations with provided buffer.
>
> This enables drivers to post multiple completion events from a single
> uring_cmd submission, which is useful for:
>
> - Notifying userspace of device events (e.g., interrupt handling)
> - Supporting devices with multiple event sources (e.g., multi-queue devic=
es)
> - Avoiding the need for device poll() support when events originate
>   from multiple sources device-wide
>
> The implementation adds two new APIs:
> - io_uring_cmd_select_buffer(): selects a buffer from the provided
>   buffer group for multishot uring_cmd
> - io_uring_mshot_cmd_post_cqe(): posts a CQE after event data is
>   pushed to the provided buffer
>
> Multishot uring_cmd must be used with buffer select (IOSQE_BUFFER_SELECT)
> and is mutually exclusive with IORING_URING_CMD_FIXED for now.
>
> The ublk driver will be the first user of this functionality:
>
>         https://github.com/ming1/linux/commits/ublk-devel/
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Sorry I was out for a while and didn't get a chance to look at this
earlier. It generally looks reasonable. I noticed a couple of small
things which I'll send out patches for.

> ---
>  include/linux/io_uring/cmd.h  | 27 +++++++++++++
>  include/uapi/linux/io_uring.h |  6 ++-
>  io_uring/opdef.c              |  1 +
>  io_uring/uring_cmd.c          | 71 ++++++++++++++++++++++++++++++++++-
>  4 files changed, 103 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index cfa6d0c0c322..856d343b8e2a 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -70,6 +70,21 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd =
*cmd,
>  /* Execute the request from a blocking context */
>  void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
>
> +/*
> + * Select a buffer from the provided buffer group for multishot uring_cm=
d.
> + * Returns the selected buffer address and size.
> + */
> +struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
> +                                           unsigned buf_group, size_t *l=
en,
> +                                           unsigned int issue_flags);
> +
> +/*
> + * Complete a multishot uring_cmd event. This will post a CQE to the com=
pletion
> + * queue and update the provided buffer.
> + */
> +bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> +                                struct io_br_sel *sel, unsigned int issu=
e_flags);
> +
>  #else
>  static inline int
>  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> @@ -102,6 +117,18 @@ static inline void io_uring_cmd_mark_cancelable(stru=
ct io_uring_cmd *cmd,
>  static inline void io_uring_cmd_issue_blocking(struct io_uring_cmd *iouc=
md)
>  {
>  }
> +static inline int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd=
,
> +                               unsigned buf_group,
> +                               void **buf, size_t *len,
> +                               unsigned int issue_flags)
> +{
> +       return -EOPNOTSUPP;
> +}
> +static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *iouc=
md,
> +                               ssize_t ret, unsigned int issue_flags)
> +{
> +       return true;
> +}
>  #endif
>
>  /*
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
> index 6957dc539d83..1e935f8901c5 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -298,9 +298,13 @@ enum io_uring_op {
>   * sqe->uring_cmd_flags                top 8bits aren't available for us=
erspace
>   * IORING_URING_CMD_FIXED      use registered buffer; pass this flag
>   *                             along with setting sqe->buf_index.
> + * IORING_URING_CMD_MULTISHOT  must be used with buffer select, like oth=
er
> + *                             multishot commands. Not compatible with
> + *                             IORING_URING_CMD_FIXED, for now.
>   */
>  #define IORING_URING_CMD_FIXED (1U << 0)
> -#define IORING_URING_CMD_MASK  IORING_URING_CMD_FIXED
> +#define IORING_URING_CMD_MULTISHOT     (1U << 1)
> +#define IORING_URING_CMD_MASK  (IORING_URING_CMD_FIXED | IORING_URING_CM=
D_MULTISHOT)
>
>
>  /*
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 9568785810d9..932319633eac 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -413,6 +413,7 @@ const struct io_issue_def io_issue_defs[] =3D {
>  #endif
>         },
>         [IORING_OP_URING_CMD] =3D {
> +               .buffer_select          =3D 1,
>                 .needs_file             =3D 1,
>                 .plug                   =3D 1,
>                 .iopoll                 =3D 1,
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 053bac89b6c0..3cfb5d51b88a 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -11,6 +11,7 @@
>  #include "io_uring.h"
>  #include "alloc_cache.h"
>  #include "rsrc.h"
> +#include "kbuf.h"
>  #include "uring_cmd.h"
>  #include "poll.h"
>
> @@ -194,8 +195,21 @@ int io_uring_cmd_prep(struct io_kiocb *req, const st=
ruct io_uring_sqe *sqe)
>         if (ioucmd->flags & ~IORING_URING_CMD_MASK)
>                 return -EINVAL;
>
> -       if (ioucmd->flags & IORING_URING_CMD_FIXED)
> +       if (ioucmd->flags & IORING_URING_CMD_FIXED) {
> +               if (ioucmd->flags & IORING_URING_CMD_MULTISHOT)
> +                       return -EINVAL;
>                 req->buf_index =3D READ_ONCE(sqe->buf_index);
> +       }
> +
> +       if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
> +               if (ioucmd->flags & IORING_URING_CMD_FIXED)
> +                       return -EINVAL;
> +               if (!(req->flags & REQ_F_BUFFER_SELECT))
> +                       return -EINVAL;
> +       } else {
> +               if (req->flags & REQ_F_BUFFER_SELECT)
> +                       return -EINVAL;
> +       }
>
>         ioucmd->cmd_op =3D READ_ONCE(sqe->cmd_op);
>
> @@ -251,6 +265,10 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int =
issue_flags)
>         }
>
>         ret =3D file->f_op->uring_cmd(ioucmd, issue_flags);
> +       if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
> +               if (ret >=3D 0)
> +                       return IOU_ISSUE_SKIP_COMPLETE;
> +       }
>         if (ret =3D=3D -EAGAIN) {
>                 ioucmd->flags |=3D IORING_URING_CMD_REISSUE;
>                 return ret;
> @@ -333,3 +351,54 @@ bool io_uring_cmd_post_mshot_cqe32(struct io_uring_c=
md *cmd,
>                 return false;
>         return io_req_post_cqe32(req, cqe);
>  }
> +
> +/*
> + * Work with io_uring_mshot_cmd_post_cqe() together for committing the
> + * provided buffer upfront
> + */
> +struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
> +                                           unsigned buf_group, size_t *l=
en,
> +                                           unsigned int issue_flags)
> +{
> +       struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
> +
> +       if (!(ioucmd->flags & IORING_URING_CMD_MULTISHOT))
> +               return (struct io_br_sel) { .val =3D -EINVAL };

Would this condition make more sense as a WARN_ON()? When would this
be called for a non-IORING_URING_CMD_MULTISHOT io_uring_cmd?

> +
> +       if (WARN_ON_ONCE(!io_do_buffer_select(req)))
> +               return (struct io_br_sel) { .val =3D -EINVAL };
> +
> +       return io_buffer_select(req, len, buf_group, issue_flags);
> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_buffer_select);
> +
> +/*
> + * Return true if this multishot uring_cmd needs to be completed, otherw=
ise
> + * the event CQE is posted successfully.
> + *
> + * This function must use `struct io_br_sel` returned from
> + * io_uring_cmd_buffer_select() for committing the buffer in the same
> + * uring_cmd submission context.
> + */
> +bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> +                                struct io_br_sel *sel, unsigned int issu=
e_flags)
> +{
> +       struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
> +       unsigned int cflags =3D 0;
> +
> +       if (!(ioucmd->flags & IORING_URING_CMD_MULTISHOT))
> +               return true;

Same here, a WARN_ON() seems like it would make more sense.

Best,
Caleb

> +
> +       if (sel->val > 0) {
> +               cflags =3D io_put_kbuf(req, sel->val, sel->buf_list);
> +               if (io_req_post_cqe(req, sel->val, cflags | IORING_CQE_F_=
MORE))
> +                       return false;
> +       }
> +
> +       io_kbuf_recycle(req, sel->buf_list, issue_flags);
> +       if (sel->val < 0)
> +               req_set_fail(req);
> +       io_req_set_res(req, sel->val, cflags);
> +       return true;
> +}
> +EXPORT_SYMBOL_GPL(io_uring_mshot_cmd_post_cqe);
> --
> 2.47.0
>

