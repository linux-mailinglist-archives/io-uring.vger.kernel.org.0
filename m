Return-Path: <io-uring+bounces-9787-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 29E25B561CB
	for <lists+io-uring@lfdr.de>; Sat, 13 Sep 2025 17:24:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D22897A80CA
	for <lists+io-uring@lfdr.de>; Sat, 13 Sep 2025 15:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBF8919258E;
	Sat, 13 Sep 2025 15:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="kDKm9Rn0"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334CE2DC776;
	Sat, 13 Sep 2025 15:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757777078; cv=none; b=HXUckx5xkBjM69hjs1TqykSyzsrViwlXE5Bfotzm6XWokqfgrCaYl6hbWfs21TVXEwscfw6tLIOh5BvS2NwnQ0+ancqskrTLYPN/x5asBFxoCLZhmZKFR8mC+syu/95FuwJZzGTWOaVfnwc1O1n55U2NgTyxIVLKlpfiLrLIE/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757777078; c=relaxed/simple;
	bh=1Y5sE84WKiYBBtWVFqxs3GYbYV6WKM/EJWKTEDg3LK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dCa5EzpuOUgiTzCbmAb4eBKr1Xv4Hq+fEOEMakHwphj2qLJPs4xJjPZgL0qpZwtf6bGLWbTDa7Zdqr6nSf0buvW/ogO+CoggEYOWtJcccnbvDyLFFD+gy0iB20GclZRe2dEufIw6Pzcl8m4lq3RjP3twHYWH1fhePpUO1Inptvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=kDKm9Rn0; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1757777075;
	bh=1Y5sE84WKiYBBtWVFqxs3GYbYV6WKM/EJWKTEDg3LK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:In-Reply-To:
	 X-Gw-Outgoing-Server-Hash:X-Gw-Message-ID:X-Gw-PM-Hash:Message-ID:
	 Date:From:Reply-To:Subject:To:Cc:In-Reply-To:References:
	 Resent-Date:Resent-From:Resent-To:Resent-Cc:User-Agent:
	 Content-Type:Content-Transfer-Encoding;
	b=kDKm9Rn0ZT6aUrEM4rhXe7APbzLU2uwQK+dFgRs3w7idU0Tjb/gH71HL4UQ1p2KOv
	 kPDzg28ycfpZTS0atzhzHGyHYuOJwnAQWkfrtAroG9vEqzDv67XDDRkQdPYbVBrptH
	 28WDPpJ20GA93eVCjFyKzfimC2rU9hFXzPQzxJX0MaEI1tVXeDcYHBVqcgHmvg8yDE
	 8NgKpCMMOUWW5I2ehkuV0dykWpzXMpQInUAUB6/D5jEy7TQ52XvJR4L5qSlzvePXh7
	 IIBhblUGirkx9Oy0DFNcKP63KlGfn6NenKXDynEBo597ns6iU8liur92syfr+sAW2M
	 FdrI5p1JhFZnw==
Received: from linux.gnuweeb.org (unknown [182.253.126.215])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 5C6E631279A4;
	Sat, 13 Sep 2025 15:24:31 +0000 (UTC)
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sat, 13 Sep 2025 22:24:22 +0700
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	dr.xiaosa@gmail.com,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: Re: [PATCH liburing v1] barrier: Convert C++ barrier functions into
 macros
Message-ID: <20250913152422.GA31788-ammarfaizi2@gnuweeb.org>
References: <20250913131547.466233-1-ammarfaizi2@gnuweeb.org>
 <e0559c10-104d-4da8-9f7f-d2ffd73d8df3@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e0559c10-104d-4da8-9f7f-d2ffd73d8df3@acm.org>
X-Gw-Outgoing-Server-Hash: 01afd303c8b96d0c1d5e80aa96a4ee40ec69888f786fa24107c0862c0644af79
X-Gw-Message-ID: 69bdbc9f940afd776081821f9fa810c6830cd39bcf9f613d97449c2948bd9b81
X-Gw-PM-Hash: 15fa1b86cfde8d1fea056597e811231aa9750ec8bc49fba31f2b60ebbd104993

On Sat, Sep 13, 2025 at 07:40:17AM -0700, Bart Van Assche wrote: 
> Converting functions into macros is a step backwards. Please check
> whether removing the "static" keyword from the inline function definitions
> in header files is sufficient to suppress the compiler
> warning about TU-local definitions.

OK, that works. I will send a follow up patch to do that instead.

After further testing, I found a new issue, still related to the "static
inline" problems apart from the barrier:
```
  In file included from work.cpp:3:
  /usr/include/liburing.h:1808:19: error: ‘int io_uring_wait_cqe(io_uring*, io_uring_cqe**)’ exposes TU-local entity ‘int __io_uring_peek_cqe(io_uring*, io_uring_cqe**, unsigned int*)’
   1808 | IOURINGINLINE int io_uring_wait_cqe(struct io_uring *ring,
        |                   ^~~~~~~~~~~~~~~~~
  /usr/include/liburing.h:1745:19: note: ‘int __io_uring_peek_cqe(io_uring*, io_uring_cqe**, unsigned int*)’ declared with internal linkage
   1745 | static inline int __io_uring_peek_cqe(struct io_uring *ring,
        |                   ^~~~~~~~~~~~~~~~~~~
```
It happens due to commit:

  f2b6fb85b79b ("liburing: Don't use `IOURINGINLINE` on private helpers")

I will try to introduce a new macro to make it C++ friendly. Apparently,
replacing "static inline" with "inline" needs to be done everywhere. Not
only in barrier.h.

-- 
Ammar Faizi


