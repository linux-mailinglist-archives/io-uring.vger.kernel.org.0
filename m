Return-Path: <io-uring+bounces-11433-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A0FC1CFC6D2
	for <lists+io-uring@lfdr.de>; Wed, 07 Jan 2026 08:43:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B9DC0300F185
	for <lists+io-uring@lfdr.de>; Wed,  7 Jan 2026 07:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85BB29BDA1;
	Wed,  7 Jan 2026 07:43:52 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E722275AFD;
	Wed,  7 Jan 2026 07:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767771832; cv=none; b=ng8yAqkn6PdDsRKiPXCZJu47y4mpnYddH2yWyvXreNh3kVj+SBEdFM0HBFDVqUwY+YVpzPRisRpIspi0rVUSKALNV6AdrUzkj6OCiDfU+EJEJoHFLm18GMa8UV7YJdoQp+GcQUt4cfZa7U2pRbTp2aqeE1cwtyGEbHYg10hmvDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767771832; c=relaxed/simple;
	bh=VTimgj/MzK6aQnK9Xw5c5SKi0aFWlJKWsBW7pxOxiQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E3ph/71Ss0eq0+nRfO3yLXe8Ki+S7KfpEN9RrKMFu1Nn5jErdo8K1bgT8SwRA9V4smkXKY5raZGXcHm+FzXtXQpH+6IvV9MNIcJnOuZCTbxt0F7hJlbW3ZbKRDv8Sjm1T685gumCWeAVJ8lZVj+h5O87haYjS/vqxX99ykrtwmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7108E227A87; Wed,  7 Jan 2026 08:43:46 +0100 (CET)
Date: Wed, 7 Jan 2026 08:43:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
	Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, io-uring@vger.kernel.org,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 04/11] fat: cleanup the flags for fat_truncate_time
Message-ID: <20260107074346.GA18258@lst.de>
References: <20260106075008.1610195-1-hch@lst.de> <20260106075008.1610195-5-hch@lst.de> <87cy3nrpdu.fsf@mail.parknet.co.jp> <878qeask1x.fsf@mail.parknet.co.jp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878qeask1x.fsf@mail.parknet.co.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 07, 2026 at 02:55:06AM +0900, OGAWA Hirofumi wrote:
> > Thanks.
> 
> Ah, I was overlooking that new value is using same value with S_*.

Still not a good idea to not create a bisection hazard.  I've added
a local fat_flags variable and a translation for this patch, even
if that will go away in the next patch to be 100% sane.

> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

But I've kept the ACK.  Let me know if I should drop it for now with
the change instead.


