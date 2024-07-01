Return-Path: <io-uring+bounces-2396-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 084CF91D835
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 08:46:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3830C1C22193
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 06:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29DFA44384;
	Mon,  1 Jul 2024 06:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="YfUWN96b"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D2F10A0E;
	Mon,  1 Jul 2024 06:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719816409; cv=none; b=UftfrrgHdttaIHOMdprZ07ur7tvN4fTJ8gwW+6/kcTgHmpCKN18GFf4oyfednE2ZrJ5Hjfml+XVXzrAin4WHV4MgTyxNGEAFEcZzcMlse3oSBBQyBDKwiaDo9kPhistJf+AMxP98NWl4HOYKleOVozh7BV15wbOW1LQGXpiQJoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719816409; c=relaxed/simple;
	bh=n5oSrhzkGLmSOnZqyv/PKViHhQvhuo5nrc+g8If0Rsg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EX4FXu+4pHCi1lln6VSfTW4+0I+NYX4SPatQPR/N6jbF+4b5/67HtOHbqsGQ153DFiI1c2eNT6ma3J2/yh1klGirZEJOX8rkHRZiSgzoUGCzPSHvmIM92O4z94L8Aq53xLYqqvX72X1o4iquZQzMKySxOEs/mk/0dD3ZleFlNPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=YfUWN96b; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1719816399;
	bh=n5oSrhzkGLmSOnZqyv/PKViHhQvhuo5nrc+g8If0Rsg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=YfUWN96bQi0fB/y4UM63sm3uMEX/uQty7+LWwQ6f6zcajCwDRcVWZslPwzL7TfqMt
	 O8Ia3QaXwQqmmC+kJWYkx2oYmehT29DB/qZ2YByYj7bSxYspwVROtL5Tti3bDx6loS
	 Qcryhc8bqoeoFHMAr8QPFLa+R7qJqFeRBTxSx2nw=
Received: from [IPv6:240e:358:1119:1300:dc73:854d:832e:2] (unknown [IPv6:240e:358:1119:1300:dc73:854d:832e:2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 1009266D10;
	Mon,  1 Jul 2024 02:46:33 -0400 (EDT)
Message-ID: <15391b83d96ddf9bfaf48c154e5d43e05d565623.camel@xry111.site>
Subject: Re: [PATCH 0/2] statx NULL path support
From: Xi Ruoyao <xry111@xry111.site>
To: Christoph Hellwig <hch@infradead.org>, Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, axboe@kernel.dk, torvalds@linux-foundation.org, 
	loongarch@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>
Date: Mon, 01 Jul 2024 14:46:27 +0800
In-Reply-To: <ZoIywaObDsx7SVw9@infradead.org>
References: <20240625110029.606032-1-mjguzik@gmail.com>
	 <ZoIywaObDsx7SVw9@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2024-06-30 at 21:38 -0700, Christoph Hellwig wrote:
> Maybe it's time and declarate the idea to deprecate stat a failure
> and we just add it back to the new generic ABI syscalls?

> The idea to get rid of layers of backwards compatibility was a good one
> and mostly succeeded, but having to deal with not only remapping
> the structure but also the empty path issues sounds like it is worth
> to just add these pretty trivial system calls back and make everyones
> life easier?

Maybe but we'll need to make time_t 64-bit.  I.e. adding stat_time64,
fstat_time64, and fstatat_time64.  Or maybe just redesign a new syscall
which is a improved statx with empty path issue and remapping issue
solved.  (With statx itself it seems impossible to solve the remapping
issue...)

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

