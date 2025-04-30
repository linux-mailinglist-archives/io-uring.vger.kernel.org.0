Return-Path: <io-uring+bounces-7785-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46D60AA48E9
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 12:43:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A0AF179FEE
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 10:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC7625D210;
	Wed, 30 Apr 2025 10:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WYUJSuQi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243DA25B68A
	for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 10:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746009575; cv=none; b=pnjJP0jVN3+ru+6sQwA4yV1DAqX/7GzC8RAn552qI/rWi+N0u5mVKVw8UO/Jkt5NGFPZKGZodxu8pVdlXf+kHCeSDvWYHI1TAcr5vd15vSF0MTDrfwu9yucqZztffcqee/HyBDkteq0+VnQynIJjA7WGiPKK2bP1t42svOx7OP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746009575; c=relaxed/simple;
	bh=d4RLgrZhyX8/Pg01VVv6h4TRP9Jm0WhqcAfzUScAuus=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bYnbfJ52EJhnsEB12ZndIWB7kbtRNUv0kvrnsvB9OVWoJ1zYfHtP6yv4kN5dMdP23+09Lftoc2Uy3XXzHzO4lu26W7E7izGbH/A+A6gnSDI57ihT3YbGS8ORcnXO6LhWLnhDeurqrR76elIynJ4D5NOsjLR7AVxhydmVsJ9CgG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WYUJSuQi; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5262475372eso2893917e0c.2
        for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 03:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746009571; x=1746614371; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ylwsJDrt4vv0hbcQwuLON7i6O6OaEoOImrGaJinpJGA=;
        b=WYUJSuQiHnLWQFEYYBzqqz86iErDXvdI3apuelCg6jve83A0yametRUdLhmSHehiQn
         Yh63xjU6qVvvGvlm+AbQBEvUmwccu9X6y6rEXHuyStGVErRL0TqYpd8hDLrtiAT8FBlx
         US3achPj3jJcmcFAb49P1wHB9P5T0VndXXrPlKa8kgSpNLM3yUamrmwNHmtpdd2xjTOw
         /LsIshelkLwlAMpFHXxck9GIvJISBUKWNriBrHQNxlYLpG3WrJAbIDMEwHPPezHUO9sk
         7wM8CDPaj6cisAmsN0G3hSOj8a+Fr+OVHNbijwmsA1f/Q2JWpw+tratfAUVMBVJYWMvs
         FAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746009571; x=1746614371;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ylwsJDrt4vv0hbcQwuLON7i6O6OaEoOImrGaJinpJGA=;
        b=nhpTDoE9tzCSpPlhPHd2qqcl/EPg82dV1oNDzM62u/N+3oiMcsQJtP3nYjt9rb7Ne5
         2ydbUe6SPhQgBicwDtjf2KaAK2i0KAqdoX7dmvioyO10SQtdRQY5nxU2HOXlwOyG3T9g
         /Q4H3jDVI3u8M62TQ2dIMxFd0qUMdtkTrn6fcSpGGNn0IyBT3BHAx8jkfQLksMeq73Tp
         Ay6s1yvje+DQ41NAcevU7oGjUEUEiuaD9tu/K2xzbvYG3TKdVSUvAg4sCm6yLsxcHir9
         w6iz9t+pmcnku0q4VJwQ9xWO5t8vmyEzOcXYFX/HccGSRIKem7VfkD6TO6gwAqWU3+vC
         ertQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2pxpYJLyzYHXcm8v/NOGvcA2JA+5rio2mZQzhgA18Nv6ZC6LQ0z+nXODrwpMlPY9y6RAuaKWLGA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFgx+7F18MCzI73suj0CAWJ6G8uXOGnzWqiNByYafnMnqIdLS4
	M4SxJ7zi2ud3ytbTcanXgkUC8WGUKKrwcRicOdxk9rgQumwBwNadeqwv949bsGZdFgTczaMkScV
	appGFC+CFv3LqLa4UmA50Pd/nDLIhR3AX43pzow==
X-Gm-Gg: ASbGncu3BUOjQMRN3knhatV9RMQmNS+DM5NvbNOQ27WACjR3xXHTr6hS0GNmvftfRyk
	EKpNFZdQob8vgaxVi3xDHFY778fbQQAo3IPeDqu+kUQRHu9xr3jtEXXwOBRxfgcmawOK8e07wJK
	EZ6qhdEI+Xps4YGD0Ags58+99KoBO1RlvD2+zqdTfc9mUZePw+k38h8g/F1h02J+mj
