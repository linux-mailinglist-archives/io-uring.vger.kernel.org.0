Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C348731FCD3
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 17:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhBSQJh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 11:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhBSQJU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 11:09:20 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315C0C06178A
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 08:08:39 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id p2so10762882edm.12
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 08:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=p7Qeq2s5Xnq9l0SeDvPjf0XHN3FRE6tEzdDl2ybtrE8=;
        b=La2J+a6v9usT3u6H9nSsx6mX/B7G1xzcjtvBWy0mQZVxr6VqQKalpmPhTgFcgOD4Vu
         HXlygKNzkKKBr6DdDrdft4DJO2zdsPc47LkPmIpZBG8rYVm0ktjRGMvIeUf/hhJp9QWi
         qCBPRLjozKe0opoP3Ng9Mmtz1s0kzKOQvp1cijTFRn3oTfuzRuFzhoYyLBMDZ3s9mW1m
         hFd9Wx+etS7Htm8sdz2N1DzpvcRs7axOm7kl8j7mYdmlMNnemgXakbEOXx+gmxfG9wHj
         8ipbajako4VqmFrb+R/KsG4fTov3KLFe0kLdy/Yym5lp3JmcZahwBtflqAL4vUrHUIu/
         fpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=p7Qeq2s5Xnq9l0SeDvPjf0XHN3FRE6tEzdDl2ybtrE8=;
        b=QcBMXIplnzh32KJwkUlyb3DC931d4e3eeROhZgoRlEI/Oeg6tqCUHxgYSwlDKEDGY9
         KaCixjIop04HPE/rQWnsEBf0QgHgrUeTjXZ9jNO79mLC4vCczYhGsCpEU1V1BT0bq3Xf
         xtsoWirqL/P0V33k0OAGF4eoOdGOxYyxHzeq7PmE2Pf41MAYxZCkyYYnfAtTrJtv5OtF
         /gMJ2ZweZGVJMB2kX6Q/N+efIFF0VGRgfOoEKJU7ICw8w+W3rWkHjOzXOkmbLCLAOFZo
         Ux5+s/vbLyu4mXDScNTKghgTO8fZ3RBgmy2DaT/I73QYPMWDo8mUuQ/Og5EQjt2yFyYn
         O22Q==
X-Gm-Message-State: AOAM5335ft4SyoT3NyYCjAalJLrSsPpBGXOOhNb54c2OdJAKyDT/7wxe
        F+QdUTxqdyfrgsbjXBCVEpKXovcldvbOly+yrT6CcQ==
X-Google-Smtp-Source: ABdhPJxBmySrnWZ/vg0O8Qkfho1wlcFSgXK2V4Ud9uDDW6ULyimn6/qyiCiMbqfas5SmTbq1t+NM1VoYsO4dC2dF+00=
X-Received: by 2002:a05:6402:5107:: with SMTP id m7mr9901048edd.52.1613750917592;
 Fri, 19 Feb 2021 08:08:37 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 19 Feb 2021 21:38:26 +0530
Message-ID: <CA+G9fYt1Bk=DW1VoPgWe9ZHHoHu+6OyZi7ndMJHmoR14uJePyQ@mail.gmail.com>
Subject: [next]: fs/io_uring.c:6171:10: error: implicit declaration of
 function 'io_sendmsg_prep_async'; did you mean 'io_req_prep_async'?
To:     linux-mips@vger.kernel.org,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        io-uring@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Linux next tag 20210219 arm and mips builds failed due to below error.

Following build configs failed
arm (s3c6400_defconfig) with gcc-8
arm (s3c6400_defconfig) with gcc-9
arm (s3c6400_defconfig) with gcc-10

mips (e55_defconfig) with gcc-8
mips (e55_defconfig) with gcc-9
mips (e55_defconfig) with gcc-10

fs/io_uring.c:6171:10: error: implicit declaration of function
'io_sendmsg_prep_async'; did you mean 'io_req_prep_async'?
[-Werror=implicit-function-declaration]
   return io_sendmsg_prep_async(req);
          ^~~~~~~~~~~~~~~~~~~~~
          io_req_prep_async

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Steps to reproduce:
-----------------------------
# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.


tuxmake --runtime podman --target-arch arm --toolchain gcc-10
--kconfig s3c6400_defconfig
or
tuxmake --runtime podman --target-arch mips --toolchain gcc-9
--kconfig e55_defconfig


-- 
Linaro LKFT
https://lkft.linaro.org
