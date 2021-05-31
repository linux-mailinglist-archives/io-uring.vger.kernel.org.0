Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE92395DBD
	for <lists+io-uring@lfdr.de>; Mon, 31 May 2021 15:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhEaNus (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 May 2021 09:50:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38300 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232955AbhEaNri (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 May 2021 09:47:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622468757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8/kzEZ+gdZBh/Nwa/sm6GIH+uwzsf4BvjPEAhah/HTA=;
        b=ZybS4GL5PLkv+5OTsqlnpikQrCz+b5TNZUQ82x0pQUR6iQhIL70wRrfbf7GuSEdSnV/cWF
        HnthdMDQ6AZvfPwFqNJrt+KRVzYCq5775jxCipG5GbbHDD8bCRByHFIJ6ahTcgx8Vx5Jyu
        6wrO3fsxGbfvBv0l2/rYcmJGP20hG9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-wT2cFsQHMIi4CH92TH_aww-1; Mon, 31 May 2021 09:45:53 -0400
X-MC-Unique: wT2cFsQHMIi4CH92TH_aww-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 524841075646;
        Mon, 31 May 2021 13:45:52 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0330E5C1B4;
        Mon, 31 May 2021 13:45:42 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>, linux-audit@redhat.com,
        io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 1/2] audit: add filtering for io_uring records, addendum
Date:   Mon, 31 May 2021 09:44:54 -0400
Message-Id: <3a2903574a4d03f73230047866112b2dad9b4a9e.1622467740.git.rgb@redhat.com>
In-Reply-To: <CAHC9VhTr_hw_RBPf5yGD16j-qV2tbjjPJkimMNNQZBHtrJDbuQ@mail.gmail.com>
References: <CAHC9VhTr_hw_RBPf5yGD16j-qV2tbjjPJkimMNNQZBHtrJDbuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The commit ("audit: add filtering for io_uring records") added support for
filtering io_uring operations.

Add checks to the audit io_uring filtering code for directory and path watches,
and to keep the list counts consistent.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit_tree.c  | 3 ++-
 kernel/audit_watch.c | 3 ++-
 kernel/auditfilter.c | 7 +++++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 6c91902f4f45..2be285c2f069 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -727,7 +727,8 @@ int audit_make_tree(struct audit_krule *rule, char *pathname, u32 op)
 {
 
 	if (pathname[0] != '/' ||
-	    rule->listnr != AUDIT_FILTER_EXIT ||
+	    (rule->listnr != AUDIT_FILTER_EXIT &&
+	     rule->listnr != AUDIT_FILTER_URING_EXIT) ||
 	    op != Audit_equal ||
 	    rule->inode_f || rule->watch || rule->tree)
 		return -EINVAL;
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 2acf7ca49154..698b62b4a2ec 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -183,7 +183,8 @@ int audit_to_watch(struct audit_krule *krule, char *path, int len, u32 op)
 		return -EOPNOTSUPP;
 
 	if (path[0] != '/' || path[len-1] == '/' ||
-	    krule->listnr != AUDIT_FILTER_EXIT ||
+	    (krule->listnr != AUDIT_FILTER_EXIT &&
+	     krule->listnr != AUDIT_FILTER_URING_EXIT) ||
 	    op != Audit_equal ||
 	    krule->inode_f || krule->watch || krule->tree)
 		return -EINVAL;
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index c21119c00504..bcdedfd1088c 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -153,7 +153,8 @@ char *audit_unpack_string(void **bufp, size_t *remain, size_t len)
 static inline int audit_to_inode(struct audit_krule *krule,
 				 struct audit_field *f)
 {
-	if (krule->listnr != AUDIT_FILTER_EXIT ||
+	if ((krule->listnr != AUDIT_FILTER_EXIT &&
+	     krule->listnr != AUDIT_FILTER_URING_EXIT) ||
 	    krule->inode_f || krule->watch || krule->tree ||
 	    (f->op != Audit_equal && f->op != Audit_not_equal))
 		return -EINVAL;
@@ -250,6 +251,7 @@ static inline struct audit_entry *audit_to_entry_common(struct audit_rule_data *
 		pr_err("AUDIT_FILTER_ENTRY is deprecated\n");
 		goto exit_err;
 	case AUDIT_FILTER_EXIT:
+	case AUDIT_FILTER_URING_EXIT:
 	case AUDIT_FILTER_TASK:
 #endif
 	case AUDIT_FILTER_USER:
@@ -982,7 +984,8 @@ static inline int audit_add_rule(struct audit_entry *entry)
 	}
 
 	entry->rule.prio = ~0ULL;
-	if (entry->rule.listnr == AUDIT_FILTER_EXIT) {
+	if (entry->rule.listnr == AUDIT_FILTER_EXIT ||
+	    entry->rule.listnr == AUDIT_FILTER_URING_EXIT) {
 		if (entry->rule.flags & AUDIT_FILTER_PREPEND)
 			entry->rule.prio = ++prio_high;
 		else
-- 
2.27.0

