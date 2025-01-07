Return-Path: <io-uring+bounces-5729-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 80834A042FD
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 15:46:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E3F918820A2
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 14:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A5A51F37BC;
	Tue,  7 Jan 2025 14:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="AxuHH87u"
X-Original-To: io-uring@vger.kernel.org
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DAA1F4266;
	Tue,  7 Jan 2025 14:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.60.130.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736261035; cv=none; b=GfjdVyUiuUO1vYhN/ig/huedVvmkjPZuyZPIl5tJxcJUlSLE7YD/1YFS/IF/dK1cTT7RB8QH7xK3wSRxZnvaAoEV4MOW8/QHRzI4vymPDNjBT4B4t3jOwVhrVe77nvh33pf7FqTeVJC/Z0sXqX+XQqVchd+s0no8HPLIdIdKKG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736261035; c=relaxed/simple;
	bh=XET52N7M0eGUziSMJyZbd6ZoSPTAoF7zQPVLxvmTz0s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Skqy11vDVPgc7Pw5w4mLxjc89VvOMt79pJBh5CoEvyh2WgMOyPRsRc1HHmwVNHlbf3DZniG6GkkZ4uvJko6OIn+ddCk3hBOdzWy4ieyr8ymhFXJq2OUlKE4eMdl5c+oY2RuG7ySJAh3nm06NpGC0NjBKBnUxa5BbLTumqXczjGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=AxuHH87u; arc=none smtp.client-ip=178.60.130.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TI7p5SpaSih+aIJ+z7u2GixnP4twdtAHkKJDjlnLw4E=; b=AxuHH87ub9K1d3MHcDlmr2eNIl
	JrGx9l6mZN2L7HxIMjRzH+/icjwtL4wn6BVxS7ypQTeQzVTK/wGrmv8g82MFaVJSiJ3OgRyW3W1xX
	1tXQ2oHrtJkT8ZKbC3AbIbz+UNcl/WLwuI3Y9LZ66XnK4kLvsBKhB9+I4ZIpnDThNXdzQnJ2EQGnO
	GFsVkyC07E0FCOMWz9hHLmIiDGx/JpKK1Wqx1jI12EaP3edGHaHbEqbWc/CsAaqOaerY0AnyHl88A
	vx2CZdncBgdwaqWNwQuj/0tLqyszzd3xov+9LVO0ef/stFeaNrccKHWI8FpQORPlCHFUgoIwjkisI
	9D9XgB0g==;
