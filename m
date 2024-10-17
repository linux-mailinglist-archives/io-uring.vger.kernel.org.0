Return-Path: <io-uring+bounces-3785-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5459B9A2676
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 17:23:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08BD31F234E7
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 15:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D645A1DE4EB;
	Thu, 17 Oct 2024 15:23:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EE3111AD;
	Thu, 17 Oct 2024 15:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729178624; cv=none; b=lEuER1QIhLJUHZleTSggP+wSqnwbA3ViXSJClV8T5wKy7rpg7if8UPYNr5delfmMP/O2NMcOGcKbFB13thHfYTKNuts1EIW4DU62Hc6Ex93AcrzwM5ryMB3Z4ecHQ3EbsFFYXinFCGx9o1Ylh2cqjKbycL8WRhz7aBscTc2aCpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729178624; c=relaxed/simple;
	bh=le4VB4b0n93zSCV37N2PIWDQ3Rzmu0T7S4TGih9DMsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TlY+whNkF3qnveXJIHADMJHjQyXKD31WsL67gw1VwQ0cfeXMsqmoqYaNaMPZmkw4Dd0EEdTkZb1cn+LWqd0XFhQGdkZDovV2VXHRQg/d0LbSfj7M0xczN5EZYXm5HlsXrlibIa/DgCWUGCc991S5w/qq+OsLMBUfoSXjzdtO4U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 32601227A8E; Thu, 17 Oct 2024 17:23:37 +0200 (CEST)
Date: Thu, 17 Oct 2024 17:23:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
	hare@suse.de, sagi@grimberg.me, martin.petersen@oracle.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	bvanassche@acm.org, asml.silence@gmail.com,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-aio@kvack.org, gost.dev@samsung.com, vishak.g@samsung.com,
	javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241017152336.GA25327@lst.de>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com> <20240930181305.17286-1-joshi.k@samsung.com> <20241015055006.GA18759@lst.de> <8be869a7-c858-459a-a34b-063bc81ce358@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8be869a7-c858-459a-a34b-063bc81ce358@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 17, 2024 at 08:05:38PM +0530, Kanchan Joshi wrote:
> Seems per-I/O hints are not getting the love they deserve.
> Apart from the block device, the usecase is when all I/Os of VM (or 
> container) are to be grouped together or placed differently.

But that assumes the file system could actually support it.  Which
is hard when you don't assume the file system isn't simply a passthrough
entity, which will not give you great results.

> > 2) A per-I/O interface to set these temperature hint conflicts badly
> > with how placement works in file systems.  If we have an urgent need
> > for it on the block device it needs to be opt-in by the file operations
> > so it can be enabled on block device, but not on file systems by
> > default.  This way you can implement it for block device, but not
> > provide it on file systems by default.  If a given file system finds
> > a way to implement it it can still opt into implementing it of course.
> 
> Why do you see this as something that is so different across filesystems 
> that they would need to "find a way to implement"?

If you want to do useful stream separation you need to write data
sequentially into the stream.  Now with streams or FDP that does not
actually imply sequentially in LBA space, but if you want the file
system to not actually deal with fragmentation from hell, and be
easily track what is grouped together you really want it sequentially
in the LBA space as well.  In other words, any kind of write placement
needs to be intimately tied to the file system block allocator.

> Both per-file and per-io hints are supplied by userspace. Inode and 
> kiocb only happen to be the mean to receive the hint information.
> FS is free to use this information (iff it wants) or simply forward this 
> down.

As mentioned above just passing it down is not actually very useful.
It might give you nice benchmark numbers when you basically reimplement
space management in userspace on a fully preallocated file, but for that
you're better of just using the block device.  If you actually want
to treat the files as files you need full file system involvement.

> Per-file hint just gets stored (within inode) without individual FS 
> involvement. Per-io hint follows the same model (i.e., it is set by 
> upper layer like io_uring/aio) and uses kiocb to store the hint. It does 
> not alter the stored inode hint value!

Yes, and now you'll get complaints that the file system ignores it
when it can't properly support it.  This is why we need a per-fop
opt in.

> The generic code (like fs/direct-io.c, fs/iomap/direct-io.c etc.,) 
> already forwards the incoming hints, without any intelligence.

Yes, and that is a problem.  We stopped doing that, but Samsung sneaked
some of this back in recently as I noticed.

> Overall, I do not see the conflict. It's all user-driven. No?

I have the gut feeling that you've just run benchmarks on image files
emulating block devices and not actually tried real file system workloads
based on this unfortunately.


