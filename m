Return-Path: <io-uring+bounces-10404-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88CD6C3B551
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 14:43:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 548A01A42212
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 13:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70AA2D6E53;
	Thu,  6 Nov 2025 13:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="Dc9W/0qp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="lPKLOs5t"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1C833CEA3;
	Thu,  6 Nov 2025 13:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762436171; cv=none; b=j6UpkOQWGp0cm6ERhrWNWoUzLZxGxMtVZyrS1RuHJ+RHEqhyT2mQPH+kRwW2PLEbo1uKLW1CpQsuER4UNyJ2LgxhhfRPSlVi+Pn8rnj2zoz/VE5OUAgVCUuECLrySij+IcUh6JaFiYmyl6m5Uubs7OSPlIsDD5zBAqEh7q2nNZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762436171; c=relaxed/simple;
	bh=TGnuswuX1qFy4EIvdysH+G2sliMJ1me6qdRXsMPTL1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WaJ2If4EcPWHQbFiVlpc0hHcZBfFeyLdlQNNlWrfO4H1yhKxi9258BWnVQZufVW8iYTrQLWCsmXA8z8QJaZqpnUYm0kCkv/UwqMJIhrgLU0bPVmwLvT/D64L2IhT4hD8Ez9AeMIS7mqWVPbpNGixkLFnunsTRN/E72uYgW15W/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=Dc9W/0qp; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=lPKLOs5t; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 075E5EC044B;
	Thu,  6 Nov 2025 08:35:46 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 06 Nov 2025 08:35:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1762436146;
	 x=1762522546; bh=fhgW2n6LPDjnPj2ytaQC56zi51DsWXbj6fvM73wiMg0=; b=
	Dc9W/0qpI6hVZo9MHkwfY+23bxwl2oSykQ6vMN8TYmLElrXVZEEn3khQ+LnAEe+O
	K/ZGruqmYq2UN4wS1tFItK89LukEtygTjd2eiMk/nINweMslrYgQa/ZAR28GubSz
	FhYKp6OTQ/imoGqqz6P7PgHvbbqXn44r5Yt7m1hZUZV+FrdkG/uxggjvFNcrXMNB
	LNt8WY+V3FOJPLBZ9CYM05XvL4RHn3sJP0VUMIrF5BXXpUgo3RFM8BAu7seLsENS
	Cj6RGJog0K7KnAzHF/60YJdSPFd3tKIM8vamMy6Av8PfGaR4/9B8wVP9aga3fFCF
	lQ991W5tggrBFnqN41uFgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762436146; x=
	1762522546; bh=fhgW2n6LPDjnPj2ytaQC56zi51DsWXbj6fvM73wiMg0=; b=l
	PKLOs5t1iIdHgEK9HP/nRUSlaEd5EDAlzRMJGNlfHkSE7MwetQwTgQPML/xfN6eM
	evYyRuEdnq72N05qf0mB3ZAEUwX3K0InVE2VT2q+bWj2qJKUpBuHyl/+U+r5D5m3
	C7K2KAlEFjbYgCx2PN4BrJ99PafqZ6qmrTCzjIM2nUQfNryLAchftTQPwmmNAz1k
	OrPoHjYFm67oY97j/z1lIr9A0yAyYZUCOBYD0zKAd6BnZjUhMD6xEj4+Sn5DWaDe
	8Xh8Jvqde/p29QPBg1BN/v3XpI0E416uG+RAwXn74Tq4DZrFpP9jvjA9IBK61o4/
	dpHB7ZZzgAfX4w3mNrtFA==
X-ME-Sender: <xms:MaQMaR-kxbEiPVFHrZkjDuT0bUWBo7Vp-DI33UJ8Ddpn0TmFA1QDGQ>
    <xme:MaQMaYy8o6EC5w8nYNIYVAuG7m3c4xdAZALcUuF5jOp8OAkcCXYD_GacHdcwyuaO2
    dq9hmYLhQESvEAF5eMkejnMFDH5-aYku5xBsOy3oVkZ-8V3Jas>
