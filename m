Return-Path: <io-uring+bounces-5731-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A2B9A0453D
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 16:55:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9F823A3BA3
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 15:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711C41F190A;
	Tue,  7 Jan 2025 15:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="OGCUHW2F"
X-Original-To: io-uring@vger.kernel.org
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267DD1E47DD;
	Tue,  7 Jan 2025 15:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.60.130.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736265327; cv=none; b=X/sCkXXtxVINpO3WyjEefaeuNr734g7T8m0gBh52zh5eO+nDdKIhAa8I8/AdclJgwxioZCpstewoaKr1phAMSI2X78x0ciAiC39TqT/2riuGPXieYTeZWOFQFkfcXZWKnjxTMaFTuEoNaTbhWJmqu92HoaRbyrNtaCt4KocKPqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736265327; c=relaxed/simple;
	bh=Qz2/EH+9xUiTFcSgL3GvgNM/Q6JdB9feRxcCpahFJh0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jWNYbsvdf6VgyfwZ27u8BXix1vBgR54xUPd21NvgQZOGPR26WhNCKkLKc09wo/LKCZMD688ebUOC5omBjcVpMXs2d/UFKAffFSqyPtwGYPZFLprWUWjvfRJxuGFu44bzq4mVWJ5+r6u77iB1Us/cFaI951sBrBSLH/TeSazHKIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=OGCUHW2F; arc=none smtp.client-ip=178.60.130.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PmJtAYZRp5JJWIKjcpPeGRUESOw+S4lj689gQtig/L4=; b=OGCUHW2FuxrET0YdI/HTkNhpC4
	By9C1iizJuewYV139BlDj1/BDSHYo2KxdkYZ4U6T5J0eTrrKsQj6qQFgYm7LDvJg/kqF0LEhcwaxR
	XqDDqw8UmcYZjdX747QryrALX9i/ZzFvVK3YGqOcdg1zRuHn9EqnTU9zVt17sKzccDZuyqS0rR8ei
	YNkx9HybwHL4slFTr2dRP/y40CkG+uWhdLjdaEHx3yBAIghdkxSr2MVFjz8JRp63VYtWqvepKQBnj
	efa089qxmcPhVEyxSXX5LH8PS8sFrMph5RHUgKPIVsw11OYevTpXvsyQe5DEtTEX2w91Hjcnv04lc
	ZH/HgTYg==;