Received: from bl23-10-177.dsl.telepac.pt ([144.64.10.177] helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1tVAnw-00Clav-BK; Tue, 07 Jan 2025 15:43:36 +0100
From: Luis Henriques <luis@igalia.com>
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,  Jens Axboe <axboe@kernel.dk>,
  Pavel Begunkov <asml.silence@gmail.com>,  linux-fsdevel@vger.kernel.org,
  io-uring@vger.kernel.org,  Joanne Koong <joannelkoong@gmail.com>,  Josef
 Bacik <josef@toxicpanda.com>,  Amir Goldstein <amir73il@gmail.com>,  Ming
 Lei <tom.leiming@gmail.com>,  David Wei <dw@davidwei.uk>,
  bernd@bsbernd.com
Subject: Re: [PATCH v9 10/17] fuse: Add io-uring sqe commit and fetch support
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
	(Bernd Schubert's message of "Tue, 07 Jan 2025 01:25:15 +0100")
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
	<20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
Date: Tue, 07 Jan 2025 14:42:52 +0000
Message-ID: <87ldvm3csz.fsf@igalia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 07 2025, Bernd Schubert wrote:

> This adds support for fuse request completion through ring SQEs
> (FUSE_URING_CMD_COMMIT_AND_FETCH handling). After committing
> the ring entry it becomes available for new fuse requests.
> Handling of requests through the ring (SQE/CQE handling)
> is complete now.
>
> Fuse request data are copied through the mmaped ring buffer,
> there is no support for any zero copy yet.

Please find below a few more comments.

Also, please note that I'm trying to understand this patchset (and the
whole fuse-over-io-uring thing), so most of my comments are minor nits.
And those that are not may simply be wrong!  I'm just noting them as I
navigate through the code.

(And by the way, thanks for this work!)

> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>  fs/fuse/dev_uring.c   | 450 ++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/fuse/dev_uring_i.h |  12 ++
>  fs/fuse/fuse_i.h      |   4 +
>  3 files changed, 466 insertions(+)
>
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index b44ba4033615e01041313c040035b6da6af0ee17..f44e66a7ea577390da87e9ac7=
d118a9416898c28 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -26,6 +26,19 @@ bool fuse_uring_enabled(void)
>  	return enable_uring;
>  }
>=20=20
> +static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_=
err,
> +			       int error)
> +{
> +	struct fuse_req *req =3D ring_ent->fuse_req;
> +
> +	if (set_err)
> +		req->out.h.error =3D error;
> +
> +	clear_bit(FR_SENT, &req->flags);
> +	fuse_request_end(ring_ent->fuse_req);
> +	ring_ent->fuse_req =3D NULL;
> +}
> +
>  void fuse_uring_destruct(struct fuse_conn *fc)
>  {
>  	struct fuse_ring *ring =3D fc->ring;
> @@ -41,8 +54,11 @@ void fuse_uring_destruct(struct fuse_conn *fc)
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
> @@ -101,20 +117,34 @@ static struct fuse_ring_queue *fuse_uring_create_qu=
eue(struct fuse_ring *ring,
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
> @@ -128,6 +158,214 @@ static struct fuse_ring_queue *fuse_uring_create_qu=
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
> +		/* Not supportd through io-uring yet */

typo: "supported"

> +		pr_warn_once("notify through fuse-io-uring not supported\n");
> +		goto seterr;
> +	}
> +
> +	err =3D -EINVAL;

Not really needed, it already has this value.

> +	if (oh->error <=3D -ERESTARTSYS || oh->error > 0)
> +		goto seterr;
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
> +		goto seterr;
> +	}
> +
> +	/*
> +	 * Is it an interrupt reply ID?
> +	 * XXX: Not supported through fuse-io-uring yet, it should not even
> +	 *      find the request - should not happen.
> +	 */
> +	WARN_ON_ONCE(oh->unique & FUSE_INT_REQ_BIT);
> +
> +	return 0;
> +
> +seterr:
> +	oh->error =3D err;
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
> +	int err, res;

nit: no need for two variables; one of the 'int' variables could be
removed.  There are other functions with a similar pattern, but this was
the first one that caught my attention.

> +	struct fuse_uring_ent_in_out ring_in_out;
> +
> +	res =3D copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
> +			     sizeof(ring_in_out));
> +	if (res)
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

nit: extra space in comment indentation.

