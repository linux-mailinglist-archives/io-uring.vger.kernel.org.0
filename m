Return-Path: <io-uring+bounces-4946-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DF039D551D
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 23:02:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33AA52835B1
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 22:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0FFE1CB512;
	Thu, 21 Nov 2024 22:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b="m6dPLELz"
X-Original-To: io-uring@vger.kernel.org
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4D31A4F20;
	Thu, 21 Nov 2024 22:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.133.4.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732226550; cv=none; b=PoGOZJ/z6O9vMRb8uuWCg+29xN4o6OJD2CmZiWMz6E0yAvrN6x55ocRZjsW7oSbIyTQEB/jThEu13483Zvz3RCIK64zXEofEssCrwDKLn9wPHlNLpA11RVtzzFtclvNH1xN8GCG9qHkQwz2xrx9UJUlrViAqbsB7c0ETiWbe+wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732226550; c=relaxed/simple;
	bh=oaON3TQHvbhvp5NiT5tAyPyIpSYNjJS8Ed01fZqfTkQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AltEtD3cSSBJeTL0X8b9IFcpFWkqoxuTvVDJpasJ6waMZ6UibuelPmmWDImUhagUj7RFQ+1KaeUzykb4BQHLwxd+/Y9Z9PR37vpnhgnOQTYbwPMVpzcYVEZV1I9BOWZUOyEIQG7XsX7z0yCoBbrCoYSDbs3dmZI7AF33kw2G3FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de; spf=pass smtp.mailfrom=zedat.fu-berlin.de; dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b=m6dPLELz; arc=none smtp.client-ip=130.133.4.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zedat.fu-berlin.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=rfNI/i+YSTQUMN5oUVqKU2Gc86BnFPrR7NkR/sTSzuE=; t=1732226547; x=1732831347; 
	b=m6dPLELz6cw5UqDORk/71vXVkzNUP2GKuf6imsM9Lp45ztbW6g6oQfocJYGtEE3f7U57bAQD1F0
	E0SeiMzUG7e8PDk40b5xnUT+G7BtPyPnwDkYVh+Z8qDgC6P7E9ohIVNuukVWLAbrlH9TTuQUXp/y7
	93RfY/XorciAHMERIoJiG8SZu9x9DAxOL3uevqyldpL+GQoQ77JJ5zgdobwmOapcVuF+o2ic+PXeZ
	698u3KndRbSialBrWDlH72zMw8gBYtZGduaoP5Ls5R7RdTgv/Fma2Tx+Ja9EdwnFU/u1z2gox1bQ+
	J5UME4amF0UIcRY8JeVyddLvmBn4euT8repg==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.98)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1tEFFc-00000000dHE-23Pt; Thu, 21 Nov 2024 23:02:12 +0100
Received: from p57bd904e.dip0.t-ipconnect.de ([87.189.144.78] helo=[192.168.178.61])
          by inpost2.zedat.fu-berlin.de (Exim 4.98)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1tEFFc-00000000hrq-0sIZ; Thu, 21 Nov 2024 23:02:12 +0100
Message-ID: <d0d818bb9635d43bde2331864733504f6f7a3635.camel@physik.fu-berlin.de>
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Lameter
 <cl@linux.com>,  Pekka Enberg <penberg@kernel.org>, David Rientjes
 <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,  Andrew Morton
 <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Roman
 Gushchin	 <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Jens Axboe	 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Mike@rox.of.borg, 	Rapoport@rox.of.borg, Christian Brauner
 <brauner@kernel.org>, Guenter Roeck	 <linux@roeck-us.net>, Kees Cook
 <keescook@chromium.org>, Jann Horn	 <jannh@google.com>
Cc: linux-mm@kvack.org, io-uring@vger.kernel.org,
 linux-m68k@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Thu, 21 Nov 2024 23:02:11 +0100
In-Reply-To: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
References: 
	<80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-ZEDAT-Hint: PO

On Wed, 2024-11-20 at 13:46 +0100, Geert Uytterhoeven wrote:
> On m68k, where the minimum alignment of unsigned long is 2 bytes:

Well, well, well, my old friend strikes again ;-).

These will always come up until we fix the alignment issue on m68k.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

