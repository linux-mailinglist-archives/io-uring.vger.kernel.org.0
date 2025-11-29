Return-Path: <io-uring+bounces-10848-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCB3C944F8
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:02:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6C3A44E41A5
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265A331064B;
	Sat, 29 Nov 2025 17:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="nORElcFX"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB46323373D;
	Sat, 29 Nov 2025 17:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435702; cv=none; b=OV7/0MPD8v4Fmk0RNZs+NiBUnncZnh/ZC5rlLQNsE4KHypYit7Zf6xriOf2qwdOJFeY7LCp2YoomG4U4pD+QEGth7pA0xc2Jzko2hGycIj1p4dXEjcYWpDDxEwEavtq/sK0udkTNLFk1IUwaUgA/G0T0k0fFJw43AIgsMa7HH+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435702; c=relaxed/simple;
	bh=QPsA95FqkoqhZwspP+I0M8hqJMt14cqnl0F7hFCckZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSs8k2PQdSru90BeFpL1Tts0L7L42Nia4BgTbpzNZJT01eJQTUutojRG6e21szmb7YYNIfOyQL5QtIhOTQXyQsZWcNpcZr+jkgV+JBPIrwwdv3HJqd7IkwFjFD5+Eiw3phHcteoztTpT1hip1WFnR6a8idQsiOc1UpSQl3wajDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=nORElcFX; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dnuK+nfSVSM8EnnK0uwzWnmtu2jEW/yLVrHY/kiG4UY=; b=nORElcFXZIM+PZtx1nWH5bOkZt
	VHIGK5a3y6Tv0bG/Ku5dhUwLqANlxxAZZcKTIzuFkS34gcK3Vd6WJjZ92s3w+qdFMwdc73XC75XG3
	tOKIj+Q88sM8iZL6P6Rj3pW0dAjP0AgM1dKiG1++gCVcyVcfwHtdopNDq783wH+pNoUGwL/gSk94k
	EnVm4EqVjhKoHQ5INCAgU/Lm9vg+/y9cer5BpYLhzwrt1I+0hRf50/lHKPAiU1M0kzCrNkUf1t66N
	kZDj5Qn/CuYo67DxoZumbabb07B+OqvbbmdCEgScUoRUsZ2aiKi9LsBC7qQfxhR/wvO0d2PPc2US3
	HkgHuUyA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKO-00000000dET-1ZhJ;
	Sat, 29 Nov 2025 17:01:44 +0000
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
Subject: [RFC PATCH v2 18/18] struct filename ->refcnt doesn't need to be atomic
Date: Sat, 29 Nov 2025 17:01:42 +0000
Message-ID: <20251129170142.150639-19-viro@zeniv.linux.org.uk>
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

... or visible outside of audit, really.  Note that references
held in delayed_filename always have refcount 1, and from the
moment of complete_getname() or equivalent point in getname...()
there won't be any references to struct filename instance left
in places visible to other threads.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c         | 10 +++++-----
 include/linux/fs.h |  8 +-------
 kernel/auditsc.c   |  6 ++++++
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 8530d75fb270..d6eac90084e1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -146,7 +146,7 @@ static inline void free_filename(struct filename *p)
 static inline void initname(struct filename *name)
 {
 	name->aname = NULL;
-	atomic_set(&name->refcnt, 1);
+	name->refcnt = 1;
 }
 
 static int getname_long(struct filename *name, const char __user *filename)
@@ -284,13 +284,13 @@ void putname(struct filename *name)
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
 
 	if (unlikely(name->name != name->iname))
@@ -323,7 +323,7 @@ int putname_to_delayed(struct delayed_filename *v, struct filename *__name)
 	struct filename *name __free(putname) = no_free_ptr(__name);
 	struct filename *copy;
 
-	if (likely(atomic_read(&name->refcnt) == 1)) {
+	if (likely(name->refcnt == 1)) {
 		v->__incomplete_filename = no_free_ptr(name);
 		return 0;
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 52ee3bc1baa9..b21814b93dcd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2837,7 +2837,7 @@ struct audit_names;
 #define EMBEDDED_NAME_MAX	128
 struct filename {
 	const char		*name;	/* pointer to actual string */
-	atomic_t		refcnt;
+	int			refcnt;
 	struct audit_names	*aname;
 	const char		iname[EMBEDDED_NAME_MAX];
 };
@@ -2947,12 +2947,6 @@ void dismiss_delayed_filename(struct delayed_filename *);
 int putname_to_delayed(struct delayed_filename *, struct filename *);
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


