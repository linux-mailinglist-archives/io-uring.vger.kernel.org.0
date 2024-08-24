Return-Path: <io-uring+bounces-2940-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FF0395DD0F
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 10:52:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9996E28394E
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 08:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8444738FA1;
	Sat, 24 Aug 2024 08:52:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE99164A;
	Sat, 24 Aug 2024 08:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724489571; cv=none; b=NbA7U90puqTQjCZCedgOccLvGV2VGZF4U7Ge64SE7uQfOA/M2mUAwHjIN5h7SYApfgcfDQsXpB3iuQ8+CLy++lMIXHGPbGoinDl0DK/Y2D/s8RalGbWFqQV6ZB4daA1zxWcuXuTE+B8t8rJN3knR+MZcQqaFaCSqSVw5RV9nbG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724489571; c=relaxed/simple;
	bh=FyYNMCJzt9PMNOd5OGdnyKqTlzi9TsZCmyBtLBxsScA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hyg4pECOCzlSrXPZo5rUNw0vthqMBgfeXr2KqGoMu0VdKnSC+TrJHCVqCNtKhl1Twd+CQp4oE04NDoru+RDJX0jhpOm34Tp5ueAZSIHavC3ag+iXkIbe3nSHDyW/meJm+UxpjNkC7hMusQtZBvOUu4VcajqfvixPjPuwZ1UG1ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 73C1D227A87; Sat, 24 Aug 2024 10:52:45 +0200 (CEST)
Date: Sat, 24 Aug 2024 10:52:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 10/10] scsi: add support for user-meta interface
Message-ID: <20240824085245.GI8805@lst.de>
References: <20240823103811.2421-1-anuj20.g@samsung.com> <CGME20240823104639epcas5p11dbab393122841419368a86b4bd5c04b@epcas5p1.samsung.com> <20240823103811.2421-12-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823103811.2421-12-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> Add support for sending user-meta buffer. Set tags to be checked
> using flags specified by user/block-layer user and underlying DIF/DIX
> configuration. Introduce BLK_INTEGRITY_APP_TAG to specify apptag.
> This provides a way for upper layers to specify apptag checking.

We'll also need that flag for nvme, don't we?  It should also be
added in a block layer patch and not as part of a driver patch.

> +/*
> + * Can't check reftag alone or apptag alone
> + */
> +static bool sd_prot_flags_valid(struct scsi_cmnd *scmd)
> +{
> +	struct request *rq = scsi_cmd_to_rq(scmd);
> +	struct bio *bio = rq->bio;
> +
> +	if (bio_integrity_flagged(bio, BIP_CHECK_REFTAG) &&
> +	    !bio_integrity_flagged(bio, BIP_CHECK_APPTAG))
> +		return false;
> +	if (!bio_integrity_flagged(bio, BIP_CHECK_REFTAG) &&
> +	    bio_integrity_flagged(bio, BIP_CHECK_APPTAG))
> +		return false;
> +	return true;
> +}

We'll need to advertise this limitations to the application or in-kernel
user somehow..

> +		if ((bio_integrity_flagged(bio, BIP_CTRL_NOCHECK) == false) &&
> +			(!dix || bio_integrity_flagged(bio, BIP_CHECK_REFTAG)))

Incorrect formatting.  This is better:

		if (!bio_integrity_flagged(bio, BIP_CTRL_NOCHECK) &&
		    (!dix || bio_integrity_flagged(bio, BIP_CHECK_REFTAG)))


