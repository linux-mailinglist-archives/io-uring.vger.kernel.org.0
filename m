Return-Path: <io-uring+bounces-6045-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71271A195E5
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 16:57:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DA2D3A61FB
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 15:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE95214205;
	Wed, 22 Jan 2025 15:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="AggQORMY"
X-Original-To: io-uring@vger.kernel.org
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B982147E5;
	Wed, 22 Jan 2025 15:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.60.130.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737561435; cv=none; b=jbPMP+nejIP57bRffx7p4W79T3m6/D9jv58ETkBCEvq0HlECnf15q1sxeXIQ0WWMf/EJZMeinrBn7Sm4qLnDKW+kRqlADneFfHxn2CwNEQ9eNl5Kub+mSRuNmqcwNzQHU9kpc/ExBHemnmEbe5TrxIWP4wHiZG5X9OxSn5mWZWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737561435; c=relaxed/simple;
	bh=G1zLOEkI0pkmdgDGjHQPF7sGrIWRJgjQanllKG99D9o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fCbPO7vBhXXYxSQgzw6UX9RCIt24880LGkWTmP5x0Nv3DXZaloQaJCEjfV4YfWKwIOh/6AkkxGxxNGP/Av/0kE5AWWGHqImdy+Lsz+raQcHZ7J9dSmLpHsg5fFfuMV/XrBeXe7xzBAPhwGZy093wmoubCLHNn3KFzHyeKIUxbws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=AggQORMY; arc=none smtp.client-ip=178.60.130.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gElyyFjB3nBBjHPreQV29IIr6yiatB6UTEXFIU++nrw=; b=AggQORMY/Lu9wCRPHXziVMIBki
	3m7660eoxweZNmiJ5UzKU/L5YlEZecu0GpRiUT/5P7ZSbBinS22FRFd3AUYY1MTk8lMG6qxSsI8D1
	ES+C9OgSIBEc69EnMgetNyNpK+3AI67GeZl2V0aLqBFr2MxCtLZLHMUnPxfBDL6XR6y2z4rC1R9SR
	OUcAYHRw+5qfufRMqDkuVXIie2kAbwdis02To5h15KN8KDa4tnB893hzzjcaaAqx/Jnyj0+KrK7Kh
	oKON9j/Q3wbpoJ/sqtERg78+qgxx3X7lgYhpQ5Ab4o1qoKjGZcqMywktD48ZR1OP2G7QX6j9GQsEN
	41pHZotA==;
