Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBEE43E935
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 22:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhJ1UDu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 16:03:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35672 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230526AbhJ1UDt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 16:03:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635451281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k4a4sKVbreCsm+hEoFDc/PGbtLVBDVWExmY4+0Om6m8=;
        b=bPzFcC6/QNHwVxvuLzpn7kgU/GbhXAVt4ZOd3HhSg71vpq7pql83h7epA2C3En8rlqQpZG
        WCfIK2aLJwzUxCRVOZEJVM2bS0RwyvHX+RPWuAAPN5m6WYHcX7d1LqMLJ9jZEsV/eFRjDH
        kLxl5NQ+DUv0dswkQAqOz6fywbjDfbQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-0XHyW5vPOu6ylgeqmyhe5w-1; Thu, 28 Oct 2021 16:01:19 -0400
X-MC-Unique: 0XHyW5vPOu6ylgeqmyhe5w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DCA3802B4F
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 20:01:19 +0000 (UTC)
Received: from madcap2.tricolour.com (unknown [10.3.128.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4570E26379;
        Thu, 28 Oct 2021 20:01:07 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>
Cc:     io-uring@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH v3 6/7] add aureport --uringop option
Date:   Thu, 28 Oct 2021 15:59:38 -0400
Message-Id: <20211028195939.3102767-7-rgb@redhat.com>
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
 docs/aureport.8        |  3 +++
 src/aureport-options.c | 19 ++++++++++++++++++-
 src/aureport-options.h |  2 +-
 src/aureport-output.c  | 37 +++++++++++++++++++++++++++++++++++++
 src/aureport-scan.c    | 26 ++++++++++++++++++++++++++
 src/aureport-scan.h    |  2 ++
 src/aureport.c         |  3 ++-
 7 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/docs/aureport.8 b/docs/aureport.8
index c4ceb09e2f7d..187fd495bea7 100644
--- a/docs/aureport.8
+++ b/docs/aureport.8
@@ -90,6 +90,9 @@ Report about responses to anomaly events
 .BR \-s ,\  \-\-syscall
 Report about syscalls
 .TP
+.BR \-U ,\  \-\-uringop
+Report about uringops
+.TP
 .B \-\-success
 Only select successful events for processing in the reports. The default is both success and failed events.
 .TP
diff --git a/src/aureport-options.c b/src/aureport-options.c
index 93621e250630..b8ab55192d08 100644
--- a/src/aureport-options.c
+++ b/src/aureport-options.c
@@ -83,7 +83,7 @@ struct nv_pair {
 
 enum {  R_INFILE, R_TIME_END, R_TIME_START, R_VERSION, R_SUMMARY, R_LOG_TIMES,
 	R_CONFIGS, R_LOGINS, R_USERS, R_TERMINALS, R_HOSTS, R_EXES, R_FILES,
-	R_AVCS, R_SYSCALLS, R_PIDS, R_EVENTS, R_ACCT_MODS,  
+	R_AVCS, R_SYSCALLS, R_URINGOPS, R_PIDS, R_EVENTS, R_ACCT_MODS,
 	R_INTERPRET, R_HELP, R_ANOMALY, R_RESPONSE, R_SUMMARY_DET, R_CRYPTO,
 	R_MAC, R_FAILED, R_SUCCESS, R_ADD, R_DEL, R_AUTH, R_NODE, R_IN_LOGS,
 	R_KEYS, R_TTY, R_NO_CONFIG, R_COMM, R_VIRT, R_INTEG, R_ESCAPE,
@@ -148,6 +148,8 @@ static struct nv_pair optiontab[] = {
 	{ R_TIME_START, "-ts" },
 	{ R_TTY, "--tty" },
 	{ R_TIME_START, "--start" },
+	{ R_URINGOPS, "-U" },
+	{ R_URINGOPS, "--uringop" },
 	{ R_USERS, "-u" },
 	{ R_USERS, "--user" },
 	{ R_VERSION, "-v" },
@@ -206,6 +208,7 @@ static void usage(void)
 	"\t-tm,--terminal\t\t\tTerMinal name report\n"
 	"\t-ts,--start [start date] [start time]\tstarting data & time for reports\n"
 	"\t--tty\t\t\t\tReport about tty keystrokes\n"
+	"\t-U,--uringop\t\t\tUring op report\n"
 	"\t-u,--user\t\t\tUser name report\n"
 	"\t-v,--version\t\t\tVersion\n"
 	"\t--virt\t\t\t\tVirtualization report\n"
@@ -485,6 +488,20 @@ int check_params(int count, char *vars[])
 				}
 			}
 			break;
+		case R_URINGOPS:
+			if (set_report(RPT_URINGOP))
+				retval = -1;
+			else {
+				if (!optarg) {
+					set_detail(D_DETAILED);
+					event_comm = dummy;
+					event_loginuid = 1;
+					event_tauid = dummy;
+				} else {
+					UNIMPLEMENTED;
+				}
+			}
+			break;
 		case R_USERS:
 			if (set_report(RPT_USER))
 				retval = -1;
diff --git a/src/aureport-options.h b/src/aureport-options.h
index a559f64546be..5d9ac2ba5dbf 100644
--- a/src/aureport-options.h
+++ b/src/aureport-options.h
@@ -36,7 +36,7 @@ typedef enum { RPT_UNSET, RPT_TIME, RPT_SUMMARY, RPT_AVC, RPT_MAC,
 	RPT_ACCT_MOD, RPT_PID, RPT_SYSCALL, RPT_TERM, RPT_USER,
 	RPT_EXE, RPT_ANOMALY, RPT_RESPONSE, RPT_CRYPTO, 
 	RPT_AUTH, RPT_KEY, RPT_TTY, RPT_COMM, RPT_VIRT,
-	RPT_INTEG } report_type_t;
+	RPT_INTEG, RPT_URINGOP } report_type_t;
 
 typedef enum { D_UNSET, D_SUM, D_DETAILED, D_SPECIFIC } report_det_t;
 
diff --git a/src/aureport-output.c b/src/aureport-output.c
index a635d536f8b3..7e92c5fab1a5 100644
--- a/src/aureport-output.c
+++ b/src/aureport-output.c
@@ -160,6 +160,12 @@ static void print_title_summary(void)
 			printf("total  terminal\n");
 			printf("===============================\n");
 			break;
+		case RPT_URINGOP:
+			printf("IO URING ops Summary Report\n");
+			printf("==========================\n");
+			printf("total  uringop\n");
+			printf("==========================\n");
+			break;
 		case RPT_USER:
 			printf("User Summary Report\n");
 			printf("===========================\n");
@@ -338,6 +344,21 @@ static void print_title_detailed(void)
 				printf("========================\n");
 			}
 			break;
