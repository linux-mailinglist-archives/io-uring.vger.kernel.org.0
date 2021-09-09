Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D954058FE
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 16:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240419AbhIIO1q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 10:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239601AbhIIO1j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 10:27:39 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB3CC05BD31
        for <io-uring@vger.kernel.org>; Thu,  9 Sep 2021 06:07:51 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v10so2494179wrd.4
        for <io-uring@vger.kernel.org>; Thu, 09 Sep 2021 06:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RWrgBMgGkAOQi0TLR84rIkrfXsgYnZ8CBYSNWCOR7OQ=;
        b=evcHa1Yw6ELAwg8c5sjoBc539kTyNcsWLA5rgPCnaHY+L0/14UvksAOOTD/ChzqfjK
         UlR4lQMFKie/+ZyqwyGfDSbmMbDp9JNIv8xzMwa/XKevxYqaHj7xRla/I6/9vEiiudi9
         q0z7aWWYV/n+2ap8QWscqKjVXkRHA1Rk5sOglf147C2s5jAjui6Qyyl/3SLoE1C20Rp7
         TvSm4UovJPVPsKuSibBvvJVwyJ0YGNso1yR3iqMMYRxUiZx59g1vmzxOG7GvEdQpgWBj
         LBj/0QhZlUAzz3Yn4egNsB3Sw7xJq/8Xw14yw9/RUMv6VzrMn4rwM2cWBtneWHKJ7TMP
         I9LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RWrgBMgGkAOQi0TLR84rIkrfXsgYnZ8CBYSNWCOR7OQ=;
        b=vReovPvE2csTrdZD/p9AWg8uhJey2wHuhGLkiL3wPj1zgHycxFq083HCNsE16J412/
         Rx0lY5cUF/OLRb/EQzvqmcSzI6lFJDOxOjTkVpZqWJFbyGa0PVTTdCNAgdpx6itcP7bB
         qwK4mSCDsMa5hdrILLdOTYa9hjPkB5FJ2173G2dk9iFzmLHBEUuE79PIa3N+3UJuZnzg
         DPSzbdIw7y++B4g7M84+XqRZvW1Jor1E91OeXyWMn2ZA2JiPyuVPqBODanp2fQDWKZyc
         rTtnfWLZjROjw1IGL3R/G34uLRQu62ZQpC5R1e13KNjcLNlgIgXFLOV+kSkuS8kvVwpy
         vTXQ==
X-Gm-Message-State: AOAM533YUYe8JGg6sZSTFZXpA2X/toZuAbCUKLSDbgcj5ZhGg5cIpLnN
        gE+0TfSLdlinLJYB7LiJgA/LgJgeF14=
X-Google-Smtp-Source: ABdhPJyt2lrtoVS4J8hR0rGlc+x6Rjbd0jrsDUUzqBockJylI93b52Gw3B0e6qUXfFIR54xpQnePjA==
X-Received: by 2002:adf:f884:: with SMTP id u4mr3344397wrp.411.1631192870580;
        Thu, 09 Sep 2021 06:07:50 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.167])
        by smtp.gmail.com with ESMTPSA id w20sm1762096wrg.1.2021.09.09.06.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 06:07:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/2] tests: test timeout cancellation fails links
Date:   Thu,  9 Sep 2021 14:07:09 +0100
Message-Id: <966a04e2acf0d7e8362141e4e57861311356688e.1631192734.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631192734.git.asml.silence@gmail.com>
References: <cover.1631192734.git.asml.silence@gmail.com>
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

