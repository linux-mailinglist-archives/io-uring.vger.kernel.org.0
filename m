Return-Path: <io-uring+bounces-8-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D916A7DBC22
	for <lists+io-uring@lfdr.de>; Mon, 30 Oct 2023 15:54:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6ACADB20C49
	for <lists+io-uring@lfdr.de>; Mon, 30 Oct 2023 14:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABE04179AF;
	Mon, 30 Oct 2023 14:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="arfIcr1P"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BFE6AB7
	for <io-uring@vger.kernel.org>; Mon, 30 Oct 2023 14:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF88C433C8;
	Mon, 30 Oct 2023 14:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698677650;
	bh=IGxZ3WXFE2g5LtHStC1maMx/25lkQzHmz4Iz8FrsjIo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=arfIcr1PLhx/XBZRkqc8eMahg/eKkqQyCDFGPdP6in7tfw5XcRfMMl8bfFUk2FOj1
	 h8JVbT0koyb35oGfarOrJkvw2R6sMStxMzsy3ogdG41x2Q92IXU1HTdw7HgdM5nmeu
	 wRp5iGcfJA55otgY73SSniYNAUCI8z6xnTR2lgiBYMv69zkQnT9G0Y7aXWoFJbmk0/
	 gfOgUAEaBwQe90fG1ty89wyGgbw4M88i5rCaAikuwtuxNsQqvLwVD/a/VsNoQMdRtV
	 iX73Ao8pJP8YCJ2ZMZ2bdw6vDlHRKSaTkzAz+QnrvivIR6FRgbZAGd3v853YOXXlHR
	 39FuqgD23s7/Q==
Date: Mon, 30 Oct 2023 08:54:07 -0600
From: Keith Busch <kbusch@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, hch@lst.de, joshi.k@samsung.com,
	martin.petersen@oracle.com
Subject: Re: [PATCHv2 1/4] block: bio-integrity: directly map user buffers
Message-ID: <ZT_Dj9Df07bCntQQ@kbusch-mbp.dhcp.thefacebook.com>
References: <20231027181929.2589937-1-kbusch@meta.com>
 <20231027181929.2589937-2-kbusch@meta.com>
 <CGME20231030144050eucas1p12ede963088687846d9b02a27d7da525e@eucas1p1.samsung.com>
 <20231030144047.yrwejvdyyi4vo62m@localhost>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231030144047.yrwejvdyyi4vo62m@localhost>

On Mon, Oct 30, 2023 at 03:40:47PM +0100, Pankaj Raghav wrote:
> > +	int ret;
> > +
> > +	/* if bvec is on the stack, we need to allocate a copy for the completion */
> > +	if (nr_vecs <= UIO_FASTIOV) {
> > +		copy_vec = kcalloc(sizeof(*bvec), nr_vecs, GFP_KERNEL);
> > +		if (!copy_vec)
> > +			return -ENOMEM;
> > +		memcpy(copy_vec, bvec, nr_vecs * sizeof(*bvec));
> > +	}
> > +
> > +	buf = kmalloc(len, GFP_KERNEL);
> > +	if (!buf)
> > +		goto free_copy;
> 
> ret is not set to -ENOMEM here.

Indeed, thanks for pointing that out. I'll wait a bit longer before
posting a v3.

