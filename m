Return-Path: <io-uring+bounces-6059-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CAD8A1A50C
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:32:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ABD6A7A1553
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 13:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8543420E31C;
	Thu, 23 Jan 2025 13:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="TxSiSlCP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MBOMp+90"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185F7320B;
	Thu, 23 Jan 2025 13:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737639158; cv=none; b=pcLlVPHXJOqODXYA/IkYdtU3ivWj94Z+VGEW5alhbtZmXswc+kVd8ovNdErFAXP0U1OykmiDB5zVUAr/t24FXoqAyz8qJoONJjmeK2kbdvXhd21r5Lv+TZQim4PewVClpFVzcAG39iIzHuHki7ZcOGaFqcuKcPKyv/i2Y8fsxKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737639158; c=relaxed/simple;
	bh=Ku2z4XAMIWzb/0v1281Ehq9i9mx/1PapQBQdFlH1+aU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jadE11iMhXBvk6GUXqBw0OXUz7iXecvUZY0uAQp1VgDHK3sZnwRfP/Qc1f5FVV0kkJr8E4maSkbbInNBZA8fX9f/kgxEiZFeKQObQlGrEUTopoLJyo/ChQkgOmry19NGOBNXweVIYyd0Kc3W3GP2y3sgUcbyhUY3tziXbw32tYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=TxSiSlCP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MBOMp+90; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id 0507B13802D2;
	Thu, 23 Jan 2025 08:32:35 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 23 Jan 2025 08:32:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1737639154;
	 x=1737725554; bh=ULPnbH0mKN3QuJ+y4wd8Lb2Zl12W2fyOIawrKFG7wcU=; b=
	TxSiSlCPGVLHsaTsZ+V8sPoUDM+YvegV/vzu/lbTNSsTrXwbdMpd1Jo2qTQhASed
	Ye/JqOTtjLvBLw5wIEfrX5xrQbPhKfreLIZLoaWh+RmVNlFVOMjNVodKHdUArfno
	hej1VCWgRCShvi6YyMi3rBXkkaCpkt5wEsF9PGlfWfRayOQi0iYYJCnWUuuY36B6
	yI04KstMDcO0yfTwfVyCfUHpH4JBOtR0BTdNkON+5RDdJPUaXQGdFztB7lRMe5BV
	A1IlJgzr68uGmM7ILsjQxT5/5SymHCJdH/0Gidw74WXEHA0f4d+th19RozimALli
	zHAkuowTxKDTuYp3kyJRQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1737639154; x=
	1737725554; bh=ULPnbH0mKN3QuJ+y4wd8Lb2Zl12W2fyOIawrKFG7wcU=; b=M
	BOMp+902yasmm4/RMJvsCey/qrltO8c/QMpGV838u0e8R73oSa8cD5/eZ4rkVFgI
	EKFtBJyaZCrcDgRmthsm83hKFr/cpRlGaa4eHUx8jT3doAnBSRCf2QkEfYvZ67Ny
	gYOLJ6anvK9LzjgnOQXK0zjt0tqNxijCTv61Y3ytLMpDYKHpUp/jzb4gaIJNFurr
	SvK6C66YtMk6s5b62oNMlTN+hoz8Hi82/4iQkIqd4hclRXXxO42vMIm8yiu4BxUp
	UBNY7v79ZDvJyR53iUQNatM4iYzVQAZKZfWYcBufu7y4WcBFmLtP5irhHuJrXxea
	kxmJzn6yjkFBVy3EdDFhQ==
X-ME-Sender: <xms:8kSSZ5sZDcsTqdoo3igeqnUtHjeDN6_NpYPLIDPs5Il3nhvjgiWHqQ>
    <xme:8kSSZydFb4ZqjBfZHzHrEpvPRch7-UtLBPUzbiVeUBqngNZYlcA62YnVI0iTerItd
    PrhA26jgTaiRZNv>
