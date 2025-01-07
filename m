Return-Path: <io-uring+bounces-5732-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB1ABA04549
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 16:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B6BA1886E83
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 15:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8C81EF08A;
	Tue,  7 Jan 2025 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="ijZ9lES5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="d40U2tm8"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B6C1EE003;
	Tue,  7 Jan 2025 15:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736265568; cv=none; b=mlApbhr3gAKa1M3tJYZDUDAdsG0BB86hHOYZlM+PZ/fg7CmlT1OoVVgpgV4e7fgOEJHWLc/lylniBjhTckyDZyJWD303Bjl3Vkl69D1dRWMMfBtau8y+DUKiWFV/EDmDR7pT0AKVgSmIGSh4sFQOgm2N1g4eHxk9D6EeSQPt9nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736265568; c=relaxed/simple;
	bh=xXbqVvSxPsj7ApMWlwB65BdWqb1c9X8xr8beSGrXGV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oJlUJblMX/O0UoHoxb4O8sEFzznWTHjU2zvgkDFCVkfaUoC02P4uuaHXbeaHgZhM8xeN6i5RRmu6AV1UekBP35t2DDkErByt62P74QiBa2WFl5otXqR/aTXuGKm+dnJFF0jFWcGQdd31gAydhukNWjqSCVVYUnuxkv2HQAvHOnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=ijZ9lES5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=d40U2tm8; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 0D0BF11401B1;
	Tue,  7 Jan 2025 10:59:24 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 07 Jan 2025 10:59:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1736265563;
	 x=1736351963; bh=Pz0ceQd1L3T2zI8k5yjdA4ScXgnr50Fik0182ExC/9g=; b=
	ijZ9lES5RrhEjshl+uOtBIa+XarCAwVPI7YJKtgJIsbM38E/faref6QVW5CMtafz
	s2V4HOS00RWlsJaE6aEpchVTIXz+8slDbWmQ/3SQA0vdCt3AezRtX+dzL7pA/Uus
	yvR6ahOQJgvtnuGbYYDA+aXrZUB+o8epw7FFKMiNLld4Ndb8Q2XWwzDEqiMO50cZ
	Muw69BJnl6+DMB53RsrpJ29CB9KrobUn1if7B4ZF5/9SkiYQirmS/yj+4Lv8G7R+
	Q12FxlC5x2BRIZo+e1yjdyaVQ385sMW6qQF9Gw+e+0lghGaDIZCNPz6GFeUFl3xY
	DEuml92AHlqFaNc9VhOi6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1736265563; x=
	1736351963; bh=Pz0ceQd1L3T2zI8k5yjdA4ScXgnr50Fik0182ExC/9g=; b=d
	40U2tm8JmfykHX1be80h6pXIyrA3yrTuCOYWQOHttTlHIDiY2tKKRF5TgKGoaRVc
	QcF72Ck/JNSg6k+jhUbHYBxgpdGcFNkZcTHSoVjctHsO3dksS8Aew6KmKAen7Xn1
	n9aPYUDc2Asa4I/liHgeHVqjiXUxCoBxxJUwbaPL4sIQ8VBmNIXofidPi7AYSLEh
	QV6v820qoS3rQyK9pVWayaHGFPH+R0FM5QjXEZcGT0AYqDSgEhfyTlkq8OdcH9Ry
	3n6EfdhA3VScxMJYut+6D5lpCFwGC1n9CxCf/mAiTtiNXl4egT2gKvRdnnUM+JhK
	6Gs7fGuUQqDc8aNwXpH0Q==
X-ME-Sender: <xms:Wk99Z5NipREJ7vAbTVJGEONaw54P2qmcNFVgXtT7AmrcGZ4dhtcjrA>
    <xme:Wk99Z78mdbv9MZvLyYG_J-jk3OCxJ2Gykn6d46m85blCIgIYPmx6Ta-us6Si3q6db
    DvBX4a2Dk6FqT1M>
X-ME-Received: <xmr:Wk99Z4RxJWMhKQ-lxoFBjk9Wrig0Bgmz2Q-SW2lIPJ313gl5M-zWutcK61RuwwGphQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudegvddgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnh
    gurdgtohhmqeenucggtffrrghtthgvrhhnpeehhfejueejleehtdehteefvdfgtdelffeu
    udejhfehgedufedvhfehueevudeugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgt
    phhtthhopeduvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhuihhssehigh
    grlhhirgdrtghomhdprhgtphhtthhopegsshgthhhusggvrhhtseguughnrdgtohhmpdhr
    tghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtthhopegrgigsoh
    gvsehkvghrnhgvlhdrughkpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgr
    ihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtghomh
    dprhgtphhtthhopehjohhsvghfsehtohigihgtphgrnhgurgdrtghomh
X-ME-Proxy: <xmx:Wk99Z1tZgT0fL50FikQLIiq7cBFAyNFUbl1JynranvuOyHKNCYl_AQ>
    <xmx:Wk99ZxeSguxQfLoV_OChoznXVGYD1_jtINsXte_7_X6slGcT5q8Hnw>
    <xmx:Wk99Zx168yKn7XFctNC9MCO1kNBfnTkyHk8ACTZVwbmWt2d6t7V57g>
    <xmx:Wk99Z9-duszllClYuEbDWHxyVwpmYOh5a0fixM3TOXcymO1DWURufg>
    <xmx:W099Z_3TVUCFKS1q_4wbjaCigK9isE9yNoVpF_zcN69pIu2sV6-KPNAK>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Jan 2025 10:59:20 -0500 (EST)
