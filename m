Return-Path: <io-uring+bounces-5730-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE283A044B5
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 16:36:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF0951888AF3
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 15:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B75D1EF0BE;
	Tue,  7 Jan 2025 15:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="f91NdyDK"
X-Original-To: io-uring@vger.kernel.org
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04B71F429B;
	Tue,  7 Jan 2025 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.60.130.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736263984; cv=none; b=WfJY+GayLsCIEHBOtHJjPSvKlSPqCKLfc2XRrIG0rIcJm0Q0uqpuDK83o3g69YeN2YT2a57UpUo9udiYMKZy3mmvyXflTDlIV8p9OHMQWk8hDFP2DkB3SRBZToBKvgnk/X3iD6z0oab4FMmjBOr9Y/mdZZtdnn96xBRY+zvEVrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736263984; c=relaxed/simple;
	bh=h2HBwmtmgxdexlcLteRaPRqdudmXxpXrS0ZLEMEPQ2I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hT742TxYdih4TOHQyMB258aIahTNwCsc1YIqhGhmubgqSBLkUXkgfZ/o1e4/HLF9Y7YaU1cnFbjGYa5JmO9N8hONLX0L77eYaj6Mcn1ZsEb2xPcMqLbckmBjIhc1nGdw/zhtqrnirHgIZdIS1E7mZlBiNE6PG2mpgZJ3s3eLXHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=f91NdyDK; arc=none smtp.client-ip=178.60.130.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LX7kEHAnry4rzN9Fxul/uofJzRpBPMX08KeTUAiRP6A=; b=f91NdyDK6IlXmbRqsqod+0wZ9F
	PDxaS4RTD6feNF5iIUk8mXVHY6TDNpK+JpVh8CGvVRW7uNoXmCfS1LO5CN3yLI4y1tPC45CRcqLYh
	+4dE9bWF+N/MVxQtjs4Sl1kErdA0IVydNWw+oZyv9cDdymNHMNiJRg5FbVjBvhi4DR2J8XCa7+7zD
	U5Pxju74JxiXUb+VQeLiGWT2VhuLKO/GXD7AFuBxOeuqrC8ub9QKQ1GZBoA8TVzcbbBiuki3AISZB
	oivyg/Ts7dUaIzbQQlJ5EX+IuDSrIBtHsK2qGtkGFIChS9w2bB1LgPVnN3HOt0Fea+ueuOhI7Y0GB
	fiBpJqQA==;
