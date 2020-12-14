Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B938B2DA263
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 22:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503659AbgLNVKX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 16:10:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55556 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503702AbgLNVKI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 16:10:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEKuGLQ019265;
        Mon, 14 Dec 2020 21:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=KbsoF7oXADG4YGErETblCBUnQIpp18wfnqtybXeOWYA=;
 b=noYV0/lCETZzEK6PD45EG+4eYYydOuspDz/mW1oZPDqvVkJNFm2SkyRaCnOpeZgcYDrD
 OOIlTjvusnTqcHvMw+PM4sa/UXiDiTBGm9PgW6C4hEXr5k5m/VMOmRAdYEqA0ZbyB4n6
 6WydP845ynQAOTwumeZqAgGteel86rXFcNn9X+Lq/i41Uhm27nUjJ6f+SXoTxLFcRcrv
 FGGRWogZEA3iQJ++JoirXJTaazI6d7lHoszCTlrd6Gl4LMPGSxBZDgyjcMWS/rQzjHiB
 dvtk8bcrT5yaPekkMkIFtDj0A7xo/tl+AFvB6JkwNipUrMXgDy1OBw89XMi0/esnPz9Z 4g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35cntkyexj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 21:09:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEKt82O132714;
        Mon, 14 Dec 2020 21:09:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35d7em0k0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 21:09:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BEL9LoW019906;
        Mon, 14 Dec 2020 21:09:21 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 13:09:21 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH 5/5] test/buffer-share: add buffer registration sharing test
Date:   Mon, 14 Dec 2020 13:09:11 -0800
Message-Id: <1607980151-18816-6-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607980151-18816-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1607980151-18816-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140140
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 .gitignore          |    1 +
 test/Makefile       |    3 +
 test/buffer-share.c | 1184 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1188 insertions(+)
 create mode 100644 test/buffer-share.c

diff --git a/.gitignore b/.gitignore
index b44560e..4e09f1f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -31,6 +31,7 @@
 /test/b19062a56726-test
 /test/b5837bd5311d-test
 /test/buffer-register
+/test/buffer-share
 /test/buffer-update
 /test/ce593a6c480a-test
 /test/close-opath
diff --git a/test/Makefile b/test/Makefile
index 5cd467c..88381da 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -30,6 +30,7 @@ test_targets += \
 	b19062a56726-test \
 	b5837bd5311d-test \
 	buffer-register \
+	buffer-share \
 	buffer-update \
 	ce593a6c480a-test \
 	close-opath \
@@ -154,6 +155,7 @@ test_srcs := \
 	b19062a56726-test.c \
 	b5837bd5311d-test.c \
 	buffer-register.c \
+	buffer-share.c \
 	buffer-update.c \
 	ce593a6c480a-test.c \
 	close-opath.c \
@@ -252,6 +254,7 @@ ce593a6c480a-test: XCFLAGS = -lpthread
 wakeup-hang: XCFLAGS = -lpthread
 pipe-eof: XCFLAGS = -lpthread
 timeout-new: XCFLAGS = -lpthread
+buffer-share: XCFLAGS = -lrt
 
 install: $(test_targets) runtests.sh runtests-loop.sh
 	$(INSTALL) -D -d -m 755 $(datadir)/liburing-test/
