Return-Path: <io-uring+bounces-7769-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4DE7A9FE94
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 02:50:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A809F3B58D3
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 00:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA6564502B;
	Tue, 29 Apr 2025 00:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="fJpY1fZ9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA308CA5A
	for <io-uring@vger.kernel.org>; Tue, 29 Apr 2025 00:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745887814; cv=none; b=q/ZaoUtmrXRH4hyaodDIs+GeaxdgMeDGbdSruufwj/izQ4jGKRzUTiSgc4OqI2Ko6goHiLW64vtc+Mo9876D9O03g249FpbVirBBscKv6sNa4isiz3f/2nggeOUdp4hiwmV9VdJZW07qY8rYtnUPI0K6ztJQJhDM+/MY2vti/wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745887814; c=relaxed/simple;
	bh=mdEDgNShpjM3HxWrBa2SSuNW4subkk8bkBMaH4XCkaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bkz+uj7yHXH8gntD87AafRHo0swY4udRN30+ykeoF3wWACO20prw8hWGNDd9msRxL5AV6Oyxqbp7THvXRSFfhyBg2nsjUzBBiRzXzH45gjqzmqzRfqQv4HLmt6PVF87kl00rv4rv7BNQOzbScEqX7bKUOqKJgZuveInmKsTyWzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=fJpY1fZ9; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2240ff0bd6eso11121305ad.0
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 17:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1745887812; x=1746492612; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X7A0rbPUI4rKDOi6FYbARbzAyXbKrgfo4m1ttW4IMwM=;
        b=fJpY1fZ9Ft5jaFqlpyn6ZdYN3X+dNiWFcVjeQC89UwOpSEu90g0rYzslYv5pn5mhRF
         2IopVeJjnok87v5PquVXcXr3bqlqIAlEH6HjK9ZZQ6QaxvoZC9Az2kEzqcmHZ3MhJSLE
         BrevLWoJ+sAldAAUnp+4xiBa8sbP020ZIi4EcejC+1yS+DTTy7h50szELEJ2BLvaOOGK
         /hyBf/VQA2VcUsTmhrSKWmIcihgBT2BfBp54PrEw43oy0Jvr3BOgJa9hFUEzmoYWX3XT
         rdlOXTc4WkLucyO8lmu76J7nHVUpRV5B77TPCPK+GIpAnSJhdrfGLlBLyCcPSOKDN6yf
         9mpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745887812; x=1746492612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X7A0rbPUI4rKDOi6FYbARbzAyXbKrgfo4m1ttW4IMwM=;
        b=FXQ38CMC+fMgaWOyiTfrXK25atDPkug1lmLCnLnZ3hPnoro5zL7RHXXAxplTAsrRvi
         EimXFA2QPKe+C9bVtyMK3bQhdA9igAL7ZD1txgp1oUqQTUpju3XYvou6EFZOG2lSYmtu
         6KZ3DGCfs4zAeMRN09qz60uendb8+DMyl+YriExu9n/MPRkwF0LX7cgSMDHrZXMgAzYX
         NTSd8oWFSeUztohNkEnBoErfiZ773m70xZXVuDfxPKrQmvXrqG8+yAq5zZanuEPgHR0l
         uZDMeauRudiGnoYRIB7zwc4d/SimHDLC60iG8ZobQsSHqcbpCBPp1/Zzr7epnZjsYvEu
         sjxw==
X-Forwarded-Encrypted: i=1; AJvYcCWK7RulhVuq4+yuSxHuzxmaw6Bx+YPX7kG7yh2cWBph67AFED1dcPTXCKkCJfSW/f1VBK3oVVIMqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwwZHVXiorrbSlmYK0JUUc+fpoIiyVhW7o/HoJAOt7Ygq7Xp9Dc
	4NwQJINlUwWNuYr2fb6lJnz8Jcq/OtilIfUNBmmg/ddjOXY/tx3vxOjxxfkBQOtsAU9EqIBAw64
	U05/lIALFkGW0xQTul9gNEgWD4Kw86y6kzXjlbA==
