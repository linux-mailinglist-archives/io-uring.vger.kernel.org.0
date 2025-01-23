Return-Path: <io-uring+bounces-6057-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E93C9A1A4BD
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:18:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7833188BED5
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 13:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF8B820F076;
	Thu, 23 Jan 2025 13:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="L3IscpZK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nHCz0oAl"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34B838F83;
	Thu, 23 Jan 2025 13:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737638285; cv=none; b=qvbagbwqXrhv/VR4HYIERj+ErTcHUw5oTd6JMX6EGaO8lkor/aui8ETgHMW6TASi76CRBNNMk9rFJNQvGs3CMwxkaIig5dU0a9MLsO0nhG945I7eEJ5BEtUAQfFqehi6fxaFct2Ou7xC7Js3uD5OiB6mNWZxp7Xs/xBrpUZ20tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737638285; c=relaxed/simple;
	bh=92fFlFrCW73ey86T8HnUH5PkVeFSBrECVQNXx1VcR1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EUkkdnlf+pWYxUIzVZ3yyTJpyqM6rdzCtdgPRf8f6a4vKqhJUAol6vcRGmgJ9UQYhoYHJTaZOdEcSa2tLSMh1+MvEugmCTxyHDssOKREZk1tnFkZjcBth+KZ0AWUoOcNc57GfNauZCAQmW1NAi+96IE9ym9V10t3jh9h6hettzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=L3IscpZK; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nHCz0oAl; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A8C6411401F6;
	Thu, 23 Jan 2025 08:18:01 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 23 Jan 2025 08:18:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1737638281;
	 x=1737724681; bh=P/+X1yNQ7fMkyNOdlCKIt5dl2GLx3acEIE9mmkTz+ps=; b=
	L3IscpZKAF/ODicXYjs/ma2XtUovvWgWTOlGOOAJCV/5rSCaDYJi1O7iJucDQlj1
	t5ptTCh3OKp0nuNvbAi+5D3jmvMv97YSrWO8XwEAqY4SNSEZWQ7wVE/cVEUPA8Z5
	Phk9dDxUevabOrWyU9Z0WdNZYlQzEhNPH7WbpSnOMgJkAKFxbp3saQjfcDgqdWYe
	erWmqPr7RznNmC64K68pCA6vXXh61grlXGgLjJOX8/LmdDSVSrdShD0dswSy0wbb
	5Auz0OQOTtSaTBx0UKbsNwoAzGiUtIcd+VuSIQ1Ugk7wFqfMzOdX4Dv0fl+JFuP8
	1VcCYTnPKNJyYBU3QDpeZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1737638281; x=
	1737724681; bh=P/+X1yNQ7fMkyNOdlCKIt5dl2GLx3acEIE9mmkTz+ps=; b=n
	HCz0oAlP4FN7mwIaXSweENI/rQPJrsI9NlUgfOTEskZ1PF1aAbMN5Gdn2vznL8R5
	Xb+iIngnyeyxVPfB5MDgykV9e9bYCm+vuVf33BwX4NTCPos4N+Q5yXdpOPniaEbI
	ynHLIaqFv/srNMbohFiF+nnIhCKb8O9g90lcnM5HcK9IVCBlkIQtYs8ZS3BhIo6R
	SmCdcxQxgG7Gt+e8B7AGCagbD8tNemLfRUc7IMzOPbbMEC74jCH10095irCzYQnH
	NEa+JWbAb2eK0Qe+6z6xNX1x1NPT8Gtsb4eMf1dK2QwcIAI4QuChWmyiMPLHUnNf
	KOY24LYQXYLnpEO0IAb8A==
X-ME-Sender: <xms:iEGSZ5At_4ECstKPSStYyCpqOxCRSPnHYSs9dlF58kPM_nwwmkfrOA>
    <xme:iEGSZ3jiS8V2tJBiO39IiRbC3mVY__yPm6OpPZLLwoKYZ6U6YCWZNcMdr0wShqkAe
    _aQ-Ipj_rGgSIEA>
