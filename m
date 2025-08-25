Return-Path: <io-uring+bounces-9281-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7112CB340D7
	for <lists+io-uring@lfdr.de>; Mon, 25 Aug 2025 15:35:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35BAF17C165
	for <lists+io-uring@lfdr.de>; Mon, 25 Aug 2025 13:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 934D026F46E;
	Mon, 25 Aug 2025 13:35:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D85E203710;
	Mon, 25 Aug 2025 13:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756128925; cv=none; b=a8X6Qzr1GL/gDc6l5BInLuJvwCO+RBVr19DOVHyn8eQkHpG/P/9v/hVfSbTybOGT9sEv6zYupPR8irZa7Dq48sQXe8aWoB2bzr6FDnhC75bryjDrFxF+KI7DJlc1TKS3UJq8E33Z5k8zCEdOQB3RIkB/Cj7HLPdpo3OO0tUeU0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756128925; c=relaxed/simple;
	bh=PafOStk5pWlzxjq3x9uYJdtDYco4pBPROdxx/w9ALC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=leHoay03i2lHSBNTWcgVbAck4Sw8lF+jv+qiYrJ20Zn/4KvoedRqbtI4x8q2+fGErYFEGPzw4O6Gbm0LhxU/RCqMkJ3b5tQty3Z2wILguy9CTfRsPMpSnyKpQHMKh2EYEEvrJHC1DVocJMf72A0sOX5QxQCLy1PkMphP17Kojh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5E83068B05; Mon, 25 Aug 2025 15:35:17 +0200 (CEST)
Date: Mon, 25 Aug 2025 15:35:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add a FMODE_ flag to indicate
 IOCB_HAS_METADATA availability
Message-ID: <20250825133516.GA14412@lst.de>
References: <20250819082517.2038819-1-hch@lst.de> <20250819082517.2038819-2-hch@lst.de> <20250819-erwirbt-freischaffend-e3d3c1e8967a@brauner> <20250819092219.GA6234@lst.de> <20250819-verrichten-bagger-d139351bb033@brauner> <20250819133447.GA16775@lst.de> <20250820-voruntersuchung-fehlzeiten-4dcf7e45c29f@brauner> <20250821084213.GA29944@lst.de> <20250825-randbemerkung-machbar-ae3dde406069@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825-randbemerkung-machbar-ae3dde406069@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 25, 2025 at 02:01:07PM +0200, Christian Brauner wrote:
> On Thu, Aug 21, 2025 at 10:42:13AM +0200, Christoph Hellwig wrote:
> > On Wed, Aug 20, 2025 at 11:40:36AM +0200, Christian Brauner wrote:
> > > I meant something like this which should effectively be the same thing
> > > just that we move the burden of having to use two bits completely into
> > > file->f_iocb_flags instead of wasting a file->f_mode bit:
> > 
> > Yeah, that could work.  But I think the double use of f_iocb_flags is
> > a bit confusing.  Another option at least for this case would be to
> > have a FOP_ flag, and then check inside the operation if it is supported
> > for this particular instance.
> 
> Do you want to try something like that? Maybe we can do this for other
> FMODE_*-based IOCB_* opt{in,outs}?

Yes, I also need to move on of the FOP_ flags to a scheme like that.
However I'm pretty busy at the momen, so I'm unlikely to get to it
before mid-September.