Received: from bl23-10-177.dsl.telepac.pt ([144.64.10.177] helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1tad6J-000nfO-PA; Wed, 22 Jan 2025 16:57:07 +0100
From: Luis Henriques <luis@igalia.com>
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,  Jens Axboe <axboe@kernel.dk>,
  Pavel Begunkov <asml.silence@gmail.com>,  linux-fsdevel@vger.kernel.org,
  io-uring@vger.kernel.org,  Joanne Koong <joannelkoong@gmail.com>,  Josef
 Bacik <josef@toxicpanda.com>,  Amir Goldstein <amir73il@gmail.com>,  Ming
 Lei <tom.leiming@gmail.com>,  David Wei <dw@davidwei.uk>,
  bernd@bsbernd.com
Subject: Re: [PATCH v10 06/17] fuse: {io-uring} Handle SQEs - register commands
In-Reply-To: <20250120-fuse-uring-for-6-10-rfc4-v10-6-ca7c5d1007c0@ddn.com>
	(Bernd Schubert's message of "Mon, 20 Jan 2025 02:28:59 +0100")
References: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
	<20250120-fuse-uring-for-6-10-rfc4-v10-6-ca7c5d1007c0@ddn.com>
Date: Wed, 22 Jan 2025 15:56:23 +0000
Message-ID: <87wmemetaw.fsf@igalia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20 2025, Bernd Schubert wrote:

> This adds basic support for ring SQEs (with opcode=3DIORING_OP_URING_CMD).
> For now only FUSE_IO_URING_CMD_REGISTER is handled to register queue
> entries.

Three comments below.

> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
> ---
>  fs/fuse/Kconfig           |  12 ++
>  fs/fuse/Makefile          |   1 +
>  fs/fuse/dev_uring.c       | 326 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/fuse/dev_uring_i.h     | 113 ++++++++++++++++
>  fs/fuse/fuse_i.h          |   5 +
>  fs/fuse/inode.c           |  10 ++
>  include/uapi/linux/fuse.h |  76 ++++++++++-
>  7 files changed, 542 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
> index 8674dbfbe59dbf79c304c587b08ebba3cfe405be..ca215a3cba3e310d1359d0692=
02193acdcdb172b 100644
> --- a/fs/fuse/Kconfig
> +++ b/fs/fuse/Kconfig
> @@ -63,3 +63,15 @@ config FUSE_PASSTHROUGH
>  	  to be performed directly on a backing file.
>=20=20
>  	  If you want to allow passthrough operations, answer Y.
> +
> +config FUSE_IO_URING
> +	bool "FUSE communication over io-uring"
> +	default y
> +	depends on FUSE_FS
> +	depends on IO_URING
> +	help
> +	  This allows sending FUSE requests over the io-uring interface and
> +          also adds request core affinity.
> +
> +	  If you want to allow fuse server/client communication through io-urin=
g,
> +	  answer Y
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
>=20=20
>  virtiofs-y :=3D virtio_fs.o
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..60e38ff1ecef3b007bae7ceed=
d7dd997439e463a
> --- /dev/null
> +++ b/fs/fuse/dev_uring.c
> @@ -0,0 +1,326 @@
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
> +static bool __read_mostly enable_uring;
> +module_param(enable_uring, bool, 0644);

Allowing to change 'enable_uring' at runtime will cause troubles.  I don't
think the code gracefully handles changes to this parameter.  Maybe it
should be a read-only parameter.  Another option would be to be proxy it
at the connection level, so that once enabled/disabled it will remain so
for the lifetime of that connection.

> +MODULE_PARM_DESC(enable_uring,
> +		 "Enable userspace communication through io-uring");
> +
> +#define FUSE_URING_IOV_SEGS 2 /* header and payload */
> +
> +
> +bool fuse_uring_enabled(void)
> +{
> +	return enable_uring;
> +}
> +
>=20
> +void fuse_uring_destruct(struct fuse_conn *fc)
> +{
> +	struct fuse_ring *ring =3D fc->ring;
> +	int qid;
> +
> +	if (!ring)
> +		return;
> +
> +	for (qid =3D 0; qid < ring->nr_queues; qid++) {
> +		struct fuse_ring_queue *queue =3D ring->queues[qid];
> +
> +		if (!queue)
> +			continue;
> +
> +		WARN_ON(!list_empty(&queue->ent_avail_queue));
> +		WARN_ON(!list_empty(&queue->ent_commit_queue));
> +
> +		kfree(queue);
> +		ring->queues[qid] =3D NULL;
> +	}
> +
> +	kfree(ring->queues);
> +	kfree(ring);
> +	fc->ring =3D NULL;
> +}
> +
> +/*
> + * Basic ring setup for this connection based on the provided configurat=
ion
> + */
> +static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
> +{
> +	struct fuse_ring *ring;
> +	size_t nr_queues =3D num_possible_cpus();
> +	struct fuse_ring *res =3D NULL;
> +	size_t max_payload_size;
> +
> +	ring =3D kzalloc(sizeof(*fc->ring), GFP_KERNEL_ACCOUNT);
> +	if (!ring)
> +		return NULL;
> +
> +	ring->queues =3D kcalloc(nr_queues, sizeof(struct fuse_ring_queue *),
> +			       GFP_KERNEL_ACCOUNT);
> +	if (!ring->queues)
> +		goto out_err;
> +
> +	max_payload_size =3D max(FUSE_MIN_READ_BUFFER, fc->max_write);
> +	max_payload_size =3D max(max_payload_size, fc->max_pages * PAGE_SIZE);
> +
> +	spin_lock(&fc->lock);
> +	if (fc->ring) {
> +		/* race, another thread created the ring in the meantime */
> +		spin_unlock(&fc->lock);
> +		res =3D fc->ring;
> +		goto out_err;
> +	}
> +
> +	fc->ring =3D ring;
> +	ring->nr_queues =3D nr_queues;
> +	ring->fc =3D fc;
> +	ring->max_payload_sz =3D max_payload_size;
> +
> +	spin_unlock(&fc->lock);
> +	return ring;
> +
> +out_err:
> +	kfree(ring->queues);
> +	kfree(ring);
> +	return res;
> +}
> +
> +static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring =
*ring,
> +						       int qid)
> +{
> +	struct fuse_conn *fc =3D ring->fc;
> +	struct fuse_ring_queue *queue;
> +
> +	queue =3D kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
> +	if (!queue)
> +		return NULL;
> +	queue->qid =3D qid;
> +	queue->ring =3D ring;
> +	spin_lock_init(&queue->lock);
> +
> +	INIT_LIST_HEAD(&queue->ent_avail_queue);
> +	INIT_LIST_HEAD(&queue->ent_commit_queue);
> +
> +	spin_lock(&fc->lock);
> +	if (ring->queues[qid]) {
> +		spin_unlock(&fc->lock);
> +		kfree(queue);
> +		return ring->queues[qid];
> +	}
> +
> +	/*
> +	 * write_once and lock as the caller mostly doesn't take the lock at all
> +	 */
> +	WRITE_ONCE(ring->queues[qid], queue);
> +	spin_unlock(&fc->lock);
> +
> +	return queue;
> +}
> +
> +/*
> + * Make a ring entry available for fuse_req assignment
> + */
> +static void fuse_uring_ent_avail(struct fuse_ring_ent *ent,
> +				 struct fuse_ring_queue *queue)
> +{
> +	WARN_ON_ONCE(!ent->cmd);
> +	list_move(&ent->list, &queue->ent_avail_queue);
> +	ent->state =3D FRRS_AVAILABLE;
> +}
> +
> +/*
> + * fuse_uring_req_fetch command handling
> + */
> +static void fuse_uring_do_register(struct fuse_ring_ent *ent,
> +				   struct io_uring_cmd *cmd,
> +				   unsigned int issue_flags)
> +{
> +	struct fuse_ring_queue *queue =3D ent->queue;
> +
> +	spin_lock(&queue->lock);
> +	ent->cmd =3D cmd;
> +	fuse_uring_ent_avail(ent, queue);
> +	spin_unlock(&queue->lock);
> +}
> +
> +/*
> + * sqe->addr is a ptr to an iovec array, iov[0] has the headers, iov[1]
> + * the payload
> + */
> +static int fuse_uring_get_iovec_from_sqe(const struct io_uring_sqe *sqe,
> +					 struct iovec iov[FUSE_URING_IOV_SEGS])
> +{
> +	struct iovec __user *uiov =3D u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	struct iov_iter iter;
> +	ssize_t ret;
> +
> +	if (sqe->len !=3D FUSE_URING_IOV_SEGS)
> +		return -EINVAL;
> +
> +	/*
> +	 * Direction for buffer access will actually be READ and WRITE,
> +	 * using write for the import should include READ access as well.
> +	 */
> +	ret =3D import_iovec(WRITE, uiov, FUSE_URING_IOV_SEGS,
> +			   FUSE_URING_IOV_SEGS, &iov, &iter);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static struct fuse_ring_ent *
> +fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
> +			   struct fuse_ring_queue *queue)
> +{
> +	struct fuse_ring *ring =3D queue->ring;
> +	struct fuse_ring_ent *ent;
> +	size_t payload_size;
> +	struct iovec iov[FUSE_URING_IOV_SEGS];
> +	int err;
> +
> +	err =3D fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
> +	if (err) {
> +		pr_info_ratelimited("Failed to get iovec from sqe, err=3D%d\n",
> +				    err);
> +		return ERR_PTR(err);
> +	}
> +
> +	err =3D -EINVAL;
> +	if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
> +		pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
> +		return ERR_PTR(err);
> +	}
> +
> +	payload_size =3D iov[1].iov_len;
> +	if (payload_size < ring->max_payload_sz) {
> +		pr_info_ratelimited("Invalid req payload len %zu\n",
> +				    payload_size);
> +		return ERR_PTR(err);
> +	}
> +
> +	/*
> +	 * The created queue above does not need to be destructed in
> +	 * case of entry errors below, will be done at ring destruction time.
> +	 */

This comment should probably be moved down, into function
fuse_uring_register() where this code was in earlier versions of the
patchset.

> +	err =3D -ENOMEM;
> +	ent =3D kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
> +	if (!ent)
> +		return ERR_PTR(err);
> +
> +	INIT_LIST_HEAD(&ent->list);
> +
> +	ent->queue =3D queue;
> +	ent->headers =3D iov[0].iov_base;
> +	ent->payload =3D iov[1].iov_base;
> +
> +	return ent;
> +}
> +
> +/*
> + * Register header and payload buffer with the kernel and puts the
> + * entry as "ready to get fuse requests" on the queue
> + */
> +static int fuse_uring_register(struct io_uring_cmd *cmd,
> +			       unsigned int issue_flags, struct fuse_conn *fc)
> +{
> +	const struct fuse_uring_cmd_req *cmd_req =3D io_uring_sqe_cmd(cmd->sqe);
> +	struct fuse_ring *ring =3D fc->ring;
> +	struct fuse_ring_queue *queue;
> +	struct fuse_ring_ent *ent;
> +	int err;
> +	unsigned int qid =3D READ_ONCE(cmd_req->qid);
> +
> +	err =3D -ENOMEM;
> +	if (!ring) {
> +		ring =3D fuse_uring_create(fc);
> +		if (!ring)
> +			return err;
> +	}
> +
> +	if (qid >=3D ring->nr_queues) {
> +		pr_info_ratelimited("fuse: Invalid ring qid %u\n", qid);
> +		return -EINVAL;
> +	}
> +
> +	err =3D -ENOMEM;

Not needed, 'err' is already set to this value.

Cheers,
--=20
Lu=C3=ADs

> +	queue =3D ring->queues[qid];
> +	if (!queue) {
> +		queue =3D fuse_uring_create_queue(ring, qid);
> +		if (!queue)
> +			return err;
> +	}
> +
> +	ent =3D fuse_uring_create_ring_ent(cmd, queue);
> +	if (IS_ERR(ent))
> +		return PTR_ERR(ent);
> +
> +	fuse_uring_do_register(ent, cmd, issue_flags);
> +
> +	return 0;
> +}
> +
> +/*
> + * Entry function from io_uring to handle the given passthrough command
> + * (op code IORING_OP_URING_CMD)
> + */
> +int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
> +				  unsigned int issue_flags)
> +{
> +	struct fuse_dev *fud;
> +	struct fuse_conn *fc;
> +	u32 cmd_op =3D cmd->cmd_op;
> +	int err;
> +
> +	if (!enable_uring) {
> +		pr_info_ratelimited("fuse-io-uring is disabled\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	/* This extra SQE size holds struct fuse_uring_cmd_req */
> +	if (!(issue_flags & IO_URING_F_SQE128))
> +		return -EINVAL;
> +
> +	fud =3D fuse_get_dev(cmd->file);
> +	if (!fud) {
> +		pr_info_ratelimited("No fuse device found\n");
> +		return -ENOTCONN;
> +	}
> +	fc =3D fud->fc;
> +
> +	if (fc->aborted)
> +		return -ECONNABORTED;
> +	if (!fc->connected)
> +		return -ENOTCONN;
> +
> +	/*
> +	 * fuse_uring_register() needs the ring to be initialized,
> +	 * we need to know the max payload size
> +	 */
> +	if (!fc->initialized)
> +		return -EAGAIN;
> +
> +	switch (cmd_op) {
> +	case FUSE_IO_URING_CMD_REGISTER:
> +		err =3D fuse_uring_register(cmd, issue_flags, fc);
> +		if (err) {
> +			pr_info_once("FUSE_IO_URING_CMD_REGISTER failed err=3D%d\n",
> +				     err);
> +			return err;
> +		}
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return -EIOCBQUEUED;
> +}
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> new file mode 100644
> index 0000000000000000000000000000000000000000..ae1536355b368583132d2ab68=
78b5490510b28e8
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
> +enum fuse_ring_req_state {
> +	FRRS_INVALID =3D 0,
> +
> +	/* The ring entry received from userspace and it is being processed */
> +	FRRS_COMMIT,
> +
> +	/* The ring entry is waiting for new fuse requests */
> +	FRRS_AVAILABLE,
> +
> +	/* The ring entry is in or on the way to user space */
> +	FRRS_USERSPACE,
> +};
> +
> +/** A fuse ring entry, part of the ring queue */
> +struct fuse_ring_ent {
> +	/* userspace buffer */
> +	struct fuse_uring_req_header __user *headers;
> +	void __user *payload;
> +
> +	/* the ring queue that owns the request */
> +	struct fuse_ring_queue *queue;
> +
> +	/* fields below are protected by queue->lock */
> +
> +	struct io_uring_cmd *cmd;
> +
> +	struct list_head list;
> +
> +	enum fuse_ring_req_state state;
> +
> +	struct fuse_req *fuse_req;
> +};
> +
> +struct fuse_ring_queue {
> +	/*
> +	 * back pointer to the main fuse uring structure that holds this
> +	 * queue
> +	 */
> +	struct fuse_ring *ring;
> +
> +	/* queue id, corresponds to the cpu core */
> +	unsigned int qid;
> +
> +	/*
> +	 * queue lock, taken when any value in the queue changes _and_ also
> +	 * a ring entry state changes.
> +	 */
> +	spinlock_t lock;
> +
> +	/* available ring entries (struct fuse_ring_ent) */
> +	struct list_head ent_avail_queue;
> +
> +	/*
> +	 * entries in the process of being committed or in the process
> +	 * to be sent to userspace
> +	 */
> +	struct list_head ent_commit_queue;
> +};
> +
> +/**
> + * Describes if uring is for communication and holds alls the data needed
> + * for uring communication
> + */
> +struct fuse_ring {
> +	/* back pointer */
> +	struct fuse_conn *fc;
> +
> +	/* number of ring queues */
> +	size_t nr_queues;
> +
> +	/* maximum payload/arg size */
> +	size_t max_payload_sz;
> +
> +	struct fuse_ring_queue **queues;
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
> +	return false;
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
>  	/** IDR for backing files ids */
>  	struct idr backing_files_map;
>  #endif
> +
> +#ifdef CONFIG_FUSE_IO_URING
> +	/**  uring connection information*/
> +	struct fuse_ring *ring;
> +#endif
>  };
>=20=20
>  /*
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 3ce4f4e81d09e867c3a7db7b1dbb819f88ed34ef..e4f9bbacfc1bc6f51d5d01b4c=
47b42cc159ed783 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -7,6 +7,7 @@
>  */
>=20=20
>  #include "fuse_i.h"
> +#include "dev_uring_i.h"
>=20=20
>  #include <linux/pagemap.h>
>  #include <linux/slab.h>
> @@ -992,6 +993,8 @@ static void delayed_release(struct rcu_head *p)
>  {
>  	struct fuse_conn *fc =3D container_of(p, struct fuse_conn, rcu);
>=20=20
> +	fuse_uring_destruct(fc);
> +
>  	put_user_ns(fc->user_ns);
>  	fc->release(fc);
>  }
> @@ -1446,6 +1449,13 @@ void fuse_send_init(struct fuse_mount *fm)
>  	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
>  		flags |=3D FUSE_PASSTHROUGH;
>=20=20
> +	/*
> +	 * This is just an information flag for fuse server. No need to check
> +	 * the reply - server is either sending IORING_OP_URING_CMD or not.
> +	 */
> +	if (fuse_uring_enabled())
> +		flags |=3D FUSE_OVER_IO_URING;
> +
>  	ia->in.flags =3D flags;
>  	ia->in.flags2 =3D flags >> 32;
>=20=20
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index f1e99458e29e4fdce5273bc3def242342f207ebd..5e0eb41d967e9de5951673de4=
405a3ed22cdd8e2 100644
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
>=20=20
>  #ifndef _LINUX_FUSE_H
> @@ -255,7 +264,7 @@
>  #define FUSE_KERNEL_VERSION 7
>=20=20
>  /** Minor version number of this interface */
> -#define FUSE_KERNEL_MINOR_VERSION 41
> +#define FUSE_KERNEL_MINOR_VERSION 42
>=20=20
>  /** The node ID of the root inode */
>  #define FUSE_ROOT_ID 1
> @@ -425,6 +434,7 @@ struct fuse_file_lock {
>   * FUSE_HAS_RESEND: kernel supports resending pending requests, and the =
high bit
>   *		    of the request ID indicates resend requests
>   * FUSE_ALLOW_IDMAP: allow creation of idmapped mounts
> + * FUSE_OVER_IO_URING: Indicate that client supports io-uring
>   */
>  #define FUSE_ASYNC_READ		(1 << 0)
>  #define FUSE_POSIX_LOCKS	(1 << 1)
> @@ -471,6 +481,7 @@ struct fuse_file_lock {
>  /* Obsolete alias for FUSE_DIRECT_IO_ALLOW_MMAP */
>  #define FUSE_DIRECT_IO_RELAX	FUSE_DIRECT_IO_ALLOW_MMAP
>  #define FUSE_ALLOW_IDMAP	(1ULL << 40)
> +#define FUSE_OVER_IO_URING	(1ULL << 41)
>=20=20
>  /**
>   * CUSE INIT request/reply flags
> @@ -1206,4 +1217,67 @@ struct fuse_supp_groups {
>  	uint32_t	groups[];
>  };
>=20=20
> +/**
> + * Size of the ring buffer header
> + */
> +#define FUSE_URING_IN_OUT_HEADER_SZ 128
> +#define FUSE_URING_OP_IN_OUT_SZ 128
> +
> +/* Used as part of the fuse_uring_req_header */
> +struct fuse_uring_ent_in_out {
> +	uint64_t flags;
> +
> +	/*
> +	 * commit ID to be used in a reply to a ring request (see also
> +	 * struct fuse_uring_cmd_req)
> +	 */
> +	uint64_t commit_id;
> +
> +	/* size of user payload buffer */
> +	uint32_t payload_sz;
> +	uint32_t padding;
> +
> +	uint64_t reserved;
> +};
> +
> +/**
> + * Header for all fuse-io-uring requests
> + */
> +struct fuse_uring_req_header {
> +	/* struct fuse_in_header / struct fuse_out_header */
> +	char in_out[FUSE_URING_IN_OUT_HEADER_SZ];
> +
> +	/* per op code header */
> +	char op_in[FUSE_URING_OP_IN_OUT_SZ];
> +
> +	struct fuse_uring_ent_in_out ring_ent_in_out;
> +};
> +
> +/**
> + * sqe commands to the kernel
> + */
> +enum fuse_uring_cmd {
> +	FUSE_IO_URING_CMD_INVALID =3D 0,
> +
> +	/* register the request buffer and fetch a fuse request */
> +	FUSE_IO_URING_CMD_REGISTER =3D 1,
> +
> +	/* commit fuse request result and fetch next request */
> +	FUSE_IO_URING_CMD_COMMIT_AND_FETCH =3D 2,
> +};
> +
> +/**
> + * In the 80B command area of the SQE.
> + */
> +struct fuse_uring_cmd_req {
> +	uint64_t flags;
> +
> +	/* entry identifier for commits */
> +	uint64_t commit_id;
> +
> +	/* queue the command is for (queue index) */
> +	uint16_t qid;
> +	uint8_t padding[6];
> +};
> +
>  #endif /* _LINUX_FUSE_H */
>
> --=20
> 2.43.0
>