Received: from bl23-10-177.dsl.telepac.pt ([144.64.10.177] helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1tVBZZ-00CmTi-Ib; Tue, 07 Jan 2025 16:32:49 +0100
From: Luis Henriques <luis@igalia.com>
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,  Jens Axboe <axboe@kernel.dk>,
  Pavel Begunkov <asml.silence@gmail.com>,  linux-fsdevel@vger.kernel.org,
  io-uring@vger.kernel.org,  Joanne Koong <joannelkoong@gmail.com>,  Josef
 Bacik <josef@toxicpanda.com>,  Amir Goldstein <amir73il@gmail.com>,  Ming
 Lei <tom.leiming@gmail.com>,  David Wei <dw@davidwei.uk>,
  bernd@bsbernd.com
Subject: Re: [PATCH v9 11/17] fuse: {io-uring} Handle teardown of ring entries
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-11-9c786f9a7a9d@ddn.com>
	(Bernd Schubert's message of "Tue, 07 Jan 2025 01:25:16 +0100")
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
	<20250107-fuse-uring-for-6-10-rfc4-v9-11-9c786f9a7a9d@ddn.com>
Date: Tue, 07 Jan 2025 15:31:55 +0000
Message-ID: <87h66a3aj8.fsf@igalia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07 2025, Bernd Schubert wrote:

> On teardown struct file_operations::uring_cmd requests
> need to be completed by calling io_uring_cmd_done().
> Not completing all ring entries would result in busy io-uring
> tasks giving warning messages in intervals and unreleased
> struct file.
>
> Additionally the fuse connection and with that the ring can
> only get released when all io-uring commands are completed.
>
> Completion is done with ring entries that are
> a) in waiting state for new fuse requests - io_uring_cmd_done
> is needed
>
> b) already in userspace - io_uring_cmd_done through teardown
> is not needed, the request can just get released. If fuse server
> is still active and commits such a ring entry, fuse_uring_cmd()
> already checks if the connection is active and then complete the
> io-uring itself with -ENOTCONN. I.e. special handling is not
> needed.
>
> This scheme is basically represented by the ring entry state
> FRRS_WAIT and FRRS_USERSPACE.
>
> Entries in state:
> - FRRS_INIT: No action needed, do not contribute to
>   ring->queue_refs yet
> - All other states: Are currently processed by other tasks,
>   async teardown is needed and it has to wait for the two
>   states above. It could be also solved without an async
>   teardown task, but would require additional if conditions
>   in hot code paths. Also in my personal opinion the code
>   looks cleaner with async teardown.
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>  fs/fuse/dev.c         |   9 +++
>  fs/fuse/dev_uring.c   | 198 ++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/fuse/dev_uring_i.h |  51 +++++++++++++
>  3 files changed, 258 insertions(+)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index aa33eba51c51dff6af2cdcf60bed9c3f6b4bc0d0..1c21e491e891196c77c7f6135=
cdc2aece785d399 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -6,6 +6,7 @@
>    See the file COPYING.
>  */
>=20=20
> +#include "dev_uring_i.h"
>  #include "fuse_i.h"
>  #include "fuse_dev_i.h"
>=20=20
> @@ -2291,6 +2292,12 @@ void fuse_abort_conn(struct fuse_conn *fc)
>  		spin_unlock(&fc->lock);
>=20=20
>  		fuse_dev_end_requests(&to_end);
> +
> +		/*
> +		 * fc->lock must not be taken to avoid conflicts with io-uring
> +		 * locks
> +		 */
> +		fuse_uring_abort(fc);
>  	} else {
>  		spin_unlock(&fc->lock);
>  	}
> @@ -2302,6 +2309,8 @@ void fuse_wait_aborted(struct fuse_conn *fc)
>  	/* matches implicit memory barrier in fuse_drop_waiting() */
>  	smp_mb();
>  	wait_event(fc->blocked_waitq, atomic_read(&fc->num_waiting) =3D=3D 0);
> +
> +	fuse_uring_wait_stopped_queues(fc);
>  }
>=20=20
>  int fuse_dev_release(struct inode *inode, struct file *file)
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index f44e66a7ea577390da87e9ac7d118a9416898c28..01a908b2ef9ada14b759ca047=
eab40b4c4431d89 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -39,6 +39,37 @@ static void fuse_uring_req_end(struct fuse_ring_ent *r=
ing_ent, bool set_err,
>  	ring_ent->fuse_req =3D NULL;
>  }
>=20=20
> +/* Abort all list queued request on the given ring queue */
> +static void fuse_uring_abort_end_queue_requests(struct fuse_ring_queue *=
queue)
> +{
> +	struct fuse_req *req;
> +	LIST_HEAD(req_list);
> +
> +	spin_lock(&queue->lock);
> +	list_for_each_entry(req, &queue->fuse_req_queue, list)
> +		clear_bit(FR_PENDING, &req->flags);
> +	list_splice_init(&queue->fuse_req_queue, &req_list);
> +	spin_unlock(&queue->lock);
> +
> +	/* must not hold queue lock to avoid order issues with fi->lock */
> +	fuse_dev_end_requests(&req_list);
> +}
> +
> +void fuse_uring_abort_end_requests(struct fuse_ring *ring)
> +{
> +	int qid;
> +	struct fuse_ring_queue *queue;
> +
> +	for (qid =3D 0; qid < ring->nr_queues; qid++) {
> +		queue =3D READ_ONCE(ring->queues[qid]);
> +		if (!queue)
> +			continue;
> +
> +		queue->stopped =3D true;
> +		fuse_uring_abort_end_queue_requests(queue);
> +	}
> +}
> +
>  void fuse_uring_destruct(struct fuse_conn *fc)
>  {
>  	struct fuse_ring *ring =3D fc->ring;
> @@ -98,10 +129,13 @@ static struct fuse_ring *fuse_uring_create(struct fu=
se_conn *fc)
>  		goto out_err;
>  	}
>=20=20
> +	init_waitqueue_head(&ring->stop_waitq);
> +
>  	fc->ring =3D ring;
>  	ring->nr_queues =3D nr_queues;
>  	ring->fc =3D fc;
>  	ring->max_payload_sz =3D max_payload_size;
> +	atomic_set(&ring->queue_refs, 0);
>=20=20
>  	spin_unlock(&fc->lock);
>  	return ring;
> @@ -158,6 +192,166 @@ static struct fuse_ring_queue *fuse_uring_create_qu=
eue(struct fuse_ring *ring,
>  	return queue;
>  }
>=20=20
> +static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
> +{
> +	struct fuse_req *req =3D ent->fuse_req;
> +
> +	/* remove entry from fuse_pqueue->processing */
> +	list_del_init(&req->list);
> +	ent->fuse_req =3D NULL;
> +	clear_bit(FR_SENT, &req->flags);
> +	req->out.h.error =3D -ECONNABORTED;
> +	fuse_request_end(req);
> +}
> +
> +/*
> + * Release a request/entry on connection tear down
> + */
> +static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
> +{
> +	if (ent->cmd) {
> +		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0, IO_URING_F_UNLOCKED);
> +		ent->cmd =3D NULL;
> +	}
> +
> +	if (ent->fuse_req)
> +		fuse_uring_stop_fuse_req_end(ent);
> +
> +	list_del_init(&ent->list);
> +	kfree(ent);
> +}
> +
> +static void fuse_uring_stop_list_entries(struct list_head *head,
> +					 struct fuse_ring_queue *queue,
> +					 enum fuse_ring_req_state exp_state)
> +{
> +	struct fuse_ring *ring =3D queue->ring;
> +	struct fuse_ring_ent *ent, *next;
> +	ssize_t queue_refs =3D SSIZE_MAX;
> +	LIST_HEAD(to_teardown);
> +
> +	spin_lock(&queue->lock);
> +	list_for_each_entry_safe(ent, next, head, list) {
> +		if (ent->state !=3D exp_state) {
> +			pr_warn("entry teardown qid=3D%d state=3D%d expected=3D%d",
> +				queue->qid, ent->state, exp_state);
> +			continue;
> +		}
> +
> +		list_move(&ent->list, &to_teardown);
> +	}
> +	spin_unlock(&queue->lock);
> +
> +	/* no queue lock to avoid lock order issues */
> +	list_for_each_entry_safe(ent, next, &to_teardown, list) {
> +		fuse_uring_entry_teardown(ent);
> +		queue_refs =3D atomic_dec_return(&ring->queue_refs);
> +		WARN_ON_ONCE(queue_refs < 0);
> +	}
> +}
> +
> +static void fuse_uring_teardown_entries(struct fuse_ring_queue *queue)
> +{
> +	fuse_uring_stop_list_entries(&queue->ent_in_userspace, queue,
> +				     FRRS_USERSPACE);
> +	fuse_uring_stop_list_entries(&queue->ent_avail_queue, queue,
> +				     FRRS_AVAILABLE);
> +}
> +
> +/*
> + * Log state debug info
> + */
> +static void fuse_uring_log_ent_state(struct fuse_ring *ring)
> +{
> +	int qid;
> +	struct fuse_ring_ent *ent;
> +
> +	for (qid =3D 0; qid < ring->nr_queues; qid++) {
> +		struct fuse_ring_queue *queue =3D ring->queues[qid];
> +
> +		if (!queue)
> +			continue;
> +
> +		spin_lock(&queue->lock);
> +		/*
> +		 * Log entries from the intermediate queue, the other queues
> +		 * should be empty
> +		 */
> +		list_for_each_entry(ent, &queue->ent_w_req_queue, list) {
> +			pr_info(" ent-req-queue ring=3D%p qid=3D%d ent=3D%p state=3D%d\n",
> +				ring, qid, ent, ent->state);
> +		}
> +		list_for_each_entry(ent, &queue->ent_commit_queue, list) {
> +			pr_info(" ent-req-queue ring=3D%p qid=3D%d ent=3D%p state=3D%d\n",

Probably copy&paste: the above string 'ent-req-queue' should probably be
'ent-commit-queue' or something similar.

> +				ring, qid, ent, ent->state);
> +		}
> +		spin_unlock(&queue->lock);
> +	}
> +	ring->stop_debug_log =3D 1;
> +}
> +
> +static void fuse_uring_async_stop_queues(struct work_struct *work)
> +{
> +	int qid;
> +	struct fuse_ring *ring =3D
> +		container_of(work, struct fuse_ring, async_teardown_work.work);
> +
> +	/* XXX code dup */

Yeah, I guess the delayed work callback could simply call
fuse_uring_stop_queues(), which would do different things depending on the
value of ring->teardown_time (0 or jiffies).  Which could also be
confusing.

>=20
> +	for (qid =3D 0; qid < ring->nr_queues; qid++) {
> +		struct fuse_ring_queue *queue =3D READ_ONCE(ring->queues[qid]);
> +
> +		if (!queue)
> +			continue;
> +
> +		fuse_uring_teardown_entries(queue);
> +	}
> +
> +	/*
> +	 * Some ring entries are might be in the middle of IO operations,

nit: remove extra 'are'.

> +	 * i.e. in process to get handled by file_operations::uring_cmd
> +	 * or on the way to userspace - we could handle that with conditions in
> +	 * run time code, but easier/cleaner to have an async tear down handler
> +	 * If there are still queue references left
> +	 */
> +	if (atomic_read(&ring->queue_refs) > 0) {
> +		if (time_after(jiffies,
> +			       ring->teardown_time + FUSE_URING_TEARDOWN_TIMEOUT))
> +			fuse_uring_log_ent_state(ring);
> +
> +		schedule_delayed_work(&ring->async_teardown_work,
> +				      FUSE_URING_TEARDOWN_INTERVAL);
> +	} else {
> +		wake_up_all(&ring->stop_waitq);
> +	}
> +}
> +
> +/*
> + * Stop the ring queues
> + */
> +void fuse_uring_stop_queues(struct fuse_ring *ring)
> +{
> +	int qid;
> +
> +	for (qid =3D 0; qid < ring->nr_queues; qid++) {
> +		struct fuse_ring_queue *queue =3D READ_ONCE(ring->queues[qid]);
> +
> +		if (!queue)
> +			continue;
> +
> +		fuse_uring_teardown_entries(queue);
> +	}
> +
> +	if (atomic_read(&ring->queue_refs) > 0) {
> +		ring->teardown_time =3D jiffies;
> +		INIT_DELAYED_WORK(&ring->async_teardown_work,
> +				  fuse_uring_async_stop_queues);
> +		schedule_delayed_work(&ring->async_teardown_work,
> +				      FUSE_URING_TEARDOWN_INTERVAL);
> +	} else {
> +		wake_up_all(&ring->stop_waitq);
> +	}
> +}
> +
>  /*
>   * Checks for errors and stores it into the request
>   */
> @@ -538,6 +732,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cm=
d *cmd, int issue_flags,
>  		return err;
>  	fpq =3D &queue->fpq;
>=20=20
> +	if (!READ_ONCE(fc->connected) || READ_ONCE(queue->stopped))
> +		return err;
> +
>  	spin_lock(&queue->lock);
>  	/* Find a request based on the unique ID of the fuse request
>  	 * This should get revised, as it needs a hash calculation and list
> @@ -667,6 +864,7 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
>  		return ERR_PTR(err);
>  	}
>=20=20
> +	atomic_inc(&ring->queue_refs);
>  	return ent;
>  }
>=20=20
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> index 80f1c62d4df7f0ca77c4d5179068df6ffdbf7d85..ee5aeccae66caaf9a4dccbbbc=
785820836182668 100644
> --- a/fs/fuse/dev_uring_i.h
> +++ b/fs/fuse/dev_uring_i.h
> @@ -11,6 +11,9 @@
>=20=20
>  #ifdef CONFIG_FUSE_IO_URING
>=20=20
> +#define FUSE_URING_TEARDOWN_TIMEOUT (5 * HZ)
> +#define FUSE_URING_TEARDOWN_INTERVAL (HZ/20)
> +
>  enum fuse_ring_req_state {
>  	FRRS_INVALID =3D 0,
>=20=20
> @@ -83,6 +86,8 @@ struct fuse_ring_queue {
>  	struct list_head fuse_req_queue;
>=20=20
>  	struct fuse_pqueue fpq;
> +
> +	bool stopped;
>  };
>=20=20
>  /**
> @@ -100,12 +105,51 @@ struct fuse_ring {
>  	size_t max_payload_sz;
>=20=20
>  	struct fuse_ring_queue **queues;
> +	/*
> +	 * Log ring entry states onces on stop when entries cannot be

typo: "once"

> +	 * released
> +	 */
> +	unsigned int stop_debug_log : 1;
> +
> +	wait_queue_head_t stop_waitq;
> +
> +	/* async tear down */
> +	struct delayed_work async_teardown_work;
> +
> +	/* log */
> +	unsigned long teardown_time;
> +
> +	atomic_t queue_refs;
>  };
>=20=20
>  bool fuse_uring_enabled(void);
>  void fuse_uring_destruct(struct fuse_conn *fc);
> +void fuse_uring_stop_queues(struct fuse_ring *ring);
> +void fuse_uring_abort_end_requests(struct fuse_ring *ring);
>  int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
>=20=20
> +static inline void fuse_uring_abort(struct fuse_conn *fc)
> +{
> +	struct fuse_ring *ring =3D fc->ring;
> +
> +	if (ring =3D=3D NULL)
> +		return;
> +
> +	if (atomic_read(&ring->queue_refs) > 0) {
> +		fuse_uring_abort_end_requests(ring);
> +		fuse_uring_stop_queues(ring);
> +	}
> +}
> +
> +static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
> +{
> +	struct fuse_ring *ring =3D fc->ring;
> +
> +	if (ring)
> +		wait_event(ring->stop_waitq,
> +			   atomic_read(&ring->queue_refs) =3D=3D 0);
> +}
> +
>  #else /* CONFIG_FUSE_IO_URING */
>=20=20
>  struct fuse_ring;
> @@ -123,6 +167,13 @@ static inline bool fuse_uring_enabled(void)
>  	return false;
>  }
>=20=20
> +static inline void fuse_uring_abort(struct fuse_conn *fc)
> +{
> +}
> +
> +static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
> +{
> +}
>  #endif /* CONFIG_FUSE_IO_URING */
>=20=20
>  #endif /* _FS_FUSE_DEV_URING_I_H */
>
> --=20
> 2.43.0
>
>

--=20
Lu=C3=ADs

