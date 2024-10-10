Return-Path: <io-uring+bounces-3551-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9079A998201
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 11:22:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFE461C24AFF
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 09:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B1821BDAB2;
	Thu, 10 Oct 2024 09:20:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600821BDA91;
	Thu, 10 Oct 2024 09:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728552019; cv=none; b=SURgbf9NzgiF8ebRdsW5FTeqU4cdH76l3JOYsqVBjAyTwbc4asEegBqswP/3UFdy8vYsDKzsn/XLf9P3MPmoJq8G4Dbmhf3Cb7641rRX6kIYGAaK/xiAkqffM8W6/D1a5zBi8Qj3py2Y+qoflEFcAEi/Vf2LcUeuVIjKj29Y+Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728552019; c=relaxed/simple;
	bh=bTnovMZgsgVOSlQlxmcq3a9nkqLgejdN9piq3zqLQ9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jqYcREFbu+eaUVlCguQ/FWNN1MAa3Lx8jrecIVZoQ8yj05z/oDYIvwhkMdx5f0Cip+ipgHYeTn+VJvL9/F7l71PxP/PGh/cMaLUJZNfvOqwTrL9TZFPXfEJRDfC+oJNRgJQ73vlAqFRke7E8fM0m+xdIYm7DGHE26auZIa1s468=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 14AAD227A8E; Thu, 10 Oct 2024 11:20:11 +0200 (CEST)
Date: Thu, 10 Oct 2024 11:20:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: Javier Gonzalez <javier.gonz@samsung.com>
Cc: Hans Holmberg <hans@owltronix.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Kanchan Joshi <joshi.k@samsung.com>, "hare@suse.de" <hare@suse.de>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"brauner@kernel.org" <brauner@kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"jack@suse.cz" <jack@suse.cz>,
	"jaegeuk@kernel.org" <jaegeuk@kernel.org>,
	"bcrl@kvack.org" <bcrl@kvack.org>,
	"dhowells@redhat.com" <dhowells@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-aio@kvack.org" <linux-aio@kvack.org>,
	"gost.dev@samsung.com" <gost.dev@samsung.com>,
	"vishak.g@samsung.com" <vishak.g@samsung.com>
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241010092010.GC9287@lst.de>
References: <20241004053121.GB14265@lst.de> <20241004061811.hxhzj4n2juqaws7d@ArmHalley.local> <20241004062733.GB14876@lst.de> <20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local> <20241004123027.GA19168@lst.de> <20241007101011.boufh3tipewgvuao@ArmHalley.local> <CANr-nt3TA75MSvTNWP3SwBh60dBwJYztHJL5LZvROa-j9Lov7g@mail.gmail.com> <97bd78a896b748b18e21e14511e8e0f4@CAMSVWEXC02.scsc.local> <CANr-nt11OJfLRFr=rzH0LyRUzVD9ZFLKsgree=Xqv__nWerVkg@mail.gmail.com> <20241010071327.rnh2wsuqdvcu2tx4@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010071327.rnh2wsuqdvcu2tx4@ArmHalley.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 10, 2024 at 09:13:27AM +0200, Javier Gonzalez wrote:
> Is this because RocksDB already does seggregation per file itself? Are
> you doing something specific on XFS or using your knoledge on RocksDB to
> map files with an "unwritten" protocol in the midde?

XFS doesn't really do anything smart at all except for grouping files
with similar temperatures, but Hans can probably explain it in more
detail.  So yes, this relies on the application doing the data separation
and using the most logical vehicle for it: files.

>
>    In this context, we have collected data both using FDP natively in
>    RocksDB and using the temperatures. Both look very good, because both
>    are initiated by RocksDB, and the FS just passes the hints directly
>    to the driver.
>
> I ask this to understand if this is the FS responsibility or the
> application's one. Our work points more to letting applications use the
> hints (as the use-cases are power users, like RocksDB). I agree with you
> that a FS could potentially make an improvement for legacy applications
> - we have not focused much on these though, so I trust you insights on
> it.

As mentioned multiple times before in this thread this absolutely
depends on the abstraction level of the application.  If the application
works on a raw device without a file system it obviously needs very
low-level control.  And in my opinion passthrough is by far the best
interface for that level of control.  If the application is using a
file system there is no better basic level abstraction than a file,
which can then be enhanced with relatively small amount of additional
information going both ways: the file system telling the application
what good file sizes and write patterns are, and the application telling
the file system what files are good candidates to merge into the same
write stream if the file system has to merge multiple actively written
to files into a write stream.  Trying to do low-level per I/O hints
on top of a file system is a recipe for trouble because you now have
to entities fighting over placement control.


