Return-Path: <io-uring+bounces-10770-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1861EC80E96
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 15:07:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 029EF4E2D29
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 14:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B936A30E0F3;
	Mon, 24 Nov 2025 14:07:55 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D8F30DEAF;
	Mon, 24 Nov 2025 14:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763993275; cv=none; b=TP5JJTgGAWn8DUr7za8GaalL1IVhAGMdbPDdm+GvyM2UUhC1IL4BS+DEcaMFqJy7AJIjKy+UUaIIkPBTXHAOeKu/jSvaAK5zdBiCfvNcGUe4MRRvW2g3mhhCiTRovWOR5QymhqTb4pvZYOGPud61xcs8ieOHvIFAxXqsd389L34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763993275; c=relaxed/simple;
	bh=P9EdTF1MezUbkGSY3Ff+pcwlx5yl4Irjd0IA0naJ6n0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QTD3Ejsa5Pyrz5rOz5MYmN8CCux7PiEit9fW2hlYoXsejvbWnY/YSspWUK88/dwYOzVLLzcsTnijWoroqrL69FUtEQwXd0NXla2S2EBCixIOI0g4oeIVdWYfbx60fSTDyDPe08DKzDIOYt3xvdLgpLsbcWK1jjRg5YRl2tXPGdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A379A68B05; Mon, 24 Nov 2025 15:07:47 +0100 (CET)
Date: Mon, 24 Nov 2025 15:07:46 +0100
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
Subject: Re: [PATCH 09/14] fs: factor out a mark_inode_dirty_time helper
Message-ID: <20251124140746.GA14417@lst.de>
References: <20251114062642.1524837-1-hch@lst.de> <20251114062642.1524837-10-hch@lst.de> <fbym7i2zelbatxbhy5eeffwpa3ni7bstjddbf7ran7djzthwjo@kfxj3wrxeuou>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbym7i2zelbatxbhy5eeffwpa3ni7bstjddbf7ran7djzthwjo@kfxj3wrxeuou>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 24, 2025 at 02:22:59PM +0100, Jan Kara wrote:
> What I find a bit concerning here is that mark_inode_dirty_time() takes a
> different kind of flags than __mark_inode_dirty() so it's relatively easy
> to confuse. Proper typing of 'flags' would be nice here but it's a bit
> cumbersome to do in C so I'm not sure if it's worth it for this relatively
> limited use. So I guess feel free to add:

Adding a __bitwise annotation for the S_ flags seems easy enough
as there's not a whole lot of variables/arguments of that time.  I can
do that as a follow-on.


