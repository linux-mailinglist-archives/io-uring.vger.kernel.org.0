Return-Path: <io-uring+bounces-9620-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32A22B46B42
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 13:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E72B23AC646
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 11:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B3D28313D;
	Sat,  6 Sep 2025 11:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1V/ROkYK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D4927CB35;
	Sat,  6 Sep 2025 11:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757158081; cv=none; b=RZfQAtRVyQoqaysqKQBhiDaeqPWaUoz/eSRls411FNnoMqzPolMa2vOQf4TjkqUmY/ZodOfYt233c+QEEkIBLjqLu9VK2hgXf6qxltTUBc/ZX5E0FfQDfVj5VcsBtk62WZUM8jk/or2pAf+7ovc3oMujZEva+2PcwI9A8EB9Olw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757158081; c=relaxed/simple;
	bh=UUlYB+wVVkdfngIGRkX7T7dpTPTGj1UM32R/16ho5FE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rZMFdASy/6wsrFxFNX2HhgVVIGFvpi976YcA/drrwmQfK/BvXDUC9q1VwAgiW8td65vwkwpBTsg/WBuCnSOh3f7ZTN2anxYLiQzKmcaYLXXRyq+kCLE0mZs6Dz/1h2uyikevr+tm1p+fyvvy3TFdMT3bySNvdV3SLXXnQ9+vcz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1V/ROkYK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB6DC4CEE7;
	Sat,  6 Sep 2025 11:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757158080;
	bh=UUlYB+wVVkdfngIGRkX7T7dpTPTGj1UM32R/16ho5FE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1V/ROkYK73OtQNbaZvgqEJVE+ZBS6vXh1OZbAMu+H9JrHr9vklgunOOsR1aHh+Dad
	 Wuk0fg8xwkYoq2Q/QxDqWzFQbg2XjtA3KZQOcwNPgjWhz3VKCK0Tvlpbdlj5nba9YF
	 3x2Lg1FdAZsJuACzkDG+Hx9gQfalBIXbF5OCoccM=
Date: Sat, 6 Sep 2025 13:27:57 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Caleb Sander Mateos <csander@purestorage.com>,
	io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <2025090633-calcium-legroom-586f@gregkh>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
 <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <2025090614-busily-upright-444d@gregkh>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025090614-busily-upright-444d@gregkh>

On Sat, Sep 06, 2025 at 01:27:04PM +0200, Greg KH wrote:
> On Fri, Sep 05, 2025 at 03:33:14PM -0400, Konstantin Ryabitsev wrote:
> > (Changing the subject and aiming this at workflows.)
> > 
> > On Fri, Sep 05, 2025 at 11:06:01AM -0700, Linus Torvalds wrote:
> > > On Fri, 5 Sept 2025 at 10:45, Konstantin Ryabitsev
> > > <konstantin@linuxfoundation.org> wrote:
> > > >
> > > > Do you just want this to become a no-op, or will it be better if it's used
> > > > only with the patch.msgid.link domain namespace to clearly indicate that it's
> > > > just a provenance link?
> > > 
> > > So I wish it at least had some way to discourage the normal mindless
> > > use - and in a perfect world that there was some more useful model for
> > > adding links automatically.
> > > 
> > > For example, I feel like for the cover letter of a multi-commit
> > > series, the link to the patch series submission is potentially more
> > > useful - and likely much less annoying - because it would go into the
> > > merge message, not individual commits.
> > 
> > We do support this usage using `b4 shazam -M` -- it's the functional
> > equivalent of applying a pull request and will use the cover letter contents
> > as the initial source of the merge commit message. I do encourage people to
> > use this more than just a linear `git am` for series, for a number of reasons:
> > 
> > - this clearly delineates the start and end of the series
> > - this incorporates the contents cover letter that can give more info about
> >   the series than just individual commits *without* the need to hit the lore
> >   archive
> > - this lets maintainers record any additional thoughts they may have in the
> >   merge commit, alongside with the original cover letter
> > 
> > Obviously, we don't want to use the cover letter as-is, which is why b4 will
> > open the configured editor to let the maintainer pulling in the series make
> > any changes to the cover letter before it becomes the merge commit.
> 
> I like this a lot, and just tried it, but it ends up applying the
> patches from the list without my signed-off-by, which will cause
> linux-next to complain when it sees that I committed patches without
> that.
> 
> Did I miss an option to `b4 shazam`?  Does it need to add a -s option
> like `b4 am` has?

Oh nevermind, it does support -s.  It's just not documented :)

let me go make a patch...

thanks,

greg k-h

