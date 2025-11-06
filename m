Return-Path: <io-uring+bounces-10425-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52FBDC3D464
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 20:48:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C13DA188B11A
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 19:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7683634E765;
	Thu,  6 Nov 2025 19:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="eMEEICGw";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wW8Mutun"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF361D516C;
	Thu,  6 Nov 2025 19:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762458526; cv=none; b=EbVTr/yspBbO2PNQ72z/l1spz8UOmkC0jQCWwxEZcWCTteTsJsYRxt6tugrVWmE4CD2wAIVmgWkVbBrUu3yeWSXYOeADetWiWn0/bgyhkROqiGbPtEIJDYHNYUsI9y2r2NUnvRzhkbd35EHRZako74cjYjmt5byoFv2+B6E6UUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762458526; c=relaxed/simple;
	bh=eaB7ww2qKgkwgcU8SCv1uPp3tOK++OtvYHkANRJxf0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NJteVPxDQnrSxdJKRpXWN3poWd7nKTq795sGpQd3WddPNyqs6YN9md/md76VedZYlMzIrFkiC+0BlwJ3WEGtW2EF1/mBhG7UGQ3w/E7zNH8PHplblsSBBulYUxqoQa4gPznQFF98tiT6Fwn8cZ7i9WmpqCu2OHsfHcXj3sCbfcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=eMEEICGw; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=wW8Mutun; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 252DEEC0256;
	Thu,  6 Nov 2025 14:48:42 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 06 Nov 2025 14:48:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1762458522;
	 x=1762544922; bh=hSKIW6Jx354wBGvRr/lhjsECozkk/8lvxyzAPthZuhA=; b=
	eMEEICGwIgJ6/MJejhz85KEowJKmvCG0+b3veyMKM/fdFIz6BFVQNDAuFtPiNpWI
	I86stbNIujb5tG29LxT9xIB2jVi6Ato9Z1eGbvnPKYXnL+gg8FVq6dGej6Jzyg2+
	cCrOEC8FmeseXAzbVB3pEGbDnu7QG+qbNdKVS4u5+RoAxjR3OAiTmpE3LoTPDnbV
	v0222lYv6217ExfnZAVoQx3Wg79/uL77ITGiWQigPW4Q3Ut6G6VByUqZAc0/qYAd
	RIDeHDRZXtgvnv8zIl9CvssguE8GRwn18YVnwQcE0NJqW9Q9AaZ2D4IuOGZDr+qI
	7dUFjQ1Qxdl1fNyk/kcfLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762458522; x=
	1762544922; bh=hSKIW6Jx354wBGvRr/lhjsECozkk/8lvxyzAPthZuhA=; b=w
	W8MutunKL9rg5yLk3WK7HUtLfLvC6KCAwaWw0bvVk7AGqxOXR+cNK8fOjeMHWual
	eqXxErWj7OZpB9v2eylP/aA9V1OO56TIWK4oDMw+fHw80/qYaRVu/HZrwoFaEfbw
	LuT/itqxi6DJR2GobRM+0wrxki+5durQ0OW4lS8auyORgPvmKdE1r8/CHQb+ig89
	XG7Oo42qgFvphZVbpcW5Na6kEPUZK/lV6qx3aKFjd/QUSNFD1VKTYVj5WbfLpcwd
	S9i4yR7SJFdUH2cE6iiwiva56CdcNUIstOELTsRXEKq7dZN8Lt8MlNT15sZ14xT4
	JheS8No85L3361E/uh8pQ==
X-ME-Sender: <xms:mPsMaVzcJUyNzF5nsoeRUrIQF3o1JRSTX5w7j6g-E2_Dyq3Qwdh8Gw>
    <xme:mPsMaYV8Xo3ShBs4NiTbaVloEwIOmRf_664KjhXFnzCbqmC8UWZDcwvYyddZb8_x9
    dKdZCLkaf10dE2JxOhbBJQ-4J5psyDIGrxzlhwj6DSiuy1P0g9x>
