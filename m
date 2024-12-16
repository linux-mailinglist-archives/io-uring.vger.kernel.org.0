Return-Path: <io-uring+bounces-5501-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E2EA29F3598
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 17:16:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EDC3165168
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 16:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6C3203D4C;
	Mon, 16 Dec 2024 16:13:02 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2808202C50;
	Mon, 16 Dec 2024 16:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734365582; cv=none; b=fBTAn3swTgdPA+5lXgiVi0Tyk7TSyciwMUzCmiSYFwfHkN1Qs252HiDLpJHJRbQx/owOXXDA7Jr+Bt/TpNsad3TaWvKAu81phzHuGPlkV1Z06cKFtAyEdsGp2QIQNH1fSCme/2agNPQy3YpsECFXu8m2MZuunGY+Ckf1DLBdmSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734365582; c=relaxed/simple;
	bh=ai1q4KaKsZ11pODmxNKJDhxqW5fr1AH0gwbTKkWMQEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WbpE+i21WhY+hsHYMFJcvDVFEIFt+J2MCQlJXHCItKgBt/rYIYAymGJe91h0oOl7dsHW7iNqvE+UOGn+H11U4ToXZh5eof4WNfCPNu7OhypPDByGZ0qo0mSM6IgTBYc4PRYg2HvzbsNVxilxLRWw9DjUHibZtFGgxmDQoM4IXuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C523968C4E; Mon, 16 Dec 2024 17:12:55 +0100 (CET)
Date: Mon, 16 Dec 2024 17:12:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
	anuj20.g@samsung.com, joshi.k@samsung.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv14 10/11] nvme: register fdp parameters with the block
 layer
Message-ID: <20241216161255.GC24735@lst.de>
References: <20241211183514.64070-1-kbusch@meta.com> <20241211183514.64070-11-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211183514.64070-11-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 11, 2024 at 10:35:13AM -0800, Keith Busch wrote:
> +	size = le32_to_cpu(hdr.sze);
> +	if (size > PAGE_SIZE * MAX_ORDER_NR_PAGES) {
> +		dev_warn(ctrl->device, "FDP config size too large:%zu\n",
> +			 size);
> +		return 0;
> +	h = vmalloc(size);
> +	if (!h)
> +		return -ENOMEM;

Isn't an unconditional vmalloc here for something that usually should
have less than a handful of descriptors a little aggressive?  I'd use
kvmalloc here to get the best of both worlds, and the free path seems
to already use kvfree anyway.

Otherwise the incremental changes vs the previous version for the entire
series look good to me.

