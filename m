Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D94C5A414B
	for <lists+io-uring@lfdr.de>; Mon, 29 Aug 2022 05:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiH2DID (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Aug 2022 23:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiH2DIC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Aug 2022 23:08:02 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F693DF1A;
        Sun, 28 Aug 2022 20:07:53 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.68.216])
        by gnuweeb.org (Postfix) with ESMTPSA id 0296380866;
        Mon, 29 Aug 2022 03:07:49 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661742472;
        bh=nee5pdsoj2i9027ao/qgMrR5X60OT6Gff/6ayksr9NY=;
        h=From:To:Cc:Subject:Date:From;
        b=QtdFqTI5I49qcChMjGj5+DXd3VaZo7BtmdWSImy5acsQvT+rCpTVsSqrPniuYJM54
         Lp/Qo1wQxLsH9v3gNXniIrDZmp1IooiPztyo5G5a4FE61bONPifrGj0NmsxmvSQxuc
         u7wnG8hBlbhHUl/G7gvEGcWxMp9N4Blqs9PoB2ZvX/tqBoBIKAm85G/zIztvTQodUp
         jwqelYPzA/79arzwRhAabAiPuiR5M9KwxJTVlKRE2eThIhjKyffr+wXbZlJKvl8EME
         In3wxX2VcnDkewUuuXQNMalZq3H6HV5i5e3tFfu8CTRiEgoV46DO1bB5YDVjuIIj46
         9Fq2MivEkKP5g==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Caleb Sander <csander@purestorage.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v1 0/4] Export io_uring syscall functions
Date:   Mon, 29 Aug 2022 10:07:35 +0700
Message-Id: <20220829030521.3373516-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Hi Jens,

The background story of this series comes from the recent conversation with
Caleb Sander at:

   https://github.com/axboe/liburing/pull/646#issuecomment-1229639532

What do you think of this series?

There are 4 patches in this series.

1) syscall: Add io_uring syscall functions

We have:

  man 2 io_uring_setup;
  man 2 io_uring_enter;
  man 2 io_uring_register;

Those entries say that io_uring syscall functions are declared in
`<linux/io_uring.h>`. But they don't actually exist and never existed.
This is causing confusion for people who read the manpage. Let's just
implement them in liburing so they exist.

This also allows the user to invoke io_uring syscalls directly instead
of using the full liburing provided setup.

2) Clarify "man 2" entry for io_uring.

io_uring_enter(), io_uring_register(), io_uring_setup() are not
declared in `<linux/io_uring.h>` and never were. Plus, these
functions don't intentionally set the `errno` variable. Reflect this
fact in the manpage.

Side note: On architectures other than x86, x86-64, and aarch64, those
functions _do_ set the `errno`, this is because the syscall is done via
libc as we don't yet have nolibc support for the mentioned archs. Users
should not rely on this behavior.

3) man: Alias `io_uring_enter2()` to `io_uring_enter()`.

We have a new function io_uring_enter2(), add the man page entry for it
by aliasing it to io_uring_enter(). This aliased man entry has already
explained it.

4) test/io_uring_{enter,setup,register}: Use the exported syscall functions.

These tests use the internal definition of __sys_io_uring* functions.
A previous commit exported new functions that do the same thing with
those __sys_io_uring* functions. Test the exported functions instead of
the internal functions.

No functional change is intended.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (4):
  syscall: Add io_uring syscall functions
  man: Clarify "man 2" entry for io_uring syscalls
  man: Alias `io_uring_enter2()` to `io_uring_enter()`
  test/io_uring_{enter,setup,register}: Use the exported syscall functions

 man/io_uring_enter.2     |  9 ++++-----
 man/io_uring_enter2.2    |  1 +
 man/io_uring_register.2  |  9 ++++-----
 man/io_uring_setup.2     |  8 +++-----
 src/Makefile             |  2 +-
 src/include/liburing.h   |  8 ++++++++
 src/liburing.map         |  4 ++++
 src/syscall.c            | 30 ++++++++++++++++++++++++++++++
 test/io_uring_enter.c    | 10 +++++-----
 test/io_uring_register.c | 34 ++++++++++++++++------------------
 test/io_uring_setup.c    |  4 ++--
 11 files changed, 78 insertions(+), 41 deletions(-)
 create mode 120000 man/io_uring_enter2.2
 create mode 100644 src/syscall.c


base-commit: bf248850dc2ae45d29d4fdde688e90d24f3dd6d2
-- 
Ammar Faizi

