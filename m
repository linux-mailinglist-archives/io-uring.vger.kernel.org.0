Return-Path: <io-uring+bounces-3787-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C3D99A2745
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 17:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51F54283968
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 15:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5531DED7B;
	Thu, 17 Oct 2024 15:46:56 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464191DF24D;
	Thu, 17 Oct 2024 15:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729180016; cv=none; b=rp0e4UFgJc078oJxN1dYjhAJNMlgrt7HgIZ1Tsc3YQvPU0ia7QcN7N5Bz8DxyjXkfw0QOeR9Dist97ojhgvjrTbRVnL68ktIYPP+KRbaZ/UI9soscglZT3UNorpV5obJ4ppSpY4osqSWsuS9unFKI4U843xcXMyOJzUIbVSZeZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729180016; c=relaxed/simple;
	bh=LJ9ADl/GZSqKR8fNykBSMVYl2SSHt5Snbnb2ygYLwXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UcnkXuUs5L+jPx2U2vfY7nmlFvsVzgTWssv2uOYnrCmySTl5dObNPyDEYsEx6oae/+q258zgL/+6tBnd2FEkOz9RkF5qZS6F8SAPjuo9/mqSj3kX7YC5c4yMbm2zRV8Spv3FqvCDGIhFqQjXlzevKs9YO+CdML69th08DlRd8qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E6EEF227A8E; Thu, 17 Oct 2024 17:46:49 +0200 (CEST)
Date: Thu, 17 Oct 2024 17:46:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	axboe@kernel.dk, hare@suse.de, sagi@grimberg.me,
	martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241017154649.GA27203@lst.de>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com> <20240930181305.17286-1-joshi.k@samsung.com> <20241015055006.GA18759@lst.de> <8be869a7-c858-459a-a34b-063bc81ce358@samsung.com> <20241017152336.GA25327@lst.de> <ZxEw5-l6DtlXCQRO@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxEw5-l6DtlXCQRO@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 17, 2024 at 09:44:39AM -0600, Keith Busch wrote:
> I'm replying just to make sure I understand what you're saying:
> 
> If we send per IO hints on a file, we could have interleaved hot and
> cold pages at various offsets of that file, so the filesystem needs an
> efficient way to allocate extents and track these so that it doesn't
> interleave these in LBA space. I think that makes sense.

That's a little simplified, but yes.

> We can add a fop_flags and block/fops.c can be the first one to turn it
> on since that LBA access is entirely user driven.

Yes, that's my main request on the per-I/O hint interface.

Now we just need to not dumb down the bio level interface to five
temeperature level and just expose the different write streams and we
can all have a happy Kumbaya.

