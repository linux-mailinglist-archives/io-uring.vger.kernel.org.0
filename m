Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0496E329E
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 18:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjDOQ6j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 12:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjDOQ6i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 12:58:38 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48F51BD6;
        Sat, 15 Apr 2023 09:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1681577916;
        bh=1qz+Hegrb9MywEJ4mTJx0QzksRUEqf3LwLZEKdEAcHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ITJKRx/cG9a3Sim+7xXpwfmBMIwU6rspcqZg4xBPqEQKcEksfdNdyII4WA571Pv1S
         vK1N0h4PvU74ryTnTpEhcm/DuDxJDr0DkDpwYBzZz16pHQqcDpTByYW43nkT0WdMAq
         F98GOn1XFwvbn2Oaz0qhkz3v2OIrYU1ZqxgqWUlesLitEVMA0s1NCBw9bovxgYI1w4
         hHYt9RZuX+MtWIFJ69xy4mqWBdhKMSxGuIOzIkxs1rYN5f9yBFE2x4/VoNK3n6IjjT
         4Vn/XOvte3tt3k1QKyajkD6xPVOYGJTspTxXspNMtuGBYkaiRmhjGHceOYMLVyU5HN
         ZXBBIgZEJhBUg==
Received: from localhost.localdomain (unknown [182.253.88.211])
        by gnuweeb.org (Postfix) with ESMTPSA id B22F1245521;
        Sat, 15 Apr 2023 23:58:33 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v1 1/2] liburing: Add `io_uring_prep_sendto()`
Date:   Sat, 15 Apr 2023 23:58:20 +0700
Message-Id: <20230415165821.791763-2-ammarfaizi2@gnuweeb.org>
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

A sendto(2) request can be done using:

   io_uring_prep_send() + io_uring_prep_send_set_addr()

Create a wrapper function, io_uring_prep_sendto().

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/include/liburing.h | 25 +++++++++++++++++--------
 src/liburing-ffi.map   |  1 +
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index fbc65b60788a4d44..70c177431faf9f75 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -758,6 +758,23 @@ IOURINGINLINE void io_uring_prep_send(struct io_uring_sqe *sqe, int sockfd,
 	sqe->msg_flags = (__u32) flags;
 }
 
+IOURINGINLINE void io_uring_prep_send_set_addr(struct io_uring_sqe *sqe,
+						const struct sockaddr *dest_addr,
+						__u16 addr_len)
+{
+	sqe->addr2 = (unsigned long)(const void *)dest_addr;
+	sqe->addr_len = addr_len;
+}
+
+IOURINGINLINE void io_uring_prep_sendto(struct io_uring_sqe *sqe, int sockfd,
+					const void *buf, size_t len, int flags,
+					const struct sockaddr *addr,
+					socklen_t addrlen)
+{
+	io_uring_prep_send(sqe, sockfd, buf, len, flags);
+	io_uring_prep_send_set_addr(sqe, addr, addrlen);
+}
+
 IOURINGINLINE void io_uring_prep_send_zc(struct io_uring_sqe *sqe, int sockfd,
 					 const void *buf, size_t len, int flags,
 					 unsigned zc_flags)
@@ -786,14 +803,6 @@ IOURINGINLINE void io_uring_prep_sendmsg_zc(struct io_uring_sqe *sqe, int fd,
 	sqe->opcode = IORING_OP_SENDMSG_ZC;
 }
 
-IOURINGINLINE void io_uring_prep_send_set_addr(struct io_uring_sqe *sqe,
-						const struct sockaddr *dest_addr,
-						__u16 addr_len)
-{
-	sqe->addr2 = (unsigned long)(const void *)dest_addr;
-	sqe->addr_len = addr_len;
-}
-
 IOURINGINLINE void io_uring_prep_recv(struct io_uring_sqe *sqe, int sockfd,
 				      void *buf, size_t len, int flags)
 {
diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index c971bf8c858f3005..0a5e12ca764a2a1e 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -170,6 +170,7 @@ LIBURING_2.4 {
 		io_uring_prep_msg_ring_cqe_flags;
 		io_uring_prep_msg_ring_fd;
 		io_uring_prep_msg_ring_fd_alloc;
+		io_uring_prep_sendto;
 	local:
 		*;
 };
-- 
Ammar Faizi

