Return-Path: <io-uring+bounces-7797-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 628A4AA5B5A
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 09:18:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 198C41BA44D1
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 07:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BA20267AEA;
	Thu,  1 May 2025 07:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPJcbEsX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C186C23183C;
	Thu,  1 May 2025 07:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746083917; cv=none; b=N4dCyTAi7FzYFTknkpy0Au8XgR2hKBWFURpGKPRS/teVXzy6IL+S6Dww7iS3wZDEfrLHNN3sNGriYXOnmdWHVGhhiHRtFVm6zD9C1AHdAe8V0jf5Jlhz+NxneKZ7LNP4Ub2cPZqYALobVy5sdCzMh415noqp+jHpocQaKafkPDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746083917; c=relaxed/simple;
	bh=su7Ol8QR1fuFy/VFNGr36BLKigm4/e1vZx94ZJZJg38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZhuhOu117thaXJQZkTJ/e61FAj0NVkae/MZcg6O++mknv3TD2g+Rb4E2CUbsuqZQxCOQRTM/m4LA/Te33m7MoG0VRdxc9/HDftU6VuxsRrwfX4yH9LRLRiXIF0YeOfYpE/djRnr0gC9n+xLhBrAF92DY+fVn20WzetdWpfZMi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPJcbEsX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF92C4CEE3;
	Thu,  1 May 2025 07:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746083916;
	bh=su7Ol8QR1fuFy/VFNGr36BLKigm4/e1vZx94ZJZJg38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rPJcbEsXhGMC0dq469bmaLlkkVmpTUn3Tb0S6zGu3+bqDNRihHhQAt0pboiT/Bfnn
	 oDLbw5I2ui5R8d5zxjLUmtpyyQ/Ql3Q2drqkJMJTROy9N0EmaHutplO2D6U4sEAGcu
	 61EjbwYysFa7sycvpKmbswX/b8m0KRwA739rNN6k=
Date: Thu, 1 May 2025 09:18:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matthew Rosato <mjrosato@linux.ibm.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	clang-built-linux <llvm@lists.linux.dev>,
	Nathan Chancellor <nathan@kernel.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	linux-s390@vger.kernel.org, linux-mips@vger.kernel.org,
	io-uring@vger.kernel.org, virtualization@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH 6.1 000/167] 6.1.136-rc1 review
Message-ID: <2025050118-glade-lunchroom-927f@gregkh>
References: <20250429161051.743239894@linuxfoundation.org>
 <CA+G9fYuNjKcxFKS_MKPRuga32XbndkLGcY-PVuoSwzv6VWbY=w@mail.gmail.com>
 <c8e88c29-e1bb-4845-a362-dc352d690508@linux.ibm.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8e88c29-e1bb-4845-a362-dc352d690508@linux.ibm.com>

On Wed, Apr 30, 2025 at 11:54:49AM -0400, Matthew Rosato wrote:
> 
> > 2)
> > Regressions on s390 with defconfig builds with gcc-13, gcc-8 and
> > clang-20 and clang-nightly toolchains on the stable-rc 6.1.136-rc1.
> > 
> > * s390, build
> >   - clang-20-defconfig
> >   - clang-nightly-defconfig
> >   - gcc-13-allmodconfig
> >   - gcc-13-defconfig
> >   - gcc-8-defconfig-fe40093d
> > 
> > Regression Analysis:
> >  - New regression? Yes
> >  - Reproducibility? Yes
> > 
> ...
> > drivers/s390/virtio/virtio_ccw.c:88:9: error: unknown type name 'dma64_t'
> >    88 |         dma64_t queue;
> >       |         ^~~~~~~
> > drivers/s390/virtio/virtio_ccw.c:95:9: error: unknown type name 'dma64_t'
> >    95 |         dma64_t desc;
> >       |         ^~~~~~~
> > drivers/s390/virtio/virtio_ccw.c:99:9: error: unknown type name 'dma64_t'
> >    99 |         dma64_t avail;
> >       |         ^~~~~~~
> > drivers/s390/virtio/virtio_ccw.c:100:9: error: unknown type name 'dma64_t'
> >   100 |         dma64_t used;
> >       |         ^~~~~~~
> > drivers/s390/virtio/virtio_ccw.c:109:9: error: unknown type name 'dma64_t'
> >   109 |         dma64_t summary_indicator;
> >       |         ^~~~~~~
> > drivers/s390/virtio/virtio_ccw.c:110:9: error: unknown type name 'dma64_t'
> >   110 |         dma64_t indicator;
> >       |         ^~~~~~~
> > drivers/s390/virtio/virtio_ccw.c: In function 'virtio_ccw_drop_indicator':
> > drivers/s390/virtio/virtio_ccw.c:370:25: error: implicit declaration
> > of function 'virt_to_dma64'; did you mean 'virt_to_page'?
> > [-Werror=implicit-function-declaration]
> >   370 |                         virt_to_dma64(get_summary_indicator(airq_info));
> >       |                         ^~~~~~~~~~~~~
> >       |                         virt_to_page
> > drivers/s390/virtio/virtio_ccw.c:374:28: error: implicit declaration
> > of function 'virt_to_dma32'; did you mean 'virt_to_page'?
> > [-Werror=implicit-function-declaration]
> >   374 |                 ccw->cda = virt_to_dma32(thinint_area);
> >       |                            ^~~~~~~~~~~~~
> >       |                            virt_to_page
> > drivers/s390/virtio/virtio_ccw.c: In function 'virtio_ccw_setup_vq':
> > drivers/s390/virtio/virtio_ccw.c:552:45: error: implicit declaration
> > of function 'u64_to_dma64' [-Werror=implicit-function-declaration]
> >   552 |                 info->info_block->l.queue = u64_to_dma64(queue);
> >       |                                             ^~~~~~~~~~~~
> > drivers/s390/virtio/virtio_ccw.c: In function 'virtio_ccw_find_vqs':
> > drivers/s390/virtio/virtio_ccw.c:654:9: error: unknown type name 'dma64_t'
> >   654 |         dma64_t *indicatorp = NULL;
> >       |         ^~~~~~~
> > cc1: some warnings being treated as errors
> 
> The virtio_ccw errors are caused by '[PATCH 6.1 033/167] s390/virtio_ccw: fix virtual vs physical address confusion'
> 
> Picking the following 2 dependencies would resolve the build error:
> 
> 1bcf7f48b7d4 s390/cio: use bitwise types to allow for type checking
> 8b19e145e82f s390/cio: introduce bitwise dma types and helper functions

I'm just going to drop all of these now and wait for a tested series to
be sent.

thanks,

greg k-h

