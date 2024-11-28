Return-Path: <io-uring+bounces-5110-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1C19DB172
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 03:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 547C9282419
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 02:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292372E401;
	Thu, 28 Nov 2024 02:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="exaeGZU7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9487404E;
	Thu, 28 Nov 2024 02:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732760607; cv=none; b=RXyK8nDagAwzFvZdXAcgOtwElzm/NpLMRPQTJy3njaJp1/JqwMqKC9tcC4CyB0M74s69apdoPmwKUSQreniN1bGX7iCHMpzcWBA5UBb1KV5hUBDHpSLe2RK+KpQHINoEtKEGZgMHIn0Uo3XOXJAwO+kMPIgOesWi5vDqM9hkRTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732760607; c=relaxed/simple;
	bh=AMTXwYGftq9jS2Oh4gMOdQJUeijCzkpwTyu2ajABwvY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gofkqwlArk5JDelMhhwIQWIZJAk2LVpTiXQJ6mYNutHCxG7ltejlqMhHv/waAPMQtycy1a4rzEVsLD0AaICHx7MMf9jWO8vFHSi9PF3GCjoXsYpj3vWoLv9COKdEwy4iPJ3cxdJqoT1fMN9qZoHL0lfKx2ABS4Q7Lf7UGtfi8nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=exaeGZU7; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-46695478d03so3108581cf.1;
        Wed, 27 Nov 2024 18:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732760603; x=1733365403; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNemXad2o4NHvB7A/omh9mJcybW+h4u4UPMSIMEUoTo=;
        b=exaeGZU7wZRTI46KS7dHS/GKtRSDa+ggg52/6JvC60xnmfdL2Qed7JEWT+Qehzp4ak
         3r96T3SHAthlX/v6IdQKiCbIgTTJnEt1aI3bZIsmxrUQQoRYVuk7C9dy4NobW5o/Pzxp
         u1DIKh8UuXH4NPBk4l+IfabCPyXaMST0DaVLVqwt22OCan9OfENkkzDW9n4Bygri5TEQ
         rELf9vHNvplsR/M1VLOwp1UhxSTz4+ko6quwOuSKRYJXkM1eytyQbTDTbM6npzAHeVG7
         MAQBO6t2kbQEkrCDGW6sk8yE6hj/cO+rKa+JUo929tkDx80Qlbn/xPwA46bNlNycTc5m
         8vFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732760603; x=1733365403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mNemXad2o4NHvB7A/omh9mJcybW+h4u4UPMSIMEUoTo=;
        b=DDxEPPHpI362SD33j3ZH6Np66RQ9yM9LUoZsrpuB/+D8JQyLWwbtio137yfDKX7d87
         xEn/dyo3M3vTFGbFvItxj8yvhSbK27B2/EhayD6G9SjlKG/Ot26S0+j4OTcdI59O5Faf
         jyYtywgXY4Y8RPn/OjdPk/FLmZn4/5oOBJZ+GcrC+q5iz512iJru0/be1P0W/c4BfHrf
         RQ94PaYv+bhwJfThWHQ6/4NZXI5FIxROoXUPpFWzyAoF+ZGE729T4hmCkptIUULALXPK
         5LRYpBv4pMHkbdoqjyY9cY9wsuMLr/H+q3CUKp4tw8x4XCiuJSv4uBbw2FbZzqqNhkDW
         GcRQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4qp/iY6Z3yrHH9Yi79mexpYDZMfPYoCHBJ30jR4MlFDfHr/9x5OqxMD38kIq4XsWrmCfyQXcc8w==@vger.kernel.org, AJvYcCUnl/v0ENRfxE5sBv/Lc/YS9eEhJNgUW6gPQFbaRl22RuG7eD4OqB1iZV7v4HSRl80rJca1UyWsALGi/ZH4KA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx98LvuShiNBhArN/q6QMYUo0IlYUbZGa4BeFxG81F5VMAIR1Ym
	hsaE6y3iLwKq5UQdDzCAYgQx2yvsrp4nSCbWTgdXbZ/GlooLj+jTiW1QBs2/WBR9Iz+zoi/YteN
	0WMClemI0lME4v0qx5L6t6VKhp4s=
