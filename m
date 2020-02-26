Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F27B416F9AF
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 09:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgBZIjE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 03:39:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44784 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgBZIjE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 03:39:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q8c1x4157792;
        Wed, 26 Feb 2020 08:39:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=oYojbi6eqa3clIbGPc3GNMK34gRTs+y0fY1uTIbn9os=;
 b=MIhsj2PdLPYP7w6dEuSOAR2X+mKxOF39/uRHaVph4mZvNlAEOP6FGNhAsE4g37cel1Cj
 642jr0LQ3SuqOAgl8qZ6Ft8z/CDZb4jKfLNZr3/nm79P62iXs5Fsp84toqnTYFmOhk0h
 W8owRLIveg8kp6ewOEIDAtmpWkqJSIKvAmq1HyaMHrl+iLEKM2OY9e5EWrSCjlbU90HL
 JSyvCGvubFEGlP+C4pOR7gPre2u6Hlctds9XgmB1BYik+MqG5n0MyTbTQGYtu3gKiIML
 eRQyYOhy4hw5AMMbw6/RCaJaCosUKX9Ot7QkktFDh//ds0xaYM68kdTnO8Nvxis+PbDA NQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ydcsrhxb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 08:39:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q8cNFI061935;
        Wed, 26 Feb 2020 08:39:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ydcs3x0gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 08:39:02 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01Q8d1DM010313;
        Wed, 26 Feb 2020 08:39:01 GMT
