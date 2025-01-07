Return-Path: <io-uring+bounces-5733-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10048A045BE
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 17:15:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 782161885687
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 16:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 684291F4E24;
	Tue,  7 Jan 2025 16:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="etGaFkM8"
X-Original-To: io-uring@vger.kernel.org
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DCC1F428A;
	Tue,  7 Jan 2025 16:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.60.130.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736266521; cv=none; b=PPXQpC75HuUNSh80AqLKAhFhRdPZTjs648J0gzLzG9p68Kb56OgMb5DMTraXMByoxX3SmK/VkDR0BwKNmh3YQD8OwV3e0AORwNX2G1xmt3hLxoPy4aqztZgGoQPxuWegRH7+Gjvf1HA7eDny5Mrjz4nJJMtyyr7dgXydHqJyaio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736266521; c=relaxed/simple;
	bh=5aDHHk//kByQ308ogbbl7PQiaCsOsJCtrCW0Nw29m3Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=g0tO/1xaHD0n+BReRvBsHkpB1xP8GDGLDeWLW+I5x0U0qxw+zVeXV8Ac23SnSYmYxJpwmBR9EOPAApHnSNGGXzSLx6C384roeKaKI4oR6L5qRhlf3Y6esogO7zBA2UO+DHBI6nMf9PTWVeEk1k36LuOcrP62UDa2Z7WYAp2SnNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=etGaFkM8; arc=none smtp.client-ip=178.60.130.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Z4oAg9v3TB+Izb+Y0dX2k6GiHyQU6MG3niqfWbg8TCM=; b=etGaFkM8wfTXkpInRQuSd/kk7p
	8ElHRb/yM/G9GRQ8M+BMcpQ+kp7sRV6FvV45b5tG2cmWmZ4rxEFrcYKVSS4TkqGlNvZAgNG0cVZmp
	Yjx6aarY0eCl8qnCgd1CB11z0CDF5cQ8EW68paURg9zWmW2SPYHVr9344zf+vc011OALi+lq2oqdv
	BXozS4rZ83mlsK3YROx8HyjVGUAFQ+ZlRamIJqT6MLNkia80Y25IvdLPOsviwjte53hHFv15nq/Yc
	I3OR21U9CFLif+MfDpLxZEaJVezloa7UvSmLZiH2qPqcOgVYwrNwboTtgieEpgNKp3ATsQInR8LBi
	5k7cXhaA==;
