Return-Path: <io-uring+bounces-1514-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB0F8A1F18
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 21:08:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C1C2286434
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 19:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8BF14286;
	Thu, 11 Apr 2024 19:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ADyqhdI3"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A943616419;
	Thu, 11 Apr 2024 19:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712862468; cv=none; b=PxOukDSlGv2paI+DZpOT4F5mqdX2fn4fLq8kn3eMycFGrnYe42zD8bt3aKVj/UxyYBspm6U7JzyG9jGxbnrcIL88awZUBbU/vktrvcBPN9bH5p3eoRJRG0dEz1T4j1eGAhSgofOPad0pqDfK56B6i/7SO+Oy2jhJZguWcM+DpHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712862468; c=relaxed/simple;
	bh=p3xSOxPuATlO71p9cnskaQJETJN0PeGN1xAKog1Qdp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPnogClrvwI4Po/Gbpg0s0nvtKKBqzrE8scEHcoOj1z8BCQFOJggtvbq9sPblZoak1ugy40S/ensGwBFqiRrEzaZM6XesXqYpQOAztGIr13u4+clwZpj8xwQs/fLDfNP/x/ygJixMVmYPMF1ex/BldR/7npXXUUIXE7NucgCCzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ADyqhdI3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PcZdbAxSEwXG3C61TyMUijUHCCvRVt8slQPN1FDjo1k=; b=ADyqhdI3aTXSxUH/1EFE7yxMaw
	Q/QzwIQp/Krx4PAZO26/s23+4WUezyP+nlstWI47eqnw9vZDe7z/lyJIztc/96TDC49tOC1plCsR2
	zHy/WFYe0Kw56iwPRg64drflom1IXRv9eRYpFdHBk9eGmtNolVadhrxb6suoJ0hIVGWEZhPmZTPYg
	rosmBvK/anQCPG0g9QahmGRPMjF6Z3lCQfxGj2kLxRhSIrl9CfEqcWT6LUTPP8E9eoliydSsex3HU
	4j7XG1TVO6TdnYQ//KK/md0lE/EhlDTciT0dgNlRVUCfFA+ZzNSkrDvXI1mmHqQlIfglCNXCKzMvH
	IzGtMSjA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruzls-0000000Dp2X-0ZEf;
	Thu, 11 Apr 2024 19:07:40 +0000
Date: Thu, 11 Apr 2024 12:07:40 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>,
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
Message-ID: <Zhg0_Pvlh9zy4zzG@bombadil.infradead.org>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
 <c4c0dad5-41a4-44b4-8f40-2a250571180b@oracle.com>
 <Zg7Z4aJtn3SxY5w1@casper.infradead.org>
 <f3c1d321-0dfc-466f-9f6a-fe2f0513d944@oracle.com>
 <ZhQud1NbO4aMt0MH@bombadil.infradead.org>
 <b0789a97-7dcf-48aa-9980-8525942dabfa@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0789a97-7dcf-48aa-9980-8525942dabfa@oracle.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Wed, Apr 10, 2024 at 09:34:36AM +0100, John Garry wrote:
> On 08/04/2024 18:50, Luis Chamberlain wrote:
> > I agree that when you don't set the sector size to 16k you are not forcing the
> > filesystem to use 16k IOs, the metadata can still be 4k. But when you
> > use a 16k sector size, the 16k IOs should be respected by the
> > filesystem.
> > 
> > Do we break BIOs to below a min order if the sector size is also set to
> > 16k?  I haven't seen that and its unclear when or how that could happen.
> 
> AFAICS, the only guarantee is to not split below LBS.

It would be odd to split a BIO given a inode requirement size spelled
out, but indeed I don't recall verifying this gaurantee.

> > At least for NVMe we don't need to yell to a device to inform it we want
> > a 16k IO issued to it to be atomic, if we read that it has the
> > capability for it, it just does it. The IO verificaiton can be done with
> > blkalgn [0].
> > 
> > Does SCSI*require*  an 16k atomic prep work, or can it be done implicitly?
> > Does it need WRITE_ATOMIC_16?
> 
> physical block size is what we can implicitly write atomically.

Yes, and also on flash to avoid read modify writes.

> So if you
> have a 4K PBS and 512B LBS, then WRITE_ATOMIC_16 would be required to write
> 16KB atomically.

Ugh. Why does SCSI requires a special command for this?

Now we know what would be needed to bump the physical block size, it is
certainly a different feature, however I think it would be good to
evaluate that world too. For NVMe we don't have such special write
requirements.

I put together this kludge with the last patches series of LBS + the
bdev cache aops stuff (which as I said before needs an alternative
solution) and just the scsi atomics topology + physical block size
change to easily experiment to see what would break:

https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=20240408-lbs-scsi-kludge

Using a larger sector size works but it does not use the special scsi
atomic write.

> > > To me, O_ATOMIC would be required for buffered atomic writes IO, as we want
> > > a fixed-sized IO, so that would mean no mixing of atomic and non-atomic IO.
> > Would using the same min and max order for the inode work instead?
> 
> Maybe, I would need to check further.

I'd be happy to help review too.

  Luis

