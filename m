Return-Path: <io-uring+bounces-3797-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D65E19A2881
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 18:24:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C3CF284F10
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 16:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82AE41DEFF6;
	Thu, 17 Oct 2024 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ftAo7CuQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543E31C1AA5;
	Thu, 17 Oct 2024 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729182241; cv=none; b=OE3Ss8euLK0BfbAkzsmHr33Wsp8Lnw1/QbbtPBB/6XjCMAXCD67inskqhAm0YwLGt9KFKe9ycNNWOR+quMl76LCE97VR3+mA/snna9WLNnNeEZTlGasyrbLSdxHoqsiE+vhW8CrRk1yafVpbdD8cGW7RdtpfYaK7lCvSBztPOZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729182241; c=relaxed/simple;
	bh=RjDlQZTkGZvAnkqNZFuzz/RFQ82YGlXnuCXfg/gs4cE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nvIh9elCGd/CuBhi9ngm+Ubnv/ADyEvjmQ9ZP2WSFSwPJSog661AAeQ6TCjQSKBLV/qC7G+DInXtZaOYFfg3gZSMDs706nh3H6B0ht4vOyr1+04zcHqNS4M69tnCnORL6gu7Mo5HFDzmlqsIWA+X6yoP8HB5c9HVQdfdNiYEcPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ftAo7CuQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FFDC4CEC3;
	Thu, 17 Oct 2024 16:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729182240;
	bh=RjDlQZTkGZvAnkqNZFuzz/RFQ82YGlXnuCXfg/gs4cE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ftAo7CuQ4OQIWh1hU+NgHZhkzh+0FAswQMwWcVSNJE5zXBFdNGB/VIxsIA5pKB6AN
	 3Lr5M3uyOFeSB94cgkq6M9LT1C5UHhWW6q9Ql2JFCTzbFh10bxOZ4QLOH+ksP8X+sP
	 IIACWncBrUJWvzd441ZuKK5p1lQnopNeOSQJY8qIi6fx93iX5krdO4l8zFlkCZtnyW
	 0caoodB3qWS8twWihXtERAgMcc7lf1RLnQiojXa/hTdItF+nl4bueHKCZNbToGO21w
	 KX/BZYgnQKi/ZZOsCab8EBgQvs9sY2UrJLdRweybpbeYff/5bCLRzyx2w0fN48nvQk
	 eX+gqJQfy14zA==
Date: Thu, 17 Oct 2024 10:23:57 -0600
From: Keith Busch <kbusch@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	axboe@kernel.dk, hare@suse.de, sagi@grimberg.me,
	martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, asml.silence@gmail.com,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-aio@kvack.org, gost.dev@samsung.com, vishak.g@samsung.com,
	javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <ZxE6HWwKPXJPtShT@kbusch-mbp.dhcp.thefacebook.com>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>
 <20240930181305.17286-1-joshi.k@samsung.com>
 <20241015055006.GA18759@lst.de>
 <8be869a7-c858-459a-a34b-063bc81ce358@samsung.com>
 <20241017152336.GA25327@lst.de>
 <ZxEw5-l6DtlXCQRO@kbusch-mbp.dhcp.thefacebook.com>
 <37af5088-6f09-4e75-b5d0-559e92d625bb@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37af5088-6f09-4e75-b5d0-559e92d625bb@acm.org>

On Thu, Oct 17, 2024 at 09:15:21AM -0700, Bart Van Assche wrote:
> On 10/17/24 8:44 AM, Keith Busch wrote:
> > On Thu, Oct 17, 2024 at 05:23:37PM +0200, Christoph Hellwig wrote:
> > > If you want to do useful stream separation you need to write data
> > > sequentially into the stream.  Now with streams or FDP that does not
> > > actually imply sequentially in LBA space, but if you want the file
> > > system to not actually deal with fragmentation from hell, and be
> > > easily track what is grouped together you really want it sequentially
> > > in the LBA space as well.  In other words, any kind of write placement
> > > needs to be intimately tied to the file system block allocator.
> > 
> > I'm replying just to make sure I understand what you're saying:
> > 
> > If we send per IO hints on a file, we could have interleaved hot and
> > cold pages at various offsets of that file, so the filesystem needs an
> > efficient way to allocate extents and track these so that it doesn't
> > interleave these in LBA space. I think that makes sense.
> > 
> > We can add a fop_flags and block/fops.c can be the first one to turn it
> > on since that LBA access is entirely user driven.
> 
> Does anyone care about buffered I/O to block devices? When using
> buffered I/O, the write_hint information from the inode is used and the per
> I/O write_hint information is ignored.

I'm pretty sure there are applications that use buffered IO on raw block
(ex: postgresql), but it's a moot point: the block file_operations that
provide the fops_flags also provide the callbacks for O_DIRECT, which is
where this matters.

We can't really use per-io write_hints on buffered-io. At least not yet,
and maybe never. I'm not sure if it makes sense for raw block because
the page writes won't necessarily match writes to storage.

