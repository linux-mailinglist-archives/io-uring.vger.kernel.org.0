Return-Path: <io-uring+bounces-9702-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F6CB515B4
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 13:30:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99976563CD3
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 11:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9FA631A056;
	Wed, 10 Sep 2025 11:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="huiukmA3"
X-Original-To: io-uring@vger.kernel.org
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFF6311958;
	Wed, 10 Sep 2025 11:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.167.242.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757503805; cv=none; b=CmFUVYIt3AeFGVoHKzUXMSvVFPvYDmcBh7HnXgcRMe5H9RBFpDaDMRCMtEmEs1YO4wGqLH/blRn53nt6CDBhOvHONBKl0XdQYCTpG77H18MnectVq8G4GkAPimKgWYxvLSdmOKAPlCuP1thq7t98nHA6dQPCRoS2J9Mz/TxJsSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757503805; c=relaxed/simple;
	bh=dGGaE5gGnSoFmRFksPhIAkDqdqcyIncmyznWMwPQu9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dtagy55wRm5m1xDYWbjQpYgNWOBfcE/p432tHnjEfM9cldqnyXufUOiEckzE2qr77yYrZmZA/gyoO6u7mmpduy/yAvT6QzJzdaeBUlRqem/86+Xn6PdwqRFUmwNNGhkHjeaT0SLqICR1xpPH1tC4J/sIpKAmPVD6HZdRrnF6V7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com; spf=pass smtp.mailfrom=ideasonboard.com; dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b=huiukmA3; arc=none smtp.client-ip=213.167.242.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ideasonboard.com
Received: from pendragon.ideasonboard.com (81-175-209-231.bb.dnainternet.fi [81.175.209.231])
	by perceval.ideasonboard.com (Postfix) with UTF8SMTPSA id 8B5BF346;
	Wed, 10 Sep 2025 13:28:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1757503726;
	bh=dGGaE5gGnSoFmRFksPhIAkDqdqcyIncmyznWMwPQu9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=huiukmA3OrXdXQ8xXx+fJwmsFCZnfP1NL63xR3sVE39uXsRENm+HEGGviqsV6oz98
	 khRf0pZLzMVbR/VVPzNEVVjP7IU7boHpx1QTpN65SwaaP83seO71ZstP24597uRjfR
	 iEes1NaDtV8kAghJMlmNZNxhdBHbzktyF9VgvF7Y=
Date: Wed, 10 Sep 2025 14:29:37 +0300
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, konstantin@linuxfoundation.org,
	csander@purestorage.com, io-uring@vger.kernel.org,
	torvalds@linux-foundation.org, workflows@vger.kernel.org
Subject: Re: [RFC] b4 dig: Add AI-powered email relationship discovery command
Message-ID: <20250910112937.GE20904@pendragon.ideasonboard.com>
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <20250909163214.3241191-1-sashal@kernel.org>
 <20250909172258.GH18349@pendragon.ideasonboard.com>
 <72dd17ad-5467-49d3-9f40-054b1bf875d5@kernel.dk>
 <aMB3_VgB4mwp-bzP@laps>
 <20250910101342.GD20904@pendragon.ideasonboard.com>
 <aMFZO6g2L5YCKR_O@laps>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aMFZO6g2L5YCKR_O@laps>

On Wed, Sep 10, 2025 at 06:55:55AM -0400, Sasha Levin wrote:
> On Wed, Sep 10, 2025 at 01:13:42PM +0300, Laurent Pinchart wrote:
> > On Tue, Sep 09, 2025 at 02:54:53PM -0400, Sasha Levin wrote:
> >> On Tue, Sep 09, 2025 at 11:26:19AM -0600, Jens Axboe wrote:
> >>> On 9/9/25 11:22 AM, Laurent Pinchart wrote:
> >>>> On Tue, Sep 09, 2025 at 12:32:14PM -0400, Sasha Levin wrote:
> >>>>> Add a new 'b4 dig' subcommand that uses AI agents to discover related
> >>>>> emails for a given message ID. This helps developers find all relevant
> >>>>> context around patches including previous versions, bug reports, reviews,
> >>>>> and related discussions.
> >>>>
> >>>> That really sounds like "if all you have is a hammer, everything looks
> >>>> like a nail". The community has been working for multiple years to
> >>>> improve discovery of relationships between patches and commits, with
> >>>> great tools such are lore, lei and b4, and usage of commit IDs, patch
> >>>> IDs and message IDs to link everything together. Those provide exact
> >>>> results in a deterministic way, and consume a fraction of power of what
> >>>> this patch would do. It would be very sad if this would be the direction
> >>>> we decide to take.
> >>>
> >>> Fully agree, this kind of lazy "oh just waste billions of cycles and
> >>> punt to some AI" bs is just kind of giving up on proper infrastructure
> >>> to support maintainers and developers.
> >>
> >> This feels like a false choice: why force a pick between b4-dig-like tooling
> >> and improving our infra? They can work together. As tagging and workflows
> >> improve, those gains will flow into the tools anyway.
> >>
> >> It's like saying we should skip -rc releases because they mean we've given up
> >> on bug free code.
> >
> > I really have trouble thinking this is a honest argument. We're
> > discussing the topic in the context of a project where we reject
> > thousands of patches all the time when they don't go in the right
> > direction.
> >
> > Throwing an LLM at the problem is not just a major waste of power, it
> > also hurts as it will shift the focus away from improving the
> > deterministic tools we've been working on. Using an LLM here only
> > benefits the companies that make money from those proprietary tools.
> 
> Really? Elsewhere in this thread I've already pointed out that something like
> this is very helpful because having to review hundreds of commits for
> backport/CVE assignment using our current scheme of Link: just pointing to the
> original submission and not any discussions is a major pain and a time waste.

That's debatable at best, I've stopped counting the number of developers
who are unhappy with the over-aggressive backport policy, and how LLMs
pick commits for backport that have no reason to be backported.

Don't get me wrong, I wouldn't want to be responsible for maintaining
stable kernels given the volume of commits. It's a never-ending,
thankless job. Still, claiming that LLMs solve the problem doesn't seem
true to me, they merely provide some sort of automation to allow us to
claim the problem has been addressed. It's closer to theatre than
engineering.

> Both Linus and Greg echoed the same concern. Heck, this thread started because
> Linus complained about how much of a human time waste our current scheme is.
> 
> So when presented with a real problem and a tool that can help mitigate it,
> you're still choosing to attack because it's LLM based and you have something
> personal against that.

I've long had something personal about using the wrong tool for a job
:-) That has very little chance of changing.

> Sorry, I'm done with this argument. Use it if you like, don't use it if you
> don't.

-- 
Regards,

Laurent Pinchart

