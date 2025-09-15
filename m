Return-Path: <io-uring+bounces-9789-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C81AB57808
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 13:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3846189A4EB
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 11:27:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13C42FC013;
	Mon, 15 Sep 2025 11:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ja2DteoC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C1A2DA776;
	Mon, 15 Sep 2025 11:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757935606; cv=none; b=CD7aVyCAleR73xGey07ze7Z1c7Izce/+5DJDmtwqZHNC7l2T/2MHjaFMu+m6sdxQMHAiW3K4hquTKG70nVnI6K8wK8XWNS1mtVowXWioNlL30ATYtKmU7HXlvh93quyQjqXMaoSFtjjkFBN/wa6dDPfKiEzuAhLhgvsyB6NerUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757935606; c=relaxed/simple;
	bh=MTehY0L7uXZCtPEzcuwk4qrp/9Xzk7WlwWtRRzf69nM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XYaVmfaaq2LHhHTjlvmyyGdU37q4YRd55kmwJojeOs9JjYCkzgF9UZH8zr3JnwjnEbaKNi1Y27v3E/sD+2SgIiK0lQbPAtcuNFFjwfuxSQhTGKRMz2bq3Zvzsv5o10NV40ld0gWJc8+E8jZY7a0Sswwm7TMpyr+uQPycKjkBArc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ja2DteoC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799B6C4CEF5;
	Mon, 15 Sep 2025 11:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757935606;
	bh=MTehY0L7uXZCtPEzcuwk4qrp/9Xzk7WlwWtRRzf69nM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ja2DteoCLWBcoQe/EXbxKqauAGJ4iwyxNYv7AoxghgC5mJ3xo4QWm9XvLYKDjZ6pL
	 vfY0ONPbDs4dBFqb0QVkKsXSCBPamLAC2bsu2eqXKZ8EBqT8FBwOCZaO5dGjtG0tj1
	 YWviD32b6yhr9MeWyDhlIAJxGgxoEgXOk1MwhrIM/1mupxfww5bN6SoQMkM0F4dfYf
	 3cu++4MzXsD5TUxXRYrcF9Nh7RBC2/H5/jkdeu53vm1iCx6jZrSnIgS9ZLfXbYaxyM
	 /JZKnl/j/UUxTHxsewbiFWDiv9pOGs5rlabExKW30rF/th9HC7ks5po4RBkXIpzXCm
	 1Sq4ZkKh+l/Pg==
Date: Mon, 15 Sep 2025 12:26:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	konstantin@linuxfoundation.org, axboe@kernel.dk,
	csander@purestorage.com, io-uring@vger.kernel.org,
	torvalds@linux-foundation.org, workflows@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] b4 dig: Add AI-powered email relationship discovery command
Message-ID: <6e25b2e7-67a2-4a92-95d5-adb279e811a7@sirena.org.uk>
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <4764751.e9J7NaK4W3@workhorse>
 <aMLlMz_ujgditm4c@laps>
 <4278380.jE0xQCEvom@workhorse>
 <aMMpqojURAZa7cPU@laps>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NgoFlW9mbzgjnno5"
Content-Disposition: inline
In-Reply-To: <aMMpqojURAZa7cPU@laps>
X-Cookie: We've upped our standards, so up yours!


--NgoFlW9mbzgjnno5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 03:57:30PM -0400, Sasha Levin wrote:

> We've started[1] the workflows@ list (which is how I stumbled on this thr=
ead)
> about 5-6 years ago when the concern from multiple maintainers was that w=
e all
> have our magical scripts, they are seriously ugly, and everyone are asham=
ed of
> sharing them. So this list was an effort to get the ball rolling on folks
> sharing some of those ugly workflows and scripts in an attempt to standar=
dize
> and improve our processes.

> I've shared this very hacky b4-dig script as exactly that: I have a very =
ugly
> bash script that addresses some of the issues Linus brought up around bei=
ng
> able to find more context for a given patch/mail.  I use that script ofte=
n, it
> helps me spend less time on browsing lore (no, dfn: won't find you syzbot
> reports or CI failures), and it just "works for me".

This seems like a great example of a situation where the suggestions
=66rom one of the other thread of asking people to clearly mark when patch
submissions are using these tools would have helped - had the submission
described the above then the Python level review would've gone a lot
differently I think.  Realising during review is a totally different
experience to being told up front.

--NgoFlW9mbzgjnno5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjH9/AACgkQJNaLcl1U
h9A7Wwf/beY2mgQEzSNuH//PeCC2wwtz5SKeaxX3/H7dBle9cqLQag46TsbxYgkZ
ahjRVZP44x/QoF10zwmVQ31vBVKlcGi78TBmmjpUrAMkPn5GZTMdBrTotUwnqyJE
uqaPDhU3LC9Q5M0HKJtfV0ntBrZIVVDGYQxcU89GED5m/ZFmZF6NDejJWDW87K96
8P9e+2Eqt4fB3qQqkRJSdeFfTMGnIW0KZEjyMN/KAydh6X1paG6rPXNUTtgRAybl
1crvZGjC3Ag959QcKjB/VbEeIJjk5SWq+jXfg7+ofMTN/7AAWa3Vz7E7AODz7ptn
Z7o5X8IjxnNtnKyMrlemCresCauiWQ==
=Zh1E
-----END PGP SIGNATURE-----

--NgoFlW9mbzgjnno5--

