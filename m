Return-Path: <io-uring+bounces-1550-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E352B8A520C
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 15:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 120D91C22963
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 13:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4277317F;
	Mon, 15 Apr 2024 13:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GmQUOqQM"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912B471B45;
	Mon, 15 Apr 2024 13:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713188659; cv=none; b=XUia/Y3T6eDK8GJl7LGjnJ8yI/GjuGC3WO06lRCSPBL5y6vlGrBSLDlGphN03/Eh+gRtzP6NHLOyWS1hStJr8iocqA6S71PkDYgISjJ7DjdUjXE33Hmq1B2sH4L1NDJp9WxSGhHDvdQ4dBEfPMNNuFYA0rTX0Iz8y+XJSOmmRWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713188659; c=relaxed/simple;
	bh=ZvNyBDTtGOhsFAqdOLjRzSyoKu4RMa5m4+b0d7iOP6k=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=hZ+9jeVsRSoU5z2R32goWWT3h0W8f171QjsQXjCxa8gqgAMFLtlBNfERiSghQVKO044mTOjjrTjerHVCrxlKDl3dAUf0GHLwRY1Ll1lzRZY5XH4Q/02v23M4dgnfze5IAalsEKH9Vbjw32oLuX2u1psTnsBIudN/vTJL+Q7vWbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=GmQUOqQM; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240415134414euoutp0297d8f98bc92bb6ff864c94e374c7eec6~GeAEOwxGg2821928219euoutp02k;
	Mon, 15 Apr 2024 13:44:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240415134414euoutp0297d8f98bc92bb6ff864c94e374c7eec6~GeAEOwxGg2821928219euoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1713188654;
	bh=ZvNyBDTtGOhsFAqdOLjRzSyoKu4RMa5m4+b0d7iOP6k=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=GmQUOqQM7o6bjsC22pyUHLVaOsoT93RV618NOsBpAbzPNHZ6j2861bf5MaKl/cKsw
	 j7+MhrH3FUEqrAX9Jxg9FnzWTwhAyYUeQr203UEEXIn+ANm0pxi+wuuWA4F9tA3feT
	 d87MPbknncddCQfILpgxP9r4OVHoVB74++gYlDRc=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240415134413eucas1p1083d673739f18b6d571ad70336b76efd~GeAEBZ3J30676906769eucas1p1k;
	Mon, 15 Apr 2024 13:44:13 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id F9.A2.09875.D2F2D166; Mon, 15
	Apr 2024 14:44:13 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240415134413eucas1p1077a3baa096cb382c62768ea968a477b~GeADh-LkK0753307533eucas1p1k;
	Mon, 15 Apr 2024 13:44:13 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240415134413eusmtrp1d53d9c801232f076ee155c4a5c3be4f1~GeADg3WW13030130301eusmtrp1y;
	Mon, 15 Apr 2024 13:44:13 +0000 (GMT)
X-AuditID: cbfec7f4-9acd8a8000002693-3b-661d2f2d85a3
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 6B.E6.09010.D2F2D166; Mon, 15
	Apr 2024 14:44:13 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240415134413eusmtip2a3107c689cd960919bc653278802044d~GeADOocSP0156501565eusmtip2O;
	Mon, 15 Apr 2024 13:44:13 +0000 (GMT)
Received: from localhost (106.210.248.128) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Mon, 15 Apr 2024 14:44:12 +0100
Date: Mon, 15 Apr 2024 15:44:06 +0200
From: Joel Granados <j.granados@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>, Muchun Song
	<muchun.song@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
	<naoya.horiguchi@nec.com>, John Johansen <john.johansen@canonical.com>, Paul
	Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, David Howells <dhowells@redhat.com>, Jarkko
	Sakkinen <jarkko@kernel.org>, Kees Cook <keescook@chromium.org>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Jens
	Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Atish
	Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, Will Deacon
	<will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Paul Walmsley
	<paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Luis Chamberlain <mcgrof@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <apparmor@lists.ubuntu.com>,
	<linux-security-module@vger.kernel.org>, <keyrings@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <io-uring@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/7] security: Remove the now superfluous sentinel
 element from ctl_table array
