Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41A945F5F0
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 21:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhKZUhw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 15:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239450AbhKZUfw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 15:35:52 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5509AC06137E
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 12:25:54 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id z5so43410488edd.3
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 12:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oXxF8pOXLObRJo1CNRtnu9qapxcwUYMO0x5oNzOu3f8=;
        b=lrCL/BicbHB5FY3o429VBuRA+cXeGw/6vd/EZbaLku7bVWiNcbIE8kLu8AMx6aRmZf
         e9lFSxn03fujsmz9MxXDTjmdcrgWH+mmThbghYw+vF+tmC/FEOlA6xqwwgbHM8Ulj7MZ
         3kNe2VEUVzgq8M2zO4f1z3xjFtp2bUTQms3jjPwV6B9fFYLisKVy9uWtxPpIsMq4I3kF
         fzAO0USSVGxCurqMDBC0IURx0LzXyz4YXqDLh+abajJwZKCPhQ5/7pmFMhCxE9lLIM0V
         UbTnkQSTL8z9JCQk6vy/s6ln0Hw/OuEf1XFKIIjKnNxxTGd+GjyDNmpi2fOan6rJDvmY
         DMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oXxF8pOXLObRJo1CNRtnu9qapxcwUYMO0x5oNzOu3f8=;
        b=DxX+2FRibkjITcdvoBiq+gHFbxS/m+yoQjAbBKXn+twa5b/iHrAu7gjZFzyHb5F89B
         V/VLaBAoykdkFPqqpCUI6FyGa9Viq6JmxeEYfWvgKqQAKrUP+WHalcy9RKnXfhrU93px
         JrrsSKUtIpaj76K8+Li98cWFLXPnFv8vqFD3GVjNTVs6UGdDnnqny0QSOcN+IOH+rMuL
         kh1STXsslW3HBDLpoovzios4OB6ymb1bvB9yYVbPrqSrWaz7rYMmAN/9cRRTWoZNU5Bz
         oFmvNc1IJQOvc+ynuEhYccBCkdmUvhc/ti080sQtlNeyETFhEV0VkhRHGQe2Bc/lIzbD
         Y/Dw==
X-Gm-Message-State: AOAM530VpFwW8xuZdQ2rQsdKHm58Nt7V2EqVhm3T81o5jQIjCAjn+1qD
        1lgE4KXoT76qW/qe63kJGwAyA/nl9ks=
X-Google-Smtp-Source: ABdhPJz95ne6EWwzgNRzlY6Mujmdhh8ZGirFegOCcnweh0RLSpe2fL2I4YUJnx+3+doAKUvwJllUSg==
X-Received: by 2002:a17:906:2844:: with SMTP id s4mr40624117ejc.66.1637958352603;
        Fri, 26 Nov 2021 12:25:52 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id aq14sm3604481ejc.23.2021.11.26.12.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 12:25:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH liburing 1/1] test: skip-cqe with hardlinks
Date:   Fri, 26 Nov 2021 20:25:42 +0000
Message-Id: <fe5333e8832e6bacb5c9ca9ec8d0004a6fd2646d.1637958333.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Test IOSQE_CQE_SKIP_SUCCESS together with IOSQE_IO_HARDLINK.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/skip-cqe.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 1 deletion(-)

diff --git a/test/skip-cqe.c b/test/skip-cqe.c
index 184932f..9de5bae 100644
--- a/test/skip-cqe.c
+++ b/test/skip-cqe.c
@@ -4,6 +4,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
+#include <assert.h>
 
 #include "liburing.h"
 
@@ -232,10 +233,79 @@ static int test_ltimeout_fire(struct io_uring *ring, bool async,
 	return 0;
 }
 
+static int test_hardlink(struct io_uring *ring, int nr, int fail_idx,
+			int skip_idx, bool hardlink_last)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret, i;
+
+	assert(fail_idx < nr);
+	assert(skip_idx < nr);
+
+	for (i = 0; i < nr; i++) {
+		sqe = io_uring_get_sqe(ring);
+		if (i == fail_idx)
+			prep_exec_fail_req(sqe);
+		else
+			io_uring_prep_nop(sqe);
+		if (i != nr - 1 || hardlink_last)
+			sqe->flags |= IOSQE_IO_HARDLINK;
+		if (i == skip_idx)
+			sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
+		sqe->user_data = i;
+	}
+
+	ret = io_uring_submit(ring);
+	if (ret != nr) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	for (i = 0; i < nr; i++) {
+		if (i == skip_idx && fail_idx != skip_idx)
+			continue;
+
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret != 0) {
+			fprintf(stderr, "wait completion %d\n", ret);
+			goto err;
+		}
+		if (cqe->user_data != i) {
+			fprintf(stderr, "invalid user_data %d (%i)\n",
+				(int)cqe->user_data, i);
+			goto err;
+		}
+		if (i == fail_idx) {
+			if (cqe->res >= 0) {
+				fprintf(stderr, "req should've failed %d %d\n",
+					(int)cqe->user_data, cqe->res);
+				goto err;
+			}
+		} else {
+			if (cqe->res) {
+				fprintf(stderr, "req error %d %d\n",
+					(int)cqe->user_data, cqe->res);
+				goto err;
+			}
+		}
+
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	if (io_uring_peek_cqe(ring, &cqe) >= 0) {
+		fprintf(stderr, "single CQE expected %i\n", (int)cqe->user_data);
+		goto err;
+	}
+	return 0;
+err:
+	return 1;
+}
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring;
-	int ret, i;
+	int ret, i, j, k;
 	int mid_idx = LINK_SIZE / 2;
 	int last_idx = LINK_SIZE - 1;
 
@@ -331,6 +401,23 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	/* test 3 positions, start/middle/end of the link, i.e. indexes 0, 3, 6 */
+	for (i = 0; i < 3; i++) {
+		for (j = 0; j < 3; j++) {
+			for (k = 0; k < 2; k++) {
+				bool mark_last = k & 1;
+
+				ret = test_hardlink(&ring, 7, i * 3, j * 3, mark_last);
+				if (ret) {
+					fprintf(stderr, "test_hardlink failed"
+							"fail %i skip %i mark last %i\n",
+						i * 3, j * 3, k);
+					return 1;
+				}
+			}
+		}
+	}
+
 	close(fds[0]);
 	close(fds[1]);
 	io_uring_queue_exit(&ring);
-- 
2.34.0

