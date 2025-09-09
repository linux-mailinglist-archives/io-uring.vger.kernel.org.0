Return-Path: <io-uring+bounces-9669-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97725B4FFCF
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 16:45:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2BD21C6096A
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 14:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69082352061;
	Tue,  9 Sep 2025 14:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q40uWBRS"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F92834F47E;
	Tue,  9 Sep 2025 14:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757429081; cv=none; b=OG4AkdZ47KGGcb4ALsNf5ULwNTZW+pZP3M2lVOCzvzwMz618xrNenSY9aZOuj6BVI6Jeo+II9SGwNutcUrbuB3lUgJ5xQgCbrpj/eLFgjjfIA3Cm6sFKTSveZ3Q4fvhZRck5LxNxg+KXsuHNzKxGgA/nFHJwsaU2IAHvhgjuNj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757429081; c=relaxed/simple;
	bh=jTvQDaz2CulFQRyRJegugtxzCVwBwv8NYHmDN0oRc1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGOax6NIr49A5tZT6/zWUNE20z9jLjDCsdchy6LZXzsVwUZqV5ToHAEpMWoiEda/y2pFeifZITjI7cLzg2uz+8yMPkAucThYpQdjgyNoS4WXLKolL9c+m47aVrlhlW0kzsN+VwTdopA/pdImnWaiaOdrOAbdHW2WugjJSawAgaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q40uWBRS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA50C4CEFB;
	Tue,  9 Sep 2025 14:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757429080;
	bh=jTvQDaz2CulFQRyRJegugtxzCVwBwv8NYHmDN0oRc1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q40uWBRSC2FYSCiYQuiMBK8kUThiXaOjOVgR9FNFBBSzrSEIeDQgevPzVe+R+rvkq
	 NvlfeIC0o7BXT/XYQKWmqGOpVSg5eoJUQWccPS9sgwsoT6POxQWIrILY94KISuW/Qc
	 n6nZk1W6HKlMv6wTey9srVG9zrCuPGumeQ2bdkcA=
Date: Tue, 9 Sep 2025 16:44:37 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>, dan.j.williams@intel.com,
	Caleb Sander Mateos <csander@purestorage.com>,
	io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <2025090901-mangle-provable-6248@gregkh>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
 <5922560.DvuYhMxLoT@rafael.j.wysocki>
 <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>

On Tue, Sep 09, 2025 at 08:35:18AM -0600, Jens Axboe wrote:
> On 9/9/25 8:18 AM, Jakub Kicinski wrote:
> > On Tue, 09 Sep 2025 15:17:15 +0200 Rafael J. Wysocki wrote:
> >>>> We do support this usage using `b4 shazam -M` -- it's the functional
> >>>> equivalent of applying a pull request and will use the cover letter contents
> >>>> as the initial source of the merge commit message. I do encourage people to
> >>>> use this more than just a linear `git am` for series, for a number of reasons:  
> >>>
> >>> For me, as a subsystem downstream person the 'mindless' patch.msgid.link
> >>> saves me time when I need to report a regression, or validate which
> >>> version of a patch was pulled from a list when curating a long-running
> >>> topic in a staging tree. I do make sure to put actual discussion
> >>> references outside the patch.msgid.link namespace and hope that others
> >>> continue to use this helpful breadcrumb.  
> >>
> >> Same here.
> >>
> >> Every time one needs to connect a git commit with a patch that it has come from,
> >> the presence of patch.msgid.link saves a search of a mailing list archive (if
> >> all goes well, or more searches otherwise).
> >>
> >> On a global scale, that's quite a number of saved mailing list archive searches.
> > 
> > +1 FWIW. I also started slapping the links on all patches in a series,
> > even if we apply with a merge commit. I don't know of a good way with
> > git to "get to the first parent merge" so scanning the history to find
> > the link in the cover letter was annoying me :(
> 
> Like I've tried to argue, I find them useful too. But after this whole
> mess of a thread, I killed -l from my scripts. I do think it's a mistake
> and it seems like the only reason to remove them is that Linus expects
> to find something at the end of the link rainbow and is often
> disappointed, and that annoys him enough to rant about it.
> 
> I know some folks downstream of me on the io_uring side find them useful
> too, because they've asked me several times to please remember to ensure
> my own self-applied patches have the link as well. For those, I tend to
> pick or add them locally rather than use b4 for it, which is why they've
> never had links.
> 
> As far as I can tell, only two things have been established here:
> 
> 1) Linus hates the Link tags, except if they have extra information
> 2) Lots of other folks find them useful

I too find them useful, especially when doing stable backport work as
it's a link to the thread of multiple commits, so I can see what is, and
is not, tagged for stable, and the proper ordering of the commits.

So I'm going to want to keep leaving them on, they work well for those
that have to spelunk into our git branches all the time.

thanks,

greg k-h

