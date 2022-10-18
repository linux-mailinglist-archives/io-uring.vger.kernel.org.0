Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209E26032B9
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 20:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiJRSsw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Oct 2022 14:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiJRSsv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 14:48:51 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B18A2871;
        Tue, 18 Oct 2022 11:48:43 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id m15so21827015edb.13;
        Tue, 18 Oct 2022 11:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2EgRk0P81xPzL9qww2eLXeNWcb1EWchmGlnBKdouweE=;
        b=K/lo4kdx8fLgnv+KP45qob3AoybmziJgIjiw3Jn7PFCi1EUZg9G8YTRNSj6YTZ+lbQ
         I9eHW7u5Xy+tn3KH/VQZv5iZNP+E3WEC0iW76wU5uie7xTyucvIM5qjHQvogLDNot8l2
         QfskDVyp5niBpeczzIcTgg/QmVRNX34Wn233XRc2xRceaPohx+E66Wh2SiToJA3fYpGx
         jjZG3tv69n/j4QZsq7md5U3eV9er2pDWO+Wodl9XcUkBm43//1GDiE1TS+S6ACrfFSCY
         FneWgW284AH9RScE7ZA6/zcaFZXEsFRpC9FbP5Iew2EWXGsTHMVtd2VjOj/67g2qRmhf
         55Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2EgRk0P81xPzL9qww2eLXeNWcb1EWchmGlnBKdouweE=;
        b=vf5Lg6P1rlwtN3ESBzgmXvh2FGoZROC5xrJ9Dx4l04WtwtflG36GPZfnjoyTJ02d6w
         AX0bgJNI/9xzoPrM2vQg2HvmQZzpeC2VdJ71HRmYVsazU3IgySBNDlbUn5+v2gwiOXZJ
         Er+4JO20CLzGbXE0Qp9kr3ijs057X1UM8zc2/5FMW2kHFIvfFyiiAFe9nevZnc6MiUO6
         HJOK+upY8oF3O8eKNOC+0ml4dpSrRFq4arvP350KkFZG69n+h36n7Bo403Ee/67mJjqI
         eiSpIHw6ydW4lX02OVuCN5qVem9f2a1G9jAlrcKcU1E5G6R6q0SZofCK66nOtQ4/Uroj
         lXng==
X-Gm-Message-State: ACrzQf3sH+MrT2sVoBozqC9cz28QKtNa+t6q8+fI+BnWQVJT5IyJynnT
        6UmY6A3ksqeUOS4RX62yGpmKuSZQRjo=
X-Google-Smtp-Source: AMsMyM42VftfztXwTkzBTqeAltrf8oNmfPM0JmYRnJKypdJcCiTBVibgtdK1Gc/ixK2zeEnLMKJfHg==
X-Received: by 2002:aa7:cb49:0:b0:45c:7613:661b with SMTP id w9-20020aa7cb49000000b0045c7613661bmr3810197edt.273.1666118921952;
        Tue, 18 Oct 2022 11:48:41 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id j18-20020a17090623f200b0078db18d7972sm7855355ejg.117.2022.10.18.11.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 11:48:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC for-next 0/4] enable pcpu bio caching for IRQ I/O
Date:   Tue, 18 Oct 2022 19:47:12 +0100
Message-Id: <cover.1666114003.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series implements bio pcpu caching for normal / IRQ-driven I/O
extending REQ_ALLOC_CACHE currently limited to iopoll. The allocation side
still only works from non-irq context, which is the reason it's not enabled
by default, but turning it on for other users (e.g. filesystems) is
as a matter of passing a flag.

t/io_uring with an Optane SSD setup showed +7% for batches of 32 requests
and +4.3% for batches of 8.

IRQ, 128/32/32, cache off
IOPS=59.08M, BW=28.84GiB/s, IOS/call=31/31
IOPS=59.30M, BW=28.96GiB/s, IOS/call=32/32
IOPS=59.97M, BW=29.28GiB/s, IOS/call=31/31
IOPS=59.92M, BW=29.26GiB/s, IOS/call=32/32
IOPS=59.81M, BW=29.20GiB/s, IOS/call=32/31

IRQ, 128/32/32, cache on
IOPS=64.05M, BW=31.27GiB/s, IOS/call=32/31
IOPS=64.22M, BW=31.36GiB/s, IOS/call=32/32
IOPS=64.04M, BW=31.27GiB/s, IOS/call=31/31
IOPS=63.16M, BW=30.84GiB/s, IOS/call=32/32

IRQ, 32/8/8, cache off
IOPS=50.60M, BW=24.71GiB/s, IOS/call=7/8
IOPS=50.22M, BW=24.52GiB/s, IOS/call=8/7
IOPS=49.54M, BW=24.19GiB/s, IOS/call=8/8
IOPS=50.07M, BW=24.45GiB/s, IOS/call=7/7
IOPS=50.46M, BW=24.64GiB/s, IOS/call=8/8

IRQ, 32/8/8, cache on
IOPS=51.39M, BW=25.09GiB/s, IOS/call=8/7
IOPS=52.52M, BW=25.64GiB/s, IOS/call=7/8
IOPS=52.57M, BW=25.67GiB/s, IOS/call=8/8
IOPS=52.58M, BW=25.67GiB/s, IOS/call=8/7
IOPS=52.61M, BW=25.69GiB/s, IOS/call=8/8

The main part is in patch 3. Would be great to take patch 1 separately
for 6.1 for extra safety.

Pavel Begunkov (4):
  bio: safeguard REQ_ALLOC_CACHE bio put
  bio: split pcpu cache part of bio_put into a helper
  block/bio: add pcpu caching for non-polling bio_put
  io_uring/rw: enable bio caches for IRQ rw

 block/bio.c   | 92 +++++++++++++++++++++++++++++++++++++++------------
 io_uring/rw.c |  3 +-
 2 files changed, 73 insertions(+), 22 deletions(-)

-- 
2.38.0

