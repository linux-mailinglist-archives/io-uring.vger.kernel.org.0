Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4F826CA35
	for <lists+io-uring@lfdr.de>; Wed, 16 Sep 2020 21:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgIPTvx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Sep 2020 15:51:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35918 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727207AbgIPRhd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Sep 2020 13:37:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600277848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y180oUkejY14cXgK4vjnfdc8RXLi2L7JY7EbjdRpGtM=;
        b=BFsrXVtTkINbB08j+jdnEROTDs+4Fxx/ja/d4sKhJamDHfRV2wPy5KsiXegR4/Wre6tim0
        Gm6AniZNde/2UBG9PNjMUBP2mlE1yXNbJsZ+v0h9vLErVrdW2AWHMpqta31nbChNbinvj2
        qFjs6/gN0SX+Q35lY6GUwntd589tHnQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-CmdiD0hSOU-DVdBXjE3LdQ-1; Wed, 16 Sep 2020 09:11:49 -0400
X-MC-Unique: CmdiD0hSOU-DVdBXjE3LdQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5333918C89C1;
        Wed, 16 Sep 2020 13:11:48 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-13-242.pek2.redhat.com [10.72.13.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E35819D6C;
        Wed, 16 Sep 2020 13:11:46 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 1/3] src/feature: add IO_URING feature checking
Date:   Wed, 16 Sep 2020 21:11:37 +0800
Message-Id: <20200916131139.11497-2-zlang@redhat.com>
In-Reply-To: <20200916131139.11497-1-zlang@redhat.com>
References: <20200916131139.11497-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IO_URING is a new feature for GNU/Linux system, if someone case of
xfstests tests this feature, better to check if current system
supports it, or need _notrun.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 src/Makefile  |  4 ++++
 src/feature.c | 41 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/src/Makefile b/src/Makefile
index 643c1916..f1422c5c 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -65,6 +65,10 @@ SUBDIRS += aio-dio-regress
 LLDLIBS += -laio
 endif
 
+ifeq ($(HAVE_URING), true)
+LLDLIBS += -luring
+endif
+
 CFILES = $(TARGETS:=.c)
 LDIRT = $(TARGETS) fssum
 
diff --git a/src/feature.c b/src/feature.c
index a7eb7595..df550cf6 100644
--- a/src/feature.c
+++ b/src/feature.c
@@ -19,6 +19,7 @@
  *
  * Test for machine features
  *   -A  test whether AIO syscalls are available
+ *   -R  test whether IO_URING syscalls are available
  *   -o  report a number of online cpus
  *   -s  report pagesize
  *   -w  report bits per long
@@ -39,6 +40,10 @@
 #include <libaio.h>
 #endif
 
+#ifdef HAVE_LIBURING_H
+#include <liburing.h>
+#endif
+
 #ifndef USRQUOTA
 #define USRQUOTA  0
 #endif
@@ -59,7 +64,7 @@ usage(void)
 	fprintf(stderr, "Usage: feature [-v] -<q|u|g|p|U|G|P> <filesystem>\n");
 	fprintf(stderr, "       feature [-v] -c <file>\n");
 	fprintf(stderr, "       feature [-v] -t <file>\n");
-	fprintf(stderr, "       feature -A | -o | -s | -w\n");
+	fprintf(stderr, "       feature -A | -R | -o | -s | -w\n");
 	exit(1);
 }
 
@@ -215,6 +220,29 @@ check_aio_support(void)
 #endif
 }
 
+static int
+check_uring_support(void)
+{
+#ifdef HAVE_LIBURING_H
+	struct io_uring ring;
+	int err;
+
+	err = io_uring_queue_init(1, &ring, 0);
+	if (err == 0)
+		return 0;
+
+	if (err == -ENOSYS) /* CONFIG_IO_URING=n */
+		return 1;
+
+	fprintf(stderr, "unexpected error from io_uring_queue_init(): %s\n",
+		strerror(-err));
+	return 2;
+#else
+	/* liburing is unavailable, assume IO_URING is unsupported */
+	return 1;
+#endif
+}
+
 
 int
 main(int argc, char **argv)
@@ -228,6 +256,7 @@ main(int argc, char **argv)
 	int	pflag = 0;
 	int	Pflag = 0;
 	int	qflag = 0;
+	int	Rflag = 0;
 	int	sflag = 0;
 	int	uflag = 0;
 	int	Uflag = 0;
@@ -235,7 +264,7 @@ main(int argc, char **argv)
 	int	oflag = 0;
 	char	*fs = NULL;
 
-	while ((c = getopt(argc, argv, "ActgGopPqsuUvw")) != EOF) {
+	while ((c = getopt(argc, argv, "ActgGopPqRsuUvw")) != EOF) {
 		switch (c) {
 		case 'A':
 			Aflag++;
@@ -264,6 +293,9 @@ main(int argc, char **argv)
 		case 'q':
 			qflag++;
 			break;
+		case 'R':
+			Rflag++;
+			break;
 		case 's':
 			sflag++;
 			break;
@@ -289,7 +321,7 @@ main(int argc, char **argv)
 		if (optind != argc-1)	/* need a device */
 			usage();
 		fs = argv[argc-1];
-	} else if (Aflag || wflag || sflag || oflag) {
+	} else if (Aflag || Rflag || wflag || sflag || oflag) {
 		if (optind != argc)
 			usage();
 	} else 
@@ -317,6 +349,9 @@ main(int argc, char **argv)
 	if (Aflag)
 		return(check_aio_support());
 
+	if (Rflag)
+		return(check_uring_support());
+
 	if (sflag) {
 		printf("%d\n", getpagesize());
 		exit(0);
-- 
2.20.1

