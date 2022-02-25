Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904DC4C3A99
	for <lists+io-uring@lfdr.de>; Fri, 25 Feb 2022 01:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbiBYA7d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 19:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbiBYA7d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 19:59:33 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9851B2AEA
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 16:59:02 -0800 (PST)
Received: from integral2.. (unknown [36.78.50.60])
        by gnuweeb.org (Postfix) with ESMTPSA id A97DD7E2A9;
        Fri, 25 Feb 2022 00:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1645750741;
        bh=Tf4hjix6jrjxk0IthS+0V1FHsK8Cthh2HDY/cJnRYwI=;
        h=From:To:Cc:Subject:Date:From;
        b=TardJ/IBoNx2OurJZQbQHz9rG4kSL2rbRdtWl0yBHHpf8dpQaABtTY4KtEXTSo0nB
         1+98AKFxR7JutR1cJJ9HJyX7Abpdr9Wy/7ZGvK3+7Gog50Qjo5jv93aV0vo8Wfirz3
         S94E+yKHtNtfl02EBurmBJtyfJG3jFMn7nPLWzPF/wnO1ogi7k29HSZlD0SBcqPGmY
         m7KwIQDIoy5bxNmMFft9iygqCATcRuhQJ3wXFAnLUyJ/1YG9qHW6DDOoOIeH12Y6hs
         IkISXTSVIV26aJybVy99J6zUmbzMyyjHppZDlLbfPaCssRY9Hg9bRuQAD2czSefTDK
         PwwPBzVcxiPZA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>, Nugra <richiisei@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v2] queue, liburing.h: Avoid `io_uring_get_sqe()` code duplication
Date:   Fri, 25 Feb 2022 07:58:14 +0700
Message-Id: <20220225005814.146492-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2861; h=from:subject; bh=Tf4hjix6jrjxk0IthS+0V1FHsK8Cthh2HDY/cJnRYwI=; b=owEBbQGS/pANAwAKATZPujT/FwpLAcsmYgBiGCmh+rX84lMXrNVXJSp7yQS7HN8TEK4XP7l0IoEN 7vD3HtSJATMEAAEKAB0WIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCYhgpoQAKCRA2T7o0/xcKSxJsCA DDndy+vHdF4OhfI3B7RGKtQUlBlTr3h2dKGjvVhNQzGGmEr7xL0ZpiufO5Dq2tQccdYRTlEvVg76G4 s/LWwdoBXYwLw+TIP+re/pY5sFHk6iZXRGThW2YCaaiozf+ypPgdW5ZqAC8Knk2C7CxtlkfmQtAK+R AugOwzAypD9k2M0EmiUw960q1QGr+ATGK+uoRsFj4u/CD+53tYkZtUDlomj5JWfD6rKyxKOtnEkX/Z Em1ec8kh7uWDjeozz3ySrw95A4gzcLTNby65TqDtBpiRUdBBWA4a21gpYtrWqks+VVkyk+3lEal0AK rgj8KqXgw5lQPQCVelcpeUUQvwEkEj
X-Developer-Key: i=ammarfaizi2@gnuweeb.org; a=openpgp; fpr=E893726DC8E4C0DE3BA20107364FBA34FF170A4B
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since commit 8be8af4afcb4909104c ("queue: provide io_uring_get_sqe()
symbol again"), we have the same definition of `io_uring_get_sqe()` in
queue.c and liburing.h.

Make it simpler, maintain it in a single place, create a new static
inline function wrapper with name `_io_uring_get_sqe()`. Then tail
call both `io_uring_get_sqe()` functions to `_io_uring_get_sqe()`.

Cc: Nugra <richiisei@gmail.com>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc: GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Cc: Tea Inside Mailing List <timl@vger.teainside.org>
Cc: io-uring Mailing List <io-uring@vger.kernel.org>
Link: https://lore.kernel.org/io-uring/20220225002852.111521-1-ammarfaizi2@gnuweeb.org # v1
Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Tested-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

  v2:
    - Address a comment from Alviro (fix typo).
    - Append Reviewed-by and Tested-by tag from Alviro.

 src/include/liburing.h |  9 +++++++--
 src/queue.c            | 11 +----------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 590fe7f..ef5a4cd 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -831,8 +831,7 @@ static inline int io_uring_wait_cqe(struct io_uring *ring,
  *
  * Returns a vacant sqe, or NULL if we're full.
  */
-#ifndef LIBURING_INTERNAL
-static inline struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring)
+static inline struct io_uring_sqe *_io_uring_get_sqe(struct io_uring *ring)
 {
 	struct io_uring_sq *sq = &ring->sq;
 	unsigned int head = io_uring_smp_load_acquire(sq->khead);
@@ -845,6 +844,12 @@ static inline struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring)
 	}
 	return sqe;
 }
+
+#ifndef LIBURING_INTERNAL
+static inline struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring)
+{
+	return _io_uring_get_sqe(ring);
+}
 #else
 struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring);
 #endif
diff --git a/src/queue.c b/src/queue.c
index 6b63490..f9b6c86 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -405,16 +405,7 @@ int io_uring_submit_and_wait(struct io_uring *ring, unsigned wait_nr)
 
 struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring)
 {
-	struct io_uring_sq *sq = &ring->sq;
-	unsigned int head = io_uring_smp_load_acquire(sq->khead);
-	unsigned int next = sq->sqe_tail + 1;
-	struct io_uring_sqe *sqe = NULL;
-
-	if (next - head <= *sq->kring_entries) {
-		sqe = &sq->sqes[sq->sqe_tail & *sq->kring_mask];
-		sq->sqe_tail = next;
-	}
-	return sqe;
+	return _io_uring_get_sqe(ring);
 }
 
 int __io_uring_sqring_wait(struct io_uring *ring)

base-commit: 868be37473052893b68a8586d45a750980be4329
-- 
2.32.0

