Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935574F0BB9
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 20:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240494AbiDCSYd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 14:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239569AbiDCSYc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 14:24:32 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A51344CF
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 11:22:38 -0700 (PDT)
Received: from integral2.. (unknown [182.2.43.220])
        by gnuweeb.org (Postfix) with ESMTPSA id AD70A7E36E;
        Sun,  3 Apr 2022 18:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1649010158;
        bh=zP/NIRheliZKEFmiKbZIuPNgIzS/R84f5azPwryJcqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iceNkJ9FuiVx2QqVVndfyK21/uvPSDST3IqHeC3DBSrEjbkUPH+N+zfTV/dg7ldP3
         RNrOoj/6fqr0aDKq0a6jtZYKlUYLIzCPTwUXs6GL4O3ztjRqzOxhmNsnKCdq9gwNBi
         JeaTH7pprqqEIskIkEU/SHquZVFVBKajh0sc+XobmKgXwYuVLL+JA8fIxvqOm2cZpk
         VMBEOow0xBUM1ICyFA3tNJwIXe+88AC+b7C800bkVVF7uf2EL0otwo8+quUO2gM8uh
         pICEoyg88jeaWStLcGLbJP7dN6Jy1zBtOS4bZ+KxxnOix8Cws0ptNrUYmj2jKcZm/O
         BX/G1YWeLFAkA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 1/3] test: Rename `[0-9a-f]-test.c` to `[0-9a-f].c`
Date:   Mon,  4 Apr 2022 01:21:58 +0700
Message-Id: <20220403182200.259937-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220403182200.259937-1-ammarfaizi2@gnuweeb.org>
References: <20220403182200.259937-1-ammarfaizi2@gnuweeb.org>
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

Simplify the test filename.

  mv -v test/232c93d07b74-test.c test/232c93d07b74.c
  mv -v test/35fa71a030ca-test.c test/35fa71a030ca.c
  mv -v test/500f9fbadef8-test.c test/500f9fbadef8.c
  mv -v test/7ad0e4b2f83c-test.c test/7ad0e4b2f83c.c
  mv -v test/8a9973408177-test.c test/8a9973408177.c
  mv -v test/917257daa0fe-test.c test/917257daa0fe.c
  mv -v test/a0908ae19763-test.c test/a0908ae19763.c
  mv -v test/a4c0b3decb33-test.c test/a4c0b3decb33.c
  mv -v test/b19062a56726-test.c test/b19062a56726.c
  mv -v test/b5837bd5311d-test.c test/b5837bd5311d.c
  mv -v test/ce593a6c480a-test.c test/ce593a6c480a.c
  mv -v test/d4ae271dfaae-test.c test/d4ae271dfaae.c
  mv -v test/d77a67ed5f27-test.c test/d77a67ed5f27.c
  mv -v test/eeed8b54e0df-test.c test/eeed8b54e0df.c
  mv -v test/fc2a85cb02ef-test.c test/fc2a85cb02ef.c

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .gitignore                                   | 30 ++++++++--------
 test/{232c93d07b74-test.c => 232c93d07b74.c} |  0
 test/{35fa71a030ca-test.c => 35fa71a030ca.c} |  0
 test/{500f9fbadef8-test.c => 500f9fbadef8.c} |  0
 test/{7ad0e4b2f83c-test.c => 7ad0e4b2f83c.c} |  0
 test/{8a9973408177-test.c => 8a9973408177.c} |  0
 test/{917257daa0fe-test.c => 917257daa0fe.c} |  0
 test/Makefile                                | 36 ++++++++++----------
 test/{a0908ae19763-test.c => a0908ae19763.c} |  0
 test/{a4c0b3decb33-test.c => a4c0b3decb33.c} |  0
 test/{b19062a56726-test.c => b19062a56726.c} |  0
 test/{b5837bd5311d-test.c => b5837bd5311d.c} |  0
 test/{ce593a6c480a-test.c => ce593a6c480a.c} |  0
 test/{d4ae271dfaae-test.c => d4ae271dfaae.c} |  0
 test/{d77a67ed5f27-test.c => d77a67ed5f27.c} |  0
 test/{eeed8b54e0df-test.c => eeed8b54e0df.c} |  0
 test/{fc2a85cb02ef-test.c => fc2a85cb02ef.c} |  0
 17 files changed, 33 insertions(+), 33 deletions(-)
 rename test/{232c93d07b74-test.c => 232c93d07b74.c} (100%)
 rename test/{35fa71a030ca-test.c => 35fa71a030ca.c} (100%)
 rename test/{500f9fbadef8-test.c => 500f9fbadef8.c} (100%)
 rename test/{7ad0e4b2f83c-test.c => 7ad0e4b2f83c.c} (100%)
 rename test/{8a9973408177-test.c => 8a9973408177.c} (100%)
 rename test/{917257daa0fe-test.c => 917257daa0fe.c} (100%)
 rename test/{a0908ae19763-test.c => a0908ae19763.c} (100%)
 rename test/{a4c0b3decb33-test.c => a4c0b3decb33.c} (100%)
 rename test/{b19062a56726-test.c => b19062a56726.c} (100%)
 rename test/{b5837bd5311d-test.c => b5837bd5311d.c} (100%)
 rename test/{ce593a6c480a-test.c => ce593a6c480a.c} (100%)
 rename test/{d4ae271dfaae-test.c => d4ae271dfaae.c} (100%)
 rename test/{d77a67ed5f27-test.c => d77a67ed5f27.c} (100%)
 rename test/{eeed8b54e0df-test.c => eeed8b54e0df.c} (100%)
 rename test/{fc2a85cb02ef-test.c => fc2a85cb02ef.c} (100%)