X-ME-Received: <xmr:8kSSZ8zT1b6rcP4YWMRQIv8Inp9YjpFiGbJ1QCtz2vjmWIXUfgAEgMbW-Q6GGaBgqUT82nmEb6nPQZe6Z3NluUB28Nxl3B4TRuM_ycs-xF5UTjqawPET>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudejgedgudejkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugessghssggvrh
    hnugdrtghomheqnecuggftrfgrthhtvghrnhephefhjeeujeelhedtheetfedvgfdtleff
    uedujefhheegudefvdfhheeuveduueegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepsggvrhhnugessghssggvrhhnugdrtghomhdpnhgspghr
    tghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehluhhishesih
    hgrghlihgrrdgtohhmpdhrtghpthhtohepsghstghhuhgsvghrthesuggunhdrtghomhdp
    rhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtoheprgigsg
    hovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhm
    rghilhdrtghomhdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkh
    gvrhhnvghlrdhorhhgpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtoh
    hmpdhrtghpthhtohepjhhoshgvfhesthhogihitghprghnuggrrdgtohhm
X-ME-Proxy: <xmx:8kSSZwPiR8oXZjaaNthVTLN5bR0o7oGJyDarneKBKLbnNYyqfysHEw>
    <xmx:8kSSZ5-xseYKjx4LBRD7xnguQBsPT5EUZO4F2MinhdVRaYhFmW7zjw>
    <xmx:8kSSZwUXuAB8wG6NPvzBml7BSbTG4ZU2gv-rC41Moy7y-4X0qBEJdg>
    <xmx:8kSSZ6fcSbSo41FJKLLtfWB6mN-BWM5NebQbsXeiCfAnRF2Acow2hw>
    <xmx:8kSSZ8VU0pwrLuwn0gm_y_y74HlVSvCnu7wAlb9N1vl-CLsIubEaSCtY>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jan 2025 08:32:33 -0500 (EST)
Message-ID: <5e99c6ab-4a29-444e-ad39-26c3a74a87ed@bsbernd.com>
Date: Thu, 23 Jan 2025 14:32:32 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 10/17] fuse: Add io-uring sqe commit and fetch support
To: Luis Henriques <luis@igalia.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
References: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
 <20250120-fuse-uring-for-6-10-rfc4-v10-10-ca7c5d1007c0@ddn.com>
 <87zfjietbi.fsf@igalia.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <87zfjietbi.fsf@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/22/25 16:56, Luis Henriques wrote:
