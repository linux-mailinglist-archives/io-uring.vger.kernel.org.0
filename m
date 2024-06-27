Return-Path: <io-uring+bounces-2365-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E169E919F46
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 08:29:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C7072858DC
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 06:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A48C22F1C;
	Thu, 27 Jun 2024 06:29:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDB122EF0;
	Thu, 27 Jun 2024 06:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719469773; cv=none; b=UFuGoFPmMBfaHhI2AsLo9KK7t/76pugtQc5jpwp+UPRt+hC85ggmLDy5ku8Gvb2Guj1emgePTOzRa3nHIIIQR6NJ+XbYG3+6qf94oA+ZbDl9V70YRTa1FaukESU7q+BHz0Ya9UJ6w8UgXhnrXrYMXKJ89yaD6Fgo9iy0g4H2YeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719469773; c=relaxed/simple;
	bh=Nhzktyb2Yyugdz2TaoXAhgfBvBE9CaX7m9s2fy6Iki4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYygbtZL47ZERqH0CNEG3JM2qNEbBc3wgRTw1xHT68AsaiL1xlJCh8MXwc8+E5WZo3BK4c9PJDZX+jRogNA1U4iffNySRefomMla9EbrH6UgXVuosfv+CvVAQR1Uwj/EaIKeEzTDRvvtP7QdW1IZjKkpfonDWri58YrZ52eJAzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CC3A768AFE; Thu, 27 Jun 2024 08:29:27 +0200 (CEST)
Date: Thu, 27 Jun 2024 08:29:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v2 10/10] nvme: add handling for user integrity buffer
Message-ID: <20240627062927.GF16047@lst.de>
References: <20240626100700.3629-1-anuj20.g@samsung.com> <CGME20240626101529epcas5p49976c46701337830c400cefd8f074b40@epcas5p4.samsung.com> <20240626100700.3629-11-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626100700.3629-11-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 26, 2024 at 03:37:00PM +0530, Anuj Gupta wrote:
> From: Kanchan Joshi <joshi.k@samsung.com>
> 
> Create a new helper that contains the handling for both kernel and user
> generated integrity buffer.
> For user provided integrity buffer, convert bip flags
> (guard/reftag/apptag checks) to protocol specific flags. Also pass
> apptag and reftag down.

The driver should not have to know about the source.

> +static void nvme_set_app_tag(struct nvme_command *cmnd, u16 apptag)
> +{
> +	cmnd->rw.apptag = cpu_to_le16(apptag);
> +	/* use 0xfff as mask so that apptag is used in entirety*/

missing space before the closing comment.   But I think this also make
sense as:

	/* use the entire application tag */

> +	if (!bip || !(bip->bip_flags & BIP_INTEGRITY_USER)) {
> +		/*
> +		 * If formated with metadata, the block layer always provides a
> +		 * metadata buffer if CONFIG_BLK_DEV_INTEGRITY is enabled.  Else
> +		 * we enable the PRACT bit for protection information or set the
> +		 * namespace capacity to zero to prevent any I/O.
> +		 */
> +		if (!blk_integrity_rq(req)) {
> +			if (WARN_ON_ONCE(!nvme_ns_has_pi(ns->head)))
> +				return BLK_STS_NOTSUPP;
> +			*control |= NVME_RW_PRINFO_PRACT;
> +		}

This feels like the wrong level of conditionals.  !bip implies
!blk_integrity_rq(req) already.

> +	} else {
> +		unsigned short bip_flags = bip->bip_flags;
> +
> +		if (bip_flags & BIP_USER_CHK_GUARD)
> +			*control |= NVME_RW_PRINFO_PRCHK_GUARD;
> +		if (bip_flags & BIP_USER_CHK_REFTAG) {
> +			*control |= NVME_RW_PRINFO_PRCHK_REF;
> +			nvme_set_ref_tag(ns, cmnd, req);
> +		}
> +		if (bip_flags & BIP_USER_CHK_APPTAG) {
> +			*control |= NVME_RW_PRINFO_PRCHK_APP;
> +			nvme_set_app_tag(cmnd, bip->apptag);
> +		}

But excpept for that the driver should always rely on the actual
flags passed by the block layer instead of having to see if it
is user passthrough data.  Also it seems like this series fails
to update the SCSI code to account for these new flags.