Message-ID: <5d2f5ed7-715a-470f-bff1-8d04af5be52d@bsbernd.com>
Date: Tue, 7 Jan 2025 16:59:18 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/17] fuse: Add io-uring sqe commit and fetch support
To: Luis Henriques <luis@igalia.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
 <87ldvm3csz.fsf@igalia.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US
In-Reply-To: <87ldvm3csz.fsf@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/7/25 15:42, Luis Henriques wrote:
> Hi,
> 
> On Tue, Jan 07 2025, Bernd Schubert wrote:
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
> Please find below a few more comments.

Thanks, I fixed all comments, except of retry in fuse_uring_next_fuse_req.


[...]

> 
> Also, please note that I'm trying to understand this patchset (and the
> whole fuse-over-io-uring thing), so most of my comments are minor nits.
> And those that are not may simply be wrong!  I'm just noting them as I
> navigate through the code.
> 
> (And by the way, thanks for this work!)
> 
>> +/*
>> + * Get the next fuse req and send it
>> + */
>> +static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
>> +				     struct fuse_ring_queue *queue,
>> +				     unsigned int issue_flags)
>> +{
>> +	int err;
>> +	bool has_next;
>> +
>> +retry:
>> +	spin_lock(&queue->lock);
>> +	fuse_uring_ent_avail(ring_ent, queue);
>> +	has_next = fuse_uring_ent_assign_req(ring_ent);
>> +	spin_unlock(&queue->lock);
>> +
>> +	if (has_next) {
>> +		err = fuse_uring_send_next_to_ring(ring_ent, issue_flags);
>> +		if (err)
>> +			goto retry;
> 
> I wonder whether this is safe.  Maybe this is *obviously* safe, but I'm
> still trying to understand this patchset; so, for me, it is not :-)
> 
> Would it be worth it trying to limit the maximum number of retries?

No, we cannot limit retries. Let's do a simple example with one ring
entry and also just one queue. Multiple applications create fuse
requests. The first application fills the only available ring entry
and submits it, the others just get queued in queue->fuse_req_queue.
After that the application just waits request_wait_answer()

On commit of the first request the ring task has to take the next
request from queue->fuse_req_queue - if something fails with that
request it has to complete it and proceed to the next request.
If we would introduce a max-retries here, it would put the ring entry
on hold (FRRS_AVAILABLE) and until another application comes, it would
forever wait there. The applications waiting in request_wait_answer
would never complete either.


> 
>> +	}
>> +}
>> +
>> +static int fuse_ring_ent_set_commit(struct fuse_ring_ent *ent)
>> +{
>> +	struct fuse_ring_queue *queue = ent->queue;
>> +
>> +	lockdep_assert_held(&queue->lock);
>> +
>> +	if (WARN_ON_ONCE(ent->state != FRRS_USERSPACE))
>> +		return -EIO;
>> +
>> +	ent->state = FRRS_COMMIT;
>> +	list_move(&ent->list, &queue->ent_commit_queue);
>> +
>> +	return 0;
>> +}
>> +
>> +/* FUSE_URING_CMD_COMMIT_AND_FETCH handler */
>> +static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>> +				   struct fuse_conn *fc)
>> +{
>> +	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
>> +	struct fuse_ring_ent *ring_ent;
>> +	int err;
>> +	struct fuse_ring *ring = fc->ring;
>> +	struct fuse_ring_queue *queue;
>> +	uint64_t commit_id = READ_ONCE(cmd_req->commit_id);
>> +	unsigned int qid = READ_ONCE(cmd_req->qid);
>> +	struct fuse_pqueue *fpq;
>> +	struct fuse_req *req;
>> +
>> +	err = -ENOTCONN;
>> +	if (!ring)
>> +		return err;
>> +
>> +	if (qid >= ring->nr_queues)
>> +		return -EINVAL;
>> +
>> +	queue = ring->queues[qid];
>> +	if (!queue)
>> +		return err;
>> +	fpq = &queue->fpq;
>> +
>> +	spin_lock(&queue->lock);
>> +	/* Find a request based on the unique ID of the fuse request
>> +	 * This should get revised, as it needs a hash calculation and list
>> +	 * search. And full struct fuse_pqueue is needed (memory overhead).
>> +	 * As well as the link from req to ring_ent.
>> +	 */
>> +	req = fuse_request_find(fpq, commit_id);
>> +	err = -ENOENT;
>> +	if (!req) {
>> +		pr_info("qid=%d commit_id %llu not found\n", queue->qid,
>> +			commit_id);
>> +		spin_unlock(&queue->lock);
>> +		return err;
>> +	}
>> +	list_del_init(&req->list);
>> +	ring_ent = req->ring_entry;
>> +	req->ring_entry = NULL;
>> +
>> +	err = fuse_ring_ent_set_commit(ring_ent);
>> +	if (err != 0) {
> 
> I'm probably missing something, but because we removed 'req' from the list
> above, aren't we leaking it if we get an error here?

Hmm, yeah, that is debatable. We basically have a grave error here.
Either kernel or userspace are doing something wrong. Though probably
you are right and we should end the request with EIO.


Thanks,
Bernd




