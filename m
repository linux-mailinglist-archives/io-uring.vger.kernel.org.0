Return-Path: <io-uring+bounces-11073-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 776DBCC0C6C
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:55:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 99AF03030155
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1427E319847;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="m70MiiA7"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7535231280B;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857294; cv=none; b=CJaNtXUAw9uLTm+DLbVQgGxmaXRCebQU1kYGTGToax0a6fpv1mHdW1HmhI0pOukVWC9jn7pQ7ksYICU5zYPAdRcsZA2mYYNbnsjTdOC2cHWZxJOTranvjvI5lwCVYXAoo6IZmdQTse6RsqzEo0OhUYmbHju9UjgoBaUwBLD/mSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857294; c=relaxed/simple;
	bh=ed4inkFbKg5gXwGxXVyNFfqCJTe0MbLbW/j1/GoDH1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhE4MhY5J+sAeP7TkI/Z1FcgshSLBWqhcerdPaHznxL7YmiTv5RzrdtirzVp/Z0Kp93i2bqEFaXakqIqj5J4bLBmpfVmLC1/E3bcPw/Ee2aw02ARfHNKlqLEe58UxDFcadZJq8buZcauJDryJmI0Wj+a7jTBfyHDN0OcH0V/mXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=m70MiiA7; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sz/9K14xSZCaQltDnYlKvdLrLATpRcUYc8VoMWgUXMw=; b=m70MiiA7LhOiREd71u5WzvtE2J
	J9VUrqeM6uUzdw5oj9CCS5fvay4nz+GOplKjWEJWewZ13vDjxbtrUHZIzylEHrDZZJLjQYn9sGszr
	nvoEYCqbkMXoHM3nOP4zbI0nAtt7vXbg6WjX9+ldA97O63BaceZPZ27I5C6DEWL5KgqiT7S7DuRYU
	Lj6czZrwl2YhaZC5c+xj0IwuE+pqTFpT0Rw8m5bCwatU969Kart+m8uDFX92+zukHYghBU0O+R7Fl
	sZSzE0PLP5wIEHQnele7I3yGtW9UndDas6wRestliai1o4OVPg0smtRKcCGaoql53djQpy7o7SSjQ
	fCpmMC2g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9k-0000000GwOg-3FtF;
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
Subject: [RFC PATCH v3 59/59] sysfs(2): fs_index() argument is _not_ a pathname
Date: Tue, 16 Dec 2025 03:55:18 +0000
Message-ID: <20251216035518.4037331-60-viro@zeniv.linux.org.uk>
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

... it's a filesystem type name.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/filesystems.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index 95e5256821a5..0c7d2b7ac26c 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -132,24 +132,21 @@ EXPORT_SYMBOL(unregister_filesystem);
 static int fs_index(const char __user * __name)
 {
 	struct file_system_type * tmp;
-	struct filename *name;
+	char *name __free(kfree) = strndup_user(__name, PATH_MAX);
 	int err, index;
 
-	name = getname(__name);
-	err = PTR_ERR(name);
 	if (IS_ERR(name))
-		return err;
+		return PTR_ERR(name);
 
 	err = -EINVAL;
 	read_lock(&file_systems_lock);
 	for (tmp=file_systems, index=0 ; tmp ; tmp=tmp->next, index++) {
-		if (strcmp(tmp->name, name->name) == 0) {
+		if (strcmp(tmp->name, name) == 0) {
 			err = index;
 			break;
 		}
 	}
 	read_unlock(&file_systems_lock);
-	putname(name);
 	return err;
 }
 
-- 
2.47.3


