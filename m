Return-Path: <io-uring+bounces-9679-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFE60B50402
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 19:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC8313665FA
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 17:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 237AD31D37B;
	Tue,  9 Sep 2025 17:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b9KxJN1b"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE32331D378;
	Tue,  9 Sep 2025 17:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757437724; cv=none; b=raurqxyUKcEDlNCAlxRks5gVR6e5971Zfeg2nRJcK5oxAZ+bNa2klbUybRLw8Qlh6LBdX95ZPKRjRQ4rEgcrbYjoTUS0VPHisxjUKikB1tfUjsAd8MQJ9LfM8On2k4b2riM3WecbcfH+mja5uy6BsAd+Wr6H4AsCgpwXTsQ6ImA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757437724; c=relaxed/simple;
	bh=hi6cEt60zaZ0xCDIiKQ2aYsqzKZgqAl/bJaZ5cBOPPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pAF2X87PgTFrRD1RTXGX9yv+58ObUjBdPW0uVeAzJ4jeKr0xZHv/4wbz4ZhCQESMU9upLGcPHjev+pt/UUSXyV2D2i/IYzNSwMWKnfNsbPKfNLcbPNs0DOoMaKh6wP1EB5I+t2WH+RGrlKwsasybQwA8TuWDc2myKs3E+alnhK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b9KxJN1b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91872C4CEF4;
	Tue,  9 Sep 2025 17:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757437723;
	bh=hi6cEt60zaZ0xCDIiKQ2aYsqzKZgqAl/bJaZ5cBOPPQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b9KxJN1bwosCellYJA/xJez/HreyGOeQd+bkztwmrrtaAThBdRCqZ8xqPP9600c4R
	 ZTY4lmQMDUxrkbEvorZZlNaZkpyroYVknwake5lPyUEXwXTUQVDmPWTtiWV+Q6q+oH
	 COrVL88EH6UMcCTl3X/3mNbIdHBWicYxijkYMmPheEbEnrZm1MkOH3viLC67v5Cc49
	 p4C6sanOebPRYX8biyze8diWlENV1RDjH3STHZ6CdDJIdqkfHiDkh3qp9WwZS86IpH
	 rwFX4et/+mfWmiDiiPy7KXRgXCLQ+p1RCuxT/Bu5pV56uuOyXMd3CsvD4e/nYT9AeV
	 lAzO5WXcJLnxA==
Date: Tue, 9 Sep 2025 18:08:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@suse.cz>,
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
	Jakub Kicinski <kuba@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>, dan.j.williams@intel.com,
	Caleb Sander Mateos <csander@purestorage.com>,
	io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <af29e72b-ade6-4549-b264-af31a3128cf1@sirena.org.uk>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
 <5922560.DvuYhMxLoT@rafael.j.wysocki>
 <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
 <20250909-green-oriole-of-speed-85cd6d@lemur>
 <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz>
 <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
 <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zGTJggtXh3KWuyOA"
Content-Disposition: inline
In-Reply-To: <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
X-Cookie: Ma Bell is a mean mother!


--zGTJggtXh3KWuyOA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 09, 2025 at 09:40:54AM -0700, Linus Torvalds wrote:

> Because if it's in a mindless script, then dammit, the lore "search"
> function is objectively better after-the-fact. Really. Using the lore
> search gives the original email *and* more.

That's not been my experience, especially now that b4 exists - my actual
workflow for this stuff is to pull the message ID out of the patch and
feed that to b4 mbox, then fire up mutt to look at the mbox.  That mbox
will have the whole thread, not just the individual message.

> Now do this:

>     firefox https://lore.kernel.org/all/?q=$(git rev-parse e9eaca6bf69d^2)

> and see how *USELESS* and completely redundant a link would have been?
> IT'S RIGHT THERE, FOR CHRISSAKE!

> That search is guaranteed to find the pull request if it was properly
> formatted, because the automation of git request-pull adds all the
> relevant data that is actually useful. Very much including that top
> commit that you asked me to pull.

That works great for pull requests, but it's not so useful for a random
patch like 5f9efb6b7667043527d377421af2070cc0aa2ecd ("Input:
mtk-pmic-keys - MT6359 has a specific release irq").  In that case the
subject line is reasonably unique but still gets me three revisions of
the series and it's a couple of clicks to get to the mbox (as it is for
the pull request) having made sure I'm going to the most recent one,
some things search picks up rather more stuff.  You get fun things like
vN being applied racing with vN+1 being posted.

> And if you have some workflow that used them, maybe we can really add
> scripting for those kinds of one-liners.

The above is my main use case for this, and I think similar for a lot of
the people working with test results - I have a git commit, how do I
translate that into a mbox with the specific thread where the patch
resulting in that commit was posted?  For me it would be ideal if no web
browser would be needed, that's suboptimal all round.

--zGTJggtXh3KWuyOA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjAXxYACgkQJNaLcl1U
h9D0LAgAhbOrMr6MLzV9o1oB08rD8rrRgEYApGE/S7d/2jw72832AlbMtcdj3nX1
10a5gSGsyUsNG3BcWZBxoyER3htGDvbzp/ZZvB8T7cKYtgsKhTwRja2POlNYB016
kXdeqv2sDgtfEsZ+VLvJWnrWWjA62K3XJFRSH3OsHGYN0MwhCq7TnmZwOIqD0Vx/
VESAHRU+aak5pzYgoOu5AcHRqyf6v3HJVz1USpfSE6fAVxkSUDdVraSr+tgTQ04m
BB4QwZydziNmnVwjpn9ZCO3uW7B4hWiqFgF7VMyGgZU+OR+6Hyq2RRfTDGyo5avE
In7ikWQ78i1nNLdO1tFkANCa3+IiQQ==
=wpXS
-----END PGP SIGNATURE-----

--zGTJggtXh3KWuyOA--

