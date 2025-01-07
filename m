Return-Path: <io-uring+bounces-5734-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E934A045E8
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 17:22:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C31B41882893
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 16:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446B11428E7;
	Tue,  7 Jan 2025 16:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="H1lRn8YT"
X-Original-To: io-uring@vger.kernel.org
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0C61DFE00;
	Tue,  7 Jan 2025 16:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.60.130.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736266956; cv=none; b=YslnCId2dWi2VUWuNG872B1fglRPUvI9wL9YCEOjkVUF5sMfbTf14lHAZPM67s9RLXZY6/10PHiEFUPs+g5VR51aDJifAbWMlhS7/eII/NIJHucNbY4HZOELx8znvnnhc9ExZMbTV/HCD6mCAJWStb1PHNkemXWGFKbY9v/PMNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736266956; c=relaxed/simple;
	bh=6wxs//7s7+PNeap8ZETBN8oPFtHZrlD6Yga2ASIqNaE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lOsDYQ4SeewKcu6dKr8pyAwHkgG7EvRsQogqTHK50f5oefm63SgM2KbDWhTLmAFS/GpcAX4I3FNSudS/CnGVvw0Mh071kBij5d+bmJd+kdMt8DoLH+cfObFOA5pVv523j07PyqjoVJdrMmIM2RXupfbugmPP7wRcVRrVBioFpSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=H1lRn8YT; arc=none smtp.client-ip=178.60.130.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Hx0/P/Eb41FHeHANOh1PnuUvh0MQxye96E7jJqYXTpA=; b=H1lRn8YT/C+QqDvfJBhwlge21C
	Up2Sv8zxVwgPQSQS89815cMwuoe7N5rpYj46a6i4XbFaspkr8sHEL8sgrkWlzQkhEDc4IDs6nOdeE
	6XqXHmBSoNi4ojC+/4ln8TjEK9KjYPY/hcrr8OZMp8fc4WUhe3o/zmf+hULokl3sSevkH7I1ozktX
	j3FK3WL7NopYb3V/xw0sIgIZg36RdA1tQ2/sZIvPioQANtJCl21mgwOdn2aynQthppQFjwKyR8Ha+
	8y9LOmzXfc6btRiu54fZi6wKbHqx+4j1PZMtOzyh6ojtkzeNRkV7omuLaQiF54UhcvA+YeXx9pOKS
	rir4RUCQ==;
