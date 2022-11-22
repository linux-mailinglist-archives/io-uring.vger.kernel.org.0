Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6671A633AB6
	for <lists+io-uring@lfdr.de>; Tue, 22 Nov 2022 12:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiKVLDR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Nov 2022 06:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiKVLDO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Nov 2022 06:03:14 -0500
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE71515810;
        Tue, 22 Nov 2022 03:03:12 -0800 (PST)
Received: by mail-qk1-f178.google.com with SMTP id i9so422807qkl.5;
        Tue, 22 Nov 2022 03:03:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=70ARIUnRx9Xu999wkVwCnI7RfU9fwwzEFy/tAdBx9cM=;
        b=HwwrfgTownnhf/qEKM+b/+d9abMnOIbT8w3B4EMDy+9xcjLqBPIeU/KzLrmNqy5h2g
         28+1CvgdHrhM8NHFXRtdQdGjVhVvCSGaRFyOmhSrPBxk+p+Y4JouCHDBbSoRIGGa+ArV
         5boSdWqWAA0ea5+DJ/wwBXtcWp6MJASvTuupO3zczM24BKP3+jo9f7ixH/hgt8EdGRHX
         I13H4vOCFjrFNbknPdomjQ3yXF8cw3lD1AnSQoNWhwyYcyJ7xn6qG7Ku2RhC9RpE7ANi
         xUmRydCfMmWd4aLgSqKyuzdlLIG7ZFU7q9D++gnNflr0rfK+BlI5YmznEW341JHaG7kS
         M4eQ==
X-Gm-Message-State: ANoB5pk1p07UIlMB7amarMApMXEWzbuld3uVr1LBWXiuiiVhzQOYqEjo
        udaiKRZExXb7hLkJV1uzjD4WfMdZVyblSg==
X-Google-Smtp-Source: AA0mqf4QjLRh7tFydPXRZ4rW6IO6uQwPQlLVuubqBSvfHiZaMNvcHP8SiCm99AlAlY88Nhx76qGTvA==
X-Received: by 2002:a05:620a:c0f:b0:6ef:1a88:fae5 with SMTP id l15-20020a05620a0c0f00b006ef1a88fae5mr5134200qki.329.1669114991453;
        Tue, 22 Nov 2022 03:03:11 -0800 (PST)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com. [209.85.128.171])
        by smtp.gmail.com with ESMTPSA id k18-20020a05620a415200b006e54251993esm10088322qko.97.2022.11.22.03.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 03:03:11 -0800 (PST)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-398cff43344so91043097b3.0;
        Tue, 22 Nov 2022 03:03:11 -0800 (PST)
X-Received: by 2002:a05:690c:b01:b0:370:202b:f085 with SMTP id
 cj1-20020a05690c0b0100b00370202bf085mr21324954ywb.502.1669114990799; Tue, 22
 Nov 2022 03:03:10 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYv-DpXNR846B0-K9wsDJVZVYE3KwioUYYLMd_Ts=gP-3w@mail.gmail.com>
In-Reply-To: <CA+G9fYv-DpXNR846B0-K9wsDJVZVYE3KwioUYYLMd_Ts=gP-3w@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 22 Nov 2022 12:02:59 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVSSdshxASS7-5rrstAcmA7gHb5zHETxj6q6L2mKQO5VQ@mail.gmail.com>
Message-ID: <CAMuHMdVSSdshxASS7-5rrstAcmA7gHb5zHETxj6q6L2mKQO5VQ@mail.gmail.com>
Subject: Re: next: mips: gcc-12-bcm63xx_defconfig failed
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-mips@vger.kernel.org, lkft-triage@lists.linaro.org,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 22, 2022 at 9:59 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
> Today's Linux next 20221122 tag mips bcm63xx_defconfig build fails,
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/build ARCH=mips
> CROSS_COMPILE=mips-linux-gnu- 'CC=sccache mips-linux-gnu-gcc'
> 'HOSTCC=sccache gcc'
> io_uring/io_uring.c: In function 'io_eventfd_ops':
> io_uring/io_uring.c:498:17: error: implicit declaration of function
> 'eventfd_signal_mask'; did you mean 'eventfd_signal'?
> [-Werror=implicit-function-declaration]
>   498 |                 eventfd_signal_mask(ev_fd->cq_ev_fd, 1,
> EPOLL_URING_WAKE);
>       |                 ^~~~~~~~~~~~~~~~~~~
>       |                 eventfd_signal
> cc1: some warnings being treated as errors
> make[3]: *** [scripts/Makefile.build:252: io_uring/io_uring.o] Error 1
>
> log:
> https://builds.tuxbuild.com/2HtTq82BIEEuUvHRpsnQuSFdite/
>
> Build history:
> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20221122/testrun/13121877/suite/build/test/gcc-12-bcm63xx_defconfig/history/

noreply@ellerman.id.au reported a similar failure for m5272c3_defconfig,
which I have bisected to commit 261187e66de362de ("io_uring: pass in
EPOLL_URING_WAKE for eventfd signaling and wakeups").  That patch
does not seem to have been posted to a public mailing list archived by lore?
Oh, it was, but using a different subject
https://lore.kernel.org/all/20221120172807.358868-4-axboe@kernel.dk
Difficult to track without a Links: tag...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
