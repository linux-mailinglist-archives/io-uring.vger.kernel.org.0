Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F384C3A56
	for <lists+io-uring@lfdr.de>; Fri, 25 Feb 2022 01:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiBYA3n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 19:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiBYA3m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 19:29:42 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3B32757B1
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 16:29:11 -0800 (PST)
Received: from integral2.. (unknown [36.78.50.60])
        by gnuweeb.org (Postfix) with ESMTPSA id B1D197E29A;
        Fri, 25 Feb 2022 00:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1645748951;
        bh=QN1I5dEGk/1XZ2b606eyJLOOAe8yIhsPpPgwLVgSakM=;
        h=From:To:Cc:Subject:Date:From;
        b=Vm4zecVgI0XbGiPUfbRTxmPc8+vSUi9mXx+w12XBSFqKkT1hrssny5nxpZ9VeeytG
         KSLP6gT9Pw9hs+7ykKp2XEtBZwspQREfPNrZ6pP6GyufXEGQVNrHpHat/vdbwqAXYL
         0jEJJCXM+qokEEP3Wj79XO0nLp8YsjcvsxF+LYZ+XLD5P+fCljDNOyt7mvXgu3Ll0P
         H0VsCtqG0bqiWj+UNQ1iIws6ovf+p9qFDHroQJ9qm5vLXMflvTmaM6r0bIl8R7b+i9
         q50IbK/QS3R2PbQCE7x73RaICIJUUQx4xuAxd6soXcckCYvkzOVLO9VXy/mtyPrYpq
         EvhZw/cEQQgbg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>, Nugra <richiisei@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v1] queue, liburing.h: Avoid `io_uring_get_sqe()` code duplication
Date:   Fri, 25 Feb 2022 07:28:52 +0700
Message-Id: <20220225002852.111521-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2514; h=from:subject; bh=QN1I5dEGk/1XZ2b606eyJLOOAe8yIhsPpPgwLVgSakM=; b=owEBbQGS/pANAwAKATZPujT/FwpLAcsmYgBiGCJROb237lp//t482+s9ZwaR8WdadFSFaxKepOyZ jv8vM5WJATMEAAEKAB0WIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCYhgiUQAKCRA2T7o0/xcKS6sFB/ 9r2Ljzjiqwp9d9n22XM8uO6RTvYEqAbq2RAJagxbCJCyvWQqFDmfXTVP9nw1Ng9o2ET2qZCfpGVOuE 6QiYUMBbmHfln/VfFUMOT5pE5/ps2Cov+n03lX7iYmOJmkFV2+EkSx53k+xw4R79VL59kCcW/oZ2DK z0yEx1FXpHJuV4WmiDRXOnqC7Hyo0kYVaaw+UTkn2WLU/Fikdo4Xt/MOJZYGXKFrbMg7pu+5mk9IQ1 aY6qayTna7S8G9GWxso1wTtuGae0k3D05EukRR1bloBiBpibZzIU4OBH/u1hxJet0lnOBNFRf5IwBw T8QSDBfnpdJ7GDT56QquTOh2SltKg/
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
symbol again"), we have the same defintion of `io_uring_get_sqe()` in
queue.c and liburing.h.

Make it simpler, maintain it in a single place, create a new static
inline function wrapper with name `_io_uring_get_sqe()`. Then tail
call both `io_uring_get_sqe()` functions to `_io_uring_get_sqe()`.

Cc: Nugra <richiisei@gmail.com>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc: GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Cc: Tea Inside Mailing List <timl@vger.teainside.org>
Cc: io-uring Mailing List <io-uring@vger.kernel.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
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

base-commit: 896a1d3ab14a8777a45db6e7b67cf557a44923fb
-- 
2.32.0

