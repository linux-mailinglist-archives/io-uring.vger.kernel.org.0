Return-Path: <io-uring+bounces-5453-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32ECE9EDD13
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 02:30:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86446283700
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 01:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F153261FD7;
	Thu, 12 Dec 2024 01:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IIceCkGN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E59A7DA8C;
	Thu, 12 Dec 2024 01:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733967011; cv=none; b=KYvV1mO0qT9IGEnqRU3VbB/DF2PzOGxvo+5Jbm7FyMFe1ue0pel/Hv1k33w1fXh/eU89645n3RipSxquzJx6902Y9P62lwFp3Abk8JczBGjajluap7tqhivlJHgjeDoGV9ZloQHBeCDJtdOo6D51By0EmXPunAZIDnwTLGVMymE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733967011; c=relaxed/simple;
	bh=NcFVTUU3L/ESM8L1F0pDZYHdHDJdmdbqUdp2ZP8pG4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t8GH4+Y3SWGYi+azeHS0ucMJOUP7HrHYL6eKjsYq9Oobyzfwt3RMV1Q8koH0wjck0r1iCn5sYhrdHaKSKr+LO3jzuw/unNRtkJF0AEBOsOlexFXUHYb5EkGhR62+CEfP2Y8QDs94T4EKs1SJxV2S70PdIrvYMSMGiEMt25pRhxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IIceCkGN; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4675ae3dcf9so666201cf.1;
        Wed, 11 Dec 2024 17:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733967008; x=1734571808; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fH3lUZvYUBmgJ0E9R+5Wpm8ljlK6Xrn13yh8/DxS+l8=;
        b=IIceCkGNxRHLq06PC+eh3+O2GfdM/nfPBrJCq/S9tekmwZ4sSFhDj0rpn0kNm4uqlq
         DAENhEJA/SRfj2/a9le0UzwJ4smlQ6eco/6RzOmrJvzDq2phXbl0cfxk0eWU5VkGLJ+R
         /rhdkEkFcpI/ITS8gxvnIpZ4R+R78hzjpaDGjH9crhz8U819UB9P4joftc8IA/Y4bY0e
         +RdNyavqg1S//m6DdMDpDlCtfexRAHZXh7qFsqhZFy8rqQABrHIaOiGTMKSehGtsGnys
         SvbTkXAOwiUB2tglPbzaH4LeDgSgCw3U21H3/hTa/kJOO+mq2ABhD9ye2n3AJpExD/3p
         z+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733967008; x=1734571808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fH3lUZvYUBmgJ0E9R+5Wpm8ljlK6Xrn13yh8/DxS+l8=;
        b=GCfVkJHkijc+QYm4GRRO7HHa+bZfqP+xfvRDnZKgWeF9ybqZhitx55SSrob5863arW
         x35pFFJpXM4w/BaxIeYwROXuY+UJufsWu3Xv9kaxZ+295udkYNjIPw3MY6KCRrXpt0Ki
         Ayg0C06AXsGzvBWCKSekI+g28h0rk0F1BcbG2+dejbHKjHpDT8CQuCIT8hcf6sY0c7mn
         mq30wYxZuQ2OQjZlGXy8mvms/0XQGHa/fUQB0A39VvGDc5jn7Xhk41TQcaqttekEwQxc
         q64LmAwf1MB3w94h/nF1hxMozvySkkf+/l7DZjLFwYso342Dw7zwPXko2/Yek6uU8fpE
         958w==
X-Forwarded-Encrypted: i=1; AJvYcCVJbMLoBQY3nyK/IT5gzjJ+X8U+c4uisSa5aF4go86lA1bZBf3j9C5OvcirOvGcoLoiSFHx5yxq4BveSisO3g==@vger.kernel.org, AJvYcCWv6j4X0wz2ynGJCY4M9DmLhnaqWdtKXQHtFUsFgT6XEkzTsWdxdi3+stLarbgO74KQOVslh85Ugw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyPM5v5Bm1msEnzfBCiSSzwGomZow43IfZMXP6NmUVCJ4p95c7/
	hsu25JE5oD30mQ9hqa1gfNBL9ZapWSSoFSOIykDpxxFxM1kDgs0Kap2XUnKIIBMc9kO2vzxsZtq
	KdCjNl0gs4Vpr1VRLh0Ljks5y8WU=
