Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6864743E933
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 22:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhJ1UDh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 16:03:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231124AbhJ1UDh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 16:03:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635451269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FHlERINM7qbwiA83+tfHfVb2caxladBhyV1rR/ArET8=;
        b=UQ45S637CwUeIQ/5S6HFnUXR/CQ3zQlwurj+Jbq3g3heUPsYEA1g3Yc+/+1cBpIbs70nBC
        dGW+UccXnmmFYeM9YzItnQdxqP/ABCzoyRfy8Ok+FYsKlB0TaGg3WRp8HiXSNrR83j3SmS
        Wm0sDnxqe4MbaiY3sgHQtcLHnAbTi9M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-OZ2mZb6kOdmaXasbozXtvA-1; Thu, 28 Oct 2021 16:01:07 -0400
X-MC-Unique: OZ2mZb6kOdmaXasbozXtvA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0C7F19200C0
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 20:01:06 +0000 (UTC)
Received: from madcap2.tricolour.com (unknown [10.3.128.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFB301A26A;
        Thu, 28 Oct 2021 20:01:01 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>
Cc:     io-uring@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH v3 5/7] add ausearch --uringop option
Date:   Thu, 28 Oct 2021 15:59:37 -0400
Message-Id: <20211028195939.3102767-6-rgb@redhat.com>
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
 docs/ausearch.8        |   3 +
 src/ausearch-common.h  |   1 +
 src/ausearch-llist.c   |   2 +
 src/ausearch-llist.h   |   1 +
 src/ausearch-lookup.c  |  25 +++++++++
 src/ausearch-lookup.h  |   1 +
 src/ausearch-match.c   |   6 +-
 src/ausearch-options.c |  36 +++++++++++-
 src/ausearch-parse.c   | 123 +++++++++++++++++++++++++++++++++++++++--
 src/ausearch-report.c  |  21 ++++++-
 10 files changed, 211 insertions(+), 8 deletions(-)

diff --git a/docs/ausearch.8 b/docs/ausearch.8
index dbd6beadeda4..e99911009053 100644
--- a/docs/ausearch.8
+++ b/docs/ausearch.8
@@ -130,6 +130,9 @@ Output is completely unformatted. This is useful for extracting records to a fil
 .BR \-sc ,\  \-\-syscall \ \fIsyscall-name-or-value\fP
 Search for an event matching the given \fIsyscall\fP. You may either give the numeric syscall value or the syscall name. If you give the syscall name, it will use the syscall table for the machine that you are using. 
 .TP
+.BR \-uo ,\  \-\-uringop \ \fIuringop-name-or-value\fP
+Search for an event matching the given \fIuring operation\fP. You may either give the numeric uring operation value or the uring operation name.
+.TP
 .BR \-se ,\  \-\-context \ \fISE-Linux-context-string\fP
 Search for event with either \fIscontext\fP/subject or \fItcontext\fP/object matching the string.
 .TP
diff --git a/src/ausearch-common.h b/src/ausearch-common.h
index 3040547afe95..f20e8570ce9b 100644
--- a/src/ausearch-common.h
+++ b/src/ausearch-common.h
@@ -56,6 +56,7 @@ extern const char *event_filename;
 extern const char *event_hostname;
 extern const char *event_terminal;
 extern int event_syscall;
+extern int event_uringop;
 extern int event_machine;
 extern const char *event_exe;
 extern int event_ua, event_ga;
diff --git a/src/ausearch-llist.c b/src/ausearch-llist.c
index ef5503c34fd9..98d446009865 100644
--- a/src/ausearch-llist.c
+++ b/src/ausearch-llist.c
@@ -59,6 +59,7 @@ void list_create(llist *l)
 	l->s.acct = NULL;
 	l->s.arch = 0;
 	l->s.syscall = 0;
+	l->s.uringop = 0;
 	l->s.session_id = -2;
 	l->s.uuid = NULL;
 	l->s.vmname = NULL;
@@ -210,6 +211,7 @@ void list_clear(llist* l)
 	l->s.acct = NULL;
 	l->s.arch = 0;
 	l->s.syscall = 0;
+	l->s.uringop = 0;
 	l->s.session_id = -2;
 	free(l->s.uuid);
 	l->s.uuid = NULL;
diff --git a/src/ausearch-llist.h b/src/ausearch-llist.h
index 56a2e7da4934..4ef60a0c93e5 100644
--- a/src/ausearch-llist.h
+++ b/src/ausearch-llist.h
@@ -55,6 +55,7 @@ typedef struct
   success_t success;    // success flag, 1 = yes, 0 = no, -1 = unset
   int arch;             // arch
   int syscall;          // syscall
+  int uringop;          // io_uring operation code
   uint32_t session_id;  // Login session id
   long long exit;       // Syscall exit code
   int exit_is_set;      // Syscall exit code is valid
diff --git a/src/ausearch-lookup.c b/src/ausearch-lookup.c
index dd58c36ad8bd..fdf036eccf37 100644
--- a/src/ausearch-lookup.c
+++ b/src/ausearch-lookup.c
@@ -109,6 +109,31 @@ const char *aulookup_syscall(llist *l, char *buf, size_t size)
 	return buf;
 }
 
