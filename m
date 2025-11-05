Return-Path: <io-uring+bounces-10391-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A319C3847B
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 00:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 003233A5213
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 23:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 383BB1EA7FF;
	Wed,  5 Nov 2025 23:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="CTSIdYuZ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="xf3iKBM4"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD3E39FCE;
	Wed,  5 Nov 2025 23:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762383697; cv=none; b=c6SLvAvBnllIcivPy9mfHzcKX1u0cA2RpZRKlRPEDQ15g7kOYwPagEkpNCqErxl1Cd6cld4ED9khe9bOOoiQ8jo600mXjuSD+7UBbyp6RM0SIs4pch7pdOMQFC9zZ1oRnzLlQLsKB+wq4TW8QVTGYqOHIv8h5XC17KOe/OACszU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762383697; c=relaxed/simple;
	bh=+dPaM07tPMobVYlu6Ub3HgsWhkPiZ2hy1tKbsg1kDf8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uJKeLG9on9XJg2H7nd41WcUGR2mEpDOdkFIgaQ57z6824rsE5PIenPaRqt+9aqeeBnzhvzTMNZ2P4AvGk9X9mu6Gs7gojuBavB2UtKbkXfP7opgFUYqQyeSypaTrPdQCrtZvUMYt3GDGbiJ5ZVB8UNnBJuVeH/WTC2pDdHJwNGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=CTSIdYuZ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=xf3iKBM4; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id F2011EC018D;
	Wed,  5 Nov 2025 18:01:33 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 05 Nov 2025 18:01:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1762383693;
	 x=1762470093; bh=PcF9pLJZR5rR4NpwLPdOKjj79/puev+BpDUvevVenUw=; b=
	CTSIdYuZuy5Dbjcgd6PLbXEybYdyg/Ar5JONG1Nr41C9Q+Wc0nOIG7Mu0MZcnNk7
	gkUAM3MiKq7wneg4EIoyBeeLd2H2fOTkA2PvQoKN5M5a9AEfenhvc11RTMPgQZDT
	U0FNN76+udS81qyeUGm123CUw4mHH7mGFpaw+vSr5GSG55PGj5Ng9/l16lzMt17H
	xOn6pdExaqRLV1ktDPZt370tZox0zubCG6le/gzrZEWt9XlkFBDcTmRMpoceTZXG
	8PG21JaJoRunAY8+pmL2xwjz3Ot5D8Cy2g9mr8rf6gnrUGgKujs5o6ercHN9dkB8
	HUffCI5e9yU/T5GYG0i7NA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762383693; x=
	1762470093; bh=PcF9pLJZR5rR4NpwLPdOKjj79/puev+BpDUvevVenUw=; b=x
	f3iKBM478BU+blVm50z7c/tn1D51xveJbwZVDGp0eyRnu1bBj7QxfRj9kjeDR5KQ
	4NtR7Wwo4oTGGqsVnevehe2czg3nwzH9sI1+zaGItoAQ2xpIiZh55bumRZ1h2Y6B
	AFBtzNu1+TIktmv5y04VxOmDCukMJAEwwzWsQnoyvb+QCTEj/J/EiOyRFCzjaima
	SNI6FJ6mgw6Ge89z7mpL77cOMWGubVy3r4nflVQ+5BaPy2KS7Z8G5me65zuZKvYA
	8yNWHH3WIipM5QHa9uNTHjcE2Wf1aA4F32U0+gfv0iMU5PsqcgGxSSIasaeuPIqD
	LSZ615ICsEjFsMir4JWnQ==
X-ME-Sender: <xms:TNcLabm3_53WxLeeNcQPprJ9IhCak_oXYDTKZhMTXa-l4tAVRMqKGQ>
    <xme:TNcLaR5x8gElOC4_3Ve7QMfWauxoNKFOnmSXkyODDkN4ufXY8xJKbrHRL-JCLNcoy
    l2qtmAzFJhdWWypDOe32yc519u349vrV379RVpPkYBC79bn_gHW>
X-ME-Received: <xmr:TNcLacT1oE1Hffw1qUZB9NsRKBTNa35oZ7_P5EPYfmDvt4Sy7Vv9b4CsRprDFjLEKLImPNgnl4GrkeIgnjJ4gLpNC4OepEQSs1WN5daiPXOlY6d96NWl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeehudeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:TNcLafwzCQxTPFIV9eIxUR2nHtvKWorcJejLeMaOdPAfprB2fNRPnA>
    <xmx:TNcLaUrzr2w9ebY1lvumfLUY_lEuN3-N6sbSuq41IqydW_Nqhg1TUA>
    <xmx:TNcLaS0jKZL3lT0AiU6tWXTywSREWrvB_ynDf1XuEalqApHfT4efcA>
    <xmx:TNcLaUwqFS5RQj2LSa3blAgICzIn_QdWp04lcVteCoe-Vb0MsDlZIQ>
    <xmx:TdcLaSdYroksF5Lld_C9xRnP09GLkWb_9fhCvHeLgwRzlQ3Z8IospK0i>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Nov 2025 18:01:31 -0500 (EST)
