Return-Path: <io-uring+bounces-10641-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A088EC5EA45
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 18:49:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9D1F3382950
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 17:01:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 409802C0260;
	Fri, 14 Nov 2025 17:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="depSgkpC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03208295DBD;
	Fri, 14 Nov 2025 17:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763139691; cv=none; b=MOlKOs9oSnz3V5els8WB4TLCWkAb3ERhuAZCYpLud2cZdBJtQorbsIlGXfhk451ppuJ9zEVuIuG1FqKMu5r6u5rrjF7/vpGdBkDhRN/BjVXBMfHabA3ey+aQPfSvkICkUSEWNO0WaQGY2AxIg38AevDxdVUduD/uTpNINUzbUTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763139691; c=relaxed/simple;
	bh=xo93xhtQbjPmQQpRAXzz2hy+EkMDFlHK8+leO+CYunA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bwJEUnFSqyjrgZNqpvGjZYL94zKmPgybM5ME4N7ZnXjFCl+kvQjt0G8OjbM1QopEF9JKbUt9zueioFpP2kI+h7S+NZ1MiwZSWTB8k538liwCAwNJuD59+fPQxirz7R2SIU271As1lV2Sl4vH+aXZ1DbJ4k4CItqLE1dx8VjARXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=depSgkpC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D0BC4CEFB;
	Fri, 14 Nov 2025 17:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763139690;
	bh=xo93xhtQbjPmQQpRAXzz2hy+EkMDFlHK8+leO+CYunA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=depSgkpCCepPRRW+haC+ZhH06xBPr/5yQrjHaIoFlCz8xf8fUrGtSukow5jCP6oM6
	 j5NyYWNTFcBHltRN23qEwrkCZX8ywI0nDaOSwiC7jaIV2zCl42k5JLmQLo1htaeT9D
	 FLysup2+Q9ecjIW+VpnTOKXOGk1P3nYyqiwxtuuBWlyWOJ6qiiMuvBO3jGauhnsTcj
	 fDKSSau3RCn0+rOF3PNnMYFN/kNzwwH+Y8rpihOFPMXz0mwunqvfR4694a4G3XPgM0
	 ruI8Q+WEJ27xbie0fKMrkI5oYeRBOb2IYG9UxoyxU58e9E8+mLINYLKgYPYMbZtBtA
	 rTGeGAjEsMHPA==
Date: Fri, 14 Nov 2025 09:01:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
	Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, io-uring@vger.kernel.org,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: re-enable IOCB_NOWAIT writes to files
Message-ID: <20251114170129.GI196370@frogsfrogsfrogs>
References: <20251114062642.1524837-1-hch@lst.de>
 <b7e8d5e3a0ce8da103f4591afc1f4a9c683ef3c7.camel@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7e8d5e3a0ce8da103f4591afc1f4a9c683ef3c7.camel@kernel.org>

On Fri, Nov 14, 2025 at 09:04:58AM -0500, Jeff Layton wrote:
> On Fri, 2025-11-14 at 07:26 +0100, Christoph Hellwig wrote:
> > Hi all,
> > 
> > commit 66fa3cedf16a ("fs: Add async write file modification handling.")
> > effectively disabled IOCB_NOWAIT writes as timestamp updates currently
> > always require blocking, and the modern timestamp resolution means we
> > always update timestamps.  This leads to a lot of context switches from
> > applications using io_uring to submit file writes, making it often worse
> > than using the legacy aio code that is not using IOCB_NOWAIT.
> > 
> > This series allows non-blocking updates for lazytime if the file system
> > supports it, and adds that support for XFS.
> > 
> > It also fixes the layering bypass in btrfs when updating timestamps on
> > device files for devices removed from btrfs usage, and FMODE_NOCMTIME
> > handling in the VFS now that nfsd started using it.  Note that I'm still
> > not sure that nfsd usage is fully correct for all file systems, as only
> > XFS explicitly supports FMODE_NOCMTIME, but at least the generic code
> > does the right thing now.
> > 
> > Diffstat:
> >  Documentation/filesystems/locking.rst |    2 
> >  Documentation/filesystems/vfs.rst     |    6 ++
> >  fs/btrfs/inode.c                      |    3 +
> >  fs/btrfs/volumes.c                    |   11 +--
> >  fs/fat/misc.c                         |    3 +
> >  fs/fs-writeback.c                     |   53 ++++++++++++++----
> >  fs/gfs2/inode.c                       |    6 +-
> >  fs/inode.c                            |  100 +++++++++++-----------------------
> >  fs/internal.h                         |    3 -
> >  fs/orangefs/inode.c                   |    7 ++
> >  fs/overlayfs/inode.c                  |    3 +
> >  fs/sync.c                             |    4 -
> >  fs/ubifs/file.c                       |    9 +--
> >  fs/utimes.c                           |    1 
> >  fs/xfs/xfs_iops.c                     |   29 ++++++++-
> >  fs/xfs/xfs_super.c                    |   29 ---------
> >  include/linux/fs.h                    |   17 +++--
> >  include/trace/events/writeback.h      |    6 --
> >  18 files changed, 152 insertions(+), 140 deletions(-)
> 
> This all looks pretty reasonable to me. There are a few changelog and
> subject line typos, but the code changes look fine. You can add:
> 
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> 
> As far as nfsd's usage of FMODE_NOCMTIME, it looks OK to me. That's
> implemented today by the check in file_modified_flags(), which is
> generic and should work across filesystems.
> 
> The main exception is xfs_exchange_range() which has some special
> handling for it, but nfsd doesn't use that functionality so that
> shouldn't be an issue.
> 
> Am I missing some subtlety?

In exchangerange specifically?

The FMODE_NOCMTIME checks in xfs_exchange_range exist to tell the
exchange-range code to update cmtime, but only if it decides to actually
go through with the mapping exchange.  Since the mapping exchange
requires a transaction anyway, it's cheap to bundle in timestamp
updates.

Also there's no way that we can do nonblocking exchangerange so a NOWAIT
flag wouldn't be much help here anyway.

(I hope that answers your question)

--D

