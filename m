Return-Path: <io-uring+bounces-11061-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7743FCC0C2A
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 50BF530215DB
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582DE314D3D;
	Tue, 16 Dec 2025 03:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ELkT/aZj"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535F2311599;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857292; cv=none; b=ChGXsIiVsJfj7ZRDnByY2tBuq0yhv12I6n3z7o3I+7iJLi8Fe6c2J2ZFx9mxd2OP94MiLl3Y3ok+kX2/47RgVWdpRaRle/DtUME2MigqWIO6iZQaqnjrKsm0SFG4q63I37lhgVozcMGeJMdMGx08J+Xi6se8wxY0QDzSkZvQ0jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857292; c=relaxed/simple;
	bh=zFlDLU2alFVD/MwuTFbdq6QS587tb9atKC26F68cFjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHML1Fnw6Y7LsUanaGv6rhR+HFbASn9PPD35aLAfdbRY9bPlqVtBwVwgI6JEAicJXsOBSs8c/ORbOXQt1vOZ1i9GxxKuTVMaHfnaWFvEGQ88TTt0sg/gnrh/JLesQwWqz9HF0K4aJf0Fy3pmrvh/UfXBPkbNKPOiGt59QsGwvB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ELkT/aZj; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KE0bqgoAYg4WN/vY/qas7LhrImQSJi8EcGd+/Tk2T7o=; b=ELkT/aZjoe+4w38oxhHjW32mj7
	KlhZpqFckSRazJNv9Vyl52gIdsJc8fNwgow/ftKfDCjm6jOPaS2AjDOjEACW5K+SLsbGqqBT1CXop
	f+7UuST5NmWGBAIXSypgGqrERYasxIJnZ707j5m/L0EjvNUo9cq5RCk01+r7O/vEkjpTOGAbeP2uX
	RA9hDe+7m2ce9CDSLcgr8cZTw5y3Qe7omiSLjsuuY9sPPy1TZw8NW+xtXcC7XurvhSksHDKc6ZxW9
	CetKnJxTLEHSkLKgAX2VY2OuCHa/AHBWJmRz/Q7vtmMeEAFwzkL1TLZieFnpBSA++EBkeod+iaSIz
	u1wNZT+A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9f-0000000GwJ7-1esV;
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
Subject: [RFC PATCH v3 08/59] do_sys_truncate(): import pathname only once
Date: Tue, 16 Dec 2025 03:54:27 +0000
Message-ID: <20251216035518.4037331-9-viro@zeniv.linux.org.uk>
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

Convert the user_path_at() call inside a retry loop into getname_flags() +
filename_lookup() + putname() and leave only filename_lookup() inside
the loop.

In this case we never pass LOOKUP_EMPTY, so getname_flags() is equivalent
to plain getname().

The things could be further simplified by use of cleanup.h stuff, but
let's not clutter the patch with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/open.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 6f48fa9c756a..2fea68991d42 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -129,14 +129,16 @@ EXPORT_SYMBOL_GPL(vfs_truncate);
 int do_sys_truncate(const char __user *pathname, loff_t length)
 {
 	unsigned int lookup_flags = LOOKUP_FOLLOW;
+	struct filename *name;
 	struct path path;
 	int error;
 
 	if (length < 0)	/* sorry, but loff_t says... */
 		return -EINVAL;
 
+	name = getname(pathname);
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (!error) {
 		error = vfs_truncate(&path, length);
 		path_put(&path);
@@ -145,6 +147,7 @@ int do_sys_truncate(const char __user *pathname, loff_t length)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