Message-ID: <20240415134406.5l6ygkl55yvioxgs@joelS2.panther.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="qw2zqgk5lfspo27e"
Content-Disposition: inline
In-Reply-To: <20240328-jag-sysctl_remset_misc-v1-2-47c1463b3af2@samsung.com>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA2VTfUxTVxzltve9lo7i42PjiphJHYtxfGnGdhdwURnsLWok+8N9hc1KH+AG
	RV+p0yUSqMUBopKig1XiYFsBaUXtoAOUyQA/EGjBTkQtDAskwKCglCl2Y7M8tpnsv3N+v3Ny
	fucmV8j3zREECnfLMxlWLk2TkCJoujpvDguLWJkcqS6PwmXnDCRWzzgIXO/SCnDO1XICl9WY
	AM4zx2P9wHESl1nUEDtULoiPTARhR64ZYs18EcC1577j4evOXBJ3HUnH9TYVifMf6SA2DvcR
	+NfBeR6+1NwBsbWpjMSDhr8IbJpVk3im0E5i3e1eHu4vGgW4svE+xL05LQCPWwv5+LB2Gb6n
	KYHY0mMWYLUtamMwbThtAHRf3gVIn3R1QVqbfZSkT2X3QnpyfBzSdWfu8Oi2PKeAbtQOCGhT
	Swjdd/EDWt0+RdDWbiVtrMknaeNDjYC+XuqCCcs/FMXImLTd+xg24s2dolSL/new5454f0e/
	BWSDXK8CIBQi6lV0szqgAIiEvlQ1QNP1vXyOOAHKO3ELcmQWoLH5PwUFwHPRodE4lhZVAD1o
	KCH/Vc2ZKwBH6gE6WWwn3CGQCkFnzdvdbpIKRZZJ22KGP1UmRAOmMcJNPCgdQDaTBrpVfhSD
	HuVbSDcWUxtReYOKx2Ef1PH1yKKGT+1H9hIr3x3Ap1agqgWhe+xJbUXfjk/xuVNXI5X9e4LD
	B9GNurs8dxaiSp9DR50/kdziLTT6uBlw2A9NXKtb6hmEOosLIWcoBujywoyAI3qAKnPmeJwq
	Gql/GVlybELHnxgI7l29Uf+UD3eoN9KYSvjcWIzyDvty6peRfnASFoHV2meqaZ+ppv2vGjcO
	ReUXH5L/G7+CKit+43N4A6qtnYblQFADAhilIj2FUayXM5+HK6TpCqU8JTwpI90Inv6MzoVr
	zgZQNfEgvBXwhKAVvPTUbD+v7wGBUJ4hZyT+YrXfymRfsUx64AuGzfiEVaYxilawQgglAeIQ
	2YuML5UizWQ+Y5g9DPvPlif0DMzmNZ33tA6cYWe6b29RZO90pcDO8dg2LVZl5mYxuWsSRM/r
	7x5q6nFmwMdJsujgxMLXE680DbyRmjHblli796yqx8PBBrTvMBoqC5JcaGgzEbc2S3RZfyXo
	tZuTxcoL31R4Y/36hj9+fOdU1yFHPur00W5KWBcSX+gXHhMqcgyZiegZ2p/4ctXmTyO96EtZ
	rOSj5ey+oUhzbOz2sZGUY/fCoC3r45ZbjTLJu28HKg0ewe8HHwt7Ic5ioIf11I4fpkfNTPWy
	Rl1MQ1zy8JO59vdczZIbstHK02umdD+vSnLuddzv1h1kG7dadwnjI7ZFeRnVX20JYakNUaWO
	A7ZtzIldEqhIla5by2cV0r8BoM6paJQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA2VSf1CTdRjv++7duxd05+vA/EZyhwvvOBqDjY2+JNjsCt6K1D84u+QKl7yA
	wTZuP7DMctBMfkxGQ1EGIaBAIvHrGAcad0oeyYX8WoIIjIOiHMlkQXFAYKzZ5V3/fZ7P8/l8
	nueee0gWr5zwI48qtYxaKU/nE974D+vf20NCQv2Tw8aqKVTWWE8gw7yTjayrFg7K6q5go7K6
	NoBy+mLQ1QkTgcr6DThyZq/iKH92B3Ke6sORebkQoIbGSxi6vXiKQL35CmQdzyZQ7lI1jlp+
	GmajSfsyhr7t7MGR7VoZgez1j9mobcFAoHnjNIGqRwYxdK9wBqCajikcDWbdAMhhM7LQF5Yt
	aMx8Hkf9A30cZBiXynbS9eX1gB7Oacbpc6u9OG3RnyHoUv0gTj90OHC69cooRn+Xs8ihOywT
	HLrtxi56+Pq7tOHWHJu23dHRLXW5BN3yu5lD376wih947pAwSq3SaZmAVJVGG81PECGxUBSJ
	hGJJpFAU/tJ7L4ul/NA9UUlM+tFMRh2657Awtdw+ys4Y4X7UebaR0IPPN+cBLxJSEmg2O/E8
	4E3yqGoA1/T5mKexAzYv3mV7sA/8aziP8IhcAA4XDT0prAAWuB5sOEgSp3bBb/r2uw0EJYD9
	D8dZbo0vVUbCpfZSjrt4xj1ivM2Mu1U+FAOXcvsJN+ZSMljRno15UqcAtBovsj2NrbCn5Od/
	DCwqE+Y+WGS7p7Go52HtOummvag4WOWYY3lWfQFmT19+svancGHtF1AIfCxPJVmeSrL8l+Sh
	g+G9dQf2P/pFWFP5G8uDo2FDwyO8AnDqgC+j0yhSFBqxUCNXaHTKFOERlaIFbDxnW/dyazu4
	MusSdgGMBF0gcMM53XR1APjhSpWS4ftyDT7+yTxukvzj44xalajWpTOaLiDdOOOXLL9tR1Qb
	n67UJooiwqQiSURkmDQyIpy/nftGRo6cR6XItUwaw2Qw6n99GOnlp8dOZNnuJvHK07aF9Ba/
	b7+Qds66MmOvmn02wTxkE1SN7T1QLPuQu3WmNfak3buWUpCjqfFa3cH19MslfX5TkqGV6BOC
	gP3O3XWzEc38iRJsMD7u8SfGPy8qEsOTZRzwipR+tVdgjN8nwMVBk1aK39S46TXXwB+q4k5D
	tKLGoT/dHaMq3nR2fG/lakD3tZ6b1awuoijux+vzb2ee9o0pCsw+v++dAt1ioGxtxvRm7ElV
	p8u0knJwp8F+SXJoeTJoRDOT4BUbbCot6NisaTq8+5H1GO++/C2Rtf5rE+rSeWFzVcdqb4EF
	kjL6b6kMuhnhvP/V9s9+NUVRH7Cp18Gd4xI+rkmVi4JZao38b8Kw6I4xBAAA
