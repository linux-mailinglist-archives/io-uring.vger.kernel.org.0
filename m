Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA46425EF66
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 19:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgIFRzg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Sep 2020 13:55:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48778 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725841AbgIFRzc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Sep 2020 13:55:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599414930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YtI2cYgrOprAMHXHKFODqp3ttlJ0aVJ663udMKjqjuw=;
        b=hm8QFNLlyDimUXqAV0lrPISMS7kXUKE5DfVCCUhXdBnr6Q4QDBA2xWZ9v35DcWFT0IJua2
        f6INdaO/loKoqY9jr2m6Ja5i/5+zrxSzWXjhhIMsC+W1r4J/M5fhhhS6ScBguiJ6uvp5Cy
        aCPBQsKHCB+5Hg8Ke2sk5V/BsSkOdn0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-mTThNzK2Pw6fhCI_Ndwesg-1; Sun, 06 Sep 2020 13:55:24 -0400
X-MC-Unique: mTThNzK2Pw6fhCI_Ndwesg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0BE4802B5C;
        Sun,  6 Sep 2020 17:55:22 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-12-98.pek2.redhat.com [10.72.12.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 685A06F142;
        Sun,  6 Sep 2020 17:55:20 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     bfoster@redhat.com, io-uring@vger.kernel.org
Subject: [PATCH v4 1/5] fsstress: add IO_URING read and write operations
Date:   Mon,  7 Sep 2020 01:55:09 +0800
Message-Id: <20200906175513.17595-2-zlang@redhat.com>
In-Reply-To: <20200906175513.17595-1-zlang@redhat.com>
References: <20200906175513.17595-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IO_URING is a new feature of curent linux kernel, add basic IO_URING
read/write into fsstess to cover this kind of IO testing.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 README                 |   4 +-
 configure.ac           |   1 +
 include/builddefs.in   |   1 +
 ltp/Makefile           |   5 ++
 ltp/fsstress.c         | 139 ++++++++++++++++++++++++++++++++++++++++-
 m4/Makefile            |   1 +
 m4/package_liburing.m4 |   4 ++
 7 files changed, 152 insertions(+), 3 deletions(-)
 create mode 100644 m4/package_liburing.m4

diff --git a/README b/README
index d0e23fcd..ae0f804d 100644
--- a/README
+++ b/README
@@ -8,13 +8,13 @@ _______________________
 	sudo apt-get install xfslibs-dev uuid-dev libtool-bin \
 	e2fsprogs automake gcc libuuid1 quota attr libattr1-dev make \
 	libacl1-dev libaio-dev xfsprogs libgdbm-dev gawk fio dbench \
-	uuid-runtime python sqlite3
+	uuid-runtime python sqlite3 liburing-dev
   For Fedora, RHEL, or CentOS:
 	yum install acl attr automake bc dbench dump e2fsprogs fio \
 	gawk gcc indent libtool lvm2 make psmisc quota sed \
 	xfsdump xfsprogs \
 	libacl-devel libattr-devel libaio-devel libuuid-devel \
-	xfsprogs-devel btrfs-progs-devel python sqlite
+	xfsprogs-devel btrfs-progs-devel python sqlite liburing-devel
 	(Older distributions may require xfsprogs-qa-devel as well.)
 	(Note that for RHEL and CentOS, you may need the EPEL repo.)
 - run make
diff --git a/configure.ac b/configure.ac
index 4bb50b32..8922c47e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -61,6 +61,7 @@ AC_PACKAGE_NEED_ACLINIT_LIBACL
 
 AC_PACKAGE_WANT_GDBM
 AC_PACKAGE_WANT_AIO
+AC_PACKAGE_WANT_URING
 AC_PACKAGE_WANT_DMAPI
 AC_PACKAGE_WANT_LINUX_FIEMAP_H
 AC_PACKAGE_WANT_FALLOCATE
diff --git a/include/builddefs.in b/include/builddefs.in
index e7894b1a..fded3230 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -61,6 +61,7 @@ RPM_VERSION     = @rpm_version@
 ENABLE_SHARED = @enable_shared@
 HAVE_DB = @have_db@
 HAVE_AIO = @have_aio@
+HAVE_URING = @have_uring@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_OPEN_BY_HANDLE_AT = @have_open_by_handle_at@
 HAVE_DMAPI = @have_dmapi@
diff --git a/ltp/Makefile b/ltp/Makefile
index ebf40336..198d930f 100644
--- a/ltp/Makefile
+++ b/ltp/Makefile
@@ -24,6 +24,11 @@ LCFLAGS += -DAIO
 LLDLIBS += -laio -lpthread
 endif
 
+ifeq ($(HAVE_URING), true)
+LCFLAGS += -DURING
+LLDLIBS += -luring
+endif
+
 ifeq ($(HAVE_LIBBTRFSUTIL), true)
 LLDLIBS += -lbtrfsutil
 endif
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 709fdeec..2c584ef0 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -30,6 +30,11 @@
 #include <libaio.h>
 io_context_t	io_ctx;
 #endif
+#ifdef URING
+#include <liburing.h>
+#define URING_ENTRIES	1
+struct io_uring	ring;
+#endif
 #include <sys/syscall.h>
 #include <sys/xattr.h>
 
@@ -139,6 +144,8 @@ typedef enum {
 	OP_TRUNCATE,
 	OP_UNLINK,
 	OP_UNRESVSP,
+	OP_URING_READ,
+	OP_URING_WRITE,
 	OP_WRITE,
 	OP_WRITEV,
 	OP_LAST
@@ -267,6 +274,8 @@ void	sync_f(int, long);
 void	truncate_f(int, long);
 void	unlink_f(int, long);
 void	unresvsp_f(int, long);
+void	uring_read_f(int, long);
+void	uring_write_f(int, long);
 void	write_f(int, long);
 void	writev_f(int, long);
 char	*xattr_flag_to_string(int);
@@ -335,6 +344,8 @@ opdesc_t	ops[] = {
 	{ OP_TRUNCATE, "truncate", truncate_f, 2, 1 },
 	{ OP_UNLINK, "unlink", unlink_f, 1, 1 },
 	{ OP_UNRESVSP, "unresvsp", unresvsp_f, 1, 1 },
+	{ OP_URING_READ, "uring_read", uring_read_f, 1, 0 },
+	{ OP_URING_WRITE, "uring_write", uring_write_f, 1, 1 },
 	{ OP_WRITE, "write", write_f, 4, 1 },
 	{ OP_WRITEV, "writev", writev_f, 4, 1 },
 }, *ops_end;
@@ -692,6 +703,12 @@ int main(int argc, char **argv)
 				fprintf(stderr, "io_setup failed");
 				exit(1);
 			}
+#endif
+#ifdef URING
+			if (io_uring_queue_init(URING_ENTRIES, &ring, 0)) {
+				fprintf(stderr, "io_uring_queue_init failed\n");
+				exit(1);
+			}
 #endif
 			for (i = 0; !loops || (i < loops); i++)
 				doproc();
@@ -701,7 +718,9 @@ int main(int argc, char **argv)
 				return 1;
 			}
 #endif
