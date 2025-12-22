Return-Path: <io-uring+bounces-11250-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 54C92CD7770
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:42:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 35B27300CCE8
	for <lists+io-uring@lfdr.de>; Mon, 22 Dec 2025 23:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2347730F94D;
	Mon, 22 Dec 2025 23:42:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BE9305E28;
	Mon, 22 Dec 2025 23:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766446924; cv=none; b=tfcGTZMD6Rhwih8nkfX/ndXJa4iiLNnojeG2EfrvH96w3+sRJgp6D611Z9iZnLsNBqnTMTTcFEjPxi9Vt1+Z6S6Y+XPFbOIu5qH7iBTeTowN3IE6mLiCYA9gBhbzlP4xuGpEVNzAoCXgG9+U7HhB9HLTNjQYEmcYbE52VBM8g6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766446924; c=relaxed/simple;
	bh=Skm04jZcbADh4Zt8DegTtfd9R0gBaHlcvWzGRPA2vI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/UrlFEac+yaMPrqP+i5K5os110Fow+C8FRlTUY0kMe9hSWBRZOMgmvqzw0oiHx+PUbLT4kzK0QY4kP4Bam0f5CF1WjHnyEZhAf15fRcAznuX5oPGAEPvAjNKo35jp4BO3Adu3cM71ug9dkxNjWngw+AEaidEEsQUWnohzavpvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E236368B05; Tue, 23 Dec 2025 00:41:56 +0100 (CET)
Date: Tue, 23 Dec 2025 00:41:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, io-uring@vger.kernel.org,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 08/10] fs: add support for non-blocking timestamp
 updates
Message-ID: <20251222234156.GA19230@lst.de>
References: <20251217061015.923954-1-hch@lst.de> <20251217061015.923954-9-hch@lst.de> <2hnq54zc4x2fpxkpuprnrutrwfp3yi5ojntu3e3xfcpeh6ztei@2fwwsemx4y5z> <20251218061900.GB2775@lst.de> <wynhubqgvknr3fl4umfst62xyacck3avmg6qnbp2na6w7ee3qf@odetcif4kozl>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wynhubqgvknr3fl4umfst62xyacck3avmg6qnbp2na6w7ee3qf@odetcif4kozl>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 19, 2025 at 04:12:01PM +0100, Jan Kara wrote:
> Ah, I see now. Thanks for explanation. This interplay between filesystem's
> .update_time() helper and inode_update_timestamps() is rather subtle.
> Cannot we move the SB_LAZYTIME checking from .update_time() to
> inode_update_timestamps() to have it all in one function? The hunk you're
> adding to xfs_vn_update_time() later in the series looks like what the
> other filesystems using it will want as well?

XFS is a bit special as it requires the ilock for timestamp updates
(I'm actually not sure how they are properly serialized for others,
but let's open that can of worms after this one is dealt with..).

But I came up with a way to make this a bit more obvious, which is
by moving the flags selection from mark_inode_dirty_time into
inode_update_timestamps.

> BTW, I've noticed that ovl_update_time() and fat_update_time() should be
> safe wrt NOWAIT IO so perhaps you don't have to disable it in your patch
> (or maybe reenable explicitly?).

fat is safe.  overlayfs is not, touch_atime might sleep in the lower fs.

> And I don't really now what orangefs_update_time() is trying to do with its
> __orangefs_setattr() call which just copies the zeroed-out timestamps from
> iattr into the inode? Mike?

I'll leave that to Mike.


