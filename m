Return-Path: <io-uring+bounces-2244-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03BE590C3F4
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 08:49:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A11B71F21CF9
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 06:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC07F69D3C;
	Tue, 18 Jun 2024 06:49:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7391318645;
	Tue, 18 Jun 2024 06:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718693354; cv=none; b=AfRcfGWTxqWowF6vzUsaVidLkCQyRTPHE2Snemx5h32Wo3cDeP3zkuw3kpuQATpyZFtWcd3UfIM27hfdC4tjh5T7g1ySpxFungRjaMxVhM/WkDmpzxk5oiGN979RYLVDT0DEz756yAtb8LBF8JpRS+970J3V07+gV7RvAdVWAHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718693354; c=relaxed/simple;
	bh=enGGZ0e5oe1iZzypuww1UNqfWKk2mZ5E6jc6utS8WDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nqEa5512vV4SYCw61e5KgUmMfSP6aleIepQXND7P7/coV93tPMZ21nWuaycCIm24rDlHyhRqVxNamB/pR3DjArnZK1YKMRECRBDyqgbkrxxr6OrjSsPMGEkaz8nNZlz+83EYfg0qttJg5AUgqYBO6F+ZSIxnklzBmPwCj59UTEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5871867373; Tue, 18 Jun 2024 08:49:07 +0200 (CEST)
Date: Tue, 18 Jun 2024 08:49:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
	hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
	djwong@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	hare@suse.de, Alan Adamson <alan.adamson@oracle.com>
Subject: Re: [PATCH v8 10/10] nvme: Atomic write support
Message-ID: <20240618064907.GA29009@lst.de>
References: <20240610104329.3555488-1-john.g.garry@oracle.com> <CGME20240610162108epcas5p27ec7c4797da691f5874208bfcfa7c3e3@epcas5p2.samsung.com> <20240610104329.3555488-11-john.g.garry@oracle.com> <faaa5c15-a80d-339a-d9dd-2dd05fb26621@samsung.com> <2ddb92d2-97e8-4eb3-9c76-8c5438bb2a44@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ddb92d2-97e8-4eb3-9c76-8c5438bb2a44@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 17, 2024 at 07:04:23PM +0100, John Garry wrote:
>> Nit: I'd cache blk_rq_bytes(req), since that is repeating and this
>> function is called for each atomic IO.
>
> blk_rq_bytes() is just a wrapper for rq->__data_len. I suppose that we 
> could cache that value to stop re-reading that memory, but I would 
> hope/expect that memory to be in the CPU cache anyway.

Yes, that feels a bit pointless.

> Only NVMe supports an LBA space boundary, so that part is specific to NVMe.
>
> Regardless, the block layer already should ensure that the atomic write 
> length and boundary is respected. nvme_valid_atomic_write() is just an 
> insurance policy against the block layer or some other component not doing 
> its job.
>
> For SCSI, the device would error - for example - if the atomic write length 
> was larger than the device supported. NVMe silently just does not execute 
> the write atomically in that scenario, which we must avoid.

It might be worth to expand the comment to include this information to
help future readers.


