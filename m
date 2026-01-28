Return-Path: <io-uring+bounces-11965-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ABLwFkaDemnx7AEAu9opvQ
	(envelope-from <io-uring+bounces-11965-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 22:44:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B19D6A92FB
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 22:44:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BFEBB3028ED1
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 21:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03A5A32571D;
	Wed, 28 Jan 2026 21:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="reU7NR21";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LhgSCiTO"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEA8233149;
	Wed, 28 Jan 2026 21:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769636647; cv=none; b=F5PEFJGswB9S6/ED4+guvIqbWljUCr1bs7b+mNPC44tvZ8GHe10x8FZAFvtz+rxsyGLNiwMpybesaL62r10HjwkZjlxJzXnSVuuoNluKPOSMqL4/EuyQFskALiPixFashMgPKxzozrd0XizXcbmld5l6xEVHMyVV9YO/Gg1yh4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769636647; c=relaxed/simple;
	bh=S4gzJY6H4RWJ9co4TpFvK31b9OvgBU4ReJmTVHeqtBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D+ejprMd/U+pPtChLH2E2KVEYN46JM930RRY36Tj37YQBq1NvXu/C4wDFBjT5bVj9OQpEuBMB1Ae9bCrxX3gTYM9Fv+JyQWxvJCu2jeiSVAu5KJfrDOST8ohZlc/JqcVvMhWHb0iAPF71GthEsq1iM+ZUncKsZUQArouUWzVIi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=reU7NR21; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LhgSCiTO; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A61CA7A0069;
	Wed, 28 Jan 2026 16:44:04 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Wed, 28 Jan 2026 16:44:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1769636644;
	 x=1769723044; bh=CXyf1/KkYT2m96Eo8gW6hrQy5FO4qvdaR85489uARVY=; b=
	reU7NR21aNI+6CxBMBaa3wQspGBzLG2Au+maxRadjomtdSo236fgrHES/RBd/jdO
	EvZWQxIf/gN+CXs/jIX2szTIgAJMNaknN0OnoI/JXHv7tQ7q7FYTgDMrRz0Q6Wuh
	Bzp2/U+sJmJoF2YXvbwQ5LQ3crE/7a5nmZ1E7eth/jMvwMjatCBEVCN947+iDYhl
	X1DG0kD1mdjVf2CcDkYSWUY9F3x49IZEDxGA7mphOspX37/gkmXfzmdJi7TxFOxO
	LR6xKw1mzwPNMmjy6vQIm5VTnC5qEEuqfPDIrob+KvchPfCsOnG8VK09vm1pmzJa
	StOGRrb8AUigvvWaXhnkYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1769636644; x=
	1769723044; bh=CXyf1/KkYT2m96Eo8gW6hrQy5FO4qvdaR85489uARVY=; b=L
	hgSCiTOCNXJZEca6xQMplnm8HfPMcyI0dpmu+m0lZHRZXash9abu87/oNoPkqIRc
	v0Kzlb4DHM7Q9ounhqC6ySOVAw3pwce6BEXIqTNq+No4JDUkiD1MVHyboPoFx0DE
	uQfv/4wVPk+mhyZPSkTCz3VT66cRSqY7im2xyyDz2kzg/vMQRLQhMcfKXS/zroS7
	HikNPQ2zRTXwzzTMf5FOyJOMCeSesYC5EcRy66RTKgJkB3v3bKpK+bSbTgt1mXW0
	jsWgCppxFS13tQqxhIi5MAQpoLmG3AmXyAaiFDOqovxWHpAfnvegCL4EEIwAWRzX
	U849Nmu73ALT5Y/73y8bA==
X-ME-Sender: <xms:I4N6aYAldmHEoX4mO0GGj1TZd4qVltdrbBmxHa-ODOak4rcFGogoJA>
    <xme:I4N6adn4c2cmuio-4elewNW2YnDpiuMxjeoxGEdjpWYYpFDife-c-8YGylC0EBhX7
    KliAJZAGSUWvjKnZJc9DZE1DvooSSdFsQaU1xiWp3XjyvD0D5J5>
X-ME-Received: <xmr:I4N6aWPCHTDJVIHpGkxdSotr3v4qz7qIOkHQLRPRpp3rfXiroUzOPI3qk164dPpsiSoT4MQYsqxd8PPu_InxF2Ow1UXG8EVI0XdtYe_1TaCwv2xxgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieeggeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeehhfejueejleehtdehteefvdfgtdelffeuudejhfehgedufedvhfehueev
    udeugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopedutddpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrd
    gtohhmpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopehm
    ihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtoheptghsrghnuggvrhesphhurh
    gvshhtohhrrghgvgdrtghomhdprhgtphhtthhopehkrhhishhmrghnsehsuhhsvgdruggv
    pdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtohep
    gihirghosghinhhgrdhlihesshgrmhhsuhhnghdrtghomhdprhgtphhtthhopehsrghfih
    hnrghskhgrrhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:I4N6aa8tlx_BT9Brrw4E6kqAjyGfnV2w1CE4YUCVqe8Ap3QqsExgqw>
    <xmx:I4N6aYEWfrmi1FFosAe-n6ydu-bJPq1ZPuCRevPVGzIENzqyPXJLmQ>
    <xmx:I4N6aZiLRaJatjgV-7uXrLw_UvCok93GkudDMB-fadqeS_2sKm2Y2w>
    <xmx:I4N6advBoZwEI7tvc7NGraPsDoZ96a_ix5NILqbNciK0ju-YjROeWA>
    <xmx:JIN6aW7DwDt1LxyBBTEHKY4UJkcNpJQOFKIp2TUZwY2-erXbwiSkxqFL>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 16:44:02 -0500 (EST)
Message-ID: <2f14fb1a-0ee2-4d86-98be-ed6112ed706d@bsbernd.com>
Date: Wed, 28 Jan 2026 22:44:01 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 19/25] fuse: add io-uring kernel-managed buffer ring
To: Joanne Koong <joannelkoong@gmail.com>, axboe@kernel.dk, miklos@szeredi.hu
Cc: csander@purestorage.com, krisman@suse.de, io-uring@vger.kernel.org,
 asml.silence@gmail.com, xiaobing.li@samsung.com, safinaskar@gmail.com,
 linux-fsdevel@vger.kernel.org
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-20-joannelkoong@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20260116233044.1532965-20-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm1,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk,szeredi.hu];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11965-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,bsbernd.com:mid,bsbernd.com:dkim]
X-Rspamd-Queue-Id: B19D6A92FB
X-Rspamd-Action: no action