+		case RPT_URINGOP:
+			if (report_detail == D_DETAILED) {
+				printf("URING op Report\n");
+				printf(
+				  "=======================================\n");
+				printf(
+				  //"# date time uringop pid comm auid event\n");
+				  "# date time syscall pid auid event\n");
+				printf(
+				  "=======================================\n");
+			} else {
+				printf("Specific Uring op Report\n");
+				printf("=======================\n");
+			}
+			break;
 		case RPT_USER:
 			if (report_detail == D_DETAILED) {
 				printf("User ID Report\n");
@@ -636,6 +657,17 @@ void print_per_event_item(llist *l)
 				sizeof(name)), 0);
 			printf(" %lu\n", l->e.serial);
 			break;
+		case RPT_URINGOP:	// report_detail == D_DETAILED
+			// uringop, pid, comm, who, event
+			// uringop, pid, who, event
+			printf("%s %u ", aulookup_uringop(l,buf,sizeof(buf)),
+				l->s.pid);
+			//safe_print_string(l->s.comm ? l->s.comm : "?", 0);
+			//putchar(' ');
+			safe_print_string(aulookup_uid(l->s.loginuid, name,
+				sizeof(name)), 0);
+			printf(" %lu\n", l->e.serial);
+			break;
 		case RPT_USER:	// report_detail == D_DETAILED
 			// who, terminal, host, exe, event
 			safe_print_string(aulookup_uid(l->s.loginuid, name,
@@ -807,6 +839,10 @@ void print_wrap_up(void)
 			slist_sort_by_hits(&sd.terms);
 			do_string_summary_output(&sd.terms);
 			break;
+		case RPT_URINGOP:
+			slist_sort_by_hits(&sd.uringop_list);
+			do_syscall_summary_output(&sd.uringop_list);
+			break;
 		case RPT_USER:
 			slist_sort_by_hits(&sd.users);
 			do_user_summary_output(&sd.users);
@@ -918,6 +954,7 @@ static void do_summary_output(void)
 	printf("Number of AVC's: %lu\n", sd.avcs);
 	printf("Number of MAC events: %lu\n", sd.mac);
 	printf("Number of failed syscalls: %lu\n", sd.failed_syscalls);
+	printf("Number of failed uring ops: %lu\n", sd.failed_uringops);
 	printf("Number of anomaly events: %lu\n", sd.anomalies);
 	printf("Number of responses to anomaly events: %lu\n", sd.responses);
 	printf("Number of crypto events: %lu\n", sd.crypto);
diff --git a/src/aureport-scan.c b/src/aureport-scan.c
index 4095e8686a05..5b2d81047e1d 100644
--- a/src/aureport-scan.c
+++ b/src/aureport-scan.c
@@ -53,6 +53,7 @@ void reset_counters(void)
 	sd.avcs = 0UL;
 	sd.mac = 0UL;
 	sd.failed_syscalls = 0UL;
+	sd.failed_uringops = 0UL;
 	sd.anomalies = 0UL;
 	sd.responses = 0UL;
 	sd.virt = 0UL;
@@ -67,6 +68,7 @@ void reset_counters(void)
 	slist_create(&sd.keys);
 	ilist_create(&sd.pids);
 	slist_create(&sd.sys_list);
+	slist_create(&sd.uringop_list);
 	ilist_create(&sd.anom_list);
 	ilist_create(&sd.mac_list);
 	ilist_create(&sd.resp_list);
@@ -89,6 +91,7 @@ void destroy_counters(void)
 	sd.avcs = 0UL;
 	sd.mac = 0UL;
 	sd.failed_syscalls = 0UL;
+	sd.failed_uringops = 0UL;
 	sd.anomalies = 0UL;
 	sd.responses = 0UL;
 	sd.virt = 0UL;
@@ -103,6 +106,7 @@ void destroy_counters(void)
 	slist_clear(&sd.keys);
 	ilist_clear(&sd.pids);
 	slist_clear(&sd.sys_list);
+	slist_clear(&sd.uringop_list);
 	ilist_clear(&sd.anom_list);
 	ilist_create(&sd.mac_list);
 	ilist_clear(&sd.resp_list);
@@ -430,6 +434,13 @@ static int per_event_summary(llist *l)
 			if (l->s.terminal)
 				slist_add_if_uniq(&sd.terms, l->s.terminal);
 			break;
+		case RPT_URINGOP:
+			if (l->s.uringop > 0) {
+				char tmp[32];
+				aulookup_uringop(l, tmp, 32);
+				slist_add_if_uniq(&sd.uringop_list, tmp);
+			}
+			break;
 		case RPT_USER:
 			if (l->s.loginuid != -2) {
 				char tmp[32];
@@ -688,6 +699,17 @@ static int per_event_detailed(llist *l)
 				UNIMPLEMENTED;
 			}
 			break;
+		case RPT_URINGOP:
+			list_first(l);
+			if (report_detail == D_DETAILED) {
+				if (l->s.uringop) {
+					print_per_event_item(l);
+					rc = 1;
+				}
+			} else { //  specific uring op report
+				UNIMPLEMENTED;
+			}
+			break;
 		case RPT_USER:
 			list_first(l);
 			if (report_detail == D_DETAILED) {
@@ -938,6 +960,10 @@ static void do_summary_total(llist *l)
 	if (l->s.success == S_FAILED && l->s.syscall > 0)
 		sd.failed_syscalls++;
 
+	// add failed uring ops
+	if (l->s.success == S_FAILED && l->s.uringop > 0)
+		sd.failed_uringops++;
+
 	// add pids
 	if (l->s.pid != -1) {
 		ilist_add_if_uniq(&sd.pids, l->s.pid, 0);
diff --git a/src/aureport-scan.h b/src/aureport-scan.h
index 76cc81874874..b974bc4d70ab 100644
--- a/src/aureport-scan.h
+++ b/src/aureport-scan.h
@@ -38,6 +38,7 @@ typedef struct sdata {
 	slist keys;
 	ilist pids;
 	slist sys_list;
+	slist uringop_list;
 	ilist anom_list;
 	ilist resp_list;
 	ilist mac_list;
@@ -55,6 +56,7 @@ typedef struct sdata {
 	unsigned long avcs;
 	unsigned long mac;
 	unsigned long failed_syscalls;
+	unsigned long failed_uringops;
 	unsigned long anomalies;
 	unsigned long responses;
 	unsigned long virt;
diff --git a/src/aureport.c b/src/aureport.c
index 22618f02346a..48d69b493f80 100644
--- a/src/aureport.c
+++ b/src/aureport.c
@@ -236,7 +236,8 @@ static void process_event(llist *entries)
 	if (scan(entries)) {
 		// If its a single event or SYSCALL load interpretations
 		if ((entries->cnt == 1) || 
-				(entries->head->type == AUDIT_SYSCALL))
+		    (entries->head->type == AUDIT_SYSCALL) ||
+		    (entries->head->type == AUDIT_URINGOP))
 			_auparse_load_interpretations(entries->head->interp);
 		// This is the per entry action item
 		if (per_event_processing(entries))
-- 
2.27.0

