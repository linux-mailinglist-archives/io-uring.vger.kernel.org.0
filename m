Return-Path: <io-uring+bounces-11693-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 01AF7D1C611
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:36:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B703C3016201
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 402D3334C30;
	Wed, 14 Jan 2026 04:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="MFkzhdkw"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F30328625;
	Wed, 14 Jan 2026 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365122; cv=none; b=PyQF/uDoKYYWb5eatyy0v/hHs8VxXlhanQYZr+owxjo5pK8Hd7md5BfEXNrcCBvTj0uYl9d7QxRzOt6Ul/sXQxkEUKjbCAXMyZiFHZyVPApAp5AUCeGbmT6iowUdcNdtjx7xzKvuNwbBKTHZDaQAKRv70vGcaPdoQ/WYef6pDnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365122; c=relaxed/simple;
	bh=ed4inkFbKg5gXwGxXVyNFfqCJTe0MbLbW/j1/GoDH1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fi3WP0Im95MEz2DU9tDe9A7TdC/CS2Li01ZGIhTM6MOecwgU0n7w1cLNSHrWbjK7IOQMyQL2IVZOKAbY6TXLD04JA2rWZmsrf9z6LmiDCQqezDA/8GVpiHr9vTACJN0PZ6lg8Pp4oVPMshepNZXflkaSt4KDAHn9xeWkC4H7jrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=MFkzhdkw; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sz/9K14xSZCaQltDnYlKvdLrLATpRcUYc8VoMWgUXMw=; b=MFkzhdkwaKmEYF1jeGGMTVTEX1
	Oy2i8mpA1WMCwhKnZlzywyn+K3s2JZ98UwozDL58g9UUzWYrFLNVdCCWxc/cCLjIuKbLgkWSkbVLD
	sDj8t3ia9LNqwMPS55VLRo+MbIy6m2uwfnOUO7lnWHekBnbbH3CrYc0+3rVRWEETqLPoIvH/Uo2Jb
	RRWcQfO9BZbHeGtPu7A+Qp1ZRflnOx9cgTwf0STYb/vYMpLMB6Yr/iBiADNrBG0WB+6QXE5aFZ8dU
	2DKfThMl7opKsTekKLL/3LJKOPDfs34aP0c6ULqF4MY0fnDcYFzC5Sh1xbP7sWPBwGeScrw8gAQHb
	1Gp+/Duw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZP-0000000GJ0y-3gFS;
	Wed, 14 Jan 2026 04:33:23 +0000
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
Subject: [PATCH v5 68/68] sysfs(2): fs_index() argument is _not_ a pathname
Date: Wed, 14 Jan 2026 04:33:10 +0000
Message-ID: <20260114043310.3885463-69-viro@zeniv.linux.org.uk>
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


