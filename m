Return-Path: <io-uring+bounces-7787-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73553AA4AAE
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 14:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FD2316E7DB
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 12:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B660A25E475;
	Wed, 30 Apr 2025 12:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HMdrnvn"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A29F25A356;
	Wed, 30 Apr 2025 12:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746014802; cv=none; b=DeP+eRCEY8ykNsXBzAAKHiDGBXFD9B4R93R7pjw3PIHSXb1Ww04sb2kB6U1BhlUWBYj8EYBfbdONfUmbP0q+TnYT4RUe9snsvr8E4GVTeqk4w9Fm1VxjJZ4s9I5kfdaS8K9vhc88gJQHpqecEHlV8slt6TBZRlwo3mI7EDJelHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746014802; c=relaxed/simple;
	bh=KxtFBMueiirNWiwnyrAtoulWVdHm+lR5mj1ckpWIfuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=osfIklCQxfJg+SMvHWwYvNKqElpF8IIwZEtx0Je3FsAm8IaM884JxhqPTKN2iVDv55MPmD3jhVOijuVUMCcMyNggmTlxU0Tuxtc2xFonBM/QMuBd+DdI29KMzI7De5d68NxVFXK1X52khED/+RVXA/WSLtpc+8/29LJquW1DEXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0HMdrnvn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17254C4CEE9;
	Wed, 30 Apr 2025 12:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746014802;
	bh=KxtFBMueiirNWiwnyrAtoulWVdHm+lR5mj1ckpWIfuU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0HMdrnvnoik3wEGng8o6argm2Gw8rEtSYc55G3B28GQuBEFRqSFdNaxsHBXyLh841
	 T7/Ps0yfVdJBG8N7LxX50V2mgE56JDHe3hoMp9z/Q1oNed7fPNABCIynsVHDDKk1Tl
	 28VprGO4rlzsTCYcVEOg3Rex4+mEC7PcGf6RNmKo=
Date: Wed, 30 Apr 2025 12:58:13 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	clang-built-linux <llvm@lists.linux.dev>,
	Nathan Chancellor <nathan@kernel.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	linux-s390@vger.kernel.org, linux-mips@vger.kernel.org,
	io-uring@vger.kernel.org, virtualization@lists.linux.dev
Subject: Re: [PATCH 6.1 000/167] 6.1.136-rc1 review
Message-ID: <2025043049-banked-doorpost-5e06@gregkh>
References: <20250429161051.743239894@linuxfoundation.org>
 <CA+G9fYuNjKcxFKS_MKPRuga32XbndkLGcY-PVuoSwzv6VWbY=w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuNjKcxFKS_MKPRuga32XbndkLGcY-PVuoSwzv6VWbY=w@mail.gmail.com>

On Wed, Apr 30, 2025 at 04:09:18PM +0530, Naresh Kamboju wrote:
> On Tue, 29 Apr 2025 at 23:31, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.136 release.
> > There are 167 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.136-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> There are three build regressions and two build warnings.
> 
> 1)
> Regressions on x86_64 with defconfig builds with clang-nightly toolchain
> on the stable-rc 6.1.136-rc1.
> 
> * x86_64, build
>   - clang-nightly-lkftconfig
>   - clang-nightly-x86_64_defconfig
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
> 
> Build regression: x86_64 clang-nightly net ip.h error default
> initialization of an object of type 'typeof (rt->dst.expires)'
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build error x86_64
> include/net/ip.h:462:14: error: default initialization of an object of
> type 'typeof (rt->dst.expires)' (aka 'const unsigned long') leaves the
> object uninitialized and is incompatible with C++
> [-Werror,-Wdefault-const-init-unsafe]
>   462 |                 if (mtu && time_before(jiffies, rt->dst.expires))
>       |                            ^

This isn't c++, so are you sure this isn't just a clang bug?

thanks,

greg k-h

