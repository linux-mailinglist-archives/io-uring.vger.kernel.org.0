Return-Path: <io-uring+bounces-11661-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E2B05D1C60B
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:35:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D46F7308C770
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F5432B9A6;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="TsOug69a"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED22A2EB5BA;
	Wed, 14 Jan 2026 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365116; cv=none; b=EyT7ta7fMa9/kqFBjYJQi1iAaQKatDD4pFsCsBQiZBjVBgupkCldJn+bgbl6XjYx2kgmXec6w88OhS8XMODH3wUECBEUUaJviWDrhHUL0k4HOAOY75BybIhIgolqWhRQpzIbknDAKg5X56paV4HKmphTS/JhQjoKB/X9WvdlxHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365116; c=relaxed/simple;
	bh=/0fIWoex2ouah10kzSGOP4Ttry/AywuteHTCCSrYFtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRum3y3hL1HwRFVpLwV0kjVOP/91YNsiphXLqBobqIFuMpXz5mkLny8y1mt5jYQ8s3S5kV4rmagPamgwJbVwxFhdi03wiGSuohn5PGx6UJdep8RUA4a4JBwuAw8h/sGLcdJscoTld5RgIX/EDEB2Oc9L3ncYxRM7ar9fTd1otyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=TsOug69a; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/XGuOGTquR6EckFojlTHWCvwfhZIN4vpTO02m2yi3yQ=; b=TsOug69aEkLQ0THA7cGCru2gt6
	3MO9ESlS3bmeJD4PIWKA6pEHgyWuS3JOiVtmtyBATAjL0klgZxXJSZzZyz9FVaQmLB9UkULZ4cYAr
	SHYdS81BiXxuUXbl8pnkxlGFHhABOSCFxzI8XZQe1Y6ZYvgoRN6JjKsABlDq7gin+2T1tsOBznJ4k
	qhvxGDZ8Kc0DNQSUlERaXZEPK6DgEDkso7NdUq7W2c41nXYzeC9PpI2ffBVTkK+9qz3nq+EGHkRTP
	WOx5l+X07McS1x8Sk2czgejmj0NlzZ4ZsLIpOvwZeawFlh143AF02eFu0heR/RQnLeXeK4hUCev+N
	qsmdNfpA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZE-0000000GInd-34qz;
	Wed, 14 Jan 2026 04:33:12 +0000
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
Subject: [PATCH v5 18/68] getname_flags() massage, part 2
Date: Wed, 14 Jan 2026 04:32:20 +0000
Message-ID: <20260114043310.3885463-19-viro@zeniv.linux.org.uk>
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

Take the "long name" case into a helper (getname_long()). In
case of failure have the caller deal with freeing the original
struct filename.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 56 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 72ee663a9b6b..953cd254216d 100644
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


