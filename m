Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5388645AAE8
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 19:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239633AbhKWSLW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 13:11:22 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61518 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239652AbhKWSLV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 13:11:21 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AND8DaK027430
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 10:08:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Gb+gJImTwxC3Z+nsR6lmv8FkAhq+aAR0p2B0R9LT4LE=;
 b=SA/WcmohyJovaDViTJUJCUKtq3bW1mrIVH9NyBUrx92QPQscfTIbXaibnHf8QQ/0IC1R
 1RxOs/MB+tHSVJUjfaLpjTanQBcdYp8niMEadCaXmmlViPMMyVqXq+ANk73UxsRwdSEm
 KS9o5ps0zpCeo9WmfLbt73+MOLIitp/HbTE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3ch0wp28sb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 10:08:05 -0800
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 23 Nov 2021 10:08:04 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id E5B6B6CCCD4B; Tue, 23 Nov 2021 10:07:54 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v1 3/4] liburing: Add test program for getdents call
Date:   Tue, 23 Nov 2021 10:07:52 -0800
Message-ID: <20211123180753.1598611-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211123180753.1598611-1-shr@fb.com>
References: <20211123180753.1598611-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: Mp2gkDhjoeAkiPj5vzO1-RwJzxUwvhIt
X-Proofpoint-GUID: Mp2gkDhjoeAkiPj5vzO1-RwJzxUwvhIt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_06,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 suspectscore=0 clxscore=1015 mlxlogscore=990 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230088
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add test program for getdents64 call.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 test/Makefile   |   1 +
 test/getdents.c | 258 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 259 insertions(+)
 create mode 100644 test/getdents.c

diff --git a/test/Makefile b/test/Makefile
index d6e7227..3e29a1f 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -77,6 +77,7 @@ test_srcs :=3D \
 	file-verify.c \
 	fixed-link.c \
 	fsync.c \
+	getdents.c \
 	hardlink.c \
 	io-cancel.c \
 	iopoll.c \