diff --git a/.gitignore b/.gitignore
index 4a6e585..58fff7f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -16,22 +16,22 @@
 /examples/link-cp
 /examples/ucontext-cp
 
-/test/232c93d07b74-test
-/test/35fa71a030ca-test
-/test/500f9fbadef8-test
-/test/7ad0e4b2f83c-test
-/test/8a9973408177-test
-/test/917257daa0fe-test
-/test/a0908ae19763-test
-/test/a4c0b3decb33-test
+/test/232c93d07b74
+/test/35fa71a030ca
+/test/500f9fbadef8
+/test/7ad0e4b2f83c
+/test/8a9973408177
+/test/917257daa0fe
+/test/a0908ae19763
+/test/a4c0b3decb33
 /test/accept
 /test/accept-link
 /test/accept-reuse
 /test/accept-test
 /test/across-fork
-/test/b19062a56726-test
-/test/b5837bd5311d-test
-/test/ce593a6c480a-test
+/test/b19062a56726
+/test/b5837bd5311d
+/test/ce593a6c480a
 /test/close-opath
 /test/config.local
 /test/connect
@@ -41,12 +41,12 @@
 /test/cq-peek-batch
 /test/cq-ready
 /test/cq-size
-/test/d4ae271dfaae-test
-/test/d77a67ed5f27-test
+/test/d4ae271dfaae
+/test/d77a67ed5f27
 /test/defer
 /test/double-poll-crash
 /test/drop-submit
-/test/eeed8b54e0df-test
+/test/eeed8b54e0df
 /test/empty-eownerdead
 /test/eventfd
 /test/eventfd-disable
@@ -55,7 +55,7 @@
 /test/exit-no-cleanup
 /test/fadvise
 /test/fallocate
-/test/fc2a85cb02ef-test
+/test/fc2a85cb02ef
 /test/file-register
 /test/file-update
 /test/file-verify
diff --git a/test/232c93d07b74-test.c b/test/232c93d07b74.c
similarity index 100%
rename from test/232c93d07b74-test.c
rename to test/232c93d07b74.c
diff --git a/test/35fa71a030ca-test.c b/test/35fa71a030ca.c
similarity index 100%
rename from test/35fa71a030ca-test.c
rename to test/35fa71a030ca.c
diff --git a/test/500f9fbadef8-test.c b/test/500f9fbadef8.c
similarity index 100%
rename from test/500f9fbadef8-test.c
rename to test/500f9fbadef8.c
diff --git a/test/7ad0e4b2f83c-test.c b/test/7ad0e4b2f83c.c
similarity index 100%
rename from test/7ad0e4b2f83c-test.c
rename to test/7ad0e4b2f83c.c
diff --git a/test/8a9973408177-test.c b/test/8a9973408177.c
similarity index 100%
rename from test/8a9973408177-test.c
rename to test/8a9973408177.c
diff --git a/test/917257daa0fe-test.c b/test/917257daa0fe.c
similarity index 100%
rename from test/917257daa0fe-test.c
rename to test/917257daa0fe.c
diff --git a/test/Makefile b/test/Makefile
index 1526776..44a96b2 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -34,22 +34,22 @@ LDFLAGS ?=
 override LDFLAGS += -L../src/ -luring
 
 test_srcs := \
