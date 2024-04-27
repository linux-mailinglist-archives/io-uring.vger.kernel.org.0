Return-Path: <io-uring+bounces-1657-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2E188B44B5
	for <lists+io-uring@lfdr.de>; Sat, 27 Apr 2024 09:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0139E1C228A9
	for <lists+io-uring@lfdr.de>; Sat, 27 Apr 2024 07:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9174841A8F;
	Sat, 27 Apr 2024 07:05:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E762F40856;
	Sat, 27 Apr 2024 07:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714201513; cv=none; b=SmzaVMVxwqLdkggWub0K2Y6bqZj+Qy+1qSbktBS9oQCmU+JIwxjF6W4kGU8Y5dg4wZQa1LCjsHw7Ts0OPMJwRi2bdviRJlzfMi5X/470ETdSjE5C4UA5xY2im9a+E9TTvSprFLLwUrpzO9ne326NwTW+amm99Iqp+wxZFhTfb4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714201513; c=relaxed/simple;
	bh=8BzCCOxMKbQBD/YBTnpw6S3QxzSLPfsYK4XW6XYXbsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VixBmoUOXIzp0i+ixDR+qv3/lBBDzzQQF9MxZ9qncsZnTg3dMLkLIqt4x/3iffDlh8AxRsz2d/ZTOtkQSAmqT9uHcxvPpjO1aHmW3IC0701SdYHBeuim4UvdivMY3knrdUenZNB7bkGGsmgN4xZPEvdDCT9HFXx8nFIiSEtJFN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DC2FC227AA8; Sat, 27 Apr 2024 09:05:08 +0200 (CEST)
Date: Sat, 27 Apr 2024 09:05:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	hch@lst.de, brauner@kernel.org, asml.silence@gmail.com,
	dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 04/10] block: avoid unpinning/freeing the bio_vec
 incase of cloned bio
Message-ID: <20240427070508.GD3873@lst.de>
References: <20240425183943.6319-1-joshi.k@samsung.com> <CGME20240425184658epcas5p2adb6bf01a5c56ffaac3a55ab57afaf8e@epcas5p2.samsung.com> <20240425183943.6319-5-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240425183943.6319-5-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 26, 2024 at 12:09:37AM +0530, Kanchan Joshi wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> Do it only once when the parent bio completes.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  block/bio-integrity.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index b4042414a08f..b698eb77515d 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -119,7 +119,8 @@ static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
>  	ret = copy_to_iter(bvec_virt(&src_bvec), bytes, &iter);
>  	WARN_ON_ONCE(ret != bytes);
>  
> -	bio_integrity_unpin_bvec(copy, nr_vecs, true);
> +	if (!bio_flagged((bip->bip_bio), BIO_CLONED))
> +		bio_integrity_unpin_bvec(copy, nr_vecs, true);
>  }

This feels wrong.  I suspect the problem is that BIP_COPY_USER is
inherited for clone bios while it shouldn't.


