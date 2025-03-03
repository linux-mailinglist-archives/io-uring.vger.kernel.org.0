Return-Path: <io-uring+bounces-6914-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DCC2A4CAED
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 19:24:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48731174EDF
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 18:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE99522333D;
	Mon,  3 Mar 2025 18:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JyO2OUgG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF9922D4E5
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 18:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741026248; cv=none; b=gaZ2QHlsD6skpMleM3oB0X/HuptWLqWlkbbkNi+YNYsXoyQMEFtdwfG5iYpqzj9vSgonxt9ZGV+4MMz9yG1EcgAwFRFowFCUkrqjpUGLWaGKklTFcVtNFekQ40hVG7mEoZVD6JgvMn6fOFjEavm1wyyKJItMjrcsjfQg9m9EnrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741026248; c=relaxed/simple;
	bh=p0NnUtlbBTDxBP6cRAnPjo8uGArQwGk9DdsBLGqQB8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UVsC5wlQe0V07Yiey0T3WHpMZwQUht9uMH976ouL94885ChvKr95a3Fh0YLl/Z0Jz7AhU6aGTLOZZ/NOdeVoEsg+AVmq3iW6lUes5SllMwyBhMHjzP3YC0AH0BWA108069r1j+2cY7QdCa7nXIvPHqu5K8pgzDHoCLGV45nYTqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JyO2OUgG; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2fe851fa123so1157354a91.0
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 10:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1741026246; x=1741631046; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZxbXHY5mQ8uMi3eT+of8SLO41OfC1CL5Ym+j8nITv2M=;
        b=JyO2OUgGheZlLoWxPCm4l6Y/1C3vgetP5K5KRTHpphX9mIXX7iguo3d3ZbVBH6dv9d
         FtvqLJowhIseLZOJKT18wTO97ILNdBVGf+beODGEXy2m+59pKlpngmvjtVRktYGjrwtE
         IaSCLuIsRKSiXOfiRXlUtIfNe4t8DUparPGPu7EkSuwZy7MheoLbmwgYH9/jYjscXdW2
         MdR0v01A21Xql2VQnGB7Aga1wwmYldhxJKBifkZQglLKgdOG+kWB+sodMM/6YeWZG0oD
         6UF0MyM5gIMdageaLZ2Nk6Y9BCXqCFTHh0sCdD+0qj/lPDsq2jKItzfRCJYcqLpYzVm8
         AZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741026246; x=1741631046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZxbXHY5mQ8uMi3eT+of8SLO41OfC1CL5Ym+j8nITv2M=;
        b=iCc5pNAQMdOUsfWUF9GPungohG8NE0yMXwVmeKnJ2MA/RN1V+kwLcmydg96tEZYDI/
         68lwsRNPlKpi/R9za7uUNKj4Os7DK1YuLV05IXcK+fsnA/3FrXnA3E5gnmgBzb7tVCOy
         LH3bf/G5KRRDmRcmlKMOlL8big2NmHn6/IljHvZTr615Pv9aQfLKp5wZmj4QAGCYTF5T
         Nihd6VFJj9q5N85uIYUPgUp+MXybJzsfI7bEtDtVMBRYlgqsf1oxT1EDiyiMBLmu3dKv
         S2z76GuLC8yN/ebM8KlAVxGABEUHPtQ5pz5vPOoF/Wp45HJEbUrH2NyGVFD6uHkNYqs3
         Te0w==
X-Gm-Message-State: AOJu0Yxw9J9tSLbSSiIn+kPt+f51OyE7InFQkahJ3eCRl5C/Qv0wiiq5
	n7Fb7wDiSEy0nPMbvCbfmFRIEqfDa8HvLQstdv8DfqbXlSt/MPmCwHA8L5BrlZOR5BMt1ETs5Io
	S3gbVy3lFwfyr3CGHoLtkPAh3/ECe/m7PK4Ax2bFmXl76d96cJmo=
