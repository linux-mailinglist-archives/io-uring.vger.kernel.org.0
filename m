Return-Path: <io-uring+bounces-2341-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6C8791768D
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 05:00:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D8C7283152
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 03:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F252612E6A;
	Wed, 26 Jun 2024 02:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="SYMIz9Dr"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C1B33DD;
	Wed, 26 Jun 2024 02:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719370796; cv=none; b=olZCxBeMX+ETP88EkByqIupyh9pwl446fWdg5I76IpWaxACsygxJVClo1+dgR1NKSLLRQySqZlmxP8cuerFHnLtT/8jWUNB4x/t3hepq9GfaVYH6YMzhR/9/OXPzbDj7ZirC/D1uV203hJDePMtXJJFckCSmSMFMbGCa55qg4M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719370796; c=relaxed/simple;
	bh=FybX7jlh5zC2JfmBcLWv6sG2UCu6xZEjoTUwjpFLwBg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=khXyaauheEon5Jt9s/9opev9PEwaWDQw2a892F1o69lrvKOtRnD4ryfwRN8qM+2ue96kMyC/UkOsyFaMx16qk6Gu0P258v3d+hfB9l6pK082vZAKkaAYHmNsGvbf5c3mWVghOIoUImEsLphtt0ySwn0BRlDTHWBDJ7uZUy6FTZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=SYMIz9Dr; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1719370793;
	bh=FybX7jlh5zC2JfmBcLWv6sG2UCu6xZEjoTUwjpFLwBg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=SYMIz9DrpuoPFtFaL+l/ALpvMKOpPj+gRWnvLg1vXoRK+Wjv53dsXgJdDUQnLLg6/
	 Zu/JFxNTVBZARB1HELrlDFRdP3/FaboffFLqh0OHIBVS8grAXnOhd1K9M6Pxuptpp7
	 u1OjORTq+b/k2nzeQXLq3f78pQCRo6JFEYn3DOYg=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384))
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 0584566F92;
	Tue, 25 Jun 2024 22:59:51 -0400 (EDT)
Message-ID: <0763d386dfd0d4b4a28744bac744b5e823144f0b.camel@xry111.site>
Subject: Re: [PATCH v3] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
From: Xi Ruoyao <xry111@xry111.site>
To: Mateusz Guzik <mjguzik@gmail.com>, brauner@kernel.org
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, axboe@kernel.dk, 
	torvalds@linux-foundation.org, loongarch@lists.linux.dev
Date: Wed, 26 Jun 2024 10:59:50 +0800
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
> +	if ((sx->flags & (AT_EMPTY_PATH | AT_STATX_SYNC_TYPE)) =3D=3D
> +	=C2=A0=C2=A0=C2=A0 (AT_EMPTY_PATH | AT_STATX_SYNC_TYPE) &&
> +	=C2=A0=C2=A0=C2=A0 vfs_empty_path(sx->dfd, path)) {
> =C2=A0		sx->filename =3D NULL;
> -		return ret;

AT_STATX_SYNC_TYPE =3D=3D AT_STATX_FORCE_SYNC | AT_STATX_DONT_SYNC but
AT_STATX_FORCE_SYNC and AT_STATX_DONT_SYNC obviously contradicts with
each other.  Thus valid uses of statx won't satisfy this condition.

And I guess the condition here should be same as the condition in
SYSCALL_DEFINE5(statx) or am I wrong?

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

