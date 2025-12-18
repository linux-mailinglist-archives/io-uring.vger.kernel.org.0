Return-Path: <io-uring+bounces-11177-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 785AACCA6A9
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 07:13:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 429403016CC3
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 06:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6109C2D7D41;
	Thu, 18 Dec 2025 06:13:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E6331064A;
	Thu, 18 Dec 2025 06:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766038406; cv=none; b=S6z4KtidsSbGTwiuhX/Xx7ebcXKPCO/MMV3CEZVBh7vckMzX5srM0aOsisBiPmq6khIus1q/su2LNIZS6vKb0VtGBypIqg/Wp3jaoi36Q1uNBnYnCnfJ+j/GnE6kcmpQM6/YxpvMXsROyO8JmGp5hJE6gCqGn6/GKkw7HWnAkGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766038406; c=relaxed/simple;
	bh=ZBYUW2in9iDytsK8dgp3TVcKqNV9Uzw5cFn++gKN9gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=utHtM6b62jquGsWm+1BwtCC7vgId7eN5rL4rwGVCjjmi/HIdTYlbqStrIF39UEqIwjtXO1Zi5Y7w0sYp/+VVBhsIKSjv1+MkTtei+IjBBfmYUxO18I5Bc7XF+/+6nWHTl8pYJMkN7SrQI2pHGMCm1E6x0x/gO22B67iFhvwnpeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 41DC7227A88; Thu, 18 Dec 2025 07:13:18 +0100 (CET)
Date: Thu, 18 Dec 2025 07:13:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, io-uring@vger.kernel.org,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 07/10] fs: add a ->sync_lazytime method
Message-ID: <20251218061317.GA2775@lst.de>
References: <20251217061015.923954-1-hch@lst.de> <20251217061015.923954-8-hch@lst.de> <ghtgokkzdo7owrkfkpittqlc6xvjhr5w4eprbq5gcszqpmy7z3@7m3ecvlqfrzu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ghtgokkzdo7owrkfkpittqlc6xvjhr5w4eprbq5gcszqpmy7z3@7m3ecvlqfrzu>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 17, 2025 at 01:30:18PM +0100, Jan Kara wrote:
> >  	if (flags & I_DIRTY_INODE) {
> > +		bool was_dirty_time =
> > +			inode_state_read_once(inode) & I_DIRTY_TIME;
> > +
> >  		/*
> >  		 * Inode timestamp update will piggback on this dirtying.
> >  		 * We tell ->dirty_inode callback that timestamps need to
> >  		 * be updated by setting I_DIRTY_TIME in flags.
> >  		 */
> > -		if (inode_state_read_once(inode) & I_DIRTY_TIME) {
> > +		if (was_dirty_time) {
> >  			spin_lock(&inode->i_lock);
> >  			if (inode_state_read(inode) & I_DIRTY_TIME) {
> >  				inode_state_clear(inode, I_DIRTY_TIME);
> >  				flags |= I_DIRTY_TIME;
> > +				was_dirty_time = true;
> 
> This looks bogus. was_dirty_time is already true here. What I think you
> wanted here is to set it to false if locked I_DIRTY_TIME check failed.
> Otherwise the patch looks good.

Or better set it to false at initialization time and only set it to
true here to simply things a bit.  But otherwise: yes.

