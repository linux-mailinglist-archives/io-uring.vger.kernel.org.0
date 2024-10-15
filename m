Return-Path: <io-uring+bounces-3694-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C2099F0F8
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 17:23:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 433BDB21FD5
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 15:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9F81CB9FE;
	Tue, 15 Oct 2024 15:23:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C1C14A60D;
	Tue, 15 Oct 2024 15:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729005785; cv=none; b=HXbACI3jqcddBDMe6L/Lg1KhquSweiPZmOpVdP+wnf7Gg51+woRpW8Yp2G2cSJ0sepwQnswbMCZkYfAWVplu3JTXS+/OrY2jabHe2OQPqL06q/GH6lL+mJFgpaBBdbO8KQFub2yO77EZAg1p6/6WCidvyl8fTGrGSz9oDHMv7xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729005785; c=relaxed/simple;
	bh=d/mpKjOkPFHF3RsVNhFtMJtwsuxvwnWzNiucqgr8Kg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfL1GhW9pu+wp6uFEdv/TkToH1n1RaaEFN43KZ0TxmjhL4jdTOILrwsBz9FG9uP605oZzmQ4RofwXg6uETkBSWr0Ow/cFP5mLpuDVws9pSVg+51OnLrGtQrTrQJFEJDNnzmbdCSm1k90hQHBwSMusLwVtCYUs1qNqV5Glkw53BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1AA12227A8E; Tue, 15 Oct 2024 17:22:58 +0200 (CEST)
Date: Tue, 15 Oct 2024 17:22:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	axboe@kernel.dk, hare@suse.de, sagi@grimberg.me,
	martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241015152257.GA12898@lst.de>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com> <20240930181305.17286-1-joshi.k@samsung.com> <20241015055006.GA18759@lst.de> <Zw6FoPCEJ0-rARGT@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw6FoPCEJ0-rARGT@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 15, 2024 at 09:09:20AM -0600, Keith Busch wrote:
> On Tue, Oct 15, 2024 at 07:50:06AM +0200, Christoph Hellwig wrote:
> > 1) While the current per-file temperature hints interface is not perfect
> > it is okay and make sense to reuse until we need something more fancy.
> > We make good use of it in f2fs and the upcoming zoned xfs code to help
> > with data placement and have numbers to show that it helps.
> 
> So we're okay to proceed with patch 1?

No, see point 3 and 4 below for why.  We'll need something like the
interface you suggested by me in point 4 and by you in reply to point 3
in the block layer, and then block/fops.c can implement the mapping on
top of that for drivers supporting it.

>  
> > 2) A per-I/O interface to set these temperature hint conflicts badly
> > with how placement works in file systems.  If we have an urgent need
> > for it on the block device it needs to be opt-in by the file operations
> > so it can be enabled on block device, but not on file systems by
> > default.  This way you can implement it for block device, but not
> > provide it on file systems by default.  If a given file system finds
> > a way to implement it it can still opt into implementing it of course.
> 
> If we add a new fop_flag that only block fops enables, then it's okay?

The flag is just one part of it.  Of course it need to be discoverable
from userspace in one way or another, and the marshalling of the flag
needs to be controller by the file system / fops instance.

> > 3) Mapping from temperature hints to separate write streams needs to
> > happen above the block layer, because file systems need to be in
> > control of it to do intelligent placement.  That means if you want to
> > map from temperature hints to stream separation it needs to be
> > implemented at the file operation layer, not in the device driver.
> > The mapping implemented in this series is probably only useful for
> > block devices.  Maybe if dumb file systems want to adopt it, it could
> > be split into library code for reuse, but as usual that's probably
> > best done only when actually needed.
> 
> IMO, I don't even think the io_uring per-io hint needs to be limited to
> the fcntl lifetime values. It could just be a u16 value opaque to the
> block layer that just gets forwarded to the device.

Well, that's what I've been arguing for all the time, and what Kanchan's
previous series was working towards.  It's not quite as trivial as
we need a bit more than just the stream, e.g. a way to discover how many
of them exist.

> > 4) To support this the block layer, that is bios and requests need
> > to support a notion of stream separation.   Kanchan's previous series
> > had most of the bits for that, it just needs to be iterated on.
> > 
> > All of this could have probably be easily done in the time spent on
> > this discussion.
---end quoted text---