X-ME-Received: <xmr:mPsMaZ9a1JFoclnHHd-cMtWSePwBmNklfCfZ2lzu2HW_BsQ7b7dRy7vY3keUFCJaOArXM6mHvaWKQNZFR_5H2DCBUODzXyv_iJuKy90NWsiVEPt-qfbP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeejieeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeehhfejueejleehtdehteefvdfgtdelffeuudejhfehgedufedvhfehueev
    udeugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopedutddpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrd
    gtohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtthho
    pegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtoheplhhinhhugidqfhhsuggvvh
    gvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegsshgthhhusggvrhht
    seguughnrdgtohhmpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrd
    gtohhmpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepgihirghosghinhhgrdhlihesshgrmhhsuhhnghdrtghomhdprhgtph
    htthhopegtshgrnhguvghrsehpuhhrvghsthhorhgrghgvrdgtohhm
X-ME-Proxy: <xmx:mPsMaTvnaybRfZ6vOoSKMxhXNi0dHmxk-RweMYxGW_GPVzmQUbeqow>
    <xmx:mPsMaR3f1DWAGcl9vpcLFVTRqXNyysUvO0CnksZCu2xRQb3Et-axpA>
    <xmx:mPsMaQQeRcMJdojIagVx65XrWIyMO8MqVKLppy7yZmup6vuOjtp9Ag>
    <xmx:mPsMadchkOqyHUPvAfZom0YTUGb313YwR0ZgAr_GrM2tRsz06moqcg>
    <xmx:mvsMaaKhhr_8u7DlVPeI2mDJox_I7zabzA5Mr3YqXjxTgZXwmBiks8y4>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 6 Nov 2025 14:48:39 -0500 (EST)
