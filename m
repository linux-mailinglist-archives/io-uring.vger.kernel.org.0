Return-Path: <io-uring+bounces-9694-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E191FB507A4
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 23:05:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11A28189C445
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 21:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C954C22173D;
	Tue,  9 Sep 2025 21:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nv2qxJX/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C8A1F3D58;
	Tue,  9 Sep 2025 21:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757451923; cv=none; b=I4VcA80kDqLOBszDSjEv4saTnm/e1MYgH9WPl2wZtmPxQu1L93PF6tJ+D1g7EZR/CWmUtNHN6vKlFHI6j/D+0GqOMaF2jG1MW8MFAvv5D53yJzFglpp1Nhhi3yktiKpgRHCNm6eMkZ8eCwcU8dQPGbQGKUiBQaeT+kEvEB8c8rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757451923; c=relaxed/simple;
	bh=vNOMPUmnU6XssDomYnLdwerx9PFNqm9nVH8sSFHH1Yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cR0WnOZGE4FAXiFh/s4wzydEF9JBl9A/wglR657wNITB3VX6M+fQYtvXHNM3xoEt0GayZ1dKhO9z5ImMgQa0JYAvJumDNAsmN2zp+pF1d/3tW877JV4PGaPDJKWxV/GO+0voB3iAzkEfKVGqhd3yDfWa0L/IqrNSZES0Yg9El4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nv2qxJX/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF1FC4CEF4;
	Tue,  9 Sep 2025 21:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757451921;
	bh=vNOMPUmnU6XssDomYnLdwerx9PFNqm9nVH8sSFHH1Yg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nv2qxJX/1dQbXHEsvXmOzlC9z8pH3VcF3Xpm0SBdLLfallO+LfF/LhbhwtEnlut5n
	 sgpGpzJOx9qodhlVZwY0VSyLrwyKrvE+u5gyHf4fgoe+6U0q2Kvh67lIr7AxW8e6Pc
	 NRHfm0pBJjiO5HkJwSVeBVlVlXxq+earYOScStWqVVBdYK5h6R//l01huM41oWRL1l
	 LuGkz6uWDi7rjuxu1KTRZNGQrWlH5AMDUQGqwopb6JrFXMZmVDhZNuzx7Yym7ZuSjD
	 YO2rEd9TpGNqS+MMC+SZUqoaB00xrouaEzHU1xS3mkJ26SjiRHETmzWK5P/cfddU41
	 hfqSIvxwSe/hQ==
Date: Tue, 9 Sep 2025 22:05:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
	Jakub Kicinski <kuba@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>, dan.j.williams@intel.com,
	Caleb Sander Mateos <csander@purestorage.com>,
	io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <22523fec-5745-40f9-8242-1c340bac843a@sirena.org.uk>
References: <5922560.DvuYhMxLoT@rafael.j.wysocki>
 <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
 <20250909-green-oriole-of-speed-85cd6d@lemur>
 <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz>
 <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
 <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
 <e09555bc-4b0f-4f3a-82a3-914f38c3cde5@suse.cz>
 <CAHk-=wgfWG+MHXoFG2guu2GAoSBrmcdXU2apj+MJpgdCXxwbwA@mail.gmail.com>
 <ad587c82-cc9c-43ef-89c5-d208734a4c7f@suse.cz>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mbJsZ2iIUchEgbGB"
Content-Disposition: inline
In-Reply-To: <ad587c82-cc9c-43ef-89c5-d208734a4c7f@suse.cz>
X-Cookie: Ma Bell is a mean mother!


--mbJsZ2iIUchEgbGB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 09, 2025 at 08:22:05PM +0200, Vlastimil Babka wrote:
> On 9/9/25 20:14, Linus Torvalds wrote:

> > But yes: please do continue to add links to the original email - IF
> > you thought about it. That has always been my standpoint. Exactly like
> > "Fixes", and exactly like EVERY SINGLE OTHER THING you add to a commit
> > message.

> Fine, maybe b4 could help here by verifying if patch-id works on commits in
> the maintainer's branch before sending a pr, and for those where it doesn't,
> the maintainer can decide to add them. It sounds more useful to me than
> adding anything "AI-powered" to it.

I think ideally if there's tooling for this it should have both a
verification feature like you mention and also be supported by b4 mbox
so that you can say "b4 mbox ${COMMIT}" or whatever and have it download
a mailbox like can currently be done with a message ID.  That'd keep the
usability we currently have, the tool could look in the message for a
link and use that if it needs it.

What might be especially usable for applying/publishing would be
something that can be used either in a hook or more likely in scripting
that'll take the Message-Ids from git that people currently use to
generate the Link: tags and discard them if whatever the tool usually
uses to find mail archive links works without them, or rewrite them into
Link: tags if not.  The tool could emit the warning you suggest when
leaving the links in.

--mbJsZ2iIUchEgbGB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjAlosACgkQJNaLcl1U
h9DYdwf/QGLJUhrIM3VlMAceJ2nDDxbEd/TpA0FpuOJMTcoFYsVjS54QrVWncdzf
RgNZcdu3oC6bRv9bK5wczsSyJ0QCvDNzKBAdpanAD/jhiUKqLMVZeORCYhDmEjn7
iMh5Wi6MMymjVq6MiK3a0IgIYpd+IAUIkKENdbMUlb6PU6njfgGfRfmS1ehM8XNS
JFhB8SrK+yZOWbes9J6IZ3ZRnpKLpWY6jrcp0867SXBirPUHNUJXV5Iqd+utS4e/
S3AhH8OeuVtYjrJN6ISOThWpT925V8VGV3jCl182GJU71BCLQQnJJVx1YxGT+s61
Ta3InC4Yb6dhfVuAFQ+EImWFB/Pbxw==
=Wkaj
-----END PGP SIGNATURE-----

--mbJsZ2iIUchEgbGB--

