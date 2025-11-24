Return-Path: <io-uring+bounces-10771-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 79AB7C80EB4
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 15:09:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2BFC64E2AA9
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 14:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5097430E828;
	Mon, 24 Nov 2025 14:09:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C992DC76F;
	Mon, 24 Nov 2025 14:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763993370; cv=none; b=FFqBg0dFiN0BuJ7QkLycdj0QwAJNkOgIKLOskt44kVTIDJn+6JO+CFOVhnaKMYxTroFu4X4dWzDN6HOnS5JSzvmUp/3W5NcWEkGtptwXG5Zv7UIqIwh7dkqCJmZgILpLFAM1D5ouw0rGeXEBdkWbyYavDvx+VgJD5/QTdtWByg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763993370; c=relaxed/simple;
	bh=trXS4N9Vz9V+Viy49DUBsztBaiTbLynzCDwJ+zstgiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D6J1MbU1DCy5f1eESktofP09TiTcfNP2dh9aZG+KVt+yQ49rMmbAAlm6tofDvIqIu/WBnTuqtenMIepdrgG7e+AJo3RCyLprq5WbDqNXbpD9ouvmwl9ewk7GCkukoIfWGDpn4Vx6D2gXhlp0615da9N5Ux3HuYE7r/dDCsj3fU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6355668B05; Mon, 24 Nov 2025 15:09:25 +0100 (CET)
Date: Mon, 24 Nov 2025 15:09:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
	io-uring@vger.kernel.org, devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 10/14] fs: factor out a sync_lazytime helper
Message-ID: <20251124140924.GB14417@lst.de>
References: <20251114062642.1524837-1-hch@lst.de> <20251114062642.1524837-11-hch@lst.de> <vkobnnw3ij2n47bhhooawbw546dgwzii32nfqcx4bduoga5d7r@vdo5ryq4mffz>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vkobnnw3ij2n47bhhooawbw546dgwzii32nfqcx4bduoga5d7r@vdo5ryq4mffz>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 24, 2025 at 02:31:02PM +0100, Jan Kara wrote:
> > +	if (wbc->sync_mode == WB_SYNC_ALL ||
> > +	    time_after(jiffies, inode->dirtied_time_when +
> > +			dirtytime_expire_interval * HZ))
> > +		sync_lazytime(inode);
> 
> The checking of inode->dirtied_time_when for inode potentially without
> I_DIRTY_TIME set (and thus with unclear value of dirtied_time_when) is kind
> of odd. It is harmless but IMO still not a good practice. Can't we keep
> this condition as is and just call sync_lazytime()?

As in keeping the I_DIRTY_TIME in the caller?  Sure, I could do that.


