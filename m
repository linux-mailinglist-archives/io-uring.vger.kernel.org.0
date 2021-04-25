Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2DF36A9B2
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 00:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhDYWjC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 18:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbhDYWjB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 18:39:01 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18EFC061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 15:38:20 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 26-20020a05600c22dab029013efd7879b8so2247289wmg.0
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 15:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P0ALCMb9R+OZzJB5hf0XiXEcdUWnZeqOW3Vzb+v8dLM=;
        b=t/WcthEDdx9uu1+zynLKKC/Sd6cn4sG4bRT7BjDCap9lNqf5zZbhhzWg4aD4XFxShA
         PhuJ/6kLW4nV8+mIA3gWGUQ0Rp8Rq16iFTgCw+dacRrOcHBG1UbcE1wPYxHIYysteeRa
         +qM4IPZ+ev22xtf/jw6xtPydH/W8ae9Sfx2Rpxwrf90n5RbKkj0v/QTUqiQPClx5WWqE
         +cx3OfJ6jaAPLEMO5ARGANAkS+5w696WATI3iRy96VYPocEXcSjzMgHMp38KZp5U2aCy
         RyJwBAMNO+WFGj2PWvNohWl8oQuEvN5aLFpbvpdXl9ZaVIcek178eEg+OCkDbsUSQ5d2
         xlzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P0ALCMb9R+OZzJB5hf0XiXEcdUWnZeqOW3Vzb+v8dLM=;
        b=qGw4YoSIZ/TyiGIrQFsUdSKwhFs55GslArff2HGaDag4PwwUXsDAAnpd7s43bS218e
         IB9EJ8RzEwD3sWyhqUPy10i9rSchpYtsRCRoCCx35MGhgyVJoOJqGWIKIlGRbD+37pAx
         WrZYyJ5PRwOCyOpT4gXvbUaI9DFEV51g83In/KjACH/7XF7W3YVLU5OHiebk1OxKfRPB
         Xoe3HYg3rWVnM5SfyhaIrwfQMXIU5SJyfF7kbYN9amOE2xn8ogkrTh/+B8FFi+b+7DdV
         cpqXxQpFDeBOpPD1roqcZhjCynzSYDtjjuDWQLZWjUnztP5azNpw6xE53UZ89mkyDAC/
         /Lcw==
X-Gm-Message-State: AOAM53113BNFbMF+SzmXDP75mDON0ozf7kcYjHoUGIjT6O/ZLWsQ8OTq
        kNKJNVOY2B2p1G9LtOZoPOU=
X-Google-Smtp-Source: ABdhPJyHjQ1MhfxiVjqpAhMU01kZY2/unQZHapr/Tf34X31JhsZofgY6rnEUuQGifAG6zG1fsZocPQ==
X-Received: by 2002:a7b:c1cc:: with SMTP id a12mr16314018wmj.97.1619390299529;
        Sun, 25 Apr 2021 15:38:19 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id s6sm5832281wms.0.2021.04.25.15.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 15:38:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] test: test ring exit cancels SQPOLL's iowq
Date:   Sun, 25 Apr 2021 23:38:09 +0100
Message-Id: <5ff453f83e0202fcdb48c27b6597aa615cd17f01.1619390260.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Another SQPOLL cancellation test making sure that io_uring_queue_exit()
does cancel all requests and free the ring, in particular for SQPOLL
requests gone to iowq.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/io-cancel.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/test/io-cancel.c b/test/io-cancel.c
index c08b7e5..c2a39b5 100644
--- a/test/io-cancel.c
+++ b/test/io-cancel.c
@@ -438,6 +438,48 @@ static int test_cancel_inflight_exit(void)
 	return 0;
 }
 
+static int test_sqpoll_cancel_iowq_requests(void)
+{
+	struct io_uring ring;
+	struct io_uring_sqe *sqe;
+	int ret, fds[2];
+	char buffer[16];
+
+	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SQPOLL);
+	if (ret) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+	if (pipe(fds)) {
+		perror("pipe");
+		return 1;
+	}
+	/* pin both pipe ends via io-wq */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_read(sqe, fds[0], buffer, 10, 0);
+	sqe->flags |= IOSQE_ASYNC | IOSQE_IO_LINK;
+	sqe->user_data = 1;
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_write(sqe, fds[1], buffer, 10, 0);
+	sqe->flags |= IOSQE_ASYNC;
+	sqe->user_data = 2;
+	ret = io_uring_submit(&ring);
+	if (ret != 2) {
+		fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	/* wait for sqpoll to kick in and submit before exit */
+	sleep(1);
+	io_uring_queue_exit(&ring);
+
+	/* close the write end, so if ring is cancelled properly read() fails*/
+	close(fds[1]);
+	read(fds[0], buffer, 10);
+	close(fds[0]);
+	return 0;
+}
 
 int main(int argc, char *argv[])
 {
@@ -461,6 +503,11 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	if (test_sqpoll_cancel_iowq_requests()) {
+		fprintf(stderr, "test_sqpoll_cancel_iowq_requests() failed\n");
+		return 1;
+	}
+
 	t_create_file(".basic-rw", FILE_SIZE);
 
 	vecs = t_create_buffers(BUFFERS, BS);
-- 
2.31.1

