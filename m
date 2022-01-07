Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A914877E4
	for <lists+io-uring@lfdr.de>; Fri,  7 Jan 2022 14:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiAGNC2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Jan 2022 08:02:28 -0500
Received: from ip59.38.31.103.in-addr.arpa.unknwn.cloudhost.asia ([103.31.38.59]:44684
        "EHLO gnuweeb.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230218AbiAGNC2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Jan 2022 08:02:28 -0500
Received: from integral2.. (unknown [36.68.70.227])
        by gnuweeb.org (Postfix) with ESMTPSA id 92778C17F2;
        Fri,  7 Jan 2022 13:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gnuweeb.org;
        s=default; t=1641560547;
        bh=+u4pKlYPYt1PipEjrDT7r8Ze8KmQqAXhDupoPACiK3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmPvt5TQOcW6rYp+Bk0Kmq7NLA94wPid8Y3COV7rUhCybGDkpA5k5lXprjPEZHqKz
         mM0dYSRHJKy+8I5hPbc0RN35t0dzVOPl94weNKak2Bc1lH3z8Wvx1JX/aFoTOHXzPI
         RnTwzgd1f83a7WplOu5ZIlEcLZ9S1aHvIK/9FLjVT1d+SQ5B6mo+TxNiP8akdP6n/1
         1jWa2lAmae2HbitST+pCQ+DeSGJUBoUr2yJh54LRRPpX4N7MD7jzJNw/DcnSePOhZn
         6kps8bAiJViSw8xdxBwx09SLx6z8NxtaBzYnvbBpb+juc5qPCHf5ZaFDfJZgW6phFh
         WpZUiw+BhgMzQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [PATCH liburing 1/3] test/socket-rw-eagain: Fix UB, accessing dead object
Date:   Fri,  7 Jan 2022 20:02:16 +0700
Message-Id: <20220107130218.1238910-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220107130218.1238910-1-ammarfaizi2@gnuweeb.org>
References: <20220107130218.1238910-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dereference to a local variable that has been out of its scope is
undefined behavior, it may contain garbage or the compiler may
reuse it for other local variables.

Fix this by moving the struct iov variable declarations so their
lifetime is extended.

Cc: Jens Axboe <axboe@kernel.dk>
Fixes: 76e3b7921fee98a5627cd270628b6a5160d3857d ("Add nonblock empty socket read test")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/socket-rw-eagain.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/test/socket-rw-eagain.c b/test/socket-rw-eagain.c
index 9854e00..2d6a817 100644
--- a/test/socket-rw-eagain.c
+++ b/test/socket-rw-eagain.c
@@ -25,6 +25,7 @@ int main(int argc, char *argv[])
 	int32_t recv_s0;
 	int32_t val = 1;
 	struct sockaddr_in addr;
+	struct iovec iov_r[1], iov_w[1];
 
 	if (argc > 1)
 		return 0;
@@ -105,28 +106,24 @@ int main(int argc, char *argv[])
 	char send_buff[128];
 
 	{
-		struct iovec iov[1];
-
-		iov[0].iov_base = recv_buff;
-		iov[0].iov_len = sizeof(recv_buff);
+		iov_r[0].iov_base = recv_buff;
+		iov_r[0].iov_len = sizeof(recv_buff);
 
 		struct io_uring_sqe* sqe = io_uring_get_sqe(&m_io_uring);
 		assert(sqe != NULL);
 
-		io_uring_prep_readv(sqe, p_fd[0], iov, 1, 0);
+		io_uring_prep_readv(sqe, p_fd[0], iov_r, 1, 0);
 		sqe->user_data = 1;
 	}
 
 	{
-		struct iovec iov[1];
-
-		iov[0].iov_base = send_buff;
-		iov[0].iov_len = sizeof(send_buff);
+		iov_w[0].iov_base = send_buff;
+		iov_w[0].iov_len = sizeof(send_buff);
 
 		struct io_uring_sqe* sqe = io_uring_get_sqe(&m_io_uring);
 		assert(sqe != NULL);
 
-		io_uring_prep_writev(sqe, p_fd[1], iov, 1, 0);
+		io_uring_prep_writev(sqe, p_fd[1], iov_w, 1, 0);
 		sqe->user_data = 2;
 	}
 
-- 
2.32.0

