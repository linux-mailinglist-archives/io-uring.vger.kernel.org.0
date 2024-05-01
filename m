Return-Path: <io-uring+bounces-1697-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A4C8B864B
	for <lists+io-uring@lfdr.de>; Wed,  1 May 2024 09:47:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54E501C211A9
	for <lists+io-uring@lfdr.de>; Wed,  1 May 2024 07:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FDF04D135;
	Wed,  1 May 2024 07:47:02 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B614AEF0;
	Wed,  1 May 2024 07:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714549622; cv=none; b=aAL0hNZHT4H4Cn+5w5fdb8/Zt4b9jASDDxG7r6PxWeiUvLC45HjNX/NoUX2H8jkV+nO9hqTU85y5sNmGe8WpAKA2I3ZmZYeWDLsx3KSdCUCIvTH3Qxad11/Ny2oMWoBg1uAiNpSL9WJ6C8zlAaP7wm+j+QTnN/55WNy74mo4qsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714549622; c=relaxed/simple;
	bh=1usElGWA7X2IM8yxssewuRUGLgOXecLhs4UNVED7azc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AbGxV7dC2ISOvJzUmxCsCRBIU1KtNjc9hvPYkLfTwNmId1zdnkD8kZWjmFN9BFIHQEUXEtTCgGY/C/GnAOH2FFmfK165C8XsC5IXUmy4FcmziBQHi/rk2McUhP5p77vDV7dtpdKHclPBQM2FLF7IFMntZDT03XTp0qo3JHXI5dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 16BB2227A87; Wed,  1 May 2024 09:46:56 +0200 (CEST)
Date: Wed, 1 May 2024 09:46:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	axboe@kernel.dk, martin.petersen@oracle.com, brauner@kernel.org,
	asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 02/10] block: copy bip_max_vcnt vecs instead of
 bip_vcnt during clone
Message-ID: <20240501074654.GB2325@lst.de>
References: <20240425183943.6319-1-joshi.k@samsung.com> <CGME20240425184653epcas5p28de1473090e0141ae74f8b0a6eb921a7@epcas5p2.samsung.com> <20240425183943.6319-3-joshi.k@samsung.com> <20240427070331.GB3873@lst.de> <73cc82c3-fbf6-ea3e-94ec-3bdce55af541@samsung.com> <Zi-MvOZ_bYVuiuBb@kbusch-mbp.mynextlight.net> <20240429170728.GA31337@lst.de> <ZjCrAkM8oOgLhg8_@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjCrAkM8oOgLhg8_@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 30, 2024 at 09:25:38AM +0100, Keith Busch wrote:
> > I think we need to do something like that - just hiding the bounce
> > buffer is not really maintainable once we get multiple levels of stacking
> > and other creative bio cloning.
> 
> Not sure I follow that. From patches 2-4 here, I think that pretty much
> covers it. It's just missing a good code comment, but the implementation
> side looks complete for any amount of stacking and splitting.

I can't see how it would work, but I'll gladly wait for a better
description.