X-Gm-Gg: ASbGncslas0tcRow3OxCf3V+WA9/xhyzBqZrjVVkHVSq6JNemBrllFPh2mJZSMDAgrU
	iontHjl/q112ifLNlB4zlHQMge4W5RzKq0+iLZY7wkZQnzsvkfbIWqQ==
X-Google-Smtp-Source: AGHT+IGMMNSpXzHP3BE5G91omkjBmMzMkf7HOdV5F8t047wRm4RItRK9PeLcGnTMO775Wzlg7EBawePCu+0K2DwzykE=
X-Received: by 2002:a05:622a:1b92:b0:466:b2c9:fb00 with SMTP id
 d75a77b69052e-46796156f94mr32009941cf.3.1733967008056; Wed, 11 Dec 2024
 17:30:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com> <20241209-fuse-uring-for-6-10-rfc4-v8-6-d9f9f2642be3@ddn.com>
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-6-d9f9f2642be3@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 11 Dec 2024 17:29:57 -0800
Message-ID: <CAJnrk1bUnERBPoCphckscZgCrsHv1FocponCQgZkThQ9T7gMog@mail.gmail.com>
Subject: Re: [PATCH v8 06/16] fuse: {io-uring} Handle SQEs - register commands
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 9, 2024 at 6:57=E2=80=AFAM Bernd Schubert <bschubert@ddn.com> w=
rote:
>
> This adds basic support for ring SQEs (with opcode=3DIORING_OP_URING_CMD)=
.
> For now only FUSE_IO_URING_CMD_REGISTER is handled to register queue
> entries.
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>

Nice, thanks for your work on this! Left a few comments below

> ---
>  fs/fuse/Kconfig           |  12 ++
>  fs/fuse/Makefile          |   1 +
>  fs/fuse/dev_uring.c       | 339 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/fuse/dev_uring_i.h     | 118 ++++++++++++++++
>  fs/fuse/fuse_i.h          |   5 +
>  fs/fuse/inode.c           |  10 ++
>  include/uapi/linux/fuse.h |  76 ++++++++++-
>  7 files changed, 560 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
> index 8674dbfbe59dbf79c304c587b08ebba3cfe405be..ca215a3cba3e310d1359d0692=
02193acdcdb172b 100644
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
> +         This allows sending FUSE requests over the io-uring interface a=
nd
> +          also adds request core affinity.
> +
> +         If you want to allow fuse server/client communication through i=
o-uring,
> +         answer Y
> diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
> index 2c372180d631eb340eca36f19ee2c2686de9714d..3f0f312a31c1cc200c0c91a08=
6b30a8318e39d94 100644
> --- a/fs/fuse/Makefile
> +++ b/fs/fuse/Makefile
> @@ -15,5 +15,6 @@ fuse-y +=3D iomode.o
>  fuse-$(CONFIG_FUSE_DAX) +=3D dax.o
>  fuse-$(CONFIG_FUSE_PASSTHROUGH) +=3D passthrough.o
>  fuse-$(CONFIG_SYSCTL) +=3D sysctl.o
> +fuse-$(CONFIG_FUSE_IO_URING) +=3D dev_uring.o
>
>  virtiofs-y :=3D virtio_fs.o
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..f0c5807c94a55f9c9e2aa95ad=
078724971ddd125
> --- /dev/null
> +++ b/fs/fuse/dev_uring.c
> @@ -0,0 +1,339 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * FUSE: Filesystem in Userspace
> + * Copyright (c) 2023-2024 DataDirect Networks.
> + */
> +
> +#include "fuse_i.h"
> +#include "dev_uring_i.h"
> +#include "fuse_dev_i.h"
> +
> +#include <linux/fs.h>
> +#include <linux/io_uring/cmd.h>
> +
> +#ifdef CONFIG_FUSE_IO_URING
> +static bool __read_mostly enable_uring;
> +module_param(enable_uring, bool, 0644);
> +MODULE_PARM_DESC(enable_uring,
> +                "Enable userspace communication through io-uring");
> +#endif
> +
> +#define FUSE_URING_IOV_SEGS 2 /* header and payload */
> +
> +
> +bool fuse_uring_enabled(void)
> +{
> +       return enable_uring;
> +}
> +
> +static int fuse_ring_ent_unset_userspace(struct fuse_ring_ent *ent)

