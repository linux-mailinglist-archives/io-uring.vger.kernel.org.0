Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305715A2C68
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 18:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241806AbiHZQgn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 12:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243915AbiHZQgm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 12:36:42 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59391BA9F6
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 09:36:40 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id h78so1559941iof.13
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 09:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=WV/E6O5Y9diFqiB3emBCf2qeCzPSUYOuQ4oXC52V5ts=;
        b=c4MKpmAEQ72Wn5r+oIaDxXIvk8N7syD3Cgwjc4GtJMg/v5gLLJ86yodwl1r/bZgpue
         zsM1/ybR2J7wWgkdf7bqJTEfrWoFsT/P+17JFDVBWr5YuELErZ9iVeu7TSUJKgnGNSi1
         TOFOanqmUQEIBSexBEmOqAjKrEfba/8ckl0Fddg4MPUlZLKj22RcvivDQ5SsafgHOac8
         rxFSZ5jri0I2CZeMjHECFRaG3DUAJthO37i2NIWnYvNWRUizScChJZ1dU0pGlcRQ7yTa
         2G1fIa8pai3JYLBqb4IJiQkBAXVDCxGr7CIeUJRwtQNndFP2Iy0xOg1SL7ozQkWCuzFA
         sqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=WV/E6O5Y9diFqiB3emBCf2qeCzPSUYOuQ4oXC52V5ts=;
        b=PRp41yjwlN8UZOMobiR+1lJca5kNECXz6lxVr5+tRFN+In0y/2F88GeyWN6f8yDPq7
         P2OE8j4AsdCnuiHlAwg947lg964hjXWUceyUDWij8FNUWtTizMYVdsOPHFoEq0KMpkbH
         JnW5DmwA6lzas/vA6NIjUtRyAzOfeXkekhpOD8uXhMXnsiwNAn0LkV/i7hVFr2oRXQ5e
         wMWnSkUoIpU2uFLgv4ee5JmMl1BIrySJPO0z6YuLGYIDA8k7CfCd/992cQphFkM9OHSE
         B2VZ903QwApLK7ZK5Cxr7gZsSdx/4SGjpken+Baz7to01k3yBizXwUZQxVc3C38+f+rC
         nI1w==
X-Gm-Message-State: ACgBeo1yK2KJcn/VsVPqvvPOxiDTMm7aQai3JjTl9/f2VLlQnmP2Ca1P
        Q3x4bAr3zPOIQON5+SYGGD68P3XSpJoeHA==
X-Google-Smtp-Source: AA6agR7y/QvAF1wCBvH+JJ74RUhYtezeGWsRZ2IRf4fKGKlSadTNX5tky6l0DnS8PVbBjobKLB1efg==
X-Received: by 2002:a05:6602:2d0d:b0:689:8260:e11d with SMTP id c13-20020a0566022d0d00b006898260e11dmr4019945iow.153.1661531799692;
        Fri, 26 Aug 2022 09:36:39 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l43-20020a026a2b000000b00349f2783ab3sm1100157jac.34.2022.08.26.09.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 09:36:38 -0700 (PDT)
Message-ID: <ac58b020-5e09-0bbb-0a63-423faf9bcf5d@kernel.dk>
Date:   Fri, 26 Aug 2022 10:36:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.0-rc3
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

Set of fixes for io_uring that should go into this release:

- Add missing header file to the MAINTAINERS entry for io_uring (Ammar)

- liburing and the kernel ship the same io_uring.h header, but one
  change we've had for a long time only in liburing is to ensure it's
  C++ safe. Add extern C around it, so we can more easily sync them in
  the future (Ammar)

- Fix an off-by-one in the sync cancel added in this merge window (me)

- Error handling fix for passthrough (Kanchan)

- Fix for address saving for async execution for the zc tx support
  (Pavel)

- Fix ordering for TCP zc notifications, so we always have them ordered
  correctly between "data was sent" and "data was acked". This isn't
  strictly needed with the notification slots, but we've been pondering
  disabling the slot support for 6.0 - and if we do, then we do require
  the ordering to be sane. Regardless of that, it's the sane thing to do
  in terms of API (Pavel)

- Minor cleanup for indentation and lockdep annotation (Pavel)

Please pull!


The following changes since commit 3f743e9bbb8fe20f4c477e4bf6341c4187a4a264:

  io_uring/net: use right helpers for async_data (2022-08-18 07:27:20 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-08-26

for you to fetch changes up to 581711c46612c1fd7f98960f9ad53f04fdb89853:

  io_uring/net: save address for sendzc async execution (2022-08-25 07:52:30 -0600)

----------------------------------------------------------------
io_uring-6.0-2022-08-26

----------------------------------------------------------------
Ammar Faizi (2):
      MAINTAINERS: Add `include/linux/io_uring_types.h`
      io_uring: uapi: Add `extern "C"` in io_uring.h for liburing

Jens Axboe (1):
      io_uring: fix off-by-one in sync cancelation file check

Kanchan Joshi (1):
      io_uring: fix submission-failure handling for uring-cmd

Pavel Begunkov (6):
      io_uring/net: fix must_hold annotation
      io_uring/net: fix zc send link failing
      io_uring/net: fix indentation
      io_uring/notif: order notif vs send CQEs
      io_uring: conditional ->async_data allocation
      io_uring/net: save address for sendzc async execution

 MAINTAINERS                   |  1 +
 include/uapi/linux/io_uring.h |  8 +++++++
 io_uring/cancel.c             |  2 +-
 io_uring/io_uring.c           |  7 +++---
 io_uring/net.c                | 56 ++++++++++++++++++++++++++++++++++++-------
 io_uring/net.h                |  1 +
 io_uring/notif.c              |  8 ++++---
 io_uring/opdef.c              |  4 +++-
 io_uring/opdef.h              |  2 ++
 io_uring/uring_cmd.c          |  2 +-
 10 files changed, 74 insertions(+), 17 deletions(-)

-- 
Jens Axboe
