Return-Path: <io-uring+bounces-6043-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC4DBA195E1
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 16:57:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C7BE18896DB
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 15:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E985F2147E5;
	Wed, 22 Jan 2025 15:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="h9TR7bVX"
X-Original-To: io-uring@vger.kernel.org
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52701214205;
	Wed, 22 Jan 2025 15:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.60.130.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737561417; cv=none; b=oqVEaCK45C3b83kvW6ZWREIru7foBt+KDuRnQrsDTJ8GFOtXC/OY4YrCLy5xjq0vPRFEV+wbUwKa80l5C4U81VWENu2IejUuaKCt6I98AjnkoQa31d1Po9Q5CLD8DCM7B/74K5azmNT/IawtR5GWANOFXyEnspVscr9btFvq5pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737561417; c=relaxed/simple;
	bh=gErql0MqfJBAyuX7vuYdjhGOuXaJMcj1PFhfFYgA9fw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HyeyT53is+Rf+wTepJgh6liE+E0EVQI5DKbdqS44P6F/z0Hxbef9hoW5V0Vns3NMoO4n85N28UrucQrzYp7WPZ04jrbtox5klkq1DV86Qnalx9GMLGlhcHpf4PIoI4UfwJT+3XyaEKnIcSfIWcwd50oLa+UUfGPFLJow6oYzICI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=h9TR7bVX; arc=none smtp.client-ip=178.60.130.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HyjsPgmvoou5Jc8L45eILCIFBPjtpPRTZAJLX7lAmY8=; b=h9TR7bVXFry98MkGVtbZdcrmSS
	u5zuFSX/nPhTB2YnrOyCugykvHewP5PR5+T875bDk3TJLON7uG200qLjCuUag4pPvA59cPPOlYOsM
	7bg37doBXvKiiXAC9U0biHwzh4PJnPvuq6OluLRICmwKeLISc2zmSaSO5VhNeio4UIFhu6UQ4gpHl
	0uRSyIqEbK/VriZSiH3xkIxYo9ZuI+re5906iXcZWVgzditYes3Bnq4pjccgZH9+ICE8Y5o3DK5z1
	UF2yQly5MEz4zJmwpMngeZfYVj4jg04dw6CEjbnY72RLdCK5qJ27Xpnn9wS42/5s8SBLBuZejP8WC
	23Jy/HSg==;
