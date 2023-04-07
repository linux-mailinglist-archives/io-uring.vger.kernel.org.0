Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8386DB0DA
	for <lists+io-uring@lfdr.de>; Fri,  7 Apr 2023 18:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjDGQsR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Apr 2023 12:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDGQsQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Apr 2023 12:48:16 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3160955AE
        for <io-uring@vger.kernel.org>; Fri,  7 Apr 2023 09:48:15 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-325f7b5cbacso404265ab.0
        for <io-uring@vger.kernel.org>; Fri, 07 Apr 2023 09:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680886094; x=1683478094;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ytz634BJanb9pscrY7J8UBoLFPmiGioTWad1WzELkkk=;
        b=aEpzUejpfp+g1+IsjHkOkwD+EiEfk/argqKFr24ZWw6bz6c9Q9RQMBsIFc5ybDRftb
         lCVDcetyPtsonDuhq8766kshOfiDhKTz+MAswj5O9UW/JJtmGZbiRiUHfjJZXYSPx/XT
         bJYvBypYovVWKuxETENuHssa5ZBdCu1G8TRTi/uohWRtJBbV84MSlCUkKBOJbUU+JJ7a
         S7sAlIOw94ZJmBZ77VwFR6bmI+FTe+JjrPoh9bROOSnrdHALGyLenQvw1TZub0Nu4y1q
         bzuI2EogBfeTp7xtZMhBkBfiq3qSIRyOu+7QVm6EkbVzEBwcbMiWEhVFMif1WaK1nfU0
         3JJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680886094; x=1683478094;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ytz634BJanb9pscrY7J8UBoLFPmiGioTWad1WzELkkk=;
        b=x1q7hGwtq2avsakWGN0IJSzFOiA+6drKRC8OpSE+y12HqvunFufB//QznEhsSVTl7m
         d1GS8mREaQSPrLQ1xwUKJwA9p4jasKQd5d3R1oR47Lh3JnX7BdzVTF5pxM1K8aAhnt9U
         uDXiesJ4jI/PBYvxPK1yHfr3YWXAwE3YXQWYft7fDv6RVhDlxE76MYwrs1a/8Zs0nzzt
         6MH4daik9zTucjHz78gcZSun1axahEhz5VqxO9EwooQ5HRZOMjNRNxHnSwX/xzHIM6N2
         L7/E0GiyEO+i/Auny/vmPOA+CX2Xn9w1D7j5iHXUbZn463Egmj9V1L4kWwLISDd3swbN
         8lew==
X-Gm-Message-State: AAQBX9cYjsn0/TdoGNhNMUQd9DPscMjBD2u031CqfkBs99mFGPLhkGEw
        9xyMghqBodo2G/AGMvjsC7id5ROP02z4CtYYW18gcg==
X-Google-Smtp-Source: AKy350a9qu5MGhBa+3RkLYr3hIKcOUXQ7EkY632uuGl9+GyiVAYyUCwBoV2dqB2LXJOS5uqY5Z3vIA==
X-Received: by 2002:a92:3612:0:b0:325:e639:76aa with SMTP id d18-20020a923612000000b00325e63976aamr1332219ila.1.1680886094442;
        Fri, 07 Apr 2023 09:48:14 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id bs23-20020a056638451700b0040b1ecc3ec4sm1206963jab.11.2023.04.07.09.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 09:48:13 -0700 (PDT)
Message-ID: <07df0b3d-4086-d2a4-efa8-0229579726fa@kernel.dk>
Date:   Fri, 7 Apr 2023 10:48:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.3-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Just two minor fixes for provided buffers - one where we could
potentially leak a buffer, and one where the returned values was
off-by-one in some cases.

Please pull!


The following changes since commit fd30d1cdcc4ff405fc54765edf2e11b03f2ed4f3:

  io_uring: fix poll/netmsg alloc caches (2023-03-30 06:53:42 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-04-06

for you to fetch changes up to b4a72c0589fdea6259720375426179888969d6a2:

  io_uring: fix memory leak when removing provided buffers (2023-04-01 16:52:12 -0600)

----------------------------------------------------------------
io_uring-6.3-2023-04-06

----------------------------------------------------------------
Wojciech Lukowicz (2):
      io_uring: fix return value when removing provided buffers
      io_uring: fix memory leak when removing provided buffers

 io_uring/io_uring.c | 2 +-
 io_uring/kbuf.c     | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

-- 
Jens Axboe

