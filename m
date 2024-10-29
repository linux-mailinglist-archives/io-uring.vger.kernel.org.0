Return-Path: <io-uring+bounces-4125-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 18AF89B4E92
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:53:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2976B222EA
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC153194A52;
	Tue, 29 Oct 2024 15:53:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DD2802;
	Tue, 29 Oct 2024 15:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730217217; cv=none; b=m4goh0j9ncjgMvmh7ECa/pLtAKx9NF79/m2sJvIhcSmExc03PpCdr2uTYA7/EbcUI17n9aAoJXYRHWwVG+a17ehzo8krxKTNlx4sqi6zsbXWSr5YEhGwNJOd1vqrYXZtD1OFFM/zS0CwZRVyTXSXqnrJZpyXLXooCE054bT6GkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730217217; c=relaxed/simple;
	bh=8FIRpPA85+k3lgKoQFsLkwYtDaZxGtBkkiX5fT/tJNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UkAub1GuUCHrLSJncQarUm7PCEoH7stqOqRf06eWVDwQjdMIeee4rLe8URY5ulFaWiZYUaUQpaUHSrHabARSTmEkA10KPogqrk75JiFpVCqTP262WTgrIX7HI/K/FOvL7uaL3SU9ogg6bk9234zuH7hAQSHZojhQogk6pab5wo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6BB04227AAD; Tue, 29 Oct 2024 16:53:31 +0100 (CET)
Date: Tue, 29 Oct 2024 16:53:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <20241029155330.GA27856@lst.de>
References: <20241029151922.459139-1-kbusch@meta.com> <20241029151922.459139-10-kbusch@meta.com> <20241029152654.GC26431@lst.de> <ZyEAb-zgvBlzZiaQ@kbusch-mbp> <20241029153702.GA27545@lst.de> <ZyEBhOoDHKJs4EEY@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyEBhOoDHKJs4EEY@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 29, 2024 at 09:38:44AM -0600, Keith Busch wrote:
> They're not exposed as write streams. Patch 7/9 sets the feature if it
> is a placement id or not, and only nvme sets it, so scsi's attributes
> are not claiming to be a write stream.

So it shows up in sysfs, but:

 - queue_max_write_hints (which really should be queue_max_write_streams)
   still picks it up, and from there the statx interface

 - per-inode fcntl hint that encode a temperature still magically
   get dumpted into the write streams if they are set.

In other words it's a really leaky half-backed abstraction.

Let's brainstorm how it could be done better:

 - the max_write_streams values only set by block devices that actually
   do support write streams, and not the fire and forget temperature
   hints.  They way this is queried is by having a non-zero value
   there, not need for an extra flag.
 - but the struct file (or maybe inode) gets a supported flag, as stream
   separation needs to be supported by the file system 
 - a separate fcntl is used to set per-inode streams (if you care about
   that, seem like the bdev use case focusses on per-I/O).  In that case
   we'd probably also need a separate inode field for them, or a somewhat
   complicated scheme to decide what is stored in the inode field if there
   is only one.
 - for block devices bdev/fops.c maps the temperature hints into write
   streams if write streams are supported, any user that mixes and
   matches write streams and temperature hints gets what they deserve
 - this could also be a helper for file systems that want to do the
   same.

Just a quick writeup while I'm on the run, there's probably a hole or
two that could be poked into it.