X-Google-Smtp-Source: AGHT+IEGrbJc8JxtRP89FE4xXSHbjaEwuC2CG8y2YBkTpepRUy6crz/1pfGUdfcI0IOB0Gksvo22zIGEP03RI2L25Ng=
X-Received: by 2002:a05:6122:25d8:b0:52a:d0f3:1ec1 with SMTP id
 71dfb90a1353d-52ad0f31f5fmr358417e0c.0.1746009570825; Wed, 30 Apr 2025
 03:39:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250429161051.743239894@linuxfoundation.org>
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 30 Apr 2025 16:09:18 +0530
X-Gm-Features: ATxdqUGXDo7pBa4eq0bS5qcWzmVSW-p2cU-XdgUlse38VYng22TRg-n231NAwjI
Message-ID: <CA+G9fYuNjKcxFKS_MKPRuga32XbndkLGcY-PVuoSwzv6VWbY=w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/167] 6.1.136-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, clang-built-linux <llvm@lists.linux.dev>, 
	Nathan Chancellor <nathan@kernel.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, linux-s390@vger.kernel.org, 
	linux-mips@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Apr 2025 at 23:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.136 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.136-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

There are three build regressions and two build warnings.

1)
Regressions on x86_64 with defconfig builds with clang-nightly toolchain
on the stable-rc 6.1.136-rc1.

* x86_64, build
  - clang-nightly-lkftconfig
  - clang-nightly-x86_64_defconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: x86_64 clang-nightly net ip.h error default
initialization of an object of type 'typeof (rt->dst.expires)'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build error x86_64
include/net/ip.h:462:14: error: default initialization of an object of
type 'typeof (rt->dst.expires)' (aka 'const unsigned long') leaves the
object uninitialized and is incompatible with C++
[-Werror,-Wdefault-const-init-unsafe]
  462 |                 if (mtu && time_before(jiffies, rt->dst.expires))
      |                            ^

## Build x86_64
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28268204/suite/build/test/clang-nightly-x86_64_defconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stale-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28268204/suite/build/test/clang-nightly-x86_64_defconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28268204/suite/build/test/clang-nightly-x86_64_defconfig/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjfmTxuT4qMCUSSj4ZwJQJrqY/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjfmTxuT4qMCUSSj4ZwJQJrqY/config
* Toolchain: Debian clang version 21.0.0
(++20250428112741+e086d7b1464a-1~exp1~20250428112923.1416)

2)
Regressions on s390 with defconfig builds with gcc-13, gcc-8 and
clang-20 and clang-nightly toolchains on the stable-rc 6.1.136-rc1.

* s390, build
  - clang-20-defconfig
  - clang-nightly-defconfig
  - gcc-13-allmodconfig
  - gcc-13-defconfig
  - gcc-8-defconfig-fe40093d

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: s390 pci_report.c fatal error linux sprintf.h No
such file or directory

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build error S390
arch/s390/pci/pci_report.c:14:10: fatal error: linux/sprintf.h: No
such file or directory
   14 | #include <linux/sprintf.h>
      |          ^~~~~~~~~~~~~~~~~
compilation terminated.
arch/s390/pci/pci_fixup.c: In function 'zpci_ism_bar_no_mmap':
arch/s390/pci/pci_fixup.c:19:13: error: 'struct pci_dev' has no member
named 'non_mappable_bars'
   19 |         pdev->non_mappable_bars = 1;
      |             ^~
drivers/s390/virtio/virtio_ccw.c:88:9: error: unknown type name 'dma64_t'
   88 |         dma64_t queue;
      |         ^~~~~~~
drivers/s390/virtio/virtio_ccw.c:95:9: error: unknown type name 'dma64_t'
   95 |         dma64_t desc;
      |         ^~~~~~~
drivers/s390/virtio/virtio_ccw.c:99:9: error: unknown type name 'dma64_t'
   99 |         dma64_t avail;
      |         ^~~~~~~
drivers/s390/virtio/virtio_ccw.c:100:9: error: unknown type name 'dma64_t'
  100 |         dma64_t used;
      |         ^~~~~~~
drivers/s390/virtio/virtio_ccw.c:109:9: error: unknown type name 'dma64_t'
  109 |         dma64_t summary_indicator;
      |         ^~~~~~~
drivers/s390/virtio/virtio_ccw.c:110:9: error: unknown type name 'dma64_t'
  110 |         dma64_t indicator;
      |         ^~~~~~~
drivers/s390/virtio/virtio_ccw.c: In function 'virtio_ccw_drop_indicator':
drivers/s390/virtio/virtio_ccw.c:370:25: error: implicit declaration
of function 'virt_to_dma64'; did you mean 'virt_to_page'?
[-Werror=implicit-function-declaration]
  370 |                         virt_to_dma64(get_summary_indicator(airq_info));
      |                         ^~~~~~~~~~~~~
      |                         virt_to_page
drivers/s390/virtio/virtio_ccw.c:374:28: error: implicit declaration
of function 'virt_to_dma32'; did you mean 'virt_to_page'?
[-Werror=implicit-function-declaration]
  374 |                 ccw->cda = virt_to_dma32(thinint_area);
      |                            ^~~~~~~~~~~~~
      |                            virt_to_page
drivers/s390/virtio/virtio_ccw.c: In function 'virtio_ccw_setup_vq':
drivers/s390/virtio/virtio_ccw.c:552:45: error: implicit declaration
of function 'u64_to_dma64' [-Werror=implicit-function-declaration]
  552 |                 info->info_block->l.queue = u64_to_dma64(queue);
      |                                             ^~~~~~~~~~~~