>=20
> +static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_r=
eq *req,
> +				   struct fuse_ring_ent *ent)
> +{
> +	struct fuse_copy_state cs;
> +	struct fuse_args *args =3D req->args;
> +	struct fuse_in_arg *in_args =3D args->in_args;
> +	int num_args =3D args->in_numargs;
> +	int err, res;
> +	struct iov_iter iter;
> +	struct fuse_uring_ent_in_out ent_in_out =3D {
> +		.flags =3D 0,
> +		.commit_id =3D ent->commit_id,
> +	};
> +
> +	if (WARN_ON(ent_in_out.commit_id =3D=3D 0))
> +		return -EINVAL;
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
> +		 * Some op code have that as zero.
> +		 */
> +		if (args->in_args[0].size > 0) {
> +			res =3D copy_to_user(&ent->headers->op_in, in_args->value,
> +					   in_args->size);
> +			err =3D res > 0 ? -EFAULT : res;
> +			if (err) {
> +				pr_info_ratelimited(
> +					"Copying the header failed.\n");
> +				return err;
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
> +	res =3D copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
> +			   sizeof(ent_in_out));
> +	err =3D res > 0 ? -EFAULT : res;
> +	if (err)
> +		return err;

Simply return err? :-)

> +
> +	return 0;
> +}
> +
> +static int
> +fuse_uring_prepare_send(struct fuse_ring_ent *ring_ent)
> +{
> +	struct fuse_ring_queue *queue =3D ring_ent->queue;
> +	struct fuse_ring *ring =3D queue->ring;
> +	struct fuse_req *req =3D ring_ent->fuse_req;
> +	int err, res;
> +
> +	err =3D -EIO;
> +	if (WARN_ON(ring_ent->state !=3D FRRS_FUSE_REQ)) {
> +		pr_err("qid=3D%d ring-req=3D%p invalid state %d on send\n",
> +		       queue->qid, ring_ent, ring_ent->state);
> +		err =3D -EIO;

'err' initialized twice.  One of these could be removed.

> +		goto err;
> +	}
> +
> +	/* copy the request */
> +	err =3D fuse_uring_copy_to_ring(ring, req, ring_ent);
> +	if (unlikely(err)) {
> +		pr_info_ratelimited("Copy to ring failed: %d\n", err);
> +		goto err;
> +	}
> +
> +	/* copy fuse_in_header */
> +	res =3D copy_to_user(&ring_ent->headers->in_out, &req->in.h,
> +			   sizeof(req->in.h));
> +	err =3D res > 0 ? -EFAULT : res;
> +	if (err)
> +		goto err;
> +
> +	set_bit(FR_SENT, &req->flags);
> +	return 0;
> +
> +err:
> +	fuse_uring_req_end(ring_ent, true, err);
> +	return err;
> +}
> +
> +/*
> + * Write data to the ring buffer and send the request to userspace,
> + * userspace will read it
> + * This is comparable with classical read(/dev/fuse)
> + */
> +static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent,
> +					unsigned int issue_flags)
> +{
> +	int err =3D 0;
> +	struct fuse_ring_queue *queue =3D ring_ent->queue;
> +
> +	err =3D fuse_uring_prepare_send(ring_ent);
> +	if (err)
> +		goto err;

Since this is the only place where this label is used, it could simply
return 'err' and the label removed.

> +
> +	spin_lock(&queue->lock);
> +	ring_ent->state =3D FRRS_USERSPACE;
> +	list_move(&ring_ent->list, &queue->ent_in_userspace);
> +	spin_unlock(&queue->lock);
> +
> +	io_uring_cmd_done(ring_ent->cmd, 0, 0, issue_flags);
> +	ring_ent->cmd =3D NULL;
> +	return 0;
> +
> +err:
> +	return err;
> +}
> +
>  /*
>   * Make a ring entry available for fuse_req assignment
>   */
> @@ -138,6 +376,210 @@ static void fuse_uring_ent_avail(struct fuse_ring_e=
nt *ring_ent,
>  	ring_ent->state =3D FRRS_AVAILABLE;
>  }
>=20=20
> +/* Used to find the request on SQE commit */
> +static void fuse_uring_add_to_pq(struct fuse_ring_ent *ring_ent,
> +				 struct fuse_req *req)
> +{
> +	struct fuse_ring_queue *queue =3D ring_ent->queue;
> +	struct fuse_pqueue *fpq =3D &queue->fpq;
> +	unsigned int hash;
> +
> +	/* commit_id is the unique id of the request */
> +	ring_ent->commit_id =3D req->in.h.unique;
> +
> +	req->ring_entry =3D ring_ent;
> +	hash =3D fuse_req_hash(ring_ent->commit_id);
> +	list_move_tail(&req->list, &fpq->processing[hash]);
> +}
> +
> +/*
> + * Assign a fuse queue entry to the given entry
> + */
> +static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ring_en=
t,
> +					   struct fuse_req *req)
> +{
> +	struct fuse_ring_queue *queue =3D ring_ent->queue;
> +
> +	lockdep_assert_held(&queue->lock);
> +
> +	if (WARN_ON_ONCE(ring_ent->state !=3D FRRS_AVAILABLE &&
> +			 ring_ent->state !=3D FRRS_COMMIT)) {
> +		pr_warn("%s qid=3D%d state=3D%d\n", __func__, ring_ent->queue->qid,
> +			ring_ent->state);
> +	}
> +	list_del_init(&req->list);
> +	clear_bit(FR_PENDING, &req->flags);
> +	ring_ent->fuse_req =3D req;
> +	ring_ent->state =3D FRRS_FUSE_REQ;
> +	list_move(&ring_ent->list, &queue->ent_w_req_queue);
> +	fuse_uring_add_to_pq(ring_ent, req);
> +}
> +
> +/*
> + * Release the ring entry and fetch the next fuse request if available
> + *
> + * @return true if a new request has been fetched
> + */
> +static bool fuse_uring_ent_assign_req(struct fuse_ring_ent *ring_ent)
> +	__must_hold(&queue->lock)
> +{
> +	struct fuse_req *req;
> +	struct fuse_ring_queue *queue =3D ring_ent->queue;
> +	struct list_head *req_queue =3D &queue->fuse_req_queue;
> +
> +	lockdep_assert_held(&queue->lock);
> +
> +	/* get and assign the next entry while it is still holding the lock */
> +	req =3D list_first_entry_or_null(req_queue, struct fuse_req, list);
> +	if (req) {
> +		fuse_uring_add_req_to_ring_ent(ring_ent, req);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Read data from the ring buffer, which user space has written to
> + * This is comparible with handling of classical write(/dev/fuse).

nit: "comparable"

> + * Also make the ring request available again for new fuse requests.
> + */
> +static void fuse_uring_commit(struct fuse_ring_ent *ring_ent,
> +			      unsigned int issue_flags)
> +{
> +	struct fuse_ring *ring =3D ring_ent->queue->ring;
> +	struct fuse_conn *fc =3D ring->fc;
> +	struct fuse_req *req =3D ring_ent->fuse_req;
> +	ssize_t err =3D 0;
> +	bool set_err =3D false;
> +
> +	err =3D copy_from_user(&req->out.h, &ring_ent->headers->in_out,
> +			     sizeof(req->out.h));
> +	if (err) {
> +		req->out.h.error =3D err;
> +		goto out;
> +	}
> +
> +	err =3D fuse_uring_out_header_has_err(&req->out.h, req, fc);
> +	if (err) {
> +		/* req->out.h.error already set */
> +		goto out;
> +	}
> +
> +	err =3D fuse_uring_copy_from_ring(ring, req, ring_ent);
> +	if (err)
> +		set_err =3D true;
> +
> +out:
> +	fuse_uring_req_end(ring_ent, set_err, err);
> +}
> +
> +/*
> + * Get the next fuse req and send it
> + */
> +static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
> +				     struct fuse_ring_queue *queue,
> +				     unsigned int issue_flags)
> +{
> +	int err;
> +	bool has_next;
> +
> +retry:
> +	spin_lock(&queue->lock);
> +	fuse_uring_ent_avail(ring_ent, queue);
> +	has_next =3D fuse_uring_ent_assign_req(ring_ent);
> +	spin_unlock(&queue->lock);
> +
> +	if (has_next) {
> +		err =3D fuse_uring_send_next_to_ring(ring_ent, issue_flags);
> +		if (err)
> +			goto retry;

I wonder whether this is safe.  Maybe this is *obviously* safe, but I'm
still trying to understand this patchset; so, for me, it is not :-)

Would it be worth it trying to limit the maximum number of retries?

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
> +	struct fuse_ring_ent *ring_ent;
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
> +	ring_ent =3D req->ring_entry;
> +	req->ring_entry =3D NULL;
> +
> +	err =3D fuse_ring_ent_set_commit(ring_ent);
> +	if (err !=3D 0) {

I'm probably missing something, but because we removed 'req' from the list
above, aren't we leaking it if we get an error here?

Cheers,
--=20
Lu=C3=ADs

> +		pr_info_ratelimited("qid=3D%d commit_id %llu state %d",
> +				    queue->qid, commit_id, ring_ent->state);
> +		spin_unlock(&queue->lock);
> +		return err;
> +	}
> +
> +	ring_ent->cmd =3D cmd;
> +	spin_unlock(&queue->lock);
> +
> +	/* without the queue lock, as other locks are taken */
> +	fuse_uring_commit(ring_ent, issue_flags);
> +
> +	/*
> +	 * Fetching the next request is absolutely required as queued
> +	 * fuse requests would otherwise not get processed - committing
> +	 * and fetching is done in one step vs legacy fuse, which has separated
> +	 * read (fetch request) and write (commit result).
> +	 */
> +	fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
> +	return 0;
> +}
> +
>  /*
>   * fuse_uring_req_fetch command handling
>   */
> @@ -325,6 +767,14 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cm=
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
> index 4e46dd65196d26dabc62dada33b17de9aa511c08..80f1c62d4df7f0ca77c4d5179=
068df6ffdbf7d85 100644
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
> @@ -70,7 +73,16 @@ struct fuse_ring_queue {
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
>


