Return-Path: <io-uring+bounces-11447-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CBCA0D016B9
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:37:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 10E343035AAA
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D8132E6BF;
	Thu,  8 Jan 2026 07:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="BP1KNZbV"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970383168F5;
	Thu,  8 Jan 2026 07:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857812; cv=none; b=BuHIUyGd3v2lZyOqIIAwhW9ZZcPoZKxiNJr0mfpXKokhCcn9Z/nndX1+Ioyk3Z+faY2qGPmEoi9PvkR138Tb09G4d8WpJFy/XMTROGID7EiWRpEB6jG521Yj4AFjMOr1u6/hj4Nw5LPjPRBEUN393O1N791+R0oNuUNqbk6m0wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857812; c=relaxed/simple;
	bh=5MEqgjhpmzI29H1uV/1SQLwXuo398WOo5iQ8G4kZTTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h21TMwcplIdBMewBYFDQ17zccdOq4PEPZxdhf4WJfxJKqZWg6lmibQEkbklQkrr8/eKvrrVO7Li6EVV/dSxNkR/b3sWYAUic35I8RqsdIABxam2jHhWHWdJFFiXnBS3EtZOCgECvpWosKspxxZH0V8ILKRuhZvr6ZhiEl5X85LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=BP1KNZbV; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=H3lRaX9hzJYaGyPHgtEsqC7lsKDUGMd09oess7PslzA=; b=BP1KNZbVJBfcMJ2579H6NvJZOn
	qIP6AfjpBe7QSewla55kqIyP/MiB1trAATjjfU7+XcV90mkEH8yaw7Mxony2ORYfclbH9bB3sUCvW
	K5qrbfbs/tXmtUzk3FxlV/vmOpEIS2N2PFnMRvSNlsfLCQur9KLaL30KNa57Pp41cUb0IK7bhw3Ln
	Z41xwLj9UCRgHzcirWyPtbf13Zs+9cGjtDsBMNj6MX+OyYlMJOm39Y0Gwpejb0dIEx7HhNAiaQpQW
	g2dEFDi4mb7LtO8pqMA2M8svMeiw7MHlZiSPa/FoJJw0Q7JbrwXAMM63Ll+exKMWT2Tu23rl4rF9H
	SXdCgX6w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkaq-00000001mfT-2J53;
	Thu, 08 Jan 2026 07:38:04 +0000
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
Subject: [PATCH v4 07/59] user_statfs(): import pathname only once
Date: Thu,  8 Jan 2026 07:37:11 +0000
Message-ID: <20260108073803.425343-8-viro@zeniv.linux.org.uk>
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

Convert the user_path_at() call inside a retry loop into getname_flags() +
filename_lookup() + putname() and leave only filename_lookup() inside
the loop.

In this case we never pass LOOKUP_EMPTY, so getname_flags() is equivalent
to plain getname().

The things could be further simplified by use of cleanup.h stuff, but
let's not clutter the patch with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/statfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/statfs.c b/fs/statfs.c
index a45ac85e6048..a5671bf6c7f0 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -99,8 +99,9 @@ int user_statfs(const char __user *pathname, struct kstatfs *st)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW|LOOKUP_AUTOMOUNT;
+	struct filename *name = getname(pathname);
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (!error) {
 		error = vfs_statfs(&path, st);
 		path_put(&path);
@@ -109,6 +110,7 @@ int user_statfs(const char __user *pathname, struct kstatfs *st)
 			goto retry;
 		}
 	}
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


