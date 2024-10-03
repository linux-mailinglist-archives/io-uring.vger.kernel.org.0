Return-Path: <io-uring+bounces-3399-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F44098F92F
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 23:48:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C893281B67
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 21:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E22061BDAB9;
	Thu,  3 Oct 2024 21:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uMjPkqbM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DE31AAE11;
	Thu,  3 Oct 2024 21:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727992132; cv=none; b=qQblZPgfhDh10yxa1dGdDdslQgzmsa579/hyGwrfQNtkes/StOHVKtD8nwcAuc/1nHR3PfgFZsk+POnZ06xykTWxxNwGyus8kwjmgzIj5leWVzRIc/3AeLkan2MZTdc5yoz4f8hbheu1NcbY4ziTqBP3Zt5F26TI19po/umArAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727992132; c=relaxed/simple;
	bh=4AzBG75BomVJ/TJ9cdnRW/C1hFEjYKKZnSLWMe4SVh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WYmjuHBuxztvHyONuxygT3hQJlsO1nuFX9JSrGj2PEAlmUOrGPtbXwfAKBqjXtaLMCurs8ta7ViqATNKQuNHUWnzTVhdpZMpPilwjQfDRgmAiz7vVvbskY01knvjaEDz/48vo+Ul/cL3T47qIflPQJ1xDGNSRnRvvlLJ07m8ir0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uMjPkqbM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE120C4CEC5;
	Thu,  3 Oct 2024 21:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727992132;
	bh=4AzBG75BomVJ/TJ9cdnRW/C1hFEjYKKZnSLWMe4SVh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uMjPkqbMwo6KWPI/vjV7wXJVcjwZU9LhSDuHlFJrl85NLpOnFN+mcoCL/a5A3Divj
	 z5qDWLrJ6MU/QyLV0Fuz2n1HOo03ima2F4T83y0nI6Fh5zPIyhsNCWSmFhB30vtOe4
	 3YPqLCzzxVHxYqHpqPa0hpTwTUzTJ9PM1AzSfnUMNATDYf3c2ZC6wsfyWZinLRZGe+
	 yQKSCwPkVxyhdwmkwz0NEQRcP0D4kibaGXmB7FbKPIF9yaCBxy9sDH6KEcMNvNMKAQ
	 /VdwNv6PEykXhqeNS5TogetQApSvcMFGBGRtQL7rDPNdm8sXMYnqH8nq0H7Aw4nqVq
	 DFXq83HxwBV1g==
Date: Thu, 3 Oct 2024 15:48:48 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
	hare@suse.de, sagi@grimberg.me, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, asml.silence@gmail.com,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-aio@kvack.org, gost.dev@samsung.com, vishak.g@samsung.com,
	javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <Zv8RQLES1LJtDsKC@kbusch-mbp>
References: <20241001092047.GA23730@lst.de>
 <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk>
 <20241002075140.GB20819@lst.de>
 <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
 <20241002151344.GA20364@lst.de>
 <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
 <20241002151949.GA20877@lst.de>
 <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com>
 <a8b6c57f-88fa-4af0-8a1a-d6a2f2ca8493@acm.org>
 <20241003125516.GC17031@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241003125516.GC17031@lst.de>

On Thu, Oct 03, 2024 at 02:55:16PM +0200, Christoph Hellwig wrote:
> On Wed, Oct 02, 2024 at 11:34:47AM -0700, Bart Van Assche wrote:
> > Isn't FDP about communicating much more than only this information to
> > the block device, e.g. information about reclaim units? Although I'm
> > personally not interested in FDP, my colleagues were involved in the
> > standardization of FDP.
> 
> Yes, it is.  And when I explained how to properly export this kind of
> information can be implemented on top of the version Kanchan sent everyone
> suddenly stopped diskussion technical points and went either silent or
> all political.

The nominals can mean whatever you want. If you want it to mean
"temperature", then that's what it means. If you want it to mean
something else, then don't use this.

These are hints at the end of the day. Nothing locks the kernel into
this if a better solution develops. As you know, it was ripped out
before.

> So I think some peoples bonuses depend on not understanding the problem
> I fear :(

The only "bonus" I have is not repeatedly explaining why people can't
use h/w features the way they want.

