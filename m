Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F8B637D9D
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 17:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiKXQ32 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 11:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKXQ31 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 11:29:27 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D18170273
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 08:29:26 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id A9CD381754;
        Thu, 24 Nov 2022 16:29:22 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669307366;
        bh=Ov7T+cVML2fZWPau1xESLQDyLzqpY18IJ9L7HJxRzOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIBFbsbD/mCTU7jwTy94VYUTOgEke5VjBkoYDXe8R3CLW8xO5Fk0ucoeYtS/nQ57u
         v4PdC/s+zFggn9kvV3XIBIfSQnPyp5L1TCYRFqVCyiq4eKAYYS+5zKh9SnV1LZZ0JS
         lnXCUmag/nsWulKpdlH76tgQhiOqY4IVfP1FTJaDeSOZwse5qtw6N4amn0lnFJ2Dj9
         A4M9lm81+5ZDMu8bMO3vRVarWD6zPQVbIBWv9TBkH2uESm0U0ZNm1Uy1K+0gO0RJly
         /8/U8dh2lajJQ4ZURbHS8wmZQ70rZ4zxfcdDqc1QpkJTAXrIR0QpkoQBiPGr+rlvBe
         rkz/aNqt7P7JQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 3/8] test/io_uring_setup: Remove unused functions
Date:   Thu, 24 Nov 2022 23:28:56 +0700
Message-Id: <20221124162633.3856761-4-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124162633.3856761-1-ammar.faizi@intel.com>
References: <20221124162633.3856761-1-ammar.faizi@intel.com>
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

When marking all internal functions as static after an attempt to
integrate `-Wmissing-prototypes` flag. Unused functions are found:

  io_uring_setup.c:22:14: error: unused function 'features_string' [-Werror,-Wunused-function]
  static char *features_string(struct io_uring_params *p)
               ^
  io_uring_setup.c:44:14: error: unused function 'flags_string' [-Werror,-Wunused-function]
  static char *flags_string(struct io_uring_params *p)
               ^
  io_uring_setup.c:83:15: error: unused function 'dump_resv' [-Werror,-Wunused-function]
  static char * dump_resv(struct io_uring_params *p)
                ^
  3 errors generated.
  make[1]: *** [Makefile:215: io_uring_setup.t] Error 1
  make[1]: *** Waiting for unfinished jobs....

Remove them.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/io_uring_setup.c | 82 ++-----------------------------------------
 1 file changed, 2 insertions(+), 80 deletions(-)

diff --git a/test/io_uring_setup.c b/test/io_uring_setup.c
index d945421..9e1a353 100644
--- a/test/io_uring_setup.c
+++ b/test/io_uring_setup.c
@@ -19,86 +19,9 @@
 
 #include "../syscall.h"
 
-char *features_string(struct io_uring_params *p)
-{
-	static char flagstr[64];
-
-	if (!p || !p->features)
-		return "none";
-
-	if (p->features & ~IORING_FEAT_SINGLE_MMAP) {
-		snprintf(flagstr, 64, "0x%.8x", p->features);
-		return flagstr;
-	}
-
-	if (p->features & IORING_FEAT_SINGLE_MMAP)
-		strncat(flagstr, "IORING_FEAT_SINGLE_MMAP", 64 - strlen(flagstr));
-
-	return flagstr;
-}
-
-/*
- * Attempt the call with the given args.  Return 0 when expect matches
- * the return value of the system call, 1 otherwise.
- */
-char *
-flags_string(struct io_uring_params *p)
-{
-	static char flagstr[64];
-	int add_pipe = 0;
-
-	memset(flagstr, 0, sizeof(flagstr));
-
-	if (!p || p->flags == 0)
-		return "none";
-
-	/*
-	 * If unsupported flags are present, just print the bitmask.
-	 */
-	if (p->flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
-			 IORING_SETUP_SQ_AFF)) {
-		snprintf(flagstr, 64, "0x%.8x", p->flags);
-		return flagstr;
-	}
-
-	if (p->flags & IORING_SETUP_IOPOLL) {
-		strncat(flagstr, "IORING_SETUP_IOPOLL", 64 - strlen(flagstr));
-		add_pipe = 1;
-	}
-	if (p->flags & IORING_SETUP_SQPOLL) {
-		if (add_pipe)
-			strncat(flagstr, "|", 64 - strlen(flagstr));
-		else
-			add_pipe = 1;
-		strncat(flagstr, "IORING_SETUP_SQPOLL", 64 - strlen(flagstr));
-	}
-	if (p->flags & IORING_SETUP_SQ_AFF) {
-		if (add_pipe)
-			strncat(flagstr, "|", 64 - strlen(flagstr));
-		strncat(flagstr, "IORING_SETUP_SQ_AFF", 64 - strlen(flagstr));
-	}
-
-	return flagstr;
-}
-
-char *
-dump_resv(struct io_uring_params *p)
-{
-	static char resvstr[4096];
-
-	if (!p)
-		return "";
-
-	sprintf(resvstr, "0x%.8x 0x%.8x 0x%.8x", p->resv[0],
-		p->resv[1], p->resv[2]);
-
-	return resvstr;
-}
-
 /* bogus: setup returns a valid fd on success... expect can't predict the
    fd we'll get, so this really only takes 1 parameter: error */
-int
-try_io_uring_setup(unsigned entries, struct io_uring_params *p, int expect)
+int try_io_uring_setup(unsigned entries, struct io_uring_params *p, int expect)
 {
 	int ret;
 
@@ -123,8 +46,7 @@ try_io_uring_setup(unsigned entries, struct io_uring_params *p, int expect)
 	return 0;
 }
 
-int
-main(int argc, char **argv)
+int main(int argc, char **argv)
 {
 	int fd;
 	unsigned int status = 0;
-- 
Ammar Faizi

