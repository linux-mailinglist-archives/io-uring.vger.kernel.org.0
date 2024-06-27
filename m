Return-Path: <io-uring+bounces-2362-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 969DD919F2F
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 08:21:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35AAFB20CA8
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 06:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3978C1A29A;
	Thu, 27 Jun 2024 06:21:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A743729CA;
	Thu, 27 Jun 2024 06:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719469308; cv=none; b=SOjYBNOucqYtN4cR6rTiCRzv5z9G9OSbG4sOdc5c8ZczIKab388Oy29MBdyJLX0Uy7ZQRsSjOt2pM4psHTPjq52Fle9qT8cWPda4s4zknlQlyJ7Ma1gzbDSb+Tm9JU8gVEFVbzzZsgiGWgrbS3xU70sjMKLEEgaROy7m6Ua3grE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719469308; c=relaxed/simple;
	bh=BywcTjIG7RxWh8SVPJ2cx81NpidQXOySb6IOMh6mx6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rgF1X1Mex1vpmwBCLWnXVY3Dz+u1hIuUlnfJlGaB0ujZ5JSZIB6ey31kEAKXmiQlbk4PgT6EbgRYqjA+dn07tZQjprDdY41BBnS/VGvjC26S36h7ZW/+EzGqn8wdtiF7zcXwxQGqBSoN9Y1HkCEFHRFEU2jwoXYIjwBxdy4OklM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 103C168AFE; Thu, 27 Jun 2024 08:21:43 +0200 (CEST)
Date: Thu, 27 Jun 2024 08:21:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v2 05/10] block: introduce BIP_CLONED flag
Message-ID: <20240627062142.GC16047@lst.de>
References: <20240626100700.3629-1-anuj20.g@samsung.com> <CGME20240626101519epcas5p163b0735c1604a228196f0e8c14773005@epcas5p1.samsung.com> <20240626100700.3629-6-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626100700.3629-6-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 26, 2024 at 03:36:55PM +0530, Anuj Gupta wrote:
> From: Kanchan Joshi <joshi.k@samsung.com>
> 
> Set the BIP_CLONED flag when bip is cloned.
> Use that flag to ensure that integrity is freed for cloned user bip.
> 
> Note that a bio may have BIO_CLONED flag set but it may still not be
> sharing the integrity vecs.

The design principle of the immutable bio_vecs for the data path
is that BIO_CLONED is just a debug aid and no code should check it.
I'd much prefer to keep that invariant for metadata.

> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index 845d4038afb1..8f07c4d0fada 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -147,7 +147,8 @@ void bio_integrity_free(struct bio *bio)
>  	struct bio_integrity_payload *bip = bio_integrity(bio);
>  	struct bio_set *bs = bio->bi_pool;
>  
> -	if (bip->bip_flags & BIP_INTEGRITY_USER)
> +	if (bip->bip_flags & BIP_INTEGRITY_USER &&
> +	    !(bip->bip_flags & BIP_CLONED))
>  		return;
>  	if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
>  		kfree(bvec_virt(bip->bip_vec));

... and the right way to approach this is to clean up the mess
that we have in bio_integrity_free, which probably needs a split up
to deal wit hthe different cases:

 - block layer auto-generated bip_vecs we need it called where it is
   right now, but that side can now unconditionally free the data
   pointed to by the bip_vec
 - for callers that supply PI data themselves, including from user space,
   the caller needs to call __bio_integrity_free and clear
   bi_integrity and REQ_INTEGRITY

this is probably best done by moving the bip_flags checks out of
bio_integrity_free and have bio_integrity_free just do the
unconditional freeing, and have a new helper for
__bio_integrity_endio / bio_integrity_verify_fn to also
free the payload.


