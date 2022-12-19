Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E90650F4D
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 16:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbiLSPxd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 10:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbiLSPxB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 10:53:01 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D8213D5F
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 07:50:27 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.89])
        by gnuweeb.org (Postfix) with ESMTPSA id 6988181907;
        Mon, 19 Dec 2022 15:50:24 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1671465026;
        bh=XGxAYIBnwKofd+fMIWTzJRh1x5SnyW9LPHDEdsO5uok=;
        h=From:To:Cc:Subject:Date:From;
        b=X/Ztbw/Or0NmUpXM7Y1dewIbt48w7tyYmpVvGr3hgZfPs2IHJ8VGlFuqYvpYA93xU
         wkcwRiFgbOuUlg5JyGot9dixvWCYaYKtvyjiFMcThTFtmFcem8BATb3pINJInyPekN
         bkBJq4mvaBbqLuID6BO2pJvidpwRaQ0K1Gpn44JhpjkjcnAc+XUEYa6DHkKrA+kU9Y
         luQPf82Vv3LRJ9xmOyqkS6mGlOQwxJTktpJleS3l43l5RQUTrZzqkImq3iiws6TGeR
         TV3aeq9u2Je4w9tgsl0SWv0a6UMv5v2sVA9XTlWAV3h8QZ1WdU9ap4nghUAsBvY6e1
         kJyw9jqRU5O/A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v1 0/8] liburing updates
Date:   Mon, 19 Dec 2022 22:49:52 +0700
Message-Id: <20221219155000.2412524-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

liburing updates, there are 8 patches in this series:

  - Patch #1 is to add a missing SPDX-License-Idetifier.
  - Patch #2 is a Makefile warning fix due to the recent liburing
    version check feature.
  - Patch #3 to #6 are a preparation patch to make the clang build
    stricter.
  - Patch #7 is to apply extra clang flags to the GitHub bot CI.
  - Patch #8 is the CHANGELOG file update.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (8):
  ffi: Add SPDX-License-Idetifier
  Makefile: Add a '+' char to silence a Makefile warning
  tests: Fix `-Wstrict-prototypes` warnings from Clang
  test/ring-leak: Remove a "break" statement in a "for loop"
  tests: Fix clang `-Wunreachable-code` warning
  tests: Declare internal variables as static
  github: Add more extra flags for clang build
  CHANGELOG: Update the CHANGELOG file

 .github/workflows/build.yml    | 2 +-
 CHANGELOG                      | 6 ++++++
 Makefile                       | 2 +-
 src/ffi.c                      | 1 +
 test/232c93d07b74.c            | 6 +++---
 test/35fa71a030ca.c            | 4 ++--
 test/a0908ae19763.c            | 2 +-
 test/a4c0b3decb33.c            | 2 +-
 test/accept-link.c             | 4 ++--
 test/accept-reuse.c            | 2 +-
 test/accept.c                  | 2 +-
 test/double-poll-crash.c       | 2 +-
 test/fadvise.c                 | 2 +-
 test/fc2a85cb02ef.c            | 4 ++--
 test/files-exit-hang-timeout.c | 4 ++--
 test/madvise.c                 | 2 +-
 test/nvme.h                    | 4 ++--
 test/poll-link.c               | 4 ++--
 test/pollfree.c                | 4 ++--
 test/ring-leak.c               | 1 -
 test/sqpoll-cancel-hang.c      | 2 +-
 test/sqpoll-disable-exit.c     | 2 +-
 test/test.h                    | 3 ++-
 test/timeout-new.c             | 6 +++---
 24 files changed, 40 insertions(+), 33 deletions(-)


base-commit: 4458aa0372738e844008397f71c062bd8bfadcac
-- 
Ammar Faizi

