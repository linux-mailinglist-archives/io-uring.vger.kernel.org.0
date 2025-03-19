Return-Path: <io-uring+bounces-7137-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C5F0A69CEC
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 00:55:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72AB33BF04C
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 23:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC8E22423E;
	Wed, 19 Mar 2025 23:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXbPhUky"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA2A1DE3A9;
	Wed, 19 Mar 2025 23:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742428389; cv=none; b=Im6LWnmdHhFKXgQPBarDuprn3innVIvv4kepDgB7PZTWuGN+JAhJVbdZxFel8HdeIdYqLDFAm9r84X/jV5/VIA3GUqBjhzS3Y3xM2MEXe6aQ1lIQGXkTwf4JIcctl0TdHc+KuoGl+Mr7biux6R6g3sSnadZe6B3dkA4Q17k4rEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742428389; c=relaxed/simple;
	bh=hH0LpOTOHDJophFQjjaTOYTw6j+eOBph/0/AThm9o3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjYfYRVQP9czyH1+wS2BDf9qezspJi23mLUwsO93hYiAoKmWA1hMXLEQAEfaLfPDG/KZye4XYibES6+0+fFSXCD5xooMkTvf9RG96EQKj4vyFNf2xAB3i/jZhh9WRVOsjYfNxbDkEaboTaB4ipZSCgDF+DJwEkJt9jhRhY9HQlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXbPhUky; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E75C4CEE4;
	Wed, 19 Mar 2025 23:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742428389;
	bh=hH0LpOTOHDJophFQjjaTOYTw6j+eOBph/0/AThm9o3M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YXbPhUkyapcCUG+Yp/RWTLgPFYZWlzHVq2ADtB7NMwXkuj83rLl/3glD4QxcG5cDa
	 CxHnEnIxLd8OdjEbJLoW3TzQinnQG/X/wQbFQQo5g5Es3LcxlMAN5OFIKs2+hQkkeO
	 l+f6XnFsGpga/wRmbixTs+kwfVLK+/ZSIsiLhO54=
Date: Wed, 19 Mar 2025 16:51:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Anders Roxell <anders.roxell@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, io-uring@vger.kernel.org
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc1 review
Message-ID: <2025031910-poking-crusher-b38f@gregkh>
References: <20250319143019.983527953@linuxfoundation.org>
 <CA+G9fYvM_riojtryOUb3UrYbtw6yUZTTnbP+_X96nJLCcWYwBA@mail.gmail.com>
 <2deb9e86-7ca8-4baf-8576-83dad1ea065f@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2deb9e86-7ca8-4baf-8576-83dad1ea065f@kernel.dk>

On Wed, Mar 19, 2025 at 10:37:20AM -0600, Jens Axboe wrote:
> On 3/19/25 10:33 AM, Naresh Kamboju wrote:
> > On Wed, 19 Mar 2025 at 20:09, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >>
> >> This is the start of the stable review cycle for the 6.6.84 release.
> >> There are 166 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.84-rc1.gz
> >> or in the git tree and branch at:
> >>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> >> and the diffstat can be found below.
> >>
> >> thanks,
> >>
> >> greg k-h
> > 
> > Regressions on mips the rt305x_defconfig builds failed with gcc-12
> > the stable-rc v6.6.83-167-gd16a828e7b09
> > 
> > First seen on the v6.6.83-167-gd16a828e7b09
> >  Good: v6.6.83
> >  Bad: v6.6.83-167-gd16a828e7b09
> > 
> > * mips, build
> >   - gcc-12-rt305x_defconfig
> > 
> > Regression Analysis:
> >  - New regression? Yes
> >  - Reproducibility? Yes
> > 
> > Build regression: mips implicit declaration of function 'vunmap'
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Ah that's my fault, forgot to include the backport of:
> 
> commit 62346c6cb28b043f2a6e95337d9081ec0b37b5f5
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Sat Mar 16 07:21:43 2024 -0600
> 
>     mm: add nommu variant of vm_insert_pages()
> 
> for 6.1-stable and 6.6-stable. Greg, can you just cherry pick that one?
> It'll pick cleanly into both, should go before the io_uring mmap series
> obviously.
> 
> Sorry about that! I did have it in my local trees, but for some reason
> forgot to include it in the sent in series.

Wait, this is already in the 6.6.y and 6.1.y queues, so this can't be
the fix.  Was there a fixup for that commit somewhere else that I'm
missing?

thanks,

greg k-h

