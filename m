Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED84D728D5A
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 03:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238035AbjFIByd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jun 2023 21:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238070AbjFIByb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jun 2023 21:54:31 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F16B30C5;
        Thu,  8 Jun 2023 18:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1686275670;
        bh=2/3SoDIX3vrChjKBTv9JJ2yq/9SZSLOJUI2W0FfW2Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=LezYDbKKugpJLMsdUR5RfusWU2WaxP+vwCa0BBn0RLAFryZkB+Dcw1bu/7l38cTyo
         fmOCjOgbPgcBOPZfV/qyxdzI/9PpzLPwVIY9JwkY5YbzL0HlSVpfGHsbcEcL1iztWJ
         R69/zFTgi8g7K8/NC6QYpTEGP1DSNkQbhAmPb6pIZSWHVmdlmDHsHm6IjExu11Q7YM
         dyZ2Qku395QCJ67QUqbQuUyKvLqlNt+fdeb8sNkIWDjrQ5pLbMedh9GG7NZIaOXsIV
         ttOUlImZvYJPr5TDHrs9JS1UVGhbip3r06D5Jw89qcGmnFYil6h+YosGN4iiN7e+js
         9Vs9RBbMBHBWA==
Received: from integral2.. (unknown [103.74.5.63])
        by gnuweeb.org (Postfix) with ESMTPSA id 1D19123EC15;
        Fri,  9 Jun 2023 08:54:27 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing v1 2/2] man/io_uring_for_each_cqe: Explicitly tell it's a macro and add an example
Date:   Fri,  9 Jun 2023 08:54:03 +0700
Message-Id: <20230609015403.3523811-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609015403.3523811-1-ammarfaizi2@gnuweeb.org>
References: <20230609015403.3523811-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Let the reader directly know that it's not a function, but a macro.
Also, give a simple example of its usage.

Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 man/io_uring_for_each_cqe.3 | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/man/io_uring_for_each_cqe.3 b/man/io_uring_for_each_cqe.3
index 8445fd605d0b02a6..78d8f6fc168d12e3 100644
--- a/man/io_uring_for_each_cqe.3
+++ b/man/io_uring_for_each_cqe.3
@@ -17,7 +17,7 @@ io_uring_for_each_cqe \- iterate pending completion events
 .PP
 The
 .BR io_uring_for_each_cqe (3)
-helper iterates completion events belonging to the
+is a macro helper that iterates completion events belonging to the
 .I ring
 using
 .I head
@@ -35,6 +35,24 @@ calling
 .BR io_uring_cqe_seen (3)
 for each of them.
 
+.SH EXAMPLE
+.EX
+void handle_cqes(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	unsigned head;
+	unsigned i = 0;
+
+	io_uring_for_each_cqe(ring, head, cqe) {
+		/* handle completion */
+		printf("cqe: %d\\n", cqe->res);
+		i++;
+	}
+
+	io_uring_cq_advance(ring, i);
+}
+.EE
+
 .SH RETURN VALUE
 None
 .SH SEE ALSO
-- 
Ammar Faizi