Received: from bl23-10-177.dsl.telepac.pt ([144.64.10.177] helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1tVCEY-00CnI4-53; Tue, 07 Jan 2025 17:15:10 +0100
From: Luis Henriques <luis@igalia.com>
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,  Jens Axboe <axboe@kernel.dk>,
  Pavel Begunkov <asml.silence@gmail.com>,  linux-fsdevel@vger.kernel.org,
  io-uring@vger.kernel.org,  Joanne Koong <joannelkoong@gmail.com>,  Josef
 Bacik <josef@toxicpanda.com>,  Amir Goldstein <amir73il@gmail.com>,  Ming
 Lei <tom.leiming@gmail.com>,  David Wei <dw@davidwei.uk>,
  bernd@bsbernd.com
Subject: Re: [PATCH v9 15/17] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-15-9c786f9a7a9d@ddn.com>
	(Bernd Schubert's message of "Tue, 07 Jan 2025 01:25:20 +0100")
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
	<20250107-fuse-uring-for-6-10-rfc4-v9-15-9c786f9a7a9d@ddn.com>
Date: Tue, 07 Jan 2025 16:14:15 +0000
Message-ID: <8734hu38ko.fsf@igalia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07 2025, Bernd Schubert wrote:

> When the fuse-server terminates while the fuse-client or kernel
> still has queued URING_CMDs, these commands retain references
> to the struct file used by the fuse connection. This prevents
> fuse_dev_release() from being invoked, resulting in a hung mount
> point.
>
> This patch addresses the issue by making queued URING_CMDs
> cancelable, allowing fuse_dev_release() to proceed as expected
> and preventing the mount point from hanging.
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>  fs/fuse/dev.c         |  2 ++
>  fs/fuse/dev_uring.c   | 71 +++++++++++++++++++++++++++++++++++++++++++++=
+++---
>  fs/fuse/dev_uring_i.h |  9 +++++++
>  3 files changed, 79 insertions(+), 3 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index afafa960d4725d9b64b22f17bf09c846219396d6..1b593b23f7b8c319ec38c7e72=
6dabf516965500e 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -599,8 +599,10 @@ static int fuse_request_queue_background(struct fuse=
_req *req)
>  	}
>  	__set_bit(FR_ISREPLY, &req->flags);
>=20=20
> +#ifdef CONFIG_FUSE_IO_URING
>  	if (fuse_uring_ready(fc))
>  		return fuse_request_queue_background_uring(fc, req);
> +#endif

I guess this should be moved to the previous patch.

Cheers,
--=20
Lu=C3=ADs

>=20=20
>  	spin_lock(&fc->bg_lock);
>  	if (likely(fc->connected)) {
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index 4e4385dff9315d25aa8c37a37f1e902aec3fcd20..cdd3917b365f4040c0f147648=
b09af9a41e2f49e 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -153,6 +153,7 @@ void fuse_uring_destruct(struct fuse_conn *fc)
>=20=20
>  	for (qid =3D 0; qid < ring->nr_queues; qid++) {
>  		struct fuse_ring_queue *queue =3D ring->queues[qid];
> +		struct fuse_ring_ent *ent, *next;
>=20=20
>  		if (!queue)
>  			continue;
> @@ -162,6 +163,12 @@ void fuse_uring_destruct(struct fuse_conn *fc)
>  		WARN_ON(!list_empty(&queue->ent_commit_queue));
>  		WARN_ON(!list_empty(&queue->ent_in_userspace));
>=20=20
> +		list_for_each_entry_safe(ent, next, &queue->ent_released,
> +					 list) {
> +			list_del_init(&ent->list);
> +			kfree(ent);
> +		}
> +
>  		kfree(queue->fpq.processing);
>  		kfree(queue);
>  		ring->queues[qid] =3D NULL;
> @@ -245,6 +252,7 @@ static struct fuse_ring_queue *fuse_uring_create_queu=
e(struct fuse_ring *ring,
>  	INIT_LIST_HEAD(&queue->ent_in_userspace);
>  	INIT_LIST_HEAD(&queue->fuse_req_queue);
>  	INIT_LIST_HEAD(&queue->fuse_req_bg_queue);
> +	INIT_LIST_HEAD(&queue->ent_released);
>=20=20
>  	queue->fpq.processing =3D pq;
>  	fuse_pqueue_init(&queue->fpq);
> @@ -283,6 +291,7 @@ static void fuse_uring_stop_fuse_req_end(struct fuse_=
ring_ent *ent)
>   */
>  static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
>  {
> +	struct fuse_ring_queue *queue =3D ent->queue;
>  	if (ent->cmd) {
>  		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0, IO_URING_F_UNLOCKED);
>  		ent->cmd =3D NULL;
> @@ -291,8 +300,16 @@ static void fuse_uring_entry_teardown(struct fuse_ri=
ng_ent *ent)
>  	if (ent->fuse_req)
>  		fuse_uring_stop_fuse_req_end(ent);
>=20=20
> -	list_del_init(&ent->list);
> -	kfree(ent);
> +	/*
> +	 * The entry must not be freed immediately, due to access of direct
> +	 * pointer access of entries through IO_URING_F_CANCEL - there is a risk
> +	 * of race between daemon termination (which triggers IO_URING_F_CANCEL
> +	 * and accesses entries without checking the list state first
> +	 */
> +	spin_lock(&queue->lock);
> +	list_move(&ent->list, &queue->ent_released);
> +	ent->state =3D FRRS_RELEASED;
> +	spin_unlock(&queue->lock);
>  }
>=20=20
>  static void fuse_uring_stop_list_entries(struct list_head *head,
> @@ -312,6 +329,7 @@ static void fuse_uring_stop_list_entries(struct list_=
head *head,
>  			continue;
>  		}
>=20=20
> +		ent->state =3D FRRS_TEARDOWN;
>  		list_move(&ent->list, &to_teardown);
>  	}
>  	spin_unlock(&queue->lock);
> @@ -426,6 +444,46 @@ void fuse_uring_stop_queues(struct fuse_ring *ring)
>  	}
>  }
>=20=20
> +/*
> + * Handle IO_URING_F_CANCEL, typically should come on daemon termination.
> + *
> + * Releasing the last entry should trigger fuse_dev_release() if
> + * the daemon was terminated
> + */
> +static void fuse_uring_cancel(struct io_uring_cmd *cmd,
> +			      unsigned int issue_flags)
> +{
> +	struct fuse_ring_ent *ent =3D uring_cmd_to_ring_ent(cmd);
> +	struct fuse_ring_queue *queue;
> +	bool need_cmd_done =3D false;
> +
> +	/*
> +	 * direct access on ent - it must not be destructed as long as
> +	 * IO_URING_F_CANCEL might come up
> +	 */
> +	queue =3D ent->queue;
> +	spin_lock(&queue->lock);
> +	if (ent->state =3D=3D FRRS_AVAILABLE) {
> +		ent->state =3D FRRS_USERSPACE;
> +		list_move(&ent->list, &queue->ent_in_userspace);
> +		need_cmd_done =3D true;
> +		ent->cmd =3D NULL;
> +	}
> +	spin_unlock(&queue->lock);
> +
> +	if (need_cmd_done) {
> +		/* no queue lock to avoid lock order issues */
> +		io_uring_cmd_done(cmd, -ENOTCONN, 0, issue_flags);
> +	}
> +}
> +
> +static void fuse_uring_prepare_cancel(struct io_uring_cmd *cmd, int issu=
e_flags,
> +				      struct fuse_ring_ent *ring_ent)
> +{
> +	uring_cmd_set_ring_ent(cmd, ring_ent);
> +	io_uring_cmd_mark_cancelable(cmd, issue_flags);
> +}
> +
>  /*
>   * Checks for errors and stores it into the request
>   */
> @@ -836,6 +894,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cm=
d *cmd, int issue_flags,
>  	spin_unlock(&queue->lock);
>=20=20
>  	/* without the queue lock, as other locks are taken */
> +	fuse_uring_prepare_cancel(ring_ent->cmd, issue_flags, ring_ent);
>  	fuse_uring_commit(ring_ent, issue_flags);
>=20=20
>  	/*
> @@ -885,6 +944,8 @@ static void fuse_uring_do_register(struct fuse_ring_e=
nt *ring_ent,
>  	struct fuse_conn *fc =3D ring->fc;
>  	struct fuse_iqueue *fiq =3D &fc->iq;
>=20=20
> +	fuse_uring_prepare_cancel(ring_ent->cmd, issue_flags, ring_ent);
> +
>  	spin_lock(&queue->lock);
>  	fuse_uring_ent_avail(ring_ent, queue);
>  	spin_unlock(&queue->lock);
> @@ -1041,6 +1102,11 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_=
cmd *cmd,
>  		return -EOPNOTSUPP;
>  	}
>=20=20
> +	if ((unlikely(issue_flags & IO_URING_F_CANCEL))) {
> +		fuse_uring_cancel(cmd, issue_flags);
> +		return 0;
> +	}
> +
>  	/* This extra SQE size holds struct fuse_uring_cmd_req */
>  	if (!(issue_flags & IO_URING_F_SQE128))
>  		return -EINVAL;
> @@ -1173,7 +1239,6 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *=
fiq, struct fuse_req *req)
>=20=20
>  	if (ent) {
>  		struct io_uring_cmd *cmd =3D ent->cmd;
> -
>  		err =3D -EIO;
>  		if (WARN_ON_ONCE(ent->state !=3D FRRS_FUSE_REQ))
>  			goto err;
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> index a4271f4e55aa9d2d9b42f3d2c4095887f9563351..af2b3de829949a778d60493f3=
6588fea67a4ba85 100644
> --- a/fs/fuse/dev_uring_i.h
> +++ b/fs/fuse/dev_uring_i.h
> @@ -28,6 +28,12 @@ enum fuse_ring_req_state {
>=20=20
>  	/* The ring entry is in or on the way to user space */
>  	FRRS_USERSPACE,
> +
> +	/* The ring entry is in teardown */
> +	FRRS_TEARDOWN,
> +
> +	/* The ring entry is released, but not freed yet */
> +	FRRS_RELEASED,
>  };
>=20=20
>  /** A fuse ring entry, part of the ring queue */
> @@ -79,6 +85,9 @@ struct fuse_ring_queue {
>  	/* entries in userspace */
>  	struct list_head ent_in_userspace;
>=20=20
> +	/* entries that are released */
> +	struct list_head ent_released;
> +
>  	/* fuse requests waiting for an entry slot */
>  	struct list_head fuse_req_queue;
>=20=20
>
> --=20
> 2.43.0
>
>


