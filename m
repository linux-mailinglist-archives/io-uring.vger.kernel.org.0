Return-Path: <io-uring+bounces-1580-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 226A88A7622
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 23:11:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B43981F22F4F
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 21:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2B45B699;
	Tue, 16 Apr 2024 21:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e/VN90jy"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08915A4CF;
	Tue, 16 Apr 2024 21:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713301871; cv=none; b=KHmkV4StHvAcVJ7aj4cYEFBCRNniO4LCJCvCJpw5EcbNv06FVon5tKRuvN7j/bjs2+PWjsHh5IUt86Byq6k0iQS/Ycgok8tF5YjlfONXeyqS8kF9afSYQxeayJtLNkJee8jsviGH/DgoqLgxJvvwWyC5MxFOCk+a0WrTOZZRhis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713301871; c=relaxed/simple;
	bh=8FNV3zbi4W0+s5iELgnOQOr6ZJQLzz3pHFBU0pDSGJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J1n/8/c3XiYz9hEBVubiDSH96+nPSyQ8y/7ZbvectoBIahUA2m5Wu/nUZ3eTcwDIlw3vFXL6/6L+tGuwdx3x5ogjiYDzxD3K7wXgGuv+lnytbxlLmvu0p7CfcmJUdljUMemf6SbdRCaJfjsG9L9GCi1H6KqHPb8w+9U7rBx3s2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e/VN90jy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FRN0S0UrdEiWG4B5xuc/QvC+4jIMUlM9ivvZ43mxxCA=; b=e/VN90jySWq7d6XlyBQgn7rs3s
	AB6sQMjNqGP7kHOZRUxvLv1PlxeTKJU1QlDocHcG7Sk6ezLyKIZLtFc1Kv01cBGJCYbKrkBGhppnz
	RdCDVzplL6GgCvgY9WxCkdNOk0db7H9pR5PCWaG6viMfEi/NWo9vYJsHICdP1374dGYBb+Hg9zg7C
	d/c7mYXYvYTX+uzESF+M4iIf4TzuqsN9oBNYY40MhgyypVIlbBZLLJS2v99LboMM3MKOcQi9Uq07T
	3WhvCC9iOEV0Un8JNpAiRR7JMuzQRPCufe7TnGJPkZPUHXDDn8KP75jb+dXzq/DYlmzLcSVrvkCpI
	DBZ09n7A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwq4z-0000000Dp1F-3nSD;
	Tue, 16 Apr 2024 21:11:01 +0000
Date: Tue, 16 Apr 2024 14:11:01 -0700
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
Message-ID: <Zh7pZUwmQXF-qC6D@bombadil.infradead.org>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
 <c4c0dad5-41a4-44b4-8f40-2a250571180b@oracle.com>
 <Zg7Z4aJtn3SxY5w1@casper.infradead.org>
 <f3c1d321-0dfc-466f-9f6a-fe2f0513d944@oracle.com>
 <ZhQud1NbO4aMt0MH@bombadil.infradead.org>
 <ZhYQANQATz82ytl1@casper.infradead.org>
 <ZhxBiLSHuW35aoLB@bombadil.infradead.org>
 <Zh2ZptLxnwa_jtSk@casper.infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh2ZptLxnwa_jtSk@casper.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Apr 15, 2024 at 10:18:30PM +0100, Matthew Wilcox wrote:
> On Sun, Apr 14, 2024 at 01:50:16PM -0700, Luis Chamberlain wrote:
> > On Wed, Apr 10, 2024 at 05:05:20AM +0100, Matthew Wilcox wrote:
> > > Have you tried just using the buffer_head code?  I think you heard bad
> > > advice at last LSFMM.  Since then I've landed a bunch of patches which
> > > remove PAGE_SIZE assumptions throughout the buffer_head code, and while
> > > I haven't tried it, it might work.  And it might be easier to make work
> > > than adding more BH hacks to the iomap code.
> > 
> > I have considered it but the issue is that *may work* isn't good enough and
> > without a test plan for buffer-heads on a real filesystem this may never
> > suffice. Addressing a buffere-head iomap compat for the block device cache
> > is less error prone here for now.
> 
> Is it really your position that testing the code I already wrote is
> harder than writing and testing some entirely new code?  Surely the
> tests are the same for both.

The compat code would only allow large folios for iomap, and use
buffer-heads for non-large folios, so nothing much would change except
a special wrapper.

> Besides, we aren't talking about a filesystem on top of the bdev here.
> We're talking about accessing the bdev's page cache directly.

Sure, but my concern was the lack of testing for buffer-head large
folios. While for iomap we'd at least have done the ton of work to
stress test testing large folios while testing XFS with it.

While the block device cache is not a proper full blown filesystem,
it just means since no filesystem has been tested with buffer heads with
large folios its a possible minefield waiting to explode due to lack of
testing.

Is writing a proper test plan for the block device cache code with
buffer-heads with large folios less work than writing the compat code
for the block device cache? I concede that I'm not sure.

I'm happy to try it out to see what blows up.

  Luis

