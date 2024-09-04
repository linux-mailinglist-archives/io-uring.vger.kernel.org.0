Return-Path: <io-uring+bounces-3039-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D13DC96CA4E
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 00:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60CAC1F28906
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 22:26:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 172111885A5;
	Wed,  4 Sep 2024 22:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSZ/VpnK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8BC1849CB;
	Wed,  4 Sep 2024 22:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725488630; cv=none; b=o4Sl9XZzR4ZFcBCd+Zk2myO682ehwg0D5m+pj//xYx/A1bpy9ddciBtcQ6g4fv6cV9M8E8/A3F3hyBoMOuGa9VVZBPdRtHw6WOFNES8BUHALErUlFOlmJRfu5DR//E3/YVoLEugY6mWYit2Pci6MWvJhiqb+X6ExrD7uJpwIZ94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725488630; c=relaxed/simple;
	bh=kRVkt4+WhsatR9jnqTZpuVAEsksRgOSOji0M4RhrWOk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u/CcdhyW4xPLkKQqn75C7DIKWi36v6wIRGUe3uvhqXmoeJDbyHNXLVB9kfSaxfMxbv52LZvb8R0gpy94JOP+EjSs/VivRelgvPqzWzrwrxRUJQHvBsHSLH4Y8X6jAyci3bqRx1tR6aRR7bw7R8sSpltLd1+YiQEU5SZCRklPaBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mSZ/VpnK; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4567dd6f77fso11453151cf.0;
        Wed, 04 Sep 2024 15:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725488627; x=1726093427; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rKNYLQsVUjNoxMpBiS/2gPNv3mQBnalHju2QL1qf/nE=;
        b=mSZ/VpnKZUZDmzTm4duMa93sBeF/N8/F26RdtFFXwvH9Y7GY95KTcvqwrxLrGcuIka
         UIl5jiB64YKEQqfaGEuey6klKfvrkiIEkNricw0dvJCpsCv9AxPiy376QttR+y+g7BS1
         N9FpITqaDnOgXuiEh5w7aTICe3Mmlke+Mi9jS4/0h3MlTa7zplYtmUiWRFJ/XRxvqgcf
         zRadFIcs+jHZ23tYl/T2UrHiQBC7RKsZDdrDCvYg/33XnKX9h3v9Cooej7hrZnr3lAV/
         bUGxW4kAb+tfqn6a9oNG/imSQ3q4TAziK6pw03QS9AemMQRVbMZ/STOfmz8In+b3s+LN
         AB3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725488627; x=1726093427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rKNYLQsVUjNoxMpBiS/2gPNv3mQBnalHju2QL1qf/nE=;
        b=r7c6Dn00Jw2jXk576lZua4spTjhSrAIypl9UqyOo0ExjAtv5ju4Vi/aXa8VV+9B8pI
         uJdyLhE01TbCPaMz4Go94M886OEwO6vG0Z4g7OvrOu7Tq89vJA0+RAuqfTQGbUEVjXxn
         CcJVFpQHRZSxrljDTqMyHSGiQnr42fZ8WZBKuOBYt8b32nsafaDuRDRzi9GgKKwdWiFD
         gRii0ZDuk4a/bueFduIrYerQOalEp0NefQGQvhrhdY6nEK6igKpZjIkHRPc+e2zKior3
         rDl2uB93kgwqfsjuacTNAdOZVmSPsj4DJ94lcoz26GEDYsiYbE6KdzkaWU2gVzQcSrGX
         y/Rw==
X-Forwarded-Encrypted: i=1; AJvYcCVAvzBvyjpGadEsXOEVus5c/jDaZiutEZshnu+rAe8npHByzi9Cf3zJuGEhEP8h7mP/2ytuKQBgtrhj8lrsvA==@vger.kernel.org, AJvYcCVouwO6yNSANl8XCwUxaYaNgWFf1opx52B3xYLwWZUlcBouqAMPXz/H+Hioa9VOepZl0Q20gli3yQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5kiVEI7bunpEiYruOA/ywQSpHTIjh3c5Sp+u0QBZLcjrpJ3Hj
	U63S4wWyoWi9NMhs4klZ/A1FhUv7VBuuJwIawLmj4zAAH6QkqDsNYgiFgd5fV4ya6U1qO7dQ9ww
	yshSC2AUl6qEWDFOa3Cj3bpca6dk=
