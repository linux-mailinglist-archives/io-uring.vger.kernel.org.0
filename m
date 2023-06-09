Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC62728D58
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 03:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbjFIBy3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jun 2023 21:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238035AbjFIBy2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jun 2023 21:54:28 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D284D1BF0;
        Thu,  8 Jun 2023 18:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1686275667;
        bh=sksGjcHbUtVAbJQuVuREhJLXzDbRGZ5kK9wdFhq2cJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=iwFZhFuSsy2B9leLI/NctNdQevFkEYFmAW2l53XOOaicXcMFQdoAdyKGg1BRoxHa1
         4CXfdKc27ZObc+pBtWdLwvMLIVCtvjL+5wONo6MreUHKL7KvDvVNDLHn7EmHw4lPpC
         yUJUHYQFaQdGcDuozB5VjCK0h7ctXUBv+Iq6YqLdk+y0euk82eo3orf5aPamgDIHGG
         besDLKYS9PKlV2BZ/BDIUEdpqN6NsXD14c6D6FbDOKOjvdy7uk2Wj7HSwSvPn2iZK4
         OJSjq4Uw/XTk241wbq2nZoKT8jFLRESankiwnaAm4CLMwWYC8e6B4Ho36vB8joDpFc
         AwsZhjKMNcxHA==
Received: from integral2.. (unknown [103.74.5.63])
        by gnuweeb.org (Postfix) with ESMTPSA id 507ED23EC0F;
        Fri,  9 Jun 2023 08:54:25 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing v1 1/2] man/io_uring_for_each_cqe: Fix return value, title, and typo
Date:   Fri,  9 Jun 2023 08:54:02 +0700
Message-Id: <20230609015403.3523811-2-ammarfaizi2@gnuweeb.org>
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

1) Fix the return value. io_uring_for_each_cqe() doesn't return an int.

2) Fix the title, it was io_uring_wait_cqes(), it should be
   io_uring_for_each_cqe().

3) Fix typo: s/io_uring_for_each_cqes/io_uring_for_each_cqe/

Fixes: 16d74b1c76043e6 ("man: add man page for io_uring_for_each_cqe()")
Reported-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 man/io_uring_for_each_cqe.3 | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/man/io_uring_for_each_cqe.3 b/man/io_uring_for_each_cqe.3
index 9230d147515c78fb..8445fd605d0b02a6 100644
--- a/man/io_uring_for_each_cqe.3
+++ b/man/io_uring_for_each_cqe.3
@@ -2,16 +2,16 @@
 .\"
 .\" SPDX-License-Identifier: LGPL-2.0-or-later
 .\"
-.TH io_uring_wait_cqes 3 "June 04, 2023" "liburing-2.4" "liburing Manual"
+.TH io_uring_for_each_cqe 3 "June 04, 2023" "liburing-2.4" "liburing Manual"
 .SH NAME
 io_uring_for_each_cqe \- iterate pending completion events
 .SH SYNOPSIS
 .nf
 .B #include <liburing.h>
 .PP
-.BI "int io_uring_for_each_cqes(struct io_uring *" ring ","
-.BI "                           unsigned " head ","
-.BI "                           struct io_uring_cqe *" cqe ");
+.BI "io_uring_for_each_cqe(struct io_uring *" ring ","
+.BI "                      unsigned " head ","
+.BI "                      struct io_uring_cqe *" cqe ") { }
 .fi
 .SH DESCRIPTION
 .PP
-- 
Ammar Faizi