+const char *aulookup_uringop(llist *l, char *buf, size_t size)
+{
+	const char *uringop;
+
+	if (report_format <= RPT_DEFAULT) {
+		snprintf(buf, size, "%d", l->s.uringop);
+		return buf;
+	}
+
+	uringop = _auparse_lookup_interpretation("uringop");
+	if (uringop) {
+		snprintf(buf, size, "%s", uringop);
+		free((void *)uringop);
+		return buf;
+	}
+
+	uringop = audit_uringop_to_name(l->s.uringop);
+	if (uringop) {
+		snprintf(buf, size, "%s", uringop);
+		return buf;
+	}
+	snprintf(buf, size, "%d", l->s.uringop);
+	return buf;
+}
+
 // See include/linux/net.h
 static struct nv_pair socktab[] = {
 	{SYS_SOCKET, "socket"},
diff --git a/src/ausearch-lookup.h b/src/ausearch-lookup.h
index d1c670147ecd..7f6a793738eb 100644
--- a/src/ausearch-lookup.h
+++ b/src/ausearch-lookup.h
@@ -35,6 +35,7 @@
 const char *aulookup_result(avc_t result);
 const char *aulookup_success(int s);
 const char *aulookup_syscall(llist *l, char *buf, size_t size);
+const char *aulookup_uringop(llist *l, char *buf, size_t size);
 const char *aulookup_uid(uid_t uid, char *buf, size_t size);
 void aulookup_destroy_uid_list(void);
 char *unescape(const char *buf);
diff --git a/src/ausearch-match.c b/src/ausearch-match.c
index 61a11d30a09b..ca3e56e2f4b5 100644
--- a/src/ausearch-match.c
+++ b/src/ausearch-match.c
@@ -45,7 +45,8 @@ static void load_interpretations(const llist *l)
 		return;
 
 	// If there is only 1 record load it, or load just the syscall one
-	if ((l->cnt == 1) || (l->head && l->head->type == AUDIT_SYSCALL))
+	if ((l->cnt == 1) || (l->head && l->head->type == AUDIT_SYSCALL) ||
+			     (l->head && l->head->type == AUDIT_URINGOP))
 		ausearch_load_interpretations(l->head);
 }
 
@@ -110,6 +111,9 @@ int match(llist *l)
 				if ((event_syscall != -1) && 
 					(event_syscall != l->s.syscall))
 						return 0;
+				if ((event_uringop != -1) &&
+					(event_uringop != l->s.uringop))
+						return 0;
 				if ((event_session_id != -2) &&
 					(event_session_id != l->s.session_id))
 					return 0;
diff --git a/src/ausearch-options.c b/src/ausearch-options.c
index a57de79b183b..ab9748f9f95e 100644
--- a/src/ausearch-options.c
+++ b/src/ausearch-options.c
@@ -56,7 +56,7 @@ auparse_esc_t escape_mode = AUPARSE_ESC_TTY;
 int event_exact_match = 0;
 uid_t event_uid = -1, event_euid = -1, event_loginuid = -2;
 const char *event_tuid = NULL, *event_teuid = NULL, *event_tauid = NULL;
-int event_syscall = -1, event_machine = -1;
+int event_syscall = -1, event_machine = -1, event_uringop = -1;
 int event_ua = 0, event_ga = 0, event_se = 0;
 int just_one = 0;
 uint32_t event_session_id = -2;
@@ -93,7 +93,8 @@ S_TIME_END, S_TIME_START, S_TERMINAL, S_ALL_UID, S_EFF_UID, S_UID, S_LOGINID,
 S_VERSION, S_EXACT_MATCH, S_EXECUTABLE, S_CONTEXT, S_SUBJECT, S_OBJECT,
 S_PPID, S_KEY, S_RAW, S_NODE, S_IN_LOGS, S_JUST_ONE, S_SESSION, S_EXIT,
 S_LINEBUFFERED, S_UUID, S_VMNAME, S_DEBUG, S_CHECKPOINT, S_ARCH, S_FORMAT,
