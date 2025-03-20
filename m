Return-Path: <io-uring+bounces-7149-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1240A6A70E
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 14:24:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD95C17187A
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 13:24:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7518620AF6D;
	Thu, 20 Mar 2025 13:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imA9543D"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DB82AE99;
	Thu, 20 Mar 2025 13:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742477040; cv=none; b=IHuJRUZ1200kLx2/Bvv9oXdx/bo7Fgt5KAh5jsksTVczfeFI/IM1PjoyvxW1dr97nQiXilXTrXU7cQILDdT0b1niG86bsFpAx1KH11nIymJ22My+A2Z45stU/YNsBkU51mrmhTjoQFmnj6HOIP2Q0xc6vFC2olBMYIJeruK27LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742477040; c=relaxed/simple;
	bh=yXpAdwA2wl9V0/3d11cnGwhrhvLntuVhj2WqTNZoesc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VnsKBZQaVDca+pxcWKEXrcs3uEJpWF0BhEheIH1U7gGurFdM/aY6MlLa2x8Icy4PZen6TwCGw5YJ2kdbC5QyJ6ne/YgxDhxnlUn+J4HLRRhxsFf+JNtC0ygOs3KBd3ilgpD68gysMWPjgLWC3ddAb22fuD6wkT79PdkpxV4vR4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imA9543D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827C9C4CEDD;
	Thu, 20 Mar 2025 13:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742477039;
	bh=yXpAdwA2wl9V0/3d11cnGwhrhvLntuVhj2WqTNZoesc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=imA9543DJ5p7W1TnaDybPi40iJGhQojll3ucOtdIcsIz9/4H1vVOLmiiwksPt0oS+
	 kiD5jANyRvdNomXm/w6YxLRNKXigdJ8hqxC7dLQWUZ4io3ckAcAl4jv8hLAKbVFTDQ
	 6iyFUitOX8WzTxnpMhpqKTRQxdPXq3D0zl48FvMs=
Date: Thu, 20 Mar 2025 06:22:40 -0700
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
Message-ID: <2025032031-negative-wreckage-dedf@gregkh>
References: <20250319143019.983527953@linuxfoundation.org>
 <CA+G9fYvM_riojtryOUb3UrYbtw6yUZTTnbP+_X96nJLCcWYwBA@mail.gmail.com>
 <2deb9e86-7ca8-4baf-8576-83dad1ea065f@kernel.dk>
 <2025031910-poking-crusher-b38f@gregkh>
 <3dc5b070-0837-4737-be78-ba846016c02e@kernel.dk>
 <412b08d9-17fc-4a62-afd3-7371cf479f2d@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412b08d9-17fc-4a62-afd3-7371cf479f2d@kernel.dk>

On Thu, Mar 20, 2025 at 07:02:23AM -0600, Jens Axboe wrote:
> On 3/20/25 6:55 AM, Jens Axboe wrote:
> > On 3/19/25 5:51 PM, Greg Kroah-Hartman wrote:
> >> On Wed, Mar 19, 2025 at 10:37:20AM -0600, Jens Axboe wrote:
> >>> On 3/19/25 10:33 AM, Naresh Kamboju wrote:
> >>>> On Wed, 19 Mar 2025 at 20:09, Greg Kroah-Hartman
> >>>> <gregkh@linuxfoundation.org> wrote:
> >>>>>
> >>>>> This is the start of the stable review cycle for the 6.6.84 release.
> >>>>> There are 166 patches in this series, all will be posted as a response
> >>>>> to this one.  If anyone has any issues with these being applied, please
> >>>>> let me know.
> >>>>>
> >>>>> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> >>>>> Anything received after that time might be too late.
> >>>>>
> >>>>> The whole patch series can be found in one patch at:
> >>>>>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.84-rc1.gz
> >>>>> or in the git tree and branch at:
> >>>>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> >>>>> and the diffstat can be found below.
> >>>>>
> >>>>> thanks,
> >>>>>
> >>>>> greg k-h
> >>>>
> >>>> Regressions on mips the rt305x_defconfig builds failed with gcc-12
> >>>> the stable-rc v6.6.83-167-gd16a828e7b09
> >>>>
> >>>> First seen on the v6.6.83-167-gd16a828e7b09
> >>>>  Good: v6.6.83
> >>>>  Bad: v6.6.83-167-gd16a828e7b09
> >>>>
> >>>> * mips, build
> >>>>   - gcc-12-rt305x_defconfig
> >>>>
> >>>> Regression Analysis:
> >>>>  - New regression? Yes
> >>>>  - Reproducibility? Yes
> >>>>
> >>>> Build regression: mips implicit declaration of function 'vunmap'
> >>>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >>>
> >>> Ah that's my fault, forgot to include the backport of:
> >>>
> >>> commit 62346c6cb28b043f2a6e95337d9081ec0b37b5f5
> >>> Author: Jens Axboe <axboe@kernel.dk>
> >>> Date:   Sat Mar 16 07:21:43 2024 -0600
> >>>
> >>>     mm: add nommu variant of vm_insert_pages()
> >>>
> >>> for 6.1-stable and 6.6-stable. Greg, can you just cherry pick that one?
> >>> It'll pick cleanly into both, should go before the io_uring mmap series
> >>> obviously.
> >>>
> >>> Sorry about that! I did have it in my local trees, but for some reason
> >>> forgot to include it in the sent in series.
> >>
> >> Wait, this is already in the 6.6.y and 6.1.y queues, so this can't be
> >> the fix.  Was there a fixup for that commit somewhere else that I'm
> >> missing?
> > 
> > Huh indeed, guess I didn't mess up in the first place. What is going on
> > here indeed... Is that mips config NOMMU yet doesn't link in mm/nommu.o?
> > 
> > Checking, and no, it definitely has MMU=y in the config. Guess I
> > should've read the initial report more closely, it's simply missing the
> > vunmap definition. Adding linux/vmalloc.h to io_uring/io_uring.c should
> > fix it.
> > 
> > How do we want to deal with this?
> 
> Either fold in the hunk from the previous email, or replace patch 2 in
> the series I sent with this one instead, which adds the vmalloc.h
> include. That should sort out the issue without needing add-on patches
> that don't exist upstream.

Now replaced, thanks!

