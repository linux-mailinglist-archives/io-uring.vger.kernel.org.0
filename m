Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F9F50C124
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 23:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiDVViX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 17:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiDVViO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 17:38:14 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643CD409D0F
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 13:42:39 -0700 (PDT)
Received: from integral2.. (unknown [36.72.214.135])
        by gnuweeb.org (Postfix) with ESMTPSA id 7FE287E75C;
        Fri, 22 Apr 2022 20:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1650659761;
        bh=thtvMtwBmerkybcm1/sZAvLVZE8w3Wv4HAsvD4AvwRw=;
        h=From:To:Cc:Subject:Date:From;
        b=khvCywoF6CU0by674tbajZeD8/29U/5lrIl32douyo+xVgJmAbCrR8yZz4RdvauK3
         sJAnqIkpvrIDzWjgWQLfcB0+KF+UV7YVuodVWQpz1q2mSJ7IAooo+AMIrDcTwIqiKr
         IRXK+rCZKGoAXLKe9BQB12JGwPkXKN/Ug6t1l0hJBCe2rZR1gHuAD353LMgiBdcY5r
         N5OIi6T7bA07BwrmrDiREFQCGRTncbXGfAG85AvqqmywfHiGSxgqGh+wDHbvYbZ/jL
         nBI5F+qex/ciPyAb+H0Ea23ZyL5sbydLfe2jyov+9FIQCGWBBHOPEMKCnPIPydS9pI
         EVEOE+mekJp/A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 0/6] liburing fixes and cleanups
Date:   Sat, 23 Apr 2022 03:35:36 +0700
Message-Id: <20220422203340.682723-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1056; h=from:subject:message-id; bh=s1C6p55dGEBiPoijBRkAGFfg+5ckbQ9VS0oYtL6IyGw=; b=owEBbQGS/pANAwAKATZPujT/FwpLAcsmYgBiYxFrPCY5NHDGHEEhSrZ0uR8tb8SanL/SkMwdhJzE wTRmFFmJATMEAAEKAB0WIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCYmMRawAKCRA2T7o0/xcKS02/CA DkTU7p4gRGJ8TIw8tsXSTkqWxY+TNa9m4eSCK6ZzCN70En99tIAtiRgc4S4HtJHaJLtuAW+J/ZKznB cdH4S+wa13NLh3VNHLnAlvpZ9bq2fse/5A62dFgxzazisAe8owtRVByrDQujwRP+jenC7MeusMx/1P nc5vjeNsmMXe5cDiaN6TJOe7RmjK61ZB3rdADDOcrGIypeL8Egy0zpmSqDFslQOfFtg1Rh+ZeAYECH 9XKDPRBTjvCd5+V+67+WE0kVhFn+rvLh9lN0yFKz5xbp5/JwqLw86FIzMpD5AAcrSRm0GE5PXYJmBk xTRj85MDS1/Ki21VIQa6IZGcIr20OR
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

Hi Jens,

Small liburing fixes and cleanups this time:

- Patch 1 and 2 are a fix for the recent updates from Dylan.
- Patch 3 and 4 are a Makefile cleanup.
- Patch 5 is an update for the GitHub bot to build x86 32-bit nolibc.
- Patch 6 is a workaround for random SIGSEGV error on test/double-poll-crash.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (6):
  test/runtests-quiet.sh: Fixup redirection
  Makefile: Make sure we build everything before runtests
  test/Makefile: Remove `.PHONY` variable
  test/Makefile: Sort the test file list alphabetically
  .github/workflows: Run the nolibc build for x86 32-bit
  test/double-poll-crash: Skip this test if the `mmap()` fails

 .github/workflows/build.yml |  2 +-
 Makefile                    |  4 ++--
 test/Makefile               |  4 ++--
 test/double-poll-crash.c    | 13 +++++++++++--
 test/runtests-quiet.sh      |  2 +-
 5 files changed, 17 insertions(+), 8 deletions(-)


base-commit: 770efd14e8b17ccf23a45c95ecc9d38de4e17011
-- 
Ammar Faizi

