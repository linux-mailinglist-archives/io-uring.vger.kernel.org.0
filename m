Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D02E5A58A7
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 02:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiH3A5K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Aug 2022 20:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiH3A5H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Aug 2022 20:57:07 -0400
Received: from linux.gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1AB8D3E3;
        Mon, 29 Aug 2022 17:57:04 -0700 (PDT)
Received: from localhost.localdomain (unknown [68.183.184.174])
        by linux.gnuweeb.org (Postfix) with ESMTPSA id 4BB68374EF2;
        Tue, 30 Aug 2022 00:57:01 +0000 (UTC)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Caleb Sander <csander@purestorage.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 4/7] man: Add `io_uring_enter2()` function signature
Date:   Tue, 30 Aug 2022 07:56:40 +0700
Message-Id: <20220830005122.885209-5-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830005122.885209-1-ammar.faizi@intel.com>
References: <20220830005122.885209-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Since kernel 5.11, liburing has io_uring_enter2() wrapper which behaves
just like the io_uring_enter(), but with an extra argument for
`IORING_ENTER_EXT_ARG` case. Add this function signature to the
synopsis part. Also, change the function name in "kernel 5.11" part to
io_uring_enter2().

Suggested-by: Caleb Sander <csander@purestorage.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 man/io_uring_enter.2 | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 05f9f72..85e582c 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -13,6 +13,10 @@ io_uring_enter \- initiate and/or complete asynchronous I/O
 .BI "int io_uring_enter(unsigned int " fd ", unsigned int " to_submit ,
 .BI "                   unsigned int " min_complete ", unsigned int " flags ,
 .BI "                   sigset_t *" sig );
+.PP
+.BI "int io_uring_enter2(unsigned int " fd ", unsigned int " to_submit ,
+.BI "                    unsigned int " min_complete ", unsigned int " flags ,
+.BI "                    sigset_t *" sig ", size_t " sz );
 .fi
 .PP
 .SH DESCRIPTION
@@ -61,9 +65,9 @@ Since kernel 5.11, the system calls arguments have been modified to look like
 the following:
 
 .nf
-.BI "int io_uring_enter(unsigned int " fd ", unsigned int " to_submit ,
-.BI "                   unsigned int " min_complete ", unsigned int " flags ,
-.BI "                   const void *" arg ", size_t " argsz );
+.BI "int io_uring_enter2(unsigned int " fd ", unsigned int " to_submit ,
+.BI "                    unsigned int " min_complete ", unsigned int " flags ,
+.BI "                    const void *" arg ", size_t " argsz );
 .fi
 
 which is behaves just like the original definition by default. However, if
-- 
Ammar Faizi

