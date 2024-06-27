Return-Path: <io-uring+bounces-2361-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03036919F23
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 08:16:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3818285CF7
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 06:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57B99200B7;
	Thu, 27 Jun 2024 06:16:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D205929CA;
	Thu, 27 Jun 2024 06:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719468979; cv=none; b=eVMVdwEJ+FBGi9BmNdbG1FMDrhV9fiuD5UBH0xfNIeIO1ubsIBReA4/+97IvwP/ZZh515z0Zi9h+5F9kexkufoo1R0aaFTRNnPL4SLYYHojqrsgciNRn9F+NEufhLx+UFzdTttiJOO6+U/+libaPGBHTqtYRj58pPcdjazkOB34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719468979; c=relaxed/simple;
	bh=Ra6CyBPwi/SDN/xakg8e7oXLQpkLpyMGzCpT1RTUJac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zd18TF5sevxft528S22CUTdYeu1GyEpFueiWzEgRWrhV363fxre5s/1BFhoXMdSvlFyClv7TULD+5vSerK2ihrMiScFbsQ5zsz5cuJuOtUjZ6QcLOVer6kcFnrog1W1v9WvYimGqC+Qjir0cM8hO5KV/OnpMsaITOOijAiEbwJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA9F968AFE; Thu, 27 Jun 2024 08:16:13 +0200 (CEST)
Date: Thu, 27 Jun 2024 08:16:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v2 04/10] block: Handle meta bounce buffer correctly in
 case of split
Message-ID: <20240627061613.GB16047@lst.de>
References: <20240626100700.3629-1-anuj20.g@samsung.com> <CGME20240626101518epcas5p17e046bca77b218fc6914ddeb182eb42e@epcas5p1.samsung.com> <20240626100700.3629-5-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626100700.3629-5-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 26, 2024 at 03:36:54PM +0530, Anuj Gupta wrote:
> @@ -105,9 +105,12 @@ static void bio_integrity_unpin_bvec(struct bio_vec *bv, int nr_vecs,
>  
>  static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
>  {
> +	struct bio *bio = bip->bip_bio;
> +	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
>  	unsigned short nr_vecs = bip->bip_max_vcnt - 1;
>  	struct bio_vec *copy = &bip->bip_vec[1];
> -	size_t bytes = bip->bip_iter.bi_size;
> +	size_t bytes = bio_integrity_bytes(bi,
> +					   bvec_iter_sectors(bip->bio_iter));

Maybe add a well documented helper that calculates the metadata bytes
based on the iter given that this is probably going to become more
common now that we're doing proper cloning?

> -	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
> -
> +	bip->bip_flags = bip_src->bip_flags & ~(BIP_BLOCK_INTEGRITY |
> +						BIP_COPY_USER);

We're probably better off say what flags should be cloned and not
which ones should not.  Preferably with a new #define in bio.h.


