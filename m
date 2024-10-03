Return-Path: <io-uring+bounces-3395-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BCD998EFB0
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 14:51:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3AA61F21043
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 12:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F07B015887C;
	Thu,  3 Oct 2024 12:51:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30E9189B8F;
	Thu,  3 Oct 2024 12:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727959878; cv=none; b=gKzik29sd1God4XTJshoNTzcSH0wfTcMHBXfTxI6sn0NzIJ6IhhZKdP1sx+3BDCxFImVxByjPL5ZnhqgwDeiwrKiJ7XyMumEPPdPeIhBpP+glKYp9CThoumwJ315mcSQ9jgN6PF05Fqn35bCYBQXE3Vot5w1OYyiNYI2YBJWZgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727959878; c=relaxed/simple;
	bh=heWLThp1SIOOMZuyRB4fwRQe+xfjAg3wDPh+zMqxVO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nelfNF2G2ouWe5OO0Mjfe67LCeiqOWo7SEpig9bQaFu9jXnH/y8jHfUTWcVSD2wsH8Jt+aHd1/vfeprK3GDMGxCfywKSKUhGZ0+2mZLl2ksI6QqZO8uvj9qu55vF/G3mBnQhtyqBppKQqXZeSGs3OLSiF6uSt+Xju70KM+HFAoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C6AE6227A88; Thu,  3 Oct 2024 14:51:10 +0200 (CEST)
Date: Thu, 3 Oct 2024 14:51:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Kanchan Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
	martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241003125110.GA17031@lst.de>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com> <20240930181305.17286-1-joshi.k@samsung.com> <20241001092047.GA23730@lst.de> <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk> <20241002075140.GB20819@lst.de> <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk> <20241002151344.GA20364@lst.de> <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com> <20241002151949.GA20877@lst.de> <Zv1nvIcENHnBcd2G@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv1nvIcENHnBcd2G@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 02, 2024 at 09:33:16AM -0600, Keith Busch wrote:
> You remember right. I also explained the use cases for per-io hints are
> to replace current passthrough users with generic read/write paths that
> have all the memory guard rails, read/write stats, and other features
> that you don't get with passthrough. This just lets you accomplish the
> same placement hints with the nvme raw block device that you get with
> the nvme char device.

Yes, and as I said before we need an opt-in from the file_ops, because
file systems can't support this.  And I'm speaking that from a position
of working on a file system that made the existing non-idea hints
work (to all fairness Hans did the hard work, but I was part of it).

