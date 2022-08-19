Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8B459A30A
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 20:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351482AbiHSRu5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 13:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354884AbiHSRuV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 13:50:21 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A31422BC6
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 10:22:49 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id j20so2621187ila.6
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 10:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=Q4YiqrxthsU7OPq35C3KfsKMYPEeCPj58JyzMgasSEI=;
        b=UbzBRpnbM0RLRFChXfAHYdIjv05Cas8lTpf09NP9rDoKv+RFzs8yGe4jjiKMQ/A613
         +8QRziTBiR0rfoosjvIDjjvg35mneEktxRyUO9pDzwwqN/Kmsrf+maUv1M5ddByI61Bx
         cYEJ2p+LWms4hTGIb8In3VnvH1TUv6sRMJBbBvBLGkVOb94NdsUhK1btdNJHtXy9pY55
         Aara4SukXz810L73RE06VlziI0/8TMK9WBXHk5+2KEZR4UxEof6cn9Qb5W46VgVPMFzC
         U2fRvZ0gG1eWOyYcHfKAnoW3Rk9SBPC5im7atxexccQwtLqTv8N2WOum5bjI5mt1rQbu
         hGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=Q4YiqrxthsU7OPq35C3KfsKMYPEeCPj58JyzMgasSEI=;
        b=XSdPvXpqAECJgQiqTBCBgtMdl0nLd9y1WPiJuZgEH3C8U6BT/aEAwP9wea1cer5Dcf
         oCni1Hjn8ybSqK8Qa+kBEsdqa8N5jS5Z/YNc2Pa92CXmjTLtkjgi9YmlHpF3WqsZHiXY
         0KfyjOP6EsulwVWMUURER1kroin1ii36DRiqsf30RCgZirEc+hLOncdlbS7uez5XCNhX
         acKm1xq1W0wEFFief3mRiw3iF+IGwn8cZ5HGhhxpeyP/omqYxcjZjjTEgKYgRLxZrmC+
         6ljUKikbM9KPQhnOLp/QDq17ITTAFWZI27EoNjQzV+5APxEwqJAtME246rdhQHGVfOFQ
         ok8w==
X-Gm-Message-State: ACgBeo0KwNKPHdbBxvZtLH1QRlaoc6qsfgayw4yfSkJLKHPkuDnPJ/Qm
        6s0iI7Y3c1+rsc/q0JVLIxwwQxevvP/CUA==
X-Google-Smtp-Source: AA6agR4Gqecv+urLYyAHkYQEufFGh/2ZFaCwrnc5nFaS4vIrpDlu+O+F9qXmFUHBo0mRPItCCf1Hsg==
X-Received: by 2002:a92:d70e:0:b0:2e8:8ac8:4f3a with SMTP id m14-20020a92d70e000000b002e88ac84f3amr4211298iln.158.1660929768934;
        Fri, 19 Aug 2022 10:22:48 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j131-20020a026389000000b00342b327d709sm1966082jac.71.2022.08.19.10.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 10:22:48 -0700 (PDT)
Message-ID: <33577155-3f44-b9b7-e5df-97ae8c0163da@kernel.dk>
Date:   Fri, 19 Aug 2022 11:22:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.0-rc2
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few fixes for regressions in this cycle:

- Two instances of using the wrong "has async data" helper (Pavel)

- Fixup zero-copy address import (Pavel)

- Bump zero-copy notification slot limit (Pavel)

Please pull!


The following changes since commit 568035b01cfb107af8d2e4bd2fb9aea22cf5b868:

  Linux 6.0-rc1 (2022-08-14 15:50:18 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-08-19

for you to fetch changes up to 3f743e9bbb8fe20f4c477e4bf6341c4187a4a264:

  io_uring/net: use right helpers for async_data (2022-08-18 07:27:20 -0600)

----------------------------------------------------------------
io_uring-6.0-2022-08-19

----------------------------------------------------------------
Pavel Begunkov (4):
      io_uring/net: use right helpers for async recycle
      io_uring/net: improve zc addr import error handling
      io_uring/notif: raise limit on notification slots
      io_uring/net: use right helpers for async_data

 io_uring/net.c   | 22 +++++++++++-----------
 io_uring/notif.h |  2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

-- 
Jens Axboe
