Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362D7592FBC
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 15:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbiHONVX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 09:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242833AbiHONVV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 09:21:21 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F9C192A5
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:21:18 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 27ELYE2E021536
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:21:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9ZBe1sl2xIUUpsYiluOlgQ7i+M3NeurHhv9G4Ib7Qxs=;
 b=Xpi5a5v2lbQhZl3zEdezg4vS9PQZcoLw99aJmHOcaY4i9M6CkrrK/gvX38zIU0S9mE6i
 LoaEghozGkHVXcBnOa0gpQ+Efsy+kaH8TDgG3Ra8pNak82gCV1PJpeKMFc5Kc0chfpn7
 K1bbMF+TRp8EDjj8FuJGPi9eBwhJsJYif48= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3hx7mx2m0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:21:18 -0700
Received: from twshared14074.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 15 Aug 2022 06:21:17 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 2882C49B72ED; Mon, 15 Aug 2022 06:09:55 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 05/11] add a defer-taskrun test
Date:   Mon, 15 Aug 2022 06:09:41 -0700
Message-ID: <20220815130947.1002152-6-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815130947.1002152-1-dylany@fb.com>
References: <20220815130947.1002152-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: fPSO8ZV_kDFswRtUFdHzgdOw05KOOnB8
X-Proofpoint-GUID: fPSO8ZV_kDFswRtUFdHzgdOw05KOOnB8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a test specifically for IORING_SETUP_DEFER_TASKRUN

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/Makefile        |   1 +
 test/defer-taskrun.c | 217 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 218 insertions(+)
 create mode 100644 test/defer-taskrun.c

diff --git a/test/Makefile b/test/Makefile
index 418c11c95875..78a499a357d7 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -62,6 +62,7 @@ test_srcs :=3D \
 	d4ae271dfaae.c \
 	d77a67ed5f27.c \
 	defer.c \
+	defer-taskrun.c \
 	double-poll-crash.c \
 	drop-submit.c \
 	eeed8b54e0df.c \