Instead of the name fuse_ring_ent_unset_userspace(), what are your
thoughts on naming it fuse_ring_ent_set_commit()?
fuse_ring_ent_set_commit() sounds more representative to me of what
this function is intended for than fuse_ring_ent_unset_userspace(),
especially as it'll also be called by fuse_uring_commit_fetch() too

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
> +/*
> + * Basic ring setup for this connection based on the provided configurat=
ion
> + */
> +static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
> +{
> +       struct fuse_ring *ring =3D NULL;

nit: don't need to set to NULL here since it gets set immediately

> +       size_t nr_queues =3D num_possible_cpus();
> +       struct fuse_ring *res =3D NULL;
> +       size_t max_payload_size;
> +
> +       ring =3D kzalloc(sizeof(*fc->ring), GFP_KERNEL_ACCOUNT);
> +       if (!ring)
> +               return NULL;
> +
> +       ring->queues =3D kcalloc(nr_queues, sizeof(struct fuse_ring_queue=
 *),
> +                              GFP_KERNEL_ACCOUNT);
> +       if (!ring->queues)
> +               goto out_err;
> +
> +       max_payload_size =3D max_t(size_t, FUSE_MIN_READ_BUFFER, fc->max_=
write);

I think we can just use max here instead of max_t since
FUSE_MIN_READ_BUFFER is never negative so the signed to unsigned
promotion will be okay

> +       max_payload_size =3D
> +               max_t(size_t, max_payload_size, fc->max_pages * PAGE_SIZE=
);

Same here, i think we can just use max here instead of max_t

> +
> +       spin_lock(&fc->lock);
> +       if (fc->ring) {
> +               /* race, another thread created the ring in the meantime =
*/
> +               spin_unlock(&fc->lock);
> +               res =3D fc->ring;
> +               goto out_err;
> +       }
> +
> +       fc->ring =3D ring;
> +       ring->nr_queues =3D nr_queues;
> +       ring->fc =3D fc;
> +       ring->max_payload_sz =3D max_payload_size;
> +
> +       spin_unlock(&fc->lock);
> +       return ring;
> +
> +out_err:
> +       kfree(ring->queues);
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

I think we need to return NULL here since fuse_uring_register() checks
"if (!queue)" for error

> +       queue->qid =3D qid;
> +       queue->ring =3D ring;
> +       spin_lock_init(&queue->lock);
> +
> +       INIT_LIST_HEAD(&queue->ent_avail_queue);
> +       INIT_LIST_HEAD(&queue->ent_commit_queue);
> +
> +       spin_lock(&fc->lock);
> +       if (ring->queues[qid]) {
> +               spin_unlock(&fc->lock);
> +               kfree(queue);
> +               return ring->queues[qid];
> +       }
> +
> +       WRITE_ONCE(ring->queues[qid], queue);

Thanks for your explanation on v7 about why this needs WRITE_ONCE.
Might be worth including that as a comment here for future readers.

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

Just curious what your thoughts are on this - would it make sense to
rename FRRS_WAIT to FRRS_AVAILABLE? It seems like FRRS_WAIT is the
state where the entry is available for new requests, and
FRRS_AVAILABLE might be more descriptive of a name than FRRS_WAIT?
Feel free to nix the idea though if you hate it

> +}
> +
> +/*
> + * fuse_uring_req_fetch command handling
> + */
> +static void _fuse_uring_register(struct fuse_ring_ent *ring_ent,
> +                                struct io_uring_cmd *cmd,
> +                                unsigned int issue_flags)
> +{
> +       struct fuse_ring_queue *queue =3D ring_ent->queue;
> +
> +       spin_lock(&queue->lock);
> +       fuse_uring_ent_avail(ring_ent, queue);
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
> +/* Register header and payload buffer with the kernel and fetch a reques=
t */
> +static int fuse_uring_register(struct io_uring_cmd *cmd,
> +                              unsigned int issue_flags, struct fuse_conn=
 *fc)
> +{
> +       const struct fuse_uring_cmd_req *cmd_req =3D io_uring_sqe_cmd(cmd=
->sqe);
> +       struct fuse_ring *ring =3D fc->ring;
> +       struct fuse_ring_queue *queue;
> +       struct fuse_ring_ent *ring_ent;
> +       int err;
> +       struct iovec iov[FUSE_URING_IOV_SEGS];
> +       size_t payload_size;
> +       unsigned int qid =3D READ_ONCE(cmd_req->qid);

Why do we need READ_ONCE()? I looked at the ublk_drv.c code and they
do this too for some io_uring_sqe_cmd()s but not for others. My (maybe
wrong) understanding is that cmd_req->qid won't ever be concurrently
modified?

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
> +       if (qid >=3D ring->nr_queues) {
> +               pr_info_ratelimited("fuse: Invalid ring qid %u\n", qid);
> +               return -EINVAL;
> +       }
> +
> +       err =3D -ENOMEM;
> +       queue =3D ring->queues[qid];
> +       if (!queue) {
> +               queue =3D fuse_uring_create_queue(ring, qid);
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
> +       if (!ring_ent)
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
> +       payload_size =3D iov[1].iov_len;
> +
> +       if (payload_size < ring->max_payload_sz) {
> +               pr_info_ratelimited("Invalid req payload len %zu\n",
> +                                   payload_size);
> +               goto err;
> +       }
> +
> +       spin_lock(&queue->lock);
> +
> +       /*
> +        * FUSE_IO_URING_CMD_REGISTER is an initialization exception, nee=
ds
> +        * state override
> +        */
> +       ring_ent->state =3D FRRS_USERSPACE;
> +       err =3D fuse_ring_ent_unset_userspace(ring_ent);
> +       spin_unlock(&queue->lock);
> +       if (WARN_ON_ONCE(err))

imo, the WARN_ON_ONCE isn't necessary since this condition has the
WARN_ON_ONCE() already in fuse_ring_ent_unset_userspace()

> +               goto err;
> +

This looks good to me but it might look even cleaner to move the
ring_ent logic into another function and then call that here.

> +       _fuse_uring_register(ring_ent, cmd, issue_flags);

IMO, _fuse_uring_register() as a function name is too similar to
fuse_uring_register(). Maybe "fuse_uring_do_register()" instead? kind
of like how there's fuse_dev_write() and fuse_dev_do_write()?

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

nit: "cocde" -> "code"

> + */
> +int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
> +                                 unsigned int issue_flags)
> +{
> +       struct fuse_dev *fud;
> +       struct fuse_conn *fc;
> +       u32 cmd_op =3D cmd->cmd_op;
> +       int err;
> +
> +       if (!enable_uring) {
> +               pr_info_ratelimited("fuse-io-uring is disabled\n");
> +               return -EOPNOTSUPP;
> +       }
> +
> +       /* This extra SQE size holds struct fuse_uring_cmd_req */
> +       if (!(issue_flags & IO_URING_F_SQE128))
> +               return -EINVAL;
> +
> +       fud =3D fuse_get_dev(cmd->file);
> +       if (!fud) {
> +               pr_info_ratelimited("No fuse device found\n");
> +               return -ENOTCONN;
> +       }
> +       fc =3D fud->fc;
> +
> +       if (fc->aborted)
> +               return -ECONNABORTED;
> +       if (!fc->connected)
> +               return -ENOTCONN;
> +
> +       /*
> +        * fuse_uring_register() needs the ring to be initialized,
> +        * we need to know the max payload size
> +        */

Does this comment belong here?

> +       if (!fc->initialized)
> +               return -EAGAIN;
> +
> +       switch (cmd_op) {
> +       case FUSE_IO_URING_CMD_REGISTER:

Nice, this opcode name seems a lot more clear to me.

> +               err =3D fuse_uring_register(cmd, issue_flags, fc);
> +               if (err) {
> +                       pr_info_once("FUSE_IO_URING_CMD_REGISTER failed e=
rr=3D%d\n",

pr_info instead of pr_info_once seems more useful here. My
understanding of pr_info_once is that this message would get printed
only once during the kernel's lifetime, but there could be multiple
fuse servers wanting to use io-uring

> +                                    err);
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
> index 0000000000000000000000000000000000000000..73e9e3063bb038e8341d85cd2=
a440421275e6aa8
> --- /dev/null
> +++ b/fs/fuse/dev_uring_i.h
> @@ -0,0 +1,118 @@
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
> +       /* The ring entry received from userspace and it is being process=
ed */
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

Is this supposed to be void __user *payload or void *__user *payload?
i see the definition for iovec as

struct iovec {
  void *iov_base;
  size_t iov_len;
};

and then in fuse_uring_register() we do "ring_ent->payload =3D
iov[1].iov_base". It seems like this should be "void __user *payload"?


> +
> +       /* the ring queue that owns the request */
> +       struct fuse_ring_queue *queue;
> +
> +       struct io_uring_cmd *cmd;
> +
> +       struct list_head list;
> +
> +       /*
> +        * state the request is currently in
> +        * (enum fuse_ring_req_state)
> +        */
> +       unsigned int state;

Any reason why we don't define this as "enum fuse_ring_req_state
state;"? Then we could get rid of that 2nd line in the comment as well

Might also be worth including a comment here that it's protected by
the ring queue spinlock.

> +
> +       struct fuse_req *fuse_req;
> +
> +       /* commit id to identify the server reply */
> +       uint64_t commit_id;
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

If I'm understanding it correctly, qid will always correspond to the
cpu core, correct? Should we get rid of "typically" here? i think that
sets the expectation that it might not.

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

IMO, I think the name could just be "avail_queue" and "commit_queue"
instead of "ent_avail_queue" and "ent_commit_queue".

> +
> +       /*
> +        * entries in the process of being committed or in the process
> +        * to be send to userspace

nit: "send" -> "sent"

> +        */
> +       struct list_head ent_commit_queue;
> +};
> +
> +/**
> + * Describes if uring is for communication and holds alls the data neede=
d
> + * for uring communication
> + */

IMO, this could just be "Holds all the data needed for uring
communication". i think the first part of this comment (eg "describes
if uring is for communication") applies more to the "bool
fuse_uring_enabled(void);" line.

> +struct fuse_ring {
> +       /* back pointer */
> +       struct fuse_conn *fc;
> +
> +       /* number of ring queues */
> +       size_t nr_queues;
> +
> +       /* maximum payload/arg size */
> +       size_t max_payload_sz;
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
> index babddd05303796d689a64f0f5a890066b43170ac..d75dd9b59a5c35b76919db760=
645464f604517f5 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -923,6 +923,11 @@ struct fuse_conn {
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
> index 3ce4f4e81d09e867c3a7db7b1dbb819f88ed34ef..e4f9bbacfc1bc6f51d5d01b4c=
47b42cc159ed783 100644
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
> @@ -992,6 +993,8 @@ static void delayed_release(struct rcu_head *p)
>  {
>         struct fuse_conn *fc =3D container_of(p, struct fuse_conn, rcu);
>
> +       fuse_uring_destruct(fc);
> +
>         put_user_ns(fc->user_ns);
>         fc->release(fc);
>  }
> @@ -1446,6 +1449,13 @@ void fuse_send_init(struct fuse_mount *fm)
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
> index f1e99458e29e4fdce5273bc3def242342f207ebd..388cb4b93f48575d5e57c27b0=
2f59a80e2fbe93c 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -220,6 +220,15 @@
>   *
>   *  7.41
>   *  - add FUSE_ALLOW_IDMAP
> + *  7.42
> + *  - Add FUSE_OVER_IO_URING and all other io-uring related flags and da=
ta
> + *    structures:
> + *    - struct fuse_uring_ent_in_out
> + *    - struct fuse_uring_req_header
> + *    - struct fuse_uring_cmd_req
> + *    - FUSE_URING_IN_OUT_HEADER_SZ
> + *    - FUSE_URING_OP_IN_OUT_SZ
> + *    - enum fuse_uring_cmd
>   */
>
>  #ifndef _LINUX_FUSE_H
> @@ -255,7 +264,7 @@
>  #define FUSE_KERNEL_VERSION 7
>
>  /** Minor version number of this interface */
> -#define FUSE_KERNEL_MINOR_VERSION 41
> +#define FUSE_KERNEL_MINOR_VERSION 42
>
>  /** The node ID of the root inode */
>  #define FUSE_ROOT_ID 1
> @@ -425,6 +434,7 @@ struct fuse_file_lock {
>   * FUSE_HAS_RESEND: kernel supports resending pending requests, and the =
high bit
>   *                 of the request ID indicates resend requests
>   * FUSE_ALLOW_IDMAP: allow creation of idmapped mounts
> + * FUSE_OVER_IO_URING: Indicate that Client supports io-uring

nit: "Client" -> "client"

>   */
>  #define FUSE_ASYNC_READ                (1 << 0)
>  #define FUSE_POSIX_LOCKS       (1 << 1)
> @@ -471,6 +481,7 @@ struct fuse_file_lock {
>  /* Obsolete alias for FUSE_DIRECT_IO_ALLOW_MMAP */
>  #define FUSE_DIRECT_IO_RELAX   FUSE_DIRECT_IO_ALLOW_MMAP
>  #define FUSE_ALLOW_IDMAP       (1ULL << 40)
> +#define FUSE_OVER_IO_URING     (1ULL << 41)
>
>  /**
>   * CUSE INIT request/reply flags
> @@ -1206,4 +1217,67 @@ struct fuse_supp_groups {
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
> +       /*
> +        * commit ID to be used in a reply to a ring request (see also
> +        * struct fuse_uring_cmd_req)
> +        */
> +       uint64_t commit_id;
> +
> +       /* size of use payload buffer */

nit: "use" -> "user"

> +       uint32_t payload_sz;
> +       uint32_t padding;
> +
> +       uint64_t reserved;
> +};

If I'm understanding it correctly, this is for a fuse-uring entry
specific header? Might be worth including that as a comment at the
top, just to be explicit. It took me a bit of digging to figure out
that this is to be used as a header

> +
> +/**
> + * Header for all fuse-io-uring requests
> + */
> +struct fuse_uring_req_header {
> +       /* struct fuse_in / struct fuse_out */
> +       char in_out[FUSE_URING_IN_OUT_HEADER_SZ];

 Does this hold struct fuse_in_header /  struct fuse_out_header? (I
see the comment says "struct fuse_in / struct fuse_out", but I don't
see those structs defined anywhere but maybe I'm missing something)

> +
> +       /* per op code structs */

IMO, "per op header" sounds more descriptive of a comment

> +       char op_in[FUSE_URING_OP_IN_OUT_SZ];
> +
> +       /* struct fuse_ring_in_out */
> +       char ring_ent_in_out[sizeof(struct fuse_uring_ent_in_out)];

Just curious, is there a reason this can't be "struct
fuse_uring_ent_in_out ent_in_out;" instead of having it defined as a
char array?

> +};
> +
> +/**
> + * sqe commands to the kernel
> + */
> +enum fuse_uring_cmd {
> +       FUSE_IO_URING_CMD_INVALID =3D 0,
> +
> +       /* register the request buffer and fetch a fuse request */
> +       FUSE_IO_URING_CMD_REGISTER =3D 1,
> +
> +       /* commit fuse request result and fetch next request */
> +       FUSE_IO_URING_CMD_COMMIT_AND_FETCH =3D 2,
> +};
> +
> +/**
> + * In the 80B command area of the SQE.
> + */
> +struct fuse_uring_cmd_req {
> +       uint64_t flags;
> +
> +       /* entry identifier for commits */
> +       uint64_t commit_id;
> +
> +       /* queue the command is for (queue index) */
> +       uint16_t qid;
> +       uint8_t padding[6];
> +};
> +
>  #endif /* _LINUX_FUSE_H */
>
> --
> 2.43.0
>

