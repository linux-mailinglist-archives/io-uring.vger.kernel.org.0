Return-Path: <io-uring+bounces-1393-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46A50898C82
	for <lists+io-uring@lfdr.de>; Thu,  4 Apr 2024 18:48:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F064E28269A
	for <lists+io-uring@lfdr.de>; Thu,  4 Apr 2024 16:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 650251F944;
	Thu,  4 Apr 2024 16:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mZVvZ5Qt"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CFE1C6A5;
	Thu,  4 Apr 2024 16:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712249327; cv=none; b=fTfPXjgtTs8ZqZFLuF/qb61Dnf3nGehB6sFWZa0CtK9znNpO3TPOYCgaATl0e/A6yhL8UDfD7xJ5emXynPnEQlc/6av1x5my8qB4p2G23HsZ5ancVftxTgUkXht+xO781iIGagv25BoagP77uAykj5OyyoJIL3Zi8o/FYOFgYwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712249327; c=relaxed/simple;
	bh=FItxQKIKnB6xDpTy4OuJ7+aJw2KPqlzMNdwMCbAlF6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pfb4GXbGLAP+qyUJNa2wieeOPLptd8Z4YYw3zuZgD7n29dHChK1SW3jjPGbo8yGq6W/aJKHm0EITRFQIPE9UmmeYGU8JZZxmFdVCFdlkviCaQ7cNpkxNcLVmO0af8wPyYfCtwQYBtbvQEu7sNwsYXWa8PyhH86W1wRxM4iu+zCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mZVvZ5Qt; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IAcMzbwzMSdGjUZJwsigBkmbiIdxzP3w50+Ad4sa5UQ=; b=mZVvZ5QtSrlprrhnUVhWEWIU7E
	sphdhQo7g/IJfa+/FvwlZsRFYmJ5wkNkd4AWif4Utjy+vMZEnwOad5hHf+SRbN7FGKw+i0FGqJBM4
	yF2PaxBkNGMpqYBfoujAS+qFScyAlz3vNlovdCRtdSYfHINucazB4MwtfIsMPo5qEa0NQKwlFZIUA
	VfRN+/hUWdkFBdAGtszp5axo9ZNsq2cyjqNAFaNh3mFRGcmLETrtGXGf3qXwEZGqMoZx63OmbHyON
	JugVn8XGevOpUa3bOez65lUMoibZGmnJJ93pBOBTs99hw8DRim6xKVB8Vqfk/oU+BU912iDFwt/nX
	hMyfZDfA==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rsQGP-00000008SrU-2u2m;
	Thu, 04 Apr 2024 16:48:33 +0000
Date: Thu, 4 Apr 2024 17:48:33 +0100
From: Matthew Wilcox <willy@infradead.org>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com
Subject: Re: [PATCH v6 00/10] block atomic writes
Message-ID: <Zg7Z4aJtn3SxY5w1@casper.infradead.org>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
 <c4c0dad5-41a4-44b4-8f40-2a250571180b@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4c0dad5-41a4-44b4-8f40-2a250571180b@oracle.com>

On Wed, Mar 27, 2024 at 01:37:41PM +0000, John Garry wrote:
> On 27/03/2024 03:50, Matthew Wilcox wrote:
> > On Tue, Mar 26, 2024 at 01:38:03PM +0000, John Garry wrote:
> > > The goal here is to provide an interface that allows applications use
> > > application-specific block sizes larger than logical block size
> > > reported by the storage device or larger than filesystem block size as
> > > reported by stat().
> > > 
> > > With this new interface, application blocks will never be torn or
> > > fractured when written. For a power fail, for each individual application
> > > block, all or none of the data to be written. A racing atomic write and
> > > read will mean that the read sees all the old data or all the new data,
> > > but never a mix of old and new.
> > > 
> > > Three new fields are added to struct statx - atomic_write_unit_min,
> > > atomic_write_unit_max, and atomic_write_segments_max. For each atomic
> > > individual write, the total length of a write must be a between
> > > atomic_write_unit_min and atomic_write_unit_max, inclusive, and a
> > > power-of-2. The write must also be at a natural offset in the file
> > > wrt the write length. For pwritev2, iovcnt is limited by
> > > atomic_write_segments_max.
> > > 
> > > There has been some discussion on supporting buffered IO and whether the
> > > API is suitable, like:
> > > https://lore.kernel.org/linux-nvme/ZeembVG-ygFal6Eb@casper.infradead.org/
> > > 
> > > Specifically the concern is that supporting a range of sizes of atomic IO
> > > in the pagecache is complex to support. For this, my idea is that FSes can
> > > fix atomic_write_unit_min and atomic_write_unit_max at the same size, the
> > > extent alignment size, which should be easier to support. We may need to
> > > implement O_ATOMIC to avoid mixing atomic and non-atomic IOs for this. I
> > > have no proposed solution for atomic write buffered IO for bdev file
> > > operations, but I know of no requirement for this.
> > 
> > The thing is that there's no requirement for an interface as complex as
> > the one you're proposing here.  I've talked to a few database people
> > and all they want is to increase the untorn write boundary from "one
> > disc block" to one database block, typically 8kB or 16kB.
> > 
> > So they would be quite happy with a much simpler interface where they
> > set the inode block size at inode creation time,
> 
> We want to support untorn writes for bdev file operations - how can we set
> the inode block size there? Currently it is based on logical block size.

ioctl(BLKBSZSET), I guess?  That currently limits to PAGE_SIZE, but I
think we can remove that limitation with the bs>PS patches.

> > and then all writes to
> > that inode were guaranteed to be untorn.  This would also be simpler to
> > implement for buffered writes.
> 
> We did consider that. Won't that lead to the possibility of breaking
> existing applications which want to do regular unaligned writes to these
> files? We do know that mysql/innodb does have some "compressed" mode of
> operation, which involves regular writes to the same file which wants untorn
> writes.

If you're talking about "regular unaligned buffered writes", then that
won't break.  If you cross a folio boundary, the result may be torn,
but if you're crossing a block boundary you expect that.

> Furthermore, untorn writes in HW are expensive - for SCSI anyway. Do we
> always want these for such a file?

Do untorn writes actually exist in SCSI?  I was under the impression
nobody had actually implemented them in SCSI hardware.

> We saw untorn writes as not being a property of the file or even the inode
> itself, but rather an attribute of the specific IO being issued from the
> userspace application.

The problem is that keeping track of that is expensive for buffered
writes.  It's a model that only works for direct IO.  Arguably we
could make it work for O_SYNC buffered IO, but that'll require some
surgery.

> > Who's asking for this more complex interface?
> 
> It's not a case of someone specifically asking for this interface. This is
> just a proposal to satisfy userspace requirement to do untorn writes in a
> generic way.
> 
> From a user point-of-view, untorn writes for a regular file can be enabled
> for up to a specific size* with FS_IOC_SETFLAGS API. Then they need to
> follow alignment and size rules for issuing untorn writes, but they would
> always need to do this. In addition, the user may still issue regular
> (tearable) writes to the file.
> 
> * I think that we could change this to only allow writes for that specific
> size, which was my proposal for buffered IO.
> 
> Thanks,
> John
> 

