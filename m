Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3DF54F375
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 10:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381358AbiFQIpz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 04:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381355AbiFQIpi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 04:45:38 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E47B6A043
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:45:27 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id h23so7427002ejj.12
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZsHDX8iN8foHq5m87WYXjazf1UiVTKwybYm2YnxPwQY=;
        b=IjLRrokUYrQYnwO51g06YUbmjNe4gdHQE8wKWKTjlzD4JvsX/eU6o3JiTrcrXXs87H
         02atB8s5ePIr9Xj27moDg48jjPha/ByDI4g09luGD2aZn6JmbCUd7/QFW0u1hbdC7fhp
         g505WlQWhxv8cqrQyO0OHn/GN0LqnkEYKSKoVtM7ET1impTKMXSNSqEonVieSGYdpZOR
         +T4u+Ig6bde3dq8GF0vGh5TQZ6FNs+2PTa27MMCJVOoztRTs3RjAOWURssFl3xwcyeFo
         QArbwJvaxH/YbLXm7Lc6FCRvJRDpbagBL5LDNoM7PSWxJYJHWSF1KteNXQadmjV16WiK
         82/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZsHDX8iN8foHq5m87WYXjazf1UiVTKwybYm2YnxPwQY=;
        b=vwuN4/um8KamfDJ7AhcNMOnrHZN6p+huTeCwRJs9H918OMAeZo+RPSOLHUR4avsi9J
         OVx4wNndpDaU5tCIuJ11VX28uDVBR/48D11OHqVdn5rZh7XnaRy/PgjcpYi5hjW2lEju
         QIJHJErS3WgnlzlUg9WAYCiW3NwaV3l3dAaPrCT5oVin3qyRKr+sfXJyZhpbvcL1aDX8
         F+UqueZhNT/HiRnuXjQCq5V3mUTeRbKImIja5B7HW7Q6k+lM6B4eDGmzB36bkAW4a5FZ
         F+9rRq4H9DRHbiQ/d31eA5X+4P3HS//zzDljZcIUQvAeEEjHFFu5G7T3bsXDN92fnCij
         LwkA==
X-Gm-Message-State: AJIora94nkOOc92ezNmtVReWaUjosQH0jm0YYIYEWzByHmWltBEsexdS
        jcJGaUOYgHa9AnNxsKLHtftAz763+bXF7w==
X-Google-Smtp-Source: AGRyM1vs+IdiDjb5lE+gvFcnRC29OCeA1Hjpp7JHCcbIE1OBbJrTvXeUw5rsgvM37+HGc5WG4QCfUQ==
X-Received: by 2002:a17:907:c06:b0:701:eb60:ded with SMTP id ga6-20020a1709070c0600b00701eb600dedmr7628015ejc.178.1655455525675;
        Fri, 17 Jun 2022 01:45:25 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:b65a])
        by smtp.gmail.com with ESMTPSA id ot21-20020a170906ccd500b006f3ef214e0esm1844106ejb.116.2022.06.17.01.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 01:45:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/2] Revert "test/nop: kill cqe32 test code"
Date:   Fri, 17 Jun 2022 09:42:41 +0100
Message-Id: <a85bf82b68dca4f82fa8c275d5ed7e06cc065034.1655455225.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655455225.git.asml.silence@gmail.com>
References: <cover.1655455225.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit e5d017ab9cd9605248db68168ae5451f830e646c.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/nop.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/test/nop.c b/test/nop.c
index 01e41a6..ce223b3 100644
--- a/test/nop.c
+++ b/test/nop.c
@@ -20,6 +20,7 @@ static int test_single_nop(struct io_uring *ring)
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
 	int ret;
+	bool cqe32 = (ring->flags & IORING_SETUP_CQE32);
 
 	sqe = io_uring_get_sqe(ring);
 	if (!sqe) {
@@ -28,6 +29,10 @@ static int test_single_nop(struct io_uring *ring)
 	}
 
 	io_uring_prep_nop(sqe);
+	if (cqe32) {
+		sqe->addr = 1234;
+		sqe->addr2 = 5678;
+	}
 	sqe->user_data = ++seq;
 
 	ret = io_uring_submit(ring);
@@ -45,6 +50,17 @@ static int test_single_nop(struct io_uring *ring)
 		fprintf(stderr, "Unexpected 0 user_data\n");
 		goto err;
 	}
+	if (cqe32) {
+		if (cqe->big_cqe[0] != 1234) {
+			fprintf(stderr, "Unexpected extra1\n");
+			goto err;
+
+		}
+		if (cqe->big_cqe[1] != 5678) {
+			fprintf(stderr, "Unexpected extra2\n");
+			goto err;
+		}
+	}
 	io_uring_cqe_seen(ring, cqe);
 	return 0;
 err:
@@ -56,6 +72,7 @@ static int test_barrier_nop(struct io_uring *ring)
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
 	int ret, i;
+	bool cqe32 = (ring->flags & IORING_SETUP_CQE32);
 
 	for (i = 0; i < 8; i++) {
 		sqe = io_uring_get_sqe(ring);
@@ -67,6 +84,10 @@ static int test_barrier_nop(struct io_uring *ring)
 		io_uring_prep_nop(sqe);
 		if (i == 4)
 			sqe->flags = IOSQE_IO_DRAIN;
+		if (cqe32) {
+			sqe->addr = 1234;
+			sqe->addr2 = 5678;
+		}
 		sqe->user_data = ++seq;
 	}
 
@@ -89,6 +110,16 @@ static int test_barrier_nop(struct io_uring *ring)
 			fprintf(stderr, "Unexpected 0 user_data\n");
 			goto err;
 		}
+		if (cqe32) {
+			if (cqe->big_cqe[0] != 1234) {
+				fprintf(stderr, "Unexpected extra1\n");
+				goto err;
+			}
+			if (cqe->big_cqe[1] != 5678) {
+				fprintf(stderr, "Unexpected extra2\n");
+				goto err;
+			}
+		}
 		io_uring_cqe_seen(ring, cqe);
 	}
 
-- 
2.36.1

