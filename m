Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1F36684A5
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 21:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240784AbjALUzd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 15:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240516AbjALUxb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 15:53:31 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8434641D;
        Thu, 12 Jan 2023 12:35:20 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 656357E74E;
        Thu, 12 Jan 2023 20:35:16 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673555719;
        bh=BsX+perw1cIaTPd1KVpYjlhIo+yy6SOqhGMLkc38NU0=;
        h=From:To:Cc:Subject:Date:From;
        b=BpU2+6xOIYvK/qmT6kaaFF664myaakOOEAqHOhZiq6c8wsmPoQ6cdww/DVnz/ydFW
         pTzNjvHTu4jfv5GdWlxNlsIFcygPGrmFIeco/CuSdBFt9IqjuzT3abkuR1ItjLomv8
         +EdADiPT4pX96xtYBAp3yaJtrfIgGW0abmqaXrq1lwOcBwe9IQNSsiqxudPFqnBEiY
         LY1WXk368M7/prJ+FYAuGLplkSiEr2F7rkkcCyHfux520A4b9XeyE+sCwp16NXPm7l
         5pRDWaEsbr3crKPESAA6nxolR8B52/jJE3xrunnBQj0pPl50KYdKWIxzcGao+JCfMz
         3vfvSGTzof07A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Breno Leitao <leitao@debian.org>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Jiahao XU <Jiahao_XU@outlook.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing v1] man/io_uring_prep_splice.3: Fix description in io_uring_prep_splice() manpage
Date:   Fri, 13 Jan 2023 03:34:52 +0700
Message-Id: <20230112203452.317648-1-ammar.faizi@intel.com>
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

Commit 55bbe5b71c7d missed a review from Gabriel. It was blindly copied
from liburing.h comment with just a modification to support manpage
formatting. Fix that.

While in there, also fix the liburing.h from which that mistake comes.

Cc: Jiahao XU <Jiahao_XU@outlook.com>
Suggested-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://lore.kernel.org/io-uring/87bkn3ekbb.fsf@suse.de
Fixes: 55bbe5b71c7d ("man/io_uring_prep_splice.3: Explain more about io_uring_prep_splice()")
Fixes: d871f482d911 ("Add inline doc in the comments for io_uring_prep_splice")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 man/io_uring_prep_splice.3 | 12 +++++++-----
 src/include/liburing.h     | 27 +++++++++++++--------------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/man/io_uring_prep_splice.3 b/man/io_uring_prep_splice.3
index a177bc6..3d6e38f 100644
--- a/man/io_uring_prep_splice.3
+++ b/man/io_uring_prep_splice.3
@@ -55,16 +55,18 @@ given as a registered file descriptor offset.
 If
 .I fd_in
 refers to a pipe,
-.IR off_in
-must be -1.
+.I off_in
+is ignored and must be set to -1.
 
 If
 .I fd_in
 does not refer to a pipe and
 .I off_in
-is -1, then bytes are read from
+is -1, then
+.I nbytes
+are read from
 .I fd_in
-starting from the file offset and it is adjusted appropriately.
+starting from the file offset, which is incremented by the number of bytes read.
 
 If
 .I fd_in
@@ -112,7 +114,7 @@ Note that even if
 .I fd_in
 or
 .I fd_out
-refers to a pipe, the splice operation can still failed with
+refers to a pipe, the splice operation can still fail with
 .B EINVAL
 if one of the fd doesn't explicitly support splice operation, e.g. reading from
 terminal is unsupported from kernel 5.7 to 5.11.
diff --git a/src/include/liburing.h b/src/include/liburing.h
index c7139ef..41a58eb 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -383,26 +383,25 @@ IOURINGINLINE void io_uring_prep_rw(int op, struct io_uring_sqe *sqe, int fd,
 	sqe->__pad2[0] = 0;
 }
 
-/**
- * @pre Either fd_in or fd_out must be a pipe.
- * @param off_in If fd_in refers to a pipe, off_in must be (int64_t) -1;
- *		 If fd_in does not refer to a pipe and off_in is (int64_t) -1,
- *		 then bytes are read from fd_in starting from the file offset
- *		 and it is adjusted appropriately;
- *		 If fd_in does not refer to a pipe and off_in is not
- *		 (int64_t) -1, then the  starting offset of fd_in will be
- *		 off_in.
- * @param off_out The description of off_in also applied to off_out.
- * @param splice_flags see man splice(2) for description of flags.
+/*
+ * io_uring_prep_splice() - Either @fd_in or @fd_out must be a pipe.
+ *
+ * - If @fd_in refers to a pipe, @off_in is ignored and must be set to -1.
+ *
+ * - If @fd_in does not refer to a pipe and @off_in is -1, then @nbytes are read
+ *   from @fd_in starting from the file offset, which is incremented by the
+ *   number of bytes read.
+ *
+ * - If @fd_in does not refer to a pipe and @off_in is not -1, then the starting
+ *   offset of @fd_in will be @off_in.
  *
  * This splice operation can be used to implement sendfile by splicing to an
  * intermediate pipe first, then splice to the final destination.
  * In fact, the implementation of sendfile in kernel uses splice internally.
  *
  * NOTE that even if fd_in or fd_out refers to a pipe, the splice operation
- * can still failed with EINVAL if one of the fd doesn't explicitly support
- * splice operation, e.g. reading from terminal is unsupported from kernel 5.7
- * to 5.11.
+ * can still fail with EINVAL if one of the fd doesn't explicitly support splice
+ * operation, e.g. reading from terminal is unsupported from kernel 5.7 to 5.11.
  * Check issue #291 for more information.
  */
 IOURINGINLINE void io_uring_prep_splice(struct io_uring_sqe *sqe,

base-commit: 55bbe5b71c7d39c9ea44e5abb886846010c67baa
-- 
Ammar Faizi

