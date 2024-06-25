Return-Path: <io-uring+bounces-2339-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 07AE6916B7A
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 17:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B16171F233AB
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 15:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38A315CD62;
	Tue, 25 Jun 2024 15:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="Q2M8zyXZ"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17961BC57;
	Tue, 25 Jun 2024 15:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719327631; cv=none; b=r1tWNRjod1x2tCLOif91GGVTYF5v+2tJZzGtzHk86UWAOygDZbM1O9ZjX3CUR+GmGkWV5xaSWTpcDPC5jCsFg6j3qz9dOGR7oTh/UwPpDggELVPkbU50nNLAPJHKu5P21zhlmu1DM1Z6oOLEBDKcAizu0XKNv40VpQlVsZyF/Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719327631; c=relaxed/simple;
	bh=XWDQMCEnDjXZKc6n8OfFSE1SonScXjdA1fH3SFBXSpQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RmRRYLXDgBBvcX3wvF6OVfZvlhD8Hm8DlSluX5nEb4xyYGMrXAURJWYc2x0xtMF0yvO0uYBh9IGNbpzwQ/Kyl/07X2HlTuXBqEukdh2EqGCSjJLiQNfUckKqi2qkU+Aw5xxUj6LcyaVvPwH4QPRNtnuNDttk2wk/LQZMmMa3e8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=Q2M8zyXZ; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1719327621;
	bh=XWDQMCEnDjXZKc6n8OfFSE1SonScXjdA1fH3SFBXSpQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=Q2M8zyXZaOR7M633GVVzlHYspg2HcutIH2WtwMysA4BiZ9rm9WUKNpV+M0KrbCmHo
	 17ft5wRX+xpwGPdid+6sMNNpLmT3jzihcIwQTLG4+MTXC+CaWhJZHn8lNo+uZyBpiw
	 +JkGDnQ5V13+QELwV6TEs5K9w9uI4Y3HT7kBUeNI=
Received: from [IPv6:240e:358:1198:3d00:dc73:854d:832e:7] (unknown [IPv6:240e:358:1198:3d00:dc73:854d:832e:7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 6B3CF6720A;
	Tue, 25 Jun 2024 11:00:06 -0400 (EDT)
Message-ID: <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
From: Xi Ruoyao <xry111@xry111.site>
To: Huacai Chen <chenhuacai@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, axboe@kernel.dk, torvalds@linux-foundation.org, 
	loongarch@lists.linux.dev
Date: Tue, 25 Jun 2024 22:58:35 +0800
In-Reply-To: <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
References: <20240625110029.606032-1-mjguzik@gmail.com>
	 <20240625110029.606032-3-mjguzik@gmail.com>
	 <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-06-25 at 22:09 +0800, Huacai Chen wrote:
> On Tue, Jun 25, 2024 at 7:01=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com>
> wrote:
> >=20
> > The newly used helper also checks for 0-sized buffers.
> >=20
> > This avoids path lookup code, lockref management, memory allocation
> > and
> > in case of NULL path userspace memory access (which can be quite
> > expensive with SMAP on x86_64).
> >=20
> > statx with AT_EMPTY_PATH paired with "" or NULL argument as
> > appropriate
> > issued on Sapphire Rapids (ops/s):
> > stock:=C2=A0=C2=A0=C2=A0=C2=A0 4231237
> > 0-check:=C2=A0=C2=A0 5944063 (+40%)
> > NULL path: 6601619 (+11%/+56%)
> >=20
> > Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> Hi, Ruoyao,
>=20
> I'm a bit confused. Ii this patch a replacement of your recent patch?

Yes, both Linus and Christian hates introducing a new AT_ flag for this.

This patch just makes statx(fd, NULL, AT_EMPTY_PATH, ...) behave like
statx(fd, "", AT_EMPTY_PATH, ...) instead.  NULL avoids the performance
issue and it's also audit-able by seccomp BPF.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

