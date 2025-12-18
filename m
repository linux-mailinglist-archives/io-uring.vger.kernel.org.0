Return-Path: <io-uring+bounces-11178-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC37CCA6D7
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 07:19:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6463A3034621
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 06:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C7831AF1D;
	Thu, 18 Dec 2025 06:19:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D81C27F732;
	Thu, 18 Dec 2025 06:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766038748; cv=none; b=dbiIt9GGVfa9JnnC/3V3P6PSKlK3du1qhcP20tr/hEKDEJv98OkMjqGxebqnIdwQteCwf9JLIO2lm4XJ03gICuQl8zM6N/ZUXn7HOLXmWoQgCKOLSFOnYAoL+8E4MG/m/tYOUzElj7v0q+k0fSVZO0DZblDmJO9hrz3Y5GNsn9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766038748; c=relaxed/simple;
	bh=JmvjwhEYnkt2EOZtxq/vNq4N+U4ZhJ/hWwGm4zYqqjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CV79iEqteaOskW7Fn4xpraYrGdQsTyDlP+wmojTppuc1FH2+I8zb4EW7pTo1kpnFQD/3KPcwlNxlTNSFbc8+yvVmlfxFvTosb39ecjIm5sykOjMs6XdUJR+Qqn0pF9madcNQ9kj5lB/xGfb1DUSvlXhFMUqh1XZ/pBKcu1CrFX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 742AF227A88; Thu, 18 Dec 2025 07:19:01 +0100 (CET)
Date: Thu, 18 Dec 2025 07:19:00 +0100
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
Message-ID: <20251218061900.GB2775@lst.de>
References: <20251217061015.923954-1-hch@lst.de> <20251217061015.923954-9-hch@lst.de> <2hnq54zc4x2fpxkpuprnrutrwfp3yi5ojntu3e3xfcpeh6ztei@2fwwsemx4y5z>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2hnq54zc4x2fpxkpuprnrutrwfp3yi5ojntu3e3xfcpeh6ztei@2fwwsemx4y5z>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 17, 2025 at 01:42:20PM +0100, Jan Kara wrote:
> > @@ -2110,12 +2110,26 @@ int inode_update_timestamps(struct inode *inode, int *flags)
> >  		now = inode_set_ctime_current(inode);
> >  		if (!timespec64_equal(&now, &ctime))
> >  			updated |= S_CTIME;
> > -		if (!timespec64_equal(&now, &mtime)) {
> > -			inode_set_mtime_to_ts(inode, now);
> > +		if (!timespec64_equal(&now, &mtime))
> >  			updated |= S_MTIME;
> > +
> > +		if (IS_I_VERSION(inode)) {
> > +			if (*flags & S_NOWAIT) {
> > +				/*
> > +				 * Error out if we'd need timestamp updates, as
> > +				 * the generally requires blocking to dirty the
> > +				 * inode in one form or another.
> > +				 */
> > +				if (updated && inode_iversion_need_inc(inode))
> > +					goto bail;
> 
> I'm confused here. What the code does is that if S_NOWAIT is set and
> i_version needs increment we bail. However the comment as well as the
> changelog speaks about timestamps needing update and not about i_version.
> And intuitively I agree that if any timestamp is updated, inode needs
> dirtying and thus we should bail regardless of whether i_version is updated
> as well or not. What am I missing?

With lazytime timestamp updates that don't require i_version updates
are performed in-memory only, and we'll only reach this with S_NOWAIT
set for those (later in the series, it can't be reached at all as
of this patch).

But yes, this needs to be documented much better.


