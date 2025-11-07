Return-Path: <io-uring+bounces-10439-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 26848C3E71D
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 05:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B9F1188B51F
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 04:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CCDE274B58;
	Fri,  7 Nov 2025 04:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="rcW0RvyT"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A12B26F2A7
	for <io-uring@vger.kernel.org>; Fri,  7 Nov 2025 04:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762489808; cv=none; b=VNAwrpaF/JltgA7s6aRZj8qE+Prgiw/RCbQ/sHrFXZGt1T4rTZap7sjiOlMxYQihjdsFfNshqcToShWj4V+1k2XDQD4blW9EFV43uC8Xb7N0dGvzHbN9YB0gENYVmuu2hqIX0bO/YH3L+NNn67OC5wSL2KOi1BUpZs85sXCGlhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762489808; c=relaxed/simple;
	bh=P+egYnlAF48BtLGaMk/tQTF8zwFK919WRwyJqvA9Mmg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XxfBS7vbO/sTn1mfr/3D9Lz2SkAvnFwvnNHEJVTOHbGcNAS0ThV474gfP/uWxrekSdL4oZDm+SCksfZD81Yq2t5XpBBv1TMN3OGMotGwyO9mNCac8UpixTsZ8vR/rAcjWsEO9mWKEfHmhDd5jBRdafG0Yy24tJtPIoppKoQJUCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=rcW0RvyT; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5A70tsBW998351
	for <io-uring@vger.kernel.org>; Thu, 6 Nov 2025 20:30:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=2mQBk4TiYt0K3pg/1A
	Q3jR4XxU/HqvrXFIWUnvvN8qo=; b=rcW0RvyT5E0v2swEFRf+M0HnPkxSdPPf6P
	+tCZPR3cvxhZVTFppGMULadhbJ276/vVRZa4BQCXCGNx9vKZ6RVkBfvCEGhPwnHn
	9l8zmQ6TsQp0gL9DLoSVwml7lmpDXYVpyUxe9BPJ/B/XjlukVPLsJNTT4LKAx1VI
	UUmcUP+WUhW8d/2t/RWX7zdGH91g9OhUrgvGmU9Ck52uv4DsXs9bvzV7K1QW0M5K
	SlyMoMccfJFJRd5rAqxcJnkbsO5nnYg94T8xbpv4vNOg4FZxtCwgsQwFVNtxN4VU
	pv6sdU6Ypw4BCfpMIJTzldCTu1cm5xITAhquOkdE0WAz02j5kKxQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a90u1cr96-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 20:30:05 -0800 (PST)
Received: from twshared13861.04.snb2.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Fri, 7 Nov 2025 04:30:03 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 975ED38308A6; Thu,  6 Nov 2025 20:29:55 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH] liburing: add test for metadata
Date: Thu, 6 Nov 2025 20:29:53 -0800
Message-ID: <20251107042953.3393507-1-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA3MDAzMiBTYWx0ZWRfXy3f7doYOOUwL
 2q6XLlO9HADMXBpjn8VasJU/5g2fVnKv3jxbeIuIGkWF4ccfKCXIGJLZES0Tddcq8JgDj7Um2bN
 iOr0d94sWc71cOQ+dgAgXBRRx5tai/RBolaFBgDM01ykX9xfVyYqZQ6LW/IEvCyxhF0b/Hhpmt2
 Ut6n7WXkpnsmOF+76lS9AxBhrsJ5EfQekTA6/Taue4bhuuJTovOxhK2LnExwbsS9FOCm/1acUBg
 kq+2bX1iVTpFGv6JcM/pNsgcrrIGH/15rgQ//pgVSkGERHI/8T39tbhQFVJGKOxQvNAVh/WjKzC
 hClNxh4mBTchX8Sj3zDzYBKyVAixwMJPw+LtybvVDnTxPuw66jynTPjjCVgYYRnJVDlTUGZeiGh
 SBa6Cqkl3frEAkExuOavMRq5ykTYeg==
