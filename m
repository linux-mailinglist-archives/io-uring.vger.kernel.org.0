Return-Path: <io-uring+bounces-1946-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FF4D8CB414
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 21:12:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAE021C226D5
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 19:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A7EE6EB41;
	Tue, 21 May 2024 19:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="mKIhI0H3"
X-Original-To: io-uring@vger.kernel.org
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73BB2AE6C;
	Tue, 21 May 2024 19:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716318751; cv=none; b=m4ra0oZqp9j1gDWQ0f6OsERKVp34tAc66mdY0MdfwYmwBc5Ur1eG6qrwnZVEuy8Iu8N+oYMWyXV4DGHW/ZUkfwElkt0dza6ncgvC63YiEmlwxCiyhj0oMe7HoZFphYtO/QbIuDv3XyQtNlcuiT+qq745MgWMuVOLVot9lV2r9Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716318751; c=relaxed/simple;
	bh=7+eylbIRtzvGKRBYimN9UCkceRxk/8t4cChv90bI7mI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oIX3J8BCZquY3LM15t2Jf+XlRa0sJYhLi87/JK1Ox/z0PvkshHQVkrY+guNPMIpezRodU0DiM7RidPCtj4mUZpyZxKDtPrEYoAsX+byQsIJ5SpUPc9RkUXBunKUy9GHeFwLjHW+HB1VMOaYQgxUD27cxox6Lv/k4wogulnQCA+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=mKIhI0H3; arc=none smtp.client-ip=212.227.17.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1716318740; x=1716923540; i=christian@heusel.eu;
	bh=7+eylbIRtzvGKRBYimN9UCkceRxk/8t4cChv90bI7mI=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=mKIhI0H39o6m/J8gAsD1F0vC7z9zZh5fKW+03laLONTIcWG8ItGQ1vM86C1eOPr4
	 FTLcSTqz4CAzbm5gSmRW7yczY1m8mMbbsMSs4LXnEO5+Qk9DMWlqGuTkMDbNobLQj
	 C4KTDdkbfMS3jC7h+gCCGk0Y4r7wEzm7E+pBcu7VkRKqHaDW42QtD8c5IlDuDWYuR
	 56wz+O25tms1MM0ojGT1UIt7f/pDjNHTUTEY46rBu8oLP4uYtrlxZ2fj5EurvgnIR
	 kyjQ+v1gL1eBI4CT8AvgJcUM+OH4A6v1Asznbx1M+ctgYfLjL8DAz2Dds8O51CDRZ
	 yjd4SOR+26KurpJySA==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([141.70.80.5]) by mrelayeu.kundenserver.de (mreue106
 [212.227.15.183]) with ESMTPSA (Nemesis) id 1M894P-1sEhsw3d2J-006LD6; Tue, 21
 May 2024 21:07:05 +0200
Date: Tue, 21 May 2024 21:07:05 +0200
From: Christian Heusel <christian@heusel.eu>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Udvare <audvare@gmail.com>, regressions@lists.linux.dev, 
	io-uring <io-uring@vger.kernel.org>
Subject: Re: [REGRESSION] ETXTBSY when running Yarn (Node) since af5d68f
Message-ID: <ocpimtl6f32k46tpcytix4kse4fhaivp7qvs4ohqmcx7ybtign@3yujd4llvah6>
References: <313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com>
 <8979ae0b-c443-4b45-8210-6394471dddd1@kernel.dk>
 <8de221f7-fe5a-4da9-899e-de2a856a4ddc@kernel.dk>
 <yywbp7fjnwgqxvc66zimea4hgdc2eysjx5nezky3vndr7xw25l@jv76rdseqm3e>
 <b8018270-6e9a-4888-87fd-69620d62c4e5@kernel.dk>
 <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="b6sfvqwzy55htqxl"
