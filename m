Return-Path: <io-uring+bounces-4126-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BB4B9B4F34
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 17:23:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D9331C20AA9
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A20198E99;
	Tue, 29 Oct 2024 16:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tmO/oYVP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDC9198A35;
	Tue, 29 Oct 2024 16:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730218980; cv=none; b=JmcLlhBK+EzI8gCsYxV/L+Uk5dZyvnWJssz7dmJdOxcbNPDKPaWPHqUxlUlZYw3gKHu/fYayk54Iow+sJu9C3IU3oHmssxp0Dz5T8NLcYmo6JUjn2OjQ4UxiDR9ZgjhGVsiEZNoI9643txveW3NvYXPeP8lz55FHeoX8hOxNSOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730218980; c=relaxed/simple;
	bh=rnqDaUxeAcqkIk/Vh8WJ9TxoWp2/b9FHNdxNoOJlIGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZLf/06yalPaIlHnIKwIsW9RP7bXMfzuak5EuoUxtqNN0tfIdnWAV4pexnpEf0s2lbitlJN4/cwr8uwu4qreWF6/Reg4pwhnG4WZS1OIkQgkO0S1ZDVgof2UAMa9LpZnXTdPT8hbzhLA2Xcz1tYT49kYloUN67nE+73+AwmxBgwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tmO/oYVP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504EFC4CECD;
	Tue, 29 Oct 2024 16:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730218980;
	bh=rnqDaUxeAcqkIk/Vh8WJ9TxoWp2/b9FHNdxNoOJlIGE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tmO/oYVPLqeC34LQRu1PYdnSvZd4ijfcozDJ/SywAmS8CCeUdPO4Fei0e+9PG7HGl
	 vDX2HjNZVgs0J/AzgItViMJdpiiaKg8CzAexngMVRoxuFOCVWnE7RWrU2kpRi0lnGZ
	 A4LNtMgy/AaERrSI2RzlS22JN6iLwo/Be9JAw1deT9ivdMKL9drQfgjaaIhceCP600
	 /pPjlAohYl149PBupNLsUs5Mb0RhmWrwAFePvBX4VbuZjcJfFHM3vNn+DrE8lnOvuz
	 bTWTe4ltpcTa4zF94DrK960V4pDkPfbP2q+pxxNotVMGXyc292q+8mPV1BVYUA3e2s
	 OMYC/pMJ5z6+w==
Date: Tue, 29 Oct 2024 10:22:56 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <ZyEL4FOBMr4H8DGM@kbusch-mbp>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241029151922.459139-10-kbusch@meta.com>
 <20241029152654.GC26431@lst.de>
 <ZyEAb-zgvBlzZiaQ@kbusch-mbp>
 <20241029153702.GA27545@lst.de>
 <ZyEBhOoDHKJs4EEY@kbusch-mbp>
 <20241029155330.GA27856@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029155330.GA27856@lst.de>

On Tue, Oct 29, 2024 at 04:53:30PM +0100, Christoph Hellwig wrote:
> On Tue, Oct 29, 2024 at 09:38:44AM -0600, Keith Busch wrote:
> > They're not exposed as write streams. Patch 7/9 sets the feature if it
> > is a placement id or not, and only nvme sets it, so scsi's attributes
> > are not claiming to be a write stream.
> 
> So it shows up in sysfs, but:
> 
>  - queue_max_write_hints (which really should be queue_max_write_streams)
>    still picks it up, and from there the statx interface
> 
>  - per-inode fcntl hint that encode a temperature still magically
>    get dumpted into the write streams if they are set.
> 
> In other words it's a really leaky half-backed abstraction.

Exactly why I asked last time: "who uses it and how do you want them to
use it" :)
 
> Let's brainstorm how it could be done better:
> 
>  - the max_write_streams values only set by block devices that actually
>    do support write streams, and not the fire and forget temperature
>    hints.  They way this is queried is by having a non-zero value
>    there, not need for an extra flag.

So we need a completely different attribute for SCSI's permanent write
streams? You'd mentioned earlier you were okay with having SCSI be able
to utilized per-io raw block write hints. Having multiple things to
check for what are all just write classifiers seems unnecessarily
complicated.

>  - but the struct file (or maybe inode) gets a supported flag, as stream
>    separation needs to be supported by the file system 
>  - a separate fcntl is used to set per-inode streams (if you care about
>    that, seem like the bdev use case focusses on per-I/O).  In that case
>    we'd probably also need a separate inode field for them, or a somewhat
>    complicated scheme to decide what is stored in the inode field if there
>    is only one.

No need to create a new fcntl. The people already testing this are
successfully using FDP with the existing fcntl hints. Their applications
leverage FDP as way to separate files based on expected lifetime. It is
how they want to use it and it is working above expectations. 

>  - for block devices bdev/fops.c maps the temperature hints into write
>    streams if write streams are supported, any user that mixes and
>    matches write streams and temperature hints gets what they deserve

That's fine. This patch series pretty much accomplishes that part.

>  - this could also be a helper for file systems that want to do the
>    same.
> 
> Just a quick writeup while I'm on the run, there's probably a hole or
> two that could be poked into it.

