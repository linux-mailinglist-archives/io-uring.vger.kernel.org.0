Return-Path: <io-uring+bounces-2363-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77206919F31
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 08:23:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32AB728485E
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 06:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1BA01CD39;
	Thu, 27 Jun 2024 06:23:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0734A29CA;
	Thu, 27 Jun 2024 06:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719469384; cv=none; b=n6hNAa5dn/+XuqQG5ZLeN5gduYb8JYyBiCumUOQjptB0rJneimduYEH2au6P2lKX4jX2xyo8VTd5j5r8qQbW7nj9S6zXLbTE54SadOE2yLCoocJLzwbK6hBfN/z19IzF+v/MuYBdzoRvEGSTkoBrURQQ5Fu4LBKpTgvpsHGugCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719469384; c=relaxed/simple;
	bh=UoM25sq22reAqzFdc2JruT9S1O2MnuULU6WJqHsP12A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eRqS9blWZIBYnFHx3seVdu1a0v5fs+Hnnd3hcwRJbi0Jc54tLfU9HXLjj7GurmPONvDhz7D64UBygk63AENzTHFoe2FTC7ebJZbexfvwo+CwAd6kHzh6fs0xbSMF6MVZRwQCrIIy2rbl4basVlr+Ef3OhTRMILevxmNLIZXDWNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B9ECF68AFE; Thu, 27 Jun 2024 08:22:59 +0200 (CEST)
Date: Thu, 27 Jun 2024 08:22:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v2 07/10] block: define meta io descriptor
Message-ID: <20240627062259.GD16047@lst.de>
References: <20240626100700.3629-1-anuj20.g@samsung.com> <CGME20240626101523epcas5p2616cf568575685bd251d28fc1398d4cd@epcas5p2.samsung.com> <20240626100700.3629-8-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626100700.3629-8-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +struct uio_meta {
> +	u16 flags;
> +	u16 apptag;
> +	struct iov_iter iter;
> +};

Everything else in the kernel uses app_tag instead of apptag, maybe
follow that here.

What flags go into flags?  Should this be a __bitwise type?
Also bio.h is used by every file system and all block drivers.
Should this be in bio-integrity.h instead?


