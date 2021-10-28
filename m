Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C5543E92F
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 22:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhJ1UDd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 16:03:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31605 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230460AbhJ1UDb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 16:03:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635451262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vYY0Sn5F1kczc7fQXEt/YWi2gSzo4ORIiG4eYh27afI=;
        b=LC+9ubIEVWkY0xPFNIyTK32EOmxgra8eVhNiMczhsgMOAfdf3K9QNLzsGV0elon+P5LqMJ
        qGqPsQgVrjfijW5DQXhfyJNVU7Nbr4w0bid4SwPZp0gMxxu166X/7ZHHO/UwabQbUVhAe4
        0H8+DhYAV2ipluhC1Oc4rJGL39dB+lc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-F5UsboiYOVu-OOr72xNkgw-1; Thu, 28 Oct 2021 16:01:01 -0400
X-MC-Unique: F5UsboiYOVu-OOr72xNkgw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F0B4A40C1
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 20:01:00 +0000 (UTC)
Received: from madcap2.tricolour.com (unknown [10.3.128.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F5AC380;
        Thu, 28 Oct 2021 20:00:58 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>
Cc:     io-uring@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH v3 3/7] add support for uringop names
Date:   Thu, 28 Oct 2021 15:59:35 -0400
Message-Id: <20211028195939.3102767-4-rgb@redhat.com>
In-Reply-To: <20211028195939.3102767-1-rgb@redhat.com>
References: <20211028195939.3102767-1-rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 lib/Makefile.am        | 17 ++++++++++--
 lib/lookup_table.c     |  5 ++--
 lib/test/lookup_test.c | 17 ++++++++++++
 lib/uringop_table.h    | 62 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 97 insertions(+), 4 deletions(-)
 create mode 100644 lib/uringop_table.h

diff --git a/lib/Makefile.am b/lib/Makefile.am
index f1107afabee6..7926ba50a78f 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -47,7 +47,7 @@ nodist_libaudit_la_SOURCES = $(BUILT_SOURCES)
 BUILT_SOURCES = actiontabs.h errtabs.h fieldtabs.h flagtabs.h \
 	fstypetabs.h ftypetabs.h i386_tables.h machinetabs.h \
 	msg_typetabs.h optabs.h ppc_tables.h s390_tables.h \
-	s390x_tables.h x86_64_tables.h
+	s390x_tables.h x86_64_tables.h uringop_tables.h
 if USE_ARM
 BUILT_SOURCES += arm_tables.h
 endif
@@ -58,7 +58,7 @@ noinst_PROGRAMS = gen_actiontabs_h gen_errtabs_h gen_fieldtabs_h \
 	gen_flagtabs_h gen_fstypetabs_h gen_ftypetabs_h gen_i386_tables_h \
 	gen_machinetabs_h gen_msg_typetabs_h \
 	gen_optabs_h gen_ppc_tables_h gen_s390_tables_h \
-	gen_s390x_tables_h gen_x86_64_tables_h
+	gen_s390x_tables_h gen_x86_64_tables_h gen_uringop_tables_h
 if USE_ARM
 noinst_PROGRAMS += gen_arm_tables_h
 endif
@@ -266,6 +266,19 @@ gen_s390x_tables_h$(BUILD_EXEEXT): LDFLAGS=$(LDFLAGS_FOR_BUILD)
 s390x_tables.h: gen_s390x_tables_h Makefile
 	./gen_s390x_tables_h --lowercase --i2s --s2i s390x_syscall > $@
 
+gen_uringop_tables_h_SOURCES = gen_tables.c gen_tables.h uringop_table.h
+gen_uringop_tables_h_CFLAGS = '-DTABLE_H="uringop_table.h"'
+$(gen_uringop_tables_h_OBJECTS): CC=$(CC_FOR_BUILD)
+$(gen_uringop_tables_h_OBJECTS): CFLAGS=$(CFLAGS_FOR_BUILD)
+$(gen_uringop_tables_h_OBJECTS): CPPFLAGS=$(CPPFLAGS_FOR_BUILD)
+$(gen_uringop_tables_h_OBJECTS): LDFLAGS=$(LDFLAGS_FOR_BUILD)
+gen_uringop_tables_h$(BUILD_EXEEXT): CC=$(CC_FOR_BUILD)
+gen_uringop_tables_h$(BUILD_EXEEXT): CFLAGS=$(CFLAGS_FOR_BUILD)
+gen_uringop_tables_h$(BUILD_EXEEXT): CPPFLAGS=$(CPPFLAGS_FOR_BUILD)
+gen_uringop_tables_h$(BUILD_EXEEXT): LDFLAGS=$(LDFLAGS_FOR_BUILD)
+uringop_tables.h: gen_uringop_tables_h Makefile
+	./gen_uringop_tables_h --lowercase --i2s --s2i uringop > $@
+
 gen_x86_64_tables_h_SOURCES = gen_tables.c gen_tables.h x86_64_table.h
 gen_x86_64_tables_h_CFLAGS = '-DTABLE_H="x86_64_table.h"'
 $(gen_x86_64_tables_h_OBJECTS): CC=$(CC_FOR_BUILD)
diff --git a/lib/lookup_table.c b/lib/lookup_table.c
index ca619fba930d..d895b1ffe530 100644
--- a/lib/lookup_table.c
+++ b/lib/lookup_table.c
@@ -46,6 +46,7 @@
 #include "s390_tables.h"
 #include "s390x_tables.h"
 #include "x86_64_tables.h"
+#include "uringop_tables.h"
 #include "errtabs.h"
 #include "fstypetabs.h"
 #include "ftypetabs.h"
@@ -147,7 +148,7 @@ int audit_name_to_uringop(const char *uringop)
 	int res = -1, found = 0;
 
 #ifndef NO_TABLES
-	//found = uringop_s2i(uringop, &res);
+	found = uringop_s2i(uringop, &res);
 #endif
 	if (found)
 		return res;
@@ -187,7 +188,7 @@ const char *audit_syscall_to_name(int sc, int machine)
 const char *audit_uringop_to_name(int uringop)
 {
 #ifndef NO_TABLES
-	//return uringop_i2s(uringop);
+	return uringop_i2s(uringop);
 #endif
 	return NULL;
 }
diff --git a/lib/test/lookup_test.c b/lib/test/lookup_test.c
index 03f40aaf0899..f58d9dde65dd 100644
--- a/lib/test/lookup_test.c
+++ b/lib/test/lookup_test.c
@@ -234,6 +234,22 @@ test_x86_64_table(void)
 #undef S2I
 }
 
