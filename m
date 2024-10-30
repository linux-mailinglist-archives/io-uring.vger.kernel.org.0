Return-Path: <io-uring+bounces-4212-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC7019B6854
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 16:51:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76BC31F226FE
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 15:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C36213ED7;
	Wed, 30 Oct 2024 15:50:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5F421314E;
	Wed, 30 Oct 2024 15:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730303459; cv=none; b=GToA271fLr5g8zxY5T3yU5R3QPYTMwjBKeEyQWZSguOttfl0crGnRQRNfsCS7VYiDtjwhPQBq0EY+P/VqPLuGbx6xZPCJdgOUuwL7W+/zXry5P9uMTaaLnpEp52xXztFGpRVAx/R/C08X5ZJnafaxLvRLw4UK2sK4ufDhtWa2zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730303459; c=relaxed/simple;
	bh=i/yskWZG3tPBNCcc+unIbOGUox6fgz9VbRLdWCDEIpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BdinDUa2WFbFp6bbdJAl/p03H0e9sesQuTBPqUMI9+ZWw4PayAhJo141FSm0ZmKw+S4wRt8GoYVhGZVp/UioqH6UyTjLRMUBBqnhg9UkxT5bHAcCaUnuXGP0YtwaQ7GS+Ca95CvPMpvd3FSldTDaYj0tQBOHXwmwdiM3YAdI79I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B5DD5227A8E; Wed, 30 Oct 2024 16:50:52 +0100 (CET)
Date: Wed, 30 Oct 2024 16:50:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <20241030155052.GA4984@lst.de>
References: <20241029152654.GC26431@lst.de> <ZyEAb-zgvBlzZiaQ@kbusch-mbp> <20241029153702.GA27545@lst.de> <ZyEBhOoDHKJs4EEY@kbusch-mbp> <20241029155330.GA27856@lst.de> <ZyEL4FOBMr4H8DGM@kbusch-mbp> <20241030045526.GA32385@lst.de> <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com> <20241030154556.GA4449@lst.de> <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 30, 2024 at 09:48:39AM -0600, Keith Busch wrote:
> What??? You said to map the temperature hints to a write stream. The
> driver offers that here. But you specifically don't want that? I'm so
> confused.

In bdev/fops.c (or file systems if they want to do that) not down in the
driver forced down everyones throat.  Which was the whole point of the
discussion that we're running in circles here.

> > with no way to make actually useful use of the stream separation.
> 
> Have you tried it? The people who actually do easily demonstrate it is
> in fact very useful.

While I've read the claim multiple times, I've not actually seen any
numbers.

