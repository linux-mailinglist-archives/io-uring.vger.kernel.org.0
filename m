Return-Path: <io-uring+bounces-4306-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B049B93BA
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 15:49:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDFCA1F21E2A
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 14:49:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D2F1AAE3B;
	Fri,  1 Nov 2024 14:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qqviswlY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FC41AA78E;
	Fri,  1 Nov 2024 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730472556; cv=none; b=H3JCkb7LcwaT5IE5nE9uqGVVrqcZy0i4BeYfg6VDNjnHPfwvOvxobaOqIyn8Ctz7FcOzCxGIt/El0kvZWCk/tT3BPqNesCprz9fp4VsMUdVKGU704xKniv6ggUP46BA24EjPDNoTgZ7pdInmOpFlm+so4WhMqWd6JymBdVU/4+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730472556; c=relaxed/simple;
	bh=k7EVw74ih8Q0h2JSgjLP3Pfx29kLuoxz2HYyitmb5QY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hBfAeUimU6J0Dijnu2NtLhFu8Y8RbYYEvS+B1WQ1IQJdsGs6JohqgBi6sliykFg8BYzQH+QafelXMTd3OY4LTWEvp6e+dFEEgplewQibODi2GoVftqWs3/9KleIeENlLK8ev57y5v1zkUnVqY4rs6apRk9ZiGbWBoNgAufxQoIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qqviswlY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFBFC4CECD;
	Fri,  1 Nov 2024 14:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730472555;
	bh=k7EVw74ih8Q0h2JSgjLP3Pfx29kLuoxz2HYyitmb5QY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qqviswlYX1BHKuPR5ekMMzxSlcNtysICRu79OUByTD9UMQIsGrpVy/A721KYFuHMe
	 TZgNQ9laCdOQKoOOdHw+RLLXTRMtPDyj+1aOdIvd/CmVB1QDlxAT1sXJW1ILqbhgQj
	 r2chJflG1cLWi+WegmVeWDFEgaGMQ1D/J7Vs55mWI6YhP5xHJdg5e1ZqnThl3RcSmW
	 A/t4EPA6eJxanq/Ag7wG+RZpB6Hdw1r++uL8XIiNJqWdiYaNtOJY5lcWERoBA2hDsR
	 ustDb/50m8C5CtlUteDhkjp1SoqsrgvAqVnupo9cwHKs137vxOIFE7gwnytEzws0Ol
	 0wDEgDRoQz2Pw==
Date: Fri, 1 Nov 2024 08:49:12 -0600
From: Keith Busch <kbusch@kernel.org>
To: Hans Holmberg <hans@owltronix.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <ZyTqZ3UR39VTHSA2@kbusch-mbp.dhcp.thefacebook.com>
References: <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com>
 <20241030154556.GA4449@lst.de>
 <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com>
 <20241030155052.GA4984@lst.de>
 <ZyJiEwZwjevelmW2@kbusch-mbp.dhcp.thefacebook.com>
 <20241030165708.GA11009@lst.de>
 <ZyK0GS33Qhkx3AW-@kbusch-mbp.dhcp.thefacebook.com>
 <CANr-nt35zoSijRXYr+ommmWGfq0+Ye0tf3SfHfwi0cfpvwB0pg@mail.gmail.com>
 <ZyOO4PojaVIdmlOA@kbusch-mbp.dhcp.thefacebook.com>
 <CANr-nt30gQzFFsnJt9Tzs1kRDWSj=2w0iTC1qYfu+7JwpszwQQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANr-nt30gQzFFsnJt9Tzs1kRDWSj=2w0iTC1qYfu+7JwpszwQQ@mail.gmail.com>

On Fri, Nov 01, 2024 at 08:16:30AM +0100, Hans Holmberg wrote:
> On Thu, Oct 31, 2024 at 3:06 PM Keith Busch <kbusch@kernel.org> wrote:
> > On Thu, Oct 31, 2024 at 09:19:51AM +0100, Hans Holmberg wrote:
> > > No. The meta data IO is just 0.1% of all writes, so that we use a
> > > separate device for that in the benchmark really does not matter.
> >
> > It's very little spatially, but they overwrite differently than other
> > data, creating many small holes in large erase blocks.
> 
> I don't really get how this could influence anything significantly.(If at all).

Fill your filesystem to near capacity, then continue using it for a few
months. While the filesystem will report some available space, there
may not be many good blocks available to erase. Maybe.
 
> > Again, I absolutely disagree that this locks anyone in to anything.
> > That's an overly dramatic excuse.
> 
> Locking in or not, to constructively move things forward (if we are
> now stuck on how to wire up fs support) 

But we're not stuck on how to wire up to fs. That part was settled and
in kernel 10 years ago. We're stuck on wiring it down to the driver,
which should have been the easiest part.

> I believe it would be worthwhile to prototype active fdp data
> placement in xfs and evaluate it. Happy to help out with that.

When are we allowed to conclude evaluation? We have benefits my
customers want on well tested kernels, and wish to proceed now.

I'm not discouraing anyone from continuing further prototypes,
innovations, and improvements. I'd like to spend more time doing that
too, and merging something incrementally better doesn't prevent anyone
from doing that.

> Fdp and zns are different beasts, so I don't expect the results in the
> presentation to be directly translatable but we can see what we can
> do.
> 
> Is RocksDB the only file system user at the moment?

Rocks is the only open source one I know about. There are propietary
users, too.

