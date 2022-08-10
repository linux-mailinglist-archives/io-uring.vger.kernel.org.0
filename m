Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9133058E416
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 02:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiHJAcf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 20:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiHJAce (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 20:32:34 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB2574DC4
        for <io-uring@vger.kernel.org>; Tue,  9 Aug 2022 17:32:32 -0700 (PDT)
Received: from integral2.. (unknown [180.246.144.41])
        by gnuweeb.org (Postfix) with ESMTPSA id 8E6FD80912;
        Wed, 10 Aug 2022 00:32:30 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1660091552;
        bh=C+Gye3EZvIlcGxNj4W91LXbelCn3L8bXgOsHnXKjJU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAqdgiGfHa5YB4d6CoDHw57wmBfqwhGXBEUM+Fj5u+PqlMvTqqLjr27CAwdV0N9eN
         7cFBMzSWSYATLotjQ63jcktuKO/M5jNRlV8OTIDJ8WHLbQqGmjl7FJfZow9U3ArLVz
         iZdTM/v3JZX7ACXHseCodOlASFdPK5CHXEbPJp+/Bpas0L9fPdL+eLoHa5aLGobusu
         +1L4MToi548jwl1tsoJ+h8UpSGyxy7/cy/PIc/qLfvuqMYBj16JPQ4g+fKjPJUTCJp
         vJIHHWgY9z2iVA+8nsJQXD2m13dcEd9yhbzjqx7O+bjGxn47T+1brc0vaLSJYnzBaz
         9EjAm4dLj+yPw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 02/10] test/eeed8b54e0df: Initialize the `malloc()`ed buffer before `write()`
Date:   Wed, 10 Aug 2022 07:31:51 +0700
Message-Id: <20220810002735.2260172-3-ammar.faizi@intel.com>
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

... to avoid valgrind's complaint:

  ==3054187== Syscall param write(buf) points to uninitialised byte(s)
  ==3054187==    at 0x4958E63: write (write.c:26)
  ==3054187==    by 0x109283: get_file_fd (eeed8b54e0df.c:36)
  ==3054187==    by 0x109283: main (eeed8b54e0df.c:85)
  ==3054187==  Address 0x4a63080 is 0 bytes inside a block of size 4,096 alloc'd
  ==3054187==    at 0x484479B: malloc (vg_replace_malloc.c:380)
  ==3054187==    by 0x109698: t_malloc (helpers.c:22)
  ==3054187==    by 0x109270: get_file_fd (eeed8b54e0df.c:35)
  ==3054187==    by 0x109270: main (eeed8b54e0df.c:85)

Link: https://github.com/axboe/liburing/issues/640
Reported-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/eeed8b54e0df.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test/eeed8b54e0df.c b/test/eeed8b54e0df.c
index b388b12..b8149f2 100644
--- a/test/eeed8b54e0df.c
+++ b/test/eeed8b54e0df.c
@@ -33,6 +33,7 @@ static int get_file_fd(void)
 	}
 
 	buf = t_malloc(BLOCK);
+	memset(buf, 0, BLOCK);
 	ret = write(fd, buf, BLOCK);
 	if (ret != BLOCK) {
 		if (ret < 0)
-- 
Ammar Faizi

