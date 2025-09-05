Return-Path: <io-uring+bounces-9608-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86908B463B1
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 21:34:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BACE5C3768
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 19:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B0A29D297;
	Fri,  5 Sep 2025 19:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0990vW6A"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DDD29BDAE;
	Fri,  5 Sep 2025 19:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757100796; cv=none; b=QYykhPrK7o11UrKu2ckEHEDI1RS2sEZvJ5CumIPJZZDxAxPTS8dcG12oMIINZFSXnwfDBiQYd66etoWMi+hXuH8zwbHti0afzP1Mk6AASqrfsuu7dgaifMWrVir3gsasunOPgdsDt2T6TRPGd1fglqh5ZckYV0oW2hG5gU5Q3W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757100796; c=relaxed/simple;
	bh=cH92BEoAZ7B/hPjqgKWRCa6e6AzFGtNxEks4z2eYejQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GiugYUxr50+tibkeRkXGmDAjODYqxKoIIveGv85UjBaW5ZvNXYWJp52WiRcz63zd8uE6RShEVYPxaUm71SY0NNGsnOw+rxXk/9z+J+WxwVsmOgtKW6NbSusuYjtxzS9nZfalsAdmHuHJI6J31ZS+REiHbeRUhqrCWNS2Wdibn1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0990vW6A; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A934FC4CEF1;
	Fri,  5 Sep 2025 19:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757100795;
	bh=cH92BEoAZ7B/hPjqgKWRCa6e6AzFGtNxEks4z2eYejQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0990vW6AZ8yObjk3Nt2vyPzAf71gNlm952V4intenD/lR4UPGJg6sgGcBX6BXlVdl
	 8MzL9V16oVs4MFmZvAQCl6MbBUw39LcPKmc2d4thKD9Hdsh1cE51VyA/NGnZq/tRBH
	 YL+ZnyVus4aMmcgXpgsn7HYhGe+uTuB4Zpnd8XaQ=
Date: Fri, 5 Sep 2025 15:33:14 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
 <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>

(Changing the subject and aiming this at workflows.)

On Fri, Sep 05, 2025 at 11:06:01AM -0700, Linus Torvalds wrote:
> On Fri, 5 Sept 2025 at 10:45, Konstantin Ryabitsev
> <konstantin@linuxfoundation.org> wrote:
> >
> > Do you just want this to become a no-op, or will it be better if it's used
> > only with the patch.msgid.link domain namespace to clearly indicate that it's
> > just a provenance link?
> 
> So I wish it at least had some way to discourage the normal mindless
> use - and in a perfect world that there was some more useful model for
> adding links automatically.
> 
> For example, I feel like for the cover letter of a multi-commit
> series, the link to the patch series submission is potentially more
> useful - and likely much less annoying - because it would go into the
> merge message, not individual commits.

We do support this usage using `b4 shazam -M` -- it's the functional
equivalent of applying a pull request and will use the cover letter contents
as the initial source of the merge commit message. I do encourage people to
use this more than just a linear `git am` for series, for a number of reasons:

- this clearly delineates the start and end of the series
- this incorporates the contents cover letter that can give more info about
  the series than just individual commits *without* the need to hit the lore
  archive
- this lets maintainers record any additional thoughts they may have in the
  merge commit, alongside with the original cover letter

Obviously, we don't want to use the cover letter as-is, which is why b4 will
open the configured editor to let the maintainer pulling in the series make
any changes to the cover letter before it becomes the merge commit.

Having the provenance link in the cover letter as opposed to individual
commits makes perfect sense in this case, especially because it is now very
obvious where the series starts and ends.

This does create a lot more non-linear history, though. Judging from some of
my discussions on the fediverse, some maintainers are not sure if that's okay
with you. If that's actually your preferred way of seeing series being
handled, then I'll work on updating maintainer docs to indicate that this is
the workflow to follow.

Question -- what would be the preferred approach for single-patch submissions?
I expect having a merge commit for those would be more annoying?

> Anyway, the "discourage mindless use" might be as simple as a big
> warning message that the link may be just adding annoying overhead.
> 
> In contrast, a "perfect" model might be to actually have some kind of
> automation of "unless there was actual discussion about it".
> 
> But I feel such a model might be much too complicated, unless somebody
> *wants* to explore using AI because their job description says "Look
> for actual useful AI uses". In today's tech world, I assume such job
> descriptions do exist. Sigh.

So, I did work on this for a while before running out of credits, and there
were the following stumbling blocks:

- consuming large threads is expensive; a thread of 20 patches and a bunch of
  follow-up discussions costs $1 of API credits just to process. I realize
  it's peanuts for a lot of full-time maintainers who have corporate API
  contracts, but it's an important consideration
- the LLMs did get confused about who said what when consuming long threads,
  at least with the models at the time. Maybe more modern models are better at
  this than those I tried a year ago. Misattributing things can be *really*
  bad in the context of decision making, so I found this the most troubling
  aspect of "have AI analyze this series and tell me if everyone important is
  okay with it."
- the models I used were proprietary (ChatGPT, Claude, Gemini), because I
  didn't have access to a good enough system to run ollama with a large enough
  context window to analyze long email threads. Even ollama is questionably
  "open source" -- but don't need to get into that aspect of it in this
  thread.

However, I feel that LLMs can be generally useful here, when handled with
care and with a good understanding that they do and will get things wrong.

> For example, since 'b4' ends up looking through the downstream thread
> of a patch anyway in order to add acked-by lines etc, I do think that
> in theory there could be some "there was lively discussion about this
> particular patch, so a link is actually worth it" heuristic.
> 
> In theory.

Yeah, in practice we can't tell a simple "good job, here's a reviewed-by" from
a "lively discussion," especially if the lively discussion was about something
else that had nothing to do with the contents of the series (e.g. as this
thread). The clever-er we try to be with b4, the quicker we run into corner
cases where our cleverness is actually doing the wrong thing.

So, I'm generally on the side of "dumb but predictably so."

-K

