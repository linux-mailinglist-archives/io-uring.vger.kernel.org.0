Return-Path: <io-uring+bounces-2245-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1FCD90C409
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 08:51:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00FA71C23405
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 06:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF2F7345B;
	Tue, 18 Jun 2024 06:51:20 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F066D1BB;
	Tue, 18 Jun 2024 06:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718693480; cv=none; b=Ln6VAWEZCzZfXYKXckMXsV7Lg5Xr4up2fjWaGWlCuIo3kvNNlzCmBM4jfZiQ4NRHWvhXIhKUuvUdV1LDhNLimb2TJpkkNNZcjXuILuWbDndWtxjRWN0FsjzSzbmDupVExWKW+yORfXx2ws6gzIHQCo35e77k1BkbiXStHoKTOaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718693480; c=relaxed/simple;
	bh=6BLzS+xoHDbfqDDfZtzzccJPWKtG+Rip0IyP0GUJYTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kHJSMH56PwkL9/ATuMeoy419BAuo/Wp2nloNVoXnAbqy8udVAIjsmX+3IhsuAyLeHR6lTZfyClZKzK7jQCtIWSWB9/FvSm/oocq/xSfdxCOd5Fytr0cRyVyb0f4bNAzK884pCij7mrhfYp+/Md/CrZvYkJCqtDqtuz+6jVi6Ats=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 70B8D67373; Tue, 18 Jun 2024 08:51:12 +0200 (CEST)
Date: Tue, 18 Jun 2024 08:51:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, djwong@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	hare@suse.de, Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v8 05/10] block: Add core atomic write support
Message-ID: <20240618065112.GB29009@lst.de>
References: <20240610104329.3555488-1-john.g.garry@oracle.com> <20240610104329.3555488-6-john.g.garry@oracle.com> <ZnCGwYomCC9kKIBY@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnCGwYomCC9kKIBY@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 17, 2024 at 12:56:01PM -0600, Keith Busch wrote:
> I'm not sure I follow why these two need to be the same. I can see
> checking for 'chunk_sectors % boundary_sectors_hw == 0', but am I
> missing something else?
> 
> The reason I ask, zone block devices redefine the "chunk_sectors" to
> mean the zone size, and I'm pretty sure the typical zone size is much
> larger than the any common atomic write size.

Yeah.  Then again atomic writes in the traditional sense don't really
make sense for zoned devices anyway as the zoned devices never overwrite
and require all data up to the write pointer to be valid.  In theory
they could be interpreted so that you don't get a partical write failure
if you stick to the atomic write boundaries, but that is mostly
pointless.

