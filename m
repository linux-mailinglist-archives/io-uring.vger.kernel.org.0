Return-Path: <io-uring+bounces-3016-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 010C296AD70
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 02:44:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 408F4B22A16
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 00:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3288646;
	Wed,  4 Sep 2024 00:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CuFb51Jy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB80563D;
	Wed,  4 Sep 2024 00:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725410642; cv=none; b=XgLQ37TY9yLItmFZFHN2O621bAyZrY6ardFW4H5qDy/1061CDLuvUatTI9XbNwbR1APK1OS6XYAnqCQVG4ZonUx2tmvREmBK84GWi5oBESEL2f+TJW5oc45Zphtwsp1mJ4UAoOmOJv3ZQGWzb7/5hJRFE1v4fY6mBxLqUX9bgjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725410642; c=relaxed/simple;
	bh=xMheCBJq1iVIAGoZDiI6b/7UtinRWkuIhNKgOeu4bfw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CQ832aPD7Ljhmxtm7p9x+okoAbdtH9OW0Js18J6feaAASSmT1QXQdTHEOoaD3NHlGUFsq3rZA0rvyJastwoA05PpFy9mtxmLCHxu/4g2Dnay1HQwfd7p78uNKpC8qT9vu1H6MhBaE69bCGUB9A92STZ9yh7UvK9ekJaQ1pw3gx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CuFb51Jy; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-457e2537611so10497351cf.0;
        Tue, 03 Sep 2024 17:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725410640; x=1726015440; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OFx8LsBVxTFMHP02PY2VCbFPhgSta6r+g9d0+VkRJ7I=;
        b=CuFb51JyhAIuRrvHUd2HeuI76V1Xr3K7wHiJMI4T0i/08ZzoiqVem4ckV1M1AGie+v
         aWt9icJnirxLjmuKXtLVjYv39wnwPKiVvWnXUJmDcGvRawS8iysNEHvlbl0+XP5paMwn
         Ka755oGEF7JNT+QfBgaHFE3rUPc2ghUaAh3CyDRHKwD6Ax5ES6hvqx13ICSSoI3h5xL0
         9SY3vmAsBo5zocMP8qK+mfVW9lnwgjMuZqzu5ThGTqkxMCnmdvzFyA9zYihEBHuPp2H0
         MdoEhkn6X3d8ecT9Q3FpD2h5EPd7czqtamuB6r0bNc7yHQ9niIMUvKe3NzvNJeNhWCg/
         9uDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725410640; x=1726015440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OFx8LsBVxTFMHP02PY2VCbFPhgSta6r+g9d0+VkRJ7I=;
        b=FvTObM4s1mk0BWIQUvySwKBybRrBGCE349YLpCL7kwmDAk2XGVs/iy815Fq3Syleb7
         y76cB0mrBiejku1wS8zxPBDobeXmPMt5AGLl+2mTnTChpc/FwuByzuqdBnlL8GPqjAeh
         Ua4ri+DL7ZC+MRt/or+c/kaNHa/Py0q38WusVHb00Vw7Ef46qI/Wrn3y/Pw6LeHKzM1h
         VWSz+rQuUIDi3ULgZ6TZnbAxsZ2Pf3D1BXQdzrmY/waiJZx8Rl1Z7XuwQqdv1/2WoveD
         UGP6vP/L45RYK6Jy+mbvEJWOxmj3y01upSd566ZGok7mHVyqaJUYV/X9qam0eVrd2gN6
         R2/w==
X-Forwarded-Encrypted: i=1; AJvYcCWzT4dkc5fMx8v3QSMiqnY3eUZNyo0mJWpUsl85TehVJx2ytuw9McTpI/ys1zwedsCJ9hdRpHxVp70blri3SQ==@vger.kernel.org, AJvYcCXe20M3Xj8SqWWB+yfDcwu9jR7qE+/GxOgg5doaFy/Y48+0oHM3KfaOTgoMXEMx7sHgGpFeVNCdnA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyON9PPXwGLSOFikCTKiWyVOm9ZWExxpdwsnDzJ11nLMwS078tM
	140mF1ioNAs+52cw1nB0qMzjPuFKXFZWwAxkApXuIOwFeBw1IkMAPhpmuhpd6Ebc/mYSsKIDZxg
	Z/B9jDXak8rl4qBexTcdNQYq8dmM=
