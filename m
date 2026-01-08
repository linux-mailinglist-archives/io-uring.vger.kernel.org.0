Return-Path: <io-uring+bounces-11467-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DD09D016FF
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:39:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D6B413075D3D
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8909E33DEE0;
	Thu,  8 Jan 2026 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="nerlYMSQ"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E53329373;
	Thu,  8 Jan 2026 07:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857817; cv=none; b=WKWBUJUQ4IdU5LDMpy9ssosYO9udBE2ozM84hrefk+ydpC67goCVs3EEG8b/H/z9CE0vNx6GPrmI7If90+gd/4lq5uyavQwWTwIvJnJa9ChSc6WhkBti3cJXBnOmC+vj6uTVTp3q0ER9wj/75tiuRy/2VMHl2pLsEHoM6glAJV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857817; c=relaxed/simple;
	bh=LCPa6AlgG23FvtWfrcMyRr7CiG/dZNLzjUcN90F5Liw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHNIzPWBgC61OwfqpUlWO6+yjWawQjmMuno9BUj+n7bnB8rBNqp9TNveEqaDgUFRhAyI7PlQAwMPQ12Kzgo7g3jjOn6bTpuVjjkIqfobXJtc0fg42DDHFaak3tZkBwxM2cuQ6+G4GlbTCBGZDx73X0diZ03X+GN0Q0TdW5yCMFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=nerlYMSQ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LcWiOTSlwXumgo7zmkdTY0JfE+7QCpe/Zf4NxR/r0b4=; b=nerlYMSQ9FXW542YSkrdRW7A4I
	KCwDiVw3KzcbXtoP0PXwCfRMWmT30aZQrKnG04YLw5T840jPYLOhEU7mhWFfRfvZdicy1ievS+f7h
	Bp2DYvgKVqETUT29/0AlJ0GUsh1Jiqe1zFRvJzeJQY0dfM/4EvOk7AMrSQMrHWPWgilGk9ywn0+MH
	tiHuqds2Rxd1jwNvWbE2cwkvEniHt7LbHE9NQMB2ftQ0a1SSKgbGjyIAEXWt6+xSW/l0jUH0LZBMB
	4GgJpcOkz5SzGtVWYuydWb5m8ow4WKuW3VLuP/O7nfRDHMDKXL4sDenpD8/O612PBAmswZeFklcvn
	YB4vtE4Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkat-00000001mkX-2XWX;
	Thu, 08 Jan 2026 07:38:07 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 20/59] struct filename ->refcnt doesn't need to be atomic
Date: Thu,  8 Jan 2026 07:37:24 +0000
Message-ID: <20260108073803.425343-21-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
References: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
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
index 4de9697bfbee..8f26e91de906 100644
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
index 9fe91db9c053..6aaaf57e90d8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2412,7 +2412,7 @@ struct audit_names;
 
 struct __filename_head {
 	const char		*name;	/* pointer to actual string */
-	atomic_t		refcnt;
+	int			refcnt;
 	struct audit_names	*aname;
 };
 #define EMBEDDED_NAME_MAX	192 - sizeof(struct __filename_head)
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