X-CMS-MailID: 20240415134413eucas1p1077a3baa096cb382c62768ea968a477b
X-Msg-Generator: CA
X-RootMTR: 20240328155911eucas1p23472e0c6505ca73df5c76fe019fdd483
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240328155911eucas1p23472e0c6505ca73df5c76fe019fdd483
References: <20240328-jag-sysctl_remset_misc-v1-0-47c1463b3af2@samsung.com>
	<CGME20240328155911eucas1p23472e0c6505ca73df5c76fe019fdd483@eucas1p2.samsung.com>
	<20240328-jag-sysctl_remset_misc-v1-2-47c1463b3af2@samsung.com>

--qw2zqgk5lfspo27e
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey

This is the only patch that I have not seen added to the next tree.
I'll put this in the sysctl-next
https://git.kernel.org/pub/scm/linux/kernel/git/sysctl/sysctl.git/log/?h=3D=
sysctl-next
for testing. Please let me know if It is lined up to be upstream through
another path.

Best

On Thu, Mar 28, 2024 at 04:57:49PM +0100, Joel Granados via B4 Relay wrote:
> From: Joel Granados <j.granados@samsung.com>
>=20
> This commit comes at the tail end of a greater effort to remove the
> empty elements at the end of the ctl_table arrays (sentinels) which will
> reduce the overall build time size of the kernel and run time memory
> bloat by ~64 bytes per sentinel (further information Link :
> https://lore.kernel.org/all/ZO5Yx5JFogGi%2FcBo@bombadil.infradead.org/)
>=20
=2E..

--=20

Joel Granados

--qw2zqgk5lfspo27e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmYdLyYACgkQupfNUreW
QU/Z+Qv+MoFmIQO7v4dtD+a9DTbUrllY4Dt8XcDo9bLc+AW59PtH7KPP2RNwklOg
uIwqgCxi+ERswmjFodCCEkyxjNShbXE14ig9pB63iMWGvgd6pyeta6IntBWQGtDS
jHDW72wnd67ATBG5Rs8N6lh2RZLx/oP4aGTV0GmcN55+LQrNxLbb+yoVh5CR6a8V
eD1AdG6QC4HggTof5/OwvU68hO6g+SPSzv/rm5ukU0RpzvH4iOMZ3jHLJX09Vbcy
pVwCg46kmK6Z7plLaG/jdYZdg8rss6kTGHQVi6q1lOeRj6h8gFjXjE54idNOOESs
Si/Q17wuejaRfBlvr8VNvz05nzCzlshasz2iSis2Rq2+xDSoZfQ7s/tGgtli0Yhd
TFvF3qGr3mufAsLNVHPQO2ygs9AZgodjG035XcgpDU5iodz9sxjFcVylksVlit16
9gNv1GMof9ZqEfXwM5c6FBSHi8gbwxiGugietf95SeKoHNIiglwDZlJssIrJ90SC
EdWFHI6W
=nkVv
-----END PGP SIGNATURE-----

--qw2zqgk5lfspo27e--

