Return-Path: <io-uring+bounces-11686-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA43D1C6A4
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:38:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 883C430C7C53
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D94331A40;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="QfYZKhl9"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E86D31A575;
	Wed, 14 Jan 2026 04:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365120; cv=none; b=Qvh9SMp6U/Km9YX713cM+RNl0meQa2JoH2NV7Yn0nJlJB0VqocCmQlOx34CRYZN+WovZo0nSqrrkqCCogqaxjZYEEIV6bGQo+XacWYowlFimJ8SeBWOKDJS+W+xl23QUgS+qBzikVBWorHIOW77QeM4wzvqgUGrJvl8RjD3tkZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365120; c=relaxed/simple;
	bh=flPREUjz226vbhFUNOUM/b2whXof1cRdtkFUivOyMAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxtyqzFtyV62oVLaMwwZYiD/yQGdUZZZd2XXFyHI0sRwHZrdWxvI4H8hMoCLh0DwD69rfv1+P0rBxug0jhXfca0T6vTst8iXV3xKZaRndFd5Cx5Xy3xMV9uFaK1sOc5uRHrkosTjzwnjZH49WSCe5Xx1Se1leBvtenKbioBVc3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=QfYZKhl9; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uZ4IKI6AXMjVP+nAvbUk5ps0UL7ywHeADF5WufBC7LU=; b=QfYZKhl9ZS5sAr87+PkL7p3Ejg
	0qSYN83Ujki+pbXZYJzVFgdGfA67n5F9KNc1BQ/gnUY9kdECHJf6/lBAlLmdSW4oeRPRUEPhBokqs
	wzEjZ+Q1BWwy7prCz+wJZCdNi8b9x12rP1xBO7UmEr0LVHDHophcwnUKPbBJotuA6UMWcNhUJ7eVg
	1q910vQE0Z6eBkHRp4NuXsuh1llWnwPgw2cZlJuyb0PJZlX2Dh+cQz8As9BjXi1RWYMzXN4lmv765
	ZYTZeSiK9wDtLsdH6uiAj4gpMqcwxqMYhZfqnnVJHIyBlVhDxOxUf0PZ0ffIFbFOR9qYtDeGreR7d
	CfE8+jtw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZM-0000000GIyG-1y4w;
	Wed, 14 Jan 2026 04:33:20 +0000
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
Subject: [PATCH v5 56/68] do_f{chmod,chown,access}at(): use CLASS(filename_uflags)
Date: Wed, 14 Jan 2026 04:32:58 +0000
Message-ID: <20260114043310.3885463-57-viro@zeniv.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/open.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 34d9b1ecc141..3c7081694326 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -469,7 +469,6 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
 	int res;
 	unsigned int lookup_flags = LOOKUP_FOLLOW;
 	const struct cred *old_cred = NULL;
-	struct filename *name;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
 		return -EINVAL;
@@ -486,7 +485,7 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
 			return -ENOMEM;
 	}
 
-	name = getname_uflags(filename, flags);
+	CLASS(filename_uflags, name)(filename, flags);
 retry:
 	res = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (res)
@@ -528,7 +527,6 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
 		goto retry;
 	}
 out:
-	putname(name);
 	if (old_cred)
 		put_cred(revert_creds(old_cred));
 
@@ -677,7 +675,6 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 		       unsigned int flags)
 {
 	struct path path;
-	struct filename *name;
 	int error;
 	unsigned int lookup_flags;
 
@@ -685,7 +682,7 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 		return -EINVAL;
 
 	lookup_flags = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
-	name = getname_uflags(filename, flags);
+	CLASS(filename_uflags, name)(filename, flags);
 retry:
 	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (!error) {
@@ -696,7 +693,6 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 			goto retry;
 		}
 	}
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