X-Google-Smtp-Source: AGHT+IF4yQqXQTC5zB+aE0NMBMLMNdyYL5pjvGEVvTcC4gif0bjzU4WKEKMrvY5oCLHmKDJjdDMJBItMjavu2eh3HKE=
X-Received: by 2002:a05:622a:5987:b0:457:cfae:5a84 with SMTP id
 d75a77b69052e-457cfae5bc0mr99032111cf.55.1725410639534; Tue, 03 Sep 2024
 17:43:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
 <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-5-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-5-9207f7391444@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 3 Sep 2024 17:43:48 -0700
Message-ID: <CAJnrk1am+s=z2iDcdQ9vXrTvo3wAXH9UE57BpXAovOqdNdYKHg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 05/17] fuse: Add a uring config ioctl
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
> This only adds the initial ioctl for basic fuse-uring initialization.
> More ioctl types will be added later to initialize queues.
>
> This also adds data structures needed or initialized by the ioctl
> command and that will be used later.
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>

Exciting to read through the work in this patchset!

I left some comments, lots of which are more granular / implementation
details than high-level design, in case that would be helpful to you
in reducing the turnaround time for this patchset. Let me know if
you'd prefer a hold-off on that though, if your intention with the RFC
is more to get high-level feedback.


Thanks,
Joanne

> ---
>  fs/fuse/Kconfig           |  12 ++++
>  fs/fuse/Makefile          |   1 +
>  fs/fuse/dev.c             |  33 ++++++++---
>  fs/fuse/dev_uring.c       | 141 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/fuse/dev_uring_i.h     | 113 +++++++++++++++++++++++++++++++++++++
>  fs/fuse/fuse_dev_i.h      |   1 +
>  fs/fuse/fuse_i.h          |   5 ++
>  fs/fuse/inode.c           |   3 +
>  include/uapi/linux/fuse.h |  47 ++++++++++++++++
>  9 files changed, 349 insertions(+), 7 deletions(-)
>
> diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
> index 8674dbfbe59d..11f37cefc94b 100644
> --- a/fs/fuse/Kconfig
> +++ b/fs/fuse/Kconfig
> @@ -63,3 +63,15 @@ config FUSE_PASSTHROUGH
>           to be performed directly on a backing file.
>
>           If you want to allow passthrough operations, answer Y.
> +
> +config FUSE_IO_URING
> +       bool "FUSE communication over io-uring"
> +       default y
> +       depends on FUSE_FS
> +       depends on IO_URING
> +       help
> +         This allows sending FUSE requests over the IO uring interface a=
nd
> +          also adds request core affinity.

nit: this wording is a little bit awkward imo. Maybe something like
"... over the IO uring interface and enables core affinity for each
request" or "... over the IO uring interface and pins each request to
a specific core"?
I think there's an extra whitespace here in front of "also".

> +
> +         If you want to allow fuse server/client communication through i=
o-uring,
> +         answer Y

super nit: missing a period at the end of Y.

> diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
> index 6e0228c6d0cb..7193a14374fd 100644
> --- a/fs/fuse/Makefile
> +++ b/fs/fuse/Makefile
> @@ -11,5 +11,6 @@ fuse-y :=3D dev.o dir.o file.o inode.o control.o xattr.=
o acl.o readdir.o ioctl.o
>  fuse-y +=3D iomode.o
>  fuse-$(CONFIG_FUSE_DAX) +=3D dax.o
>  fuse-$(CONFIG_FUSE_PASSTHROUGH) +=3D passthrough.o
> +fuse-$(CONFIG_FUSE_IO_URING) +=3D dev_uring.o
>
>  virtiofs-y :=3D virtio_fs.o
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index dbc222f9b0f0..6489179e7260 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -8,6 +8,7 @@
>
>  #include "fuse_i.h"
>  #include "fuse_dev_i.h"
> +#include "dev_uring_i.h"
>
>  #include <linux/init.h>
>  #include <linux/module.h>
> @@ -26,6 +27,13 @@
>  MODULE_ALIAS_MISCDEV(FUSE_MINOR);
>  MODULE_ALIAS("devname:fuse");
>
> +#ifdef CONFIG_FUSE_IO_URING
> +static bool __read_mostly enable_uring;