X-ME-Received: <xmr:iEGSZ0mVx_z_3Mm7shm2yT6f1DLLwV68E9A2hCXCJiwnqL73Y5kOclKka2Cv7LPJvfGPTtCCZUhcD69UN5RIOCHPJ9LGjwJjxpK1SC_5smakzCtbOuKk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudejgedgudejhecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:iEGSZzySSSMTiptQqc5Ebe6D6CS4S6GjNWeyy5tTZAsYPwIUtknsPQ>
    <xmx:iEGSZ-TvSDO0WhFPV5gSHE2mqMO9B6PHKl-ExaFqZxkMxCHuPk9pIQ>
    <xmx:iEGSZ2aYq7xNavi0q9wRqlH2hNc9fpNWy0wLfwfhPR_10OLnhZrv1A>
    <xmx:iEGSZ_QYoeR_Ec24JGWYqRyhI3InG_2QAWfgmNZ49947j-RoOQk_mw>
    <xmx:iUGSZ1I-VcQis-rYkIcYrEkexf059z1tbPr_uHM1crfCnEblRsHnwp1q>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jan 2025 08:17:58 -0500 (EST)
Message-ID: <6eee7da2-80c2-48ab-8a2d-9cf19b2e491f@bsbernd.com>
Date: Thu, 23 Jan 2025 14:17:57 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/17] fuse: {io-uring} Handle SQEs - register
 commands
To: Luis Henriques <luis@igalia.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
References: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
 <20250120-fuse-uring-for-6-10-rfc4-v10-6-ca7c5d1007c0@ddn.com>
 <87wmemetaw.fsf@igalia.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <87wmemetaw.fsf@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/22/25 16:56, Luis Henriques wrote:
> On Mon, Jan 20 2025, Bernd Schubert wrote:
> 
>> This adds basic support for ring SQEs (with opcode=IORING_OP_URING_CMD).
>> For now only FUSE_IO_URING_CMD_REGISTER is handled to register queue
>> entries.
> 
> Three comments below.
> 
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
>> ---
>>  fs/fuse/Kconfig           |  12 ++
>>  fs/fuse/Makefile          |   1 +
>>  fs/fuse/dev_uring.c       | 326 ++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/fuse/dev_uring_i.h     | 113 ++++++++++++++++
>>  fs/fuse/fuse_i.h          |   5 +
>>  fs/fuse/inode.c           |  10 ++
>>  include/uapi/linux/fuse.h |  76 ++++++++++-
>>  7 files changed, 542 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
>> index 8674dbfbe59dbf79c304c587b08ebba3cfe405be..ca215a3cba3e310d1359d069202193acdcdb172b 100644
>> --- a/fs/fuse/Kconfig
>> +++ b/fs/fuse/Kconfig
>> @@ -63,3 +63,15 @@ config FUSE_PASSTHROUGH
>>  	  to be performed directly on a backing file.
>>  
>>  	  If you want to allow passthrough operations, answer Y.
>> +
>> +config FUSE_IO_URING
>> +	bool "FUSE communication over io-uring"
>> +	default y
>> +	depends on FUSE_FS
>> +	depends on IO_URING
>> +	help
>> +	  This allows sending FUSE requests over the io-uring interface and
>> +          also adds request core affinity.
>> +
>> +	  If you want to allow fuse server/client communication through io-uring,
>> +	  answer Y
>> diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
>> index 2c372180d631eb340eca36f19ee2c2686de9714d..3f0f312a31c1cc200c0c91a086b30a8318e39d94 100644
>> --- a/fs/fuse/Makefile
>> +++ b/fs/fuse/Makefile
>> @@ -15,5 +15,6 @@ fuse-y += iomode.o
>>  fuse-$(CONFIG_FUSE_DAX) += dax.o
>>  fuse-$(CONFIG_FUSE_PASSTHROUGH) += passthrough.o
>>  fuse-$(CONFIG_SYSCTL) += sysctl.o
>> +fuse-$(CONFIG_FUSE_IO_URING) += dev_uring.o
>>  
>>  virtiofs-y := virtio_fs.o
>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>> new file mode 100644
>> index 0000000000000000000000000000000000000000..60e38ff1ecef3b007bae7ceedd7dd997439e463a
>> --- /dev/null
>> +++ b/fs/fuse/dev_uring.c
>> @@ -0,0 +1,326 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * FUSE: Filesystem in Userspace
>> + * Copyright (c) 2023-2024 DataDirect Networks.
>> + */
>> +
>> +#include "fuse_i.h"
>> +#include "dev_uring_i.h"
>> +#include "fuse_dev_i.h"
>> +
>> +#include <linux/fs.h>
>> +#include <linux/io_uring/cmd.h>
>> +
>> +static bool __read_mostly enable_uring;
>> +module_param(enable_uring, bool, 0644);
> 
> Allowing to change 'enable_uring' at runtime will cause troubles.  I don't
> think the code gracefully handles changes to this parameter.  Maybe it
> should be a read-only parameter.  Another option would be to be proxy it
> at the connection level, so that once enabled/disabled it will remain so
> for the lifetime of that connection.

