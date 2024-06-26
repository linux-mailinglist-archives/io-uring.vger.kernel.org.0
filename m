Return-Path: <io-uring+bounces-2342-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ABB0D9176AF
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 05:15:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A42F1F22B52
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 03:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B7472B9C0;
	Wed, 26 Jun 2024 03:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="eW1UdU77"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E20134C6;
	Wed, 26 Jun 2024 03:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719371754; cv=none; b=S3IpvUiK/nVAfxtpPYiCOPn4N8/cyQlefMhbaMHGWv2S25aSLJWISMcsVb09ZnEblatnN/ceNPGjNSKSAjjlNy9/QJjHwgTrKRyvO1ZS3iWlvpLWxAwSxqjziA2gHAUY7UPGFtvnQk1Cm4IKKZm0UjviOZvY7/EhIKHkUXQ7t/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719371754; c=relaxed/simple;
	bh=FQS+D+ZzbS4ClYxxY1k60wyNI6dxzh9Y5+6vean5MV8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=awV9kbxc8/GZEXmXAyaBnoSDW3+3TjwF6EEwaX6ptVuTblbVmGrbzLzg8wv5BxukEDcHED8q9ZV9EXsE2JEQhLk3KRhkSMtc2a65OiN9/+YSYDraBj+/MmiW6oK9cs8YjtMoA5UiJ9zshht7UyYu1Zx0AUi+AyBekxYTQOMpGJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=eW1UdU77; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1719371751;
	bh=FQS+D+ZzbS4ClYxxY1k60wyNI6dxzh9Y5+6vean5MV8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=eW1UdU77ZJEgpSuregPJiyETC+M5hUNwizR/1qDy+Igpo3DB8mGKqvr0u/PERL52h
	 T+ZYo5dgMtkDpIXVyLix8QvFnB7IknCbvo24DDNCfGry6lSxiDSbR6fF5/MvhjesYO
	 cz97bkW8P+W7gH9Vz2l+SXYVhk1agTkT1oLPQmCM=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 5ED67674A5;
	Tue, 25 Jun 2024 23:15:49 -0400 (EDT)
Message-ID: <6ba5b3a01715326d2a0aee11db5cbc7cb7bce59d.camel@xry111.site>
Subject: Re: [PATCH v3] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
From: Xi Ruoyao <xry111@xry111.site>
To: Mateusz Guzik <mjguzik@gmail.com>, brauner@kernel.org
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, axboe@kernel.dk, 
	torvalds@linux-foundation.org, loongarch@lists.linux.dev
Date: Wed, 26 Jun 2024 11:15:47 +0800
In-Reply-To: <20240625151807.620812-1-mjguzik@gmail.com>
References: <20240625151807.620812-1-mjguzik@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
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
> This avoids path lookup code, lockref management, memory allocation and
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
> ---
>=20
> Diffed against fs-next and assumes c050122bdbb4 ("fs: new helper
> vfs_empty_path()") from vfs.empty.path is already applied.
>=20
> WARNING: io_uring remains untested (modulo compilation). I presume
> Jens has a handy way of making sure things still work.=20

For non-io_uring part:

On LoongArch the time usage of 10000000 calls:

baseline
Glibc fstat: ./a.out  0.44s user 3.56s system 99% cpu 4.013 total
bare statx:  ./a.out  0.39s user 3.54s system 99% cpu 3.927 total

patched
Glibc fstat: ./a.out  0.49s user 1.34s system 99% cpu 1.841 total
bare statx:  ./a.out  0.42s user 1.32s system 99% cpu 1.748 total
statx NULL:  ./a.out  0.44s user 1.29s system 99% cpu 1.734 total

Tested-by: Xi Ruoyao <xry111@xry111.site>

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