X-Gm-Gg: ASbGncuSiUcbDU4CpAPgRKxGd8rNUNIZpqxpIyfMXB/4g/KzGoeZsMa35TqmpXI9PCO
	7NmYIXYjbQHLvn0/STwv98PcMMmJSs5M1jYVE6pYYeSaIUWE=
X-Google-Smtp-Source: AGHT+IGqI8jNL59FCVtKbr892Gxq9SqSAzLyFMVguVA5J/h+VYbr+zvZHmFUpkn9K6+vGU7sbe1GhR0dCfmS52LphGY=
X-Received: by 2002:a05:622a:1985:b0:466:a553:d867 with SMTP id
 d75a77b69052e-466b36b8a4dmr77930221cf.44.1732760603521; Wed, 27 Nov 2024
 18:23:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com> <20241127-fuse-uring-for-6-10-rfc4-v7-6-934b3a69baca@ddn.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-6-934b3a69baca@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 27 Nov 2024 18:23:12 -0800
Message-ID: <CAJnrk1YnWFQYG9VTr_1iUwcJmQEg3LemGOGkiqwbaqa4EaMUWw@mail.gmail.com>
Subject: Re: [PATCH RFC v7 06/16] fuse: {uring} Handle SQEs - register commands
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 5:41=E2=80=AFAM Bernd Schubert <bschubert@ddn.com> =
wrote:
>
> This adds basic support for ring SQEs (with opcode=3DIORING_OP_URING_CMD)=
.
> For now only FUSE_URING_REQ_FETCH is handled to register queue entries.
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>  fs/fuse/Kconfig           |  12 ++
>  fs/fuse/Makefile          |   1 +
>  fs/fuse/dev.c             |   4 +
>  fs/fuse/dev_uring.c       | 318 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/fuse/dev_uring_i.h     | 115 +++++++++++++++++
>  fs/fuse/fuse_i.h          |   5 +
>  fs/fuse/inode.c           |  10 ++
>  include/uapi/linux/fuse.h |  67 ++++++++++
>  8 files changed, 532 insertions(+)
>
> diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
> index 8674dbfbe59dbf79c304c587b08ebba3cfe405be..11f37cefc94b2af5a675c2388=
01560c822b95f1a 100644
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
> +
> +         If you want to allow fuse server/client communication through i=
o-uring,
> +         answer Y
> diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
> index ce0ff7a9007b94b4ab246b5271f227d126c768e8..fcf16b1c391a9bf11ca9f3a25=
b137acdb203ac47 100644
> --- a/fs/fuse/Makefile
> +++ b/fs/fuse/Makefile
> @@ -14,5 +14,6 @@ fuse-y :=3D dev.o dir.o file.o inode.o control.o xattr.=
o acl.o readdir.o ioctl.o
>  fuse-y +=3D iomode.o
>  fuse-$(CONFIG_FUSE_DAX) +=3D dax.o
>  fuse-$(CONFIG_FUSE_PASSTHROUGH) +=3D passthrough.o
> +fuse-$(CONFIG_FUSE_IO_URING) +=3D dev_uring.o
>
>  virtiofs-y :=3D virtio_fs.o
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 63c3865aebb7811fdf4a5729b2181ee8321421dc..0770373492ae9ee83c4154fed=
e9dcfd7be9fb33d 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -6,6 +6,7 @@
>    See the file COPYING.
>  */
>
> +#include "dev_uring_i.h"
>  #include "fuse_i.h"
>  #include "fuse_dev_i.h"
>
> @@ -2452,6 +2453,9 @@ const struct file_operations fuse_dev_operations =
=3D {
>         .fasync         =3D fuse_dev_fasync,
>         .unlocked_ioctl =3D fuse_dev_ioctl,
>         .compat_ioctl   =3D compat_ptr_ioctl,
> +#ifdef CONFIG_FUSE_IO_URING
> +       .uring_cmd      =3D fuse_uring_cmd,
> +#endif
>  };
>  EXPORT_SYMBOL_GPL(fuse_dev_operations);
>
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..af9c5f116ba1dcf6c01d0359d=
1a06491c92c32f9
> --- /dev/null
> +++ b/fs/fuse/dev_uring.c
> @@ -0,0 +1,318 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * FUSE: Filesystem in Userspace
> + * Copyright (c) 2023-2024 DataDirect Networks.
> + */
> +
> +#include <linux/fs.h>

