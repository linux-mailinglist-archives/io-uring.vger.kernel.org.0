Return-Path: <io-uring+bounces-3306-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 473ED9861A3
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 16:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0811C288708
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 14:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ADFEDF53;
	Wed, 25 Sep 2024 14:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="h2eaIGtA"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A961B25757;
	Wed, 25 Sep 2024 14:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727274632; cv=none; b=n5s1jKTD7m3TCK8E9DRZrQg10QZY4hxGNkev2rDkyUt6xN21NtIAHgPzoDXsMkr10+irL9V2d3oDT6mz6tAP29oThEbTOIrWCs6VP8934CBt+cnph2OdNoyUbrb65H4pM70g3/p84puIV2oPIMyIru7GJ6XciKDww6I6cuQZ2xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727274632; c=relaxed/simple;
	bh=1gtNphDi5bzcfWG6u8nfxXUGf9DsB1ZBd5SkCfMHNps=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S/VWnOsP13CJU6T14fmJq8l6s3PklCT5VmfyDdHH/dLS4mYDxEkAHKMS++u8eG02tc20Ba9kkQ+Fy1xzhYvuDzEhzhAVJcJDbMqPt1wLhnJ16uST4CKEJ6/740KLg/l6ZigEAJEEqu93RM7Wzd3/WryfgL/P0N9beziPWx7pBe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=h2eaIGtA; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1727274623;
	bh=1gtNphDi5bzcfWG6u8nfxXUGf9DsB1ZBd5SkCfMHNps=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=h2eaIGtAqTLXmhPcihkAlmwuwbGYpNovsndV7595U9IjVAI3Q21qlKYi0V2kRtHgf
	 fSoS+lufy4UAWUgafABMNlpQ6GJDK7whd6bOcxQO5I7oveaW8DR7q6Vw684CkbEdb5
	 3RERFyBx8d9ztoJlu6gImUFCpPcMksjszrq0yeFA=
Received: from [192.168.124.11] (unknown [113.200.174.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 645BC668F5;
	Wed, 25 Sep 2024 10:30:21 -0400 (EDT)
Message-ID: <6afb4e1e2bad540dcb4790170c42f38a95d369bb.camel@xry111.site>
Subject: Re: [PATCH v3] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
From: Xi Ruoyao <xry111@xry111.site>
To: Mateusz Guzik <mjguzik@gmail.com>, brauner@kernel.org, Miao Wang
	 <shankerwangmiao@gmail.com>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, axboe@kernel.dk, 
	torvalds@linux-foundation.org, loongarch@lists.linux.dev
Date: Wed, 25 Sep 2024 22:30:18 +0800
In-Reply-To: <20240625151807.620812-1-mjguzik@gmail.com>
References: <20240625151807.620812-1-mjguzik@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.0 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-06-25 at 17:18 +0200, Mateusz Guzik wrote:
> The newly used helper also checks for empty ("") paths.
>=20
> NULL paths with any flag value other than AT_EMPTY_PATH go the usual
> route and end up with -EFAULT to retain compatibility (Rust is abusing
> calls of the sort to detect availability of statx).
>=20
> This avoids path lookup code, lockref management, memory allocation
> and
> in case of NULL path userspace memory access (which can be quite
> expensive with SMAP on x86_64).
>=20
> Benchmarked with statx(..., AT_EMPTY_PATH, ...) running on Sapphire
> Rapids, with the "" path for the first two cases and NULL for the last
> one.
>=20
> Results in ops/s:
> stock:=C2=A0=C2=A0=C2=A0=C2=A0 4231237
> pre-check: 5944063 (+40%)
> NULL path: 6601619 (+11%/+56%)
>=20
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>

Hi Mateusz and Christian,

There's a special case, AT_FDCWD + NULL + AT_EMPTY_PATH, still resulting
EFAULT, while AT_FDCWD + "" + AT_EMPTY_PATH is OK (returning the stat of
current directory).

I know allowing NULL with AT_FDCWD won't produce any performance gain,
but it seems the difference would make the document of the API more
nasty.

So is it acceptable to make the kernel "hide" this difference, i.e.
accept AT_FDCWD + NULL + AT_EMPTY_PATH as-is AT_FDCWD + "" +
AT_EMPTY_PATH?

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

