Return-Path: <io-uring+bounces-3890-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B68389A9927
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 08:03:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7717E284F5E
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 06:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C2313AD2A;
	Tue, 22 Oct 2024 06:02:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E24D13B592;
	Tue, 22 Oct 2024 06:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576960; cv=none; b=mz8mFL/tCfLpKJ3KrRT87EmHWQ2KvxDfyPviqfZ67J7yYROkSq8wbBlVnUCsVDM2SknrBwrC0lydN7VCvc8HE/D8kRM1dOcTmNxmJPcnO53h3QRcvWK+EpSo/XqXdBmBBQWSC8sgRCWfZ2xeJ2U4nz7FC50aauB9tpRsvmCmvh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576960; c=relaxed/simple;
	bh=n5VQAtqdEOh1UvMkBAgosNvfEzTu2meF2z8LNGkYtPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FsvjJG6sScUFxrVCltl7Ad/JvOZGP743pHXPq7ZZIy3Zo4EHul9Rc2UoqRC9tNG/CWJ7lfsYiB9Kxe2cU1vn20t4Qu/NMH7786PqLPdhbXIpffZEOZU2sob4LLA0xB2v2iXyUPeFwHdpc5IpDwYf8ktcAaomvcDTSINQztLIiz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B7BD0227AA8; Tue, 22 Oct 2024 08:02:33 +0200 (CEST)
Date: Tue, 22 Oct 2024 08:02:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v4 07/11] io_uring/rw: add support to send meta along
 with read/write
Message-ID: <20241022060233.GA10327@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113747epcas5p4e276eb0da2695ba032ce1d2a3b83fff4@epcas5p4.samsung.com> <20241016112912.63542-8-anuj20.g@samsung.com> <20241017081057.GA27241@lst.de> <20241021053110.GA2720@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241021053110.GA2720@green245>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 21, 2024 at 11:01:10AM +0530, Anuj Gupta wrote:
> > What is the meta_type for?  To distintinguish PI from non-PI metadata?
> 
> meta_type field is kept so that meta_types beyond integrity can also
> be supported in future. Pavel suggested this to Kanchan when this was
> discussed in LSF/MM.
> 
> > Why doesn't this support non-PI metadata?
> 
> It supports that. We have tested that (pi_type = 0 case).

What other metadata except for PI and plain non-integrity data
do you plan to support?  This seems like a weird field.  In doubt
just leave reserved space that is checked for 0 instead of adding
an encondig that doesn't make much sense.  If we actually do end
up with a metadata scheme we can't encode into the pi_type we can
still use that reserved space.

> 
> > Also PI or TO_PI might be
> > a better name than the rather generic integrity.  (but I'll defer to
> > Martin if he has any good arguments for naming here).
> 
> Open to a different/better name.

metadata?

> > > +	/* Exclude meta IO as we don't support partial completion for that */
> > >  	return req->flags & REQ_F_ISREG ||
> > > -		S_ISBLK(file_inode(req->file)->i_mode);
> > > +		S_ISBLK(file_inode(req->file)->i_mode) ||
> > > +		!(rw->kiocb.ki_flags & IOCB_HAS_METADATA);
> > >  }
> > 
> > What partial ocmpletions aren't supported?  Note that this would
> > trigger easily as right now metadata is only added for block devices
> > anyway.
> 
> It seems that this scenario is less likely to happen. The plumbing
> seemed a bit non trivial. I have the plan to look at it, once the
> initial version of this series goes in.

I still don't understand what this is trying to do, especially as
it is dead code with the checks above.

> > 
> > > +	if (unlikely(kiocb->ki_flags & IOCB_HAS_METADATA)) {
> > 
> > For a workload using metadata this is everything but unlikely.  Is
> > there a specific reason you're trying to override the existing
> > branch predictor here (although on at least x86_64 gcc these kinds
> > of unlikely calls tend to be no-ops anyway).
> 
> The branch predictions were added to make it a bit friendly for
> non-metadata read/write case. 

Throwing in these hints unless you have numbers justifying them is not
a good idea.


