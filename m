Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF4A58E415
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 02:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiHJAce (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 20:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiHJAcb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 20:32:31 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854A372ED1
        for <io-uring@vger.kernel.org>; Tue,  9 Aug 2022 17:32:30 -0700 (PDT)
Received: from integral2.. (unknown [180.246.144.41])
        by gnuweeb.org (Postfix) with ESMTPSA id 6845080872;
        Wed, 10 Aug 2022 00:32:27 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1660091550;
        bh=jCCTmOx9NmGfxdpLE7rPWkrAzBsa5pgaAzqzz83v3qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPiZd6Pba55KtFvWLD4mawnJsHniTZ5AvCqgUwbx6z6WKk/OrkPZJQdAJ7Drbsjiv
         h4su6R4m+KBm0bbWbp9CpS8rt1CFlUVXcvxSCAQSIOfIYnFtwAS7ulF+lfniv1Ta6k
         HVLpSrF8qng1UwSsogd6ZcPdQxQ3YdQKLOtJ5XlYJEfv+FvFEcalJgqbdWTYnhpIZn
         q3OJS09eFSdaawAldxOMQs4FNd6l0KCdgUNBk30m7Y28JcSf6EG4K8nM5EH9a2zZ98
         L0P2YwUrMhH0WMDjRPz3iNIIhdYe2Hz5ELecCJJmdWPACU4BXs202FjMtyXDoEGC4z
         CfNxSf/kLAf6A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 01/10] test/cq-overflow: Don't call `io_uring_queue_exit()` if the ring is not initialized
Date:   Wed, 10 Aug 2022 07:31:50 +0700
Message-Id: <20220810002735.2260172-2-ammar.faizi@intel.com>
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

Don't call `io_uring_queue_exit()` if the ring is not initialized.

Fix this:

  + valgrind -q ./cq-overflow.t
  file open: Invalid argument
  ==3054159== Use of uninitialised value of size 8
  ==3054159==    at 0x10A863: io_uring_queue_exit (setup.c:183)
  ==3054159==    by 0x1095DE: test_io.constprop.0 (cq-overflow.c:148)
  ==3054159==    by 0x109266: main (cq-overflow.c:269)
  ==3054159==
  ==3054159== Invalid read of size 4
  ==3054159==    at 0x10A863: io_uring_queue_exit (setup.c:183)
  ==3054159==    by 0x1095DE: test_io.constprop.0 (cq-overflow.c:148)
  ==3054159==    by 0x109266: main (cq-overflow.c:269)
  ==3054159==  Address 0x0 is not stack'd, malloc'd or (recently) free'd
  ==3054159==
  ==3054159==
  ==3054159== Process terminating with default action of signal 11 (SIGSEGV): dumping core
  ==3054159==  Access not within mapped region at address 0x0

Link: https://github.com/axboe/liburing/issues/640
Reported-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/cq-overflow.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/test/cq-overflow.c b/test/cq-overflow.c
index 0018081..312b414 100644
--- a/test/cq-overflow.c
+++ b/test/cq-overflow.c
@@ -33,14 +33,15 @@ static int test_io(const char *file, unsigned long usecs, unsigned *drops, int f
 	fd = open(file, O_RDONLY | O_DIRECT);
 	if (fd < 0) {
 		perror("file open");
-		goto err;
+		return 1;
 	}
 
 	memset(&p, 0, sizeof(p));
 	ret = io_uring_queue_init_params(ENTRIES, &ring, &p);
 	if (ret) {
+		close(fd);
 		fprintf(stderr, "ring create failed: %d\n", ret);
-		goto err;
+		return 1;
 	}
 	nodrop = 0;
 	if (p.features & IORING_FEAT_NODROP)
-- 
Ammar Faizi

