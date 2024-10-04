Return-Path: <io-uring+bounces-3404-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C8D598FD03
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 07:31:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C84E5B22140
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 05:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67BFF17758;
	Fri,  4 Oct 2024 05:31:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0592D1D5ADA;
	Fri,  4 Oct 2024 05:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728019896; cv=none; b=c+H6upHBhHtHXdbLdZgzhYqz2e8KcqEfW4cq7PelBHihN7sUapKwlcrnBNAk1niRBDTepjkUfa9OSsM4/920G+93qdx9eYBZWq9PehSnroGAKwLRPRF5hVTru8hXpYltru4x5Z2NIUlUGBIqWMTrJOTVjDVMRMxoSv2b9ajABQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728019896; c=relaxed/simple;
	bh=nUEuLQ1T+SsbWS+ChW4nTKZEi5kAcOmQwITs0gm1xEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tgfmQtIAJgSYRN5KYE8yXWTdfpulBDiriSdjJAL8P2BYTig6gFDMIOzQbuUcJKTzuHzmE5w+XFxb0ctQZK0Uk1quEwn8xiziQGi4UAtzsgkwJpUrlSm9zjz8Q7ZiNFlz0oFygE17uz6REYUV9g4VWv2a/WKO1lqR8Rzirh4kCU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C2B83227A87; Fri,  4 Oct 2024 07:31:21 +0200 (CEST)
Date: Fri, 4 Oct 2024 07:31:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Kanchan Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	bvanassche@acm.org, asml.silence@gmail.com,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-aio@kvack.org, gost.dev@samsung.com, vishak.g@samsung.com,
	javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241004053121.GB14265@lst.de>
References: <20241001092047.GA23730@lst.de> <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk> <20241002075140.GB20819@lst.de> <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk> <20241002151344.GA20364@lst.de> <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com> <20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com> <20241003125400.GB17031@lst.de> <c68fef87-288a-42c7-9185-8ac173962838@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c68fef87-288a-42c7-9185-8ac173962838@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 03, 2024 at 04:14:57PM -0600, Jens Axboe wrote:
> On 10/3/24 6:54 AM, Christoph Hellwig wrote:
> > For file: yes.  The problem is when you have more files than buckets on
> > the device or file systems.  Typical enterprise SSDs support somewhere
> > between 8 and 16 write streams, and there typically is more data than
> > that.  So trying to group it somehow is good idea as not all files can
> > have their own bucket.
> > 
> > Allowing this inside a file like done in this patch set on the other
> > hand is pretty crazy.
> 
> I do agree that per-file hints are not ideal. In the spirit of making
> some progress, how about we just retain per-io hints initially? We can
> certainly make that work over dio. Yes buffered IO won't work initially,
> but at least we're getting somewhere.

Huh?  Per I/O hints at the syscall level are the problem (see also the
reply from Martin).  Per file make total sense, but we need the file
system in control.

The real problem is further down the stack.  For the SCSI temperature
hints just passing them on make sense.  But when you map to some kind
of stream separation in the device, no matter if that is streams, FDP,
or various kinds of streams we don't even support in thing like CF
and SDcard, the driver is not the right place to map temperature hint
to streams.  The requires some kind of intelligence.  It could be
dirt simple and just do a best effort mapping of the temperature
hints 1:1 to separate write streams, or do a little mapping if there
is not enough of them which should work fine for a raw block device.

But one we have a file system things get more complicated:

 - the file system will want it's own streams for metadata and GC
 - even with that on beefy enough hardware you can have more streams
   then temperature levels, and the file system can and should
   do intelligen placement (based usually on files)

Or to summarize:  the per-file temperature hints make sense as a user
interface.  Per-I/O hints tend to be really messy at least if a file
system is involved.  Placing the temperatures to separate write streams
in the driver does not scale even to the most trivial write stream
aware file system implementations.

And for anyone who followed the previous discussions of the patches
none of this should been new, each point has been made at least three
times before.


