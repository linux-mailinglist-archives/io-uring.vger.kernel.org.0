Return-Path: <io-uring+bounces-11480-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F3D1DD018AC
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 82B0B30A930B
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C424342529;
	Thu,  8 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="rNbEzKHo"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841B531ED76;
	Thu,  8 Jan 2026 07:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857818; cv=none; b=nnbYS/8hS09UFNlVppNec8xn8ArpH8zI8wRbGKcIRbgSDPcVYKYIlxEA7N1mak07pIdkngmG9mNoq5u7D9IDnexmQk0QoyUPjYbtMpGKJlssDAvOrheghZLA0Qlbm1K4AFGzJagH6dHQ7lYwYEYQt1wedbFhrw0KTv8KctGAnWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857818; c=relaxed/simple;
	bh=QmdvDh6ZC+vTUW7I+/3NR1ZSyfxcvYqlL1sBR3JZVe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIt3LajDFVgMDAVSlu/eZGaSCu3ooN/WE8g/AHco7o3ZqdIkeHfxnSt6qeOvlDLTF6Io6ZkyyTfNM/Aw5mCzjRUE8VgxqedsALROlA6CNsnCOfX091/bROGQKfAJEsRk6wijLWrRbUhNI58G/1zCrC8z+690V5ymM37EdRXWFJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=rNbEzKHo; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Y/tgOGIFg+4nJnG3/oUX+72381wYKpaNlwOXFe6p+iM=; b=rNbEzKHoED2LBnJuMjeY59GeIC
	gWoLatI0Wox7thSh7HQKaelv45HzjzSnWcyQJ5bXBv9l63I33jV8xpQmrXH1GzS6vmnUzqxAA7NQ1
	4eCjN8m5DARYlhw/9P/cuhv+0GNNdmqnbhAxoQGcEsUyj/8jFPodZ9TJmmMAbjhaHSfuDcctmALOW
	C9RuNxNbKNNPl0ygTJR94D2Kx4dsh7Ra/oczoNtpUic15oOC2SN7wE/EnFAe/4oqs83frWoIAoYau
	VOaeEMSZFlimKLTA26Y618Z9rRAt70bzWc8JGCJb7BGi0/ipt/fcOqW+JKY3upyJqLkrCg7YwDOV+
	J0DHUWJw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkar-00000001mhV-2H4I;
	Thu, 08 Jan 2026 07:38:05 +0000
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
Subject: [PATCH v4 13/59] getname_flags() massage, part 2
Date: Thu,  8 Jan 2026 07:37:17 +0000
Message-ID: <20260108073803.425343-14-viro@zeniv.linux.org.uk>
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


