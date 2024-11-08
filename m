Return-Path: <io-uring+bounces-4566-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BFE59C2277
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 17:54:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C8B01C2324C
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 16:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0089C1991D7;
	Fri,  8 Nov 2024 16:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C2lLtvWI"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B941990B3;
	Fri,  8 Nov 2024 16:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731084881; cv=none; b=qfSA5vYX4SR+pA/vyq9ELPzkzaD/Br3+rfKJ9ZR9RSDsZh5KkANkFKxandmWX53dqD3Q6v+W2okcy10JIwFIk0iyVqTP0WzLv8BVv9tiyzaalVQuS+fr+XHQ2tHQG+8FguLlyD+Kp8mNBWyT6N86nqB36uNVkFwx5WElgRtyplU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731084881; c=relaxed/simple;
	bh=E0EZ/sxws/NGF6AvtsX0MIm2JEy4i9WWwwZh3CclBUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R0vtHosdd15OR0vPx02YlnO5VxPfDFrpsTK5BKzIUyqpoZ/nQLHNiIRoo7RwU4yl7BxJsGB0fYsWAvYLaoIRa79xqo0O7jYMbYx7amujCoSD53Zm3Ke+Uk0rJcpgZ+NjgM0GTzKPA80/x9/gk/GDprMRV4B0Hh3XmD9mgvo4s7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C2lLtvWI; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8WOWX2ViKLpGC5S466nNFKPxXmrIIp9DY7fU8LLtYuo=; b=C2lLtvWITVHGHLciF/2Bj25Rqg
	RcI1MAjloGD1+aEhk7MLAtgh5GwL5L1aB0j0k0+28Rg40xQxnAAvHy7xRv2tb9lNPUHTPP9YC2c6J
	brxQpqhitJMvPJ4LErKW6PTJwgXnsUgdU6g44yZUK1FZuBGwA2PaSFH7E8wPyP1tcHRgQW7BlUfzs
	HU543g/tSng67+bcwNqg5cPkEvG4gg80cBf6n9qCu75U1E/ksxVVFHGmYgWbIfALfFA2UepS8d1lD
	v0ZoQY8qwHWAi9/vhAXVCWbRLEuKfQ6DweVyodc8fR8CAHaiqEtxCiXGHQdEznqspMXA1bbo6Bc8h
	i7glbyHw==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t9SFm-0000000959i-25EG;
	Fri, 08 Nov 2024 16:54:34 +0000
Date: Fri, 8 Nov 2024 16:54:34 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <Zy5CSgNJtgUgBH3H@casper.infradead.org>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241105155014.GA7310@lst.de>
 <Zy0k06wK0ymPm4BV@kbusch-mbp>
 <20241108141852.GA6578@lst.de>
 <Zy4zgwYKB1f6McTH@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zy4zgwYKB1f6McTH@kbusch-mbp>

On Fri, Nov 08, 2024 at 08:51:31AM -0700, Keith Busch wrote:
> On Fri, Nov 08, 2024 at 03:18:52PM +0100, Christoph Hellwig wrote:
> > We're not really duplicating much.  Writing sequential is pretty easy,
> > and tracking reclaim units separately means you need another tracking
> > data structure, and either that or the LBA one is always going to be
> > badly fragmented if they aren't the same.
> 
> You're getting fragmentation anyway, which is why you had to implement
> gc. You're just shifting who gets to deal with it from the controller to
> the host. The host is further from the media, so you're starting from a
> disadvantage. The host gc implementation would have to be quite a bit
> better to justify the link and memory usage necessary for the copies
> (...queue a copy-offload discussion? oom?).

But the filesystem knows which blocks are actually in use.  Sending
TRIM/DISCARD information to the drive at block-level granularity hasn't
worked out so well in the past.  So the drive is the one at a disadvantage
because it has to copy blocks which aren't actually in use.

I like the idea of using copy-offload though.

