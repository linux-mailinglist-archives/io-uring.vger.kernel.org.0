Return-Path: <io-uring+bounces-7140-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2CC9A6A020
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 08:08:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4007D170F9F
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 07:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 918931E32C6;
	Thu, 20 Mar 2025 07:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lfi9GVUP"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78791C3F02;
	Thu, 20 Mar 2025 07:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742454503; cv=none; b=V5vaRprPvfgjEg/nT2NWuE/3PMffkrJFkb+FV6pB8dqb8oZL7bzu9sWTNduewGjgXBTgOfjYj/1ZPOxiabFi8xXXYEDFeLgwvBSK62m0XJc0QPk/Mf+SymoXxV7FFBPCSLrj7h4fErJTTnYbN5QdmQZMTTjKj6Ruojn2aqfjSuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742454503; c=relaxed/simple;
	bh=W+9m4XEehGdKldYYVEGbIC6F/LyBFoLsNvRrssBfmkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aAl3SRwwIrl8482+lWRO6dDny8Ma+tsQhmCPn5TXn2q8cvqpqLWoURY7/7aKY6CMV9rmYkGCvbTwQwX7xK7xW54NORC32FEqdp/FHYQwMGZ1iAx+uqi7FwOM+9v77Uss1e3bsVGBFWjWcBR0ShYK61nNVmXvLFHx50ffc/1dieY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Lfi9GVUP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Z1vSfJUNPkSiRaWMFL7kD4jilYBU0XwUxXLmUH1EUDc=; b=Lfi9GVUP7J0+CSIvCCEI9YBvDt
	NG6+M1wHsK5fW6nYH7D2gxkPlwi047ytsQs+KDdovgDNmsr2Flg5NrwjefXdwJbX6OaELW7/Hidyi
	MMbR2kuyVXC+jSPCKCTb/cCP6Ur/fXK/rcD7eb5CIe7EfTWum142o0rFFw1n4t+ZTT3g0jSQ7r6tw
	QNNAmQQfubgOKceoh+S9i/9OvaTREuTx6yvgxJMbmjqSQE/zWR+CgbpB85vF31YwbnRdlcogymNc+
	HRLXr9FWGHDaOzs0wVso0L4veyVaP/pBK8yQxTXWpF5jUQp52yVY/VNsxDAj+yqrTHvNNWT+k3AMD
	hZoEy8MQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tvA0q-0000000BMyY-05jV;
	Thu, 20 Mar 2025 07:08:20 +0000
Date: Thu, 20 Mar 2025 00:08:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z9u-489C_PVu8Se1@infradead.org>
References: <Z8zbYOkwSaOJKD1z@fedora>
 <a8e5c76a-231f-07d1-a394-847de930f638@redhat.com>
 <Z8-ReyFRoTN4G7UU@dread.disaster.area>
 <Z9ATyhq6PzOh7onx@fedora>
 <Z9DymjGRW3mTPJTt@dread.disaster.area>
 <Z9FFTiuMC8WD6qMH@fedora>
 <7b8b8a24-f36b-d213-cca1-d8857b6aca02@redhat.com>
 <Z9j2RJBark15LQQ1@dread.disaster.area>
 <Z9knXQixQhs90j5F@infradead.org>
 <Z9k-JE8FmWKe0fm0@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9k-JE8FmWKe0fm0@fedora>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 18, 2025 at 05:34:28PM +0800, Ming Lei wrote:
> On Tue, Mar 18, 2025 at 12:57:17AM -0700, Christoph Hellwig wrote:
> > On Tue, Mar 18, 2025 at 03:27:48PM +1100, Dave Chinner wrote:
> > > Yes, NOWAIT may then add an incremental performance improvement on
> > > top for optimal layout cases, but I'm still not yet convinced that
> > > it is a generally applicable loop device optimisation that everyone
> > > wants to always enable due to the potential for 100% NOWAIT
> > > submission failure on any given loop device.....
> 
> NOWAIT failure can be avoided actually:
> 
> https://lore.kernel.org/linux-block/20250314021148.3081954-6-ming.lei@redhat.com/

That's a very complex set of heuristics which doesn't match up
with other uses of it.

> 
> > 
> > Yes, I think this is a really good first step:
> > 
> > 1) switch loop to use a per-command work_item unconditionally, which also
> >    has the nice effect that it cleans up the horrible mess of the
> >    per-blkcg workers.  (note that this is what the nvmet file backend has
> 
> It could be worse to take per-command work, because IO handling crosses
> all system wq worker contexts.

So do other workloads with pretty good success.

> 
> >    always done with good result)
> 
> per-command work does burn lots of CPU unnecessarily, it isn't good for
> use case of container

That does not match my observations in say nvmet.  But if you have
numbers please share them.


