Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BAC58E418
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 02:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiHJAck (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 20:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiHJAci (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 20:32:38 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F306778208
        for <io-uring@vger.kernel.org>; Tue,  9 Aug 2022 17:32:37 -0700 (PDT)
Received: from integral2.. (unknown [180.246.144.41])
        by gnuweeb.org (Postfix) with ESMTPSA id AB91580818;
        Wed, 10 Aug 2022 00:32:35 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1660091557;
        bh=Goxkml2Kgc8NNLi9Lw2CvK/OUKT6Ntuv+SVwp3+YSco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZGJJ6xpjjSV6EwuOxol+onVm/EJGPmdKObiQe1zu1Vk8MukjW9jrsWnGS8adT7mP
         tLCbLovl2kaojliBG2O5zlHxk5fIUMr0st99gz2903rV40sR6J8TPLVo5dZZGnzvCD
         5lqZsMHDkc2rXNZD/c60w4+vMtOCQmkoHnaiA0m8NdA2ih/IWScCsACqOD107zvNdH
         cr+EHyppVfkyNllJZGa8daJhxQuHfGOy9IhO/+PRw7Yva0Vk9lB6pmzLv2qdjTna9v
         19A8xdgb0SCkKchP7IoztbASnz2LC02sHNZREuS8ssHtDWkECIYvcQ1L66RA/C8/HU
         Bz47oy4seg63A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 04/10] test/fixed-reuse: Fix reading from uninitialized array
Date:   Wed, 10 Aug 2022 07:31:53 +0700
Message-Id: <20220810002735.2260172-5-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220810002735.2260172-1-ammar.faizi@intel.com>
References: <20220810002735.2260172-1-ammar.faizi@intel.com>
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

Fix this:

  ==2253268== Conditional jump or move depends on uninitialised value(s)
  ==2253268==    at 0x109F0E: test (fixed-reuse.c:109)
  ==2253268==    by 0x109A62: main (fixed-reuse.c:147)

Link: https://github.com/axboe/liburing/issues/640
Reported-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/fixed-reuse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/fixed-reuse.c b/test/fixed-reuse.c
index 401251a..a248e35 100644
--- a/test/fixed-reuse.c
+++ b/test/fixed-reuse.c
@@ -26,7 +26,7 @@ static int test(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
-	char buf[BSIZE];
+	char buf[BSIZE] = { };
 	int ret, i;
 
 	/* open FNAME1 in slot 0 */
-- 
Ammar Faizi