On 1/17/26 00:30, Joanne Koong wrote:
> Add io-uring kernel-managed buffer ring capability for fuse daemons
> communicating through the io-uring interface.
> 
> This has two benefits:
> a) eliminates the overhead of pinning/unpinning user pages and
> translating virtual addresses for every server-kernel interaction
> 
> b) reduces the amount of memory needed for the buffers per queue and
> allows buffers to be reused across entries. Incremental buffer
> consumption, when added, will allow a buffer to be used across multiple
> requests.
> 
> Buffer ring usage is set on a per-queue basis. In order to use this, the
> daemon needs to have preregistered a kernel-managed buffer ring and a
> fixed buffer at index 0 that will hold all the headers, and set the
> "use_bufring" field during registration. The kernel-managed buffer ring
> will be pinned for the lifetime of the connection.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/dev_uring.c       | 412 ++++++++++++++++++++++++++++++++------
>  fs/fuse/dev_uring_i.h     |  31 ++-
>  include/uapi/linux/fuse.h |  15 +-
>  3 files changed, 389 insertions(+), 69 deletions(-)
> 
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index b57871f92d08..40e8c2e6b77c 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -10,6 +10,8 @@
>  #include "fuse_trace.h"
>  
>  #include <linux/fs.h>
> +#include <linux/io_uring.h>
> +#include <linux/io_uring/buf.h>
>  #include <linux/io_uring/cmd.h>
>  
>  static bool __read_mostly enable_uring;
> @@ -19,6 +21,8 @@ MODULE_PARM_DESC(enable_uring,
>  
>  #define FUSE_URING_IOV_SEGS 2 /* header and payload */
>  
> +#define FUSE_URING_RINGBUF_GROUP 0
> +#define FUSE_URING_FIXED_HEADERS_OFFSET 0
>  
>  bool fuse_uring_enabled(void)
>  {
> @@ -276,20 +280,45 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
>  	return res;
>  }
>  
> -static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
> -						       int qid)
> +static int fuse_uring_buf_ring_setup(struct io_uring_cmd *cmd,
> +				     struct fuse_ring_queue *queue,
> +				     unsigned int issue_flags)
> +{
> +	int err;
> +
> +	err = io_uring_buf_ring_pin(cmd, FUSE_URING_RINGBUF_GROUP, issue_flags,
> +				    &queue->bufring);
> +	if (err)
> +		return err;
> +
> +	if (!io_uring_is_kmbuf_ring(cmd, FUSE_URING_RINGBUF_GROUP,
> +				    issue_flags)) {
> +		io_uring_buf_ring_unpin(cmd, FUSE_URING_RINGBUF_GROUP,
> +					issue_flags);
> +		return -EINVAL;
> +	}
> +
> +	queue->use_bufring = true;
> +
> +	return 0;
> +}
> +
> +static struct fuse_ring_queue *
> +fuse_uring_create_queue(struct io_uring_cmd *cmd, struct fuse_ring *ring,
> +			int qid, bool use_bufring, unsigned int issue_flags)
>  {
>  	struct fuse_conn *fc = ring->fc;
>  	struct fuse_ring_queue *queue;
>  	struct list_head *pq;
> +	int err;
>  
>  	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
>  	if (!queue)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  	pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
>  	if (!pq) {
>  		kfree(queue);
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  	}
>  
>  	queue->qid = qid;
> @@ -307,6 +336,15 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
>  	queue->fpq.processing = pq;
>  	fuse_pqueue_init(&queue->fpq);
>  
> +	if (use_bufring) {
> +		err = fuse_uring_buf_ring_setup(cmd, queue, issue_flags);
> +		if (err) {
> +			kfree(pq);
> +			kfree(queue);
> +			return ERR_PTR(err);
> +		}
> +	}
> +
>  	spin_lock(&fc->lock);
>  	if (ring->queues[qid]) {
>  		spin_unlock(&fc->lock);
> @@ -584,6 +622,35 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
>  	return err;
>  }
>  
> +static int get_kernel_ring_header(struct fuse_ring_ent *ent,
> +				  enum fuse_uring_header_type type,
> +				  struct iov_iter *headers_iter)
> +{
> +	size_t offset;
> +
> +	switch (type) {
> +	case FUSE_URING_HEADER_IN_OUT:
> +		/* No offset - start of header */
> +		offset = 0;
> +		break;
> +	case FUSE_URING_HEADER_OP:
> +		offset = offsetof(struct fuse_uring_req_header, op_in);
> +		break;
> +	case FUSE_URING_HEADER_RING_ENT:
> +		offset = offsetof(struct fuse_uring_req_header, ring_ent_in_out);
> +		break;
> +	default:
> +		WARN_ONCE(1, "Invalid header type: %d\n", type);
> +		return -EINVAL;
> +	}
> +
> +	*headers_iter = ent->headers_iter;
> +	if (offset)
> +		iov_iter_advance(headers_iter, offset);
> +
> +	return 0;
> +}
> +
>  static void __user *get_user_ring_header(struct fuse_ring_ent *ent,
>  					 enum fuse_uring_header_type type)
>  {
> @@ -605,17 +672,38 @@ static __always_inline int copy_header_to_ring(struct fuse_ring_ent *ent,
>  					       const void *header,
>  					       size_t header_size)
>  {
> -	void __user *ring = get_user_ring_header(ent, type);
> +	bool use_bufring = ent->queue->use_bufring;
> +	int err = 0;
>  
> -	if (!ring)
> -		return -EINVAL;
> +	if (use_bufring) {
> +		struct iov_iter iter;
> +
> +		err =  get_kernel_ring_header(ent, type, &iter);
> +		if (err)
> +			goto done;
> +
> +		if (copy_to_iter(header, header_size, &iter) != header_size)
> +			err = -EFAULT;
> +	} else {
> +		void __user *ring = get_user_ring_header(ent, type);
> +
> +		if (!ring) {
> +			err = -EINVAL;
> +			goto done;
> +		}
>  
> -	if (copy_to_user(ring, header, header_size)) {
> -		pr_info_ratelimited("Copying header to ring failed.\n");
> -		return -EFAULT;
> +		if (copy_to_user(ring, header, header_size))
> +			err = -EFAULT;
>  	}
>  
> -	return 0;
> +done:
> +	if (err)
> +		pr_info_ratelimited("Copying header to ring failed: "
> +				    "header_type=%u, header_size=%zu, "
> +				    "use_bufring=%d\n", type, header_size,
> +				    use_bufring);
> +
> +	return err;
>  }
>  
>  static __always_inline int copy_header_from_ring(struct fuse_ring_ent *ent,
> @@ -623,17 +711,38 @@ static __always_inline int copy_header_from_ring(struct fuse_ring_ent *ent,
>  						 void *header,
>  						 size_t header_size)
>  {
> -	const void __user *ring = get_user_ring_header(ent, type);
> +	bool use_bufring = ent->queue->use_bufring;
> +	int err = 0;
>  
> -	if (!ring)
> -		return -EINVAL;
> +	if (use_bufring) {
> +		struct iov_iter iter;
> +
> +		err = get_kernel_ring_header(ent, type, &iter);
> +		if (err)
> +			goto done;
> +
> +		if (copy_from_iter(header, header_size, &iter) != header_size)
> +			err = -EFAULT;
> +	} else {
> +		const void __user *ring = get_user_ring_header(ent, type);
>  
> -	if (copy_from_user(header, ring, header_size)) {
> -		pr_info_ratelimited("Copying header from ring failed.\n");
> -		return -EFAULT;
> +		if (!ring) {
> +			err = -EINVAL;
> +			goto done;
> +		}
> +
> +		if (copy_from_user(header, ring, header_size))
> +			err = -EFAULT;
>  	}
>  
> -	return 0;
> +done:
> +	if (err)
> +		pr_info_ratelimited("Copying header from ring failed: "
> +				    "header_type=%u, header_size=%zu, "
> +				    "use_bufring=%d\n", type, header_size,
> +				    use_bufring);
> +
> +	return err;
>  }
>  
>  static int setup_fuse_copy_state(struct fuse_copy_state *cs,
> @@ -643,14 +752,23 @@ static int setup_fuse_copy_state(struct fuse_copy_state *cs,
>  {
>  	int err;
>  
> -	err = import_ubuf(dir, ent->payload, ring->max_payload_sz, iter);
> -	if (err) {
> -		pr_info_ratelimited("fuse: Import of user buffer failed\n");
> -		return err;
> +	if (!ent->queue->use_bufring) {
> +		err = import_ubuf(dir, ent->payload, ring->max_payload_sz, iter);
> +		if (err) {
> +			pr_info_ratelimited("fuse: Import of user buffer "
> +					    "failed\n");
> +			return err;
> +		}
>  	}
>  
>  	fuse_copy_init(cs, dir == ITER_DEST, iter);
>  
> +	if (ent->queue->use_bufring) {
> +		cs->is_kaddr = true;
> +		cs->len = ent->payload_kvec.iov_len;
> +		cs->kaddr = ent->payload_kvec.iov_base;
> +	}
> +
>  	cs->is_uring = true;
>  	cs->req = req;
>  
> @@ -762,6 +880,94 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
>  				   sizeof(req->in.h));
>  }
>  
> +static bool fuse_uring_req_has_payload(struct fuse_req *req)
> +{
> +	struct fuse_args *args = req->args;
> +
> +	return args->in_numargs > 1 || args->out_numargs;
> +}
> +
> +static int fuse_uring_select_buffer(struct fuse_ring_ent *ent,
> +				    unsigned int issue_flags)
> +	__must_hold(&queue->lock)
> +{
> +	struct io_br_sel sel;
> +	size_t len = 0;
> +
> +	lockdep_assert_held(&ent->queue->lock);
> +
> +	/* Get a buffer to use for the payload */
> +	sel = io_ring_buffer_select(cmd_to_io_kiocb(ent->cmd), &len,
> +				    ent->queue->bufring, issue_flags);
> +	if (sel.val)
> +		return sel.val;
> +	if (!sel.kaddr)
> +		return -ENOENT;
> +
> +	ent->payload_kvec.iov_base = sel.kaddr;
> +	ent->payload_kvec.iov_len = len;
> +	ent->ringbuf_buf_id = sel.buf_id;
> +
> +	return 0;
> +}
> +
> +static void fuse_uring_clean_up_buffer(struct fuse_ring_ent *ent,
> +				       unsigned int issue_flags)
> +	__must_hold(&queue->lock)
> +{
> +	struct kvec *kvec = &ent->payload_kvec;
> +
> +	lockdep_assert_held(&ent->queue->lock);
> +
> +	if (!ent->queue->use_bufring || !kvec->iov_base)
> +		return;
> +
> +	WARN_ON_ONCE(io_uring_kmbuf_recycle(ent->cmd, FUSE_URING_RINGBUF_GROUP,
> +					    (u64)kvec->iov_base, kvec->iov_len,
> +					    ent->ringbuf_buf_id, issue_flags));
> +
> +	memset(kvec, 0, sizeof(*kvec));
> +}
> +
> +static int fuse_uring_next_req_update_buffer(struct fuse_ring_ent *ent,
> +					     struct fuse_req *req,
> +					     unsigned int issue_flags)
> +{
> +	bool buffer_selected;
> +	bool has_payload;
> +
> +	if (!ent->queue->use_bufring)
> +		return 0;
> +
> +	ent->headers_iter.data_source = false;
> +
> +	buffer_selected = ent->payload_kvec.iov_base != NULL;
> +	has_payload = fuse_uring_req_has_payload(req);
> +
> +	if (has_payload && !buffer_selected)
> +		return fuse_uring_select_buffer(ent, issue_flags);
> +
> +	if (!has_payload && buffer_selected)
> +		fuse_uring_clean_up_buffer(ent, issue_flags);
> +
> +	return 0;
> +}
> +
> +static int fuse_uring_prep_buffer(struct fuse_ring_ent *ent,
> +				  struct fuse_req *req, unsigned issue_flags)
> +{
> +	if (!ent->queue->use_bufring)
> +		return 0;
> +
> +	ent->headers_iter.data_source = false;
> +
> +	/* no payload to copy, can skip selecting a buffer */
> +	if (!fuse_uring_req_has_payload(req))
> +		return 0;
> +
> +	return fuse_uring_select_buffer(ent, issue_flags);
> +}
> +
>  static int fuse_uring_prepare_send(struct fuse_ring_ent *ent,
>  				   struct fuse_req *req)
>  {
> @@ -824,21 +1030,29 @@ static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ent,
>  }
>  
>  /* Fetch the next fuse request if available */
> -static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_ent *ent)
> +static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_ent *ent,
> +						  unsigned int issue_flags)
>  	__must_hold(&queue->lock)
>  {
>  	struct fuse_req *req;
>  	struct fuse_ring_queue *queue = ent->queue;
>  	struct list_head *req_queue = &queue->fuse_req_queue;
> +	int err;
>  
>  	lockdep_assert_held(&queue->lock);
>  
>  	/* get and assign the next entry while it is still holding the lock */
>  	req = list_first_entry_or_null(req_queue, struct fuse_req, list);
> -	if (req)
> -		fuse_uring_add_req_to_ring_ent(ent, req);
> +	if (req) {
> +		err = fuse_uring_next_req_update_buffer(ent, req, issue_flags);
> +		if (!err) {
> +			fuse_uring_add_req_to_ring_ent(ent, req);
> +			return req;
> +		}
> +	}
>  
> -	return req;
> +	fuse_uring_clean_up_buffer(ent, issue_flags);
> +	return NULL;
>  }
>  
>  /*
> @@ -878,7 +1092,8 @@ static void fuse_uring_commit(struct fuse_ring_ent *ent, struct fuse_req *req,
>   * Else, there is no next fuse request and this returns false.
>   */
>  static bool fuse_uring_get_next_fuse_req(struct fuse_ring_ent *ent,
> -					 struct fuse_ring_queue *queue)
> +					 struct fuse_ring_queue *queue,
> +					 unsigned int issue_flags)
>  {
>  	int err;
>  	struct fuse_req *req;
> @@ -886,7 +1101,7 @@ static bool fuse_uring_get_next_fuse_req(struct fuse_ring_ent *ent,
>  retry:
>  	spin_lock(&queue->lock);
>  	fuse_uring_ent_avail(ent, queue);
> -	req = fuse_uring_ent_assign_req(ent);
> +	req = fuse_uring_ent_assign_req(ent, issue_flags);
>  	spin_unlock(&queue->lock);
>  
>  	if (req) {
> @@ -927,6 +1142,39 @@ static void fuse_uring_send(struct fuse_ring_ent *ent, struct io_uring_cmd *cmd,
>  	io_uring_cmd_done(cmd, ret, issue_flags);
>  }
>  
> +static void fuse_uring_headers_cleanup(struct fuse_ring_ent *ent,
> +				       unsigned int issue_flags)
> +{
> +	if (!ent->queue->use_bufring || !ent->headers_node)
> +		return;
> +
> +	io_uring_fixed_index_put(ent->cmd, ent->headers_node, issue_flags);
> +	ent->headers_node = NULL;
> +}
> +
> +static int fuse_uring_headers_prep(struct fuse_ring_ent *ent, unsigned int dir,
> +				   unsigned int issue_flags)
> +{
> +	size_t header_size = sizeof(struct fuse_uring_req_header);
> +	struct io_uring_cmd *cmd = ent->cmd;
> +	struct io_rsrc_node *node;
> +	unsigned int offset;
> +
> +	if (!ent->queue->use_bufring)
> +		return 0;
> +
> +	offset = ent->fixed_buf_id * header_size;
> +
> +	node = io_uring_fixed_index_get(cmd, FUSE_URING_FIXED_HEADERS_OFFSET,
> +					offset, header_size, dir,
> +					&ent->headers_iter, issue_flags);
> +	if (IS_ERR(node))
> +		return PTR_ERR(node);
> +
> +	ent->headers_node = node;
> +	return 0;
> +}
> +
>  /* FUSE_URING_CMD_COMMIT_AND_FETCH handler */
>  static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>  				   struct fuse_conn *fc)
> @@ -940,6 +1188,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>  	unsigned int qid = READ_ONCE(cmd_req->qid);
>  	struct fuse_pqueue *fpq;
>  	struct fuse_req *req;
> +	bool send;
>  
>  	err = -ENOTCONN;
>  	if (!ring)
> @@ -990,7 +1239,12 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>  
>  	/* without the queue lock, as other locks are taken */
>  	fuse_uring_prepare_cancel(cmd, issue_flags, ent);
> -	fuse_uring_commit(ent, req, issue_flags);
> +
> +	err = fuse_uring_headers_prep(ent, ITER_SOURCE, issue_flags);
> +	if (err)
> +		fuse_uring_req_end(ent, req, err);
> +	else
> +		fuse_uring_commit(ent, req, issue_flags);
>  
>  	/*
>  	 * Fetching the next request is absolutely required as queued
> @@ -998,7 +1252,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>  	 * and fetching is done in one step vs legacy fuse, which has separated
>  	 * read (fetch request) and write (commit result).
>  	 */
> -	if (fuse_uring_get_next_fuse_req(ent, queue))
> +	send = fuse_uring_get_next_fuse_req(ent, queue, issue_flags);
> +	fuse_uring_headers_cleanup(ent, issue_flags);
> +	if (send)
>  		fuse_uring_send(ent, cmd, 0, issue_flags);
>  	return 0;
>  }
> @@ -1094,39 +1350,48 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
>  	struct iovec iov[FUSE_URING_IOV_SEGS];
>  	int err;
>  
> +	ent = kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
> +	if (!ent)
> +		return ERR_PTR(-ENOMEM);
> +
> +	INIT_LIST_HEAD(&ent->list);
> +
> +	ent->queue = queue;
> +
> +	if (queue->use_bufring) {
> +		ent->fixed_buf_id = READ_ONCE(cmd->sqe->buf_index);
> +		atomic_inc(&ring->queue_refs);
> +		return ent;
> +	}
> +
>  	err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
>  	if (err) {
>  		pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
>  				    err);
> -		return ERR_PTR(err);
> +		goto error;
>  	}
>  
>  	err = -EINVAL;
>  	if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
>  		pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
> -		return ERR_PTR(err);
> +		goto error;
>  	}
>  
>  	payload_size = iov[1].iov_len;
>  	if (payload_size < ring->max_payload_sz) {
>  		pr_info_ratelimited("Invalid req payload len %zu\n",
>  				    payload_size);
> -		return ERR_PTR(err);
> +		goto error;
>  	}
> -
> -	err = -ENOMEM;
> -	ent = kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
> -	if (!ent)
> -		return ERR_PTR(err);
> -
> -	INIT_LIST_HEAD(&ent->list);
> -
> -	ent->queue = queue;
>  	ent->headers = iov[0].iov_base;
>  	ent->payload = iov[1].iov_base;
>  
>  	atomic_inc(&ring->queue_refs);
>  	return ent;
> +
> +error:
> +	kfree(ent);
> +	return ERR_PTR(err);
>  }
>  
>  /*
> @@ -1137,6 +1402,8 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
>  			       unsigned int issue_flags, struct fuse_conn *fc)
>  {
>  	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
> +	unsigned int init_flags = READ_ONCE(cmd_req->init.flags);
> +	bool use_bufring = init_flags & FUSE_URING_BUF_RING;
>  	struct fuse_ring *ring = smp_load_acquire(&fc->ring);
>  	struct fuse_ring_queue *queue;
>  	struct fuse_ring_ent *ent;
> @@ -1157,9 +1424,13 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
>  
>  	queue = ring->queues[qid];
>  	if (!queue) {
> -		queue = fuse_uring_create_queue(ring, qid);
> -		if (!queue)
> -			return err;
> +		queue = fuse_uring_create_queue(cmd, ring, qid, use_bufring,
> +						issue_flags);
> +		if (IS_ERR(queue))
> +			return PTR_ERR(queue);
> +	} else {
> +		if (queue->use_bufring != use_bufring)
> +			return -EINVAL;
>  	}
>  
>  	/*
> @@ -1258,15 +1529,19 @@ static void fuse_uring_send_in_task(struct io_tw_req tw_req, io_tw_token_t tw)
>  	struct io_uring_cmd *cmd = io_uring_cmd_from_tw(tw_req);
>  	struct fuse_ring_ent *ent = uring_cmd_to_ring_ent(cmd);
>  	struct fuse_ring_queue *queue = ent->queue;
> +	bool send = true;
>  	int err;
>  
>  	if (!tw.cancel) {
> -		err = fuse_uring_prepare_send(ent, ent->fuse_req);
> -		if (err) {
> -			if (!fuse_uring_get_next_fuse_req(ent, queue))
> -				return;
> -			err = 0;
> -		}
> +		if (fuse_uring_headers_prep(ent, ITER_DEST, issue_flags))
> +			return;
> +
> +		if (fuse_uring_prepare_send(ent, ent->fuse_req))
> +			send = fuse_uring_get_next_fuse_req(ent, queue, issue_flags);
> +		fuse_uring_headers_cleanup(ent, issue_flags);
> +		if (!send)
> +			return;
> +		err = 0;
>  	} else {
>  		err = -ECANCELED;
>  	}
> @@ -1325,14 +1600,19 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
>  	req->ring_queue = queue;
>  	ent = list_first_entry_or_null(&queue->ent_avail_queue,
>  				       struct fuse_ring_ent, list);
> -	if (ent)
> -		fuse_uring_add_req_to_ring_ent(ent, req);
> -	else
> -		list_add_tail(&req->list, &queue->fuse_req_queue);
> -	spin_unlock(&queue->lock);
> +	if (ent) {
> +		err = fuse_uring_prep_buffer(ent, req, IO_URING_F_UNLOCKED);
> +		if (!err) {
> +			fuse_uring_add_req_to_ring_ent(ent, req);
> +			spin_unlock(&queue->lock);
> +			fuse_uring_dispatch_ent(ent);
> +			return;
> +		}
> +		WARN_ON_ONCE(err != -ENOENT);
> +	}
>  
> -	if (ent)
> -		fuse_uring_dispatch_ent(ent);
> +	list_add_tail(&req->list, &queue->fuse_req_queue);
> +	spin_unlock(&queue->lock);
>  
>  	return;
>  
> @@ -1350,6 +1630,7 @@ bool fuse_uring_queue_bq_req(struct fuse_req *req)
>  	struct fuse_ring *ring = fc->ring;
>  	struct fuse_ring_queue *queue;
>  	struct fuse_ring_ent *ent = NULL;
> +	int err;
>  
>  	queue = fuse_uring_task_to_queue(ring);
>  	if (!queue)
> @@ -1382,14 +1663,15 @@ bool fuse_uring_queue_bq_req(struct fuse_req *req)
>  	req = list_first_entry_or_null(&queue->fuse_req_queue, struct fuse_req,
>  				       list);
>  	if (ent && req) {
> -		fuse_uring_add_req_to_ring_ent(ent, req);
> -		spin_unlock(&queue->lock);
> -
> -		fuse_uring_dispatch_ent(ent);
> -	} else {
> -		spin_unlock(&queue->lock);
> +		err = fuse_uring_prep_buffer(ent, req, IO_URING_F_UNLOCKED);
> +		if (!err) {
> +			fuse_uring_add_req_to_ring_ent(ent, req);
> +			spin_unlock(&queue->lock);
> +			fuse_uring_dispatch_ent(ent);
> +			return true;
> +		}
>  	}
> -
> +	spin_unlock(&queue->lock);
>  	return true;
>  }
>  
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> index 51a563922ce1..ac6da80c3d70 100644
> --- a/fs/fuse/dev_uring_i.h
> +++ b/fs/fuse/dev_uring_i.h
> @@ -7,6 +7,8 @@
>  #ifndef _FS_FUSE_DEV_URING_I_H
>  #define _FS_FUSE_DEV_URING_I_H
>  
> +#include <linux/uio.h>
> +
>  #include "fuse_i.h"
>  
>  #ifdef CONFIG_FUSE_IO_URING
> @@ -38,9 +40,26 @@ enum fuse_ring_req_state {
>  
>  /** A fuse ring entry, part of the ring queue */
>  struct fuse_ring_ent {
> -	/* userspace buffer */
> -	struct fuse_uring_req_header __user *headers;
> -	void __user *payload;
> +	union {
> +		/* queue->use_bufring == false */
> +		struct {
> +			/* userspace buffers */
> +			struct fuse_uring_req_header __user *headers;
> +			void __user *payload;
> +		};
> +		/* queue->use_bufring == true */
> +		struct {
> +			struct iov_iter headers_iter;
> +			struct io_rsrc_node *headers_node;
> +			struct kvec payload_kvec;
> +			/*
> +			 * This needs to be tracked in order to properly recycle
> +			 * the buffer when done with it
> +			 */
> +			unsigned int ringbuf_buf_id;
> +			unsigned int fixed_buf_id;
> +		};
> +	};
>  
>  	/* the ring queue that owns the request */
>  	struct fuse_ring_queue *queue;
> @@ -99,6 +118,12 @@ struct fuse_ring_queue {
>  	unsigned int active_background;
>  
>  	bool stopped;
> +
> +	/* true if kernel-managed buffer ring is used */
> +	bool use_bufring: 1;
> +
> +	/* synchronized by the queue lock */
> +	struct io_buffer_list *bufring;
>  };
>  
>  /**
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index c13e1f9a2f12..b49c8d3b9ab6 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -240,6 +240,9 @@
>   *  - add FUSE_COPY_FILE_RANGE_64
>   *  - add struct fuse_copy_file_range_out
>   *  - add FUSE_NOTIFY_PRUNE
> + *
> + *  7.46
> + *  - add fuse_uring_cmd_req init flags
>   */
>  
>  #ifndef _LINUX_FUSE_H
> @@ -1294,6 +1297,9 @@ enum fuse_uring_cmd {
>  	FUSE_IO_URING_CMD_COMMIT_AND_FETCH = 2,
>  };
>  
> +/* fuse_uring_cmd_req init flags */
> +#define FUSE_URING_BUF_RING	(1 << 0)
> +
>  /**
>   * In the 80B command area of the SQE.
>   */
> @@ -1305,7 +1311,14 @@ struct fuse_uring_cmd_req {
>  
>  	/* queue the command is for (queue index) */
>  	uint16_t qid;
> -	uint8_t padding[6];
> +
> +	union {
> +		struct {
> +			uint16_t flags;
> +		} init;
> +	};
> +

I won't manage to review everything of this patch today, but just
noticed this. There is already an unused flags, why don't you use that?
I had edded it exactly for such things.

> +	uint8_t padding[4];
>  };
>  
>  #endif /* _LINUX_FUSE_H */

Thanks,
Bernd

