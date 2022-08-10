Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CB358E41E
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 02:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiHJAc4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 20:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiHJAcy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 20:32:54 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920807C184
        for <io-uring@vger.kernel.org>; Tue,  9 Aug 2022 17:32:53 -0700 (PDT)
Received: from integral2.. (unknown [180.246.144.41])
        by gnuweeb.org (Postfix) with ESMTPSA id 16F2E807CA;
        Wed, 10 Aug 2022 00:32:50 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1660091573;
        bh=6G26TH3u8k3JCLyT8Jc7GHih4BvnsCUEfWTRbUwRZ+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AosnPtO6hlMFRmapzSsNK1ZnTodMdNq8zZpfJIJ7ZWfG18PrXNg1D4gWXuI5N7ua1
         teSXnRY5X4aIXFFbgnpj+SzETi7YY6rtDgpr4DE8MAkUbKV3qI9C12ZnKETIcDMOtv
         HcWiOBYZoi9THiqa8nzOv+6/RFv0L4dhmmPZ4Xi9Tgb/ZNNcyumaVLVCwi8HlhAnhN
         fya/SfAJM8Jufd48xzbInE5uteCwv2rdvV8Q1z30syrUIaI8Mv0dQvO6rL3CuStttA
         eDhQIl9xambDZXPecEyWIA8SngXoihRZCk1xfLngh6T5tjJnwgbjbD1x1zYIdnrFzC
         /iorHjPaCx1QQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 10/10] test/file-register: Fix reading from uninitialized buffer
Date:   Wed, 10 Aug 2022 07:31:59 +0700
Message-Id: <20220810002735.2260172-11-ammar.faizi@intel.com>
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

  ==2256677== Conditional jump or move depends on uninitialised value(s)
  ==2256677==    at 0x485207E: bcmp (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
  ==2256677==    by 0x10BEAE: test_fixed_read_write (file-register.c:489)
  ==2256677==    by 0x10AED2: test_skip (file-register.c:595)
  ==2256677==    by 0x10AED2: main (file-register.c:1087)

Link: https://github.com/axboe/liburing/issues/640
Reported-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/file-register.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/file-register.c b/test/file-register.c
index 634ef81..0a8aa57 100644
--- a/test/file-register.c
+++ b/test/file-register.c
@@ -431,7 +431,7 @@ static int test_fixed_read_write(struct io_uring *ring, int index)
 	iov[0].iov_len = 4096;
 	memset(iov[0].iov_base, 0x5a, 4096);
 
-	iov[1].iov_base = t_malloc(4096);
+	iov[1].iov_base = t_calloc(1, 4096);
 	iov[1].iov_len = 4096;
 
 	sqe = io_uring_get_sqe(ring);
-- 
Ammar Faizi

