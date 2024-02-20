Return-Path: <io-uring+bounces-658-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A98485B525
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 09:29:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9E032830C4
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 08:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 616475C8F3;
	Tue, 20 Feb 2024 08:29:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF925467B;
	Tue, 20 Feb 2024 08:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708417753; cv=none; b=TjVs0CZfgtHp+TPxO3GlqXrdW7ZV45ihpriDqMNa9JGowIw2MjQNhB4jGN751BQZMyh7P1o7qwkO13+g+XRIkMMk50hSBwZv5kMYN5MaZbixvcOH04BS+U1dGMhp+JFdfggML7GNu/UFrbaumkZ35UG+YO9h110RaKhco8i+XM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708417753; c=relaxed/simple;
	bh=QXaT3nMZ99hdDbzY7H8ZM5BvZ3c3AxhfZpb4C1LydmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s2wqPoMbLT8Q27guKgcWBVkUK3vJ2tapZBQXKOY+oOMMJ9xWZ/DGaWoLkOd30DIFgsoEts/cHosxUFT39FkS5e5Fvrt5bHcNWQQ2oy5KIqNzqmRD4j+BC+u9vud91uDbQ5N7P6A+3z0JANlNFCPHG0reWbdpEKZPlrI7vbjKbMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 01C1868D08; Tue, 20 Feb 2024 09:29:03 +0100 (CET)
Date: Tue, 20 Feb 2024 09:29:02 +0100
From: Christoph Hellwig <hch@lst.de>
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
	ritesh.list@gmail.com,
	Prasad Singamsetty <prasad.singamsetty@oracle.com>
Subject: Re: [PATCH v4 06/11] block: Add atomic write support for statx
Message-ID: <20240220082902.GC13785@lst.de>
References: <20240219130109.341523-1-john.g.garry@oracle.com> <20240219130109.341523-7-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219130109.341523-7-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +#define BDEV_STATX_SUPPORTED_MASK (STATX_DIOALIGN | STATX_WRITE_ATOMIC)

> +	if (!(request_mask & BDEV_STATX_SUPPORTED_MASK))
> +		return;

BDEV_STATX_SUPPORTED_MASK is misleading here.  bdevs support a lot more
fields, these are just the ones needing special attention.  I'd do away
with the extra define and just open code it.

> +	/* If this is a block device inode, override the filesystem
> +	 * attributes with the block device specific parameters
> +	 * that need to be obtained from the bdev backing inode
> +	 */

This is not the normal kernel multi-line comment format.

> +	if (S_ISBLK(d_backing_inode(path.dentry)->i_mode))
> +		bdev_statx(path.dentry, stat, request_mask);

I know I touched this last, but does anyone remember why we have
various random fixups in vfs_statx and not in vfs_getattr_nosec, where
they we have more of them and also the inode at hand?

