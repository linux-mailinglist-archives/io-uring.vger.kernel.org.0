Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E4063733F
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 09:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiKXIB0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 03:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiKXIBZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 03:01:25 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D5AC6218
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 00:01:24 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id AA2078166D;
        Thu, 24 Nov 2022 08:01:20 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669276884;
        bh=ERtkqvk6tbxxYN/xhabf3FdA1VeYaViBkUA0ip8IjMI=;
        h=From:To:Cc:Subject:Date:From;
        b=o4+DoaasMmIAp+lP8E6+ImL4DmgOLUpJdLqjTDpoud8BraTA4EhYPZC6xM7hQXnYr
         H70BqqLRFZrBytKUj9wldTrbcvRVxgdeLhSqBPhCl8tqN+qHD78D8Y3ViBxp9VGjWV
         tzrfykgHmCjQmg2CG9CSrxV33PPDwxlxThmIxRDIuORKZS+TJsdylvohRJzldFUxRo
         eaNK4PIuqLiv2Kmpx6+lxEQ2/DcmaFX942SFzCb6mLj3BQEOdNi8x+MwbEHzJrEivH
         NcPwNUMaSfOi5BFmLayYtNPxlgWRbYKhXVbgOouurxlOdDJ63Mv65yhdtOyVfdNAO9
         bJnpz9B9ms2eQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>
Subject: [PATCH liburing v1 0/7] Ensure we mark internal functions and variables as static
Date:   Thu, 24 Nov 2022 15:00:55 +0700
Message-Id: <20221124075846.3784701-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Hi Jens,

This series is a -Wmissing-prototypes enforcement. -Wmissing-prototypes
is a clang C compiler flag that warns us if we have functions or
variables that are not used outisde the translation unit, but not marked
as static. This enforcement is good because it hints the compiler to do
escape analysis and optimization better.

There are 7 patches in this series.

- Patch 1 is a core library change. Export __io_uring_flush_sq().
- Patch 2 to 6 are cleanups preparation before enforcing
  -Wmissing-prototypes.
- Patch 7 is to add `-Wmissing-prototypes` for GitHub CI bot.

This series has been build tested each patch with the GitHub CI robot
and no breakage is found.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (7):
  liburing.h: Export `__io_uring_flush_sq()` function
  test/io_uring_setup: Remove unused functions
  ucontext-cp: Remove an unused function
  tests: Mark internal functions as static
  ucontext-cp: Mark internal functions as static
  test/Makefile: Omit `-Wmissing-prototypes` from the C++ compiler flags
  github: Add `-Wmissing-prototypes` for GitHub CI bot

 .github/workflows/build.yml |  7 ++--
 examples/ucontext-cp.c      | 19 +--------
 src/include/liburing.h      |  1 +
 src/liburing.map            |  5 +++
 test/Makefile               | 11 ++++-
 test/accept-link.c          |  2 +-
 test/accept-reuse.c         |  9 ++--
 test/ce593a6c480a.c         |  4 +-
 test/defer-taskrun.c        |  2 +-
 test/exit-no-cleanup.c      |  2 +-
 test/hardlink.c             |  2 +-
 test/io_uring_setup.c       | 83 ++-----------------------------------
 test/link_drain.c           |  2 +-
 test/multicqes_drain.c      | 27 +++++++-----
 test/nvme.h                 |  3 +-
 test/poll-link.c            |  2 +-
 test/poll-mshot-overflow.c  |  2 +-
 test/read-before-exit.c     |  2 +-
 test/ring-leak2.c           |  2 +-
 test/sq-poll-kthread.c      |  2 +-
 test/sqpoll-cancel-hang.c   |  2 +-
 test/symlink.c              |  3 +-
 test/timeout-new.c          | 12 ++++--
 23 files changed, 70 insertions(+), 136 deletions(-)


base-commit: b90a28636e5b5efe6dc1383acc90aec61814d9ba
-- 
Ammar Faizi