X-Gm-Gg: ASbGncu/FkHpTTy7oHvKbxwNslQ8FV9AP5sZI75tuQgAJQIuxd8F9c6aV24/6m73OlJ
	nMKUYi89+sQaYAZLrtMpvc72KNdHjtFh18mRdhJVpK+fDRTMTkV7fOb91FrAnqJaKdLXLYsYQKY
	ERx5Pi1rtyI3Q1B6Jtmdx5KFm1
X-Google-Smtp-Source: AGHT+IGlPs9tYPNuedud5jToB9i201QCfucnQVVAb+yTmRXRZuRVLllyk9axoW+FiOOTENCVA4xRW04f9KGG+dBFy1o=
X-Received: by 2002:a17:90b:3b8d:b0:2fa:6055:17e7 with SMTP id
 98e67ed59e1d1-2febac10932mr8848950a91.8.1741026245708; Mon, 03 Mar 2025
 10:24:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1741014186.git.asml.silence@gmail.com> <c76dd6eddfe98a9b714f577f28bdf20fa0a11dd4.1741014186.git.asml.silence@gmail.com>
In-Reply-To: <c76dd6eddfe98a9b714f577f28bdf20fa0a11dd4.1741014186.git.asml.silence@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 3 Mar 2025 10:23:53 -0800
X-Gm-Features: AQ5f1Jocp-t58_R9-dKzvXlfLotHro3RRu-4PQQTamIpB4kFcvaBPsuRYtSfF4w
Message-ID: <CADUfDZoDf6g7k48iy7jisPjbr+UoYXP_t1hKGV9SwrnWcOxFVg@mail.gmail.com>
Subject: Re: [PATCH 1/8] io_uring: introduce struct iou_vec
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Andres Freund <andres@anarazel.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 7:50=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> I need a convenient way to pass around and work with iovec+size pair,
> put them into a structure and makes use of it in rw.c
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/io_uring_types.h |  5 +++++
>  io_uring/rsrc.c                |  9 +++++++++
>  io_uring/rsrc.h                | 17 +++++++++++++++++
>  io_uring/rw.c                  | 17 +++++++----------
>  io_uring/rw.h                  |  6 ++++--
>  5 files changed, 42 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 35fc241c4672..9101f12d21ef 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -110,6 +110,11 @@ struct io_uring_task {
>         } ____cacheline_aligned_in_smp;
>  };
>
> +struct iou_vec {
> +       struct iovec            *iovec;
> +       unsigned                nr;
> +};
> +
>  struct io_uring {
>         u32 head;
>         u32 tail;
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index d6ac41840900..9b05e614819e 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1264,3 +1264,12 @@ int io_register_clone_buffers(struct io_ring_ctx *=
ctx, void __user *arg)
>         fput(file);
>         return ret;
>  }
> +
> +void io_vec_free(struct iou_vec *iv)
> +{
> +       if (!iv->iovec)
> +               return;
> +       kfree(iv->iovec);
> +       iv->iovec =3D NULL;
> +       iv->nr =3D 0;
> +}
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index 662244282b2c..e3f1cfb2ff7b 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -3,6 +3,7 @@
>  #define IOU_RSRC_H
>
>  #include <linux/lockdep.h>
> +#include <linux/io_uring_types.h>

I sent out a separate patch for this a couple days ago:
https://lore.kernel.org/io-uring/20250301183612.937529-1-csander@purestorag=
e.com/T/#u