X-Proofpoint-ORIG-GUID: HxFv56Vv3B-XdqZI8GagTHdeTanFG1Ag
X-Authority-Analysis: v=2.4 cv=YbWwJgRf c=1 sm=1 tr=0 ts=690d75cd cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=6y2LiFgye2AjAuDQ5WgA:9
X-Proofpoint-GUID: HxFv56Vv3B-XdqZI8GagTHdeTanFG1Ag
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_05,2025-11-06_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

If the test device supports metadata, try attaching a pi buffer with
various page offsets, and seed offsets. If the metadata contains opaque
data preceding or following the data integrity field, fill it with a
pattern of data, and verify the expected data and metadata matches on
the other side.

The sizes and offsets send should guarantee kernel splits and bounce
buffers will get used.

At the end of the test, the written blocks are overwritten without
providing metadata. This test doesn't calculate the guard tags, so
writing without metadata lets the kernel generate the expected guard and
ref tags so that buffered IO won't get seemingly unexpected failures.

Tested on qemu nvme with 512b and 4k logical block size with 8, 16, and
64 metadata, both with and without pi offsets for the larger formats.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 src/include/liburing/io_uring.h |  16 ++
 test/Makefile                   |   1 +
 test/metadata.c                 | 404 ++++++++++++++++++++++++++++++++
 3 files changed, 421 insertions(+)
 create mode 100644 test/metadata.c

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index 44ce8229..a54e5b42 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -100,6 +100,10 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		struct {
+			__u64   attr_ptr; /* pointer to attribute information */
+			__u64   attr_type_mask; /* bit mask of attributes */
+                };
 		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
@@ -109,6 +113,18 @@ struct io_uring_sqe {
 	};
 };
=20
+/* sqe->attr_type_mask flags */
+#define IORING_RW_ATTR_FLAG_PI  (1U << 0)
+/* PI attribute information */
+struct io_uring_attr_pi {
+		__u16	flags;
+		__u16	app_tag;
+		__u32	len;
+		__u64	addr;
+		__u64	seed;
+		__u64	rsvd;
+};
+
 /*
  * If sqe->file_index is set to this for opcodes that instantiate a new
  * direct descriptor (like openat/openat2/accept), then io_uring will al=
locate
diff --git a/test/Makefile b/test/Makefile
index ee983680..8c4c6db5 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -141,6 +141,7 @@ test_srcs :=3D \
 	link-timeout.c \
 	linked-defer-close.c \
 	madvise.c \
+	metadata.c \
 	min-timeout.c \
 	min-timeout-wait.c \
 	mkdir.c \
diff --git a/test/metadata.c b/test/metadata.c
new file mode 100644
index 00000000..66a2565b
--- /dev/null
+++ b/test/metadata.c
@@ -0,0 +1,404 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Description: test userspace metadata
+ */
+
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+#include <linux/fs.h>
+
+#include "liburing.h"
+#include "helpers.h"
+#include "test.h"
+
+#ifndef FS_IOC_GETLBMD_CAP
+/* Protection info capability flags */
+#define LBMD_PI_CAP_INTEGRITY           (1 << 0)
+#define LBMD_PI_CAP_REFTAG              (1 << 1)
+
+/* Checksum types for Protection Information */
+#define LBMD_PI_CSUM_NONE               0
+#define LBMD_PI_CSUM_IP                 1
+#define LBMD_PI_CSUM_CRC16_T10DIF       2
+#define LBMD_PI_CSUM_CRC64_NVME         4
+
+/*
+ * Logical block metadata capability descriptor
+ * If the device does not support metadata, all the fields will be zero.
+ * Applications must check lbmd_flags to determine whether metadata is
+ * supported or not.
+ */
+struct logical_block_metadata_cap {
+	/* Bitmask of logical block metadata capability flags */
+	__u32	lbmd_flags;
+	/*
+	 * The amount of data described by each unit of logical block
+	 * metadata
+	 */
+	__u16	lbmd_interval;
+	/*
+	 * Size in bytes of the logical block metadata associated with each
+	 * interval
+	 */
+	__u8	lbmd_size;
+	/*
+	 * Size in bytes of the opaque block tag associated with each
+	 * interval
+	 */
+	__u8	lbmd_opaque_size;
+	/*
+	 * Offset in bytes of the opaque block tag within the logical block
+	 * metadata
+	 */
+	__u8	lbmd_opaque_offset;
+	/* Size in bytes of the T10 PI tuple associated with each interval */
+	__u8	lbmd_pi_size;
+	/* Offset in bytes of T10 PI tuple within the logical block metadata */
+	__u8	lbmd_pi_offset;
+	/* T10 PI guard tag type */
+	__u8	lbmd_guard_tag_type;
+	/* Size in bytes of the T10 PI application tag */
+	__u8	lbmd_app_tag_size;
+	/* Size in bytes of the T10 PI reference tag */
+	__u8	lbmd_ref_tag_size;
+	/* Size in bytes of the T10 PI storage tag */
+	__u8	lbmd_storage_tag_size;
+	__u8	pad;
+};
+
+#define FS_IOC_GETLBMD_CAP                      _IOWR(0x15, 2, struct lo=
gical_block_metadata_cap)
+#endif /* FS_IOC_GETLBMD_CAP */
+
+#ifndef IO_INTEGRITY_CHK_GUARD
+/* flags for integrity meta */
+#define IO_INTEGRITY_CHK_GUARD          (1U << 0) /* enforce guard check=
 */