Content-Disposition: inline
In-Reply-To: <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>
X-Provags-ID: V03:K1:kgkegRoPeUGhjjEJa+tcyoRrRxXaq6BOFXwXjFP0Ha99JIt/M8v
 OfWDh1jbiv4fM86kgAPUw6IPBdZHvdpp4b/NhbMow/b3xPaZq0kpxG50BLau2KyARERquaS
 g9h/GlWMkzvoi0AMAbttuIBkmZpUyEhV3xsZo7tg/7lRzfm1RgGPtdXEttvy9VwDuqcqX3m
 XKVhhirOTF5FysQ7OlmsQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:92sUtXNc4Kc=;OjmIERMOmh/4i60NX/6IJsSC81g
 WBuo/K3Ar9xi4GcPoGBHE+InuCQ3Y9qUsNWduM23IXxdZJmoUKLBKdexbdaxy6j0WC+eB4pQs
 s7KBS5daIiZ2HUK1CE89iBaSTPf/NEi97sE/Pp2/IxsPuhnVC/nA9AZsvWmNNLvt6/6+ylooe
 CIqmDKsT5IUh/pnvLJvT9GYK28GE7/I3fEwEl03HM4h/0z6x7r488vGDXbryfSrP5KJ4SxWV8
 5aO61GchGXlZaUXckWd6wolJIzEBDUSahoqKFhFayo5ZMiO6YbeFrOmdxjIq5ATQIEW1DSrrV
 4WmSNQAy0N/z9UZb/FsGwjvybYhIa06Ot95CZMLZEU6tRuY8vXYUTUqAKuSodAZlP0JM4o7Z5
 CsEFf7JT4Lhp54P/GTHNQwbeSbHYmTmSW3q1wTOFIPwfBykQqwIVdlJ5oxI7rmw4PKX+gjX/6
 9y+P7TAg8ILokOfVZQJ/NLflljo91xVPKVjAFEEStLQFwRqvUgow/pXuWczfQmMf1vsAW6DAg
 losdSWBV5lgKEJoG3zhWnQ1rZc0JetgtKYaMeHjPJLHiFfpawNb9OfW7yUYMYulexjAOSY6i0
 ZfazmunFO5+BjNV0A8RzbeQTnCzlsBT/S1+saUce8drPN41706+7Xs7ZBWbTNyGMnGpsW3hWS
 IR2AEgqar6TknH3uNMBMQuUtz3q9IJjwWDl9hg+srxu4rpDIn6zgQJZn8AoG5RNGjUFplSofQ
 9RQw1x17qxZYjqAwYZhI0qkWUExqEwvH3joeaYeFgeSVT2pkeIWMc0=


--b6sfvqwzy55htqxl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24/05/21 12:29PM, Jens Axboe wrote:
> On 5/21/24 12:25 PM, Jens Axboe wrote:
> > Outside of that, only other thing I can think of is that the final
> > close would be punted to task_work by fput(), which means there's also
> > a dependency on the task having run its kernel task_work before it's
> > fully closed.
>=20
> Yep I think that's it, the below should fix it.

It indeed does! I applied the patch on top of Linus tree and the issue
is now gone!

Tested-by: Christian Heusel <christian@heusel.eu>

Cheers,
Chris

--b6sfvqwzy55htqxl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmZM8NkACgkQwEfU8yi1
JYWchQ/+O/tAak+4j1iNvLfN/JV7KYQkA6jOesBc9p6DREfsSM+Ptu0me3IvnxEy
OyeGys8XjcLzhpI5bZVXfxUK0W7lDqlHdPQQkeQjGe/ZMjuYNR3bv3zcdTuNZ572
odGeCJzh1zzxy6yvlY5PFrVF6OIsriIyD7b6t2JbuuxQCbjk8ImEW0SUCE3/QZaE
P9r+bBEUoNqKV8psWnYC9dZZja9y/V5Hh+x43ZKeaCKxVuytLypSYO0aT05uMJPU
iI7FbasgWnP0dTSqmT35AWW8+nUoair3Ni/83SuO1AOVZnkTrJNQ9KmNebWjfNW2
gP3nvyAf1pTLzfL/MuxNPnOoR9ziO+KhJmnzRSXHOdYteRUnKV5pWQ1VoGzdEYRw
dDwSmLtak5NbevaInmoYuGbZP0+prFk4ulnLLp2zNQha0QPjYH3WFmI3LG5FpzUF
DONMzg0V/gKom5a19xGG8gpCi4YDTQckRB1z9f+nVVLC2m5jMGx1v513ZeWUrAZy
JXFahhUBArxHSHL5+paCVPrhl64Uc298bdg+aLIZ+C2VQcF0CIezMSeGfpOUVgyv
0rF2tAGjjtjpumYDXYXC1kZWD73sRUiTPDfOuoCLi4mps2Ko+9B6Hkq2mnTLmaMm
FhrFQaWS8hAXigvqTepStN5M0bp3RgtfXBEaqvYS84c6WCUJmPg=
=f7N+
-----END PGP SIGNATURE-----

--b6sfvqwzy55htqxl--

