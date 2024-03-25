Return-Path: <io-uring+bounces-1206-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D7688A598
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 16:01:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB6F430925A
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 15:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C2C5D725;
	Mon, 25 Mar 2024 12:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h+JVBj39"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F5D13C8E2
	for <io-uring@vger.kernel.org>; Mon, 25 Mar 2024 12:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711368230; cv=none; b=I1Gv58oZ/OUGnLP3SfNZzuSfV1l1oiviFZky3JOsNMBzB9fzTAB7x5HPzt3eMz+Va66SocTRJdGHgQU+ah9j+TpqGBomOhOhYtFgm1bH7dspQc6B0FsCUnZ5KfED4ThhXGKxMRmXEndA5+W3bf51mUl5ooFvzVRMyPEgdZv5sxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711368230; c=relaxed/simple;
	bh=9A5NQZ6Kv0F4Rf5WGQdi4KgnIW6JE6WsKzd2qDv4uio=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oE+I89s/GhpfK6r5XNszJ3CN9N4fXGBeGOzPfM/bhPLgbFeW7xYifonrKi7mCtapy1LJ5+hgdLrpp7HIttSK9fGGS6VS9CC7sA4+T2QGQxYJfMnaxdV72Sux48KxPNtXL6+jV9lXR/2xEVdgD/n6Ao6x3YFk/mRJ2CZiwILErio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h+JVBj39; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-dccb1421bdeso3710015276.1
        for <io-uring@vger.kernel.org>; Mon, 25 Mar 2024 05:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711368227; x=1711973027; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m/JyMoBgeA7nUiZ18ZAMSpOwC0fQsdKGKKdCn1tUSAk=;
        b=h+JVBj39jYr/DTevfAxgwFlbLOcNlrGBxnNJOZhtbyCekz0yr85vtVFEyTXThJEFHf
         wY8iy1BzFi9iiYeA6KX6I5PIjvs6Bb/oZ0KX0c88xd4GGxjJjt/FHMwiAozUNdY1z5SW
         QmL4X/pSVvtq7pRINaldln8Epz1EPpAbrUgz+wHZCB9iZbrOM51bcfihczQ9v9wEL7p6
         7CPjTiAG/7ORBI+VT1m+OEY1nJ9l4VpKV4e7MDqObh9BUAE1/jtO1YSY8/t7Qvfci+3R
         aLJA3rAati7a0yX6/wGgr8t4SjewO/MnJPzl0McqYZ/nN9Dib2QqmUgDpBxiYw0a7Iz3
         84Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711368227; x=1711973027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m/JyMoBgeA7nUiZ18ZAMSpOwC0fQsdKGKKdCn1tUSAk=;
        b=kIE1Ts3oW6DcFXafJnTu5NwZG49i76nBY01UJ7DC9ebk/N8lYZHL5Si+6B8Q80frzW
         40Bl+dq7brr7DsFxmwObdjB0Lc3QaIcGJpMSRsGwOC/yBNOiv06O8lWkb+8TTEJo+l4y
         nY3pUg15tJJHej4dFQvR+NGNerPZWTqY9nn3vVj2mMqEUmdfOg733c6T+TBZcTCrpNPG
         hVThGT4bMvA3MgzzbJ6iNRg1+uD5pUwFN2j4+uiyQl5mcOBHvPFlnN/A01hRnlUmtAAU
         4ACKBmJdMX8ubW+7mdCWWJsauGkgntLHk2a1G5BvNEAJ9x5/514JhG51KoskkRSzaksA
         tNLA==
X-Gm-Message-State: AOJu0YxGoLvZYCnaDQ43px7asLiM7RU+hWbCyllKBu1+8Z6BmNmY++pG
	bIdYFncLgR+bUsDcs9Et8tS3zHV7Pszofrur9UMR2PrGeXiGAABTdg6D9Ali6ceidPNzR+/8zH/
	9tfmyMNTWb+U2q+EKuO86NMdPfQ==