Received: from bl23-10-177.dsl.telepac.pt ([144.64.10.177] helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1tad5x-000nee-Qk; Wed, 22 Jan 2025 16:56:45 +0100
From: Luis Henriques <luis@igalia.com>
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,  Jens Axboe <axboe@kernel.dk>,
  Pavel Begunkov <asml.silence@gmail.com>,  linux-fsdevel@vger.kernel.org,
  io-uring@vger.kernel.org,  Joanne Koong <joannelkoong@gmail.com>,  Josef
 Bacik <josef@toxicpanda.com>,  Amir Goldstein <amir73il@gmail.com>,  Ming
 Lei <tom.leiming@gmail.com>,  David Wei <dw@davidwei.uk>,
  bernd@bsbernd.com
Subject: Re: [PATCH v10 10/17] fuse: Add io-uring sqe commit and fetch support
In-Reply-To: <20250120-fuse-uring-for-6-10-rfc4-v10-10-ca7c5d1007c0@ddn.com>
	(Bernd Schubert's message of "Mon, 20 Jan 2025 02:29:03 +0100")
References: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
	<20250120-fuse-uring-for-6-10-rfc4-v10-10-ca7c5d1007c0@ddn.com>
Date: Wed, 22 Jan 2025 15:56:01 +0000
Message-ID: <87zfjietbi.fsf@igalia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20 2025, Bernd Schubert wrote:

> This adds support for fuse request completion through ring SQEs
> (FUSE_URING_CMD_COMMIT_AND_FETCH handling). After committing
> the ring entry it becomes available for new fuse requests.
> Handling of requests through the ring (SQE/CQE handling)
> is complete now.
>
> Fuse request data are copied through the mmaped ring buffer,
> there is no support for any zero copy yet.

Single comment below.

> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
> ---
>  fs/fuse/dev_uring.c   | 448 ++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/fuse/dev_uring_i.h |  12 ++
>  fs/fuse/fuse_i.h      |   4 +
>  3 files changed, 464 insertions(+)
>
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index 60e38ff1ecef3b007bae7ceedd7dd997439e463a..74aa5ccaff30998cf58e805f7=
c1b7ebf70d5cd6d 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -24,6 +24,18 @@ bool fuse_uring_enabled(void)
>  	return enable_uring;
>  }
>=20=20
> +static void fuse_uring_req_end(struct fuse_ring_ent *ent, int error)
> +{
> +	struct fuse_req *req =3D ent->fuse_req;
> +
> +	if (error)
> +		req->out.h.error =3D error;
> +
> +	clear_bit(FR_SENT, &req->flags);
> +	fuse_request_end(ent->fuse_req);
> +	ent->fuse_req =3D NULL;
> +}
> +
>  void fuse_uring_destruct(struct fuse_conn *fc)
>  {
>  	struct fuse_ring *ring =3D fc->ring;
> @@ -39,8 +51,11 @@ void fuse_uring_destruct(struct fuse_conn *fc)
>  			continue;
>=20=20
>  		WARN_ON(!list_empty(&queue->ent_avail_queue));
> +		WARN_ON(!list_empty(&queue->ent_w_req_queue));
>  		WARN_ON(!list_empty(&queue->ent_commit_queue));
> +		WARN_ON(!list_empty(&queue->ent_in_userspace));
>=20=20
> +		kfree(queue->fpq.processing);
>  		kfree(queue);
>  		ring->queues[qid] =3D NULL;
>  	}
> @@ -99,20 +114,34 @@ static struct fuse_ring_queue *fuse_uring_create_que=
ue(struct fuse_ring *ring,
>  {
>  	struct fuse_conn *fc =3D ring->fc;
>  	struct fuse_ring_queue *queue;
> +	struct list_head *pq;
>=20=20
>  	queue =3D kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
>  	if (!queue)
>  		return NULL;
> +	pq =3D kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
> +	if (!pq) {
> +		kfree(queue);
> +		return NULL;
> +	}
> +
>  	queue->qid =3D qid;
>  	queue->ring =3D ring;
>  	spin_lock_init(&queue->lock);
>=20=20
>  	INIT_LIST_HEAD(&queue->ent_avail_queue);
>  	INIT_LIST_HEAD(&queue->ent_commit_queue);
> +	INIT_LIST_HEAD(&queue->ent_w_req_queue);
> +	INIT_LIST_HEAD(&queue->ent_in_userspace);
> +	INIT_LIST_HEAD(&queue->fuse_req_queue);
> +
> +	queue->fpq.processing =3D pq;
> +	fuse_pqueue_init(&queue->fpq);
>=20=20
>  	spin_lock(&fc->lock);
>  	if (ring->queues[qid]) {
>  		spin_unlock(&fc->lock);
> +		kfree(queue->fpq.processing);
>  		kfree(queue);
>  		return ring->queues[qid];
>  	}
> @@ -126,6 +155,213 @@ static struct fuse_ring_queue *fuse_uring_create_qu=
eue(struct fuse_ring *ring,
>  	return queue;
>  }
>=20=20
> +/*
> + * Checks for errors and stores it into the request
> + */
> +static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
> +					 struct fuse_req *req,
> +					 struct fuse_conn *fc)
> +{
> +	int err;
> +
> +	err =3D -EINVAL;
> +	if (oh->unique =3D=3D 0) {
> +		/* Not supported through io-uring yet */
> +		pr_warn_once("notify through fuse-io-uring not supported\n");
> +		goto err;
> +	}
> +
> +	if (oh->error <=3D -ERESTARTSYS || oh->error > 0)
> +		goto err;
> +
> +	if (oh->error) {
> +		err =3D oh->error;
> +		goto err;
> +	}
> +
> +	err =3D -ENOENT;
> +	if ((oh->unique & ~FUSE_INT_REQ_BIT) !=3D req->in.h.unique) {
> +		pr_warn_ratelimited("unique mismatch, expected: %llu got %llu\n",
> +				    req->in.h.unique,
> +				    oh->unique & ~FUSE_INT_REQ_BIT);
> +		goto err;
> +	}
> +
> +	/*
> +	 * Is it an interrupt reply ID?
> +	 * XXX: Not supported through fuse-io-uring yet, it should not even
> +	 *      find the request - should not happen.
> +	 */
> +	WARN_ON_ONCE(oh->unique & FUSE_INT_REQ_BIT);
> +
> +	err =3D 0;
> +err:
> +	return err;
> +}
> +
> +static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
> +				     struct fuse_req *req,
> +				     struct fuse_ring_ent *ent)
> +{
> +	struct fuse_copy_state cs;
> +	struct fuse_args *args =3D req->args;
> +	struct iov_iter iter;
> +	int err;
> +	struct fuse_uring_ent_in_out ring_in_out;
> +
> +	err =3D copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
> +			     sizeof(ring_in_out));
> +	if (err)
> +		return -EFAULT;
> +
> +	err =3D import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_sz,
> +			  &iter);
> +	if (err)
> +		return err;
> +
> +	fuse_copy_init(&cs, 0, &iter);
> +	cs.is_uring =3D 1;
> +	cs.req =3D req;
> +
> +	return fuse_copy_out_args(&cs, args, ring_in_out.payload_sz);
> +}
> +
> + /*
> +  * Copy data from the req to the ring buffer
> +  */
> +static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_r=
eq *req,
> +				   struct fuse_ring_ent *ent)
> +{
> +	struct fuse_copy_state cs;
> +	struct fuse_args *args =3D req->args;
> +	struct fuse_in_arg *in_args =3D args->in_args;
> +	int num_args =3D args->in_numargs;
> +	int err;
> +	struct iov_iter iter;
> +	struct fuse_uring_ent_in_out ent_in_out =3D {
> +		.flags =3D 0,
> +		.commit_id =3D req->in.h.unique,
> +	};
> +
> +	err =3D import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz, &ite=
r);
> +	if (err) {
> +		pr_info_ratelimited("fuse: Import of user buffer failed\n");
> +		return err;
> +	}
> +
> +	fuse_copy_init(&cs, 1, &iter);
> +	cs.is_uring =3D 1;
> +	cs.req =3D req;
> +
> +	if (num_args > 0) {
> +		/*
> +		 * Expectation is that the first argument is the per op header.
> +		 * Some op code have that as zero size.
> +		 */
> +		if (args->in_args[0].size > 0) {
> +			err =3D copy_to_user(&ent->headers->op_in, in_args->value,
> +					   in_args->size);
> +			if (err) {
> +				pr_info_ratelimited(
> +					"Copying the header failed.\n");
> +				return -EFAULT;
> +			}
> +		}
> +		in_args++;
> +		num_args--;
> +	}
> +
> +	/* copy the payload */
> +	err =3D fuse_copy_args(&cs, num_args, args->in_pages,
> +			     (struct fuse_arg *)in_args, 0);
> +	if (err) {
> +		pr_info_ratelimited("%s fuse_copy_args failed\n", __func__);
> +		return err;
> +	}
> +
> +	ent_in_out.payload_sz =3D cs.ring.copied_sz;
> +	err =3D copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
> +			   sizeof(ent_in_out));
> +	return err ? -EFAULT : 0;
> +}
> +
> +static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
> +				   struct fuse_req *req)
> +{
> +	struct fuse_ring_queue *queue =3D ent->queue;
> +	struct fuse_ring *ring =3D queue->ring;
> +	int err;
> +
> +	err =3D -EIO;
> +	if (WARN_ON(ent->state !=3D FRRS_FUSE_REQ)) {
> +		pr_err("qid=3D%d ring-req=3D%p invalid state %d on send\n",
> +		       queue->qid, ent, ent->state);
> +		return err;
> +	}
> +
> +	err =3D -EINVAL;
> +	if (WARN_ON(req->in.h.unique =3D=3D 0))
> +		return err;
> +
> +	/* copy the request */
> +	err =3D fuse_uring_args_to_ring(ring, req, ent);
> +	if (unlikely(err)) {
> +		pr_info_ratelimited("Copy to ring failed: %d\n", err);
> +		return err;
> +	}
> +
> +	/* copy fuse_in_header */
> +	err =3D copy_to_user(&ent->headers->in_out, &req->in.h,
> +			   sizeof(req->in.h));
> +	if (err) {
> +		err =3D -EFAULT;
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int fuse_uring_prepare_send(struct fuse_ring_ent *ent)
> +{
> +	struct fuse_req *req =3D ent->fuse_req;
> +	int err;
> +
> +	err =3D fuse_uring_copy_to_ring(ent, req);
> +	if (!err)
> +		set_bit(FR_SENT, &req->flags);
> +	else
> +		fuse_uring_req_end(ent, err);
> +
> +	return err;
> +}
> +
> +/*
> + * Write data to the ring buffer and send the request to userspace,
> + * userspace will read it
> + * This is comparable with classical read(/dev/fuse)
> + */
> +static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ent,
> +					unsigned int issue_flags)
> +{
> +	struct fuse_ring_queue *queue =3D ent->queue;
> +	int err;
> +	struct io_uring_cmd *cmd;
> +
> +	err =3D fuse_uring_prepare_send(ent);
> +	if (err)
> +		return err;
> +
> +	spin_lock(&queue->lock);
> +	cmd =3D ent->cmd;
> +	ent->cmd =3D NULL;
> +	ent->state =3D FRRS_USERSPACE;
> +	list_move(&ent->list, &queue->ent_in_userspace);
> +	spin_unlock(&queue->lock);
> +
> +	io_uring_cmd_done(cmd, 0, 0, issue_flags);
> +	return 0;
> +}
> +
>  /*
>   * Make a ring entry available for fuse_req assignment
>   */
> @@ -137,6 +373,210 @@ static void fuse_uring_ent_avail(struct fuse_ring_e=
nt *ent,
>  	ent->state =3D FRRS_AVAILABLE;
>  }
>=20=20
> +/* Used to find the request on SQE commit */
> +static void fuse_uring_add_to_pq(struct fuse_ring_ent *ent,
> +				 struct fuse_req *req)
> +{
> +	struct fuse_ring_queue *queue =3D ent->queue;
> +	struct fuse_pqueue *fpq =3D &queue->fpq;
> +	unsigned int hash;
> +
> +	req->ring_entry =3D ent;
> +	hash =3D fuse_req_hash(req->in.h.unique);
> +	list_move_tail(&req->list, &fpq->processing[hash]);
> +}
> +
> +/*
> + * Assign a fuse queue entry to the given entry
> + */
> +static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ent,
> +					   struct fuse_req *req)
> +{
> +	struct fuse_ring_queue *queue =3D ent->queue;
> +	struct fuse_conn *fc =3D req->fm->fc;
> +	struct fuse_iqueue *fiq =3D &fc->iq;
> +
> +	lockdep_assert_held(&queue->lock);
> +
> +	if (WARN_ON_ONCE(ent->state !=3D FRRS_AVAILABLE &&
> +			 ent->state !=3D FRRS_COMMIT)) {
> +		pr_warn("%s qid=3D%d state=3D%d\n", __func__, ent->queue->qid,
> +			ent->state);
> +	}
> +
> +	spin_lock(&fiq->lock);
> +	clear_bit(FR_PENDING, &req->flags);
> +	spin_unlock(&fiq->lock);
> +	ent->fuse_req =3D req;
> +	ent->state =3D FRRS_FUSE_REQ;
> +	list_move(&ent->list, &queue->ent_w_req_queue);
> +	fuse_uring_add_to_pq(ent, req);
> +}
> +
> +/*
> + * Release the ring entry and fetch the next fuse request if available
> + *
> + * @return true if a new request has been fetched
> + */
> +static bool fuse_uring_ent_assign_req(struct fuse_ring_ent *ent)
> +	__must_hold(&queue->lock)
> +{
> +	struct fuse_req *req;
> +	struct fuse_ring_queue *queue =3D ent->queue;
> +	struct list_head *req_queue =3D &queue->fuse_req_queue;
> +
> +	lockdep_assert_held(&queue->lock);
> +
> +	/* get and assign the next entry while it is still holding the lock */
> +	req =3D list_first_entry_or_null(req_queue, struct fuse_req, list);
> +	if (req) {
> +		fuse_uring_add_req_to_ring_ent(ent, req);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Read data from the ring buffer, which user space has written to
> + * This is comparible with handling of classical write(/dev/fuse).
> + * Also make the ring request available again for new fuse requests.
> + */
> +static void fuse_uring_commit(struct fuse_ring_ent *ent,
> +			      unsigned int issue_flags)
> +{
> +	struct fuse_ring *ring =3D ent->queue->ring;
> +	struct fuse_conn *fc =3D ring->fc;
> +	struct fuse_req *req =3D ent->fuse_req;
> +	ssize_t err =3D 0;
> +
> +	err =3D copy_from_user(&req->out.h, &ent->headers->in_out,
> +			     sizeof(req->out.h));
> +	if (err) {
> +		req->out.h.error =3D err;

Shouldn't 'req->out.h.error' be set to -EFAULT instead?

Cheers,
--=20
Lu=C3=ADs

> +		goto out;
> +	}
> +
> +	err =3D fuse_uring_out_header_has_err(&req->out.h, req, fc);
> +	if (err) {
> +		/* req->out.h.error already set */
> +		goto out;
> +	}
> +
> +	err =3D fuse_uring_copy_from_ring(ring, req, ent);
> +out:
> +	fuse_uring_req_end(ent, err);
> +}
> +
> +/*
> + * Get the next fuse req and send it
> + */
> +static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ent,
> +				     struct fuse_ring_queue *queue,
> +				     unsigned int issue_flags)
> +{
> +	int err;
> +	bool has_next;
> +
> +retry:
> +	spin_lock(&queue->lock);
> +	fuse_uring_ent_avail(ent, queue);
> +	has_next =3D fuse_uring_ent_assign_req(ent);
> +	spin_unlock(&queue->lock);
> +
> +	if (has_next) {
> +		err =3D fuse_uring_send_next_to_ring(ent, issue_flags);
> +		if (err)
> +			goto retry;
> +	}
> +}
> +
> +static int fuse_ring_ent_set_commit(struct fuse_ring_ent *ent)
> +{
> +	struct fuse_ring_queue *queue =3D ent->queue;
> +
> +	lockdep_assert_held(&queue->lock);
> +
> +	if (WARN_ON_ONCE(ent->state !=3D FRRS_USERSPACE))
> +		return -EIO;
> +
> +	ent->state =3D FRRS_COMMIT;
> +	list_move(&ent->list, &queue->ent_commit_queue);
> +
> +	return 0;
> +}
> +
> +/* FUSE_URING_CMD_COMMIT_AND_FETCH handler */
> +static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_f=
lags,
> +				   struct fuse_conn *fc)
> +{
> +	const struct fuse_uring_cmd_req *cmd_req =3D io_uring_sqe_cmd(cmd->sqe);
> +	struct fuse_ring_ent *ent;
> +	int err;
> +	struct fuse_ring *ring =3D fc->ring;
> +	struct fuse_ring_queue *queue;
> +	uint64_t commit_id =3D READ_ONCE(cmd_req->commit_id);
> +	unsigned int qid =3D READ_ONCE(cmd_req->qid);
> +	struct fuse_pqueue *fpq;
> +	struct fuse_req *req;
> +
> +	err =3D -ENOTCONN;
> +	if (!ring)
> +		return err;
> +
> +	if (qid >=3D ring->nr_queues)
> +		return -EINVAL;
> +
> +	queue =3D ring->queues[qid];
> +	if (!queue)
> +		return err;
> +	fpq =3D &queue->fpq;
> +
> +	spin_lock(&queue->lock);
> +	/* Find a request based on the unique ID of the fuse request
> +	 * This should get revised, as it needs a hash calculation and list
> +	 * search. And full struct fuse_pqueue is needed (memory overhead).
> +	 * As well as the link from req to ring_ent.
> +	 */
> +	req =3D fuse_request_find(fpq, commit_id);
> +	err =3D -ENOENT;
> +	if (!req) {
> +		pr_info("qid=3D%d commit_id %llu not found\n", queue->qid,
> +			commit_id);
> +		spin_unlock(&queue->lock);
> +		return err;
> +	}
> +	list_del_init(&req->list);
> +	ent =3D req->ring_entry;
> +	req->ring_entry =3D NULL;
> +
> +	err =3D fuse_ring_ent_set_commit(ent);
> +	if (err !=3D 0) {
> +		pr_info_ratelimited("qid=3D%d commit_id %llu state %d",
> +				    queue->qid, commit_id, ent->state);
> +		spin_unlock(&queue->lock);
> +		req->out.h.error =3D err;
> +		clear_bit(FR_SENT, &req->flags);
> +		fuse_request_end(req);
> +		return err;
> +	}
> +
> +	ent->cmd =3D cmd;
> +	spin_unlock(&queue->lock);
> +
> +	/* without the queue lock, as other locks are taken */
> +	fuse_uring_commit(ent, issue_flags);
> +
> +	/*
> +	 * Fetching the next request is absolutely required as queued
> +	 * fuse requests would otherwise not get processed - committing
> +	 * and fetching is done in one step vs legacy fuse, which has separated
> +	 * read (fetch request) and write (commit result).
> +	 */
> +	fuse_uring_next_fuse_req(ent, queue, issue_flags);
> +	return 0;
> +}
> +
>  /*
>   * fuse_uring_req_fetch command handling
>   */
> @@ -318,6 +758,14 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cm=
d *cmd,
>  			return err;
>  		}
>  		break;
> +	case FUSE_IO_URING_CMD_COMMIT_AND_FETCH:
> +		err =3D fuse_uring_commit_fetch(cmd, issue_flags, fc);
> +		if (err) {
> +			pr_info_once("FUSE_IO_URING_COMMIT_AND_FETCH failed err=3D%d\n",
> +				     err);
> +			return err;
> +		}
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> index ae1536355b368583132d2ab6878b5490510b28e8..44bf237f0d5abcadbb768ba39=
40c3fec813b079d 100644
> --- a/fs/fuse/dev_uring_i.h
> +++ b/fs/fuse/dev_uring_i.h
> @@ -20,6 +20,9 @@ enum fuse_ring_req_state {
>  	/* The ring entry is waiting for new fuse requests */
>  	FRRS_AVAILABLE,
>=20=20
> +	/* The ring entry got assigned a fuse req */
> +	FRRS_FUSE_REQ,
> +
>  	/* The ring entry is in or on the way to user space */
>  	FRRS_USERSPACE,
>  };
> @@ -67,7 +70,16 @@ struct fuse_ring_queue {
>  	 * entries in the process of being committed or in the process
>  	 * to be sent to userspace
>  	 */
> +	struct list_head ent_w_req_queue;
>  	struct list_head ent_commit_queue;
> +
> +	/* entries in userspace */
> +	struct list_head ent_in_userspace;
> +
> +	/* fuse requests waiting for an entry slot */
> +	struct list_head fuse_req_queue;
> +
> +	struct fuse_pqueue fpq;
>  };
>=20=20
>  /**
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index e545b0864dd51e82df61cc39bdf65d3d36a418dc..e71556894bc25808581424ec7=
bdd4afeebc81f15 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -438,6 +438,10 @@ struct fuse_req {
>=20=20
>  	/** fuse_mount this request belongs to */
>  	struct fuse_mount *fm;
> +
> +#ifdef CONFIG_FUSE_IO_URING
> +	void *ring_entry;
> +#endif
>  };
>=20=20
>  struct fuse_iqueue;
>
> --=20
> 2.43.0
>

