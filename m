Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81B458E419
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 02:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiHJAcm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 20:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiHJAcl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 20:32:41 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CEE7170C
        for <io-uring@vger.kernel.org>; Tue,  9 Aug 2022 17:32:40 -0700 (PDT)
Received: from integral2.. (unknown [180.246.144.41])
        by gnuweeb.org (Postfix) with ESMTPSA id 48DC380866;
        Wed, 10 Aug 2022 00:32:38 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1660091560;
        bh=s+qeufJzYyP7r6zLUww1VcpAkPWWD8ekEFqTI/SrShg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kh+T0N3oYbPegKbCiQfFAk+QDxc/OM6wZRItSPDDg/dXVvwKZ2UQ/Z9F0urcYqac3
         OntEM+21fWX4TurFBRONgZBy64hmu99pt7uO+jYVnEFLZ4pQkhvq25YL3SIsbmZbb+
         rUlI0W0n56GUYAVqb8YopuXZzkpvuJ7RjzIH/p/67cotI9AkQ3gMOKPukhYhw2Hk8w
         UYYi7F2w+9utOgwQBL8IoSMoyHhHGEWUDpPieSIq0uZqDumEbKRVaXIsgxWdleCcdH
         eDSHctJ9DdXS/oJ9dyhrz1CxBlwTQG9Is/CtxLK1ZPpNphnjPjZmhRlFMfnnU/g5JF
         ib5mIb+YuheIA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 05/10] test/fpos: Fix reading from uninitialized buffer
Date:   Wed, 10 Aug 2022 07:31:54 +0700
Message-Id: <20220810002735.2260172-6-ammar.faizi@intel.com>
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

  ==3054875== Conditional jump or move depends on uninitialised value(s)
  ==3054875==    at 0x109898: test_read (fpos.c:109)
  ==3054875==    by 0x109898: main (fpos.c:243)
  ==3054875==
  ==3054875== Conditional jump or move depends on uninitialised value(s)
  ==3054875==    at 0x10987B: test_read (fpos.c:111)
  ==3054875==    by 0x10987B: main (fpos.c:243)

Link: https://github.com/axboe/liburing/issues/640
Reported-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/fpos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/test/fpos.c b/test/fpos.c
index 4ffa22d..4c36f11 100644
--- a/test/fpos.c
+++ b/test/fpos.c
@@ -52,6 +52,9 @@ static int test_read(struct io_uring *ring, bool async, int blocksize)
 	unsigned char buff[QUEUE_SIZE * blocksize];
 	unsigned char reordered[QUEUE_SIZE * blocksize];
 
+	memset(buff, 0, QUEUE_SIZE * blocksize);
+	memset(reordered, 0, QUEUE_SIZE * blocksize);
+
 	create_file(".test_fpos_read", FILE_SIZE);
 	fd = open(".test_fpos_read", O_RDONLY);
 	unlink(".test_fpos_read");
-- 
Ammar Faizi