Message-ID: <f74e1f05-5d66-4723-a689-338ee61d9b43@bsbernd.com>
Date: Thu, 6 Nov 2025 00:01:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] fuse: use enum types for header copying
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu, axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, bschubert@ddn.com, asml.silence@gmail.com,
 io-uring@vger.kernel.org, xiaobing.li@samsung.com, csander@purestorage.com,
 kernel-team@meta.com
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-6-joannelkoong@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20251027222808.2332692-6-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/27/25 23:28, Joanne Koong wrote:
> Use enum types to identify which part of the header needs to be copied.
> This improves the interface and will simplify both kernel-space and
> user-space header addresses when fixed buffer support is added.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/dev_uring.c | 55 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 45 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index faa7217e85c4..d96368e93e8d 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -31,6 +31,12 @@ struct fuse_uring_pdu {
>  
>  static const struct fuse_iqueue_ops fuse_io_uring_ops;
>  
> +enum fuse_uring_header_type {
> +	FUSE_URING_HEADER_IN_OUT,

In post review of my own names, headers->in_out is rather hard to
understand, I would have probably chosen "msg_in_out" now.
With that _maybe_ FUSE_URING_HEADER_MSG_IN_OUT?

> +	FUSE_URING_HEADER_OP,
> +	FUSE_URING_HEADER_RING_ENT,
> +};
> +
>  static void uring_cmd_set_ring_ent(struct io_uring_cmd *cmd,
>  				   struct fuse_ring_ent *ring_ent)
>  {
> @@ -574,9 +580,31 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
>  	return err;
>  }
>  
> -static int copy_header_to_ring(void __user *ring, const void *header,
> -			       size_t header_size)
> +static void __user *get_user_ring_header(struct fuse_ring_ent *ent,
> +					 enum fuse_uring_header_type type)
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
> +static int copy_header_to_ring(struct fuse_ring_ent *ent,
> +			       enum fuse_uring_header_type type,
> +			       const void *header, size_t header_size)
>  {
> +	void __user *ring = get_user_ring_header(ent, type);
> +
> +	if (!ring)
> +		return -EINVAL;
> +
>  	if (copy_to_user(ring, header, header_size)) {
>  		pr_info_ratelimited("Copying header to ring failed.\n");
>  		return -EFAULT;
> @@ -585,9 +613,15 @@ static int copy_header_to_ring(void __user *ring, const void *header,
>  	return 0;
>  }
>  
> -static int copy_header_from_ring(void *header, const void __user *ring,
> -				 size_t header_size)
> +static int copy_header_from_ring(struct fuse_ring_ent *ent,
> +				 enum fuse_uring_header_type type,
> +				 void *header, size_t header_size)
>  {
> +	const void __user *ring = get_user_ring_header(ent, type);
> +
> +	if (!ring)
> +		return -EINVAL;
> +
>  	if (copy_from_user(header, ring, header_size)) {
>  		pr_info_ratelimited("Copying header from ring failed.\n");
>  		return -EFAULT;
> @@ -606,8 +640,8 @@ static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
>  	int err;
>  	struct fuse_uring_ent_in_out ring_in_out;
>  
> -	err = copy_header_from_ring(&ring_in_out, &ent->headers->ring_ent_in_out,
> -				    sizeof(ring_in_out));
> +	err = copy_header_from_ring(ent, FUSE_URING_HEADER_RING_ENT,
> +				    &ring_in_out, sizeof(ring_in_out));
>  	if (err)
>  		return err;
>  
> @@ -656,7 +690,7 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
>  		 * Some op code have that as zero size.
>  		 */
>  		if (args->in_args[0].size > 0) {
> -			err = copy_header_to_ring(&ent->headers->op_in,
> +			err = copy_header_to_ring(ent, FUSE_URING_HEADER_OP,
>  						  in_args->value,
>  						  in_args->size);
>  			if (err)
> @@ -675,7 +709,8 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
>  	}
>  
>  	ent_in_out.payload_sz = cs.ring.copied_sz;
> -	return copy_header_to_ring(&ent->headers->ring_ent_in_out, &ent_in_out,
> +	return copy_header_to_ring(ent, FUSE_URING_HEADER_RING_ENT,
> +				   &ent_in_out,
>  				   sizeof(ent_in_out));
>  }
>  
> @@ -705,7 +740,7 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
>  	}
>  
>  	/* copy fuse_in_header */
> -	return copy_header_to_ring(&ent->headers->in_out, &req->in.h,
> +	return copy_header_to_ring(ent, FUSE_URING_HEADER_IN_OUT, &req->in.h,
>  				   sizeof(req->in.h));
>  }
>  
> @@ -800,7 +835,7 @@ static void fuse_uring_commit(struct fuse_ring_ent *ent, struct fuse_req *req,
>  	struct fuse_conn *fc = ring->fc;
>  	ssize_t err = 0;
>  
> -	err = copy_header_from_ring(&req->out.h, &ent->headers->in_out,
> +	err = copy_header_from_ring(ent, FUSE_URING_HEADER_IN_OUT, &req->out.h,
>  				    sizeof(req->out.h));
>  	if (err) {
>  		req->out.h.error = err;


Reviewed-by: Bernd Schubert <bschubert@ddn.com>

