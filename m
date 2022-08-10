Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C366858E41A
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 02:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiHJAcq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 20:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiHJAco (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 20:32:44 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB2274DC4
        for <io-uring@vger.kernel.org>; Tue,  9 Aug 2022 17:32:43 -0700 (PDT)
Received: from integral2.. (unknown [180.246.144.41])
        by gnuweeb.org (Postfix) with ESMTPSA id D3FEE807CA;
        Wed, 10 Aug 2022 00:32:40 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1660091562;
        bh=2+2WbL9YQE9VVPKsr5JbG+UxqwYgXsXaBDlTThv95To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJLp6Zm8LXtI2WkM2BJ/tefd5jKN/5KKOROYcooCUnSebPzdfGQw2kppPH6+6K6eH
         bRMX7h7drssL1iWyQC2/hguGTK7JEynzIV0VJxvvQYduN4dG0EZyvphRvgdugfyedW
         r1qjcSdkdlXNLiSqnceVJugHZvWshzZVSaz/+DG/rrs+ry8IKJMO1Mv9RwCEs22M0M
         UDzSMmbIvXaQ0T6wElC+PU6K2FFRWdxtij/32VRizHcQ1eBN55r87erdmlwoeNW4Wp
         qhm0OEfwE07iB0tJRs3248YW4an+QPp5tb9BFYQfiAZZud+tnL1DuesZLTmTJBW8Wn
         zPNnOvMY3fU4g==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 06/10] test/statx: Fix reading from uninitialized buffer
Date:   Wed, 10 Aug 2022 07:31:55 +0700
Message-Id: <20220810002735.2260172-7-ammar.faizi@intel.com>
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

  ==3062618== Conditional jump or move depends on uninitialised value(s)
  ==3062618==    at 0x484D65E: bcmp (vg_replace_strmem.c:1129)
  ==3062618==    by 0x109304: test_statx (statx.c:71)
  ==3062618==    by 0x109304: main (statx.c:149)

Link: https://github.com/axboe/liburing/issues/640
Reported-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/statx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/statx.c b/test/statx.c
index 5fa086e..4ae3452 100644
--- a/test/statx.c
+++ b/test/statx.c
@@ -40,7 +40,7 @@ static int test_statx(struct io_uring *ring, const char *path)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
-	struct statx x1, x2;
+	struct statx x1 = { }, x2 = { };
 	int ret;
 
 	sqe = io_uring_get_sqe(ring);
-- 
Ammar Faizi

