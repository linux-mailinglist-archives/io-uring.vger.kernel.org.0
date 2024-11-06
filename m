Return-Path: <io-uring+bounces-4477-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F79C9BDE79
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 07:05:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D58CB22F4D
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 06:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4593D55E73;
	Wed,  6 Nov 2024 06:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2CK4oSvs"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1718836D;
	Wed,  6 Nov 2024 06:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730873146; cv=none; b=awGbxd6nInyXxVR6btSSLOdIBWZKnm15c5zu2o4Ad6sPXrOoEu4feJPbtjHoJDFTqKe9DP8ZETBM7t/ZTLrLrs4rAKPfHQ+eATJ+c6pFwip+P0SB4pOG3K4eiI0sWFBUDXg41VgirmvxBuv2msHgq7a8DbMe/VtrV/IiiSfO64I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730873146; c=relaxed/simple;
	bh=WxbzO6pfMlOShiCLVZII6L6t6lGJ+1jEJGdnxmGZ61g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IxeJCJy/crPPalcGxXlnUUz2X//HjRbnUB5Qj9ohjU2FZj3NwvUAGn6BRVUT4S0tjkGMvEscmPNTIC68+01Maldk8TyPXFoiLNO/WovfAQm3FvRC2q/Hy4ezc9B9VF4+E3FqmpBp2GrK+xvJmR647M4FBGMjoEgoURSUa7w8t0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2CK4oSvs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127DEC4CECD;
	Wed,  6 Nov 2024 06:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730873145;
	bh=WxbzO6pfMlOShiCLVZII6L6t6lGJ+1jEJGdnxmGZ61g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2CK4oSvsIRWPA6yzEfULcGhtGkIaKV5SulddRpvAAAtbFnJosS34w7YR90qgK6GpM
	 AsrS4n2GEHfi1PD10U3VtjtLHnCRAfgo+2WLYIursq8c96tCASiuRuq1hu7ABP16Jz
	 7tNUFhpTvjeYObbjG3vSD/B88eMnwbz/WeZ0yJKk=
Date: Wed, 6 Nov 2024 07:05:27 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>,
	Andrew Marshall <andrew@johnandrewmarshall.com>,
	io-uring@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: Stable backport (was "Re: PROBLEM: io_uring hang causing
 uninterruptible sleep state on 6.6.59")
Message-ID: <2024110620-stretch-custodian-0e7d@gregkh>
References: <3d913aef-8c44-4f50-9bdf-7d9051b08941@app.fastmail.com>
 <cc8b92ba-2daa-49e3-abe6-39e7d79f213d@kernel.dk>
 <ZygO7O1Pm5lYbNkP@kbusch-mbp>
 <25c4c665-1a33-456c-93c7-8b7b56c0e6db@kernel.dk>
 <c34e6c38-ca47-439a-baf1-3489c05a65a8@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c34e6c38-ca47-439a-baf1-3489c05a65a8@kernel.dk>

On Sun, Nov 03, 2024 at 07:38:30PM -0700, Jens Axboe wrote:
> On 11/3/24 5:06 PM, Jens Axboe wrote:
> > On 11/3/24 5:01 PM, Keith Busch wrote:
> >> On Sun, Nov 03, 2024 at 04:53:27PM -0700, Jens Axboe wrote:
> >>> On 11/3/24 4:47 PM, Andrew Marshall wrote:
> >>>> I identified f4ce3b5d26ce149e77e6b8e8f2058aa80e5b034e as the likely
> >>>> problematic commit simply by browsing git log. As indicated above;
> >>>> reverting that atop 6.6.59 results in success. Since it is passing on
> >>>> 6.11.6, I suspect there is some missing backport to 6.6.x, or some
> >>>> other semantic merge conflict. Unfortunately I do not have a compact,
> >>>> minimal reproducer, but can provide my large one (it is testing a
> >>>> larger build process in a VM) if needed?there are some additional
> >>>> details in the above-linked downstream bug report, though. I hope that
> >>>> having identified the problematic commit is enough for someone with
> >>>> more context to go off of. Happy to provide more information if
> >>>> needed.
> >>>
> >>> Don't worry about not having a reproducer, having the backport commit
> >>> pin pointed will do just fine. I'll take a look at this.
> >>
> >> I think stable is missing:
> >>
> >>   6b231248e97fc3 ("io_uring: consolidate overflow flushing")
> > 
> > I think you need to go back further than that, this one already
> > unconditionally holds ->uring_lock around overflow flushing...
> 
> Took a look, it's this one:
> 
> commit 8d09a88ef9d3cb7d21d45c39b7b7c31298d23998
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Wed Apr 10 02:26:54 2024 +0100
> 
>     io_uring: always lock __io_cqring_overflow_flush
> 
> Greg/stable, can you pick this one for 6.6-stable? It picks
> cleanly.
> 
> For 6.1, which is the other stable of that age that has the backport,
> the attached patch will do the trick.
> 
> With that, I believe it should be sorted. Hopefully that can make
> 6.6.60 and 6.1.116.

Now queued up, thanks.

greg k-h