+#define IO_INTEGRITY_CHK_REFTAG         (1U << 1) /* enforce ref check *=
/
+#define IO_INTEGRITY_CHK_APPTAG         (1U << 2) /* enforce app check *=
/
+#endif /* IO_INTEGRITY_CHK_GUARD */
+
+/* This size should guarantee at least one split */
+#define DATA_SIZE (8 * 1024 * 1024)
+
+static unsigned short lba_size;
+static unsigned char metadata_size;
+static unsigned char pi_offset;
+static bool reftag_enabled;
+
+static long pagesize;
+
+struct t10_pi_tuple {
+        __be16 guard_tag;       /* Checksum */
+        __be16 app_tag;         /* Opaque storage */
+        __be32 ref_tag;         /* Target LBA or indirect LBA */
+};
+
+static int init_capabilities(int fd)
+{
+	struct logical_block_metadata_cap md_cap;
+	int ret;
+
+	ret =3D ioctl(fd, FS_IOC_GETLBMD_CAP, &md_cap);
+	if (ret < 0)
+		return ret;
+
+	lba_size =3D md_cap.lbmd_interval;
+	metadata_size =3D md_cap.lbmd_size;
+	pi_offset =3D md_cap.lbmd_pi_offset;
+	reftag_enabled =3D md_cap.lbmd_flags & LBMD_PI_CAP_REFTAG;
+
+	pagesize =3D sysconf(_SC_PAGE_SIZE);
+	return 0;
+}
+
+static unsigned int swap(unsigned int value)
+{
+	return ((value >> 24) & 0x000000ff) |
+		((value >> 8)  & 0x0000ff00) |
+		((value << 8)  & 0x00ff0000) |
+		((value << 24) & 0xff000000);
+}
+
+static void init_metadata(void *p, int intervals, int ref)
+{
+	int i, j;
+
+	for (i =3D 0; i < intervals; i++, ref++) {
+		int remaining =3D metadata_size - pi_offset;
+		unsigned char *m =3D p;
+
+		for (j =3D 0; j < pi_offset; j++)
+			m[j] =3D (unsigned char)(ref + j + i);
+
+		p +=3D pi_offset;
+		if (reftag_enabled) {
+			struct t10_pi_tuple *tuple =3D p;
+
+			tuple->ref_tag =3D swap(ref);
+			remaining -=3D sizeof(*tuple);
+			p +=3D sizeof(*tuple);
+		}
+
+		m =3D p;
+		for (j =3D 0; j < remaining; j++)
+			m[j] =3D (unsigned char)~(ref + j + i);
+
+		p +=3D remaining;
+	}
+}
+
+static int check_metadata(void *p, int intervals, int ref)
+{
+	int i, j;
+
+	for (i =3D 0; i < intervals; i++, ref++) {
+		int remaining =3D metadata_size - pi_offset;
+		unsigned char *m =3D p;
+
+		for (j =3D 0; j < pi_offset; j++) {
+			if (m[j] !=3D (unsigned char)(ref + j + i)) {
+				fprintf(stderr, "(pre)interval:%d byte:%d expected:%x got:%x\n",
+					i, j, (unsigned char)(ref + j + i), m[j]);
+				return -1;
+			}
+		}
+
+		p +=3D pi_offset;
+		if (reftag_enabled) {
+			struct t10_pi_tuple *tuple =3D p;
+
+			if (swap(tuple->ref_tag) !=3D ref) {
+				fprintf(stderr, "reftag interval:%d expected:%x got:%x\n",
+					i, ref, swap(tuple->ref_tag));
+				return -1;
+			}
+
+			remaining -=3D sizeof(*tuple);
+			p +=3D sizeof(*tuple);
+		}
+
+		m =3D p;
+		for (j =3D 0; j < remaining; j++) {
+			if (m[j] !=3D (unsigned char)~(ref + j + i)) {
+				fprintf(stderr, "(post)interval:%d byte:%d expected:%x got:%x\n",
+					i, j, (unsigned char)~(ref + j + i), m[j]);
+				return -1;
+			}
+		}
+
+		p +=3D remaining;
+	}
+
+	return 0;
+}
+
+static int init_data(void *data, int offset)
+{
+	unsigned char *d =3D data;
+	int i;
+
+	for (i =3D 0; i < DATA_SIZE; i++)
+		d[i] =3D (unsigned char)(0xaa + offset + i);
+
+	return 0;
+}
+
+static int check_data(void *data, int offset)
+{
+	unsigned char *d =3D data;
+	int i;
+
+	for (i =3D 0; i < DATA_SIZE; i++)
+		if (d[i] !=3D (unsigned char)(0xaa + offset + i))
+			return -1;
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int fd, ret, offset, intervals, metabuffer_size, metabuffer_tx_size;
+	void *orig_data_buf, *orig_pi_buf, *data_buf;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+
+	if (argc < 2) {
+		fprintf(stderr, "Usage: %s <dev>\n", argv[0]);
+		return T_EXIT_FAIL;
+	}
+
+	fd =3D open(argv[1], O_RDWR | O_DIRECT);
+	if (fd < 0) {
+		perror("Failed to open device with O_DIRECT");
+		return T_EXIT_FAIL;
+	}
+
+	ret =3D init_capabilities(fd);
+	if (ret < 0)
+		return T_EXIT_FAIL;
+	if (lba_size =3D=3D 0 || metadata_size =3D=3D 0)
+		return T_EXIT_SKIP;
+
+	intervals =3D DATA_SIZE / lba_size;
+	metabuffer_tx_size =3D intervals * metadata_size;
+	metabuffer_size =3D metabuffer_tx_size * 2;
+
+	if (posix_memalign(&orig_data_buf, pagesize, DATA_SIZE)) {
+		perror("posix_memalign failed for data buffer");
+		ret =3D T_EXIT_FAIL;
+		goto close;
+	}
+
+	if (posix_memalign(&orig_pi_buf, pagesize, metabuffer_size)) {
+		perror("posix_memalign failed for metadata buffer");
+		ret =3D T_EXIT_FAIL;
+		goto free;
+	}
+
+	ret =3D io_uring_queue_init(8, &ring, 0);
+	if (ret < 0) {
+		perror("io_uring_queue_init failed");
+		goto cleanup;
+	}
+
+	data_buf =3D orig_data_buf;
+	for (offset =3D 0; offset < 512; offset++) {
+		void *pi_buf =3D (char *)orig_pi_buf + offset * 4;
+		struct io_uring_attr_pi pi_attr =3D {
+			.addr =3D (__u64)pi_buf,
+			.seed =3D offset,
+			.len =3D metabuffer_tx_size,
+		};
+
+		if (reftag_enabled)
+			pi_attr.flags =3D IO_INTEGRITY_CHK_REFTAG;
+
+		init_data(data_buf, offset);
+		init_metadata(pi_buf, intervals, offset);
+
+		sqe =3D io_uring_get_sqe(&ring);
+		if (!sqe) {
+			fprintf(stderr, "Failed to get SQE\n");
+			ret =3D T_EXIT_FAIL;
+			goto ring_exit;
+		}
+
+		io_uring_prep_write(sqe, fd, data_buf, DATA_SIZE, offset * lba_size * =
8);
+		io_uring_sqe_set_data(sqe, (void *)1L);
+
+		sqe->attr_type_mask =3D IORING_RW_ATTR_FLAG_PI;
+		sqe->attr_ptr =3D (__u64)&pi_attr;
+
+		ret =3D io_uring_submit(&ring);
+		if (ret < 1) {
+			perror("io_uring_submit failed (WRITE)");
+			ret =3D T_EXIT_FAIL;
+			goto ring_exit;
+		}
+
+		ret =3D io_uring_wait_cqe(&ring, &cqe);
+		if (ret < 0) {
+			perror("io_uring_wait_cqe failed (WRITE)");
+			ret =3D T_EXIT_FAIL;
+			goto ring_exit;
+		}
+
+		if (cqe->res < 0) {
+			fprintf(stderr, "write failed at offset %d: %s\n",
+				offset, strerror(-cqe->res));
+			ret =3D T_EXIT_FAIL;
+			goto ring_exit;
+		}
+
+		io_uring_cqe_seen(&ring, cqe);
+
+		memset(data_buf, 0, DATA_SIZE);
+		memset(pi_buf, 0, metabuffer_tx_size);
+
+		sqe =3D io_uring_get_sqe(&ring);
+		if (!sqe) {
+			fprintf(stderr, "failed to get SQE\n");
+			ret =3D T_EXIT_FAIL;
+			goto ring_exit;
+		}
+
+		io_uring_prep_read(sqe, fd, data_buf, DATA_SIZE, offset * lba_size * 8=
);
+		io_uring_sqe_set_data(sqe, (void *)2L);
+
+		sqe->attr_type_mask =3D IORING_RW_ATTR_FLAG_PI;
+		sqe->attr_ptr =3D (__u64)&pi_attr;
+
+		ret =3D io_uring_submit(&ring);
+		if (ret < 1) {
+			perror("io_uring_submit failed (read)");
+			ret =3D T_EXIT_FAIL;
+			goto ring_exit;
+		}
+
+		ret =3D io_uring_wait_cqe(&ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "io_uring_wait_cqe failed (read): %s\n", strerror(-re=
t));
+			ret =3D T_EXIT_FAIL;
+			goto ring_exit;
+		}
+
+		if (cqe->res < 0) {
+			fprintf(stderr, "read failed at offset %d: %s\n",
+				offset, strerror(-cqe->res));
+			ret =3D T_EXIT_FAIL;
+			goto ring_exit;
+		}
+
+		ret =3D check_data(data_buf, offset);
+		if (ret) {
+			fprintf(stderr, "data corruption at offset %d\n",
+				offset);
+			ret =3D T_EXIT_FAIL;
+			goto ring_exit;
+		}
+
+		ret =3D check_metadata(pi_buf, intervals, offset);
+		if (ret) {
+			fprintf(stderr, "metadata corruption at offset %d\n",
+				offset);
+			ret =3D T_EXIT_FAIL;
+			goto ring_exit;
+		}
+
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	memset(data_buf, 0, DATA_SIZE);
+
+	sqe =3D io_uring_get_sqe(&ring);
+	io_uring_prep_write(sqe, fd, data_buf, DATA_SIZE, 0);
+	io_uring_sqe_set_data(sqe, (void *)1L);
+
+	sqe =3D io_uring_get_sqe(&ring);
+	io_uring_prep_write(sqe, fd, data_buf, DATA_SIZE, DATA_SIZE);
+	io_uring_sqe_set_data(sqe, (void *)2L);
+
+	io_uring_submit(&ring);
+
+	io_uring_wait_cqe(&ring, &cqe);
+	io_uring_cqe_seen(&ring, cqe);
+	io_uring_wait_cqe(&ring, &cqe);
+	io_uring_cqe_seen(&ring, cqe);
+ring_exit:
+    io_uring_queue_exit(&ring);
+cleanup:
+    free(orig_pi_buf);
+free:
+    free(orig_data_buf);
+close:
+    close(fd);
+    return ret;
+}
--=20
2.47.3


