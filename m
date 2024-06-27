Return-Path: <io-uring+bounces-2360-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37D6E919F1C
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 08:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B4031C20FAE
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 06:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DECC17C6A;
	Thu, 27 Jun 2024 06:14:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D30C1CF92;
	Thu, 27 Jun 2024 06:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719468847; cv=none; b=ANUBhS3PbVbyI04GLB2idWV+5HysB6bWQe7x70GjKyZnLfJS2WOQ+NgA9z8kOX4ZK1DKbxWWC/dn+omQ/Q/S5zzqWSYOX9AoQ84P6xUmkg0ZIE7P7YbyPtXWIl4N+eAzYO19oSHVAA640PE0J9Wep4Ddq8gMx5oLa6MdY9XrKw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719468847; c=relaxed/simple;
	bh=+fvlvPJv7lOrSL+qX1Rlr4bx/Lijzw6pGiEm7q4fA6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RWO0lAmVwwyPNedwSp6bI4d2W4SSvzQWPzuCsyOPF8PxoxMz3Nyhccuk4918U2cnF2ZYg7BlQpvM3pON9pUQi+bAHoaTW0Met8xHEWqDWsV3qENXPIhXUg1n1+LljvdSo3oDAfvr4m2cOIJ8uH5SeaNE2ZCb+iYEvW7zEDMkWvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6143968AFE; Thu, 27 Jun 2024 08:14:01 +0200 (CEST)
Date: Thu, 27 Jun 2024 08:14:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v2 03/10] block: copy bip_max_vcnt vecs instead of
 bip_vcnt during clone
Message-ID: <20240627061401.GA16047@lst.de>
References: <20240626100700.3629-1-anuj20.g@samsung.com> <CGME20240626101516epcas5p19fb40e8231d1832cab3d031672f0109e@epcas5p1.samsung.com> <20240626100700.3629-4-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626100700.3629-4-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 26, 2024 at 03:36:53PM +0530, Anuj Gupta wrote:
> If bio_integrity_copy_user is used to process the meta buffer, bip_max_vcnt
> is one greater than bip_vcnt.

Why?

> @@ -647,12 +647,12 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
>  
>  	BUG_ON(bip_src == NULL);
>  
> -	bip = bio_integrity_alloc(bio, gfp_mask, bip_src->bip_vcnt);
> +	bip = bio_integrity_alloc(bio, gfp_mask, bip_src->bip_max_vcnt);
>  	if (IS_ERR(bip))
>  		return PTR_ERR(bip);
>  
>  	memcpy(bip->bip_vec, bip_src->bip_vec,
> -	       bip_src->bip_vcnt * sizeof(struct bio_vec));
> +	       bip_src->bip_max_vcnt * sizeof(struct bio_vec));
>  
>  	bip->bip_vcnt = bip_src->bip_vcnt;
>  	bip->bip_iter = bip_src->bip_iter;

So trying to compare this to how the bio data path is cloned, it seems
like bio_integrity_clone is still copying the bvec array.  With the
concept of the immutable bvecs we've had for years this should not
be required.  That is reuse the actual bio_vecs, and just copy
the iter similar to bio_alloc_clone/__bio_clone.

