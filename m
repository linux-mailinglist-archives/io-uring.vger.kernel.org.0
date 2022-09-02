Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942D25AAD43
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 13:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiIBLOy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 07:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiIBLOx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 07:14:53 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C90E0A7
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 04:14:50 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id bp20so1385727wrb.9
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 04:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=+EzCvqhuPXn6pBcKGFX9KUSNBtR+7W5a37WMLSsZlzc=;
        b=IFbvuHZyvT0yMn1h03g4YrVXgIqudz11VLV4oenbmXAJDxtRAC6YpGAJzB29UOm8NK
         c41bWYTNwe7MxseU07D/Y7muGRb7KRiXWsM0t5XJA/LQvNpF4tnbUjiF9K/35NqES9PM
         CVbS1VeCr98so2B2jCXBnsOQ0oBlCzzTrviWW5fMmf+61U3A+HhoaBXnRo0ahV4vCnI0
         A8gqaeR08rP5kMSSUdQGbJlEoO17mO0LQx0jgWVjv8ONutyERYQuz9CgAP0dgti/etfQ
         SwdN80xoXwMAqmMIGM8kM+/I7REZKbXCC1TG8syIWh2a9gqf1C0pJKzMjcoT+X8M2Fni
         gxNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=+EzCvqhuPXn6pBcKGFX9KUSNBtR+7W5a37WMLSsZlzc=;
        b=MbiVfTaIxSWWkdsV+B/VJ2+jQp3tZGwr0kRTV39a49deM9eWFjmHbja+yZrpAe6IJB
         sMp6rFj9ACa2joWTr8rLfLtwa/MFIP1asPzp2t8gd0eb0dMCoqqAg28FjlNX0rrWvvEM
         ADfkj0dNi47VzPwkLF+GmM1SZr5H1tV84JfG9xTEnHNZm2WoYUT4aA8shvw6vBEq60i9
         dIHiUxq5PUzJlSvHia8PXi3IUfCxzKRkMZnyR4HZnFDfB5P6r7nLIisb4d8YC0DU0J4x
         /B01cB+xcZLDipGlc5gffY+Olyjg6H9oZrAJzJ9yt9nw5MCLl7M5dxyXpaIHYc8KikLA
         I7Yg==
X-Gm-Message-State: ACgBeo3EdcCNbU+42xLNKwXdxRl3qYa9SW9jAcrpzC1BLU/ym4vQenbd
        rIvtyBxR7dUMU1rgcZBPPDV/Rf/+AlI=
X-Google-Smtp-Source: AA6agR4+yDbt92zo3WTp4PKhcMIthZkM6U85BEkcplj9ENXcXdHHITdkyBJrEAVHR7PoEpO3QYStdg==
X-Received: by 2002:a05:6000:78d:b0:226:d5c1:5ebd with SMTP id bu13-20020a056000078d00b00226d5c15ebdmr14830862wrb.565.1662117288786;
        Fri, 02 Sep 2022 04:14:48 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-225.dab.02.net. [82.132.230.225])
        by smtp.gmail.com with ESMTPSA id bg32-20020a05600c3ca000b003a536d5aa2esm2087379wmb.11.2022.09.02.04.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 04:14:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/4] tests: verify that send addr is copied when async
Date:   Fri,  2 Sep 2022 12:12:36 +0100
Message-Id: <67fa1af95c4565ef0e9f43833b67d6c4d50d66f6.1662116617.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662116617.git.asml.silence@gmail.com>
References: <cover.1662116617.git.asml.silence@gmail.com>
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

The kernel should not be touching timespec after returning from submit
syscall, make sure it's not reloaded after a request goes async.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 69 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 307c114..97727e3 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -836,6 +836,69 @@ static int test_inet_send(struct io_uring *ring)
 	return 0;
 }
 
+static int test_async_addr(struct io_uring *ring)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct sockaddr_storage addr;
+	int sock_tx = -1, sock_rx = -1;
+	struct __kernel_timespec ts;
+	int ret;
+
+	ret = prepare_ip(&addr, &sock_tx, &sock_rx, true, false, false, false);
+	if (ret) {
+		fprintf(stderr, "sock prep failed %d\n", ret);
+		return 1;
+	}
+
+	sqe = io_uring_get_sqe(ring);
+	ts.tv_sec = 1;
+	ts.tv_nsec = 0;
+	io_uring_prep_timeout(sqe, &ts, 0, IORING_TIMEOUT_ETIME_SUCCESS);
+	sqe->user_data = 1;
+	sqe->flags |= IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_sendzc(sqe, sock_tx, tx_buffer, 1, 0, 0, 0);
+	sqe->user_data = 2;
+	io_uring_prep_sendzc_set_addr(sqe, (const struct sockaddr *)&addr,
+				      sizeof(struct sockaddr_in6));
+
+	ret = io_uring_submit(ring);
+	assert(ret == 2);
+	memset(&addr, 0, sizeof(addr));
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "io_uring_wait_cqe failed %i\n", ret);
+		return 1;
+	}
+	if (cqe->user_data != 1 || cqe->res != -ETIME) {
+		fprintf(stderr, "invalid timeout res %i %i\n",
+			(int)cqe->user_data, cqe->res);
+		return 1;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "io_uring_wait_cqe failed %i\n", ret);
+		return 1;
+	}
+	if (cqe->user_data != 2 || cqe->res != 1) {
+		fprintf(stderr, "invalid send %i %i\n",
+			(int)cqe->user_data, cqe->res);
+		return 1;
+	}
+	io_uring_cqe_seen(ring, cqe);
+	ret = recv(sock_rx, rx_buffer, 1, MSG_TRUNC);
+	assert(ret == 1);
+
+	close(sock_tx);
+	close(sock_rx);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring;
@@ -973,6 +1036,12 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "test_inet_send() failed\n");
 		return ret;
 	}
+
+	ret = test_async_addr(&ring);
+	if (ret) {
+		fprintf(stderr, "test_async_addr() failed\n");
+		return ret;
+	}
 out:
 	io_uring_queue_exit(&ring);
 	close(sp[0]);
-- 
2.37.2

