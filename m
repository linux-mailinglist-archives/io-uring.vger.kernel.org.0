Return-Path: <io-uring+bounces-1399-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B791899520
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 08:14:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23B60B2762C
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 06:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0D2625765;
	Fri,  5 Apr 2024 06:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hz94qC/k"
X-Original-To: io-uring@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01952561B;
	Fri,  5 Apr 2024 06:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712297652; cv=none; b=IgsZc8c69YFKlqC2xcZLDUN0hrTLcNS0ftAV8wgdhooVaxDF2lFHDKhPmX/9wAtd3PR2JXGT0R4wIQdkvJD5jRwqHpFXwIlHHucmw5tYDnE/4iSNO8LvRwi8NKpTaHSxk1n6Vm/RDYzN+ooMZ6zymY3j5ALiSlFXQYCJd1RdpKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712297652; c=relaxed/simple;
	bh=T4i8qF0kQ4jicK7JZlDiiL/gPtfRv3965SlOH/CPHGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CRkY9aP+xajAcZSLzFDtE2GfYIALYE8TI89F1SFDktjzBBdXKaekmb89i2dQ6wxfbJGDUSvF8EPKXV7vIctcB7csjzMUuf7FGc5LNXR36Nh/GtBykg1y6Tiqq8iw2NpFxJVn/g1XeadKhDROrAfMEsyONUNLWASderfqMb3Egrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hz94qC/k; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 02:14:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712297648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cyDSL8bbIuBGPhpbWHPKmW3FA/QoKWRocxhlzQJfbtc=;
	b=hz94qC/kMRNS8U2dSJJFe2U7oUJcHRk3926Ki59ll2pNGoO5uHEl7dQNMvZUgrG+MfUImO
	zUxRu+mDOai5BT/NVbKKNoflDpesoqFuwv8FXi6MUOzEEibDucN5fxjULUVlpyNyoxOjXg
	gbSNlp3nETvz9HC2EdVXfC0L4ho3bTc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, 
	kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	dchinner@redhat.com, jack@suse.cz, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org, 
	ojaswin@linux.ibm.com, linux-aio@kvack.org, linux-btrfs@vger.kernel.org, 
	io-uring@vger.kernel.org, nilay@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH v6 00/10] block atomic writes
Message-ID: <zn6kcqq24f7ltg5fpbsnuxyr7qqzqmydz4mnmaqlmsntq4pekz@h3jkkp5xps73>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgOXb_oZjsUU12YL@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 27, 2024 at 03:50:07AM +0000, Matthew Wilcox wrote:
> On Tue, Mar 26, 2024 at 01:38:03PM +0000, John Garry wrote:
> > The goal here is to provide an interface that allows applications use
> > application-specific block sizes larger than logical block size
> > reported by the storage device or larger than filesystem block size as
> > reported by stat().
> > 
> > With this new interface, application blocks will never be torn or
> > fractured when written. For a power fail, for each individual application
> > block, all or none of the data to be written. A racing atomic write and
> > read will mean that the read sees all the old data or all the new data,
> > but never a mix of old and new.
> > 
> > Three new fields are added to struct statx - atomic_write_unit_min,
> > atomic_write_unit_max, and atomic_write_segments_max. For each atomic
> > individual write, the total length of a write must be a between
> > atomic_write_unit_min and atomic_write_unit_max, inclusive, and a
> > power-of-2. The write must also be at a natural offset in the file
> > wrt the write length. For pwritev2, iovcnt is limited by
> > atomic_write_segments_max.
> > 
> > There has been some discussion on supporting buffered IO and whether the
> > API is suitable, like:
> > https://lore.kernel.org/linux-nvme/ZeembVG-ygFal6Eb@casper.infradead.org/
> > 
> > Specifically the concern is that supporting a range of sizes of atomic IO
> > in the pagecache is complex to support. For this, my idea is that FSes can
> > fix atomic_write_unit_min and atomic_write_unit_max at the same size, the
> > extent alignment size, which should be easier to support. We may need to
> > implement O_ATOMIC to avoid mixing atomic and non-atomic IOs for this. I
> > have no proposed solution for atomic write buffered IO for bdev file
> > operations, but I know of no requirement for this.
> 
> The thing is that there's no requirement for an interface as complex as
> the one you're proposing here.  I've talked to a few database people
> and all they want is to increase the untorn write boundary from "one
> disc block" to one database block, typically 8kB or 16kB.
> 
> So they would be quite happy with a much simpler interface where they
> set the inode block size at inode creation time, and then all writes to
> that inode were guaranteed to be untorn.  This would also be simpler to
> implement for buffered writes.
> 
> Who's asking for this more complex interface?

I get the impression the atomic writes stuff has suffered from too
/much/ review and too many maintainers asking for and demanding all
their different must-haves.