X-ME-Received: <xmr:MaQMaZrnSoNxLkbSlkCuDQoQ0pmhQGSLy_5ARzTCp_6Ge3pcTP53AbGKkkwjTkm95xF6UaQS3UIxjOdTKK3tlHs4z-r-wln0CWfWUzRBzXGKWjlBJsD7>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeeiledvucetufdoteggodetrf
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
X-ME-Proxy: <xmx:MaQMaRpw8xmEopzMC_aq-sODsCObRnKjFg1FihMZk8qPsaavAEGuJQ>
    <xmx:MaQMaRCAFjuz240k7d6OfHSR6ywTyfUhunLaEN1Y58clFPDD0ws52g>
    <xmx:MaQMaXv31BC0nTbZmBHsE-P4p0-_yZUAMtW301-PMgOnAzel1DCBpw>
    <xmx:MaQMaYKj5NnPY4CUNEQBkFp4Kn2e1MskcJ7kBtjypWudWgmBO4A34Q>
    <xmx:MaQMaT0PzXNhqd6phNf0Tq4s9lwJBn0_b0gpvaaCEd1eSqHh5AYI2Ba7>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 6 Nov 2025 08:35:43 -0500 (EST)
Message-ID: <6255493e-f1eb-4f17-a312-7adb6c62cc8a@bsbernd.com>
Date: Thu, 6 Nov 2025 14:35:42 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/8] fuse: add user_ prefix to userspace headers and
 payload fields
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu, axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, bschubert@ddn.com, asml.silence@gmail.com,
 io-uring@vger.kernel.org, xiaobing.li@samsung.com, csander@purestorage.com,
 kernel-team@meta.com
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-7-joannelkoong@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20251027222808.2332692-7-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/27/25 23:28, Joanne Koong wrote:
> Rename the headers and payload fields to user_headers and user_payload.
> This makes it explicit that these pointers reference userspace addresses
> and prepares for upcoming fixed buffer support, where there will be
> separate fields for kernel-space pointers to the payload and headers.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/dev_uring.c   | 17 ++++++++---------
>  fs/fuse/dev_uring_i.h |  4 ++--
>  2 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index d96368e93e8d..c814b571494f 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -585,11 +585,11 @@ static void __user *get_user_ring_header(struct fuse_ring_ent *ent,
>  {
>  	switch (type) {
>  	case FUSE_URING_HEADER_IN_OUT:
> -		return &ent->headers->in_out;
> +		return &ent->user_headers->in_out;
>  	case FUSE_URING_HEADER_OP:
> -		return &ent->headers->op_in;
> +		return &ent->user_headers->op_in;
>  	case FUSE_URING_HEADER_RING_ENT:
> -		return &ent->headers->ring_ent_in_out;
> +		return &ent->user_headers->ring_ent_in_out;
>  	}
>  
>  	WARN_ON_ONCE(1);
> @@ -645,7 +645,7 @@ static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
>  	if (err)
>  		return err;
>  
> -	err = import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_sz,
> +	err = import_ubuf(ITER_SOURCE, ent->user_payload, ring->max_payload_sz,
>  			  &iter);
>  	if (err)
>  		return err;
> @@ -674,7 +674,7 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
>  		.commit_id = req->in.h.unique,
>  	};
>  
> -	err = import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz, &iter);
> +	err = import_ubuf(ITER_DEST, ent->user_payload, ring->max_payload_sz, &iter);
>  	if (err) {
>  		pr_info_ratelimited("fuse: Import of user buffer failed\n");
>  		return err;
> @@ -710,8 +710,7 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
>  
>  	ent_in_out.payload_sz = cs.ring.copied_sz;
>  	return copy_header_to_ring(ent, FUSE_URING_HEADER_RING_ENT,
> -				   &ent_in_out,
> -				   sizeof(ent_in_out));
> +				   &ent_in_out, sizeof(ent_in_out));
>  }
>  
>  static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
> @@ -1104,8 +1103,8 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
>  	INIT_LIST_HEAD(&ent->list);
>  
>  	ent->queue = queue;
> -	ent->headers = iov[0].iov_base;
> -	ent->payload = iov[1].iov_base;
> +	ent->user_headers = iov[0].iov_base;
> +	ent->user_payload = iov[1].iov_base;
>  
>  	atomic_inc(&ring->queue_refs);
>  	return ent;
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> index 51a563922ce1..381fd0b8156a 100644
> --- a/fs/fuse/dev_uring_i.h
> +++ b/fs/fuse/dev_uring_i.h
> @@ -39,8 +39,8 @@ enum fuse_ring_req_state {
>  /** A fuse ring entry, part of the ring queue */
>  struct fuse_ring_ent {
>  	/* userspace buffer */
> -	struct fuse_uring_req_header __user *headers;
> -	void __user *payload;
> +	struct fuse_uring_req_header __user *user_headers;
> +	void __user *user_payload;
>  
>  	/* the ring queue that owns the request */
>  	struct fuse_ring_queue *queue;

Reviwed-by: Bernd Schubert <bschubert@ddn.com>