nit: for consistency, should this line be placed directly above the
other "#include <linux..." line?

> +
> +#include "fuse_i.h"
> +#include "dev_uring_i.h"
> +#include "fuse_dev_i.h"
> +
> +#include <linux/io_uring/cmd.h>
> +
> +#ifdef CONFIG_FUSE_IO_URING
> +static bool __read_mostly enable_uring;
> +module_param(enable_uring, bool, 0644);
> +MODULE_PARM_DESC(enable_uring,
> +                "Enable uring userspace communication through uring.");

nit: The double uring seems a bit repetitive to me. Maybe just "enable
uring userspace communication" or "enable userspace communication
through uring"? Also, super nit but I noticed the other
MODULE_PARM_DESCs don't have trailing periods.

> +#endif
> +
> +bool fuse_uring_enabled(void)
> +{
> +       return enable_uring;
> +}
> +
> +static int fuse_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
> +{
> +       struct fuse_ring_queue *queue =3D ent->queue;
> +
> +       lockdep_assert_held(&queue->lock);
> +
> +       if (WARN_ON_ONCE(ent->state !=3D FRRS_USERSPACE))
> +               return -EIO;
> +
> +       ent->state =3D FRRS_COMMIT;
> +       list_move(&ent->list, &queue->ent_commit_queue);
> +
> +       return 0;
> +}
> +
> +void fuse_uring_destruct(struct fuse_conn *fc)
> +{
> +       struct fuse_ring *ring =3D fc->ring;
> +       int qid;
> +
> +       if (!ring)
> +               return;
> +
> +       for (qid =3D 0; qid < ring->nr_queues; qid++) {
> +               struct fuse_ring_queue *queue =3D ring->queues[qid];
> +
> +               if (!queue)
> +                       continue;
> +
> +               WARN_ON(!list_empty(&queue->ent_avail_queue));
> +               WARN_ON(!list_empty(&queue->ent_commit_queue));
> +
> +               kfree(queue);
> +               ring->queues[qid] =3D NULL;
> +       }
> +
> +       kfree(ring->queues);
> +       kfree(ring);
> +       fc->ring =3D NULL;
> +}
> +
> +#define FUSE_URING_IOV_SEGS 2 /* header and payload */

nit: to make the code flow easier, might be better to move #defines to
the top of the file after the includes.

