Return-Path: <io-uring+bounces-7132-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 380A3A6950F
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 17:33:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 659D6189CF4D
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 16:33:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03DC51DEFC5;
	Wed, 19 Mar 2025 16:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A6A/67I7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E0A1DE4FB
	for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 16:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742402016; cv=none; b=OYVsAjWggyDH7TUlOSjfI90s5OySIPPw1kklk/pToimwsLHmhk26vFrGO9TWJuAPT/iX8LABmG7jj06231FtyO84Btwzm88VtWDc0DS6NwKeLI/KWQ7fw79DEuXLALwshV5YFVnOJXMW0/3WtBWnwooHf45M9Zxj8ZDo54bR0fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742402016; c=relaxed/simple;
	bh=b5JoerGjzoODytPs4/JCCgsORTIkD1OWdTmBFC8AjPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dmvMbHoY/C5BBLGlu2zTAmWXbkJO4BXTQ+15i5v5N+Lc4IMykbhE6/TtX00tMgVjkydDhIYzFodqheTnwZQ0HJuNzMkAnpGDHkqwZEQ0ULuLX8XZ7Hajej2DUR9SDcuqghwRfy41OqUNfl8sQXixZyMH2B8IYnB6dUJHWDAzfHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A6A/67I7; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-523efb24fb9so2967340e0c.3
        for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 09:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742402013; x=1743006813; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OVuqKpUv1pEU4LzOHuIA6EH8XUgNHnH2M2llTP84R4g=;
        b=A6A/67I7CkMWwUadriYwzJU/lkazyWM2kNKMUtyaTwie3iaKbuhInQoWY5vYbCLqBC
         gRSzPna9jvRlZ8PzRcSshfJlpC8uTumAng6LmkJbI59MQjb9B9uvh+8bFDv3GxmfF5JY
         q1GLtFM5x9O41LvK3MycD5eqhpE4JaWi+45b24GkpjKVRHaAqIWUIIZdsUqBbAsZwqwh
         v9gAfOoX49+wuqyKEiSmq88hYsdGL5thq8CXV8o5oqHX/cM6HbKV34xAh4QMmTlxQwes
         vQLY9FL+q3P0FksMdJ9SnoygTIIHxhjwG8JOXO3/51tBu362ll4uSFD2gZdrP2sCpS0S
         VM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742402013; x=1743006813;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OVuqKpUv1pEU4LzOHuIA6EH8XUgNHnH2M2llTP84R4g=;
        b=BiE8bOaH0srPo6GLL0fCnJYSvzCYwrnlbDqwu1AjB09n/ySOqk20ylpvahmkGDdr8l
         RxhckO+SlSRvNRiRVCe8Zu6B6znO/qPJHUdUmYb35+o5Gg1g5S4PIJOq/1WH30VvF+1s
         zGot6QkyO7YQ297mxijti//ABZOiOwA0Mnw9zg9ZUvKlrvkzi8xJLBHsB/vDqr/ajoi4
         gFTnfim1Hms6UCqs+bCJxCrD7zy20wROf9eXLp4AV96/PfYA0aFN0Xnxk40EhxJq+Ihw
         aMX8TtfBW50H9I5S7KimAmHpPwHfzesv/21ip/MeeoY+CLGyJUfICZ4Nj6h0EBd+CA6o
         kNDg==
X-Forwarded-Encrypted: i=1; AJvYcCVLWkhPLHfla2uTQgppHC4TsSNPykPnIsYvJ+W/k7I8hkZCc+Xp0tD7S+CuZktA0FeAsoilfDxq3w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9vO8nfEA2v5+fVo2NUSvJ4s8dyLj+5SwyUwfjLSWs3W9HRGSH
	nGLi84gUOaCuWmcUn/u2OvNXm0h+iAn27AKb/5R9MNJvgfOa5kFvFmNxMGNyv0qHiwMvHrL3OzX
	DL2PwO/BnpIPSdmLIl8KYcVhb/3hY7ehKJZQEBQ==
X-Gm-Gg: ASbGncspCHymd5/klW8ycgBRJcyJpU0S83yufQzyindneKj5c4tqkp496GIsaI3efbb
	/fBDiZeAAzCixzoPf5YOh1u6bOo7h/zCzihG2Kb5sPHicKZxNKIAB0wxEV7AEdVT23Hm382uKKc
	iBzuVjlgRsd1+I+SP9CxprLHqjWZT6lpX//eBOQJdM5OQLabM0W65f3OM=
X-Google-Smtp-Source: AGHT+IHWmBTfBeI+pX6l/d4K6vWO07nXM028XzAozff8NwOIYDbLIFEeoObpskDnFhKhHnfnKlb6wiHJoN9ZGxWxSfQ=
X-Received: by 2002:a05:6122:8890:b0:525:9440:243c with SMTP id
 71dfb90a1353d-525944025e4mr695738e0c.11.1742402012994; Wed, 19 Mar 2025
 09:33:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250319143019.983527953@linuxfoundation.org>
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 19 Mar 2025 22:03:20 +0530
X-Gm-Features: AQ5f1JqIqR8G0jdBi-EqCaYlr4_sxu0nohARN-WaSCDfLRpd0KihGkC9ntbmtXw
Message-ID: <CA+G9fYvM_riojtryOUb3UrYbtw6yUZTTnbP+_X96nJLCcWYwBA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Mar 2025 at 20:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.84 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.84-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on mips the rt305x_defconfig builds failed with gcc-12
the stable-rc v6.6.83-167-gd16a828e7b09

First seen on the v6.6.83-167-gd16a828e7b09
 Good: v6.6.83
 Bad: v6.6.83-167-gd16a828e7b09

* mips, build
  - gcc-12-rt305x_defconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: mips implicit declaration of function 'vunmap'
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
io_uring/io_uring.c: In function 'io_pages_unmap':
io_uring/io_uring.c:2708:17: error: implicit declaration of function
'vunmap'; did you mean 'kunmap'?
[-Werror=implicit-function-declaration]
 2708 |                 vunmap(ptr);
      |                 ^~~~~~
      |                 kunmap
io_uring/io_uring.c: In function '__io_uaddr_map':
io_uring/io_uring.c:2784:21: error: implicit declaration of function
'vmap'; did you mean 'kmap'? [-Werror=implicit-function-declaration]
 2784 |         page_addr = vmap(page_array, nr_pages, VM_MAP, PAGE_KERNEL);
      |                     ^~~~
      |                     kmap
io_uring/io_uring.c:2784:48: error: 'VM_MAP' undeclared (first use in
this function); did you mean 'VM_MTE'?
 2784 |         page_addr = vmap(page_array, nr_pages, VM_MAP, PAGE_KERNEL);
      |                                                ^~~~~~
      |                                                VM_MTE

## Source
* Kernel version: 6.6.84-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: d16a828e7b0965ca37245ebea19052ad7b4b2f9b
* Git describe: v6.6.83-167-gd16a828e7b09
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-167-gd16a828e7b09/

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-167-gd16a828e7b09/testrun/27677634/suite/build/test/gcc-12-rt305x_defconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-167-gd16a828e7b09/testrun/27677634/suite/build/test/gcc-12-rt305x_defconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-167-gd16a828e7b09/testrun/27677634/suite/build/test/gcc-12-rt305x_defconfig/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2uXZlKzVxja3mOQfRLlPRxHzd5L/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2uXZlKzVxja3mOQfRLlPRxHzd5L/config

## Steps to reproduce
 - tuxmake --runtime podman --target-arch mips --toolchain gcc-12
--kconfig rt305x_defconfig


--
Linaro LKFT
https://lkft.linaro.org

