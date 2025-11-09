Return-Path: <io-uring+bounces-10474-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A574DC43969
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 07:38:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B369B3AD738
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 06:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBC84258ED1;
	Sun,  9 Nov 2025 06:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="t7ZoDXsb"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4783241CB7;
	Sun,  9 Nov 2025 06:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762670271; cv=none; b=WhimD6NFy9vGr+Hznf5psU6X330eTuZPBwAhJChfixSB+ygcjpe/iyJrdCHCmy9jLxgSwZG5+4Owhxa5PFq51DqOZ1EeV3iIplTgcVlcvL+ZT5zu36zKfTTEfREds+gug8scgXzHsab0bP8WHrE7bvpqXufhHU4fx18MuKmGH9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762670271; c=relaxed/simple;
	bh=YXvExZ6nFYMYGW5Yow8JrqcueNyhJE1qx9yl2S9CFNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVVsyTw0a6OYhNPxwnEmVd8orRGUYvf0hRyfvfFPzad/lQ4MaNh8cc081B53C8Eg6EpHNZL3VDkJnvvZgWpxLfeKczIYfcii1G9rmH9nebClzJjaHnnbcBjzXODrXyiolOTxBsy8D14hBmWR/LXx5qun97LCdYVcFFIg+xDom/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=t7ZoDXsb; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2OVGejaTIaqTifOZGRFKTB6zyUq35WGbXMjA6hnZtbo=; b=t7ZoDXsbxeLWCoY8yjMq5se07Q
	bcSED/P0dXfRD+NsKjJP6B2IfQvTyLXF/hnkOb/+k0Fc9LohkOBMjKYwlZebDDxGS8WA9QuK1I4Z+
	SZilhrZDcdYetf5fUwGLSXge2fbcdMKq5pKqey0GChiBJuwMWha52uQ69o67Enh+oRcdD9AwGfCUS
	lEBh/9HKU0miOH8luLnlAc6HvHxqP01J2eQMDV8ENZ+H4aQmNynkFAv7vD0TTYCc1s69EUvOVpGIF
	NZovAt+r61Fy7uxMKLTBscBtlzI8kFwu/xf9ZgLM0Rp6CwT2ggNqWJXdEMzx/tEPSYeEfPmg0dnTN
	/7umuPcg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHz3b-00000008ldY-07hj;
	Sun, 09 Nov 2025 06:37:47 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC][PATCH 13/13] struct filename ->refcnt doesn't need to be atomic
Date: Sun,  9 Nov 2025 06:37:45 +0000
Message-ID: <20251109063745.2089578-14-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

... or visible outside of audit, really.  Note that references
held in delayed_filename always have refcount 1, and from the
moment of complete_getname() or equivalent point in getname...()
there is no references to struct filename instance anywhere
that would be visible to other threads.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c         | 8 ++++----
 include/linux/fs.h | 8 +-------
 kernel/auditsc.c   | 6 ++++++
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index bb306177b8a3..9863cc319181 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -128,7 +128,7 @@
 static inline void initname(struct filename *name)
 {
 	name->aname = NULL;
-	atomic_set(&name->refcnt, 1);
+	name->refcnt = 1;
 }
 
 static struct filename *
@@ -283,13 +283,13 @@ void putname(struct filename *name)
 	if (IS_ERR_OR_NULL(name))
 		return;
 
-	refcnt = atomic_read(&name->refcnt);
+	refcnt = name->refcnt;
 	if (unlikely(refcnt != 1)) {
 		if (WARN_ON_ONCE(!refcnt))
 			return;
 
-		if (!atomic_dec_and_test(&name->refcnt))
-			return;
+		name->refcnt--;
+		return;
 	}
 
 	if (unlikely(name->name != name->iname)) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d57c8e21be13..4ea32aba847b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2835,7 +2835,7 @@ extern struct kobject *fs_kobj;
 struct audit_names;
 struct filename {
 	const char		*name;	/* pointer to actual string */
-	atomic_t		refcnt;
+	int			refcnt;
 	struct audit_names	*aname;
 	const char		iname[];
 };
@@ -2944,12 +2944,6 @@ int delayed_getname_uflags(struct delayed_filename *v, const char __user *, int)
 void dismiss_delayed_filename(struct delayed_filename *);
 struct filename *complete_getname(struct delayed_filename *);
 
-static inline struct filename *refname(struct filename *name)
-{
-	atomic_inc(&name->refcnt);
-	return name;
-}
-
 extern int finish_open(struct file *file, struct dentry *dentry,
 			int (*open)(struct inode *, struct file *));
 extern int finish_no_open(struct file *file, struct dentry *dentry);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index e59a094bb9f7..d71fc73455b2 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2169,6 +2169,12 @@ static struct audit_names *audit_alloc_name(struct audit_context *context,
 	return aname;
 }
 
+static inline struct filename *refname(struct filename *name)
+{
+	name->refcnt++;
+	return name;
+}
+
 /**
  * __audit_getname - add a name to the list
  * @name: name to add
-- 
2.47.3


