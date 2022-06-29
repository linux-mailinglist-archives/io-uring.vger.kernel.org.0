Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0C1560813
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 19:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiF2R73 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 13:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiF2R71 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 13:59:27 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26C1335
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 10:59:26 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id 93C277FC07;
        Wed, 29 Jun 2022 17:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656525565;
        bh=1oM/S+2sCrAwMzVsOIZUiUryQ1mfVFi7H/1kHJsc6oE=;
        h=From:To:Cc:Subject:Date:From;
        b=T29W+LXxGfer+ULMGK5IaH/ysr8evBciNteHQvoUw5Uy622F0lr9ke0a2SKeexvNW
         YdWMEsIbTharpaByZPqNid7zWOc474InYzosq8WSYJMH5bT59oXrgwVp/G4eJyyKPp
         NSybn0EWhigVrny1nEqFD3Hsgd4iBgdsQMmMpK5eLlEHUWGT1FzS5oCoAuYbm2hn/v
         YwZ3Kz1jbmBnkEpiPfTLN2pAmJIbSSsXwWBKWaVaRQi0cBv7t3rw5SKsyv/Bs7XnAN
         vkAMqqoXhBQ6u+VyQUJN1bknU6fzJwIy2dyCfi8rDfciUv1RD/6QumWRZ2GFmlU9Iy
         KOPprgQQuh0iQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v2 0/8] aarch64 support
Date:   Thu, 30 Jun 2022 00:58:22 +0700
Message-Id: <20220629175255.1377052-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLACK autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Hi Jens,

This is v2 revision of aarch64 support.

This series contains nolibc support for aarch64 and one extra irrelevant
cleanup (patch #1). The missing bit from aarch64 is get_page_size()
which is a bit complicated to implement without libc.

aarch64 supports three values of page size: 4K, 16K, and 64K which are
selected at kernel compilation time. Therefore, we can't hard code the
page size for this arch. In this series we utilize open(), read() and
close() syscall to find the page size from /proc/self/auxv.

The auxiliary vector contains information about the page size, it is
located at `AT_PAGESZ` keyval pair.

For more details about the auxv data structure, check the link below.

Link: https://github.com/torvalds/linux/blob/v5.19-rc4/fs/binfmt_elf.c#L260
Link: https://lwn.net/Articles/631631/

There are 8 patches in this series. Summary:

- Patch 1 is just a trivial changelog fix.
- Patch 2 and 3 are to add open() and read() syscall. We will need them
  to get the page size on aarch64.
- Patch 4 is to remove __INTERNAL__LIBURING_SYSCALL_H checks.
- Patch 5 is to add get_page_size() function.
- Patch 6 is to enable the nolibc support for aarch64.
- Patch 7 is for GitHub bot build.
- Patch 8 is to update the CHANGELOG to note aarch64 nolibc support.

I have built it with GitHub bot and it compiles just fine. But I don't
have an aarch64 machine to run the tests. Since you are using aarch64,
I can rely on you to test it.

How to test this?

  make clean;
  ./configure --nolibc;
  make -j8;

  ldd src/liburing.so.2.3;
  # Make sure you don't see libc.so from the `ldd` command.

  make runtests;

Please give it a test, thanks!

## Changelog

v1 -> v2:
  - Drop aarch64 renaming directory patch.
  - Fallback the page size to 4K if we fail to get it.
  - Cache the page size after we read it from /proc/self/auxv.
  - Massage commit messages.
  - Note aarch64 nolibc support in CHANGELOG.


Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (8):
  CHANGELOG: Fixup missing space
  arch: syscall: Add `__sys_open()` syscall
  arch: syscall: Add `__sys_read()` syscall
  arch: Remove `__INTERNAL__LIBURING_LIB_H` checks
  arch/aarch64: lib: Add `get_page_size()` function
  arch: Enable nolibc support for aarch64
  .github: Enable aarch64 nolibc build for GitHub bot
  CHANGELOG: Note about aarch64 support

 .github/workflows/build.yml |  2 +-
 CHANGELOG                   |  7 +++++-
 src/arch/aarch64/lib.h      | 45 +++++++++++++++++++++++++++++++++++++
 src/arch/aarch64/syscall.h  |  8 +++----
 src/arch/generic/lib.h      |  4 ----
 src/arch/generic/syscall.h  | 20 +++++++++++++----
 src/arch/syscall-defs.h     | 12 ++++++++++
 src/arch/x86/lib.h          |  4 ----
 src/arch/x86/syscall.h      |  4 ----
 src/lib.h                   | 32 +++++++++++++-------------
 src/syscall.h               |  2 --
 11 files changed, 100 insertions(+), 40 deletions(-)
 create mode 100644 src/arch/aarch64/lib.h


base-commit: 7d1cce2112ddf358b56ae0abd18c86e8ede9447f
-- 
Ammar Faizi

