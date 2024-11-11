Return-Path: <io-uring+bounces-4603-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ED3D9C3BF2
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 11:30:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 691201C21BEF
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 10:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A76117C9BB;
	Mon, 11 Nov 2024 10:29:22 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CB01850AF;
	Mon, 11 Nov 2024 10:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731320962; cv=none; b=EY8hoco10BKQrTEDBrz17eUI6jhdBsgb2MXERNL7caIdv0UBpPxxJvdRlznuOCH087/Sa9wY/pg5Q2ykS3J7mfHUS06n/AeOytZJFjlj2463ULDt9IST3wMxHM5oPkz6yY6bZfwfN5eyauk0IvpcE6rHwr1dLwcCV9mx7ZwLePQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731320962; c=relaxed/simple;
	bh=H8688IHkrAhzY0lMUPLf6jI8Dg7DkVuXAc0C7/5+aus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GBzSdKpRxaWIEARV5sxJFtLDX9XYfHwPS2E6/5oe0XfxDU0w4lEj033LgD8LjudW4xvPET6TOb23mBfbjO3IYqLozRJjfZp798UaTUyVRsIy+1Qoi1MVCAJo47eXI6y43x/sCBWCGKg4lfHZBNyQVjmdIUyVRhXLnXV0smkQR4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3C96168D09; Mon, 11 Nov 2024 11:29:15 +0100 (CET)
Date: Mon, 11 Nov 2024 11:29:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	javier.gonz@samsung.com, joshi.k@samsung.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv11 0/9] write hints with nvme fdp and scsi streams
Message-ID: <20241111102914.GA27870@lst.de>
References: <20241108193629.3817619-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108193629.3817619-1-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 08, 2024 at 11:36:20AM -0800, Keith Busch wrote:
>   Default partition split so partition one gets all the write hints
>   exclusively

I still don't think this actually works as expected, as the user
interface says the write streams are contigous, and with the bitmap
they aren't.

As I seem to have a really hard time to get my point across, I instead
spent this morning doing a POC of what I mean, and pushed it here:

http://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/block-write-streams

The big differences are:

 - there is a separate write_stream value now instead of overloading
   the write hint.  For now it is an 8-bit field for the internal
   data structures so that we don't have to grow the bio, but all the
   user interfaces are kept at 16 bits (or in case of statx reduced to
   it).  If this becomes now enough because we need to support devices
   with multiple reclaim groups we'll have to find some space by using
   unions or growing structures
 - block/fops.c is the place to map the existing write hints into
   the write streams instead of the driver
 - the stream granularity is added, because adding it to statx at a
   later time would be nasty.  Getting it in nvme is actually amazingly
   cumbersome so I gave up on that and just fed a dummy value for
   testing, though
 - the partitions remapping is now done using an offset into the global
   write stream space so that the there is a contiguous number space.
   The interface for this is rather hacky, so only treat it as a start
   for interface and use case discussions.
 - the generic stack limits code stopped stacking the max write
   streams.  While it does the right thing for simple things like
   multipath and mirroring/striping is is wrong for anything non-trivial
   like parity raid.  I've left this as a separate fold patch for the
   discussion.

