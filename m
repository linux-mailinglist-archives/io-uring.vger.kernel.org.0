Return-Path: <io-uring+bounces-1403-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA964899A99
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 12:20:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 849C7282DD4
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 10:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30FB31649DB;
	Fri,  5 Apr 2024 10:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t3AqxFMd"
X-Original-To: io-uring@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F99161B53
	for <io-uring@vger.kernel.org>; Fri,  5 Apr 2024 10:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712312442; cv=none; b=ShKH0U6OgbDpEbp/ybwov+Nq6CxndRc5taEngXMWC7aUM2u8KLYixw9xTxSCfh7NUig1tccIAL4uWWfr9vQcNf18pR+DjNalybyiwrCfEPHapMSfrad9S1QJSSv4cWXTAU1UD8JX53ez60YSJ2GBr55090Kl5zZsbYOjdNIwz4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712312442; c=relaxed/simple;
	bh=x9FEW35UHYYiTgw3MPS855vU699G37yrjB8/DVBrIOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PK2z2f2NEU1m8R13s6n8j1tMDfxlQ/S9LaTUPFcdGcynN8tzdqYtgQ+UtRK9RPskEu7c6OXu0fpgaalCSaUBP52BQXTi9Zf8263LmMPr98rOU7sjndftPOvXZ4SwurvM+WQXvqbXcUSMgH++rZIP/jGVJnZL+f4DNAfiZ+Mnzb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t3AqxFMd; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 06:20:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712312437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JKB/XK2+ZspoYCWJ5e9uu85ZD/ohSEghijO4GmecwRI=;
	b=t3AqxFMdmrGtYQ9G8J216FgOVp7DHoc0Xl3/V6haSjRofA+J7YhhVeOOItBQf08WAumVMo
	nQF8ZnKnTLhSXGMG2LvUUMcNlI5s/Bj6jZIzc20XpDdSIHP81L8M5hslsOIXVeIolsY/ev
	xjIhfxlnC1KvRHF0mVQhDM3doE0Si7o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@infradead.org>, 
	John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com, jack@suse.cz, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org, 
	ojaswin@linux.ibm.com, linux-aio@kvack.org, linux-btrfs@vger.kernel.org, 
	io-uring@vger.kernel.org, nilay@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH v6 00/10] block atomic writes
Message-ID: <62uvkga54im76lnz47nc2znoeayidp2tcwpffseqtl42xdwxlc@hep6ckbgpwqz>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
 <ZgSCMXKtcYWhxR7e@dread.disaster.area>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgSCMXKtcYWhxR7e@dread.disaster.area>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 28, 2024 at 07:31:45AM +1100, Dave Chinner wrote:
> On Wed, Mar 27, 2024 at 03:50:07AM +0000, Matthew Wilcox wrote:
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
> > set the inode block size at inode creation time, and then all writes to
> > that inode were guaranteed to be untorn.  This would also be simpler to
> > implement for buffered writes.
> 
> You're conflating filesystem functionality that applications will use
> with hardware and block-layer enablement that filesystems and
> filesystem utilities need to configure the filesystem in ways that
> allow users to make use of atomic write capability of the hardware.
> 
> The block layer functionality needs to export everything that the
> hardware can do and filesystems will make use of. The actual
> application usage and setup of atomic writes at the filesystem/page
> cache layer is a separate problem.  i.e. The block layer interfaces
> need only support direct IO and expose limits for issuing atomic
> direct IO, and nothing more. All the more complex stuff to make it
> "easy to use" is filesystem level functionality and completely
> outside the scope of this patchset....

A CoW filesystem can implement atomic writes without any block device
support. It seems to me that might have been the easier place to start -
start by getting the APIs right, then do all the plumbing for efficient
untorn writes on non CoW filesystems...