diff --git a/test/getdents.c b/test/getdents.c
new file mode 100644
index 0000000..81da36c
--- /dev/null
+++ b/test/getdents.c
@@ -0,0 +1,258 @@
+#include <assert.h>
+#include <dirent.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/resource.h>
+#include <sys/xattr.h>
+#include <unistd.h>
+
+#include "helpers.h"
+#include "liburing.h"
+
+#define BUFFER_SIZE 512
+
+#define LIST_INIT(name) { &(name), &(name) }
+
+#define CONTAINER_OF(ptr, type, member) (					\
+	{									\
+		const typeof(((type *)0)->member) *__ptr =3D (ptr);		\
+		(type *)((char *)__ptr - (intptr_t)(&((type *)0)->member)); 	\
+	})
+
+struct list {
+	struct list	*next;
+	struct list	*prev;
+};
+
+struct dir {
+	struct list	list;
+	int		ret;
+
+	struct dir	*parent;
+	int		fd;
+	uint64_t	off;
+	uint8_t		buf[BUFFER_SIZE];
+	char		name[0];
+};
+
+struct linux_dirent64 {
+	int64_t		d_ino;    /* 64-bit inode number */
+	int64_t		d_off;    /* 64-bit offset to next structure */
+	unsigned short	d_reclen; /* Size of this dirent */
+	unsigned char	d_type;   /* File type */
+	char		d_name[]; /* Filename (null-terminated) */
+};
+
+/* Define global variables. */
+static struct io_uring ring;
+static struct list active =3D LIST_INIT(active);
+static int sqes_in_flight =3D 0;
+static int num_dir_entries =3D 0;
+
+/* Forward declarations. */
+static void drain_cqes(void);
+static void schedule_readdir(struct dir *dir);
+
+/* List helper functions. */
+static inline void
+list_add_tail(struct list *l, struct list *head)
+{
+	l->next =3D head;
+	l->prev =3D head->prev;
+	head->prev->next =3D l;
+	head->prev =3D l;
+}
+
+static inline void list_del(struct list *l)
+{
+	l->prev->next =3D l->next;
+	l->next->prev =3D l->prev;
+	l->prev =3D NULL;
+	l->next =3D NULL;
+}
+
+static inline int is_list_empty(const struct list *l)
+{
+	return l->next =3D=3D l;
+}
+
+static struct io_uring_sqe *get_sqe(void)
+{
+	struct io_uring_sqe *sqe;
+
+	sqe =3D io_uring_get_sqe(&ring);
+	while (sqe =3D=3D NULL) {
+		drain_cqes();
+
+		int ret =3D io_uring_submit(&ring);
+		if (ret < 0 && errno !=3D EBUSY) {
+			perror("io_uring_submit");
+			exit(EXIT_FAILURE);
+		}
+
+		sqe =3D io_uring_get_sqe(&ring);
+	}
+
+	sqes_in_flight++;
+	return sqe;
+}
+
+static void drain_cqes(void)
+{
+	int 			count;
+	uint32_t 		head;
+	struct io_uring_cqe 	*cqe;
+
+	count =3D 0;
+	io_uring_for_each_cqe (&ring, head, cqe) {
+		struct dir *dir;
+
+		dir =3D io_uring_cqe_get_data(cqe);
+
+		list_add_tail(&dir->list, &active);
+		dir->ret =3D cqe->res;
+
+		count++;
+	}
+
+	sqes_in_flight -=3D count;
+	io_uring_cq_advance(&ring, count);
+}
+
+static void schedule_opendir(struct dir *parent, const char *name)
+{
+	int 			len =3D strlen(name);
+	struct dir 		*dir;
+	struct io_uring_sqe 	*sqe;
+
+	dir =3D malloc(sizeof(*dir) + len + 1);
+	if (dir =3D=3D NULL) {
+		fprintf(stderr, "out of memory\n");
+		exit(EXIT_FAILURE);
+	}
+
+	dir->parent =3D parent;
+	dir->fd =3D -1;
+	memcpy(dir->name, name, len);
+	dir->name[len] =3D 0;
+
+	sqe =3D get_sqe();
+	io_uring_prep_openat(sqe,
+			     (parent !=3D NULL) ? parent->fd : AT_FDCWD,
+			     dir->name,
+			     O_DIRECTORY,
+			     0);
+	io_uring_sqe_set_data(sqe, dir);
+}
+
+static void opendir_completion(struct dir *dir, int ret)
+{
+	if (ret < 0) {
+		fprintf(stderr, "error opening ");
+		fprintf(stderr, ": %s\n", strerror(-ret));
+		return;
+	}
+
+	dir->fd =3D ret;
+	dir->off =3D 0;
+	schedule_readdir(dir);
+}
+
+static void schedule_readdir(struct dir *dir)
+{
+	struct io_uring_sqe *sqe;
+
+	sqe =3D get_sqe();
+	io_uring_prep_getdents(sqe, dir->fd, dir->buf, sizeof(dir->buf), dir->o=
ff);
+	io_uring_sqe_set_data(sqe, dir);
+}
+
+static void readdir_completion(struct dir *dir, int ret)
+{
+	uint8_t *bufp;
+	uint8_t *end;
+
+	if (ret < 0) {
+		fprintf(stderr, "error reading ");
+		fprintf(stderr, ": %s (%d)\n", strerror(-ret), ret);
+		return;
+	}
+
+	if (ret =3D=3D 0) {
+		free(dir);
+		return;
+	}
+
+	bufp =3D dir->buf;
+	end =3D bufp + ret;
+
+	while (bufp < end) {
+		struct linux_dirent64 *dent;
+
+		dent =3D (struct linux_dirent64 *)bufp;
+
+		if (strcmp(dent->d_name, ".") && strcmp(dent->d_name, "..")) {
+			if (dent->d_type =3D=3D DT_DIR)
+				schedule_opendir(dir, dent->d_name);
+		}
+
+		dir->off =3D dent->d_off;
+		bufp +=3D dent->d_reclen;
+		++num_dir_entries;
+	}
+
+	schedule_readdir(dir);
+}
+
+int main(int argc, char *argv[])
+{
+	struct rlimit rlim;
+
+	/* Increase number of files rlimit to 1M. */
+	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0) {
+		perror("getrlimit");
+		return 1;
+	}
+
+	if (geteuid() =3D=3D 0 && rlim.rlim_max < 1048576)
+		rlim.rlim_max =3D 1048576;
+
+	if (rlim.rlim_cur < rlim.rlim_max) {
+		rlim.rlim_cur =3D rlim.rlim_max;
+		setrlimit(RLIMIT_NOFILE, &rlim);
+	}
+
+	if (io_uring_queue_init(256, &ring, 0) < 0) {
+		perror("io_uring_queue_init");
+		return 1;
+	}
+
+	/* Submit and handle requests. */
+	schedule_opendir(NULL, ".");
+	while (sqes_in_flight) {
+		int ret =3D io_uring_submit_and_wait(&ring, 1);
+		if (ret < 0 && errno !=3D EBUSY) {
+			perror("io_uring_submit_and_wait");
+			return 1;
+		}
+
+		drain_cqes();
+
+		while (!is_list_empty(&active)) {
+			struct dir *dir;
+
+			dir =3D CONTAINER_OF(active.next, struct dir, list);
+			list_del(&dir->list);
+
+			if (dir->fd =3D=3D -1)
+				opendir_completion(dir, dir->ret);
+			else
+				readdir_completion(dir, dir->ret);
+		}
+	}
+
+	io_uring_queue_exit(&ring);
+	return num_dir_entries < 50;
+}
--=20
2.30.2