Received: from bl23-10-177.dsl.telepac.pt ([144.64.10.177] helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1tVBvI-00Cmsm-9w; Tue, 07 Jan 2025 16:55:16 +0100
From: Luis Henriques <luis@igalia.com>
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,  Jens Axboe <axboe@kernel.dk>,
  Pavel Begunkov <asml.silence@gmail.com>,  linux-fsdevel@vger.kernel.org,
  io-uring@vger.kernel.org,  Joanne Koong <joannelkoong@gmail.com>,  Josef
 Bacik <josef@toxicpanda.com>,  Amir Goldstein <amir73il@gmail.com>,  Ming
 Lei <tom.leiming@gmail.com>,  David Wei <dw@davidwei.uk>,
  bernd@bsbernd.com
Subject: Re: [PATCH v9 13/17] fuse: Allow to queue fg requests through io-uring
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-13-9c786f9a7a9d@ddn.com>
	(Bernd Schubert's message of "Tue, 07 Jan 2025 01:25:18 +0100")
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
	<20250107-fuse-uring-for-6-10-rfc4-v9-13-9c786f9a7a9d@ddn.com>
Date: Tue, 07 Jan 2025 15:54:27 +0000
Message-ID: <87a5c239ho.fsf@igalia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07 2025, Bernd Schubert wrote:

> This prepares queueing and sending foreground requests through
> io-uring.
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>  fs/fuse/dev_uring.c   | 185 ++++++++++++++++++++++++++++++++++++++++++++=
++++--
>  fs/fuse/dev_uring_i.h |  11 ++-
>  2 files changed, 187 insertions(+), 9 deletions(-)
>
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index 01a908b2ef9ada14b759ca047eab40b4c4431d89..89a22a4eee23cbba49bac7a2d=
2126bb51193326f 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -26,6 +26,29 @@ bool fuse_uring_enabled(void)
>  	return enable_uring;
>  }
>=20=20
> +struct fuse_uring_pdu {
> +	struct fuse_ring_ent *ring_ent;
> +};
> +
> +static const struct fuse_iqueue_ops fuse_io_uring_ops;
> +
> +static void uring_cmd_set_ring_ent(struct io_uring_cmd *cmd,
> +				   struct fuse_ring_ent *ring_ent)
> +{
> +	struct fuse_uring_pdu *pdu =3D
> +		io_uring_cmd_to_pdu(cmd, struct fuse_uring_pdu);
> +
> +	pdu->ring_ent =3D ring_ent;
> +}
> +
> +static struct fuse_ring_ent *uring_cmd_to_ring_ent(struct io_uring_cmd *=
cmd)
> +{
> +	struct fuse_uring_pdu *pdu =3D
> +		io_uring_cmd_to_pdu(cmd, struct fuse_uring_pdu);
> +
> +	return pdu->ring_ent;
> +}
> +
>  static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_=
err,
>  			       int error)
>  {
> @@ -441,7 +464,7 @@ static int fuse_uring_copy_to_ring(struct fuse_ring *=
ring, struct fuse_req *req,
>  	struct iov_iter iter;
>  	struct fuse_uring_ent_in_out ent_in_out =3D {
>  		.flags =3D 0,
> -		.commit_id =3D ent->commit_id,
> +		.commit_id =3D req->in.h.unique,
>  	};
>=20=20
>  	if (WARN_ON(ent_in_out.commit_id =3D=3D 0))
> @@ -460,7 +483,7 @@ static int fuse_uring_copy_to_ring(struct fuse_ring *=
ring, struct fuse_req *req,
>  	if (num_args > 0) {
>  		/*
>  		 * Expectation is that the first argument is the per op header.
> -		 * Some op code have that as zero.
> +		 * Some op code have that as zero size.
>  		 */
>  		if (args->in_args[0].size > 0) {
>  			res =3D copy_to_user(&ent->headers->op_in, in_args->value,
> @@ -578,11 +601,8 @@ static void fuse_uring_add_to_pq(struct fuse_ring_en=
t *ring_ent,
>  	struct fuse_pqueue *fpq =3D &queue->fpq;
>  	unsigned int hash;
>=20=20
> -	/* commit_id is the unique id of the request */
> -	ring_ent->commit_id =3D req->in.h.unique;
> -
>  	req->ring_entry =3D ring_ent;
> -	hash =3D fuse_req_hash(ring_ent->commit_id);
> +	hash =3D fuse_req_hash(req->in.h.unique);
>  	list_move_tail(&req->list, &fpq->processing[hash]);
>  }
>=20=20
> @@ -777,6 +797,31 @@ static int fuse_uring_commit_fetch(struct io_uring_c=
md *cmd, int issue_flags,
>  	return 0;
>  }
>=20=20
> +static bool is_ring_ready(struct fuse_ring *ring, int current_qid)
> +{
> +	int qid;
> +	struct fuse_ring_queue *queue;
> +	bool ready =3D true;
> +
> +	for (qid =3D 0; qid < ring->nr_queues && ready; qid++) {
> +		if (current_qid =3D=3D qid)
> +			continue;
> +
> +		queue =3D ring->queues[qid];
> +		if (!queue) {
> +			ready =3D false;
> +			break;
> +		}
> +
> +		spin_lock(&queue->lock);
> +		if (list_empty(&queue->ent_avail_queue))
> +			ready =3D false;
> +		spin_unlock(&queue->lock);
> +	}
> +
> +	return ready;
> +}
> +
>  /*
>   * fuse_uring_req_fetch command handling
>   */
> @@ -785,10 +830,22 @@ static void fuse_uring_do_register(struct fuse_ring=
_ent *ring_ent,
>  				   unsigned int issue_flags)
>  {
>  	struct fuse_ring_queue *queue =3D ring_ent->queue;
> +	struct fuse_ring *ring =3D queue->ring;
> +	struct fuse_conn *fc =3D ring->fc;
> +	struct fuse_iqueue *fiq =3D &fc->iq;
>=20=20
>  	spin_lock(&queue->lock);
>  	fuse_uring_ent_avail(ring_ent, queue);
>  	spin_unlock(&queue->lock);
> +
> +	if (!ring->ready) {
> +		bool ready =3D is_ring_ready(ring, queue->qid);
> +
> +		if (ready) {
> +			WRITE_ONCE(ring->ready, true);
> +			fiq->ops =3D &fuse_io_uring_ops;

Shouldn't we be taking the fiq->lock to protect the above operation?

> +		}
> +	}
>  }
>=20=20
>  /*
> @@ -979,3 +1036,119 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_=
cmd *cmd,
>=20=20
>  	return -EIOCBQUEUED;
>  }
> +
> +/*
> + * This prepares and sends the ring request in fuse-uring task context.
> + * User buffers are not mapped yet - the application does not have permi=
ssion
> + * to write to it - this has to be executed in ring task context.
> + */
> +static void
> +fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
> +			    unsigned int issue_flags)
> +{
> +	struct fuse_ring_ent *ent =3D uring_cmd_to_ring_ent(cmd);
> +	struct fuse_ring_queue *queue =3D ent->queue;
> +	int err;
> +
> +	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD)) {
> +		err =3D -ECANCELED;
> +		goto terminating;
> +	}
> +
> +	err =3D fuse_uring_prepare_send(ent);
> +	if (err)
> +		goto err;

Suggestion: simplify this function flow.  Something like:

	int err =3D 0;

	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD))
		err =3D -ECANCELED;
	else if (fuse_uring_prepare_send(ent)) {
		fuse_uring_next_fuse_req(ent, queue, issue_flags);
		return;
	}
	spin_lock(&queue->lock);
        [...]

> +		goto terminating;
> +	}
> +
> +	err =3D fuse_uring_prepare_send(ent);
> +	if (err)
> +		goto err;

> +
> +terminating:
> +	spin_lock(&queue->lock);
> +	ent->state =3D FRRS_USERSPACE;
> +	list_move(&ent->list, &queue->ent_in_userspace);
> +	spin_unlock(&queue->lock);
> +	io_uring_cmd_done(cmd, err, 0, issue_flags);
> +	ent->cmd =3D NULL;
> +	return;
> +err:
> +	fuse_uring_next_fuse_req(ent, queue, issue_flags);
> +}
> +
> +static struct fuse_ring_queue *fuse_uring_task_to_queue(struct fuse_ring=
 *ring)
