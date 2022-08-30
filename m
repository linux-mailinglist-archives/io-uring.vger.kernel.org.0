Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFD65A5897
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 02:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiH3A4z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Aug 2022 20:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiH3A4y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Aug 2022 20:56:54 -0400
Received: from linux.gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD85C86FE2;
        Mon, 29 Aug 2022 17:56:52 -0700 (PDT)
Received: from localhost.localdomain (unknown [68.183.184.174])
        by linux.gnuweeb.org (Postfix) with ESMTPSA id 673E2374E5F;
        Tue, 30 Aug 2022 00:56:49 +0000 (UTC)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Caleb Sander <csander@purestorage.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 0/7] Export io_uring syscall functions
Date:   Tue, 30 Aug 2022 07:56:36 +0700
Message-Id: <20220830005122.885209-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Hi Jens,

This series adds io_uring syscall functions and exports them. There
are 7 patches in this series:

1) Make the arguments of io_uring syscalls consistent with what is
   said in the manpage. These change are in header files. No
   functional change is intended.

2) Add io_uring syscall functions.

   We have:

     man 2 io_uring_setup;
     man 2 io_uring_enter;
     man 2 io_uring_register;

   Those entries say that io_uring syscall functions are declared in
   `<linux/io_uring.h>`. But they don't actually exist and never
   existed. This is causing confusion for people who read the manpage.
   Let's just implement them in liburing so they exist. This also
   allows the user to invoke io_uring syscalls directly instead of
   using the full liburing provided setup.

3) man: Clarify "man 2" entry for io_uring syscalls.

   io_uring_enter(), io_uring_register(), and io_uring_setup() are not
   declared in `<linux/io_uring.h>` (and never were). A previous
   commit adds the implementation of these functions in liburing.
   Change the include header to `<liburing.h>`. Then clarify that
   those functions don't intentionally set the `errno` variable.
   Instead they return a negative error code when the syscall fails.

4) Add `io_uring_enter2()` function signature.

   Since kernel 5.11, liburing has io_uring_enter2() wrapper which
   behaves just like the io_uring_enter(), but with an extra argument
   for `IORING_ENTER_EXT_ARG` case. Add this function signature to the
   synopsis part.

5) man: Alias `io_uring_enter2()` to `io_uring_enter()`.

   We have a new function io_uring_enter2(), add the man page entry
   for it by aliasing it to io_uring_enter(). The aliased man entry
   has already explained it.

6) test/io_uring_{enter,setup,register}: Use the exported syscall
   functions.

   These tests use the internal definition of __sys_io_uring*
   functions. A previous commit exported new functions that do the
   same thing with those __sys_io_uring* functions. Test the exported
   functions instead of the internal functions. No functional change
   is intended.

7) Just a trivial typo fix.


## Changelog revision

 RFC v1 -> v2:

  - Make io_uring syscall arguments consistent with the manpage.
  - Separate syscall declarations in liburing.h with a blank line.
  - Remove unused include in syscall.c.
  - Add io_uring_enter2() function signature to manpage.
  - Append Reviewed-by tags from Caleb Sander.
  - Fix typo introduced by an old commit, 1dbc9974486cbc.


Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (7):
  syscall: Make io_uring syscall arguments consistent
  syscall: Add io_uring syscall functions
  man: Clarify "man 2" entry for io_uring syscalls
  man: Add `io_uring_enter2()` function signature
  man: Alias `io_uring_enter2()` to `io_uring_enter()`
  test/io_uring_{enter,setup,register}: Use the exported syscall functions
  man/io_uring_enter.2: Fix typo "which is behaves" -> "which behaves"

 man/io_uring_enter.2       | 21 ++++++++++++---------
 man/io_uring_enter2.2      |  1 +
 man/io_uring_register.2    |  9 ++++-----
 man/io_uring_setup.2       |  8 +++-----
 src/Makefile               |  2 +-
 src/arch/generic/syscall.h | 19 ++++++++++---------
 src/arch/syscall-defs.h    | 19 ++++++++++---------
 src/include/liburing.h     | 12 ++++++++++++
 src/liburing.map           |  4 ++++
 src/syscall.c              | 29 +++++++++++++++++++++++++++++
 test/io_uring_enter.c      | 10 +++++-----
 test/io_uring_register.c   | 34 ++++++++++++++++------------------
 test/io_uring_setup.c      |  4 ++--
 13 files changed, 109 insertions(+), 63 deletions(-)
 create mode 120000 man/io_uring_enter2.2
 create mode 100644 src/syscall.c


base-commit: 243477691678af27dafe378f1e19be5df61e9daf
-- 
Ammar Faizi

