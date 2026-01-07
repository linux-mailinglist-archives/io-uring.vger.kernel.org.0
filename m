Return-Path: <io-uring+bounces-11430-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8833FCFC663
	for <lists+io-uring@lfdr.de>; Wed, 07 Jan 2026 08:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E1A593038057
	for <lists+io-uring@lfdr.de>; Wed,  7 Jan 2026 07:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F84225A35;
	Wed,  7 Jan 2026 07:33:01 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5721623C503;
	Wed,  7 Jan 2026 07:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767771181; cv=none; b=myCKkJggibEIMvcFChMtSk2EYM5Fk3VPbmQsioduYB/mv97ozhqQjDyyoXNpDtbPJUXH7w7he7jZ2Rv9ynkI1Bqmx8F1KJAMQ9js6SJ2ITiyXhjX1RX6y4IZrRxqofI9c3CYRyCF4zlM1Cn1C9a1f2zNC4hOUq8WoEcoVHslT50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767771181; c=relaxed/simple;
	bh=rcNkEg2r6U/yIEY7iukyvq5YvWXgri4jOz/NbgAd+eQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XD96N1iSOlTNICVDR5nAClgzhqfeA8RH1rPha7vXOEaPgALcBjHlinW+CEnloA2T6DGcS6DMAjftPeuwsvmomagw6VvCuZOojmUWBVZeedeRi/HmjlV2EtwZH0+p0+O+LpN8f7RSAT9h0ljwiW8wGmWG56azkTieYRfxKZioA0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C876467373; Wed,  7 Jan 2026 08:32:47 +0100 (CET)
Date: Wed, 7 Jan 2026 08:32:47 +0100
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
Message-ID: <20260107073247.GA17448@lst.de>
References: <20251223003756.409543-1-hch@lst.de> <20251224-zusah-emporsteigen-764a9185a0a1@brauner> <20260106062409.GA16998@lst.de> <20260106-bequem-albatros-3c747261974f@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106-bequem-albatros-3c747261974f@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 06, 2026 at 10:43:49PM +0100, Christian Brauner wrote:
> > Umm, as in my self reply just before heading out for vacation, Julia
> > found issues in it using static type checking tools.  I have a new
> > version that fixes that and sorts out the S_* mess.  So please drop
> > it again for now, I'll resend the fixed version ASAP.
> 
> It has never been pushed nor applied as I saw your mail right before all
> of that.

Thanks.  But maybe you can fix up the applied messages to be more
specific?  We had various issues in the past with them, where they
were sent, but things did not end up in the tree for various reasons.

