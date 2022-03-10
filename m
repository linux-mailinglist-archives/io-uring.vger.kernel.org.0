Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2694D456A
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 12:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241458AbiCJLOM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 06:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241486AbiCJLOK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 06:14:10 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597E83B03C
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 03:13:10 -0800 (PST)
Received: from localhost.localdomain (unknown [138.197.159.143])
        by gnuweeb.org (Postfix) with ESMTPSA id 72D697E2CD;
        Thu, 10 Mar 2022 11:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646910790;
        bh=uuX90nuv877/C4onFNI5x1c9ovU7MdZmcxbW9Y0HIJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7p6jTWJdSQQGPuO2KrrTi7M+OsHPUNahWqLR2QFBJqZwu9wIKrdGJfRomvgRzwNM
         v/pILYxaGUSzbDMorDd0gmewNutFA0LI+WQHHJv/TrywYJhcPzZDxNTYrNUdGltVOl
         LaGoW7i8B96/If6Hpjtxx0tBISAP4okk9RD/aYmBH+a49O0rrSM2crkv98bEcnRMOj
         Y+wqF1i+ucatJ8mq9YI3ZCvSgV37PoMYEsnZtG/autc8pgTc4KD1A+LM/1Pa3ACf/X
         4P+MjthhU+rgxT/J/gidlSIJGFHnRq73L1JxqE2E7EIjbFUcQsW6JhwZsMss7/YdDd
         rB2Os5Qe620BQ==
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, gwml <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v3 3/4] test/Makefile: Add liburing.a as a dependency
Date:   Thu, 10 Mar 2022 11:12:30 +0000
Message-Id: <20220310111231.1713588-4-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220310111231.1713588-1-alviro.iskandar@gnuweeb.org>
References: <20220310111231.1713588-1-alviro.iskandar@gnuweeb.org>
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

The test binaries statically link liburing using liburing.a file. When
liburing.a is recompiled, make sure the tests are also recompiled to
ensure changes are applied to the test binary. It makes "make clean"
command optional when making changes.

Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---
 test/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/Makefile b/test/Makefile
index f421f53..9dae002 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -196,10 +196,10 @@ all: $(test_targets)
 helpers.o: helpers.c
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<
 
-%: %.c $(helpers) helpers.h
+%: %.c $(helpers) helpers.h ../src/liburing.a
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
 
-%: %.cc $(helpers) helpers.h
+%: %.cc $(helpers) helpers.h ../src/liburing.a
 	$(QUIET_CXX)$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
 
 
-- 
2.25.1

