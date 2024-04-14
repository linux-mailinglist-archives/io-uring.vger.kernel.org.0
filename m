Return-Path: <io-uring+bounces-1540-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C6758A4578
	for <lists+io-uring@lfdr.de>; Sun, 14 Apr 2024 22:50:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 089AA280E6D
	for <lists+io-uring@lfdr.de>; Sun, 14 Apr 2024 20:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4F7136649;
	Sun, 14 Apr 2024 20:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PtLHbReA"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E714E18E1D;
	Sun, 14 Apr 2024 20:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713127829; cv=none; b=IdRXfZGti5F40Sw9Fx5EI5/7wL1FmtESzl05rLJzYhpKIV62wbOoyqaq9l2ACQCKXPXNYC6ai0Tqw9TeLUAyz6mlLfuEHUv0iYPUkwjTKDAvAXttYOjzUASRYKIej5cMNGmf1ZonsAV4xk3dFX8RO8ahksvYYE68IgLuwV8NXwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713127829; c=relaxed/simple;
	bh=F4vbb1SRBmgpVZuLjWS+M3TEdCeLFcPYBYURh/MbXT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mc+exxCff8uAxzVsfms1bpHhD+gtrdzaTw8LUONsKi8xVdZajzJEdyTnXFEi4jXqpnjeV2vJWh9NEfPPlEke5oIzq8kA0Vak4fnZ2sbjAzjWxSiAN8751zo+AyzIxo3SSAiWyRcqMVWWYfK2qdYybbDNE/gR5pQAVm2l9wd74Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PtLHbReA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Fsqo+TcihzvYrlHKzsufMdVp0+RBP5LCcQAVZASLf7k=; b=PtLHbReA2YowMxzMDhLrmIA2MJ
	yJYbXJQ0ZbYLQ/SMNhgGTcDpPfRZkAI6xThUkPM1wevXaJ7rbvA4AFVvUeDD2joY6ZUCHJixCmCkY
	MtEJo+KT6LUT2oeZUpWWvQI56Tf3GWsYHPZC0y3thYyQsc4k8zFKAALCBBtX1nj08Tcjt934Qn5aX
	IQBVwS55vs5QwynPLaqOgWi+bNbOwhZlCW1uLtVUmtpsSsoROR/XJVSnkNDkIxnmmyET8yFI9D7Ao
	CAQnNJFsm/ei3C4lwrxQUPQXwOKDDNL9R21DHi4SjGA0B05DcPMAs9lPAxPMAgoT1j5Z+as759b6W
	g95FC3eg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rw6no-00000006NUn-3vr6;
	Sun, 14 Apr 2024 20:50:17 +0000
Date: Sun, 14 Apr 2024 13:50:16 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
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
Message-ID: <ZhxBiLSHuW35aoLB@bombadil.infradead.org>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
 <c4c0dad5-41a4-44b4-8f40-2a250571180b@oracle.com>
 <Zg7Z4aJtn3SxY5w1@casper.infradead.org>
 <f3c1d321-0dfc-466f-9f6a-fe2f0513d944@oracle.com>
 <ZhQud1NbO4aMt0MH@bombadil.infradead.org>
 <ZhYQANQATz82ytl1@casper.infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYQANQATz82ytl1@casper.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Wed, Apr 10, 2024 at 05:05:20AM +0100, Matthew Wilcox wrote:
> On Mon, Apr 08, 2024 at 10:50:47AM -0700, Luis Chamberlain wrote:
> > On Fri, Apr 05, 2024 at 11:06:00AM +0100, John Garry wrote:
> > > On 04/04/2024 17:48, Matthew Wilcox wrote:
> > > > > > The thing is that there's no requirement for an interface as complex as
> > > > > > the one you're proposing here.  I've talked to a few database people
> > > > > > and all they want is to increase the untorn write boundary from "one
> > > > > > disc block" to one database block, typically 8kB or 16kB.
> > > > > > 
> > > > > > So they would be quite happy with a much simpler interface where they
> > > > > > set the inode block size at inode creation time,
> > > > > We want to support untorn writes for bdev file operations - how can we set
> > > > > the inode block size there? Currently it is based on logical block size.
> > > > ioctl(BLKBSZSET), I guess?  That currently limits to PAGE_SIZE, but I
> > > > think we can remove that limitation with the bs>PS patches.
> > 
> > I can say a bit more on this, as I explored that. Essentially Matthew,
> > yes, I got that to work but it requires a set of different patches. We have
> > what we tried and then based on feedback from Chinner we have a
> > direction on what to try next. The last effort on that front was having the
> > iomap aops for bdev be used and lifting the PAGE_SIZE limit up to the
> > page cache limits. The crux on that front was that we end requiring
> > disabling BUFFER_HEAD and that is pretty limitting, so my old
> > implementation had dynamic aops so to let us use the buffer-head aops
> > only when using filesystems which require it and use iomap aops
> > otherwise. But as Chinner noted we learned through the DAX experience
> > that's not a route we want to again try, so the real solution is to
> > extend iomap bdev aops code with buffer-head compatibility.
> 
> Have you tried just using the buffer_head code?  I think you heard bad
> advice at last LSFMM.  Since then I've landed a bunch of patches which
> remove PAGE_SIZE assumptions throughout the buffer_head code, and while
> I haven't tried it, it might work.  And it might be easier to make work
> than adding more BH hacks to the iomap code.

I have considered it but the issue is that *may work* isn't good enough and
without a test plan for buffer-heads on a real filesystem this may never
suffice. Addressing a buffere-head iomap compat for the block device cache
is less error prone here for now.

  Luis

