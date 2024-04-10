Return-Path: <io-uring+bounces-1491-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42A3589E8AB
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 06:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D74481F2515E
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 04:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8EDBBE5A;
	Wed, 10 Apr 2024 04:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ClEKjZyn"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D400B4C94;
	Wed, 10 Apr 2024 04:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712721940; cv=none; b=RKJggihAd7jubdzLs23ck7tNRa/p01TXZlV8G2rr8cSQLqvTMIyXYz6ltKpT8UKGF573CUO/r6XkfGgnNOEF9m+qE8fbKpR/8fNgTnKTNXyQcKiQ78YzcHF9c0CxyW2PFLA34Ib5HP/33LtQREXUkgOOg6D+9oQKrVifHOUPfjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712721940; c=relaxed/simple;
	bh=KWJYcJImYSZUHfkkZGcSRS3Vw/Qv1TU4MIWBb6oY7/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SdyxgRB2U1vtDZdoPEsaoz6Ww7u5oSGfspOr8Q52/L/oNtkRHo33X641D6CVGo+EyeOMI8n70bH3rJwicGFyebIgPIodLFHBZJXiw13JJtMbPTrA+vIWrkrtb+vn00KUNSQvrC6Ja3BVNxfuQ5oI4wB4OG9QOKXpy/x6zfGHkxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ClEKjZyn; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qs5zPeAsEcTuuvWHCl8rO9RDQhxhl31TRFIHSeLuueU=; b=ClEKjZyn0q+YoWT29QBVUZv3x4
	7ISBLoo3ezuPgISr4g1j134YmhOhC3bGqp/zBcIxc/aIa2f1wbY3tEj4KA35QtdzIjwNvWTmykbXZ
	DFP3fKW2rcC1gxLGBJ4PkcEZIPKb+26gGieZFatmm0nFBXNkjWN3rVkCGdIPy9wmstcMXjWPMILP1
	oDIIbPGGkcggayy9BUb5XOLhqvRRiJjzZmgA5Ox3pXKzSoPue9vqLgwAQz+r+RAbBwoC+mSzhUM7z
	xG/FpDxPzMuVfmcrJ8mIaztiG4XhivtLEK/40Tx7XFqq8UKlf/wodX/BukW2wTCz599syOPVXetah
	7vprz9MQ==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruPD6-00000003bR4-2bWn;
	Wed, 10 Apr 2024 04:05:20 +0000
Date: Wed, 10 Apr 2024 05:05:20 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>,
	axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com
Subject: Re: [PATCH v6 00/10] block atomic writes
Message-ID: <ZhYQANQATz82ytl1@casper.infradead.org>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
 <c4c0dad5-41a4-44b4-8f40-2a250571180b@oracle.com>
 <Zg7Z4aJtn3SxY5w1@casper.infradead.org>
 <f3c1d321-0dfc-466f-9f6a-fe2f0513d944@oracle.com>
 <ZhQud1NbO4aMt0MH@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhQud1NbO4aMt0MH@bombadil.infradead.org>

On Mon, Apr 08, 2024 at 10:50:47AM -0700, Luis Chamberlain wrote:
> On Fri, Apr 05, 2024 at 11:06:00AM +0100, John Garry wrote:
> > On 04/04/2024 17:48, Matthew Wilcox wrote:
> > > > > The thing is that there's no requirement for an interface as complex as
> > > > > the one you're proposing here.  I've talked to a few database people
> > > > > and all they want is to increase the untorn write boundary from "one
> > > > > disc block" to one database block, typically 8kB or 16kB.
> > > > > 
> > > > > So they would be quite happy with a much simpler interface where they
> > > > > set the inode block size at inode creation time,
> > > > We want to support untorn writes for bdev file operations - how can we set
> > > > the inode block size there? Currently it is based on logical block size.
> > > ioctl(BLKBSZSET), I guess?  That currently limits to PAGE_SIZE, but I
> > > think we can remove that limitation with the bs>PS patches.
> 
> I can say a bit more on this, as I explored that. Essentially Matthew,
> yes, I got that to work but it requires a set of different patches. We have
> what we tried and then based on feedback from Chinner we have a
> direction on what to try next. The last effort on that front was having the
> iomap aops for bdev be used and lifting the PAGE_SIZE limit up to the
> page cache limits. The crux on that front was that we end requiring
> disabling BUFFER_HEAD and that is pretty limitting, so my old
> implementation had dynamic aops so to let us use the buffer-head aops
> only when using filesystems which require it and use iomap aops
> otherwise. But as Chinner noted we learned through the DAX experience
> that's not a route we want to again try, so the real solution is to
> extend iomap bdev aops code with buffer-head compatibility.

Have you tried just using the buffer_head code?  I think you heard bad
advice at last LSFMM.  Since then I've landed a bunch of patches which
remove PAGE_SIZE assumptions throughout the buffer_head code, and while
I haven't tried it, it might work.  And it might be easier to make work
than adding more BH hacks to the iomap code.

A quick audit for problems ...

__getblk_slow:
       if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
                        (size < 512 || size > PAGE_SIZE))) {

cont_expand_zero (not used by bdev code)
cont_write_begin (ditto)

That's all I spot from a quick grep for PAGE, offset_in_page() and kmap.

You can't do a lot of buffer_heads per folio, because you'll overrun
        struct buffer_head *bh, *head, *arr[MAX_BUF_PER_PAGE];
in block_read_full_folio(), but you can certainly do _one_ buffer_head
per folio, and that's all you need for bs>PS.

> I suspect this is a use case where perhaps the max folio order could be
> set for the bdev in the future, the logical block size the min order,
> and max order the large atomic.

No, that's not what we want to do at all!  Minimum writeback size needs
to be the atomic size, otherwise we have to keep track of which writes
are atomic and which ones aren't.  So, just set the logical block size
to the atomic size, and we're done.