Message-ID: <a335fd2c-03ca-4201-abcf-74809b84c426@bsbernd.com>
Date: Thu, 6 Nov 2025 20:48:38 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] fuse: support io-uring registered buffers
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu, axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, bschubert@ddn.com, asml.silence@gmail.com,
 io-uring@vger.kernel.org, xiaobing.li@samsung.com, csander@purestorage.com,
 kernel-team@meta.com
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-9-joannelkoong@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20251027222808.2332692-9-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/27/25 23:28, Joanne Koong wrote:
> Add support for io-uring registered buffers for fuse daemons
> communicating through the io-uring interface. Daemons may register
> buffers ahead of time, which will eliminate the overhead of
> pinning/unpinning user pages and translating virtual addresses for every
> server-kernel interaction.
> 
> To support page-aligned payloads, the buffer is structured such that the
> payload is at the front of the buffer and the fuse_uring_req_header is
> offset from the end of the buffer.
> 
> To be backwards compatible, fuse uring still needs to support non-registered
> buffers as well.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/dev_uring.c   | 200 +++++++++++++++++++++++++++++++++---------
>  fs/fuse/dev_uring_i.h |  27 +++++-
>  2 files changed, 183 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index c6b22b14b354..f501bc81f331 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -580,6 +580,22 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
>  	return err;
>  }
>  
> +static void *get_kernel_ring_header(struct fuse_ring_ent *ent,
> +				    enum fuse_uring_header_type type)
> +{
> +	switch (type) {
> +	case FUSE_URING_HEADER_IN_OUT:
> +		return &ent->headers->in_out;
> +	case FUSE_URING_HEADER_OP:
> +		return &ent->headers->op_in;
> +	case FUSE_URING_HEADER_RING_ENT:
> +		return &ent->headers->ring_ent_in_out;
> +	}
> +
> +	WARN_ON_ONCE(1);
> +	return NULL;
> +}
> +
>  static void __user *get_user_ring_header(struct fuse_ring_ent *ent,
>  					 enum fuse_uring_header_type type)
>  {
> @@ -600,16 +616,22 @@ static int copy_header_to_ring(struct fuse_ring_ent *ent,
>  			       enum fuse_uring_header_type type,
>  			       const void *header, size_t header_size)
>  {
> -	void __user *ring = get_user_ring_header(ent, type);
> +	if (ent->fixed_buffer) {
> +		void *ring = get_kernel_ring_header(ent, type);
>  
> -	if (!ring)
> -		return -EINVAL;
> +		if (!ring)
> +			return -EINVAL;
> +		memcpy(ring, header, header_size);
> +	} else {
> +		void __user *ring = get_user_ring_header(ent, type);
>  
> -	if (copy_to_user(ring, header, header_size)) {
> -		pr_info_ratelimited("Copying header to ring failed.\n");
> -		return -EFAULT;
> +		if (!ring)
> +			return -EINVAL;
> +		if (copy_to_user(ring, header, header_size)) {
> +			pr_info_ratelimited("Copying header to ring failed.\n");
> +			return -EFAULT;
> +		}
>  	}
> -
>  	return 0;
>  }
>  
> @@ -617,14 +639,21 @@ static int copy_header_from_ring(struct fuse_ring_ent *ent,
>  				 enum fuse_uring_header_type type,
>  				 void *header, size_t header_size)
>  {
> -	const void __user *ring = get_user_ring_header(ent, type);
> +	if (ent->fixed_buffer) {
> +		const void *ring = get_kernel_ring_header(ent, type);
>  
> -	if (!ring)
> -		return -EINVAL;
> +		if (!ring)
> +			return -EINVAL;
> +		memcpy(header, ring, header_size);
> +	} else {
> +		const void __user *ring = get_user_ring_header(ent, type);
>  
> -	if (copy_from_user(header, ring, header_size)) {
> -		pr_info_ratelimited("Copying header from ring failed.\n");
> -		return -EFAULT;
> +		if (!ring)
> +			return -EINVAL;
> +		if (copy_from_user(header, ring, header_size)) {
> +			pr_info_ratelimited("Copying header from ring failed.\n");
> +			return -EFAULT;
> +		}
>  	}
>  
>  	return 0;
> @@ -637,11 +666,15 @@ static int setup_fuse_copy_state(struct fuse_ring *ring, struct fuse_req *req,
>  {
>  	int err;
>  
> -	err = import_ubuf(rw, ent->user_payload, ring->max_payload_sz,
> -			  iter);
> -	if (err) {
> -		pr_info_ratelimited("fuse: Import of user buffer failed\n");
> -		return err;
> +	if (ent->fixed_buffer) {
> +		*iter = ent->payload_iter;
> +	} else {
> +		err = import_ubuf(rw, ent->user_payload, ring->max_payload_sz,
> +				  iter);
> +		if (err) {
> +			pr_info_ratelimited("fuse: Import of user buffer failed\n");
> +			return err;
> +		}
>  	}
>  
>  	fuse_copy_init(cs, rw == ITER_DEST, iter);
> @@ -754,6 +787,62 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
>  				   sizeof(req->in.h));
>  }
>  
> +/*
> + * Prepare fixed buffer for access. Sets up the payload iter and kmaps the
> + * header.
> + *
> + * Callers must call fuse_uring_unmap_buffer() in the same scope to release the
> + * header mapping.
> + *
> + * For non-fixed buffers, this is a no-op.
> + */
> +static int fuse_uring_map_buffer(struct fuse_ring_ent *ent)
> +{
> +	size_t header_size = sizeof(struct fuse_uring_req_header);
> +	struct iov_iter iter;
> +	struct page *header_page;
> +	size_t count, start;
> +	ssize_t copied;
> +	int err;
> +
> +	if (!ent->fixed_buffer)
> +		return 0;
> +
> +	err = io_uring_cmd_import_fixed_full(ITER_DEST, &iter, ent->cmd, 0);

This seems to be a rather expensive call, especially as it gets
called twice (during submit and fetch).
Wouldn't be there be a possibility to check if the user buffer changed
and then keep the existing iter? I think Caleb had a similar idea
in patch 1/8.

> +	if (err)
> +		return err;
> +
> +	count = iov_iter_count(&iter);
> +	if (count < header_size || count & (PAGE_SIZE - 1))
> +		return -EINVAL;

|| !PAGE_ALIGNED(count)) ?

> +
> +	/* Adjust the payload iter to protect the header from any overwrites */
> +	ent->payload_iter = iter;
> +	iov_iter_truncate(&ent->payload_iter, count - header_size);
> +
> +	/* Set up the headers */
> +	iov_iter_advance(&iter, count - header_size);
> +	copied = iov_iter_get_pages2(&iter, &header_page, header_size, 1, &start);

The iter is later used for the payload, but I miss a reset? iov_iter_revert()?

> +	if (copied < header_size)
> +		return -EFAULT;
> +	ent->headers = kmap_local_page(header_page) + start;

My plan for the alternative pinning patch (with io-uring) was to let the 
header be shared by multiple entries. Current libfuse master handles
a fixed page size buffer for the payload (prepared page pinning - I
didn't expect I was blocked for 9 months on other work), missing is to
share it between ring entries.
I think this wouldn't work with registered buffer approach - it
always needs one full page?

I would also like to discuss dynamic multiple payload sizes per queue. 
For example to have something like

256 x 4K
8 x 128K
4 x 1M

I think there are currently two ways to do that

1) Sort entries into pools
2) Sort buffers into pools and let entries use these. Here the header
would be fixed and payload would come from a pool. 

With the appraoch to have payload and header in one buffer we couldn't
use 2). Using 1) should be fine, though.

> +
> +	/*
> +	 * We can release the acquired reference on the header page immediately
> +	 * since the page is pinned and io_uring_cmd_import_fixed_full()
> +	 * prevents it from being unpinned while we are using it.
> +	 */
> +	put_page(header_page);
> +
> +	return 0;
> +}
> +
> +static void fuse_uring_unmap_buffer(struct fuse_ring_ent *ent)
> +{
> +	if (ent->fixed_buffer)
> +		kunmap_local(ent->headers);
> +}
> +
>  static int fuse_uring_prepare_send(struct fuse_ring_ent *ent,
>  				   struct fuse_req *req)
>  {
> @@ -932,6 +1021,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>  	unsigned int qid = READ_ONCE(cmd_req->qid);
>  	struct fuse_pqueue *fpq;
>  	struct fuse_req *req;
> +	bool next_req;
>  
>  	err = -ENOTCONN;
>  	if (!ring)
> @@ -982,6 +1072,13 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>  
>  	/* without the queue lock, as other locks are taken */
>  	fuse_uring_prepare_cancel(cmd, issue_flags, ent);
> +
> +	err = fuse_uring_map_buffer(ent);
> +	if (err) {
> +		fuse_uring_req_end(ent, req, err);
> +		return err;
> +	}
> +
>  	fuse_uring_commit(ent, req, issue_flags);
>  
>  	/*
> @@ -990,7 +1087,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>  	 * and fetching is done in one step vs legacy fuse, which has separated
>  	 * read (fetch request) and write (commit result).
>  	 */
> -	if (fuse_uring_get_next_fuse_req(ent, queue))
> +	next_req = fuse_uring_get_next_fuse_req(ent, queue);
> +	fuse_uring_unmap_buffer(ent);
> +	if (next_req)
>  		fuse_uring_send(ent, cmd, 0, issue_flags);
>  	return 0;
>  }
> @@ -1086,39 +1185,49 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
>  	struct iovec iov[FUSE_URING_IOV_SEGS];
>  	int err;
>  
> +	err = -ENOMEM;
> +	ent = kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
> +	if (!ent)
> +		return ERR_PTR(err);
> +
> +	INIT_LIST_HEAD(&ent->list);
> +
> +	ent->queue = queue;
> +
> +	if (READ_ONCE(cmd->sqe->uring_cmd_flags) & IORING_URING_CMD_FIXED) {
> +		ent->fixed_buffer = true;
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
>  	ent->user_headers = iov[0].iov_base;
>  	ent->user_payload = iov[1].iov_base;
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
> @@ -1249,20 +1358,29 @@ static void fuse_uring_send_in_task(struct io_uring_cmd *cmd,
>  {
>  	struct fuse_ring_ent *ent = uring_cmd_to_ring_ent(cmd);
>  	struct fuse_ring_queue *queue = ent->queue;
> +	bool send_ent = true;
>  	int err;
>  
> -	if (!(issue_flags & IO_URING_F_TASK_DEAD)) {
> -		err = fuse_uring_prepare_send(ent, ent->fuse_req);
> -		if (err) {
> -			if (!fuse_uring_get_next_fuse_req(ent, queue))
> -				return;
> -			err = 0;
> -		}
> -	} else {
> -		err = -ECANCELED;
> +	if (issue_flags & IO_URING_F_TASK_DEAD) {
> +		fuse_uring_send(ent, cmd, -ECANCELED, issue_flags);
> +		return;
> +	}
> +
> +	err = fuse_uring_map_buffer(ent);
> +	if (err) {
> +		fuse_uring_req_end(ent, ent->fuse_req, err);
> +		return;

I think this needs to abort the connection now. There could be multiple
commands on the queue and they would be stuck now and there is no
notification to fuse server either.


> +	}
> +
> +	err = fuse_uring_prepare_send(ent, ent->fuse_req);
> +	if (err) {
> +		send_ent = fuse_uring_get_next_fuse_req(ent, queue);
> +		err = 0;
>  	}
> +	fuse_uring_unmap_buffer(ent);
>  
> -	fuse_uring_send(ent, cmd, err, issue_flags);
> +	if (send_ent)
> +		fuse_uring_send(ent, cmd, err, issue_flags);
>  }
>  
>  static struct fuse_ring_queue *fuse_uring_task_to_queue(struct fuse_ring *ring)
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> index 381fd0b8156a..fe14acccd6a6 100644
> --- a/fs/fuse/dev_uring_i.h
> +++ b/fs/fuse/dev_uring_i.h
> @@ -7,6 +7,7 @@
>  #ifndef _FS_FUSE_DEV_URING_I_H
>  #define _FS_FUSE_DEV_URING_I_H
>  
> +#include <linux/uio.h>
>  #include "fuse_i.h"
>  
>  #ifdef CONFIG_FUSE_IO_URING
> @@ -38,9 +39,29 @@ enum fuse_ring_req_state {
>  
>  /** A fuse ring entry, part of the ring queue */
>  struct fuse_ring_ent {
> -	/* userspace buffer */
> -	struct fuse_uring_req_header __user *user_headers;
> -	void __user *user_payload;
> +	/*
> +	 * If true, the buffer was pre-registered by the daemon and the
> +	 * pages backing it are pinned in kernel memory. The fixed buffer layout
> +	 * is: [payload][header at end]. Use payload_iter and headers for
> +	 * copying to/from the ring.
> +	 *
> +	 * Otherwise, use user_headers and user_payload which point to userspace
> +	 * addresses representing the ring memory.
> +	 */
> +	bool fixed_buffer;
> +
> +	union {
> +		/* fixed_buffer == false */
> +		struct {
> +			struct fuse_uring_req_header __user *user_headers;
> +			void __user *user_payload;
> +		};
> +		/* fixed_buffer == true */
> +		struct {
> +			struct fuse_uring_req_header *headers;
> +			struct iov_iter payload_iter;
> +		};
> +	};
>  
>  	/* the ring queue that owns the request */
>  	struct fuse_ring_queue *queue;

Thanks,
Bernd

