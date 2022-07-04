Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02190565D36
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 19:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiGDRy6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 13:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiGDRy6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 13:54:58 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDBD646B
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 10:54:57 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id E2012801E6;
        Mon,  4 Jul 2022 17:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656957296;
        bh=4l9pLaCxhcUFyKlHx2VS/fIHiVMcAIb+1rjX8ECnKqo=;
        h=From:To:Cc:Subject:Date:From;
        b=hvy+UHZMeP+t0hk6zd0rsT8m6lBVBNFZn6Z1b8uzMjL++VE5y5rKVo0jXUmd+qRw1
         t2slsvSnBZtuuQxEgNbipYuzDpUNC1hMjqlcYbNK9+PGBeEQ8JQJSizLsmmUUACgEQ
         u5K0Jc5U08EwwBE/fSXSS7ccgcOkJGS8Pot17bwA+U7wrBM7LVJHo5rn7MkxOQodIb
         0xy3KehcgTuB0ENIrqyxpBKkBVUPQYjjZ7L48fErh0n5ys6RthBdSAI/plnhaogADa
         0Atq5tWaE7+SOjBs8+UPr2geTAtMWc8BXdY/zE4PO8gQfG1tLgfqQ8xiMxtimkxsVP
         7LJjtC1JsitrQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v3 00/10] aarch64 support
Date:   Tue,  5 Jul 2022 00:54:26 +0700
Message-Id: <20220704174858.329326-1-ammar.faizi@intel.com>
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

This is v3 revision of aarch64 support.

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

There are 10 patches in this series. Summary:

- Patch 1 is just a trivial changelog fix.
- Patch 2 and 3 are to add open() and read() syscall.
- Patch 4 is to remove __INTERNAL__LIBURING_SYSCALL_H checks.
- Patch 5 is to add get_page_size() function.
- Patch 6 is just a trivial style fixup for #ifdef and friends.
- Patch 7 is to enable the nolibc support for aarch64.
- Patch 8 is to add nolibc test.
- Patch 9 is for GitHub bot build.
- Patch 10 is to update the CHANGELOG to note aarch64 nolibc support.

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

v2 -> v3:
  - No need to init the static var to zero.
  - Split style fixup into a separate patch.
  - Add nolibc test to test get_page_size() function.
  - Use __NR_openat when __NR_open is not defined on the arch.
  - Split open/read/close in get_page_size() into a new function.
  - Cache the get_page_size() fallback value when we fail on the
    syscalls.

v1 -> v2:
  - Drop aarch64 renaming directory patch.
  - Fallback the page size to 4K if we fail to get it.
  - Cache the page size after we read it from /proc/self/auxv.
  - Massage commit messages.
  - Note aarch64 nolibc support in CHANGELOG.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (10):
  CHANGELOG: Fixup missing space
  arch: syscall: Add `__sys_open()` syscall
  arch: syscall: Add `__sys_read()` syscall
  arch: Remove `__INTERNAL__LIBURING_LIB_H` checks
  arch/aarch64: lib: Add `get_page_size()` function
  lib: Style fixup for #if / #elif / #else / #endif
  lib: Enable nolibc support for aarch64
  test: Add nolibc test
  .github: Enable aarch64 nolibc build for GitHub bot
  CHANGELOG: Note about aarch64 support

 .github/workflows/build.yml |  2 +-
 CHANGELOG                   |  7 ++++-
 src/arch/aarch64/lib.h      | 51 +++++++++++++++++++++++++++++++
 src/arch/aarch64/syscall.h  |  4 ---
 src/arch/generic/lib.h      |  4 ---
 src/arch/generic/syscall.h  | 20 ++++++++++---
 src/arch/syscall-defs.h     | 19 ++++++++++++
 src/arch/x86/lib.h          |  4 ---
 src/arch/x86/syscall.h      |  4 ---
 src/lib.h                   | 32 ++++++++++----------
 src/syscall.h               |  2 --
 test/Makefile               |  1 +
 test/nolibc.c               | 60 +++++++++++++++++++++++++++++++++++++
 13 files changed, 170 insertions(+), 40 deletions(-)
 create mode 100644 src/arch/aarch64/lib.h
 create mode 100644 test/nolibc.c


base-commit: f8eb5f804288e10ae7ef442ef482e4dd8b18fee7
-- 
Ammar Faizi

