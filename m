Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9888637D9A
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 17:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiKXQ3Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 11:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKXQ3P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 11:29:15 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876B316FB29
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 08:29:14 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 2093B81725;
        Thu, 24 Nov 2022 16:29:09 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669307353;
        bh=xUoq7jSYmhCi5dD6XeBErKJG85TRqcqSzPvRBo89GyI=;
        h=From:To:Cc:Subject:Date:From;
        b=cAAU79bEdDApRpb7CWFJXFZqscrNgD470/SlYJKgsZl68fYBE4w3b+XJt0oRRRs2e
         CYHrl57RXWlGi9JmX4MDQijjs4HH0kj7dlpCRQaZaHLqgz6f/iYiempvHTgvYAAPAU
         qTFsKdUnaRkvxR7HeZwDoB7aV0Cb75P7VQzL6Mo8xVVrIrBn27l23UGwBxjWs5XZBz
         zqIX8J4eXg5vlXL8QehWTjdqG8JRBNVrlLTJcysMj7qdH/TbjD4T48aH/3akq5w7bV
         SfDQb8Tn7UgUKmKmbuICToSagF3nzd2gl2iWZemX8kLvhzW4ZnP2SN+BWShpMuvwV3
         n7/y+xA0Jq70w==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 0/8] Ensure we mark non-exported functions and variables as static
Date:   Thu, 24 Nov 2022 23:28:53 +0700
Message-Id: <20221124162633.3856761-1-ammar.faizi@intel.com>
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

This is a v2 revision.

This series is a -Wmissing-prototypes enforcement. -Wmissing-prototypes
is a clang C compiler flag that warns us if we have functions or
variables that are not used outisde the translation unit, but not marked
as static.

There are 8 patches in this series:

- Patch #1, is just a typo cleanup.
- Patch #2, core library change, mark __io_uring_flush_sq() as static.
- Patch #3 to patch #7 are the cleanup preparation for
  -Wmissing-prototypes enforcement.
- Patch #8 is to enforce -Wmissing-prototypes on the GitHub CI robot.

This series has been build-tested each patch with the GitHub CI robot
and no breakage is found.

## Changelog

v2:
  - Add a new patch #1, fix typo.
  - Don't export __io_uring_flush_sq(). Instead, make a copy of this
    function in test/helpers.c.
  - Massage the commit message.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (8):
  queue: Fix typo "entererd" -> "entered"
  queue: Mark `__io_uring_flush_sq()` as static
  test/io_uring_setup: Remove unused functions
  ucontext-cp: Remove an unused function
  tests: Mark non-exported functions as static
  ucontext-cp: Mark a non-exported function as static
  test/Makefile: Omit `-Wmissing-prototypes` from the C++ compiler flags
  github: Add `-Wmissing-prototypes` for GitHub CI bot

 .github/workflows/build.yml |  7 ++--
 examples/ucontext-cp.c      | 19 +--------
 src/queue.c                 |  4 +-
 test/Makefile               | 11 ++++-
 test/accept-link.c          |  2 +-
 test/accept-reuse.c         |  9 ++--
 test/ce593a6c480a.c         |  4 +-
 test/defer-taskrun.c        |  2 +-
 test/exit-no-cleanup.c      |  2 +-
 test/hardlink.c             |  2 +-
 test/helpers.c              | 33 +++++++++++++++
 test/helpers.h              |  2 +
 test/io_uring_passthrough.c |  2 -
 test/io_uring_setup.c       | 83 ++-----------------------------------
 test/iopoll.c               |  2 -
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
 26 files changed, 101 insertions(+), 142 deletions(-)


base-commit: 636b6bdaa8d84f1b5318e27d1e4ffa86361ae66d
-- 
Ammar Faizi

