Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A196158E417
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 02:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiHJAci (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 20:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiHJAcg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 20:32:36 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D68674E0E
        for <io-uring@vger.kernel.org>; Tue,  9 Aug 2022 17:32:35 -0700 (PDT)
Received: from integral2.. (unknown [180.246.144.41])
        by gnuweeb.org (Postfix) with ESMTPSA id 2699880866;
        Wed, 10 Aug 2022 00:32:32 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1660091555;
        bh=99QuzWpQ2m326XNPxrLiBmn8OFsQT+YXxjXSNENxBuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hoQXYtDOqOOuKvMWB0ePrSvCChRvgip+iVXVIEo+QnqPvWnhA2wqfTJ6ZoNH3aFH7
         kvR33d14jrTAHY8yNloaT4gAJ/QgZBcf3rHvrnz19tRNukabDeXkuMK75WhCbj4WEC
         nLNme1m/2OY1+cOG8hqqXYxTCNopooIvxodQmYlIoALtxRgN9xWS9pit80kLx4AI4N
         jy0d77QGrbCdYEAkwvJZUDrpaYyGBgK1L4ei464QgkmOKA0IWY5UiMyjWOJ4heZ0l9
         fE2AGOtVN+gzK9Ovs2PJRT6Rfh9+U7+c7a6J8LddTGIJxz2Q/MnQ5X4IOq9c0Yw+1H
         YNwRL7gvSPyXg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 03/10] test/file-verify: Fix reading from uninitialized buffer
Date:   Wed, 10 Aug 2022 07:31:52 +0700
Message-Id: <20220810002735.2260172-4-ammar.faizi@intel.com>
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

  ==3054556== Conditional jump or move depends on uninitialised value(s)
  ==3054556==    at 0x1099DB: verify_buf (file-verify.c:48)
  ==3054556==    by 0x10A506: test (file-verify.c:449)
  ==3054556==    by 0x109353: main (file-verify.c:538)

Link: https://github.com/axboe/liburing/issues/640
Reported-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/file-verify.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/test/file-verify.c b/test/file-verify.c
index 595dafd..b1a8fd4 100644
--- a/test/file-verify.c
+++ b/test/file-verify.c
@@ -347,13 +347,16 @@ static int test(struct io_uring *ring, const char *fname, int buffered,
 				void *ptr;
 
 				t_posix_memalign(&ptr, 4096, CHUNK_SIZE / nr_vecs);
+				memset(ptr, 0, CHUNK_SIZE / nr_vecs);
 				vecs[j][i].iov_base = ptr;
 				vecs[j][i].iov_len = CHUNK_SIZE / nr_vecs;
 			}
 		}
 	} else {
-		for (j = 0; j < READ_BATCH; j++)
+		for (j = 0; j < READ_BATCH; j++) {
 			t_posix_memalign(&buf[j], 4096, CHUNK_SIZE);
+			memset(buf[j], 0, CHUNK_SIZE);
+		}
 		nr_vecs = 0;
 	}
 
-- 
Ammar Faizi

