Return-Path: <io-uring+bounces-7786-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E3EFAA4924
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 12:48:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E5A4166292
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 10:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F2F246796;
	Wed, 30 Apr 2025 10:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E4rCIKZt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F25E235348
	for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 10:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746010078; cv=none; b=U0d4tXWOZTIA21BhTU3S/Ng5bSPj7dPMh7FeGxrCqsHHfmo3jO4CCWpLo8D1ttdX0aayTQeb4XX3ZSd0Aj1aOJst0GVK/nA+P1flrAWtz0WlPQWKzuwW4PEZu7F/g8kSYRrG/x1v5EXQvMPFXN3LqAwEppjN33PJUA8oK8Eb9qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746010078; c=relaxed/simple;
	bh=KZ4D4wA6jOB19CqMttYNzcmG3vmZVzgiZpvB/b91YRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s7kCWi4WjBpQKjVFiIIFfjzeGjJQFHjqtrk0aqCDuzCegmHCbNbjqpkvGCjaXphVbBMeNmxnsDidewhOjbErudD++X/zlPjXuP8ke36Fa2jr9j2C+uPIqau4/F7HJV5+7ejuNOsAaQuyAy+AowZ2e/I+6qhiUKKVS+Ci7NCW3sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=E4rCIKZt; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-39c14016868so7591614f8f.1
        for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 03:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746010073; x=1746614873; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0CkkUaAdJmcxdXetcIEsOI8FyoUSTguzDgC+/O7Abg=;
        b=E4rCIKZtiES52Jhwk3GmLZODjM843uucbigRWENBZxOc5O1sRdD+QLQvjvEgP272xc
         ybOcsF/fQc2X5Gs2bgYBiHgqqK6HiUbJNwprbnivtvScwHEojkrucnwixDhJwOsh1iI5
         FC5zWVHoVwClQqImmtsGNuM3W49asBkCXSc0g2Zul9hME8fK5yl1eiA3GmFKFtEPOFyX
         7LbW/DYRptGVafYQRAS1ufyuOyj5Gw4JwWv7i/F0jv/3eLLEsFxJdKqzimk7ONC1IVSG
         WuFhsbG1GhRAYWw9VIfPNrg3zC+0EuCVgaRdN7mRCy5sgdHzW+dGVrG0dkbJ8dagtNWP
         OcQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746010073; x=1746614873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q0CkkUaAdJmcxdXetcIEsOI8FyoUSTguzDgC+/O7Abg=;
        b=Oj3sDjUGp5OHPAo2InltU4C2f4ZD4NrCz9KcfNd2muI+r7rxI7IooKxAEE/uY6t2ey
         cOHVEWAWykKyBHuuHZwBfXIpN842tcCOZSDdNYphJt8miWQufWOi+m04BAdZ5+b6Sk3s
         T60aK6/cg7Qp0BNs3plyjWVcv1mAOJuXNGGzBjcnD2oXIFrReJKSQZiP8fJQFH7GlWQt
         GQ8MrOF3dE6X9unG9rwYw+VClzDzi70brOxesbssmNLVES+VWEl9yXBfNwOIKKaamQUG
         eSrHMorT+HyxBQOMZPXEj8FtBICl5l7IQdomzIiqyDw0F8zKZXHherZLW889l0Wrs0j0
         0kZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXs+7fXl/rbjsvc6envN10JdArSL0+F5cnvi9LzAX5C1F8eQrpGtANKV1fbFMGqiV64/tkXLp+Tw==@vger.kernel.org
X-Gm-Message-State: AOJu0YweVmYOeWatGRMlRH/Z4RXOP7AJDSAmRJIMvxtU8DKcK4PP8m4G
	/JiTdn+Ndr+ZCXuxCUTPqfarw76iMOE9SKMFmjQVf2sioQX5NKPQTu38O8ik9NU=
X-Gm-Gg: ASbGncsgaCGrq2+UDtIJUxP9yBzGOMu6G7dGqKRJB6sw8XIIVJzZYeo8GD/vBFSDGdR
	Ucc/z1Zort0JZ728nUjkkyAJSHVi9U2/aXj1xrse28syXX2k3m6GGWieN4z3BRinBWm9Z2SNmDx
	iuBuUeTa4cG1V24C331ZjJIBc8n52pzLQUmfO+hwkwNyObCSxMxl0Gzg1+uds8bHl7JyWlNxgTx
	8QOfY0V4eti2XoOCd0Mh4XruoO2aOIEePqMAlAJL8fnQR9Pj6fNHcg39bcZXEW7g8pKuiQr3K9c
	1X6LHilidboscm5BjhIn2+7LpTIQn55L4rfNu8CJ1cBQ2A==
