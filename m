Return-Path: <io-uring+bounces-1673-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69F7D8B5FB2
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 19:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 194BA1F253F0
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 17:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12AAD47A5C;
	Mon, 29 Apr 2024 17:09:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252F483CBA;
	Mon, 29 Apr 2024 17:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410576; cv=none; b=P3HrQfnDIOR6a6WQUS1eMF0hf7JNl51NNMSXbiiFqGWSZuMYJe5VwQLg/CXcS8YyFIC7ksT4sOPVvgs+9QeU5vMiby6TqxTTdCHRPhtm4JRKsTcHKye/Q8SCOTddJeanwG0xjyta48DxB91QnehXwwiNqAPtYQZamPMymUi7q9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410576; c=relaxed/simple;
	bh=TF9NcPCZiSVrfrSW6ZL/GeKMxvf+YDtHyr9A0ksj3YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ao9N8tCavGtuh1V262yCpRCLf8bmoGp3I+cCpYydyE5vuvkfMkVOgSLpvyvhf9ui++jnuDyBTvvGLtARmsOWVScgeIsXmkRZ6FVJv6s72gmZINBpwBHtzNJ+oJhUYSQ8bOZ/SK7HZJNSFn7ztABimePf8exxZb/AO2UHqBRWaY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A34F1227A87; Mon, 29 Apr 2024 19:09:29 +0200 (CEST)
Date: Mon, 29 Apr 2024 19:09:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	martin.petersen@oracle.com, kbusch@kernel.org, brauner@kernel.org,
	asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 04/10] block: avoid unpinning/freeing the bio_vec
 incase of cloned bio
Message-ID: <20240429170929.GB31337@lst.de>
References: <20240425183943.6319-1-joshi.k@samsung.com> <CGME20240425184658epcas5p2adb6bf01a5c56ffaac3a55ab57afaf8e@epcas5p2.samsung.com> <20240425183943.6319-5-joshi.k@samsung.com> <20240427070508.GD3873@lst.de> <03cb6ac3-595f-abb1-324b-647ed84cfe6b@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03cb6ac3-595f-abb1-324b-647ed84cfe6b@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 29, 2024 at 05:10:59PM +0530, Kanchan Joshi wrote:
> > This feels wrong.  I suspect the problem is that BIP_COPY_USER is
> > inherited for clone bios while it shouldn't.
> > 
> 
> But BIP_COPY_USER flag is really required in the clone bio. So that we 
> can copy the subset of the metadata back (from kernel bounce buffer to 
> user space pinned buffer) in case of read io.
> 
> Overall, copy-back will happen in installments (for each cloned bio), 
> while the unpin will happen in one shot (for the source bio).

That seems a bit odd compared to the bio data path.  If you think this
is better than the version used in the data path let's convert the
data path to this scheme first to make sure we don't diverge and get
the far better testing on the main data map side.

