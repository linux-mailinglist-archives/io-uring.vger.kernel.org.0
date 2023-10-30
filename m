Return-Path: <io-uring+bounces-11-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FEC97DC1E0
	for <lists+io-uring@lfdr.de>; Mon, 30 Oct 2023 22:25:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D46E8B20D26
	for <lists+io-uring@lfdr.de>; Mon, 30 Oct 2023 21:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 042451B29C;
	Mon, 30 Oct 2023 21:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPQ2cNx+"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7775199D9
	for <io-uring@vger.kernel.org>; Mon, 30 Oct 2023 21:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAFAC433C8;
	Mon, 30 Oct 2023 21:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698701114;
	bh=hzofDKiGjd6jXy/PnVdRPIXYvHmctTDMe4RQrG3lL0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dPQ2cNx+nf0zldx6hUWvHXnWXeCuEJx441hauvRDRt6MKXThszkTf4gfrU24nSrC0
	 p4X/Fn1v7pt+ROyfx1qK3h1Xoc57kH8H2v7mjdspHNYECqapBIYHd2W2PlZCEVYXd1
	 a4NNOXfbDLuoaU8GNVFEP0VkkMOdVkzZHbZxprwXo03QKG7U7TX4gtI9AuFYwlVIdk
	 2y3+7oa+de7PNNY1moaag5IXcmd4NkY3BUQftK15qsJe7c2dPRhoBjUzoO5UYMH4QJ
	 0Nq7H0uJN0pw62hfnQ/MDPzt4tT0xppeN8rIt1A6a98g8k7nnzaapP1V82PS3q+6zE
	 ds3aYJGO2K5ng==
Date: Mon, 30 Oct 2023 15:25:11 -0600
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com
Subject: Re: [PATCHv2 1/4] block: bio-integrity: directly map user buffers
Message-ID: <ZUAfNzhvp9KGysT2@kbusch-mbp.dhcp.thefacebook.com>
References: <20231027181929.2589937-1-kbusch@meta.com>
 <CGME20231027182017epcas5p1fb1f91bc876d9bc1b1229c012bcd1ea2@epcas5p1.samsung.com>
 <20231027181929.2589937-2-kbusch@meta.com>
 <c3a946f4-b2f8-c800-1573-1f87c9d637d7@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3a946f4-b2f8-c800-1573-1f87c9d637d7@samsung.com>

On Tue, Oct 31, 2023 at 02:32:48AM +0530, Kanchan Joshi wrote:
> On 10/27/2023 11:49 PM, Keith Busch wrote:
> > +
> > +	bip_for_each_vec(bv, bip, iter) {
> > +		if (dirty && !PageCompound(bv.bv_page))
> > +			set_page_dirty_lock(bv.bv_page);
> > +		unpin_user_page(bv.bv_page);
> > +	}
> > +}
> 
> Leak here, page-unpinning loop will not execute for the common (i.e., 
> no-copy) case...
> 
> > +	bip = bio_integrity_alloc(bio, GFP_KERNEL, folios);
> > +	if (IS_ERR(bip)) {
> > +		ret = PTR_ERR(bip);
> > +		goto release_pages;
> > +	}
> > +
> > +	memcpy(bip->bip_vec, bvec, folios * sizeof(*bvec));
> 
> Because with this way of copying, bip->bip_iter.bi_size will remain zero.

Good catch.
 
> Second, is it fine not to have those virt-alignment checks that are done 
> by bvec_gap_to_prev() when the pages are added using 
> bio_integrity_add_page()?

We're mapping a single user buffer. It's guaranteed to be virtually
congiguous, so no gaps.