Thank you, very good point. I'm adding a new patch that handles that, it
depends on 
[PATCH v10 16/17] fuse: block request allocation until io-uring init is complete

so added a new patch. Folding it in here would also be possible, dunno
what Miklos prefers, especially as it is already in linux-next.

> 
>> +MODULE_PARM_DESC(enable_uring,
>> +		 "Enable userspace communication through io-uring");
>> +
>> +#define FUSE_URING_IOV_SEGS 2 /* header and payload */
>> +
>> +
>> +bool fuse_uring_enabled(void)
>> +{
>> +	return enable_uring;
>> +}
>> +
>>
>> +void fuse_uring_destruct(struct fuse_conn *fc)
>> +{
>> +	struct fuse_ring *ring = fc->ring;
>> +	int qid;
>> +
>> +	if (!ring)
>> +		return;
>> +
>> +	for (qid = 0; qid < ring->nr_queues; qid++) {
>> +		struct fuse_ring_queue *queue = ring->queues[qid];
>> +
>> +		if (!queue)
>> +			continue;
>> +
>> +		WARN_ON(!list_empty(&queue->ent_avail_queue));
>> +		WARN_ON(!list_empty(&queue->ent_commit_queue));
>> +
>> +		kfree(queue);
>> +		ring->queues[qid] = NULL;
>> +	}
>> +
>> +	kfree(ring->queues);
>> +	kfree(ring);
>> +	fc->ring = NULL;
>> +}
>> +
>> +/*
>> + * Basic ring setup for this connection based on the provided configuration
>> + */
>> +static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
>> +{
>> +	struct fuse_ring *ring;
>> +	size_t nr_queues = num_possible_cpus();
>> +	struct fuse_ring *res = NULL;
>> +	size_t max_payload_size;
>> +
>> +	ring = kzalloc(sizeof(*fc->ring), GFP_KERNEL_ACCOUNT);
>> +	if (!ring)
>> +		return NULL;
>> +
>> +	ring->queues = kcalloc(nr_queues, sizeof(struct fuse_ring_queue *),
>> +			       GFP_KERNEL_ACCOUNT);
>> +	if (!ring->queues)
>> +		goto out_err;
>> +
>> +	max_payload_size = max(FUSE_MIN_READ_BUFFER, fc->max_write);
>> +	max_payload_size = max(max_payload_size, fc->max_pages * PAGE_SIZE);
>> +
>> +	spin_lock(&fc->lock);
>> +	if (fc->ring) {
>> +		/* race, another thread created the ring in the meantime */
>> +		spin_unlock(&fc->lock);
>> +		res = fc->ring;
>> +		goto out_err;
>> +	}
>> +
>> +	fc->ring = ring;
>> +	ring->nr_queues = nr_queues;
>> +	ring->fc = fc;
>> +	ring->max_payload_sz = max_payload_size;
>> +
>> +	spin_unlock(&fc->lock);
>> +	return ring;
>> +
>> +out_err:
>> +	kfree(ring->queues);
>> +	kfree(ring);
>> +	return res;
>> +}
>> +
>> +static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
>> +						       int qid)
>> +{
>> +	struct fuse_conn *fc = ring->fc;
>> +	struct fuse_ring_queue *queue;
>> +
>> +	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
>> +	if (!queue)
>> +		return NULL;
>> +	queue->qid = qid;
>> +	queue->ring = ring;
>> +	spin_lock_init(&queue->lock);
>> +
>> +	INIT_LIST_HEAD(&queue->ent_avail_queue);
>> +	INIT_LIST_HEAD(&queue->ent_commit_queue);
>> +
>> +	spin_lock(&fc->lock);
>> +	if (ring->queues[qid]) {
>> +		spin_unlock(&fc->lock);
>> +		kfree(queue);
>> +		return ring->queues[qid];
>> +	}
>> +
>> +	/*
>> +	 * write_once and lock as the caller mostly doesn't take the lock at all
>> +	 */
>> +	WRITE_ONCE(ring->queues[qid], queue);
>> +	spin_unlock(&fc->lock);
>> +
>> +	return queue;
>> +}
>> +
>> +/*
>> + * Make a ring entry available for fuse_req assignment
>> + */
>> +static void fuse_uring_ent_avail(struct fuse_ring_ent *ent,
>> +				 struct fuse_ring_queue *queue)
>> +{
>> +	WARN_ON_ONCE(!ent->cmd);
>> +	list_move(&ent->list, &queue->ent_avail_queue);
>> +	ent->state = FRRS_AVAILABLE;
>> +}
>> +
>> +/*
>> + * fuse_uring_req_fetch command handling
>> + */
>> +static void fuse_uring_do_register(struct fuse_ring_ent *ent,
>> +				   struct io_uring_cmd *cmd,
>> +				   unsigned int issue_flags)
>> +{
>> +	struct fuse_ring_queue *queue = ent->queue;
>> +
>> +	spin_lock(&queue->lock);
>> +	ent->cmd = cmd;
>> +	fuse_uring_ent_avail(ent, queue);
>> +	spin_unlock(&queue->lock);
>> +}
>> +
>> +/*
>> + * sqe->addr is a ptr to an iovec array, iov[0] has the headers, iov[1]
>> + * the payload
>> + */
>> +static int fuse_uring_get_iovec_from_sqe(const struct io_uring_sqe *sqe,
>> +					 struct iovec iov[FUSE_URING_IOV_SEGS])
>> +{
>> +	struct iovec __user *uiov = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +	struct iov_iter iter;
>> +	ssize_t ret;
>> +
>> +	if (sqe->len != FUSE_URING_IOV_SEGS)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * Direction for buffer access will actually be READ and WRITE,
>> +	 * using write for the import should include READ access as well.
>> +	 */
>> +	ret = import_iovec(WRITE, uiov, FUSE_URING_IOV_SEGS,
>> +			   FUSE_URING_IOV_SEGS, &iov, &iter);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return 0;
>> +}
>> +
>> +static struct fuse_ring_ent *
>> +fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
>> +			   struct fuse_ring_queue *queue)
>> +{
>> +	struct fuse_ring *ring = queue->ring;
>> +	struct fuse_ring_ent *ent;
>> +	size_t payload_size;
>> +	struct iovec iov[FUSE_URING_IOV_SEGS];
>> +	int err;
>> +
>> +	err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
>> +	if (err) {
>> +		pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
>> +				    err);
>> +		return ERR_PTR(err);
>> +	}
>> +
>> +	err = -EINVAL;
>> +	if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
>> +		pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
>> +		return ERR_PTR(err);
>> +	}
>> +
>> +	payload_size = iov[1].iov_len;
>> +	if (payload_size < ring->max_payload_sz) {
>> +		pr_info_ratelimited("Invalid req payload len %zu\n",
>> +				    payload_size);
>> +		return ERR_PTR(err);
>> +	}
>> +
>> +	/*
>> +	 * The created queue above does not need to be destructed in
>> +	 * case of entry errors below, will be done at ring destruction time.
>> +	 */
> 
> This comment should probably be moved down, into function
> fuse_uring_register() where this code was in earlier versions of the
> patchset.

