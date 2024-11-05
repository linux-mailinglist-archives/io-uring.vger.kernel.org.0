Return-Path: <io-uring+bounces-4453-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3657D9BC9DD
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 11:03:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6699A1C22556
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 10:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 022C81CDA3B;
	Tue,  5 Nov 2024 10:03:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573D318F2F7;
	Tue,  5 Nov 2024 10:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730800993; cv=none; b=pXjsQo441PMKiRcWxAADcP0llMykyNki2fdbpTQEBMnq4WIpsu2UjHJVzlUAcQHE+gOeAPEY+vGdqb/DxuT4wGTt1fMDyU2C0IZUBWDSFoW0y6zlxFL1EVwnTqmHzqWmJT/OLMV4tKCWWIfgNwTkh39No8hu+fVlQm9d+Cju9fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730800993; c=relaxed/simple;
	bh=oi+hODaubSqjykR3ygGmsP6g2tHPT7jHikSbj4esYwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gAvoXeS58imHmxp/exi85OrERUOp5xow2luSbDMuaCXv7ZYUlF0fDSx4BIptb4az1DoMQuvg6E+AUCNTrQ63XNu3PjjZfoYYFPVjLQ8WNKlCbIZWn2um/JqIvmSDgrFt0vpCiR1DhthAUxS1XsaUwivxP1goZ2Ekog4QlKlBk+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 13978227AA8; Tue,  5 Nov 2024 11:03:08 +0100 (CET)
Date: Tue, 5 Nov 2024 11:03:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 02/10] block: copy back bounce buffer to user-space
 correctly in case of split
Message-ID: <20241105100307.GA650@lst.de>
References: <20241104140601.12239-1-anuj20.g@samsung.com> <CGME20241104141448epcas5p4179505e12f9cf45fd792dc6da6afce8e@epcas5p4.samsung.com> <20241104140601.12239-3-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104140601.12239-3-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 04, 2024 at 07:35:53PM +0530, Anuj Gupta wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Copy back the bounce buffer to user-space in entirety when the parent
> bio completes. The existing code uses bip_iter.bi_size for sizing the
> copy, which can be modified. So move away from that and fetch it from
> the vector passed to the block layer. While at it, switch to using
> better variable names.
> 
> Fixes: 492c5d455969f ("block: bio-integrity: directly map user buffers")
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> [hch: better names for variables]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This shouldn't really have a from for me as it wasn't my patch
originally.  But if you insist to re-attribute it, my signoff should
be the first as signoffs are supposed to be a chain starting from
the original author to the submitter.


