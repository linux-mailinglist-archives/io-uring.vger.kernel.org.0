Return-Path: <io-uring+bounces-11495-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 235FBD01849
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:11:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 680C33139D05
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E84D5345757;
	Thu,  8 Jan 2026 07:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="TEWSypab"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C5733E37D;
	Thu,  8 Jan 2026 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857822; cv=none; b=l4Xxh80p5KI9MnEhpYdJBBORlM10aocacRRlJ/7UVgk4MLdx1QeiwrK7dspcrXl//FTdDuQKKQWMmGDyAMRIof44piD2RNvSUzks/iCOpiPJzzosrRwKQjeNKgj6/O8Ayut9R2t/HEhQ9WXUr8l5D3xOS2rHNeiQnuh8tadST/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857822; c=relaxed/simple;
	bh=feV5iC2WMzEnCYTs5Mi4FLodvFANEDFlUJ5R18kq/6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUgOCSq+je8F8QrIoos/xTe/upgzeq2ZzjBnaRiQWsvOKKjTP1CPQbm/FGwHnsjlij0wi6DtpXoUyfnao+TVJBG0m7+O8dLISIaquAE8LMkR/xWR9rLoqRmnMF/8QcfAcWYQSJn4EH7kaWGxfrKpQkMHhPtqNunASoWrzKSuC/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=TEWSypab; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4k7kWmP1ZhXBmL+hmhsC3wCogciqSjx/xESlh9/A6eA=; b=TEWSypabzKOAox/7nNTak911u4
	UPZ3JOWdEpkrjuxI7RtRFkHOtgnXY7iPWYiPTlkhQ1NjVOD4udEuoEm4+z/BsMh2kvIrGDZrPBwqt
	amHHRKbqSzYK+bamO0zLHiGc0aRFNqcPMOcxhRUR8HIMSccQn4CLAw3vBj4zKmfQzMh4XZvcmeEuK
	5WsdUIVa/uxOg6IeTxPLGxlh4zIOUMxELjqWtkwm+RKzWxJC13zbKb4ViuDVkzfEXjhwOv8eC2dVT
	09YRfy5LTacbKJI4+svkEieu3Ykrqtb6PO50fsZ0QBp4MY4uxLPyNJhvFshw6kpe4uG8fbKoNbbFV
	8YbvVhrQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkaz-00000001mtA-1YVq;
	Thu, 08 Jan 2026 07:38:13 +0000
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
Subject: [PATCH v4 48/59] namei.c: switch user pathname imports to CLASS(filename{,_flags})
Date: Thu,  8 Jan 2026 07:37:52 +0000
Message-ID: <20260108073803.425343-49-viro@zeniv.linux.org.uk>
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
index 325a69f2bfff..cbddd5d44a12 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3022,11 +3022,8 @@ struct dentry *start_removing_user_path_at(int dfd,
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
 
@@ -3604,11 +3601,8 @@ int path_pts(struct path *path)
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
 
@@ -4967,11 +4961,8 @@ inline struct dentry *start_creating_user_path(
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


