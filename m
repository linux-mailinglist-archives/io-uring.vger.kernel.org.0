Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F3F2DC995
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 00:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730789AbgLPXaO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 18:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730518AbgLPXaN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 18:30:13 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E364C06179C
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 15:29:33 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id q16so26696785edv.10
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 15:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=oHW20Y04wvGVk9UmyRRlDNomzN5I2m9VJ+tYDy3fSD0=;
        b=uahCANzXwA5aCIUV6du8D8u6wNGaEy7y9ykhpmdKEcXYF11CilccpIgDGEdpo3gDev
         1N/k435DAd3SBeFjdznGM3iO3j4rMGhaRkTTRuWHb7Kw82JlJDOFzQ87kn4OrrUb3el4
         LgqZ7KhFPoAvKDRZf6L72NIua03MMQeIut7Vtb2MRck0p+eKvMLUFoG5aTudi825ssJm
         OvVulup8uximjKksGN9xl2bXbmdmiP6gwV7G3s/sOzcAGU3jSGcEbw375s+gnFle4UOO
         zE+rJthMK9IW0RuFoelWkbyzBORcgLQXB3JxbEcZR6j42R/CpKp/qYx7/yHPRU2WKfHn
         X7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=oHW20Y04wvGVk9UmyRRlDNomzN5I2m9VJ+tYDy3fSD0=;
        b=ESMansAly0m30SmT6dIoK2ErNv/G8Mj3aKahYK3O7ppmWPV3gnENead+/IrSug0fHH
         kCZo/keZ/s2eOxiHfTThCE1q7Y/hqs2mA3iMUY2utRtxFOGrBHdapCjFSY5XvIgztMMr
         /6Ya4sihRul7RJ+QOpb1DtIUfGLkCfkWjlNeBHjK3zBdKlZFdbkVj/7zfYDApkPwAOjF
         O8K2e11E4AKZKRXqpV67ZsiXNn4igwd48tjfO/Pa/3+9/BWPZSbxbn1NAHsM6a3X9pII
         OuwO9o9qo1B29p5yGx7ulHvw5O0vRn4Z1/0b2w6GRKIjJwVvJzQJOFV23pDZWMJBCsAK
         DeQA==
X-Gm-Message-State: AOAM533VTQwss+ubV+ehXk0WTeGliC9OfCv9qFwndvT+ZelE+jCuShCq
        70N2yegDJdIvOIowpWXEPJr+4z9EIqyaQnBr1XfuFU2XmsHKNOvSWd8=
X-Google-Smtp-Source: ABdhPJx0xf/MWmTSvAGM/6rUZqnEOQ282USilJvvQmN0mTdbfyXnWaE8k+maUbAKIG/VOIzjhVa1YVkAW7Xxsw41rc8=
X-Received: by 2002:a05:6402:1592:: with SMTP id c18mr35556563edv.181.1608161371798;
 Wed, 16 Dec 2020 15:29:31 -0800 (PST)
MIME-Version: 1.0
References: <20201216180313.46610-2-v@nametag.social> <202012170740.EgQPKuIj-lkp@intel.com>
In-Reply-To: <202012170740.EgQPKuIj-lkp@intel.com>
From:   Victor Stewart <v@nametag.social>
Date:   Wed, 16 Dec 2020 23:29:20 +0000
Message-ID: <CAM1kxwiL4dD=X18_Crd813nyt_UWpPP8XmwUf10JZhzV7221Yw@mail.gmail.com>
Subject: Re: [PATCH net-next v4] udp:allow UDP cmsghdrs through io_uring
To:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>, Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

what's to be done about this kernel test robot output, if anything?

On Wed, Dec 16, 2020 at 11:12 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Victor,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Victor-Stewart/udp-allow-UDP-cmsghdrs-through-io_uring/20201217-020451
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9
> config: riscv-randconfig-r031-20201216 (attached as .config)
> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project 71601d2ac9954cb59c443cb3ae442cb106df35d4)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install riscv cross compiling tool for clang build
>         # apt-get install binutils-riscv64-linux-gnu
>         # https://github.com/0day-ci/linux/commit/6cce2a0155c3ee2a1550cb3d5e434cc85f055a60
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Victor-Stewart/udp-allow-UDP-cmsghdrs-through-io_uring/20201217-020451
>         git checkout 6cce2a0155c3ee2a1550cb3d5e434cc85f055a60
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=riscv
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    /tmp/leds-blinkm-655475.s: Assembler messages:
> >> /tmp/leds-blinkm-655475.s:590: Error: unrecognized opcode `zext.b s7,a0'
> >> /tmp/leds-blinkm-655475.s:614: Error: unrecognized opcode `zext.b a0,a0'
> >> /tmp/leds-blinkm-655475.s:667: Error: unrecognized opcode `zext.b a2,s2'
>    /tmp/leds-blinkm-655475.s:750: Error: unrecognized opcode `zext.b a2,s2'
>    /tmp/leds-blinkm-655475.s:833: Error: unrecognized opcode `zext.b a2,s2'
>    clang-12: error: assembler command failed with exit code 1 (use -v to see invocation)
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
