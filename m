Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8378562092
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 18:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbiF3QuK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 12:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235969AbiF3QuI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 12:50:08 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB00B35269
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:50:07 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U7Upi8009340
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:50:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=qLdVoMa0kj/ezY488L/hv4CmRi0Qmg8ruKaqWcOmxtQ=;
 b=fFG+TgftRUXXJ4MiTs++5u6JBu5pyFJeV6pr4jbHDdNWbGQeJWAjkB/EMIfh1wjhbg8R
 FgsrfUtQacVNCf2VyvRl0p1U+/yLPjuSwLEX9hxquxETdnDHpYZfJNTWkhAiGtslurUR
 oKGR/YcLf1bkLGsFRmcaCM6nLcqUEGulGOY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h17geuveg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:50:06 -0700
Received: from twshared14577.08.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 09:50:05 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 54C3725D4D2A; Thu, 30 Jun 2022 09:49:28 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v3 liburing 6/7] add poll overflow test
Date:   Thu, 30 Jun 2022 09:49:17 -0700
Message-ID: <20220630164918.3958710-7-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630164918.3958710-1-dylany@fb.com>
References: <20220630164918.3958710-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 980g7koY2YRVLDBloso6z4FyTU3E2xDz
X-Proofpoint-GUID: 980g7koY2YRVLDBloso6z4FyTU3E2xDz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_12,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a test that when CQE overflows, multishot poll doesn't give
out of order completions.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/Makefile              |   1 +
 test/poll-mshot-overflow.c | 128 +++++++++++++++++++++++++++++++++++++
 2 files changed, 129 insertions(+)
 create mode 100644 test/poll-mshot-overflow.c

diff --git a/test/Makefile b/test/Makefile
index e718583..9590e1e 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -117,6 +117,7 @@ test_srcs :=3D \
 	poll-link.c \
 	poll-many.c \
 	poll-mshot-update.c \
+	poll-mshot-overflow.c \
 	poll-ring.c \
 	poll-v-poll.c \
 	pollfree.c \
diff --git a/test/poll-mshot-overflow.c b/test/poll-mshot-overflow.c
new file mode 100644
index 0000000..078df04
--- /dev/null
+++ b/test/poll-mshot-overflow.c
@@ -0,0 +1,128 @@
+// SPDX-License-Identifier: MIT
+
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <signal.h>
+#include <poll.h>
+#include <sys/wait.h>
+
+#include "liburing.h"
+
+int check_final_cqe(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	int count =3D 0;
+	bool signalled_no_more =3D false;
+
+	while (!io_uring_peek_cqe(ring, &cqe)) {
+		if (cqe->user_data =3D=3D 1) {
+			count++;
+			if (signalled_no_more) {
+				fprintf(stderr, "signalled no more!\n");
+				return 1;
+			}
+			if (!(cqe->flags & IORING_CQE_F_MORE))
+				signalled_no_more =3D true;
+		} else if (cqe->user_data !=3D 3) {
+			fprintf(stderr, "%d: got unexpected %d\n", count, (int)cqe->user_data=
);
+			return 1;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	if (!count) {
+		fprintf(stderr, "no cqe\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+	int pipe1[2];
+	int ret, i;
+
+	if (argc > 1)
+		return 0;
+
+	if (pipe(pipe1) !=3D 0) {
+		perror("pipe");
+		return 1;
+	}
+
+	struct io_uring_params params =3D {
+		.flags =3D IORING_SETUP_CQSIZE,
+		.cq_entries =3D 2
+	};
+
+	ret =3D io_uring_queue_init_params(2, &ring, &params);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+	}
+
+	sqe =3D io_uring_get_sqe(&ring);
+	if (!sqe) {
+		fprintf(stderr, "get sqe failed\n");
+		return 1;
+	}
+	io_uring_prep_poll_multishot(sqe, pipe1[0], POLLIN);
+	io_uring_sqe_set_data64(sqe, 1);
+
+	if (io_uring_cq_ready(&ring)) {
+		fprintf(stderr, "unexpected cqe\n");
+		return 1;
+	}
+
+	for (i =3D 0; i < 2; i++) {
+		sqe =3D io_uring_get_sqe(&ring);
+		io_uring_prep_nop(sqe);
+		io_uring_sqe_set_data64(sqe, 2);
+		io_uring_submit(&ring);
+	}
+
+	do {
+		errno =3D 0;
+		ret =3D write(pipe1[1], "foo", 3);
+	} while (ret =3D=3D -1 && errno =3D=3D EINTR);
+
+	if (ret <=3D 0) {
+		fprintf(stderr, "write failed: %d\n", errno);
+		return 1;
+	}
+
+	/* should have 2 cqe + 1 overflow now, so take out two cqes */
+	for (i =3D 0; i < 2; i++) {
+		if (io_uring_peek_cqe(&ring, &cqe)) {
+			fprintf(stderr, "unexpectedly no cqe\n");
+			return 1;
+		}
+		if (cqe->user_data !=3D 2) {
+			fprintf(stderr, "unexpected user_data\n");
+			return 1;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	/* now remove the poll */
+	sqe =3D io_uring_get_sqe(&ring);
+	io_uring_prep_poll_remove(sqe, 1);
+	io_uring_sqe_set_data64(sqe, 3);
+	ret =3D io_uring_submit(&ring);
+
+	if (ret !=3D 1) {
+		fprintf(stderr, "bad poll remove\n");
+		return 1;
+	}
+
+	ret =3D check_final_cqe(&ring);
+
+	return ret;
+}
--=20
2.30.2

