Return-Path: <io-uring+bounces-3769-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7214E9A1D1E
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 10:24:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1CDA5B260D4
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 08:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 591241C2447;
	Thu, 17 Oct 2024 08:24:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB3A1D0DE7;
	Thu, 17 Oct 2024 08:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729153471; cv=none; b=aCWT3RMsloyodSRFZGtjrNPFT1uYl96FbytpvyXgsZQYeF67YdnpVUsFaYvgT1PsrUzVf2R0QCMedLxv27kKuDFiIyg1sCwKn9J+KSMW1ZQiQGEZq6bdDznEJxLueZk4P7N2drli32trQgLrLkbgp4LIW2aTZMrkTxUQl0H/qFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729153471; c=relaxed/simple;
	bh=ZX0wpqvZ52TSRgk4GVNDk8XKff15P46R/U9UTePfsYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ifY7A1AWUyxuJvb1FpBgBrmaVQw6aOieoc+NTRh3if3V1yK+qLlSHEgjT8IiVQ4MQWd1x41qdmkI2tJeh3zTECaPBTSwpx+d6sH0B5M1/jqUFs8QtMpolw51rFCFwNw/WyiGuzrc0nCv1dYppdZ5VuXAs3UDCgq4Jbs8UoPjx6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A0E75227A8E; Thu, 17 Oct 2024 10:24:22 +0200 (CEST)
Date: Thu, 17 Oct 2024 10:24:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v4 09/11] block: add support to pass user meta buffer
Message-ID: <20241017082422.GB28355@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113752epcas5p4c365819fce1e5d498fd781ae2b309341@epcas5p4.samsung.com> <20241016112912.63542-10-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016112912.63542-10-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 16, 2024 at 04:59:10PM +0530, Anuj Gupta wrote:
> From: Kanchan Joshi <joshi.k@samsung.com>
> 
> If an iocb contains metadata, extract that and prepare the bip.
> Based on flags specified by the user, set corresponding guard/app/ref
> tags to be checked in bip.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  block/bio-integrity.c         | 51 +++++++++++++++++++++++++++++++++++
>  block/fops.c                  | 44 +++++++++++++++++++++++-------
>  include/linux/bio-integrity.h |  7 +++++
>  3 files changed, 93 insertions(+), 9 deletions(-)
> 
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index d3c8b56d3fe6..24fad9b6f3ec 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -12,6 +12,7 @@
>  #include <linux/bio.h>
>  #include <linux/workqueue.h>
>  #include <linux/slab.h>
> +#include <uapi/linux/blkdev.h>
>  #include "blk.h"
>  
>  static struct kmem_cache *bip_slab;
> @@ -303,6 +304,55 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
>  	return nr_bvecs;
>  }
>  
> +static void bio_uio_meta_to_bip(struct bio *bio, struct uio_meta *meta)
> +{
> +	struct bio_integrity_payload *bip = bio_integrity(bio);
> +
> +	if (meta->flags & BLK_INTEGRITY_CHK_GUARD)
> +		bip->bip_flags |= BIP_CHECK_GUARD;
> +	if (meta->flags & BLK_INTEGRITY_CHK_APPTAG)
> +		bip->bip_flags |= BIP_CHECK_APPTAG;
> +	if (meta->flags & BLK_INTEGRITY_CHK_REFTAG)
> +		bip->bip_flags |= BIP_CHECK_REFTAG;
> +
> +	bip->app_tag = meta->app_tag;
> +}
> +
> +int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta)

Just noticed this when looking at the seed situation:  Can you please
move bio_integrity_map_iter below bio_integrity_map_user as it is
a relatively thing wrapper for it? 


