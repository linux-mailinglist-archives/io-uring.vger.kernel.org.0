Return-Path: <io-uring+bounces-1674-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE5A8B5FBA
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 19:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC9BDB2105C
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 17:11:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BEB586643;
	Mon, 29 Apr 2024 17:11:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8158183CBA;
	Mon, 29 Apr 2024 17:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410679; cv=none; b=tQYEOA7ZdGJFHY7W2ImSF14zhlXt/mFuDg0T9Mx62CRxCHIJ3FXf769BSgMBPjNt35L2eemseYFEZgnf9YU3ciLal+/mirUfMzKVdfwZcrZccEtQWToeAc/Jkb7hSoyuQe1Il0lGahlns0jeqn7UkQEYlW+22kzeli/t3thqLc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410679; c=relaxed/simple;
	bh=YnYryjOKk81ylgIJ6YJomPMX/ilCcxC6RAJ1L1BQbHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qwz0EOh3xwdMn+0+MnTCvVCom+ZwB64FPcxOWv9nVekMxJZP43re40M+X8ajKQUhnqueJSy/N9XR6bJ2RDoPU/1v3R3vuXeN/Eljq15JqCv2jT8Hr2B5vcPHvS25JWsNHOf5FkdPxsC+p/ZCwqx1DNZtxSxiHt4NFRPPwt3rCXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 97297227A87; Mon, 29 Apr 2024 19:11:13 +0200 (CEST)
Date: Mon, 29 Apr 2024 19:11:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	martin.petersen@oracle.com, kbusch@kernel.org, brauner@kernel.org,
	asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 05/10] block, nvme: modify rq_integrity_vec function
Message-ID: <20240429171113.GC31337@lst.de>
References: <20240425183943.6319-1-joshi.k@samsung.com> <CGME20240425184700epcas5p1687590f7e4a3f3c3620ac27af514f0ca@epcas5p1.samsung.com> <20240425183943.6319-6-joshi.k@samsung.com> <20240427071834.GE3873@lst.de> <56f3d65b-5dda-f5fc-68c2-ab9cf368f066@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56f3d65b-5dda-f5fc-68c2-ab9cf368f066@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 29, 2024 at 05:04:30PM +0530, Kanchan Joshi wrote:
> >> +	return (struct bio_vec){0};
> > 
> > No need for the 0 here.
>   Um, I did not follow. Need that to keep the compiler happy.
> Do you suggest to change the prototype.

Just removing the NULL as in:

	return (struct bio_vec){ };

compiles just fine here, and at least for non-anonymous struct
initializers we use it all the time.

