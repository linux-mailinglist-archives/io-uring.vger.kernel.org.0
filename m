Return-Path: <io-uring+bounces-657-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE41185B4EE
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 09:23:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03A7C1C20B4E
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 08:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6DBB5C8EA;
	Tue, 20 Feb 2024 08:22:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECD45BAE4;
	Tue, 20 Feb 2024 08:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708417373; cv=none; b=LNozJekuQbv625gKsv+FTCUBvvApBJBZKC+8/c8iSM49kK+djBb+BHgjyJdsFmWDZKHLIytXJ6CAQ1uwpixAL1ClrN3SwcMjBPhM82XLtPBL+xQ0LcX/NToXh1rm1eGprymcV1cw66S+OM+e/swCcSFA5nnISUl8BlnV/0wg8/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708417373; c=relaxed/simple;
	bh=xcBFurX3UmQ0rxHVywfl4AduS/GQVMII1hz9dAXtgO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmCZH/1h5H+kIFE71LVL6WnvgW9723FtZDVNzMP2TXt26quG/S5WGkxbG8OSqSkwebJzJgjQw11BUks0rqvpeT2GpLcyGgh33KuGPS4dmbZtzdEimCY5li65BbgdzNsLSYBRrGV1YaaE0v9esyJ8RvJo5VnxKvc+3KaEOFHeo2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B616D68CFE; Tue, 20 Feb 2024 09:22:45 +0100 (CET)
Date: Tue, 20 Feb 2024 09:22:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk,
	kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com
Subject: Re: [PATCH v4 05/11] block: Add core atomic write support
Message-ID: <20240220082245.GB13785@lst.de>
References: <20240219130109.341523-1-john.g.garry@oracle.com> <20240219130109.341523-6-john.g.garry@oracle.com> <ZdPdHzNAVb5hqlkY@dread.disaster.area>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdPdHzNAVb5hqlkY@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 20, 2024 at 09:58:39AM +1100, Dave Chinner wrote:
> > +	lim->atomic_write_hw_max_sectors = 0;
> > +	lim->atomic_write_max_sectors = 0;
> > +	lim->atomic_write_hw_boundary_sectors = 0;
> > +	lim->atomic_write_hw_unit_min_sectors = 0;
> > +	lim->atomic_write_unit_min_sectors = 0;
> > +	lim->atomic_write_hw_unit_max_sectors = 0;
> > +	lim->atomic_write_unit_max_sectors = 0;
> >  }
> 
> Seems to me this function would do better to just
> 
> 	memset(lim, 0, sizeof(*lim));
> 
> and then set all the non-zero fields.

.. which the caller already has done :)  In the block tree this
function looks completely different now and relies on the caller
provided zeroing.

> > +void blk_queue_atomic_write_max_bytes(struct request_queue *q,
> > +				      unsigned int bytes)
> > +{
> > +	q->limits.atomic_write_hw_max_sectors = bytes >> SECTOR_SHIFT;
> > +	blk_atomic_writes_update_limits(q);
> > +}
> > +EXPORT_SYMBOL(blk_queue_atomic_write_max_bytes);
> 
> Ok, so this can silently set a limit that is different to what the
> caller asked to have set?
> 
> How is the caller supposed to find this out if the smaller limit
> that was set is not compatible with their configuration?
> 
> i.e. shouldn't this return an error if the requested size cannot
> be set exactly as specified?

That's how the blk limits all work.  The driver provides the hardware
capabilities for a given value, and the block layer ensures it
works with other limits imposed by the block layer or other parts
of the device limits.

