Return-Path: <io-uring+bounces-4187-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 044D99B5AE9
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 05:55:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4C001F247F6
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 04:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E642D193063;
	Wed, 30 Oct 2024 04:55:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B72682899;
	Wed, 30 Oct 2024 04:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730264132; cv=none; b=HsdrQvlXaE9i5tqNBjQ48mCMunt0x5M2R/1DPYeO6Mx/SfbgUO3fVzWUXH/0JWdYqNC8Dvt1fKyY/MwM8JjoczOA6NOqvW0EgpQTdPt7y09/KTDidE2kbFCksJla/3V8yY7uJY1j/jx0utRzMX+qdy1wpdk09XxnOIRu+xOMx6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730264132; c=relaxed/simple;
	bh=+yEj88EyYnXmjD78HRAS31cGQ57Fw4vx63oq6eLlUrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XVyUlGOuA/61yuYa/xhdYlRfzZBaTvCJC2naOnfDX4XQLZpLcjh2dCCQrSfo3W53un7/FmxmmHAz09Za4h1b0gNp+ZetFHl0N/fJYXxB7DxS4pFms67ROKPRGmqRvtN79I3IuS4s7p72Gtr1l9a6y0gYmE19d9MMeP0IV1fBCtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 55591227A8E; Wed, 30 Oct 2024 05:55:26 +0100 (CET)
Date: Wed, 30 Oct 2024 05:55:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <20241030045526.GA32385@lst.de>
References: <20241029151922.459139-1-kbusch@meta.com> <20241029151922.459139-10-kbusch@meta.com> <20241029152654.GC26431@lst.de> <ZyEAb-zgvBlzZiaQ@kbusch-mbp> <20241029153702.GA27545@lst.de> <ZyEBhOoDHKJs4EEY@kbusch-mbp> <20241029155330.GA27856@lst.de> <ZyEL4FOBMr4H8DGM@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyEL4FOBMr4H8DGM@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 29, 2024 at 10:22:56AM -0600, Keith Busch wrote:
> On Tue, Oct 29, 2024 at 04:53:30PM +0100, Christoph Hellwig wrote:
> > On Tue, Oct 29, 2024 at 09:38:44AM -0600, Keith Busch wrote:
> > > They're not exposed as write streams. Patch 7/9 sets the feature if it
> > > is a placement id or not, and only nvme sets it, so scsi's attributes
> > > are not claiming to be a write stream.
> > 
> > So it shows up in sysfs, but:
> > 
> >  - queue_max_write_hints (which really should be queue_max_write_streams)
> >    still picks it up, and from there the statx interface
> > 
> >  - per-inode fcntl hint that encode a temperature still magically
> >    get dumpted into the write streams if they are set.
> > 
> > In other words it's a really leaky half-backed abstraction.
> 
> Exactly why I asked last time: "who uses it and how do you want them to
> use it" :)

For the temperature hints the only public user I known is rocksdb, and
that only started working when Hans fixed a brown paperbag bug in the
rocksdb code a while ago.  Given that f2fs interprets the hints I suspect
something in the Android world does as well, maybe Bart knows more.

For the separate write streams the usage I want for them is poor mans
zones - e.g. write N LBAs sequentially into a separate write streams
and then eventually discard them together.  This will fit nicely into
f2fs and the pending xfs work as well as quite a few userspace storage
systems.  For that the file system or application needs to query
the number of available write streams (and in the bitmap world their
numbers of they are distontigous) and the size your can fit into the
"reclaim unit" in FDP terms.  I've not been bothering you much with
the latter as it is an easy retrofit once the I/O path bits lands.

> > Let's brainstorm how it could be done better:
> > 
> >  - the max_write_streams values only set by block devices that actually
> >    do support write streams, and not the fire and forget temperature
> >    hints.  They way this is queried is by having a non-zero value
> >    there, not need for an extra flag.
> 
> So we need a completely different attribute for SCSI's permanent write
> streams? You'd mentioned earlier you were okay with having SCSI be able
> to utilized per-io raw block write hints. Having multiple things to
> check for what are all just write classifiers seems unnecessarily
> complicated.

I don't think the multiple write streams interface applies to SCSIs
write streams, as they enforce a relative temperature, and they don't
have the concept of how much you can write into an "reclaim unit".

OTOH there isn't much you need to query for them anyway, as the
temperature hints have always been defined as pure hints with all
up and downsides of that.

> No need to create a new fcntl. The people already testing this are
> successfully using FDP with the existing fcntl hints. Their applications
> leverage FDP as way to separate files based on expected lifetime. It is
> how they want to use it and it is working above expectations. 

FYI, I think it's always fine and easy to map the temperature hits to
write streams if that's all the driver offers.  It loses a lot of the
capapilities, but as long as it doesn't enforce a lower level interface
that never exposes more that's fine.