diff --git a/test/buffer-share.c b/test/buffer-share.c
new file mode 100644
index 0000000..81e0537
--- /dev/null
+++ b/test/buffer-share.c
@@ -0,0 +1,1184 @@
+/* SPDX-License-Identifier: MIT */
+#include <stdio.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <stdarg.h>
+#include <signal.h>
+#include <inttypes.h>
+#include <sys/mman.h>
+#include <sys/ipc.h>
+#include <sys/shm.h>
+#include <linux/mman.h>
+#include <sys/types.h>
+#include <sys/syscall.h>
+#include <sys/socket.h>
+#include <sys/ptrace.h>
+#include <sys/wait.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <string.h>
+#include <linux/fs.h>
+
+#include "liburing.h"
+
+/*
+ * The main (granparent) process creates a shared memory status segment for 
+ * all tests and then creates a parent process which drives test execution.
+ * The grandparent then waits to reap the status of granchildren test
+ * processes, for the final test case which involves running IO tests after
+ * the parent exits.
+ * 
+ * The parent process creates a shared memory data segment where all IO
+ * buffers reside. The parent then runs all test cases.  For each test
+ * the parent creates the specified number of test processes, and waits
+ * for the children to execute the actual tests.  The parent controls
+ * children's execution with ptrace().
+ *
+ * The tests are organized as follows:
+ *
+ * test           ring        registration   test       expected
+ * category       sharing     type           case       result
+ * --------       -------     ---            ----       ------
+ * registration   none        none           various    pass
+ * IO             fd based    register/pin              failure errno
+ *                            attach
+ *
+ * The IO test has been adapted largely unchanged from test/read-write.c.
+ */
+
+#define MAXID		128	/* max number of tester processes */
+int pids[MAXID];
+int status[MAXID];
+int nids = 1;
+
+#define SHM_ST_SZ	(MAXID * 4)
+#define SHM_ST_NONE	-1
+
+#define FILE_SIZE	(128 * 1024)
+#define BS		4096
+#define BUFFERS		(FILE_SIZE / BS)
+
+#define	SZ_2M		0x200000
+
+#define SQ_THREAD_IDLE  2000
+
+char *shmbuf;
+char *shmstat;
+
+struct iovec vecs[UIO_MAXIOV];
+unsigned long buf_cnt = BUFFERS;
+unsigned long shm_sz = SZ_2M;
+
+int no_read;
+int warned;
+int verbose = 0;
+
+enum {
+	REG_NOP = 0,
+	REG_PIN,
+	REG_ATT,
+};
+
+char *r2s[] = {
+	"nop",
+	"pin",
+	"att",
+};
+
+enum {
+	TEST_DFLT = 0,
+	TEST_INVFD,
+	TEST_BADFD,
+	TEST_UNREG,
+	TEST_BUSY,
+	TEST_EXIT,
+	TEST_FIN,
+};
+
+char *t2s[] = {
+	"dflt",
+	"invfd",
+	"badfd",
+	"unreg",
+	"busy",
+	"exit",
+	"fin",
+};
+
+enum {
+	TEST_REG = 0,
+	TEST_IO,
+};
+
+char *i2s[] = {
+	"reg",
+	"io",
+};
+
+enum {
+	NO,
+	FD,
+};
+
+char *s2s[] = {
+	"nos",
+	"fd",
+};
+
+enum {
+	PASS,
+	FAIL,
+	NONE,
+};
+
+enum {
+	V0 = 0,
+	V1,
+	V2,
+	V3,
+	V4,
+};
+
+struct test_desc {
+	int id;
+	int idx;
+	int fd;
+	int sp[2];
+	int share;
+	int reg;
+	int preg;
+	int test;
+	int expect;
+};
+struct test_desc tdcs[MAXID];
+
+static int test_reg(struct test_desc *);
+static int test_io(struct test_desc *);
+
+int (*test_fn[])(struct test_desc *) = {
+	test_reg,
+	test_io,
+};
+
+static void
+vinfo(int level, char *fmt, ...)
+{
+	va_list args;
+
+	if (verbose < level)
+		return;
+
+	fprintf(stderr, "%-5d ", getpid());
+	va_start(args, fmt);
+	vfprintf(stderr, fmt, args);
+	va_end(args);
+	fflush(stderr);
+}
+
+static void
+verror(char *msg)
+{
+        if (!verbose)
+                return;
+
+        fprintf(stderr, "%-5d %s: %s\n", getpid(), msg, strerror(errno));
+        fflush(stderr);
+}
+
+static void
+send_fd(int socket, int fd)
+{
+	char buf[CMSG_SPACE(sizeof(fd))];
+	struct cmsghdr *cmsg;
+	struct msghdr msg;
+
+	memset(buf, 0, sizeof(buf));
+	memset(&msg, 0, sizeof(msg));
+
+	msg.msg_control = buf;
+	msg.msg_controllen = sizeof(buf);
+
+	cmsg = CMSG_FIRSTHDR(&msg);
+	cmsg->cmsg_level = SOL_SOCKET;
+	cmsg->cmsg_type = SCM_RIGHTS;
+	cmsg->cmsg_len = CMSG_LEN(sizeof(fd));
+
+	memmove(CMSG_DATA(cmsg), &fd, sizeof(fd));
+
+	msg.msg_controllen = CMSG_SPACE(sizeof(fd));
+
+	if (sendmsg(socket, &msg, 0) < 0) {
+		verror("sendmsg");
+		exit(1);
+	}
+}
+
+static int
+recv_fd(int socket)
+{
+	int *fdp, fd = -1, ret;
+	char buf[CMSG_SPACE(sizeof(fd))];
+	struct cmsghdr *cmsg;
+	struct msghdr msg;
+
+	memset(buf, 0, sizeof(buf));
+	memset(&msg, 0, sizeof(msg));
+
+	msg.msg_control = buf;
+	msg.msg_controllen = sizeof(buf);
+
+	ret = recvmsg(socket, &msg, 0);
+	if (ret < 0) {
+		verror("recvmsg");
+		exit(1);
+	}
+
+	for (cmsg = CMSG_FIRSTHDR(&msg); cmsg != NULL;
+	     cmsg = CMSG_NXTHDR(&msg,cmsg)) {
+		if (cmsg->cmsg_level == SOL_SOCKET &&
+		    cmsg->cmsg_type == SCM_RIGHTS) {
+        		fdp = (int *)CMSG_DATA(cmsg);
+        		fd = *fdp;
+    		}
+	}
+
+	return fd;
+}
+
+static int
+shm_create(void)
+{
+	int id;
+
+	id = shmget(2, shm_sz, SHM_HUGETLB | IPC_CREAT | SHM_R | SHM_W);
+	if (id < 0) {
+		fprintf(stderr, "Unable to map a huge page. "
+			"Increase /proc/sys/vm/nr_hugepages by at least 1.\n");
+		verror("shmget");
+		exit(1);
+	}
+	vinfo(V3, "shm_create shmid: 0x%x\n", id);
+
+	return id;
+}
+
+static char *
+shm_attach(int id)
+{
+	char *addr;
+
+	addr = shmat(id, 0, 0);
+	if (addr == MAP_FAILED) {
+		verror("shmat");
+		shmctl(id, IPC_RMID, NULL);
+	}
+	vinfo(V3, "shm_attach shmid: 0x%x shmbuf: %p\n", id, addr);
+
+	return addr;
+}
+
+static void
+shm_destroy(int id, char *addr)
+{
+	int ret;
+
+	vinfo(V3, "shm_destroy shmid: 0x%x\n", id);
+
+	ret = shmdt((const void *)addr);
+	if (ret)
+		verror("shmdt");
+
+	shmctl(id, IPC_RMID, NULL);
+
+	if (ret)
+		exit(1);
+}
+
+static void *
+shmstat_create(void)
+{
+	int res;
+	int fd;
+	char fname[32];
+	void *addr = NULL;
+
+	snprintf(fname, sizeof(fname), "shmstat.%d", getpid());
+
+	/* get shared memory file descriptor (NOT a file) */
+	fd = shm_open(fname, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
+	if (fd == -1) {
+		verror("open");
+		goto done;
+	}
+
+	/* extend shared memory object as by default it's set to size 0 */
+	res = ftruncate(fd, SHM_ST_SZ);
+	if (res == -1) {
+		verror("ftruncate");
+		goto done;
+	}
+
+	/* map shared memory to process address space */
+	addr = mmap(NULL, SHM_ST_SZ, PROT_WRITE, MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		verror("mmap");
+		goto done;
+	}
+	memset(addr, 0, SHM_ST_SZ);
+done:
+	return addr;
+}
+
+static void
+shmstat_store(struct test_desc *tdc, int data)
+{
+	vinfo(V4, "stat_store %i %d\n", tdc->idx, data);
+	shmstat[tdc->idx] = data;
+}
+
+static int
+shmstat_check(int expect)
+{
+	int i;
+
+	for (i = 0; i < nids; i++) {
+		if (shmstat[i] != expect) {
+			vinfo(V3, "check_shmstat child %d: expect %d got %d\n",
+			      pids[i], expect, shmstat[i]);
+			return shmstat[i];
+		}
+	}
+
+	return 0;
+}
+
+static int
+queue_init(struct test_desc *tdc, int qd, struct io_uring *ring,
+	   struct io_uring_params *p, int reg)
+{
+	int ret;
+
+	if (tdc->share == FD) {
+		if (reg == REG_ATT) {
+			p->flags |= IORING_SETUP_ATTACH_BUF;
+			if (tdc->test == TEST_BADFD)
+				p->wq_fd = -1;
+			else if (tdc->test == TEST_INVFD)
+				p->wq_fd = 0;
+			else
+				p->wq_fd = tdc->fd;
+		} else
+			p->flags |= IORING_SETUP_SHARE_BUF;
+	}
+
+	ret = io_uring_queue_init_params(qd, ring, p);
+	if (ret)
+		verror("queue_init");
+	vinfo(V2, "queue_init %d\n", ring->ring_fd);
+
+	return ret;
+}
+
+static void
+queue_exit(struct io_uring *ring)
+{
+	vinfo(V2, "queue_exit %d\n", ring->ring_fd);
+	io_uring_queue_exit(ring);
+}
+
+static void
+create_buffers(char *adr)
+{
+	int i;
+
+	if (buf_cnt > UIO_MAXIOV) {
+		fprintf(stderr, "invalid buffer count: %ld\n", buf_cnt);
+		exit(1);
+	}
+
+	for (i = 0; i < buf_cnt; i++) {
+		vecs[i].iov_base = adr;
+		vecs[i].iov_len = BS;
+		adr += BS;
+	}
+}
+
+static int
+register_buffers(struct test_desc *tdc, struct io_uring *ring)
+{
+	if (tdc->reg == REG_ATT)
+		return io_uring_register_buffers(ring, 0, 0);
+
+	return io_uring_register_buffers(ring, vecs, buf_cnt);
+}
+
+static void
+stop(void)
+{
+	vinfo(V2, "raise SIGSTOP\n");
+	raise(SIGSTOP);
+	vinfo(V2, "resume SIGSTOP\n");
+}
+
+static int
+test_reg(struct test_desc *tdc)
+{
+	int ret;
+	struct io_uring_params p = {0};
+	struct io_uring ring;
+
+	ret = queue_init(tdc, 1, &ring, &p, tdc->reg);
+	if (ret)
+		return ret;
+
+	ret = register_buffers(tdc, &ring);
+	if (ret)
+		verror("register test_reg");
+
+	if (tdc->test == TEST_BUSY) {
+		vinfo(V2, "delay\n");
+		sleep(5);
+	} else if (tdc->test == TEST_EXIT) {
+		stop();
+	}
+
+	queue_exit(&ring);
+
+	return ret;
+}
+
+static int
+create_file(const char *file)
+{
+	ssize_t ret;
+	char *buf;
+	int fd;
+
+	buf = malloc(FILE_SIZE);
+	memset(buf, 0xaa, FILE_SIZE);
+
+	fd = open(file, O_WRONLY | O_CREAT, 0644);
+	if (fd < 0) {
+		verror("open");
+		return 1;
+	}
+	ret = write(fd, buf, FILE_SIZE);
+	close(fd);
+	return ret != FILE_SIZE;
+}
+
+static int
+do_io(struct test_desc *tdc, const char *file,
+      struct io_uring *ring, int write, int buffered,
+      int sqthread, int fixed, int nonvec, int seq, int exp_len)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int open_flags;
+	int i, fd, ret = 0;
+	off_t offset;
+
+	vinfo(V1, "%s: %d/%d/%d/%d/%d\n",
+	     __FUNCTION__, write, buffered, sqthread, fixed, nonvec);
+
+	if (sqthread && geteuid()) {
+		vinfo(V1, "SKIPPED (not root)\n");
+		return 0;
+	}
+
+	if (write)
+		open_flags = O_WRONLY;
+	else
+		open_flags = O_RDONLY;
+	if (!buffered)
+		open_flags |= O_DIRECT;
+
+	fd = open(file, open_flags);
+	if (fd < 0) {
+		verror("open");
+		goto err;
+	}
+
+	if (fixed) {
+		ret = register_buffers(tdc, ring);
+		if (ret) {
+			vinfo(V1, "buffer reg failed: %d\n", ret);
+			goto err;
+		}
+	}
+	if (fixed || sqthread) {
+		ret = io_uring_register_files(ring, &fd, 1);
+		if (ret) {
+			vinfo(V1, "file reg failed: %d\n", ret);
+			goto err;
+		}
+	}
+
+	offset = 0;
+	for (i = 0; i < BUFFERS; i++) {
+		sqe = io_uring_get_sqe(ring);
+		if (!sqe) {
+			vinfo(V1, "sqe get failed\n");
+			goto err;
+		}
+		if (!seq)
+			offset = BS * (rand() % BUFFERS);
+		if (write) {
+			int use_fd = fd;
+
+			if (fixed || sqthread)
+				use_fd = 0;
+
+			if (fixed) {
+				io_uring_prep_write_fixed(sqe, use_fd,
+							  vecs[i].iov_base,
+							  vecs[i].iov_len,
+							  offset, i);
+			} else if (nonvec) {
+				io_uring_prep_write(sqe, use_fd,
+						    vecs[i].iov_base,
+						    vecs[i].iov_len, offset);
+			} else {
+				io_uring_prep_writev(sqe, use_fd, &vecs[i], 1,
+						     offset);
+			}
+		} else {
+			int use_fd = fd;
+
+			if (fixed || sqthread)
+				use_fd = 0;
+
+			if (fixed) {
+				io_uring_prep_read_fixed(sqe, use_fd,
+							 vecs[i].iov_base,
+							 vecs[i].iov_len,
+							 offset, i);
+			} else if (nonvec) {
+				io_uring_prep_read(sqe, use_fd,
+						   vecs[i].iov_base,
+						   vecs[i].iov_len, offset);
+			} else {
+				io_uring_prep_readv(sqe, use_fd, &vecs[i], 1,
+						    offset);
+			}
+
+		}
+		if (fixed || sqthread)
+			sqe->flags |= IOSQE_FIXED_FILE;
+		if (seq)
+			offset += BS;
+	}
+
+	ret = io_uring_submit(ring);
+	if (ret != BUFFERS) {
+		vinfo(V1, "submit got %d, wanted %d\n", ret, BUFFERS);
+		goto err;
+	}
+
+	for (i = 0; i < BUFFERS; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret) {
+			vinfo(V1, "wait_cqe %d\n", ret);
+			goto err;
+		}
+		if (cqe->res == -EINVAL && nonvec) {
+			if (!warned) {
+				vinfo(V1, "Non-vectored IO not "
+				      "supported, skipping\n");
+				warned = 1;
+				no_read = 1;
+			}
+		} else if (cqe->res != exp_len) {
+			vinfo(V1, "cqe res %d, wanted %d\n", cqe->res, exp_len);
+			ret = cqe->res;
+			goto err;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	if (fixed) {
+		ret = io_uring_unregister_buffers(ring);
+		if (ret) {
+			vinfo(V1, "buffer unreg failed: %d\n", ret);
+			goto err;
+		}
+	}
+	if (fixed || sqthread) {
+		ret = io_uring_unregister_files(ring);
+		if (ret) {
+			vinfo(V1, "file unreg failed: %d\n", ret);
+			goto err;
+		}
+	}
+
+	close(fd);
+	vinfo(V1, "%s: %d/%d/%d/%d/%d: PASS\n",
+	     __FUNCTION__, write, buffered, sqthread, fixed, nonvec);
+	return 0;
+err:
+	(void)io_uring_unregister_buffers(ring);
+	if (fd != -1)
+		close(fd);
+	return ret;
+}
+
+static int
+run_test_io(struct test_desc *tdc, const char *file,
+	      int write, int buffered, int sqthread, int fixed, int nonvec)
+{
+	struct io_uring_params p = {0};
+	struct io_uring ring;
+	int share, ret;
+
+	share = tdc->share;
+
+	if (!fixed)
+		tdc->share = NO;
+
+	if (sqthread) {
+		if (geteuid()) {
+			if (!warned) {
+				fprintf(stderr,
+					"SQPOLL requires root, skipping\n");
+				warned = 1;
+			}
+			return 0;
+		}
+		p.flags = IORING_SETUP_SQPOLL;
+		p.sq_thread_idle = nids * SQ_THREAD_IDLE;
+	}
+	ret = queue_init(tdc, 64, &ring, &p, tdc->reg);
+
+	if (ret)
+		goto done;
+
+	ret = do_io(tdc, file, &ring, write, buffered, sqthread, fixed,
+		    nonvec, 0, BS);
+
+	queue_exit(&ring);
+done:
+	tdc->share = share;
+	return ret;
+}
+
+
+static int
+has_nonvec_read(void)
+{
+	struct io_uring_probe *p;
+	struct io_uring ring;
+	int ret;
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	vinfo(V1, "io_uring_queue_init %d\n", ring.ring_fd);
+	if (ret) {
+		verror("io_uring_queue_init");
+		exit(ret);
+	}
+
+	p = calloc(1, sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
+	ret = io_uring_register_probe(&ring, p, 256);
+	/* if we don't have PROBE_REGISTER, we don't have OP_READ/WRITE */
+	if (ret == -EINVAL) {
+out:
+		queue_exit(&ring);
+		return 0;
+	} else if (ret) {
+		fprintf(stderr, "register_probe: %d\n", ret);
+		goto out;
+	}
+
+	if (p->ops_len <= IORING_OP_READ)
+		goto out;
+	if (!(p->ops[IORING_OP_READ].flags & IO_URING_OP_SUPPORTED))
+		goto out;
+	queue_exit(&ring);
+	return 1;
+}
+
+static int
+test_io(struct test_desc *tdc)
+{
+	int i, ret, nr;
+	char fname[32];
+
+	snprintf(fname, sizeof(fname), ".basic-rw.%d", getpid());
+	if (create_file(fname)) {
+		fprintf(stderr, "file creation failed\n");
+		ret = 1;
+		goto err;
+	}
+
+	if (tdc->test == TEST_EXIT)
+		stop();
+
+	/* if we don't have nonvec read, skip testing that */
+	if (has_nonvec_read())
+		nr = 64;
+	else
+		nr = 32;
+
+	for (i = 0; i < nr; i++) {
+		int v1, v2, v3, v4, v5;
+
+		v1 = (i & 1) != 0;
+		v2 = (i & 2) != 0;
+		v3 = (i & 4) != 0;
+		v4 = (i & 8) != 0;
+		v5 = (i & 16) != 0;
+		ret = run_test_io(tdc, fname, v1, v2, v3, v4, v5);
+		if (ret) {
+			vinfo(V1, "test_io failed %d/%d/%d/%d/%d\n",
+			      v1, v2, v3, v4, v5);
+			goto err;
+		}
+	}
+err:
+	unlink(fname);
+	return ret;
+}
+
+static int
+get_socketpair(int sp[])
+{
+	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sp) != 0) {
+		verror("socketpair\n");
+		return errno;
+	}
+	return 0;
+}
+
+static void
+waitstoppid(int pid)
+{
+	int ret;
+	int status;
+
+	while (1) {
+		vinfo(V2, "waitstop %d\n", pid);
+
+		ret = waitpid(pid, &status, WNOHANG | WUNTRACED | WCONTINUED);
+		if (ret != pid) {
+			sleep(1);
+			continue;
+		}
+		if (WIFSTOPPED(status))
+			return;
+
+		break;
+	}
+
+	vinfo(V2, "pid %d was not stopped!\n", pid);
+	exit(1);
+}
+
+static void
+waitstop(void)
+{
+	int i;
+
+	for (i = 0; i < nids; i++)
+		waitstoppid(pids[i]);
+}
+		
+static void
+waitexitpid(int pid, int *status)
+{
+	int ret, xs;
+
+	while (1) {
+		vinfo(V2, "waitexit %d\n", pid);
+
+		ret = waitpid(pid, status, WNOHANG | WUNTRACED | WCONTINUED);
+		if (ret != pid) {
+			sleep(1);
+			continue;
+		}
+		xs = *status;
+		if (WIFEXITED(xs)) {
+			vinfo(2, "child %d exited: %d\n", pid, WEXITSTATUS(xs));
+			*status =  WEXITSTATUS(xs);
+			return;
+		}
+
+		vinfo(V2, "waitexit 0x%x e:%d s:%d d:%d t:%d c:%d\n", xs,
+		      WIFEXITED(xs), WIFSIGNALED(xs), WCOREDUMP(xs),
+		      WIFSTOPPED(xs), WIFCONTINUED(xs));
+		break;
+	}
+
+	vinfo(V2, "pid %d didn't exit!\n", pid);
+	exit(1);
+}
+
+static void
+waitexit(void)
+{
+	int i;
+
+	for (i = 0; i < nids; i++) {
+		status[i] = 0;
+		waitexitpid(pids[i], &status[i]);
+	}
+}
+
+static void
+contpid(int pid)
+{
+	int ret;
+
+	vinfo(V2, "cont %d\n", pid);
+
+	ret = ptrace(PTRACE_CONT, pid, NULL, NULL);
+	if (ret < 0) {
+		verror("ptrace");
+		exit(1);
+	}
+}
+
+static void
+cont(void)
+{
+	int i;
+
+	for (i = 0; i < nids; i++)
+		contpid(pids[i]);
+}
+
+static void
+send_ring_fd(int fd)
+{
+	int i;
+	struct test_desc *tdc;
+
+	for (i = 0; i < nids; i++) {
+		tdc = &tdcs[i];
+		vinfo(V3, "send_fd %d %d: %d\n", pids[i], tdc->sp[0], fd);
+		send_fd(tdc->sp[0], fd);
+	}
+}
+
+static void
+close_sockets(void)
+{
+	int i;
+
+	for (i = 0; i < nids; i++) {
+		shutdown(tdcs[i].sp[0], SHUT_RDWR);
+		shutdown(tdcs[i].sp[1], SHUT_RDWR);
+	}
+}
+
+static int
+run_parent(struct test_desc *tdc)
+{
+	int ret;
+	struct io_uring_params p = {0};
+	struct io_uring ring;
+
+	waitstop();
+
+	ret = queue_init(tdc, 1, &ring, &p, tdc->preg);
+	if (ret)
+		return ret;
+
+	if (tdc->preg == REG_NOP)
+		goto send;
+
+	ret = io_uring_register_buffers(&ring, vecs, buf_cnt);
+	if (ret) {
+		verror("register run_parent");
+		goto done;
+	}
+
+	if (tdc->test == TEST_UNREG) {
+		ret = io_uring_unregister_buffers(&ring);
+		if (ret) {
+			verror("unregister run_parent");
+			goto done;
+		}
+	}
+send:
+	if (tdc->share == FD)
+		send_ring_fd(ring.ring_fd);
+
+	cont();
+
+	if (tdc->test == TEST_BUSY) {
+		ret = io_uring_unregister_buffers(&ring);
+		if (ret)
+			verror("unregister run_parent busy");
+		if (-ret == tdc->expect)
+			ret = -ret;
+	} else if (tdc->test == TEST_EXIT) {
+		waitstop();
+		vinfo(2, "parent exiting\n");
+		exit(2);
+	}
+
+	waitexit();
+	if (!ret && tdc->test == TEST_FIN) {
+		ret = io_uring_unregister_buffers(&ring);
+		if (ret)
+			verror("unregister run_parent fin");
+	}
+
+done:
+	queue_exit(&ring);
+
+	if (ret)
+		cont();
+
+	return ret;
+}
+
+static void
+run_child(struct test_desc *tdc)
+{
+	int from_fd, ret = ECONNABORTED;
+	int (*fn)(struct test_desc *);
+
+	vinfo(V1, "child stop\n");
+
+	ptrace(PTRACE_TRACEME, 0, NULL, NULL);
+	raise(SIGSTOP);
+
+	if (tdc->share == FD) {
+		vinfo(V3, "recv_fd %d\n", tdc->sp[1]);
+		from_fd = recv_fd(tdc->sp[1]);
+		if (from_fd < 0)
+			goto done;
+		vinfo(V3, "recv_fd %d: %d\n", tdc->sp[1], from_fd);
+		tdc->fd = from_fd;
+	}
+
+	fn = test_fn[tdc->id];
+	ret = fn(tdc);
+
+	if (tdc->share == FD)
+		close_sockets();
+
+done:
+	vinfo(V2, "child exiting %d\n", ret);
+	/*
+	 * The parent exits for the final test before waiting for children
+	 * so save the test status.
+	 */
+	shmstat_store(tdc, -ret);
+	exit(-ret);
+}
+
+static int
+run_test(struct test_desc *proto)
+{
+	int i, pid, ret;
+	struct test_desc *tdc = NULL;
+
+	ret = pid = 0;
+
+	for (i = 0; i < nids; i++) {
+		tdcs[i] = *proto;
+		tdc = & tdcs[i];
+		tdc->idx = i;
+		if (tdc->share == FD) {
+			ret = get_socketpair(tdc->sp);
+			if (ret)
+				return -ret;
+		}
+		pid = fork();
+		if (pid) {
+			pids[i] = pid;
+			continue;
+		}
+		run_child(tdc);
+	}
+
+	ret = run_parent(proto);
+
+	if (proto->share == FD)
+		close_sockets();
+
+	return ret;
+}
+
+static int
+check_exitstat(struct test_desc *tdc, int *stat)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < nids; i++) {
+		if (status[i] != tdc->expect) {
+			vinfo(V1, "check_exitstat child %d: expect %d got %d\n",
+			      pids[i], tdc->expect, status[i]);
+			if (!ret) {
+				ret = 1;
+				*stat = status[i];
+			}
+		}
+	}
+
+	if (!ret)
+		*stat = status[0];
+
+	return ret;
+}
+
+static int
+test(int id, int share, int preg, int reg, int test, int expect)
+{
+	int ret, stat;
+	char *res;
+
+	struct test_desc tdc = {
+		.id = id,
+		.fd = -1,
+		.sp = {-1, -1},
+		.share = share,
+		.preg = preg,
+		.reg = reg,
+		.test = test,
+		.expect = expect,
+	};
+
+	vinfo(V1, "test(%s %s %s %s %s)\n", i2s[tdc.id], s2s[tdc.share],
+	      r2s[tdc.preg], r2s[tdc.reg], t2s[tdc.test]);
+
+	memset(tdcs, 0, sizeof(tdcs));
+	memset(pids, 0, sizeof(pids));
+	memset(status, 0, sizeof(status));
+	memset(shmstat, SHM_ST_NONE, SHM_ST_SZ);
+
+	ret = run_test(&tdc);
+	stat = ret;
+
+	if (ret) {
+		ret = 1;
+		res = "FAIL RUN";
+	} else {
+		ret = check_exitstat(&tdc, &stat);
+		res = ret ? "FAIL" : "PASS";
+	}
+
+	vinfo(V1, "test(%s %s %s %s %s: %d %d) %s\n",
+	      i2s[tdc.id], s2s[tdc.share], r2s[tdc.preg],
+	      r2s[tdc.reg], t2s[tdc.test], tdc.expect, stat, res);
+
+	return ret;
+}
+
+static int
+test_exit(int expect)
+{
+	int status, i, ret = 0;
+
+	vinfo(V1, "grandparent pid\n");
+
+	wait(&status);
+
+	vinfo(V2, "parent exited: %d\n", WEXITSTATUS(status));
+
+	for (i = 0; i < 60; i++) {
+		ret = shmstat_check(expect);
+		if (ret >= 0)
+			break;
+		sleep(1);
+	}
+
+	if (ret) {
+		vinfo(V1, "Bad test_exit stat %d\n", ret);
+		ret = 1;
+	}
+
+	vinfo(V1, "Test exit %d\n", ret);
+	exit(ret);
+}
+
+/*
+ * main()
+ * -> shm_create()
+ * -> create_buffers()
+ * parent:
+ * -> test()
+ *    -> run_test()
+ *       -> run_parent()
+ *          -> io_uring_register_buffers()
+ *       -> run_child()
+ * 	 -> test_reg()
+ *          -> register_buffers()
+ *       -> test_io()
+ *          -> run_test_io()
+ *             -> do_io()
+ *                -> register_buffers()
+ *
+ * grandparent:
+ * -> test_exit()
+ */
+
+int
+main(int argc, char *argv[])
+{
+	int shmid, pid, ret = 0;
+	char c;
+
+	while ((c = getopt(argc, argv, "s:v:")) != -1)
+		switch (c) {
+		case 's':
+			shm_sz = atoi(optarg) * SZ_2M;
+			break;
+		case 'v':
+			verbose = atoi(optarg);
+			break;
+		default:
+			exit(1);
+		}
+
+	argc -= optind;
+	argv += optind;
+
+	if (argc)
+		nids = atoi(argv[0]);
+
+	if (!nids || nids > MAXID)
+		exit(1);
+
+	shmstat = shmstat_create();
+	if (shmstat == MAP_FAILED)
+		exit(1);
+
+	pid = fork();
+	if (pid)
+		exit(test_exit(PASS));
+
+	vinfo(V1, "parent pid\n");
+
+	shmid = shm_create();
+	if (shmid < 0)
+		exit(1);
+
+	shmbuf = shm_attach(shmid);
+	if (shmbuf == MAP_FAILED) {
+		shm_destroy(shmid, shmbuf);
+		exit(1);
+	}
+
+	create_buffers(shmbuf);
+
+	ret |= test(TEST_REG, NO, REG_PIN, REG_PIN, TEST_DFLT,  PASS);
+	ret |= test(TEST_REG, NO, REG_NOP, REG_NOP, TEST_DFLT,  PASS);
+	ret |= test(TEST_REG, NO, REG_NOP, REG_ATT, TEST_DFLT,  EINVAL);
+	ret |= test(TEST_REG, FD, REG_PIN, REG_ATT, TEST_DFLT,  PASS);
+	ret |= test(TEST_REG, FD, REG_NOP, REG_ATT, TEST_DFLT,  PASS);
+	ret |= test(TEST_REG, FD, REG_PIN, REG_ATT, TEST_BUSY,  PASS);
+	ret |= test(TEST_REG, FD, REG_PIN, REG_ATT, TEST_FIN,   PASS);
+	ret |= test(TEST_REG, FD, REG_PIN, REG_ATT, TEST_BADFD, EBADF);
+	ret |= test(TEST_REG, FD, REG_PIN, REG_ATT, TEST_INVFD, EINVAL);
+	ret |= test(TEST_REG, FD, REG_PIN, REG_ATT, TEST_UNREG, EINVAL);
+	ret |= test(TEST_IO,  FD, REG_PIN, REG_PIN, TEST_DFLT,  PASS);
+	ret |= test(TEST_IO,  FD, REG_PIN, REG_ATT, TEST_DFLT,  PASS);
+	ret |= test(TEST_IO,  FD, REG_NOP, REG_ATT, TEST_DFLT,  EFAULT);
+	ret |= test(TEST_IO,  FD, REG_PIN, REG_ATT, TEST_EXIT,  NONE);
+
+	shm_destroy(shmid, shmbuf);
+
+	return ret;
+}
-- 
1.8.3.1