Yeah, makes sense.

> 
>> +	err = -ENOMEM;
>> +	ent = kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
>> +	if (!ent)
>> +		return ERR_PTR(err);
>> +
>> +	INIT_LIST_HEAD(&ent->list);
>> +
>> +	ent->queue = queue;
>> +	ent->headers = iov[0].iov_base;
>> +	ent->payload = iov[1].iov_base;
>> +
>> +	return ent;
>> +}
>> +
>> +/*
>> + * Register header and payload buffer with the kernel and puts the
>> + * entry as "ready to get fuse requests" on the queue
>> + */
>> +static int fuse_uring_register(struct io_uring_cmd *cmd,
>> +			       unsigned int issue_flags, struct fuse_conn *fc)
>> +{
>> +	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
>> +	struct fuse_ring *ring = fc->ring;
>> +	struct fuse_ring_queue *queue;
>> +	struct fuse_ring_ent *ent;
>> +	int err;
>> +	unsigned int qid = READ_ONCE(cmd_req->qid);
>> +
>> +	err = -ENOMEM;
>> +	if (!ring) {
>> +		ring = fuse_uring_create(fc);
>> +		if (!ring)
>> +			return err;
>> +	}
>> +
>> +	if (qid >= ring->nr_queues) {
>> +		pr_info_ratelimited("fuse: Invalid ring qid %u\n", qid);
>> +		return -EINVAL;
>> +	}
>> +
>> +	err = -ENOMEM;
> 
> Not needed, 'err' is already set to this value.

Hmm yeah, the style to set the error before is very inviting to do that. 


Thanks for spotting and your review,
Bernd




