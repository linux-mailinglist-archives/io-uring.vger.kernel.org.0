Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2124659E537
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 16:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239296AbiHWOh0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 10:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243210AbiHWOgf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 10:36:35 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E482BCEDE;
        Tue, 23 Aug 2022 04:53:52 -0700 (PDT)
Received: from localhost.localdomain (unknown [125.160.110.187])
        by gnuweeb.org (Postfix) with ESMTPSA id F07F280A7A;
        Tue, 23 Aug 2022 11:52:52 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661255575;
        bh=5FCcSEkEjM0f53ffxeKLMsN7UlBLSLfk9y8UVqAo6DY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLf9Wu33hwVJeUoqTHldPH4VmVioyOH0vVkVcAbThYQxVfOfeB6oBV/tMlVffw7Lg
         m2mYVbVkGcToUf9e3R+Guzc8Ake6J5oio6ZFR0YQHJP3SpboiPoJHFyCT+D+11+0ak
         SAD2GxL6Xwo5+Rx1emx1eo+qc7TbbVnMWY2lRh4hC+lQyH8uefeCIdB5TwXA8hUGvG
         13JZC+a30t6dROq4vtvySvx3zbnehu8O7QsrNdJkKExSwJkcdnoXY1mJaGzAD2qVSR
         +LVDGMVsgSR/B5p2B6ELRw4pNuvxB21Ig0E1tRWvCAPzbTi/ey7NunxnDXFgJlUsmo
         tho5k3pr5dAJA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Kanna Scarlet <knscarlet@gnuweeb.org>
Subject: [PATCH 1/2] liburing: Change the type of `flags` in `io_uring_prep_renameat()` to `unsigned int`
Date:   Tue, 23 Aug 2022 18:52:43 +0700
Message-Id: <20220823114813.2865890-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220823114813.2865890-1-ammar.faizi@intel.com>
References: <20220823114813.2865890-1-ammar.faizi@intel.com>
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

Sync with the declaration of `renameat2()` from the man page.

Closes: https://github.com/axboe/liburing/pull/615
Link: https://man7.org/linux/man-pages/man2/rename.2.html
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 man/io_uring_prep_renameat.3 | 4 ++--
 src/include/liburing.h       | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/man/io_uring_prep_renameat.3 b/man/io_uring_prep_renameat.3
index 1fc9e01..08d4a46 100644
--- a/man/io_uring_prep_renameat.3
+++ b/man/io_uring_prep_renameat.3
@@ -16,12 +16,12 @@ io_uring_prep_renameat \- prepare a renameat request
 .BI "                            const char *" oldpath ","
 .BI "                            int " newdirfd ","
 .BI "                            const char *" newpath ","
-.BI "                            int " flags ");"
+.BI "                            unsigned int " flags ");"
 .PP
 .BI "void io_uring_prep_rename(struct io_uring_sqe *" sqe ","
 .BI "                          const char *" oldpath ","
 .BI "                          const char *" newpath ","
-.BI "                          int " flags ");"
+.BI "                          unsigned int " flags ");"
 .fi
 .SH DESCRIPTION
 .PP
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 06f4a50..df748aa 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -862,7 +862,7 @@ static inline void io_uring_prep_unlink(struct io_uring_sqe *sqe,
 
 static inline void io_uring_prep_renameat(struct io_uring_sqe *sqe, int olddfd,
 					  const char *oldpath, int newdfd,
-					  const char *newpath, int flags)
+					  const char *newpath, unsigned int flags)
 {
 	io_uring_prep_rw(IORING_OP_RENAMEAT, sqe, olddfd, oldpath,
 				(__u32) newdfd,
-- 
Ammar Faizi

