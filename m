Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169D7678D5F
	for <lists+io-uring@lfdr.de>; Tue, 24 Jan 2023 02:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbjAXBYW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 20:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbjAXBYS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 20:24:18 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A98303C9
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 17:23:51 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id r9so12459756wrw.4
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 17:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0CyeNHO+wApPujQwvE0G8Yf0/otNiaiqcYQlH4gdJd8=;
        b=Mb0nryN79iteZrLNPnmJi5cbW21RoIg3tQNrRpR6O7MSQWtKJRQdYxDU0bQtEUfCv+
         0X2cmiDHUkmejngf2r2TQZT0IYBeYD6LpyPB5BdrC/CpVF/9YxK5NUMiUFjeziExo/kp
         Q1iJJeBsl8jJBS/oPSCsVKXtTjqi+3NrKlATy56JD3BnJxjl3sVY/A4In40JvGkbxWYM
         hx7G8ocscu/6TPtozBYAnbKehyWb7rPyK9eOc9ZXs54v77kIZsP4toT0CpWOSwp+kTD8
         wuIcB2r8sY8TRwelKJYZraXOzHMzxCUw3UddjXG6Rr+0GVIJUSezq3gM4wsfQBLes8rU
         3jFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0CyeNHO+wApPujQwvE0G8Yf0/otNiaiqcYQlH4gdJd8=;
        b=Qqp/s5DL4Anqahq+HMgiGaN/FDhDnOsor+LXPZollL56qDWshCngKAEKc9ez6LYVZm
         iQUKG0jmOmeh3rrEeq/vaS/DMcdEcBhlO4o1pSkWwc8JTk3QvnP6OWxuhpwd0ZVF0m4v
         BlHr/+IDFlcxr+MR2TtoSoZlKmoVBL/zavvqd7p9mrP2Pna9uP/F89L+rsXxgovrk+w0
         6gEgXHVESN9xJ7MBnfznOspRb455IIFn49UlL2Bj8XmTWByYtzF6VfFGjRdGsWQd7b30
         3WPVFHBrrJmfXkuegqHm0jSUSmilBGRlBAF+5Og27SRYembHP9pDteBb7kSD3zoQdSdR
         P/bw==
X-Gm-Message-State: AFqh2kr3jsn6htMruLpFLiNB4m88FOQfVbj0tXUkzIT1HvultYEIzp8a
        yJ7GYpc9n98XHXbrywadwbJHFW3296A=
X-Google-Smtp-Source: AMrXdXtb4XTi0LHBJDZx8HNDC/uH48kAQDnPa3Y+GMOTADVZeQUbPutrCO0FyUG6oUvFJCBkZqs5pw==
X-Received: by 2002:adf:cd8f:0:b0:2bd:d4bd:5829 with SMTP id q15-20020adfcd8f000000b002bdd4bd5829mr24533890wrj.19.1674523428619;
        Mon, 23 Jan 2023 17:23:48 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.37.76.threembb.co.uk. [92.41.37.76])
        by smtp.gmail.com with ESMTPSA id t20-20020adfa2d4000000b002bdcce37d31sm712912wra.99.2023.01.23.17.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 17:23:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 4/5] tests/msg_ring: refactor test_remote
Date:   Tue, 24 Jan 2023 01:21:48 +0000
Message-Id: <1c0e97492c0010a65c5c5f42450350b37c1a3809.1674523156.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1674523156.git.asml.silence@gmail.com>
References: <cover.1674523156.git.asml.silence@gmail.com>
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

Refactor test_remote() by folding all pthread accounting inside of it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/msg-ring.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/test/msg-ring.c b/test/msg-ring.c
index 66c60b3..495c127 100644
--- a/test/msg-ring.c
+++ b/test/msg-ring.c
@@ -93,17 +93,23 @@ static void *wait_cqe_fn(void *data)
 		goto err;
 	}
 
+	io_uring_cqe_seen(ring, cqe);
 	return NULL;
 err:
+	io_uring_cqe_seen(ring, cqe);
 	return (void *) (unsigned long) 1;
 }
 
 static int test_remote(struct io_uring *ring, struct io_uring *target)
 {
+	pthread_t thread;
+	void *tret;
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
 	int ret;
 
+	pthread_create(&thread, NULL, wait_cqe_fn, target);
+
 	sqe = io_uring_get_sqe(ring);
 	if (!sqe) {
 		fprintf(stderr, "get sqe failed\n");
@@ -134,6 +140,7 @@ static int test_remote(struct io_uring *ring, struct io_uring *target)
 	}
 
 	io_uring_cqe_seen(ring, cqe);
+	pthread_join(thread, &tret);
 	return 0;
 err:
 	return 1;
@@ -237,8 +244,6 @@ static int test_disabled_ring(struct io_uring *ring, int flags)
 int main(int argc, char *argv[])
 {
 	struct io_uring ring, ring2, pring;
-	pthread_t thread;
-	void *tret;
 	int ret, i;
 
 	if (argc > 1)
@@ -287,18 +292,13 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	pthread_create(&thread, NULL, wait_cqe_fn, &ring2);
-
 	ret = test_remote(&ring, &ring2);
 	if (ret) {
 		fprintf(stderr, "test_remote failed\n");
 		return T_EXIT_FAIL;
 	}
 
-	pthread_join(thread, &tret);
-
 	io_uring_queue_exit(&ring);
-	io_uring_queue_exit(&ring2);
 	io_uring_queue_exit(&pring);
 
 	if (t_probe_defer_taskrun()) {
@@ -337,5 +337,6 @@ int main(int argc, char *argv[])
 
 	}
 
+	io_uring_queue_exit(&ring2);
 	return T_EXIT_PASS;
 }
-- 
2.38.1

