Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142B256456E
	for <lists+io-uring@lfdr.de>; Sun,  3 Jul 2022 08:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiGCGon (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jul 2022 02:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiGCGon (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jul 2022 02:44:43 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0B164D0
        for <io-uring@vger.kernel.org>; Sat,  2 Jul 2022 23:44:42 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id A32C2801D5;
        Sun,  3 Jul 2022 06:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656830681;
        bh=n0MhH4UJwahD5/LSJRmoCIUvNRpxnmSnrXpfUHPvIiw=;
        h=From:To:Cc:Subject:Date:From;
        b=npp8mskjLvriH4eh1RXljkzT8cPWEsWHDfm0KPVzr70mLqtBf5x3wgzJBcHhMtpOF
         dgHddTgCuBhXIEhHFBs5dEg6pV8S4rm9coQPZ68712dKloG+7cSNIx5n1hRT9HapmP
         kefqPLB1uDntmTnU8EyXMbJPwqnDom98+Sdtg0fOahNNwrgpNLyZmhXey3J9Q1gSKQ
         gBWtU2qAhRWGCaSxxE4i9aX9Qs4KnEc83HGDBWc2bQ4NtyppoIktdS068+7qF/rWQ8
         k1NCqzNj3goTjn15Qmghf1J/B/DASUjx9CWlKJehdzQwTcEDXculzqsbIbxalj0J73
         e0V3nzkdwRZ7A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing] test/helpers: Use a proper cast for `(struct sockaddr *)` argument
Date:   Sun,  3 Jul 2022 13:44:05 +0700
Message-Id: <20220703063755.189175-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2031; i=ammarfaizi2@gnuweeb.org; h=from:subject; bh=KemLh7csRivuskefKnyeOdJ1j70scQpC1JqFAAJzVSo=; b=owEBbQGS/pANAwAKATZPujT/FwpLAcsmYgBiwTog8vL8JMtBUfR9HJpLp8fRqhdskg4/BZlFd56G CGIluw+JATMEAAEKAB0WIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCYsE6IAAKCRA2T7o0/xcKS3FjCA C+LfLaEhkUp/iAFS3NhMVwEs3uvv2s1oDxJWnEG4O7fTdeKuqtKjb3fOuFBnXA7/neZ+VD1Vnk7P+d Xfk7ANSLMqlGKui95QBcnyecuc64hpBRnT8ikeoUdkF/yyhjFdW/oBEb+yZ800HKc/xD7x07zcDpgw v7yz2OksmCbSchnSGCwegvqwi5ykVY4K+J2hxWc3qblzLJDYml+4UqvpF5+k4xfMyuPZwtTvSh5iUq ut61XMPWStpmo2zfVJFrmJEaWiSG3eOZS265AttTZvM7yOGpgn2o6Gd3PmXarSushErGK+YOdOyqaA t+SvUS7GU32tBp9I+1iz2/brixRHDx
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Sometimes the compiler accepts (struct sockaddr_in *) to be passed in
to (struct sockaddr *) without a cast. But not all compilers agree with
that. Building with clang 13.0.1 yields the following error:

  error: incompatible pointer types passing 'struct sockaddr_in *' to \
  parameter of type 'struct sockaddr *' [-Werror,-Wincompatible-pointer-types]

Explicitly cast the pointer to (struct sockaddr *) to avoid this error.

Cc: kernel-team@fb.com
Cc: Dylan Yudaken <dylany@fb.com>
Fixes: 9167905ca187064ba1d9ac4c8bb8484157bef86b ("add t_create_socket_pair")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/helpers.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/test/helpers.c b/test/helpers.c
index 3660cc0..0146533 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -190,26 +190,28 @@ int t_create_socket_pair(int fd[2], bool stream)
 		goto errno_cleanup;
 	}
 
-	if (getsockname(fd[0], &serv_addr, (socklen_t *)&paddrlen)) {
+	if (getsockname(fd[0], (struct sockaddr *)&serv_addr,
+			(socklen_t *)&paddrlen)) {
 		fprintf(stderr, "getsockname failed\n");
 		goto errno_cleanup;
 	}
 	inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr);
 
-	if (connect(fd[1], &serv_addr, paddrlen)) {
+	if (connect(fd[1], (struct sockaddr *)&serv_addr, paddrlen)) {
 		fprintf(stderr, "connect failed\n");
 		goto errno_cleanup;
 	}
 
 	if (!stream) {
 		/* connect the other udp side */
-		if (getsockname(fd[1], &serv_addr, (socklen_t *)&paddrlen)) {
+		if (getsockname(fd[1], (struct sockaddr *)&serv_addr,
+				(socklen_t *)&paddrlen)) {
 			fprintf(stderr, "getsockname failed\n");
 			goto errno_cleanup;
 		}
 		inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr);
 
-		if (connect(fd[0], &serv_addr, paddrlen)) {
+		if (connect(fd[0], (struct sockaddr *)&serv_addr, paddrlen)) {
 			fprintf(stderr, "connect failed\n");
 			goto errno_cleanup;
 		}

base-commit: 98c14a04e2c0dcdfbb71372a1a209ed889fb3e4d
-- 
Ammar Faizi

