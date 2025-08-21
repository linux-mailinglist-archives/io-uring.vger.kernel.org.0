Return-Path: <io-uring+bounces-9155-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A096B2F2B3
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 10:47:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02C2816B98F
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 08:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C533F2EAB7A;
	Thu, 21 Aug 2025 08:42:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2D62EA73B;
	Thu, 21 Aug 2025 08:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755765738; cv=none; b=ULYuFZvPYHky6vClgwEOLtbBOc3VYfK5cgc07SrtNzJRMVZ7FoNdgJ25KDQx712jnfe3om2dJCnxKP0nwuG8XeCA/JIeJGv7880ui3mVQFRGqvJGhtJFA29S247qG2OuvYONVuLq2PA35PgbaxjPhSUQiJzTmocQnzrPvVfzyBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755765738; c=relaxed/simple;
	bh=DbZjJsYD/eZ++hES+BocHpYYahV+KWymDG6KUyPWuF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vh6YV80093HYTAPvo01XYXbIHtm12P/DQFz6gUofz1gaXrejadi+j1iSSXzrzAbK9dFKCriDcJwQc1bH64+JSpscg2OTjREXi+kfItEq7sXNkj6PlNMDahqNaSN4nDusF9l8hryA6irI6s5OMFzOL4bI/Vhrk0g/uapzZhIkXDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 33D69227A88; Thu, 21 Aug 2025 10:42:13 +0200 (CEST)
Date: Thu, 21 Aug 2025 10:42:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add a FMODE_ flag to indicate
 IOCB_HAS_METADATA availability
Message-ID: <20250821084213.GA29944@lst.de>
References: <20250819082517.2038819-1-hch@lst.de> <20250819082517.2038819-2-hch@lst.de> <20250819-erwirbt-freischaffend-e3d3c1e8967a@brauner> <20250819092219.GA6234@lst.de> <20250819-verrichten-bagger-d139351bb033@brauner> <20250819133447.GA16775@lst.de> <20250820-voruntersuchung-fehlzeiten-4dcf7e45c29f@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820-voruntersuchung-fehlzeiten-4dcf7e45c29f@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 20, 2025 at 11:40:36AM +0200, Christian Brauner wrote:
> I meant something like this which should effectively be the same thing
> just that we move the burden of having to use two bits completely into
> file->f_iocb_flags instead of wasting a file->f_mode bit:

Yeah, that could work.  But I think the double use of f_iocb_flags is
a bit confusing.  Another option at least for this case would be to
have a FOP_ flag, and then check inside the operation if it is supported
for this particular instance.


