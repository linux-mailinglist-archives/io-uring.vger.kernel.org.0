Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE55643E92E
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 22:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhJ1UDd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 16:03:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43651 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230323AbhJ1UDb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 16:03:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635451264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a3N07SdqyFGpFYdIk2c0ScWTh+x70cCVMOCVAmGSQe8=;
        b=e5hbiXKi23JFS035kFNtiMyYGQKdkb31YeuET6zqMv9S4CPJpgGfytIYtP+iVhO5yrCz9x
        ZZv4DoX41+mkao8ei60m7PCExvudnQPHTT/tO42LMV9f7kfZM0LeFSsQ8SfRNVKCGQR0AN
        yCJxK4nNsbC363uRdMfJUDFxCqxko4o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-o44zzFB2N8CGbGp_HeWRuQ-1; Thu, 28 Oct 2021 16:01:02 -0400
X-MC-Unique: o44zzFB2N8CGbGp_HeWRuQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2448100C669
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 20:01:01 +0000 (UTC)
Received: from madcap2.tricolour.com (unknown [10.3.128.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89EBE380;
        Thu, 28 Oct 2021 20:01:00 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>
Cc:     io-uring@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH v3 4/7] add field support for the AUDIT_URINGOP record type
Date:   Thu, 28 Oct 2021 15:59:36 -0400
Message-Id: <20211028195939.3102767-5-rgb@redhat.com>
In-Reply-To: <20211028195939.3102767-1-rgb@redhat.com>
References: <20211028195939.3102767-1-rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Kernel support to audit io_uring operations was added with commit 5bd2182d58e9
("audit,io_uring,io-wq: add some basic audit support to io_uring").  Add
support to interpret the "uringop" record field.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 audisp/plugins/ids/model_behavior.c |  1 +
 auparse/auparse-defs.h              |  2 +-
 auparse/auparse-idata.h             |  1 +
 auparse/ellist.c                    |  7 +++++++
 auparse/interpret.c                 | 21 ++++++++++++++++++++-
 auparse/rnode.h                     |  1 +
 auparse/typetab.h                   |  1 +
 bindings/python/auparse_python.c    |  1 +
 contrib/plugin/audisp-example.c     |  1 +
 src/auditd-event.c                  |  1 +
 10 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/audisp/plugins/ids/model_behavior.c b/audisp/plugins/ids/model_behavior.c
index df94fcaf4b0e..09c7017569b9 100644
--- a/audisp/plugins/ids/model_behavior.c
+++ b/audisp/plugins/ids/model_behavior.c
@@ -80,6 +80,7 @@ void process_behavior_model(auparse_state_t *au, struct ids_conf *config)
 	/* Now we can branch based on what the first record type we find. */
 	switch (type) {
 		case AUDIT_SYSCALL:
+		case AUDIT_URINGOP:
 			process_plain_syscalls(au);
 			break;
 		//case SECCOMP:
diff --git a/auparse/auparse-defs.h b/auparse/auparse-defs.h
index 7c0ac76c84cc..7e17d3306b4e 100644
--- a/auparse/auparse-defs.h
+++ b/auparse/auparse-defs.h
@@ -88,7 +88,7 @@ typedef enum {  AUPARSE_TYPE_UNCLASSIFIED,  AUPARSE_TYPE_UID, AUPARSE_TYPE_GID,
 	AUPARSE_TYPE_NETACTION, AUPARSE_TYPE_MACPROTO,
 	AUPARSE_TYPE_IOCTL_REQ, AUPARSE_TYPE_ESCAPED_KEY,
 	AUPARSE_TYPE_ESCAPED_FILE, AUPARSE_TYPE_FANOTIFY,
-	AUPARSE_TYPE_NLMCGRP, AUPARSE_TYPE_RESOLVE
+	AUPARSE_TYPE_NLMCGRP, AUPARSE_TYPE_URINGOP, AUPARSE_TYPE_RESOLVE
 } auparse_type_t;
 
 /* This type determines what escaping if any gets applied to interpreted fields */
diff --git a/auparse/auparse-idata.h b/auparse/auparse-idata.h
index eaca86a3da24..42f65d35b65b 100644
--- a/auparse/auparse-idata.h
+++ b/auparse/auparse-idata.h
@@ -33,6 +33,7 @@ typedef struct _idata {
 	int syscall;		// The syscall for the event
 	unsigned long long a0;	// arg 0 to the syscall
 	unsigned long long a1;	// arg 1 to the syscall
+	int uringop;		// The uring op for the event
 	const char *cwd;	// The current working directory
 	const char *name;	// name of field being interpreted
 	const char *val;	// value of field being interpreted
diff --git a/auparse/ellist.c b/auparse/ellist.c
index ae85addbe52a..cac2a9f38d8e 100644
--- a/auparse/ellist.c
+++ b/auparse/ellist.c
@@ -278,6 +278,12 @@ static int parse_up_record(rnode* r)
 			} else if (r->type == AUDIT_CWD) {
 				if (strcmp(n.name, "cwd") == 0)
 					r->cwd = strdup(n.val);
+			} else if (r->nv.cnt == (3 + offset) &&
+					strcmp(n.name, "uringop") == 0){
+				errno = 0;
+				r->uringop = strtoul(n.val, NULL, 10);
+				if (errno)
+					r->uringop = -1;
 			}
 		} else if (r->type == AUDIT_AVC || r->type == AUDIT_USER_AVC) {
 			// We special case these 2 fields because selinux
@@ -362,6 +368,7 @@ int aup_list_append(event_list_t *l, char *record, int list_idx,
 	r->a1 = 0LL;
 	r->machine = -1;
 	r->syscall = -1;
+	r->uringop = -1;
 	r->item = l->cnt; 
 	r->list_idx = list_idx;
 	r->line_number = line_number;
diff --git a/auparse/interpret.c b/auparse/interpret.c
index 92b95b6a6dc8..8b5150638c4d 100644
--- a/auparse/interpret.c
+++ b/auparse/interpret.c
@@ -501,7 +501,7 @@ const char *_auparse_lookup_interpretation(const char *name)
 	if (nvlist_find_name(&il, name)) {
 		n = nvlist_get_cur(&il);
 		// This is only called from src/ausearch-lookup.c
-		// it only looks up auid and syscall. One needs
+		// it only looks up auid and syscall/uringop. One needs
 		// escape, the other does not.
 		if (strstr(name, "id"))
 			return print_escaped(n->interp_val);
@@ -817,6 +817,21 @@ static const char *print_syscall(const idata *id)
 	return out;
 }
 
+static const char *print_uringop(const idata *id)
+{
+	const char *uring;
+	char *out;
+	int uringop = id->uringop;
+
+	uring = audit_uringop_to_name(uringop);
+	if (uring) {
+		return strdup(uring);
+	}
+	if (asprintf(&out, "unknown-uringop(%d)", uringop) < 0)
+		out = NULL;
+	return out;
+}
+
 static const char *print_exit(const char *val)
 {
         long long ival;
@@ -3049,6 +3064,7 @@ const char *do_interpret(const rnode *r, auparse_esc_t escape_mode)
 
 	id.machine = r->machine;
 	id.syscall = r->syscall;
+	id.uringop = r->uringop;
 	id.a0 = r->a0;
 	id.a1 = r->a1;
 	id.cwd = r->cwd;
@@ -3164,6 +3180,9 @@ unknown:
 		case AUPARSE_TYPE_ARCH:
 			out = print_arch(id->val, id->machine);
 			break;
+		case AUPARSE_TYPE_URINGOP:
+			out = print_uringop(id);
+			break;
 		case AUPARSE_TYPE_EXIT:
 			out = print_exit(id->val);
 			break;
diff --git a/auparse/rnode.h b/auparse/rnode.h
index 69f084369523..69e89170cdf6 100644
--- a/auparse/rnode.h
+++ b/auparse/rnode.h
@@ -55,6 +55,7 @@ typedef struct _rnode{
 	int syscall;            // The syscall for the event
 	unsigned long long a0;  // arg 0 to the syscall
 	unsigned long long a1;  // arg 1 to the syscall
+	int uringop;            // The uring op for the event
 	nvlist nv;              // name-value linked list of parsed elements
 	unsigned int item;      // Which item of the same event
 	int list_idx;		// The index into the source list, points to where record was found
diff --git a/auparse/typetab.h b/auparse/typetab.h
index 4a3027957072..ced0ce47fcaf 100644
--- a/auparse/typetab.h
+++ b/auparse/typetab.h
@@ -44,6 +44,7 @@ _S(AUPARSE_TYPE_GID,		"igid"		)
 _S(AUPARSE_TYPE_GID,		"inode_gid"	)
 _S(AUPARSE_TYPE_GID,		"new_gid"	)
 _S(AUPARSE_TYPE_SYSCALL,	"syscall"	)
+_S(AUPARSE_TYPE_URINGOP,	"uringop"	)
 _S(AUPARSE_TYPE_ARCH,		"arch"		)
 _S(AUPARSE_TYPE_EXIT,		"exit"		)
 _S(AUPARSE_TYPE_ESCAPED,	"path"		)
diff --git a/bindings/python/auparse_python.c b/bindings/python/auparse_python.c
index 77dd8615cf50..f924fb269a53 100644
--- a/bindings/python/auparse_python.c
+++ b/bindings/python/auparse_python.c
@@ -2356,6 +2356,7 @@ initauparse(void)
     PyModule_AddIntConstant(m, "AUPARSE_TYPE_UID",     AUPARSE_TYPE_UID);
     PyModule_AddIntConstant(m, "AUPARSE_TYPE_GID",     AUPARSE_TYPE_GID);
     PyModule_AddIntConstant(m, "AUPARSE_TYPE_SYSCALL", AUPARSE_TYPE_SYSCALL);
+    PyModule_AddIntConstant(m, "AUPARSE_TYPE_URINGOP", AUPARSE_TYPE_URINGOP);
     PyModule_AddIntConstant(m, "AUPARSE_TYPE_ARCH",    AUPARSE_TYPE_ARCH);
     PyModule_AddIntConstant(m, "AUPARSE_TYPE_EXIT",    AUPARSE_TYPE_EXIT);
     PyModule_AddIntConstant(m, "AUPARSE_TYPE_ESCAPED", AUPARSE_TYPE_ESCAPED);
diff --git a/contrib/plugin/audisp-example.c b/contrib/plugin/audisp-example.c
index c523c0a19804..6907d2036fb7 100644
--- a/contrib/plugin/audisp-example.c
+++ b/contrib/plugin/audisp-example.c
@@ -225,6 +225,7 @@ static void handle_event(auparse_state_t *au,
 				dump_fields_of_record(au);
 				break;
 			case AUDIT_SYSCALL:
+			case AUDIT_URINGOP:
 				dump_whole_record(au); 
 				break;
 			case AUDIT_USER_LOGIN:
diff --git a/src/auditd-event.c b/src/auditd-event.c
index 788c44a08197..68369fae81ab 100644
--- a/src/auditd-event.c
+++ b/src/auditd-event.c
@@ -456,6 +456,7 @@ static const char *format_enrich(const struct audit_reply *rep)
 					len -= vlen;
 					break;
 				case AUPARSE_TYPE_SYSCALL:
+				case AUPARSE_TYPE_URINGOP:
 				case AUPARSE_TYPE_ARCH:
 				case AUPARSE_TYPE_SOCKADDR:
 					if (add_separator(len))
-- 
2.27.0

