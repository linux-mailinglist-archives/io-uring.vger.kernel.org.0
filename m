Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9530553E31C
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 10:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiFFGMj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 02:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiFFGMe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 02:12:34 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B8E2642
        for <io-uring@vger.kernel.org>; Sun,  5 Jun 2022 23:12:31 -0700 (PDT)
Received: from integral2.. (unknown [36.73.79.120])
        by gnuweeb.org (Postfix) with ESMTPSA id 23DAD7E582;
        Mon,  6 Jun 2022 06:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1654495951;
        bh=gj0GtIs0va16fY980Ta5awB1nXkVh39xAdN2e1h6gCA=;
        h=From:To:Cc:Subject:Date:From;
        b=X8MBKc+KldFaDHbstb1SYwftXN61C3v5f+B6LUmYWQIin9YIw1sSsS88qaUZYSJ1N
         99R6LKa3o1cS70D17Z0EldhI0fH1wgbDUWxFfNX+4TaVb61lSZiMO/UjSZ48kQ8d7c
         Uwk1lNQ4bZsWGl6bv4qbLX19ni0XyWeasGZV07t20xDK3kGExQfX5OR6ni6pZeW7He
         WyWJjqxsKw2JKCtIH0nUp+3Mvc717Mf1eIW8RqWrWwe777MQIHSY1HOEIvUVEN/f/f
         +yQygRwm5E6bJ3IKDIIXBqFdwti8mTqhoCgkv8vhtwPKdi1n4NzLWdTwp4fqnMGLzl
         wz+GmFsFAQfYQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "Fernanda Ma'rouf" <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH v1 0/5] Ensure io_uring data structure consistentcy in liburing
Date:   Mon,  6 Jun 2022 13:12:04 +0700
Message-Id: <20220606061209.335709-1-ammarfaizi2@gnuweeb.org>
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


Hi,

This is an RFC for liburing-2.3.

## Introduction:
This series adds compile time assertions for liburing. They are taken
from the io_uring source in the kernel tree. The point of this series
is to make sure the shared struct is consistent between the kernel
space and user space.


## Implementation detail:
We use `static_assert()` macro from <assert.h> that can yield compile
error if the expression given to it evaluates to false. This way we
can create a `BUILD_BUG_ON()` macro that we usually use inside the
kernel. The assertions are placed inside a header file named
build_assert.h, this header is included via compile flag `-include`
when compiling the core liburing sources.


## How to maintain this?
This is pretty much easy to maintain, we just need to sync the
`BUILD_BUG_ON()` macro calls that check the shared struct from
io_uring. See patch #5 for detail.


## Patches summary:

  - Patch 1 is just a small code style cleanup.
  - Patch 2 is to add BUILD_BUG_ON() macro.
  - Patch 3 is to add sizeof_field() macro.
  - Patch 4 is to avoid macro redefinition warnings.
  - Patch 5 is the main part, it adds io_uring data structure
    assertions.


Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (5):
  lib: Don't indent in `#ifdef -> #define -> #endif` block
  lib: Add `BUILD_BUG_ON()` macro
  lib: Add `sizeof_field()` macro
  Avoid macro redefinition warnings
  Add io_uring data structure build assertion

 src/Makefile       |  3 ++-
 src/build_assert.h | 57 ++++++++++++++++++++++++++++++++++++++++++++++
 src/lib.h          | 18 +++++++++++----
 src/queue.c        |  2 ++
 src/register.c     |  2 ++
 src/setup.c        |  2 ++
 src/syscall.c      |  2 ++
 7 files changed, 80 insertions(+), 6 deletions(-)
 create mode 100644 src/build_assert.h


base-commit: 4633a2d0fe9bd1f3dbb5b6d2788a08a264803146
-- 
Ammar Faizi

