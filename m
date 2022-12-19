Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF666650F52
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 16:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbiLSPxi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 10:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbiLSPxI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 10:53:08 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5347ABB4
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 07:50:42 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.89])
        by gnuweeb.org (Postfix) with ESMTPSA id 1AE348191C;
        Mon, 19 Dec 2022 15:50:39 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1671465042;
        bh=CvUQd37G+LX9A5SN2izZvKT3GxHNSWIKrHqN3MCv2JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiakWzwqU27gQ7pxUxQEBH6PgCNwjO5HczJ+Zr7XSpQsuBvU5Bv5UxxRUhnRF/jhc
         4CadGUPiFXwFPnq9btiovUfbM6uxm88xDkCxKIpfC5r768xjsBkjDYrpZSRjM5P19e
         9nF3gOpuL6Ph4IiQkCczyJdyXsr7MSm0CPrcYZyaAjsJ3P9ajlfjfucpBVLDm49OKv
         GeY4mpDb4sbXozjXsBoDEFWWsC+KEajaJ5E6JCEXoPKT0Qr2nfWa6puQ+QTVyt/pXr
         zOoL4Zd/uiSJUy2sKq8ph5vl0AR8J7Qw1fbF090e6N1QLghIlFzT9j8i5f1XmVARqA
         mCyQuQhqP99Pg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v1 5/8] tests: Fix clang `-Wunreachable-code` warning
Date:   Mon, 19 Dec 2022 22:49:57 +0700
Message-Id: <20221219155000.2412524-6-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221219155000.2412524-1-ammar.faizi@intel.com>
References: <20221219155000.2412524-1-ammar.faizi@intel.com>
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

Clang says:

  fadvise.c:190:3: warning: code will never be executed [-Wunreachable-code]
                  fprintf(stderr, "Suspicious timings\n");
                  ^~~~~~~
  fadvise.c:189:6: note: silence by adding parentheses to mark code as \
  explicitly dead
          if (0 && bad > good) {
              ^
              /* DISABLES CODE */ ( )

  madvise.c:186:3: warning: code will never be executed [-Wunreachable-code]
                  fprintf(stderr, "Suspicious timings (%u > %u)\n", bad, good);
                  ^~~~~~~
  madvise.c:185:6: note: silence by adding parentheses to mark code as \
  explicitly dead
          if (0 && bad > good)
              ^
              /* DISABLES CODE */ ( )

Add parentheses to silence the warning.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/fadvise.c | 2 +-
 test/madvise.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/fadvise.c b/test/fadvise.c
index 889f447..4f4d85f 100644
--- a/test/fadvise.c
+++ b/test/fadvise.c
@@ -179,21 +179,21 @@ int main(int argc, char *argv[])
 			goto err;
 		} else if (!ret)
 			good++;
 		else if (ret == 2)
 			bad++;
 		if (i >= MIN_LOOPS && !bad)
 			break;
 	}
 
 	/* too hard to reliably test, just ignore */
-	if (0 && bad > good) {
+	if ((0) && bad > good) {
 		fprintf(stderr, "Suspicious timings\n");
 		goto err;
 	}
 
 	if (fname != argv[1])
 		unlink(fname);
 	io_uring_queue_exit(&ring);
 	return T_EXIT_PASS;
 err:
 	if (fname != argv[1])
diff --git a/test/madvise.c b/test/madvise.c
index 8848143..7938ec4 100644
--- a/test/madvise.c
+++ b/test/madvise.c
@@ -175,21 +175,21 @@ int main(int argc, char *argv[])
 			goto err;
 		} else if (!ret)
 			good++;
 		else if (ret == 2)
 			bad++;
 		if (i >= MIN_LOOPS && !bad)
 			break;
 	}
 
 	/* too hard to reliably test, just ignore */
-	if (0 && bad > good)
+	if ((0) && bad > good)
 		fprintf(stderr, "Suspicious timings (%u > %u)\n", bad, good);
 	if (fname != argv[1])
 		unlink(fname);
 	io_uring_queue_exit(&ring);
 	return T_EXIT_PASS;
 err:
 	if (fname != argv[1])
 		unlink(fname);
 	return T_EXIT_FAIL;
 }
-- 
Ammar Faizi