-	232c93d07b74-test.c \
-	35fa71a030ca-test.c \
-	500f9fbadef8-test.c \
-	7ad0e4b2f83c-test.c \
-	8a9973408177-test.c \
-	917257daa0fe-test.c \
-	a0908ae19763-test.c \
-	a4c0b3decb33-test.c \
+	232c93d07b74.c \
+	35fa71a030ca.c \
+	500f9fbadef8.c \
+	7ad0e4b2f83c.c \
+	8a9973408177.c \
+	917257daa0fe.c \
+	a0908ae19763.c \
+	a4c0b3decb33.c \
 	accept.c \
 	accept-link.c \
 	accept-reuse.c \
 	accept-test.c \
 	across-fork.c \
-	b19062a56726-test.c \
-	b5837bd5311d-test.c \
-	ce593a6c480a-test.c \
+	b19062a56726.c \
+	b5837bd5311d.c \
+	ce593a6c480a.c \
 	close-opath.c \
 	connect.c \
 	cq-full.c \
@@ -57,12 +57,12 @@ test_srcs := \
 	cq-peek-batch.c \
 	cq-ready.c \
 	cq-size.c \
-	d4ae271dfaae-test.c \
-	d77a67ed5f27-test.c \
+	d4ae271dfaae.c \
+	d77a67ed5f27.c \
 	defer.c \
 	double-poll-crash.c \
 	drop-submit.c \
-	eeed8b54e0df-test.c \
+	eeed8b54e0df.c \
 	empty-eownerdead.c \
 	eventfd.c \
 	eventfd-disable.c \
@@ -72,7 +72,7 @@ test_srcs := \
 	exit-no-cleanup.c \
 	fadvise.c \
 	fallocate.c \
-	fc2a85cb02ef-test.c \
+	fc2a85cb02ef.c \
 	file-register.c \
 	files-exit-hang-poll.c \
 	files-exit-hang-timeout.c \
@@ -211,8 +211,8 @@ helpers.o: helpers.c
 	$(QUIET_CXX)$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
 
 
-35fa71a030ca-test: override LDFLAGS += -lpthread
-232c93d07b74-test: override LDFLAGS += -lpthread
+35fa71a030ca: override LDFLAGS += -lpthread
+232c93d07b74: override LDFLAGS += -lpthread
 send_recv: override LDFLAGS += -lpthread
 send_recvmsg: override LDFLAGS += -lpthread
 poll-link: override LDFLAGS += -lpthread
@@ -220,7 +220,7 @@ accept-link: override LDFLAGS += -lpthread
 submit-reuse: override LDFLAGS += -lpthread
 poll-v-poll: override LDFLAGS += -lpthread
 across-fork: override LDFLAGS += -lpthread
-ce593a6c480a-test: override LDFLAGS += -lpthread
+ce593a6c480a: override LDFLAGS += -lpthread
 wakeup-hang: override LDFLAGS += -lpthread
 pipe-eof: override LDFLAGS += -lpthread
 timeout-new: override LDFLAGS += -lpthread
diff --git a/test/a0908ae19763-test.c b/test/a0908ae19763.c
similarity index 100%
rename from test/a0908ae19763-test.c
rename to test/a0908ae19763.c
diff --git a/test/a4c0b3decb33-test.c b/test/a4c0b3decb33.c
similarity index 100%
rename from test/a4c0b3decb33-test.c
rename to test/a4c0b3decb33.c
diff --git a/test/b19062a56726-test.c b/test/b19062a56726.c
similarity index 100%
rename from test/b19062a56726-test.c
rename to test/b19062a56726.c
diff --git a/test/b5837bd5311d-test.c b/test/b5837bd5311d.c
similarity index 100%
rename from test/b5837bd5311d-test.c
rename to test/b5837bd5311d.c
diff --git a/test/ce593a6c480a-test.c b/test/ce593a6c480a.c
similarity index 100%
rename from test/ce593a6c480a-test.c
rename to test/ce593a6c480a.c
diff --git a/test/d4ae271dfaae-test.c b/test/d4ae271dfaae.c
similarity index 100%
rename from test/d4ae271dfaae-test.c
rename to test/d4ae271dfaae.c
diff --git a/test/d77a67ed5f27-test.c b/test/d77a67ed5f27.c
similarity index 100%
rename from test/d77a67ed5f27-test.c
rename to test/d77a67ed5f27.c
diff --git a/test/eeed8b54e0df-test.c b/test/eeed8b54e0df.c
similarity index 100%
rename from test/eeed8b54e0df-test.c
rename to test/eeed8b54e0df.c
diff --git a/test/fc2a85cb02ef-test.c b/test/fc2a85cb02ef.c
similarity index 100%
rename from test/fc2a85cb02ef-test.c
rename to test/fc2a85cb02ef.c
-- 
Ammar Faizi

