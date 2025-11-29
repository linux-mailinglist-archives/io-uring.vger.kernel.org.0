Return-Path: <io-uring+bounces-10850-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E25EFC944EF
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:02:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3D0F7346D45
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60D04310779;
	Sat, 29 Nov 2025 17:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="sIbDoKJR"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC6630F94B;
	Sat, 29 Nov 2025 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435702; cv=none; b=ExaxLCV6IBq8HWzr0cVXs4mh7BeesCE5h68T/Wx/CA95pkapWIz/uLPzaktTrdBk1HSJ8JhiyBLEUoypgIAONQiyfCfN/O3QA9T0OpgMo4rlITsAOUPgyYBW8KPUQT6t/A7qB6HSA4WQ9M84oAw9P3mJf8MVrTkD1rHahGnKX5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435702; c=relaxed/simple;
	bh=or88/cs3i4pfwUdhAxVj23lMPsEmVJdRJAAG/mncoXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CP3B2y36zrfq/OzjhN8qxG4klH8O6HlpRdEh0WlhQ2/UxqKAqK6JbAe5TmvLcywGpOA0oY/vyA7EHzMuFR+thzYW79PO8YwBVeWs77PP7vYOTmTiGxO6JinY6gU8MMmkFfcz2BEvOEw0agOSYJNO1xxymDGTJIoTnw98hjsoozU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=sIbDoKJR; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ROqYr8yMtaXCpVDH16m5r5NcISitdCrn+12IWlVF+zM=; b=sIbDoKJReVWlEfWvsvECAAXm/e
	RHSDfW1Zz5LmxRNilTx+V/CPY0o/u+25GKC3lpyLIVXnKON7GPPSPGKgZXXkPtSqCWjGNX7w43EA5
	4p57E0EUOg8kO1uq6wHCeioi5oRYfc7fsEAN7SFHBgv23+H8lkkMR088HOKZE18S93DmWKud42ZNQ
	FAkzcvikw9XsqsOFK2Pl1wcCyqXNCLa2UFXPJnR/c9n1tZWEnNYxWugFVGh0ONB+V3H7+qJb4NBkl
	YDXt2CLF97B0MjtdrHPOQkcJFZAiR3Z3UuABJctai4yFJPdNShxjoAYCQ1x7gKu60FKGALQhXeFAC
	HwC6Vg6w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKN-00000000dCz-2Abj;
	Sat, 29 Nov 2025 17:01:43 +0000
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
Subject: [RFC PATCH v2 10/18] get rid of audit_reusename()
Date: Sat, 29 Nov 2025 17:01:34 +0000
Message-ID: <20251129170142.150639-11-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
References: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

Originally we tried to avoid multiple insertions into audit names array
during retry loop by a cute hack - memorize the userland pointer and
if there already is a match, just grab an extra reference to it.

Cute as it had been, it had problems - two identical pointers had
audit aux entries merged, two identical strings did not.  Having
different behaviour for syscalls that differ only by addresses of
otherwise identical string arguments is obviously wrong - if nothing
else, compiler can decide to merge identical string literals.

Besides, this hack does nothing for non-audited processes - they get
a fresh copy for retry.  It's not time-critical, but having behaviour
subtly differ that way is bogus.

These days we have very few places that import filename more than once
(9 functions total) and it's easy to massage them so we get rid of all
re-imports.  With that done, we don't need audit_reusename() anymore.
There's no need to memorize userland pointer either.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c            | 11 +++--------
 include/linux/audit.h | 11 -----------
 include/linux/fs.h    |  1 -
 kernel/auditsc.c      | 23 -----------------------
 4 files changed, 3 insertions(+), 43 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7377020a2cba..dd86e41deeeb 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -125,9 +125,8 @@
 
 #define EMBEDDED_NAME_MAX	(PATH_MAX - offsetof(struct filename, iname))
 
-static inline void initname(struct filename *name, const char __user *uptr)
+static inline void initname(struct filename *name)
 {
-	name->uptr = uptr;
 	name->aname = NULL;
 	atomic_set(&name->refcnt, 1);
 }
@@ -139,10 +138,6 @@ getname_flags(const char __user *filename, int flags)
 	char *kname;
 	int len;
 
-	result = audit_reusename(filename);
-	if (result)
-		return result;
-
 	result = __getname();
 	if (unlikely(!result))
 		return ERR_PTR(-ENOMEM);
@@ -210,7 +205,7 @@ getname_flags(const char __user *filename, int flags)
 			return ERR_PTR(-ENAMETOOLONG);
 		}
 	}
-	initname(result, filename);
+	initname(result);
 	audit_getname(result);
 	return result;
 }
@@ -268,7 +263,7 @@ struct filename *getname_kernel(const char * filename)
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 	memcpy((char *)result->name, filename, len);
-	initname(result, NULL);
+	initname(result);
 	audit_getname(result);
 	return result;
 }
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 536f8ee8da81..d936a604d056 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -316,7 +316,6 @@ extern void __audit_uring_exit(int success, long code);
 extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
 				  unsigned long a2, unsigned long a3);
 extern void __audit_syscall_exit(int ret_success, long ret_value);
-extern struct filename *__audit_reusename(const __user char *uptr);
 extern void __audit_getname(struct filename *name);
 extern void __audit_inode(struct filename *name, const struct dentry *dentry,
 				unsigned int flags);
@@ -380,12 +379,6 @@ static inline void audit_syscall_exit(void *pt_regs)
 		__audit_syscall_exit(success, return_code);
 	}
 }
-static inline struct filename *audit_reusename(const __user char *name)
-{
-	if (unlikely(!audit_dummy_context()))
-		return __audit_reusename(name);
-	return NULL;
-}
 static inline void audit_getname(struct filename *name)
 {
 	if (unlikely(!audit_dummy_context()))
@@ -624,10 +617,6 @@ static inline struct audit_context *audit_context(void)
 {
 	return NULL;
 }
-static inline struct filename *audit_reusename(const __user char *name)
-{
-	return NULL;
-}
 static inline void audit_getname(struct filename *name)
 { }
 static inline void audit_inode(struct filename *name,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c895146c1444..bbae3cfdc338 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2835,7 +2835,6 @@ extern struct kobject *fs_kobj;
 struct audit_names;
 struct filename {
 	const char		*name;	/* pointer to actual string */
-	const __user char	*uptr;	/* original userland pointer */
 	atomic_t		refcnt;
 	struct audit_names	*aname;
 	const char		iname[];
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index d1966144bdfe..e59a094bb9f7 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2169,29 +2169,6 @@ static struct audit_names *audit_alloc_name(struct audit_context *context,
 	return aname;
 }
 
-/**
- * __audit_reusename - fill out filename with info from existing entry
- * @uptr: userland ptr to pathname
- *
- * Search the audit_names list for the current audit context. If there is an
- * existing entry with a matching "uptr" then return the filename
- * associated with that audit_name. If not, return NULL.
- */
-struct filename *
-__audit_reusename(const __user char *uptr)
-{
-	struct audit_context *context = audit_context();
-	struct audit_names *n;
-
-	list_for_each_entry(n, &context->names_list, list) {
-		if (!n->name)
-			continue;
-		if (n->name->uptr == uptr)
-			return refname(n->name);
-	}
-	return NULL;
-}
-
 /**
  * __audit_getname - add a name to the list
  * @name: name to add
-- 
2.47.3


