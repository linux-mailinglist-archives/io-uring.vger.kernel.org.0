Return-Path: <io-uring+bounces-4912-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50A8B9D47FA
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 07:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5C89282AE8
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 06:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7AB54207A;
	Thu, 21 Nov 2024 06:54:20 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4255817BD3;
	Thu, 21 Nov 2024 06:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732172060; cv=none; b=ZrFINGgT125Aa7pvZ/eJHBgP7nBXf24UVoDtn4ogvkdNc2cwV2y7imUCgeh9Dnt7W72PgMKBVSlrGCSJdwO83uxpBszfne3gJS+058VGkDQ95nHExO4vflsG618dOt5zIVbcECNyUpDLmOsnvPgyMAdRm4mbbLhpfGC5UonqBlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732172060; c=relaxed/simple;
	bh=kny5aq3Sf0mGB8wddIubpsuJjSYKI1g1UlvMUtCv9N8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TgRw2Lnk6x6SJTvIHC2Ci2bx6ir4fl7VWpRFUgpdj8vN4SprjiY6N5uqG1oq+fMTlOoYBbI4CCxaHkmrFec1DsxYlm1H9mgSyYB8wbDft97WHn0586KFZ4bykVG9zjVl2n4Me4Piw5DMHOpW3Sp8EMtjAp5ud0DzyYOjf6iYKWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D51AB68AFE; Thu, 21 Nov 2024 07:54:13 +0100 (CET)
Date: Thu, 21 Nov 2024 07:54:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>,
	axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <20241121065413.GA22464@lst.de>
References: <20241114104517.51726-1-anuj20.g@samsung.com> <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com> <20241114104517.51726-7-anuj20.g@samsung.com> <20241114121632.GA3382@lst.de> <3fa101c9-1b38-426d-9d7c-8ed488035d4a@gmail.com> <ZzeNEcpSKFemO30g@casper.infradead.org> <20241120173517.GQ9425@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241120173517.GQ9425@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 20, 2024 at 09:35:17AM -0800, Darrick J. Wong wrote:
> I like willy's suggestion -- what's the difficulty in having a SQE flag
> that says "...and keep going into the next SQE"?  I guess that
> introduces the problem that you can no longer react to the observation
> of 4 new SQEs by creating 4 new contexts to process those SQEs and throw
> all 4 of them at background threads, since you don't know how many IOs
> are there.

Which is why everyone hates the nvme fused commands with passion, and no
one but vmware actually uses them, and no other fused command pair
except for compare and write ever materialized.

> That said, depending on the size of the PI metadata, it might be more
> convenient for the app programmer to supply one pointer to a single
> array of PI information for the entire IO request, packed in whatever
> format the underlying device wants.
> 
> Thinking with my xfs(progs) hat on, if we ever wanted to run xfs_buf(fer
> cache) IOs through io_uring with PI metadata, we'd probably want a
> vectored io submission interface (xfs_buffers can map to discontiguous
> LBA ranges on disk), but we'd probably have a single memory object to
> hold all the PI information.

Agreed.  And unless I'm misremembering something, all proposals so far
had a single PI buffer for vectored read/writes.