X-Google-Smtp-Source: AGHT+IGsHW1m57YPSBjyoH0m1tOCqumEAaRrh1JLQtdRAkqFRsjaHfDkhAbBtbsVKSW2EhPG1ngy3LS+d8TaHWq4/0o=
X-Received: by 2002:a25:dbd0:0:b0:dcc:e9d:4a22 with SMTP id
 g199-20020a25dbd0000000b00dcc0e9d4a22mr4823290ybf.12.1711368227291; Mon, 25
 Mar 2024 05:03:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320225750.1769647-1-axboe@kernel.dk> <20240320225750.1769647-11-axboe@kernel.dk>
In-Reply-To: <20240320225750.1769647-11-axboe@kernel.dk>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 25 Mar 2024 17:33:09 +0530
Message-ID: <CACzX3AvbFtCAH8Lr_zsNjQeMMhrRFdrmLcE=zRygWe61nL5YAA@mail.gmail.com>
Subject: Re: [PATCH 10/17] io_uring/rw: always setup io_async_rw for
 read/write requests
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2024 at 4:28=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> read/write requests try to put everything on the stack, and then alloc
> and copy if we need to retry. This necessitates a bunch of nasty code
> that deals with intermediate state.
>
> Get rid of this, and have the prep side setup everything we need
> upfront, which greatly simplifies the opcode handlers.
>
> This includes adding an alloc cache for io_async_rw, to make it cheap
> to handle.
>
> In terms of cost, this should be basically free and transparent. For
> the worst case of {READ,WRITE}_FIXED which didn't need it before,
> performance is unaffected in the normal peak workload that is being
> used to test that. Still runs at 122M IOPS.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h |   1 +
>  io_uring/io_uring.c            |   3 +
>  io_uring/opdef.c               |  15 +-
>  io_uring/rw.c                  | 538 ++++++++++++++++-----------------
>  io_uring/rw.h                  |  19 +-
>  5 files changed, 278 insertions(+), 298 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index f37caff64d05..2ba8676f83cc 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -300,6 +300,7 @@ struct io_ring_ctx {
>                 struct io_hash_table    cancel_table_locked;
>                 struct io_alloc_cache   apoll_cache;
>                 struct io_alloc_cache   netmsg_cache;
> +               struct io_alloc_cache   rw_cache;
>
>                 /*
>                  * Any cancelable uring_cmd is added to this list in
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index ff0e233ce3c9..cc8ce830ff4b 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -308,6 +308,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
>                             sizeof(struct async_poll));
>         io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
>                             sizeof(struct io_async_msghdr));
> +       io_alloc_cache_init(&ctx->rw_cache, IO_ALLOC_CACHE_MAX,
> +                           sizeof(struct io_async_rw));
>         io_futex_cache_init(ctx);
>         init_completion(&ctx->ref_comp);
>         xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
> @@ -2898,6 +2900,7 @@ static __cold void io_ring_ctx_free(struct io_ring_=
ctx *ctx)
>         io_eventfd_unregister(ctx);
>         io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free);
>         io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
> +       io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
>         io_futex_cache_free(ctx);
>         io_destroy_buffers(ctx);
>         mutex_unlock(&ctx->uring_lock);
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index dd4a1e1425e1..fcae75a08f2c 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -67,7 +67,7 @@ const struct io_issue_def io_issue_defs[] =3D {
>                 .iopoll                 =3D 1,
>                 .iopoll_queue           =3D 1,
>                 .vectored               =3D 1,
> -               .prep                   =3D io_prep_rwv,
> +               .prep                   =3D io_prep_readv,
>                 .issue                  =3D io_read,
>         },
>         [IORING_OP_WRITEV] =3D {
> @@ -81,7 +81,7 @@ const struct io_issue_def io_issue_defs[] =3D {
>                 .iopoll                 =3D 1,
>                 .iopoll_queue           =3D 1,
>                 .vectored               =3D 1,
> -               .prep                   =3D io_prep_rwv,
> +               .prep                   =3D io_prep_writev,
>                 .issue                  =3D io_write,
>         },
>         [IORING_OP_FSYNC] =3D {
> @@ -99,7 +99,7 @@ const struct io_issue_def io_issue_defs[] =3D {
>                 .ioprio                 =3D 1,
>                 .iopoll                 =3D 1,
>                 .iopoll_queue           =3D 1,
> -               .prep                   =3D io_prep_rw_fixed,
> +               .prep                   =3D io_prep_read_fixed,
>                 .issue                  =3D io_read,
>         },
>         [IORING_OP_WRITE_FIXED] =3D {
> @@ -112,7 +112,7 @@ const struct io_issue_def io_issue_defs[] =3D {
>                 .ioprio                 =3D 1,
>                 .iopoll                 =3D 1,
>                 .iopoll_queue           =3D 1,
> -               .prep                   =3D io_prep_rw_fixed,
> +               .prep                   =3D io_prep_write_fixed,
>                 .issue                  =3D io_write,
>         },
>         [IORING_OP_POLL_ADD] =3D {
> @@ -239,7 +239,7 @@ const struct io_issue_def io_issue_defs[] =3D {
>                 .ioprio                 =3D 1,
>                 .iopoll                 =3D 1,
>                 .iopoll_queue           =3D 1,
> -               .prep                   =3D io_prep_rw,
> +               .prep                   =3D io_prep_read,
>                 .issue                  =3D io_read,
>         },
>         [IORING_OP_WRITE] =3D {
> @@ -252,7 +252,7 @@ const struct io_issue_def io_issue_defs[] =3D {
>                 .ioprio                 =3D 1,
>                 .iopoll                 =3D 1,
>                 .iopoll_queue           =3D 1,
> -               .prep                   =3D io_prep_rw,
> +               .prep                   =3D io_prep_write,
>                 .issue                  =3D io_write,
>         },
>         [IORING_OP_FADVISE] =3D {
> @@ -490,14 +490,12 @@ const struct io_cold_def io_cold_defs[] =3D {
>         [IORING_OP_READV] =3D {
>                 .async_size             =3D sizeof(struct io_async_rw),
>                 .name                   =3D "READV",
> -               .prep_async             =3D io_readv_prep_async,
>                 .cleanup                =3D io_readv_writev_cleanup,
>                 .fail                   =3D io_rw_fail,
>         },
>         [IORING_OP_WRITEV] =3D {
>                 .async_size             =3D sizeof(struct io_async_rw),
>                 .name                   =3D "WRITEV",
> -               .prep_async             =3D io_writev_prep_async,
>                 .cleanup                =3D io_readv_writev_cleanup,
>                 .fail                   =3D io_rw_fail,
>         },
> @@ -699,6 +697,7 @@ const struct io_cold_def io_cold_defs[] =3D {
>  #endif
>         },
>         [IORING_OP_READ_MULTISHOT] =3D {
> +               .async_size             =3D sizeof(struct io_async_rw),
>                 .name                   =3D "READ_MULTISHOT",
>         },
>         [IORING_OP_WAITID] =3D {
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 35216e8adc29..583fe61a0acb 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -75,7 +75,153 @@ static int io_iov_buffer_select_prep(struct io_kiocb =
*req)
>         return 0;
>  }
>
> -int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +static int __io_import_iovec(int ddir, struct io_kiocb *req,
> +                            struct io_async_rw *io,
> +                            unsigned int issue_flags)
> +{
> +       const struct io_issue_def *def =3D &io_issue_defs[req->opcode];
> +       struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
> +       void __user *buf;
> +       size_t sqe_len;
> +
> +       buf =3D u64_to_user_ptr(rw->addr);
> +       sqe_len =3D rw->len;
> +
> +       if (!def->vectored || req->flags & REQ_F_BUFFER_SELECT) {
> +               if (io_do_buffer_select(req)) {
> +                       buf =3D io_buffer_select(req, &sqe_len, issue_fla=
gs);
> +                       if (!buf)
> +                               return -ENOBUFS;
> +                       rw->addr =3D (unsigned long) buf;
> +                       rw->len =3D sqe_len;
> +               }
> +
> +               return import_ubuf(ddir, buf, sqe_len, &io->s.iter);
> +       }
> +
> +       io->free_iovec =3D io->s.fast_iov;
> +       return __import_iovec(ddir, buf, sqe_len, UIO_FASTIOV, &io->free_=
iovec,
> +                               &io->s.iter, req->ctx->compat);
> +}
> +
> +static inline int io_import_iovec(int rw, struct io_kiocb *req,
> +                                 struct io_async_rw *io,
> +                                 unsigned int issue_flags)
> +{
> +       int ret;
> +
> +       ret =3D __io_import_iovec(rw, req, io, issue_flags);
> +       if (unlikely(ret < 0))
> +               return ret;
> +
> +       iov_iter_save_state(&io->s.iter, &io->s.iter_state);
> +       return 0;
> +}
> +
> +static void io_rw_iovec_free(struct io_async_rw *rw)
> +{
> +       if (rw->free_iovec) {
> +               kfree(rw->free_iovec);
> +               rw->free_iovec =3D NULL;
> +       }
> +}
> +
> +static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags=
)
> +{
> +       struct io_async_rw *rw =3D req->async_data;
> +
> +       if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
> +               io_rw_iovec_free(rw);
> +               return;
> +       }
> +       if (io_alloc_cache_put(&req->ctx->rw_cache, &rw->cache)) {
> +               req->async_data =3D NULL;
> +               req->flags &=3D ~REQ_F_ASYNC_DATA;
> +       }
> +}
> +
> +static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_f=
lags)
> +{
> +       /*
> +        * Disable quick recycling for anything that's gone through io-wq=
.
> +        * In theory, this should be fine to cleanup. However, some read =
or
> +        * write iter handling touches the iovec AFTER having called into=
 the
> +        * handler, eg to reexpand or revert. This means we can have:
> +        *
> +        * task                 io-wq
> +        *   issue
> +        *     punt to io-wq
> +        *                      issue
> +        *                        blkdev_write_iter()
> +        *                          ->ki_complete()
> +        *                            io_complete_rw()
> +        *                              queue tw complete
> +        *  run tw
> +        *    req_rw_cleanup
> +        *                      iov_iter_count() <- look at iov_iter agai=
n
> +        *
> +        * which can lead to a UAF. This is only possible for io-wq offlo=
ad
> +        * as the cleanup can run in parallel. As io-wq is not the fast p=
ath,
> +        * just leave cleanup to the end.
> +        *
> +        * This is really a bug in the core code that does this, any issu=
e
> +        * path should assume that a successful (or -EIOCBQUEUED) return =
can
> +        * mean that the underlying data can be gone at any time. But tha=
t
> +        * should be fixed seperately, and then this check could be kille=
d.
> +        */
> +       if (!(req->flags & REQ_F_REFCOUNT)) {
> +               req->flags &=3D ~REQ_F_NEED_CLEANUP;
> +               io_rw_recycle(req, issue_flags);
> +       }
> +}
> +
> +static int io_rw_alloc_async(struct io_kiocb *req)
> +{
> +       struct io_ring_ctx *ctx =3D req->ctx;
> +       struct io_cache_entry *entry;
> +       struct io_async_rw *rw;
> +
> +       entry =3D io_alloc_cache_get(&ctx->rw_cache);
> +       if (entry) {
> +               rw =3D container_of(entry, struct io_async_rw, cache);
> +               req->flags |=3D REQ_F_ASYNC_DATA;
> +               req->async_data =3D rw;
> +               goto done;
> +       }
> +
> +       if (!io_alloc_async_data(req)) {
> +               rw =3D req->async_data;
> +done:
> +               rw->free_iovec =3D NULL;
> +               rw->bytes_done =3D 0;
> +               return 0;
> +       }
> +
> +       return -ENOMEM;
> +}
> +
> +static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_impo=
rt)
> +{
> +       struct io_async_rw *rw;
> +       int ret;
> +
> +       if (io_rw_alloc_async(req))
> +               return -ENOMEM;
> +
> +       if (!do_import || io_do_buffer_select(req))
> +               return 0;
> +
> +       rw =3D req->async_data;
> +       ret =3D io_import_iovec(ddir, req, rw, 0);
> +       if (unlikely(ret < 0))
> +               return ret;
> +
> +       iov_iter_save_state(&rw->s.iter, &rw->s.iter_state);

It seems that the state of iov_iter gets saved in the caller io_import_iove=
c
as well. Do we need to save it again here?
--
Anuj Gupta