I don't see where enable_uring gets used in this patchset, are you
planning to use this in a separate future patchset?

> +module_param(enable_uring, bool, 0644);
> +MODULE_PARM_DESC(enable_uring,
> +                "Enable uring userspace communication through uring.");
                                     ^^^ extra "uring" here?

> +#endif
> +
>  static struct kmem_cache *fuse_req_cachep;
>
>  static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *re=
q)
> @@ -2298,16 +2306,12 @@ static int fuse_device_clone(struct fuse_conn *fc=
, struct file *new)
>         return 0;
>  }
>
> -static long fuse_dev_ioctl_clone(struct file *file, __u32 __user *argp)
> +static long _fuse_dev_ioctl_clone(struct file *file, int oldfd)

I think it'd be a bit clearer if this change was moved to patch 06/17
"Add the queue configuration ioctl" where it gets used

>  {
>         int res;
> -       int oldfd;
>         struct fuse_dev *fud =3D NULL;
>         struct fd f;
>
> -       if (get_user(oldfd, argp))
> -               return -EFAULT;
> -
>         f =3D fdget(oldfd);
>         if (!f.file)
>                 return -EINVAL;
> @@ -2330,6 +2334,16 @@ static long fuse_dev_ioctl_clone(struct file *file=
, __u32 __user *argp)
>         return res;
>  }
>
> +static long fuse_dev_ioctl_clone(struct file *file, __u32 __user *argp)
> +{
> +       int oldfd;
> +
> +       if (get_user(oldfd, argp))
> +               return -EFAULT;
> +
> +       return _fuse_dev_ioctl_clone(file, oldfd);
> +}
> +
>  static long fuse_dev_ioctl_backing_open(struct file *file,
>                                         struct fuse_backing_map __user *a=
rgp)
>  {
> @@ -2365,8 +2379,9 @@ static long fuse_dev_ioctl_backing_close(struct fil=
e *file, __u32 __user *argp)
>         return fuse_backing_close(fud->fc, backing_id);
>  }
>
> -static long fuse_dev_ioctl(struct file *file, unsigned int cmd,
> -                          unsigned long arg)
> +static long
> +fuse_dev_ioctl(struct file *file, unsigned int cmd,
> +              unsigned long arg)

I think you accidentally added this line break here?

