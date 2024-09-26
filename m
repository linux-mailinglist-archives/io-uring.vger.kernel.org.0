Return-Path: <io-uring+bounces-3315-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D363987418
	for <lists+io-uring@lfdr.de>; Thu, 26 Sep 2024 15:02:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FA6F1C252AE
	for <lists+io-uring@lfdr.de>; Thu, 26 Sep 2024 13:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D03CB3B1A1;
	Thu, 26 Sep 2024 13:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="P5r//7RW"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC9B3B1A2;
	Thu, 26 Sep 2024 13:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727355745; cv=none; b=a+fHil1mGX23Hc0n3+X5mCNefB7LjiFiDdDSp4sr+KiKQE5qy8KHG+9m4qUUzyJEb+X7Am/Timnebw+QW1nkX5D7VTQ10h9w7HVNOe8Q3KcsQW+OfxsF+E8UXiohsWOwEyYqmFhThr+DqTY1o/+Rp9Bus7yOrMlXHSR9jGQ2vCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727355745; c=relaxed/simple;
	bh=/PkRpfB0PdoBt4FH2s7FLwEXQjPgWWiJFlbMEgJ5WaU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mMQBAnzDqpa4o8iUC8aNmlDNwHKYNWB46SrZQgDHiE/QQRKR2ufRsxnLnRfnqVZLfSLGZzuCBuf2r/sWheIVVYtxxFkqGJVmr+r4CLfyzwO2V/xGzPBpQ5/fmrQWwYi0MEE2RaK9Or2Cm4EwriuACkFG3qiM6mvbmvaA8Zsmhug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=P5r//7RW; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1727355739;
	bh=/PkRpfB0PdoBt4FH2s7FLwEXQjPgWWiJFlbMEgJ5WaU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=P5r//7RW1i54eoDPKokh9h7fLtp56utlLdSYwLbCLCJJ3i0rzn515ty+KdKzJVmrK
	 zd5tyHya/b/66LljnDMEfMOqNND3zbpjolbOcazN8VOPl0ZZP9PbMRQq35MDLPS5Hg
	 sbYzzN+XkJigBLIPmKqBRikmXLuLIO2ySRh40yCE=
Received: from [192.168.124.11] (unknown [113.200.174.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 9530C66522;
	Thu, 26 Sep 2024 09:02:16 -0400 (EDT)
Message-ID: <3b42c80c3be4f583b4e7fe5f04015b0e8d39d73f.camel@xry111.site>
Subject: Re: [PATCH v3] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
From: Xi Ruoyao <xry111@xry111.site>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, Miao Wang <shankerwangmiao@gmail.com>, 
	viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, axboe@kernel.dk, 
	torvalds@linux-foundation.org, loongarch@lists.linux.dev
Date: Thu, 26 Sep 2024 21:02:11 +0800
In-Reply-To: <CAGudoHFrTWktBYQjrQMJbVZvWLPD3A51YsOMOJqAtpdruSkGsQ@mail.gmail.com>
References: <20240625151807.620812-1-mjguzik@gmail.com>
	 <6afb4e1e2bad540dcb4790170c42f38a95d369bb.camel@xry111.site>
	 <CAGudoHFrTWktBYQjrQMJbVZvWLPD3A51YsOMOJqAtpdruSkGsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.0 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-09-25 at 17:56 +0200, Mateusz Guzik wrote:
> On Wed, Sep 25, 2024 at 4:30=E2=80=AFPM Xi Ruoyao <xry111@xry111.site> wr=
ote:
> > There's a special case, AT_FDCWD + NULL + AT_EMPTY_PATH, still resultin=
g
> > EFAULT, while AT_FDCWD + "" + AT_EMPTY_PATH is OK (returning the stat o=
f
> > current directory).
> >=20
> > I know allowing NULL with AT_FDCWD won't produce any performance gain,
> > but it seems the difference would make the document of the API more
> > nasty.
> >=20
> > So is it acceptable to make the kernel "hide" this difference, i.e.
> > accept AT_FDCWD + NULL + AT_EMPTY_PATH as-is AT_FDCWD + "" +
> > AT_EMPTY_PATH?
> >=20
>=20
> huh, that indeed makes sense to add. kind of weird this was not sorted
> out at the time, but i'm not going to pointer a finger at myself :) so
> ACK from me as far as the idea goes
>=20
> I presume you can do the honors? :)

Should I use a Fixes: tag in the commit then? (I.e. should it be
backported to 6.11?)


--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

