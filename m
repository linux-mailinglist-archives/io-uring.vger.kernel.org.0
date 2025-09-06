Return-Path: <io-uring+bounces-9621-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CBAD9B46B62
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 13:30:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE44E7A787D
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 11:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCB917082A;
	Sat,  6 Sep 2025 11:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8hNSAZy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949AB3FBB3;
	Sat,  6 Sep 2025 11:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757158239; cv=none; b=IJBXnzhgVOY3s86RxghB+nME/HJsZuEsVif+l+SEn2uKY7qrBDhEsGezxmdaQuyKnhU2WasDcUI6iVvBIMQCmE19ogeWygof0Dmhmy9aRlvR3s4FhpTFxD2CMq/VZ+csJz2h9dBh7xyP6n7d/MKV8HBkq1OpBxfy4XliPSb9als=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757158239; c=relaxed/simple;
	bh=EVORCTkqkwCRSMu3NUDPY1xsO1kW8QaI0S62v3I2cfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDWdemAFu0vGZmiOXSGc2QsWeoG0XuMlyS7oBxo81DYMbAJxKhl4bA+7+9OeUfuG+Dmn/VmSppNILUlW0FEpEu6SdrYaahZiHo+Ui55K9pYxDd07uTyYT7UlT9nZr2v9XOe/hHAbRP9F4fv89EvdJP0cVdkghjWkjoMf0PG6iPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8hNSAZy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA664C4CEE7;
	Sat,  6 Sep 2025 11:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757158239;
	bh=EVORCTkqkwCRSMu3NUDPY1xsO1kW8QaI0S62v3I2cfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D8hNSAZyCLamH9eCdoTrCXo3euObmNWA8q7cZHA7MrEe2VzapyF9psVbXpnBdNexM
	 gnJFSNQi6r5u4zSwXBphBO/H7b7eIiz8/uOLc7+G2TLHaQmWXO0aTALrfex+0RAHsl
	 8C/s4bfCsto1Scq3JcKU9/+CQ+K9dXX5uGfEzXJg=
Date: Sat, 6 Sep 2025 13:30:36 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Caleb Sander Mateos <csander@purestorage.com>,
	io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <2025090605-evidence-chomp-d442@gregkh>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
 <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <2025090614-busily-upright-444d@gregkh>
 <2025090633-calcium-legroom-586f@gregkh>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025090633-calcium-legroom-586f@gregkh>

On Sat, Sep 06, 2025 at 01:27:57PM +0200, Greg KH wrote:
> On Sat, Sep 06, 2025 at 01:27:04PM +0200, Greg KH wrote:
> > On Fri, Sep 05, 2025 at 03:33:14PM -0400, Konstantin Ryabitsev wrote:
> > > (Changing the subject and aiming this at workflows.)
> > > 
> > > On Fri, Sep 05, 2025 at 11:06:01AM -0700, Linus Torvalds wrote:
> > > > On Fri, 5 Sept 2025 at 10:45, Konstantin Ryabitsev
> > > > <konstantin@linuxfoundation.org> wrote:
> > > > >
> > > > > Do you just want this to become a no-op, or will it be better if it's used
> > > > > only with the patch.msgid.link domain namespace to clearly indicate that it's
> > > > > just a provenance link?
> > > > 
> > > > So I wish it at least had some way to discourage the normal mindless
> > > > use - and in a perfect world that there was some more useful model for
> > > > adding links automatically.
> > > > 
> > > > For example, I feel like for the cover letter of a multi-commit
> > > > series, the link to the patch series submission is potentially more
> > > > useful - and likely much less annoying - because it would go into the
> > > > merge message, not individual commits.
> > > 
> > > We do support this usage using `b4 shazam -M` -- it's the functional
> > > equivalent of applying a pull request and will use the cover letter contents
> > > as the initial source of the merge commit message. I do encourage people to
> > > use this more than just a linear `git am` for series, for a number of reasons:
> > > 
> > > - this clearly delineates the start and end of the series
> > > - this incorporates the contents cover letter that can give more info about
> > >   the series than just individual commits *without* the need to hit the lore
> > >   archive
> > > - this lets maintainers record any additional thoughts they may have in the
> > >   merge commit, alongside with the original cover letter
> > > 
> > > Obviously, we don't want to use the cover letter as-is, which is why b4 will
> > > open the configured editor to let the maintainer pulling in the series make
> > > any changes to the cover letter before it becomes the merge commit.
> > 
> > I like this a lot, and just tried it, but it ends up applying the
> > patches from the list without my signed-off-by, which will cause
> > linux-next to complain when it sees that I committed patches without
> > that.
> > 
> > Did I miss an option to `b4 shazam`?  Does it need to add a -s option
> > like `b4 am` has?
> 
> Oh nevermind, it does support -s.  It's just not documented :)
> 
> let me go make a patch...

And it is documented.  Ugh, nevermind, I need more coffee, sorry for the
noise.

