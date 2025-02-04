Return-Path: <io-uring+bounces-6246-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F068DA26B72
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 06:39:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CC2316742F
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 05:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6989B1E0087;
	Tue,  4 Feb 2025 05:39:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FBD1DE4C1;
	Tue,  4 Feb 2025 05:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738647561; cv=none; b=cmK6l4/cV1FEA6nHxFHzKYAPVhFAnYoAbvHUo8eyOzmsGEfhnWX/g5mtpYl3W1aqDJekrUz1JnFX06D248HVVFzR2nhdgGR7W68EktKyINFDjrtvZLhVx6vseeovm3GqeITQJS0jkLfRpbtVjD4t4LRSi+uwCLfL/qb2lQtWNwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738647561; c=relaxed/simple;
	bh=6W0gpua/z0lVJ9/1+YXqngxLzNpaRw0tWiI/EFoamho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E15g5jeG3SzPQkFQHuvOmfNLbsPOHqRT+P5KHmJ9ZBwq1pFV07fsJAtzLQ6N5k5E0blzVqSPwxNfQNVbS2MxWSZpjJrktdbzEWv62gqSHWJd2CvYLDg2mgfCTVG20t+C/+fVZTWMCvxoOGqk3AKI24maz1O+qCps1g4DLyxjM3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D43FC68AFE; Tue,  4 Feb 2025 06:39:14 +0100 (CET)
Date: Tue, 4 Feb 2025 06:39:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v11 07/10] block: introduce
 BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
Message-ID: <20250204053914.GA28919@lst.de>
References: <20241128112240.8867-1-anuj20.g@samsung.com> <CGME20241128113112epcas5p186ef86baaa3054effb7244c54ee2f991@epcas5p1.samsung.com> <20241128112240.8867-8-anuj20.g@samsung.com> <20250203065331.GA16999@lst.de> <20250203143948.GA17571@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203143948.GA17571@green245>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 03, 2025 at 08:09:48PM +0530, Anuj Gupta wrote:
> +	if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
> +		bip->bip_flags |= BIP_IP_CHECKSUM;

I don't think this part will work, but it's a bug since day one of
the nvmet PI support:  NVMe doesn't support IP checksum, but in this
case we'd expect the remoe side to supply it.  So the setup path
needs to check for a support csum type.  I can look into that as a
separate fix.

We'll also need to set the BIP_CHECK_GUARD flag here I think.


