Return-Path: <io-uring+bounces-12044-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +EHPCpeLgmmqWAMAu9opvQ
	(envelope-from <io-uring+bounces-12044-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 00:58:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF72DFDEC
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 00:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1A1FD30BAB8F
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 23:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42AAA35CB9C;
	Tue,  3 Feb 2026 23:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="lKL4fu8V";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="f/y+4irO"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5FA34E74B;
	Tue,  3 Feb 2026 23:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770163090; cv=none; b=nh8KJi0bKpeHOlNo8tuUDCU5gh3Q/gVcrpMYujwf+fTtG8cPUVubhd2tf4XZjPbBC1U/LafksHtSwssfLDqx/7d8w+/S6U521kGJCrJaoKJNAkbJ/atD3HGvkleEgDEiUtzpjScA5xmk0ui6AsyRR+uT4AAUrFaQ8RJJNWDQVKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770163090; c=relaxed/simple;
	bh=spEt2VovXRGtxvJ1POP+FxX6OF1vR/YhDMP0+zn8EGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LaFtfcsAAmo/UgNVOuAuZ2LlfVLoXkjW4njZE8bV2dzm88WgnHBgn+yuPaFkO8EpJngAA5U+XPvcSut3EsxAjT+l6tIJV6bpy50s7LgxHWAaE3Ebxz6/QC+3aZDbv1/iFZWlCZPibqtQonhDoM2Qml4oSVRPeWDtqpAk4EMiEjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=lKL4fu8V; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=f/y+4irO; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 83CF71D00029;
	Tue,  3 Feb 2026 18:58:06 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 03 Feb 2026 18:58:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1770163086;
	 x=1770249486; bh=Ka3JWjcCY0f/YWYqKd3Yxa7YVmgj9gA/QdTny1c8yJQ=; b=
	lKL4fu8VJyfBWQOQq/HSm8LQvtpj5GZXoXSCkuUbUY8ATYi5OSN/JSThKRQGyuhB
	9/WO9ZXfFpQ1ftY3C+RaeaC7KsGiMWVIT5QKIp4T/QnnZ/n7PYeBjGcQzMXjCBp6
	C2YOzkjOQEIENVmbOmj76n4i+PLSxi9xFbsXYsNeo7xBNxjeTOEYOOpRf26zISX4
	SJbpW2zDuVbZLo9KkfXo3kmjxekUnC2lvLbZqgZV4K1mSSTBRe3DgAkca96/b1Gz
	uo3t8UbpnL7D29G20UKNNLw7/HsfvQORoFaMWbxVjC+q6vgwTut2JH/6OuXql9ks
	1V/UvgzbrDwTZmdg4MDQOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770163086; x=
	1770249486; bh=Ka3JWjcCY0f/YWYqKd3Yxa7YVmgj9gA/QdTny1c8yJQ=; b=f
	/y+4irOfDU50gUuQZXJ0JOKZaGyvxmdWZfm/7iD4l8J4JCN7mplak69jyqVtY6yy
	fx7k4hUHFIlv3tH1Aro6yvPv7joOJeaxoOADFjsz5HVJl/JQ2V9JnWfeAaHwIUz/
	spG4pu97QBlOEJyeIgc6Vy4bdm37rO+lvYgviDWI89skbXEnloC2mt2XKJqlwnmc
	bxc1m71Tc75URKXRTFC1TpLq7cslwuv1bNYY47GHkqmix1FaJlSXR6cVwfY3aoEu
	FGx01ahZBdKxjzZjfJshy3R/i4OX8Im9SB8ot4oG4QOw1x7w2L+PbS8JvaEfoiNu
	wUCDEIQ8wEKVnOSNwSb1w==
X-ME-Sender: <xms:jYuCabNebmpikSh3wbbodzuCn9lt9rfrUvqnBtfnCGxoDgcW1X-ipQ>
    <xme:jYuCaa7Zow6KLdqdUPH9DNH31w0dY_mdMrZP6oVm5V0q-q2-n3qoqBspSsMkya3Ek
    ZZjOAnGtnK8ACj5U-ST8pZcw292Dk82YAbGaTEm6_VI5v8Ib6Iz>
X-ME-Received: <xmr:jYuCaegyPoNGg_GgMJ26OlCkPlhH1eYGb2spDgNuh1l2QSwfFMnldmS73dsIQ89YE3VjiT7hx7QRnFyvOu-kVWGXw5hAht57PFAgB0fV4gWaubRSHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukedugedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeehhfejueejleehtdehteefvdfgtdelffeuudejhfehgedufedvhfehueev
    udeugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopeelpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtg
    homhdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtohep
    rgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopegsshgthhhusggvrhhtseguug
    hnrdgtohhmpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhm
    pdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheptghsrghnuggvrhesphhurhgvshhtohhrrghgvgdrtghomhdprhgtphhtthho
    peigihgrohgsihhnghdrlhhisehsrghmshhunhhgrdgtohhmpdhrtghpthhtoheplhhinh
    hugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:jYuCaffSufJdhURWzwOxS5St7DveuPeTyEFTxZpUt89VKFKAfdfvPg>
    <xmx:jYuCaWy5Y8OFehbCVZfEWYZRSkSrQ9mnybgGXbPNnwlDRfJ117B3fw>
    <xmx:jYuCae3haNmURV2fYXDvoNavQQufRynfFcTsgt_tG9qre9z4KK90tA>
    <xmx:jYuCacxYxQxCGqDoDPVNuKF8HOsRExz4t5-yIVMgu3sBc2o6HCjLbQ>
    <xmx:jouCaXz0D4H57pKjZU52GBsR_KG-aLJqSxEQp-jlcDUwTY5icts9cVk5>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Feb 2026 18:58:04 -0500 (EST)
Message-ID: <4e406b1f-723b-4dc7-8e50-1a5ef6ea11b3@bsbernd.com>
Date: Wed, 4 Feb 2026 00:58:03 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/25] fuse: add io-uring kernel-managed buffer ring
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu, axboe@kernel.dk
Cc: bschubert@ddn.com, asml.silence@gmail.com, io-uring@vger.kernel.org,
 csander@purestorage.com, xiaobing.li@samsung.com,
 linux-fsdevel@vger.kernel.org
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-20-joannelkoong@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20251223003522.3055912-20-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm1,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[ddn.com,gmail.com,vger.kernel.org,purestorage.com,samsung.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com,szeredi.hu,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12044-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4BF72DFDEC
X-Rspamd-Action: no action



On 12/23/25 01:35, Joanne Koong wrote:
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
>  fs/fuse/dev_uring.c       | 423 ++++++++++++++++++++++++++++++++------
>  fs/fuse/dev_uring_i.h     |  30 ++-
>  include/uapi/linux/fuse.h |  15 +-
>  3 files changed, 399 insertions(+), 69 deletions(-)
> 
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index b57871f92d08..e9905f09c3ad 100644
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
> @@ -276,20 +280,46 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
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
> +	err = io_uring_cmd_buf_ring_pin(cmd, FUSE_URING_RINGBUF_GROUP,
> +					issue_flags, &queue->bufring);
> +	if (err)
> +		return err;
> +
> +	if (!io_uring_cmd_is_kmbuf_ring(cmd, FUSE_URING_RINGBUF_GROUP,
> +					issue_flags)) {
> +		io_uring_cmd_buf_ring_unpin(cmd,
> +					    FUSE_URING_RINGBUF_GROUP,
> +					    issue_flags);
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
> @@ -307,6 +337,15 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
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
> @@ -584,6 +623,35 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
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
> @@ -605,17 +673,38 @@ static __always_inline int copy_header_to_ring(struct fuse_ring_ent *ent,
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
> @@ -623,17 +712,38 @@ static __always_inline int copy_header_from_ring(struct fuse_ring_ent *ent,
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
> +		err =  get_kernel_ring_header(ent, type, &iter);
> +		if (err)
> +			goto done;
> +
> +		if (copy_from_iter(header, header_size, &iter) != header_size)
> +			err = -EFAULT;
> +	} else {
> +		const void __user *ring = get_user_ring_header(ent, type);
> +
> +		if (!ring) {
> +			err = -EINVAL;
> +			goto done;
> +		}
>  
> -	if (copy_from_user(header, ring, header_size)) {
> -		pr_info_ratelimited("Copying header from ring failed.\n");
> -		return -EFAULT;
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
> @@ -643,14 +753,23 @@ static int setup_fuse_copy_state(struct fuse_copy_state *cs,
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
> @@ -762,6 +881,103 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
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
> +	WARN_ON_ONCE(io_uring_cmd_kmbuffer_recycle(ent->cmd,
> +						   FUSE_URING_RINGBUF_GROUP,
> +						   (u64)kvec->iov_base,
> +						   kvec->iov_len,
> +						   ent->ringbuf_buf_id,
> +						   issue_flags));
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
> +	buffer_selected = ent->payload_kvec.iov_base != 0;
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
> +				  struct fuse_req *req, unsigned int dir,
> +				  unsigned issue_flags)
> +{
> +	if (!ent->queue->use_bufring)
> +		return 0;
> +
> +	if (dir == ITER_SOURCE) {
> +		ent->headers_iter.data_source = true;
> +		return 0;
> +	}
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
> @@ -824,21 +1040,29 @@ static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ent,
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

Hmm, who/what is going to handle the request if this fails? Let's say we
have just one ring entry per queue and now it fails here - this ring
entry will go into FRRS_AVAILABLE and nothing will pull from the queue
anymore. I guess it _should_ not happen, some protection would be good.
In order to handle it, at least one other ent needs to be in flight.

Thanks,
Bernd

