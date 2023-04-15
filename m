Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2AFE6E32A1
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 18:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjDOQ6m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 12:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjDOQ6l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 12:58:41 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A9849C8;
        Sat, 15 Apr 2023 09:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1681577919;
        bh=v6rcx08r6yOYiVA0eKkrbzv0NZtEnrMCKsIIQqjqoKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=RJivG/DE2q7ND227w68cEUYjNe5ATJjNvqjRQEPzoHUPk2izwbP+gY2sQSSn4w5gT
         Ac4rdogWKvONb+N5K6y/GyIwSZjPjG93nEOXurQVC6hvKw4rmpIa1GyURP6JB+cIIR
         S0Kp2I++YCCQdX5EVb1dEDeHo/gubQmf5JAa9hiurZHZnkD75HImuXKtlU7+So8bIX
         j3CQxj3iJ8/YW7BGChj+XyAZzwXhXhktZDS7RS4HOxI20UJQaKHO7VTg5QFZmMIpVf
         zhyZDlfdNVta2L/uCHyGn7CYMejOFhBY3UyVo9r3BTIL9kUaeFcMb3/XTBhnfiBeq9
         4w1N/P/S5RUcw==
Received: from localhost.localdomain (unknown [182.253.88.211])
        by gnuweeb.org (Postfix) with ESMTPSA id 283EB2450ED;
        Sat, 15 Apr 2023 23:58:36 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v1 2/2] man: Add `io_uring_prep_sendto()`
Date:   Sat, 15 Apr 2023 23:58:21 +0700
Message-Id: <20230415165821.791763-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230415165821.791763-1-ammarfaizi2@gnuweeb.org>
References: <20230415165821.791763-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 CHANGELOG                  |  1 +
 man/io_uring_prep_send.3   | 31 +++++++++++++++++++++++++++++++
 man/io_uring_prep_sendto.3 |  1 +
 3 files changed, 33 insertions(+)
 create mode 120000 man/io_uring_prep_sendto.3

diff --git a/CHANGELOG b/CHANGELOG
index 85e02a280d4a7c45..71ca3919e114d858 100644
--- a/CHANGELOG
+++ b/CHANGELOG
@@ -14,6 +14,7 @@ liburing-2.4 release
   io_uring_prep_openat2_direct(), io_uring_prep_msg_ring_fd(), and
   io_uring_prep_socket_direct() factor in being called with
   IORING_FILE_INDEX_ALLOC for allocating a direct descriptor.
+- Add io_uring_prep_sendto() function.
 
 liburing-2.3 release
 
diff --git a/man/io_uring_prep_send.3 b/man/io_uring_prep_send.3
index 3bdc96751ebfb230..b555ec3a8548c449 100644
--- a/man/io_uring_prep_send.3
+++ b/man/io_uring_prep_send.3
@@ -14,6 +14,14 @@ io_uring_prep_send \- prepare a send request
 .BI "                        const void *" buf ","
 .BI "                        size_t " len ","
 .BI "                        int " flags ");"
+.PP
+.BI "void io_uring_prep_sendto(struct io_uring_sqe *" sqe ","
+.BI "                          int " sockfd ","
+.BI "                          const void *" buf ","
+.BI "                          size_t " len ","
+.BI "                          int " flags ","
+.BI "                          const struct sockaddr *" addr ","
+.BI "                          socklen_t " addrlen ");"
 .fi
 .SH DESCRIPTION
 .PP
@@ -43,6 +51,28 @@ This function prepares an async
 .BR send (2)
 request. See that man page for details.
 
+The
+.BR io_uring_prep_sendto (3)
+function prepares a sendto request. The submission queue entry
+.I sqe
+is setup to use the file descriptor
+.I sockfd
+to start sending the data from
+.I buf
+of size
+.I len
+bytes and with modifier flags
+.IR flags .
+The destination address is specified by
+.I addr
+and
+.I addrlen
+and must be a valid address for the socket type.
+
+This function prepares an async
+.BR sendto (2)
+request. See that man page for details.
+
 .SH RETURN VALUE
 None
 .SH ERRORS
@@ -64,3 +94,4 @@ field.
 .BR io_uring_get_sqe (3),
 .BR io_uring_submit (3),
 .BR send (2)
+.BR sendto (2)
diff --git a/man/io_uring_prep_sendto.3 b/man/io_uring_prep_sendto.3
new file mode 120000
index 0000000000000000..ba85e68453fe6dcb
--- /dev/null
+++ b/man/io_uring_prep_sendto.3
@@ -0,0 +1 @@
+io_uring_prep_send.3
\ No newline at end of file
-- 
Ammar Faizi