>  {
>         void __user *argp =3D (void __user *)arg;
>
> @@ -2380,6 +2395,10 @@ static long fuse_dev_ioctl(struct file *file, unsi=
gned int cmd,
>         case FUSE_DEV_IOC_BACKING_CLOSE:
>                 return fuse_dev_ioctl_backing_close(file, argp);
>
> +#ifdef CONFIG_FUSE_IO_URING
> +       case FUSE_DEV_IOC_URING_CFG:
> +               return fuse_uring_conn_cfg(file, argp);
> +#endif
>         default:
>                 return -ENOTTY;
>         }
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> new file mode 100644
> index 000000000000..4e7518ef6527
> --- /dev/null
> +++ b/fs/fuse/dev_uring.c
> @@ -0,0 +1,141 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * FUSE: Filesystem in Userspace
> + * Copyright (c) 2023-2024 DataDirect Networks.
> + */
> +
> +#include "fuse_dev_i.h"
> +#include "fuse_i.h"
> +#include "dev_uring_i.h"
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/poll.h>
> +#include <linux/sched/signal.h>
> +#include <linux/uio.h>
> +#include <linux/miscdevice.h>
> +#include <linux/pagemap.h>
> +#include <linux/file.h>
> +#include <linux/slab.h>
> +#include <linux/pipe_fs_i.h>
> +#include <linux/swap.h>
> +#include <linux/splice.h>
> +#include <linux/sched.h>
> +#include <linux/io_uring.h>
> +#include <linux/mm.h>
> +#include <linux/io.h>
> +#include <linux/io_uring.h>
> +#include <linux/io_uring/cmd.h>
> +#include <linux/topology.h>
> +#include <linux/io_uring/cmd.h>

Are all of these headers (eg miscdevice.h, pipe_fs_i.h, topology.h) needed?

> +
> +static void fuse_uring_queue_cfg(struct fuse_ring_queue *queue, int qid,
> +                                struct fuse_ring *ring)
> +{
> +       int tag;
> +
> +       queue->qid =3D qid;
> +       queue->ring =3D ring;
> +
> +       for (tag =3D 0; tag < ring->queue_depth; tag++) {
> +               struct fuse_ring_ent *ent =3D &queue->ring_ent[tag];
> +
> +               ent->queue =3D queue;
> +               ent->tag =3D tag;
> +       }
> +}
> +
> +static int _fuse_uring_conn_cfg(struct fuse_ring_config *rcfg,
> +                               struct fuse_conn *fc, struct fuse_ring *r=
ing,
> +                               size_t queue_sz)

Should this function just be marked "void" as the return type?

> +{
> +       ring->numa_aware =3D rcfg->numa_aware;
> +       ring->nr_queues =3D rcfg->nr_queues;
> +       ring->per_core_queue =3D rcfg->nr_queues > 1;
> +
> +       ring->max_nr_sync =3D rcfg->sync_queue_depth;
> +       ring->max_nr_async =3D rcfg->async_queue_depth;
> +       ring->queue_depth =3D ring->max_nr_sync + ring->max_nr_async;
> +
> +       ring->req_buf_sz =3D rcfg->user_req_buf_sz;
> +
> +       ring->queue_size =3D queue_sz;
> +
> +       fc->ring =3D ring;
> +       ring->fc =3D fc;
> +
> +       return 0;
> +}
> +
> +static int fuse_uring_cfg_sanity(struct fuse_ring_config *rcfg)
> +{
> +       if (rcfg->nr_queues =3D=3D 0) {
> +               pr_info("zero number of queues is invalid.\n");

I think this might get misinterpreted as "zero queues are invalid" -
maybe something like: "fuse_ring_config nr_queues=3D0 is invalid arg"
might be clearer?

> +               return -EINVAL;
> +       }
> +
> +       if (rcfg->nr_queues > 1 && rcfg->nr_queues !=3D num_present_cpus(=
)) {

Will it always be that nr_queues must be the number of CPUs on the
system or will that constraint be relaxed in the future?

> +               pr_info("nr-queues (%d) does not match nr-cores (%d).\n",

nit: %u for nr_queues,  s/nr-queues/nr_queues
It might be useful here to specify "uring nr_queues" as well to make
it more obvious

> +                       rcfg->nr_queues, num_present_cpus());
> +               return -EINVAL;
> +       }
> +

Should this function also sanity check that the queue depth is <=3D
FUSE_URING_MAX_QUEUE_DEPTH?

> +       return 0;
> +}
> +
> +/*
> + * Basic ring setup for this connection based on the provided configurat=
ion
> + */
> +int fuse_uring_conn_cfg(struct file *file, void __user *argp)

Is there a reason we pass in "void __user *argp" instead of "struct
fuse_ring_config __user *argp"?

> +{
> +       struct fuse_ring_config rcfg;
> +       int res;
> +       struct fuse_dev *fud;
> +       struct fuse_conn *fc;
> +       struct fuse_ring *ring =3D NULL;
> +       struct fuse_ring_queue *queue;
> +       int qid;
> +
> +       res =3D copy_from_user(&rcfg, (void *)argp, sizeof(rcfg));

I don't think we need this "(void *)" cast here

> +       if (res !=3D 0)
> +               return -EFAULT;
> +       res =3D fuse_uring_cfg_sanity(&rcfg);
> +       if (res !=3D 0)
> +               return res;
> +
> +       fud =3D fuse_get_dev(file);
> +       if (fud =3D=3D NULL)

nit: if (!fud)

> +               return -ENODEV;

Should this be -ENODEV or -EPERM? -ENODEV makes sense to me but I'm
seeing other callers of fuse_get_dev() in fuse/dev.c return -EPERM
when fud is NULL.

> +       fc =3D fud->fc;
> +

Should we add a check
if (fc->ring)
   return -EINVAL (or -EALREADY);

if not, then i think we need to move the "for (qid =3D 0; ...)" logic
below to be within the "if (fc->ring =3D=3D NULL)" check

> +       if (fc->ring =3D=3D NULL) {

nit: if (!fc->ring)

> +               size_t queue_depth =3D rcfg.async_queue_depth +
> +                                    rcfg.sync_queue_depth;
> +               size_t queue_sz =3D sizeof(struct fuse_ring_queue) +
> +                                 sizeof(struct fuse_ring_ent) * queue_de=
pth;
> +
> +               ring =3D kvzalloc(sizeof(*fc->ring) + queue_sz * rcfg.nr_=
queues,
> +                               GFP_KERNEL_ACCOUNT);
> +               if (ring =3D=3D NULL)

nit: if (!ring)

> +                       return -ENOMEM;
> +
> +               spin_lock(&fc->lock);
> +               if (fc->ring =3D=3D NULL)

if (!fc->ring)

> +                       res =3D _fuse_uring_conn_cfg(&rcfg, fc, ring, que=
ue_sz);
> +               else
> +                       res =3D -EALREADY;
> +               spin_unlock(&fc->lock);
> +               if (res !=3D 0)

nit: if (res)

> +                       goto err;
> +       }
> +
> +       for (qid =3D 0; qid < ring->nr_queues; qid++) {
> +               queue =3D fuse_uring_get_queue(ring, qid);
> +               fuse_uring_queue_cfg(queue, qid, ring);
> +       }
> +
> +       return 0;
> +err:
> +       kvfree(ring);
> +       return res;
> +}
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> new file mode 100644
> index 000000000000..d4eff87bcd1f
> --- /dev/null
> +++ b/fs/fuse/dev_uring_i.h
> @@ -0,0 +1,113 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + *
> + * FUSE: Filesystem in Userspace
> + * Copyright (c) 2023-2024 DataDirect Networks.
> + */
> +
> +#ifndef _FS_FUSE_DEV_URING_I_H
> +#define _FS_FUSE_DEV_URING_I_H
> +
> +#include "fuse_i.h"
> +
> +#ifdef CONFIG_FUSE_IO_URING
> +
> +/* IORING_MAX_ENTRIES */

nit: I'm not sure this comment is that helpful. The
"FUSE_URING_MAX_QUEUE_DEPTH" name is clear enough, I think.

> +#define FUSE_URING_MAX_QUEUE_DEPTH 32768
> +
> +/* A fuse ring entry, part of the ring queue */
> +struct fuse_ring_ent {
> +       /* back pointer */
> +       struct fuse_ring_queue *queue;

Do you think it's worth using the tag to find the queue (i think we
can just use some containerof magic to get the queue backpointer here
since ring_ent is embedded within struct fuse_ring_queue?) instead of
having this be an explicit 8 byte pointer? I'm thinking about the case
where the user sets a queue depth of 32k (eg
FUSE_URING_MAX_QUEUE_DEPTH) and is on an 8-core system where they set
nr_queues to 8. This would end up in 8 * 32k * 8 =3D 2 MiB extra memory
allocated which seems non-trivial (but I guess this is also an extreme
case). Curious what your thoughts on this are.

> +
> +       /* array index in the ring-queue */
> +       unsigned int tag;

Just wondering, is this called "tag" instead of "index" to be
consistent with an io-ring naming convention?

> +};
> +
> +struct fuse_ring_queue {
> +       /*
> +        * back pointer to the main fuse uring structure that holds this
> +        * queue
> +        */
> +       struct fuse_ring *ring;
> +
> +       /* queue id, typically also corresponds to the cpu core */
> +       unsigned int qid;
> +
> +       /* size depends on queue depth */
> +       struct fuse_ring_ent ring_ent[] ____cacheline_aligned_in_smp;
> +};
> +
> +/**
> + * Describes if uring is for communication and holds alls the data neede=
d

nit: maybe this should just be "Holds all the data needed for uring
communication"?

nit: s/alls/all

> + * for uring communication
> + */
> +struct fuse_ring {
> +       /* back pointer */
> +       struct fuse_conn *fc;
> +
> +       /* number of ring queues */

I think it's worth calling out here too that this must be the number
of CPUs on the system and that each CPU operates its own ring queue.

> +       size_t nr_queues;
> +
> +       /* number of entries per queue */
> +       size_t queue_depth;
> +
> +       /* req_arg_len + sizeof(struct fuse_req) */

What is req_arg_len? In _fuse_uring_conn_cfg(), it looks like this
gets set to rcfg->user_req_buf_sz which is passed in from userspace,
but from what I understand, "struct fuse_req" is a kernel-defined
struct? I'm a bit confused overall what the comment refers to, but I
also haven't yet looked through the libfuse change yet for this
patchset.

> +       size_t req_buf_sz;
> +
> +       /* max number of background requests per queue */
> +       size_t max_nr_async;
> +
> +       /* max number of foreground requests */

nit: for consistency with the comment for max_nr_async,
s/requests/"requests per queue"

> +       size_t max_nr_sync;

It's interesting to me that this can get configured by userspace for
background requests vs foreground requests. My perspective was that
from the userspace POV, there's no differentiation between background
vs foreground requests. Personally, I'm still not really even sure yet
which of the read requests are async vs sync when I do a 8 MiB read
call for example (iirc, I was seeing both, when it first tried the
readahead path). It seems a bit like overkill to me but maybe there
are some servers that actually do care a lot about this.

> +
> +       /* size of struct fuse_ring_queue + queue-depth * entry-size */
> +       size_t queue_size;
> +
> +       /* one queue per core or a single queue only ? */
> +       unsigned int per_core_queue : 1;
> +
> +       /* numa aware memory allocation */
> +       unsigned int numa_aware : 1;
> +
> +       struct fuse_ring_queue queues[] ____cacheline_aligned_in_smp;
> +};
> +
> +void fuse_uring_abort_end_requests(struct fuse_ring *ring);