X-Google-Smtp-Source: AGHT+IGNNRy4PH92+7j0Ai5ComfG3VcuRdc7eRFYN9MlXNwnWXPspmkRo1bsp3MGrMHG6agBsO2P3w==
X-Received: by 2002:a05:6000:3107:b0:3a0:89ec:d398 with SMTP id ffacd0b85a97d-3a08f764da6mr2056906f8f.17.1746010073149;
        Wed, 30 Apr 2025 03:47:53 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a073e5c9cdsm16545781f8f.87.2025.04.30.03.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 03:47:52 -0700 (PDT)
Date: Wed, 30 Apr 2025 13:47:49 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
	clang-built-linux <llvm@lists.linux.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Nathan Chancellor <nathan@kernel.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, linux-s390@vger.kernel.org,
	linux-mips@vger.kernel.org, io-uring@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH 6.1 000/167] 6.1.136-rc1 review
Message-ID: <55d4db6d-ceef-4e36-9e5b-7c4c825080fe@stanley.mountain>
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

All the clang-nightly issues seem like bugs in clang.  I would say only
the build error on S390 is a kernel issue.

regards,
dan carpenter

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
> 
> ## Build x86_64
> * Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28268204/suite/build/test/clang-nightly-x86_64_defconfig/log
> * Build history:
> https://qa-reports.linaro.org/lkft/linux-stale-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28268204/suite/build/test/clang-nightly-x86_64_defconfig/history/
> * Build details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28268204/suite/build/test/clang-nightly-x86_64_defconfig/details/
> * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjfmTxuT4qMCUSSj4ZwJQJrqY/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjfmTxuT4qMCUSSj4ZwJQJrqY/config
> * Toolchain: Debian clang version 21.0.0
> (++20250428112741+e086d7b1464a-1~exp1~20250428112923.1416)
> 
> 2)
> Regressions on s390 with defconfig builds with gcc-13, gcc-8 and
> clang-20 and clang-nightly toolchains on the stable-rc 6.1.136-rc1.
> 
> * s390, build
>   - clang-20-defconfig
>   - clang-nightly-defconfig
>   - gcc-13-allmodconfig
>   - gcc-13-defconfig
>   - gcc-8-defconfig-fe40093d
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
> 
> Build regression: s390 pci_report.c fatal error linux sprintf.h No
> such file or directory
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build error S390
> arch/s390/pci/pci_report.c:14:10: fatal error: linux/sprintf.h: No
> such file or directory
>    14 | #include <linux/sprintf.h>
>       |          ^~~~~~~~~~~~~~~~~
> compilation terminated.
> arch/s390/pci/pci_fixup.c: In function 'zpci_ism_bar_no_mmap':
> arch/s390/pci/pci_fixup.c:19:13: error: 'struct pci_dev' has no member
> named 'non_mappable_bars'
>    19 |         pdev->non_mappable_bars = 1;
>       |             ^~
> drivers/s390/virtio/virtio_ccw.c:88:9: error: unknown type name 'dma64_t'
>    88 |         dma64_t queue;
>       |         ^~~~~~~
> drivers/s390/virtio/virtio_ccw.c:95:9: error: unknown type name 'dma64_t'
>    95 |         dma64_t desc;
>       |         ^~~~~~~
> drivers/s390/virtio/virtio_ccw.c:99:9: error: unknown type name 'dma64_t'
>    99 |         dma64_t avail;
>       |         ^~~~~~~
> drivers/s390/virtio/virtio_ccw.c:100:9: error: unknown type name 'dma64_t'
>   100 |         dma64_t used;
>       |         ^~~~~~~
> drivers/s390/virtio/virtio_ccw.c:109:9: error: unknown type name 'dma64_t'
>   109 |         dma64_t summary_indicator;
>       |         ^~~~~~~
> drivers/s390/virtio/virtio_ccw.c:110:9: error: unknown type name 'dma64_t'
>   110 |         dma64_t indicator;
>       |         ^~~~~~~
> drivers/s390/virtio/virtio_ccw.c: In function 'virtio_ccw_drop_indicator':
> drivers/s390/virtio/virtio_ccw.c:370:25: error: implicit declaration
> of function 'virt_to_dma64'; did you mean 'virt_to_page'?
> [-Werror=implicit-function-declaration]
>   370 |                         virt_to_dma64(get_summary_indicator(airq_info));
>       |                         ^~~~~~~~~~~~~
>       |                         virt_to_page
> drivers/s390/virtio/virtio_ccw.c:374:28: error: implicit declaration
> of function 'virt_to_dma32'; did you mean 'virt_to_page'?
> [-Werror=implicit-function-declaration]
>   374 |                 ccw->cda = virt_to_dma32(thinint_area);
>       |                            ^~~~~~~~~~~~~
>       |                            virt_to_page
> drivers/s390/virtio/virtio_ccw.c: In function 'virtio_ccw_setup_vq':
> drivers/s390/virtio/virtio_ccw.c:552:45: error: implicit declaration
> of function 'u64_to_dma64' [-Werror=implicit-function-declaration]
>   552 |                 info->info_block->l.queue = u64_to_dma64(queue);
>       |                                             ^~~~~~~~~~~~
> drivers/s390/virtio/virtio_ccw.c: In function 'virtio_ccw_find_vqs':
> drivers/s390/virtio/virtio_ccw.c:654:9: error: unknown type name 'dma64_t'
>   654 |         dma64_t *indicatorp = NULL;
>       |         ^~~~~~~
> cc1: some warnings being treated as errors
> 
> ## Build s390
> * Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28268210/suite/build/test/gcc-13-defconfig/log
> * Build history:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28268210/suite/build/test/gcc-13-defconfig/history/
> * Build details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28268210/suite/build/test/gcc-13-defconfig/details/
> * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjfcqRiiDhTc38knEJ0xbygtF/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjfcqRiiDhTc38knEJ0xbygtF/config
> * Toolchain: Debian clang version 21.0.0
> (++20250428112741+e086d7b1464a-1~exp1~20250428112923.1416)
> 
> 3)
> Regressions on mips with defconfig builds with clang-nightly
> toolchains on the stable-rc 6.1.136-rc1.
> 
> * mips, build
>   - clang-nightly-allnoconfig
>   - clang-nightly-defconfig
>   - clang-nightly-tinyconfig
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
> 
> Build regression: mips kernel branch.c error default initialization of
> an object of type union
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build error mips
> arch/mips/kernel/branch.c:35:6: error: default initialization of an
> object of type 'union (unnamed union at
> arch/mips/kernel/branch.c:35:6)' with const member leaves the object
> uninitialized and is incompatible with C++
> [-Werror,-Wdefault-const-init-unsafe]
>    35 |         if (__get_user(inst, (u16 __user *) msk_isa16_mode(epc))) {
>       |             ^
> 
> 
> ## Build mips
> * Build log:  https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28266863/suite/build/test/clang-nightly-tinyconfig/log
> * Build history:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28266863/suite/build/test/clang-nightly-tinyconfig/history/
> * Build details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28266863/suite/build/test/clang-nightly-tinyconfig/details/
> * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjfMHLLGL9OjZrjKvW9u8uy4b/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjfMHLLGL9OjZrjKvW9u8uy4b/config
> 
> 
> ## Build warnings
> 
> a)
> Build warnings on x86_64 builds.
> io_uring/timeout.c:410:31: warning: default initialization of an
> object of type 'typeof ((sqe->addr2))' (aka 'const unsigned long
> long') leaves the object uninitialized and is incompatible with C++
> [-Wdefault-const-init-unsafe]
>   410 |                 if (get_timespec64(&tr->ts,
> u64_to_user_ptr(sqe->addr2)))
>       |                                             ^
> 
> Links:
>  - https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjeiV7BNYgKZ2oXuK3BNEYYBa/
> 
> b)
> Build warnings on arm with clang-nightly with tinyconfig.
> 
> clang: warning: argument unused during compilation: '-march=armv7-m'
> [-Wunused-command-line-argument]
> kernel/params.c:367:22: warning: default initialization of an object
> of type 'struct kernel_param' with const member leaves the object
> uninitialized and is incompatible with C++
> [-Wdefault-const-init-unsafe]
>   367 |         struct kernel_param dummy;
>       |                             ^
> include/linux/moduleparam.h:73:12: note: member 'perm' declared 'const' here
>    73 |         const u16 perm;
>       |                   ^
> kernel/params.c:423:22: warning: default initialization of an object
> of type 'struct kernel_param' with const member leaves the object
> uninitialized and is incompatible with C++
> [-Wdefault-const-init-unsafe]
>   423 |         struct kernel_param kp;
>       |                             ^
> include/linux/moduleparam.h:73:12: note: member 'perm' declared 'const' here
>    73 |         const u16 perm;
>       |                   ^
> 2 warnings generated.
> 
> Links:
>  - https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjeaX1oyIaa7F0nsdW1BymEGQ/
> 
> ## Build
> * kernel: 6.1.136-rc1
> * git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> * git commit: 961a5173f29d2aa1f2c87ff9612b029c46086972
> * git describe: v6.1.134-461-g961a5173f29d
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d
> 
> ## Test Regressions (compared to v6.1.134-292-gb8b5da130779)
> * i386, build
>   - clang-nightly-defconfig
>   - clang-nightly-lkftconfig
> 
> * mips, build
>   - clang-nightly-allnoconfig
>   - clang-nightly-defconfig
>   - clang-nightly-tinyconfig
> 
> * s390, build
>   - clang-20-defconfig
>   - clang-nightly-defconfig
>   - gcc-13-allmodconfig
>   - gcc-13-defconfig
>   - gcc-8-defconfig-fe40093d
> 
> * x86_64, build
>   - clang-nightly-lkftconfig
>   - clang-nightly-x86_64_defconfig
> 
> ## Metric Regressions (compared to v6.1.134-292-gb8b5da130779)
> 
> ## Test Fixes (compared to v6.1.134-292-gb8b5da130779)
> 
> ## Metric Fixes (compared to v6.1.134-292-gb8b5da130779)
> 
> ## Test result summary
> total: 96862, pass: 76665, fail: 4435, skip: 15439, xfail: 323
> 
> ## Build Summary
> * arc: 5 total, 5 passed, 0 failed
> * arm: 135 total, 135 passed, 0 failed
> * arm64: 43 total, 43 passed, 0 failed
> * i386: 27 total, 20 passed, 7 failed
> * mips: 26 total, 22 passed, 4 failed
> * parisc: 4 total, 4 passed, 0 failed
> * powerpc: 32 total, 31 passed, 1 failed
> * riscv: 11 total, 9 passed, 2 failed
> * s390: 14 total, 8 passed, 6 failed
> * sh: 10 total, 10 passed, 0 failed
> * sparc: 7 total, 7 passed, 0 failed
> * x86_64: 35 total, 32 passed, 3 failed
> 
> ## Test suites summary
> * boot
> * commands
> * kselftest-arm64
> * kselftest-breakpoints
> * kselftest-capabilities
> * kselftest-cgroup
> * kselftest-clone3
> * kselftest-core
> * kselftest-cpu-hotplug
> * kselftest-cpufreq
> * kselftest-efivarfs
> * kselftest-exec
> * kselftest-fpu
> * kselftest-ftrace
> * kselftest-futex
> * kselftest-gpio
> * kselftest-intel_pstate
> * kselftest-ipc
> * kselftest-kcmp
> * kselftest-kvm
> * kselftest-livepatch
> * kselftest-membarrier
> * kselftest-memfd
> * kselftest-mincore
> * kselftest-mqueue
> * kselftest-net
> * kselftest-net-mptcp
> * kselftest-openat2
> * kselftest-ptrace
> * kselftest-rseq
> * kselftest-rtc
> * kselftest-seccomp
> * kselftest-sigaltstack
> * kselftest-size
> * kselftest-tc-testing
> * kselftest-timers
> * kselftest-tmpfs
> * kselftest-tpm2
> * kselftest-user_events
> * kselftest-vDSO
> * kselftest-x86
> * kunit
> * kvm-unit-tests
> * lava
> * libgpiod
> * libhugetlbfs
> * log-parser-boot
> * log-parser-build-clang
> * log-parser-build-gcc
> * log-parser-test
> * ltp-capability
> * ltp-commands
> * ltp-containers
> * ltp-controllers
> * ltp-cpuhotplug
> * ltp-crypto
> * ltp-cve
> * ltp-dio
> * ltp-fcntl-locktests
> * ltp-fs
> * ltp-fs_bind
> * ltp-fs_perms_simple
> * ltp-hugetlb
> * ltp-ipc
> * ltp-math
> * ltp-mm
> * ltp-nptl
> * ltp-pty
> * ltp-sched
> * ltp-smoke
> * ltp-syscalls
> * ltp-tracing
> * perf
> * rcutorture
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