X-Gm-Gg: ASbGnctVNmZm4xgaBqdI7Og2kLiKmWnWRu4fXzk7PmQ9UH7oXWWuxDTGEz5xoBcdIuk
	9IcnjWxlL4CV5CytV/0SPP2xvz9wcxU95kgP57U7CB+u2sUPDwGOucVV1Qmo4qte1G5ctuhgTyH
	0h2Hkvr730dg+RsJySqdV8meA6kv6XoKY=
X-Google-Smtp-Source: AGHT+IFpCOBSWacUnmHn8AmyL9fuqPeMaNSs/6MK1LMCXEt/xh/w1gGc+9LJtPoT+zgX5cJaRhHXfkwj2QfFHFQaxKM=
X-Received: by 2002:a17:90b:33cf:b0:309:f0d4:6e7f with SMTP id
 98e67ed59e1d1-30a220e9852mr685854a91.5.1745887811881; Mon, 28 Apr 2025
 17:50:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428094420.1584420-1-ming.lei@redhat.com> <20250428094420.1584420-6-ming.lei@redhat.com>
In-Reply-To: <20250428094420.1584420-6-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 28 Apr 2025 17:50:00 -0700
X-Gm-Features: ATxdqUGyTT0Vk-IUzudOb54g1GD7Gvii91dgJIZ5H5MmTH8lN2wGd8gGie7FCJE
Message-ID: <CADUfDZp33TcsrrVKBFZCKw23ySoHx=+YBgs_mnA6V4J-asrRMQ@mail.gmail.com>
Subject: Re: [RFC PATCH 5/7] ublk: prepare for supporting to register request
 buffer automatically
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org, 
	Uday Shankar <ushankar@purestorage.com>, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2025 at 2:45=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> UBLK_F_SUPPORT_ZERO_COPY requires ublk server to issue explicit buffer
