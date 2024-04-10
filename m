Return-Path: <io-uring+bounces-1497-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88CE38A0410
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 01:34:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 440D6283BE6
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 23:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE18F3D970;
	Wed, 10 Apr 2024 23:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JE2fo2vX"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CAF3BB43;
	Wed, 10 Apr 2024 23:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712792069; cv=none; b=IO6YmtdnzC0O1EEdaWy5VZp7427gTTOSu+wo+4HuZ2iWmVdJxZRAWRgdFBNGdttieJNJvDddOyLowKhqIr/GXTAdTu3TMjXQhELC4ziuwGnT+YvJv4Br1NccbN4hiUki+k2Wy1K4+6GC3E7dpr1hCgDSbdnMkFoagyfx76nqrbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712792069; c=relaxed/simple;
	bh=uqzNxqrBph2PlRsjh6hC900ySu85OHtjJiS7mW6FX+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljUZ65MQLt0UejX/zHvA6Dr0tpSyhPPYF3sKHOtHrLtc8rpFxwb40MJ3f2qJbRBiz8jMy4BYOdOh6wKb+Ecs4SNoLiUhuKORQRuYeVUHKTrXacqBNCDTuGd98hXXR8VA3ZAIvgpgebdLz2ubF+u0+37Z9o6ghBcIFeqmHX8+PVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JE2fo2vX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FXmAKscTbgNJ1p29Two6+cxbrIyx3G8HLoeSBvRIChc=; b=JE2fo2vXsHYBjNsZu7z66/oeOy
	TmDFDhmMWI9DAzYzarLq47L936opk3bRPR+HQRcRAPsrypIYPj5IBH+1d79t1LK+AnBA+5NqwzAXv
	TNWkEFAYnKtYuy0h5tNyXJoPw6mPA/ZLGwkw/Vn/jRQml7vmt1L232DP97jJ5uLt2PaI8tFK42Rre
	a1JqxOrlDlkYEwwZOATQlvCzzPoVitwEw5sALBZYIINr8eL0SYCToM8rS1J4KPxntH2tebwotXZtC
	7VN7jbR6LjOg1f1PqKaNoltS7oh8wdYpnuu9FXnUjmMvryJcahiQgKb2l/KRMQpv94xvskr6zJLmZ
	jPffkkNw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruhSN-00000009Tii-29zF;
	Wed, 10 Apr 2024 23:34:19 +0000
Date: Wed, 10 Apr 2024 16:34:19 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk,
	kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org,
	Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v6 05/10] block: Add core atomic write support
Message-ID: <Zhch-6XSPYxM4ku3@bombadil.infradead.org>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <20240326133813.3224593-6-john.g.garry@oracle.com>
 <0a9fb564-7129-4153-97d6-76e9b3a1b6c1@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a9fb564-7129-4153-97d6-76e9b3a1b6c1@infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Tue, Mar 26, 2024 at 10:11:50AM -0700, Randy Dunlap wrote:
> Hi,
> 
> On 3/26/24 06:38, John Garry wrote:
> > diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
> > index 1fe9a553c37b..4c775f4bdefe 100644
> > --- a/Documentation/ABI/stable/sysfs-block
> > +++ b/Documentation/ABI/stable/sysfs-block
> > +What:		/sys/block/<disk>/atomic_write_boundary_bytes
> > +Date:		February 2024
> > +Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
> > +Description:
> > +		[RO] A device may need to internally split I/Os which
> > +		straddle a given logical block address boundary. In that
> > +		case a single atomic write operation will be processed as
> > +		one of more sub-operations which each complete atomically.
> 
> 		    or

If *or* was meant, wouldn't it be better just to say one or more
operations may be processed as one atomically in this situation?

  Luis

