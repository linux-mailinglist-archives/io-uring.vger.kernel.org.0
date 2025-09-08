Return-Path: <io-uring+bounces-9639-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24B73B48CB4
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 13:59:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEF13200354
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 11:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B14352DE71C;
	Mon,  8 Sep 2025 11:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="geT4ONah"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8816F281375;
	Mon,  8 Sep 2025 11:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757332786; cv=none; b=ZKL9rRdsKzIsdWwiYeAYCt5aU/No8Jy5XQibJBQF+E1Idg5HI6uUtUZz/bVKX+kirUs8zcHX4OTWR0sXnx4WcwgUSJaauAwdJIXIwHG9cbbuhNACDhFyH8GjuO7PWCurRXvCl7uWE3FQbrxCJ93ybZcmcdmg/TpNqlkP8YmjS84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757332786; c=relaxed/simple;
	bh=Z18dYGbVBxhQdrBJ9dFppbGyfSMxBu3aI+xNHdGsRY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bq3rPHzRw/85Qf0fEG+dIU3aGptxXcZ71f6Su/7g+nX0SXOvheIrF8tH4slis9+Jetv4V+LL5/UFOtKKsWczkIA7BGdo8EHuucSXRTe2GvBZyjkN4uA7B43bR52yk6nKCq4fkgMQCLR9EwVzciInw4yL4HR6+UjiOum36RR4nEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=geT4ONah; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A280C4CEF1;
	Mon,  8 Sep 2025 11:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757332786;
	bh=Z18dYGbVBxhQdrBJ9dFppbGyfSMxBu3aI+xNHdGsRY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=geT4ONah7Ta5//y3PIOlrU1Dol+3QXefdse2eMuwWBvEmvtuZP+NtQMxesDyjj7gP
	 IHryqjAZvAe5VNlLmkG90gxclXBVTeesB+dHwRQROgkyzY2PyFqdU8K9VktawJXp+o
	 id5oizZ73ElSUnzzn2u9Mmczn7w+b9UCAVqmplb8EmxrlcJLNqsJkNk4oIBiQg/V0h
	 JLv93XejozRbTsjMZEw4lpb7L8DZWj441R7pGbB60FVXTdS2P0uwJ40c/oGsP0AV3B
	 VOq39sC6f8lNXV5DorGKqhUVAmEa2PsWR9vpzZMUnd5+ib/soZPCvP7EQF5ga8uJI0
	 tfNCl5JBesVYg==
Date: Mon, 8 Sep 2025 12:59:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg KH <gregkh@linuxfoundation.org>, Jens Axboe <axboe@kernel.dk>,
	Caleb Sander Mateos <csander@purestorage.com>,
	io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <684c2197-7cd4-4330-9a43-109c40fda9cf@sirena.org.uk>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
 <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <2025090614-busily-upright-444d@gregkh>
 <20250906-almond-tench-of-aurora-3431ee@lemur>
 <CAHk-=wh8hvhtgg+DhyXeJSyZ=SrUYE85kAFRYiKBRp6u2YwvgA@mail.gmail.com>
 <20250906-macho-reindeer-of-certainty-ff2cbb@lemur>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AVW3f+5yfb/QrPEv"
Content-Disposition: inline
In-Reply-To: <20250906-macho-reindeer-of-certainty-ff2cbb@lemur>
X-Cookie: Air is water with holes in it.


--AVW3f+5yfb/QrPEv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 06, 2025 at 02:50:49PM -0400, Konstantin Ryabitsev wrote:
> On Sat, Sep 06, 2025 at 08:31:59AM -0700, Linus Torvalds wrote:

> > An emailed patch series is *not* a git pull. If you want actual real
> > git history, just use git. Using a patch series and shazam for that
> > would be *bad*. It's actively worse than just using git, with zero
> > upside.

> The primary consumer of this are the CI systems, though, like those that plug
> into patchwork. In order to be able to run a bunch of tests they need to be
> able to apply the patches to a tree, so, in a sense, they do need to recreate
> git as much as possible, including the branch point.

Well, for CI we often don't exactly care that the patch is applied in
the context that the sender sent it, we care more that the patch is
applied for testing in the same context where it's going to be applied
when merged.  The base information is useful and we might want to use
it, but we might also not.  My flow is to apply things, test and then
push to the actual tree if the testing is happy so I'm testing the
actual commits that will be pushed if everything goes well.

> > No, the upside of a patch series is that it's *not* fixed in stone yet
> > - not in history, not in acks, not in actual code. So do *not*
> > encourage people to think of it as some second-rate "git history"
> > model. It's not, and it would be *BAD* at it.

> b4 will tell you if a series applies cleanly to the current tree, but I don't
> think we make use of this with `shazam -M` -- we always try to parent it
> against the indicated base commit. Is the recommendation then to always try to
> use the latest tree and bail out if it doesn't apply?

If we're going to automatically pick up the base commit that needs an
option to limit what the commits that might be selected are, people
don't always send something directly usable.  For example with a series
that should be split between trees (eg, a driver plus DT updates to add
the device to some boards) you might reasonably base off linux-next,
that'll get a current tree for everywhere the individual patches should
be applied.  For example my scripting when it's paying attention to base
commits will ignore anything that's not in the history of the branch the
tree is targeted at unless I explicitly tell it otherwise.

--AVW3f+5yfb/QrPEv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi+xSwACgkQJNaLcl1U
h9AzAQf+LOBfPDuwksbahnKf1GXymtpyeLECFBfMfugmzM8YN746jg30JE5ZRXNd
obXc5nva2BXLfe3FR+H7xWkCZutI7bM3bgZsxvFawqo/VsU4lcHV+wN+CsMKqpCM
pds3x8ycVS+idFkJJaHa6YhOIQXq9wg2iMakdgxPgiTvUcyJlLdIyUeeJDLthxYv
1eopWWDLIy2g/ih3koCuBWnxuqr9LqKzxyWaIfaDNOl6L1ZR/6+jLNCYfgN45yv1
gZtWk4HAm7iMYgTJrswhTy2cAZdYrah68vNoFyExCv3oe8/0VBub5Z4jJ8BeZ5dN
BDHjWkP7L4GxJcg2WJKyOrvXMGhLMg==
=m3M0
-----END PGP SIGNATURE-----

--AVW3f+5yfb/QrPEv--