nit: I think it'd be a bit cleaner if this got moved to patch 12/17
(fuse: {uring} Handle teardown of ring entries) when it gets used

> +int fuse_uring_conn_cfg(struct file *file, void __user *argp);
> +
> +static inline void fuse_uring_conn_destruct(struct fuse_conn *fc)
> +{
> +       if (fc->ring =3D=3D NULL)

nit: if (!fc->ring)

> +               return;
> +
> +       kvfree(fc->ring);
> +       fc->ring =3D NULL;
> +}
> +
> +static inline struct fuse_ring_queue *
> +fuse_uring_get_queue(struct fuse_ring *ring, int qid)
> +{
> +       char *ptr =3D (char *)ring->queues;

Do we need to cast this to char * or can we just do the math below as
return ring->queues + qid;

> +
> +       if (WARN_ON(qid > ring->nr_queues))

Should this be >=3D since qid is 0-indexed?

we should never reach here, but it feels like if we do, we should just
automatically return NULL.

> +               qid =3D 0;
> +
> +       return (struct fuse_ring_queue *)(ptr + qid * ring->queue_size);
> +}
> +
> +#else /* CONFIG_FUSE_IO_URING */
> +
> +struct fuse_ring;
> +
> +static inline void fuse_uring_conn_init(struct fuse_ring *ring,
> +                                       struct fuse_conn *fc)
> +{
> +}
> +
> +static inline void fuse_uring_conn_destruct(struct fuse_conn *fc)
> +{
> +}
> +
> +#endif /* CONFIG_FUSE_IO_URING */
> +
> +#endif /* _FS_FUSE_DEV_URING_I_H */
> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> index 6c506f040d5f..e6289bafb788 100644
> --- a/fs/fuse/fuse_dev_i.h
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -7,6 +7,7 @@
>  #define _FS_FUSE_DEV_I_H
>
>  #include <linux/types.h>
> +#include <linux/fs.h>

