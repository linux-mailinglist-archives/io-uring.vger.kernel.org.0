Return-Path: <io-uring+bounces-1660-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 527A28B469B
	for <lists+io-uring@lfdr.de>; Sat, 27 Apr 2024 16:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4A93283126
	for <lists+io-uring@lfdr.de>; Sat, 27 Apr 2024 14:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB8C4EB46;
	Sat, 27 Apr 2024 14:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F3emSUjz"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1297F3A1C7;
	Sat, 27 Apr 2024 14:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714227416; cv=none; b=PvbY5ow6+Xc0sCkyByzXgxjU6UyFCBjElLXyOoNwSNYN2oMD+6+upw869U37hLa/3EI6r0mcXuOk6GXR4VBzaq8gQbGhIvx2vb8Jx32Aqr9fsA/hH0TNqrEiXsqVlaQitTPlLrUSFmAJ7DNoXzpsW+snr5Mnm1f/DPylCYjpyeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714227416; c=relaxed/simple;
	bh=Na+9ra5c6HOeVkjiYeIyIYZNajmyn09tvJZtK9DS1pI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RbdsE119G6+gxYIOOD/G5MGr9mCqfcDJ5BFUH4QWVCOBaF7BYDi4+FdGSVIIodMd3RuAwF8eBjUC9CWm7PLJLD144WuhWIg2wf4N7MuHHwE31UyzZS/748hwB8nvgwfx2qd3gqRwrV9aQ5FkwAvMztvrxoFpFIID/Y6UdUdcTEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F3emSUjz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC98EC113CE;
	Sat, 27 Apr 2024 14:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714227415;
	bh=Na+9ra5c6HOeVkjiYeIyIYZNajmyn09tvJZtK9DS1pI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F3emSUjz+0ahZUdDclaFWuMk27w0bn3NKv1d3skqWdCQwWwZ9vfAFLgkbVBHcLYsT
	 nsCIK+ZaIohpY+msyXGe5LZqLq9r6tDdwpjEgW0l6hwAMIYJuKf/ZBhcUiJI18mKO1
	 K8QUxvkXALqEXQ27PTQ8PeKnsy0creMzLh01o65ADUJrAfMgmMwkwGkopjOeFf+c/v
	 RvvBfD19NqoMwCtWC5lcRwLNKIN3kX7HfKC2imxXG8aAVPn/JaRyYNP9B9pjvh1UtL
	 2IFjsoGPhelUcvqgGmarWsd7xxlpeHwKGolKX/yAsi4np0Xq3qREcZNQsDelxwv2VH
	 bP7JMXw3tQJ2g==
Date: Sat, 27 Apr 2024 08:16:52 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, brauner@kernel.org,
	asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 01/10] block: set bip_vcnt correctly
Message-ID: <Zi0I1Aa7mIJ9tOht@kbusch-mbp.mynextlight.net>
References: <20240425183943.6319-1-joshi.k@samsung.com>
 <CGME20240425184651epcas5p3404f2390d6cf05148eb96e1af093e7bc@epcas5p3.samsung.com>
 <20240425183943.6319-2-joshi.k@samsung.com>
 <20240427070214.GA3873@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240427070214.GA3873@lst.de>

On Sat, Apr 27, 2024 at 09:02:14AM +0200, Christoph Hellwig wrote:
> On Fri, Apr 26, 2024 at 12:09:34AM +0530, Kanchan Joshi wrote:
> > From: Anuj Gupta <anuj20.g@samsung.com>
> > 
> > Set the bip_vcnt correctly in bio_integrity_init_user and
> > bio_integrity_copy_user. If the bio gets split at a later point,
> > this value is required to set the right bip_vcnt in the cloned bio.
> > 
> > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Please add a Fixes tag and submit it separately from the features.
> 
> I'm actually kinda surprised the direct user mapping of integrity data
> survived so far without this.

The only existing use case for user metadata is REQ_OP_DRV_IN/OUT, which
never splits, so these initial fixes only really matter after this
series adds new usage for generic READ/WRITE.