> +
> +/*
> + * Basic ring setup for this connection based on the provided configurat=
ion
> + */
> +static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
> +{
> +       struct fuse_ring *ring =3D NULL;
> +       size_t nr_queues =3D num_possible_cpus();
> +       struct fuse_ring *res =3D NULL;
> +
> +       ring =3D kzalloc(sizeof(*fc->ring) +
> +                              nr_queues * sizeof(struct fuse_ring_queue)=
,

I think you just need kzalloc(sizeof(*fc->ring)); here since you're
allocating ring->queues later below

> +                      GFP_KERNEL_ACCOUNT);
> +       if (!ring)
> +               return NULL;
> +
> +       ring->queues =3D kcalloc(nr_queues, sizeof(struct fuse_ring_queue=
 *),
> +                              GFP_KERNEL_ACCOUNT);
> +       if (!ring->queues)
> +               goto out_err;
> +
> +       spin_lock(&fc->lock);
> +       if (fc->ring) {
> +               /* race, another thread created the ring in the mean time=
 */

nit: s/mean time/meantime

> +               spin_unlock(&fc->lock);
> +               res =3D fc->ring;
> +               goto out_err;
> +       }
> +
> +       fc->ring =3D ring;
> +       ring->nr_queues =3D nr_queues;
> +       ring->fc =3D fc;
> +
> +       spin_unlock(&fc->lock);
> +       return ring;
> +
> +out_err:
> +       if (ring)

I think you meant if (ring->queues)

> +               kfree(ring->queues);
> +       kfree(ring);
> +       return res;
> +}
> +
> +static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring =
*ring,
> +                                                      int qid)
> +{
> +       struct fuse_conn *fc =3D ring->fc;
> +       struct fuse_ring_queue *queue;
> +
> +       queue =3D kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
> +       if (!queue)
> +               return ERR_PTR(-ENOMEM);
> +       spin_lock(&fc->lock);

This probably doesn't make much of a difference but might be better to
minimize logic inside the lock, eg do the queue initialization stuff
outside the lock

> +       if (ring->queues[qid]) {
> +               spin_unlock(&fc->lock);
> +               kfree(queue);
> +               return ring->queues[qid];
> +       }
> +
> +       queue->qid =3D qid;
> +       queue->ring =3D ring;
> +       spin_lock_init(&queue->lock);
> +
> +       INIT_LIST_HEAD(&queue->ent_avail_queue);
> +       INIT_LIST_HEAD(&queue->ent_commit_queue);
> +
> +       WRITE_ONCE(ring->queues[qid], queue);

Just curious, why do we need WRITE_ONCE here if it's already protected
by the fc->lock?

> +       spin_unlock(&fc->lock);
> +
> +       return queue;
> +}
> +
> +/*
> + * Make a ring entry available for fuse_req assignment
> + */
> +static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
> +                                struct fuse_ring_queue *queue)
> +{
> +       list_move(&ring_ent->list, &queue->ent_avail_queue);
> +       ring_ent->state =3D FRRS_WAIT;
> +}
> +
> +/*
> + * fuse_uring_req_fetch command handling
> + */
> +static void _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
> +                             struct io_uring_cmd *cmd,
> +                             unsigned int issue_flags)
> +{
> +       struct fuse_ring_queue *queue =3D ring_ent->queue;
> +
> +       spin_lock(&queue->lock);
> +       fuse_uring_ent_avail(ring_ent, queue);
> +       ring_ent->cmd =3D cmd;
> +       spin_unlock(&queue->lock);
> +}
> +
> +/*
> + * sqe->addr is a ptr to an iovec array, iov[0] has the headers, iov[1]
> + * the payload
> + */
> +static int fuse_uring_get_iovec_from_sqe(const struct io_uring_sqe *sqe,
> +                                        struct iovec iov[FUSE_URING_IOV_=
SEGS])
> +{
> +       struct iovec __user *uiov =3D u64_to_user_ptr(READ_ONCE(sqe->addr=
));
> +       struct iov_iter iter;
> +       ssize_t ret;
> +
> +       if (sqe->len !=3D FUSE_URING_IOV_SEGS)
> +               return -EINVAL;
> +
> +       /*
> +        * Direction for buffer access will actually be READ and WRITE,
> +        * using write for the import should include READ access as well.
> +        */
> +       ret =3D import_iovec(WRITE, uiov, FUSE_URING_IOV_SEGS,
> +                          FUSE_URING_IOV_SEGS, &iov, &iter);
> +       if (ret < 0)
> +               return ret;
> +
> +       return 0;
> +}
> +
> +static int fuse_uring_fetch(struct io_uring_cmd *cmd, unsigned int issue=
_flags,
> +                           struct fuse_conn *fc)
> +{
> +       const struct fuse_uring_cmd_req *cmd_req =3D io_uring_sqe_cmd(cmd=
->sqe);
> +       struct fuse_ring *ring =3D fc->ring;
> +       struct fuse_ring_queue *queue;
> +       struct fuse_ring_ent *ring_ent;
> +       int err;
> +       struct iovec iov[FUSE_URING_IOV_SEGS];
> +
> +       err =3D fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
> +       if (err) {
> +               pr_info_ratelimited("Failed to get iovec from sqe, err=3D=
%d\n",
> +                                   err);
> +               return err;
> +       }
> +
> +       err =3D -ENOMEM;
> +       if (!ring) {
> +               ring =3D fuse_uring_create(fc);
> +               if (!ring)
> +                       return err;
> +       }
> +
> +       queue =3D ring->queues[cmd_req->qid];
> +       if (!queue) {
> +               queue =3D fuse_uring_create_queue(ring, cmd_req->qid);
> +               if (!queue)
> +                       return err;
> +       }
> +
> +       /*
> +        * The created queue above does not need to be destructed in
> +        * case of entry errors below, will be done at ring destruction t=
ime.
> +        */
> +
> +       ring_ent =3D kzalloc(sizeof(*ring_ent), GFP_KERNEL_ACCOUNT);
> +       if (ring_ent =3D=3D NULL)

nit: !ring_ent

> +               return err;
> +
> +       INIT_LIST_HEAD(&ring_ent->list);
> +
> +       ring_ent->queue =3D queue;
> +       ring_ent->cmd =3D cmd;
> +
> +       err =3D -EINVAL;
> +       if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
> +               pr_info_ratelimited("Invalid header len %zu\n", iov[0].io=
v_len);
> +               goto err;
> +       }
> +
> +       ring_ent->headers =3D iov[0].iov_base;
> +       ring_ent->payload =3D iov[1].iov_base;
> +       ring_ent->max_arg_len =3D iov[1].iov_len;
> +
> +       if (ring_ent->max_arg_len <
> +           max_t(size_t, FUSE_MIN_READ_BUFFER, fc->max_write)) {

If I'm understanding this correctly, iov[0] is the header and iov[1]
is the payload. Is this right that the payload len must always be
equal to fc->max_write?

Also, do we need to take into account fc->max_pages too?

> +               pr_info_ratelimited("Invalid req payload len %zu\n",
> +                                   ring_ent->max_arg_len);
> +               goto err;
> +       }
> +
> +       spin_lock(&queue->lock);
> +
> +       /*
> +        * FUSE_URING_REQ_FETCH is an initialization exception, needs
> +        * state override
> +        */
> +       ring_ent->state =3D FRRS_USERSPACE;
> +       err =3D fuse_ring_ent_unset_userspace(ring_ent);
> +       spin_unlock(&queue->lock);
> +       if (WARN_ON_ONCE(err !=3D 0))