-
+#ifdef URING
+			io_uring_queue_exit(&ring);
+#endif
 			cleanup_flist();
 			free(freq_table);
 			return 0;
@@ -2170,6 +2189,108 @@ do_aio_rw(int opno, long r, int flags)
 }
 #endif
 
+#ifdef URING
+void
+do_uring_rw(int opno, long r, int flags)
+{
+	char		*buf = NULL;
+	int		e;
+	pathname_t	f;
+	int		fd = -1;
+	size_t		len;
+	int64_t		lr;
+	off64_t		off;
+	struct stat64	stb;
+	int		v;
+	char		st[1024];
+	struct io_uring_sqe	*sqe;
+	struct io_uring_cqe	*cqe;
+	struct iovec	iovec;
+	int		iswrite = (flags & (O_WRONLY | O_RDWR)) ? 1 : 0;
+
+	init_pathname(&f);
+	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
+		if (v)
+			printf("%d/%d: do_uring_rw - no filename\n", procid, opno);
+		goto uring_out;
+	}
+	fd = open_path(&f, flags);
+	e = fd < 0 ? errno : 0;
+	check_cwd();
+	if (fd < 0) {
+		if (v)
+			printf("%d/%d: do_uring_rw - open %s failed %d\n",
+			       procid, opno, f.path, e);
+		goto uring_out;
+	}
+	if (fstat64(fd, &stb) < 0) {
+		if (v)
+			printf("%d/%d: do_uring_rw - fstat64 %s failed %d\n",
+			       procid, opno, f.path, errno);
+		goto uring_out;
+	}
+	inode_info(st, sizeof(st), &stb, v);
+	if (!iswrite && stb.st_size == 0) {
+		if (v)
+			printf("%d/%d: do_uring_rw - %s%s zero size\n", procid, opno,
+			       f.path, st);
+		goto uring_out;
+	}
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		if (v)
+			printf("%d/%d: do_uring_rw - io_uring_get_sqe failed\n",
+			       procid, opno);
+		goto uring_out;
+	}
+	lr = ((int64_t)random() << 32) + random();
+	len = (random() % FILELEN_MAX) + 1;
+	buf = malloc(len);
+	if (!buf) {
+		if (v)
+			printf("%d/%d: do_uring_rw - malloc failed\n",
+			       procid, opno);
+		goto uring_out;
+	}
+	iovec.iov_base = buf;
+	iovec.iov_len = len;
+	if (iswrite) {
+		off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
+		off %= maxfsize;
+		memset(buf, nameseq & 0xff, len);
+		io_uring_prep_writev(sqe, fd, &iovec, 1, off);
+	} else {
+		off = (off64_t)(lr % stb.st_size);
+		io_uring_prep_readv(sqe, fd, &iovec, 1, off);
+	}
+
+	if ((e = io_uring_submit_and_wait(&ring, 1)) != 1) {
+		if (v)
+			printf("%d/%d: %s - io_uring_submit failed %d\n", procid, opno,
+			       iswrite ? "uring_write" : "uring_read", e);
+		goto uring_out;
+	}
+	if ((e = io_uring_wait_cqe(&ring, &cqe)) < 0) {
+		if (v)
+			printf("%d/%d: %s - io_uring_wait_cqe failed %d\n", procid, opno,
+			       iswrite ? "uring_write" : "uring_read", e);
+		goto uring_out;
+	}
+	if (v)
+		printf("%d/%d: %s %s%s [%lld, %d(res=%d)] %d\n",
+		       procid, opno, iswrite ? "uring_write" : "uring_read",
+		       f.path, st, (long long)off, (int)len, cqe->res, e);
+	io_uring_cqe_seen(&ring, cqe);
+
+ uring_out:
+	if (buf)
+		free(buf);
+	if (fd > 0)
+		close(fd);
+	free_pathname(&f);
+}
+#endif
+
 void
 aread_f(int opno, long r)
 {
@@ -5044,6 +5165,22 @@ unresvsp_f(int opno, long r)
 	close(fd);
 }
 
+void
+uring_read_f(int opno, long r)
+{
+#ifdef URING
+	do_uring_rw(opno, r, O_RDONLY);
+#endif
+}
+
+void
+uring_write_f(int opno, long r)
+{
+#ifdef URING
+	do_uring_rw(opno, r, O_WRONLY);
+#endif
+}
+
 void
 write_f(int opno, long r)
 {
diff --git a/m4/Makefile b/m4/Makefile
index 7fbff822..0352534d 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -14,6 +14,7 @@ LSRCFILES = \
 	package_dmapidev.m4 \
 	package_globals.m4 \
 	package_libcdev.m4 \
+	package_liburing.m4 \
 	package_ncurses.m4 \
 	package_pthread.m4 \
 	package_ssldev.m4 \
diff --git a/m4/package_liburing.m4 b/m4/package_liburing.m4
new file mode 100644
index 00000000..c92cc02a
--- /dev/null
+++ b/m4/package_liburing.m4
@@ -0,0 +1,4 @@
+AC_DEFUN([AC_PACKAGE_WANT_URING],
+  [ AC_CHECK_HEADERS(liburing.h, [ have_uring=true ], [ have_uring=false ])
+    AC_SUBST(have_uring)
+  ])
-- 
2.20.1