X-Google-Smtp-Source: AGHT+IFEEOiFvSYXzRR6icDiAj5ewRIRWNAmT0g7lDjUWxdcq00aSDjXrIKRz+g949MmDZimqtpysS3k6dbryR4n5eg=
X-Received: by 2002:a05:622a:34f:b0:446:5c58:805d with SMTP id
 d75a77b69052e-457f8c0a7d4mr55582261cf.19.1725488627003; Wed, 04 Sep 2024
 15:23:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
 <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-6-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-6-9207f7391444@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 4 Sep 2024 15:23:36 -0700
Message-ID: <CAJnrk1aFcDyJJ5rP1LFkpyUPHkzDv_bcOMPW2m28ZBS8T+WmUA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 06/17] fuse: Add the queue configuration ioctl
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 1, 2024 at 6:37=E2=80=AFAM Bernd Schubert <bschubert@ddn.com> w=
rote:
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>  fs/fuse/dev.c             | 30 ++++++++++++++++++++++++++++++
>  fs/fuse/dev_uring.c       |  2 ++
>  fs/fuse/dev_uring_i.h     | 13 +++++++++++++
>  fs/fuse/fuse_i.h          |  4 ++++
>  include/uapi/linux/fuse.h | 39 +++++++++++++++++++++++++++++++++++++++
>  5 files changed, 88 insertions(+)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 6489179e7260..06ea4dc5ffe1 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -2379,6 +2379,33 @@ static long fuse_dev_ioctl_backing_close(struct fi=
le *file, __u32 __user *argp)
>         return fuse_backing_close(fud->fc, backing_id);
>  }
>
> +#ifdef CONFIG_FUSE_IO_URING
> +static long fuse_uring_queue_ioc(struct file *file, __u32 __user *argp)
> +{
> +       int res =3D 0;
> +       struct fuse_dev *fud;
> +       struct fuse_conn *fc;
> +       struct fuse_ring_queue_config qcfg;
> +
> +       res =3D copy_from_user(&qcfg, (void *)argp, sizeof(qcfg));
> +       if (res !=3D 0)
> +               return -EFAULT;
> +
> +       res =3D _fuse_dev_ioctl_clone(file, qcfg.control_fd);

I'm confused how this works for > 1 queues. If I'm understanding this
correctly, if a system has multiple cores and the server would like
multi-queues, then the server needs to call the ioctl
FUSE_DEV_IOC_URING_QUEUE_CFG multiple times (each with a different
qid).

In this handler, when we get to _fuse_dev_ioctl_clone() ->
fuse_device_clone(), it allocates and installs a new fud and then sets
file->private_data to fud, but isn't this underlying file the same for
all of the queues since they are using the same fd for the ioctl
calls? It seems like every queue after the 1st would fail with -EINVAL
from the "if (new->private_data)" check in fuse_device_clone()?

Not sure if I'm missing something or if this intentionally doesn't
support multi-queue yet. If the latter, then I'm curious how you're
planning to get the fud for a specific queue given that
file->private_data and fuse_get_dev() only can support the single
queue case.

Thanks,
Joanne

> +       if (res !=3D 0)
> +               return res;
> +
> +       fud =3D fuse_get_dev(file);
> +       if (fud =3D=3D NULL)
> +               return -ENODEV;
> +       fc =3D fud->fc;
> +
> +       fud->ring_q =3D fuse_uring_get_queue(fc->ring, qcfg.qid);
> +
> +       return 0;
> +}
> +#endif
> +
>  static long
>  fuse_dev_ioctl(struct file *file, unsigned int cmd,
>                unsigned long arg)
> @@ -2398,6 +2425,9 @@ fuse_dev_ioctl(struct file *file, unsigned int cmd,
>  #ifdef CONFIG_FUSE_IO_URING
>         case FUSE_DEV_IOC_URING_CFG:
>                 return fuse_uring_conn_cfg(file, argp);
> +
> +       case FUSE_DEV_IOC_URING_QUEUE_CFG:
> +               return fuse_uring_queue_ioc(file, argp);
>  #endif
>         default:
>                 return -ENOTTY;
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index 4e7518ef6527..4dcb4972242e 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -42,6 +42,8 @@ static void fuse_uring_queue_cfg(struct fuse_ring_queue=
 *queue, int qid,
>
>                 ent->queue =3D queue;
>                 ent->tag =3D tag;
> +
> +               ent->state =3D FRRS_INIT;
>         }
>  }
>
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> index d4eff87bcd1f..301b37d16506 100644
> --- a/fs/fuse/dev_uring_i.h
> +++ b/fs/fuse/dev_uring_i.h
> @@ -14,6 +14,13 @@
>  /* IORING_MAX_ENTRIES */
>  #define FUSE_URING_MAX_QUEUE_DEPTH 32768
>
> +enum fuse_ring_req_state {
> +
> +       /* request is basially initialized */
> +       FRRS_INIT =3D 1,
> +
> +};
> +
>  /* A fuse ring entry, part of the ring queue */
>  struct fuse_ring_ent {
>         /* back pointer */
> @@ -21,6 +28,12 @@ struct fuse_ring_ent {
>
>         /* array index in the ring-queue */
>         unsigned int tag;
> +
> +       /*
> +        * state the request is currently in
> +        * (enum fuse_ring_req_state)
> +        */
> +       unsigned long state;
>  };
>
>  struct fuse_ring_queue {
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 33e81b895fee..5eb8552d9d7f 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -540,6 +540,10 @@ struct fuse_dev {
>
>         /** list entry on fc->devices */
>         struct list_head entry;
> +
> +#ifdef CONFIG_FUSE_IO_URING
> +       struct fuse_ring_queue *ring_q;
> +#endif
>  };
>
>  enum fuse_dax_mode {
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index a1c35e0338f0..143ed3c1c7b3 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -1118,6 +1118,18 @@ struct fuse_ring_config {
>         uint8_t padding[64];
>  };
>
> +struct fuse_ring_queue_config {
> +       /* qid the command is for */
> +       uint32_t qid;
> +
> +       /* /dev/fuse fd that initiated the mount. */
> +       uint32_t control_fd;
> +
> +       /* for future extensions */
> +       uint8_t padding[64];
> +};
> +
> +
>  /* Device ioctls: */
>  #define FUSE_DEV_IOC_MAGIC             229
>  #define FUSE_DEV_IOC_CLONE             _IOR(FUSE_DEV_IOC_MAGIC, 0, uint3=
2_t)
> @@ -1126,6 +1138,8 @@ struct fuse_ring_config {
>  #define FUSE_DEV_IOC_BACKING_CLOSE     _IOW(FUSE_DEV_IOC_MAGIC, 2, uint3=
2_t)
>  #define FUSE_DEV_IOC_URING_CFG         _IOR(FUSE_DEV_IOC_MAGIC, 3, \
>                                              struct fuse_ring_config)
> +#define FUSE_DEV_IOC_URING_QUEUE_CFG   _IOR(FUSE_DEV_IOC_MAGIC, 3, \
> +                                            struct fuse_ring_queue_confi=
g)
>
>  struct fuse_lseek_in {
>         uint64_t        fh;
> @@ -1233,4 +1247,29 @@ struct fuse_supp_groups {
>  #define FUSE_RING_HEADER_BUF_SIZE 4096
>  #define FUSE_RING_MIN_IN_OUT_ARG_SIZE 4096
>
> +/**
> + * This structure mapped onto the
> + */
> +struct fuse_ring_req {
> +       union {
> +               /* The first 4K are command data */
> +               char ring_header[FUSE_RING_HEADER_BUF_SIZE];
> +
> +               struct {
> +                       uint64_t flags;
> +
> +                       uint32_t in_out_arg_len;
> +                       uint32_t padding;
> +
> +                       /* kernel fills in, reads out */
> +                       union {
> +                               struct fuse_in_header in;
> +                               struct fuse_out_header out;
> +                       };
> +               };
> +       };
> +
> +       char in_out_arg[];
> +};
> +
>  #endif /* _LINUX_FUSE_H */
>
> --
> 2.43.0
>