drivers/s390/virtio/virtio_ccw.c: In function 'virtio_ccw_find_vqs':
drivers/s390/virtio/virtio_ccw.c:654:9: error: unknown type name 'dma64_t'
  654 |         dma64_t *indicatorp = NULL;
      |         ^~~~~~~
cc1: some warnings being treated as errors

## Build s390
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28268210/suite/build/test/gcc-13-defconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28268210/suite/build/test/gcc-13-defconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28268210/suite/build/test/gcc-13-defconfig/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjfcqRiiDhTc38knEJ0xbygtF/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjfcqRiiDhTc38knEJ0xbygtF/config
* Toolchain: Debian clang version 21.0.0
(++20250428112741+e086d7b1464a-1~exp1~20250428112923.1416)

3)
Regressions on mips with defconfig builds with clang-nightly
toolchains on the stable-rc 6.1.136-rc1.

* mips, build
  - clang-nightly-allnoconfig
  - clang-nightly-defconfig
  - clang-nightly-tinyconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: mips kernel branch.c error default initialization of
an object of type union

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build error mips
arch/mips/kernel/branch.c:35:6: error: default initialization of an
object of type 'union (unnamed union at
arch/mips/kernel/branch.c:35:6)' with const member leaves the object
uninitialized and is incompatible with C++
[-Werror,-Wdefault-const-init-unsafe]
   35 |         if (__get_user(inst, (u16 __user *) msk_isa16_mode(epc))) {
      |             ^


## Build mips
* Build log:  https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28266863/suite/build/test/clang-nightly-tinyconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28266863/suite/build/test/clang-nightly-tinyconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d/testrun/28266863/suite/build/test/clang-nightly-tinyconfig/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjfMHLLGL9OjZrjKvW9u8uy4b/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjfMHLLGL9OjZrjKvW9u8uy4b/config


## Build warnings

a)
Build warnings on x86_64 builds.
io_uring/timeout.c:410:31: warning: default initialization of an
object of type 'typeof ((sqe->addr2))' (aka 'const unsigned long
long') leaves the object uninitialized and is incompatible with C++
[-Wdefault-const-init-unsafe]
  410 |                 if (get_timespec64(&tr->ts,
u64_to_user_ptr(sqe->addr2)))
      |                                             ^

Links:
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjeiV7BNYgKZ2oXuK3BNEYYBa/

b)
Build warnings on arm with clang-nightly with tinyconfig.

clang: warning: argument unused during compilation: '-march=armv7-m'
[-Wunused-command-line-argument]
kernel/params.c:367:22: warning: default initialization of an object
of type 'struct kernel_param' with const member leaves the object
uninitialized and is incompatible with C++
[-Wdefault-const-init-unsafe]
  367 |         struct kernel_param dummy;
      |                             ^
include/linux/moduleparam.h:73:12: note: member 'perm' declared 'const' here
   73 |         const u16 perm;
      |                   ^
kernel/params.c:423:22: warning: default initialization of an object
of type 'struct kernel_param' with const member leaves the object
uninitialized and is incompatible with C++
[-Wdefault-const-init-unsafe]
  423 |         struct kernel_param kp;
      |                             ^
include/linux/moduleparam.h:73:12: note: member 'perm' declared 'const' here
   73 |         const u16 perm;
      |                   ^
2 warnings generated.

Links:
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPjeaX1oyIaa7F0nsdW1BymEGQ/

## Build
* kernel: 6.1.136-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 961a5173f29d2aa1f2c87ff9612b029c46086972
* git describe: v6.1.134-461-g961a5173f29d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-461-g961a5173f29d

## Test Regressions (compared to v6.1.134-292-gb8b5da130779)
* i386, build
  - clang-nightly-defconfig
  - clang-nightly-lkftconfig

* mips, build
  - clang-nightly-allnoconfig
  - clang-nightly-defconfig
  - clang-nightly-tinyconfig

* s390, build
  - clang-20-defconfig
  - clang-nightly-defconfig
  - gcc-13-allmodconfig
  - gcc-13-defconfig
  - gcc-8-defconfig-fe40093d

* x86_64, build
  - clang-nightly-lkftconfig
  - clang-nightly-x86_64_defconfig

## Metric Regressions (compared to v6.1.134-292-gb8b5da130779)

## Test Fixes (compared to v6.1.134-292-gb8b5da130779)

## Metric Fixes (compared to v6.1.134-292-gb8b5da130779)

## Test result summary
total: 96862, pass: 76665, fail: 4435, skip: 15439, xfail: 323

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 43 total, 43 passed, 0 failed
* i386: 27 total, 20 passed, 7 failed
* mips: 26 total, 22 passed, 4 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 9 passed, 2 failed
* s390: 14 total, 8 passed, 6 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 35 total, 32 passed, 3 failed

## Test suites summary
* boot
* commands
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-efivarfs
* kselftest-exec
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-x86
* kunit
* kvm-unit-tests
* lava
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-capability
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org

