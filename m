Return-Path: <io-uring+bounces-11068-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5762FCC0C2D
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:55:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 20B9A3027BCB
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65203191C9;
	Tue, 16 Dec 2025 03:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Tqjj+jQB"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CF531281B;
	Tue, 16 Dec 2025 03:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857294; cv=none; b=YKdGMKue/DoMYV0cZC5AO4OR/dcah9X691/d8kGJ2gy7CtK5aa/YkezuISWNpP8NKj/DkyDdmNgOEzRGqEj/qU+jUywTMcIfUqlpsF6xN6IKLxAE1N0SJ6bejo0wsg80AZeBW5rkKVi1A5oFcXWMDlp45//cJCSqqtR8O6hu8K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857294; c=relaxed/simple;
	bh=QmdvDh6ZC+vTUW7I+/3NR1ZSyfxcvYqlL1sBR3JZVe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TY+Cj6AKp8oiDByHErhdOCxe76RUQuP2bnLOXc41+gW0j0Kv6ZJVDjHPy9OT+/Kwiz/ta0CPL3fLdv/0ZlmOpiNXukZBMZNyKgQCPJ7rLIv4omTOBlqs4OpHALPhLlQDYUKbzQ9lAUbCDr7a7KwZsJhp4HOqprJfYA6SJ32fDwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Tqjj+jQB; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Y/tgOGIFg+4nJnG3/oUX+72381wYKpaNlwOXFe6p+iM=; b=Tqjj+jQBZ2/AGLQsUCf8zgnkJe
	0ZVogFd9ocw24etLMgthihgYPL671liFhTyNxO95cuhM0WWHhqH/RX78BP3M0ITj5ZGe+toVa1Ogp
	EkMV0RhRLgNylj7ZQEcZ6kJcNyOgsAhKCucynOphRZt0G3ks/qqd7KnR3tY6jUkdQxq6Psj+GyhxQ
	iOBzXi5r9lM6a3CaqxpvXnLxv7AjArKeo2uSk4FAoxLCjda8bf7s0mDaVv2g19N28HbHhc55A3Sac
	6ve7WYlEVNBYvh0lmffmcKrVi2EqI/My7uTCnzrC7S4DbMhHferO/RR2pmvIa/5Ntq3LBscIckxlw
	+JoqQ0OQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9f-0000000GwJU-3vG1;
	Tue, 16 Dec 2025 03:55:19 +0000
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
Subject: [RFC PATCH v3 13/59] getname_flags() massage, part 2
Date: Tue, 16 Dec 2025 03:54:32 +0000
Message-ID: <20251216035518.4037331-14-viro@zeniv.linux.org.uk>
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

Take the "long name" case into a helper (getname_long()). In
case of failure have the caller deal with freeing the original
struct filename.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 56 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ea7efbddc7f4..471e4db2dbdb 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -131,6 +131,32 @@ static inline void initname(struct filename *name)
 	atomic_set(&name->refcnt, 1);
 }
 
+static struct filename *getname_long(struct filename *old,
+				     const char __user *filename)
+{
+	int len;
+	/*
+	 * size is chosen that way we to guarantee that
+	 * p->iname[0] is within the same object and that
+	 * p->name can't be equal to p->iname, no matter what.
+	 */
+	const size_t size = offsetof(struct filename, iname[1]);
+	struct filename *p __free(kfree) = kzalloc(size, GFP_KERNEL);
+	if (unlikely(!p))
+		return ERR_PTR(-ENOMEM);
+
+	memmove(old, &old->iname, EMBEDDED_NAME_MAX);
+	p->name = (char *)old;
+	len = strncpy_from_user((char *)old + EMBEDDED_NAME_MAX,
+				filename + EMBEDDED_NAME_MAX,
+				PATH_MAX - EMBEDDED_NAME_MAX);
+	if (unlikely(len < 0))
+		return ERR_PTR(len);
+	if (unlikely(len == PATH_MAX - EMBEDDED_NAME_MAX))
+		return ERR_PTR(-ENAMETOOLONG);
+	return no_free_ptr(p);
+}
+
 struct filename *
 getname_flags(const char __user *filename, int flags)
 {
@@ -173,34 +199,10 @@ getname_flags(const char __user *filename, int flags)
 	 * userland.
 	 */
 	if (unlikely(len == EMBEDDED_NAME_MAX)) {
-		const size_t size = offsetof(struct filename, iname[1]);
-		struct filename *p;
-
-		/*
-		 * size is chosen that way we to guarantee that
-		 * result->iname[0] is within the same object and that
-		 * kname can't be equal to result->iname, no matter what.
-		 */
-		p = kzalloc(size, GFP_KERNEL);
-		if (unlikely(!p)) {
-			__putname(result);
-			return ERR_PTR(-ENOMEM);
-		}
-		memmove(result, &result->iname, EMBEDDED_NAME_MAX);
-		kname = (char *)result;
-		p->name = kname;
-		len = strncpy_from_user(kname + EMBEDDED_NAME_MAX,
-					filename + EMBEDDED_NAME_MAX,
-					PATH_MAX - EMBEDDED_NAME_MAX);
-		if (unlikely(len < 0)) {
-			kfree(p);
-			__putname(result);
-			return ERR_PTR(len);
-		}
-		if (unlikely(len == PATH_MAX - EMBEDDED_NAME_MAX)) {
-			kfree(p);
+		struct filename *p = getname_long(result, filename);
+		if (IS_ERR(p)) {
 			__putname(result);
-			return ERR_PTR(-ENAMETOOLONG);
+			return p;
 		}
 		result = p;
 	}
-- 
2.47.3