> register/unregister uring_cmd for each IO, this way is not only inefficie=
nt,
> but also introduce dependency between buffer consumer and buffer register=
/
> unregister uring_cmd, please see tools/testing/selftests/ublk/stripe.c
> in which backing file IO has to be issued one by one by IOSQE_IO_LINK.
>
> Prepare for adding feature UBLK_F_AUTO_BUF_REG for addressing the existin=
g
> zero copy limitation:
>
> - register request buffer automatically to ublk uring_cmd's io_uring
>   context before delivering io command to ublk server
>
> - unregister request buffer automatically from the ublk uring_cmd's
>   io_uring context when completing the request
>
> - io_uring will unregister the buffer automatically when uring is
>   exiting, so we needn't worry about accident exit
>
> For using this feature, ublk server has to create one sparse buffer table
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/block/ublk_drv.c | 85 +++++++++++++++++++++++++++++++++++-----
>  1 file changed, 76 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 9cd331d12fa6..1fd20e481a60 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -133,6 +133,14 @@ struct ublk_uring_cmd_pdu {
>   */
>  #define UBLK_IO_FLAG_NEED_GET_DATA 0x08
>
> +/*
> + * request buffer is registered automatically, so we have to unregister =
it
> + * before completing this request.
> + *
> + * io_uring will unregister buffer automatically for us during exiting.
> + */
> +#define UBLK_IO_FLAG_AUTO_BUF_REG      0x10
> +
>  /* atomic RW with ubq->cancel_lock */
>  #define UBLK_IO_FLAG_CANCELED  0x80000000
>
> @@ -205,6 +213,7 @@ struct ublk_params_header {
>         __u32   types;
>  };
>
> +static void ublk_io_release(void *priv);
>  static void ublk_stop_dev_unlocked(struct ublk_device *ub);
>  static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *=
ubq);
>  static inline struct request *__ublk_check_and_get_req(struct ublk_devic=
e *ub,
> @@ -615,6 +624,11 @@ static inline bool ublk_support_zero_copy(const stru=
ct ublk_queue *ubq)
>         return ubq->flags & UBLK_F_SUPPORT_ZERO_COPY;
>  }
>
> +static inline bool ublk_support_auto_buf_reg(const struct ublk_queue *ub=
q)
> +{
> +       return false;
> +}
> +
>  static inline bool ublk_support_user_copy(const struct ublk_queue *ubq)
>  {
>         return ubq->flags & UBLK_F_USER_COPY;
> @@ -622,7 +636,8 @@ static inline bool ublk_support_user_copy(const struc=
t ublk_queue *ubq)
>
>  static inline bool ublk_need_map_io(const struct ublk_queue *ubq)
>  {
> -       return !ublk_support_user_copy(ubq) && !ublk_support_zero_copy(ub=
q);
> +       return !ublk_support_user_copy(ubq) && !ublk_support_zero_copy(ub=
q) &&
> +               !ublk_support_auto_buf_reg(ubq);
>  }
>
>  static inline bool ublk_need_req_ref(const struct ublk_queue *ubq)
> @@ -633,17 +648,22 @@ static inline bool ublk_need_req_ref(const struct u=
blk_queue *ubq)
>          *
>          * for zero copy, request buffer need to be registered to io_urin=
g
>          * buffer table, so reference is needed
> +        *
> +        * For auto buffer register, ublk server still may issue
> +        * UBLK_IO_COMMIT_AND_FETCH_REQ before one registered buffer is u=
sed up,
> +        * so reference is required too.
>          */
> -       return ublk_support_user_copy(ubq) || ublk_support_zero_copy(ubq)=
;
> +       return ublk_support_user_copy(ubq) || ublk_support_zero_copy(ubq)=
 ||
> +               ublk_support_auto_buf_reg(ubq);
>  }
>
>  static inline void ublk_init_req_ref(const struct ublk_queue *ubq,
> -               struct request *req)
> +               struct request *req, int init_ref)
>  {
>         if (ublk_need_req_ref(ubq)) {
>                 struct ublk_rq_data *data =3D blk_mq_rq_to_pdu(req);
>
> -               refcount_set(&data->ref, 1);
> +               refcount_set(&data->ref, init_ref);
>         }
>  }
>
> @@ -1157,6 +1177,37 @@ static inline void __ublk_abort_rq(struct ublk_que=
ue *ubq,
>                 blk_mq_end_request(rq, BLK_STS_IOERR);
>  }
>
> +static bool ublk_auto_buf_reg(struct ublk_queue *ubq, struct request *re=
q,
> +                             struct ublk_io *io, unsigned int issue_flag=
s)
> +{
> +       struct io_buf_data data =3D {
> +               .rq    =3D req,
> +               .index =3D req->tag,

It feels a bit misleading to specify a value here that is always
overwritten by ublk_init_auto_buf_reg() in the next patch. Can you
just omit the field from the initialization here? Same comment for
ublk_auto_buf_unreg().

> +               .release =3D ublk_io_release,
> +       };
> +       int ret;
> +
> +       /* one extra reference is dropped by ublk_io_release */
> +       ublk_init_req_ref(ubq, req, 2);

I think the ublk_need_req_ref(ubq) check in ublk_init_req_ref() is not
needed here, since this is only called when
ublk_support_auto_buf_reg(ubq) is true. Maybe just inline the
refcount_set() here? Then you could drop the ubq argument to
ublk_auto_buf_reg(), and ublk_init_req_ref() wouldn't need to be
modified.

Best,
Caleb

> +       ret =3D io_buffer_register_bvec(io->cmd, &data, issue_flags);
> +       if (ret) {
> +               blk_mq_end_request(req, BLK_STS_IOERR);
> +               return false;
> +       }
> +       io->flags |=3D UBLK_IO_FLAG_AUTO_BUF_REG;
> +       return true;
> +}
> +
> +static bool ublk_prep_buf_reg(struct ublk_queue *ubq, struct request *re=
q,
> +                             struct ublk_io *io, unsigned int issue_flag=
s)
> +{
> +       if (ublk_support_auto_buf_reg(ubq) && ublk_rq_has_data(req))
> +               return ublk_auto_buf_reg(ubq, req, io, issue_flags);
> +
> +       ublk_init_req_ref(ubq, req, 1);
> +       return true;
> +}
> +
>  static void ublk_start_io(struct ublk_queue *ubq, struct request *req,
>                           struct ublk_io *io)
>  {
> @@ -1181,8 +1232,6 @@ static void ublk_start_io(struct ublk_queue *ubq, s=
truct request *req,
>                 ublk_get_iod(ubq, req->tag)->nr_sectors =3D
>                         mapped_bytes >> 9;
>         }
> -
> -       ublk_init_req_ref(ubq, req);
>  }
>
>  static void ublk_dispatch_req(struct ublk_queue *ubq,
> @@ -1225,7 +1274,9 @@ static void ublk_dispatch_req(struct ublk_queue *ub=
q,
>         }
>
>         ublk_start_io(ubq, req, io);
> -       ublk_complete_io_cmd(io, req, UBLK_IO_RES_OK, issue_flags);
> +
> +       if (ublk_prep_buf_reg(ubq, req, io, issue_flags))
> +               ublk_complete_io_cmd(io, req, UBLK_IO_RES_OK, issue_flags=
);
>  }
>
>  static void ublk_cmd_tw_cb(struct io_uring_cmd *cmd,
> @@ -2007,9 +2058,21 @@ static int ublk_fetch(struct io_uring_cmd *cmd, st=
ruct ublk_queue *ubq,
>         return ret;
>  }
>
> +static void ublk_auto_buf_unreg(struct ublk_io *io, struct io_uring_cmd =
*cmd,
> +                               struct request *req, unsigned int issue_f=
lags)
> +{
> +       struct io_buf_data data =3D {
> +               .index =3D req->tag,
> +       };
> +
> +       WARN_ON_ONCE(io_buffer_unregister_bvec(cmd, &data, issue_flags));
> +       io->flags &=3D ~UBLK_IO_FLAG_AUTO_BUF_REG;
> +}
> +
>  static int ublk_commit_and_fetch(const struct ublk_queue *ubq,
>                                  struct ublk_io *io, struct io_uring_cmd =
*cmd,
> -                                const struct ublksrv_io_cmd *ub_cmd)
> +                                const struct ublksrv_io_cmd *ub_cmd,
> +                                unsigned int issue_flags)
>  {
>         struct request *req;
>
> @@ -2033,6 +2096,9 @@ static int ublk_commit_and_fetch(const struct ublk_=
queue *ubq,
>                 return -EINVAL;
>         }
>
> +       if (io->flags & UBLK_IO_FLAG_AUTO_BUF_REG)
> +               ublk_auto_buf_unreg(io, cmd, req, issue_flags);
> +
>         ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
>
>         /* now this cmd slot is owned by ublk driver */
> @@ -2065,6 +2131,7 @@ static void ublk_get_data(struct ublk_queue *ubq, s=
truct ublk_io *io)
>                         ublk_get_iod(ubq, req->tag)->addr);
>
>         ublk_start_io(ubq, req, io);
> +       ublk_init_req_ref(ubq, req, 1);
>  }
>
>  static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
> @@ -2124,7 +2191,7 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd =
*cmd,
>                         goto out;
>                 break;
>         case UBLK_IO_COMMIT_AND_FETCH_REQ:
> -               ret =3D ublk_commit_and_fetch(ubq, io, cmd, ub_cmd);
> +               ret =3D ublk_commit_and_fetch(ubq, io, cmd, ub_cmd, issue=
_flags);
>                 if (ret)
>                         goto out;
>                 break;
> --
> 2.47.0
>

