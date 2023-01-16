Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2042A66CAB6
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 18:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbjAPRGR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 12:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbjAPRFt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 12:05:49 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA84A42BD1
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:47:15 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id iv8-20020a05600c548800b003db04a0a46bso77808wmb.0
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dBVp6yRtRK9lPrnY+FhtWIbQj375GGk2O7UbyglVeRI=;
        b=Tw/UBEvFwfZ4gfOsa6d+8gel1ZykUZfHUxkjXMklwLxhwQDYi4FdoEHlHmYrFcMSO9
         cV1VX16olK0tu1YeY1fkZ/iNJHgA8VoWk7cJA2StbvW5fFwgsGN0b1B4k4OXTh5+s50z
         ePJNc93m+VzUbSLfpmbrqEXJMn+0M0xhPUJLtMN7vqDmPW66GR2aCkuUa2HIvnm8JGwb
         D1KKZkOcyYG8pWzFxeLWE9nGEWRxAhCs7GJGruAUZVnSqLb2jE/unGxFmTU/8r8nlt/k
         jLTI4HV3qZeZ08C8PWKXlzJTNKrzq4zvog3VLUeYcthRxSkLyHImUcQ5WW/ZVaDQzHPW
         8lxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dBVp6yRtRK9lPrnY+FhtWIbQj375GGk2O7UbyglVeRI=;
        b=6GPjCPwOOHEe45wkwa/aoo4aNFIXd2fmASAwaM4WgENDbSqlv8jrzc9v4rIb2ZOWPc
         wWjaV95hNa44R/dHVnFve3WW4g3KbrUE1qPyHkMUqGbZJd7sXpb8g/X3eiV/j4rRZmRx
         oVFBc9GxBhoB2CfzbgK/SoCswiL43YzqyD9xOAztnRZuYtnYG15iIqJGzgjgc/KQ0D7t
         23MVe2xvXyCupbrv4D3kY+eNEewUcgTZIapWlsWQF8oIB7eLUtGejWaD96JSTW6uiX74
         vB+01xxwYdkd954S/iSVU6dcGuRrahY7ZVWRIKC1U3J65EYpq4HxZMJUabJ2BIn2A2oy
         eTAQ==
X-Gm-Message-State: AFqh2kqPlcZUDXpTHd0GEHnBB7llwZcJfM+UGwCK/t1IpKHAQtVf4nnA
        MADThtsW3P5QDmc+O5TeXTxZHsc28QU=
X-Google-Smtp-Source: AMrXdXttATKKg9x2Zkwh0qETCZyEWYdiZx/1BURH+lK19dB4fbHC8CCAWOl2IZv9M+hMlJMU1asfZg==
X-Received: by 2002:a05:600c:1d29:b0:3d9:69fd:7707 with SMTP id l41-20020a05600c1d2900b003d969fd7707mr8835824wms.2.1673887633719;
        Mon, 16 Jan 2023 08:47:13 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.33.8.threembb.co.uk. [92.41.33.8])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c444a00b003d998412db6sm42012397wmn.28.2023.01.16.08.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 08:47:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/3] tests: refactor poll-many.c
Date:   Mon, 16 Jan 2023 16:46:07 +0000
Message-Id: <2c4935efe1ba84e48bf444afc119ad60a51befc5.1673886955.git.asml.silence@gmail.com>
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

Use right return codes and extract the testing into a function

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/poll-many.c | 46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/test/poll-many.c b/test/poll-many.c
index dfbeeab..ebf22e8 100644
--- a/test/poll-many.c
+++ b/test/poll-many.c
@@ -14,6 +14,7 @@
 #include <fcntl.h>
 
 #include "liburing.h"
+#include "helpers.h"
 
 #define	NFILES	5000
 #define BATCH	500
@@ -137,6 +138,21 @@ static int arm_polls(struct io_uring *ring)
 	return 0;
 }
 
+static int do_test(struct io_uring *ring)
+{
+	int i;
+
+	if (arm_polls(ring))
+		return 1;
+
+	for (i = 0; i < NLOOPS; i++) {
+		trigger_polls();
+		if (reap_polls(ring))
+			return 1;
+	}
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring;
@@ -149,7 +165,7 @@ int main(int argc, char *argv[])
 
 	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0) {
 		perror("getrlimit");
-		goto err_noring;
+		return T_EXIT_FAIL;
 	}
 
 	if (rlim.rlim_cur < (2 * NFILES + 5)) {
@@ -159,14 +175,14 @@ int main(int argc, char *argv[])
 			if (errno == EPERM)
 				goto err_nofail;
 			perror("setrlimit");
-			goto err_noring;
+			return T_EXIT_FAIL;
 		}
 	}
 
 	for (i = 0; i < NFILES; i++) {
 		if (pipe(p[i].fd) < 0) {
 			perror("pipe");
-			goto err_noring;
+			return T_EXIT_FAIL;
 		}
 	}
 
@@ -176,31 +192,23 @@ int main(int argc, char *argv[])
 	if (ret) {
 		if (ret == -EINVAL) {
 			fprintf(stdout, "No CQSIZE, trying without\n");
-			ret = io_uring_queue_init(RING_SIZE, &ring, 0);
+
+			params.flags &= ~IORING_SETUP_CQSIZE;
+			params.cq_entries = 0;
+			ret = io_uring_queue_init_params(RING_SIZE, &ring, &params);
 			if (ret) {
 				fprintf(stderr, "ring setup failed: %d\n", ret);
-				return 1;
+				return T_EXIT_FAIL;
 			}
 		}
 	}
 
-	if (arm_polls(&ring))
-		goto err;
-
-	for (i = 0; i < NLOOPS; i++) {
-		trigger_polls();
-		ret = reap_polls(&ring);
-		if (ret)
-			goto err;
+	if (do_test(&ring)) {
+		fprintf(stderr, "test (normal) failed\n");
+		return T_EXIT_FAIL;
 	}
-
 	io_uring_queue_exit(&ring);
 	return 0;
-err:
-	io_uring_queue_exit(&ring);
-err_noring:
-	fprintf(stderr, "poll-many failed\n");
-	return 1;
 err_nofail:
 	fprintf(stderr, "poll-many: not enough files available (and not root), "
 			"skipped\n");
-- 
2.38.1

