Return-Path: <io-uring+bounces-3396-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B23198EFBB
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 14:54:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B345C1F21043
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 12:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3845B15539D;
	Thu,  3 Oct 2024 12:54:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84664155314;
	Thu,  3 Oct 2024 12:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727960048; cv=none; b=gZIeNZ57/1rdt/SCzDfVSy7rWQze22nzlGYEjiLggBkxsVIZpRzlF3DiOIKqMX0i7w9IsYvyfj4kbcHmQckhHcYUaeOqP1n1bM11mzg45NDIsFpDksyI2wgpRIB6kzVKF6+eQts8paQdAkW8qm6sxH3fRyVh+00Z97UrxTqUx1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727960048; c=relaxed/simple;
	bh=dGNbAALEf+un52yguhYbJzQbjOA+mwWEp+lyL3RbhNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RW9f5cxeL7Lfo4EcAvnE5nGDTAGCOjm4P+zcpPg4XVHytoPedPLR0R9di4HTEGTWIoYOK+W2a7V/dMrqMCirHLaIIYRo/EEox1df0muTVhNNel2XrHZMPuMszP3BhJ2vmPSVhsqvqKs4uegdB9imGnUXkEKo24ljdmHMqwqCwSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2BB8A227A88; Thu,  3 Oct 2024 14:54:01 +0200 (CEST)
Date: Thu, 3 Oct 2024 14:54:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
	hare@suse.de, sagi@grimberg.me, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241003125400.GB17031@lst.de>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com> <20240930181305.17286-1-joshi.k@samsung.com> <20241001092047.GA23730@lst.de> <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk> <20241002075140.GB20819@lst.de> <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk> <20241002151344.GA20364@lst.de> <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com> <20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 02, 2024 at 11:47:32AM -0400, Martin K. Petersen wrote:
> It is the kernel's job to manage the system's hardware resources and
> arbitrate and share these resources optimally and fairly between all
> running applications.

Exactly.

> What irks me is defining application interfaces which fundamentally tell
> the kernel that "these blocks are part of the same file".
> 
> The kernel already knows this. It is the very entity which provides that
> abstraction. Why do we need an explicit interface to inform the kernel
> that concurrent writes to the same file should have the same
> "temperature" or need to go to the same "bin" on the storage device?
> Shouldn't that just happen automatically?

For file: yes.  The problem is when you have more files than buckets on
the device or file systems.  Typical enterprise SSDs support somewhere
between 8 and 16 write streams, and there typically is more data than
that.  So trying to group it somehow is good idea as not all files can
have their own bucket.

Allowing this inside a file like done in this patch set on the other
hand is pretty crazy.

> Whether it's SCSI groups, streams, UFS hints, or NVMe FDP, it seems like
> we are consistently failing to deliver something that actually works for
> anything but a few specialized corner cases. I think that is a shame.

Yes, it is.  And as someone who has been sitting in this group that is
because it's always someone in a place of power forcing down their version
because they got a promotіon, best of show award or whatever.


