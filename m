Return-Path: <io-uring+bounces-10640-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA3CC5E2BE
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 17:22:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E6AA03A8431
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 15:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D47E624E4D4;
	Fri, 14 Nov 2025 15:30:45 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5852A246778;
	Fri, 14 Nov 2025 15:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763134245; cv=none; b=ABo6LYKxOTTDa0HinGGi8snn6hq5CiU7KKf24hViA+coE0dx8aQNUG/nySldXBWm05KPrtMzUjX7CLjBo2Jx0nEWi8CmqWmwckZijk0Yk/TG+EdfZ6WLZlBJj6C2eiYMpLh/SBwIePP9OWkE8N7w6Bqm1r3plLTgkEyYuiYgxLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763134245; c=relaxed/simple;
	bh=Ji4lGzu390e13RQokZdLHZORhR0//OPD3AErEgLRCyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7BMDTgvq+aTVagrF1J5KSB1J0RXaU1BRBawGsdMESiCUyH9E856R2pj+CznwpdiwN6x+zTwhnDz32ZfIYbbpA/TxucyxoQRFxIlyQcbOrFf+2leIkuaoW3KeJeH/oZ/sjmKJsnKGMsJql8zRsA1ysO1rw3VVcrgt9Fiefe+OWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 34600227AA8; Fri, 14 Nov 2025 16:30:37 +0100 (CET)
Date: Fri, 14 Nov 2025 16:30:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
	Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
	io-uring@vger.kernel.org, devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 14/14] xfs: enable non-blocking timestamp updates
Message-ID: <20251114153036.GA30882@lst.de>
References: <20251114062642.1524837-1-hch@lst.de> <20251114062642.1524837-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114062642.1524837-15-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 14, 2025 at 07:26:17AM +0100, Christoph Hellwig wrote:
> The lazytime path using generic_update_time can never block in XFS
> because there is no ->dirty_inode method that could block.  Allow
> non-blocking timestamp updates for this case.

As the report noted, it turns out my rebase lost the most important
thing here, which is to not reject S_NOWAIT for the lazytime path.
The incremental patch is below.  I'll resend on Monday, and officially
declare that Friday the 14th is the new Friday the 13th.

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 3d7b89ffacde..35dbabf1e111 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1196,9 +1196,13 @@ xfs_vn_update_time(
 	trace_xfs_update_time(ip);
 
 	if (inode->i_sb->s_flags & SB_LAZYTIME) {
-		if (!((flags & S_VERSION) &&
-		      inode_maybe_inc_iversion(inode, false)))
-			return generic_update_time(inode, flags);
+		int updated = inode_update_timestamps(inode, flags);
+
+		if (!(updated & S_VERSION)) {
+			if (updated)
+				mark_inode_dirty_time(inode, updated);
+			return 0;
+		}
 
 		/* Capture the iversion update that just occurred */
 		log_flags |= XFS_ILOG_CORE;