-S_EXTRA_TIME, S_EXTRA_LABELS, S_EXTRA_KEYS, S_EXTRA_OBJ2, S_ESCAPE, S_EOE_TMO };
+S_EXTRA_TIME, S_EXTRA_LABELS, S_EXTRA_KEYS, S_EXTRA_OBJ2, S_ESCAPE, S_EOE_TMO,
+S_URINGOP };
 
 static struct nv_pair optiontab[] = {
 	{ S_EVENT, "-a" },
@@ -148,6 +149,8 @@ static struct nv_pair optiontab[] = {
 	{ S_RAW, "--raw" },
 	{ S_SYSCALL, "-sc" },
 	{ S_SYSCALL, "--syscall" },
+	{ S_URINGOP, "-uo" },
+	{ S_URINGOP, "--uringop" },
 	{ S_CONTEXT, "-se" },
 	{ S_CONTEXT, "--context" },
 	{ S_SESSION, "--session" },
@@ -239,6 +242,7 @@ static void usage(void)
 	"\t-ue,--uid-effective <effective User id>  search based on Effective\n\t\t\t\t\tuser id\n"
 	"\t-ui,--uid <User Id>\t\tsearch based on user id\n"
 	"\t-ul,--loginuid <login id>\tsearch based on the User's Login id\n"
+	"\t-uo,--uringop <SysCall name>\tsearch based on syscall name or number\n"
 	"\t-uu,--uuid <guest UUID>\t\tsearch for events related to the virtual\n"
 	"\t\t\t\t\tmachine with the given UUID.\n"
 	"\t-v,--version\t\t\tversion\n"
@@ -826,6 +830,34 @@ int check_params(int count, char *vars[])
                         }
 			c++;
 			break;
+		case S_URINGOP:
+			if (!optarg) {
+				fprintf(stderr,
+					"Argument is required for %s\n",
+					vars[c]);
+				retval = -1;
+				break;
+			}
+			if (isdigit(optarg[0])) {
+				errno = 0;
+				event_uringop = (int)strtoul(optarg, NULL, 10);
+				if (errno) {
+					fprintf(stderr,
+			"Uring operation numeric conversion error (%s) for %s\n",
+						strerror(errno), optarg);
+					retval = -1;
+				}
+			} else {
+				event_uringop = audit_name_to_uringop(optarg);
+				if (event_uringop == -1) {
+					fprintf(stderr,
+						"Uring operation %s not found\n",
+						optarg);
+					retval = -1;
+				}
+			}
+			c++;
+			break;
 		case S_CONTEXT:
 			if (!optarg) {
 				fprintf(stderr, 
diff --git a/src/ausearch-parse.c b/src/ausearch-parse.c
index 39fb7cf51be0..4c6b3c954178 100644
--- a/src/ausearch-parse.c
+++ b/src/ausearch-parse.c
@@ -46,6 +46,7 @@ static const char key_sep[2] = { AUDIT_KEY_SEPARATOR, 0 };
 
 static int parse_task_info(lnode *n, search_items *s);
 static int parse_syscall(lnode *n, search_items *s);
+static int parse_uringop(lnode *n, search_items *s);
 static int parse_dir(const lnode *n, search_items *s);
 static int common_path_parser(search_items *s, char *path);
 static int avc_parse_path(const lnode *n, search_items *s);
@@ -94,6 +95,9 @@ int extract_search_items(llist *l)
 			case AUDIT_SYSCALL:
 				ret = parse_syscall(n, s);
 				break;
+			case AUDIT_URINGOP:
+				ret = parse_uringop(n, s);
+				break;
 			case AUDIT_CWD:
 				ret = parse_dir(n, s);
 				break;
@@ -384,7 +388,7 @@ try_again:
 		*term = ' ';
 	}
 
-	if (event_terminal) {
+	if (event_terminal && !s->uringop) {
 		// dont do this search unless needed
 		str = strstr(term, "tty=");
 		if (str) {
@@ -416,7 +420,7 @@ try_again:
 		}
 	}
 
-	if (event_comm) {
+	if (event_comm && !s->uringop) {
 		// dont do this search unless needed
 		str = strstr(term, "comm=");
 		if (str) {
@@ -439,7 +443,7 @@ try_again:
 		} else
 			return 38;
 	}
-	if (event_exe) {
+	if (event_exe && !s->uringop) {
 		// dont do this search unless needed
 		str = strstr(n->message, "exe=");
 		if (str) {
@@ -480,7 +484,7 @@ try_again:
 		}
 	}
 	// success
-	if (event_success != S_UNSET) {
+	if (event_success != S_UNSET && !s->uringop) {
 		if (term == NULL)
 			term = n->message;
 		str = strstr(term, "res=");
@@ -602,6 +606,117 @@ static int parse_syscall(lnode *n, search_items *s)
 		return 13;
 	*term = ' ';
 
+	ret = parse_task_info(n, s);
+	if (ret)
+		return ret;
+
+	if (event_key) {
+		str = strstr(term, "key=");
+		if (str) {
+			if (!s->key) {
+				//create
+				s->key = malloc(sizeof(slist));
+				if (s->key == NULL)
+					return 43;
+				slist_create(s->key);
+			}
+			str += 4;
+			if (*str == '"') {
+				str++;
+				term = strchr(str, '"');
+				if (term == NULL)
+					return 44;
+				*term = 0;
+				if (s->key) {
+					// append
+					snode sn;
+					sn.str = strdup(str);
+					sn.key = NULL;
+					sn.hits = 1;
+					slist_append(s->key, &sn);
+				}
+				*term = '"';
+			} else {
+				if (s->key) {
+					char *saved;
+					char *keyptr = unescape(str);
+					if (keyptr == NULL)
+						return 45;
+					char *kptr = strtok_r(keyptr,
+							key_sep, &saved);
+					while (kptr) {
+						snode sn;
+						// append
+						sn.str = strdup(kptr);
+						sn.key = NULL;
+						sn.hits = 1;
+						slist_append(s->key, &sn);
+						kptr = strtok_r(NULL,
+							key_sep, &saved);
+					}
+					free(keyptr);
+
+				}
+			}
+		}
+	}
+	return 0;
+}
+
+static int parse_uringop(lnode *n, search_items *s)
+{
+	char *ptr, *str, *term;
+	extern int event_machine;
+	int ret;
+
+	term = n->message;
+	// get uring_op
+	str = strstr(term, "uring_op=");
+	if (str == NULL)
+		return 4;
+	ptr = str + 9;
+	term = strchr(ptr, ' ');
+	if (term == NULL)
+		return 5;
+	*term = 0;
+	errno = 0;
+	s->uringop = (int)strtoul(ptr, NULL, 10);
+	if (errno)
+		return 6;
+	*term = ' ';
+	// get success
+	if (event_success != S_UNSET) {
+		str = strstr(term, "success=");
+		if (str) { // exit_group does not set success !?!
+			ptr = str + 8;
+			term = strchr(ptr, ' ');
+			if (term == NULL)
+				return 7;
+			*term = 0;
+			if (strcmp(ptr, "yes") == 0)
+				s->success = S_SUCCESS;
+			else
+				s->success = S_FAILED;
+			*term = ' ';
+		}
+	}
+	// get exit
+	if (event_exit_is_set) {
+		str = strstr(term, "exit=");
+		if (str == NULL)
+			return 8;
+		ptr = str + 5;
+		term = strchr(ptr, ' ');
+		if (term == NULL)
+			return 9;
+		*term = 0;
+		errno = 0;
+		s->exit = strtoll(ptr, NULL, 0);
+		if (errno)
+			return 10;
+		s->exit_is_set = 1;
+		*term = ' ';
+	}
 	ret = parse_task_info(n, s);
 	if (ret)
 		return ret;
diff --git a/src/ausearch-report.c b/src/ausearch-report.c
index 9f91f9c864e0..733852e5c9e3 100644
--- a/src/ausearch-report.c
+++ b/src/ausearch-report.c
@@ -52,6 +52,7 @@ extern time_t lol_get_eoe_timeout(void);
 /* The machine based on elf type */
 static unsigned long machine = -1;
 static int cur_syscall = -1;
+static int cur_uringop = -1;
 
 /* The first syscall argument */
 static unsigned long long a0, a1;
@@ -185,6 +186,7 @@ static void output_interpreted_record(const lnode *n, const event *e)
 	// Reset these because each record could be different
 	machine = -1;
 	cur_syscall = -1;
+	cur_uringop = -1;
 
 	/* Check and see if we start with a node
  	 * If we do, and there is a space in the line
@@ -368,8 +370,25 @@ static void report_interpret(char *name, char *val, int comma, int rtype)
 			cur_syscall = ival;
 		}
 		id.syscall = cur_syscall;
-	} else
+		id.uringop = 0;
+	} else if (rtype == AUDIT_URINGOP) {
+		if (cur_uringop < 0 && *name == 'u' &&
+				strcmp(name, "uringop") == 0) {
+			unsigned long ival;
+			errno = 0;
+			ival = strtoul(val, NULL, 10);
+			if (errno) {
+				printf("uring op conversion error(%s) ", val);
+				return;
+			}
+			cur_uringop = ival;
+		}
+		id.uringop = cur_uringop;
 		id.syscall = 0;
+	} else {
+		id.syscall = 0;
+		id.uringop = 0;
+	}
 	id.machine = machine;
 	id.a0 = a0;
 	id.a1 = a1;
-- 
2.27.0