Received: from bl23-10-177.dsl.telepac.pt ([144.64.10.177] helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1tVCLa-00CnQN-6g; Tue, 07 Jan 2025 17:22:26 +0100
From: Luis Henriques <luis@igalia.com>
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Bernd Schubert <bschubert@ddn.com>,  Miklos Szeredi <miklos@szeredi.hu>,
  Jens Axboe <axboe@kernel.dk>,  Pavel Begunkov <asml.silence@gmail.com>,
  linux-fsdevel@vger.kernel.org,  io-uring@vger.kernel.org,  Joanne Koong
 <joannelkoong@gmail.com>,  Josef Bacik <josef@toxicpanda.com>,  Amir
 Goldstein <amir73il@gmail.com>,  Ming Lei <tom.leiming@gmail.com>,  David
 Wei <dw@davidwei.uk>
Subject: Re: [PATCH v9 10/17] fuse: Add io-uring sqe commit and fetch support
In-Reply-To: <5d2f5ed7-715a-470f-bff1-8d04af5be52d@bsbernd.com> (Bernd
	Schubert's message of "Tue, 7 Jan 2025 16:59:18 +0100")
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
	<20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
	<87ldvm3csz.fsf@igalia.com>
	<5d2f5ed7-715a-470f-bff1-8d04af5be52d@bsbernd.com>
Date: Tue, 07 Jan 2025 16:21:42 +0000
Message-ID: <87v7uq1tnt.fsf@igalia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07 2025, Bernd Schubert wrote:

> On 1/7/25 15:42, Luis Henriques wrote:
>> Hi,
>> On Tue, Jan 07 2025, Bernd Schubert wrote:
>>=20
>>> This adds support for fuse request completion through ring SQEs
>>> (FUSE_URING_CMD_COMMIT_AND_FETCH handling). After committing
>>> the ring entry it becomes available for new fuse requests.
>>> Handling of requests through the ring (SQE/CQE handling)
>>> is complete now.
>>>
>>> Fuse request data are copied through the mmaped ring buffer,
>>> there is no support for any zero copy yet.
>> Please find below a few more comments.
>
> Thanks, I fixed all comments, except of retry in fuse_uring_next_fuse_req.

Awesome, thanks for taking those comments into account.

> [...]
>
>> Also, please note that I'm trying to understand this patchset (and the
>> whole fuse-over-io-uring thing), so most of my comments are minor nits.
>> And those that are not may simply be wrong!  I'm just noting them as I
>> navigate through the code.
>> (And by the way, thanks for this work!)
>>=20
>>> +/*
>>> + * Get the next fuse req and send it
>>> + */
>>> +static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
>>> +				     struct fuse_ring_queue *queue,
>>> +				     unsigned int issue_flags)
>>> +{
>>> +	int err;
>>> +	bool has_next;
>>> +
>>> +retry:
>>> +	spin_lock(&queue->lock);
>>> +	fuse_uring_ent_avail(ring_ent, queue);
>>> +	has_next =3D fuse_uring_ent_assign_req(ring_ent);
>>> +	spin_unlock(&queue->lock);
>>> +
>>> +	if (has_next) {
>>> +		err =3D fuse_uring_send_next_to_ring(ring_ent, issue_flags);
>>> +		if (err)
>>> +			goto retry;
>> I wonder whether this is safe.  Maybe this is *obviously* safe, but I'm
>> still trying to understand this patchset; so, for me, it is not :-)
>> Would it be worth it trying to limit the maximum number of retries?
>
> No, we cannot limit retries. Let's do a simple example with one ring
> entry and also just one queue. Multiple applications create fuse
> requests. The first application fills the only available ring entry
> and submits it, the others just get queued in queue->fuse_req_queue.
> After that the application just waits request_wait_answer()
>
> On commit of the first request the ring task has to take the next
> request from queue->fuse_req_queue - if something fails with that
> request it has to complete it and proceed to the next request.
> If we would introduce a max-retries here, it would put the ring entry
> on hold (FRRS_AVAILABLE) and until another application comes, it would
> forever wait there. The applications waiting in request_wait_answer
> would never complete either.

Oh! OK, I see it now.  I totally misunderstood it then.  Thanks for taking
your taking explaining it.

Cheers,
--=20
Lu=C3=ADs

>>> +	}
>>> +}
>>> +
>>> +static int fuse_ring_ent_set_commit(struct fuse_ring_ent *ent)
>>> +{
>>> +	struct fuse_ring_queue *queue =3D ent->queue;
>>> +
>>> +	lockdep_assert_held(&queue->lock);
>>> +
>>> +	if (WARN_ON_ONCE(ent->state !=3D FRRS_USERSPACE))
>>> +		return -EIO;
>>> +
>>> +	ent->state =3D FRRS_COMMIT;
>>> +	list_move(&ent->list, &queue->ent_commit_queue);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +/* FUSE_URING_CMD_COMMIT_AND_FETCH handler */
>>> +static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue=
_flags,
>>> +				   struct fuse_conn *fc)
>>> +{
>>> +	const struct fuse_uring_cmd_req *cmd_req =3D io_uring_sqe_cmd(cmd->sq=
e);
>>> +	struct fuse_ring_ent *ring_ent;
>>> +	int err;
>>> +	struct fuse_ring *ring =3D fc->ring;
>>> +	struct fuse_ring_queue *queue;
>>> +	uint64_t commit_id =3D READ_ONCE(cmd_req->commit_id);
>>> +	unsigned int qid =3D READ_ONCE(cmd_req->qid);
>>> +	struct fuse_pqueue *fpq;
>>> +	struct fuse_req *req;
>>> +
>>> +	err =3D -ENOTCONN;
>>> +	if (!ring)
>>> +		return err;
>>> +
>>> +	if (qid >=3D ring->nr_queues)
>>> +		return -EINVAL;
>>> +
>>> +	queue =3D ring->queues[qid];
>>> +	if (!queue)
>>> +		return err;
>>> +	fpq =3D &queue->fpq;
>>> +
>>> +	spin_lock(&queue->lock);
>>> +	/* Find a request based on the unique ID of the fuse request
>>> +	 * This should get revised, as it needs a hash calculation and list
>>> +	 * search. And full struct fuse_pqueue is needed (memory overhead).
>>> +	 * As well as the link from req to ring_ent.
>>> +	 */
>>> +	req =3D fuse_request_find(fpq, commit_id);
>>> +	err =3D -ENOENT;
>>> +	if (!req) {
>>> +		pr_info("qid=3D%d commit_id %llu not found\n", queue->qid,
>>> +			commit_id);
>>> +		spin_unlock(&queue->lock);
>>> +		return err;
>>> +	}
>>> +	list_del_init(&req->list);
>>> +	ring_ent =3D req->ring_entry;
>>> +	req->ring_entry =3D NULL;
>>> +
>>> +	err =3D fuse_ring_ent_set_commit(ring_ent);
>>> +	if (err !=3D 0) {
>> I'm probably missing something, but because we removed 'req' from the li=
st
>> above, aren't we leaking it if we get an error here?
>
> Hmm, yeah, that is debatable. We basically have a grave error here.
> Either kernel or userspace are doing something wrong. Though probably
> you are right and we should end the request with EIO.
>
>
> Thanks,
> Bernd
>
>
>


