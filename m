Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B83D3F7BCA
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 19:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbhHYRzF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 13:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhHYRzC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 13:55:02 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7CCC0613C1
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 10:54:16 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id u15so53524wmj.1
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 10:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+G/eNPvdggyi2dvgIHMZmb5tIiltQv++r0iLiEwml+k=;
        b=dAkEyuBhI9ndTIZUIjSmVLeXGSeuEwFlbThhzyig+HV1VAp6yRQ36v5T+5dk8Ji9aw
         Dzis/OlOs1i3WxNPVqke6yEuyiQoHSWr/awZhQX04l5XUWUcYZZ+exoSvPVFkDaM5uvn
         00wo+N/V3aISQ/dfiknNRYsdy7F29E6Yw0lpEc5ofVUnKRg1NUWV41mnECsPbeqvxYwQ
         3IpPevJAmFkrKzXSHOoxZmzVWHYVZ1DCN+AQ7Fa6jt7a55g/Um1NahhncqywubsU77Iy
         WlmfnNCr/qTVE6puh/jwe0Q3RlsjY5975H9itTroGiBt5MCXIYsI43Ez1YbaZvCK860r
         3bCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+G/eNPvdggyi2dvgIHMZmb5tIiltQv++r0iLiEwml+k=;
        b=HWKnuKXg5SriQa3wSgMe6IyHXn1g0Hi2RbW8AJAjMK0+iS0jgjeuiRY3scx6vCghaT
         9LkMMxH+IntFUYHsMM23U1MDdZ1v+upYlpVNGybb1eC1Tkqj5kz24Bx5Snlvqmh63iuP
         gyeC06NuvsA8itIhg+SqtVVWGxnaZ4/FXVNJu72XIEQ6FbuWyqcgYHO+pEYNhdxdUZOZ
         qo3lTt0026w/SgBIGL9o+gj1+wg4dC9nRRftoVYM7mOK5uKmzoNylcOhUZggUgJ6KK6p
         yGCrtWD1K5DPHmh94+DWBkTsbo5o6NwgfZHz59tKp7CefzI0ONiak1lL1ky48yd+pVf7
         ia0w==
X-Gm-Message-State: AOAM530A9qKqKS2OdnshRyjKfhh1OPNW0UxeYXID2FZRW/sdwjTBLkB8
        wh/pQhRDwO4S1p7gcgaIuRQBLzRgs2c=
X-Google-Smtp-Source: ABdhPJx+qc+u6TF2mQiOq0TRpsPmseq77obO78A23Sv6c1wdZgOqtjm2osum/EDpBa2WfgLUgPQkdQ==
X-Received: by 2002:a05:600c:4ca2:: with SMTP id g34mr7067943wmp.46.1629914055071;
        Wed, 25 Aug 2021 10:54:15 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id q9sm590459wrs.3.2021.08.25.10.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 10:54:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/2] tests: don't skip sqpoll needlessly
Date:   Wed, 25 Aug 2021 18:53:35 +0100
Message-Id: <9ace2f7ac85ac105e46bb8d09afee96c5dc842b1.1629913874.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629913874.git.asml.silence@gmail.com>
References: <cover.1629913874.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Newer kernels support non-privileged SQPOLL, don't skip sqpoll testing
in sq-poll-kthread and others when it would work just fine.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/d4ae271dfaae-test.c |  5 -----
 test/sq-poll-kthread.c   | 14 ++++++--------
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/test/d4ae271dfaae-test.c b/test/d4ae271dfaae-test.c
index 80d3f71..10c7e98 100644
--- a/test/d4ae271dfaae-test.c
+++ b/test/d4ae271dfaae-test.c
@@ -27,11 +27,6 @@ int main(int argc, char *argv[])
 	char *fname;
 	void *buf;
 
-	if (geteuid()) {
-		fprintf(stdout, "Test requires root, skipping\n");
-		return 0;
-	}
-
 	memset(&p, 0, sizeof(p));
 	p.flags = IORING_SETUP_SQPOLL;
 	ret = t_create_ring_params(4, &ring, &p);
diff --git a/test/sq-poll-kthread.c b/test/sq-poll-kthread.c
index ed7d0bf..0a0a75a 100644
--- a/test/sq-poll-kthread.c
+++ b/test/sq-poll-kthread.c
@@ -17,6 +17,7 @@
 #include <sys/epoll.h>
 
 #include "liburing.h"
+#include "helpers.h"
 
 #define SQ_THREAD_IDLE  2000
 #define BUF_SIZE        128
@@ -38,23 +39,20 @@ static int do_test_sq_poll_kthread_stopped(bool do_exit)
 	uint8_t buf[BUF_SIZE];
 	struct iovec iov;
 
-	if (geteuid()) {
-		fprintf(stderr, "sqpoll requires root!\n");
-		return TEST_SKIPPED;
-	}
-
 	if (pipe(pipe1) != 0) {
 		perror("pipe");
 		return TEST_FAILED;
 	}
 
 	memset(&param, 0, sizeof(param));
-
 	param.flags |= IORING_SETUP_SQPOLL;
 	param.sq_thread_idle = SQ_THREAD_IDLE;
 
-	ret = io_uring_queue_init_params(16, &ring, &param);
-	if (ret) {
+	ret = t_create_ring_params(16, &ring, &param);
+	if (ret == T_SETUP_SKIP) {
+		ret = TEST_FAILED;
+		goto err_pipe;
+	} else if (ret != T_SETUP_OK) {
 		fprintf(stderr, "ring setup failed\n");
 		ret = TEST_FAILED;
 		goto err_pipe;
-- 
2.32.0