>
>  enum {
>         IORING_RSRC_FILE                =3D 0,
> @@ -144,4 +145,20 @@ static inline void __io_unaccount_mem(struct user_st=
ruct *user,
>         atomic_long_sub(nr_pages, &user->locked_vm);
>  }
>
> +void io_vec_free(struct iou_vec *iv);
> +
> +static inline void io_vec_reset_iovec(struct iou_vec *iv,
> +                                     struct iovec *iovec, unsigned nr)
> +{
> +       io_vec_free(iv);
> +       iv->iovec =3D iovec;
> +       iv->nr =3D nr;
> +}
> +
> +static inline void io_alloc_cache_vec_kasan(struct iou_vec *iv)
> +{
> +       if (IS_ENABLED(CONFIG_KASAN))
> +               io_vec_free(iv);
> +}
> +
>  #endif
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 5ee9f8949e8b..ad7f647d48e9 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -87,9 +87,9 @@ static int io_import_vec(int ddir, struct io_kiocb *req=
,
>         int ret, nr_segs;
>         struct iovec *iov;
>
> -       if (io->free_iovec) {
> -               nr_segs =3D io->free_iov_nr;
> -               iov =3D io->free_iovec;
> +       if (io->vec.iovec) {
> +               nr_segs =3D io->vec.nr;
> +               iov =3D io->vec.iovec;
>         } else {
>                 nr_segs =3D 1;
>                 iov =3D &io->fast_iov;
> @@ -101,9 +101,7 @@ static int io_import_vec(int ddir, struct io_kiocb *r=
eq,
>                 return ret;
>         if (iov) {
>                 req->flags |=3D REQ_F_NEED_CLEANUP;
> -               io->free_iov_nr =3D io->iter.nr_segs;
> -               kfree(io->free_iovec);
> -               io->free_iovec =3D iov;
> +               io_vec_reset_iovec(&io->vec, iov, io->iter.nr_segs);
>         }
>         return 0;
>  }
> @@ -151,7 +149,7 @@ static void io_rw_recycle(struct io_kiocb *req, unsig=
ned int issue_flags)
>         if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
>                 return;
>
> -       io_alloc_cache_kasan(&rw->free_iovec, &rw->free_iov_nr);
> +       io_alloc_cache_vec_kasan(&rw->vec);
>         if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
>                 req->async_data =3D NULL;
>                 req->flags &=3D ~REQ_F_ASYNC_DATA;
> @@ -201,7 +199,7 @@ static int io_rw_alloc_async(struct io_kiocb *req)
>         rw =3D io_uring_alloc_async_data(&ctx->rw_cache, req);
>         if (!rw)
>                 return -ENOMEM;
> -       if (rw->free_iovec)
> +       if (rw->vec.iovec)
>                 req->flags |=3D REQ_F_NEED_CLEANUP;
>         rw->bytes_done =3D 0;
>         return 0;
> @@ -1327,7 +1325,6 @@ void io_rw_cache_free(const void *entry)
>  {
>         struct io_async_rw *rw =3D (struct io_async_rw *) entry;
>
> -       if (rw->free_iovec)
> -               kfree(rw->free_iovec);
> +       io_vec_free(&rw->vec);
>         kfree(rw);
>  }
> diff --git a/io_uring/rw.h b/io_uring/rw.h
> index bf121b81ebe8..e86a3858f48b 100644
> --- a/io_uring/rw.h
> +++ b/io_uring/rw.h
> @@ -3,19 +3,21 @@
>  #include <linux/io_uring_types.h>
>  #include <linux/pagemap.h>
>
> +#include "rsrc.h"

Why is this include necessary? struct iou_vec is defined in
io_uring_types.h. Seems like the include would make more sense in
rw.c.

Best,
Caleb

> +
>  struct io_meta_state {
>         u32                     seed;
>         struct iov_iter_state   iter_meta;
>  };
>
>  struct io_async_rw {
> +       struct iou_vec                  vec;
>         size_t                          bytes_done;
> -       struct iovec                    *free_iovec;
> +
>         struct_group(clear,
>                 struct iov_iter                 iter;
>                 struct iov_iter_state           iter_state;
>                 struct iovec                    fast_iov;
> -               int                             free_iov_nr;
>                 /*
>                  * wpq is for buffered io, while meta fields are used wit=
h
>                  * direct io
> --
> 2.48.1
>
>

