Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0135817C6
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 18:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbiGZQpJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 12:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239010AbiGZQpI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 12:45:08 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8666103
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 09:45:06 -0700 (PDT)
Received: from integral2.. (unknown [125.160.106.238])
        by gnuweeb.org (Postfix) with ESMTPSA id D27207E254;
        Tue, 26 Jul 2022 16:45:03 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658853906;
        bh=/eUd7bmBYeMu1TkW7KfYCNBj5f6Xq9Yxi+IljF55o24=;
        h=From:To:Cc:Subject:Date:From;
        b=QUcOKx3O/ATjiqvfobKyJZ/KJgJAZYivXK/TGiE5PV77NwjJVbsN45v359aAlNU12
         kgq4zSOJABJPQTgx5EQKrkBsT2710qNzfbSEPaDevTgkpQWct8/Xmj+6xHHq6339KI
         ed7wzunk9zwBPY2Dnaaw3wLu/nWFW/5n6UmJhRLi6Svi1w+jx8KRCfquGYHV1FhzMx
         1U+OzjUM1GTrTzZh2CSOyFLVm6NEPg+Dm7JsSiKNv13D+50KVQVJnloGtaHazBtD4i
         9HvQMO1TDR3izQlXvEJWDyWP7uIFtpU4lONJmrLCFNlCRHTHQ7UdpZATxmJjsl/A7R
         jEhgGaIXzplBw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>
Subject: [PATCH liburing] examples/io_uring-udp: Use a proper cast for `(struct sockaddr *)` argument
Date:   Tue, 26 Jul 2022 23:44:59 +0700
Message-Id: <20220726164310.266060-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
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

Sometimes the compiler accepts `(struct sockaddr_in *)` and
`(struct sockaddr_in6 *)` to be passed in to `(struct sockaddr *)`
without a cast. But not all compilers agree with that. Building with
clang 13.0.1 yields the following errors:

    io_uring-udp.c:134:18: error: incompatible pointer types passing \
    'struct sockaddr_in6 *' to parameter of type 'const struct sockaddr *' \
    [-Werror,-Wincompatible-pointer-types

    io_uring-udp.c:142:18: error: incompatible pointer types passing \
    'struct sockaddr_in *' to parameter of type 'const struct sockaddr *' \
    [-Werror,-Wincompatible-pointer-types]

Explicitly cast the pointer to (struct sockaddr *) to avoid this error.

Cc: Dylan Yudaken <dylany@fb.com>
Cc: Facebook Kernel Team <kernel-team@fb.com>
Fixes: 61d472b51e761e61cbf46caea40aaf40d8ed1484 ("add an example for a UDP server")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 examples/io_uring-udp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/examples/io_uring-udp.c b/examples/io_uring-udp.c
index 77472df..b4ef0a3 100644
--- a/examples/io_uring-udp.c
+++ b/examples/io_uring-udp.c
@@ -131,7 +131,7 @@ static int setup_sock(int af, int port)
 			.sin6_addr = IN6ADDR_ANY_INIT
 		};
 
-		ret = bind(fd, &addr6, sizeof(addr6));
+		ret = bind(fd, (struct sockaddr *) &addr6, sizeof(addr6));
 	} else {
 		struct sockaddr_in addr = {
 			.sin_family = af,
@@ -139,7 +139,7 @@ static int setup_sock(int af, int port)
 			.sin_addr = { INADDR_ANY }
 		};
 
-		ret = bind(fd, &addr, sizeof(addr));
+		ret = bind(fd, (struct sockaddr *) &addr, sizeof(addr));
 	}
 
 	if (ret) {

base-commit: 61d472b51e761e61cbf46caea40aaf40d8ed1484
-- 
Ammar Faizi