+static void
+test_uringop_table(void)
+{
+	static const struct entry t[] = {
+#include "../uringop_table.h"
+	};
+
+	printf("Testing uringop_table...\n");
+#define I2S(I) audit_uringop_to_name((I))
+#define S2I(S) audit_name_to_uringop((S))
+	TEST_I2S(0);
+	TEST_S2I(-1);
+#undef I2S
+#undef S2I
+}
+
 static void
 test_actiontab(void)
 {
@@ -395,6 +411,7 @@ main(void)
 	test_s390_table();
 	test_s390x_table();
 	test_x86_64_table();
+	test_uringop_table();
 	test_actiontab();
 	test_errtab();
 	test_fieldtab();
diff --git a/lib/uringop_table.h b/lib/uringop_table.h
new file mode 100644
index 000000000000..241828efc654
--- /dev/null
+++ b/lib/uringop_table.h
@@ -0,0 +1,62 @@
+/* uringop_table.h --
+ * Copyright 2005-21 Red Hat Inc.
+ * All Rights Reserved.
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation; either
+ * version 2.1 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this library; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * Authors:
+ *      Richard Guy Briggs <rgb@redhat.com>
+ */
+
+/* from /usr/include/linux/io_uring.h */
+
+_S(0,	"nop")
+_S(1,	"readv")
+_S(2,	"writev")
+_S(3,	"fsync")
+_S(4,	"read_fixed")
+_S(5,	"write_fixed")
+_S(6,	"poll_add")
+_S(7,	"poll_remove")
+_S(8,	"sync_file_range")
+_S(9,	"sendmsg")
+_S(10,	"recvmsg")
+_S(11,	"timeout")
+_S(12,	"timeout_remove")
+_S(13,	"accept")
+_S(14,	"async_cancel")
+_S(15,	"link_timeout")
+_S(16,	"connect")
+_S(17,	"fallocate")
+_S(18,	"openat")
+_S(19,	"close")
+_S(20,	"files_update")
+_S(21,	"statx")
+_S(22,	"read")
+_S(23,	"write")
+_S(24,	"fadvise")
+_S(25,	"madvise")
+_S(26,	"send")
+_S(27,	"recv")
+_S(28,	"openat2")
+_S(29,	"epoll_ctl")
+_S(30,	"splice")
+_S(31,	"provide_bufers")
+_S(32,	"remove_bufers")
+_S(33,	"tee")
+_S(34,	"shutdown")
+_S(35,	"renameat")
+_S(36,	"unlinkat")
+
-- 
2.27.0

