Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F576619529
	for <lists+io-uring@lfdr.de>; Fri,  4 Nov 2022 12:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiKDLH6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Nov 2022 07:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbiKDLHq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Nov 2022 07:07:46 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AABC1A20F
        for <io-uring@vger.kernel.org>; Fri,  4 Nov 2022 04:07:45 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id d26so12292057eje.10
        for <io-uring@vger.kernel.org>; Fri, 04 Nov 2022 04:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HgAMscCPPAhCavrOsCy3bwUWODYv1hI3zI94H1LqKf8=;
        b=Qhtp+tWubT9eaWJUT044z9P+v92gcOi0LMg3PkYdeWJZWTDV/g32FN7Xu3+wX9y15J
         Vl5pCyrkxsHLEorpyhAPiNZrMnEPVBN3iqqbA323IoCNUZ9C2S5wYD9ZwOONw5RKGhSB
         EGvsGp/tIizfaklB2kmTK1ClwLVuWMS4gGir9Bd/Jx3GacGqnmFUxvdXtPNKu6ilL+91
         KD8q181rBMPjVJHXFKuZIkn+v00/R5emWh/mDTZfMRAaKXPHifGy9c3nxjULisJ6GXXc
         yIFcS7SLyCWzn4XKNDK0+AF/e8gt7SZNCdgUiTCQw/eEqgApnRB0w85R8wLJoPHAcfc2
         gJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HgAMscCPPAhCavrOsCy3bwUWODYv1hI3zI94H1LqKf8=;
        b=P+NoJ+Mq2tbVvEWKYvpddHEh4lIoq3W2MJIwADvgXlQJWzHzEe/NhTVbeZzoaBa/rA
         JvjqYmforzAqy2rLN/cQlb42VGV6NxVJbUI9lknPh/UwghKFt5IxdA44n7zd9UvEhH5b
         J8Dr7pFe/VYnwQLm0taJPci7m3VRvzZSlQ5LkEBbr1fn0qaWTKXigrwsLqGxgvDk/YxD
         //jjcSD2Fhz9rgRsoBv/QI09gEk5N9u2juMcVX8MJJGxopWR6Rw4Up8ndiTLsISGCXzZ
         eJg7JSXWeGnVWedZvetj1LOpkB6iiOq52R4GZ1jD+2P/QSpBICpLeE2W04AIhwuyZ78K
         K4dQ==
X-Gm-Message-State: ACrzQf2A2IchQYFy8AON4SH/VwZAjUb1cSKlwIn9wBFQjVTgwjrOZ1Od
        eDn6XtcptY1NkMPLgizF0Pu4gFRPkzY=
X-Google-Smtp-Source: AMsMyM6aYwpbNZ1Ssq5sgO87AdupqtHjK273uU3K8SGYrL1Q/q6mmCZ+P7o7z4vilBzctiUApaIsdw==
X-Received: by 2002:a17:907:6d1b:b0:7a1:11a9:1334 with SMTP id sa27-20020a1709076d1b00b007a111a91334mr5412423ejc.131.1667560063696;
        Fri, 04 Nov 2022 04:07:43 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:4173])
        by smtp.gmail.com with ESMTPSA id bg19-20020a170906a05300b0078df26efb7dsm1665491ejb.107.2022.11.04.04.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 04:07:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/3] tests/zc: create a new ring for test_send_faults()
Date:   Fri,  4 Nov 2022 11:05:51 +0000
Message-Id: <2c2adfcd0d89d1961dab3c3a1265f0d26c73e03e.1667559818.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1667559818.git.asml.silence@gmail.com>
References: <cover.1667559818.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We need IORING_SETUP_SUBMIT_ALL for test_send_faults() to be sure
io_uring doesn't stop submission on first failure.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index a50b5b1..30b50e1 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -116,7 +116,7 @@ static int test_basic_send(struct io_uring *ring, int sock_tx, int sock_rx)
 	return T_EXIT_PASS;
 }
 
-static int test_send_faults(struct io_uring *ring, int sock_tx, int sock_rx)
+static int test_send_faults(int sock_tx, int sock_rx)
 {
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
@@ -124,24 +124,31 @@ static int test_send_faults(struct io_uring *ring, int sock_tx, int sock_rx)
 	unsigned zc_flags = 0;
 	int payload_size = 100;
 	int ret, i, nr_cqes = 2;
+	struct io_uring ring;
 
-	sqe = io_uring_get_sqe(ring);
+	ret = io_uring_queue_init(32, &ring, IORING_SETUP_SUBMIT_ALL);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		return -1;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
 	io_uring_prep_send_zc(sqe, sock_tx, (void *)1UL, payload_size,
 			      msg_flags, zc_flags);
 	sqe->user_data = 1;
 
-	sqe = io_uring_get_sqe(ring);
+	sqe = io_uring_get_sqe(&ring);
 	io_uring_prep_send_zc(sqe, sock_tx, tx_buffer, payload_size,
 			      msg_flags, zc_flags);
 	sqe->user_data = 2;
 	io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)1UL,
 				    sizeof(struct sockaddr_in6));
 
-	ret = io_uring_submit(ring);
+	ret = io_uring_submit(&ring);
 	assert(ret == 2);
 
 	for (i = 0; i < nr_cqes; i++) {
-		ret = io_uring_wait_cqe(ring, &cqe);
+		ret = io_uring_wait_cqe(&ring, &cqe);
 		assert(!ret);
 		assert(cqe->user_data <= 2);
 
@@ -150,9 +157,9 @@ static int test_send_faults(struct io_uring *ring, int sock_tx, int sock_rx)
 			if (cqe->flags & IORING_CQE_F_MORE)
 				nr_cqes++;
 		}
-		io_uring_cqe_seen(ring, cqe);
+		io_uring_cqe_seen(&ring, cqe);
 	}
-	assert(check_cq_empty(ring));
+	assert(check_cq_empty(&ring));
 	return T_EXIT_PASS;
 }
 
@@ -728,7 +735,7 @@ int main(int argc, char *argv[])
 
 	has_sendmsg = io_check_zc_sendmsg(&ring);
 
-	ret = test_send_faults(&ring, sp[0], sp[1]);
+	ret = test_send_faults(sp[0], sp[1]);
 	if (ret) {
 		fprintf(stderr, "test_send_faults() failed\n");
 		return T_EXIT_FAIL;
-- 
2.38.0