nit: WARN_ON_ONCE(err)

> +               goto err;
> +
> +       _fuse_uring_fetch(ring_ent, cmd, issue_flags);
> +
> +       return 0;
> +err:
> +       list_del_init(&ring_ent->list);
> +       kfree(ring_ent);
> +       return err;
> +}
> +
> +/*
> + * Entry function from io_uring to handle the given passthrough command
> + * (op cocde IORING_OP_URING_CMD)
> + */
> +int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
> +{
> +       struct fuse_dev *fud;
> +       struct fuse_conn *fc;
> +       u32 cmd_op =3D cmd->cmd_op;
> +       int err;
> +
> +       /* Disabled for now, especially as teardown is not implemented ye=
t */
> +       pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
> +       return -EOPNOTSUPP;
> +
> +       if (!enable_uring) {
> +               pr_info_ratelimited("fuse-io-uring is disabled\n");
> +               return -EOPNOTSUPP;
> +       }
> +
> +       fud =3D fuse_get_dev(cmd->file);
> +       if (!fud) {
> +               pr_info_ratelimited("No fuse device found\n");
> +               return -ENOTCONN;
> +       }
> +       fc =3D fud->fc;
> +
> +       if (!fc->connected || fc->aborted)
> +               return fc->aborted ? -ECONNABORTED : -ENOTCONN;

I find
if (fc->aborted)
  return -ECONNABORTED;
if (!fc->connected)
   return -ENOTCONN;

easier to read
> +
> +       switch (cmd_op) {
> +       case FUSE_URING_REQ_FETCH:

FUSE_URING_REQ_FETCH is only used for initialization, would it be
clearer if this was named FUSE_URING_INIT or something like that?

> +               err =3D fuse_uring_fetch(cmd, issue_flags, fc);
> +               if (err) {
> +                       pr_info_once("fuse_uring_fetch failed err=3D%d\n"=
, err);
> +                       return err;
> +               }
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       return -EIOCBQUEUED;
> +}
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> new file mode 100644
> index 0000000000000000000000000000000000000000..75c644cc0b2bb3721b08f8695=
964815d53f46e92
> --- /dev/null
> +++ b/fs/fuse/dev_uring_i.h
> @@ -0,0 +1,115 @@
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
> +enum fuse_ring_req_state {
> +       FRRS_INVALID =3D 0,
> +
> +       /* The ring entry received from userspace and it being processed =
*/

nit: "it is being processed"

> +       FRRS_COMMIT,
> +
> +       /* The ring entry is waiting for new fuse requests */
> +       FRRS_WAIT,
> +
> +       /* The ring entry is in or on the way to user space */
> +       FRRS_USERSPACE,
> +};
> +
> +/** A fuse ring entry, part of the ring queue */
> +struct fuse_ring_ent {
> +       /* userspace buffer */
> +       struct fuse_uring_req_header __user *headers;
> +       void *__user *payload;
> +
> +       /* the ring queue that owns the request */
> +       struct fuse_ring_queue *queue;
> +
> +       struct io_uring_cmd *cmd;
> +
> +       struct list_head list;
> +
> +       /* size of payload buffer */
> +       size_t max_arg_len;
> +
> +       /*
> +        * state the request is currently in
> +        * (enum fuse_ring_req_state)
> +        */
> +       unsigned int state;
> +
> +       struct fuse_req *fuse_req;
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
> +       /*
> +        * queue lock, taken when any value in the queue changes _and_ al=
so
> +        * a ring entry state changes.
> +        */
> +       spinlock_t lock;
> +
> +       /* available ring entries (struct fuse_ring_ent) */
> +       struct list_head ent_avail_queue;
> +
> +       /*
> +        * entries in the process of being committed or in the process
> +        * to be send to userspace
> +        */
> +       struct list_head ent_commit_queue;
> +};
> +
> +/**
> + * Describes if uring is for communication and holds alls the data neede=
d
> + * for uring communication
> + */
> +struct fuse_ring {
> +       /* back pointer */
> +       struct fuse_conn *fc;
> +
> +       /* number of ring queues */
> +       size_t nr_queues;
> +
> +       struct fuse_ring_queue **queues;
> +};
> +
> +bool fuse_uring_enabled(void);
> +void fuse_uring_destruct(struct fuse_conn *fc);
> +int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
> +
> +#else /* CONFIG_FUSE_IO_URING */
> +
> +struct fuse_ring;
> +
> +static inline void fuse_uring_create(struct fuse_conn *fc)
> +{
> +}
> +
> +static inline void fuse_uring_destruct(struct fuse_conn *fc)
> +{
> +}
> +
> +static inline bool fuse_uring_enabled(void)
> +{
> +       return false;
> +}
> +
> +#endif /* CONFIG_FUSE_IO_URING */
> +
> +#endif /* _FS_FUSE_DEV_URING_I_H */
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index e3748751e231d0991c050b31bdd84db0b8016f9f..a21256ec4c3b4bd7c67eae2d0=
3b68d87dcc8234b 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -914,6 +914,11 @@ struct fuse_conn {
>         /** IDR for backing files ids */
>         struct idr backing_files_map;
>  #endif
> +
> +#ifdef CONFIG_FUSE_IO_URING
> +       /**  uring connection information*/
> +       struct fuse_ring *ring;
> +#endif
>  };
>
>  /*
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index fd3321e29a3e569bf06be22a5383cf34fd42c051..76267c79e920204175e571385=
3de8214c5555d46 100644
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
> @@ -959,6 +960,8 @@ static void delayed_release(struct rcu_head *p)
>  {
>         struct fuse_conn *fc =3D container_of(p, struct fuse_conn, rcu);
>
> +       fuse_uring_destruct(fc);
> +
>         put_user_ns(fc->user_ns);
>         fc->release(fc);
>  }
> @@ -1413,6 +1416,13 @@ void fuse_send_init(struct fuse_mount *fm)
>         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
>                 flags |=3D FUSE_PASSTHROUGH;
>
> +       /*
> +        * This is just an information flag for fuse server. No need to c=
heck
> +        * the reply - server is either sending IORING_OP_URING_CMD or no=
t.
> +        */
> +       if (fuse_uring_enabled())
> +               flags |=3D FUSE_OVER_IO_URING;
> +
>         ia->in.flags =3D flags;
>         ia->in.flags2 =3D flags >> 32;
>
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index f1e99458e29e4fdce5273bc3def242342f207ebd..6d39077edf8cde4fa77130efc=
ec16323839a676c 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -220,6 +220,14 @@
>   *
>   *  7.41
>   *  - add FUSE_ALLOW_IDMAP
> + *  7.42
> + *  - Add FUSE_OVER_IO_URING and all other io-uring related flags and da=
ta
> + *    structures:
> + *    - fuse_uring_ent_in_out
> + *    - fuse_uring_req_header
> + *    - fuse_uring_cmd_req
> + *    - FUSE_URING_IN_OUT_HEADER_SZ
> + *    - FUSE_URING_OP_IN_OUT_SZ
>   */
>
>  #ifndef _LINUX_FUSE_H
> @@ -425,6 +433,7 @@ struct fuse_file_lock {
>   * FUSE_HAS_RESEND: kernel supports resending pending requests, and the =
high bit
>   *                 of the request ID indicates resend requests
>   * FUSE_ALLOW_IDMAP: allow creation of idmapped mounts
> + * FUSE_OVER_IO_URING: Indicate that Client supports io-uring
>   */
>  #define FUSE_ASYNC_READ                (1 << 0)
>  #define FUSE_POSIX_LOCKS       (1 << 1)
> @@ -471,6 +480,7 @@ struct fuse_file_lock {
>  /* Obsolete alias for FUSE_DIRECT_IO_ALLOW_MMAP */
>  #define FUSE_DIRECT_IO_RELAX   FUSE_DIRECT_IO_ALLOW_MMAP
>  #define FUSE_ALLOW_IDMAP       (1ULL << 40)
> +#define FUSE_OVER_IO_URING     (1ULL << 41)
>
>  /**
>   * CUSE INIT request/reply flags
> @@ -1206,4 +1216,61 @@ struct fuse_supp_groups {
>         uint32_t        groups[];
>  };
>
> +/**
> + * Size of the ring buffer header
> + */
> +#define FUSE_URING_IN_OUT_HEADER_SZ 128
> +#define FUSE_URING_OP_IN_OUT_SZ 128
> +
> +struct fuse_uring_ent_in_out {
> +       uint64_t flags;
> +
> +       /* size of use payload buffer */
> +       uint32_t payload_sz;
> +       uint32_t padding;
> +
> +       uint8_t reserved[30];

out of curiosity, how was 30 chosen here? I think this makes the
struct 46 bytes?

> +};
> +
> +/**
> + * This structure mapped onto the
> + */
> +struct fuse_uring_req_header {
> +       /* struct fuse_in / struct fuse_out */
> +       char in_out[FUSE_URING_IN_OUT_HEADER_SZ];
> +
> +       /* per op code structs */
> +       char op_in[FUSE_URING_OP_IN_OUT_SZ];
> +
> +       /* struct fuse_ring_in_out */
> +       char ring_ent_in_out[sizeof(struct fuse_uring_ent_in_out)];
> +};
> +
> +/**
> + * sqe commands to the kernel
> + */
> +enum fuse_uring_cmd {
> +       FUSE_URING_REQ_INVALID =3D 0,
> +
> +       /* submit sqe to kernel to get a request */
> +       FUSE_URING_REQ_FETCH =3D 1,
> +
> +       /* commit result and fetch next request */
> +       FUSE_URING_REQ_COMMIT_AND_FETCH =3D 2,
> +};
> +
> +/**
> + * In the 80B command area of the SQE.
> + */
> +struct fuse_uring_cmd_req {
> +       uint64_t flags;
> +
> +       /* entry identifier */
> +       uint64_t commit_id;
> +
> +       /* queue the command is for (queue index) */
> +       uint16_t qid;
> +       uint8_t padding[6];
> +};
> +
>  #endif /* _LINUX_FUSE_H */
>

I'll be out the rest of this week for an American holiday
(Thanksgiving) and next week for a work trip but will review the rest
of this patchset after that when i get back.

Thanks,
Joanne
> --
> 2.43.0
>

