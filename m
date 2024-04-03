Return-Path: <io-uring+bounces-1388-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49104897A73
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 23:13:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C4601C26680
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 21:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D000015666B;
	Wed,  3 Apr 2024 21:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKx6/qod"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60C85DF0E;
	Wed,  3 Apr 2024 21:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712178770; cv=none; b=PYikDNlEqSqSMHoxY5MU4aGL1JzLu8PpUdl8rWZxl96euJ5KlwAWev57PNcqGDoDG0yguYxkvUHQe7dzLy42Np0hxYFM1eG/MlLbt29GpywX16NsYgqzig20AM6TY4RLUzabN5nA1oXL7rkJjaoIJkddszwqdIcrV48aDxvFZdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712178770; c=relaxed/simple;
	bh=MhBeFVX+yqfsszn7feIWeCwLrrnL1A5qyItez7QnJ1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cnjxQNgqYScy6AmQffRly/sng+J2AtmJdOm1NnVcyk0NdRDm7vuVesiTycu/J83Czgs/eys9Oa264h/WeMvf8zzzoJ0n4YoTdXehoQLUxm00spZGMzKYsKwkmUl/aSwohKCMdCHIvdHTsJRhBguDxnlwPPN1p4hipONO7E9RxF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKx6/qod; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6ADC433C7;
	Wed,  3 Apr 2024 21:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712178770;
	bh=MhBeFVX+yqfsszn7feIWeCwLrrnL1A5qyItez7QnJ1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FKx6/qodk41xQfO+hzX4a16PJ+jm4Mxfrqh1k0qZaD8FxruP1dcomzmymE9I1Ieba
	 Gto5eTQNY41wGS/ofcYE63P+Da4Vy3cnQ8WFZdPLSfely5MrcOCLqErQOEvAa15woY
	 CZlIIQ8dMrcwPc13JX6uARH298S0mvBy8WFoNO6xtdPPjG4cqVT4FAlBnyB/6HgvML
	 3BCOQ97u5iUyXA8f0E6zfN1jiw7wfsSxbMeHzu/SH2xHAmGqI1vQcVxYnzUzavCvt7
	 +nzWQw31j3W4gdW7hbbwqeV2vaeY14Q9PhoYyHavmYeK8UGyDpce/Pw+NA9tPn9bjw
	 hVIot6CnIbpoQ==
Date: Wed, 3 Apr 2024 22:12:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: [PATCH v2] fs: claw back a few FMODE_* bits
Message-ID: <9bb5e9ad-d788-441e-96f3-489a031bb387@sirena.org.uk>
References: <20240328-gewendet-spargel-aa60a030ef74@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="K+f1fOeCclksxSlf"
Content-Disposition: inline
In-Reply-To: <20240328-gewendet-spargel-aa60a030ef74@brauner>
X-Cookie: Idleness is the holiday of fools.


--K+f1fOeCclksxSlf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2024 at 01:27:24PM +0100, Christian Brauner wrote:
> There's a bunch of flags that are purely based on what the file
> operations support while also never being conditionally set or unset.
> IOW, they're not subject to change for individual files. Imho, such
> flags don't need to live in f_mode they might as well live in the fops
> structs itself. And the fops struct already has that lonely
> mmap_supported_flags member. We might as well turn that into a generic
> fop_flags member and move a few flags from FMODE_* space into FOP_*
> space. That gets us four FMODE_* bits back and the ability for new
> static flags that are about file ops to not have to live in FMODE_*
> space but in their own FOP_* space. It's not the most beautiful thing
> ever but it gets the job done. Yes, there'll be an additional pointer
> chase but hopefully that won't matter for these flags.

For the past couple of days several LTP tests (open_by_handle_at0[12]
and name_to_handle_at01) have been failing on all the arm64 platforms
we're running these tests on.  I ran a bisect which came back to this
commit which is in -next as 80a07849c0b8d8a2e839c8.  I didn't verify a
revert against -next due to conflicts and it being pretty late but I'm a
little suspicous this report is misdrected, the commit doesn't look
obviously relevant but equally I'm totally unfamiliar with this bit of
the code. =20

We use a NFS root for our testing.  The last pass was next-20240328 and
while the bisect was run on yesterday's -next things still look bad
today.

Bisect log:

