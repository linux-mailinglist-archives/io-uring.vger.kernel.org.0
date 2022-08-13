Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F9E591C66
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 21:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiHMTZK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Aug 2022 15:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiHMTZJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Aug 2022 15:25:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873025F97
        for <io-uring@vger.kernel.org>; Sat, 13 Aug 2022 12:25:07 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so3661556pjl.0
        for <io-uring@vger.kernel.org>; Sat, 13 Aug 2022 12:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=1pe9TrGivBV74UNvJxunaAY8DOXis3OTO0ynOvBxAKo=;
        b=vRrdQnTAEW4SwJpKJYDUEvDoM2NJ6eMgNYT2HOyPKfgYSQFay/5nVvssKUoUP6oRtW
         bUHSdGhpV+iI7/BY9FG7C/6MMvVBuJdJDcqFX1BH9fOifAPRzzv3g0idVM6i6+GSJSFP
         h8+l7OUl1wHNLCiPjWiidYreudiOTip8eE9fBAN5tZ7CGk4cESeNfBtPnQTfHDQjuiiO
         9mGAw7tTG7lvzqyXgIo+l8D/uJm3Kq39H+USmZLaKSlPAnwXOXU9jXKGVsV5SkjMDZL4
         41VHb4HCOtiSNkxZRR0ZWIvIbFoF0nTfzYELozjFf7W0lQruAaGYVKqT8Rm8jXTZehDz
         u3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=1pe9TrGivBV74UNvJxunaAY8DOXis3OTO0ynOvBxAKo=;
        b=mjTqQVoSUowfjR0QMiNNrRZtzJaKmxZOKP5ZqgcIvXqoNAgLJa53zQ39/W8VHvcvfV
         XZdgnO/+qgWQMU6CJHQBbIHyETlGe+wVcbPia1vsA0ex9jeDWhFDGVvbwvRvNBayKzo3
         wnkz5plwB+7Wa18Qir55bUyGtFsNwKKKqHfiVCmU4G0AbpqAd1+5hVfxryzglq4TNsKr
         YqQZIYarnLB4v3l83bbEiuwYwQ57Yafk17HbxlNc85BwhI+lJMd1OKpI5r+DWC1A8GOS
         exNCdA+PPULApLUC1vjhHw41lJ72iC8oLBaC3gRJMD+yRYEwypnkpb4P11ocwgnnMiRX
         Ge7Q==
X-Gm-Message-State: ACgBeo2JWbWOKZalC32w54R7Ld03HPteiWqO7Fu4WaSvwnQl0DN8pkhB
        pucTHnjJs4RH5P28Z5sbNQDK+6Onrcx0iA==
X-Google-Smtp-Source: AA6agR4pbfT6O0JAn2GVRhaxt/aMZQuBKbltLiZIAF8L7/0pekIGMS3bvi7RZl2AsQX6VygBLV5e/g==
X-Received: by 2002:a17:902:dac5:b0:16f:63c:3e91 with SMTP id q5-20020a170902dac500b0016f063c3e91mr9154175plx.169.1660418706874;
        Sat, 13 Aug 2022 12:25:06 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y11-20020aa78f2b000000b0052e988c1630sm3901427pfr.138.2022.08.13.12.25.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Aug 2022 12:25:06 -0700 (PDT)
Message-ID: <12ca64e0-f78d-4da4-7103-17218ce8e20f@kernel.dk>
Date:   Sat, 13 Aug 2022 13:25:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL v2] io_uring fixes for 6.0-rc1
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

A few fixes that should go upstream before 6.0-rc1. Same as the one from
yesterday, but this time adding the kiocb randomization patch before the
patch that verifies the io_uring command sizing. In detail:

- Regression fix for this merge window, fixing a wrong order of
  arguments for io_req_set_res() for passthru (Dylan)

- Fix for the audit code leaking context memory (Peilin)

- Ensure that provided buffers are memcg accounted (Pavel)

- Correctly handle short zero-copy sends (Pavel)

- Sparse warning fixes for the recvmsg multishot command (Dylan)

- Error handling fix for passthru (Anuj)

- Remove randomization of struct kiocb fields, to avoid it growing
  in size if re-arranged in such a fashion that it grows more holes
  or padding (Keith, Linus)

- Small series improving type safety of the sqe fields (Stefan)

Please pull!


The following changes since commit e2b542100719a93f8cdf6d90185410d38a57a4c1:

  Merge tag 'flexible-array-transformations-UAPI-6.0-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux (2022-08-02 19:50:47 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-08-13

for you to fetch changes up to 9c71d39aa0f40d4e6bfe14958045a42c722bd327:

  io_uring: add missing BUILD_BUG_ON() checks for new io_uring_sqe fields (2022-08-12 17:01:00 -0600)

----------------------------------------------------------------
io_uring-6.0-2022-08-13

----------------------------------------------------------------
Anuj Gupta (1):
      io_uring: fix error handling for io_uring_cmd

Dylan Yudaken (1):
      io_uring: fix io_recvmsg_prep_multishot sparse warnings

Keith Busch (1):
      fs: don't randomize struct kiocb fields

Ming Lei (1):
      io_uring: pass correct parameters to io_req_set_res

Pavel Begunkov (2):
      io_uring: mem-account pbuf buckets
      io_uring/net: send retry for zerocopy

Peilin Ye (1):
      audit, io_uring, io-wq: Fix memory leak in io_sq_thread() and io_wqe_worker()

Stefan Metzmacher (3):
      io_uring: consistently make use of io_notif_to_data()
      io_uring: make io_kiocb_to_cmd() typesafe
      io_uring: add missing BUILD_BUG_ON() checks for new io_uring_sqe fields

 include/linux/audit.h          |  5 ----
 include/linux/fs.h             |  5 ----
 include/linux/io_uring_types.h |  9 +++++-
 io_uring/advise.c              |  8 ++---
 io_uring/cancel.c              |  4 +--
 io_uring/epoll.c               |  4 +--
 io_uring/fs.c                  | 28 +++++++++---------
 io_uring/io-wq.c               |  3 --
 io_uring/io_uring.c            | 19 ++++++++++--
 io_uring/kbuf.c                | 10 +++----
 io_uring/msg_ring.c            |  8 ++---
 io_uring/net.c                 | 66 +++++++++++++++++++++++++-----------------
 io_uring/notif.c               |  4 +--
 io_uring/notif.h               |  2 +-
 io_uring/openclose.c           | 16 +++++-----
 io_uring/poll.c                | 16 +++++-----
 io_uring/rsrc.c                | 10 +++----
 io_uring/rw.c                  | 28 +++++++++---------
 io_uring/splice.c              |  8 ++---
 io_uring/sqpoll.c              |  4 ---
 io_uring/statx.c               |  6 ++--
 io_uring/sync.c                | 12 ++++----
 io_uring/timeout.c             | 26 ++++++++---------
 io_uring/uring_cmd.c           | 17 +++++++----
 io_uring/xattr.c               | 18 ++++++------
 kernel/auditsc.c               | 25 ----------------
 26 files changed, 178 insertions(+), 183 deletions(-)

-- 
Jens Axboe

