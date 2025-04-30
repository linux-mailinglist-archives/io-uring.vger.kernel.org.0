Return-Path: <io-uring+bounces-7796-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2254AA58BA
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 01:33:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F91250062C
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 23:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFEAF22A4E0;
	Wed, 30 Apr 2025 23:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIzTjYsF"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745BA22576A;
	Wed, 30 Apr 2025 23:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746055942; cv=none; b=uFizHAE0MaHPGZD0Td4CpPezbuC2lwspyHRr4V2kSKG7+4ZiLWnTZ1xMuVWxeMJ9EIVKBEEupAGPGPVXhFyBiUQf6p42tGPuUSUVq4RITJ6eJA2wAa/JA7ccNd0DGXRYOIZUZq35OLeK+YpR5KibgdOVImk+raagxy9hF8/gkOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746055942; c=relaxed/simple;
	bh=injRZ9eFv1pQlB4XTtV4bwLucOJq7jcy48IS30S1PN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KgMpdk3SQneVSwHVifizXZMuzOXShsxNgvEg+3k2Ag8Ne4ikyTdsC6jKtq7Rs5a34jWXDVsKAtoSk7vNdBAv5E532DACGsas6Ohprg3Phab5e2kUlRzBFcQwyO5TeSRwUFyA6zQ/CrN9KjzdhuhdX6jTCyx97TjoPkEVAOZFvlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIzTjYsF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAD0C4CEE7;
	Wed, 30 Apr 2025 23:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746055941;
	bh=injRZ9eFv1pQlB4XTtV4bwLucOJq7jcy48IS30S1PN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jIzTjYsFTFwiwRq3tj7yguqrHRe0TbnVzePwStGnaGhUKS6nUd7TqBQ10jr+2jhe2
	 neo9h6UBYhG2zD3AKVhHK9X7x9hqwgTQGFgUD7AkT00FkxYP3RE6c/sAO2jfFEDEUJ
	 rjiylF2zs2vkmsALcnTpUvKuWvymy471JQ5zS+yfQCYxS0sOogEza44RfhdjIq8W6M
	 5lpr0Y5JWS8gy9EV8AulHk8dddIciPhJ8yXKguc2jb5DefDhVLBZh7/sD/wuFAm5Pk
	 aQ2FOToLP19T6JIZjCofYoWGS59sGBPL/f4Sm9xD7C6+5OuqWuyqsS/185Krzi159A
	 tpVP1UwtIbWMA==
Date: Wed, 30 Apr 2025 16:32:14 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	clang-built-linux <llvm@lists.linux.dev>,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	linux-s390@vger.kernel.org, linux-mips@vger.kernel.org,
	io-uring@vger.kernel.org, virtualization@lists.linux.dev
Subject: Re: [PATCH 6.1 000/167] 6.1.136-rc1 review
Message-ID: <20250430233214.GC3715926@ax162>
References: <20250429161051.743239894@linuxfoundation.org>
 <CA+G9fYuNjKcxFKS_MKPRuga32XbndkLGcY-PVuoSwzv6VWbY=w@mail.gmail.com>
 <2025043049-banked-doorpost-5e06@gregkh>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025043049-banked-doorpost-5e06@gregkh>

On Wed, Apr 30, 2025 at 12:58:13PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 30, 2025 at 04:09:18PM +0530, Naresh Kamboju wrote:
> > Regressions on x86_64 with defconfig builds with clang-nightly toolchain
> > on the stable-rc 6.1.136-rc1.

clang-nightly is always a moving target so for the sake of the stable
-rc reports, I would only focus on issues that appear with just those
patches, as you should see this issue on 6.1.136.

> > * x86_64, build
> >   - clang-nightly-lkftconfig
> >   - clang-nightly-x86_64_defconfig
> > 
> > Regression Analysis:
> >  - New regression? Yes
> >  - Reproducibility? Yes
> > 
> > Build regression: x86_64 clang-nightly net ip.h error default
> > initialization of an object of type 'typeof (rt->dst.expires)'
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > ## Build error x86_64
> > include/net/ip.h:462:14: error: default initialization of an object of
> > type 'typeof (rt->dst.expires)' (aka 'const unsigned long') leaves the
> > object uninitialized and is incompatible with C++
> > [-Werror,-Wdefault-const-init-unsafe]
> >   462 |                 if (mtu && time_before(jiffies, rt->dst.expires))
> >       |                            ^
> 
> This isn't c++, so are you sure this isn't just a clang bug?

Yes, it is intentional that this warns for C code, the clang maintainer
felt that the default initialization behavior of const variables not
marked as static or thread local was worth warning about by default.

https://github.com/llvm/llvm-project/pull/137166

But it is going to be adjusted to allow the kernel to opt-out of the
warning for aggregate members, as that triggers often in the kernel:

https://github.com/llvm/llvm-project/pull/137961

The only instance of -Wdefault-const-init-var-unsafe that I have found
so far is in typecheck(), which should be easy enough to clean up.

Cheers,
Nathan

diff --git a/include/linux/typecheck.h b/include/linux/typecheck.h
index 46b15e2aaefb..5b473c9905ae 100644
--- a/include/linux/typecheck.h
+++ b/include/linux/typecheck.h
@@ -7,8 +7,8 @@
  * Always evaluates to 1 so you may use it easily in comparisons.
  */
 #define typecheck(type,x) \
-({	type __dummy; \
-	typeof(x) __dummy2; \
+({	type __dummy = {}; \
+	typeof(x) __dummy2 = {}; \
 	(void)(&__dummy == &__dummy2); \
 	1; \
 })