I think you accidentally included this.

>
>  /* Ordinary requests have even IDs, while interrupts IDs are odd */
>  #define FUSE_INT_REQ_BIT (1ULL << 0)
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index f23919610313..33e81b895fee 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -917,6 +917,11 @@ struct fuse_conn {
>         /** IDR for backing files ids */
>         struct idr backing_files_map;
>  #endif
> +
> +#ifdef CONFIG_FUSE_IO_URING
> +       /**  uring connection information*/
nit: need extra space between information and */
> +       struct fuse_ring *ring;
> +#endif
>  };
>
>  /*
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 99e44ea7d875..33a080b24d65 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -7,6 +7,7 @@
>  */
>
>  #include "fuse_i.h"
> +#include "dev_uring_i.h"
>
>  #include <linux/pagemap.h>
>  #include <linux/slab.h>
> @@ -947,6 +948,8 @@ static void delayed_release(struct rcu_head *p)
>  {
>         struct fuse_conn *fc =3D container_of(p, struct fuse_conn, rcu);
>
> +       fuse_uring_conn_destruct(fc);

I think it's cleaner if this is moved to fuse_free_conn than here.

> +
>         put_user_ns(fc->user_ns);
>         fc->release(fc);
>  }
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index d08b99d60f6f..a1c35e0338f0 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -1079,12 +1079,53 @@ struct fuse_backing_map {
>         uint64_t        padding;
>  };
>
> +enum fuse_uring_ioctl_cmd {

Do you have a link to the libfuse side? I'm not seeing these get used
in the patchset - I'm curious how libfuse will be using these then?

> +       /* not correctly initialized when set */
> +       FUSE_URING_IOCTL_CMD_INVALID    =3D 0,
> +
> +       /* Ioctl to prepare communucation with io-uring */

nit: communication spelling

> +       FUSE_URING_IOCTL_CMD_RING_CFG   =3D 1,
> +
> +       /* Ring queue configuration ioctl */
> +       FUSE_URING_IOCTL_CMD_QUEUE_CFG  =3D 2,
> +};
> +
> +enum fuse_uring_cfg_flags {
> +       /* server/daemon side requests numa awareness */
> +       FUSE_URING_WANT_NUMA =3D 1ul << 0,

nit: 1UL for consistency

> +};
> +
> +struct fuse_ring_config {
> +       /* number of queues */
> +       uint32_t nr_queues;
> +
> +       /* number of foreground entries per queue */
> +       uint32_t sync_queue_depth;
> +
> +       /* number of background entries per queue */
> +       uint32_t async_queue_depth;
> +
> +       /*
> +        * buffer size userspace allocated per request buffer
> +        * from the mmaped queue buffer
> +        */
> +       uint32_t user_req_buf_sz;
> +
> +       /* ring config flags */
> +       uint64_t numa_aware:1;
> +
> +       /* for future extensions */
> +       uint8_t padding[64];
> +};
> +
>  /* Device ioctls: */
>  #define FUSE_DEV_IOC_MAGIC             229
>  #define FUSE_DEV_IOC_CLONE             _IOR(FUSE_DEV_IOC_MAGIC, 0, uint3=
2_t)
>  #define FUSE_DEV_IOC_BACKING_OPEN      _IOW(FUSE_DEV_IOC_MAGIC, 1, \
>                                              struct fuse_backing_map)
>  #define FUSE_DEV_IOC_BACKING_CLOSE     _IOW(FUSE_DEV_IOC_MAGIC, 2, uint3=
2_t)
> +#define FUSE_DEV_IOC_URING_CFG         _IOR(FUSE_DEV_IOC_MAGIC, 3, \
> +                                            struct fuse_ring_config)
>
>  struct fuse_lseek_in {
>         uint64_t        fh;
> @@ -1186,4 +1227,10 @@ struct fuse_supp_groups {
>         uint32_t        groups[];
>  };
>
> +/**
> + * Size of the ring buffer header
> + */
> +#define FUSE_RING_HEADER_BUF_SIZE 4096
> +#define FUSE_RING_MIN_IN_OUT_ARG_SIZE 4096

I think this'd be cleaner to review if this got moved to the patch
where this gets used

> +
>  #endif /* _LINUX_FUSE_H */
>
> --
> 2.43.0
>

