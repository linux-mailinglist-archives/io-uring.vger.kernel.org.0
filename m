Return-Path: <io-uring+bounces-11112-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 53FA8CC0EC5
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:42:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 887793142395
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50102E9748;
	Tue, 16 Dec 2025 04:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="E/wgEtdK"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97E032D7E0;
	Tue, 16 Dec 2025 04:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765858282; cv=none; b=vCIg6hU/9hL/TCk/imkSSzPDJqMA95o6C9yubbuMDBYijdLv+bl1It6jiBaukkPBi3Eb6kFNlEbcqCIfRs1ntc9+oe9KmFvZvZK5up0/Lqv2x5xH1BTj7/nwYOMWxdh+0dzNPm3kfBmSv5NZ8QKf6z2o0bSDqnR3TQsoHcNbStY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765858282; c=relaxed/simple;
	bh=ioXf5hyYI0arJkYoZAz9bLmowVwquWhysnemwDA53BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXMaoeMLIZs617D7m0rrEQw+U9gxO8kGsTb1RzU3PBmBYKg9JvYpt286FGEXO93A1laPBqt109SIcAoNPtkEtARJhOAgbgyM1bed2OGLyeWGins7DsvNuw/o7iuW6mgg+xjhcoqxsvuBESekP6qjd9mV4PB17D0NodZaQ1bg9l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=E/wgEtdK; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7IQfpKmysnQB0XEm2JYvCsb/kBeyJZl4dDIhHs/pXAA=; b=E/wgEtdKhUD4jo8Pm3X2cVNAPs
	A/vnJUZ+31piizzr1C91Q5rhgs+pXEEjiBfFYpSokarQh4N9pxyC5NQI5Vx63co3IYGmlCq2E8w0s
	TQjf9V5ymagkrIbl1krqrDMxgk0lXZ9F93/OGkQw25QlSa+8wXq4Avkz5PkHoSILNVInxuPhyu0LS
	5DQa49xJ9+iVWE4MFCWgo4kh4bCmPSjfYrTKfqUvtWDrMtiacDiL1n3R+4qka/jBkDybKVFk/sJiF
	G2PO5kMq8248uqMBOojJQhmVE1B5TnmwtUxkteJsjl9yRkLg0mtVW0QEroM92kURIeG+tjO9wodBW
	g/AkC7TA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9k-0000000GwMu-0IeC;
	Tue, 16 Dec 2025 03:55:24 +0000
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
Subject: [RFC PATCH v3 49/59] namei.c: switch user pathname imports to CLASS(filename{,_flags})
Date: Tue, 16 Dec 2025 03:55:08 +0000
Message-ID: <20251216035518.4037331-50-viro@zeniv.linux.org.uk>
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

filename_flags is used by user_path_at().  I suspect that mixing
LOOKUP_EMPTY with real lookup flags had been a mistake all along; the
former belongs to pathname import, the latter - to pathwalk.  Right now
none of the remaining in-tree callers of user_path_at() are getting
LOOKUP_EMPTY in flags, so user_path_at() could probably be switched
to CLASS(filename)...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e0c8d3832861..a564ca4f7ffd 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3025,11 +3025,8 @@ struct dentry *start_removing_user_path_at(int dfd,
 					   const char __user *name,
 					   struct path *path)
 {
-	struct filename *filename = getname(name);
-	struct dentry *res = __start_removing_path(dfd, filename, path);
-
-	putname(filename);
-	return res;
+	CLASS(filename, filename)(name);
+	return __start_removing_path(dfd, filename, path);
 }
 EXPORT_SYMBOL(start_removing_user_path_at);
 
@@ -3607,11 +3604,8 @@ int path_pts(struct path *path)
 int user_path_at(int dfd, const char __user *name, unsigned flags,
 		 struct path *path)
 {
-	struct filename *filename = getname_flags(name, flags);
-	int ret = filename_lookup(dfd, filename, flags, path, NULL);
-
-	putname(filename);
-	return ret;
+	CLASS(filename_flags, filename)(name, flags);
+	return filename_lookup(dfd, filename, flags, path, NULL);
 }
 EXPORT_SYMBOL(user_path_at);
 
@@ -4970,11 +4964,8 @@ inline struct dentry *start_creating_user_path(
 	int dfd, const char __user *pathname,
 	struct path *path, unsigned int lookup_flags)
 {
-	struct filename *filename = getname(pathname);
-	struct dentry *res = filename_create(dfd, filename, path, lookup_flags);
-
-	putname(filename);
-	return res;
+	CLASS(filename, filename)(pathname);
+	return filename_create(dfd, filename, path, lookup_flags);
 }
 EXPORT_SYMBOL(start_creating_user_path);
 
-- 
2.47.3


