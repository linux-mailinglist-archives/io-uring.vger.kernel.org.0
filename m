Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D714D44B2
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 11:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241291AbiCJKdp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 05:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241436AbiCJKde (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 05:33:34 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56FE1039
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 02:32:29 -0800 (PST)
Received: from localhost.localdomain (unknown [138.197.159.143])
        by gnuweeb.org (Postfix) with ESMTPSA id C7FFE7E2B2;
        Thu, 10 Mar 2022 10:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646908348;
        bh=3LklH9xcZlJsW8N4l5LemR/TtMKAc+MebSjm6DfEsr0=;
        h=From:To:Cc:Subject:Date:From;
        b=Q2zE2VHtA+gUXZnZHIvFjJnDzlVqdZhK+XxreiA/18lop0G1jwwLK791s11wkVk8r
         cWCXK20MN5plNkegoP9ryQzsZtmatNLs0+LY//iX1CjGTXwo51/MZ7vVlFGGnOheys
         56RunSz/M5FR8y3lmhk0qVjGCuHZqok5l1B634omZGXNFA/P1DQcOIKnep9bs1TcrP
         2MqoNdtIXwEwu6iwPsjbKC33NCB8SrxvhiD7x19KqBK5cTn4QnBT6zBUjlOH0/kJLW
         DnXRZzdP/mRCaU8gsBZyCh8EH1ans/BTjAFJg5OXroECw6vm/0GlsrLAlWNVAcyWG3
         hn2M3Q/RLqwxQ==
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, gwml <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 0/4] Changes for Makefile
Date:   Thu, 10 Mar 2022 10:32:20 +0000
Message-Id: <20220310103224.1675123-1-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.27.0
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

Hello sir,

This patchset (v2) changes Makefile. 4 patches here:

1. Remove -fomit-frame-pointer flag, because it's already covered
   by the -O2 optimization flag.

2. When the header files are modified, the compiled objects are
   not going to be recompiled because the header files are not
   marked as a dependency for the objects.

  - Instruct the compiler to generate dependency files.

  - Include those files from src/Makefile. Ensure if any changes are
    made, files that depend on the changes are recompiled.

3. The test binaries statically link liburing using liburing.a file.
   When liburing.a is recompiled, make sure the tests are also
   recompiled to ensure changes are applied to the test binary. It
   makes "make clean" command optional when making changes.

4. Same as no. 3, but for examples.

please review,
thx

link v1: https://lore.kernel.org/io-uring/20220308224002.3814225-1-alviro.iskandar@gnuweeb.org/
v1 -> v2:
  - Instruct the compiler to generate dependency files instead
    of hard code it in the Makefile.
  - Add liburing.a to dependency for test (patch 3).
  - Add liburing.a to dependency for examples (patch 4).

Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---

Alviro Iskandar Setiawan (4):
  src/Makefile: Remove `-fomit-frame-pointer` from default build
  src/Makefile: Add header files as dependency
  test/Makefile: Add liburing.a as a dependency
  examples/Makefile: Add liburing.a as a dependency

 examples/Makefile |  2 +-
 src/Makefile      | 13 ++++++-------
 test/Makefile     |  4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)


base-commit: 6231f56da7881bde6fb011e1b54d672f8fe5a224
-- 
2.25.1

