Return-Path: <io-uring+bounces-2334-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5185D9168C2
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 15:24:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E1051C217D7
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 13:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A24D315A86D;
	Tue, 25 Jun 2024 13:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="cOtuOETZ"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354A81509A2;
	Tue, 25 Jun 2024 13:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719321883; cv=none; b=jfy/4SzNEDCEqUi5NOe9IFaWnBsh+8Izt2quACb+O1L1fmd0nPqwno2Oq5HnTxE/jVLDZCSdKzGx2xO7e6J2EWDMY2UCJL2pcHh5Mam8+oVqwVfluqTOW/ZWTLpvXnCiZ/4UHSgqCaKSEQz+DEcVCOxme3LgzCym6ECQUmNARYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719321883; c=relaxed/simple;
	bh=lvJBkVKspbfH8LvAiHXE/YRiBjcdn5hLmqAnrMqJHPc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ad2iFG2BrwH7Kz8sa/pmtrB8L0Vq19D05uNFALMJ7NY9fOM3dOa0WLNmmO5d8tOmt+nxe48FKIc+m/6BTZqluiUXOKL+Gt+BFGz7M6NNyNJDC7eb9/lUbQuAf5Fsv8fnNZIOFOX+h592/4FxVS9qd0H59wK8SgTiYW5wwdVlm64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=cOtuOETZ; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1719321880;
	bh=lvJBkVKspbfH8LvAiHXE/YRiBjcdn5hLmqAnrMqJHPc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=cOtuOETZvbD25N8NNfc0QadAiAJPTLKGcnawNx1NRy76Qp4zpFz05UOlwvAIF+zi+
	 5QQn/5kJpUr7lpXayCFYhJSJj0fKQGi8qc4iXdm7F6Mk24Xorf+kaPkUZunW7vuSKg
	 ALiHGiwTw8z6PtNqZQsUznBjlJja1jeKl7yJsYHc=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id EDFB11A3F32;
	Tue, 25 Jun 2024 09:24:35 -0400 (EDT)
Message-ID: <fa1a8a0b01cd8c53d290cf431b9c1ffc6305ef0d.camel@xry111.site>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
From: Xi Ruoyao <xry111@xry111.site>
To: Mateusz Guzik <mjguzik@gmail.com>, brauner@kernel.org
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, axboe@kernel.dk, 
	torvalds@linux-foundation.org, loongarch@lists.linux.dev
Date: Tue, 25 Jun 2024 21:24:32 +0800
In-Reply-To: <20240625110029.606032-3-mjguzik@gmail.com>
References: <20240625110029.606032-1-mjguzik@gmail.com>
	 <20240625110029.606032-3-mjguzik@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-06-25 at 13:00 +0200, Mateusz Guzik wrote:
> +	if (flags =3D=3D AT_EMPTY_PATH && vfs_empty_path(dfd, filename))

Could it be

if ((flags & AT_EMPTY_PATH) && vfs_empty_path(dfd, filename))

instead?

When fstatat is implemented with statx AT_NO_AUTOMOUNT is needed, or at
least Glibc developers think it's needed:

#if FSTATAT_USE_STATX

static inline int=20
fstatat64_time64_statx (int fd, const char *file, struct __stat64_t64 *buf,
            int flag)
{
  /* 32-bit kABI with default 64-bit time_t, e.g. arc, riscv32.   Also
     64-bit time_t support is done through statx syscall.  */
  struct statx tmp;
  int r =3D INTERNAL_SYSCALL_CALL (statx, fd, file, AT_NO_AUTOMOUNT | flag,
                 STATX_BASIC_STATS, &tmp);

so "flags =3D=3D AT_EMPTY_PATH" won't be true if Glibc implements fstatat
and fstat via statx (on LoongArch and 32-bit platforms).

I was just surprised when I saw a 100%+ improve for statx("",
AT_EMPTY_PATH) but not stat on the Loongson machine.

> +		return do_statx_fd(dfd, flags, mask, buffer);
> +
> =C2=A0	name =3D getname_flags(filename, getname_statx_lookup_flags(flags)=
, NULL);

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

