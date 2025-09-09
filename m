Return-Path: <io-uring+bounces-9661-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A499EB4ABFF
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 13:29:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BAFF1B219E8
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 11:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C99D320CD9;
	Tue,  9 Sep 2025 11:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cak3ijy4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5407531D741;
	Tue,  9 Sep 2025 11:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757417356; cv=none; b=vAM9Q6rxTwMmSrjK/up4bwaVkt8fqqtrOi7GdeAtcu9wY0xB+v+2I7z2GxZAokQdIx4ET/dkWnDZPajXMj7EFqu0z9ZuRNeIl3MyqxmHfcHL5bKXIPjuSwZcp7epsm5N+LBi0/iqfnogcuRByJvRcZcz2dMKdFJCAgs994D5AXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757417356; c=relaxed/simple;
	bh=X0VC08lbTf4ADXXSPh4wvl08HHb0OF1/HAxWNsHKADk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k5N5Z5PVfsZtkdRzngnPCG17NokzEmyjaBc5JtFAnzIUB3hRB2cNiYYxHOMSJm/5w1Kox7dsHu2/yd9nnbtNUq8g9D3DG+FguK5xnXzX3kpBSxnInUVDICfdj68wFjLaQTNXDHyLBO/wou8rlRta1NWOmyKK3lcQdRWByNZhkP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cak3ijy4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEF9C4CEF4;
	Tue,  9 Sep 2025 11:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757417356;
	bh=X0VC08lbTf4ADXXSPh4wvl08HHb0OF1/HAxWNsHKADk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cak3ijy4AfW3KPyos+wo6/CNjzjgeLFY2Rg/gU2LPtfkBhcqIWW5X9BG+Hl6+WBny
	 DAsS91PRHPmvlzCjd4m50Dpj9AyXfA7la8fZVx9zNpFtIuKsqWu2UqwrBRg/BCFQ25
	 l/MiCXpthM9NSgHowDApcmR/Q9b3uUjScp4Bc40HRS+mdc9TW26oKWFm98HLzfkeVm
	 tY1AaO+7tL9TRHQbwQ71oV6TR6JT5DRyR2iSfmqj6aV3rGx+5kVk48bXIDORGUpJv3
	 Qiqcv8vaJ92c/aJRiAVZLM2HC8eh5QcuGZsGIIjIqKhjU4OK4Yh3oHxeKrkv+nJxO4
	 W+RKyaTRQucOQ==
Date: Tue, 9 Sep 2025 12:29:12 +0100
From: Mark Brown <broonie@kernel.org>
To: dan.j.williams@intel.com
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Caleb Sander Mateos <csander@purestorage.com>,
	io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <e448d26b-6514-400c-86ec-29f0f04634af@sirena.org.uk>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
 <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iKDciDXwQYc+Lf9P"
Content-Disposition: inline
In-Reply-To: <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
X-Cookie: Ma Bell is a mean mother!


--iKDciDXwQYc+Lf9P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 08, 2025 at 01:11:00PM -0700, dan.j.williams@intel.com wrote:
> Konstantin Ryabitsev wrote:

> > We do support this usage using `b4 shazam -M` -- it's the functional
> > equivalent of applying a pull request and will use the cover letter contents
> > as the initial source of the merge commit message. I do encourage people to
> > use this more than just a linear `git am` for series, for a number of reasons:

> For me, as a subsystem downstream person the 'mindless' patch.msgid.link
> saves me time when I need to report a regression, or validate which
> version of a patch was pulled from a list when curating a long-running
> topic in a staging tree. I do make sure to put actual discussion
> references outside the patch.msgid.link namespace and hope that others
> continue to use this helpful breadcrumb.

Yes, I use the links constantly too when reporting regressions - it's
super helpful to just be able to pull the message and thread from the
mailing list with b4.  You get an initial way into the discussion (and
any reports someone else made) and a good list of people to CC.

--iKDciDXwQYc+Lf9P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjAD4cACgkQJNaLcl1U
h9D4Owf/QKLfJlZTYPlyLO7+UtV3jD9ccqM8crHbkfIvGdY2MoZJhellCXqHch1a
UjcaHRSOKS9qafOufL8dwRvnofwafAk2oDq5QQc7gOCC47WrXGOlN8Ym3nOtGgUW
mOwuWPSBo6Dncf/kizDH53Xv0UnRhYeXTIoFvwBPUZVTmeqNsBqLDbIh4X79KVVi
CaiAwlfnFdBxdznKG/o7DygTRGbqsi/oV1/9qqnqSDjY69ilf8B9Eo+C2uefb61l
PhJ1hAJcTgyZP/CS/w58xWl3eOao1cvpcoXr4MWEN7CqB4iokXd8AsUGlnqsNIjr
wh504P9YBHYcfacAYAIqQevv3kx2NA==
=14Or
-----END PGP SIGNATURE-----

--iKDciDXwQYc+Lf9P--

