Return-Path: <io-uring+bounces-4223-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B473D9B6ACD
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 790A628191E
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 17:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FDA21FD85;
	Wed, 30 Oct 2024 17:15:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A225121FD96;
	Wed, 30 Oct 2024 17:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730308546; cv=none; b=K8BiHQulna1McL1u469v0eMCVFzekqXRODdc8iiUlxdqK+R0SaMYd5L1BaFST5lU7cOXVzz7+cN5Zi0wUqMf4/US/IVBhzGicwakNPRelaOt15fGNO0AnxM+DXdhvqYhLbMvuiftdQlqdlgnOn8pEfpQmPph6cXhl13Yv8LJehM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730308546; c=relaxed/simple;
	bh=IJdnnD1uUE0ZHuFk2kqH8UbU4rUPWlzafuUOmtVe4PE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nslbTf9kjDtXoKcRlHVfNvuDNoxFSFRJhCkh46OO1zeQVCTAB5rnU58nO22fmZIjoGL2nL1/o26q//U5ezLrWy5GT/vccpN9fSwVhtARWmPi8c0vsXQh6SBUfpu/15fFAJVXXNeFShTAHQ4PDeM+wNQfJBnnMnNqYWiaRIoErp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B10FB227A8E; Wed, 30 Oct 2024 18:15:41 +0100 (CET)
Date: Wed, 30 Oct 2024 18:15:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <20241030171541.GB12580@lst.de>
References: <20241029155330.GA27856@lst.de> <ZyEL4FOBMr4H8DGM@kbusch-mbp> <20241030045526.GA32385@lst.de> <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com> <20241030154556.GA4449@lst.de> <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com> <20241030155052.GA4984@lst.de> <ZyJiEwZwjevelmW2@kbusch-mbp.dhcp.thefacebook.com> <20241030165708.GA11009@lst.de> <ZyJnPwqIufrcMkFg@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyJnPwqIufrcMkFg@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 30, 2024 at 11:05:03AM -0600, Keith Busch wrote:
> On Wed, Oct 30, 2024 at 05:57:08PM +0100, Christoph Hellwig wrote:
> > And once it uses by default, taking it away will have someone scream
> > regresion, because we're not taking it away form that super special
> > use case.
> 
> Refusing to allow something because someone might find it useful has got
> to be the worst reasoning I've heard. :)

That's not that point.  The point is by locking us in we can't actually
do the proper thing.  And that's what I'm really worried about.
Especially with the not all that great numbers in the success story.

