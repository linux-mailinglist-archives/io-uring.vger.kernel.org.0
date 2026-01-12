Return-Path: <io-uring+bounces-11584-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E4599D11B62
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 11:06:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8163D300AC42
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 10:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF76F28C037;
	Mon, 12 Jan 2026 10:06:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E36526A0A7;
	Mon, 12 Jan 2026 10:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768212372; cv=none; b=gCHr5clbbO11e3QGOGEbXNCSdr3TXt4Msbqubs9MlU2uS6+Ytz4ZBrEn+UjVNuhKi7EK4exNEfhdqZja4XOA4XY+n7g8RcftQRAz4ibB87vqdSM2+dVjcGORIXCGv/vlZJVEzyuYBkhErFr11rsdA1SC6CzdpaaF847b3OkUMi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768212372; c=relaxed/simple;
	bh=0L66puMBFlXoIMOy/5TP3WD0noDEOHxqIpJ/hhFD0iQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hiVW/VDas2AbTAbDXVmBJpNnzTXNdWGUGMVTrN+mtLmT96XmUYXcwNa145T5SaKhn7CPWKcVBCRd8Tyck6fWSPj1TM/FS0gAYNiz9rdMxNR5NKvySgukP99YftSF914FMRxp0wbaem/LbJjf7L2KwQ+nhBNUoroX+sWiWIVy3/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 09124227A8E; Mon, 12 Jan 2026 11:05:59 +0100 (CET)
Date: Mon, 12 Jan 2026 11:05:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
	David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, io-uring@vger.kernel.org,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: re-enable IOCB_NOWAIT writes to files v4
Message-ID: <20260112100558.GA7670@lst.de>
References: <20251223003756.409543-1-hch@lst.de> <20251224-zusah-emporsteigen-764a9185a0a1@brauner> <20260106062409.GA16998@lst.de> <20260106-bequem-albatros-3c747261974f@brauner> <20260107073247.GA17448@lst.de> <20260112-adelstitel-propaganda-ef80e3d2f8ca@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112-adelstitel-propaganda-ef80e3d2f8ca@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 12, 2026 at 11:04:17AM +0100, Christian Brauner wrote:
> On Wed, Jan 07, 2026 at 08:32:47AM +0100, Christoph Hellwig wrote:
> > On Tue, Jan 06, 2026 at 10:43:49PM +0100, Christian Brauner wrote:
> > > > Umm, as in my self reply just before heading out for vacation, Julia
> > > > found issues in it using static type checking tools.  I have a new
> > > > version that fixes that and sorts out the S_* mess.  So please drop
> > > > it again for now, I'll resend the fixed version ASAP.
> > > 
> > > It has never been pushed nor applied as I saw your mail right before all
> > > of that.
> > 
> > Thanks.  But maybe you can fix up the applied messages to be more
> > specific?  We had various issues in the past with them, where they
> > were sent, but things did not end up in the tree for various reasons.
> 
> What are you thinking of exactly?

Only send out the applied message when something is actually pushed
to the public tree?

