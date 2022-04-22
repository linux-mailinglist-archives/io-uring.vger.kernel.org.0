Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD6B50C132
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 23:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiDVVi0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 17:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiDVViP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 17:38:15 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5C6409D08
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 13:42:38 -0700 (PDT)
Received: from integral2.. (unknown [36.72.214.135])
        by gnuweeb.org (Postfix) with ESMTPSA id 642577E772;
        Fri, 22 Apr 2022 20:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1650659776;
        bh=jnEo/KvqFJZ248sSjUR0rdQ1fRAS+japUJ+1OXvZEBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4EwPjbLz8QD4gz9Xltymi0qEYHhoLswWsCOE/xE8rqMJa0gISoBlG0hrDj87DkJZ
         GrixMlRvsUDiOuBT60IdAVssAgieIae0BYDs4sFnMbsWWK/jn/Rxd9HN8ar+AdWsp9
         pe58BUlbmY0zHcgbXr8YN1en5M+Ojvym0lqyAq7W42OLdX1VSmdYWRbFSjFWxl1T9G
         Nspcm6tzL9boj0IO/JT5lchwkbs4ZsDbqTAJdJuXqKHYOtG6XS5ZFu+GCJd3BmLD9g
         O1bQB9ec78uaT5o7l/hnIis/YeSH/JUs4ZJp+BK8ga3QYRF6iwd+Kz53ggaRRkh+Uo
         1Lf/Svugw+tMg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 6/6] test/double-poll-crash: Skip this test if the `mmap()` fails
Date:   Sat, 23 Apr 2022 03:35:42 +0700
Message-Id: <20220422203340.682723-7-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220422203340.682723-1-ammar.faizi@intel.com>
References: <20220422203340.682723-1-ammar.faizi@intel.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2030; h=from:subject:message-id; bh=Vn/ek/GiFPnQu1HiLf9xF0ohkLZLS9iJ0oLr8+bv8Kk=; b=owEBbQGS/pANAwAKATZPujT/FwpLAcsmYgBiYxFslsBrg7OlpBuKbaLuFFL8eScq1eQm+WGQ9jav QOY/b1aJATMEAAEKAB0WIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCYmMRbAAKCRA2T7o0/xcKS4fiCA CdzJ6E/ZKAVZPbE/Tq2LKmoRGiRadRGigwB36a+AwVq0qboaCgb76WFkJS7V1OxZJnA9qPmtIBn9ST B9RF0hoKYdM+kyy0AF66LrOfbuSiVR4+A/bh/z0uXQalzm+OWUQ9jH84kW6+R3mu0Ttx3vB9r/IX2K f89tvDDmEcKK8Hst/yaIibxdhwaWeJ/og5aZjH/6FbQS6BtMHOQzpcHFnyrLEvdFkqwiU8wC55lGLS bX63bglUYQq5K3tBizUHvmM5aRNkRBOCyzZe0N07OvisdLgsE5mde76l6H9SZNmE399b1zSOTjQPVj vKdlrI9JUf5oWouoHwbeaZqsfiUGSb
X-Developer-Key: i=ammarfaizi2@gnuweeb.org; a=openpgp; fpr=E893726DC8E4C0DE3BA20107364FBA34FF170A4B
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

This test is very prone to hiting a SIGSEGV signal due to missing error
handling on mmap() calls. This especially often happens when executing
`runtests-parallel`. Let's just skip this test if those calls fail
instead of having a random segfault with no clear resolution.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/double-poll-crash.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/test/double-poll-crash.c b/test/double-poll-crash.c
index 5bfce09..231c7da 100644
--- a/test/double-poll-crash.c
+++ b/test/double-poll-crash.c
@@ -52,10 +52,14 @@ static long syz_io_uring_setup(volatile long a0, volatile long a1,
   *ring_ptr_out = mmap(vma1, ring_sz, PROT_READ | PROT_WRITE,
                        MAP_SHARED | MAP_POPULATE | MAP_FIXED, fd_io_uring,
                        IORING_OFF_SQ_RING);
+  if (*ring_ptr_out == MAP_FAILED)
+    exit(0);
   uint32_t sqes_sz = setup_params->sq_entries * SIZEOF_IO_URING_SQE;
   *sqes_ptr_out =
       mmap(vma2, sqes_sz, PROT_READ | PROT_WRITE,
            MAP_SHARED | MAP_POPULATE | MAP_FIXED, fd_io_uring, IORING_OFF_SQES);
+  if (*sqes_ptr_out == MAP_FAILED)
+    exit(0);
   return fd_io_uring;
 }
 
@@ -108,6 +112,7 @@ uint64_t r[4] = {0xffffffffffffffff, 0x0, 0x0, 0xffffffffffffffff};
 
 int main(int argc, char *argv[])
 {
+  void *mmap_ret;
 #if !defined(__i386) && !defined(__x86_64__)
   return 0;
 #endif
@@ -115,8 +120,12 @@ int main(int argc, char *argv[])
   if (argc > 1)
     return 0;
 
-  mmap((void *)0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
-  mmap((void *)0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
+  mmap_ret = mmap((void *)0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
+  if (mmap_ret == MAP_FAILED)
+    return 0;
+  mmap_ret = mmap((void *)0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
+  if (mmap_ret == MAP_FAILED)
+    return 0;
   intptr_t res = 0;
   *(uint32_t*)0x20000484 = 0;
   *(uint32_t*)0x20000488 = 0;
-- 
Ammar Faizi

