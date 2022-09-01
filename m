Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB53F5A9335
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 11:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbiIAJdd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 05:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbiIAJdc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 05:33:32 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3329B1314E4
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 02:33:28 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2811L1WG002702
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 02:33:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=vdLgoPRmihW03RzES3m7kZr3l5AcEv78g4/43Qy3Cuw=;
 b=YC2VP04MSo2erVFHZEBp+8svQ6jhqps0D17kfpLvd/kSZbh+JSgtq4SDE2EueoTeSEZe
 nonKBf5+YFAAo71Hje9pbCyiNQFDHMTclg9U2JuqByO2RRJBMKYEMigQ2ogUEAjSD994
 4FjBiBWWiUS5VEFGRHc+BxFtoJ0pjZER4OM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jaab2wgja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 02:33:27 -0700
Received: from twshared11415.03.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 02:33:26 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id B8C9657693FA; Thu,  1 Sep 2022 02:33:06 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 06/12] add a defer-taskrun test
Date:   Thu, 1 Sep 2022 02:32:57 -0700
Message-ID: <20220901093303.1974274-7-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901093303.1974274-1-dylany@fb.com>
References: <20220901093303.1974274-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: uVClqUNw3hOCQI3_bCTmXPeUfEYJ4wrc
X-Proofpoint-ORIG-GUID: uVClqUNw3hOCQI3_bCTmXPeUfEYJ4wrc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_06,2022-08-31_03,2022-06-22_01
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
 test/defer-taskrun.c | 333 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 334 insertions(+)
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
index 000000000000..aec8c5d3f223
--- /dev/null
+++ b/test/defer-taskrun.c
@@ -0,0 +1,333 @@
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
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#include "liburing.h"
+#include "test.h"
+#include "helpers.h"
+
+#define EXEC_FILENAME ".defer-taskrun"
+#define EXEC_FILESIZE (1U<<20)
+
+static bool can_read_t(int fd, int time)
+{
+	int ret;
+	struct pollfd p =3D {
+		.fd =3D fd,
+		.events =3D POLLIN,
+	};
+
+	ret =3D poll(&p, 1, time);
+
+	return ret =3D=3D 1;
+}
+
+static bool can_read(int fd)
+{
+	return can_read_t(fd, 0);
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
+	ret =3D io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER |
+					    IORING_SETUP_DEFER_TASKRUN);
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
+	/* can take time due to rcu_call */
+	CHECK(can_read_t(fda, 1000));
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
+	ret =3D io_uring_queue_init(8, &td.ring, IORING_SETUP_SINGLE_ISSUER |
+					       IORING_SETUP_DEFER_TASKRUN);
+	if (ret)
+		return ret;
+
+	/* check that even before submitting we don't get errors */
+	CHECK(io_uring_get_events(&td.ring) =3D=3D 0);
+
+	td.efd =3D eventfd(0, 0);
+	CHECK(td.efd >=3D 0);
+
+	CHECK(pthread_create(&t1, NULL, thread, &td) =3D=3D 0);
+	CHECK(pthread_join(t1, NULL) =3D=3D 0);
+
+	CHECK(write(td.efd, &val, sizeof(val)) =3D=3D sizeof(val));
+	CHECK(io_uring_wait_cqe(&td.ring, &cqe) =3D=3D -EEXIST);
+
+	close(td.efd);
+	io_uring_queue_exit(&td.ring);
+	return 0;
+}
+
+static int test_exec(const char *filename)
+{
+	int ret;
+	int fd;
+	struct io_uring ring;
+	pid_t fork_pid;
+	static char * const new_argv[] =3D {"1", "2", "3", NULL};
+	static char * const new_env[] =3D {NULL};
+	char *buff;
+
+	fork_pid =3D fork();
+	CHECK(fork_pid >=3D 0);
+	if (fork_pid > 0) {
+		int wstatus;
+
+		CHECK(waitpid(fork_pid, &wstatus, 0) !=3D (pid_t)-1);
+		if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus) !=3D T_EXIT_SKIP) {
+			fprintf(stderr, "child failed %i\n", WEXITSTATUS(wstatus));
+			return -1;
+		}
+		return 0;
+	}
+
+	ret =3D io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER |
+					    IORING_SETUP_DEFER_TASKRUN);
+	if (ret)
+		return ret;
+
+	if (filename) {
+		fd =3D open(filename, O_RDONLY | O_DIRECT);
+	} else {
+		t_create_file(EXEC_FILENAME, EXEC_FILESIZE);
+		fd =3D open(EXEC_FILENAME, O_RDONLY | O_DIRECT);
+		unlink(EXEC_FILENAME);
+	}
+	buff =3D (char*)malloc(EXEC_FILESIZE);
+	CHECK(posix_memalign((void **)&buff, 4096, EXEC_FILESIZE) =3D=3D 0);
+	CHECK(buff);
+
+	CHECK(fd >=3D 0);
+	io_uring_prep_read(io_uring_get_sqe(&ring), fd, buff, EXEC_FILESIZE, 0)=
;
+	io_uring_submit(&ring);
+	ret =3D execve("/proc/self/exe", new_argv, new_env);
+	/* if we get here it failed anyway */
+	fprintf(stderr, "execve failed %d\n", ret);
+	return -1;
+}
+
+static int test_flag(void)
+{
+	struct io_uring ring;
+	int ret;
+	int fd;
+	struct io_uring_cqe *cqe;
+
+	ret =3D io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER |
+					    IORING_SETUP_DEFER_TASKRUN |
+					    IORING_SETUP_TASKRUN_FLAG);
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
+static int test_ring_shutdown(void)
+{
+	struct io_uring ring;
+	int ret;
+	int fd[2];
+	char buff =3D '\0';
+	char send =3D 'X';
+
+	ret =3D io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER |
+					    IORING_SETUP_DEFER_TASKRUN |
+					    IORING_SETUP_TASKRUN_FLAG);
+	CHECK(!ret);
+
+	ret =3D t_create_socket_pair(fd, true);
+	CHECK(!ret);
+
+	io_uring_prep_recv(io_uring_get_sqe(&ring), fd[0], &buff, 1, 0);
+	io_uring_submit(&ring);
+
+	ret =3D write(fd[1], &send, 1);
+	CHECK(ret =3D=3D 1);
+
+	/* should not have processed the poll cqe yet */
+	CHECK(io_uring_cq_ready(&ring) =3D=3D 0);
+	io_uring_queue_exit(&ring);
+
+	/* task work should have been processed by now */
+	CHECK(buff =3D 'X');
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+	const char *filename =3D NULL;
+
+	if (argc > 2)
+		return T_EXIT_SKIP;
+	if (argc =3D=3D 2) {
+		/* This test exposes interesting behaviour with a null-blk
+		 * device configured like:
+		 * $ modprobe null-blk completion_nsec=3D100000000 irqmode=3D2
+		 * and then run with $ defer-taskrun.t /dev/nullb0
+		 */
+		filename =3D argv[1];
+	}
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
+	ret =3D test_exec(filename);
+	if (ret) {
+		fprintf(stderr, "test_exec failed\n");
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
+	ret =3D test_ring_shutdown();
+	if (ret) {
+		fprintf(stderr, "test_ring_shutdown failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	return T_EXIT_PASS;
+}
--=20
2.30.2

