Return-Path: <io-uring+bounces-6967-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B897A5017E
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 15:11:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7847189264F
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 14:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8670224A073;
	Wed,  5 Mar 2025 14:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kQzhYj77"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F00155751;
	Wed,  5 Mar 2025 14:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741183861; cv=none; b=MvcnTlCabcHpfMjiXBV5qdC+QaFXV6Ee1Pot7vgXXFhJE5vx4NppfMjNiynUfXJa7QoVoFMutHUlP7WXbAjg2fUpMvhGAgpqs4zC2MpiWos6OFhOmVzABvczeJl94+15Qt3Sw7wZaMi0kbeOTa313j19EpHOYQQtnH0vyvwOiow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741183861; c=relaxed/simple;
	bh=RigXWhKk1lS/tegXjHPsbf8sEUN3NntaWaJoQ+Izwa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETSbW50oPeNcW1PIOY9kCVL8yNIZxsSwgZ7l3hSWMU8E3EgrIZAaFwxND3pDjpnExHp3/YFO8fUJzZWaZEvHqYahSNuY+yuSrCgvaTD4IbjN2UXcEj490HUK0NnL7tXYZKTgbxGOlU8oJbMOgWh8jcm2jPyIXrasmHf91cxZang=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kQzhYj77; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jOWrYc0+9HlzrR3aKKb90D4IoCghYF5gZHmBO6zxWks=; b=kQzhYj77dCGr+9N1uRZlvvEzHD
	1OFRwZH7vwensH3pcwxMTpkm+1e/O/GUE7NAq0djcZiBrStOOE2hAZ8azU4qSiUCRoOvgr1Jnnguc
	Vk/Ya19P+7MXGBFIIv0NoMR2LCqYNlJz0A+KgoNIb3iYzstJEWnD+BRG7iqkMUBFA1Jejn7Yar0pJ
	j66CZz3pKtKEqjZIpvSKmFLhwLROnQEFHMyM6/bT2cHLkG3oCKQAwATyL7Y3jlx7NTwODm/Y/ujDb
	KZy5nlR6yizfmOCTjU3MbR+gmrUUwV4LWnwYEC8GQHduIaQpQgzfN0bRdPOB8qE8AJ1wWrpjIBsgn
	sTruLyvA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tppSd-00000008IPY-0VCH;
	Wed, 05 Mar 2025 14:10:59 +0000
Date: Wed, 5 Mar 2025 06:10:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
Message-ID: <Z8hbc5Nzp6cFMpXO@infradead.org>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8dsfxVqpv-kqeZy@dread.disaster.area>
 <970ec89d-4161-41f4-b66f-c65ebd4bd583@gmail.com>
 <Z8emslEolstG76A7@dread.disaster.area>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8emslEolstG76A7@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 05, 2025 at 12:19:46PM +1100, Dave Chinner wrote:
> I really don't care about what io_uring thinks or does. If the block
> layer REQ_NOWAIT semantics are unusable for non-blocking IO
> submission, then that's the problem that needs fixing. This isn't a
> problem we can (or should) try to work around in the iomap layer.

Agreed.  The problem are the block layer semantics.  iomap/xfs really
just is the messenger here.

> For example: we have RAID5 witha 64kB chunk size, so max REQ_NOWAIT
> io size is 64kB according to the queue limits. However, if we do a
> 64kB IO at a 60kB chunk offset, that bio is going to be split into a
> 4kB bio and a 60kB bio because they are issued to different physical
> devices.....
> 
> There is no way the bio submitter can know that this behaviour will
> occur, nor should they even be attempting to predict when/if such
> splitting may occur.

And for something that has a real block allocator it could also be
entirely dynamic.  But I'm not sure if dm-thinp or bcache do anything
like that at the moment.

> > Are you only concerned about the size being too restrictive or do you
> > see any other problems?
> 
> I'm concerned abou the fact that REQ_NOWAIT is not usable as it
> stands. We've identified bio chaining as an issue, now bio splitting
> is an issue, and I'm sure if we look further there will be other
> cases that are issues (e.g. bounce buffers).
> 
> The underlying problem here is that bio submission errors are
> reported through bio completion mechanisms, not directly back to the
> submitting context. Fix that problem in the block layer API, and
> then iomap can use REQ_NOWAIT without having to care about what the
> block layer is doing under the covers.

Exactly.  Either they need to be reported synchronously, or maybe we
need a block layer hook in bio_endio that retries the given bio on a
workqueue without ever bubbling up to the caller.  But allowing delayed
BLK_STS_AGAIN is going to mess up any non-trivial caller.  But even
for the plain block device is will cause duplicate I/O where some
blocks have already been read/written and then will get resubmitted.

I'm not sure that breaks any atomicity assumptions as we don't really
give explicit ones for block devices (except maybe for the new
RWF_ATOMIC flag?), but it certainly is unexpected and suboptimal.