Received: from localhost.localdomain (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 00:39:00 -0800
From:   Bob Liu <bob.liu@oracle.com>
To:     linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, martin.petersen@oracle.com,
        linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com,
        io-uring@vger.kernel.org, Bob Liu <bob.liu@oracle.com>
Subject: [PATCH 4/4] liburing/test: add testcase for protect information passthrough
Date:   Wed, 26 Feb 2020 16:37:19 +0800
Message-Id: <20200226083719.4389-5-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200226083719.4389-1-bob.liu@oracle.com>
References: <20200226083719.4389-1-bob.liu@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=894 spamscore=0 suspectscore=1 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=1
 bulkscore=0 malwarescore=0 spamscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=950 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260065
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Demonstrate how to use IORING_OP_READ{WRITE}V_PI cmd.
Write data together with protection information, then read back and compare
results.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 src/include/liburing.h          |  16 ++
 src/include/liburing/io_uring.h |   2 +
 test/Makefile                   |   4 +-
 test/pi_passthrough.c           | 267 ++++++++++++++++++++++++++++++++
 4 files changed, 287 insertions(+), 2 deletions(-)
 create mode 100644 test/pi_passthrough.c

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 2f1e968..2967c5b 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -206,6 +206,14 @@ static inline void io_uring_prep_rw(int op, struct io_uring_sqe *sqe, int fd,
 	sqe->__pad2[0] = sqe->__pad2[1] = sqe->__pad2[2] = 0;
 }
 
+static inline void io_uring_prep_readv_pi(struct io_uring_sqe *sqe, int fd,
+				       const struct iovec *iovecs,
+				       unsigned nr_vecs, off_t offset)
+{
+	io_uring_prep_rw(IORING_OP_READV_PI, sqe, fd, iovecs, nr_vecs, offset);
+}
+
+
 static inline void io_uring_prep_readv(struct io_uring_sqe *sqe, int fd,
 				       const struct iovec *iovecs,
 				       unsigned nr_vecs, off_t offset)
@@ -228,6 +236,14 @@ static inline void io_uring_prep_writev(struct io_uring_sqe *sqe, int fd,
 	io_uring_prep_rw(IORING_OP_WRITEV, sqe, fd, iovecs, nr_vecs, offset);
 }
 
+static inline void io_uring_prep_writev_pi(struct io_uring_sqe *sqe, int fd,
+					const struct iovec *iovecs,
+					unsigned nr_vecs, off_t offset)
+{
+	io_uring_prep_rw(IORING_OP_WRITEV_PI, sqe, fd, iovecs, nr_vecs, offset);
+}
+
+
 static inline void io_uring_prep_write_fixed(struct io_uring_sqe *sqe, int fd,
 					     const void *buf, unsigned nbytes,
 					     off_t offset, int buf_index)
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 3f7961c..f5bb46f 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -86,6 +86,8 @@ enum {
 	IORING_OP_NOP,
 	IORING_OP_READV,
 	IORING_OP_WRITEV,
+	IORING_OP_READV_PI,
+	IORING_OP_WRITEV_PI,
 	IORING_OP_FSYNC,
 	IORING_OP_READ_FIXED,
 	IORING_OP_WRITE_FIXED,
diff --git a/test/Makefile b/test/Makefile
index 4a0bb4e..0bf29ec 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -13,7 +13,7 @@ all_targets += poll poll-cancel ring-leak fsync io_uring_setup io_uring_register
 		send_recvmsg a4c0b3decb33-test 500f9fbadef8-test timeout \
 		sq-space_left stdout cq-ready cq-peek-batch file-register \
 		cq-size 8a9973408177-test a0908ae19763-test 232c93d07b74-test \
-		socket-rw accept timeout-overflow defer read-write io-cancel \
+		socket-rw accept timeout-overflow defer read-write pi_passthrough io-cancel \
 		link-timeout cq-overflow link_drain fc2a85cb02ef-test \
 		poll-link accept-link fixed-link poll-cancel-ton teardowns \
 		poll-many b5837bd5311d-test accept-test d77a67ed5f27-test \
@@ -40,7 +40,7 @@ test_srcs := poll.c poll-cancel.c ring-leak.c fsync.c io_uring_setup.c \
 	500f9fbadef8-test.c timeout.c sq-space_left.c stdout.c cq-ready.c\
 	cq-peek-batch.c file-register.c cq-size.c 8a9973408177-test.c \
 	a0908ae19763-test.c 232c93d07b74-test.c socket-rw.c accept.c \
-	timeout-overflow.c defer.c read-write.c io-cancel.c link-timeout.c \
+	timeout-overflow.c defer.c read-write.c pi_passthrough.c io-cancel.c link-timeout.c \
 	cq-overflow.c link_drain.c fc2a85cb02ef-test.c poll-link.c \
 	accept-link.c fixed-link.c poll-cancel-ton.c teardowns.c poll-many.c \
 	b5837bd5311d-test.c accept-test.c d77a67ed5f27-test.c connect.c \
diff --git a/test/pi_passthrough.c b/test/pi_passthrough.c
new file mode 100644
index 0000000..27d679a
--- /dev/null
+++ b/test/pi_passthrough.c
@@ -0,0 +1,267 @@
+/*
+ * Simple app that demonstrates how to setup an io_uring interface,
+ * submit and complete IO against it, and then tear it down.
+ *
+ * gcc -Wall -O2 -D_GNU_SOURCE -o pi_passthrough pi_passthrough.c -luring
+ * modprobe scsi_debug.ko dif=1 guard=1 dev_size_mb=1024 num_parts=1 ato=1 dix=31
+ */
+#include <stdio.h>
+#include <fcntl.h>
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include "liburing.h"
+
+#define NR_SECTOR   11
+#define SECTOR_SIZE 512
+#define BUF_SIZE    (NR_SECTOR * SECTOR_SIZE)
+
+/* Will be round up power of 2 */
+#define QD	    (NR_SECTOR + 1 )
+
+struct sd_dif_tuple {
+       uint16_t guard_tag;	/* Checksum */
+       uint16_t app_tag;	/* Opaque storage */
+       uint32_t ref_tag;	/* Target LBA or indirect LBA */
+};
+
+
+typedef unsigned short __sum16;
+static inline unsigned short from32to16(unsigned int x)
+{
+        /* add up 16-bit and 16-bit for 16+c bit */
+        x = (x & 0xffff) + (x >> 16);
+        /* add up carry.. */
+        x = (x & 0xffff) + (x >> 16);
+        return x;
+}
+
+static unsigned int do_csum(const unsigned char *buff, int len)
+{
+	int odd, count;
+	unsigned long result = 0;
+
+	if (len <= 0)
+		goto out;
+	odd = 1 & (unsigned long) buff;
+	if (odd) {
+#ifdef __LITTLE_ENDIAN
+		result = *buff;
+#else
+		result += (*buff << 8);
+#endif
+		len--;
+		buff++;
+	}
+	count = len >> 1;		/* nr of 16-bit words.. */
+	if (count) {
+		if (2 & (unsigned long) buff) {
+			result += *(unsigned short *) buff;
+			count--;
+			len -= 2;
+			buff += 2;
+		}
+		count >>= 1;		/* nr of 32-bit words.. */
+		if (count) {
+			unsigned long carry = 0;
+			do {
+				unsigned long w = *(unsigned int *) buff;
+				count--;
+				buff += 4;
+				result += carry;
+				result += w;
+				carry = (w > result);
+			} while (count);
+			result += carry;
+			result = (result & 0xffff) + (result >> 16);
+		}
+		if (len & 2) {
+			result += *(unsigned short *) buff;
+			buff += 2;
+		}
+	}
+	if (len & 1)
+#ifdef __LITTLE_ENDIAN
+		result += *buff;
+#else
+		result += (*buff << 8);
+#endif
+	result = from32to16(result);
+	if (odd)
+		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
+out:
+	return result;
+}
+
+/*
+ * this routine is used for miscellaneous IP-like checksums, mainly
+ * in icmp.c
+ */
+__sum16 ip_compute_csum(const void *buff, int len)
+{
+	return (__sum16)~do_csum(buff, len);
+}
+
+static void stamp_pi_buffer(struct sd_dif_tuple *t, uint16_t csum,
+			    uint16_t tag, uint32_t sector)
+{
+	//t->guard_tag = htons(csum);
+	t->guard_tag = csum;
+	t->app_tag = getpid();
+	t->ref_tag = htonl(sector);
+}
+
+static void dump_buffer(char *buf, size_t len)
+{
+	size_t off;
+	char *p;
+
+	for (p = buf; p < buf + len; p++) {
+		off = p - buf;
+		if (off % 32 == 0) {
+			if (p != buf)
+				printf("\n");
+			printf("%05zu:", off);
+		}
+		printf(" %02x", *p & 0xFF);
+	}
+	printf("\n");
+}
+
+int io_rw(int fd, int write, void *buf, size_t len,
+		void *mbuf, size_t pi_buflen)
+{
+	struct io_uring ring;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct iovec *iovecs;
+	int i, ret, pending, done, offset=0;
+
+	iovecs = calloc(QD, sizeof(struct iovec));
+	for (i = 0; i < QD - 1; i++) {
+		iovecs[i].iov_base = buf + i * SECTOR_SIZE;
+		iovecs[i].iov_len = SECTOR_SIZE;
+	}
+	/* Last iovecs store protect information */
+	iovecs[i].iov_base = mbuf;
+	iovecs[i].iov_len  = pi_buflen;
+
+	if (write) {
+		__sum16 ip_csum;
+		int out_fd = 0;
+		out_fd = open("/dev/random", O_RDONLY);
+		if (out_fd < 0) {
+			perror("open");
+			return 1;
+		}
+
+		ret = read(out_fd, buf, len);
+		printf("read %d bytes from file\n", ret);
+		for( i = 0; i < NR_SECTOR; i++) {
+			ip_csum = ip_compute_csum(buf + i*SECTOR_SIZE, SECTOR_SIZE);
+			printf("ip_csum:0x%x\n", ip_csum);
+
+			stamp_pi_buffer(mbuf + i * sizeof(struct sd_dif_tuple),
+					ip_csum,0x0, i & 0xffffffff);
+		}
+	}
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret < 0) {
+		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
+		return 1;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe)
+		return 1;
+	if(write)
+		io_uring_prep_writev_pi(sqe, fd, iovecs, QD, offset);
+	else
+		io_uring_prep_readv_pi(sqe, fd, iovecs, QD, offset);
+
+	ret = io_uring_submit(&ring);
+	if (ret < 0) {
+		fprintf(stderr, "io_uring_submit: %s\n", strerror(-ret));
+		return 1;
+	}
+
+	done = 0;
+	pending = ret;
+	for (i = 0; i < pending; i++) {
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "io_uring_wait_cqe: %s\n", strerror(-ret));
+			return 1;
+		}
+
+		done++;
+		ret = 0;
+		if (cqe->res != SECTOR_SIZE) {
+			fprintf(stderr, "ceq->res=%d, wanted %d\n",
+					cqe->res, SECTOR_SIZE);
+			ret = 1;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+		if (ret)
+			break;
+	}
+	io_uring_queue_exit(&ring);
+	printf("Submitted=%d, completed=%d\n", pending, done);
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int fd;
+	int page_size = 4096;
+	size_t pi_buflen;
+	void *buf, *mbuf;
+	void *buf2, *mbuf2; //read back
+
+	if (argc < 2) {
+		printf("%s: file\n", argv[0]);
+		return 1;
+	}
+
+	fd = open(argv[1], O_RDWR |O_SYNC| O_DIRECT);
+	if (fd < 0) {
+		perror("open");
+		return 1;
+	}
+
+	/* write with protect information */
+	pi_buflen =  NR_SECTOR * sizeof(struct sd_dif_tuple);
+	if (posix_memalign(&buf, page_size, BUF_SIZE) ||
+			posix_memalign(&mbuf, page_size, pi_buflen) ) {
+		perror("memalign");
+		return 1;
+	}
+	io_rw(fd, 1, buf, BUF_SIZE, mbuf, pi_buflen);
+
+	/* read out protect information */
+	if (posix_memalign(&buf2, page_size, BUF_SIZE) ||
+			posix_memalign(&mbuf2, page_size, pi_buflen) ) {
+		perror("memalign");
+		return 1;
+	}
+	io_rw(fd, 0, buf2, BUF_SIZE, mbuf2, pi_buflen);
+	close(fd);
+
+	/* Compare result. */
+	if(memcmp(buf, buf2, BUF_SIZE)) {
+		printf("err!! protect date mismatch!!\n");
+		dump_buffer(buf, BUF_SIZE);
+		dump_buffer(mbuf, pi_buflen);
+	}
+	if(memcmp(mbuf, mbuf2, pi_buflen)) {
+		printf("err!! protect date mismatch!!\n");
+		dump_buffer(buf2, BUF_SIZE);
+		dump_buffer(mbuf2, pi_buflen);
+	}
+	printf("test succ!!\n");
+
+	return 0;
+}
-- 
2.17.1

