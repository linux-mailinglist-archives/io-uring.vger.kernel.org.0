Return-Path: <io-uring+bounces-1239-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68DCA88D52F
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 04:50:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CEA91F2CEC1
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 03:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC54222616;
	Wed, 27 Mar 2024 03:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k6AI2bfn"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2171BF31;
	Wed, 27 Mar 2024 03:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711511419; cv=none; b=NKLWOwmyqvHnMNUZcv2SKNcQe0Ti8ZG6xSHa35iIVq3cN6GcKLziCuaKleL3v6cdtT7EXQZmaxwztSl09y563ZWz8Y30EVXMeR2my0FJ/jK9K0lWiBnaSz1km9H6UpwaIj1NUY0XstT8WJ++JoozxjbU0XOGLypaDmTRQ0LXJyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711511419; c=relaxed/simple;
	bh=yxDuwLY/j7X4qrwh8xDbw8rteroxa22o47tiK/LWHgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rGUWnWSEzO7Db++j1e814O0vouSLqYWj8wLrkftf8KZj7b7KWokiZvb4jMsxjYDO7XLRhqmDQLLw943v8IDSJDFHvIx70d00npWjPXc3uq0mmTnyI/k6HMjAcKaigU9mdwMkQFlldF+AaZl92ymM4Ggk/afAd/BLYOGsZgI4ZtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k6AI2bfn; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rk1STaKASJZMOQESaE4YdsbKcHTwjlEtdkr30vV9pdg=; b=k6AI2bfnRnr2I3SiqEJhR0ATer
	L/tOjZtLNhHZu7N988MPkHPWZJoBDo+zKoYivmHKkU31eNPCva+VjDW+1R4Gm2R9QCg9X4JWeyq/e
	dI4XLAOq1DzhKn4YwIj+lcTmhL1RkuTgK/i1pDSmi9D6Lm5kMFE+Q+1wlg5UMNTm5hOwkCAqbRAJj
	IEUAQSGMrFpTRQY4p8k8ZrEEaxVf4ciY1E1jJcKZIkIQFhgMyGawFsbfpoeYbqpLUo4LPaD/rKBC3
	+6OIEw+02Zj2ueHh3TKcU/mDZsebPI/D73/FkvUZGJNikrmvbubgTIxVumhEwo5Ifk7nNsozpsf7o
	FJjRTWDA==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpKIh-00000002xYu-3gF1;
	Wed, 27 Mar 2024 03:50:07 +0000
Date: Wed, 27 Mar 2024 03:50:07 +0000
From: Matthew Wilcox <willy@infradead.org>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
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
Message-ID: <ZgOXb_oZjsUU12YL@casper.infradead.org>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326133813.3224593-1-john.g.garry@oracle.com>

On Tue, Mar 26, 2024 at 01:38:03PM +0000, John Garry wrote:
> The goal here is to provide an interface that allows applications use
> application-specific block sizes larger than logical block size
> reported by the storage device or larger than filesystem block size as
> reported by stat().
> 
> With this new interface, application blocks will never be torn or
> fractured when written. For a power fail, for each individual application
> block, all or none of the data to be written. A racing atomic write and
> read will mean that the read sees all the old data or all the new data,
> but never a mix of old and new.
> 
> Three new fields are added to struct statx - atomic_write_unit_min,
> atomic_write_unit_max, and atomic_write_segments_max. For each atomic
> individual write, the total length of a write must be a between
> atomic_write_unit_min and atomic_write_unit_max, inclusive, and a
> power-of-2. The write must also be at a natural offset in the file
> wrt the write length. For pwritev2, iovcnt is limited by
> atomic_write_segments_max.
> 
> There has been some discussion on supporting buffered IO and whether the
> API is suitable, like:
> https://lore.kernel.org/linux-nvme/ZeembVG-ygFal6Eb@casper.infradead.org/
> 
> Specifically the concern is that supporting a range of sizes of atomic IO
> in the pagecache is complex to support. For this, my idea is that FSes can
> fix atomic_write_unit_min and atomic_write_unit_max at the same size, the
> extent alignment size, which should be easier to support. We may need to
> implement O_ATOMIC to avoid mixing atomic and non-atomic IOs for this. I
> have no proposed solution for atomic write buffered IO for bdev file
> operations, but I know of no requirement for this.

The thing is that there's no requirement for an interface as complex as
the one you're proposing here.  I've talked to a few database people
and all they want is to increase the untorn write boundary from "one
disc block" to one database block, typically 8kB or 16kB.

So they would be quite happy with a much simpler interface where they
set the inode block size at inode creation time, and then all writes to
that inode were guaranteed to be untorn.  This would also be simpler to
implement for buffered writes.

Who's asking for this more complex interface?

