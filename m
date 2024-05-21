Return-Path: <io-uring+bounces-1940-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 506E68CB364
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 20:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AAB43B22456
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 18:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D561120322;
	Tue, 21 May 2024 18:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="JGBNWrkJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67891F959;
	Tue, 21 May 2024 18:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716315493; cv=none; b=LQc+dnbufsuFC+egXkGfEhRAv8q0bBDkyw1ujEZloIlC9cPsM5hG+dQ9N36q7NM1r7ronZ9LAlJl0O7aVPHYZIMSHYYA1dEb9qly90DB33zspAjPxeyWVKwD2fuI2grl+F9s8Xz0U7Ww+aZ2tAt7dnWCAVMswXZaDO5nBY6ploo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716315493; c=relaxed/simple;
	bh=QR1Tc5K/7o0+AkiE7lxgJ3pkj5BPv+zYIZLPP8GZTyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2ejDd0HmBdtb+FZZwRlJdGLkJjpBHic6CIgovJFkbvkmXy/ZPV/p9ua42HTK6JtN0s6YQK+avlAmp+vAm/4W4LpT0UiofbrqPeWZSbMOENXx73uppT3qow4CVgmO3+x9eGVAMbezUO41jUdjpzelj0Xe2hAtb9KJEGmLVGBDH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=JGBNWrkJ; arc=none smtp.client-ip=212.227.126.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1716315481; x=1716920281; i=christian@heusel.eu;
	bh=QR1Tc5K/7o0+AkiE7lxgJ3pkj5BPv+zYIZLPP8GZTyY=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=JGBNWrkJHeGQcN5ZqjIfu1P8oXWIttb+KXbk+NwE4B1QQpWer7Ilm8f7kW/x3hBZ
	 TZpcG6u5CwfxjMdzabkzdDQ5Vw1gVhFHxcMjhKTk2ROGQIR1u0KR57R0IxQazlpGr
	 WPrmUCfvqc4uVv4Mh1JGVYj4IXiQgKsjC7JP9KzuXeri/pJSZ9KqRsHHQYzmxizbn
	 Z8/BLNlQkH59a+9J7iA7YR5eItSLagfkIkD/IIEODTPS34uniB1VhmIepJHqW3/Ck
	 kWLDOElmdwl6ZnBJp7u+VMf6KYl374fEtogdMmovfABN1brJTVTQjqI/NsVXlt8+u
	 OYBL3hxpHgaA4Z53Ow==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([141.70.80.5]) by mrelayeu.kundenserver.de (mreue012
 [212.227.15.167]) with ESMTPSA (Nemesis) id 1Mf3yk-1slK2l0fzm-00gV1k; Tue, 21
 May 2024 20:18:01 +0200
Date: Tue, 21 May 2024 20:17:58 +0200
From: Christian Heusel <christian@heusel.eu>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Udvare <audvare@gmail.com>, regressions@lists.linux.dev, 
	io-uring <io-uring@vger.kernel.org>
Subject: Re: [REGRESSION] ETXTBSY when running Yarn (Node) since af5d68f
Message-ID: <yywbp7fjnwgqxvc66zimea4hgdc2eysjx5nezky3vndr7xw25l@jv76rdseqm3e>
References: <313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com>
 <8979ae0b-c443-4b45-8210-6394471dddd1@kernel.dk>
 <8de221f7-fe5a-4da9-899e-de2a856a4ddc@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4m4uzdi6s7s3b7sn"
Content-Disposition: inline
In-Reply-To: <8de221f7-fe5a-4da9-899e-de2a856a4ddc@kernel.dk>
X-Provags-ID: V03:K1:QzCgQhG+FCAeUy0ve6ps+EUmjZuI7cGJfnw4Bvg7/5aSjZmpaTi
 +loFMXUZsPc+GnV91HqY/ntMhLEnkp+WHF93pKMOBq94bTcsfnzuxbyxbP5aEstTpfIPfKP
 XP13XbHKHV7+M1tzECdcWAsmiY8hUrHocnC+2Czb2IeLDf2D3q+n2eJZk11RzUNvbUhY6kt
 kkuruAK/ozW+s6DLN51Wg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:sAiUW4L/KrA=;bQH5dVySgObQlCOC2bfwDpNIoIh
 1b6qLYozPNP8/sW7Q6WDpJOF2tvVqknu6KWw2BICR46Oi2mDOs+878zBIQ4WB+Zsc5POxM4M2
 2wbL350NBPvu61nHxITzQJb0tlQmfvdwJME/h+4H2fgwLT4LDjcv4Y4lINpz3xg8OfhY/Wd9+
 KpAyPX4RZb/sC1rbyWnYfIlsilB9P4HQi86Lh603lNgVnxTK556mwlJ4mCEx8Rj7CyWPe0brt
 94+W5UyUuw6LCWFC0KDBkQ5uOCGlQ6ir1pLLdr+S7pFddA5CPc/MZPV8HSNMvfEDiCXXRfzpQ
 NLFnxuUItHZ5QrxmNcLNHNbf/Qowucn8Z6vUw96/2RtceNpkkMC+l893CztwbzzLL0OlMPTzW
 yoYxAs0Z9Qzwc4FSKx27rV8LmT11A5DeOD32JySANAq+XC3sxpgPK5VDpXU1D6blpi1hjjcRQ
 jRVnPqcnh0zHmWYK/dSsUjiqJV6lL2RY+kfTD5BdWLss4K+o6pImA8yhum4P0fjL79q9Dlbw+
 YTEVLhWbPx8vVVRElP/VdlHQSBsKQLlmdmKwBnnv5ogWzfbYlFCQwHp1v1Cgr6qR0KsoxiLNv
 B3gaEm6EwgAnNkFSTUyPErVg6ZsXqH9UB+y6GGdTYvfc7nnMinaxBden9o4Jgs8nJXaKdTQ7B
 LBGpA4n1JW5/Vb14fKgz+YGkb4eisXL5zYwqyI1vKyZv8zoq+9PGgRhCL9DftOzkuTTYIeB2+
 dCAHOMwM4aKYOJfjy+1/edahsqBGjTPzVDF/893E53bzRDosTeYT0s=


