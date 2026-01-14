Return-Path: <io-uring+bounces-11682-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 044ABD1C698
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:38:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B93930C3C42
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7E8033120D;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Va9dJkUm"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC74303A1D;
	Wed, 14 Jan 2026 04:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365120; cv=none; b=p6+aeXHHRthEbGP3u7vAP20KIo28AfxW6eDKTGXcJ+aWYyzs3MeLlJJTjcn+i9kPDWpf3N9ijBFwpooxKcSTMcwI2ycGAQVFrc6Kik3bGqwGFid8cbqwXI7y+/UMEF7d/Dle/7/TFhMm9eHZoHsOUySirvFFGs2n3xbgUPkoNJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365120; c=relaxed/simple;
	bh=urAa3ZS6X7nMsa9ZRz2Pqn/hpkIvLTL3N56s9umZyt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZue41xhgVtWo96h5s14raZrs+vG58Xn5gv4VDc6bQV1nLfUhySS6UTcV7quhe/40tewu0KhyVvyvYl2znOJxAByjI9uXHPZR4XG7cTwG26MaPA6DBWaBdChdwDWBZ5sWYDygYkQwhumnAetVdxs7j0ewyPAGs2QrJ1ll5wD41A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Va9dJkUm; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5+CNfJBBa99USZB4Xzhgo+c1jKCiUr7CLOmJPPMy31A=; b=Va9dJkUmRZ6qkdGkQKEsXYEUtf
	98HjeXCJpQ+CR4pk7/Ru4qbh5VuTyjEZLOaqe6kodcb63JqXwx1l6CsAb5L3xnb3XxlgEGjWjQHPb
	I9BADjZvFp8/5GHSl44pgjF2xWc6hEx+7PExqnpZO7c2Honz6umVtvB0C7dS8fG7L36wKBCFCMu6T
	IAWzKD6XcfdNECS1V4g18VIlnOMpkPnDLhOYFVvxL/sOKiivja3BQomQ6agr33PCiUJQGLoosxlWL
	SeGgkevMT6I9ahicQQmD0+MxelCsaMmCiTJEA1HJbyC42JsJv+4fbchbMYFxM2/C+RoRlfNaofvSu
	q+bUsfxA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZL-0000000GIwu-2Jw5;
	Wed, 14 Jan 2026 04:33:19 +0000
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
Subject: [PATCH v5 52/68] chdir(2): unspaghettify a bit...
Date: Wed, 14 Jan 2026 04:32:54 +0000
Message-ID: <20260114043310.3885463-53-viro@zeniv.linux.org.uk>
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
 fs/open.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 425c09d83d7f..bcaaf884e436 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -558,26 +558,19 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
-	struct filename *name = getname(filename);
+	CLASS(filename, name)(filename);
 retry:
 	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
-	if (error)
-		goto out;
-
-	error = path_permission(&path, MAY_EXEC | MAY_CHDIR);
-	if (error)
-		goto dput_and_out;
-
-	set_fs_pwd(current->fs, &path);
-
-dput_and_out:
-	path_put(&path);
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
+	if (!error) {
+		error = path_permission(&path, MAY_EXEC | MAY_CHDIR);
+		if (!error)
+			set_fs_pwd(current->fs, &path);
+		path_put(&path);
+		if (retry_estale(error, lookup_flags)) {
+			lookup_flags |= LOOKUP_REVAL;
+			goto retry;
+		}
 	}
-out:
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


