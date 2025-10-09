Return-Path: <io-uring+bounces-9934-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AB97BC71A4
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 03:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B863D3C532D
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 01:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D2778F39;
	Thu,  9 Oct 2025 01:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cm415Qm7"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBDB42AA6
	for <io-uring@vger.kernel.org>; Thu,  9 Oct 2025 01:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759973167; cv=none; b=Q3lE0VPwgtr9Y9D818AyN1nomYLblmrLb+FuO3xQPumYKEsO/ByQ/gy1umf+5yEUHJDuBT17MChSvl5my3Vd/1LNnW8zN6hxB7d4tIV6mzC7wvuomoQg6E+bqEEa/Bs6CXzrdrvoCYUzhWpfd7K4aUKRbV8lSi/XbpNI4ADlPmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759973167; c=relaxed/simple;
	bh=04pKXYUEW22wmnqOJaOUGxvcsNNdckjnNeS+V/RVb1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LYf9GVS0UelngOc83jj0eMoLRZUMS4W2QlspM7nFRops61Zk/3J+WXNA8tKtTVyLT9hPUopFGIw3XCLHaH6jruoCTSSiN1lLK6ue0NT3FxTL8K5CxarkGSI2J/Oz/M5CGBL1SpFI6rfjfxBnGhE015C8vWXchPoORmMCS8Rm3D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cm415Qm7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759973164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EvWzY/E22zcDn5kzwElN2TmHttFiMXzo5vH5EqPpajs=;
	b=cm415Qm74T85QizhfkOSH8mi0/+GrF7jHkK0O5sPrWDnphM1iW/LyZDh/m44deIVJgmxQf
	sAxQ1Ub8AqVwEvVBW2lsaeUornbA+AK38eIaXOIwbvLsXsqWMTgSvlgzKR2RkJul2tEmab
	s5iUMx5P3iP/uKsDfYkRDCYtvjl6xOU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-RRMylnauMzSjSA39-fgRKQ-1; Wed,
 08 Oct 2025 21:26:00 -0400
X-MC-Unique: RRMylnauMzSjSA39-fgRKQ-1
X-Mimecast-MFC-AGG-ID: RRMylnauMzSjSA39-fgRKQ_1759973159
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 45BA81956096;
	Thu,  9 Oct 2025 01:25:59 +0000 (UTC)
Received: from fedora (unknown [10.72.120.19])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 370C019560BA;
	Thu,  9 Oct 2025 01:25:52 +0000 (UTC)
Date: Thu, 9 Oct 2025 09:25:47 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH V4 6/6] loop: add hint for handling aio via IOCB_NOWAIT
Message-ID: <aOcPG2wHcc7Gfmt9@fedora>
References: <20250928132927.3672537-1-ming.lei@redhat.com>
 <20250928132927.3672537-7-ming.lei@redhat.com>
 <aN92BCY1GQZr9YB-@infradead.org>
 <aOPPpEPnClM-4CSy@fedora>
 <aOS0LdM6nMVcLPv_@infradead.org>
 <aOUESdhW-joMHvyW@fedora>
 <aOX88d7GrbhBkC51@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOX88d7GrbhBkC51@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Oct 07, 2025 at 10:56:01PM -0700, Christoph Hellwig wrote:
> On Tue, Oct 07, 2025 at 08:15:05PM +0800, Ming Lei wrote:
> > NOWAIT is obviously interface provided by FS, here loop just wants to try
> > NOWAIT first in block layer dispatch context for avoiding the extra wq
> > schedule latency.
> 
> Yes.
> 
> > But for write on sparse file, trying NOWAIT first may bring extra retry
> > cost, that is why the hint is added. It is very coarse, but potential
> > regression can be avoided.
> 
> And that is absolutely not a property of loop, and loop should not have
> to know about.  So this logic needs to be in common code, preferably
> triggered by a fs flag.  Note that this isn't about holes - it is about
> allocating blocks.  For most file systems filling holes or extending
> past i_size is what requires allocating blocks.  But for a out of place
> write file systems like btrfs, or zoned xfs we always need to allocate
> blocks for now.  But I have work that I need to finish off that allows
> for non-blocking block allocation in zoned XFS, at which point you
> don't need this.  I think some of this might be true for network file
> systems already.

Firstly this FS flag isn't available, if it is added, we may take it into
account, and it is just one check, which shouldn't be blocker for this
loop perf improvement.

Secondly it isn't enough to replace nowait decision from user side, one
case is overwrite, which is a nice usecase for nowait.

> 
> > 
> > > rather have a flag similar FOP_DIO_PARALLEL_WRITE that makes this
> > > limitation clear rather then opencoding it in the loop driver while
> > 
> > What is the limitation?
> 
> See above.
> 
> > > leabing the primary user of RWF_NOWAIT out in the cold.
> > 
> > FOP_DIO_PARALLEL_WRITE is one static FS feature,
> 
> It actually isn't :( I need to move it to be a bit more dynamic on a
> per-file basis.
> 
> > but here it is FS
> > runtime behavior, such as if the write can be blocked because of space
> > allocation, so it can't be done by one static flag.
> 
> Yes, that's why you want a flag to indicate that a file, or maybe file
> operations instance can do non-blocking fill of blocks.  But that's
> for the future, for now I just want your logic lifted to common code
> and shared with io_uring so that we don't have weird hardcoded
> assumptions about file system behavior inside the loop driver.

As I mentioned the hint in this patch is very loop specific for avoiding
potential write perf regression, which just works for loop's case.

It can't be applied on io-uring, otherwise perf regression can be caused on
overwrite from io-uring application.

So I don't know what is the exact common code or logic for both loop and
io-uring.


Thanks,
Ming


