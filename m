Return-Path: <io-uring+bounces-4881-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7E4B9D4138
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 18:35:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 943B91F22C4D
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 17:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DAB519F41C;
	Wed, 20 Nov 2024 17:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLUzD5nA"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BE35588F;
	Wed, 20 Nov 2024 17:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732124119; cv=none; b=UM8Tvb4m+MTC6hH3cTgWq7RFY+d9w/BckATGR0pPhmHJwMTWEKmR/YkxIOtuWWYDU64+fwWmxoJ2uyPNA6swrKsDzw3JZ4H5z1vBvCo4riZ/P9vzDPHndBPbm/9D/jp0oVJ1lYGHMraXSzqwP79qW+ZzqFvf5mZEL4Ydgzcsans=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732124119; c=relaxed/simple;
	bh=zhUb1iqG0sWlDdOWsUtyWjkBDoFZXFk2BYB6s8NvcW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Doq+ohvoMauTE1lmgRIdbUQCuKghJdNNzGmNWXFSyBFbb5FqwC4anCSPbweV2FqNGhgF0gyi5L/vRXES4z1qkaFSEg2x3YsxhEGQJ+in9nHdYrCfIebdVconhKLrmE6dRY3ivtih4lDJlYWCM0km42A4pf9JSVR6YHbVDwfB8cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLUzD5nA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9551EC4CECD;
	Wed, 20 Nov 2024 17:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732124118;
	bh=zhUb1iqG0sWlDdOWsUtyWjkBDoFZXFk2BYB6s8NvcW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LLUzD5nAaUwl9vXY+3MQc8Sg4ssq4q4ByVc9JI2Y4n+Yt1kif7fKNsX1iw9qBALKd
	 jrOIX3vDsp2ybevJ8zF9wEi7L09s4rgIFxHzejp/m2+yh18lWnuoB2Svmu6jQL7+t3
	 QaBtG50OgjyjfvpbeVJZEVrcnLl8m7cob922A4sdXGTs0c9gELvbboSE2ZPMBQFesP
	 vOAuV4FlMssmc2SFpWEdfqFsTjNPns8SGxD9Mz+ig/gbJCVrIRii6cssEsFwAuBu8J
	 DKV3AkQ36KcBvFxleA+LPG4qjhOdljCjhPqKIrXpezWXIJDntBVMJMsZ/6yd6cO5t+
	 kb0lafconi9CQ==
Date: Wed, 20 Nov 2024 09:35:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk,
	kbusch@kernel.org, martin.petersen@oracle.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <20241120173517.GQ9425@frogsfrogsfrogs>
References: <20241114104517.51726-1-anuj20.g@samsung.com>
 <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>
 <20241114104517.51726-7-anuj20.g@samsung.com>
 <20241114121632.GA3382@lst.de>
 <3fa101c9-1b38-426d-9d7c-8ed488035d4a@gmail.com>
 <ZzeNEcpSKFemO30g@casper.infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzeNEcpSKFemO30g@casper.infradead.org>

On Fri, Nov 15, 2024 at 06:04:01PM +0000, Matthew Wilcox wrote:
> On Thu, Nov 14, 2024 at 01:09:44PM +0000, Pavel Begunkov wrote:
> > With SQE128 it's also a problem that now all SQEs are 128 bytes regardless
> > of whether a particular request needs it or not, and the user will need
> > to zero them for each request.
> 
> The way we handled this in NVMe was to use a bit in the command that
> was called (iirc) FUSED, which let you use two consecutive entries for
> a single command.
> 
> Some variant on that could surely be used for io_uring.  Perhaps a
> special opcode that says "the real opcode is here, and this is a two-slot
> command".  Processing gets a little spicy when one slot is the last in
> the buffer and the next is the the first in the buffer, but that's a SMOP.

I like willy's suggestion -- what's the difficulty in having a SQE flag
that says "...and keep going into the next SQE"?  I guess that
introduces the problem that you can no longer react to the observation
of 4 new SQEs by creating 4 new contexts to process those SQEs and throw
all 4 of them at background threads, since you don't know how many IOs
are there.

That said, depending on the size of the PI metadata, it might be more
convenient for the app programmer to supply one pointer to a single
array of PI information for the entire IO request, packed in whatever
format the underlying device wants.

Thinking with my xfs(progs) hat on, if we ever wanted to run xfs_buf(fer
cache) IOs through io_uring with PI metadata, we'd probably want a
vectored io submission interface (xfs_buffers can map to discontiguous
LBA ranges on disk), but we'd probably have a single memory object to
hold all the PI information.

But really, AFAICT it's 6 of one or half a dozen of the other, so I
don't care all that much so long as you all pick something and merge it.
:)

--D

