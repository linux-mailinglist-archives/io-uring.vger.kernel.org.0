Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1A166CAB9
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 18:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbjAPRGT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 12:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbjAPRFu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 12:05:50 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5744142BDB
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:47:17 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id o17-20020a05600c511100b003db021ef437so1232295wms.4
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lX8aU+It/RddJirXAjTzMk8oomykuceGP53WmVeJLB4=;
        b=iJMzeWKhpeQZMlkaCE6FtGlPWi2/O5NTxYtmLmVaac4AsNlT+JvlAhQObLc1INGphy
         DeNsoSn+pSyg+rkHHqA3qYICmV6Z/1NhdD1U7TBtCBZjgiTESk/Wy/FXIR9JkJllFebb
         OISqG+EL1wWKd35cq9MT9IO8frEgd08nffDvmTK9+q2fob7Yb8oVHokLb7NGjnECaaN/
         HwB4vTTAJ5AibdoTvmcMWTy56yozuKqyOzv7Rx6KYBtdbg/7vvBMh92uFm3CzR7lqAS2
         lw7gSocdfpePiERGDupo9LypNVJxe+oSWRY9qFjH9LZEZKPVvqbEVlvk76z+Zj8geCRy
         yeOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lX8aU+It/RddJirXAjTzMk8oomykuceGP53WmVeJLB4=;
        b=sO34xYsDNEzc1WLpPEGrPJ9ox3IlRbdT7UEMbfxFG6gxMydTo7gwiwlxKe8Z6Mw3A6
         SgkxsmmkHm1rViJnYXiPwrW02TkFpyHAITnHf8YiUNX7bVPHOkLsVKDYOaI11aXuWNK8
         rVHBgDTG7teSqPXEYouIpxy8Pexgx9YyNTpBzAJVrZNwGKXhX55s6SaBLqgkAE+3hmpF
         BlzVW0LV6IvgfkzuB+XEZBwvrsPbVjWVxPqpvFcACEwr9gYZ41gm8YLUNHDf8UUYQ2Nu
         3vOHzWtjugMj+t8C5bATXeoyhDdC8oTPT9oQtugp3pu+R758ScDgQLzc7nIiyOKj1kns
         c7qQ==
X-Gm-Message-State: AFqh2krp3oqPZBCKeV/4ET3HztN9ksGPxRfD0/zIhOYYkbnXfhiZFYuc
        bfV+zT1KcRgzZM9HsQmZ0KZVuk3J9vE=
X-Google-Smtp-Source: AMrXdXvSjgoTaLXll3wLQ107QxYmR3a15Xl3JU71KD2Qss22BJeOoRegEaL+enlp0btg/S0xb5IUoA==
X-Received: by 2002:a05:600c:24ce:b0:3da:18c5:e48b with SMTP id 14-20020a05600c24ce00b003da18c5e48bmr8840714wmu.18.1673887635629;
        Mon, 16 Jan 2023 08:47:15 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.33.8.threembb.co.uk. [92.41.33.8])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c444a00b003d998412db6sm42012397wmn.28.2023.01.16.08.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 08:47:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/3] tests: lazy pollwq activation for disabled rings
Date:   Mon, 16 Jan 2023 16:46:09 +0000
Message-Id: <befc85abe49e87880de9575327a73ff634362bcc.1673886955.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673886955.git.asml.silence@gmail.com>
References: <cover.1673886955.git.asml.silence@gmail.com>
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

We have some internal changes in how ring polling is done, i.e. lazy
pollwq activation, test it when we start polling a disabled ring and
so before the task has been assigned.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/poll.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 89 insertions(+), 7 deletions(-)

diff --git a/test/poll.c b/test/poll.c
index a7db7dc..7b90f3d 100644
--- a/test/poll.c
+++ b/test/poll.c
@@ -12,6 +12,7 @@
 #include <poll.h>
 #include <sys/wait.h>
 #include <error.h>
+#include <assert.h>
 
 #include "helpers.h"
 #include "liburing.h"
@@ -22,6 +23,15 @@ static void do_setsockopt(int fd, int level, int optname, int val)
 		error(1, errno, "setsockopt %d.%d: %d", level, optname, val);
 }
 
+static bool check_cq_empty(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe = NULL;
+	int ret;
+
+	ret = io_uring_peek_cqe(ring, &cqe); /* nothing should be there */
+	return ret == -EAGAIN;
+}
+
 static int test_basic(void)
 {
 	struct io_uring_cqe *cqe;
@@ -110,9 +120,6 @@ static int test_missing_events(void)
 	char buf[2] = {};
 	int res_mask = 0;
 
-	if (!t_probe_defer_taskrun())
-		return 0;
-
 	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER |
 					    IORING_SETUP_DEFER_TASKRUN);
 	if (ret) {
@@ -180,6 +187,66 @@ static int test_missing_events(void)
 	return 0;
 }
 
+static int test_disabled_ring_lazy_polling(int early_poll)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct io_uring ring, ring2;
+	unsigned head;
+	int ret, i = 0;
+
+	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER |
+					     IORING_SETUP_DEFER_TASKRUN |
+					     IORING_SETUP_R_DISABLED);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+	}
+	ret = io_uring_queue_init(8, &ring2, 0);
+	if (ret) {
+		fprintf(stderr, "ring2 setup failed: %d\n", ret);
+		return 1;
+	}
+
+	if (early_poll) {
+		/* start polling disabled DEFER_TASKRUN ring */
+		sqe = io_uring_get_sqe(&ring2);
+		io_uring_prep_poll_add(sqe, ring.ring_fd, POLLIN);
+		ret = io_uring_submit(&ring2);
+		assert(ret == 1);
+		assert(check_cq_empty(&ring2));
+	}
+
+	/* enable rings, which should also activate pollwq */
+	ret = io_uring_enable_rings(&ring);
+	assert(ret >= 0);
+
+	if (!early_poll) {
+		/* start polling enabled DEFER_TASKRUN ring */
+		sqe = io_uring_get_sqe(&ring2);
+		io_uring_prep_poll_add(sqe, ring.ring_fd, POLLIN);
+		ret = io_uring_submit(&ring2);
+		assert(ret == 1);
+		assert(check_cq_empty(&ring2));
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_nop(sqe);
+	ret = io_uring_submit(&ring);
+	assert(ret == 1);
+
+	io_uring_for_each_cqe(&ring2, head, cqe) {
+		i++;
+	}
+	if (i !=  1) {
+		fprintf(stderr, "fail, polling stuck\n");
+		return 1;
+	}
+	io_uring_queue_exit(&ring);
+	io_uring_queue_exit(&ring2);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	int ret;
@@ -193,10 +260,25 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
-	ret = test_missing_events();
-	if (ret) {
-		fprintf(stderr, "test_missing_events() failed %i\n", ret);
-		return T_EXIT_FAIL;
+
+	if (t_probe_defer_taskrun()) {
+		ret = test_missing_events();
+		if (ret) {
+			fprintf(stderr, "test_missing_events() failed %i\n", ret);
+			return T_EXIT_FAIL;
+		}
+
+		ret = test_disabled_ring_lazy_polling(false);
+		if (ret) {
+			fprintf(stderr, "test_disabled_ring_lazy_polling(false) failed %i\n", ret);
+			return T_EXIT_FAIL;
+		}
+
+		ret = test_disabled_ring_lazy_polling(true);
+		if (ret) {
+			fprintf(stderr, "test_disabled_ring_lazy_polling(true) failed %i\n", ret);
+			return T_EXIT_FAIL;
+		}
 	}
 
 	return 0;
-- 
2.38.1

