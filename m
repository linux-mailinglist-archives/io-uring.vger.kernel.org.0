Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673B740763B
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 13:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhIKLN4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 07:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhIKLNx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 07:13:53 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6260AC061574
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 04:12:41 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l7-20020a1c2507000000b002e6be5d86b3so3095720wml.3
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 04:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RWrgBMgGkAOQi0TLR84rIkrfXsgYnZ8CBYSNWCOR7OQ=;
        b=EBEo0d+WFFn7mGFIVScEvZK8utU5CZN4cq+UKfuGue5L95P5sBgeOl/Qxnx8vF81CW
         4iwkS3Rfdh/XTa7uDh9M4mchAQ41cetyyMyhWX4Wq0+5K222xv5T1UotVq/3numNTmaW
         oWkMS5WeVrF6K1+7H8lFHcQKueEp0aVnIYLDRKWHfbKIYHZ9B8KYKJBplohLmq5cvR9T
         AXQQQ7wl0EjcpqmQ5pcL0SelcpGxgskU4T6fUyDPW07+WvQTp7tMQyhhTC3Ep35HQU57
         0auMZ9yyrEokeHHwyu04Tp6AupStnDUKpd2oFVpJ28bnyQg9FR4vflitabyR1eAvsw7s
         emeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RWrgBMgGkAOQi0TLR84rIkrfXsgYnZ8CBYSNWCOR7OQ=;
        b=mra3u+3H1n/36qij3V5B8da44wrrBdM3ktjl1U6Tetd1Z5tJaI50VKgwRAgvm4lI2N
         lM/tuVBZ+M8fpUv3U//xUnWNXtelKkgN5bkJGoZn+EOjASvwI1UWuAwhtcGTf+xlpCC1
         o5xvpXgPBv1pMSytZ2jr7H4NlSYzQiikSM3/Tr0Cn5U++Zz1edioU2ff2zEYq2gD4OhJ
         27+c+2gzL2ykGP5m0hxnYTveiosyPO1IZapgUCnyrcpW4lXPvUxIbuOqP+8U+MHRGI+t
         ijMY4hElifHu26wsqVyzvEEtxz1ihMw1gFgqIUVOwTC8cpFote0yGYXCg6gtwrvUGk9e
         H3SA==
X-Gm-Message-State: AOAM531Hq4AWdPWI+EURD3UdO9OIDmQDxACA+OlEQLNgBdIendXoSMYj
        g2Ku6O21KB/sTbWJpH6JtOGy/6xY0ic=
X-Google-Smtp-Source: ABdhPJzs3CcRIQycmx8xQ034hglF8SqNcLIShtElz/ukuLpCF/D8YNsHjduBzyE8XmJ+OwPY92/Esg==
X-Received: by 2002:a05:600c:2250:: with SMTP id a16mr2307062wmm.72.1631358760063;
        Sat, 11 Sep 2021 04:12:40 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.175])
        by smtp.gmail.com with ESMTPSA id x11sm1335470wmk.21.2021.09.11.04.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 04:12:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing v2 2/2] tests: test timeout cancellation fails links
Date:   Sat, 11 Sep 2021 12:11:56 +0100
Message-Id: <e9acec809a3d86cab22601fe87c963c4ffac61e6.1631358658.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631358658.git.asml.silence@gmail.com>
References: <cover.1631358658.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Test that we appropriately fail linked requests when we cancel a
normal timeout.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/timeout.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/test/timeout.c b/test/timeout.c
index d2e4930..cef6846 100644
--- a/test/timeout.c
+++ b/test/timeout.c
@@ -10,6 +10,8 @@
 #include <string.h>
 #include <fcntl.h>
 #include <sys/time.h>
+#include <sys/wait.h>
+#include <sys/types.h>
 
 #include "liburing.h"
 #include "../src/syscall.h"
@@ -1171,6 +1173,82 @@ err:
 	return 1;
 }
 
+static int test_timeout_link_cancel(void)
+{
+	struct io_uring ring;
+	struct io_uring_cqe *cqe;
+	pid_t p;
+	int ret, i, wstatus;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+
+	p = fork();
+	if (p == -1) {
+		fprintf(stderr, "fork() failed\n");
+		return 1;
+	}
+
+	if (p == 0) {
+		struct io_uring_sqe *sqe;
+		struct __kernel_timespec ts;
+		const char *prog_path = "./exec-target";
+
+		msec_to_ts(&ts, 10000);
+		sqe = io_uring_get_sqe(&ring);
+		io_uring_prep_timeout(sqe, &ts, 0, 0);
+		sqe->flags |= IOSQE_IO_LINK;
+		sqe->user_data = 0;
+
+		sqe = io_uring_get_sqe(&ring);
+		io_uring_prep_nop(sqe);
+		sqe->user_data = 1;
+
+		ret = io_uring_submit(&ring);
+		if (ret != 2) {
+			fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+			exit(1);
+		}
+
+		/* trigger full cancellation */
+		ret = execl(prog_path, prog_path, NULL);
+		if (ret) {
+			fprintf(stderr, "exec failed %i\n", errno);
+			exit(1);
+		}
+		exit(0);
+	}
+
+	if (waitpid(p, &wstatus, 0) == (pid_t)-1) {
+		perror("waitpid()");
+		return 1;
+	}
+	if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus)) {
+		fprintf(stderr, "child failed %i\n", WEXITSTATUS(wstatus));
+		return 1;
+	}
+
+	for (i = 0; i < 2; ++i) {
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "wait_cqe=%d\n", ret);
+			return 1;
+		}
+		if (cqe->res != -ECANCELED) {
+			fprintf(stderr, "invalid result, user_data: %i res: %i\n",
+					(int)cqe->user_data, cqe->res);
+			return 1;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring, sqpoll_ring;
@@ -1348,6 +1426,12 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_timeout_link_cancel();
+	if (ret) {
+		fprintf(stderr, "test_timeout_link_cancel failed\n");
+		return ret;
+	}
+
 	if (sqpoll)
 		io_uring_queue_exit(&sqpoll_ring);
 	return 0;
-- 
2.33.0

