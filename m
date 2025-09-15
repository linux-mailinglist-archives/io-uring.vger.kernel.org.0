Return-Path: <io-uring+bounces-9791-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA57EB579CD
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 14:04:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8498A201BF1
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 12:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D108A3019B8;
	Mon, 15 Sep 2025 12:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjK1TvwJ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8ED92FABEF;
	Mon, 15 Sep 2025 12:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757937830; cv=none; b=VuDu38qt/R6aFvmjqRcBaGTZbH0FV4V/WP408csjwu9Mk/LoCFN5ha/2Ipo/BDWj/dwpNHaLzo1NusNuWdZCKy/a8sQjSzp/RmnpMxxu9KryDgZtxGMe0x07Zp5pt+LDbizcoeaUbzudbgtp2HEvDatQptBEiy1Ho7tjHV2PSR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757937830; c=relaxed/simple;
	bh=k++F5CAnc5g3Ke5opUQkU/3F3JLhh0WCAWPms5P8Om0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jP/fieGuOyaVpO0NXpBhQ85OUXumuf29BjqODTU6UtYTMasU3sRfzEAUh6YJcZt6O9DSH1jpifWvXorJa5QQQmu9r6IyyPSWwmqxtovtl3vLIyFdgMDxn9P/Hdsy4bvSckj3El9r5ylplq/5k9XN6CxPylXCQonWyKeye2A4abk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjK1TvwJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEB5C4CEF5;
	Mon, 15 Sep 2025 12:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757937830;
	bh=k++F5CAnc5g3Ke5opUQkU/3F3JLhh0WCAWPms5P8Om0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BjK1TvwJ+wyY58MvtUMxZD0VBOgaGRxi1P3W1hlacdyaHFtOSn/KFnTDbEI2MVAz4
	 oI9MTguN+8VYq6LGtQP60F189sESCCZr4BF+7q0g/wvcklYiijaLT3JCnY3yj6uRCu
	 NIq7Yc0eOKc6IJ4qnegf96OuWpVvk/ObRoNR5GxqIpoOk454VFTP0Gcqr3bwFnIFAS
	 aALRSLVRAz8YvqmTtH58dXS50b5az+vfJU96UIHPvvFY/8CYoUUwsVxsRMkzYjNJNV
	 VA8JV5YmDZH2qRwxy82BEe4ev9Gq4Fr6YHoCCaiMykJk3dU778rEGeAb0WZkX+99KA
	 Lhs6oECiJw2hw==
Date: Mon, 15 Sep 2025 13:03:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	konstantin@linuxfoundation.org, axboe@kernel.dk,
	csander@purestorage.com, io-uring@vger.kernel.org,
	torvalds@linux-foundation.org, workflows@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] b4 dig: Add AI-powered email relationship discovery command
Message-ID: <8250c70a-0cab-4549-ad1f-aca28e7a1342@sirena.org.uk>
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <4764751.e9J7NaK4W3@workhorse>
 <aMLlMz_ujgditm4c@laps>
 <4278380.jE0xQCEvom@workhorse>
 <aMMpqojURAZa7cPU@laps>
 <6e25b2e7-67a2-4a92-95d5-adb279e811a7@sirena.org.uk>
 <aMf9FaDxGY4nYI2f@laps>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kiyxGJ+4hswg2nI0"
Content-Disposition: inline
In-Reply-To: <aMf9FaDxGY4nYI2f@laps>
X-Cookie: Use a pun, go to jail.


--kiyxGJ+4hswg2nI0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 15, 2025 at 07:48:37AM -0400, Sasha Levin wrote:
> On Mon, Sep 15, 2025 at 12:26:41PM +0100, Mark Brown wrote:

> > This seems like a great example of a situation where the suggestions
> > from one of the other thread of asking people to clearly mark when patch
> > submissions are using these tools would have helped - had the submission
> > described the above then the Python level review would've gone a lot
> > differently I think.  Realising during review is a totally different
> > experience to being told up front.

> Do you mean using the Assisted-by tags that were discussed in the other thread?

Not just that, which you did have, but also a mention of how the tools
have been used.

--kiyxGJ+4hswg2nI0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjIAKAACgkQJNaLcl1U
h9CGUwf+K1boklZhxyZRX+imuHacTwVekbiORc8Dxzu60q26HqKWVnc5UXRbvE2r
BYokhuc54XTEkz0N/DquoqGrMEz3U5m430SMNcsk/Z9zCCpeuYBR1J3y4Nr7I20I
qJZ7uW3Dl//9SfLPe5cxmILuTFG6902I5U9W4V6RGF1tF5OzrrioXzdAIiyDZHiL
k3M5UUMgGun2mTVaQXbTlVB8+NBn2EHuS/XYamCHh+XAxbh8mQhgsyneVa3aENyn
iT3+uzfplXy+icX1bbMunCAlHFhuHMxcJ5nmsyIDPOmVy3imsXV7YeZtCyxDOb2T
TpJzxmPoawUmnrrt2d2RMGJdjvUuGA==
=VKhj
-----END PGP SIGNATURE-----

--kiyxGJ+4hswg2nI0--

