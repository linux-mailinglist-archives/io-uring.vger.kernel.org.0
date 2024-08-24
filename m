Return-Path: <io-uring+bounces-2938-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B10D895DD01
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 10:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DF27283B45
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 08:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50687143889;
	Sat, 24 Aug 2024 08:44:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990948460;
	Sat, 24 Aug 2024 08:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724489076; cv=none; b=laiC4D4f3mFy4NA+LLl9+kemnmpHXxf3uR+cfE+APBzsbT3me0bUbK+JBaGz5JJsbQAgOCjeazdZq8cY62iWzYiDH2UJctWGvg7oyyhWX4cPWB1LiDjWiMZHcpyCZ84PYljm1/3SZxEX2Ds6hBwjxO8TeAD22QotHeU6/0PBo90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724489076; c=relaxed/simple;
	bh=eLrPulrnIY/B36XVtFNCVSHh/ecSt3QlKey4nC8gxwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b2td4BrAEq1xst2CfY62ylVXEs+sTSabq4A6fFcJPVTrPPOhM9RNFChTGmZic9jcSbdAkinJ3flESUc5GjTwpx07aWAOtT7PyhTV+Kg3LMqsVW9eWczTxP1f1vmHwURBpPT1tm2eF5b+rVK6DoDR3sv77mocgQYTecx631U0t60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4148A227A87; Sat, 24 Aug 2024 10:44:30 +0200 (CEST)
Date: Sat, 24 Aug 2024 10:44:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v3 08/10] block: add support to pass user meta buffer
Message-ID: <20240824084430.GG8805@lst.de>
References: <20240823103811.2421-1-anuj20.g@samsung.com> <CGME20240823104634epcas5p4ef1af26cc7146b4e8b7a4a1844ffe476@epcas5p4.samsung.com> <20240823103811.2421-10-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823103811.2421-10-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 23, 2024 at 04:08:09PM +0530, Anuj Gupta wrote:
> From: Kanchan Joshi <joshi.k@samsung.com>
> 
> If iocb contains the meta, extract that and prepare the bip.

If an iocb contains metadata, ...

> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -154,6 +154,9 @@ static void blkdev_bio_end_io(struct bio *bio)
>  		}
>  	}
>  
> +	if (bio_integrity(bio) && (dio->iocb->ki_flags & IOCB_HAS_META))
> +		bio_integrity_unmap_user(bio);

How could bio_integrity() be true here without the iocb flag?

> +		if (!is_sync && unlikely(iocb->ki_flags & IOCB_HAS_META)) {

unlikely is actively harmful here, as the code is likely if you use
the feature..

> +			ret = bio_integrity_map_iter(bio, iocb->private);
> +			if (unlikely(ret)) {
> +				bio_release_pages(bio, false);
> +				bio_clear_flag(bio, BIO_REFFED);
> +				bio_put(bio);
> +				blk_finish_plug(&plug);
> +				return ret;
> +			}

This duplicates the error handling done just above.  Please add a
goto label to de-duplicate it.

> +	if (unlikely(iocb->ki_flags & IOCB_HAS_META)) {
> +		ret = bio_integrity_map_iter(bio, iocb->private);
> +		WRITE_ONCE(iocb->private, NULL);
> +		if (unlikely(ret)) {
> +			bio_put(bio);
> +			return ret;

This probably also wants an out_bio_put label even if the duplication
is minimal so far.

You probably also want a WARN_ON for the iocb meta flag in
__blkdev_direct_IO_simple so that we don't get caught off guard
if someone adds a synchronous path using PI.

> diff --git a/block/t10-pi.c b/block/t10-pi.c
> index e7052a728966..cb7bc4a88380 100644
> --- a/block/t10-pi.c
> +++ b/block/t10-pi.c
> @@ -139,6 +139,8 @@ static void t10_pi_type1_prepare(struct request *rq)
>  		/* Already remapped? */
>  		if (bip->bip_flags & BIP_MAPPED_INTEGRITY)
>  			break;
> +		if (bip->bip_flags & BIP_INTEGRITY_USER)
> +			break;

This is wrong.  When submitting metadata on a partition the ref tag
does need to be remapped.  Please also add a tests that tests submitting
metadata on a partition so that we have a regression test for this.

> +	BIP_INTEGRITY_USER      = 1 << 9, /* Integrity payload is user
> +					   * address
> +					   */

.. and with the above fix this flag should not be needed.

>  };
>  
>  struct bio_integrity_payload {
> @@ -24,6 +27,7 @@ struct bio_integrity_payload {
>  	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
>  	unsigned short		bip_max_vcnt;	/* integrity bio_vec slots */
>  	unsigned short		bip_flags;	/* control flags */
> +	u16			app_tag;

Please document the field even if it seems obvious.


