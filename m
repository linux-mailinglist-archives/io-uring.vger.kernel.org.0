Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AACD5AA89D
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 09:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbiIBHQP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 03:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235295AbiIBHQM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 03:16:12 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACF7550BB
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 00:16:10 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.70.226])
        by gnuweeb.org (Postfix) with ESMTPSA id 585AB80C38;
        Fri,  2 Sep 2022 07:16:06 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662102970;
        bh=2p9uHfWtW3AKFDRIFltihLhNPVLqKFuiwaVh2DT6Y5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrIeiej1KF92eSZmADJXkEKGyDRjyW8ytRoMswcTlcucwZqHuG4atHc1JNiksrN9r
         ujifqSb3OrbnukXsn+DHgECASUaHq7/t3CduP3+bAahnPymu/iCgdBjenjhgodpeJI
         HiBw/8mcrY0JcDdFaKqRee37uWqembyerVe3VfnJssSHJvV5furSxkBE5rTWhcXaaa
         mu0ieKCTf72HFliiiTiLZXtApNJiTOAYB71fNWkfOTVmciMA4X9iGp+jocoit1xEnv
         7Ds+sC8jP+v9+r0R1G+88FH0XdYALnHrAkIpsf/1o+VSLDOxtlsvGe5abhocEMx+rq
         wmFwO1h+jN5/g==
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
Subject: [PATCH liburing v2 10/12] t/recv-msgall: Don't use a static port number
Date:   Fri,  2 Sep 2022 14:15:03 +0700
Message-Id: <20220902071153.3168814-11-ammar.faizi@intel.com>
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

Don't use a static port number. It might already be in use, resulting
in a test failure. Use an ephemeral port to make this test reliable.

Cc: Dylan Yudaken <dylany@fb.com>
Cc: Facebook Kernel Team <kernel-team@fb.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Tested-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/recv-msgall.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/test/recv-msgall.c b/test/recv-msgall.c
index a6f7cfc..ae123e4 100644
--- a/test/recv-msgall.c
+++ b/test/recv-msgall.c
@@ -12,45 +12,43 @@
 #include <sys/socket.h>
 #include <pthread.h>
 
 #include "liburing.h"
 #include "helpers.h"
 
 #define MAX_MSG	128
-
-#define PORT	10201
 #define HOST	"127.0.0.1"
+static __be16 bind_port;
 
 static int recv_prep(struct io_uring *ring, struct iovec *iov, int *sock,
 		     int use_recvmsg)
 {
 	struct sockaddr_in saddr;
 	struct io_uring_sqe *sqe;
 	int sockfd, ret, val;
 	struct msghdr msg = { };
 
 	memset(&saddr, 0, sizeof(saddr));
 	saddr.sin_family = AF_INET;
 	saddr.sin_addr.s_addr = htonl(INADDR_ANY);
-	saddr.sin_port = htons(PORT);
 
 	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
 	if (sockfd < 0) {
 		perror("socket");
 		return 1;
 	}
 
 	val = 1;
 	setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
 
-	ret = bind(sockfd, (struct sockaddr *)&saddr, sizeof(saddr));
-	if (ret < 0) {
+	if (t_bind_ephemeral_port(sockfd, &saddr)) {
 		perror("bind");
 		goto err;
 	}
+	bind_port = saddr.sin_port;
 
 	sqe = io_uring_get_sqe(ring);
 	if (!use_recvmsg) {
 		io_uring_prep_recv(sqe, sockfd, iov->iov_base, iov->iov_len,
 					MSG_WAITALL);
 	} else {
 		msg.msg_namelen = sizeof(struct sockaddr_in);
@@ -161,15 +159,15 @@ static int do_send(void)
 
 	buf = malloc(MAX_MSG * sizeof(int));
 	for (i = 0; i < MAX_MSG; i++)
 		buf[i] = i;
 
 	memset(&saddr, 0, sizeof(saddr));
 	saddr.sin_family = AF_INET;
-	saddr.sin_port = htons(PORT);
+	saddr.sin_port = bind_port;
 	inet_pton(AF_INET, HOST, &saddr.sin_addr);
 
 	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
 	if (sockfd < 0) {
 		perror("socket");
 		return 1;
 	}
-- 
Ammar Faizi

