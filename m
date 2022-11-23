Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4941D635BE4
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbiKWLgi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbiKWLgg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:36:36 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FA011DA29
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:36:35 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id s5so11760038wru.1
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=da2QefqNv60KG19SLkKIuXsfvTh0a3cDn3yIWSSJr1o=;
        b=c/VJRP6u53JaT7z4oWZarghKX38OQd5BsfwI5h7VHiB7WxLfvZ8GBwtOAJWVotxNXJ
         l+ic9itW7ORuwpimoUp3/gKR8hZKbQLVZV1sJqGkvdSrP6QhPA2hIFsyqx42O4tc+Ycs
         RFSkXu7FI+OqreB3mnDow/KBh4VSvL4OrKR1on97VhoDtgKgcsezqvuxZYc4QgVzJI4d
         hiIA2lJVsCuEZ3YYAL3FeemFCDVu5IoZZlf9QnyqThQg84LhaDoTeNy+q9XUbvWHIUyC
         gxYUi+7u85sEh7koyM9otvxdH2h0pych0KiiNhiUcPbv8BdQiuLYm/u+aHCvxLZmbF7q
         LqSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=da2QefqNv60KG19SLkKIuXsfvTh0a3cDn3yIWSSJr1o=;
        b=BCuOGO0e3Ga2hNILpCGZYR6sDJmWg7+Wb/zjU3GGwjtWvcfo1E1jrYs51RTIZRV8lh
         5MuHpOjlEToXNtmPcdDhcjLVEsPf0oLWKiETil+NhtjkNBxSAip0vUgBSKE66QJtk0Rx
         iKM2UyEfLHWDFKp95lc+/hQk0iYKKRgLkDoE/AyfJxZAQt4TG2w4d7VrMf6Up3ncU0wG
         UEJEBgbb96r3DdRZAhAT6FvNP0bp5jzDZgQHxchSKWPG00SaIedfFdrxWQWdGk/eSORd
         ecnN7Yy3gT/f0fEb6CbD6Mc+SPdEKtVRqNWFLRIsyoj4sq+/2UISDS64XzpOj9f4GGyJ
         yx6w==
X-Gm-Message-State: ANoB5pmVPlS7ZzwYPLLsZJmECQWhVD0ihqWd+xtrI4ZfdGNBH2vbv5N2
        0mQC+TmhISc/Ll8ZMWrHb/pLs5uuxuY=
X-Google-Smtp-Source: AA0mqf61TFD4p4aAfXTahwrvgaZXETOAmZjbrJQyDzq3VHN5kgV4BKdPbc+BmmZl7rKQxO5M3fr7Bg==
X-Received: by 2002:a5d:4241:0:b0:236:57cf:1b6f with SMTP id s1-20020a5d4241000000b0023657cf1b6fmr5272698wrr.153.1669203393980;
        Wed, 23 Nov 2022 03:36:33 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e1b])
        by smtp.gmail.com with ESMTPSA id y9-20020a5d4ac9000000b00241ce5d605dsm10854508wrs.110.2022.11.23.03.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 03:36:33 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/3] tests: refactor poll.c
Date:   Wed, 23 Nov 2022 11:35:09 +0000
Message-Id: <880d8b2607a063442659025a43240127a8887470.1669079092.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669079092.git.asml.silence@gmail.com>
References: <cover.1669079092.git.asml.silence@gmail.com>
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

Extract all poll.c testing into a separate function

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/poll.c | 49 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/test/poll.c b/test/poll.c
index 42123bd..f0c1c40 100644
--- a/test/poll.c
+++ b/test/poll.c
@@ -12,9 +12,10 @@
 #include <poll.h>
 #include <sys/wait.h>
 
+#include "helpers.h"
 #include "liburing.h"
 
-int main(int argc, char *argv[])
+static int test_basic(void)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
@@ -23,20 +24,16 @@ int main(int argc, char *argv[])
 	pid_t p;
 	int ret;
 
-	if (argc > 1)
-		return 0;
-
 	if (pipe(pipe1) != 0) {
 		perror("pipe");
 		return 1;
 	}
 
 	p = fork();
-	switch (p) {
-	case -1:
+	if (p == -1) {
 		perror("fork");
 		exit(2);
-	case 0: {
+	} else if (p == 0) {
 		ret = io_uring_queue_init(1, &ring, 0);
 		if (ret) {
 			fprintf(stderr, "child: ring setup failed: %d\n", ret);
@@ -78,18 +75,36 @@ int main(int argc, char *argv[])
 							(long) cqe->res);
 			return 1;
 		}
+
+		io_uring_queue_exit(&ring);
 		exit(0);
-		}
-	default:
-		do {
-			errno = 0;
-			ret = write(pipe1[1], "foo", 3);
-		} while (ret == -1 && errno == EINTR);
+	}
 
-		if (ret != 3) {
-			fprintf(stderr, "parent: bad write return %d\n", ret);
-			return 1;
-		}
+	do {
+		errno = 0;
+		ret = write(pipe1[1], "foo", 3);
+	} while (ret == -1 && errno == EINTR);
+
+	if (ret != 3) {
+		fprintf(stderr, "parent: bad write return %d\n", ret);
+		return 1;
+	}
+	close(pipe1[0]);
+	close(pipe1[1]);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1)
 		return 0;
+
+	ret = test_basic();
+	if (ret) {
+		fprintf(stderr, "test_basic() failed %i\n", ret);
+		return T_EXIT_FAIL;
 	}
+	return 0;
 }
-- 
2.38.1

