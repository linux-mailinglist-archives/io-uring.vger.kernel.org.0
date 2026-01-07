Return-Path: <io-uring+bounces-11431-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 61F40CFC624
	for <lists+io-uring@lfdr.de>; Wed, 07 Jan 2026 08:36:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id F3D1B300183F
	for <lists+io-uring@lfdr.de>; Wed,  7 Jan 2026 07:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8614D250BEC;
	Wed,  7 Jan 2026 07:36:00 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DCA264638;
	Wed,  7 Jan 2026 07:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767771360; cv=none; b=IjKLmPoPTYwkDtATFbVHLUlsiiG+Lshyxsg7OVbfOjR4fvAuPyYFaNGgQNk+kTf+YX/9yUtJRrcjau1btXb6eaZDWfHOka/qzEuirgLjgoS5nirfy+LV+GQwrqgFrAY77l5xfEe5xZlDZXsdXCHhG34YETJdK+iBRCSocf6RICw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767771360; c=relaxed/simple;
	bh=MYOuB/KZfOgHfaM3iD3cEkrlO8Alm/fztkpNRGJNxs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hPFds8DeCyz+c7HRVDcAYUUJbUjKZe9Oa2c58ARQWmdM3j88ddL6whefs0oaEn2NROKjfbRxhxytya5oNdp1VN+UsB3vH7b4hA3jxhz5EDzfhpo7AOClpf+FX36JQRXMdH0MAePcqDE/CzAHm/QO7V1OAKinPq1BXvNYMhl+BiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5170F227A87; Wed,  7 Jan 2026 08:35:53 +0100 (CET)
Date: Wed, 7 Jan 2026 08:35:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, io-uring@vger.kernel.org,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 05/11] fs: refactor ->update_time handling
Message-ID: <20260107073552.GB17448@lst.de>
References: <20260106075008.1610195-1-hch@lst.de> <20260106075008.1610195-6-hch@lst.de> <jlw4ghr5vx32ss576akxes25oodlcx42zak7vjaaktlgn3m3d7@cbpcvx66y7za>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jlw4ghr5vx32ss576akxes25oodlcx42zak7vjaaktlgn3m3d7@cbpcvx66y7za>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 06, 2026 at 12:48:47PM +0100, Jan Kara wrote:
> > +static int inode_update_cmtime(struct inode *inode)
> > +{
> > +	struct timespec64 now = inode_set_ctime_current(inode);
> 
> This needs to be below sampling of ctime. Otherwise inode dirtying will be
> broken...

Fixed.