--4m4uzdi6s7s3b7sn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24/05/21 10:22AM, Jens Axboe wrote:
> > On 5/21/24 10:02 AM, Andrew Udvare wrote:
> >> #regzbot introduced: v6.8..v6.9-rc1
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commi=
t/?id=3Daf5d68f8892f8ee8f137648b79ceb2abc153a19b
> >>
> >> Since the above commit present in 6.9+, Node running a Yarn installati=
on that executes a subprocess always shows the following:
> >>
> >> This also appears to affect node-gyp: https://github.com/nodejs/node/i=
ssues/53051
> >>
> >> See also: https://bugs.gentoo.org/931942
> >=20
> > This looks like a timing alteration due to task_work being done
> > differently, from a quick look and guess. For some reason SQPOLL is
> > being used. I tried running it here, but it doesn't reproduce for me.
> > Tried both current -git and 6.9 as released. I'll try on x86 as well to
> > see if I can hit it.
>=20

It seems like this also was a problem for libuv previously as somone
noted in a comment on the Arch Linux Bugtracker[0]:

- https://github.com/libuv/libuv/commit/1752791c9ea89dbf54e2a20a9d9f899119a=
2d179
- https://github.com/libuv/libuv/blob/v1.48.0/src/unix/linux.c#L834

Cheers,
Chris

[0]: https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/issu=
es/55#note_186921

#regzbot introduced: af5d68f8892f8ee8f137648b79ceb2abc153a19b
#regzbot link: https://bugs.gentoo.org/931942
#regzbot link: https://gitlab.archlinux.org/archlinux/packaging/packages/li=
nux/-/issues/55


--4m4uzdi6s7s3b7sn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmZM5VYACgkQwEfU8yi1
JYUlYg/9Hi9Lyw4PuBl7dcxotlhc8WKYVaQmHKETI6fAkzvYJIq74FcYsj3LVAEf
GcPNJah2x/DmF07LsXE39gvOmP9ahq++r2tycmc+iZjGQ8ZFbuPb4ty3DJO782nz
iAsP0aXdHWJ5/d3/pAhrJt5/fNixU424AeR9uVQLBlulWV+m7+q/ygr60IqXN4Bu
WaYrC6GYMMb5e+neR2KbLTW2XU4L7HdhMGpX/h2IHlz+AZaq+IxDrsvmVN5fjUQB
RChwbUX3wsjmBWmCsByPgQ7S+BcjzfbbaUFTwFAT+7b0Vx3JDJ+FmRAdojlccnN1
DRAygTMLctbAw1vmMJqyDyKZNuyfVzX3oN5bf2q4sOUIQoP6xYoKpx2V66eDnTRq
beT4KfjKDaatKQNRg5WuLmDUlaGYn6Xr4buLoyViUTi8pvY3vwWQuWQ3B1C18CGY
8Nf+aJb3geG5+83J/l6ORwRgpjs/mcQmCfOikLrwSDMJoJVT1vzUAXJyT6hVntze
YhDYOG38yAWNfn9isOYdRdtYKG81euY8joPJTF9XKM43M+rTKXVhE/3kXckbTbfo
vsPw4945hi36onPujRjFm+q+6WXCT+6uJ3dfq4wp1BWaUu0JspdLijUCD7xZDCXF
hiFy5Whkdy/9KA4zPPkOoVUBoNLyTkvfRvEfj20JP292iztRqOs=
=9Iae
-----END PGP SIGNATURE-----

--4m4uzdi6s7s3b7sn--