git bisect start
# bad: [c0b832517f627ead3388c6f0c74e8ac10ad5774b] Add linux-next specific f=
iles for 20240402
git bisect bad c0b832517f627ead3388c6f0c74e8ac10ad5774b
# good: [0fc83069bcaee78f60b8511d9453a9441963a072] Merge branch 'for-linux-=
next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
git bisect good 0fc83069bcaee78f60b8511d9453a9441963a072
# bad: [784b758e641c4b36be7ef8ab585bea834099b030] Merge branch 'for-linux-n=
ext' of https://gitlab.freedesktop.org/drm/misc/kernel.git
git bisect bad 784b758e641c4b36be7ef8ab585bea834099b030
# good: [8b8b4dca2ddd82d3ae7e2a6a2fc7d49e511ceae7] Merge branch 'dev' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/exfat.git
git bisect good 8b8b4dca2ddd82d3ae7e2a6a2fc7d49e511ceae7
# bad: [2c20b30ed316f5cb8773e5f99c02cd997f2374b7] Merge branch 'main' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
git bisect bad 2c20b30ed316f5cb8773e5f99c02cd997f2374b7
# bad: [bbe99111e156e6838845511debc03f4ef5041f1a] Merge branch 'linux-next'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
git bisect bad bbe99111e156e6838845511debc03f4ef5041f1a
# bad: [7e4f9465775837c3af79501698b0bb5ce28ffb11] Merge branch 'for-next' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/printk/linux.git
git bisect bad 7e4f9465775837c3af79501698b0bb5ce28ffb11
# good: [a2b4cab9da7746c42f87c13721d305baf0085a20] Merge branch 'for-6.10' =
into for-next
git bisect good a2b4cab9da7746c42f87c13721d305baf0085a20
# bad: [35c44ac8370af87614db9d0727da06a07d5436a2] Merge branch 'vfs.mount.a=
pi' into vfs.all
git bisect bad 35c44ac8370af87614db9d0727da06a07d5436a2
# good: [16634c0975ba6569991274e7a4ccbb15766e31d3] Merge patch series 'fs: =
aio: more folio conversion' of https://lore.kernel.org/r/20240321131640.948=
634-1-wangkefeng.wang@huawei.com
git bisect good 16634c0975ba6569991274e7a4ccbb15766e31d3
# bad: [276832a7ef840783bf867abe680db0eb6b3d4655] Merge branch 'vfs.misc' i=
nto vfs.all
git bisect bad 276832a7ef840783bf867abe680db0eb6b3d4655
# good: [1b43c4629756a2c4bbbe4170eea1cc869fd8cb91] fs: Annotate struct file=
_handle with __counted_by() and use struct_size()
git bisect good 1b43c4629756a2c4bbbe4170eea1cc869fd8cb91
# good: [22650a99821dda3d05f1c334ea90330b4982de56] fs,block: yield devices =
early
git bisect good 22650a99821dda3d05f1c334ea90330b4982de56
# bad: [80a07849c0b8d8a2e839c83cea939c2e1cd7800b] fs: claw back a few FMODE=
_* bits
git bisect bad 80a07849c0b8d8a2e839c83cea939c2e1cd7800b
# first bad commit: [80a07849c0b8d8a2e839c83cea939c2e1cd7800b] fs: claw bac=
k a few FMODE_* bits

--K+f1fOeCclksxSlf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYNxkwACgkQJNaLcl1U
h9Ditwf+ONflswHRYnr7p2R5aO2ZQsIYjhKd4BoBPFb3Q6ukC3feFlN7DEQCTQ3k
/CSMkjuCGGQzRKV+PD9+kzH192FbQD2ZkfIcc3LdDJnjX9M8NRCfQx0iJtB1sHAk
Pni7/cmrLk7wnuUN1rLMWE1B5kZ8miLJpMyrnr04xlp3Bvm5K8GEPTdkX2JkxXAX
Wmpxk+uEpmMJ8D2GndUXka4CWRbvLAxhXdfOba4WyR6/r86S1BjrmN9W3yHp46A6
c7CM1Mx+xMCRIX7XqDHi6f9srZ43pV6ZTD727nxhI4g/cBvs+ou1GlxCyCW7qZBf
UGXQiw6cdUFDPr46vnYJSZPSA6uWFQ==
=0ldx
-----END PGP SIGNATURE-----

--K+f1fOeCclksxSlf--

