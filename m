Return-Path: <io-uring+bounces-2429-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E865926724
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 19:30:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32615B20DD4
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 17:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3097184136;
	Wed,  3 Jul 2024 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="gPv9gp6I"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449BD17556B;
	Wed,  3 Jul 2024 17:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720027821; cv=none; b=mhx6s89+Y5zCQYMtLyrPyE92GO7TKKGo5rCrhwWxLfzw9K3gLOww4mvzKPsbS6WB2Nn9vm5efdYpIm+NVo8MUBgIt4mMmvlAAeC3IMvhxjamHGyFZvA8w74xyrV4sPvgpKvTWv7LELLSzA1l44JG043MPncD6Z1VmI2Bo1NXiNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720027821; c=relaxed/simple;
	bh=AegVO+tUySKhRPn+emoRbtM2je4QWC7tk7WKV2tGqaY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q25xzY0P08Kbp1iEns3dVNKUJHHE2Trk9tibC+8vbahStoRL/8x6QmNccI+GVX1i13V0UWLlEq1nxo2+oqqZ7kFmU5ohYiWPcSb8zqQdAlPJhWUTYVmlSFURKhjCCKNJt9OaiqlGI8hdFh5x04i0+Ic1uB96BTh9kzf61gB9qkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=gPv9gp6I; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1720027818;
	bh=AegVO+tUySKhRPn+emoRbtM2je4QWC7tk7WKV2tGqaY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=gPv9gp6IoHjLGVuhcyl/sAdDgBtygPOnWSitN3Bs6ZL4Dro7IZ7P8TmqvP3U7Ds49
	 gu8rxRaDFmMphgbFw2miMmX3G2RNFwxBr22DZsFsDcggjlh+0BiCAuRYuUrv5AQBln
	 g6yCiupGs3md42rwgYizpRydFc2qTUMKwHqBfDO0=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id E7CD01A40AA;
	Wed,  3 Jul 2024 13:30:15 -0400 (EDT)
Message-ID: <b60a61b8c9171a6106d50346ecd7fba1cfc4dcb0.camel@xry111.site>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
From: Xi Ruoyao <xry111@xry111.site>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>, libc-alpha@sourceware.org, 
 "Andreas K. Huettel"
	 <dilfridge@gentoo.org>, Arnd Bergmann <arnd@arndb.de>, Huacai Chen
	 <chenhuacai@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, Alexander Viro
	 <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	loongarch@lists.linux.dev
Date: Thu, 04 Jul 2024 01:30:14 +0800
In-Reply-To: <CAHk-=wif5KJEdvZZfTVX=WjOOK7OqoPwYng6n-uu=VeYUpZysQ@mail.gmail.com>
References: <20240625110029.606032-1-mjguzik@gmail.com>
	 <20240625110029.606032-3-mjguzik@gmail.com>
	 <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
	 <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
	 <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
	 <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
	 <1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com>
	 <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
	 <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com>
	 <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
	 <CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com>
	 <8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site>
	 <CAHk-=wif5KJEdvZZfTVX=WjOOK7OqoPwYng6n-uu=VeYUpZysQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-07-03 at 10:09 -0700, Linus Torvalds wrote:
> > And should we add stat_time64, fstat_time64, and fstatat_time64 to stop
> > using statx on 32-bit platforms too as it's disgusting?
>=20
> We already have 'stat64' for 32-bit platforms. We have had it for over
> 25 years - it predates not only the kernel git tree, it predates the
> BK tree too.
>=20
> I think stat64 was introduced in 2.3.34. That is literally last century.

struct stat64 {

// ...

    int     st_atime;   /* Time of last access.  */
    unsigned int    st_atime_nsec;
    int     st_mtime;   /* Time of last modification.  */
    unsigned int    st_mtime_nsec;
    int     st_ctime;   /* Time of last status change.  */
    unsigned int    st_ctime_nsec;
    unsigned int    __unused4;
    unsigned int    __unused5;
};

> Anybody who tries to make this about 2037 is being actively dishonest.

> Why are people even discussing this pointless thing?

So are we going to drop 32-bit support before 2037?  Then yes it'd be
pointless and I can live (even easier) without 32-bit things.

Otherwise, we still have 13 years before 2037 but this does not render
the thing pointless.  We still have to provide a 64-bit time stamp soon
or later.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