> On Mon, Jan 20 2025, Bernd Schubert wrote:
> 
>> This adds support for fuse request completion through ring SQEs
>> (FUSE_URING_CMD_COMMIT_AND_FETCH handling). After committing
>> the ring entry it becomes available for new fuse requests.
>> Handling of requests through the ring (SQE/CQE handling)
>> is complete now.
>>
>> Fuse request data are copied through the mmaped ring buffer,
>> there is no support for any zero copy yet.
> 
> Single comment below.
> 
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
>> ---
>>  fs/fuse/dev_uring.c   | 448 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/fuse/dev_uring_i.h |  12 ++
>>  fs/fuse/fuse_i.h      |   4 +
>>  3 files changed, 464 insertions(+)
>>
>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>> index 60e38ff1ecef3b007bae7ceedd7dd997439e463a..74aa5ccaff30998cf58e805f7c1b7ebf70d5cd6d 100644
>> --- a/fs/fuse/dev_uring.c
>> +++ b/fs/fuse/dev_uring.c
>> @@ -24,6 +24,18 @@ bool fuse_uring_enabled(void)
>>  	return enable_uring;
>>  }
>>  
>> +static void fuse_uring_req_end(struct fuse_ring_ent *ent, int error)
>> +{
>> +	struct fuse_req *req = ent->fuse_req;
>> +
>> +	if (error)
>> +		req->out.h.error = error;
>> +
>> +	clear_bit(FR_SENT, &req->flags);
>> +	fuse_request_end(ent->fuse_req);
>> +	ent->fuse_req = NULL;
>> +}
>> +
>>  void fuse_uring_destruct(struct fuse_conn *fc)
>>  {
>>  	struct fuse_ring *ring = fc->ring;
>> @@ -39,8 +51,11 @@ void fuse_uring_destruct(struct fuse_conn *fc)
>>  			continue;
>>  
>>  		WARN_ON(!list_empty(&queue->ent_avail_queue));
>> +		WARN_ON(!list_empty(&queue->ent_w_req_queue));
>>  		WARN_ON(!list_empty(&queue->ent_commit_queue));
>> +		WARN_ON(!list_empty(&queue->ent_in_userspace));
>>  
>> +		kfree(queue->fpq.processing);
>>  		kfree(queue);
>>  		ring->queues[qid] = NULL;
>>  	}
>> @@ -99,20 +114,34 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
>>  {
>>  	struct fuse_conn *fc = ring->fc;
>>  	struct fuse_ring_queue *queue;
>> +	struct list_head *pq;
>>  
>>  	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
>>  	if (!queue)
>>  		return NULL;
>> +	pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
>> +	if (!pq) {
>> +		kfree(queue);
>> +		return NULL;
>> +	}
>> +
>>  	queue->qid = qid;
>>  	queue->ring = ring;
>>  	spin_lock_init(&queue->lock);
>>  
>>  	INIT_LIST_HEAD(&queue->ent_avail_queue);
>>  	INIT_LIST_HEAD(&queue->ent_commit_queue);
>> +	INIT_LIST_HEAD(&queue->ent_w_req_queue);
>> +	INIT_LIST_HEAD(&queue->ent_in_userspace);
>> +	INIT_LIST_HEAD(&queue->fuse_req_queue);
>> +
>> +	queue->fpq.processing = pq;
>> +	fuse_pqueue_init(&queue->fpq);
>>  
>>  	spin_lock(&fc->lock);
>>  	if (ring->queues[qid]) {
>>  		spin_unlock(&fc->lock);
>> +		kfree(queue->fpq.processing);
>>  		kfree(queue);
>>  		return ring->queues[qid];
>>  	}
>> @@ -126,6 +155,213 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
>>  	return queue;
>>  }
>>  
>> +/*
>> + * Checks for errors and stores it into the request
>> + */
>> +static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
>> +					 struct fuse_req *req,
>> +					 struct fuse_conn *fc)
>> +{
>> +	int err;
>> +
>> +	err = -EINVAL;
>> +	if (oh->unique == 0) {
>> +		/* Not supported through io-uring yet */
>> +		pr_warn_once("notify through fuse-io-uring not supported\n");
>> +		goto err;
>> +	}
>> +
>> +	if (oh->error <= -ERESTARTSYS || oh->error > 0)
>> +		goto err;
>> +
>> +	if (oh->error) {
>> +		err = oh->error;
>> +		goto err;
>> +	}
>> +
>> +	err = -ENOENT;
>> +	if ((oh->unique & ~FUSE_INT_REQ_BIT) != req->in.h.unique) {
>> +		pr_warn_ratelimited("unique mismatch, expected: %llu got %llu\n",
>> +				    req->in.h.unique,
>> +				    oh->unique & ~FUSE_INT_REQ_BIT);
>> +		goto err;
>> +	}
>> +
>> +	/*
>> +	 * Is it an interrupt reply ID?
>> +	 * XXX: Not supported through fuse-io-uring yet, it should not even
>> +	 *      find the request - should not happen.
>> +	 */
>> +	WARN_ON_ONCE(oh->unique & FUSE_INT_REQ_BIT);
>> +
>> +	err = 0;
>> +err:
>> +	return err;
>> +}
>> +
>> +static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
>> +				     struct fuse_req *req,
>> +				     struct fuse_ring_ent *ent)
>> +{
>> +	struct fuse_copy_state cs;
>> +	struct fuse_args *args = req->args;
>> +	struct iov_iter iter;
>> +	int err;
>> +	struct fuse_uring_ent_in_out ring_in_out;
>> +
>> +	err = copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
>> +			     sizeof(ring_in_out));
>> +	if (err)
>> +		return -EFAULT;
>> +
>> +	err = import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_sz,
>> +			  &iter);
>> +	if (err)
>> +		return err;
>> +
>> +	fuse_copy_init(&cs, 0, &iter);
>> +	cs.is_uring = 1;
>> +	cs.req = req;
>> +
>> +	return fuse_copy_out_args(&cs, args, ring_in_out.payload_sz);
>> +}
>> +
>> + /*
>> +  * Copy data from the req to the ring buffer
>> +  */
>> +static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
>> +				   struct fuse_ring_ent *ent)
>> +{
>> +	struct fuse_copy_state cs;
>> +	struct fuse_args *args = req->args;
>> +	struct fuse_in_arg *in_args = args->in_args;
>> +	int num_args = args->in_numargs;
>> +	int err;
>> +	struct iov_iter iter;
>> +	struct fuse_uring_ent_in_out ent_in_out = {
>> +		.flags = 0,
>> +		.commit_id = req->in.h.unique,
>> +	};
>> +
>> +	err = import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz, &iter);
>> +	if (err) {
>> +		pr_info_ratelimited("fuse: Import of user buffer failed\n");
>> +		return err;
>> +	}
>> +
>> +	fuse_copy_init(&cs, 1, &iter);
>> +	cs.is_uring = 1;
>> +	cs.req = req;
>> +
>> +	if (num_args > 0) {
>> +		/*
>> +		 * Expectation is that the first argument is the per op header.
>> +		 * Some op code have that as zero size.
>> +		 */
>> +		if (args->in_args[0].size > 0) {
>> +			err = copy_to_user(&ent->headers->op_in, in_args->value,
>> +					   in_args->size);
>> +			if (err) {
>> +				pr_info_ratelimited(
>> +					"Copying the header failed.\n");
>> +				return -EFAULT;
>> +			}
>> +		}
>> +		in_args++;
>> +		num_args--;
>> +	}
>> +
>> +	/* copy the payload */
>> +	err = fuse_copy_args(&cs, num_args, args->in_pages,
>> +			     (struct fuse_arg *)in_args, 0);
>> +	if (err) {
>> +		pr_info_ratelimited("%s fuse_copy_args failed\n", __func__);
>> +		return err;
>> +	}
>> +
>> +	ent_in_out.payload_sz = cs.ring.copied_sz;
>> +	err = copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
>> +			   sizeof(ent_in_out));
>> +	return err ? -EFAULT : 0;
>> +}
>> +
>> +static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
>> +				   struct fuse_req *req)
>> +{
>> +	struct fuse_ring_queue *queue = ent->queue;
>> +	struct fuse_ring *ring = queue->ring;
>> +	int err;
>> +
>> +	err = -EIO;
>> +	if (WARN_ON(ent->state != FRRS_FUSE_REQ)) {
>> +		pr_err("qid=%d ring-req=%p invalid state %d on send\n",
>> +		       queue->qid, ent, ent->state);
>> +		return err;
>> +	}
>> +
>> +	err = -EINVAL;
>> +	if (WARN_ON(req->in.h.unique == 0))
>> +		return err;
>> +
>> +	/* copy the request */
>> +	err = fuse_uring_args_to_ring(ring, req, ent);
>> +	if (unlikely(err)) {
>> +		pr_info_ratelimited("Copy to ring failed: %d\n", err);
>> +		return err;
>> +	}
>> +
>> +	/* copy fuse_in_header */
>> +	err = copy_to_user(&ent->headers->in_out, &req->in.h,
>> +			   sizeof(req->in.h));
>> +	if (err) {
>> +		err = -EFAULT;
>> +		return err;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int fuse_uring_prepare_send(struct fuse_ring_ent *ent)
>> +{
>> +	struct fuse_req *req = ent->fuse_req;
>> +	int err;
>> +
>> +	err = fuse_uring_copy_to_ring(ent, req);
>> +	if (!err)
>> +		set_bit(FR_SENT, &req->flags);
>> +	else
>> +		fuse_uring_req_end(ent, err);
>> +
>> +	return err;
>> +}
>> +
>> +/*
>> + * Write data to the ring buffer and send the request to userspace,
>> + * userspace will read it
>> + * This is comparable with classical read(/dev/fuse)
>> + */
>> +static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ent,
>> +					unsigned int issue_flags)
>> +{
>> +	struct fuse_ring_queue *queue = ent->queue;
>> +	int err;
>> +	struct io_uring_cmd *cmd;
>> +
>> +	err = fuse_uring_prepare_send(ent);
>> +	if (err)
>> +		return err;
>> +
>> +	spin_lock(&queue->lock);
>> +	cmd = ent->cmd;
>> +	ent->cmd = NULL;
>> +	ent->state = FRRS_USERSPACE;
>> +	list_move(&ent->list, &queue->ent_in_userspace);
>> +	spin_unlock(&queue->lock);
>> +
>> +	io_uring_cmd_done(cmd, 0, 0, issue_flags);
>> +	return 0;
>> +}
>> +
>>  /*
>>   * Make a ring entry available for fuse_req assignment
>>   */
>> @@ -137,6 +373,210 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ent,
>>  	ent->state = FRRS_AVAILABLE;
>>  }
>>  
>> +/* Used to find the request on SQE commit */
>> +static void fuse_uring_add_to_pq(struct fuse_ring_ent *ent,
>> +				 struct fuse_req *req)
>> +{
>> +	struct fuse_ring_queue *queue = ent->queue;
>> +	struct fuse_pqueue *fpq = &queue->fpq;
>> +	unsigned int hash;
>> +
>> +	req->ring_entry = ent;
>> +	hash = fuse_req_hash(req->in.h.unique);
>> +	list_move_tail(&req->list, &fpq->processing[hash]);
>> +}
>> +
>> +/*
>> + * Assign a fuse queue entry to the given entry
>> + */
>> +static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ent,
>> +					   struct fuse_req *req)
>> +{
>> +	struct fuse_ring_queue *queue = ent->queue;
>> +	struct fuse_conn *fc = req->fm->fc;
>> +	struct fuse_iqueue *fiq = &fc->iq;
>> +
>> +	lockdep_assert_held(&queue->lock);
>> +
>> +	if (WARN_ON_ONCE(ent->state != FRRS_AVAILABLE &&
>> +			 ent->state != FRRS_COMMIT)) {
>> +		pr_warn("%s qid=%d state=%d\n", __func__, ent->queue->qid,
>> +			ent->state);
>> +	}
>> +
>> +	spin_lock(&fiq->lock);
>> +	clear_bit(FR_PENDING, &req->flags);
>> +	spin_unlock(&fiq->lock);
>> +	ent->fuse_req = req;
>> +	ent->state = FRRS_FUSE_REQ;
>> +	list_move(&ent->list, &queue->ent_w_req_queue);
>> +	fuse_uring_add_to_pq(ent, req);
>> +}
>> +
>> +/*
>> + * Release the ring entry and fetch the next fuse request if available
>> + *
>> + * @return true if a new request has been fetched
>> + */
>> +static bool fuse_uring_ent_assign_req(struct fuse_ring_ent *ent)
>> +	__must_hold(&queue->lock)
>> +{
>> +	struct fuse_req *req;
>> +	struct fuse_ring_queue *queue = ent->queue;
>> +	struct list_head *req_queue = &queue->fuse_req_queue;
>> +
>> +	lockdep_assert_held(&queue->lock);
>> +
>> +	/* get and assign the next entry while it is still holding the lock */
>> +	req = list_first_entry_or_null(req_queue, struct fuse_req, list);
>> +	if (req) {
>> +		fuse_uring_add_req_to_ring_ent(ent, req);
>> +		return true;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>> +/*
>> + * Read data from the ring buffer, which user space has written to
>> + * This is comparible with handling of classical write(/dev/fuse).
>> + * Also make the ring request available again for new fuse requests.
>> + */
>> +static void fuse_uring_commit(struct fuse_ring_ent *ent,
>> +			      unsigned int issue_flags)
>> +{
>> +	struct fuse_ring *ring = ent->queue->ring;
>> +	struct fuse_conn *fc = ring->fc;
>> +	struct fuse_req *req = ent->fuse_req;
>> +	ssize_t err = 0;
>> +
>> +	err = copy_from_user(&req->out.h, &ent->headers->in_out,
>> +			     sizeof(req->out.h));
>> +	if (err) {
>> +		req->out.h.error = err;
> 
> Shouldn't 'req->out.h.error' be set to -EFAULT instead?

Yep, thanks! I'm good at adding wrong error codes :(


Thanks,
Bernd


