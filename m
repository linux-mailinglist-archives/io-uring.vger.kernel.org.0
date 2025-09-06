Return-Path: <io-uring+bounces-9625-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C03FFB4764D
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 20:50:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7F761BC73A1
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 18:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00F49253F12;
	Sat,  6 Sep 2025 18:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDeOnFku"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8DE2222AF;
	Sat,  6 Sep 2025 18:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757184650; cv=none; b=j6VcXUWPCYgLEKYUNwq5pA9IMxpfsDQD6xQI1HUR1ZqfShfsG0tQ7iJyQUjrbJ7v0iUjuVZKGxNOSFJji9Su6u0KbfpGvSD8YOG1zA7g2xxcxmeTVtpj6w5XqGhtlruFxRdYJ0xQy6m8jvSUYN/dsXPvBxJgdk5eZ/FvTd5i1XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757184650; c=relaxed/simple;
	bh=FxXZFlSUHRGwj45r/lRFUsNZzQNOYdefVc1ypWMBIeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ab2w3dEwv7JYGcU8PiX62Z/P/m9PzNtsJu2OIkVuYgF+FHTYm/TAehjfhmwW5HnPtVCP8BqySbH5qpqHE1nIp8HtrCEf7sogdEvYmJ2NYICMI4joRq/gEm/5Pawa6kGeg/R6jXKUTeFUGj+gFZulP5A0DnOLNWEY6rt6Rlxw6pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDeOnFku; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37245C4CEE7;
	Sat,  6 Sep 2025 18:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757184650;
	bh=FxXZFlSUHRGwj45r/lRFUsNZzQNOYdefVc1ypWMBIeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cDeOnFkuoQmpMTWI9WG5kzXFrafRp0OyPMQNGIL3DhCYUNeVCz3BbOwLrskAwOJht
	 x8aj5el9I9DSeONhE8SkPNxPDTF06QSZlZk4bZ4JOkco4fCo7Gv8oJTBwOyIWrpRZM
	 C4p43LcXQcdlC3V7XV5Wd1i0SaXReLg96VtEsO9I=
Date: Sat, 6 Sep 2025 14:50:49 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jens Axboe <axboe@kernel.dk>, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <20250906-macho-reindeer-of-certainty-ff2cbb@lemur>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
 <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <2025090614-busily-upright-444d@gregkh>
 <20250906-almond-tench-of-aurora-3431ee@lemur>
 <CAHk-=wh8hvhtgg+DhyXeJSyZ=SrUYE85kAFRYiKBRp6u2YwvgA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wh8hvhtgg+DhyXeJSyZ=SrUYE85kAFRYiKBRp6u2YwvgA@mail.gmail.com>

On Sat, Sep 06, 2025 at 08:31:59AM -0700, Linus Torvalds wrote:
> On Sat, 6 Sept 2025 at 06:51, Konstantin Ryabitsev
> <konstantin@linuxfoundation.org> wrote:
> >
> > Unfortunately, `shazam -M` is not perfect, because we do need to know the
> > base-commit, and there's still way too many series sent without this info.
> 
> No, no. You're thinking about it wrong.
> 
> An emailed patch series is *not* a git pull. If you want actual real
> git history, just use git. Using a patch series and shazam for that
> would be *bad*. It's actively worse than just using git, with zero
> upside.

The primary consumer of this are the CI systems, though, like those that plug
into patchwork. In order to be able to run a bunch of tests they need to be
able to apply the patches to a tree, so, in a sense, they do need to recreate
git as much as possible, including the branch point.

> No, the upside of a patch series is that it's *not* fixed in stone yet
> - not in history, not in acks, not in actual code. So do *not*
> encourage people to think of it as some second-rate "git history"
> model. It's not, and it would be *BAD* at it.

b4 will tell you if a series applies cleanly to the current tree, but I don't
think we make use of this with `shazam -M` -- we always try to parent it
against the indicated base commit. Is the recommendation then to always try to
use the latest tree and bail out if it doesn't apply?

> That kind of global history would be *worse* for the whole "send
> patches by email" model.
> 
> So don't strive to replicate git - badly. Strive to do a *good* job.

But people do want to replicate git, if only so they can run integration tests
in a more automated fashion. If I understand correctly, you suggest two modes
of operations:

1. recreate the tree exactly as the author intended, so that CI systems can
   run tests.

2. try to create a merge commit on top of the latest HEAD and bail if it's not
   working, letting the maintainer fix any conflicts on their own.

> Your comment about how you want to know the base commit makes me think
> you are missing the point.

No, I'm mostly implementing what people tell me they'd like to see. :) Someone
once told me that they really wanted to be able to treat mailed series exactly
like a pull request, hence why this feature exists. You're actually the first
person to say that this behaviour is not what we should be doing.

-K

