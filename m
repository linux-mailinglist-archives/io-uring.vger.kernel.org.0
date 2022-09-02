Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC785AA892
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 09:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbiIBHPg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 03:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbiIBHPc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 03:15:32 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9200C27CFE
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 00:15:31 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.70.226])
        by gnuweeb.org (Postfix) with ESMTPSA id 817AB80C57;
        Fri,  2 Sep 2022 07:15:27 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662102931;
        bh=lZw4entFoarpqtxNEsuI3QpY8fUls6MsgylWRSF/gFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJwKH9iLze8+Cv7ToS8KMYgZvEubbfTc89gFwj8+CvMZG8DhDdXYM4zXBV4T/rbq3
         C8VaOWpFEGB+U6Y61iEqEbWJBHZlJUrPFoReMTbFFj1CcPVEV2lt+BpFT8jFA7Zm7f
         /wY8aqhK4grXqcK8wJvK2DIewMhG1NZx1oBslp2B2emO44US0ADmPKMenhr4erIfuM
         nCO2uYZkEbwiEcxm6EOSChJp8ZPWjp4+aR6VloHQZRZqs2YzlhusghEQClBnoPALMP
         dYM69mjs6SdBP/rAOyAe7G2DCurSzjDVw+U1zrBJjxuf4B4+o5pBHm4KnUcvS3+cIu
         eYfuqd6Aa0KjQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: [PATCH liburing v2 01/12] test/helpers: Add `t_bind_ephemeral_port()` function
Date:   Fri,  2 Sep 2022 14:14:54 +0700
Message-Id: <20220902071153.3168814-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220902071153.3168814-1-ammar.faizi@intel.com>
References: <20220902071153.3168814-1-ammar.faizi@intel.com>
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

This is a prep patch to fix an intermittent issue with the port number.

We have many places where we need to bind() a socket to any unused port
number. To achieve that, the current approach does one of the following
mechanisms:

  1) Randomly brute force the port number until the bind() syscall
     succeeds.

  2) Use a static port at compile time (randomly chosen too).

This is not reliable and it results in an intermittent issue (test
fails when the selected port is in use).

Setting @addr->sin_port to zero on a bind() syscall lets the kernel
choose a port number that is not in use. The caller then can know the
port number to be bound by invoking a getsockname() syscall after
bind() succeeds.

Wrap this procedure in a new function called t_bind_ephemeral_port().
The selected port will be returned into @addr->sin_port, the caller
can use it later to connect() or whatever they need.

Link: https://lore.kernel.org/r/918facd1-78ba-2de7-693a-5f8c65ea2fcd@gnuweeb.org
Cc: Dylan Yudaken <dylany@fb.com>
Cc: Facebook Kernel Team <kernel-team@fb.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Tested-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/helpers.c | 18 ++++++++++++++++++
 test/helpers.h |  7 +++++++
 2 files changed, 25 insertions(+)

diff --git a/test/helpers.c b/test/helpers.c
index 0146533..4d5c402 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -24,14 +24,32 @@ void *t_malloc(size_t size)
 {
 	void *ret;
 	ret = malloc(size);
 	assert(ret);
 	return ret;
 }
 
+/*
+ * Helper for binding socket to an ephemeral port.
+ * The port number to be bound is returned in @addr->sin_port.
+ */
+int t_bind_ephemeral_port(int fd, struct sockaddr_in *addr)
+{
+	socklen_t addrlen;
+
+	addr->sin_port = 0;
+	if (bind(fd, (struct sockaddr *)addr, sizeof(*addr)))
+		return -errno;
+
+	addrlen = sizeof(*addr);
+	assert(!getsockname(fd, (struct sockaddr *)addr, &addrlen));
+	assert(addr->sin_port != 0);
+	return 0;
+}
+
 /*
  * Helper for allocating size bytes aligned on a boundary.
  */
 void t_posix_memalign(void **memptr, size_t alignment, size_t size)
 {
 	int ret;
 	ret = posix_memalign(memptr, alignment, size);
diff --git a/test/helpers.h b/test/helpers.h
index 6d5726c..9ad9947 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -18,14 +18,21 @@ enum t_setup_ret {
 
 enum t_test_result {
 	T_EXIT_PASS   = 0,
 	T_EXIT_FAIL   = 1,
 	T_EXIT_SKIP   = 77,
 };
 
+/*
+ * Helper for binding socket to an ephemeral port.
+ * The port number to be bound is returned in @addr->sin_port.
+ */
+int t_bind_ephemeral_port(int fd, struct sockaddr_in *addr);
+
+
 /*
  * Helper for allocating memory in tests.
  */
 void *t_malloc(size_t size);
 
 
 /*
-- 
Ammar Faizi