> +{
> +	unsigned int qid;
> +	struct fuse_ring_queue *queue;
> +
> +	qid =3D task_cpu(current);
> +
> +	if (WARN_ONCE(qid >=3D ring->nr_queues,
> +		      "Core number (%u) exceeds nr ueues (%zu)\n", qid,

typo: 'queues'

> +		      ring->nr_queues))
> +		qid =3D 0;
> +
> +	queue =3D ring->queues[qid];
> +	if (WARN_ONCE(!queue, "Missing queue for qid %d\n", qid))
> +		return NULL;

nit: no need for this if statement.  The WARN_ONCE() is enough.

Cheers,
--=20
Lu=C3=ADs

> +
> +	return queue;
> +}
> +
> +/* queue a fuse request and send it if a ring entry is available */
> +void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req =
*req)
> +{
> +	struct fuse_conn *fc =3D req->fm->fc;
> +	struct fuse_ring *ring =3D fc->ring;
> +	struct fuse_ring_queue *queue;
> +	struct fuse_ring_ent *ent =3D NULL;
> +	int err;
> +
> +	err =3D -EINVAL;
> +	queue =3D fuse_uring_task_to_queue(ring);
> +	if (!queue)
> +		goto err;
> +
> +	if (req->in.h.opcode !=3D FUSE_NOTIFY_REPLY)
> +		req->in.h.unique =3D fuse_get_unique(fiq);
> +
> +	spin_lock(&queue->lock);
> +	err =3D -ENOTCONN;
> +	if (unlikely(queue->stopped))
> +		goto err_unlock;
> +
> +	ent =3D list_first_entry_or_null(&queue->ent_avail_queue,
> +				       struct fuse_ring_ent, list);
> +	if (ent)
> +		fuse_uring_add_req_to_ring_ent(ent, req);
> +	else
> +		list_add_tail(&req->list, &queue->fuse_req_queue);
> +	spin_unlock(&queue->lock);
> +
> +	if (ent) {
> +		struct io_uring_cmd *cmd =3D ent->cmd;
> +
> +		err =3D -EIO;
> +		if (WARN_ON_ONCE(ent->state !=3D FRRS_FUSE_REQ))
> +			goto err;
> +
> +		uring_cmd_set_ring_ent(cmd, ent);
> +		io_uring_cmd_complete_in_task(cmd, fuse_uring_send_req_in_task);
> +	}
> +
> +	return;
> +
> +err_unlock:
> +	spin_unlock(&queue->lock);
> +err:
> +	req->out.h.error =3D err;
> +	clear_bit(FR_PENDING, &req->flags);
> +	fuse_request_end(req);
> +}
> +
> +static const struct fuse_iqueue_ops fuse_io_uring_ops =3D {
> +	/* should be send over io-uring as enhancement */
> +	.send_forget =3D fuse_dev_queue_forget,
> +
> +	/*
> +	 * could be send over io-uring, but interrupts should be rare,
> +	 * no need to make the code complex
> +	 */
> +	.send_interrupt =3D fuse_dev_queue_interrupt,
> +	.send_req =3D fuse_uring_queue_fuse_req,
> +};
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> index ee5aeccae66caaf9a4dccbbbc785820836182668..cda330978faa019ceedf161f5=
0d86db976b072e2 100644
> --- a/fs/fuse/dev_uring_i.h
> +++ b/fs/fuse/dev_uring_i.h
> @@ -48,9 +48,6 @@ struct fuse_ring_ent {
>  	enum fuse_ring_req_state state;
>=20=20
>  	struct fuse_req *fuse_req;
> -
> -	/* commit id to identify the server reply */
> -	uint64_t commit_id;
>  };
>=20=20
>  struct fuse_ring_queue {
> @@ -120,6 +117,8 @@ struct fuse_ring {
>  	unsigned long teardown_time;
>=20=20
>  	atomic_t queue_refs;
> +
> +	bool ready;
>  };
>=20=20
>  bool fuse_uring_enabled(void);
> @@ -127,6 +126,7 @@ void fuse_uring_destruct(struct fuse_conn *fc);
>  void fuse_uring_stop_queues(struct fuse_ring *ring);
>  void fuse_uring_abort_end_requests(struct fuse_ring *ring);
>  int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
> +void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req =
*req);
>=20=20
>  static inline void fuse_uring_abort(struct fuse_conn *fc)
>  {
> @@ -150,6 +150,11 @@ static inline void fuse_uring_wait_stopped_queues(st=
ruct fuse_conn *fc)
>  			   atomic_read(&ring->queue_refs) =3D=3D 0);
>  }
>=20=20
> +static inline bool fuse_uring_ready(struct fuse_conn *fc)
> +{
> +	return fc->ring && fc->ring->ready;
> +}
> +
>  #else /* CONFIG_FUSE_IO_URING */
>=20=20
>  struct fuse_ring;
>
> --=20
> 2.43.0
>
>


