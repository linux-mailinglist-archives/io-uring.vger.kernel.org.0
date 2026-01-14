Return-Path: <io-uring+bounces-11694-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 93B6CD1C626
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:36:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 987EA301679E
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09CA335063;
	Wed, 14 Jan 2026 04:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="qP/LMEqQ"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01592F362B;
	Wed, 14 Jan 2026 04:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365122; cv=none; b=d4pQV0LL72wPcox4tOow8LBYUQByY/DEdQkJ6Ot4qxnoHlMvZ/wollcmo6oEkDRiJ1b8MeTS4ExKDRsnMbsQWNegDWDOekdV0mBXlaKUoOQxf5UaerrgOP9XU3soEUlKYX4ko052RZXuZ/qcWSoO+pTTT97upYEniSp9oK1kQ+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365122; c=relaxed/simple;
	bh=DRDmIOvg1abJl+/JeOeB7ulbY6rmfIdfsjab/8Rf3SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJ0gp/UFXOmixC2yyJrJP0yU8r/jMWgHTVCqIJCBf5TTosm2DRL0wmtS/2LyHxdzewkxqL81CL03ix6WoLw0m7KVXpnrYkDPBfb6sJMG5K3+ALD762xCmzJysCVeSCmHhn6g9NcY13hSb3HrndXh7ZiRLMY9SqqtuaoxnxwS9KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=qP/LMEqQ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5yAr+d87WTeC2PgxeAVXbzQHbhxJXXfFmShFH8sOGxA=; b=qP/LMEqQn/eejt+MO24g8FWM88
	7F8UtvM/lckMH5gaT154etzpDmO6cgFX5OTi/Qrsxfm2icW83e0ygEK8o+By4OcgdgovO7WiNMCrL
	6PuC1Wq6qnbKzCxeG2saWHdisI677t75amgt87uB4fvhrXCZCwCbM8OUguwNJh/m1BOxgJIKe1clZ
	jJgKsjA64BHapqtZ0JIv8bXzDD9/ruvnKgrD4E0N+OpIfik96UNnVyqpidf0ho50GyDRgLKyXxTkg
	+hDZ+YB0PW++51x5s6n+MEYJV3ABYC2Vu4cOHqHllqjXIOkLHdPGu9StlYgJHB9O0bzne9I2fiMvb
	0baYcFOQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZF-0000000GInv-2OJH;
	Wed, 14 Jan 2026 04:33:13 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jens Axboe <axboe@kernel.dk>,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 24/68] struct filename ->refcnt doesn't need to be atomic
Date: Wed, 14 Jan 2026 04:32:26 +0000
Message-ID: <20260114043310.3885463-25-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
References: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
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

Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c         | 12 ++++++------
 include/linux/fs.h |  8 +-------
 kernel/auditsc.c   |  6 +++---
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b76cc43fe89d..f4359825ba48 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -150,7 +150,7 @@ static inline void free_filename(struct filename *p)
 static inline void initname(struct filename *name)
 {
 	name->aname = NULL;
-	atomic_set(&name->refcnt, 1);
+	name->refcnt = 1;
 }
 
 static int getname_long(struct filename *name, const char __user *filename)
@@ -292,13 +292,13 @@ void putname(struct filename *name)
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
@@ -328,12 +328,12 @@ int delayed_getname_uflags(struct delayed_filename *v, const char __user *string
 
 int putname_to_delayed(struct delayed_filename *v, struct filename *name)
 {
-	if (likely(atomic_read(&name->refcnt) == 1)) {
+	if (likely(name->refcnt == 1)) {
 		v->__incomplete_filename = name;
 		return 0;
 	}
+	name->refcnt--;
 	v->__incomplete_filename = do_getname_kernel(name->name, true);
-	putname(name);
 	return PTR_ERR_OR_ZERO(v->__incomplete_filename);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f1612a7dffd0..6a26ee347517 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2412,7 +2412,7 @@ struct audit_names;
 
 struct __filename_head {
 	const char		*name;	/* pointer to actual string */
-	atomic_t		refcnt;
+	int			refcnt;
 	struct audit_names	*aname;
 };
 #define EMBEDDED_NAME_MAX	(192 - sizeof(struct __filename_head))
@@ -2527,12 +2527,6 @@ void dismiss_delayed_filename(struct delayed_filename *);
 int putname_to_delayed(struct delayed_filename *, struct filename *);
 struct filename *complete_getname(struct delayed_filename *);
 
-static inline struct filename *refname(struct filename *name)
-{
-	atomic_inc(&name->refcnt);
-	return name;
-}
-
 DEFINE_CLASS(filename, struct filename *, putname(_T), getname(p), const char __user *p)
 EXTEND_CLASS(filename, _kernel, getname_kernel(p), const char *p)
 EXTEND_CLASS(filename, _flags, getname_flags(p, f), const char __user *p, unsigned int f)
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 67d8da927381..86a44b162a87 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2191,7 +2191,7 @@ void __audit_getname(struct filename *name)
 	n->name = name;
 	n->name_len = AUDIT_NAME_FULL;
 	name->aname = n;
-	refname(name);
+	name->refcnt++;
 }
 
 static inline int audit_copy_fcaps(struct audit_names *name,
@@ -2323,7 +2323,7 @@ void __audit_inode(struct filename *name, const struct dentry *dentry,
 		return;
 	if (name) {
 		n->name = name;
-		refname(name);
+		name->refcnt++;
 	}
 
 out:
@@ -2445,7 +2445,7 @@ void __audit_inode_child(struct inode *parent,
 		if (found_parent) {
 			found_child->name = found_parent->name;
 			found_child->name_len = AUDIT_NAME_FULL;
-			refname(found_child->name);
+			found_child->name->refcnt++;
 		}
 	}
 
-- 
2.47.3