diff --git a/test/defer-taskrun.c b/test/defer-taskrun.c
new file mode 100644
index 000000000000..5ba044a0955d
--- /dev/null
+++ b/test/defer-taskrun.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: MIT
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <error.h>
+#include <sys/eventfd.h>
+#include <signal.h>
+#include <poll.h>
+#include <assert.h>
+#include <pthread.h>
+
+#include "liburing.h"
+#include "test.h"
+#include "helpers.h"
+
+static bool can_read(int fd)
+{
+	int ret;
+	struct pollfd p =3D {
+		.fd =3D fd,
+		.events =3D POLLIN,
+	};
+
+	ret =3D poll(&p, 1, 0);
+
+	return ret =3D=3D 1;
+}
+
+static void eventfd_clear(int fd)
+{
+	uint64_t val;
+	int ret;
+
+	assert(can_read(fd));
+	ret =3D read(fd, &val, 8);
+	assert(ret =3D=3D 8);
+}
+
+static void eventfd_trigger(int fd)
+{
+	uint64_t val =3D 1;
+	int ret;
+
+	ret =3D write(fd, &val, sizeof(val));
+	assert(ret =3D=3D sizeof(val));
+}
+
+#define CHECK(x) if (!(x)) { \
+		fprintf(stderr, "%s:%d %s failed\n", __FILE__, __LINE__, #x); \
+		return -1; }
+
+static int test_eventfd(void)
+{
+	struct io_uring ring;
+	int ret;
+	int fda, fdb;
+	struct io_uring_cqe *cqe;
+
+	ret =3D io_uring_queue_init(8, &ring, IORING_SETUP_DEFER_TASKRUN);
+	if (ret)
+		return ret;
+
+	fda =3D eventfd(0, EFD_NONBLOCK);
+	fdb =3D eventfd(0, EFD_NONBLOCK);
+
+	CHECK(fda >=3D 0 && fdb >=3D 0);
+
+	ret =3D io_uring_register_eventfd(&ring, fda);
+	if (ret)
+		return ret;
+
+	CHECK(!can_read(fda));
+	CHECK(!can_read(fdb));
+
+	io_uring_prep_poll_add(io_uring_get_sqe(&ring), fdb, POLLIN);
+	io_uring_submit(&ring);
+	CHECK(!can_read(fda)); /* poll should not have completed */
+
+	io_uring_prep_nop(io_uring_get_sqe(&ring));
+	io_uring_submit(&ring);
+	CHECK(can_read(fda)); /* nop should have */
+
+	CHECK(io_uring_peek_cqe(&ring, &cqe) =3D=3D 0);
+	CHECK(cqe->res =3D=3D 0);
+	io_uring_cqe_seen(&ring, cqe);
+	eventfd_clear(fda);
+
+	eventfd_trigger(fdb);
+	CHECK(can_read(fda));
+
+	/* should not have processed the cqe yet */
+	CHECK(io_uring_cq_ready(&ring) =3D=3D 0);
+
+	io_uring_get_events(&ring);
+	CHECK(io_uring_cq_ready(&ring) =3D=3D 1);
+
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+struct thread_data {
+	struct io_uring ring;
+	int efd;
+	char buff[8];
+};
+
+void *thread(void *t)
+{
+	struct thread_data *td =3D t;
+
+	io_uring_prep_read(io_uring_get_sqe(&td->ring), td->efd, td->buff, size=
of(td->buff), 0);
+	io_uring_submit(&td->ring);
+
+	return NULL;
+}
+
+static int test_thread_shutdown(void)
+{
+	pthread_t t1;
+	int ret;
+	struct thread_data td;
+	struct io_uring_cqe *cqe;
+	uint64_t val =3D 1;
+
+	ret =3D io_uring_queue_init(8, &td.ring, IORING_SETUP_DEFER_TASKRUN);
+	if (ret)
+		return ret;
+
+	td.efd =3D eventfd(0, 0);
+	CHECK(td.efd >=3D 0);
+
+	CHECK(pthread_create(&t1, NULL, thread, &td) =3D=3D 0);
+	CHECK(pthread_join(t1, NULL) =3D=3D 0);
+
+	CHECK(write(td.efd, &val, sizeof(val)) =3D=3D sizeof(val));
+	CHECK(!io_uring_wait_cqe(&td.ring, &cqe));
+	CHECK(cqe->res =3D=3D -ECANCELED);
+	io_uring_cqe_seen(&td.ring, cqe);
+
+	close(td.efd);
+	io_uring_queue_exit(&td.ring);
+	return 0;
+}
+
+static int test_flag(void)
+{
+	struct io_uring ring;
+	int ret;
+	int fd;
+	struct io_uring_cqe *cqe;
+
+	ret =3D io_uring_queue_init(8, &ring,
+				  IORING_SETUP_DEFER_TASKRUN | IORING_SETUP_TASKRUN_FLAG);
+	CHECK(!ret);
+
+	fd =3D eventfd(0, EFD_NONBLOCK);
+	CHECK(fd >=3D 0);
+
+	io_uring_prep_poll_add(io_uring_get_sqe(&ring), fd, POLLIN);
+	io_uring_submit(&ring);
+	CHECK(!can_read(fd)); /* poll should not have completed */
+
+	eventfd_trigger(fd);
+	CHECK(can_read(fd));
+
+	/* should not have processed the poll cqe yet */
+	CHECK(io_uring_cq_ready(&ring) =3D=3D 0);
+
+	/* flag should be set */
+	CHECK(IO_URING_READ_ONCE(*ring.sq.kflags) & IORING_SQ_TASKRUN);
+
+	/* Specifically peek, knowing we have only no cqe
+	 * but because the flag is set, liburing should try and get more
+	 */
+	ret =3D io_uring_peek_cqe(&ring, &cqe);
+
+	CHECK(ret =3D=3D 0 && cqe);
+	CHECK(!(IO_URING_READ_ONCE(*ring.sq.kflags) & IORING_SQ_TASKRUN));
+
+	close(fd);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	if (!t_probe_defer_taskrun())
+		return T_EXIT_SKIP;
+
+	ret =3D test_thread_shutdown();
+	if (ret) {
+		fprintf(stderr, "test_thread_shutdown failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret =3D test_eventfd();
+	if (ret) {
+		fprintf(stderr, "eventfd failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret =3D test_flag();
+	if (ret) {
+		fprintf(stderr, "flag failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	return T_EXIT_PASS;
+}
--=20
2.30.2

