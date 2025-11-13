Return-Path: <io-uring+bounces-10553-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D947C55FA0
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 07:51:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 08B653492B6
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 06:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4762B30102A;
	Thu, 13 Nov 2025 06:51:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF0C289811;
	Thu, 13 Nov 2025 06:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763016663; cv=none; b=ZqP97qxt4gYoP2Zt6V1dkJxSwcM7GA0qNj0UlysDkeSvWu2FHBmEtishcHcqr9fjo8XE2EtLeIU/XiHT6huPEA4wTGrF+dWLyRhpg2O5lLix2AFqn6yv5+bD7Xo6CN0ViFGPcfgZ8gkRUztHHDgt/4o1mCfc+XD7Jb6wx2juUjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763016663; c=relaxed/simple;
	bh=+WKoqGO2f9tpwqkvL4EZEY7g5ZBBuAqMDoq+Jh0H5oI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sRfiElycLPZdcKReNrO3Of0NgYZg9uYe/CNA1XnHULcKg+ZE01GXDSf8Ri/rXis8Zt4l2qoxePVRvExbgKyuePxZVW/wGUtP2VLrbQB/maVat9/vHQf11UjEP/LjMN6lgHXxMrg/Kja08VrEIgOY51U27hVrSVvBe3vY73r8bqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3BF816732A; Thu, 13 Nov 2025 07:50:56 +0100 (CET)
Date: Thu, 13 Nov 2025 07:50:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Darrick J. Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Avi Kivity <avi@scylladb.com>, Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 4/5] iomap: support write completions from interrupt
 context
Message-ID: <20251113065055.GA29641@lst.de>
References: <20251112072214.844816-1-hch@lst.de> <20251112072214.844816-5-hch@lst.de> <nujtqnweb7jfbyk4ov3a7z5tdtl24xljntzbpecgv6l7aoeytd@nkxsilt6w7d3>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nujtqnweb7jfbyk4ov3a7z5tdtl24xljntzbpecgv6l7aoeytd@nkxsilt6w7d3>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 12, 2025 at 09:25:58PM +0100, Jan Kara wrote:
> > +
> > +		/*
> > +		 * We can only do inline completion for pure overwrites that
> > +		 * don't require additional I/O at completion time.
> > +		 *
> > +		 * This rules out writes that need zeroing or extent conversion,
> > +		 * or extend the file size.
> > +		 */
> > +		if (!iomap_dio_is_overwrite(iomap))
> > +			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> >  	} else {
> >  		bio_opf |= REQ_OP_READ;
> >  	}
> 
> OK, now I see why you wrote iomap_dio_is_overwrite() the way you did. You
> still want to keep completions inline for overwrites of possibly
> uncommitted extents.

Yes.

> But I have to admit it all seems somewhat fragile and
> difficult to follow. Can't we just check for IOMAP_DIO_UNWRITTEN |
> IOMAP_DIO_COW | IOMAP_DIO_NEED_SYNC in flags (plus the i_size check) and be
> done with it?

You mean drop the common helper?  How would that be better and less
fragile?   Note that I care strongly, but I don't really see the point.

