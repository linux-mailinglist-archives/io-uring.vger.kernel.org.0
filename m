Return-Path: <io-uring+bounces-11300-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DA463CDAC5D
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 23:53:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7479830115CA
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 22:53:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA2019CC28;
	Tue, 23 Dec 2025 22:53:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B711DFF7;
	Tue, 23 Dec 2025 22:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766530410; cv=none; b=XX0mJYAA3wPsRdOAU1WqiH8r331mEulKjKIqu1Z4Xy8RMyAHSmxKUWFoqcdnrCmNezjaGFujAZOrOTziNgOpo/E3HWyZC3Z2AOaI+lS3AlSitmpLfnB1SzvX+9ZYqUnD72vH3I4ZDzcxLuOrUWOWo86BEqEzmeRBC33RsNjZS78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766530410; c=relaxed/simple;
	bh=1LPbsoM7pLMPQQedIWbt8mP12TcgBuK/MV8HZi+GMFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSqFOCpZiWLP9jImc8TyvzaPRf2xe4L0posDI7jruIgWdQWbYSY95KnSQvy6Iy4BffBC8b3raFf1QxS5/xww/2oTl0NISZiZufD/T2LGdJxMX9sln+8ZHJBV+6nrHEh/xy48W9eZhe7EBwxD9rDJf+v2Mn0djkyZPIOMa06g8oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 98B7D227A87; Tue, 23 Dec 2025 23:53:16 +0100 (CET)
Date: Tue, 23 Dec 2025 23:53:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
	Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, io-uring@vger.kernel.org,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: re-enable IOCB_NOWAIT writes to files v4
Message-ID: <20251223225316.GA26676@lst.de>
References: <20251223003756.409543-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251223003756.409543-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

Julia found a nice little typo in the new changes, which really
wants me to split the atime from c/mtime update path badly.  So
don't feel rushed to review this version and enjoy the holidays,
there will be a new one soon.

On Tue, Dec 23, 2025 at 09:37:43AM +0900, Christoph Hellwig wrote:
> Hi all,
> 
> commit 66fa3cedf16a ("fs: Add async write file modification handling.")
> effectively disabled IOCB_NOWAIT writes as timestamp updates currently
> always require blocking, and the modern timestamp resolution means we
> always update timestamps.  This leads to a lot of context switches from
> applications using io_uring to submit file writes, making it often worse
> than using the legacy aio code that is not using IOCB_NOWAIT.
> 
> This series allows non-blocking updates for lazytime if the file system
> supports it, and adds that support for XFS.
> 
> Changes since v3:
>  - fix was_dirty_time handling in __mark_inode_dirty for the racy flag
>    update case
>  - refactor inode_update_timestamps to make the lazytime vs blocking
>    logical more clear
>  - allow non-blocking timestamp updates for fat
> 
> Changes since v2:
>  - drop patches merged upstream
>  - adjust for the inode state accesors
>  - keep a check in __writeback_single_inode instead of exercising
>    potentially undefined behavior
>  - more spelling fixes
> 
> Changes since v1:
>  - more regular numbering of the S_* flags
>  - fix XFS to actually not block
>  - don't ignore the generic_update_time return value in
>    file_update_time_flags
>  - fix the sync_lazytime return value
>  - fix an out of data comment in btrfs
>  - fix a race that would update i_version before returning -EAGAIN in XFS
> 
> Diffstat:
>  Documentation/filesystems/locking.rst |    2 
>  Documentation/filesystems/vfs.rst     |    6 +
>  fs/btrfs/inode.c                      |    8 +-
>  fs/fs-writeback.c                     |   33 +++++++---
>  fs/gfs2/inode.c                       |    6 +
>  fs/inode.c                            |  111 +++++++++++++++++++++-------------
>  fs/internal.h                         |    3 
>  fs/nfs/inode.c                        |    4 -
>  fs/orangefs/inode.c                   |    5 +
>  fs/overlayfs/inode.c                  |    2 
>  fs/sync.c                             |    4 -
>  fs/ubifs/file.c                       |   13 ++-
>  fs/xfs/xfs_iops.c                     |   34 +++++++++-
>  fs/xfs/xfs_super.c                    |   29 --------
>  include/linux/fs.h                    |   27 ++++++--
>  include/trace/events/writeback.h      |    6 -
>  16 files changed, 182 insertions(+), 111 deletions(-)
---end quoted text---

