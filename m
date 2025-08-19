Return-Path: <io-uring+bounces-9055-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10666B2BDC0
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 11:43:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CA451884D59
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 09:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B9731A05B;
	Tue, 19 Aug 2025 09:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJGMW5S3"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6824A31A048;
	Tue, 19 Aug 2025 09:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755596609; cv=none; b=YLntwHb9pSRWrnvNzOY8KUfgYLdkwRjffruwbhN2KSMDfTgZ2X9u4PI6C1NrxF88jmpBVSFlAaAqd2tPqZzWaKuMiZUmToFwTvvd6M1QS17L2Hui0bwQa01JES/I8LTcAf97nN2T31AgcK5KsEEPSQ1b9FrHzvj6bYSJTS4lEHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755596609; c=relaxed/simple;
	bh=tdTkeisceSQV+wOrvcB1lSQqOqyddwQ9F5klGtSfUXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XLuOGRc+fcy+w5NpsII3+ksIaCG+qBbfdIFdtUPSWRiaPqs61obI/NNXElfSKQotWkqTbHR/gB3gNXwkPbBWNp/+2SEpUOENg3R0wCrnnQ6WGdc25kxuOEEGTDpbCekvlSC70poAvmJ/djhPihDRIpOVeD0vHj7e1lQHC3tPDdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KJGMW5S3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3B2C4CEF1;
	Tue, 19 Aug 2025 09:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755596608;
	bh=tdTkeisceSQV+wOrvcB1lSQqOqyddwQ9F5klGtSfUXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KJGMW5S37jKqU+1+bgbURyL096oJ30LdcqjT4u22TMsUwrn6Aif82gIU7884w8kJJ
	 MljlaIpAIdt5VkekmX23efVQLQDyqOKRcOHp2Xkzmfr7FB5BwIOXMuvAPeBeDp0PFZ
	 FdgDjpmp1srFE7HV2X3vnBsSk+cMT2anVsVtea5GUNyO14Mbe+kkFOFLvQS1+oqxcy
	 5TirnPTdOjJX8it8lOvGK2NS6zb+lwWkZDSU3UXZpy/9KpahrPbvPFkCIzur8f3p/6
	 lsB/9REytYv8PszfD2vEpOH9SFepps8lNvLB2mPxkMc7XyE/ZIZoGUOQbcvg5bFKhh
	 sbWy/5vcu0geA==
Date: Tue, 19 Aug 2025 11:43:24 +0200
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>, 
	io-uring@vger.kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 3/6] fhandle: do_handle_open() should get FD with user
 flags
Message-ID: <20250819-gezeugt-umeinander-e354e377c266@brauner>
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
 <20250814235431.995876-4-tahbertschinger@gmail.com>
 <CAOQ4uxhhSRVyyfZuuPpbF7GpcTiPcxt3RAywbtNVVV_QDPkBRQ@mail.gmail.com>
 <20250815-raupen-erdgeschichte-f16f3bf454ea@brauner>
 <CAOQ4uxgBXeE3N5Pq8p=3AgH_cFnkzOK=ipiZHwx6i_C6Oghc3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgBXeE3N5Pq8p=3AgH_cFnkzOK=ipiZHwx6i_C6Oghc3w@mail.gmail.com>

On Fri, Aug 15, 2025 at 03:51:53PM +0200, Amir Goldstein wrote:
> On Fri, Aug 15, 2025 at 3:46 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Fri, Aug 15, 2025 at 11:17:26AM +0200, Amir Goldstein wrote:
> > > On Fri, Aug 15, 2025 at 1:52 AM Thomas Bertschinger
> > > <tahbertschinger@gmail.com> wrote:
> > > >
> > > > In f07c7cc4684a, do_handle_open() was switched to use the automatic
> > > > cleanup method for getting a FD. In that change it was also switched
> > > > to pass O_CLOEXEC unconditionally to get_unused_fd_flags() instead
> > > > of passing the user-specified flags.
> > > >
> > > > I don't see anything in that commit description that indicates this was
> > > > intentional, so I am assuming it was an oversight.
> > > >
> > > > With this fix, the FD will again be opened with, or without, O_CLOEXEC
> > > > according to what the user requested.
> > > >
> > > > Fixes: f07c7cc4684a ("fhandle: simplify error handling")
> > > > Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> > >
> > > This patch does not seem to be conflicting with earlier patches in the series
> > > but it is still preferred to start the series with the backportable fix patch.
> > >
> > > Fee free to add:
> > > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> >
> > I'm kinda tempted to last let it slide because I think that's how it
> > should actually be... But ofc, we'll fix.
> 
> You mean forcing O_CLOEXEC. right?

Yes, of course. :)

> Not ignoring the rest of O_ flags...

No, I think that would be unwise. :)

