Return-Path: <io-uring+bounces-11091-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E45DCC0C9F
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:57:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 57FD83062E70
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4248A32572D;
	Tue, 16 Dec 2025 03:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ZwilCr+E"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7557F31280E;
	Tue, 16 Dec 2025 03:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857296; cv=none; b=Q4PgcG1dFImC88RZyBJLdjawU89IsFTlK0WDotwSxzJSkCZJGbqCWp+/pdJMHu6CZdD3zPiwfMOlXFoSF1j/gf3X7mbVdYI8tXLsdhr4aKfx+V6ojk0ivf4iqFoAftPK1c1V+UK7s2V9BBZM6EDwx2A2YTJ7oizhqjMSOTWfHhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857296; c=relaxed/simple;
	bh=2CHW41/M3UBBr9SffnNIEEiMvQ5CCktWZE0nn4bF3bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fH8wGSoMlKN1VvwMX55WYapObg7Zrq2Agf93lyWORJHavKhRZpxdCHTFE+6oxfKjS18pJ+3d6l+ZBstVKYCx5xpDPmJM1yd095ofx4NB/jcol7KdtaMyhCaOPi45ebuPEXvMJ58UEj9ueJ1VNNqgkm3bYIj0v+GX5oU45VxninE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ZwilCr+E; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZDabGQhCWYKB8pau0wUjnJ++S20uh9OJmrx26ZM+e4M=; b=ZwilCr+EKEdAQl4w7kPdgftiAB
	C2NyzY67VvlaGfqXmSwIqA8dtWZzOChG3bh8Vt/fAmmLssQzri2ai4ndHGDVVriO5mQe2I9gI0g3y
	IOyyXT4vi37YYpVN/zCOGSErJEwAKFN/OQsE4fux+Kq0Pj7Ou6CHIgnvitP1tN71jxPxX+kTb6Mso
	5wcTffYmCelodFzJg/DLPS0jlUMiqxMAocrqDkqQ+cu3jWBaPRqWt+3SVRBTgpsM8FGQnL32Wj8rU
	/Svy0+SOVpdV+8FKv/S5q9ms/Fy1riSyMidTROgbUkO0PZxTOiUN5xALLQEOCr6pB4gWljY59yYKb
	C8Ld/jGg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9g-0000000GwJp-1SUK;
	Tue, 16 Dec 2025 03:55:20 +0000
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
Subject: [RFC PATCH v3 18/59] struct filename ->refcnt doesn't need to be atomic
Date: Tue, 16 Dec 2025 03:54:37 +0000
Message-ID: <20251216035518.4037331-19-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
References: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
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
 fs/namei.c         | 10 +++++-----
 include/linux/fs.h |  8 +-------
 kernel/auditsc.c   |  6 ++++++
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 4faaae0239ad..192d31acb4ff 100644
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
@@ -294,13 +294,13 @@ void putname(struct filename *name)
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
@@ -332,7 +332,7 @@ int putname_to_delayed(struct delayed_filename *v, struct filename *__name)
 {
 	struct filename *name __free(putname) = no_free_ptr(__name);
 
-	if (likely(atomic_read(&name->refcnt) == 1)) {
+	if (likely(name->refcnt == 1)) {
 		v->__incomplete_filename = no_free_ptr(name);
 		return 0;
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e446cb8c1e37..b711f46ba8f5 100644
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
 extern int finish_open(struct file *file, struct dentry *dentry,
 			int (*open)(struct inode *, struct file *));
 extern int finish_no_open(struct file *file, struct dentry *dentry);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 67d8da927381..b1dc9284550a 100644
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


