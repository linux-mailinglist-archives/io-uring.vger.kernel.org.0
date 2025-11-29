Return-Path: <io-uring+bounces-10853-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F2C35C94513
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:02:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 82BCB4E4F6B
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD9BF31195D;
	Sat, 29 Nov 2025 17:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="HFl38DU2"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB26D22F177;
	Sat, 29 Nov 2025 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435702; cv=none; b=uHcGbN54WTpMvqyMiFdLfAd9/xm7DdqWUdjYvuEUFOhBkX7PqE5eqn8OhxkfKxMPvLTOjRp5hPDb+NAq8oxfrT9i1pP0up3bCv27jmsZ0EeCji9TBf+II0ksJu6LYl7CKtbFFtKMgZi533qx366NC+K9uNHQ9g5K0OWs1t0Fwbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435702; c=relaxed/simple;
	bh=xXjiSJqz9atJbTcDg9W0bbHB5PBDXejQhA3es4Oab4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUHnYEhl/y4TFdx4Uc6/wKUCVYWPXZLvEjFVqLLd1vwipx+CSWEc2iCGpCNtTe1aOVEMEdqjpJKzDmdQYj1Ns1A5TUWhCfYwYXnRyH8GJikzDzynOQfqL8uf0loQ3fEgFjTWCW0SgkhjZ8HDMKcfp1hyU6rgZOvubeZbcYCf0NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=HFl38DU2; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2LzmL8ymMOWR0VR+c5QLErm3uhF2BblZGtoWhaq1f0I=; b=HFl38DU2N8ROp8wh8HImOY03Kb
	ZjO5ADk0TYtcCEdiinFbMmdoq+Oykw6V8mH6F93CKF1+PghIW8Jp5wrzHSxw+dGGYEzAqZXv+KB6g
	XKdCQBNl1G2FVGkYukcjB5TJeSy7pj0eR1uSVsJ6RnqFVQM0PU/6+2BLBtkD6EAfveQQ9N9PGCMtt
	mFODHxoxa0S+HFMcO3rIYFxETYwTJMRPI5OhFpVeaHeXcZWqJerQZCpKPIJtYzEFasCYF2wJ9z+Jv
	b6kuvFhsbF/1qkmJpnMLN0L5PE3P9dVX6IleLzX7LtxCunoXYNlz77LNKyMl+iap9+w1KP/MmP9cW
	lgE5LWNQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKN-00000000dDA-32N8;
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
Subject: [RFC PATCH v2 13/18] getname_flags() massage, part 2
Date: Sat, 29 Nov 2025 17:01:37 +0000
Message-ID: <20251129170142.150639-14-viro@zeniv.linux.org.uk>
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

Take the "long name" case into a helper (getname_long()). In
case of failure have the caller deal with freeing the original
struct filename.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 56 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index bc5fe9732949..62e992e4f152 100644
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


